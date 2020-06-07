char Version1[]="DOS.COM V0.1.4";//test bed
//todo: resize and take own stack
//Finder / DOS1.vmdk / Rechtsclick / Öffnen / Parallels Mounter
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

char DOS_ERR=0;
unsigned int count21h=0;

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
	return r;
}
	
int ShowRegister() {
    asm mov [vAX], ax
    asm mov [vBX], bx
    asm mov [vCX], cx
    asm mov [vDX], dx
    asm mov [vSP], sp
    asm mov [vBP], bp
    asm mov ax, cs
    asm mov [vCS], ax
    asm mov ax, ds
    asm mov [vDS], ax
    asm mov ax, ss
    asm mov [vSS], ax
    asm mov ax, es
    asm mov [vES], ax
    putch(10);
    cputs( "AX="); printhex16(vAX);
    cputs(",BX="); printhex16(vBX);
    cputs(",CX="); printhex16(vCX);
    cputs(",DX="); printhex16(vDX);
    cputs(",SP="); printhex16(vSP);
    cputs(",BP="); printhex16(vBP);
    cputs(",CS="); printhex16(vCS);
    cputs(",DS="); printhex16(vDS);
    cputs(",SS="); printhex16(vSS);
    cputs(",ES="); printhex16(vES);
}

//--------------------------------  disk IO  -------------------
char BIOS_ERR=0;
unsigned int  BIOS_Status=0;
char DiskBuf [512];
char Drive;
unsigned int  Cylinders;
char Sectors;
char Heads;
char Attached;
int  ParmTableSeg;
int  ParmTableOfs;
char DriveType;
int  PartNo;
//hard disk partition structure
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
//		cputs("AH Return Code:");
//		printhex16(BIOS_Status);	
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
	
//		putch(10);
		cputs("CyHdSc=");			printunsign(Cylinders);
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
	j = j + 0x1be;			ptBootable=DiskBuf[j];
	j++;					ptStartHead=DiskBuf[j];
	j++;					ptStartSector=DiskBuf[j];
	ah=0;//next line convert byte to word
	ptStartCylinder=ptStartSector;	
	ptStartSector &= 0x3F;
//	ptStartSector++;//Sector start with 1 todo
	ptStartCylinder &= 0xC0;
	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	
	j++;
	ah=0;//byte 2 word
	ptStartCylinder=DiskBuf[j] + ptStartCylinder;
//	byte add, ok because low byte is empty
//	ptStartCylinder=ptStartCylinder + DiskBuf[j];//OK

	j++;					ptFileSystem=DiskBuf[j];
	j++;					ptEndHead=DiskBuf[j];
	j++;					ptEndSector=DiskBuf[j];
	ah=0;//next line convert byte to word
	ptEndCylinder=ptEndSector;//see next 5 line		
	ptEndSector &= 0x3F;
	ptEndSector++;//Sector start with 1
	ptEndCylinder &= 0xC0;
	ptEndCylinder = ptEndCylinder << 2;//OK no short cut!	
	j++;
	ah=0;//byte 2 word
	ptEndCylinder=DiskBuf[j] + ptEndCylinder;
//	byte add, ok because low byte is empty
//	ptStartCylinder=ptStartCylinder + DiskBuf[j];//OK
	
	j++;
	p = j + &DiskBuf;//copy ptStartSector, ptPartLen
	memcpy(&ptStartSectorlo, p, 8);
	
	j += 8;//next partition entry
}
	
int printPartitionData() {
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
	cputs(",St=");
	printunsign(ptStartSectorhi);
	putch(':');
	printunsign(ptStartSectorlo);
	cputs(",Len=");
	printunsign(ptPartLenhi);
	putch(':');
	printunsign(ptPartLenlo);
}
	
int testDisk(drive) {
	char c; int i;
	asm mov [ParmTableSeg], ds
	//Offset is in DiskBuf
	BIOS_Status=Int13hRW(2,drive,0,0,1,1,ParmTableSeg,DiskBuf);
	if (BIOS_ERR) Int13hError();
	else {	
		putch(10);
		cputs("Read Partition Status:");
		printhex16(BIOS_Status);	
		cputs(",MBR Magic=");	
		i=510;		c = DiskBuf[i];		printhex8(c);
		i++;		c = DiskBuf[i];		printhex8(c);
		
		cputs(",DiskBuf=");
		printhex16(ParmTableSeg);
		putch(':');							
		printhex16(DiskBuf);
		putch('.');
	
		PartNo=0;
		do {
			getPartitionData();
			printPartitionData();
			PartNo ++;
		} while (PartNo <4);
	}	
}

int Int13hExt(char drive) {
	putch(10);
	cputs("Int13h 41hExt AX=");
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
		cputs(" BX=");		printhex16(vBX);
		cputs(" CX=");		printhex16(vCX);
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
	getkey();
	mdump(DiskBuf, 512);
	Int13hExt(Drive);
}
