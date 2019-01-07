char Version1[]="DOS.COM V0.1.1";//IO.SYS and MSDS.SYS for 1OS
//todo: resize and take own stack
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
        writett‚y();
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
    asm int 33; 21h
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

int main() {
    DOS_ERR = 0;
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
}
