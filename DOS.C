char Version1[]="DOS.COM V0.1.2";//test bed
//todo: resize and take own stack
#define ORGDATA		4000//start of arrays
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

//-------------------  disk IO  -----------------
char BIOS_ERR=0;
int  BIOS_Status=0;
char DiskBuf[512];
char Drive;
int  Cylinders;
int  Sectors;
int  Heads;
char Attached;
int  ParmTableSeg;
int  ParmTableOfs;
char DriveType;

int Int13hError() {
	cputs("*** disk error #(hex) :");
	printhex16(BIOS_Status);	
}	
int Int13hRawIO(char drive, char function) {
	BIOS_ERR=0;	
	dl=drive;
	ah=function;//0=reset, 1=status, 8=parms, 10h=hd status
	inth 0x13;
    __emit__(0x73, 04); //jnc over BIOS_ERR++
	BIOS_ERR++;//Status or error code in AH
}

int Int13hRW(char rw, char drive, int head, int cyl, int sector,
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
int Int13hReset() {
	BIOS_Status=Int13hRawIO(0x80, 0);
	if (BIOS_ERR) Int13hError();	
}
int Int13hStatusRead() {
	BIOS_Status=Int13hRawIO(0x80, 1);
	//AH=Status Floppy, AL=Status fixed disk	
	if (BIOS_ERR) Int13hError();	
	// AL is destroyed but we have AX in BIOS_Status 
}				 
int Int13hDriveParams() {
	BIOS_Status=Int13hRawIO(0x80, 8);
	asm mov [Sectors],      cl
	Sectors &= 0x3F;
	Sectors++;//1 to 64

	asm mov [Cylinders],    cl	
	Cylinders &= 0xC0;//;bit 9 and 10
	Cylinders << 2;//compiler flaw: forget to store in Cylinders
	asm mov [Cylinders],    ax
	asm add [Cylinders],    ch;low byte	
	Cylinders++;//1 to 1024

	asm mov [Heads],        dh
	Heads++;//1 to 256
	asm mov [Attached],     dl
	asm mov [ParmTableSeg], es
	asm mov [ParmTableOfs], di
	asm mov [DriveType],    bl
	if (BIOS_ERR) Int13hError();//the above params are invalid	
}	
int Int13hHardDriveStatus() {
	BIOS_Status=Int13hRawIO(0x80, 0x10);
	
	if (BIOS_ERR) Int13hError();//the above params are invalid			
}	

int PrintDriveParms() {
	cputs(" HD Params: Drive :"); 		printhex8(Drive);
	cputs(", Cyl :");					printunsign(Cylinders);
	cputs(", Sec :");					printunsign(Sectors);
	cputs(", Hd :");
}
	
int main() {
    DOS_ERR = 0;
    Int13hDriveParams();
    PrintDriveParms();
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
