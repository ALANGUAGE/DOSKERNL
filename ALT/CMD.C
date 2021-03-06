char Version1[]="CMD V0.5.1";//Command.com for 1OS
//--------------------------- Bios Routines I/O ---------------------
int writetty()     {//char in AL
    ah=0x0E;
    asm push bx
    bx=0;     //page in BH
    inth 0x10;
    asm pop bx
}
int putch(char c)  {
    if (c==10)  {// LF
        al=13;   // CR, write CR first and then LF
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

int gotoxy (char x, char y) {
    ah=2;
    bx=0;
    dh=y;
    dl=x;
    __emit__(0xCD,0x10);
}
int clrscr()    {
    ax=0x0600;
    bh=7;
    cx=0;
    dx=0x184F;
    __emit__(0xCD,0x10);
    gotoxy(0,0);
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

unsigned int vAX;
unsigned int vBX;
unsigned int vES;

char par_count=0;
char *par1;
char *par2;
char *par3;

int DOS_ERR=0;
int DOS_NoBytes;        //number of bytes read (0 or 1)
char DOS_ByteRead;      //the byte just read by DOS

int DosInt() {
    inth 0x21;
    __emit__(0x73, 04); //jnc over DOS_ERR++
    DOS_ERR++;
}
int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }
int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
int readRL(char *s, int fd, int len){
    dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
int fputcR(char *n, int fd) {
//    dx=n;
    __asm{lea dx, [bp+4]}; /* = *n */
    cx=1;
    bx=fd;
    ax=0x4000;
    DosInt();
}
int setdta(char *s) {dx=s; ah=0x1A; __emit__(0xCD,0x21); }
int ffirst(char *s) {dx=s; ah=0x4E; cx=0x1E; DosInt(); }
int fnext (char *s) {dx=s; ah=0x4F; cx=0x1E; DosInt(); }

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

int prunsign(unsigned int n) {
    unsigned int e;
    if (n >= 10) {
        e=n/10;
        prunsign(e);
        }
    n=n%10;
    n+='0';
    putch(n);
}
int letter(char c) {
  if (c> 'z') return 0;
  if (c< 'A') return 0;
  if (c> 'Z') { if (c< 'a') return 0; }
  return 1;
}
int digit(char c){
    if(c<'0') return 0;
    if(c>'9') return 0;
    return 1;
}
int strlen(char *s) { int c;
    c=0;
    while (*s!=0) {s++; c++;}
    return c;
    }
int strcpy(char *s, char *t) {
    do { *s=*t; s++; t++; }
    while (*t!=0);
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
int toupper(char *s) {
    while(*s) {
        if (*s >= 'a') if (*s <= 'z') *s=*s-32;
            s++;
    }
}
int atoi(char *s) {
    char c;
    unsigned int i; unsigned int j;
    i=0;
    while (*s) {
        c=*s;
        c-=48;
        i=i*10;
        j=0;
        j=c;//c2i
        i=i+j;
        s++;
        }
    return i;
}


int setblock(unsigned int i) {
    DOS_ERR=0;
    bx=i;
    ax=cs;
    es=ax;
    ax=0x4A00;
    DosInt();
//modify memory Allocation. IN: ES=Block Seg, BX=size in para
    asm mov [vAX], ax; vAX=ax;
    asm mov [vBX], bx; vBX=bx;
    if (DOS_ERR) cputs(" ***Error SetBlock***");
//    7=MCB destroyed, 8=Insufficient memory, 90=Invalid block address
//    BX=Max mem available, if CF & AX=8
//    cputs(" AX:"); printhex16(vAX);
//    cputs(", BX:"); printhex16(vBX);
}

int Env_seg=0; //Take over Master Environment, do not change
int Cmd_ofs=0;     int Cmd_seg=0;
int FCB_ofs1=0x5C; int FCB_seg1=0;
int FCB_ofs2=0x6C; int FCB_seg2=0;
char FCB1=0; char FCB1A[]="           ";
char FCB1B[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
char FCB2=0; char FCB2A[]="           ";
char FCB2B[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
// structure until here
char FNBuf[64];
char inp_buf[81];

int getcurdir() {
    si=&FNBuf;
    dl=0;
    ah=0x47;
    DosInt();
    asm mov [vAX], ax; vAX=ax;
    asm mov [vBX], bx; vBX=bx;
    if (DOS_ERR) cputs(" ***Error GetCurrentDir***");
}

    int stkseg;
    int stkptr;
int exec1(char *Datei1, char *ParmBlk, char *CmdLine1) {
    putch(10);
    __emit__(0x26,0xA1,0x2C,0);//asm mov ax, [es:2ch]

    asm mov [Env_seg], ax
    Cmd_ofs = CmdLine1;
    ax      =es;
    asm mov [Cmd_seg],  ds
    asm mov [FCB_seg1], ax
    asm mov [FCB_seg2], ax
    asm mov [stkseg],   ss
    asm mov [stkptr],   sp
    dx=Datei1;
    bx=ParmBlk;
    ax=0x4B00;
    DosInt();
    asm mov [vAX], ax
    ss=stkseg;
    sp=stkptr;
    if (DOS_ERR) {
        cputs("*****EXEC ERROR Code: ");
        printhex16(vAX);
}       }

char inp_len=0;

int dodos() {
    char *p; int h;
    strcpy(inp_buf, " ");
    h=strlen(inp_buf);
    inp_len=h & 255;
    p=&inp_buf+h;
    *p=0;
    cputs("Before DOS: ");
    cputs(inp_buf);
    exec1("Z:\COMMAND.COM", &Env_seg, &inp_len);
}

int extrinsic(char *s) {
    char *p;
    inp_len=strlen(inp_buf);
    if (inp_len == 0) return;
    p=&inp_buf+inp_len;
    *p=0;
    waitkey();
    exec1(inp_buf, &Env_seg, &inp_len);
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

int dodump() {
    unsigned int i;
    i=atoi(par2);
    mdump(i, 120);
    putch(10);
}

char path[]="*.*";
char direcord[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};//21 do not change
char dirattr=0;
int  dirtime=0;
int  dirdate=0;
int  dirlenlo=0;
int  dirlenhi=0;
char dirdatname[]={0,0,0,0,0,0,0,0,0,0,0,0,0};//13 structure until here

int dodir() {
    int j;
    char c;
    getcurdir();
    cputs("Current directory: ");
    cputs(FNBuf);
    putch(10);

    setdta(direcord);

    ffirst(path);
    if (DOS_ERR) {
        cputs("Empty directory ");
        return;
        }
    cputs("Name             Date   Time Attr   Size");
  do {
        putch(10);
        cputs(dirdatname);
        j=strlen(dirdatname);
        do {
            putch(' ');
            j++;
            } while (j<13);

        j=dirdate & 31;
        if (j<10) putch(' ');
        prunsign(j);
        putch('.');

        j=dirdate >> 5;
        j&=  15;
        if (j<10) putch('0');
        prunsign(j);
        putch('.');

        j=dirdate >> 9;
        j+=  80;
        if (j>=100) j-=100;
        if (j<10) putch('0');
        prunsign(j);
        putch(' ');
        putch(' ');

        j=dirtime  >>11;
        if (j<10) putch(' ');
        prunsign(j);
        putch(':');

        j=dirtime  >> 5;
        j&=  63;
        if (j<10) putch('0');
        prunsign(j);
        putch(' ');

        c = dirattr & 32;
        if (c) putch('A'); else putch(' ');
        c = dirattr & 16;
        if (c) putch('D'); else putch(' ');
        c = dirattr & 8;
        if (c) putch('V'); else putch(' ');
        c = dirattr & 4;
        if (c) putch('S'); else putch(' ');
        c = dirattr & 2;
        if (c) putch('H'); else putch(' ');
        c = dirattr & 1;
        if (c) putch('R'); else putch(' ');

        if (dirlenhi) {
            dirlenlo=dirlenlo >>10;
            dirlenhi=dirlenhi << 6;
            dirlenhi=dirlenhi+dirlenlo;
            putch(' ');
            prunsign(dirlenhi);
            cputs(" KB");
            }
        else {
            putch(' ');
            prunsign(dirlenlo);
            }
    j=fnext(path);
    } while (j!=18);
    putch(10);
}


char memSignature;
unsigned int memOwner;
unsigned int memSize;

int domem() {
    unsigned int i;
    char c;
    ah=0x52;//DOS list of lists
    asm int 33 ; // out= ES:BX ptr to invars
    asm mov [vBX], bx
//    asm mov es, [es:bx-2]//first memory control block
    __emit__(0x26,0x8E,0x47,0xFE);
    asm mov [vES], es
    do {
        putch(10);
        cputs("Start:");
        printhex16(vES);
        if (vES >= 0xA000) cputs(" MCB in UMB");
//        asm mov al, [es:0]// M or Z
        __emit__(0x26,0xA0,0,0);
        asm mov [memSignature], al
//        cputs(", ");
//        putch(memSignature);
//        asm mov ax, [es:1]//program segment prefix
        __emit__(0x26,0xA1,1,0);
        asm mov [memOwner], ax
        cputs(", PSP:");
        printhex16(memOwner);
//        asm mov ax, [es:3]//size in para
        __emit__(0x26,0xA1,3,0);
        asm mov [memSize], ax
        cputs(", Size:");
        printhex16(memSize);
        if (memOwner == 0) cputs(" free");
        if (memOwner == 8) cputs(" DOS ");
        i=memOwner-vES;
    vES = vES + memSize;
    vES++;
    asm mov es, vES
    es = vES;
    }
    while (memSignature == 'M');
    putch(10);
}

int dotype() {
    int fdin; int i;
    fdin=openR(par2);
    if (DOS_ERR) {
        cputs("file missing");
        putch(10);
        return;
        }
    do {
        DOS_NoBytes=readR(&DOS_ByteRead, fdin);
        putch(DOS_ByteRead);
        }
        while (DOS_NoBytes);
    fcloseR(fdin);
}

int Prompt1(unsigned char *s) {
    char c;
    unsigned char *startstr;
    startstr=s;
    do {
        c=getkey();
        if (c == 27)    exitR(1);//good bye
        if (c==8) {
            if (s > startstr){
                s--;
                putch(8);
                putch(' ');
                putch(8);
                }
                else putch(7);
            }
            else {
                *s=c;
                s++;
                putch(c);
            }
    } while(c!=13);
    s--;
    *s=0;
}

char Info1[]=" commands: help,exit,cls,type,mem,dir,dump (adr),exec,dos,*COM";

int dohelp() {
    unsigned int i;
    cputs(Version1);
    cputs(Info1);
    putch(10);
}


int getpar(char *t) {
    while (*t == 32) t++;
    if (*t<=13) return 0;

    par1=t;
    while(*t >= 33) t++;
    if (*t==0) return 1;
    *t=0;
    t++;
    while (*t == 32) t++;
    if (*t<=13) return 1;

    par2=t;
    while(*t >= 33) t++;
    if (*t==0) return 2;
    *t=0;
    t++;
    while (*t == 32) t++;
    if (*t<=13) return 2;

    par3=t;
    while(*t >= 33) t++;
    *t=0;
    return 3;
}

int intrinsic() {
    toupper(par1);
    if(eqstr(par1,"HELP")){dohelp();return;}
    if(eqstr(par1,"EXIT"))exitR(0);
    if(eqstr(par1,"CLS" )){clrscr();return;}
    if(eqstr(par1,"TYPE")){dotype();return;}
    if(eqstr(par1,"MEM" )){domem(); return;}
    if(eqstr(par1,"DIR" )){dodir();return;}
    if(eqstr(par1,"DUMP")){dodump();return;}
    if(eqstr(par1,"DOS" )){dodos(); return;}
    if(eqstr(par1,"EXEC")){exec1 ();return;}
    extrinsic(inp_buf);
}


int get_cmd(){
    *inp_buf=0;
    DOS_ERR=0;
    putch(':');
    Prompt1(inp_buf);
    putch(10);
}

int main() {
    setblock(4096);
    dohelp();
    do {
        get_cmd();
        par_count=getpar(inp_buf);
        intrinsic();
        }
    while(1);
}
