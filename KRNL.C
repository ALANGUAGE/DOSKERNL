char Version1[]="KERNEL.COM V0.1b";
//---------------------------- Kernel Data Area ---------------------
char KERNEL_ERR=0;
unsigned int count18h=0;
unsigned int vAX;
char cent;char year;char month;char day;
char hour; char min; char sec;
//--------------------------- Bios Routines I/O ---------------------
int writetty()     {//char in AL
    ah=0x0E;
    bx=0;     //page
    inth 0x10;
}
int putch(char c)  {
    if (c==10)  {
        al=13;
        writetty();
    }
    al=c;
    writetty();
}
int cputs(char *s) {//only with correct DS !!!
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
    writetty();
}
// ------------------------- Bios Functions -------------------------
int BCDtoChar(char BCD) { // converts 2 digit packed BCD
    char LowNibble;       // to Integer
    LowNibble = BCD & 0xF;// save ones digit
    BCD >> 4;// extract tens digit, result in AX
    asm push dx
    dl = 10;
    asm mul dl; result in AX
    asm pop dx
    al += LowNibble;
    ah=0;//result is byte
}
int GetRTCDate() {
//    cputs(" RTC Date:");
    ah=4;
    inth 0x1A;
    __emit__(0x73, 04); //jnc over KERNEL_ERR++
    KERNEL_ERR++;
    asm mov [cent], ch; cent ... are used by GetDate
    asm mov [year], cl
    asm mov [month],dh
    asm mov [day],  dl
    if (KERNEL_ERR > 0) cputs("ERROR no RTC");
}
int GetRTCTime() {
//    cputs(" RTCTime:");
    ah=2;
    inth 0x1A;
    __emit__(0x73, 04); //jnc over KERNEL_ERR++
    KERNEL_ERR++;
    asm mov [hour], ch
    asm mov [min],  cl
    asm mov [sec],  dh
    if (KERNEL_ERR > 0) cputs("ERROR no RTC");
}
//--------------------------- Kernel Routines -----------------------
int KernelInt() {
    inth 0x18;
    __emit__(0x73, 04); //jnc over KERNEL_ERR++
    KERNEL_ERR++;
}
unsigned int VecOldOfs;
unsigned int VecOldSeg;

int GetIntVec(char c) {
    asm push es
    al=c;
    ah=0x35;
    KernelInt();
    asm mov [VecOldOfs], bx
    asm mov [VecOldSeg], es
    asm pop es
}

//--------------------------- Start of new Interrupt 18h ------------
int KERNEL_START() {
    count18h++;
    asm sti; set interrupt enable

    if (ah==0x01) {//Read Keyboard and Echo
        kbdEcho();
        asm iret
    }
    if (ah==0x02) {//Display Character
        al=dl;
        writetty();
        asm iret
    }
    if (ah==0x06) {//Direct Console I/O
        if (dl == 0xFF) {// then read character
            getch();
            asm iret
        }
        al=dl;           // else display character
        writetty();
        asm iret
    }
    if (ah==0x07) {//Direct Console Input
        getch();
        asm iret
    }
    if (ah==0x09) {//display string in DS:DX
        asm push si
        si=dx;
        asm cld; clear direction, string up
        asm lodsb; from DS:SI to AL
        while (al != '$') {
            writetty();
            asm lodsb
        }
        asm pop si
        asm iret
    }

    if (ah==0x25) {//setIntVec in AL from DS:DX
        asm cli; clear int enable, turn OFF int
        asm push ax
        asm push es
        asm push di
        asm push ds; later pop ax
        ax << 2;
        ah=0;
        di=ax;
        ax=0;
        es=ax;//segment 0
        ax=dx;
        asm cld; clear direction, string up
        asm stosw; ofs in DX to ES:DI
        asm pop ax; get DS
        asm stosw; seg (DS) to ES:DI+2
        asm pop di
        asm pop es
        asm pop ax
        asm sti;set int enable, turn ON int
        asm iret
    }
    if (ah==0x2A) {//GetDate
        GetRTCDate();// get Date in BCD
        cent=BCDtoChar(cent);
        year=BCDtoChar(year);
        month=BCDtoChar(month);
        day=BCDtoChar(day);
        ch=0;
        cl=year;
        asm add cx, 2000; add century
        dh=month;
        dl=day;
        asm iret
    }
    if (ah==0x2C) {//GetTime, NO 1/100 sec
        GetRTCTime();
        hour=BCDtoChar(hour);
        min=BCDtoChar(min);
        sec=BCDtoChar(sec);
        ch=hour;
        cl=min;
        dh=sec;
        dl=0;// NO 1/100 sec
        asm iret
    }
    if (ah==0x30) {//getDosVer
        ax=0x1E03; //Ver 3.30
        asm iret
    }
    if (ah==0x33) {//Control C Check (break)
        al=0xFF;// error for all subcodes
        dl=0;// always off
        asm iret
    }
    if (ah==0x35) {//getIntVec in AL to ES:BX
        asm cli; clear int enable, turn OFF int
        asm push ds
        bx=0;
        ds=bx;  //Int table starts at 0000
        bl=al;
        bx << 2;//int is 4 bytes long
        asm les bx, [bx]; ofs in bx, seg in es
        asm pop ds
        asm sti; set int enable, turn ON int
        asm iret
    }
    if (ah==0x4C) {//Terminate
        al=0;//returncode
        inth 0x21;
        // asm iret
    }
    if (ah==0x54) {//GetVerifyState
        al=0;// always off
        asm iret
    }
    // function not implemented
    asm mov [vAX], ah
    cputs(" FUNC ");
    printhex8(vAX);
    cputs(" not impl.");
    inth 3;// break
    asm iret
}// END OF TSR

//--------------------------- Kernel Programs for separate use
int GetTickerBios() {
    cputs(" BiosTicker LO/HI:");
    ah=0;
    inth 0x1A;
    printunsign(dx);
    putch(':');
    printunsign(cx);
}

int RAM046CTicks() {
    cputs(" Ticks @40:6C LO/HI:");
    asm push es
    ax=0x40;
    es=ax;
    __emit__(0x26);// ES:
    asm mov ax, [108]; 6Ch
    printunsign(ax);
    putch(':');
    __emit__(0x26);// ES:
    asm mov ax, [110]; 6Eh
    printunsign(ax);
    asm pop es
}

int printDateTime() {
    ah=0x2A;
    KernelInt();
    printunsign(day);
    putch('.');
    printunsign(month);
    putch('.');
    printunsign(cent);
    printunsign(year);
    putch(' ');

    ah=0x2C;
    KernelInt();
    printunsign(hour);
    putch(':');
    printunsign(min);
    putch(':');
    printunsign(sec);
}
int printVersion() {
    ah=0x30;
    KernelInt();
    asm mov [vAX], ax
    cputs(" KernelVer:");
    printhex4(vAX);
    putch('.');
    vAX=vAX >>8;
    printunsign(vAX);
}
int main() {
    count18h=0;
    //set Int Vec to KERNEL_START
    asm mov dx, KERNEL_START
    ax=0x2518;
    inth 0x21;//new In18h is not connected

    printDateTime();

    cputs(" c18h=");
    printunsign(count18h);
    ah=0x4C;//Terminate
    KernelInt();
}
