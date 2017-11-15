;PLA compiler A.COM V0.9.5, Input: CMD.C, Output: CMD.S
org  256 
jmp main
;-1 char Version1[]="CMD V0.5";//Command.com for 1OS

Version1 db "CMD V0.5",0
;-2         

;-3 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }

writetty: PROC
 mov  ah, 14
 mov  bx, 0
 db 205,16
;-4 int putch(char c)  {if (c==10) {al=13; writetty();} al=c; writetty(); }

 ret
ENDP
putch: PROC;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
 mov  al, 13
 call writetty
.putch1:
 mov  al, [bp+4]
 call writetty
;-5 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
 LEAVE
 ret
ENDP
cputs: PROC;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
 inc  word[bp+4]
 jmp .cputs2
.cputs3:
;-6 

;-7 int gotoxy (char x, char y) {
 LEAVE
 ret
ENDP
gotoxy: PROC
;-8     ah=2; 
;
 ENTER  0,0
 mov  ah, 2
;-9     bx=0; 

 mov  bx, 0
;-10     dh=y; 

 mov  dh, [bp+6]
;-11     dl=x; 

 mov  dl, [bp+4]
;-12     __emit__(0xCD,0x10); 

 db 205,16
;-13 }

;-14 int clrscr()    {
 LEAVE
 ret
ENDP
clrscr: PROC
;-15     ax=0x0600; 

 mov  ax, 1536
;-16     bh=7; 

 mov  bh, 7
;-17     cx=0; 

 mov  cx, 0
;-18     dx=0x184F; 

 mov  dx, 6223
;-19     __emit__(0xCD,0x10); 

 db 205,16
;-20     gotoxy(0,0);

 push 0
 push 0
 call gotoxy
 add  sp, 4
;-21 }

;-22 

;-23 

;-24 int getch()  { ah=0x10; __emit__(0xCD,0x16); }

 ret
ENDP
getch: PROC
 mov  ah, 16
 db 205,22
;-25 int waitkey(){ ah=0x11; __emit__(0xCD,0x10); __emit__(0x74,0xFA); }

 ret
ENDP
waitkey: PROC
 mov  ah, 17
 db 205,16
 db 116,250
;-26 int GetKey() {

 ret
ENDP
GetKey: PROC
;-27     int i; 

;-28     waitkey();
;
 ENTER  2,0
 call waitkey
;-29     i=getch() & 255; 

 call getch
 and ax, 255
 mov [bp-2], ax
;-30     if(i==0)i=getch()+256; 

 mov ax, [bp-2]
 cmp ax, 0
 jne .GetKey4
 call getch
 add ax, 256
 mov [bp-2], ax
;-31         ax=i;

.GetKey4:
 mov  ax, [bp-2]
;-32 }

;-33 int getche() { GetKey(); writetty();}
 LEAVE
 ret
ENDP
getche: PROC
 call GetKey
 call writetty
;-34 

;-35 

;-36 char par_count=0;

 ret
ENDP
par_count db 0
;-37 char *par1;

par1 dw 0
;-38 char *par2;

par2 dw 0
;-39 char *par3;

par3 dw 0
;-40         

;-41 int DOS_ERR=0;        

DOS_ERR dw 0
;-42 int DOS_NoBytes;        //number of bytes read (0 or 1)

DOS_NoBytes dw 0
;-43 char DOS_ByteRead;      //the byte just read by DOS

DOS_ByteRead db 0
;-44         

;-45 int DosInt() {

DosInt: PROC
;-46     __emit__(0xCD,0x21);//int 0x21;

 db 205,33
;-47     __emit__(0x73, 04); //ifcarry DOS_ERR++;

 db 115,4
;-48     DOS_ERR++;

 inc  word[DOS_ERR]
;-49 }

;-50 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }

 ret
ENDP
openR: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt
;-51 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
ENDP
creatR: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt
;-52 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
 LEAVE
 ret
ENDP
fcloseR: PROC;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 call DosInt
;-53 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
 LEAVE
 ret
ENDP
exitR: PROC;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 call DosInt
;-54 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
 LEAVE
 ret
ENDP
readR: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt
;-55 int readRL(char *s, int fd, int len){
 LEAVE
 ret
ENDP
readRL: PROC
;-56     dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt
;-57 int fputcR(char *n, int fd) { 
 LEAVE
 ret
ENDP
fputcR: PROC
;-58     __asm{lea dx, [bp+4]}; /* = *n */  
;
 ENTER  0,0
lea dx, [bp+4]
;-59 //    dx=n;

;-60     cx=1; 

 mov  cx, 1
;-61     bx=fd; 

 mov  bx, [bp+6]
;-62     ax=0x4000; 

 mov  ax, 16384
;-63     DosInt(); 

 call DosInt
;-64 }

;-65 int setdta(char *s) {dx=s; ah=0x1A; __emit__(0xCD,0x21); }
 LEAVE
 ret
ENDP
setdta: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ah, 26
 db 205,33
;-66 int ffirst(char *s) {dx=s; ah=0x4E; cx=0x1E; DosInt(); }
 LEAVE
 ret
ENDP
ffirst: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ah, 78
 mov  cx, 30
 call DosInt
;-67 int fnext (char *s) {dx=s; ah=0x4F; cx=0x1E; DosInt(); }
 LEAVE
 ret
ENDP
fnext: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ah, 79
 mov  cx, 30
 call DosInt
;-68 

;-69 int printhex4(unsigned char c) {
 LEAVE
 ret
ENDP
printhex4: PROC
;-70     c += 48;
;
 ENTER  0,0
 add  byte[bp+4], 48
;-71     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex45
 add  byte[bp+4], 7
;-72     putch(c);

.printhex45:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-73 }

;-74 int printhex8a(unsigned char c) {
 LEAVE
 ret
ENDP
printhex8a: PROC
;-75     unsigned char nib;

;-76     nib = c >> 4; printhex4(nib);
;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-77     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-78 }

;-79 int printhex16(unsigned int i) {
 LEAVE
 ret
ENDP
printhex16: PROC
;-80     unsigned int half;

;-81     half = i >>  8; printhex8a(half);
;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2
;-82     half = i & 255; printhex8a(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2
;-83 }

;-84 

;-85 int prunsign(unsigned int n) { 
 LEAVE
 ret
ENDP
prunsign: PROC
;-86     unsigned int e;

;-87     if (n >= 10) { 
;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .prunsign6
;-88         e=n/10; 

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-89         prunsign(e); 

 push word [bp-2]
 call prunsign
 add  sp, 2
;-90         } 

;-91     n=n%10; 

.prunsign6:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-92     n+='0'; 

 add  word[bp+4], 48
;-93     putch(n); 

 push word [bp+4]
 call putch
 add  sp, 2
;-94 }

;-95 int letter(char c) {
 LEAVE
 ret
ENDP
letter: PROC
;-96   if (c> 'z') return 0;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 122
 jle .letter7
 mov ax, 0
 jmp .retnletter
;-97   if (c< 'A') return 0;

.letter7:
 mov al, [bp+4]
 cmp al, 65
 jge .letter8
 mov ax, 0
 jmp .retnletter
;-98   if (c> 'Z') { if (c< 'a') return 0; }

.letter8:
 mov al, [bp+4]
 cmp al, 90
 jle .letter9
 mov al, [bp+4]
 cmp al, 97
 jge .letter10
 mov ax, 0
 jmp .retnletter
.letter10:
;-99   return 1;

.letter9:
 mov ax, 1
 jmp .retnletter
;-100 }

;-101 int digit(char c){

 .retnletter: LEAVE
 ret
ENDP
digit: PROC
;-102     if(c<'0') return 0;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit11
 mov ax, 0
 jmp .retndigit
;-103     if(c>'9') return 0;

.digit11:
 mov al, [bp+4]
 cmp al, 57
 jle .digit12
 mov ax, 0
 jmp .retndigit
;-104     return 1;

.digit12:
 mov ax, 1
 jmp .retndigit
;-105 }

;-106 int strlen(char *s) { int c;

 .retndigit: LEAVE
 ret
ENDP
strlen: PROC
;-107     c=0;
;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-108     while (*s!=0) {s++; c++;}

.strlen13:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen14
 inc  word[bp+4]
 inc  word[bp-2]
;-109     return c;

 jmp .strlen13
.strlen14:
 mov ax, [bp-2]
 jmp .retnstrlen
;-110     }

;-111 int strcpy(char *s, char *t) {

 .retnstrlen: LEAVE
 ret
ENDP
strcpy: PROC
;-112     do { *s=*t; s++; t++; }
;
 ENTER  0,0
.strcpy15:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-113     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy16
 jmp .strcpy15
.strcpy16:
;-114     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-115     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-116 }

;-117 int eqstr(char *p, char *q) {

 .retnstrcpy: LEAVE
 ret
ENDP
eqstr: PROC
;-118     while(*p) {
;
 ENTER  0,0
.eqstr17:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr18
;-119         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr19
 mov ax, 0
 jmp .retneqstr
;-120             p++;

.eqstr19:
 inc  word[bp+4]
;-121             q++;

 inc  word[bp+6]
;-122         }

;-123     if(*q) return 0;

 jmp .eqstr17
.eqstr18:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr20
 mov ax, 0
 jmp .retneqstr
;-124     return 1;

.eqstr20:
 mov ax, 1
 jmp .retneqstr
;-125 }

;-126 int toupper(char *s) {

 .retneqstr: LEAVE
 ret
ENDP
toupper: PROC
;-127     while(*s) {
;
 ENTER  0,0
.toupper21:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper22
;-128         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  .toupper23
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  .toupper24
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
;-129             s++;

.toupper24:
.toupper23:
 inc  word[bp+4]
;-130     }

;-131 }

 jmp .toupper21
.toupper22:
;-132 

;-133 

;-134 char FNBuf[64];
 LEAVE
 ret
ENDP
section .bss
absolute 25000
FNBuf resb 64
section .text
;-135 char Pfad[]="*.*";

Pfad db "*.*",0
;-136 char direcord[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};//21 do not change

direcord db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;-137 char dirattr=0;   

dirattr db 0
;-138 int  dirtime=0;  

dirtime dw 0
;-139 int  dirdate=0;

dirdate dw 0
;-140 int  dirlenlo=0;  

dirlenlo dw 0
;-141 int  dirlenhi=0; 

dirlenhi dw 0
;-142 char dirdatname[]={0,0,0,0,0,0,0,0,0,0,0,0,0};//13 structure until here

dirdatname db 0,0,0,0,0,0,0,0,0,0,0,0,0
;-143 

;-144 int dodir() { 

dodir: PROC
;-145     int j;

;-146     char c;

;-147     si= &FNBuf; 
;
 ENTER  4,0
 mov  si, FNBuf
;-148     dl=0;  

 mov  dl, 0
;-149     ax=0x4700;//get current directory 

 mov  ax, 18176
;-150     DosInt(); 

 call DosInt
;-151     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dodir25
;-152         cputs(" error reading directory");

 push dodir_0
 call cputs
 add  sp, 2
;-153         return;

 jmp .retndodir
;-154     }

;-155     cputs("Current directory: "); 

.dodir25:
 push dodir_1
 call cputs
 add  sp, 2
;-156     cputs(FNBuf); 

 lea  ax, [FNBuf]
 push ax
 call cputs
 add  sp, 2
;-157     putch(10);

 push 10
 call putch
 add  sp, 2
;-158  

;-159     setdta(direcord);

 lea  ax, [direcord]
 push ax
 call setdta
 add  sp, 2
;-160       

;-161     ffirst(Pfad);

 lea  ax, [Pfad]
 push ax
 call ffirst
 add  sp, 2
;-162     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dodir26
;-163         cputs("Empty directory "); 

 push dodir_2
 call cputs
 add  sp, 2
;-164         return;

 jmp .retndodir
;-165         }

;-166     cputs("Name             Date   Time Attr   Size");

.dodir26:
 push dodir_3
 call cputs
 add  sp, 2
;-167   do {

.dodir27:
;-168         putch(10);  

 push 10
 call putch
 add  sp, 2
;-169         cputs(dirdatname);  

 lea  ax, [dirdatname]
 push ax
 call cputs
 add  sp, 2
;-170         j=strlen(dirdatname);

 lea  ax, [dirdatname]
 push ax
 call strlen
 add  sp, 2
 mov [bp-2], ax
;-171         do {

.dodir28:
;-172             putch(' '); 

 push 32
 call putch
 add  sp, 2
;-173             j++; 

 inc  word[bp-2]
;-174             } while (j<13);

 mov ax, [bp-2]
 cmp ax, 13
 jge .dodir29
 jmp .dodir28
.dodir29:
;-175             

;-176         j=dirdate & 31;         

 mov ax, [dirdate]
 and ax, 31
 mov [bp-2], ax
;-177         if (j<10) putch(' '); 

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir30
 push 32
 call putch
 add  sp, 2
;-178         prunsign(j); 

.dodir30:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-179         putch('.');

 push 46
 call putch
 add  sp, 2
;-180             

;-181         j=dirdate >> 5; 

 mov ax, [dirdate]
 shr ax, 5
 mov [bp-2], ax
;-182         j&=  15;

 and  word[bp-2], 15
;-183         if (j<10) putch('0'); 

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir31
 push 48
 call putch
 add  sp, 2
;-184         prunsign(j); 

.dodir31:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-185         putch('.');

 push 46
 call putch
 add  sp, 2
;-186             

;-187         j=dirdate >> 9; 

 mov ax, [dirdate]
 shr ax, 9
 mov [bp-2], ax
;-188         j+=  80;

 add  word[bp-2], 80
;-189         if (j>=100) j-=100;

 mov ax, [bp-2]
 cmp ax, 100 ;unsigned : 1
 jl  .dodir32
 sub  word[bp-2], 100
;-190         if (j<10) putch('0'); 

.dodir32:
 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir33
 push 48
 call putch
 add  sp, 2
;-191         prunsign(j); 

.dodir33:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-192         putch(' ');

 push 32
 call putch
 add  sp, 2
;-193         putch(' ');

 push 32
 call putch
 add  sp, 2
;-194             

;-195         j=dirtime  >>11;         

 mov ax, [dirtime]
 shr ax, 11
 mov [bp-2], ax
;-196         if (j<10) putch(' '); 

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir34
 push 32
 call putch
 add  sp, 2
;-197         prunsign(j); 

.dodir34:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-198         putch(':');

 push 58
 call putch
 add  sp, 2
;-199             

;-200         j=dirtime  >> 5; 

 mov ax, [dirtime]
 shr ax, 5
 mov [bp-2], ax
;-201         j&=  63;

 and  word[bp-2], 63
;-202         if (j<10) putch('0'); 

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir35
 push 48
 call putch
 add  sp, 2
;-203         prunsign(j); 

.dodir35:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-204         putch(' ');

 push 32
 call putch
 add  sp, 2
;-205                        

;-206         c = dirattr & 32;

 mov al, [dirattr]
 and al, 32
 mov [bp-4], al
;-207         if (c) putch('A'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir36
 push 65
 call putch
 add  sp, 2
 jmp .dodir37
.dodir36:
 push 32
 call putch
 add  sp, 2
;-208         c = dirattr & 16;

.dodir37:
 mov al, [dirattr]
 and al, 16
 mov [bp-4], al
;-209         if (c) putch('D'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir38
 push 68
 call putch
 add  sp, 2
 jmp .dodir39
.dodir38:
 push 32
 call putch
 add  sp, 2
;-210         c = dirattr & 8;

.dodir39:
 mov al, [dirattr]
 and al, 8
 mov [bp-4], al
;-211         if (c) putch('V'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir40
 push 86
 call putch
 add  sp, 2
 jmp .dodir41
.dodir40:
 push 32
 call putch
 add  sp, 2
;-212         c = dirattr & 4;

.dodir41:
 mov al, [dirattr]
 and al, 4
 mov [bp-4], al
;-213         if (c) putch('S'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir42
 push 83
 call putch
 add  sp, 2
 jmp .dodir43
.dodir42:
 push 32
 call putch
 add  sp, 2
;-214         c = dirattr & 2;

.dodir43:
 mov al, [dirattr]
 and al, 2
 mov [bp-4], al
;-215         if (c) putch('H'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir44
 push 72
 call putch
 add  sp, 2
 jmp .dodir45
.dodir44:
 push 32
 call putch
 add  sp, 2
;-216         c = dirattr & 1;

.dodir45:
 mov al, [dirattr]
 and al, 1
 mov [bp-4], al
;-217         if (c) putch('R'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir46
 push 82
 call putch
 add  sp, 2
 jmp .dodir47
.dodir46:
 push 32
 call putch
 add  sp, 2
;-218                               

;-219         if (dirlenhi) { 

.dodir47:
 mov ax, [dirlenhi]
 or  al, al
 je .dodir48
;-220             dirlenlo=dirlenlo >>10; 

 mov ax, [dirlenlo]
 shr ax, 10
 mov word [dirlenlo], ax
;-221             dirlenhi=dirlenhi << 6;

 mov ax, [dirlenhi]
 shl ax, 6
 mov word [dirlenhi], ax
;-222             dirlenhi=dirlenhi+dirlenlo;

 mov ax, [dirlenhi]
 add ax, [dirlenlo]
 mov word [dirlenhi], ax
;-223             putch(' ');

 push 32
 call putch
 add  sp, 2
;-224             prunsign(dirlenhi); 

 push word [dirlenhi]
 call prunsign
 add  sp, 2
;-225             cputs(" KB"); 

 push dodir_4
 call cputs
 add  sp, 2
;-226             }

;-227         else {

 jmp .dodir49
.dodir48:
;-228             putch(' ');

 push 32
 call putch
 add  sp, 2
;-229             prunsign(dirlenlo);

 push word [dirlenlo]
 call prunsign
 add  sp, 2
;-230             }   

;-231     j=fnext(Pfad);  

.dodir49:
 lea  ax, [Pfad]
 push ax
 call fnext
 add  sp, 2
 mov [bp-2], ax
;-232     } while (j!=18);

 mov ax, [bp-2]
 cmp ax, 18
 je  .dodir50
 jmp .dodir27
.dodir50:
;-233     putch(10);    

 push 10
 call putch
 add  sp, 2
;-234 }

;-235 

;-236 

;-237 char memSignature; 

 .retndodir: LEAVE
 ret
dodir_0 db " error reading directory",0
dodir_1 db "Current directory: ",0
dodir_2 db "Empty directory ",0
dodir_3 db "Name             Date   Time Attr   Size",0
dodir_4 db " KB",0
ENDP
memSignature db 0
;-238 unsigned int memOwner; 

memOwner dw 0
;-239 unsigned int memSize;

memSize dw 0
;-240 unsigned int vES; 

vES dw 0
;-241 unsigned int vBX; 

vBX dw 0
;-242 

;-243 int domem() { 

domem: PROC
;-244     unsigned int i;

;-245     char c;

;-246     ah=0x52;//DOS list of lists 
;
 ENTER  4,0
 mov  ah, 82
;-247     asm int 33 ; // out= ES:BX ptr to invars

 int 33 ; // out= ES:BX ptr to invars
;-248     asm mov [vBX], bx 

 mov [vBX], bx 
;-249 //    asm mov es, [es:bx-2]//first memory control block

;-250     __emit__(0x26,0x8E,0x47,0xFE);            

 db 38,142,71,254
;-251     asm mov [vES], es   

 mov [vES], es   
;-252     do {

.domem51:
;-253         putch(10); 

 push 10
 call putch
 add  sp, 2
;-254         cputs("Start:"); 

 push domem_0
 call cputs
 add  sp, 2
;-255         printhex16(vES);

 push word [vES]
 call printhex16
 add  sp, 2
;-256         if (vES >= 0xA000) cputs(" MCB in UMB");

 mov ax, [vES]
 cmp ax, 40960 ;unsigned : 0
 jb  .domem52
 push domem_1
 call cputs
 add  sp, 2
;-257 //        asm mov al, [es:0]// M or Z 

;-258         __emit__(0x26,0xA0,0,0);     

.domem52:
 db 38,160,0,0
;-259         asm mov [memSignature], al         

 mov [memSignature], al         
;-260 //        cputs(", ");

;-261 //        putch(memSignature);

;-262 //        asm mov ax, [es:1]//program segment prefix  

;-263         __emit__(0x26,0xA1,1,0);           

 db 38,161,1,0
;-264         asm mov [memOwner], ax  

 mov [memOwner], ax  
;-265         cputs(", PSP:"); 

 push domem_2
 call cputs
 add  sp, 2
;-266         printhex16(memOwner);

 push word [memOwner]
 call printhex16
 add  sp, 2
;-267 //        asm mov ax, [es:3]//size in para

;-268         __emit__(0x26,0xA1,3,0);                       

 db 38,161,3,0
;-269         asm mov [memSize], ax  

 mov [memSize], ax  
;-270         cputs(", Size:"); 

 push domem_3
 call cputs
 add  sp, 2
;-271         printhex16(memSize);

 push word [memSize]
 call printhex16
 add  sp, 2
;-272         if (memOwner == 0) cputs(" free");

 mov ax, [memOwner]
 cmp ax, 0
 jne .domem53
 push domem_4
 call cputs
 add  sp, 2
;-273         if (memOwner == 8) cputs(" DOS ");

.domem53:
 mov ax, [memOwner]
 cmp ax, 8
 jne .domem54
 push domem_5
 call cputs
 add  sp, 2
;-274         i=memOwner-vES; 

.domem54:
 mov ax, [memOwner]
 sub ax, [vES]
 mov [bp-2], ax
;-275     vES = vES + memSize;  

 mov ax, [vES]
 add ax, [memSize]
 mov word [vES], ax
;-276     vES++;

 inc  word[vES]
;-277     asm mov es, vES 

 mov es, vES 
;-278     es = vES;

 mov  es, [vES]
;-279     } 

;-280     while (memSignature == 'M');

 mov al, [memSignature]
 cmp al, 77
 jne .domem55
 jmp .domem51
.domem55:
;-281     putch(10); 

 push 10
 call putch
 add  sp, 2
;-282 }

;-283 

;-284 int dotype() {
 LEAVE
 ret
domem_0 db "Start:",0
domem_1 db " MCB in UMB",0
domem_2 db ", PSP:",0
domem_3 db ", Size:",0
domem_4 db " free",0
domem_5 db " DOS ",0
ENDP
dotype: PROC
;-285     int fdin; int i;

;-286     fdin=openR(par2);
;
 ENTER  4,0
 push word [par2]
 call openR
 add  sp, 2
 mov [bp-2], ax
;-287     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dotype56
;-288         cputs("file missing");

 push dotype_0
 call cputs
 add  sp, 2
;-289         putch(10); 

 push 10
 call putch
 add  sp, 2
;-290         return;

 jmp .retndotype
;-291         }

;-292     do {

.dotype56:
.dotype57:
;-293         DOS_NoBytes=readR(&DOS_ByteRead, fdin);

 push word [bp-2]
 lea  ax, [DOS_ByteRead]
 push ax
 call readR
 add  sp, 4
 mov word [DOS_NoBytes], ax
;-294         putch(DOS_ByteRead); 

 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-295         } 

;-296         while (DOS_NoBytes);

 mov ax, [DOS_NoBytes]
 or  al, al
 je .dotype58
 jmp .dotype57
.dotype58:
;-297     fcloseR(fdin);

 push word [bp-2]
 call fcloseR
 add  sp, 2
;-298 }

;-299 

;-300 int Prompt1(unsigned char *s) {

 .retndotype: LEAVE
 ret
dotype_0 db "file missing",0
ENDP
Prompt1: PROC
;-301     char c; 

;-302     unsigned char *startstr;

;-303     startstr=s;  
;
 ENTER  4,0
 mov ax, [bp+4]
 mov [bp-4], ax
;-304     do { 

.Prompt159:
;-305         c=GetKey();  

 call GetKey
 mov [bp-2], al
;-306         if (c == 27)    exitR(1);//good bye

 mov al, [bp-2]
 cmp al, 27
 jne .Prompt160
 push 1
 call exitR
 add  sp, 2
;-307         if (c==8) {

.Prompt160:
 mov al, [bp-2]
 cmp al, 8
 jne .Prompt161
;-308             if (s > startstr){

 mov ax, [bp+4]
 cmp ax, [bp-4]
 jle .Prompt162
;-309                 s--;

 dec  word[bp+4]
;-310                 putch(8);

 push 8
 call putch
 add  sp, 2
;-311                 putch(' ');

 push 32
 call putch
 add  sp, 2
;-312                 putch(8);

 push 8
 call putch
 add  sp, 2
;-313                 }

;-314                 else putch(7);

 jmp .Prompt163
.Prompt162:
 push 7
 call putch
 add  sp, 2
;-315             }

.Prompt163:
;-316             else { 

 jmp .Prompt164
.Prompt161:
;-317                 *s=c; 

 mov al, [bp-2]
 mov  bx, [bp+4]
 mov  [bx], al
;-318                 s++; 

 inc  word[bp+4]
;-319                 putch(c); 

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-320             }

;-321     } while(c!=13); 

.Prompt164:
 mov al, [bp-2]
 cmp al, 13
 je  .Prompt165
 jmp .Prompt159
.Prompt165:
;-322     s--;  

 dec  word[bp+4]
;-323     *s=0; 

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-324 }

;-325 

;-326 char Info1[]=" commands: help,exit,cls,type,mem,dir";
 LEAVE
 ret
ENDP
Info1 db " commands: help,exit,cls,type,mem,dir",0
;-327 //dos,dump,exec,fn, *.COM

;-328 

;-329 int dohelp() { 

dohelp: PROC
;-330     unsigned int i;   

;-331     cputs(Version1);
;
 ENTER  2,0
 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2
;-332 //    rdump();

;-333     cputs(Info1);   putch(10); 

 lea  ax, [Info1]
 push ax
 call cputs
 add  sp, 2
 push 10
 call putch
 add  sp, 2
;-334 }

;-335 

;-336 char inp_buf[81]; 
 LEAVE
 ret
ENDP
section .bss
absolute 25064
inp_buf resb 81
section .text
;-337 

;-338 int getpar(char *t) {    

getpar: PROC
;-339     while (*t == 32) t++; 
;
 ENTER  0,0
.getpar66:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar67
 inc  word[bp+4]
;-340     if (*t<=13) return 0;

 jmp .getpar66
.getpar67:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar68
 mov ax, 0
 jmp .retngetpar
;-341         

;-342     par1=t; 

.getpar68:
 mov ax, [bp+4]
 mov word [par1], ax
;-343     while(*t >= 33) t++; 

.getpar69:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar70
 inc  word[bp+4]
;-344     if (*t==0) return 1;

 jmp .getpar69
.getpar70:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar71
 mov ax, 1
 jmp .retngetpar
;-345     *t=0; 

.getpar71:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-346     t++;

 inc  word[bp+4]
;-347     while (*t == 32) t++; 

.getpar72:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar73
 inc  word[bp+4]
;-348     if (*t<=13) return 1;

 jmp .getpar72
.getpar73:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar74
 mov ax, 1
 jmp .retngetpar
;-349         

;-350     par2=t; 

.getpar74:
 mov ax, [bp+4]
 mov word [par2], ax
;-351     while(*t >= 33) t++; 

.getpar75:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar76
 inc  word[bp+4]
;-352     if (*t==0) return 2;

 jmp .getpar75
.getpar76:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar77
 mov ax, 2
 jmp .retngetpar
;-353     *t=0; 

.getpar77:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-354     t++;    

 inc  word[bp+4]
;-355     while (*t == 32) t++; 

.getpar78:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar79
 inc  word[bp+4]
;-356     if (*t<=13) return 2;

 jmp .getpar78
.getpar79:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar80
 mov ax, 2
 jmp .retngetpar
;-357          

;-358     par3=t;     

.getpar80:
 mov ax, [bp+4]
 mov word [par3], ax
;-359     while(*t >= 33) t++; 

.getpar81:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar82
 inc  word[bp+4]
;-360     *t=0;     

 jmp .getpar81
.getpar82:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-361     return 3;    

 mov ax, 3
 jmp .retngetpar
;-362 }

;-363 

;-364 int intrinsic() {

 .retngetpar: LEAVE
 ret
ENDP
intrinsic: PROC
;-365     toupper(par1);      

 push word [par1]
 call toupper
 add  sp, 2
;-366     if(eqstr(par1,"HELP")){dohelp();return;}

 push intrinsic_0
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic83
 call dohelp
 jmp .retnintrinsic
;-367     if(eqstr(par1,"EXIT"))exitR(0);

.intrinsic83:
 push intrinsic_1
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic84
 push 0
 call exitR
 add  sp, 2
;-368     if(eqstr(par1,"CLS" )){clrscr();return;}

.intrinsic84:
 push intrinsic_2
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic85
 call clrscr
 jmp .retnintrinsic
;-369     if(eqstr(par1,"TYPE")){dotype();return;}

.intrinsic85:
 push intrinsic_3
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic86
 call dotype
 jmp .retnintrinsic
;-370     if(eqstr(par1,"MEM" )){domem(); return;}

.intrinsic86:
 push intrinsic_4
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic87
 call domem
 jmp .retnintrinsic
;-371     if(eqstr(par1,"DIR" )){dodir();return;}

.intrinsic87:
 push intrinsic_5
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic88
 call dodir
 jmp .retnintrinsic
;-372 //    if(eqstr(s,"DOS" )){dodos(); return;}

;-373 //    if(eqstr(s,"DUMP")){dodump();return;}

;-374 //    if(eqstr(s,"EXEC")){exec1 ();return;}

;-375 //    if(eqstr(s,"FN"  )){doFN();  return;}

;-376 //    extrinsic(inp_buf);

;-377 }

.intrinsic88:
;-378 

;-379 

;-380 int get_cmd(){

 .retnintrinsic:
 ret
intrinsic_0 db "HELP",0
intrinsic_1 db "EXIT",0
intrinsic_2 db "CLS",0
intrinsic_3 db "TYPE",0
intrinsic_4 db "MEM",0
intrinsic_5 db "DIR",0
ENDP
get_cmd: PROC
;-381     *inp_buf=0;

 mov ax, 0
 mov  bx, [inp_buf]
 mov  [bx], al
;-382     DOS_ERR=0;

 mov ax, 0
 mov word [DOS_ERR], ax
;-383     putch(':');

 push 58
 call putch
 add  sp, 2
;-384     Prompt1(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call Prompt1
 add  sp, 2
;-385     putch(10);

 push 10
 call putch
 add  sp, 2
;-386 }

;-387 

;-388 int main() {

 ret
ENDP
main: PROC
;-389     dohelp();

 call dohelp
;-390     do { 

.main89:
;-391         get_cmd(); 

 call get_cmd
;-392         par_count=getpar(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call getpar
 add  sp, 2
 mov byte [par_count], al
;-393         intrinsic(); 

 call intrinsic
;-394         } 

;-395     while(1);

 mov ax, 1
 or  al, al
 je .main90
 jmp .main89
.main90:
;-396 }

 ret
ENDP
;Glob. variables:24 (200), Functions:39 (300), Lines:397
;Constant: 187 (3000), stacksize: 40491