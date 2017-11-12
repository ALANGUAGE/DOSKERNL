// AR.C Archive
//int DOS_ERR=0;  char ext;  // Extended Key
                        //  at - pipe  \   '   "   ;   ,   [   {        PROMPT.C
/*unsigned char KeybGer1[]={64,45,124,92, 39, 34, 59, 58, 91,123};
  unsigned char Keybtmp1[]="yYzZ#^&*()_\]}/?><";
                        //   "  \   >  <   �   �   �   �   �   �
/*unsigned char KeybGer2[]={34,92, 62,60,132,142,148,153,129,154};
  unsigned char Keybtmp2[]="zZyY$&/()=?<+*-_:;";
  char direcord[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};// do not change
/*char dirattr=0;   int  dirzeit=0;  int  dirdatum=0;
  int dirbytlo=0; int  dirbythi=0; char dirdatnam[]={0,0,0,0,0,0,0,0,0,0,0,0,0};
 int pos;   char inp_buf[81];    */
int writetty()     { ah=0x0E; bx=0; inth 0x10; }                   //  BSCREEN.C
int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
int mkneg(int n) { n; __asm {neg ax} }
int prunsign(unsigned int n) { unsigned int e;
  if ( _ n >= 10) { e=n/10; prunsign(e); } n=n%10; n+='0'; putch(n); }
int pint (int n){int e; if(n<0) {  prc('-');  n=mkneg(n); }
  if (n >= 10) {e=n/10;  pint(e);}  n=n%10; n=n+'0'; putch(n); }
int printint5(unsigned int j)  {
  if (j<10000) putch(32); if (j<1000) putch(32);  if (j<100) putch(32);
   if (j<10) putch(32);  prunsign(j); }
int printhex8(unsigned int c) { unsigned int nib;
  nib = c >> 4; nib += 48; if (nib > 57)nib += 7; putch(nib);
  nib = c & 15; nib += 48; if (nib > 57)nib += 7; putch(nib); }
int printhex16(unsigned int i) {unsigned int half;
  half = i >>  8; printhex8(half); half = i & 255; printhex8(half); }
int getch()  { ah=0x10; inth 0x16; }                             //   KEYBOARD.C
int getche() { GetKey(); writetty();}
int waitkey(){ ah=0x11; inth 0x16; __emit__(0x74,0xFA); }
int GetKey() {int i; waitkey();i=getch() & 255; if(i==0)i=getch()+256; ax=i;}

int kbhit()  {ah=0x11; inth 0x16; ifzero return 1; 0; }
int textmode(char c) {/*C80=3,C4350=64*/ al=c; ah=0; inth 0x10;} //    TURBOIO.C
int CrtGetMode() { ah=15; inth 0x10; } // mode=low, y=high
int setcursorsize(int cur)  {ah=1; bx=0; cx=cur;       inth 0x10; }
int getcursorsize() {ah=3; bx=0; inth 0x10; _ ax=cx; }
int gotoxy (char x, char y) {ah=2; bx=0; dh=y; dl=x; inth 0x10; }
int setxy(unsigned int i)   {ah=2; bx=0; dx=i;       inth 0x10; }
int getxy() {ah=3; bx=0; inth 0x10; ax=dx; }  // y=high, x=low
int putxy_c (char x, char y, char c) { gotoxy(x,y); al=c;   writeca(c,7); }
int putxy_ca(char x, char y, char c, char a){ gotoxy(x, y); writeca(c,a); }
int putxy_sa(char x, char y, char *s,char a){ gotoxy(x, y); writstr(s,a); }
int wherex() { getxy() & 255;}
int wherey() { getxy() >>  8;}
int writeca(char c, char a) { ah=9; al=c; bh=0; bl=a; cx=1; inth 0x10; }
int writstr(char *s, char a) { unsigned int curPos; char c;   curPos=getxy();
  while (*s) {c=*s; writeca(c, a); s++; curPos++; setxy(curPos); } }
int putxy_n(char x, char y, int i, char a) { gotoxy(x, y);
  pos=getxy(); putxy_n1(i, a); pos++; }
int putxy_n1(unsigned int n, char a) {unsigned int e;
  if (n >= 10) {e=n/10; putxy_n1(e,a); } n=n%10; n+='0';
  writeca(n, a); pos++; setxy(pos); }
int clrscr()    {ax=0x0600; bh=7; cx=0; dx=0x184F; inth 0x10; gotoxy(0,0);}
int clrscr5080(){ax=0x0600; bh=7; cx=0; dx=0x314F; inth 0x10; gotoxy(0,0);}
int KeybGer(unsigned char c) { unsigned int i;                      //  PROMPT.C
  i=isin(KeybGer1, c);  if (_ i==0) return c; i+=29; c=*i; return c; }
int ReadStr(char *s){char c; do{c=getche();*s=c;s++;}while(c!=13); s--;*s=0;}
int Prompt1(unsigned char *s) {char c; unsigned char *starts;
  starts=s;  do { c=GetKey();  if (c == 27) exitR(1);
    if (c==8) {if (s > starts){s--;putch(8);putch(' ');putch(8);}else putch(7);}
    else { c=KeybGer(c); *s=c; s++; putch(c); }
  } while(c!=13); s--;  *s=0; }
int BoxS(char x1,char y1,char x2,char y2,unsigned char e,unsigned char a)//BOX.C
{ char c;
  if(e) { putxy_ca(x1,y1,218,a); putxy_ca(x2,y1,191,a); }   //Corner up
  else  { putxy_ca(x1,y1,201,a); putxy_ca(x2,y1,187,a); } c=x1+1;
  do{if(e) {putxy_ca(c,y1,196,a); putxy_ca(c,y2,196,a); }   //Line up+down
     else  {putxy_ca(c,y1,205,a); putxy_ca(c,y2,205,a); }
     c++; } while (c < x2); c=y1+1;
  do{if(e) {putxy_ca(x1,c,179,a); putxy_ca(x2,c,179,a); }   //Left, Rigth
     else  {putxy_ca(x1,c,186,a); putxy_ca(x2,c,186,a); }
     c++; } while (c < y2);
  if(e) { putxy_ca(x1,y2,192,a); putxy_ca(x2,y2,217,a); }   //Corner down
  else  { putxy_ca(x1,y2,200,a); putxy_ca(x2,y2,188,a); }  }
int LinieHS(char x1, char y1, char x2, unsigned char e, unsigned char a){char c;
  if(e) { putxy_ca(x1,y1,195,a); putxy_ca(x2,y1,180,a); }  //Corner
  else  { putxy_ca(x1,y1,204,a); putxy_ca(x2,y1,185,a); } c=x1+1;
  do{if(e) putxy_ca(c,y1,196,a); else putxy_ca(c,y1,205,a);//Line
     c++; } while (c < x2);  }
int biostime() { _AX=0x40; _ es=ax; __asm{mov ax, es:6Ch}; }         //    RTC.C
int waitticks(int i) { int w1; int w2; int j;
  j=0;  do { w1=biostime(); do { w2=biostime(); } while (w1 == w2) ;
     j++; } while ( j < i ); }
int bios_wait(int i) { int j;
  _CX=0; _DX=0; _AH=1; inth 0x1A; do { _AH=0; inth 0x1A; _ j=dx;
  } while ( j < i); }
/*BLACK 0,BLUE 1,GREEN 2,CYAN 3,RED 4,MAGENTA 5,BROWN 6,LIGHTGRAY 7
 BLINK 128, INTENSITY + 8, BACKGROUND * 16 (<<4) */
int screen(int x, int y, char c, char attr) {                     //  DIRECTIO.C
  x=x*80; x=x+y; x=x+x; /* y*160+x*2 */  putscreen(c, attr, x);  }
int putscreen(char c, char attr, int loc) {
  __emit__(6); ax=0xB800; _ es=ax; al=c; ah=attr;
  __asm{ mov es:[bp+8], ax};  __emit__(7); /*pop es*/ }             //  STRING.C
int toupper(char *s) {while(*s) {if (*s >= 'a') if (*s <= 'z') *s=*s-32; s++;}}
//int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
int strcpy(char *s, char *t) {do { *s=*t; s++; t++; }
  while (*t!=0); *s=0; return s; }
int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  do { *s=*t; s++; t++; n--; if (*t == 0) n=0; } while (n); *s=0; }
int isin  (char *s, char c) { while(*s) { if (*s==c) return s; s++;}  return 0;}
int instr1(char *s, char c) { while(*s) { if (*s==c) return 1; s++;}  return 0;}
int instr2(char *s, char c) { while(*s) { if (*s==c) return &s; s++;} return 0;}
int digit(char c){ if(c<'0') return 0; if(c>'9') return 0; return 1; }
int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  if (c> 'z') return 0; if (c< '@') return 0;
  if (c> 'Z') { if (c< 'a') return 0; }  return 1; }
int alnum(char c) { if (digit(c)) return 1; if (c=='_') return 1;
  if (c> 'z') return 0; if (c< '@') return 0;
  if (c> 'Z') { if (c< 'a') return 0; }  return 1; }//same as letter  XXXXXXXXX
int eqstr(char *p, char *q) { while(*p) {
    if (*p != *q) return 0; p++; q++; }
    if(*q) return 0; return 1; }
int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
int basename(char *s) { char *p; p=0;
  while (*s) { if (*s == '.') p=s;   s++; } return p; }
int strstr1 (char *s, char *t) { char c; int len; char sc;          /*untested*/
  len=strlen(t); if (len == 0) return 0;
  c=*t;  t++;
  do {  do { sc = *s; s++; if (sc == 0) return 0; } while (sc != c);
    } while (strncmp1 (s, t, len) != 0 );
  s--; return s; }
int strncmp1(char *s, char *t, int n) {                             /*untested*/
  while (*s == *t) {
    if (*s == 0) return 0;  if ( n == 0) return 0;
    s++;  t++;  n--;  }     if (n) return 1;
  return 0; }

int rdump() { unsigned int rax; unsigned int rbx; unsigned int rcs;
  unsigned int res;     _ rax=ax; _ rbx=bx; _ rcs=cs; _ res=es;
  cputs(" Reg: AX="); printhex16(rax);  cputs(",BX="); printhex16(rbx);
  cputs(",CS="); printhex16(rcs);  cputs(",ES="); printhex16(res);putch(' '); }
int dodump() { unsigned int i;
  cputs("Memory dump Startadresse: ");   Prompt1(inp_buf);
  i=atoi(inp_buf); mdump(i, 120); }
int mdump(unsigned char *adr, unsigned int len ) {unsigned char c; int i; int j;
  j=0; while (j < len ) {
    putch(10);  printhex16(adr); putch(':');
    i=0; while (_ i < 16) {putch(' '); c = *adr; printhex8(c);adr++;i++;j++;}
    putch(' '); adr -=16; i=0; while(_ i < 16) {c= *adr; if (c < 32) putch('.');
    else putch(c); adr++; i++; }  }  }

int getchaR(){_ ext=0;ax=0x0C08;inth 0x21; ifzero{ext++; ax=0x0800; inth 0x21;}}
int DosInt() { inth 0x21; ifcarry DOS_ERR++; }
int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
int readRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  cx=1; bx=fd; ax=0x4000; DosInt(); }
int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
int truncR(int fd){dx=0; cx=0; bx=fd; ax=0x4200; DosInt();}
int fcloseR(int fd) {bx=fd; ax=0x3E00; inth 0x21; }
int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
int ffirst(char *s) {dx=s; ah=0x4E; cx=0x1E; DosInt(); }
int fnext (char *s) {dx=s; ah=0x4F; cx=0x1E; DosInt(); }
int GetDate(char *s) { int Jahr; char Monat; char Tag; char Wochentag;
  ah=0x2A; DosInt();
  _ Jahr=cx;  _ Monat=dh; _ Tag=dl; _ Wochentag=al; Jahr=Jahr % 100;
  *s=Jahr / 10; *s=*s+'0'; s++; *s=Jahr % 10; *s=*s+'0'; s++;
  *s=Monat/ 10; *s=*s+'0';s++;  *s=Monat% 10; *s=*s+'0'; s++;
  *s=Tag  / 10; *s=*s+'0';s++;  *s=Tag  % 10; *s=*s+'0'; s++;  *s=0;  }
int tell1(int fd) { /*filelen: IN CX:DX, OUT DX:AX, return low */
  bx=fd; cx=0; dx=0;  ax=0x4202; DosInt(); }
int seek2(int base, int fd, int hi2, int lo2) {
  dx=lo2; cx=hi2; bx=fd; al=base; ah=0x42; DosInt();
  _ lo2=ax; _ hi2=dx; }

int atoi(char *s) { char c; unsigned int i; i=0;
  while (*s) { c=*s; c-=48; i=i*10; i=i+c; s++; }  return i;  }
int uitoaR(unsigned int n, char *s) { int i;  int re;
  i=0;  while(i<5) { *s = '0'; s++; i++; }   *s = 0;   s--;
  do { re = n % 10;  *s = re + '0';  n = n / 10;  s--;  } while (n > 0); }
int ultoaR(int lo1, int hi1, char *s ) {
  _DX = hi1; _AX = lo1; _DI=s;   __asm{
  add di,10     ;add statt mov
  mov byte ptr [di+1], 0
  mov si,10     ;Divisor
  mov bx,ax     ;AX retten
  div1:
  mov ax,dx     ;f�r erste Division
  xor dx,dx
  or  ax,ax     ;Ende High-Teil
  jz  div2
  div si
  div2:
  mov cx,ax     ;AX retten High-Teil
  mov ax,bx     ;Low-Anteil
  mov bx,cx     ;BX = Wert High
  div si
  mov cl,dl     ;DX erhalten
  add cl,48
  mov [di],cl   ;statt mov asc_str[di],cl
  dec di
  mov dx,ax     ;Anteil Low
  mov cx,dx     ;DX zwischenspeichern
  mov dx,bx     ;DX = High
  mov bx,cx     ;BX = Low
  mov ax,dx     ;AX = High
  or  ax,bx     ;Ende?
  jnz div1
  inc di        ; neu eingef�hrt
  mov ax,di
}  }
int ultoa2(unsigned int l, unsigned int h, char *s) { int i;
  i=0;  while(i<10) { *s = '0'; s++; i++; }   *s = 0;   s--;
  asm mov eax, dword ptr [bp+4]  ; l   /* edx:eax DIV ebx = eax Rest edx */
  asm ultoaL1:
  asm xor edx, edx
  asm mov ebx, 10
  asm div ebx
  asm add dl, 48
;  asm mov [bp+6], dl  ; s
  asm mov bx, [bp+6]
  asm mov [bx], dl
  asm dec  word ptr	[bp+6]  ; s--;
  asm cmp eax, 0
  asm jnz ultoaL1
  asm mov ax, [bp+6]
}
/*char LastFunctionB;  int LastFunction() {&LastFunctionB;}
/* while(expr) stmt; do stmt while(expr); FOR: i=0; while(i<10){stmt; i++;}*/
/* DIV SI= dx:ax/si= ax,Rest dx;  dividend / divisor = quotient, remainder */
//
