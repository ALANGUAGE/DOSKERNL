char Version1[]="DOS.COM V0.1.4";//test bed
//todo: resize and take own stack
//Finder /hg/VirtualBox VMs/DOS1/DOS1.vhd (.vmdk) 
// Rechtsclick / Öffnen / Parallels Mounter
//Ranish Üart, int8h: CHS 1014/15/63, Start=63,Len=1023057
#define ORGDATA		8192//start of arrays
unsigned int vAX;
unsigned int vBX;
unsigned int vCX;
unsigned int vDX;
unsigned int vSP;
unsigned int vBP;
unsigned int vCS;
unsigned int vDS;
unsigned int vSS;
unsigned int vES;

char DOS_ERR;
char BIOS_ERR;
int  BIOS_Status;
char DiskBuf [512];
char Drive;
unsigned int  Cylinders;
char Sectors;
char Heads;
char Attached;
int  DiskBufSeg;
char DriveType;
int  PartNo;
//start hard disk partition structure 16 bytes
unsigned char ptBootable;	//80h = active partition, else 00
unsigned char ptStartHead;	//
unsigned char ptStartSector;	//bits 0-5
unsigned int  ptStartCylinder;//bits 8,9 in bits 6,7 of sector
unsigned char ptFileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=hugePart
unsigned char ptEndHead;		//
unsigned char ptEndSector;	//bits 0-5
unsigned int  ptEndCylinder;	//bits 8,9 in bits 6,7 of sector
unsigned int ptStartSectorlo;//sectors preceding partition
unsigned int ptStartSectorhi;
unsigned int ptPartLenlo;    //length of partition in sectors
unsigned int ptPartLenhi;
//end hard disk partition structure

//start boot ms-dos
//unsigned char  jmp[3];	/* Must be 0xEB, 0x3C, 0x90		*/
//unsigned char  sys_id[8];	/* Probably:   "MSDOS5.0"		*/
unsigned int   sect_size;	/* Sector size in bytes (512)		*/
unsigned char  clust_size;	/* Sectors per cluster (1,2,4,...,128)	*/
unsigned int   res_sects;	/* Reserved sectors at the beginning	*/
unsigned char  num_fats;	/* Number of FAT copies (1 or 2)	*/
unsigned int   root_entr;	/* Root directory entries		*/
unsigned int   total_sect;	/* Total sectors (if less 64k)		*/
unsigned char  media_desc;	/* Media descriptor byte (F8h for HD)	*/
unsigned int   fat_size;	/* Sectors per fat			*/
unsigned int   num_sects;	/* Sectors per track			*/
unsigned int   num_sides;	/* Sides				*/
unsigned long  hid_sects;	/* Special hidden sectors		*/
unsigned long  big_total;	/* Big total number of sectors  	*/
unsigned int   drive_num;	/* Drive number				*/
unsigned char  ext_signat;	/* Extended Boot Record signature (29h)	*/
unsigned long  serial_num;	/* Volume serial number			*/
//unsigned char  label[11];	/* Volume label				*/
//unsigned char  fs_id[8];	/* File system id			*/
//unsigned char  xcode[448];	/* Loader executable code		*/
//unsigned short magic_num;	/* Magic number (Must be 0xAA55) 	*/
//end boot ms-dos


long L1;
long L2;
int test() {
L2 = L1;//OK	
	}
	
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

int memcpy(char *s, char *t, int i) {
	unsigned int r;
	r = s;
	do {
		*s = *t;
		s++; t++; i--;
	} while (i != 0);
	ax=r;//	return r;
}

int printlong(unsigned int lo, unsigned int hi) {
// DX:AX DIV BX = AX remainder dx
	dx=hi;
	ax=lo;
__asm{	
  	mov     bx,10          ;CONST
    push    bx             ;Sentinel
.a: mov     cx,ax          ;Temporarily store LowDividend in CX
    mov     ax,dx          ;First divide the HighDividend
    xor     dx,dx          ;Setup for division DX:AX / BX
    div     bx             ; -> AX is HighQuotient, Remainder is re-used
    db		145;=91h xchg ax,cx;Temporarily move it to CX restoring LowDividend
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
} }

//--------------------------------  disk IO  -------------------

int Int13hRW(char rw, char drive, char head, int cyl, char sector,
	char count, int BufSeg, int BufOfs) {//CHS max. 8GB
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
int Int13hRaw(char drive, char function) {
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
	BIOS_Status=Int13hRaw(Drive, 0);//Reset
	BIOS_ERR=0;
}	

int Params(char drive) {
	cputs("(AH=08)Drive Params:");
	BIOS_Status=Int13hRaw(drive, 8);
	if (BIOS_ERR) Int13hError();
	else {
		asm mov [Heads],        dh
//		Heads++;
		asm mov [Attached],     dl
		// CX =       ---CH--- ---CL---
		// cylinder : 76543210 98
		// sector   :            543210	
		asm mov [Sectors],      cl
		Sectors &= 0x3F;// 63
//		Sectors++;//1 to 64
	
		asm mov [Cylinders],    cx	
		Cylinders &= 0xC0;//;bit 9 and 10 only
		Cylinders = Cylinders << 2;//compiler flaw:
		asm add [Cylinders],    ch;//byte add, low byte is empty	
	
		cputs("CylHeadSec=");		printunsign(Cylinders);
		putch('/');					printunsign(Heads);
		putch('/');					printunsign(Sectors);
		cputs(", NoDrives=");		printhex8(Attached);
		putch('.');
	}
}

int Status(drive) {
	putch(10);
	cputs("(1)Status last Op=");
	BIOS_Status=Int13hRaw(drive, 1);	
	if (BIOS_ERR) Int13hError();	
	printhex16(BIOS_Status);	
}	

int getPartitionData() {
	unsigned int j; char c; char *p;
	j = PartNo << 4;
	j = j + 0x1be;			ptBootable=DiskBuf[j];//80H=boot
	j++;					ptStartHead=DiskBuf[j];
	j++;					ptStartSector=DiskBuf[j];
	ah=0;//next line convert byte to word
	ptStartCylinder=ptStartSector;	
	ptStartSector &= 0x3F;
//	ptStartSector++;//Sector start with 1 todo
	ptStartCylinder &= 0xC0;
	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	
	j++;
	ah=0;//byte to word
	ptStartCylinder=DiskBuf[j] + ptStartCylinder;
	j++;					ptFileSystem=DiskBuf[j];
//	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=huge<2GB MS-DOS4.0	
	j++;					ptEndHead=DiskBuf[j];
	j++;					ptEndSector=DiskBuf[j];
	ah=0;//next line convert byte to word
	ptEndCylinder=ptEndSector;//see next 5 line		
	ptEndSector &= 0x3F;
//	ptEndSector++;//Sector start with 1 todo
	ptEndCylinder &= 0xC0;
	ptEndCylinder = ptEndCylinder << 2;//OK no short cut!	
	j++;
	ah=0;//byte to word
	ptEndCylinder=DiskBuf[j] + ptEndCylinder;
	j++;
	p = j + &DiskBuf;//copy ptStartSector, ptPartLen
	memcpy(&ptStartSectorlo, p, 8);
	
	j += 8;//next partition entry
}
	
int printPartitionData() {
	unsigned int i; unsigned int j;
	putch(10);		
	cputs("No=");			printunsign(PartNo);
	cputs(",Boot=");		printhex8(ptBootable);
	cputs(" ID=");			printunsign(ptFileSystem);
	cputs(",HdSeCy=");		printunsign(ptStartHead);
	cputs("/");				printunsign(ptStartSector);	
	cputs("/");				printunsign(ptStartCylinder);
	cputs("-");				printunsign(ptEndHead);
	cputs("/");				printunsign(ptEndSector);	
	cputs("/");				printunsign(ptEndCylinder);
//	putch(10);		
	cputs(",Start=");
	printlong(ptStartSectorlo, ptStartSectorhi);
	cputs(",Len=");
	printlong(ptPartLenlo, ptPartLenhi);
	cputs(" Sec=");
	i = ptPartLenhi <<  5;//64KB Sec to MB; >>4 + <<9 = <<5
	j = ptPartLenlo >> 11;//Sec to MB
	i = i + j;
	printunsign(i);
	cputs(" MByte.");
}
	
int testDisk(drive) {
	char c; int i;
	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf
	BIOS_Status=Int13hRW(2,drive,0,0,1,1,DiskBufSeg,DiskBuf);
	if (BIOS_ERR) Int13hError();
	else {	
		putch(10);
		cputs("Read Partition Status:");
		printhex16(BIOS_Status);	
		cputs(",MBR Magic=");	
		i=510;		c = DiskBuf[i];		printhex8(c);
		i++;		c = DiskBuf[i];		printhex8(c);
		
		cputs(",DiskBuf=");
		printhex16(DiskBufSeg);
		putch(':');							
		printhex16(DiskBuf);
		putch('.');
	
		PartNo=0;
		do {
			getPartitionData();
			printPartitionData();
			if (ptBootable == 0x80) {
				cputs(" boot partition found");
				if (ptFileSystem == 6) cputs(" huge partition < 2GB");
				PartNo=99;//end of loop	
			}
			PartNo ++;
		} while (PartNo <4);
	}	
}

int getMBR() {
	Cylinders=ptStartCylinder;
	Heads=ptStartHead;
	Sectors=ptStartSector ; // +1
	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf
  BIOS_Status=Int13hRW(2,Drive,Heads,Cylinders,Sectors,1,DiskBufSeg,DiskBuf);
		
	
}

int Int13hExt(char drive) {
	putch(10);
	cputs("Int13h 41hExt AX(3000=ERROR)=");
	bx=0x55AA;
	BIOS_Status=Int13hRaw(0x80, 0x41);	
	printhex16(BIOS_Status);
	if (BIOS_ERR) {
		cputs(" not present");	
		Int13hError();	
		}
	else {
		cputs(" status=1:supported");
		asm mov [vBX], bx;0xAA55 Extension installed
		asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			
		cputs(" BX(AA55)=");				printhex16(vBX);
		cputs(" CX(Interface bitmask)=");	printhex16(vCX);
		}		
}	

int mdump(unsigned char *adr, unsigned int len ) {
    unsigned char c;
    int i;
    int j;
    int k;
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
	Drive=0x80;
	
	Params(Drive);
	testDisk(Drive);
//	Int13hExt(Drive);
	getMBR();
	mdump(DiskBuf, 512);
}
