
46	/*
47	 * Oracle LGPL Disclaimer: For the avoidance of doubt, except that if any license choice
48	 * other than GPL or LGPL is available it will apply instead, Oracle elects to use only
49	 * the Lesser General Public License version 2.1 (LGPLv2) at this time for any software where
50	 * a choice of LGPL license versions is made available with the language indicating
51	 * that LGPLv2 or any later version may be used, or where a choice of which version
52	 * of the LGPL is applied is otherwise unspecified.
53	 */
54	
55	
56	#include <stdint.h>
57	#include "biosint.h"
58	#include "inlines.h"
59	#include "ebda.h"
60	#include "ata.h"
61	
62	
63	#if DEBUG_INT13_HD
64	#  define BX_DEBUG_INT13_HD(...) BX_DEBUG(__VA_ARGS__)
65	#else
66	#  define BX_DEBUG_INT13_HD(...)
67	#endif
68	
69	/* Generic disk read/write routine signature. */
70	typedef int __fastcall (* dsk_rw_func)(bio_dsk_t __far *bios_dsk);
71	
72	/* Controller specific disk access routines. Declared as a union to reduce
73	 * the need for conditionals when choosing between read/write functions.
74	 * Note that we get away with using near pointers, which is nice.
75	 */
76	typedef union {
77	    struct {
78	        dsk_rw_func     read;
79	        dsk_rw_func     write;
80	    } s;
81	    dsk_rw_func a[2];
82	} dsk_acc_t;
83	
84	/* Pointers to HW specific disk access routines. */
85	dsk_acc_t   dskacc[DSKTYP_CNT] = {
86	    [DSK_TYPE_ATA]  = { ata_read_sectors,  ata_write_sectors },
87	#ifdef VBOX_WITH_AHCI
88	    [DSK_TYPE_AHCI] = { ahci_read_sectors, ahci_write_sectors },
89	#endif
90	#ifdef VBOX_WITH_SCSI
91	    [DSK_TYPE_SCSI] = { scsi_read_sectors, scsi_write_sectors },
92	#endif
93	#ifdef VBOX_WITH_VIRTIO_SCSI
94	    [DSK_TYPE_VIRTIO_SCSI] = { virtio_scsi_read_sectors, virtio_scsi_write_sectors },
95	#endif
96	};
97	
98	
99	/// @todo put in a header
100	#define AX      r.gr.u.r16.ax
101	#define BX      r.gr.u.r16.bx
102	#define CX      r.gr.u.r16.cx
103	#define DX      r.gr.u.r16.dx
104	#define SI      r.gr.u.r16.si
105	#define DI      r.gr.u.r16.di
106	#define BP      r.gr.u.r16.bp
107	#define ELDX    r.gr.u.r16.sp
108	#define DS      r.ds
109	#define ES      r.es
110	#define FLAGS   r.ra.flags.u.r16.flags
111	
112	
113	/*
114	 * Build translated CHS geometry given a disk size in sectors. Based on
115	 * Phoenix EDD 3.0. This is used as a fallback to generate sane logical
116	 * geometry in case none was provided in CMOS.
117	 */
118	void set_geom_lba(chs_t __far *lgeo, uint64_t nsectors64)
119	{
120	    uint32_t    limit = 8257536;    /* 1024 * 128 * 63 */
121	    uint32_t    nsectors;
122	    unsigned    heads = 255;
123	    int         i;
124	
125	    nsectors = (nsectors64 >> 32) ? 0xFFFFFFFFL : (uint32_t)nsectors64;
126	    /* Start with ~4GB limit, go down to 504MB. */
127	    for (i = 0; i < 4; ++i) {
128	        if (nsectors <= limit)
129	            heads = (heads + 1) / 2;
130	        limit /= 2;
131	    }
132	
133	    lgeo->cylinders = nsectors / (heads * 63UL);
134	    if (lgeo->cylinders > 1024)
135	        lgeo->cylinders = 1024;
136	    lgeo->heads     = heads;
137	    lgeo->spt       = 63;   /* Always 63 sectors per track, the maximum. */
138	}
139	
140	int edd_fill_dpt(dpt_t __far *dpt, bio_dsk_t __far *bios_dsk, uint8_t device)
141	{
142	    uint16_t    ebda_seg = read_word(0x0040,0x000E);
143	
144	    /* Check if buffer is large enough. */
145	    if (dpt->size < 0x1a)
146	        return -1;
147	
148	    /* Fill in EDD 1.x table. */
149	    if (dpt->size >= 0x1a) {
150	        uint64_t    lba;
151	
152	        dpt->size      = 0x1a;
153	        dpt->blksize   = bios_dsk->devices[device].blksize;
154	
155	        if (bios_dsk->devices[device].device == DSK_DEVICE_CDROM) {
156	            dpt->infos         = 0x74;  /* Removable, media change, lockable, max values */
157	            dpt->cylinders     = 0xffffffff;
158	            dpt->heads         = 0xffffffff;
159	            dpt->spt           = 0xffffffff;
160	            dpt->sector_count1 = 0xffffffff;
161	            dpt->sector_count2 = 0xffffffff;
162	        } else {
163	            dpt->infos     = 0x02;  // geometry is valid
164	            dpt->cylinders = bios_dsk->devices[device].pchs.cylinders;
165	            dpt->heads     = bios_dsk->devices[device].pchs.heads;
166	            dpt->spt       = bios_dsk->devices[device].pchs.spt;
167	            lba = bios_dsk->devices[device].sectors;
168	            dpt->sector_count1 = lba;
169	            dpt->sector_count2 = lba >> 32;
170	        }
171	    }
172	
173	    /* Fill in EDD 2.x table. */
174	    if (dpt->size >= 0x1e) {
175	        uint8_t     channel, irq, mode, checksum, i, xlation;
176	        uint16_t    iobase1, iobase2, options;
177	
178	        dpt->size = 0x1e;
179	        dpt->dpte_segment = ebda_seg;
180	        dpt->dpte_offset  = (uint16_t)&EbdaData->bdisk.dpte;
181	
182	        // Fill in dpte
183	        channel = device / 2;
184	        iobase1 = bios_dsk->channels[channel].iobase1;
185	        iobase2 = bios_dsk->channels[channel].iobase2;
186	        irq     = bios_dsk->channels[channel].irq;
187	        mode    = bios_dsk->devices[device].mode;
188	        xlation = bios_dsk->devices[device].translation;
189	
190	        options  = (xlation == GEO_TRANSLATION_NONE ? 0 : 1 << 3);  /* CHS translation */
191	        options |= (1 << 4);    /* LBA translation */
192	        if (bios_dsk->devices[device].device == DSK_DEVICE_CDROM) {
193	            options |= (1 << 5);    /* Removable device */
194	            options |= (1 << 6);    /* ATAPI device */
195	        }
196	#if VBOX_BIOS_CPU >= 80386
197	        options |= (mode == ATA_MODE_PIO32 ? 1 : 0 << 7);
198	#endif
199	        options |= (xlation == GEO_TRANSLATION_LBA ? 1 : 0 << 9);
200	        options |= (xlation == GEO_TRANSLATION_RECHS ? 3 : 0 << 9);
201	
202	        bios_dsk->dpte.iobase1  = iobase1;
203	        bios_dsk->dpte.iobase2  = iobase2;
204	        bios_dsk->dpte.prefix   = (0xe | (device % 2)) << 4;
205	        bios_dsk->dpte.unused   = 0xcb;
206	        bios_dsk->dpte.irq      = irq;
207	        bios_dsk->dpte.blkcount = 1;
208	        bios_dsk->dpte.dma      = 0;
209	        bios_dsk->dpte.pio      = 0;
210	        bios_dsk->dpte.options  = options;
211	        bios_dsk->dpte.reserved = 0;
212	        bios_dsk->dpte.revision = 0x11;
213	
214	        checksum = 0;
215	        for (i = 0; i < 15; ++i)
216	            checksum += read_byte(ebda_seg, (uint16_t)&EbdaData->bdisk.dpte + i);
217	        checksum = -checksum;
218	        bios_dsk->dpte.checksum = checksum;
219	    }
220	
221	    /* Fill in EDD 3.x table. */
222	    if (dpt->size >= 0x42) {
223	        uint8_t     channel, iface, checksum, i;
224	        uint16_t    iobase1;
225	
226	        channel = device / 2;
227	        iface   = bios_dsk->channels[channel].iface;
228	        iobase1 = bios_dsk->channels[channel].iobase1;
229	
230	        dpt->size       = 0x42;
231	        dpt->key        = 0xbedd;
232	        dpt->dpi_length = 0x24;
233	        dpt->reserved1  = 0;
234	        dpt->reserved2  = 0;
235	
236	        if (iface == ATA_IFACE_ISA) {
237	            dpt->host_bus[0] = 'I';
238	            dpt->host_bus[1] = 'S';
239	            dpt->host_bus[2] = 'A';
240	            dpt->host_bus[3] = ' ';
241	        }
242	        else {
243	            // FIXME PCI
244	        }
245	        dpt->iface_type[0] = 'A';
246	        dpt->iface_type[1] = 'T';
247	        dpt->iface_type[2] = 'A';
248	        dpt->iface_type[3] = ' ';
249	        dpt->iface_type[4] = ' ';
250	        dpt->iface_type[5] = ' ';
251	        dpt->iface_type[6] = ' ';
252	        dpt->iface_type[7] = ' ';
253	
254	        if (iface == ATA_IFACE_ISA) {
255	            ((uint16_t __far *)dpt->iface_path)[0] = iobase1;
256	            ((uint16_t __far *)dpt->iface_path)[1] = 0;
257	            ((uint32_t __far *)dpt->iface_path)[1] = 0;
258	        }
259	        else {
260	            // FIXME PCI
261	        }
262	        ((uint16_t __far *)dpt->device_path)[0] = device & 1; // device % 2; @todo: correct?
263	        ((uint16_t __far *)dpt->device_path)[1] = 0;
264	        ((uint32_t __far *)dpt->device_path)[1] = 0;
265	
266	        checksum = 0;
267	        for (i = 30; i < 64; i++)
268	            checksum += ((uint8_t __far *)dpt)[i];
269	        checksum = -checksum;
270	        dpt->checksum = checksum;
271	    }
272	    return 0;
273	}
274	
275	void BIOSCALL int13_harddisk(disk_regs_t r)
276	{
277	    uint32_t            lba;
278	    uint16_t            cylinder, head, sector;
279	    uint16_t            nlc, nlh, nlspt;
280	    uint16_t            count;
281	    uint8_t             device, status;
282	    bio_dsk_t __far     *bios_dsk;
283	
284	    BX_DEBUG_INT13_HD("%s: AX=%04x BX=%04x CX=%04x DX=%04x ES=%04x\n", __func__, AX, BX, CX, DX, ES);
285	
286	    SET_IF();   /* INT 13h always returns with interrupts enabled. */
287	
288	    bios_dsk = read_word(0x0040,0x000E) :> &EbdaData->bdisk;
289	    write_byte(0x0040, 0x008e, 0);  // clear completion flag
290	
291	    // basic check : device has to be defined
292	    if ( (GET_ELDL() < 0x80) || (GET_ELDL() >= 0x80 + BX_MAX_STORAGE_DEVICES) ) {
293	        BX_DEBUG("%s: function %02x, ELDL out of range %02x\n", __func__, GET_AH(), GET_ELDL());
294	        goto int13_fail;
295	    }
296	
297	    // Get the ata channel
298	    device = bios_dsk->hdidmap[GET_ELDL()-0x80];
299	
300	    // basic check : device has to be valid
301	    if (device >= BX_MAX_STORAGE_DEVICES) {
302	        BX_DEBUG("%s: function %02x, unmapped device for ELDL=%02x\n", __func__, GET_AH(), GET_ELDL());
303	        goto int13_fail;
304	    }
305	
306	    switch (GET_AH()) {
307	
308	    case 0x00: /* disk controller reset */
309	#ifdef VBOX_WITH_SCSI
310	        /* SCSI controller does not need a reset. */
311	        if (!VBOX_IS_SCSI_DEVICE(device))
312	#endif
313	        ata_reset (device);
314	        goto int13_success;
315	        break;
316	
317	    case 0x01: /* read disk status */
318	        status = read_byte(0x0040, 0x0074);
319	        SET_AH(status);
320	        SET_DISK_RET_STATUS(0);
321	        /* set CF if error status read */
322	        if (status) goto int13_fail_nostatus;
323	        else        goto int13_success_noah;
324	        break;
325	
326	    case 0x02: // read disk sectors
327	    case 0x03: // write disk sectors
328	    case 0x04: // verify disk sectors
329	
330	        count       = GET_AL();
331	        cylinder    = GET_CH();
332	        cylinder   |= ( ((uint16_t) GET_CL()) << 2) & 0x300;
333	        sector      = (GET_CL() & 0x3f);
334	        head        = GET_DH();
335	
336	        /* Segment and offset are in ES:BX. */
337	        if ( (count > 128) || (count == 0) ) {
338	            BX_INFO("%s: function %02x, count out of range!\n", __func__, GET_AH());
339	            goto int13_fail;
340	        }
341	
342	        /* Get the logical CHS geometry. */
343	        nlc   = bios_dsk->devices[device].lchs.cylinders;
344	        nlh   = bios_dsk->devices[device].lchs.heads;
345	        nlspt = bios_dsk->devices[device].lchs.spt;
346	
347	        /* Sanity check the geometry. */
348	        if( (cylinder >= nlc) || (head >= nlh) || (sector > nlspt )) {
349	            BX_INFO("%s: function %02x, disk %02x, parameters out of range %04x/%04x/%04x!\n", __func__, GET_AH(), GET_DL(), cylinder, head, sector);
350	            goto int13_fail;
351	        }
352	
353	        // FIXME verify
354	        if ( GET_AH() == 0x04 )
355	            goto int13_success;
356	
357	        /* If required, translate LCHS to LBA and execute command. */
358	        /// @todo The IS_SCSI_DEVICE check should be redundant...
359	        if (( (bios_dsk->devices[device].pchs.heads != nlh) || (bios_dsk->devices[device].pchs.spt != nlspt)) || VBOX_IS_SCSI_DEVICE(device)) {
360	            lba = ((((uint32_t)cylinder * (uint32_t)nlh) + (uint32_t)head) * (uint32_t)nlspt) + (uint32_t)sector - 1;
361	            sector = 0; // this forces the command to be lba
362	            BX_DEBUG_INT13_HD("%s: %d sectors from lba %lu @ %04x:%04x\n", __func__,
363	                              count, lba, ES, BX);
364	        } else {
365	            BX_DEBUG_INT13_HD("%s: %d sectors from C/H/S %u/%u/%u @ %04x:%04x\n", __func__,
366	                              count, cylinder, head, sector, ES, BX);
367	        }
368	
369	
370	        /* Clear the count of transferred sectors/bytes. */
371	        bios_dsk->drqp.trsfsectors = 0;
372	        bios_dsk->drqp.trsfbytes   = 0;
373	
374	        /* Pass request information to low level disk code. */
375	        bios_dsk->drqp.lba      = lba;
376	        bios_dsk->drqp.buffer   = MK_FP(ES, BX);
377	        bios_dsk->drqp.nsect    = count;
378	        bios_dsk->drqp.sect_sz  = 512;  /// @todo device specific?
379	        bios_dsk->drqp.cylinder = cylinder;
380	        bios_dsk->drqp.head     = head;
381	        bios_dsk->drqp.sector   = sector;
382	        bios_dsk->drqp.dev_id   = device;
383	
384	        status = dskacc[bios_dsk->devices[device].type].a[GET_AH() - 0x02](bios_dsk);
385	
386	        // Set nb of sector transferred
387	        SET_AL(bios_dsk->drqp.trsfsectors);
388	
389	        if (status != 0) {
390	            BX_INFO("%s: function %02x, error %02x !\n", __func__, GET_AH(), status);
391	            SET_AH(0x0c);
392	            goto int13_fail_noah;
393	        }
394	
395	        goto int13_success;
396	        break;
397	
398	    case 0x05: /* format disk track */
399	        BX_INFO("format disk track called\n");
400	        goto int13_success;
401	        break;
402	
403	    case 0x08: /* read disk drive parameters */
404	
405	        /* Get the logical geometry from internal table. */
406	        nlc   = bios_dsk->devices[device].lchs.cylinders;
407	        nlh   = bios_dsk->devices[device].lchs.heads;
408	        nlspt = bios_dsk->devices[device].lchs.spt;
409	
410	        count = bios_dsk->hdcount;
411	        /* Maximum cylinder number is just one less than the number of cylinders. */
412	        nlc = nlc - 1; /* 0 based , last sector not used */
413	        SET_AL(0);
414	        SET_CH(nlc & 0xff);
415	        SET_CL(((nlc >> 2) & 0xc0) | (nlspt & 0x3f));
416	        SET_DH(nlh - 1);
417	        SET_DL(count); /* FIXME returns 0, 1, or n hard drives */
418	
419	        // FIXME should set ES & DI
420	        /// @todo Actually, the above comment is nonsense.
421	
422	        goto int13_success;
423	        break;
424	
425	    case 0x10: /* check drive ready */
426	        // should look at 40:8E also???
427	
428	#ifdef VBOX_WITH_SCSI
429	        /* SCSI drives are always "ready". */
430	        if (!VBOX_IS_SCSI_DEVICE(device)) {
431	#endif
432	        // Read the status from controller
433	        status = inb(bios_dsk->channels[device/2].iobase1 + ATA_CB_STAT);
434	        if ( (status & ( ATA_CB_STAT_BSY | ATA_CB_STAT_RDY )) == ATA_CB_STAT_RDY ) {
435	            goto int13_success;
436	        } else {
437	            SET_AH(0xAA);
438	            goto int13_fail_noah;
439	        }
440	#ifdef VBOX_WITH_SCSI
441	        } else  /* It's not an ATA drive. */
442	            goto int13_success;
443	#endif
444	        break;
445	
446	    case 0x15: /* read disk drive size */
447	
448	        /* Get the physical geometry from internal table. */
449	        cylinder = bios_dsk->devices[device].pchs.cylinders;
450	        head     = bios_dsk->devices[device].pchs.heads;
451	        sector   = bios_dsk->devices[device].pchs.spt;
452	
453	        /* Calculate sector count seen by old style INT 13h. */
454	        lba = (uint32_t)cylinder * head * sector;
455	        CX = lba >> 16;
456	        DX = lba & 0xffff;
457	
458	        SET_AH(3);  // hard disk accessible
459	        goto int13_success_noah;
460	        break;
461	
462	    case 0x09: /* initialize drive parameters */
463	    case 0x0c: /* seek to specified cylinder */
464	    case 0x0d: /* alternate disk reset */
465	    case 0x11: /* recalibrate */
466	    case 0x14: /* controller internal diagnostic */
467	        BX_INFO("%s: function %02xh unimplemented, returns success\n", __func__, GET_AH());
468	        goto int13_success;
469	        break;
470	
471	    case 0x0a: /* read disk sectors with ECC */
472	    case 0x0b: /* write disk sectors with ECC */
473	    case 0x18: // set media type for format
474	    default:
475	        BX_INFO("%s: function %02xh unsupported, returns fail\n", __func__, GET_AH());
476	        goto int13_fail;
477	        break;
478	    }
479	
480	int13_fail:
481	    SET_AH(0x01); // defaults to invalid function in AH or invalid parameter
482	int13_fail_noah:
483	    SET_DISK_RET_STATUS(GET_AH());
484	int13_fail_nostatus:
485	    SET_CF();     // error occurred
486	    return;
487	
488	int13_success:
489	    SET_AH(0x00); // no error
490	int13_success_noah:
491	    SET_DISK_RET_STATUS(0x00);
492	    CLEAR_CF();   // no error
493	    return;
494	}
495	
496	void BIOSCALL int13_harddisk_ext(disk_regs_t r)
497	{
498	    uint64_t            lba;
499	    uint16_t            segment, offset;
500	    uint8_t             device, status;
501	    uint16_t            count;
502	    uint8_t             type;
503	    bio_dsk_t __far     *bios_dsk;
504	    int13ext_t __far    *i13_ext;
505	#if 0
506	    uint16_t            ebda_seg = read_word(0x0040,0x000E);
507	    uint16_t            npc, nph, npspt;
508	    uint16_t            size;
509	    dpt_t __far         *dpt;
510	#endif
511	
512	    bios_dsk = read_word(0x0040,0x000E) :> &EbdaData->bdisk;
513	
514	    BX_DEBUG_INT13_HD("%s: AX=%04x BX=%04x CX=%04x DX=%04x ES=%04x DS=%04x SI=%04x\n",
515	                      __func__, AX, BX, CX, DX, ES, DS, SI);
516	
517	    write_byte(0x0040, 0x008e, 0);  // clear completion flag
518	
519	    // basic check : device has to be defined
520	    if ( (GET_ELDL() < 0x80) || (GET_ELDL() >= 0x80 + BX_MAX_STORAGE_DEVICES) ) {
521	        BX_DEBUG("%s: function %02x, ELDL out of range %02x\n", __func__, GET_AH(), GET_ELDL());
522	        goto int13x_fail;
523	    }
524	
525	    // Get the ata channel
526	    device = bios_dsk->hdidmap[GET_ELDL()-0x80];
527	
528	    // basic check : device has to be valid
529	    if (device >= BX_MAX_STORAGE_DEVICES) {
530	        BX_DEBUG("%s: function %02x, unmapped device for ELDL=%02x\n", __func__, GET_AH(), GET_ELDL());
531	        goto int13x_fail;
532	    }
533	
534	    switch (GET_AH()) {
535	    case 0x41: // IBM/MS installation check
536	        BX=0xaa55;     // install check
537	        SET_AH(0x30);  // EDD 3.0
538	        CX=0x0007;     // ext disk access and edd, removable supported
539	        goto int13x_success_noah;
540	        break;
541	
542	    case 0x42: // IBM/MS extended read
543	    case 0x43: // IBM/MS extended write
544	    case 0x44: // IBM/MS verify
545	    case 0x47: // IBM/MS extended seek
546	
547	        /* Get a pointer to the extended structure. */
548	        i13_ext = DS :> (int13ext_t *)SI;
549	
550	        count   = i13_ext->count;
551	        segment = i13_ext->segment;
552	        offset  = i13_ext->offset;
553	
554	        // Get 64 bits lba and check
555	        lba = i13_ext->lba2;
556	        lba <<= 32;
557	        lba |= i13_ext->lba1;
558	
559	        BX_DEBUG_INT13_HD("%s: %d sectors from LBA 0x%llx @ %04x:%04x\n", __func__,
560	                          count, lba, segment, offset);
561	
562	        type = bios_dsk->devices[device].type;
563	        if (lba >= bios_dsk->devices[device].sectors) {
564	              BX_INFO("%s: function %02x. LBA out of range\n", __func__, GET_AH());
565	              goto int13x_fail;
566	        }
567	
568	        /* Don't bother with seek or verify. */
569	        if (( GET_AH() == 0x44 ) || ( GET_AH() == 0x47 ))
570	            goto int13x_success;
571	
572	        /* Clear the count of transferred sectors/bytes. */
573	        bios_dsk->drqp.trsfsectors = 0;
574	        bios_dsk->drqp.trsfbytes   = 0;
575	
576	        /* Pass request information to low level disk code. */
577	        bios_dsk->drqp.lba     = lba;
578	        bios_dsk->drqp.buffer  = MK_FP(segment, offset);
579	        bios_dsk->drqp.nsect   = count;
580	        bios_dsk->drqp.sect_sz = 512;   /// @todo device specific?
581	        bios_dsk->drqp.sector  = 0;     /* Indicate LBA. */
582	        bios_dsk->drqp.dev_id  = device;
583	
584	        /* Execute the read or write command. */
585	        status = dskacc[type].a[GET_AH() - 0x42](bios_dsk);
586	        count  = bios_dsk->drqp.trsfsectors;
587	        i13_ext->count = count;
588	
589	        if (status != 0) {
590	            BX_INFO("%s: function %02x, error %02x !\n", __func__, GET_AH(), status);
591	            SET_AH(0x0c);
592	            goto int13x_fail_noah;
593	        }
594	
595	        goto int13x_success;
596	        break;
597	
598	    case 0x45: // IBM/MS lock/unlock drive
599	    case 0x49: // IBM/MS extended media change
600	        goto int13x_success;   // Always success for HD
601	        break;
602	
603	    case 0x46: // IBM/MS eject media
604	        SET_AH(0xb2);          // Volume Not Removable
605	        goto int13x_fail_noah; // Always fail for HD
606	        break;
607	
608	    case 0x48: // IBM/MS get drive parameters
609	        if (edd_fill_dpt(DS :> (dpt_t *)SI, bios_dsk, device))
610	            goto int13x_fail;
611	        else
612	            goto int13x_success;
613	        break;
614	
615	    case 0x4e: // // IBM/MS set hardware configuration
616	        // DMA, prefetch, PIO maximum not supported
617	        switch (GET_AL()) {
618	        case 0x01:
619	        case 0x03:
620	        case 0x04:
621	        case 0x06:
622	            goto int13x_success;
623	            break;
624	        default :
625	            goto int13x_fail;
626	        }
627	        break;
628	
629	    case 0x50: // IBM/MS send packet command
630	    default:
631	        BX_INFO("%s: function %02xh unsupported, returns fail\n", __func__, GET_AH());
632	        goto int13x_fail;
633	        break;
634	    }
635	
636	int13x_fail:
637	    SET_AH(0x01); // defaults to invalid function in AH or invalid parameter
638	int13x_fail_noah:
639	    SET_DISK_RET_STATUS(GET_AH());
640	    SET_CF();     // error occurred
641	    return;
642	
643	int13x_success:
644	    SET_AH(0x00); // no error
645	int13x_success_noah:
646	    SET_DISK_RET_STATUS(0x00);
647	    CLEAR_CF();   // no error
648	    return;
649	}
650	
651	/* Avoid saving general registers already saved by caller (PUSHA). */
652	#pragma aux int13_harddisk modify [di si cx dx bx];
653	#pragma aux int13_harddisk_ext modify [di si cx dx bx];
654	