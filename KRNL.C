char Version1[]="KERNEL.COM V0.1";
char DOS_ERR=0;
char KERNEL_ERR=0;
unsigned int count18h=0;
unsigned int vAX;

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

int DosInt() {
    inth 0x21;
    __emit__(0x73, 04); //jnc over DOS_ERR++
    DOS_ERR++;
}
int KernelInt() {
    inth 0x18;
    __emit__(0x73, 04); //jnc over KERNEL_ERR++
    KERNEL_ERR++;
}

int KERNEL_START() {
    count18h++;
    asm sti; set int enable

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
        asm cld; clear direction, Up
        asm stosw; ofs in DX to ES:DI
        asm pop ax; get DS
        asm stosw; seg (DS) to ES:DI+2
        asm pop di
        asm pop es
        asm pop ax
        asm sti;set int enable, turn ON int
        asm iret
    }
    if (ah==0x30) {//getDosVer
        ax=0x1E03; //Ver 3.30
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
    cputs(" FUNC 18h not impl.");
    asm iret
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

int GetDate() {
    int year;char month;char day;char dayofweek;
    ah=0x2A;
    DosInt();
    asm mov [bp-2], cx; year
    asm mov [bp-4], dh; month
    asm mov [bp-6], dl; day
    asm mov [bp-8], al; dayofweek
    printunsign(dayofweek);
    putch(':');
    printunsign(day);
    putch('.');
    printunsign(month);
    putch('.');
    printunsign(year);
    putch(' ');
}
int RTCDate() {
    char year;char month;char day;char cent;
    cputs(" RTC:");
    ah=4;
    inth 0x1A;
    __emit__(0x73, 04); //jnc over KERNEL_ERR++
    KERNEL_ERR++;

    asm mov [bp-2], cl; year
    asm mov [bp-4], dh; month
    asm mov [bp-6], dl; day
    asm mov [bp-8], ch; cent
    if (KERNEL_ERR > 0) cputs("ERROR no RTC");
//    printunsign(day);
    printhex8(day);
    putch('.');
//    printunsign(month);
    printhex8(month);
    putch('.');
    printhex8(cent);
//    printunsign(year);
    printhex8(year);
    putch(' ');
}

char datestr[20];
int Int1ADate(char *s) {
    char year;char month;char day;char y20;
    ah=4;
    inth 0x1A;
    __emit__(0x73, 04); //jnc over KERNEL_ERR++
    KERNEL_ERR++;
    asm mov [bp-2], cl; year
    asm mov [bp-4], dh; month
    asm mov [bp-6], dl; day
    asm mov [bp-8], ch; y20

  *s=year / 10; *s=*s+'0'; s++;
  *s=year % 10; *s=*s+'0'; s++;
  *s='.'; s++;
  *s=month/ 10; *s=*s+'0'; s++;
  *s=month% 10; *s=*s+'0'; s++;
  *s='.'; s++;
  *s=day  / 10; *s=*s+'0'; s++;
  *s=day  % 10; *s=*s+'0'; s++;
  *s=' '; s++;
  *s=0;
}

int GetTime() {
    char hour; char min; char sec; char h100;
    ah=0x2C;
    DosInt();
    asm mov [bp-2], ch; hour
    asm mov [bp-4], cl; min
    asm mov [bp-6], dh; sec
    asm mov [bp-8], dl; h100
    printunsign(hour);
    putch(':');
    printunsign(min);
    putch(':');
    printunsign(sec);
    putch('-');
    printunsign(h100);
}
int GetTicker() {
    cputs(" GetTi.LO/HI:");
    ah=0;
    inth 0x1A;
    printunsign(dx);
    putch(':');
    printunsign(cx);
}
int BiosTicks() {
    cputs(" BiosTi.LO/HI:");
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

int main() {
    count18h=0;
    //set Int Vec to KERNEL_START
    asm mov dx, KERNEL_START
    ax=0x2518;
//    DosInt();
    KernelInt();

    GetDate();
    RTCDate();
    Int1ADate(datestr);
    cputs(datestr);
    GetTime();
    GetTicker();
    BiosTicks();
//    cputs(datestr);
//    putch(' ');

/*    GetIntVec(0x18);
    cputs("Int18h=");
    printhex16(VecOldSeg);
    putch(':');
    printhex16(VecOldOfs);
*/

/*
    ah=0x30;
    KernelInt();
    asm mov [vAX], ax
    cputs(" KernelVer:");
    printhex4(vAX);
    putch('.');
    vAX=vAX >>8;
    printunsign(vAX);
*/
//    ah=0x99;//test error function not found
//    KernelInt();

    cputs(" c18h=");
    printunsign(count18h);
}
