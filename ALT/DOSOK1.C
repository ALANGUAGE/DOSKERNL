char Version1[]="DOS.COM V0.1.2";//test bed
//todo: resize and take own stack
#define ORGDATA		4096//start of arrays
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

int writetty()     {
    ah=0x0E;
    bx=0;
    asm int 16
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

//Int = pushf + call far
//Int = pushf + push cs + push offset DOS_START + jmp far cs:VecOldOfs
int DosInt() {
    inth 0x21;
    __emit__(0x73, 04); //jnc over DOS_ERR++
    DOS_ERR++;
}

unsigned char JmpFarHook=0xEA;//start struct
unsigned int VecOldOfs;
unsigned int VecOldSeg;//end struct

int GetIntVec(char c) {
    asm push es
    al=c;
    ah=0x35;
    DosInt();
    asm mov [VecOldOfs], bx
    asm mov [VecOldSeg], es
    asm pop es
}

unsigned int VecNewOfs;
unsigned int VecNewSeg;

int GetIntVecNew(char c) {
    asm push es
    al=c;
    ah=0x35;
    DosInt();
    asm mov [VecNewOfs], bx
    asm mov [VecNewSeg], es
    asm pop es
}
/*
int SetIntVecDos(char *adr) {
    asm push ds
    ax=cs;
    ds=ax;
//    dx= &adr; is mov instead of lea
    asm lea dx, [bp+4]; *adr
    ax=0x2521;//new addr in ds:dx
    DosInt();
    asm pop ds
}
*/
unsigned int DS_old;

int DOS_START() {
    count21h++;
    if (ah != 0x80) {
        asm jmp JmpFarHook; goto old kernel
    }
        ax=ds;
        __emit__(0x2E);//cs seg for next instruction
        asm mov [DS_old], ax
        ax=cs;// cs seg is the only seg we know the value
        ds=ax;

        asm sti; enable interrupts
        cputs("Inside DOS_START:");
        ShowRegister();

        cputs(" count21h=");
        printunsign(count21h);
        cputs(" DS: old=");
        printunsign(DS_old);

        ax=DS_old;//restore ds Seg
        ds=ax;
        asm iret
}

int setblock(unsigned int i) {
    DOS_ERR=0;
    bx=i;
    ax=cs;
    es=ax;
    ax=0x4A00;
    //modify mem Alloc. IN: ES=Block Seg, BX=size in para
    DosInt();
    asm mov [vAX], ax
    asm mov [vBX], bx
    if (DOS_ERR) cputs(" ***Error SetBlock***");
    cputs("SetBlock AX:"); printhex16(vAX);
    cputs(",BX:"); printhex16(vBX);
}


//--------------------------------  disk IO  -------------------
char BIOS_ERR=0;
int  BIOS_Status=0;
char DiskBuf [512];
char Drive;
int  Cylinders;
char Sectors;
char Heads;
char Attached;
int  ParmTableSeg;
int  ParmTableOfs;
char DriveType;
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


int Int13hRW(char rw, char drive, char head, int cyl, int sector,
	int count, int BufSeg, int BufOfs) {//CHS max. 8GB
	BIOS_ERR=0;	
	dl=drive;
	dh=head;
	es=BufSeg;
	bx=BufOfs;
	cx=cyl;	
	cx &= 0x300;//2 high bits of cyl
	cx >> 2;//in 2 high bits of cl	
	sector &= 0x3F;//only 6 bits for sector
	cl += sector;
	ch=cyl;//low byte of cyl in ch
	
	al=count;
	ah=rw;
	inth 0x13;
    __emit__(0x73, 04); //jnc over BIOS_ERR++
	BIOS_ERR++;
}
int Int13hRawIO(char drive, char function) {
	BIOS_ERR=0;	
	dl=drive;
	ah=function;//0=reset, 1=status, 8=parms
	inth 0x13;
    __emit__(0x73, 04); //jnc over BIOS_ERR++
	BIOS_ERR++;//Status or error code in AX
}
int Int13hError() {
	cputs(" ** disk error AX=");
	printhex16(BIOS_Status);
//	cputs(" BIOS_ERR=");
//	printunsign(BIOS_ERR);
	cputs(".  ");
//	putch(10);
	BIOS_Status=Int13hRawIO(Drive, 0);//Reset
	BIOS_ERR=0;
}	

int PrintDriveParms() {
	asm mov [Heads],        dh
	Heads++;//1 to 256
	asm mov [Attached],     dl
	asm mov [ParmTableSeg], es
	asm mov [ParmTableOfs], di
	asm mov [DriveType],    bl;BiosType(biosval)
	// CX =       ---CH--- ---CL---
	// cylinder : 76543210 98
	// sector   :            543210	
	asm mov [Sectors],      cl
	Sectors &= 0x3F;// 63
	Sectors++;//1 to 64

	asm mov [Cylinders],    cl	
	Cylinders &= 0xC0;//;bit 9 and 10
	Cylinders = Cylinders << 2;//compiler flaw:
	asm add [Cylinders],    ch;//byte add, low byte is empty	
//	Cylinders++;//1 to 1024	

	putch(10);
	cputs("HD Params:");		 	//printhex8(Drive);
	cputs(" Cyl=");						printunsign(Cylinders);
	cputs(", Sec=");					printunsign(Sectors);
	cputs(", Hd=");						printunsign(Heads);
	cputs(", Attached=");				printhex8(Attached);
	putch(10);	
	cputs("DriveType (FL)=");			printhex8(DriveType);
	cputs(", ParmTable=");				printhex16(ParmTableSeg);
	putch(':');							printhex16(ParmTableOfs);
	putch('.');
}

int Params(drive) {
	putch(10);	
	cputs("(8)Drive Params :");
	BIOS_Status=Int13hRawIO(drive, 8);//error
	if (BIOS_ERR) Int13hError();
	printhex16(BIOS_Status);	
    PrintDriveParms();

	putch(10);
	cputs("(10h)Status :");
	BIOS_Status=Int13hRawIO(drive, 0x10);	
	if (BIOS_ERR) Int13hError();	
	printhex16(BIOS_Status);	
}

int Status(drive) {
	putch(10);
	cputs("(1)Status last Op: AH=FL, AL=HD :");
	BIOS_Status=Int13hRawIO(drive, 1);	
	if (BIOS_ERR) Int13hError();	
	printhex16(BIOS_Status);	
}	

int testDisk(drive) {
	int i; int j; char c;
	putch(10);
	cputs("ReadStat=");	
	asm mov [ParmTableSeg], ds
	//Offset is in DiskBuf
	BIOS_Status=Int13hRW(2,drive,0,0,1,1,ParmTableSeg,DiskBuf);
	if (BIOS_ERR) Int13hError();	
//	printhex16(BIOS_Status);	
	cputs(", Part.Info: Magic=");
	i=510;
	c = DiskBuf[i];
	printhex8(c);
	i++;
	c = DiskBuf[i];
	printhex8(c);
	
	cputs(",DiskBuf=");
	printhex16(ParmTableSeg);
	putch(':');							
	printhex16(DiskBuf);
	putch('.');

    putch(10);		
	i=0;
	cputs("Part=");
	printhex8(i);
	j=0x1be;
	ptBootable=DiskBuf[j];
	cputs(",BootId=");
	printhex8(ptBootable);
	j++;
	ptStartHead=DiskBuf[j];
	cputs(",StartHd=");
	printhex8(ptStartHead);
	j++;
	ptStartSector=DiskBuf[j];
	ah=0;//next line convert byte to word
	ptStartCylinder=ptStartSector;//see next 5 line		
	ptStartSector &= 0x3F;
	ptStartSector++;//Sector start with 1
	cputs(",StartSec=");
	printhex8(ptStartSector);	
	ptStartCylinder &= 0xC0;
	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	
	j++;
	ah=0;//byte 2 word
	ptStartCylinder=DiskBuf[j] + ptStartCylinder;
//	byte add, ok because low byte is empty
//	ptStartCylinder=ptStartCylinder + DiskBuf[j];//OK
	cputs(",StartCyl=");
	printhex16(ptStartCylinder);
	j++;
	ptFileSystem=DiskBuf[j];
	cputs(",FileID=");
	printhex8(ptFileSystem);
	j++;
	ptEndHead=DiskBuf[j];
	cputs(",EndHd=");
	printhex8(ptEndHead);
	j++;
	ptEndSector=DiskBuf[j];
	
		
	
}	

int mdump(unsigned char *adr, unsigned int len ) {
    unsigned char c;
    int i;
    int j;
    j=0;
    while (j < len ) {
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
char Dummy[10];


//------------------------------------ main ---------------
int main() {
//	unsigned int i;
	Drive=0x80;
//	i = 0;

//  LabelAddr[LabelMaxIx] = AbsoluteLab;


//	asm  mov [DiskBuf+bx], al
	
//	asm mov [Dummy+bx], al
		
//	DiskBuf [i] = 0;
	
//	do {
//		DiskBuf[i] = 0;
//		i++;
//	} while (i < 100);

	Params(Drive);
	testDisk(Drive);

//	mdump(DiskBuf, 256);
	

	putch(10);
	cputs("(41)Ext present :");
	bx=0x55AA;
	BIOS_Status=Int13hRawIO(0x80, 0x41);	
	if (BIOS_ERR) Int13hError();
	//BIOS_Status=ax;01: Extension supported
	asm mov [vBX], bx;0xAA55 Extension installed
	asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			
	printhex16(BIOS_Status);		

/*	DosBox Disk Services Int13h:
	00	Reset Disk System
	01	Get Status of Last Drive Operation
	02	Read Sectors
	03	Write Sectors
	08	Get Drive Parameters
	only DosBox_X:
	41	EXT Extension Available
	42	EXT Read Sectors
	43	EXT Write Sectors
	48	EXT Read Drive Parameter
*/
/*
    setblock(4096);// 64KB

    GetIntVec(0x21);
    cputs(" Main Int21h old=");
    printhex16(VecOldSeg);
    putch(':');
    printhex16(VecOldOfs);

    asm mov dx, DOS_START
//    asm lea dx, [DOS_START]
    ax=0x2521;
    DosInt();
//    ShowRegister();

    GetIntVecNew(0x21);
    cputs(" Int21h new=");
    printhex16(VecNewSeg);
    putch(':');
    printhex16(VecNewOfs);

    cputs(" count21h=");
    printunsign(count21h);
    cputs(" end main.");

//    asm int 32;20h exit

    asm mov dx, main;get adr of main in dx//Terminate stay resident
    asm shr dx, 4   ;make para
    asm add dx, 17  ;PSP in para + align to next para
    ax=0x3100;
    DosInt();
*/

}
