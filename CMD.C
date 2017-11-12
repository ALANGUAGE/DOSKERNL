char Version1[]="CMD V0.5";//Command.com for 1OS

int DOS_ERR=0;
char inp_buf[81];

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

int DosInt() {
    __emit__(0xCD,0x21);//inth 0x21;
    __emit__(0x73, 04); //ifcarry DOS_ERR++;
    DOS_ERR++;
}
int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }
int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
int readRL(char *s, int fd, int len){
    dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  cx=1; bx=fd; ax=0x4000; DosInt(); }


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

int isin(char *s, char c) { 
    while(*s) { 
        if (*s==c) return s; 
            s++;
        }  
    return 0;
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
int head1(char *s) {
    while(*s >= 'A') s++;     
    *s=0; 
}


int Prompt1(unsigned char *s) {
    char c; 
    unsigned char *starts;
    starts=s;  
    do { 
        c=GetKey();  
        if (c == 27)    exitR(1);
        if (c==8) {
            if (s > starts){
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

char Info1[]=" commands: help,exit,cls";
//char Info1[]="CMD commands: cls,dir,dos,exit,type,mem,dump,help";
char Info2[]="exec,fn,down,co,unreal,un,test,  *.COM ";

int dohelp() { 
    unsigned int i;   
    cputs(Version1);
//    rdump();
    cputs(Info1);   putch(10); 
//    cputs(Info2);
}

int intrinsic(char *t) {  
    char s[81];  
    char c; int i;
    DOS_ERR=0;    
    while (*t == ' ') t++;
    strcpy(s, t); 
    toupper(s);   
    head1(s);
    if(eqstr(s,"HELP")){dohelp();return;}
    if(eqstr(s,"EXIT"))exitR(0);
    if(eqstr(s,"CLS" )){clrscr();return;}
//    if(eqstr(s,"DIR" )){dir1();return;}
//    if(eqstr(s,"DOS" )){dodos(); return;}
//    if(eqstr(s,"TYPE")){dotype();return;}
//    if(eqstr(s,"MEM" )){domem(); return;}
//    if(eqstr(s,"DUMP")){dodump();return;}
//    if(eqstr(s,"EXEC")){exec1 ();return;}
//    if(eqstr(s,"FN"  )){doFN();  return;}
//    if(eqstr(s,"DOWN")){dodown();return;}
//    if(eqstr(s,"CO"  )){doco();  return;}
//    if(eqstr(s,"UNREAL")){dounreal();  return;}
//    if(eqstr(s,"UN")){doun();  return;}  
//    if(eqstr(s,"TEST")){test();  return;}
//    extrinsic(inp_buf);
}


int get_cmd(char *s){
    inp_buf=0;
    DOS_ERR=0;
    putch(':');
    Prompt1(inp_buf);
    putch(10);
}

int main() {
    dohelp();
    do { 
        get_cmd(inp_buf); 
        intrinsic(inp_buf); 
        } 
    while(1);
}
