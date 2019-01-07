char Version1[]="KERNEL.COM V0.1";
char DOS_ERR=0;
char KERNEL_ERR=0;
unsigned int count18h=0;
unsigned int vAX;

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

int DosInt() {
    asm int 33; 21h
    __emit__(0x73, 04); //jnc over DOS_ERR++
    DOS_ERR++;
}
int KernelInt() {
    asm int 24; 18h
    __emit__(0x73, 04); //jnc over KERNEL_ERR++
    KERNEL_ERR++;
}

int KERNEL_START() {
    count18h++;
    asm sti; enable interrupts
    if (ah==0x30) {//getDosVer
        ax=0x1403;
        asm iret
    }
    if (ah==0x25) {//setIntVec

    }
    cputs(" FUNC 18h not impl.");
    asm iret
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
/* KERNEL_START not found because it is no variable
int SetIntVecKrnl(char *adr) {
    asm push ds
    ax=cs;
    ds=ax;
//    dx= &adr; is mov instead of lea
    asm lea dx, [bp+4]; *adr
    ax=0x2518;//new addr in ds:dx
    DosInt();
    asm pop ds
}
*/
int main() {
    count18h=0;
    GetIntVec(0x18);
//    cputs("Int18h old=");
//    printhex16(VecOldSeg);
//    putch(':');
//    printhex16(VecOldOfs);
    //set Int Vec to KERNEL_START
    asm mov dx, KERNEL_START
    ax=0x2518;
    DosInt();


/*    ah=0x30;
    DosInt();
    asm mov [vAX], ax
    cputs(" DosVer:");
    printhex16(vAX);
*/
    ah=0x30;
    KernelInt();
    asm mov [vAX], ax
    cputs(" KernelVer:");
    printhex4(vAX);
    putch('.');
    vAX=vAX >>8;
    printunsign(vAX);

    cputs(" count18h=");
    printunsign(count18h);
    cputs(" end main.");
}
