char Version1[]="DOS.COM V0.1.6";//test bed
//todo: resize and take own stack
//Finder /hg/VirtualBox VMs/DOS1/DOS1.vhd (.vmdk) 
// Rechtsclick / Öffnen / Parallels Mounter
//Ranish Part, int8h: CHS 1014/15/63, Start=63,Len=1.023.057
//Boot Sec=63, head=16, hidden=63, Sec=983.121
#define ORGDATA		8192//start of arrays
unsigned int vAX ;unsigned int vBX ;unsigned int vCX; unsigned int vDX;
unsigned int vSP; unsigned int vBP; unsigned int vCS; unsigned int vDS;
unsigned int vSS; unsigned int vES; //debugging

unsigned char DOS_ERR;
unsigned char BIOS_ERR;
unsigned int  BIOS_Status;

unsigned char DiskBuf [512];
unsigned int  DiskBufSeg;
unsigned char Drive=0x80;
unsigned long Sectors_to_read;//for readLogical

//Params from int13h, Function 8
unsigned int  pa_Cylinders;
unsigned char pa_Sectors;
unsigned char pa_Heads;
unsigned char pa_Attached;

//calcFATtype     
unsigned int FatStartSector;
unsigned int FatSectors;
unsigned int RootDirStartSector;
unsigned int RootDirSectors;
unsigned int DataStartSector;
unsigned long DataSectors32;
unsigned long CountofClusters;
char          trueFATtype;
unsigned long Sectors_per_cylinder;

//start hard disk partition structure 16 bytes in MBR. do not change
unsigned char pt_Bootable;		//80h = active partition, else 00
unsigned char pt_StartHead;
unsigned char pt_StartSector;	//bits 0-5
unsigned int  pt_StartCylinder;	//bits 8,9 in bits 6,7 of sector
unsigned char pt_FileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=largeFAT16
unsigned char pt_EndHead;
unsigned char pt_EndSector;		//bits 0-5
unsigned int  pt_EndCylinder;	//bits 8,9 in bits 6,7 of sector
unsigned long pt_HiddenSector;	//sectors preceding partition
unsigned long pt_PartLen;    	//length of partition in sectors
//end hard disk partition structure

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
unsigned int  bs_num_sects;	// 24 (DOS 3+)sectors per track 
unsigned int  bs_num_sides;	// 26 (DOS 3+)number of heads   
unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors 
unsigned long bs_tot_sect32;	// 32 (DOS 4+) number of sectors if ofs 19 = 0
unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number
unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk
unsigned char bs_ext_signat;// 38 (DOS 4+) Extended signature,get next 3(29h)
unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random
unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"
unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"
// 62 end boot BIOS Parameter Block

int test() {

__asm{	

}	}

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

int printlong(unsigned int *p) {
	unsigned int lo; unsigned int hi;
	lo = *p;
	p +=2;
	hi = *p;
	dx=hi;
	ax=lo;
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

int memcpy(char *s, char *t, unsigned int i) {
	unsigned int r;
	r = s;
	do {
		*s = *t;
		s++; t++; i--;
	} while (i != 0);
	ax=r;//	return r;
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

int Params() {
	cputs("Drive Params:");
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
		cputs("CylHeadSec=");		printunsign(pa_Cylinders);
		putch('/');					printunsign(pa_Heads);
		putch('/');					printunsign(pa_Sectors);
		cputs(", NoDrives=");		printhex8  (pa_Attached);
		putch('.');
	}
	return 0;
}

int Status(drive) {
	putch(10);
	cputs("Status last Op=");
	BIOS_Status=Int13hfunction(drive, 1);	
	if (BIOS_ERR) Int13hError();	
	printhex16(BIOS_Status);	
}	

int getPartitionData(int PartNo) {
	unsigned int j; char c; char *p;
	j = PartNo << 4;
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
	
int printPartitionData(int PartNo) {
	unsigned long Lo;
	putch(10);		
	cputs("No=");			printunsign(PartNo);
	cputs(",Boot=");		printhex8(pt_Bootable);
	cputs(" ID=");			printunsign(pt_FileSystem);
	cputs(",HdSeCy=");		printunsign(pt_StartHead);
	cputs("/");				printunsign(pt_StartSector);	
	cputs("/");				printunsign(pt_StartCylinder);
	cputs("-");				printunsign(pt_EndHead);
	cputs("/");				printunsign(pt_EndSector);	
	cputs("/");				printunsign(pt_EndCylinder);
	cputs(",Start=");		printlong(&pt_HiddenSector);
	cputs(",Len=");			printlong(&pt_PartLen);
	cputs(" Sec=");
	Lo = pt_PartLen >> 11;//sectors to MByte
	printlong(&Lo);
	cputs(" MByte.");	
	putch(10);
}
int checkBootSign() {
	char c; char d; int i; char ok;
	cputs(",magic number=");	
	i=510;		c = DiskBuf[i];		printhex8(c);
	i++;		d = DiskBuf[i];		printhex8(d);
	ok=0;
	if (c == 0x55) ok=1;
	if (d == 0xAA) ok=1;
	if (ok) {
		cputs(" found.");
		return 1;
		}
	else {
		cputs(" NOT found.");
		return 0;	
	}
}	
	
int readMBR() {
	int isFAT; int PartNo;
	isFAT=0;
	PartNo=0;
	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);
	if (BIOS_ERR) {
		Int13hError();
		return 0;
		}
	else {	
		putch(10);
		cputs("Read partition status:");
		if(checkBootSign()==0) return 0;	
		do {
			getPartitionData(PartNo);
			printPartitionData(PartNo);
			
			if (pt_Bootable == 0x80) {
				cputs("Boot partition found");
				if (pt_FileSystem == 1) {
					cputs(", FAT12 partition < 32MB");
					isFAT=1;
					}
				if (pt_FileSystem == 4) {
					cputs(", small FAT16 partition < 32MB");
					isFAT=4;
					}
				if (pt_FileSystem == 6) {
					cputs(", large FAT16 partition < 2GB");
					isFAT=6;
					}
				PartNo=99;//end of loop	
			}
			PartNo ++;
		} while (PartNo <4);
		if (isFAT==0) cputs(" no active FAT partition found");
		return isFAT;
	}	
}

int getBootSector() {
  	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,
  		pt_StartSector, 1, DiskBufSeg, DiskBuf);
	if (BIOS_ERR) {
		Int13hError();
		return 0;
		}
	else {	
		putch(10);
		cputs("Read boot sector status:");
		printhex16(BIOS_Status);	
		if(checkBootSign()==0) return 0;
		
		memcpy(&bs_jmp, &DiskBuf, 62);
		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");
		if (bs_jmp[2] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");
		putch(10);
		cputs("OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);
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
		cputs("Media descriptor(F8h for HD)=");printhex8(bs_media_desc);
		cputs(".Sectors per FAT=");printunsign(bs_fat_size);
		putch(10);
		cputs("sectors per track=");printunsign(bs_num_sects);
		cputs(".number of heads=");printunsign(bs_num_sides);
		putch(10);
		cputs("hidden sectors(long)=");printlong(&bs_hid_sects);
		cputs(".sectors(long)=");printlong(&bs_tot_sect32);
		putch(10);
		cputs("physical drive number=");printunsign(bs_drive_num);
		cputs(".Windows NT check disk=");printunsign(bs_reserved);
		putch(10);
		cputs("Extended signature(29h)=");printhex8(bs_ext_signat);
		cputs(".Volume serial(long)=");printlong(&bs_serial_num);
		putch(10);
		cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);
		cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);		
	}
	return 1;
}

int calcFATtype() {	
	unsigned long templong;//converting word to dword

	FatStartSector=bs_res_sects;	
	FatSectors=bs_fat_size;	
	if (bs_num_fats == 2) FatSectors=FatSectors+FatSectors;

	RootDirStartSector=FatStartSector + FatSectors;
	RootDirSectors= bs_root_entr << 5;// *32	
	RootDirSectors= RootDirSectors / bs_sect_size;

	DataStartSector=RootDirStartSector + RootDirSectors;
	templong=(long) DataStartSector;		
	
	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;		
	DataSectors32=bs_tot_sect32 - templong;//sub 32bit		

	templong =(long) bs_clust_size;		
	CountofClusters=DataSectors32 / templong;
		
	Sectors_per_cylinder = bs_num_sects *  bs_num_sides;//d=w*w
	asm mov [Sectors_per_cylinder + 2], dx;store high word

	putch(10);
	cputs("FatStartSector:");	printunsign(FatStartSector);
	cputs(", FatSectors=");		printunsign(FatSectors);
	putch(10);
	cputs("RootDirStartSector="); printunsign(RootDirStartSector);
	cputs(", RootDirSectors=");	printunsign(RootDirSectors);
	putch(10);
	cputs("DataStartSector=");	printunsign(DataStartSector);
	cputs(", DataSectors32=");	printlong(&DataSectors32);			
	putch(10);
	cputs("CountofClusters=");	printlong(&CountofClusters);
	cputs(", Sectors_per_cylinder="); printlong(&Sectors_per_cylinder);
	cputs(", trueFATtype=FAT"); 
	
	asm xor eax, eax ;clear bit 15-31			
	templong = 65525;			
	if (CountofClusters > templong) {
		trueFATtype=32; 
		cputs("32 NOT supported"); 
		return 1;
		}
	asm xor eax, eax ;clear bit 15-31
	templong=4086;
	if (CountofClusters < templong) {
		trueFATtype=12; 
		cputs("12"); 
		return 0;
		}
	trueFATtype=16;
	cputs("16");
	return 0;
}

int Int13hExt() {
	bx=0x55AA;
	BIOS_Status=Int13hfunction(Drive, 0x41);	
	asm mov [vAX], ax;
	asm mov [vBX], bx; 0xAA55 Extension installed
	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported 			
	putch(10);
	cputs("Int13h 41h Ext=");printhex16(vAX);
	cputs(", BIOS_Status=");				printhex16(BIOS_Status);
	if (BIOS_ERR) {
		cputs(" Ext NOT present");	
		Int13hError();	
		return 1;
		}
	else {
		cputs(" Extension found BX(AA55)=");printhex16(vBX);
		cputs(" CX=");						printhex16(vCX);
		}
	return 0;			
}	

int readLogical() {
	unsigned int track;
	Sectors_to_read = Sectors_to_read + bs_hid_sects;//d=d+d

//	track = Sectors_to_read / 




	DiskSectorReadWrite(2, bs_drive_num );
	
//int DiskSectorReadWrite(char rw, char drive, char head, int cyl, 
//char sector, char count, int BufSeg, int BufOfs)
	
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

//------------------------------------ main ---------------
int main() {
	int res;
	Drive=0x80;
	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf

	if (Params()) 			return 1;//no hard disk
	res=readMBR();//0=error,1=FAT12,6=FAT16,11=FAT32
	if (res == 0) 			return 1;
//	mdump(DiskBuf, 512);
//	Int13hExt(Drive);
	if(getBootSector()==0) 	return 1;
//	mdump(DiskBuf, 512);
	if (calcFATtype())		return 1;
	if(trueFATtype != 16) 	return 1;
	Int13hExt();
}
