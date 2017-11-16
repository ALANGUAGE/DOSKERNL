char Version1[]="CMD V0.5";//Command.com for 1OS
        
int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }
int putch(char c)  {if (c==10) {al=13; writetty();} al=c; writetty(); }
int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }

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


int getch()  { ah=0x10; __emit__(0xCD,0x16); }
int waitkey(){ ah=0x11; __emit__(0xCD,0x10); __emit__(0x74,0xFA); }
int GetKey() {
    int i; 
    waitkey();
    i=getch() & 255; 
    if(i==0)i=getch()+256; 
        ax=i;
}
int getche() { GetKey(); writetty();}


char par_count=0;
char *par1;
char *par2;
char *par3;
        
int DOS_ERR=0;        
int DOS_NoBytes;        //number of bytes read (0 or 1)
char DOS_ByteRead;      //the byte just read by DOS
        
int DosInt() {
    __emit__(0xCD,0x21);//int 0x21;
    __emit__(0x73, 04); //ifcarry DOS_ERR++;
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
    __asm{lea dx, [bp+4]}; /* = *n */  
//    dx=n;
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
    unsigned int i; 
    i=0;
    while (*s) { 
        c=*s; 
        c-=48; 
        i=i*10; 
        i=i+c; 
        s++; 
        }  
    return i; 
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
    cputs(par2);
    cputs(":par2 "); 
    prunsign(i);
    mdump(i, 120);
    putch(10);      
}

char FNBuf[64];
char Pfad[]="*.*";
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
    si= &FNBuf; 
    dl=0;  
    ax=0x4700;//get current directory 
    DosInt(); 
    if (DOS_ERR) {
        cputs(" error reading directory");
        return;
    }
    cputs("Current directory: "); 
    cputs(FNBuf); 
    putch(10);
 
    setdta(direcord);
      
    ffirst(Pfad);
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
    j=fnext(Pfad);  
    } while (j!=18);
    putch(10);    
}


char memSignature; 
unsigned int memOwner; 
unsigned int memSize;
unsigned int vES; 
unsigned int vBX; 

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
        c=GetKey();  
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

char Info1[]=" commands: help,exit,cls,type,mem,dir,dump (adr)";
//dos,exec,fn, *.COM

int dohelp() { 
    unsigned int i;   
    cputs(Version1);
//    rdump();
    cputs(Info1);   putch(10); 
}

char inp_buf[81]; 

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
//    if(eqstr(par1,"DOS" )){dodos(); return;}
//    if(eqstr(par1,"EXEC")){exec1 ();return;}
//    if(eqstr(par1,"FN"  )){doFN();  return;}
//    extrinsic(inp_buf);
}


int get_cmd(){
    *inp_buf=0;
    DOS_ERR=0;
    putch(':');
    Prompt1(inp_buf);
    putch(10);
}

int main() {
    dohelp();
    do { 
        get_cmd(); 
        par_count=getpar(inp_buf);
        intrinsic(); 
        } 
    while(1);
}
