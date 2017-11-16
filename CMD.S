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

;-74 int printhex8(unsigned char c) {
 LEAVE
 ret
ENDP
printhex8: PROC
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

;-81     half = i >>  8; printhex8(half);
;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-82     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
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
;-132 int atoi(char *s) { 
 LEAVE
 ret
ENDP
atoi: PROC
;-133     char c; 

;-134     unsigned int i; 

;-135     i=0;
;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], ax
;-136     while (*s) { 

.atoi25:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .atoi26
;-137         c=*s; 

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-138         c-=48; 

 sub  byte[bp-2], 48
;-139         i=i*10; 

 mov ax, [bp-4]
 mov bx, 10
 mul bx
 mov [bp-4], ax
;-140         i=i+c; 

 mov ax, [bp-4]
 add al, [bp-2]
 mov [bp-4], ax
;-141         s++; 

 inc  word[bp+4]
;-142         }  

;-143     return i; 

 jmp .atoi25
.atoi26:
 mov ax, [bp-4]
 jmp .retnatoi
;-144 }

;-145 

;-146 

;-147 int mdump(unsigned char *adr, unsigned int len ) {

 .retnatoi: LEAVE
 ret
ENDP
mdump: PROC
;-148     unsigned char c; 

;-149     int i; 

;-150     int j;

;-151     j=0; 
;
 ENTER  6,0
 mov ax, 0
 mov [bp-6], ax
;-152     while (j < len ) {

.mdump27:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump28
;-153         putch(10);  

 push 10
 call putch
 add  sp, 2
;-154         printhex16(adr); 

 push word [bp+4]
 call printhex16
 add  sp, 2
;-155         putch(':');

 push 58
 call putch
 add  sp, 2
;-156         i=0; 

 mov ax, 0
 mov [bp-4], ax
;-157         while (i < 16) {

.mdump29:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump30
;-158             putch(' '); 

 push 32
 call putch
 add  sp, 2
;-159             c = *adr; 

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-160             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-161             adr++;

 inc  word[bp+4]
;-162             i++;

 inc  word[bp-4]
;-163             j++;

 inc  word[bp-6]
;-164             }

;-165         putch(' '); 

 jmp .mdump29
.mdump30:
 push 32
 call putch
 add  sp, 2
;-166         adr -=16; 

 sub  word[bp+4], 16
;-167         i=0; 

 mov ax, 0
 mov [bp-4], ax
;-168         while(i < 16) {

.mdump31:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump32
;-169             c= *adr; 

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-170             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump33
 push 46
 call putch
 add  sp, 2
;-171                 else putch(c); 

 jmp .mdump34
.mdump33:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-172             adr++;

.mdump34:
 inc  word[bp+4]
;-173             i++; 

 inc  word[bp-4]
;-174         }  

;-175     }  

 jmp .mdump31
.mdump32:
;-176 }

 jmp .mdump27
.mdump28:
;-177 

;-178 int dodump() { 
 LEAVE
 ret
ENDP
dodump: PROC
;-179     unsigned int i;

;-180     i=atoi(par2);
;
 ENTER  2,0
 push word [par2]
 call atoi
 add  sp, 2
 mov [bp-2], ax
;-181     cputs(par2);

 push word [par2]
 call cputs
 add  sp, 2
;-182     cputs(":par2 "); 

 push dodump_0
 call cputs
 add  sp, 2
;-183     prunsign(i);

 push word [bp-2]
 call prunsign
 add  sp, 2
;-184     mdump(i, 120);

 push 120
 push word [bp-2]
 call mdump
 add  sp, 4
;-185     putch(10);      

 push 10
 call putch
 add  sp, 2
;-186 }

;-187 

;-188 char FNBuf[64];
 LEAVE
 ret
dodump_0 db ":par2 ",0
ENDP
section .bss
absolute 25000
FNBuf resb 64
section .text
;-189 char Pfad[]="*.*";

Pfad db "*.*",0
;-190 char direcord[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};//21 do not change

direcord db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;-191 char dirattr=0;   

dirattr db 0
;-192 int  dirtime=0;  

dirtime dw 0
;-193 int  dirdate=0;

dirdate dw 0
;-194 int  dirlenlo=0;  

dirlenlo dw 0
;-195 int  dirlenhi=0; 

dirlenhi dw 0
;-196 char dirdatname[]={0,0,0,0,0,0,0,0,0,0,0,0,0};//13 structure until here

dirdatname db 0,0,0,0,0,0,0,0,0,0,0,0,0
;-197 

;-198 int dodir() { 

dodir: PROC
;-199     int j;

;-200     char c;

;-201     si= &FNBuf; 
;
 ENTER  4,0
 mov  si, FNBuf
;-202     dl=0;  

 mov  dl, 0
;-203     ax=0x4700;//get current directory 

 mov  ax, 18176
;-204     DosInt(); 

 call DosInt
;-205     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dodir35
;-206         cputs(" error reading directory");

 push dodir_0
 call cputs
 add  sp, 2
;-207         return;

 jmp .retndodir
;-208     }

;-209     cputs("Current directory: "); 

.dodir35:
 push dodir_1
 call cputs
 add  sp, 2
;-210     cputs(FNBuf); 

 lea  ax, [FNBuf]
 push ax
 call cputs
 add  sp, 2
;-211     putch(10);

 push 10
 call putch
 add  sp, 2
;-212  

;-213     setdta(direcord);

 lea  ax, [direcord]
 push ax
 call setdta
 add  sp, 2
;-214       

;-215     ffirst(Pfad);

 lea  ax, [Pfad]
 push ax
 call ffirst
 add  sp, 2
;-216     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dodir36
;-217         cputs("Empty directory "); 

 push dodir_2
 call cputs
 add  sp, 2
;-218         return;

 jmp .retndodir
;-219         }

;-220     cputs("Name             Date   Time Attr   Size");

.dodir36:
 push dodir_3
 call cputs
 add  sp, 2
;-221   do {

.dodir37:
;-222         putch(10);  

 push 10
 call putch
 add  sp, 2
;-223         cputs(dirdatname);  

 lea  ax, [dirdatname]
 push ax
 call cputs
 add  sp, 2
;-224         j=strlen(dirdatname);

 lea  ax, [dirdatname]
 push ax
 call strlen
 add  sp, 2
 mov [bp-2], ax
;-225         do {

.dodir38:
;-226             putch(' '); 

 push 32
 call putch
 add  sp, 2
;-227             j++; 

 inc  word[bp-2]
;-228             } while (j<13);

 mov ax, [bp-2]
 cmp ax, 13
 jge .dodir39
 jmp .dodir38
.dodir39:
;-229             

;-230         j=dirdate & 31;         

 mov ax, [dirdate]
 and ax, 31
 mov [bp-2], ax
;-231         if (j<10) putch(' '); 

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir40
 push 32
 call putch
 add  sp, 2
;-232         prunsign(j); 

.dodir40:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-233         putch('.');

 push 46
 call putch
 add  sp, 2
;-234             

;-235         j=dirdate >> 5; 

 mov ax, [dirdate]
 shr ax, 5
 mov [bp-2], ax
;-236         j&=  15;

 and  word[bp-2], 15
;-237         if (j<10) putch('0'); 

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir41
 push 48
 call putch
 add  sp, 2
;-238         prunsign(j); 

.dodir41:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-239         putch('.');

 push 46
 call putch
 add  sp, 2
;-240             

;-241         j=dirdate >> 9; 

 mov ax, [dirdate]
 shr ax, 9
 mov [bp-2], ax
;-242         j+=  80;

 add  word[bp-2], 80
;-243         if (j>=100) j-=100;

 mov ax, [bp-2]
 cmp ax, 100 ;unsigned : 1
 jl  .dodir42
 sub  word[bp-2], 100
;-244         if (j<10) putch('0'); 

.dodir42:
 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir43
 push 48
 call putch
 add  sp, 2
;-245         prunsign(j); 

.dodir43:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-246         putch(' ');

 push 32
 call putch
 add  sp, 2
;-247         putch(' ');

 push 32
 call putch
 add  sp, 2
;-248             

;-249         j=dirtime  >>11;         

 mov ax, [dirtime]
 shr ax, 11
 mov [bp-2], ax
;-250         if (j<10) putch(' '); 

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir44
 push 32
 call putch
 add  sp, 2
;-251         prunsign(j); 

.dodir44:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-252         putch(':');

 push 58
 call putch
 add  sp, 2
;-253             

;-254         j=dirtime  >> 5; 

 mov ax, [dirtime]
 shr ax, 5
 mov [bp-2], ax
;-255         j&=  63;

 and  word[bp-2], 63
;-256         if (j<10) putch('0'); 

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir45
 push 48
 call putch
 add  sp, 2
;-257         prunsign(j); 

.dodir45:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-258         putch(' ');

 push 32
 call putch
 add  sp, 2
;-259                        

;-260         c = dirattr & 32;

 mov al, [dirattr]
 and al, 32
 mov [bp-4], al
;-261         if (c) putch('A'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir46
 push 65
 call putch
 add  sp, 2
 jmp .dodir47
.dodir46:
 push 32
 call putch
 add  sp, 2
;-262         c = dirattr & 16;

.dodir47:
 mov al, [dirattr]
 and al, 16
 mov [bp-4], al
;-263         if (c) putch('D'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir48
 push 68
 call putch
 add  sp, 2
 jmp .dodir49
.dodir48:
 push 32
 call putch
 add  sp, 2
;-264         c = dirattr & 8;

.dodir49:
 mov al, [dirattr]
 and al, 8
 mov [bp-4], al
;-265         if (c) putch('V'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir50
 push 86
 call putch
 add  sp, 2
 jmp .dodir51
.dodir50:
 push 32
 call putch
 add  sp, 2
;-266         c = dirattr & 4;

.dodir51:
 mov al, [dirattr]
 and al, 4
 mov [bp-4], al
;-267         if (c) putch('S'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir52
 push 83
 call putch
 add  sp, 2
 jmp .dodir53
.dodir52:
 push 32
 call putch
 add  sp, 2
;-268         c = dirattr & 2;

.dodir53:
 mov al, [dirattr]
 and al, 2
 mov [bp-4], al
;-269         if (c) putch('H'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir54
 push 72
 call putch
 add  sp, 2
 jmp .dodir55
.dodir54:
 push 32
 call putch
 add  sp, 2
;-270         c = dirattr & 1;

.dodir55:
 mov al, [dirattr]
 and al, 1
 mov [bp-4], al
;-271         if (c) putch('R'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir56
 push 82
 call putch
 add  sp, 2
 jmp .dodir57
.dodir56:
 push 32
 call putch
 add  sp, 2
;-272                               

;-273         if (dirlenhi) { 

.dodir57:
 mov ax, [dirlenhi]
 or  al, al
 je .dodir58
;-274             dirlenlo=dirlenlo >>10; 

 mov ax, [dirlenlo]
 shr ax, 10
 mov word [dirlenlo], ax
;-275             dirlenhi=dirlenhi << 6;

 mov ax, [dirlenhi]
 shl ax, 6
 mov word [dirlenhi], ax
;-276             dirlenhi=dirlenhi+dirlenlo;

 mov ax, [dirlenhi]
 add ax, [dirlenlo]
 mov word [dirlenhi], ax
;-277             putch(' ');

 push 32
 call putch
 add  sp, 2
;-278             prunsign(dirlenhi); 

 push word [dirlenhi]
 call prunsign
 add  sp, 2
;-279             cputs(" KB"); 

 push dodir_4
 call cputs
 add  sp, 2
;-280             }

;-281         else {

 jmp .dodir59
.dodir58:
;-282             putch(' ');

 push 32
 call putch
 add  sp, 2
;-283             prunsign(dirlenlo);

 push word [dirlenlo]
 call prunsign
 add  sp, 2
;-284             }   

;-285     j=fnext(Pfad);  

.dodir59:
 lea  ax, [Pfad]
 push ax
 call fnext
 add  sp, 2
 mov [bp-2], ax
;-286     } while (j!=18);

 mov ax, [bp-2]
 cmp ax, 18
 je  .dodir60
 jmp .dodir37
.dodir60:
;-287     putch(10);    

 push 10
 call putch
 add  sp, 2
;-288 }

;-289 

;-290 

;-291 char memSignature; 

 .retndodir: LEAVE
 ret
dodir_0 db " error reading directory",0
dodir_1 db "Current directory: ",0
dodir_2 db "Empty directory ",0
dodir_3 db "Name             Date   Time Attr   Size",0
dodir_4 db " KB",0
ENDP
memSignature db 0
;-292 unsigned int memOwner; 

memOwner dw 0
;-293 unsigned int memSize;

memSize dw 0
;-294 unsigned int vES; 

vES dw 0
;-295 unsigned int vBX; 

vBX dw 0
;-296 

;-297 int domem() { 

domem: PROC
;-298     unsigned int i;

;-299     char c;

;-300     ah=0x52;//DOS list of lists 
;
 ENTER  4,0
 mov  ah, 82
;-301     asm int 33 ; // out= ES:BX ptr to invars

 int 33 ; // out= ES:BX ptr to invars
;-302     asm mov [vBX], bx 

 mov [vBX], bx 
;-303 //    asm mov es, [es:bx-2]//first memory control block

;-304     __emit__(0x26,0x8E,0x47,0xFE);            

 db 38,142,71,254
;-305     asm mov [vES], es   

 mov [vES], es   
;-306     do {

.domem61:
;-307         putch(10); 

 push 10
 call putch
 add  sp, 2
;-308         cputs("Start:"); 

 push domem_0
 call cputs
 add  sp, 2
;-309         printhex16(vES);

 push word [vES]
 call printhex16
 add  sp, 2
;-310         if (vES >= 0xA000) cputs(" MCB in UMB");

 mov ax, [vES]
 cmp ax, 40960 ;unsigned : 0
 jb  .domem62
 push domem_1
 call cputs
 add  sp, 2
;-311 //        asm mov al, [es:0]// M or Z 

;-312         __emit__(0x26,0xA0,0,0);     

.domem62:
 db 38,160,0,0
;-313         asm mov [memSignature], al         

 mov [memSignature], al         
;-314 //        cputs(", ");

;-315 //        putch(memSignature);

;-316 //        asm mov ax, [es:1]//program segment prefix  

;-317         __emit__(0x26,0xA1,1,0);           

 db 38,161,1,0
;-318         asm mov [memOwner], ax  

 mov [memOwner], ax  
;-319         cputs(", PSP:"); 

 push domem_2
 call cputs
 add  sp, 2
;-320         printhex16(memOwner);

 push word [memOwner]
 call printhex16
 add  sp, 2
;-321 //        asm mov ax, [es:3]//size in para

;-322         __emit__(0x26,0xA1,3,0);                       

 db 38,161,3,0
;-323         asm mov [memSize], ax  

 mov [memSize], ax  
;-324         cputs(", Size:"); 

 push domem_3
 call cputs
 add  sp, 2
;-325         printhex16(memSize);

 push word [memSize]
 call printhex16
 add  sp, 2
;-326         if (memOwner == 0) cputs(" free");

 mov ax, [memOwner]
 cmp ax, 0
 jne .domem63
 push domem_4
 call cputs
 add  sp, 2
;-327         if (memOwner == 8) cputs(" DOS ");

.domem63:
 mov ax, [memOwner]
 cmp ax, 8
 jne .domem64
 push domem_5
 call cputs
 add  sp, 2
;-328         i=memOwner-vES; 

.domem64:
 mov ax, [memOwner]
 sub ax, [vES]
 mov [bp-2], ax
;-329     vES = vES + memSize;  

 mov ax, [vES]
 add ax, [memSize]
 mov word [vES], ax
;-330     vES++;

 inc  word[vES]
;-331     asm mov es, vES 

 mov es, vES 
;-332     es = vES;

 mov  es, [vES]
;-333     } 

;-334     while (memSignature == 'M');

 mov al, [memSignature]
 cmp al, 77
 jne .domem65
 jmp .domem61
.domem65:
;-335     putch(10); 

 push 10
 call putch
 add  sp, 2
;-336 }

;-337 

;-338 int dotype() {
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
;-339     int fdin; int i;

;-340     fdin=openR(par2);
;
 ENTER  4,0
 push word [par2]
 call openR
 add  sp, 2
 mov [bp-2], ax
;-341     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dotype66
;-342         cputs("file missing");

 push dotype_0
 call cputs
 add  sp, 2
;-343         putch(10); 

 push 10
 call putch
 add  sp, 2
;-344         return;

 jmp .retndotype
;-345         }

;-346     do {

.dotype66:
.dotype67:
;-347         DOS_NoBytes=readR(&DOS_ByteRead, fdin);

 push word [bp-2]
 lea  ax, [DOS_ByteRead]
 push ax
 call readR
 add  sp, 4
 mov word [DOS_NoBytes], ax
;-348         putch(DOS_ByteRead); 

 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-349         } 

;-350         while (DOS_NoBytes);

 mov ax, [DOS_NoBytes]
 or  al, al
 je .dotype68
 jmp .dotype67
.dotype68:
;-351     fcloseR(fdin);

 push word [bp-2]
 call fcloseR
 add  sp, 2
;-352 }

;-353 

;-354 int Prompt1(unsigned char *s) {

 .retndotype: LEAVE
 ret
dotype_0 db "file missing",0
ENDP
Prompt1: PROC
;-355     char c; 

;-356     unsigned char *startstr;

;-357     startstr=s;  
;
 ENTER  4,0
 mov ax, [bp+4]
 mov [bp-4], ax
;-358     do { 

.Prompt169:
;-359         c=GetKey();  

 call GetKey
 mov [bp-2], al
;-360         if (c == 27)    exitR(1);//good bye

 mov al, [bp-2]
 cmp al, 27
 jne .Prompt170
 push 1
 call exitR
 add  sp, 2
;-361         if (c==8) {

.Prompt170:
 mov al, [bp-2]
 cmp al, 8
 jne .Prompt171
;-362             if (s > startstr){

 mov ax, [bp+4]
 cmp ax, [bp-4]
 jle .Prompt172
;-363                 s--;

 dec  word[bp+4]
;-364                 putch(8);

 push 8
 call putch
 add  sp, 2
;-365                 putch(' ');

 push 32
 call putch
 add  sp, 2
;-366                 putch(8);

 push 8
 call putch
 add  sp, 2
;-367                 }

;-368                 else putch(7);

 jmp .Prompt173
.Prompt172:
 push 7
 call putch
 add  sp, 2
;-369             }

.Prompt173:
;-370             else { 

 jmp .Prompt174
.Prompt171:
;-371                 *s=c; 

 mov al, [bp-2]
 mov  bx, [bp+4]
 mov  [bx], al
;-372                 s++; 

 inc  word[bp+4]
;-373                 putch(c); 

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-374             }

;-375     } while(c!=13); 

.Prompt174:
 mov al, [bp-2]
 cmp al, 13
 je  .Prompt175
 jmp .Prompt169
.Prompt175:
;-376     s--;  

 dec  word[bp+4]
;-377     *s=0; 

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-378 }

;-379 

;-380 char Info1[]=" commands: help,exit,cls,type,mem,dir,dump (adr)";
 LEAVE
 ret
ENDP
Info1 db " commands: help,exit,cls,type,mem,dir,dump (adr)",0
;-381 //dos,exec,fn, *.COM

;-382 

;-383 int dohelp() { 

dohelp: PROC
;-384     unsigned int i;   

;-385     cputs(Version1);
;
 ENTER  2,0
 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2
;-386 //    rdump();

;-387     cputs(Info1);   putch(10); 

 lea  ax, [Info1]
 push ax
 call cputs
 add  sp, 2
 push 10
 call putch
 add  sp, 2
;-388 }

;-389 

;-390 char inp_buf[81]; 
 LEAVE
 ret
ENDP
section .bss
absolute 25064
inp_buf resb 81
section .text
;-391 

;-392 int getpar(char *t) {    

getpar: PROC
;-393     while (*t == 32) t++; 
;
 ENTER  0,0
.getpar76:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar77
 inc  word[bp+4]
;-394     if (*t<=13) return 0;

 jmp .getpar76
.getpar77:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar78
 mov ax, 0
 jmp .retngetpar
;-395         

;-396     par1=t; 

.getpar78:
 mov ax, [bp+4]
 mov word [par1], ax
;-397     while(*t >= 33) t++; 

.getpar79:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar80
 inc  word[bp+4]
;-398     if (*t==0) return 1;

 jmp .getpar79
.getpar80:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar81
 mov ax, 1
 jmp .retngetpar
;-399     *t=0; 

.getpar81:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-400     t++;

 inc  word[bp+4]
;-401     while (*t == 32) t++; 

.getpar82:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar83
 inc  word[bp+4]
;-402     if (*t<=13) return 1;

 jmp .getpar82
.getpar83:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar84
 mov ax, 1
 jmp .retngetpar
;-403         

;-404     par2=t; 

.getpar84:
 mov ax, [bp+4]
 mov word [par2], ax
;-405     while(*t >= 33) t++; 

.getpar85:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar86
 inc  word[bp+4]
;-406     if (*t==0) return 2;

 jmp .getpar85
.getpar86:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar87
 mov ax, 2
 jmp .retngetpar
;-407     *t=0; 

.getpar87:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-408     t++;    

 inc  word[bp+4]
;-409     while (*t == 32) t++; 

.getpar88:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar89
 inc  word[bp+4]
;-410     if (*t<=13) return 2;

 jmp .getpar88
.getpar89:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar90
 mov ax, 2
 jmp .retngetpar
;-411          

;-412     par3=t;     

.getpar90:
 mov ax, [bp+4]
 mov word [par3], ax
;-413     while(*t >= 33) t++; 

.getpar91:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar92
 inc  word[bp+4]
;-414     *t=0;     

 jmp .getpar91
.getpar92:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-415     return 3;    

 mov ax, 3
 jmp .retngetpar
;-416 }

;-417 

;-418 int intrinsic() {

 .retngetpar: LEAVE
 ret
ENDP
intrinsic: PROC
;-419     toupper(par1);      

 push word [par1]
 call toupper
 add  sp, 2
;-420     if(eqstr(par1,"HELP")){dohelp();return;}

 push intrinsic_0
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic93
 call dohelp
 jmp .retnintrinsic
;-421     if(eqstr(par1,"EXIT"))exitR(0);

.intrinsic93:
 push intrinsic_1
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic94
 push 0
 call exitR
 add  sp, 2
;-422     if(eqstr(par1,"CLS" )){clrscr();return;}

.intrinsic94:
 push intrinsic_2
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic95
 call clrscr
 jmp .retnintrinsic
;-423     if(eqstr(par1,"TYPE")){dotype();return;}

.intrinsic95:
 push intrinsic_3
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic96
 call dotype
 jmp .retnintrinsic
;-424     if(eqstr(par1,"MEM" )){domem(); return;}

.intrinsic96:
 push intrinsic_4
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic97
 call domem
 jmp .retnintrinsic
;-425     if(eqstr(par1,"DIR" )){dodir();return;}

.intrinsic97:
 push intrinsic_5
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic98
 call dodir
 jmp .retnintrinsic
;-426     if(eqstr(par1,"DUMP")){dodump();return;}

.intrinsic98:
 push intrinsic_6
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic99
 call dodump
 jmp .retnintrinsic
;-427 //    if(eqstr(par1,"DOS" )){dodos(); return;}

;-428 //    if(eqstr(par1,"EXEC")){exec1 ();return;}

;-429 //    if(eqstr(par1,"FN"  )){doFN();  return;}

;-430 //    extrinsic(inp_buf);

;-431 }

.intrinsic99:
;-432 

;-433 

;-434 int get_cmd(){

 .retnintrinsic:
 ret
intrinsic_0 db "HELP",0
intrinsic_1 db "EXIT",0
intrinsic_2 db "CLS",0
intrinsic_3 db "TYPE",0
intrinsic_4 db "MEM",0
intrinsic_5 db "DIR",0
intrinsic_6 db "DUMP",0
ENDP
get_cmd: PROC
;-435     *inp_buf=0;

 mov ax, 0
 mov  bx, [inp_buf]
 mov  [bx], al
;-436     DOS_ERR=0;

 mov ax, 0
 mov word [DOS_ERR], ax
;-437     putch(':');

 push 58
 call putch
 add  sp, 2
;-438     Prompt1(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call Prompt1
 add  sp, 2
;-439     putch(10);

 push 10
 call putch
 add  sp, 2
;-440 }

;-441 

;-442 int main() {

 ret
ENDP
main: PROC
;-443     dohelp();

 call dohelp
;-444     do { 

.main100:
;-445         get_cmd(); 

 call get_cmd
;-446         par_count=getpar(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call getpar
 add  sp, 2
 mov byte [par_count], al
;-447         intrinsic(); 

 call intrinsic
;-448         } 

;-449     while(1);

 mov ax, 1
 or  al, al
 je .main101
 jmp .main100
.main101:
;-450 }

 ret
ENDP
;Glob. variables:24 (200), Functions:42 (300), Lines:451
;Constant: 187 (3000), stacksize: 40491