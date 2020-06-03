
DOSBox-X
Main Page
Related Pages
Namespaces
Classes
Files

File List
File Members
src/ints/bios_disk.cpp
00001 /*
00002  *  Copyright (C) 2002-2019  The DOSBox Team
00003  *
00004  *  This program is free software; you can redistribute it and/or modify
00005  *  it under the terms of the GNU General Public License as published by
00006  *  the Free Software Foundation; either version 2 of the License, or
00007  *  (at your option) any later version.
00008  *
00009  *  This program is distributed in the hope that it will be useful,
00010  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
00011  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
00012  *  GNU General Public License for more details.
00013  *
00014  *  You should have received a copy of the GNU General Public License
00015  *  along with this program; if not, write to the Free Software
00016  *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1335, USA.
00017  */
00018 
00019 #include "dosbox.h"
00020 #include "callback.h"
00021 #include "bios.h"
00022 #include "bios_disk.h"
00023 #include "regs.h"
00024 #include "mem.h"
00025 #include "dos_inc.h" /* for Drives[] */
00026 #include "../dos/drives.h"
00027 #include "mapper.h"
00028 #include "ide.h"
00029 
00030 #if defined(_MSC_VER)
00031 # pragma warning(disable:4244) /* const fmath::local::uint64_t to double possible loss of data */
00032 #endif
00033 
00034 extern bool int13_extensions_enable;
00035 
00036 diskGeo DiskGeometryList[] = {
00037     { 160,  8, 1, 40, 0, 512,  64, 1, 0xFE},      // IBM PC double density 5.25" single-sided 160KB
00038     { 180,  9, 1, 40, 0, 512,  64, 2, 0xFC},      // IBM PC double density 5.25" single-sided 180KB
00039     { 200, 10, 1, 40, 0, 512,   0, 0,    0},      // DEC Rainbow double density 5.25" single-sided 200KB (I think...)
00040     { 320,  8, 2, 40, 1, 512, 112, 2, 0xFF},      // IBM PC double density 5.25" double-sided 320KB
00041     { 360,  9, 2, 40, 1, 512, 112, 2, 0xFD},      // IBM PC double density 5.25" double-sided 360KB
00042     { 400, 10, 2, 40, 1, 512,   0, 0,    0},      // DEC Rainbow double density 5.25" double-sided 400KB (I think...)
00043     { 640,  8, 2, 80, 3, 512, 112, 2, 0xFB},      // IBM PC double density 3.5" double-sided 640KB
00044     { 720,  9, 2, 80, 3, 512, 112, 2, 0xF9},      // IBM PC double density 3.5" double-sided 720KB
00045     {1200, 15, 2, 80, 2, 512, 224, 1, 0xF9},      // IBM PC double density 5.25" double-sided 1.2MB
00046     {1440, 18, 2, 80, 4, 512, 224, 1, 0xF0},      // IBM PC high density 3.5" double-sided 1.44MB
00047     {2880, 36, 2, 80, 6, 512, 240, 2, 0xF0},      // IBM PC high density 3.5" double-sided 2.88MB
00048 
00049     {1232,  8, 2, 77, 7, 1024,192, 1, 0xFE},      // NEC PC-98 high density 3.5" double-sided 1.2MB "3-mode"
00050 
00051     {   0,  0, 0,  0, 0,    0,  0, 0,    0}
00052 };
00053 
00054 Bitu call_int13 = 0;
00055 Bitu diskparm0 = 0, diskparm1 = 0;
00056 static Bit8u last_status;
00057 static Bit8u last_drive;
00058 Bit16u imgDTASeg;
00059 RealPt imgDTAPtr;
00060 DOS_DTA *imgDTA;
00061 bool killRead;
00062 static bool swapping_requested;
00063 
00064 void CMOS_SetRegister(Bitu regNr, Bit8u val); //For setting equipment word
00065 
00066 /* 2 floppys and 2 harddrives, max */
00067 bool imageDiskChange[MAX_DISK_IMAGES]={false};
00068 imageDisk *imageDiskList[MAX_DISK_IMAGES]={NULL};
00069 imageDisk *diskSwap[MAX_SWAPPABLE_DISKS]={NULL};
00070 Bit32s swapPosition;
00071 
00072 imageDisk *GetINT13FloppyDrive(unsigned char drv) {
00073     if (drv >= 2)
00074         return NULL;
00075     return imageDiskList[drv];
00076 }
00077 
00078 imageDisk *GetINT13HardDrive(unsigned char drv) {
00079     if (drv < 0x80 || drv >= (0x80+MAX_DISK_IMAGES-2))
00080         return NULL;
00081 
00082     return imageDiskList[drv-0x80];
00083 }
00084 
00085 void FreeBIOSDiskList() {
00086     for (int i=0;i < MAX_DISK_IMAGES;i++) {
00087         if (imageDiskList[i] != NULL) {
00088             if (i >= 2) IDE_Hard_Disk_Detach(i);
00089             imageDiskList[i]->Release();
00090             imageDiskList[i] = NULL;
00091         }
00092     }
00093 
00094     for (int j=0;j < MAX_SWAPPABLE_DISKS;j++) {
00095         if (diskSwap[j] != NULL) {
00096             diskSwap[j]->Release();
00097             diskSwap[j] = NULL;
00098         }
00099     }
00100 }
00101 
00102 //update BIOS disk parameter tables for first two hard drives
00103 void updateDPT(void) {
00104     Bit32u tmpheads, tmpcyl, tmpsect, tmpsize;
00105     PhysPt dpphysaddr[2] = { CALLBACK_PhysPointer(diskparm0), CALLBACK_PhysPointer(diskparm1) };
00106     for (int i = 0; i < 2; i++) {
00107         tmpheads = 0; tmpcyl = 0; tmpsect = 0; tmpsize = 0;
00108         if (imageDiskList[i + 2] != NULL) {
00109             imageDiskList[i + 2]->Get_Geometry(&tmpheads, &tmpcyl, &tmpsect, &tmpsize);
00110         }
00111         phys_writew(dpphysaddr[i], (Bit16u)tmpcyl);
00112         phys_writeb(dpphysaddr[i] + 0x2, (Bit8u)tmpheads);
00113         phys_writew(dpphysaddr[i] + 0x3, 0);
00114         phys_writew(dpphysaddr[i] + 0x5, tmpcyl == 0 ? 0 : (Bit16u)-1);
00115         phys_writeb(dpphysaddr[i] + 0x7, 0);
00116         phys_writeb(dpphysaddr[i] + 0x8, tmpcyl == 0 ? 0 : (0xc0 | (((tmpheads) > 8) << 3)));
00117         phys_writeb(dpphysaddr[i] + 0x9, 0);
00118         phys_writeb(dpphysaddr[i] + 0xa, 0);
00119         phys_writeb(dpphysaddr[i] + 0xb, 0);
00120         phys_writew(dpphysaddr[i] + 0xc, (Bit16u)tmpcyl);
00121         phys_writeb(dpphysaddr[i] + 0xe, (Bit8u)tmpsect);
00122     }
00123 }
00124 
00125 void incrementFDD(void) {
00126     Bit16u equipment=mem_readw(BIOS_CONFIGURATION);
00127     if(equipment&1) {
00128         Bitu numofdisks = (equipment>>6)&3;
00129         numofdisks++;
00130         if(numofdisks > 1) numofdisks=1;//max 2 floppies at the moment
00131         equipment&=~0x00C0;
00132         equipment|=(numofdisks<<6);
00133     } else equipment|=1;
00134     mem_writew(BIOS_CONFIGURATION,equipment);
00135     CMOS_SetRegister(0x14, (Bit8u)(equipment&0xff));
00136 }
00137 
00138 int swapInDisksSpecificDrive = -1;
00139 // -1 = swap across A: and B: (DOSBox / DOSBox-X default behavior)
00140 //  0 = swap across A: only
00141 //  1 = swap across B: only
00142 
00143 void swapInDisks(void) {
00144     bool allNull = true;
00145     Bit32s diskcount = 0;
00146     Bits diskswapcount = 2;
00147     Bits diskswapdrive = 0;
00148     Bit32s swapPos = swapPosition;
00149     Bit32s i;
00150 
00151     /* Check to make sure that  there is at least one setup image */
00152     for(i=0;i<MAX_SWAPPABLE_DISKS;i++) {
00153         if(diskSwap[i]!=NULL) {
00154             allNull = false;
00155             break;
00156         }
00157     }
00158 
00159     /* No disks setup... fail */
00160     if (allNull) return;
00161 
00162     /* if a specific drive is to be swapped, then adjust to focus on it */
00163     if (swapInDisksSpecificDrive >= 0 && swapInDisksSpecificDrive <= 1) {
00164         diskswapdrive = swapInDisksSpecificDrive;
00165         diskswapcount = 1;
00166     }
00167 
00168     /* If only one disk is loaded, this loop will load the same disk in dive A and drive B */
00169     while(diskcount < diskswapcount) {
00170         if(diskSwap[swapPos] != NULL) {
00171             LOG_MSG("Loaded drive %d disk %d from swaplist position %d - \"%s\"", (int)diskswapdrive, (int)diskcount, (int)swapPos, diskSwap[swapPos]->diskname.c_str());
00172 
00173             if (imageDiskList[diskswapdrive] != NULL)
00174                 imageDiskList[diskswapdrive]->Release();
00175 
00176             imageDiskList[diskswapdrive] = diskSwap[swapPos];
00177             imageDiskList[diskswapdrive]->Addref();
00178 
00179             imageDiskChange[diskswapdrive] = true;
00180 
00181             diskcount++;
00182             diskswapdrive++;
00183         }
00184 
00185         swapPos++;
00186         if(swapPos>=MAX_SWAPPABLE_DISKS) swapPos=0;
00187     }
00188 }
00189 
00190 bool getSwapRequest(void) {
00191     bool sreq=swapping_requested;
00192     swapping_requested = false;
00193     return sreq;
00194 }
00195 
00196 void swapInNextDisk(bool pressed) {
00197     if (!pressed)
00198         return;
00199     DriveManager::CycleAllDisks();
00200     /* Hack/feature: rescan all disks as well */
00201     LOG_MSG("Diskcaching reset for floppy drives.");
00202     for(Bitu i=0;i<2;i++) { /* Swap A: and B: where DOSBox mainline would run through ALL drive letters */
00203         if (Drives[i] != NULL) {
00204             Drives[i]->EmptyCache();
00205             Drives[i]->MediaChange();
00206         }
00207     }
00208     swapPosition++;
00209     if(diskSwap[swapPosition] == NULL) swapPosition = 0;
00210     swapInDisks();
00211     swapping_requested = true;
00212 }
00213 
00214 void swapInNextCD(bool pressed) {
00215     if (!pressed)
00216         return;
00217     DriveManager::CycleAllCDs();
00218     /* Hack/feature: rescan all disks as well */
00219     LOG_MSG("Diskcaching reset for normal mounted drives.");
00220     for(Bitu i=2;i<DOS_DRIVES;i++) { /* Swap C: D: .... Z: TODO: Need to swap ONLY if a CD-ROM drive! */
00221         if (Drives[i] != NULL) {
00222             Drives[i]->EmptyCache();
00223             Drives[i]->MediaChange();
00224         }
00225     }
00226 }
00227 
00228 
00229 Bit8u imageDisk::Read_Sector(Bit32u head,Bit32u cylinder,Bit32u sector,void * data,unsigned int req_sector_size) {
00230     Bit32u sectnum;
00231 
00232     if (req_sector_size == 0)
00233         req_sector_size = sector_size;
00234     if (req_sector_size != sector_size)
00235         return 0x05;
00236 
00237     sectnum = ( (cylinder * heads + head) * sectors ) + sector - 1L;
00238 
00239     return Read_AbsoluteSector(sectnum, data);
00240 }
00241 
00242 Bit8u imageDisk::Read_AbsoluteSector(Bit32u sectnum, void * data) {
00243     Bit64u bytenum,res;
00244     int got;
00245 
00246     bytenum = (Bit64u)sectnum * (Bit64u)sector_size;
00247     if ((bytenum + sector_size) > this->image_length) {
00248         LOG_MSG("Attempt to read invalid sector in Read_AbsoluteSector for sector %lu.\n", (unsigned long)sectnum);
00249         return 0x05;
00250     }
00251     bytenum += image_base;
00252 
00253     //LOG_MSG("Reading sectors %ld at bytenum %I64d", sectnum, bytenum);
00254 
00255     fseeko64(diskimg,(long)bytenum,SEEK_SET);
00256     res = (Bit64u)ftello64(diskimg);
00257     if (res != bytenum) {
00258         LOG_MSG("fseek() failed in Read_AbsoluteSector for sector %lu. Want=%llu Got=%llu\n",
00259             (unsigned long)sectnum,(unsigned long long)bytenum,(unsigned long long)res);
00260         return 0x05;
00261     }
00262 
00263     got = (int)fread(data, 1, sector_size, diskimg);
00264     if ((unsigned int)got != sector_size) {
00265         LOG_MSG("fread() failed in Read_AbsoluteSector for sector %lu. Want=%u got=%d\n",
00266             (unsigned long)sectnum,(unsigned int)sector_size,(unsigned int)got);
00267         return 0x05;
00268     }
00269 
00270     return 0x00;
00271 }
00272 
00273 Bit8u imageDisk::Write_Sector(Bit32u head,Bit32u cylinder,Bit32u sector,const void * data,unsigned int req_sector_size) {
00274     Bit32u sectnum;
00275 
00276     if (req_sector_size == 0)
00277         req_sector_size = sector_size;
00278     if (req_sector_size != sector_size)
00279         return 0x05;
00280 
00281     sectnum = ( (cylinder * heads + head) * sectors ) + sector - 1L;
00282 
00283     return Write_AbsoluteSector(sectnum, data);
00284 }
00285 
00286 
00287 Bit8u imageDisk::Write_AbsoluteSector(Bit32u sectnum, const void *data) {
00288     Bit64u bytenum;
00289 
00290     bytenum = (Bit64u)sectnum * sector_size;
00291     if ((bytenum + sector_size) > this->image_length) {
00292         LOG_MSG("Attempt to read invalid sector in Write_AbsoluteSector for sector %lu.\n", (unsigned long)sectnum);
00293         return 0x05;
00294     }
00295     bytenum += image_base;
00296 
00297     //LOG_MSG("Writing sectors to %ld at bytenum %d", sectnum, bytenum);
00298 
00299     fseeko64(diskimg,(off_t)bytenum,SEEK_SET);
00300     if ((Bit64u)ftello64(diskimg) != bytenum)
00301         LOG_MSG("WARNING: fseek() failed in Write_AbsoluteSector for sector %lu\n",(unsigned long)sectnum);
00302 
00303     size_t ret=fwrite(data, sector_size, 1, diskimg);
00304 
00305     return ((ret>0)?0x00:0x05);
00306 
00307 }
00308 
00309 void imageDisk::Set_Reserved_Cylinders(Bitu resCyl) {
00310     reserved_cylinders = resCyl;
00311 }
00312 
00313 Bit32u imageDisk::Get_Reserved_Cylinders() {
00314     return reserved_cylinders;
00315 }
00316 
00317 imageDisk::imageDisk(IMAGE_TYPE class_id) {
00318     heads = 0;
00319     cylinders = 0;
00320     image_base = 0;
00321     sectors = 0;
00322     refcount = 0;
00323     sector_size = 512;
00324     image_length = 0;
00325     reserved_cylinders = 0;
00326     diskimg = NULL;
00327     this->class_id = class_id;
00328     active = false;
00329     hardDrive = false;
00330     diskSizeK = 0;
00331     floppytype = 0;
00332 }
00333 
00334 imageDisk::imageDisk(FILE* diskimg, const char* diskName, Bit32u cylinders, Bit32u heads, Bit32u sectors, Bit32u sector_size, bool hardDrive) {
00335     if (diskName) this->diskname = diskName;
00336     this->cylinders = cylinders;
00337     this->heads = heads;
00338     this->sectors = sectors;
00339     image_base = 0;
00340     this->image_length = (Bit64u)cylinders * heads * sectors * sector_size;
00341     refcount = 0;
00342     this->sector_size = sector_size;
00343     this->diskSizeK = this->image_length / 1024;
00344     reserved_cylinders = 0;
00345     this->diskimg = diskimg;
00346     class_id = ID_BASE;
00347     active = true;
00348     this->hardDrive = hardDrive;
00349     floppytype = 0;
00350 }
00351 
00352 /* .HDI and .FDI header (NP2) */
00353 #pragma pack(push,1)
00354 typedef struct {
00355     uint8_t dummy[4];           // +0x00
00356     uint8_t hddtype[4];         // +0x04
00357     uint8_t headersize[4];      // +0x08
00358     uint8_t hddsize[4];         // +0x0C
00359     uint8_t sectorsize[4];      // +0x10
00360     uint8_t sectors[4];         // +0x14
00361     uint8_t surfaces[4];        // +0x18
00362     uint8_t cylinders[4];       // +0x1C
00363 } HDIHDR;                       // =0x20
00364 
00365 typedef struct {
00366         uint8_t dummy[4];           // +0x00
00367         uint8_t fddtype[4];         // +0x04
00368         uint8_t headersize[4];      // +0x08
00369         uint8_t fddsize[4];         // +0x0C
00370         uint8_t sectorsize[4];      // +0x10
00371         uint8_t sectors[4];         // +0x14
00372         uint8_t surfaces[4];        // +0x18
00373         uint8_t cylinders[4];       // +0x1C
00374 } FDIHDR;                       // =0x20
00375 
00376 typedef struct {
00377         char    sig[16];            // +0x000
00378         char    comment[0x100];     // +0x010
00379         UINT8   headersize[4];      // +0x110
00380     uint8_t prot;               // +0x114
00381     uint8_t nhead;              // +0x115
00382     uint8_t _unknown_[10];      // +0x116
00383 } NFDHDR;                       // =0x120
00384 
00385 typedef struct {
00386         char    sig[16];            // +0x000
00387         char    comment[0x100];     // +0x010
00388         UINT8   headersize[4];      // +0x110
00389     uint8_t prot;               // +0x114
00390     uint8_t nhead;              // +0x115
00391     uint8_t _unknown_[10];      // +0x116
00392     uint32_t trackheads[164];   // +0x120
00393     uint32_t addinfo;           // +0x3b0
00394     uint8_t _unknown2_[12];     // +0x3b4
00395 } NFDHDRR1;                     // =0x3c0
00396 
00397 typedef struct {
00398     uint8_t log_cyl;            // +0x0
00399     uint8_t log_head;           // +0x1
00400     uint8_t log_rec;            // +0x2
00401     uint8_t sec_len_pow2;       // +0x3         sz = 128 << len_pow2
00402     uint8_t flMFM;              // +0x4
00403     uint8_t flDDAM;             // +0x5
00404     uint8_t byStatus;           // +0x6
00405     uint8_t bySTS0;             // +0x7
00406     uint8_t bySTS1;             // +0x8
00407     uint8_t bySTS2;             // +0x9
00408     uint8_t byRetry;            // +0xA
00409     uint8_t byPDA;              // +0xB
00410     uint8_t _unknown_[4];       // +0xC
00411 } NFDHDR_ENTRY;                 // =0x10
00412 
00413 typedef struct {
00414     char        szFileID[15];                 // 識別ID "T98HDDIMAGE.R0"
00415     char        Reserve1[1];                  // 予約
00416     char        szComment[0x100];             // イメージコメント(ASCIIz)
00417     uint32_t    dwHeadSize;                   // ヘッダ部のサイズ
00418     uint32_t    dwCylinder;                   // シリンダ数
00419     uint16_t    wHead;                        // ヘッド数
00420     uint16_t    wSect;                        // １トラックあたりのセクタ数
00421     uint16_t    wSectLen;                     // セクタ長
00422     char        Reserve2[2];                  // 予約
00423     char        Reserve3[0xe0];               // 予約
00424 }NHD_FILE_HEAD,*LP_NHD_FILE_HEAD;
00425 #pragma pack(pop)
00426 
00427 imageDisk::imageDisk(FILE *imgFile, Bit8u *imgName, Bit32u imgSizeK, bool isHardDisk) {
00428     heads = 0;
00429     cylinders = 0;
00430     image_base = 0;
00431     image_length = (Bit64u)imgSizeK * (Bit64u)1024;
00432     sectors = 0;
00433     refcount = 0;
00434     sector_size = 512;
00435     reserved_cylinders = 0;
00436     diskimg = imgFile;
00437     class_id = ID_BASE;
00438     diskSizeK = imgSizeK;
00439     floppytype = 0;
00440 
00441     if (imgName != NULL)
00442         diskname = (const char*)imgName;
00443 
00444     active = false;
00445     hardDrive = isHardDisk;
00446     if(!isHardDisk) {
00447         Bit8u i=0;
00448         bool founddisk = false;
00449 
00450         if (imgName != NULL) {
00451             char *ext = strrchr((char*)imgName,'.');
00452             if (ext != NULL) {
00453                 if (!strcasecmp(ext,".fdi")) {
00454                     if (imgSizeK >= 160) {
00455                         FDIHDR fdihdr;
00456 
00457                         // PC-98 .FDI images appear to be 4096 bytes of a short header and many zeros.
00458                         // followed by a straight sector dump of the disk. The header is NOT NECESSARILY
00459                         // 4KB in size, but usually is.
00460                         LOG_MSG("Image file has .FDI extension, assuming FDI image and will take on parameters in header.");
00461 
00462                         assert(sizeof(fdihdr) == 0x20);
00463                         if (fseek(imgFile,0,SEEK_SET) == 0 && ftell(imgFile) == 0 &&
00464                             fread(&fdihdr,sizeof(fdihdr),1,imgFile) == 1) {
00465                             uint32_t ofs = host_readd(fdihdr.headersize);
00466                             uint32_t fddsize = host_readd(fdihdr.fddsize); /* includes header */
00467                             uint32_t sectorsize = host_readd(fdihdr.sectorsize);
00468 
00469                             if (sectorsize != 0 && ((sectorsize & (sectorsize - 1)) == 0/*is power of 2*/) &&
00470                                 sectorsize >= 256 && sectorsize <= 1024 &&
00471                                 ofs != 0 && (ofs % sectorsize) == 0/*offset is nonzero and multiple of sector size*/ &&
00472                                 (ofs % 1024) == 0/*offset is a multiple of 1024 because of imgSizeK*/ &&
00473                                 fddsize >= sectorsize && (fddsize/1024) <= (imgSizeK+4)) {
00474 
00475                                 founddisk = true;
00476                                 sector_size = sectorsize;
00477                                 imgSizeK -= (ofs / 1024);
00478                                 image_base = ofs;
00479                                 image_length -= ofs;
00480                                 LOG_MSG("FDI header: sectorsize is %u bytes/sector, header is %u bytes, fdd size (plus header) is %u bytes",
00481                                     (unsigned int)sectorsize,(unsigned int)ofs,(unsigned int)fddsize);
00482 
00483                                 /* take on the geometry. */
00484                                 sectors = host_readd(fdihdr.sectors);
00485                                 heads = host_readd(fdihdr.surfaces);
00486                                 cylinders = host_readd(fdihdr.cylinders);
00487                                 LOG_MSG("FDI: Geometry is C/H/S %u/%u/%u",
00488                                     (unsigned int)cylinders,(unsigned int)heads,(unsigned int)sectors);
00489                             }
00490                             else {
00491                                 LOG_MSG("FDI header rejected. sectorsize=%u headersize=%u fddsize=%u",
00492                                     (unsigned int)sectorsize,(unsigned int)ofs,(unsigned int)fddsize);
00493                             }
00494                         }
00495                         else {
00496                             LOG_MSG("Unable to read .FDI header");
00497                         }
00498                     }
00499                 }
00500             }
00501         }
00502 
00503         if (sectors == 0 && heads == 0 && cylinders == 0) {
00504             while (DiskGeometryList[i].ksize!=0x0) {
00505                 if ((DiskGeometryList[i].ksize==imgSizeK) ||
00506                         (DiskGeometryList[i].ksize+1==imgSizeK)) {
00507                     if (DiskGeometryList[i].ksize!=imgSizeK)
00508                         LOG_MSG("ImageLoader: image file with additional data, might not load!");
00509                     founddisk = true;
00510                     active = true;
00511                     floppytype = i;
00512                     heads = DiskGeometryList[i].headscyl;
00513                     cylinders = DiskGeometryList[i].cylcount;
00514                     sectors = DiskGeometryList[i].secttrack;
00515                     sector_size = DiskGeometryList[i].bytespersect;
00516                     LOG_MSG("Identified '%s' as C/H/S %u/%u/%u %u bytes/sector",
00517                             imgName,cylinders,heads,sectors,sector_size);
00518                     break;
00519                 }
00520                 i++;
00521             }
00522         }
00523         if(!founddisk) {
00524             active = false;
00525         }
00526     }
00527     else { /* hard disk */
00528         if (imgName != NULL) {
00529             char *ext = strrchr((char*)imgName,'.');
00530             if (ext != NULL) {
00531                 if (!strcasecmp(ext,".nhd")) {
00532                     if (imgSizeK >= 160) {
00533                         NHD_FILE_HEAD nhdhdr;
00534 
00535                         LOG_MSG("Image file has .NHD extension, assuming NHD image and will take on parameters in header.");
00536 
00537                         assert(sizeof(nhdhdr) == 0x200);
00538                         if (fseek(imgFile,0,SEEK_SET) == 0 && ftell(imgFile) == 0 &&
00539                             fread(&nhdhdr,sizeof(nhdhdr),1,imgFile) == 1 &&
00540                             host_readd((ConstHostPt)(&nhdhdr.dwHeadSize)) >= 0x200 &&
00541                             !memcmp(nhdhdr.szFileID,"T98HDDIMAGE.R0\0",15)) {
00542                             uint32_t ofs = host_readd((ConstHostPt)(&nhdhdr.dwHeadSize));
00543                             uint32_t sectorsize = host_readw((ConstHostPt)(&nhdhdr.wSectLen));
00544 
00545                             if (sectorsize != 0 && ((sectorsize & (sectorsize - 1)) == 0/*is power of 2*/) &&
00546                                 sectorsize >= 256 && sectorsize <= 1024 &&
00547                                 ofs != 0 && (ofs % sectorsize) == 0/*offset is nonzero and multiple of sector size*/) {
00548 
00549                                 sector_size = sectorsize;
00550                                 imgSizeK -= (ofs / 1024);
00551                                 image_base = ofs;
00552                                 image_length -= ofs;
00553                                 LOG_MSG("NHD header: sectorsize is %u bytes/sector, header is %u bytes",
00554                                         (unsigned int)sectorsize,(unsigned int)ofs);
00555 
00556                                 /* take on the geometry.
00557                                  * PC-98 IPL1 support will need it to make sense of the partition table. */
00558                                 sectors = host_readw((ConstHostPt)(&nhdhdr.wSect));
00559                                 heads = host_readw((ConstHostPt)(&nhdhdr.wHead));
00560                                 cylinders = host_readd((ConstHostPt)(&nhdhdr.dwCylinder));
00561                                 LOG_MSG("NHD: Geometry is C/H/S %u/%u/%u",
00562                                         (unsigned int)cylinders,(unsigned int)heads,(unsigned int)sectors);
00563                             }
00564                             else {
00565                                 LOG_MSG("NHD header rejected. sectorsize=%u headersize=%u",
00566                                         (unsigned int)sectorsize,(unsigned int)ofs);
00567                             }
00568                         }
00569                         else {
00570                             LOG_MSG("Unable to read .NHD header");
00571                         }
00572                     }
00573                 }
00574                 if (!strcasecmp(ext,".hdi")) {
00575                     if (imgSizeK >= 160) {
00576                         HDIHDR hdihdr;
00577 
00578                         // PC-98 .HDI images appear to be 4096 bytes of a short header and many zeros.
00579                         // followed by a straight sector dump of the disk. The header is NOT NECESSARILY
00580                         // 4KB in size, but usually is.
00581                         LOG_MSG("Image file has .HDI extension, assuming HDI image and will take on parameters in header.");
00582 
00583                         assert(sizeof(hdihdr) == 0x20);
00584                         if (fseek(imgFile,0,SEEK_SET) == 0 && ftell(imgFile) == 0 &&
00585                             fread(&hdihdr,sizeof(hdihdr),1,imgFile) == 1) {
00586                             uint32_t ofs = host_readd(hdihdr.headersize);
00587                             uint32_t hddsize = host_readd(hdihdr.hddsize); /* includes header */
00588                             uint32_t sectorsize = host_readd(hdihdr.sectorsize);
00589 
00590                             if (sectorsize != 0 && ((sectorsize & (sectorsize - 1)) == 0/*is power of 2*/) &&
00591                                 sectorsize >= 256 && sectorsize <= 1024 &&
00592                                 ofs != 0 && (ofs % sectorsize) == 0/*offset is nonzero and multiple of sector size*/ &&
00593                                 (ofs % 1024) == 0/*offset is a multiple of 1024 because of imgSizeK*/ &&
00594                                 hddsize >= sectorsize && (hddsize/1024) <= (imgSizeK+4)) {
00595 
00596                                 sector_size = sectorsize;
00597                                 imgSizeK -= (ofs / 1024);
00598                                 image_base = ofs;
00599                                 image_length -= ofs;
00600                                 LOG_MSG("HDI header: sectorsize is %u bytes/sector, header is %u bytes, hdd size (plus header) is %u bytes",
00601                                     (unsigned int)sectorsize,(unsigned int)ofs,(unsigned int)hddsize);
00602 
00603                                 /* take on the geometry.
00604                                  * PC-98 IPL1 support will need it to make sense of the partition table. */
00605                                 sectors = host_readd(hdihdr.sectors);
00606                                 heads = host_readd(hdihdr.surfaces);
00607                                 cylinders = host_readd(hdihdr.cylinders);
00608                                 LOG_MSG("HDI: Geometry is C/H/S %u/%u/%u",
00609                                     (unsigned int)cylinders,(unsigned int)heads,(unsigned int)sectors);
00610                             }
00611                             else {
00612                                 LOG_MSG("HDI header rejected. sectorsize=%u headersize=%u hddsize=%u",
00613                                     (unsigned int)sectorsize,(unsigned int)ofs,(unsigned int)hddsize);
00614                             }
00615                         }
00616                         else {
00617                             LOG_MSG("Unable to read .HDI header");
00618                         }
00619                     }
00620                 }
00621             }
00622         }
00623 
00624         if (sectors == 0 || heads == 0 || cylinders == 0)
00625             active = false;
00626     }
00627 }
00628 
00629 void imageDisk::Set_Geometry(Bit32u setHeads, Bit32u setCyl, Bit32u setSect, Bit32u setSectSize) {
00630     Bitu bigdisk_shift = 0;
00631 
00632     if (IS_PC98_ARCH) {
00633         /* TODO: PC-98 has it's own 4096 cylinder limit */
00634     }
00635     else {
00636         if(setCyl > 16384) LOG_MSG("This disk image is too big.");
00637         else if(setCyl > 8192) bigdisk_shift = 4;
00638         else if(setCyl > 4096) bigdisk_shift = 3;
00639         else if(setCyl > 2048) bigdisk_shift = 2;
00640         else if(setCyl > 1024) bigdisk_shift = 1;
00641     }
00642 
00643     heads = setHeads << bigdisk_shift;
00644     cylinders = setCyl >> bigdisk_shift;
00645     sectors = setSect;
00646     sector_size = setSectSize;
00647     active = true;
00648 }
00649 
00650 void imageDisk::Get_Geometry(Bit32u * getHeads, Bit32u *getCyl, Bit32u *getSect, Bit32u *getSectSize) {
00651     *getHeads = heads;
00652     *getCyl = cylinders;
00653     *getSect = sectors;
00654     *getSectSize = sector_size;
00655 }
00656 
00657 Bit8u imageDisk::GetBiosType(void) {
00658     if(!hardDrive) {
00659         return (Bit8u)DiskGeometryList[floppytype].biosval;
00660     } else return 0;
00661 }
00662 
00663 Bit32u imageDisk::getSectSize(void) {
00664     return sector_size;
00665 }
00666 
00667 static Bit8u GetDosDriveNumber(Bit8u biosNum) {
00668     switch(biosNum) {
00669         case 0x0:
00670             return 0x0;
00671         case 0x1:
00672             return 0x1;
00673         case 0x80:
00674             return 0x2;
00675         case 0x81:
00676             return 0x3;
00677         case 0x82:
00678             return 0x4;
00679         case 0x83:
00680             return 0x5;
00681         default:
00682             return 0x7f;
00683     }
00684 }
00685 
00686 static bool driveInactive(Bit8u driveNum) {
00687     if(driveNum>=(2 + MAX_HDD_IMAGES)) {
00688         LOG(LOG_BIOS,LOG_ERROR)("Disk %d non-existant", (int)driveNum);
00689         last_status = 0x01;
00690         CALLBACK_SCF(true);
00691         return true;
00692     }
00693     if(imageDiskList[driveNum] == NULL) {
00694         LOG(LOG_BIOS,LOG_ERROR)("Disk %d not active", (int)driveNum);
00695         last_status = 0x01;
00696         CALLBACK_SCF(true);
00697         return true;
00698     }
00699     if(!imageDiskList[driveNum]->active) {
00700         LOG(LOG_BIOS,LOG_ERROR)("Disk %d not active", (int)driveNum);
00701         last_status = 0x01;
00702         CALLBACK_SCF(true);
00703         return true;
00704     }
00705     return false;
00706 }
00707 
00708 static struct {
00709     Bit8u sz;
00710     Bit8u res;
00711     Bit16u num;
00712     Bit16u off;
00713     Bit16u seg;
00714     Bit32u sector;
00715 } dap;
00716 
00717 static void readDAP(Bit16u seg, Bit16u off) {
00718     dap.sz = real_readb(seg,off++);
00719     dap.res = real_readb(seg,off++);
00720     dap.num = real_readw(seg,off); off += 2;
00721     dap.off = real_readw(seg,off); off += 2;
00722     dap.seg = real_readw(seg,off); off += 2;
00723 
00724     /* Although sector size is 64-bit, 32-bit 2TB limit should be more than enough */
00725     dap.sector = real_readd(seg,off); off +=4;
00726 
00727     if (real_readd(seg,off)) {
00728         E_Exit("INT13: 64-bit sector addressing not supported");
00729     }
00730 }
00731 
00732 void IDE_ResetDiskByBIOS(unsigned char disk);
00733 void IDE_EmuINT13DiskReadByBIOS(unsigned char disk,unsigned int cyl,unsigned int head,unsigned sect);
00734 void IDE_EmuINT13DiskReadByBIOS_LBA(unsigned char disk,uint64_t lba);
00735 
00736 static Bitu INT13_DiskHandler(void) {
00737     Bit16u segat, bufptr;
00738     Bit8u sectbuf[512];
00739     Bit8u  drivenum;
00740     Bitu  i,t;
00741     last_drive = reg_dl;
00742     drivenum = GetDosDriveNumber(reg_dl);
00743     bool any_images = false;
00744     for(i = 0;i < MAX_DISK_IMAGES;i++) {
00745         if(imageDiskList[i]) any_images=true;
00746     }
00747 
00748     // unconditionally enable the interrupt flag
00749     CALLBACK_SIF(true);
00750 
00751     /* map out functions 0x40-0x48 if not emulating INT 13h extensions */
00752     if (!int13_extensions_enable && reg_ah >= 0x40 && reg_ah <= 0x48) {
00753         LOG_MSG("Warning: Guest is attempting to use INT 13h extensions (AH=0x%02X). Set 'int 13 extensions=1' if you want to enable them.\n",reg_ah);
00754         reg_ah=0xff;
00755         CALLBACK_SCF(true);
00756         return CBRET_NONE;
00757     }
00758 
00759     //drivenum = 0;
00760     //LOG_MSG("INT13: Function %x called on drive %x (dos drive %d)", reg_ah,  reg_dl, drivenum);
00761 
00762     // NOTE: the 0xff error code returned in some cases is questionable; 0x01 seems more correct
00763     switch(reg_ah) {
00764     case 0x0: /* Reset disk */
00765         {
00766             /* if there aren't any diskimages (so only localdrives and virtual drives)
00767              * always succeed on reset disk. If there are diskimages then and only then
00768              * do real checks
00769              */
00770             if (any_images && driveInactive(drivenum)) {
00771                 /* driveInactive sets carry flag if the specified drive is not available */
00772                 if ((machine==MCH_CGA) || (machine==MCH_AMSTRAD) || (machine==MCH_PCJR)) {
00773                     /* those bioses call floppy drive reset for invalid drive values */
00774                     if (((imageDiskList[0]) && (imageDiskList[0]->active)) || ((imageDiskList[1]) && (imageDiskList[1]->active))) {
00775                         if (machine!=MCH_PCJR && reg_dl<0x80) reg_ip++;
00776                         last_status = 0x00;
00777                         CALLBACK_SCF(false);
00778                     }
00779                 }
00780                 return CBRET_NONE;
00781             }
00782             if (machine!=MCH_PCJR && reg_dl<0x80) reg_ip++;
00783             if (reg_dl >= 0x80) IDE_ResetDiskByBIOS(reg_dl);
00784             last_status = 0x00;
00785             CALLBACK_SCF(false);
00786         }
00787         break;
00788     case 0x1: /* Get status of last operation */
00789 
00790         if(last_status != 0x00) {
00791             reg_ah = last_status;
00792             CALLBACK_SCF(true);
00793         } else {
00794             reg_ah = 0x00;
00795             CALLBACK_SCF(false);
00796         }
00797         break;
00798     case 0x2: /* Read sectors */
00799         if (reg_al==0) {
00800             reg_ah = 0x01;
00801             CALLBACK_SCF(true);
00802             return CBRET_NONE;
00803         }
00804         if (!any_images) {
00805             if (drivenum >= DOS_DRIVES || !Drives[drivenum] || Drives[drivenum]->isRemovable()) {
00806                 reg_ah = 0x01;
00807                 CALLBACK_SCF(true);
00808                 return CBRET_NONE;
00809             }
00810             // Inherit the Earth cdrom and Amberstar use it as a disk test
00811             if (((reg_dl&0x80)==0x80) && (reg_dh==0) && ((reg_cl&0x3f)==1)) {
00812                 if (reg_ch==0) {
00813                     PhysPt ptr = PhysMake(SegValue(es),reg_bx);
00814                     // write some MBR data into buffer for Amberstar installer
00815                     mem_writeb(ptr+0x1be,0x80); // first partition is active
00816                     mem_writeb(ptr+0x1c2,0x06); // first partition is FAT16B
00817                 }
00818                 reg_ah = 0;
00819                 CALLBACK_SCF(false);
00820                 return CBRET_NONE;
00821             }
00822         }
00823         if (driveInactive(drivenum)) {
00824             reg_ah = 0xff;
00825             CALLBACK_SCF(true);
00826             return CBRET_NONE;
00827         }
00828 
00829         /* INT 13h is limited to 512 bytes/sector (as far as I know).
00830          * The sector buffer in this function is limited to 512 bytes/sector,
00831          * so this is also a protection against overruning the stack if you
00832          * mount a PC-98 disk image (1024 bytes/sector) and try to read it with INT 13h. */
00833         if (imageDiskList[drivenum]->sector_size > sizeof(sectbuf)) {
00834             LOG(LOG_MISC,LOG_DEBUG)("INT 13h: Read failed because disk bytes/sector on drive %c is too large",(char)drivenum+'A');
00835 
00836             imageDiskChange[drivenum] = false;
00837 
00838             reg_ah = 0x80; /* timeout */
00839             CALLBACK_SCF(true);
00840             return CBRET_NONE;
00841         }
00842 
00843         /* If the disk changed, the first INT 13h read will signal an error and set AH = 0x06 to indicate disk change */
00844         if (drivenum < 2 && imageDiskChange[drivenum]) {
00845             LOG(LOG_MISC,LOG_DEBUG)("INT 13h: Failing first read of drive %c to indicate disk change",(char)drivenum+'A');
00846 
00847             imageDiskChange[drivenum] = false;
00848 
00849             reg_ah = 0x06; /* diskette changed or removed */
00850             CALLBACK_SCF(true);
00851             return CBRET_NONE;
00852         }
00853 
00854         segat = SegValue(es);
00855         bufptr = reg_bx;
00856         for(i=0;i<reg_al;i++) {
00857             last_status = imageDiskList[drivenum]->Read_Sector((Bit32u)reg_dh, (Bit32u)(reg_ch | ((reg_cl & 0xc0)<< 2)), (Bit32u)((reg_cl & 63)+i), sectbuf);
00858 
00859             /* IDE emulation: simulate change of IDE state that would occur on a real machine after INT 13h */
00860             IDE_EmuINT13DiskReadByBIOS(reg_dl, (Bit32u)(reg_ch | ((reg_cl & 0xc0)<< 2)), (Bit32u)reg_dh, (Bit32u)((reg_cl & 63)+i));
00861 
00862             if((last_status != 0x00) || (killRead)) {
00863                 LOG_MSG("Error in disk read");
00864                 killRead = false;
00865                 reg_ah = 0x04;
00866                 CALLBACK_SCF(true);
00867                 return CBRET_NONE;
00868             }
00869             for(t=0;t<512;t++) {
00870                 real_writeb(segat,bufptr,sectbuf[t]);
00871                 bufptr++;
00872             }
00873         }
00874         reg_ah = 0x00;
00875         CALLBACK_SCF(false);
00876         break;
00877     case 0x3: /* Write sectors */
00878         
00879         if(driveInactive(drivenum)) {
00880             reg_ah = 0xff;
00881             CALLBACK_SCF(true);
00882             return CBRET_NONE;
00883         }                     
00884 
00885         /* INT 13h is limited to 512 bytes/sector (as far as I know).
00886          * The sector buffer in this function is limited to 512 bytes/sector,
00887          * so this is also a protection against overruning the stack if you
00888          * mount a PC-98 disk image (1024 bytes/sector) and try to read it with INT 13h. */
00889         if (imageDiskList[drivenum]->sector_size > sizeof(sectbuf)) {
00890             LOG(LOG_MISC,LOG_DEBUG)("INT 13h: Write failed because disk bytes/sector on drive %c is too large",(char)drivenum+'A');
00891 
00892             imageDiskChange[drivenum] = false;
00893 
00894             reg_ah = 0x80; /* timeout */
00895             CALLBACK_SCF(true);
00896             return CBRET_NONE;
00897         }
00898 
00899         bufptr = reg_bx;
00900         for(i=0;i<reg_al;i++) {
00901             for(t=0;t<imageDiskList[drivenum]->getSectSize();t++) {
00902                 sectbuf[t] = real_readb(SegValue(es),bufptr);
00903                 bufptr++;
00904             }
00905 
00906             last_status = imageDiskList[drivenum]->Write_Sector((Bit32u)reg_dh, (Bit32u)(reg_ch | ((reg_cl & 0xc0) << 2)), (Bit32u)((reg_cl & 63) + i), &sectbuf[0]);
00907             if(last_status != 0x00) {
00908             CALLBACK_SCF(true);
00909                 return CBRET_NONE;
00910             }
00911         }
00912         reg_ah = 0x00;
00913         CALLBACK_SCF(false);
00914         break;
00915     case 0x04: /* Verify sectors */
00916         if (reg_al==0) {
00917             reg_ah = 0x01;
00918             CALLBACK_SCF(true);
00919             return CBRET_NONE;
00920         }
00921         if(driveInactive(drivenum)) {
00922             reg_ah = last_status;
00923             return CBRET_NONE;
00924         }
00925 
00926         /* TODO: Finish coding this section */
00927         /*
00928         segat = SegValue(es);
00929         bufptr = reg_bx;
00930         for(i=0;i<reg_al;i++) {
00931             last_status = imageDiskList[drivenum]->Read_Sector((Bit32u)reg_dh, (Bit32u)(reg_ch | ((reg_cl & 0xc0)<< 2)), (Bit32u)((reg_cl & 63)+i), sectbuf);
00932             if(last_status != 0x00) {
00933                 LOG_MSG("Error in disk read");
00934                 CALLBACK_SCF(true);
00935                 return CBRET_NONE;
00936             }
00937             for(t=0;t<512;t++) {
00938                 real_writeb(segat,bufptr,sectbuf[t]);
00939                 bufptr++;
00940             }
00941         }*/
00942         reg_ah = 0x00;
00943         //Qbix: The following codes don't match my specs. al should be number of sector verified
00944         //reg_al = 0x10; /* CRC verify failed */
00945         //reg_al = 0x00; /* CRC verify succeeded */
00946         CALLBACK_SCF(false);
00947           
00948         break;
00949     case 0x05: /* Format track */
00950         /* ignore it. I just fucking want FORMAT.COM to write the FAT structure for God's sake */
00951         LOG_MSG("WARNING: Format track ignored\n");
00952         if (driveInactive(drivenum)) {
00953             reg_ah = 0xff;
00954             CALLBACK_SCF(true);
00955             return CBRET_NONE;
00956         }
00957         CALLBACK_SCF(false);
00958         reg_ah = 0x00;
00959         break;
00960     case 0x06: /* Format track set bad sector flags */
00961         /* ignore it. I just fucking want FORMAT.COM to write the FAT structure for God's sake */
00962         LOG_MSG("WARNING: Format track set bad sector flags ignored (6)\n");
00963         if (driveInactive(drivenum)) {
00964             reg_ah = 0xff;
00965             CALLBACK_SCF(true);
00966             return CBRET_NONE;
00967         }
00968         CALLBACK_SCF(false);
00969         reg_ah = 0x00;
00970         break;
00971     case 0x07: /* Format track set bad sector flags */
00972         /* ignore it. I just fucking want FORMAT.COM to write the FAT structure for God's sake */
00973         LOG_MSG("WARNING: Format track set bad sector flags ignored (7)\n");
00974         if (driveInactive(drivenum)) {
00975             reg_ah = 0xff;
00976             CALLBACK_SCF(true);
00977             return CBRET_NONE;
00978         }
00979         CALLBACK_SCF(false);
00980         reg_ah = 0x00;
00981         break;
00982     case 0x08: /* Get drive parameters */
00983         if(driveInactive(drivenum)) {
00984             last_status = 0x07;
00985             reg_ah = last_status;
00986             CALLBACK_SCF(true);
00987             return CBRET_NONE;
00988         }
00989         reg_ax = 0x00;
00990         reg_bl = imageDiskList[drivenum]->GetBiosType();
00991         Bit32u tmpheads, tmpcyl, tmpsect, tmpsize;
00992         imageDiskList[drivenum]->Get_Geometry(&tmpheads, &tmpcyl, &tmpsect, &tmpsize);
00993         if (tmpcyl==0) LOG(LOG_BIOS,LOG_ERROR)("INT13 DrivParm: cylinder count zero!");
00994         else tmpcyl--;      // cylinder count -> max cylinder
00995         if (tmpheads==0) LOG(LOG_BIOS,LOG_ERROR)("INT13 DrivParm: head count zero!");
00996         else tmpheads--;    // head count -> max head
00997 
00998         /* older BIOSes were known to subtract 1 or 2 additional "reserved" cylinders.
00999          * some code, such as Windows 3.1 WDCTRL, might assume that fact. emulate that here */
01000         {
01001             Bit32u reserv = imageDiskList[drivenum]->Get_Reserved_Cylinders();
01002             if (tmpcyl > reserv) tmpcyl -= reserv;
01003             else tmpcyl = 0;
01004         }
01005 
01006         reg_ch = (Bit8u)(tmpcyl & 0xff);
01007         reg_cl = (Bit8u)(((tmpcyl >> 2) & 0xc0) | (tmpsect & 0x3f)); 
01008         reg_dh = (Bit8u)tmpheads;
01009         last_status = 0x00;
01010         if (reg_dl&0x80) {  // harddisks
01011             reg_dl = 0;
01012             for (int index = 2; index < MAX_DISK_IMAGES; index++) {
01013                 if (imageDiskList[index] != NULL) reg_dl++;
01014             }
01015         } else {        // floppy disks
01016             reg_dl = 0;
01017             if(imageDiskList[0] != NULL) reg_dl++;
01018             if(imageDiskList[1] != NULL) reg_dl++;
01019         }
01020         CALLBACK_SCF(false);
01021         break;
01022     case 0x11: /* Recalibrate drive */
01023         reg_ah = 0x00;
01024         CALLBACK_SCF(false);
01025         break;
01026     case 0x15: /* Get disk type */
01027         /* Korean Powerdolls uses this to detect harddrives */
01028         LOG(LOG_BIOS,LOG_WARN)("INT13: Get disktype used!");
01029         if (any_images) {
01030             if(driveInactive(drivenum)) {
01031                 last_status = 0x07;
01032                 reg_ah = last_status;
01033                 CALLBACK_SCF(true);
01034                 return CBRET_NONE;
01035             }
01036             Bit32u tmpheads, tmpcyl, tmpsect, tmpsize;
01037             imageDiskList[drivenum]->Get_Geometry(&tmpheads, &tmpcyl, &tmpsect, &tmpsize);
01038             Bit64u largesize = tmpheads*tmpcyl*tmpsect*tmpsize;
01039             largesize/=512;
01040             Bit32u ts = static_cast<Bit32u>(largesize);
01041             reg_ah = (drivenum <2)?1:3; //With 2 for floppy MSDOS starts calling int 13 ah 16
01042             if(reg_ah == 3) {
01043                 reg_cx = static_cast<Bit16u>(ts >>16);
01044                 reg_dx = static_cast<Bit16u>(ts & 0xffff);
01045             }
01046             CALLBACK_SCF(false);
01047         } else {
01048             if (drivenum <DOS_DRIVES && (Drives[drivenum] != 0 || drivenum <2)) {
01049                 if (drivenum <2) {
01050                     //TODO use actual size (using 1.44 for now).
01051                     reg_ah = 0x1; // type
01052 //                  reg_cx = 0;
01053 //                  reg_dx = 2880; //Only set size for harddrives.
01054                 } else {
01055                     //TODO use actual size (using 105 mb for now).
01056                     reg_ah = 0x3; // type
01057                     reg_cx = 3;
01058                     reg_dx = 0x4800;
01059                 }
01060                 CALLBACK_SCF(false);
01061             } else { 
01062                 LOG(LOG_BIOS,LOG_WARN)("INT13: no images, but invalid drive for call 15");
01063                 reg_ah=0xff;
01064                 CALLBACK_SCF(true);
01065             }
01066         }
01067         break;
01068     case 0x17: /* Set disk type for format */
01069         /* Pirates! needs this to load */
01070         killRead = true;
01071         reg_ah = 0x00;
01072         CALLBACK_SCF(false);
01073         break;
01074     case 0x41: /* Check Extensions Present */
01075         if ((reg_bx == 0x55aa) && !(driveInactive(drivenum))) {
01076             LOG_MSG("INT13: Check Extensions Present for drive: 0x%x", reg_dl);
01077             reg_ah=0x1; /* 1.x extension supported */
01078             reg_bx=0xaa55;  /* Extensions installed */
01079             reg_cx=0x1; /* Extended disk access functions (AH=42h-44h,47h,48h) supported */
01080             CALLBACK_SCF(false);
01081             break;
01082         }
01083         LOG_MSG("INT13: AH=41h, Function not supported 0x%x for drive: 0x%x", reg_bx, reg_dl);
01084         CALLBACK_SCF(true);
01085         break;
01086     case 0x42: /* Extended Read Sectors From Drive */
01087         /* Read Disk Address Packet */
01088         readDAP(SegValue(ds),reg_si);
01089 
01090         if (dap.num==0) {
01091             reg_ah = 0x01;
01092             CALLBACK_SCF(true);
01093             return CBRET_NONE;
01094         }
01095         if (!any_images) {
01096             // Inherit the Earth cdrom (uses it as disk test)
01097             if (((reg_dl&0x80)==0x80) && (reg_dh==0) && ((reg_cl&0x3f)==1)) {
01098                 reg_ah = 0;
01099                 CALLBACK_SCF(false);
01100                 return CBRET_NONE;
01101             }
01102         }
01103         if (driveInactive(drivenum)) {
01104             reg_ah = 0xff;
01105             CALLBACK_SCF(true);
01106             return CBRET_NONE;
01107         }
01108 
01109         segat = dap.seg;
01110         bufptr = dap.off;
01111         for(i=0;i<dap.num;i++) {
01112             last_status = imageDiskList[drivenum]->Read_AbsoluteSector(dap.sector+i, sectbuf);
01113 
01114             IDE_EmuINT13DiskReadByBIOS_LBA(reg_dl,dap.sector+i);
01115 
01116             if((last_status != 0x00) || (killRead)) {
01117                 LOG_MSG("Error in disk read");
01118                 killRead = false;
01119                 reg_ah = 0x04;
01120                 CALLBACK_SCF(true);
01121                 return CBRET_NONE;
01122             }
01123             for(t=0;t<512;t++) {
01124                 real_writeb(segat,bufptr,sectbuf[t]);
01125                 bufptr++;
01126             }
01127         }
01128         reg_ah = 0x00;
01129         CALLBACK_SCF(false);
01130         break;
01131     case 0x43: /* Extended Write Sectors to Drive */
01132         if(driveInactive(drivenum)) {
01133             reg_ah = 0xff;
01134             CALLBACK_SCF(true);
01135             return CBRET_NONE;
01136         }
01137 
01138         /* Read Disk Address Packet */
01139         readDAP(SegValue(ds),reg_si);
01140         bufptr = dap.off;
01141         for(i=0;i<dap.num;i++) {
01142             for(t=0;t<imageDiskList[drivenum]->getSectSize();t++) {
01143                 sectbuf[t] = real_readb(dap.seg,bufptr);
01144                 bufptr++;
01145             }
01146 
01147             last_status = imageDiskList[drivenum]->Write_AbsoluteSector(dap.sector+i, &sectbuf[0]);
01148             if(last_status != 0x00) {
01149                 CALLBACK_SCF(true);
01150                 return CBRET_NONE;
01151             }
01152         }
01153         reg_ah = 0x00;
01154         CALLBACK_SCF(false);
01155         break;
01156     case 0x48: { /* get drive parameters */
01157         uint16_t bufsz;
01158 
01159         if(driveInactive(drivenum)) {
01160             reg_ah = 0xff;
01161             CALLBACK_SCF(true);
01162             return CBRET_NONE;
01163         }
01164 
01165         segat = SegValue(ds);
01166         bufptr = reg_si;
01167         bufsz = real_readw(segat,bufptr+0);
01168         if (bufsz < 0x1A) {
01169             reg_ah = 0xff;
01170             CALLBACK_SCF(true);
01171             return CBRET_NONE;
01172         }
01173         if (bufsz > 0x1E) bufsz = 0x1E;
01174         else bufsz = 0x1A;
01175 
01176         Bit32u tmpheads, tmpcyl, tmpsect, tmpsize;
01177         imageDiskList[drivenum]->Get_Geometry(&tmpheads, &tmpcyl, &tmpsect, &tmpsize);
01178 
01179         real_writew(segat,bufptr+0x00,bufsz);
01180         real_writew(segat,bufptr+0x02,0x0003);  /* C/H/S valid, DMA boundary errors handled */
01181         real_writed(segat,bufptr+0x04,tmpcyl);
01182         real_writed(segat,bufptr+0x08,tmpheads);
01183         real_writed(segat,bufptr+0x0C,tmpsect);
01184         real_writed(segat,bufptr+0x10,tmpcyl*tmpheads*tmpsect);
01185         real_writed(segat,bufptr+0x14,0);
01186         real_writew(segat,bufptr+0x18,512);
01187         if (bufsz >= 0x1E)
01188             real_writed(segat,bufptr+0x1A,0xFFFFFFFF); /* no EDD information available */
01189 
01190         reg_ah = 0x00;
01191         CALLBACK_SCF(false);
01192         } break;
01193     default:
01194         LOG(LOG_BIOS,LOG_ERROR)("INT13: Function %x called on drive %x (dos drive %d)", (int)reg_ah, (int)reg_dl, (int)drivenum);
01195         reg_ah=0xff;
01196         CALLBACK_SCF(true);
01197     }
01198     return CBRET_NONE;
01199 }
01200 
01201 void CALLBACK_DeAllocate(Bitu in);
01202 
01203 void BIOS_UnsetupDisks(void) {
01204     if (call_int13 != 0) {
01205         CALLBACK_DeAllocate(call_int13);
01206         RealSetVec(0x13,0); /* zero INT 13h for now */
01207         call_int13 = 0;
01208     }
01209     if (diskparm0 != 0) {
01210         CALLBACK_DeAllocate(diskparm0);
01211         diskparm0 = 0;
01212     }
01213     if (diskparm1 != 0) {
01214         CALLBACK_DeAllocate(diskparm1);
01215         diskparm1 = 0;
01216     }
01217 }
01218 
01219 void BIOS_SetupDisks(void) {
01220     unsigned int i;
01221 
01222     if (IS_PC98_ARCH) {
01223         // TODO
01224         return;
01225     }
01226 
01227 /* TODO Start the time correctly */
01228     call_int13=CALLBACK_Allocate(); 
01229     CALLBACK_Setup(call_int13,&INT13_DiskHandler,CB_INT13,"Int 13 Bios disk");
01230     RealSetVec(0x13,CALLBACK_RealPointer(call_int13));
01231 
01232     //release the drives after a soft reset
01233     FreeBIOSDiskList();
01234 
01235     /* FIXME: Um... these aren't callbacks. Why are they allocated as callbacks? We have ROM general allocation now. */
01236     diskparm0 = CALLBACK_Allocate();
01237     CALLBACK_SetDescription(diskparm0,"BIOS Disk 0 parameter table");
01238     diskparm1 = CALLBACK_Allocate();
01239     CALLBACK_SetDescription(diskparm1,"BIOS Disk 1 parameter table");
01240     swapPosition = 0;
01241 
01242     RealSetVec(0x41,CALLBACK_RealPointer(diskparm0));
01243     RealSetVec(0x46,CALLBACK_RealPointer(diskparm1));
01244 
01245     PhysPt dp0physaddr=CALLBACK_PhysPointer(diskparm0);
01246     PhysPt dp1physaddr=CALLBACK_PhysPointer(diskparm1);
01247     for(i=0;i<16;i++) {
01248         phys_writeb(dp0physaddr+i,0);
01249         phys_writeb(dp1physaddr+i,0);
01250     }
01251 
01252     imgDTASeg = 0;
01253 
01254 /* Setup the Bios Area */
01255     mem_writeb(BIOS_HARDDISK_COUNT,2);
01256 
01257     killRead = false;
01258     swapping_requested = false;
01259 }
01260 
01261 // VFD *.FDD floppy disk format support
01262 
01263 Bit8u imageDiskVFD::Read_Sector(Bit32u head,Bit32u cylinder,Bit32u sector,void * data,unsigned int req_sector_size) {
01264     vfdentry *ent;
01265 
01266     if (req_sector_size == 0)
01267         req_sector_size = sector_size;
01268 
01269 //    LOG_MSG("VFD read sector: CHS %u/%u/%u sz=%u",cylinder,head,sector,req_sector_size);
01270 
01271     ent = findSector(head,cylinder,sector,req_sector_size);
01272     if (ent == NULL) return 0x05;
01273     if (ent->getSectorSize() != req_sector_size) return 0x05;
01274 
01275     if (ent->hasSectorData()) {
01276         fseek(diskimg,(long)ent->data_offset,SEEK_SET);
01277         if ((uint32_t)ftell(diskimg) != ent->data_offset) return 0x05;
01278         if (fread(data,req_sector_size,1,diskimg) != 1) return 0x05;
01279         return 0;
01280     }
01281     else if (ent->hasFill()) {
01282         memset(data,ent->fillbyte,req_sector_size);
01283         return 0x00;
01284     }
01285 
01286     return 0x05;
01287 }
01288 
01289 Bit8u imageDiskVFD::Read_AbsoluteSector(Bit32u sectnum, void * data) {
01290     unsigned int c,h,s;
01291 
01292     if (sectors == 0 || heads == 0)
01293         return 0x05;
01294 
01295     s = (sectnum % sectors) + 1;
01296     h = (sectnum / sectors) % heads;
01297     c = (sectnum / sectors / heads);
01298     return Read_Sector(h,c,s,data);
01299 }
01300 
01301 imageDiskVFD::vfdentry *imageDiskVFD::findSector(Bit8u head,Bit8u track,Bit8u sector/*TODO: physical head?*/,unsigned int req_sector_size) {
01302     std::vector<imageDiskVFD::vfdentry>::iterator i = dents.begin();
01303     unsigned char szb=0xFF;
01304 
01305     if (req_sector_size == 0)
01306         req_sector_size = sector_size;
01307 
01308     if (req_sector_size != ~0U) {
01309         unsigned int c = req_sector_size;
01310         while (c >= 128U) {
01311             c >>= 1U;
01312             szb++;
01313         }
01314 
01315 //        LOG_MSG("req=%u c=%u szb=%u",req_sector_size,c,szb);
01316 
01317         if (szb > 8 || c != 64U)
01318             return NULL;
01319     }
01320 
01321     while (i != dents.end()) {
01322         imageDiskVFD::vfdentry &ent = *i;
01323 
01324         if (ent.head == head &&
01325             ent.track == track &&
01326             ent.sector == sector &&
01327             (ent.sizebyte == szb || req_sector_size == ~0U))
01328             return &(*i);
01329 
01330         i++;
01331     }
01332 
01333     return NULL;
01334 }
01335 
01336 Bit8u imageDiskVFD::Write_Sector(Bit32u head,Bit32u cylinder,Bit32u sector,const void * data,unsigned int req_sector_size) {
01337     unsigned long new_offset;
01338     unsigned char tmp[12];
01339     vfdentry *ent;
01340 
01341 //    LOG_MSG("VFD write sector: CHS %u/%u/%u",cylinder,head,sector);
01342 
01343     if (req_sector_size == 0)
01344         req_sector_size = sector_size;
01345 
01346     ent = findSector(head,cylinder,sector,req_sector_size);
01347     if (ent == NULL) return 0x05;
01348     if (ent->getSectorSize() != req_sector_size) return 0x05;
01349 
01350     if (ent->hasSectorData()) {
01351         fseek(diskimg,(long)ent->data_offset,SEEK_SET);
01352         if ((uint32_t)ftell(diskimg) != ent->data_offset) return 0x05;
01353         if (fwrite(data,req_sector_size,1,diskimg) != 1) return 0x05;
01354         return 0;
01355     }
01356     else if (ent->hasFill()) {
01357         bool isfill = false;
01358 
01359         /* well, is the data provided one character repeated?
01360          * note the format cannot represent a fill byte of 0xFF */
01361         if (((unsigned char*)data)[0] != 0xFF) {
01362             unsigned int i=1;
01363 
01364             do {
01365                 if (((unsigned char*)data)[i] == ((unsigned char*)data)[0]) {
01366                     if ((++i) == req_sector_size) {
01367                         isfill = true;
01368                         break; // yes!
01369                     }
01370                 }
01371                 else {
01372                     break; // nope
01373                 }
01374             } while (1);
01375         }
01376 
01377         if (ent->entry_offset == 0) return 0x05;
01378 
01379         if (isfill) {
01380             fseek(diskimg,(long)ent->entry_offset,SEEK_SET);
01381             if ((uint32_t)ftell(diskimg) != ent->entry_offset) return 0x05;
01382             if (fread(tmp,12,1,diskimg) != 1) return 0x05;
01383 
01384             tmp[0x04] = ((unsigned char*)data)[0]; // change the fill byte
01385 
01386             LOG_MSG("VFD write: 'fill' sector changing fill byte to 0x%x",tmp[0x04]);
01387 
01388             fseek(diskimg,(long)ent->entry_offset,SEEK_SET);
01389             if ((uint32_t)ftell(diskimg) != ent->entry_offset) return 0x05;
01390             if (fwrite(tmp,12,1,diskimg) != 1) return 0x05;
01391         }
01392         else {
01393             fseek(diskimg,0,SEEK_END);
01394             new_offset = (unsigned long)ftell(diskimg);
01395 
01396             /* we have to change it from a fill sector to an actual sector */
01397             LOG_MSG("VFD write: changing 'fill' sector to one with data (data at %lu)",(unsigned long)new_offset);
01398 
01399             fseek(diskimg,(long)ent->entry_offset,SEEK_SET);
01400             if ((uint32_t)ftell(diskimg) != ent->entry_offset) return 0x05;
01401             if (fread(tmp,12,1,diskimg) != 1) return 0x05;
01402 
01403             tmp[0x00] = ent->track;
01404             tmp[0x01] = ent->head;
01405             tmp[0x02] = ent->sector;
01406             tmp[0x03] = ent->sizebyte;
01407             tmp[0x04] = 0xFF; // no longer a fill byte
01408             tmp[0x05] = 0x00; // TODO ??
01409             tmp[0x06] = 0x00; // TODO ??
01410             tmp[0x07] = 0x00; // TODO ??
01411             *((uint32_t*)(tmp+8)) = new_offset;
01412             ent->fillbyte = 0xFF;
01413             ent->data_offset = (uint32_t)new_offset;
01414 
01415             fseek(diskimg,(long)ent->entry_offset,SEEK_SET);
01416             if ((uint32_t)ftell(diskimg) != ent->entry_offset) return 0x05;
01417             if (fwrite(tmp,12,1,diskimg) != 1) return 0x05;
01418 
01419             fseek(diskimg,(long)ent->data_offset,SEEK_SET);
01420             if ((uint32_t)ftell(diskimg) != ent->data_offset) return 0x05;
01421             if (fwrite(data,req_sector_size,1,diskimg) != 1) return 0x05;
01422         }
01423     }
01424 
01425     return 0x05;
01426 }
01427 
01428 Bit8u imageDiskVFD::Write_AbsoluteSector(Bit32u sectnum,const void *data) {
01429     unsigned int c,h,s;
01430 
01431     if (sectors == 0 || heads == 0)
01432         return 0x05;
01433 
01434     s = (sectnum % sectors) + 1;
01435     h = (sectnum / sectors) % heads;
01436     c = (sectnum / sectors / heads);
01437     return Write_Sector(h,c,s,data);
01438 }
01439 
01440 imageDiskVFD::imageDiskVFD(FILE *imgFile, Bit8u *imgName, Bit32u imgSizeK, bool isHardDisk) : imageDisk(ID_VFD) {
01441     (void)isHardDisk;//UNUSED
01442     unsigned char tmp[16];
01443 
01444     heads = 1;
01445     cylinders = 0;
01446     image_base = 0;
01447     sectors = 0;
01448     active = false;
01449     sector_size = 0;
01450     reserved_cylinders = 0;
01451     diskSizeK = imgSizeK;
01452     diskimg = imgFile;
01453 
01454     if (imgName != NULL)
01455         diskname = (const char*)imgName;
01456 
01457     // NOTES:
01458     // 
01459     //  +0x000: "VFD1.00"
01460     //  +0x0DC: array of 12-byte entries each describing a sector
01461     //
01462     //  Each entry:
01463     //  +0x0: track
01464     //  +0x1: head
01465     //  +0x2: sector
01466     //  +0x3: sector size (128 << this byte)
01467     //  +0x4: fill byte, or 0xFF
01468     //  +0x5: unknown
01469     //  +0x6: unknown
01470     //  +0x7: unknown
01471     //  +0x8: absolute data offset (32-bit integer) or 0xFFFFFFFF if the entire sector is that fill byte
01472     fseek(diskimg,0,SEEK_SET);
01473     memset(tmp,0,8);
01474     size_t readResult = fread(tmp,1,8,diskimg);
01475     if (readResult != 8) {
01476             LOG(LOG_IO, LOG_ERROR) ("Reading error in imageDiskVFD constructor\n");
01477             return;
01478     }
01479 
01480     if (!memcmp(tmp,"VFD1.",5)) {
01481         Bit8u i=0;
01482         bool founddisk = false;
01483         uint32_t stop_at = 0xC3FC;
01484         unsigned long entof;
01485 
01486         // load table.
01487         // we have to determine as we go where to stop reading.
01488         // the source of info I read assumes the whole header (and table)
01489         // is 0xC3FC bytes. I'm not inclined to assume that, so we go by
01490         // that OR the first sector offset whichever is smaller.
01491         // the table seems to trail off into a long series of 0xFF at the end.
01492         fseek(diskimg,0xDC,SEEK_SET);
01493         while ((entof=((unsigned long)ftell(diskimg)+12ul)) <= stop_at) {
01494             memset(tmp,0xFF,12);
01495             readResult = fread(tmp,12,1,diskimg);
01496             if (readResult != 1) {
01497                 LOG(LOG_IO, LOG_ERROR) ("Reading error in imageDiskVFD constructor\n");
01498                 return;
01499             }
01500 
01501             if (!memcmp(tmp,"\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF",12))
01502                 continue;
01503             if (!memcmp(tmp,"\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00",12))
01504                 continue;
01505 
01506             struct vfdentry v;
01507 
01508             v.track = tmp[0];
01509             v.head = tmp[1];
01510             v.sector = tmp[2];
01511             v.sizebyte = tmp[3];
01512             v.fillbyte = tmp[4];
01513             v.data_offset = *((uint32_t*)(tmp+8));
01514             v.entry_offset = (uint32_t)entof;
01515 
01516             // maybe the table can end sooner than 0xC3FC?
01517             // if we see sectors appear at an offset lower than our stop_at point
01518             // then adjust the stop_at point. assume the table cannot mix with
01519             // sector data.
01520             if (v.hasSectorData()) {
01521                 if (stop_at > v.data_offset)
01522                     stop_at = v.data_offset;
01523             }
01524 
01525             dents.push_back(v);
01526 
01527             LOG_MSG("VFD entry: track=%u head=%u sector=%u size=%u fill=0x%2X has_data=%u has_fill=%u entoff=%lu dataoff=%lu",
01528                 v.track,
01529                 v.head,
01530                 v.sector,
01531                 v.getSectorSize(),
01532                 v.fillbyte,
01533                 v.hasSectorData(),
01534                 v.hasFill(),
01535                 (unsigned long)v.entry_offset,
01536                 (unsigned long)v.data_offset);
01537         }
01538 
01539         if (!dents.empty()) {
01540             /* okay, now to figure out what the geometry of the disk is.
01541              * we cannot just work from an "absolute" disk image model
01542              * because there's no VFD header to just say what the geometry is.
01543              * Like the IBM PC BIOS, we have to look at the disk and figure out
01544              * which geometry to apply to it, even if the FDD format allows
01545              * sectors on other tracks to have wild out of range sector, track,
01546              * and head numbers or odd sized sectors.
01547              *
01548              * First, determine sector size according to the boot sector. */
01549             vfdentry *ent;
01550 
01551             ent = findSector(/*head*/0,/*track*/0,/*sector*/1,~0U);
01552             if (ent != NULL) {
01553                 if (ent->sizebyte <= 3) /* x <= 1024 */
01554                     sector_size = ent->getSectorSize();
01555             }
01556 
01557             /* oh yeah right, sure.
01558              * I suppose you're one of those FDD images where the sector size is 128 bytes/sector
01559              * in the boot sector and the rest is 256 bytes/sector elsewhere. I have no idea why
01560              * but quite a few FDD images have this arrangement. */
01561             if (sector_size != 0 && sector_size < 512) {
01562                 ent = findSector(/*head*/0,/*track*/1,/*sector*/1,~0U);
01563                 if (ent != NULL) {
01564                     if (ent->sizebyte <= 3) { /* x <= 1024 */
01565                         unsigned int nsz = ent->getSectorSize();
01566                         if (sector_size != nsz)
01567                             LOG_MSG("VFD warning: sector size changes between track 0 and 1");
01568                         if (sector_size < nsz)
01569                             sector_size = nsz;
01570                     }
01571                 }
01572             }
01573 
01574             if (sector_size != 0) {
01575                 i=0;
01576                 while (DiskGeometryList[i].ksize != 0) {
01577                     diskGeo &diskent = DiskGeometryList[i];
01578 
01579                     if (diskent.bytespersect == sector_size) {
01580                         ent = findSector(0,0,diskent.secttrack);
01581                         if (ent != NULL) {
01582                             LOG_MSG("VFD disk probe: %u/%u/%u exists",0,0,diskent.secttrack);
01583                             if (sectors < diskent.secttrack)
01584                                 sectors = diskent.secttrack;
01585                         }
01586                     }
01587 
01588                     i++;
01589                 }
01590             }
01591 
01592             if (sector_size != 0 && sectors != 0) {
01593                 i=0;
01594                 while (DiskGeometryList[i].ksize != 0) {
01595                     diskGeo &diskent = DiskGeometryList[i];
01596 
01597                     if (diskent.bytespersect == sector_size && diskent.secttrack >= sectors) {
01598                         ent = findSector(0,diskent.cylcount-1,sectors);
01599                         if (ent != NULL) {
01600                             LOG_MSG("VFD disk probe: %u/%u/%u exists",0,diskent.cylcount-1,sectors);
01601                             if (cylinders < diskent.cylcount)
01602                                 cylinders = diskent.cylcount;
01603                         }
01604                     }
01605 
01606                     i++;
01607                 }
01608             }
01609 
01610             if (sector_size != 0 && sectors != 0 && cylinders != 0) {
01611                 ent = findSector(1,0,sectors);
01612                 if (ent != NULL) {
01613                     LOG_MSG("VFD disk probe: %u/%u/%u exists",1,0,sectors);
01614                     heads = 2;
01615                 }
01616             }
01617 
01618             // TODO: drive_fat.cpp should use an extension to this API to allow changing the sectors/track
01619             //       according to what it reads from the MS-DOS BIOS parameter block, just like real MS-DOS.
01620             //       This would allow better representation of strange disk formats such as the "extended"
01621             //       floppy format that Microsoft used to use for Word 95 and Windows 95 install floppies.
01622 
01623             LOG_MSG("VFD geometry detection: C/H/S %u/%u/%u %u bytes/sector",
01624                 cylinders, heads, sectors, sector_size);
01625 
01626             if (sector_size != 0 && sectors != 0 && cylinders != 0 && heads != 0)
01627                 founddisk = true;
01628 
01629             if(!founddisk) {
01630                 active = false;
01631             } else {
01632                 incrementFDD();
01633             }
01634         }
01635     }
01636 }
01637 
01638 imageDiskVFD::~imageDiskVFD() {
01639     if(diskimg != NULL) {
01640         fclose(diskimg);
01641         diskimg=NULL; 
01642     }
01643 }
01644 
01645 // D88 *.D88 floppy disk format support
01646 
01647 enum {
01648     D88_TRACKMAX        = 164,
01649     D88_HEADERSIZE      = 0x20 + (D88_TRACKMAX * 4)
01650 };
01651 
01652 #pragma pack(push,1)
01653 typedef struct D88HEAD {
01654     char            fd_name[17];                // +0x00 Disk Name
01655     unsigned char   reserved1[9];               // +0x11 Reserved
01656     unsigned char   protect;                    // +0x1A Write Protect bit:4
01657     unsigned char   fd_type;                    // +0x1B Disk Format
01658     uint32_t        fd_size;                    // +0x1C Disk Size
01659     uint32_t        trackp[D88_TRACKMAX];       // +0x20 <array of DWORDs>     164 x 4 = 656 = 0x290
01660 } D88HEAD;                                      // =0x2B0 total
01661 
01662 typedef struct D88SEC {
01663     unsigned char   c;                          // +0x00
01664     unsigned char   h;                          // +0x01
01665     unsigned char   r;                          // +0x02
01666     unsigned char   n;                          // +0x03
01667     uint16_t        sectors;                    // +0x04 Sector Count
01668     unsigned char   mfm_flg;                    // +0x06 sides
01669     unsigned char   del_flg;                    // +0x07 DELETED DATA
01670     unsigned char   stat;                       // +0x08 STATUS (FDC ret)
01671     unsigned char   seektime;                   // +0x09 Seek Time
01672     unsigned char   reserved[3];                // +0x0A Reserved
01673     unsigned char   rpm_flg;                    // +0x0D rpm          0:1.2  1:1.44
01674     uint16_t        size;                       // +0x0E Sector Size
01675                                                 // <sector contents follow>
01676 } D88SEC;                                       // =0x10 total
01677 #pragma pack(pop)
01678 
01679 Bit8u imageDiskD88::Read_Sector(Bit32u head,Bit32u cylinder,Bit32u sector,void * data,unsigned int req_sector_size) {
01680     vfdentry *ent;
01681 
01682     if (req_sector_size == 0)
01683         req_sector_size = sector_size;
01684 
01685 //    LOG_MSG("D88 read sector: CHS %u/%u/%u sz=%u",cylinder,head,sector,req_sector_size);
01686 
01687     ent = findSector(head,cylinder,sector,req_sector_size);
01688     if (ent == NULL) return 0x05;
01689     if (ent->getSectorSize() != req_sector_size) return 0x05;
01690 
01691     fseek(diskimg,(long)ent->data_offset,SEEK_SET);
01692     if ((uint32_t)ftell(diskimg) != ent->data_offset) return 0x05;
01693     if (fread(data,req_sector_size,1,diskimg) != 1) return 0x05;
01694     return 0;
01695 }
01696 
01697 Bit8u imageDiskD88::Read_AbsoluteSector(Bit32u sectnum, void * data) {
01698     unsigned int c,h,s;
01699 
01700     if (sectors == 0 || heads == 0)
01701         return 0x05;
01702 
01703     s = (sectnum % sectors) + 1;
01704     h = (sectnum / sectors) % heads;
01705     c = (sectnum / sectors / heads);
01706     return Read_Sector(h,c,s,data);
01707 }
01708 
01709 imageDiskD88::vfdentry *imageDiskD88::findSector(Bit8u head,Bit8u track,Bit8u sector/*TODO: physical head?*/,unsigned int req_sector_size) {
01710     if ((size_t)track >= dents.size())
01711         return NULL;
01712 
01713     std::vector<imageDiskD88::vfdentry>::iterator i = dents.begin();
01714 
01715     if (req_sector_size == 0)
01716         req_sector_size = sector_size;
01717 
01718     while (i != dents.end()) {
01719         imageDiskD88::vfdentry &ent = *i;
01720 
01721         if (ent.head == head &&
01722             ent.track == track &&
01723             ent.sector == sector &&
01724             (ent.sector_size == req_sector_size || req_sector_size == ~0U))
01725             return &(*i);
01726 
01727         i++;
01728     }
01729 
01730     return NULL;
01731 }
01732 
01733 Bit8u imageDiskD88::Write_Sector(Bit32u head,Bit32u cylinder,Bit32u sector,const void * data,unsigned int req_sector_size) {
01734     vfdentry *ent;
01735 
01736     if (req_sector_size == 0)
01737         req_sector_size = sector_size;
01738 
01739 //    LOG_MSG("D88 read sector: CHS %u/%u/%u sz=%u",cylinder,head,sector,req_sector_size);
01740 
01741     ent = findSector(head,cylinder,sector,req_sector_size);
01742     if (ent == NULL) return 0x05;
01743     if (ent->getSectorSize() != req_sector_size) return 0x05;
01744 
01745     fseek(diskimg,(long)ent->data_offset,SEEK_SET);
01746     if ((uint32_t)ftell(diskimg) != ent->data_offset) return 0x05;
01747     if (fwrite(data,req_sector_size,1,diskimg) != 1) return 0x05;
01748     return 0;
01749 }
01750 
01751 Bit8u imageDiskD88::Write_AbsoluteSector(Bit32u sectnum,const void *data) {
01752     unsigned int c,h,s;
01753 
01754     if (sectors == 0 || heads == 0)
01755         return 0x05;
01756 
01757     s = (sectnum % sectors) + 1;
01758     h = (sectnum / sectors) % heads;
01759     c = (sectnum / sectors / heads);
01760     return Write_Sector(h,c,s,data);
01761 }
01762 
01763 imageDiskD88::imageDiskD88(FILE *imgFile, Bit8u *imgName, Bit32u imgSizeK, bool isHardDisk) : imageDisk(ID_D88) {
01764     (void)isHardDisk;//UNUSED
01765     D88HEAD head;
01766 
01767     fd_type_major = DISKTYPE_2D;
01768     fd_type_minor = 0;
01769 
01770     assert(sizeof(D88HEAD) == 0x2B0);
01771     assert(sizeof(D88SEC) == 0x10);
01772 
01773     heads = 0;
01774     cylinders = 0;
01775     image_base = 0;
01776     sectors = 0;
01777     active = false;
01778     sector_size = 0;
01779     reserved_cylinders = 0;
01780     diskSizeK = imgSizeK;
01781     diskimg = imgFile;
01782     active = false;
01783 
01784     if (imgName != NULL)
01785         diskname = (const char*)imgName;
01786 
01787     // NOTES:
01788     // 
01789     //  +0x000: D88 header
01790     //  +0x020: Offset of D88 tracks, per track
01791     //  +0x2B0: <begin data>
01792     //
01793     // Track offsets are sequential, always
01794     //
01795     // Each track is an array of:
01796     //
01797     //  ENTRY:
01798     //   <D88 sector head>
01799     //   <sector contents>
01800     //
01801     // Array of ENTRY from offset until next track
01802     fseek(diskimg,0,SEEK_END);
01803     off_t fsz = ftell(diskimg);
01804 
01805     fseek(diskimg,0,SEEK_SET);
01806     if (fread(&head,sizeof(head),1,diskimg) != 1) return;
01807 
01808     // validate fd_size
01809     if ((uint32_t)host_readd((ConstHostPt)(&head.fd_size)) > (uint32_t)fsz) return;
01810 
01811     fd_type_major = head.fd_type >> 4U;
01812     fd_type_minor = head.fd_type & 0xFU;
01813 
01814     // validate that none of the track offsets extend past the file
01815     {
01816         for (unsigned int i=0;i < D88_TRACKMAX;i++) {
01817             uint32_t trackoff = host_readd((ConstHostPt)(&head.trackp[i]));
01818 
01819             if (trackoff == 0) continue;
01820 
01821             if ((trackoff + 16U) > (uint32_t)fsz) {
01822                 LOG_MSG("D88: track starts past end of file");
01823                 return;
01824             }
01825         }
01826     }
01827 
01828     // read each track
01829     for (unsigned int track=0;track < D88_TRACKMAX;track++) {
01830         uint32_t trackoff = host_readd((ConstHostPt)(&head.trackp[track]));
01831 
01832         if (trackoff != 0) {
01833             fseek(diskimg, (long)trackoff, SEEK_SET);
01834             if ((off_t)ftell(diskimg) != (off_t)trackoff) continue;
01835 
01836             D88SEC s;
01837             unsigned int count = 0;
01838 
01839             do {
01840                 if (fread(&s,sizeof(s),1,diskimg) != 1) break;
01841 
01842                 uint16_t sector_count = host_readw((ConstHostPt)(&s.sectors));
01843                 uint16_t sector_size = host_readw((ConstHostPt)(&s.size));
01844 
01845                 if (sector_count == 0U || sector_size < 128U) break;
01846                 if (sector_count > 128U || sector_size > 16384U) break;
01847                 if (s.n > 8U) s.n = 8U;
01848 
01849                 vfdentry vent;
01850                 vent.sector_size = 128 << s.n;
01851                 vent.data_offset = (uint32_t)ftell(diskimg);
01852                 vent.entry_offset = vent.data_offset - (uint32_t)16;
01853                 vent.track = s.c;
01854                 vent.head = s.h;
01855                 vent.sector = s.r;
01856 
01857                 LOG_MSG("D88: trackindex=%u C/H/S/sz=%u/%u/%u/%u data-at=0x%lx",
01858                     track,vent.track,vent.head,vent.sector,vent.sector_size,(unsigned long)vent.data_offset);
01859 
01860                 dents.push_back(vent);
01861                 if ((++count) >= sector_count) break;
01862 
01863                 fseek(diskimg, (long)sector_size, SEEK_CUR);
01864             } while (1);
01865         }
01866     }
01867 
01868     if (!dents.empty()) {
01869         /* okay, now to figure out what the geometry of the disk is.
01870          * we cannot just work from an "absolute" disk image model
01871          * because there's no D88 header to just say what the geometry is.
01872          * Like the IBM PC BIOS, we have to look at the disk and figure out
01873          * which geometry to apply to it, even if the FDD format allows
01874          * sectors on other tracks to have wild out of range sector, track,
01875          * and head numbers or odd sized sectors.
01876          *
01877          * First, determine sector size according to the boot sector. */
01878         bool founddisk = false;
01879         vfdentry *ent;
01880 
01881         ent = findSector(/*head*/0,/*track*/0,/*sector*/1,~0U);
01882         if (ent != NULL) {
01883             if (ent->getSectorSize() <= 1024) /* x <= 1024 */
01884                 sector_size = ent->getSectorSize();
01885         }
01886 
01887         /* oh yeah right, sure.
01888          * I suppose you're one of those FDD images where the sector size is 128 bytes/sector
01889          * in the boot sector and the rest is 256 bytes/sector elsewhere. I have no idea why
01890          * but quite a few FDD images have this arrangement. */
01891         if (sector_size != 0 && sector_size < 512) {
01892             ent = findSector(/*head*/0,/*track*/1,/*sector*/1,~0U);
01893             if (ent != NULL) {
01894                 if (ent->getSectorSize() <= 1024) { /* x <= 1024 */
01895                     unsigned int nsz = ent->getSectorSize();
01896                     if (sector_size != nsz)
01897                         LOG_MSG("D88 warning: sector size changes between track 0 and 1");
01898                     if (sector_size < nsz)
01899                         sector_size = nsz;
01900                 }
01901             }
01902         }
01903 
01904         if (sector_size != 0) {
01905             unsigned int i = 0;
01906             while (DiskGeometryList[i].ksize != 0) {
01907                 diskGeo &diskent = DiskGeometryList[i];
01908 
01909                 if (diskent.bytespersect == sector_size) {
01910                     ent = findSector(0,0,diskent.secttrack);
01911                     if (ent != NULL) {
01912                         LOG_MSG("D88 disk probe: %u/%u/%u exists",0,0,diskent.secttrack);
01913                         if (sectors < diskent.secttrack)
01914                             sectors = diskent.secttrack;
01915                     }
01916                 }
01917 
01918                 i++;
01919             }
01920         }
01921 
01922         if (sector_size != 0 && sectors != 0) {
01923             unsigned int i = 0;
01924             while (DiskGeometryList[i].ksize != 0) {
01925                 diskGeo &diskent = DiskGeometryList[i];
01926 
01927                 if (diskent.bytespersect == sector_size && diskent.secttrack >= sectors) {
01928                     ent = findSector(0,diskent.cylcount-1,sectors);
01929                     if (ent != NULL) {
01930                         LOG_MSG("D88 disk probe: %u/%u/%u exists",0,diskent.cylcount-1,sectors);
01931                         if (cylinders < diskent.cylcount)
01932                             cylinders = diskent.cylcount;
01933                     }
01934                 }
01935 
01936                 i++;
01937             }
01938         }
01939 
01940         if (sector_size != 0 && sectors != 0 && cylinders != 0) {
01941             ent = findSector(1,0,sectors);
01942             if (ent != NULL) {
01943                 LOG_MSG("D88 disk probe: %u/%u/%u exists",1,0,sectors);
01944                 heads = 2;
01945             }
01946         }
01947 
01948         // TODO: drive_fat.cpp should use an extension to this API to allow changing the sectors/track
01949         //       according to what it reads from the MS-DOS BIOS parameter block, just like real MS-DOS.
01950         //       This would allow better representation of strange disk formats such as the "extended"
01951         //       floppy format that Microsoft used to use for Word 95 and Windows 95 install floppies.
01952 
01953         LOG_MSG("D88 geometry detection: C/H/S %u/%u/%u %u bytes/sector",
01954                 cylinders, heads, sectors, sector_size);
01955 
01956         if (sector_size != 0 && sectors != 0 && cylinders != 0 && heads != 0)
01957             founddisk = true;
01958 
01959         if(!founddisk) {
01960             active = false;
01961         } else {
01962             incrementFDD();
01963         }
01964     }
01965 }
01966 
01967 imageDiskD88::~imageDiskD88() {
01968     if(diskimg != NULL) {
01969         fclose(diskimg);
01970         diskimg=NULL; 
01971     }
01972 }
01973 
01974 /*--------------------------------*/
01975 
01976 Bit8u imageDiskNFD::Read_Sector(Bit32u head,Bit32u cylinder,Bit32u sector,void * data,unsigned int req_sector_size) {
01977     vfdentry *ent;
01978 
01979     if (req_sector_size == 0)
01980         req_sector_size = sector_size;
01981 
01982 //    LOG_MSG("NFD read sector: CHS %u/%u/%u sz=%u",cylinder,head,sector,req_sector_size);
01983 
01984     ent = findSector(head,cylinder,sector,req_sector_size);
01985     if (ent == NULL) return 0x05;
01986     if (ent->getSectorSize() != req_sector_size) return 0x05;
01987 
01988     fseek(diskimg,(long)ent->data_offset,SEEK_SET);
01989     if ((uint32_t)ftell(diskimg) != ent->data_offset) return 0x05;
01990     if (fread(data,req_sector_size,1,diskimg) != 1) return 0x05;
01991     return 0;
01992 }
01993 
01994 Bit8u imageDiskNFD::Read_AbsoluteSector(Bit32u sectnum, void * data) {
01995     unsigned int c,h,s;
01996 
01997     if (sectors == 0 || heads == 0)
01998         return 0x05;
01999 
02000     s = (sectnum % sectors) + 1;
02001     h = (sectnum / sectors) % heads;
02002     c = (sectnum / sectors / heads);
02003     return Read_Sector(h,c,s,data);
02004 }
02005 
02006 imageDiskNFD::vfdentry *imageDiskNFD::findSector(Bit8u head,Bit8u track,Bit8u sector/*TODO: physical head?*/,unsigned int req_sector_size) {
02007     if ((size_t)track >= dents.size())
02008         return NULL;
02009 
02010     std::vector<imageDiskNFD::vfdentry>::iterator i = dents.begin();
02011 
02012     if (req_sector_size == 0)
02013         req_sector_size = sector_size;
02014 
02015     while (i != dents.end()) {
02016         imageDiskNFD::vfdentry &ent = *i;
02017 
02018         if (ent.head == head &&
02019             ent.track == track &&
02020             ent.sector == sector &&
02021             (ent.sector_size == req_sector_size || req_sector_size == ~0U))
02022             return &(*i);
02023 
02024         i++;
02025     }
02026 
02027     return NULL;
02028 }
02029 
02030 Bit8u imageDiskNFD::Write_Sector(Bit32u head,Bit32u cylinder,Bit32u sector,const void * data,unsigned int req_sector_size) {
02031     vfdentry *ent;
02032 
02033     if (req_sector_size == 0)
02034         req_sector_size = sector_size;
02035 
02036 //    LOG_MSG("NFD read sector: CHS %u/%u/%u sz=%u",cylinder,head,sector,req_sector_size);
02037 
02038     ent = findSector(head,cylinder,sector,req_sector_size);
02039     if (ent == NULL) return 0x05;
02040     if (ent->getSectorSize() != req_sector_size) return 0x05;
02041 
02042     fseek(diskimg,(long)ent->data_offset,SEEK_SET);
02043     if ((uint32_t)ftell(diskimg) != ent->data_offset) return 0x05;
02044     if (fwrite(data,req_sector_size,1,diskimg) != 1) return 0x05;
02045     return 0;
02046 }
02047 
02048 Bit8u imageDiskNFD::Write_AbsoluteSector(Bit32u sectnum,const void *data) {
02049     unsigned int c,h,s;
02050 
02051     if (sectors == 0 || heads == 0)
02052         return 0x05;
02053 
02054     s = (sectnum % sectors) + 1;
02055     h = (sectnum / sectors) % heads;
02056     c = (sectnum / sectors / heads);
02057     return Write_Sector(h,c,s,data);
02058 }
02059 
02060 imageDiskNFD::imageDiskNFD(FILE *imgFile, Bit8u *imgName, Bit32u imgSizeK, bool isHardDisk, unsigned int revision) : imageDisk(ID_NFD) {
02061     (void)isHardDisk;//UNUSED
02062     union {
02063         NFDHDR head;
02064         NFDHDRR1 headr1;
02065     }; // these occupy the same location of memory
02066 
02067     assert(sizeof(NFDHDR) == 0x120);
02068     assert(sizeof(NFDHDRR1) == 0x3C0);
02069     assert(sizeof(NFDHDR_ENTRY) == 0x10);
02070 
02071     heads = 0;
02072     cylinders = 0;
02073     image_base = 0;
02074     sectors = 0;
02075     active = false;
02076     sector_size = 0;
02077     reserved_cylinders = 0;
02078     diskSizeK = imgSizeK;
02079     diskimg = imgFile;
02080     active = false;
02081 
02082     if (imgName != NULL)
02083         diskname = (const char*)imgName;
02084 
02085     // NOTES:
02086     // 
02087     //  +0x000: NFD header
02088     //  +0x020: Offset of NFD tracks, per track
02089     //  +0x2B0: <begin data>
02090     //
02091     // Track offsets are sequential, always
02092     //
02093     // Each track is an array of:
02094     //
02095     //  ENTRY:
02096     //   <NFD sector head>
02097     //   <sector contents>
02098     //
02099     // Array of ENTRY from offset until next track
02100     fseek(diskimg,0,SEEK_END);
02101     off_t fsz = ftell(diskimg);
02102 
02103     fseek(diskimg,0,SEEK_SET);
02104     if (revision == 0) {
02105         if (fread(&head,sizeof(head),1,diskimg) != 1) return;
02106     }
02107     else if (revision == 1) {
02108         if (fread(&headr1,sizeof(headr1),1,diskimg) != 1) return;
02109     }
02110     else {
02111         abort();
02112     }
02113 
02114     // validate fd_size
02115     if ((uint32_t)host_readd((ConstHostPt)(&head.headersize)) < sizeof(head)) return;
02116     if ((uint32_t)host_readd((ConstHostPt)(&head.headersize)) > (uint32_t)fsz) return;
02117 
02118     unsigned int data_offset = host_readd((ConstHostPt)(&head.headersize));
02119 
02120     std::vector< std::pair<uint32_t,NFDHDR_ENTRY> > seclist;
02121 
02122     if (revision == 0) {
02123         unsigned int secents = (host_readd((ConstHostPt)(&head.headersize)) - sizeof(head)) / sizeof(NFDHDR_ENTRY);
02124         if (secents == 0) return;
02125         secents--;
02126         if (secents == 0) return;
02127 
02128         for (unsigned int i=0;i < secents;i++) {
02129             uint32_t ofs = (uint32_t)ftell(diskimg);
02130             NFDHDR_ENTRY e;
02131 
02132             if (fread(&e,sizeof(e),1,diskimg) != 1) return;
02133             seclist.push_back( std::pair<uint32_t,NFDHDR_ENTRY>(ofs,e) );
02134 
02135             if (e.log_cyl == 0xFF || e.log_head == 0xFF || e.log_rec == 0xFF || e.sec_len_pow2 > 7)
02136                 continue;
02137 
02138             LOG_MSG("NFD %u/%u: ofs=%lu data=%lu cyl=%u head=%u sec=%u len=%u",
02139                     (unsigned int)i,
02140                     (unsigned int)secents,
02141                     (unsigned long)ofs,
02142                     (unsigned long)data_offset,
02143                     e.log_cyl,
02144                     e.log_head,
02145                     e.log_rec,
02146                     128 << e.sec_len_pow2);
02147 
02148             vfdentry vent;
02149             vent.sector_size = 128 << e.sec_len_pow2;
02150             vent.data_offset = (uint32_t)data_offset;
02151             vent.entry_offset = (uint32_t)ofs;
02152             vent.track = e.log_cyl;
02153             vent.head = e.log_head;
02154             vent.sector = e.log_rec;
02155             dents.push_back(vent);
02156 
02157             data_offset += 128u << e.sec_len_pow2;
02158             if (data_offset > (unsigned int)fsz) return;
02159         }
02160     }
02161     else {
02162         /* R1 has an array of offsets to where each tracks begins.
02163          * The end of the track is an entry like 0x1A 0x00 0x00 0x00 0x00 0x00 0x00 .... */
02164         /* The R1 images I have as reference always have offsets in ascending order. */
02165         for (unsigned int ti=0;ti < 164;ti++) {
02166             uint32_t trkoff = host_readd((ConstHostPt)(&headr1.trackheads[ti]));
02167 
02168             if (trkoff == 0) break;
02169 
02170             fseek(diskimg,(long)trkoff,SEEK_SET);
02171             if ((off_t)ftell(diskimg) != (off_t)trkoff) return;
02172 
02173             NFDHDR_ENTRY e;
02174 
02175             // track id
02176             if (fread(&e,sizeof(e),1,diskimg) != 1) return;
02177             unsigned int sectors = host_readw((ConstHostPt)(&e) + 0);
02178             unsigned int diagcount = host_readw((ConstHostPt)(&e) + 2);
02179 
02180             LOG_MSG("NFD R1 track ent %u offset %lu sectors %u diag %u",ti,(unsigned long)trkoff,sectors,diagcount);
02181 
02182             for (unsigned int s=0;s < sectors;s++) {
02183                 uint32_t ofs = (uint32_t)ftell(diskimg);
02184 
02185                 if (fread(&e,sizeof(e),1,diskimg) != 1) return;
02186 
02187                 LOG_MSG("NFD %u/%u: ofs=%lu data=%lu cyl=%u head=%u sec=%u len=%u rep=%u",
02188                         (unsigned int)s,
02189                         (unsigned int)sectors,
02190                         (unsigned long)ofs,
02191                         (unsigned long)data_offset,
02192                         e.log_cyl,
02193                         e.log_head,
02194                         e.log_rec,
02195                         128 << e.sec_len_pow2,
02196                         e.byRetry);
02197 
02198                 vfdentry vent;
02199                 vent.sector_size = 128 << e.sec_len_pow2;
02200                 vent.data_offset = (uint32_t)data_offset;
02201                 vent.entry_offset = (uint32_t)ofs;
02202                 vent.track = e.log_cyl;
02203                 vent.head = e.log_head;
02204                 vent.sector = e.log_rec;
02205                 dents.push_back(vent);
02206 
02207                 data_offset += 128u << e.sec_len_pow2;
02208                 if (data_offset > (unsigned int)fsz) return;
02209             }
02210 
02211             for (unsigned int d=0;d < diagcount;d++) {
02212                 if (fread(&e,sizeof(e),1,diskimg) != 1) return;
02213 
02214                 unsigned int retry = e.byRetry;
02215                 unsigned int len = host_readd((ConstHostPt)(&e) + 10);
02216 
02217                 LOG_MSG("NFD diag %u/%u: retry=%u len=%u data=%lu",d,diagcount,retry,len,(unsigned long)data_offset);
02218 
02219                 data_offset += (1+retry) * len;
02220             }
02221         }
02222     }
02223 
02224     if (!dents.empty()) {
02225         /* okay, now to figure out what the geometry of the disk is.
02226          * we cannot just work from an "absolute" disk image model
02227          * because there's no NFD header to just say what the geometry is.
02228          * Like the IBM PC BIOS, we have to look at the disk and figure out
02229          * which geometry to apply to it, even if the FDD format allows
02230          * sectors on other tracks to have wild out of range sector, track,
02231          * and head numbers or odd sized sectors.
02232          *
02233          * First, determine sector size according to the boot sector. */
02234         bool founddisk = false;
02235         vfdentry *ent;
02236 
02237         ent = findSector(/*head*/0,/*track*/0,/*sector*/1,~0U);
02238         if (ent != NULL) {
02239             if (ent->getSectorSize() <= 1024) /* x <= 1024 */
02240                 sector_size = ent->getSectorSize();
02241         }
02242 
02243         /* oh yeah right, sure.
02244          * I suppose you're one of those FDD images where the sector size is 128 bytes/sector
02245          * in the boot sector and the rest is 256 bytes/sector elsewhere. I have no idea why
02246          * but quite a few FDD images have this arrangement. */
02247         if (sector_size != 0 && sector_size < 512) {
02248             ent = findSector(/*head*/0,/*track*/1,/*sector*/1,~0U);
02249             if (ent != NULL) {
02250                 if (ent->getSectorSize() <= 1024) { /* x <= 1024 */
02251                     unsigned int nsz = ent->getSectorSize();
02252                     if (sector_size != nsz)
02253                         LOG_MSG("NFD warning: sector size changes between track 0 and 1");
02254                     if (sector_size < nsz)
02255                         sector_size = nsz;
02256                 }
02257             }
02258         }
02259 
02260         if (sector_size != 0) {
02261             unsigned int i = 0;
02262             while (DiskGeometryList[i].ksize != 0) {
02263                 diskGeo &diskent = DiskGeometryList[i];
02264 
02265                 if (diskent.bytespersect == sector_size) {
02266                     ent = findSector(0,0,diskent.secttrack);
02267                     if (ent != NULL) {
02268                         LOG_MSG("NFD disk probe: %u/%u/%u exists",0,0,diskent.secttrack);
02269                         if (sectors < diskent.secttrack)
02270                             sectors = diskent.secttrack;
02271                     }
02272                 }
02273 
02274                 i++;
02275             }
02276         }
02277 
02278         if (sector_size != 0 && sectors != 0) {
02279             unsigned int i = 0;
02280             while (DiskGeometryList[i].ksize != 0) {
02281                 diskGeo &diskent = DiskGeometryList[i];
02282 
02283                 if (diskent.bytespersect == sector_size && diskent.secttrack >= sectors) {
02284                     ent = findSector(0,diskent.cylcount-1,sectors);
02285                     if (ent != NULL) {
02286                         LOG_MSG("NFD disk probe: %u/%u/%u exists",0,diskent.cylcount-1,sectors);
02287                         if (cylinders < diskent.cylcount)
02288                             cylinders = diskent.cylcount;
02289                     }
02290                 }
02291 
02292                 i++;
02293             }
02294         }
02295 
02296         if (sector_size != 0 && sectors != 0 && cylinders != 0) {
02297             ent = findSector(1,0,sectors);
02298             if (ent != NULL) {
02299                 LOG_MSG("NFD disk probe: %u/%u/%u exists",1,0,sectors);
02300                 heads = 2;
02301             }
02302         }
02303 
02304         // TODO: drive_fat.cpp should use an extension to this API to allow changing the sectors/track
02305         //       according to what it reads from the MS-DOS BIOS parameter block, just like real MS-DOS.
02306         //       This would allow better representation of strange disk formats such as the "extended"
02307         //       floppy format that Microsoft used to use for Word 95 and Windows 95 install floppies.
02308 
02309         LOG_MSG("NFD geometry detection: C/H/S %u/%u/%u %u bytes/sector",
02310                 cylinders, heads, sectors, sector_size);
02311 
02312         if (sector_size != 0 && sectors != 0 && cylinders != 0 && heads != 0)
02313             founddisk = true;
02314 
02315         if(!founddisk) {
02316             active = false;
02317         } else {
02318             incrementFDD();
02319         }
02320     }
02321 }
02322 
02323 imageDiskNFD::~imageDiskNFD() {
02324     if(diskimg != NULL) {
02325         fclose(diskimg);
02326         diskimg=NULL; 
02327     }
02328 }
02329 
Generated on Tue Oct 1 2019 18:06:28 for DOSBox-X by   doxygen 1.8.0