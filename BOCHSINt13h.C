#define SET_DISK_RET_STATUS(status) write_byte(status, 0x0074, 0x0040)

#if BX_USE_ATADRV

  int
int13_edd(DS, SI, device)
  Bit16u DS, SI;
  Bit8u device;
{
  Bit32u lba_low, lba_high;
  Bit16u npc, nph, npspt, size, t13;
  Bit16u ebda_seg=read_word(0x000E,0x0040);

  //
  // DS has been set to EBDA segment before call
  //

  Bit8u type=read_byte_DS(&EbdaData->ata.devices[device].type);

  size=read_word(SI+(Bit16u)&Int13DPT->size,DS);
  t13 = size == 74;

  // Buffer is too small
  if(size < 26)
    return 1;

  // EDD 1.x
  if(size >= 26) {
    Bit16u   blksize, infos;

    write_word(26, SI+(Bit16u)&Int13DPT->size, DS);

    blksize = read_word_DS(&EbdaData->ata.devices[device].blksize);

    if (type == ATA_TYPE_ATA)
    {
      npc     = read_word_DS(&EbdaData->ata.devices[device].pchs.cylinders);
      nph     = read_word_DS(&EbdaData->ata.devices[device].pchs.heads);
      npspt   = read_word_DS(&EbdaData->ata.devices[device].pchs.spt);
      lba_low = read_dword_DS(&EbdaData->ata.devices[device].sectors_low);
      lba_high = read_dword_DS(&EbdaData->ata.devices[device].sectors_high);

      if (lba_high || (lba_low/npspt)/nph > 0x3fff)
      {
        infos = 0 << 1; // geometry is invalid
        npc = 0x3fff;
      }
      else
      {
        infos = 1 << 1; // geometry is valid
      }
    }

    if (type == ATA_TYPE_ATAPI)
    {
      npc     = 0xffffffff;
      nph     = 0xffffffff;
      npspt   = 0xffffffff;
      lba_low = 0xffffffff;
      lba_high = 0xffffffff;

      infos =  1 << 2 /* removable */ | 1 << 4 /* media change */ |
               1 << 5 /* lockable */ | 1 << 6; /* max values */
    }

    write_word(infos, SI+(Bit16u)&Int13DPT->infos, DS);
    write_dword((Bit32u)npc, SI+(Bit16u)&Int13DPT->cylinders, DS);
    write_dword((Bit32u)nph, SI+(Bit16u)&Int13DPT->heads, DS);
    write_dword((Bit32u)npspt, SI+(Bit16u)&Int13DPT->spt, DS);
    write_dword(lba_low, SI+(Bit16u)&Int13DPT->sector_count1, DS);
    write_dword(lba_high, SI+(Bit16u)&Int13DPT->sector_count2, DS);
    write_word(blksize, SI+(Bit16u)&Int13DPT->blksize, DS);
  }

  // EDD 2.x
  if(size >= 30) {
    Bit8u  channel, dev, irq, mode, checksum, i, translation;
    Bit16u iobase1, iobase2, options;

    write_word(30, SI+(Bit16u)&Int13DPT->size, DS);

    write_word(ebda_seg, SI+(Bit16u)&Int13DPT->dpte_segment, DS);
    write_word(&EbdaData->ata.dpte, SI+(Bit16u)&Int13DPT->dpte_offset, DS);

    // Fill in dpte
    channel = device / 2;
    iobase1 = read_word_DS(&EbdaData->ata.channels[channel].iobase1);
    iobase2 = read_word_DS(&EbdaData->ata.channels[channel].iobase2);
    irq = read_byte_DS(&EbdaData->ata.channels[channel].irq);
    mode = read_byte_DS(&EbdaData->ata.devices[device].mode);
    translation = read_byte_DS(&EbdaData->ata.devices[device].translation);

    options = (1<<4); // lba translation
    options |= (mode==ATA_MODE_PIO32?1:0)<<7;

    if (type == ATA_TYPE_ATA)
    {
      options |= (translation==ATA_TRANSLATION_NONE?0:1)<<3; // chs translation
      options |= (translation==ATA_TRANSLATION_LBA?1:0)<<9;
      options |= (translation==ATA_TRANSLATION_RECHS?3:0)<<9;
    }

    if (type == ATA_TYPE_ATAPI)
    {
      options |= (1<<5); // removable device
      options |= (1<<6); // atapi device
    }

    write_word_DS(&EbdaData->ata.dpte.iobase1, iobase1);
    write_word_DS(&EbdaData->ata.dpte.iobase2, iobase2 + ATA_CB_DC);
    write_byte_DS(&EbdaData->ata.dpte.prefix, (0xe | (device % 2))<<4 );
    write_byte_DS(&EbdaData->ata.dpte.unused, 0xcb );
    write_byte_DS(&EbdaData->ata.dpte.irq, irq );
    write_byte_DS(&EbdaData->ata.dpte.blkcount, 1 );
    write_byte_DS(&EbdaData->ata.dpte.dma, 0 );
    write_byte_DS(&EbdaData->ata.dpte.pio, 0 );
    write_word_DS(&EbdaData->ata.dpte.options, options);
    write_word_DS(&EbdaData->ata.dpte.reserved, 0);
    write_byte_DS(&EbdaData->ata.dpte.revision, 0x11);

    checksum=0;
    for (i=0; i<15; i++) checksum+=read_byte_DS(((Bit8u*)(&EbdaData->ata.dpte)) + i);
    checksum = -checksum;
    write_byte_DS(&EbdaData->ata.dpte.checksum, checksum);
  }

  // EDD 3.x
  if(size >= 66) {
    Bit8u channel, iface, checksum, i;
    Bit16u iobase1;

    channel = device / 2;
    iface = read_byte_DS(&EbdaData->ata.channels[channel].iface);
    iobase1 = read_word_DS(&EbdaData->ata.channels[channel].iobase1);

    // Set DS to original DS register value
    set_DS(DS);
    write_word_DS(SI+(Bit16u)&Int13DPT->dpi.t13.key, 0xbedd);
    write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.dpi_length, t13 ? 44 : 36);
    write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.reserved1, 0);
    write_word_DS(SI+(Bit16u)&Int13DPT->dpi.t13.reserved2, 0);

    if (iface==ATA_IFACE_ISA) {
      write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.host_bus[0], 'I');
      write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.host_bus[1], 'S');
      write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.host_bus[2], 'A');
      write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.host_bus[3], ' ');
    }
    else {
      // FIXME PCI
    }

    if (type == ATA_TYPE_ATA) {
        write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_type[0], 'A');
        write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_type[1], 'T');
        write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_type[2], 'A');
        write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_type[3], ' ');
        write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_type[4], ' ');
        write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_type[5], ' ');
        write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_type[6], ' ');
        write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_type[7], ' ');
    } else if (type == ATA_TYPE_ATAPI) {
        write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_type[0], 'A');
        write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_type[1], 'T');
        write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_type[2], 'A');
        write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_type[3], 'P');
        write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_type[4], 'I');
        write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_type[5], ' ');
        write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_type[6], ' ');
        write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_type[7], ' ');
    }

    if (iface==ATA_IFACE_ISA) {
      write_word_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_path[0], iobase1);
      write_word_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_path[2], 0);
      write_dword_DS(SI+(Bit16u)&Int13DPT->dpi.t13.iface_path[4], 0L);
    }
    else {
      // FIXME PCI
    }
    write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.device_path[0], device%2);
    write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.device_path[1], 0);
    write_word_DS(SI+(Bit16u)&Int13DPT->dpi.t13.device_path[2], 0);
    write_dword_DS(SI+(Bit16u)&Int13DPT->dpi.t13.device_path[4], 0L);
    if (t13) {
      write_dword_DS(SI+(Bit16u)&Int13DPT->dpi.t13.device_path[8], 0L);
      write_dword_DS(SI+(Bit16u)&Int13DPT->dpi.t13.device_path[12], 0L);
    }

    if (t13)
      write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.reserved3, 0);
    else
      write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.phoenix.reserved3, 0);

    checksum = 0;
    for (i = 30; i < (t13 ? 73 : 65); i++) checksum += read_byte_DS(SI + i);
    checksum = -checksum;
    if (t13)
      write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.t13.checksum, checksum);
    else
      write_byte_DS(SI+(Bit16u)&Int13DPT->dpi.phoenix.checksum, checksum);
  }

  return 0;
}

  void
int13_harddisk(EHAX, DS, ES, DI, SI, BP, ELDX, BX, DX, CX, AX, IP, CS, FLAGS)
  Bit16u EHAX, DS, ES, DI, SI, BP, ELDX, BX, DX, CX, AX, IP, CS, FLAGS;
{
  Bit32u lba_low, lba_high;
  Bit16u cylinder, head, sector;
  Bit16u segment, offset;
  Bit16u npc, nph, npspt, nlc, nlh, nlspt;
  Bit16u size, count;
  Bit8u  device, status;

  //
  // DS has been set to EBDA segment before call
  //

  BX_DEBUG_INT13_HD("int13_harddisk: AX=%04x BX=%04x CX=%04x DX=%04x ES=%04x\n", AX, BX, CX, DX, ES);

  write_byte(0, 0x008e, 0x0040);  // clear completion flag

  // basic check : device has to be defined
  if ( (GET_ELDL() < 0x80) || (GET_ELDL() >= 0x80 + BX_MAX_ATA_DEVICES) ) {
    BX_INFO("int13_harddisk: function %02x, ELDL out of range %02x\n", GET_AH(), GET_ELDL());
    goto int13_fail;
  }

  // Get the ata channel
  device=read_byte_DS(&EbdaData->ata.hdidmap[GET_ELDL()-0x80]);

  // basic check : device has to be valid
  if (device >= BX_MAX_ATA_DEVICES) {
    BX_INFO("int13_harddisk: function %02x, unmapped device for ELDL=%02x\n", GET_AH(), GET_ELDL());
    goto int13_fail;
  }

  switch (GET_AH()) {

    case 0x00: /* disk controller reset */
      ata_reset (device);
      goto int13_success;
      break;

    case 0x01: /* read disk status */
      status = read_byte(0x0074, 0x0040);
      SET_AH(status);
      SET_DISK_RET_STATUS(0);
      /* set CF if error status read */
      if (status) goto int13_fail_nostatus;
      else        goto int13_success_noah;
      break;

    case 0x02: // read disk sectors
    case 0x03: // write disk sectors
    case 0x04: // verify disk sectors

      count       = GET_AL();
      cylinder    = GET_CH();
      cylinder   |= ( ((Bit16u) GET_CL()) << 2) & 0x300;
      sector      = (GET_CL() & 0x3f);
      head        = GET_DH();

      segment = ES;
      offset  = BX;

      if ((count > 128) || (count == 0) || (sector == 0)) {
        BX_INFO("int13_harddisk: function %02x, parameter out of range!\n",GET_AH());
        goto int13_fail;
      }

      nlc   = read_word_DS(&EbdaData->ata.devices[device].lchs.cylinders);
      nlh   = read_word_DS(&EbdaData->ata.devices[device].lchs.heads);
      nlspt = read_word_DS(&EbdaData->ata.devices[device].lchs.spt);

      // sanity check on cyl heads, sec
      if( (cylinder >= nlc) || (head >= nlh) || (sector > nlspt) ) {
        BX_INFO("int13_harddisk: function %02x, parameters out of range %04x/%04x/%04x!\n", GET_AH(), cylinder, head, sector);
        goto int13_fail;
      }

      // FIXME verify
      if (GET_AH() == 0x04) goto int13_success;

      nph   = read_word_DS(&EbdaData->ata.devices[device].pchs.heads);
      npspt = read_word_DS(&EbdaData->ata.devices[device].pchs.spt);

      // if needed, translate lchs to lba, and execute command
      if ( (nph != nlh) || (npspt != nlspt)) {
        lba_low = ((((Bit32u)cylinder * (Bit32u)nlh) + (Bit32u)head) * (Bit32u)nlspt) + (Bit32u)sector - 1;
        lba_high = 0;
        sector = 0; // this forces the command to be lba
      }

      if (GET_AH() == 0x02)
        status=ata_cmd_data_io(0, device, ATA_CMD_READ_SECTORS, count, cylinder, head, sector, lba_low, lba_high, segment, offset);
      else
        status=ata_cmd_data_io(1, device, ATA_CMD_WRITE_SECTORS, count, cylinder, head, sector, lba_low, lba_high, segment, offset);

      // Set nb of sector transferred
      SET_AL(read_word_DS(&EbdaData->ata.trsfsectors));

      if (status != 0) {
        BX_INFO("int13_harddisk: function %02x, error %02x !\n",GET_AH(),status);
        SET_AH(0x0c);
        goto int13_fail_noah;
      }

      goto int13_success;
      break;

    case 0x05: /* format disk track */
      BX_INFO("format disk track called\n");
      goto int13_success;
      return;
      break;

    case 0x08: /* read disk drive parameters */

      // Get logical geometry from table
      nlc   = read_word_DS(&EbdaData->ata.devices[device].lchs.cylinders);
      nlh   = read_word_DS(&EbdaData->ata.devices[device].lchs.heads);
      nlspt = read_word_DS(&EbdaData->ata.devices[device].lchs.spt);
      count = read_byte_DS(&EbdaData->ata.hdcount);

      nlc = nlc - 1; /* 0 based */
      SET_AL(0);
      SET_CH(nlc & 0xff);
      SET_CL(((nlc >> 2) & 0xc0) | (nlspt & 0x3f));
      SET_DH(nlh - 1);
      SET_DL(count); /* FIXME returns 0, 1, or n hard drives */

      // FIXME should set ES & DI

      goto int13_success;
      break;

    case 0x10: /* check drive ready */
      // should look at 40:8E also???

      // Read the status from controller
      status = inb(read_word_DS(&EbdaData->ata.channels[device/2].iobase1) + ATA_CB_STAT);
      if ( (status & (ATA_CB_STAT_BSY | ATA_CB_STAT_RDY)) == ATA_CB_STAT_RDY ) {
        goto int13_success;
      }
      else {
        SET_AH(0xAA);
        goto int13_fail_noah;
      }
      break;

    case 0x15: /* read disk drive size */

      // Get logical geometry from table
      nlc   = read_word_DS(&EbdaData->ata.devices[device].lchs.cylinders);
      nlh   = read_word_DS(&EbdaData->ata.devices[device].lchs.heads);
      nlspt = read_word_DS(&EbdaData->ata.devices[device].lchs.spt);

      // Compute sector count seen by int13
      lba_low = (Bit32u)(nlc - 1) * (Bit32u)nlh * (Bit32u)nlspt;
      CX = lba_low >> 16;
      DX = lba_low & 0xffff;

      SET_AH(3);  // hard disk accessible
      goto int13_success_noah;
      break;

    case 0x41: // IBM/MS installation check
      BX=0xaa55;     // install check
      SET_AH(0x30);  // EDD 3.0
      CX=0x0007;     // ext disk access and edd, removable supported
      goto int13_success_noah;
      break;

    case 0x42: // IBM/MS extended read
    case 0x43: // IBM/MS extended write
    case 0x44: // IBM/MS verify
    case 0x47: // IBM/MS extended seek

      count=read_word(SI+(Bit16u)&Int13Ext->count, DS);
      segment=read_word(SI+(Bit16u)&Int13Ext->segment, DS);
      offset=read_word(SI+(Bit16u)&Int13Ext->offset, DS);

      // Get 32 msb lba and check
      lba_high=read_dword(SI+(Bit16u)&Int13Ext->lba2, DS);
      if (lba_high > read_dword_DS(&EbdaData->ata.devices[device].sectors_high) ) {
        BX_INFO("int13_harddisk: function %02x. LBA out of range\n",GET_AH());
        goto int13_fail;
      }

      // Get 32 lsb lba and check
      lba_low=read_dword(SI+(Bit16u)&Int13Ext->lba1, DS);
      if (lba_high == read_dword_DS(&EbdaData->ata.devices[device].sectors_high)
          && lba_low >= read_dword_DS(&EbdaData->ata.devices[device].sectors_low) ) {
        BX_INFO("int13_harddisk: function %02x. LBA out of range\n",GET_AH());
        goto int13_fail;
      }

      // If verify or seek
      if (( GET_AH() == 0x44 ) || ( GET_AH() == 0x47 ))
        goto int13_success;

      // Execute the command
      if (GET_AH() == 0x42)
        status=ata_cmd_data_io(0, device, ATA_CMD_READ_SECTORS, count, 0, 0, 0, lba_low, lba_high, segment, offset);
      else
        status=ata_cmd_data_io(1, device, ATA_CMD_WRITE_SECTORS, count, 0, 0, 0, lba_low, lba_high, segment, offset);

      count=read_word_DS(&EbdaData->ata.trsfsectors);
      write_word(count, SI+(Bit16u)&Int13Ext->count, DS);

      if (status != 0) {
        BX_INFO("int13_harddisk: function %02x, error %02x !\n",GET_AH(),status);
        SET_AH(0x0c);
        goto int13_fail_noah;
      }

      goto int13_success;
      break;

    case 0x45: // IBM/MS lock/unlock drive
    case 0x49: // IBM/MS extended media change
      goto int13_success;    // Always success for HD
      break;

    case 0x46: // IBM/MS eject media
      SET_AH(0xb2);          // Volume Not Removable
      goto int13_fail_noah;  // Always fail for HD
      break;

    case 0x48: // IBM/MS get drive parameters
      if (int13_edd(DS, SI, device))
        goto int13_fail;

      goto int13_success;
      break;

    case 0x4e: // // IBM/MS set hardware configuration
      // DMA, prefetch, PIO maximum not supported
      switch (GET_AL()) {
        case 0x01:
        case 0x03:
        case 0x04:
        case 0x06:
          goto int13_success;
          break;
        default:
          goto int13_fail;
      }
      break;

    case 0x09: /* initialize drive parameters */
    case 0x0c: /* seek to specified cylinder */
    case 0x0d: /* alternate disk reset */
    case 0x11: /* recalibrate */
    case 0x14: /* controller internal diagnostic */
      BX_INFO("int13_harddisk: function %02xh unimplemented, returns success\n", GET_AH());
      goto int13_success;
      break;

    case 0x0a: /* read disk sectors with ECC */
    case 0x0b: /* write disk sectors with ECC */
    case 0x18: // set media type for format
    case 0x50: // IBM/MS send packet command
    default:
      BX_INFO("int13_harddisk: function %02xh unsupported, returns fail\n", GET_AH());
      goto int13_fail;
      break;
  }

int13_fail:
  SET_AH(0x01); // defaults to invalid function in AH or invalid parameter
int13_fail_noah:
  SET_DISK_RET_STATUS(GET_AH());
int13_fail_nostatus:
  SET_CF();     // error occurred
  return;

int13_success:
  SET_AH(0x00); // no error
int13_success_noah:
  SET_DISK_RET_STATUS(0x00);
  CLEAR_CF();   // no error
}
