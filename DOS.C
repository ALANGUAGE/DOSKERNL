char Version1[]="DOS.COM V0.2.0";//test bed
//Finder /hg/DOS/DOS3.vhd
//rigth click / open / Parallels Mounter
// (E)DX:(E)AX DIV r/m16(32) = (E)AX, remainder (E)DX
// AL*r/m8=AX; AX*r/m16=DX:AX; EAX*r/m32=EDX:EAX
// > 16.777.216 sectors (8GB) only LBA
#define ORGDATA		16384//start of arrays
#define debug 0
unsigned int vAX ;unsigned int vBX ;unsigned int vCX; unsigned int vDX;
unsigned int vSP; unsigned int vBP; unsigned int vCS; unsigned int vDS;
unsigned int vSS; unsigned int vES; //debugging

unsigned char DOS_ERR;
unsigned char BIOS_ERR;
unsigned int  BIOS_Status;
unsigned int  DiskBufSeg;
unsigned char dummy[1];//todo remove
unsigned char DiskBuf [512];
unsigned char Drive=0x80;
//unsigned long sect_size_long;
unsigned long clust_sizeL;
unsigned long sector_sizeL;
unsigned char filename[67];
unsigned char searchstr  [12];//with null
char *upto;		//IN:part of filename to search/OUT:to search next time
char isfilename;//is filename or part of directory?
char fat_notfound;

//Params from int13h, Function 8
unsigned int  pa_Cylinders;
unsigned char pa_Sectors;
unsigned char pa_Heads;
unsigned char pa_Attached;
unsigned int  pt_PartNo;

//start hard disk partition structure 16 bytes in MBR. do not change
unsigned char pt_Bootable;		// 00 80h = active partition, else 00
unsigned char pt_StartHead;		// 01
unsigned char pt_StartSector;	// 02 bits 0-5
unsigned int  pt_StartCylinder;	//    bits 8,9 in bits 6,7 of sector
unsigned char pt_FileSystem;	// 04 0=nu,1=FAT12,4=16,5=ExtP,6=large16
unsigned char pt_EndHead;		// 05
unsigned char pt_EndSector;		// 06 bits 0-5
unsigned int  pt_EndCylinder;	//    bits 8,9 in bits 6,7 of sector
unsigned long pt_HiddenSector;	// 08 sectors preceding partition
unsigned long pt_PartLen;    	// 12 length of partition in sectors
//  16 end hard disk partition structure

//start boot BIOS Parameter Block structure. do not change
unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90
unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"
unsigned int  bs_sect_size;	// 11 bytes per sector (512)
unsigned char bs_clust_size;// 13 sectors per cluster (1,2,4,..,128)
unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0
unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)
unsigned int  bs_root_entr;	// 17 number of root directory entries (512)
unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)
unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)
unsigned int  bs_fat_size;	// 22 sectors per fat
unsigned int  bs_sectors_per_track; // 24 (DOS 3+)sectors per track
unsigned int  bs_num_heads;	// 26 (DOS 3+)number of heads
unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors
unsigned long bs_tot_sect32;// 32 (DOS 4+) number of sectors if ofs 19 = 0
unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number
unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk
unsigned char bs_ext_signat;// 38 (DOS 4+) Ext. signature,get next 3(29h)
unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random
unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"
unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"
// 62 end boot BIOS Parameter Block

//start directory entry structure, do not change
unsigned char dir_Filename[]="1234567";	//00 +lengthbyte=11
unsigned char dir_Ext[]="12";	//07 +lengthbyte=3
unsigned char dir_Attrib;		//11 directory=10h, Label=08h, read only=1
unsigned char dir_NTReserved;	//12 low case in body=8h, in ext=10h
unsigned char dir_TimeCreatedMS;//13 in 10 milliseconda or zero
unsigned int  dir_TimeCreated;	//14 creation time, resolution 2 sec. or 0
unsigned int  dir_DateCreated;	//16 creation date or zero
unsigned int  dir_DateLastAccessd;		//18 no time info available or zero
unsigned int  dir_FirstClusterHiBytes;	//20 FAT12/16 always zero
unsigned int  dir_LastModTime;	//22 modification time on closing
unsigned int  dir_LastModDate;	//24 modification date on closing
unsigned int  dir_FirstCluster;	//26 1.clu. of file data,if filesize=0 then 0
unsigned long dir_FileSize;		//28 size in bytes, if directory then zero
// 32 end direcctory entry structure

//FATInit
unsigned int  fat_FatStartSector;
unsigned long fat_FatStartSectorL;
unsigned int  fat_FatSectors;
unsigned long fat_RootDirStartSectorL;
unsigned long fat_RootDirSectorsL;
unsigned long fat_DataStartSectorL;
unsigned long fat_num_tracks;
unsigned int  fat_num_cylinders;
unsigned long Sectors_per_cylinder;
unsigned long DataSectors32;
unsigned long CountofClusters;
unsigned char trueFATtype;	//12, 16, 32 from FATInit
unsigned int  FATtype;		//0=error,1=FAT12,6=FAT16,11=FAT32 from ReadMBR

//fatfile
//unsigned char fat_filename [8];
//unsigned char fat_fileext  [3];
		 int  fatfile_root;
unsigned int  fatfile_cluster;
unsigned int  fatfile_nextCluster;
unsigned int  fatfile_sectorCount;
unsigned long fatfile_sectorStartL;
unsigned int  fatfile_lastBytes;
unsigned int  fatfile_lastSectors;
         int  fatfile_dir;
unsigned int  fatfile_currentCluster;
unsigned int  fatfile_sectorUpto;
unsigned int  fatfile_byteUpto;
unsigned long fatfile_fileSize;

int test() {
	__asm{
}	}

//------------------------------------   IO  -------------------

int writetty()     {//char in AL
    ah=0x0E;
    push bx;
    bx=0;			//page in BH
    inth 0x10;		//16
    pop bx;
}
int putch(char c)  {
    if (c==10)  {
        al=13;
        writetty();
    }
    al=c;
    writetty();
}
int cputs(char *s) {
    char c;
    while(*s) {
        c=*s;
        putch(c);
        s++;
    }
}
int cputsLen(char *s, int len) {
	char c;
	do {
		c=*s;
		putch(c);
		s++;
		len--;
	} while (len > 0);
}

int getch() {
    ah=0x10;//MF2-KBD read char
    inth 0x16;//AH=Scan code, AL=char
}
int waitkey() {
    ah=0x11;//get kbd status
    inth 0x16;//AH:Scan code, AL:char read, resting in buffer
    //zero flag: 0=IS char, 1=NO char
    __emit__(0x74,0xFA);// jz back 2 bytes until char read
}
int getkey() {
    waitkey();
    getch();
    ah=0;//clear scan code
    if (al == 0) getch() + 0x100;
    //put ext code in AX
}
int kbdEcho() {
    getkey();
    writetty();//destroys AH
}

int printhex4(unsigned char c) {
    c += 48;
    if (c > 57) c += 7;
    putch(c);
}
int printhex8(unsigned char c) {
    unsigned char nib;
    nib = c >> 4; printhex4(nib);
    nib = c & 15; printhex4(nib);
}
int printhex16(unsigned int i) {
    unsigned int half;
    half = i >>  8; printhex8(half);
    half = i & 255; printhex8(half);
}

int printunsign(unsigned int n) {
    unsigned int e;
    if (n >= 10) {
        e=n/10;
        printunsign(e);
        }
    n=n%10;
    n+='0';
    putch(n);
}

int printlong(unsigned long L) {
    ax = L;     // get low in ax
    edx=L;
    edx >> 16;  // get high in dx
__asm{
  	mov     bx,10          ;CONST
    push    bx             ;Sentinel
.a: mov     cx,ax          ;Temporarily store LowDividend in CX
    mov     ax,dx          ;First divide the HighDividend
    xor     dx,dx          ;Setup for division DX:AX / BX
;// DX:AX DIV BX = AX remainder dx
    div     bx             ; -> AX is HighQuotient, Remainder is re-used
    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
    push    dx             ;(1) Save remainder for now
    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
    or      cx,ax          ;Is the true 32-bit quotient zero?
    jnz     .a             ;No, use as next dividend
    pop     ax             ;(1a) First pop (Is digit for sure)
.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
}	writetty();		__asm{
    pop     ax             ;(1b) All remaining pops
    cmp     ax,bx          ;Was it the sentinel?
    jb      .b             ;Not yet
}
}
//--------------------------------  string  ---------------------
int strlen(char *s) { int c;
    c=0;
    while (*s!=0) {s++; c++;}
    return c;
}
int strcpy(char *s, char *t) {//new
    while (*t!=0) {
    	*s=*t; s++; t++; }
    *s=0;
    return s;
}
int eqstr(char *p, char *q) {
    while(*p) {
        if (*p != *q) return 0;
        p++;
        q++;
    }
    if(*q) return 0;
    return 1;
}

int memcmp(char *s, char *t, unsigned int i) {
    do {
        if (*s < *t) return 0xFFFF;
        if (*s > *t) return 1;
        s++; t++; i--;
    } while (i != 0);
    return 0;
}

int strcat(char *s, char *t) {
    while (*s != 0) s++;
    strcpy(s, t);
}
int toupper(char *s) {
    while(*s) {
        if (*s >= 'a') if (*s <= 'z') *s=*s-32;
        s++;
    }
}
int strchr(char *s, char c) {
    while(*s) {
        if (*s==c) return s;
        s++;
    }
    return 0;
}
int memchr(char *s, char c, unsigned int i) {
    while(i > 0) {
        if (*s==c) return s;
        s++; i--;
    }
    return 0;
}
int memchr1(char *s, char c, unsigned int i) {
	unsigned int pos;
	pos=1;
    while(i > 0) {
        if (*s==c) return pos;
        s++; i--; pos++;
    }
    return 0;
}
int instr1(char *s, char c) {
    while(*s) {
        if (*s==c) return 1;
        s++;
    }
    return 0;
}

int memcpy(char *s, char *t, unsigned int i) {
	unsigned int r;
	r = s;
	do {
		*s = *t;
		s++; t++; i--;
	} while (i != 0);
	ax=r;//	return r;
}

int mdump(unsigned char *adr, unsigned int len ) {
    unsigned char c; int i; int j; int k;
    j=0;
    k=0;
    while (j < len ) {
	    k++;;
	    if (k > 8) {
		    getkey();
		    k=1;
		    }
        putch(10);
        printhex16(adr);
        putch(':');
        i=0;
        while (i < 16) {
            putch(' ');
            c = *adr;
            printhex8(c);
            adr++;
            i++;
            j++;
            }
        putch(' ');
        adr -=16;
        i=0;
        while(i < 16) {
            c= *adr;
            if (c < 32) putch('.');
                else putch(c);
            adr++;
            i++;
        }
    }
}

//--------------------------------  disk IO  -------------------

int DiskSectorReadWrite(char rw, char drive, char head, int cyl,
char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB
	BIOS_ERR=0;
	dl=drive;
	dh=head;//may include 2 more cylinder bits
	es=BufSeg;
	bx=BufOfs;
	cx=cyl;
	cx &= 0x300;//2 high bits of cyl
	cx >> 2;//in 2 high bits of cl
	sector &= 0x3F;//only 6 bits for sector
	cl += sector;
	ch=cyl;//low byte of cyl in ch, word 2 byte
	al=count;
	ah=rw;
	inth 0x13;
    __emit__(0x73, 04); //jnc over BIOS_ERR++
	BIOS_ERR++;
}
int Int13hfunction(char drive, char function) {
	BIOS_ERR=0;
	dl=drive;
	ah=function;//0=reset, 1=status, 8=parms
	inth 0x13;
    __emit__(0x73, 04); //jnc over BIOS_ERR++
	BIOS_ERR++;//Status or error code in AX
}
int Int13hError() {
	cputs("** DISK ERROR AX=");
	printhex16(BIOS_Status);
	cputs(".  ");
	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR
}
int Status(drive) {
	putch(10);
	cputs("Status last Op=");
	BIOS_Status=Int13hfunction(drive, 1);
	if (BIOS_ERR) Int13hError();
	printhex16(BIOS_Status);
}

int Params() {
	if (debug) cputs(" DriveParams ");
	BIOS_Status=Int13hfunction(Drive, 8);
	if (BIOS_ERR) {
		Int13hError();
		return 1;
		}
	else {
		asm mov [pa_Heads],        dh
		asm mov [pa_Attached],     dl
		// CX =       ---CH--- ---CL---
		// cylinder : 76543210 98
		// sector   :            543210
		asm mov [pa_Sectors],      cl
		pa_Sectors &= 0x3F;// 63
//		pa_Sectors++;//1 to 64

		asm mov [pa_Cylinders],    cx
		pa_Cylinders &= 0xC0;//;bit 9 and 10 only
		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:
		asm add [pa_Cylinders],    ch;//byte add, low byte is empty

		if (pa_Attached == 0) {
			cputs(" no hard disk found");
			return 1;
			}
	}
	return 0;
}


int getPartitionData() {
	unsigned int j; char c; char *p;
	j = pt_PartNo << 4;
	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot
	j++;					pt_StartHead=DiskBuf[j];
	j++;					pt_StartSector=DiskBuf[j];
	pt_StartCylinder=(int)pt_StartSector;
	pt_StartSector &= 0x3F;
//	pt_StartSector++;//Sector start with 1 todo
	pt_StartCylinder &= 0xC0;
	pt_StartCylinder = pt_StartCylinder << 2;
	j++;
	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;
	j++;					pt_FileSystem=DiskBuf[j];
//	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB
	j++;					pt_EndHead=DiskBuf[j];
	j++;					pt_EndSector=DiskBuf[j];
	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line
	pt_EndSector &= 0x3F;
//	pt_EndSector++;//Sector start with 1 todo
	pt_EndCylinder &= 0xC0;
	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!
	j++;
	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;
	j++;
	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen
	memcpy(&pt_HiddenSector, p, 8);
}

int checkBootSign() {
	int i;
	i=510;
	if (DiskBuf[i] == 0x55) {
		i++;
		if (DiskBuf[i] == 0xAA) return 1;
	}
	cputs(" Magic number NOT found.");
	return 0;
}

int readMBR() {
	int isFAT;
	isFAT=0;
	pt_PartNo=0;
	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);
	if (BIOS_ERR) {
		Int13hError();
		return 0;
		}
	else {
//		cputs(" Read partition.");
		if(checkBootSign()==0) return 0;
		do {
			getPartitionData();

			if (pt_Bootable == 0x80) {
//				cputs("Boot partition found");
				if (pt_FileSystem == 1) {
					cputs(", FAT12 partition < 32MB");
					isFAT=1;
					}
				if (pt_FileSystem == 4) {
					cputs(", small FAT16 partition < 32MB");
					isFAT=4;
					}
				if (pt_FileSystem == 6) {
//					cputs(", large FAT16 partition < 2GB");
					isFAT=6;
					}
				pt_PartNo=99;//end of loop
			}
			pt_PartNo ++;
		} while (pt_PartNo <4);
		return isFAT;
	}
}

int getBootSector() {
	int i;
	if (debug) cputs(" Read boot sector");
  	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,
  		pt_StartSector, 1, DiskBufSeg, DiskBuf);
	if (BIOS_ERR) {
		Int13hError();
		return 0;
		}
	else {
//		printhex16(BIOS_Status);
		if(checkBootSign()==0) return 0;
		memcpy(&bs_jmp, &DiskBuf, 62);
		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");
		i=2;
		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");
	}
	return 1;
}

int FATInit() {
	unsigned long templong;//converting word to dword

	clust_sizeL = (long) bs_clust_size;
	sector_sizeL= (long) bs_sect_size;

	fat_FatStartSector = bs_res_sects;
	fat_FatStartSectorL= (long) fat_FatStartSector; 
	fat_FatSectors = bs_fat_size;
	if (bs_num_fats == 2) fat_FatSectors=fat_FatSectors+fat_FatSectors;

	fat_RootDirStartSectorL = (long)fat_FatStartSector + fat_FatSectors;
	
	fat_RootDirSectorsL = (long) bs_root_entr >> 4;//  ./. 16
		
	fat_DataStartSectorL = fat_RootDirStartSectorL + fat_RootDirSectorsL;

	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;
	DataSectors32=bs_tot_sect32 - fat_DataStartSectorL;

	CountofClusters=DataSectors32 / clust_sizeL;//d=d/b

	templong = (long) bs_sectors_per_track;
	fat_num_tracks = bs_tot_sect32 / templong;//d=d/w

	templong = (long) bs_num_heads;
	fat_num_cylinders = fat_num_tracks / templong;//w=d/w

	Sectors_per_cylinder = bs_sectors_per_track *  bs_num_heads;//d=w*w
	asm mov [Sectors_per_cylinder + 2], dx;store high word

	templong = (long) 65525;
	if (CountofClusters > templong) {
		trueFATtype=32;
		cputs(" FAT32 NOT supported");
		return 1;
		}
	templong= (long) 4086;
	if (CountofClusters < templong) {
		trueFATtype=12;
		cputs(" FAT12");
		return 0;
		}
	trueFATtype=16;
	if (debug) cputs(" FAT16");
	return 0;
}

int Int13hExt() {
	bx=0x55AA;
	BIOS_Status=Int13hfunction(Drive, 0x41);
	asm mov [vAX], ax;
	asm mov [vBX], bx; 0xAA55 Extension installed
	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported
	if (BIOS_ERR) {
		cputs(" Ext NOT present");
		Int13hError();
		return 1;
		}
	else {
	if (debug) cputs(",Int13h Ext");
		}
	return 0;
}

int PrintDriveParameter() {
	unsigned long Lo;
// from Params
	putch(10);
	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);
	putch('/');					printunsign(pa_Heads);
	putch('/');					printunsign(pa_Sectors);
	cputs(", NoDrives=");		printhex8  (pa_Attached);
	putch('.');
//from getPartitionData
	putch(10);
	cputs("getPartitionData:No=");printunsign(pt_PartNo);
	cputs(",Boot=");		printhex8(pt_Bootable);
	cputs(" ID=");			printunsign(pt_FileSystem);
	cputs(",HdSeCy=");		printunsign(pt_StartHead);
	cputs("/");				printunsign(pt_StartSector);
	cputs("/");				printunsign(pt_StartCylinder);
	cputs("-");				printunsign(pt_EndHead);
	cputs("/");				printunsign(pt_EndSector);
	cputs("/");				printunsign(pt_EndCylinder);
	cputs(",Start=");		printlong(pt_HiddenSector);
	cputs(",Len=");			printlong(pt_PartLen);
	cputs(" Sec=");
	Lo = pt_PartLen >> 11;//sectors to MByte
	printlong(Lo);
	cputs(" MByte.");
//from getBootSector
	putch(10);
	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);
	putch(10);
	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);
	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);
	putch(10);
	cputs("Reserved sectors=");printunsign(bs_res_sects);
	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);
	putch(10);
	cputs("Root directory entries(512)=");printunsign(bs_root_entr);
	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);
	putch(10);
	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);
	cputs(".Sectors per FAT=");printunsign(bs_fat_size);
	putch(10);
	cputs("sectors per track=");printunsign(bs_sectors_per_track);
	cputs(".number of heads=");printunsign(bs_num_heads);
	putch(10);
	cputs("hidden sectors(long)=");printlong(bs_hid_sects);
	cputs(".sectors(long)=");printlong(bs_tot_sect32);
	putch(10);
	cputs("physical drive number=");printunsign(bs_drive_num);
	cputs(".Windows NT check disk=");printunsign(bs_reserved);
	putch(10);
	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);
	cputs(".Volume serial(long)=");printlong(bs_serial_num);
	putch(10);
	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);
	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);
//from FATInit
	putch(10);
	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);
	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);
	putch(10);
	cputs("fat_RootDirStartSectorL="); printlong(fat_RootDirStartSectorL);
	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectorsL);
	putch(10);
	cputs("fat_DataStartSectorL=");	printunsign(fat_DataStartSectorL);
	cputs(", DataSectors32=");	printlong(DataSectors32);
	putch(10);
	cputs("CountofClusters=");	printlong(CountofClusters);
	cputs(", Sectors_per_cylinder="); printlong(Sectors_per_cylinder);
	putch(10);
	cputs("fat_num_tracks=");	printlong(fat_num_tracks);
	cputs(", fat_num_cylinders="); printunsign(fat_num_cylinders);
}

//--------------------------------  file IO  -------------------
int error2(char *s) {
	putch(10);
	cputs("*** ERROR *** ");
	cputs(s);
	DOS_ERR++;
}
// 1.
int readLogical(unsigned long SectorL) {//OUT:1 sector in DiskBuf
	unsigned int track; unsigned int head; unsigned int sect;
	SectorL = SectorL + bs_hid_sects;//d=d+d
	track = SectorL / Sectors_per_cylinder;  //w=d/d
	head  = SectorL % Sectors_per_cylinder;  //w=d%d
	sect  = head            % bs_sectors_per_track;  //w=w%w
	sect++;
	head  = head            / bs_sectors_per_track;	 //w=w/w

	DiskSectorReadWrite(2, bs_drive_num, head, track/* =cyl */,
		sect, 1, DiskBufSeg , DiskBuf);
}

// 2.a
int printDirEntry() {
    unsigned int j;
	putch(10);
	cputs(filename);
	cputs(" ATTR:");
	printhex8(dir_Attrib);	
	if (dir_Attrib &  1) cputs(" r/o");
	if (dir_Attrib &  2) cputs(" hid");
	if (dir_Attrib &  4) cputs(" sys");
	if (dir_Attrib &  8) cputs(" vol");		
	if (dir_Attrib & 16) cputs(" dir");
	if (dir_Attrib & 32) cputs(" arc");
	if (dir_Attrib == 0) cputs("    ");
	
	putch(' ');
	j=dir_LastModDate & 31;//day
	if (j<10) putch(' ');
	printunsign(j);
	putch('.');

	j=dir_LastModDate >> 5;//month
	j&=  15;
	if (j<10) putch('0');
	printunsign(j);
	putch('.');

	j=dir_LastModDate >> 9;//year
	j+= 1980;
	printunsign(j);
	putch(' ');
	//putch(' ');

	j=dir_LastModTime  >>11;//hour
	if (j<10) putch(' ');
	printunsign(j);
	putch(':');

	j=dir_LastModTime  >> 5;//minute
	j&=  63;
	if (j<10) putch('0');
	printunsign(j);
	putch(':');

	j=dir_LastModTime & 31;// 2 seconds
	j=j+j;
	if (j<10) putch('0');
	printunsign(j);
	putch(' ');

	cputs(" 1.Cl:"); 
	printunsign(dir_FirstCluster);
	cputs(" Size:");
	printlong(dir_FileSize);
	
}

// 2.b
int fatDirSectorList(unsigned long startSector, unsigned long numsectors) {
    char *p;
	unsigned int EndDiskBuf;
	char isHide;//shows entries, NOT lfn, deleted or empty
	
	do {
/*		putch(10);
		cputs("Sektor = "); 
		printlong(startSector);
		cputs(", numsectors = "); 
		printunsign(numsectors);
		getkey();
*/
		readLogical(startSector);
		p=&DiskBuf;
		EndDiskBuf= p + bs_sect_size;		
		
		do {
			memcpy(dir_Filename, p, 32);//copy whole dir structure
			memcpy(filename, p, 11);
			filename[11] = 0;
			
			isHide=0;//show in listing
			if (*p ==    0) {//only empty entries following
				isHide++;
				numsectors=1;//finish searching
				p = EndDiskBuf;
				}
			if (*p == 0xE5) isHide++;//deleted, free entry
			if (*p <=   31) isHide++;//part of LFN
			if (dir_Attrib ==    15) isHide++;//LFN start
					
			if (isHide == 0) printDirEntry();
			p+=32;//get next entry
		} while (p < EndDiskBuf);
		startSector = startSector + 1;//long, do NOT use ++ or +=1
		numsectors--;
//mdump(DiskBuf, 512);
	} while (numsectors > 0);
	fatfile_cluster=0;//not found but not end
}

// 2.
int fatDirSectorSearch(unsigned long startSector, unsigned long numsectors) {
    //search for file name. IN:searchstr
    char *p;
	unsigned int EndDiskBuf;
	fat_notfound=0;	
	do {
		readLogical(startSector);
		p=&DiskBuf;
		EndDiskBuf= p + bs_sect_size;
		do {
			if (memcmp(p, searchstr, 11) == 0) {//found file name
				memcpy(dir_Filename, p, 32);//copy whole dir structure
				memcpy(filename, p, 11);
				filename[11] = 0;
				fatfile_cluster   = dir_FirstCluster;
				fatfile_fileSize  = dir_FileSize;
//				fatfile_Attr      = dir_Attrib;
//				fatfile_LastModTime= dir_LastModTime;
//				fatfile_LastModDate= dir_LastModDate;
				printDirEntry();
			}
			if (*p == 0) {//only empty entries following
					fat_notfound=1;
					return;
				}
			p+=32;//get next entry
		} while (p < EndDiskBuf);
		startSector++;		
		numsectors--;
	} while (numsectors > 0);
	fatfile_cluster=0;//not found but not end
}

// 3.
int fatRootSearch() {
    fatDirSectorSearch(fat_RootDirStartSectorL, fat_RootDirSectorsL);
//	getkey();
//    fatDirSectorList(fat_RootDirStartSectorL, fat_RootDirSectorsL);
}

// 4.
int fatClusterAnalyse(unsigned int cluster) {
//OUT: fatfile_sectorStartL, fatfile_nextCluster
	unsigned long fatSectorL;
	unsigned int offset;
	char *p;
	
	fatfile_sectorStartL = (long) cluster - 2;
	fatfile_sectorStartL = fatfile_sectorStartL * clust_sizeL;
	fatfile_sectorStartL = fatfile_sectorStartL + fat_DataStartSectorL;
	
	fatSectorL = (long) cluster + cluster;
	fatSectorL = fatSectorL / sector_sizeL;		
	fatSectorL = fatSectorL + fat_FatStartSectorL; 

	readLogical(fatSectorL);
	
	offset = cluster + cluster;
	offset = offset % bs_sect_size;
	
	p=&DiskBuf;
	p = p + offset;	
	memcpy(&fatfile_nextCluster, p, 2);
}

// 5.
int fatDirSearch() {//search a directory chain. IN:searchstr
	
	fatClusterAnalyse(fatfile_cluster);
	//OUT: fatfile_sectorStartL, fatfile_nextCluster

	fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster); 
	while (fatfile_cluster == 0) {//not found but not end
		if (fatfile_nextCluster >= 0xFFF8) {
			fat_notfound=1;
			return;	
		}		
		fatfile_cluster=fatfile_nextCluster;
		fatClusterAnalyse(fatfile_cluster);
		fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster);
	}	
}

int is_delimiter(char *s) {
	if (*s == '/' ) return 1;
	if (*s == '\\') return 1;
	if (*s ==    0) return 2;
	if (*s ==  '.') return 3;
	return 0;
}	
// 6.
int fatNextSearch() {//get next part of filename to do a search
//	IN:  upto: points to start of search in filename 
//	OUT: upto: points to search for next time
//	OUT: searchstr: part of filename in DIR-format with blanks (11bytes)
//	OUT: isfilename: 0=part of directory, 1=filename
//	OUT: fat_notfound
	char *searchstrp;
	char *p; 
	unsigned int  len;
	unsigned int delimiter;
putch(10); cputs("A:"); cputs(upto);
	delimiter=is_delimiter(upto);
	if (delimiter == 1) upto++;
	if (delimiter == 2) {fat_notfound=1; return; }

	strcpy(&searchstr, "           ");//11 blank padded
	searchstrp = &searchstr;//clear searchstr
	len=0;
	delimiter=is_delimiter(upto);
	while (delimiter == 0) { //no slash, zero, point
		*searchstrp = *upto;
		searchstrp++;
		upto++;	
		len++;
		delimiter=is_delimiter(upto);
	} 
	if (len > 8) {fat_notfound=1; return; }
	isfilename=0;//default directory
	if (delimiter == 2) isfilename=1;//last name is always a file name
	if (delimiter == 3) {//remove dot in name		
		searchstrp = &searchstr;
		searchstrp += 8;//start extension		
		len=0;
		upto++;
		delimiter=is_delimiter(upto);
		while (delimiter == 0) { //no slash, zero, point
			*searchstrp = *upto;
			searchstrp++;
			upto++;	
			len++;
			delimiter=is_delimiter(upto);
		} 
		if (len > 3) {fat_notfound=1; return; }
		if (delimiter == 2) isfilename=1;//last name is always a file name
	}	
putch(10);
cputs("End:"); cputsLen(searchstr, 11);
cputs(",isFN="); printunsign(isfilename);
cputs(",upto="); cputs(upto);
}

// 7.
int fatGetStartCluster() {
	if (fat_notfound) return;
	upto = &filename;
	fatfile_cluster = 0;
	if (debug) {
		cputs("GetStartCluster filename=");cputs(filename);
		cputs(", upto="); cputs(upto); }
	fatNextSearch();
}

// 8.
int fatOpenFile() {//set handle for root or subdir
	unsigned long bytes_per_cluster;
	fat_notfound=0;
	if (debug) cputs("fatOpenfile ");	
	if (filename[0] == 0) {//empty filename
//	if (strlen(filename) == 0) {//empty filename
		fat_notfound=1;//todo: return
		
		fatfile_root = 1;
		fatfile_nextCluster = 0xFFFF;
		fatfile_sectorCount = fat_RootDirSectorsL;
		fatfile_sectorStartL = fat_RootDirStartSectorL;
		fatfile_lastBytes   = 0;
		fatfile_lastSectors = fat_RootDirSectorsL;
		fatfile_cluster     = 0;
		fatfile_dir         = 1;

	} else {//search in subdir
		fatfile_root = 0;
		fatGetStartCluster();
		if (fat_notfound) return 1;
		bytes_per_cluster   = (long) bs_clust_size * bs_sect_size;
		fatfile_lastBytes   = fatfile_fileSize % bytes_per_cluster;
		fatfile_lastSectors = fatfile_lastBytes / bs_sect_size;
		fatfile_lastBytes   = fatfile_lastBytes % bs_sect_size;
		if (fatfile_fileSize == 0) fatfile_dir = 1;
		else                       fatfile_dir = 0;

//		fatClusterAnalyse();
		fatfile_sectorCount = (int) bs_clust_size;
	}
	fatfile_currentCluster = fatfile_cluster;
	fatfile_sectorUpto = 0;
	fatfile_byteUpto   = 0;
	if (fat_notfound) return 1;
	return 0;
}

// 9.
int fileOpen() {//remove drive letter and insert in drive
	int rc;
	toupper(filename);
	rc=fatOpenFile();
	cputs(" rc="); printunsign(rc);
	if (rc) return 0;//error
//	else return fhandle;
}

//------------------------------- Init,  main ---------------
int Init() {
	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
	if (debug) cputs("Init ");

	if (Params()) cputs("** NO DRIVE PARAMS FOUND **");//no hard disk
	FATtype=readMBR();//0=error,1=FAT12,6=FAT16,11=FAT32
	if (FATtype == 0) {
		cputs("** no active FAT partition found **");
		return 1;
		}
	if(getBootSector()==0) 	return 1;
	if (FATInit())			return 1;
	if(trueFATtype != 16) 	return 1;
	Int13hExt();
	return 0;
}

int main() {
	Drive=0x80;
	if (Init() != 0) return 1;
	strcpy(&filename, "alfa5/binslash/dos.com");
	fileOpen();	
	fatNextSearch();	
	strcpy(&filename, "tet/abc.d");
	fileOpen();	
	strcpy(&filename, "T.dot/abc.");
	fileOpen();	
	fatNextSearch();
	strcpy(&filename, "test1.c");
	fileOpen();	
	strcpy(&filename, "123456789.123");
	fileOpen();	
	strcpy(&filename, "test2");
	fileOpen();	
	fatNextSearch();
	strcpy(&filename, " ");
	fileOpen();	
	strcpy(&filename, "");
	fileOpen();	
}
/*cputs(" delimiter="); printunsign(delimiter);
cputs(", isfilename="); printunsign(isfilename);
cputs(", upto="); printunsign(upto);
cputs("="); cputs(upto);
cputs(", len="); printunsign(len);
cputs(", searchstr="); cputsLen(searchstr, len);
*/

