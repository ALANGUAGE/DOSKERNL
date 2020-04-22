;PLA compiler A.COM V0.9.6, Input: CMD.C, Output: CMD.S
org  256 
jmp main
;-1 char Version1[]="CMD V0.5.1";//Command.com for 1OS

Version1 db "CMD V0.5.1",0
;-2 //--------------------------- Bios Routines I/O ---------------------

;-3 int writetty()     {//char in AL


writetty: PROC
;-4     ah=0x0E;

 mov  ah, 14
;-5     asm push bx

 push bx
;-6     bx=0;     //page in BH

 mov  bx, 0
;-7     inth 0x10;

 int  16
;-8     asm pop bx

 pop bx
;-9 }

;-10 int putch(char c)  {

 ret
ENDP

putch: PROC
;-11     if (c==10)  {// LF

;Function : putch, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-12         al=13;   // CR, write CR first and then LF

 mov  al, 13
;-13         writetty();

 call writetty
;-14     }

;-15     al=c;

.putch1:
 mov  al, [bp+4]
;-16     writetty();

 call writetty
;-17 }

;-18 int cputs(char *s) {//only with correct DS !!!

 LEAVE
 ret
ENDP

cputs: PROC
;-19     char c;

;-20     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;300 ptr sign byte s = bp+4
;301 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-21         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-22         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-23         s++;

 inc  word[bp+4]
;-24     }

;-25 }

 jmp .cputs2
.cputs3:
;-26 

;-27 int gotoxy (char x, char y) {

 LEAVE
 ret
ENDP

gotoxy: PROC
;-28     ah=2;

;Function : gotoxy, Number local Var: 2
; # type sign width local variables
;300 var sign byte x = bp+4
;301 var sign byte y = bp+6;
 ENTER  0,0
 mov  ah, 2
;-29     bx=0;

 mov  bx, 0
;-30     dh=y;

 mov  dh, [bp+6]
;-31     dl=x;

 mov  dl, [bp+4]
;-32     __emit__(0xCD,0x10);

 db 205,16
;-33 }

;-34 int clrscr()    {

 LEAVE
 ret
ENDP

clrscr: PROC
;-35     ax=0x0600;

 mov  ax, 1536
;-36     bh=7;

 mov  bh, 7
;-37     cx=0;

 mov  cx, 0
;-38     dx=0x184F;

 mov  dx, 6223
;-39     __emit__(0xCD,0x10);

 db 205,16
;-40     gotoxy(0,0);

 push 0
 push 0
 call gotoxy
 add  sp, 4
;-41 }

;-42 

;-43 int getch() {

 ret
ENDP

getch: PROC
;-44     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-45     inth 0x16;//AH=Scan code, AL=char

 int  22
;-46 }

;-47 int waitkey() {

 ret
ENDP

waitkey: PROC
;-48     ah=0x11;//get kbd status

 mov  ah, 17
;-49     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-50     //zero flag: 0=IS char, 1=NO char

;-51     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-52 }

;-53 int getkey() {

 ret
ENDP

getkey: PROC
;-54     waitkey();

 call waitkey
;-55     getch();

 call getch
;-56     ah=0;//clear scan code

 mov  ah, 0
;-57     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey4
 call getch
 add ax, 256
;-58     //put ext code in AX

;-59 }

.getkey4:
;-60 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-61     getkey();

 call getkey
;-62     writetty();//destroys AH

 call writetty
;-63 }

;-64 

;-65 unsigned int vAX;

 ret
ENDP
vAX dw 0
;-66 unsigned int vBX;

vBX dw 0
;-67 unsigned int vES;

vES dw 0
;-68 

;-69 char par_count=0;

par_count db 0
;-70 char *par1;

par1 dw 0
;-71 char *par2;

par2 dw 0
;-72 char *par3;

par3 dw 0
;-73 

;-74 int DOS_ERR=0;

DOS_ERR dw 0
;-75 int DOS_NoBytes;        //number of bytes read (0 or 1)

DOS_NoBytes dw 0
;-76 char DOS_ByteRead;      //the byte just read by DOS

DOS_ByteRead db 0
;-77 

;-78 int DosInt() {


DosInt: PROC
;-79     inth 0x21;

 int  33
;-80     __emit__(0x73, 04); //jnc over DOS_ERR++

 db 115,4
;-81     DOS_ERR++;

 inc  word[DOS_ERR]
;-82 }

;-83 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }

 ret
ENDP

openR: PROC
;Function : openR, Number local Var: 1
; # type sign width local variables
;300 ptr sign byte s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt
;-84 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }

 LEAVE
 ret
ENDP

creatR: PROC
;Function : creatR, Number local Var: 1
; # type sign width local variables
;300 ptr sign byte s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt
;-85 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }

 LEAVE
 ret
ENDP

fcloseR: PROC
;Function : fcloseR, Number local Var: 1
; # type sign width local variables
;300 var sign word fd = bp+4;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 call DosInt
;-86 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }

 LEAVE
 ret
ENDP

exitR: PROC
;Function : exitR, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 call DosInt
;-87 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }

 LEAVE
 ret
ENDP

readR: PROC
;Function : readR, Number local Var: 2
; # type sign width local variables
;300 ptr sign byte s = bp+4
;301 var sign word fd = bp+6;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt
;-88 int readRL(char *s, int fd, int len){

 LEAVE
 ret
ENDP

readRL: PROC
;-89     dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}

;Function : readRL, Number local Var: 3
; # type sign width local variables
;300 ptr sign byte s = bp+4
;301 var sign word fd = bp+6
;302 var sign word len = bp+8;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt
;-90 int fputcR(char *n, int fd) {

 LEAVE
 ret
ENDP

fputcR: PROC
;-91 //    dx=n;

;-92     __asm{lea dx, [bp+4]}; /* = *n */

;Function : fputcR, Number local Var: 2
; # type sign width local variables
;300 ptr sign byte n = bp+4
;301 var sign word fd = bp+6;
 ENTER  0,0
lea dx, [bp+4]
;-93     cx=1;

 mov  cx, 1
;-94     bx=fd;

 mov  bx, [bp+6]
;-95     ax=0x4000;

 mov  ax, 16384
;-96     DosInt();

 call DosInt
;-97 }

;-98 int setdta(char *s) {dx=s; ah=0x1A; __emit__(0xCD,0x21); }

 LEAVE
 ret
ENDP

setdta: PROC
;Function : setdta, Number local Var: 1
; # type sign width local variables
;300 ptr sign byte s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ah, 26
 db 205,33
;-99 int ffirst(char *s) {dx=s; ah=0x4E; cx=0x1E; DosInt(); }

 LEAVE
 ret
ENDP

ffirst: PROC
;Function : ffirst, Number local Var: 1
; # type sign width local variables
;300 ptr sign byte s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ah, 78
 mov  cx, 30
 call DosInt
;-100 int fnext (char *s) {dx=s; ah=0x4F; cx=0x1E; DosInt(); }

 LEAVE
 ret
ENDP

fnext: PROC
;Function : fnext, Number local Var: 1
; # type sign width local variables
;300 ptr sign byte s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ah, 79
 mov  cx, 30
 call DosInt
;-101 

;-102 int printhex4(unsigned char c) {

 LEAVE
 ret
ENDP

printhex4: PROC
;-103     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;300 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-104     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex45
 add  byte[bp+4], 7
;-105     putch(c);

.printhex45:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-106 }

;-107 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-108     unsigned char nib;

;-109     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;300 var unsg byte c = bp+4
;301 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-110     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-111 }

;-112 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-113     unsigned int half;

;-114     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;300 var unsg word i = bp+4
;301 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-115     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-116 }

;-117 

;-118 int prunsign(unsigned int n) {

 LEAVE
 ret
ENDP

prunsign: PROC
;-119     unsigned int e;

;-120     if (n >= 10) {

;Function : prunsign, Number local Var: 2
; # type sign width local variables
;300 var unsg word n = bp+4
;301 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .prunsign6
;-121         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-122         prunsign(e);

 push word [bp-2]
 call prunsign
 add  sp, 2
;-123         }

;-124     n=n%10;

.prunsign6:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-125     n+='0';

 add  word[bp+4], 48
;-126     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-127 }

;-128 int letter(char c) {

 LEAVE
 ret
ENDP

letter: PROC
;-129   if (c> 'z') return 0;

;Function : letter, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 122
 jle .letter7
 mov ax, 0
 jmp .retnletter
;-130   if (c< 'A') return 0;

.letter7:
 mov al, [bp+4]
 cmp al, 65
 jge .letter8
 mov ax, 0
 jmp .retnletter
;-131   if (c> 'Z') { if (c< 'a') return 0; }

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
;-132   return 1;

.letter9:
 mov ax, 1
 jmp .retnletter
;-133 }

;-134 int digit(char c){

 .retnletter:
 LEAVE
 ret
ENDP

digit: PROC
;-135     if(c<'0') return 0;

;Function : digit, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit11
 mov ax, 0
 jmp .retndigit
;-136     if(c>'9') return 0;

.digit11:
 mov al, [bp+4]
 cmp al, 57
 jle .digit12
 mov ax, 0
 jmp .retndigit
;-137     return 1;

.digit12:
 mov ax, 1
 jmp .retndigit
;-138 }

;-139 int strlen(char *s) { int c;

 .retndigit:
 LEAVE
 ret
ENDP

strlen: PROC
;-140     c=0;

;Function : strlen, Number local Var: 2
; # type sign width local variables
;300 ptr sign byte s = bp+4
;301 var sign word c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-141     while (*s!=0) {s++; c++;}

.strlen13:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen14
 inc  word[bp+4]
 inc  word[bp-2]
;-142     return c;

 jmp .strlen13
.strlen14:
 mov ax, [bp-2]
 jmp .retnstrlen
;-143     }

;-144 int strcpy(char *s, char *t) {

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-145     do { *s=*t; s++; t++; }

;Function : strcpy, Number local Var: 2
; # type sign width local variables
;300 ptr sign byte s = bp+4
;301 ptr sign byte t = bp+6;
 ENTER  0,0
.strcpy15:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-146     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy16
 jmp .strcpy15
.strcpy16:
;-147     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-148     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-149 }

;-150 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-151     while(*p) {

;Function : eqstr, Number local Var: 2
; # type sign width local variables
;300 ptr sign byte p = bp+4
;301 ptr sign byte q = bp+6;
 ENTER  0,0
.eqstr17:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr18
;-152         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr19
 mov ax, 0
 jmp .retneqstr
;-153             p++;

.eqstr19:
 inc  word[bp+4]
;-154             q++;

 inc  word[bp+6]
;-155         }

;-156     if(*q) return 0;

 jmp .eqstr17
.eqstr18:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr20
 mov ax, 0
 jmp .retneqstr
;-157     return 1;

.eqstr20:
 mov ax, 1
 jmp .retneqstr
;-158 }

;-159 int toupper(char *s) {

 .retneqstr:
 LEAVE
 ret
ENDP

toupper: PROC
;-160     while(*s) {

;Function : toupper, Number local Var: 1
; # type sign width local variables
;300 ptr sign byte s = bp+4;
 ENTER  0,0
.toupper21:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper22
;-161         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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
;-162             s++;

.toupper24:
.toupper23:
 inc  word[bp+4]
;-163     }

;-164 }

 jmp .toupper21
.toupper22:
;-165 int atoi(char *s) {

 LEAVE
 ret
ENDP

atoi: PROC
;-166     char c;

;-167     unsigned int i; unsigned int j;

;-168     i=0;

;Function : atoi, Number local Var: 4
; # type sign width local variables
;300 ptr sign byte s = bp+4
;301 var sign byte c = bp-2
;302 var unsg word i = bp-4
;303 var unsg word j = bp-6;
 ENTER  6,0
 mov ax, 0
 mov [bp-4], ax
;-169     while (*s) {

.atoi25:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .atoi26
;-170         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-171         c-=48;

 sub  byte[bp-2], 48
;-172         i=i*10;

 mov ax, [bp-4]
 mov bx, 10
 mul bx
 mov [bp-4], ax
;-173         j=0;

 mov ax, 0
 mov [bp-6], ax
;-174         j=c;//c2i

 mov al, [bp-2]
 mov [bp-6], ax
;-175         i=i+j;

 mov ax, [bp-4]
 add ax, [bp-6]
 mov [bp-4], ax
;-176         s++;

 inc  word[bp+4]
;-177         }

;-178     return i;

 jmp .atoi25
.atoi26:
 mov ax, [bp-4]
 jmp .retnatoi
;-179 }

;-180 

;-181 

;-182 int setblock(unsigned int i) {

 .retnatoi:
 LEAVE
 ret
ENDP

setblock: PROC
;-183     DOS_ERR=0;

;Function : setblock, Number local Var: 1
; # type sign width local variables
;300 var unsg word i = bp+4;
 ENTER  0,0
 mov ax, 0
 mov word [DOS_ERR], ax
;-184     bx=i;

 mov  bx, [bp+4]
;-185     ax=cs;

 mov  ax, cs
;-186     es=ax;

 mov  es, ax
;-187     ax=0x4A00;

 mov  ax, 18944
;-188     DosInt();

 call DosInt
;-189 //modify memory Allocation. IN: ES=Block Seg, BX=size in para

;-190     asm mov [vAX], ax; vAX=ax;

 mov [vAX], ax; vAX=ax;
;-191     asm mov [vBX], bx; vBX=bx;

 mov [vBX], bx; vBX=bx;
;-192     if (DOS_ERR) cputs(" ***Error SetBlock***");

 mov ax, [DOS_ERR]
 or  al, al
 je .setblock27
 push setblock_0
 call cputs
 add  sp, 2
;-193 //    7=MCB destroyed, 8=Insufficient memory, 90=Invalid block address

;-194 //    BX=Max mem available, if CF & AX=8

;-195 //    cputs(" AX:"); printhex16(vAX);

;-196 //    cputs(", BX:"); printhex16(vBX);

;-197 }

.setblock27:
;-198 

;-199 int Env_seg=0; //Take over Master Environment, do not change

 LEAVE
 ret
setblock_0 db " ***Error SetBlock***",0
ENDP
Env_seg dw 0
;-200 int Cmd_ofs=0;     int Cmd_seg=0;

Cmd_ofs dw 0
Cmd_seg dw 0
;-201 int FCB_ofs1=0x5C; int FCB_seg1=0;

FCB_ofs1 dw 92
FCB_seg1 dw 0
;-202 int FCB_ofs2=0x6C; int FCB_seg2=0;

FCB_ofs2 dw 108
FCB_seg2 dw 0
;-203 char FCB1=0; char FCB1A[]="           ";

FCB1 db 0
FCB1A db "           ",0
;-204 char FCB1B[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

FCB1B db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;-205 char FCB2=0; char FCB2A[]="           ";

FCB2 db 0
FCB2A db "           ",0
;-206 char FCB2B[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

FCB2B db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;-207 // structure until here

;-208 char FNBuf[64];

section .bss
absolute 25000
FNBuf resb 64
section .text
;-209 char inp_buf[81];

section .bss
absolute 25064
inp_buf resb 81
section .text
;-210 

;-211 int getcurdir() {


getcurdir: PROC
;-212     si=&FNBuf;

 mov  si, FNBuf
;-213     dl=0;

 mov  dl, 0
;-214     ah=0x47;

 mov  ah, 71
;-215     DosInt();

 call DosInt
;-216     asm mov [vAX], ax; vAX=ax;

 mov [vAX], ax; vAX=ax;
;-217     asm mov [vBX], bx; vBX=bx;

 mov [vBX], bx; vBX=bx;
;-218     if (DOS_ERR) cputs(" ***Error GetCurrentDir***");

 mov ax, [DOS_ERR]
 or  al, al
 je .getcurdir28
 push getcurdir_0
 call cputs
 add  sp, 2
;-219 }

.getcurdir28:
;-220 

;-221     int stkseg;

 ret
getcurdir_0 db " ***Error GetCurrentDir***",0
ENDP
stkseg dw 0
;-222     int stkptr;

stkptr dw 0
;-223 int exec1(char *Datei1, char *ParmBlk, char *CmdLine1) {


exec1: PROC
;-224     putch(10);

;Function : exec1, Number local Var: 3
; # type sign width local variables
;300 ptr sign byte Datei1 = bp+4
;301 ptr sign byte ParmBlk = bp+6
;302 ptr sign byte CmdLine1 = bp+8;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-225     __emit__(0x26,0xA1,0x2C,0);//asm mov ax, [es:2ch]

 db 38,161,44,0
;-226 

;-227     asm mov [Env_seg], ax

 mov [Env_seg], ax
;-228     Cmd_ofs = CmdLine1;

 mov ax, [bp+8]
 mov word [Cmd_ofs], ax
;-229     ax      =es;

 mov  ax, es
;-230     asm mov [Cmd_seg],  ds

 mov [Cmd_seg],  ds
;-231     asm mov [FCB_seg1], ax

 mov [FCB_seg1], ax
;-232     asm mov [FCB_seg2], ax

 mov [FCB_seg2], ax
;-233     asm mov [stkseg],   ss

 mov [stkseg],   ss
;-234     asm mov [stkptr],   sp

 mov [stkptr],   sp
;-235     dx=Datei1;

 mov  dx, [bp+4]
;-236     bx=ParmBlk;

 mov  bx, [bp+6]
;-237     ax=0x4B00;

 mov  ax, 19200
;-238     DosInt();

 call DosInt
;-239     asm mov [vAX], ax

 mov [vAX], ax
;-240     ss=stkseg;

 mov  ss, [stkseg]
;-241     sp=stkptr;

 mov  sp, [stkptr]
;-242     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .exec129
;-243         cputs("*****EXEC ERROR Code: ");

 push exec1_0
 call cputs
 add  sp, 2
;-244         printhex16(vAX);

 push word [vAX]
 call printhex16
 add  sp, 2
;-245 }       }

.exec129:
;-246 

;-247 char inp_len=0;

 LEAVE
 ret
exec1_0 db "*****EXEC ERROR Code: ",0
ENDP
inp_len db 0
;-248 

;-249 int dodos() {


dodos: PROC
;-250     char *p; int h;

;-251     strcpy(inp_buf, " ");

;Function : dodos, Number local Var: 2
; # type sign width local variables
;300 ptr sign byte p = bp-2
;301 var sign word h = bp-4;
 ENTER  4,0
 push dodos_0
 lea  ax, [inp_buf]
 push ax
 call strcpy
 add  sp, 4
;-252     h=strlen(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call strlen
 add  sp, 2
 mov [bp-4], ax
;-253     inp_len=h & 255;

 mov ax, [bp-4]
 and ax, 255
 mov byte [inp_len], al
;-254     p=&inp_buf+h;

 mov ax, inp_buf
 add ax, [bp-4]
 mov [bp-2], ax
;-255     *p=0;

 mov ax, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-256     cputs("Before DOS: ");

 push dodos_1
 call cputs
 add  sp, 2
;-257     cputs(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call cputs
 add  sp, 2
;-258     exec1("Z:\COMMAND.COM", &Env_seg, &inp_len);

 lea  ax, [inp_len]
 push ax
 lea  ax, [Env_seg]
 push ax
 push dodos_2
 call exec1
 add  sp, 6
;-259 }

;-260 

;-261 int extrinsic(char *s) {

 LEAVE
 ret
dodos_0 db " ",0
dodos_1 db "Before DOS: ",0
dodos_2 db "Z:\COMMAND.COM",0
ENDP

extrinsic: PROC
;-262     char *p;

;-263     inp_len=strlen(inp_buf);

;Function : extrinsic, Number local Var: 2
; # type sign width local variables
;300 ptr sign byte s = bp+4
;301 ptr sign byte p = bp-2;
 ENTER  2,0
 lea  ax, [inp_buf]
 push ax
 call strlen
 add  sp, 2
 mov byte [inp_len], al
;-264     if (inp_len == 0) return;

 mov al, [inp_len]
 cmp al, 0
 jne .extrinsic30
 jmp .retnextrinsic
;-265     p=&inp_buf+inp_len;

.extrinsic30:
 mov ax, inp_buf
 add al, [inp_len]
 mov [bp-2], ax
;-266     *p=0;

 mov ax, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-267     waitkey();

 call waitkey
;-268     exec1(inp_buf, &Env_seg, &inp_len);

 lea  ax, [inp_len]
 push ax
 lea  ax, [Env_seg]
 push ax
 lea  ax, [inp_buf]
 push ax
 call exec1
 add  sp, 6
;-269 }

;-270 

;-271 

;-272 int mdump(unsigned char *adr, unsigned int len ) {

 .retnextrinsic:
 LEAVE
 ret
ENDP

mdump: PROC
;-273     unsigned char c;

;-274     int i;

;-275     int j;

;-276     j=0;

;Function : mdump, Number local Var: 5
; # type sign width local variables
;300 ptr unsg byte adr = bp+4
;301 var unsg word len = bp+6
;302 var unsg byte c = bp-2
;303 var sign word i = bp-4
;304 var sign word j = bp-6;
 ENTER  6,0
 mov ax, 0
 mov [bp-6], ax
;-277     while (j < len ) {

.mdump31:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump32
;-278         putch(10);

 push 10
 call putch
 add  sp, 2
;-279         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-280         putch(':');

 push 58
 call putch
 add  sp, 2
;-281         i=0;

 mov ax, 0
 mov [bp-4], ax
;-282         while (i < 16) {

.mdump33:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump34
;-283             putch(' ');

 push 32
 call putch
 add  sp, 2
;-284             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-285             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-286             adr++;

 inc  word[bp+4]
;-287             i++;

 inc  word[bp-4]
;-288             j++;

 inc  word[bp-6]
;-289             }

;-290         putch(' ');

 jmp .mdump33
.mdump34:
 push 32
 call putch
 add  sp, 2
;-291         adr -=16;

 sub  word[bp+4], 16
;-292         i=0;

 mov ax, 0
 mov [bp-4], ax
;-293         while(i < 16) {

.mdump35:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump36
;-294             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-295             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump37
 push 46
 call putch
 add  sp, 2
;-296                 else putch(c);

 jmp .mdump38
.mdump37:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-297             adr++;

.mdump38:
 inc  word[bp+4]
;-298             i++;

 inc  word[bp-4]
;-299         }

;-300     }

 jmp .mdump35
.mdump36:
;-301 }

 jmp .mdump31
.mdump32:
;-302 

;-303 int dodump() {

 LEAVE
 ret
ENDP

dodump: PROC
;-304     unsigned int i;

;-305     i=atoi(par2);

;Function : dodump, Number local Var: 1
; # type sign width local variables
;300 var unsg word i = bp-2;
 ENTER  2,0
 push word [par2]
 call atoi
 add  sp, 2
 mov [bp-2], ax
;-306     mdump(i, 120);

 push 120
 push word [bp-2]
 call mdump
 add  sp, 4
;-307     putch(10);

 push 10
 call putch
 add  sp, 2
;-308 }

;-309 

;-310 char path[]="*.*";

 LEAVE
 ret
ENDP
path db "*.*",0
;-311 char direcord[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};//21 do not change

direcord db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;-312 char dirattr=0;

dirattr db 0
;-313 int  dirtime=0;

dirtime dw 0
;-314 int  dirdate=0;

dirdate dw 0
;-315 int  dirlenlo=0;

dirlenlo dw 0
;-316 int  dirlenhi=0;

dirlenhi dw 0
;-317 char dirdatname[]={0,0,0,0,0,0,0,0,0,0,0,0,0};//13 structure until here

dirdatname db 0,0,0,0,0,0,0,0,0,0,0,0,0
;-318 

;-319 int dodir() {


dodir: PROC
;-320     int j;

;-321     char c;

;-322     getcurdir();

;Function : dodir, Number local Var: 2
; # type sign width local variables
;300 var sign word j = bp-2
;301 var sign byte c = bp-4;
 ENTER  4,0
 call getcurdir
;-323     cputs("Current directory: ");

 push dodir_0
 call cputs
 add  sp, 2
;-324     cputs(FNBuf);

 lea  ax, [FNBuf]
 push ax
 call cputs
 add  sp, 2
;-325     putch(10);

 push 10
 call putch
 add  sp, 2
;-326 

;-327     setdta(direcord);

 lea  ax, [direcord]
 push ax
 call setdta
 add  sp, 2
;-328 

;-329     ffirst(path);

 lea  ax, [path]
 push ax
 call ffirst
 add  sp, 2
;-330     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dodir39
;-331         cputs("Empty directory ");

 push dodir_1
 call cputs
 add  sp, 2
;-332         return;

 jmp .retndodir
;-333         }

;-334     cputs("Name             Date   Time Attr   Size");

.dodir39:
 push dodir_2
 call cputs
 add  sp, 2
;-335   do {

.dodir40:
;-336         putch(10);

 push 10
 call putch
 add  sp, 2
;-337         cputs(dirdatname);

 lea  ax, [dirdatname]
 push ax
 call cputs
 add  sp, 2
;-338         j=strlen(dirdatname);

 lea  ax, [dirdatname]
 push ax
 call strlen
 add  sp, 2
 mov [bp-2], ax
;-339         do {

.dodir41:
;-340             putch(' ');

 push 32
 call putch
 add  sp, 2
;-341             j++;

 inc  word[bp-2]
;-342             } while (j<13);

 mov ax, [bp-2]
 cmp ax, 13
 jge .dodir42
 jmp .dodir41
.dodir42:
;-343 

;-344         j=dirdate & 31;

 mov ax, [dirdate]
 and ax, 31
 mov [bp-2], ax
;-345         if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir43
 push 32
 call putch
 add  sp, 2
;-346         prunsign(j);

.dodir43:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-347         putch('.');

 push 46
 call putch
 add  sp, 2
;-348 

;-349         j=dirdate >> 5;

 mov ax, [dirdate]
 shr ax, 5
 mov [bp-2], ax
;-350         j&=  15;

 and  word[bp-2], 15
;-351         if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir44
 push 48
 call putch
 add  sp, 2
;-352         prunsign(j);

.dodir44:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-353         putch('.');

 push 46
 call putch
 add  sp, 2
;-354 

;-355         j=dirdate >> 9;

 mov ax, [dirdate]
 shr ax, 9
 mov [bp-2], ax
;-356         j+=  80;

 add  word[bp-2], 80
;-357         if (j>=100) j-=100;

 mov ax, [bp-2]
 cmp ax, 100 ;unsigned : 1
 jl  .dodir45
 sub  word[bp-2], 100
;-358         if (j<10) putch('0');

.dodir45:
 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir46
 push 48
 call putch
 add  sp, 2
;-359         prunsign(j);

.dodir46:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-360         putch(' ');

 push 32
 call putch
 add  sp, 2
;-361         putch(' ');

 push 32
 call putch
 add  sp, 2
;-362 

;-363         j=dirtime  >>11;

 mov ax, [dirtime]
 shr ax, 11
 mov [bp-2], ax
;-364         if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir47
 push 32
 call putch
 add  sp, 2
;-365         prunsign(j);

.dodir47:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-366         putch(':');

 push 58
 call putch
 add  sp, 2
;-367 

;-368         j=dirtime  >> 5;

 mov ax, [dirtime]
 shr ax, 5
 mov [bp-2], ax
;-369         j&=  63;

 and  word[bp-2], 63
;-370         if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir48
 push 48
 call putch
 add  sp, 2
;-371         prunsign(j);

.dodir48:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-372         putch(' ');

 push 32
 call putch
 add  sp, 2
;-373 

;-374         c = dirattr & 32;

 mov al, [dirattr]
 and al, 32
 mov [bp-4], al
;-375         if (c) putch('A'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir49
 push 65
 call putch
 add  sp, 2
 jmp .dodir50
.dodir49:
 push 32
 call putch
 add  sp, 2
;-376         c = dirattr & 16;

.dodir50:
 mov al, [dirattr]
 and al, 16
 mov [bp-4], al
;-377         if (c) putch('D'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir51
 push 68
 call putch
 add  sp, 2
 jmp .dodir52
.dodir51:
 push 32
 call putch
 add  sp, 2
;-378         c = dirattr & 8;

.dodir52:
 mov al, [dirattr]
 and al, 8
 mov [bp-4], al
;-379         if (c) putch('V'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir53
 push 86
 call putch
 add  sp, 2
 jmp .dodir54
.dodir53:
 push 32
 call putch
 add  sp, 2
;-380         c = dirattr & 4;

.dodir54:
 mov al, [dirattr]
 and al, 4
 mov [bp-4], al
;-381         if (c) putch('S'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir55
 push 83
 call putch
 add  sp, 2
 jmp .dodir56
.dodir55:
 push 32
 call putch
 add  sp, 2
;-382         c = dirattr & 2;

.dodir56:
 mov al, [dirattr]
 and al, 2
 mov [bp-4], al
;-383         if (c) putch('H'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir57
 push 72
 call putch
 add  sp, 2
 jmp .dodir58
.dodir57:
 push 32
 call putch
 add  sp, 2
;-384         c = dirattr & 1;

.dodir58:
 mov al, [dirattr]
 and al, 1
 mov [bp-4], al
;-385         if (c) putch('R'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir59
 push 82
 call putch
 add  sp, 2
 jmp .dodir60
.dodir59:
 push 32
 call putch
 add  sp, 2
;-386 

;-387         if (dirlenhi) {

.dodir60:
 mov ax, [dirlenhi]
 or  al, al
 je .dodir61
;-388             dirlenlo=dirlenlo >>10;

 mov ax, [dirlenlo]
 shr ax, 10
 mov word [dirlenlo], ax
;-389             dirlenhi=dirlenhi << 6;

 mov ax, [dirlenhi]
 shl ax, 6
 mov word [dirlenhi], ax
;-390             dirlenhi=dirlenhi+dirlenlo;

 mov ax, [dirlenhi]
 add ax, [dirlenlo]
 mov word [dirlenhi], ax
;-391             putch(' ');

 push 32
 call putch
 add  sp, 2
;-392             prunsign(dirlenhi);

 push word [dirlenhi]
 call prunsign
 add  sp, 2
;-393             cputs(" KB");

 push dodir_3
 call cputs
 add  sp, 2
;-394             }

;-395         else {

 jmp .dodir62
.dodir61:
;-396             putch(' ');

 push 32
 call putch
 add  sp, 2
;-397             prunsign(dirlenlo);

 push word [dirlenlo]
 call prunsign
 add  sp, 2
;-398             }

;-399     j=fnext(path);

.dodir62:
 lea  ax, [path]
 push ax
 call fnext
 add  sp, 2
 mov [bp-2], ax
;-400     } while (j!=18);

 mov ax, [bp-2]
 cmp ax, 18
 je  .dodir63
 jmp .dodir40
.dodir63:
;-401     putch(10);

 push 10
 call putch
 add  sp, 2
;-402 }

;-403 

;-404 

;-405 char memSignature;

 .retndodir:
 LEAVE
 ret
dodir_0 db "Current directory: ",0
dodir_1 db "Empty directory ",0
dodir_2 db "Name             Date   Time Attr   Size",0
dodir_3 db " KB",0
ENDP
memSignature db 0
;-406 unsigned int memOwner;

memOwner dw 0
;-407 unsigned int memSize;

memSize dw 0
;-408 

;-409 int domem() {


domem: PROC
;-410     unsigned int i;

;-411     char c;

;-412     ah=0x52;//DOS list of lists

;Function : domem, Number local Var: 2
; # type sign width local variables
;300 var unsg word i = bp-2
;301 var sign byte c = bp-4;
 ENTER  4,0
 mov  ah, 82
;-413     asm int 33 ; // out= ES:BX ptr to invars

 int 33 ; // out= ES:BX ptr to invars
;-414     asm mov [vBX], bx

 mov [vBX], bx
;-415 //    asm mov es, [es:bx-2]//first memory control block

;-416     __emit__(0x26,0x8E,0x47,0xFE);

 db 38,142,71,254
;-417     asm mov [vES], es

 mov [vES], es
;-418     do {

.domem64:
;-419         putch(10);

 push 10
 call putch
 add  sp, 2
;-420         cputs("Start:");

 push domem_0
 call cputs
 add  sp, 2
;-421         printhex16(vES);

 push word [vES]
 call printhex16
 add  sp, 2
;-422         if (vES >= 0xA000) cputs(" MCB in UMB");

 mov ax, [vES]
 cmp ax, 40960 ;unsigned : 0
 jb  .domem65
 push domem_1
 call cputs
 add  sp, 2
;-423 //        asm mov al, [es:0]// M or Z

;-424         __emit__(0x26,0xA0,0,0);

.domem65:
 db 38,160,0,0
;-425         asm mov [memSignature], al

 mov [memSignature], al
;-426 //        cputs(", ");

;-427 //        putch(memSignature);

;-428 //        asm mov ax, [es:1]//program segment prefix

;-429         __emit__(0x26,0xA1,1,0);

 db 38,161,1,0
;-430         asm mov [memOwner], ax

 mov [memOwner], ax
;-431         cputs(", PSP:");

 push domem_2
 call cputs
 add  sp, 2
;-432         printhex16(memOwner);

 push word [memOwner]
 call printhex16
 add  sp, 2
;-433 //        asm mov ax, [es:3]//size in para

;-434         __emit__(0x26,0xA1,3,0);

 db 38,161,3,0
;-435         asm mov [memSize], ax

 mov [memSize], ax
;-436         cputs(", Size:");

 push domem_3
 call cputs
 add  sp, 2
;-437         printhex16(memSize);

 push word [memSize]
 call printhex16
 add  sp, 2
;-438         if (memOwner == 0) cputs(" free");

 mov ax, [memOwner]
 cmp ax, 0
 jne .domem66
 push domem_4
 call cputs
 add  sp, 2
;-439         if (memOwner == 8) cputs(" DOS ");

.domem66:
 mov ax, [memOwner]
 cmp ax, 8
 jne .domem67
 push domem_5
 call cputs
 add  sp, 2
;-440         i=memOwner-vES;

.domem67:
 mov ax, [memOwner]
 sub ax, [vES]
 mov [bp-2], ax
;-441     vES = vES + memSize;

 mov ax, [vES]
 add ax, [memSize]
 mov word [vES], ax
;-442     vES++;

 inc  word[vES]
;-443     asm mov es, vES

 mov es, vES
;-444     es = vES;

 mov  es, [vES]
;-445     }

;-446     while (memSignature == 'M');

 mov al, [memSignature]
 cmp al, 77
 jne .domem68
 jmp .domem64
.domem68:
;-447     putch(10);

 push 10
 call putch
 add  sp, 2
;-448 }

;-449 

;-450 int dotype() {

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
;-451     int fdin; int i;

;-452     fdin=openR(par2);

;Function : dotype, Number local Var: 2
; # type sign width local variables
;300 var sign word fdin = bp-2
;301 var sign word i = bp-4;
 ENTER  4,0
 push word [par2]
 call openR
 add  sp, 2
 mov [bp-2], ax
;-453     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dotype69
;-454         cputs("file missing");

 push dotype_0
 call cputs
 add  sp, 2
;-455         putch(10);

 push 10
 call putch
 add  sp, 2
;-456         return;

 jmp .retndotype
;-457         }

;-458     do {

.dotype69:
.dotype70:
;-459         DOS_NoBytes=readR(&DOS_ByteRead, fdin);

 push word [bp-2]
 lea  ax, [DOS_ByteRead]
 push ax
 call readR
 add  sp, 4
 mov word [DOS_NoBytes], ax
;-460         putch(DOS_ByteRead);

 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-461         }

;-462         while (DOS_NoBytes);

 mov ax, [DOS_NoBytes]
 or  al, al
 je .dotype71
 jmp .dotype70
.dotype71:
;-463     fcloseR(fdin);

 push word [bp-2]
 call fcloseR
 add  sp, 2
;-464 }

;-465 

;-466 int Prompt1(unsigned char *s) {

 .retndotype:
 LEAVE
 ret
dotype_0 db "file missing",0
ENDP

Prompt1: PROC
;-467     char c;

;-468     unsigned char *startstr;

;-469     startstr=s;

;Function : Prompt1, Number local Var: 3
; # type sign width local variables
;300 ptr unsg byte s = bp+4
;301 var sign byte c = bp-2
;302 ptr unsg byte startstr = bp-4;
 ENTER  4,0
 mov ax, [bp+4]
 mov [bp-4], ax
;-470     do {

.Prompt172:
;-471         c=getkey();

 call getkey
 mov [bp-2], al
;-472         if (c == 27)    exitR(1);//good bye

 mov al, [bp-2]
 cmp al, 27
 jne .Prompt173
 push 1
 call exitR
 add  sp, 2
;-473         if (c==8) {

.Prompt173:
 mov al, [bp-2]
 cmp al, 8
 jne .Prompt174
;-474             if (s > startstr){

 mov ax, [bp+4]
 cmp ax, [bp-4]
 jle .Prompt175
;-475                 s--;

 dec  word[bp+4]
;-476                 putch(8);

 push 8
 call putch
 add  sp, 2
;-477                 putch(' ');

 push 32
 call putch
 add  sp, 2
;-478                 putch(8);

 push 8
 call putch
 add  sp, 2
;-479                 }

;-480                 else putch(7);

 jmp .Prompt176
.Prompt175:
 push 7
 call putch
 add  sp, 2
;-481             }

.Prompt176:
;-482             else {

 jmp .Prompt177
.Prompt174:
;-483                 *s=c;

 mov al, [bp-2]
 mov  bx, [bp+4]
 mov  [bx], al
;-484                 s++;

 inc  word[bp+4]
;-485                 putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-486             }

;-487     } while(c!=13);

.Prompt177:
 mov al, [bp-2]
 cmp al, 13
 je  .Prompt178
 jmp .Prompt172
.Prompt178:
;-488     s--;

 dec  word[bp+4]
;-489     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-490 }

;-491 

;-492 char Info1[]=" commands: help,exit,cls,type,mem,dir,dump (adr),exec,dos,*COM";

 LEAVE
 ret
ENDP
Info1 db " commands: help,exit,cls,type,mem,dir,dump (adr),exec,dos,*COM",0
;-493 

;-494 int dohelp() {


dohelp: PROC
;-495     unsigned int i;

;-496     cputs(Version1);

;Function : dohelp, Number local Var: 1
; # type sign width local variables
;300 var unsg word i = bp-2;
 ENTER  2,0
 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2
;-497     cputs(Info1);

 lea  ax, [Info1]
 push ax
 call cputs
 add  sp, 2
;-498     putch(10);

 push 10
 call putch
 add  sp, 2
;-499 }

;-500 

;-501 

;-502 int getpar(char *t) {

 LEAVE
 ret
ENDP

getpar: PROC
;-503     while (*t == 32) t++;

;Function : getpar, Number local Var: 1
; # type sign width local variables
;300 ptr sign byte t = bp+4;
 ENTER  0,0
.getpar79:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar80
 inc  word[bp+4]
;-504     if (*t<=13) return 0;

 jmp .getpar79
.getpar80:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar81
 mov ax, 0
 jmp .retngetpar
;-505 

;-506     par1=t;

.getpar81:
 mov ax, [bp+4]
 mov word [par1], ax
;-507     while(*t >= 33) t++;

.getpar82:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar83
 inc  word[bp+4]
;-508     if (*t==0) return 1;

 jmp .getpar82
.getpar83:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar84
 mov ax, 1
 jmp .retngetpar
;-509     *t=0;

.getpar84:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-510     t++;

 inc  word[bp+4]
;-511     while (*t == 32) t++;

.getpar85:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar86
 inc  word[bp+4]
;-512     if (*t<=13) return 1;

 jmp .getpar85
.getpar86:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar87
 mov ax, 1
 jmp .retngetpar
;-513 

;-514     par2=t;

.getpar87:
 mov ax, [bp+4]
 mov word [par2], ax
;-515     while(*t >= 33) t++;

.getpar88:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar89
 inc  word[bp+4]
;-516     if (*t==0) return 2;

 jmp .getpar88
.getpar89:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar90
 mov ax, 2
 jmp .retngetpar
;-517     *t=0;

.getpar90:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-518     t++;

 inc  word[bp+4]
;-519     while (*t == 32) t++;

.getpar91:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar92
 inc  word[bp+4]
;-520     if (*t<=13) return 2;

 jmp .getpar91
.getpar92:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar93
 mov ax, 2
 jmp .retngetpar
;-521 

;-522     par3=t;

.getpar93:
 mov ax, [bp+4]
 mov word [par3], ax
;-523     while(*t >= 33) t++;

.getpar94:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar95
 inc  word[bp+4]
;-524     *t=0;

 jmp .getpar94
.getpar95:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-525     return 3;

 mov ax, 3
 jmp .retngetpar
;-526 }

;-527 

;-528 int intrinsic() {

 .retngetpar:
 LEAVE
 ret
ENDP

intrinsic: PROC
;-529     toupper(par1);

 push word [par1]
 call toupper
 add  sp, 2
;-530     if(eqstr(par1,"HELP")){dohelp();return;}

 push intrinsic_0
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic96
 call dohelp
 jmp .retnintrinsic
;-531     if(eqstr(par1,"EXIT"))exitR(0);

.intrinsic96:
 push intrinsic_1
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic97
 push 0
 call exitR
 add  sp, 2
;-532     if(eqstr(par1,"CLS" )){clrscr();return;}

.intrinsic97:
 push intrinsic_2
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic98
 call clrscr
 jmp .retnintrinsic
;-533     if(eqstr(par1,"TYPE")){dotype();return;}

.intrinsic98:
 push intrinsic_3
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic99
 call dotype
 jmp .retnintrinsic
;-534     if(eqstr(par1,"MEM" )){domem(); return;}

.intrinsic99:
 push intrinsic_4
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic100
 call domem
 jmp .retnintrinsic
;-535     if(eqstr(par1,"DIR" )){dodir();return;}

.intrinsic100:
 push intrinsic_5
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic101
 call dodir
 jmp .retnintrinsic
;-536     if(eqstr(par1,"DUMP")){dodump();return;}

.intrinsic101:
 push intrinsic_6
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic102
 call dodump
 jmp .retnintrinsic
;-537     if(eqstr(par1,"DOS" )){dodos(); return;}

.intrinsic102:
 push intrinsic_7
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic103
 call dodos
 jmp .retnintrinsic
;-538     if(eqstr(par1,"EXEC")){exec1 ();return;}

.intrinsic103:
 push intrinsic_8
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic104
 call exec1
 jmp .retnintrinsic
;-539     extrinsic(inp_buf);

.intrinsic104:
 lea  ax, [inp_buf]
 push ax
 call extrinsic
 add  sp, 2
;-540 }

;-541 

;-542 

;-543 int get_cmd(){

 .retnintrinsic:
 ret
intrinsic_0 db "HELP",0
intrinsic_1 db "EXIT",0
intrinsic_2 db "CLS",0
intrinsic_3 db "TYPE",0
intrinsic_4 db "MEM",0
intrinsic_5 db "DIR",0
intrinsic_6 db "DUMP",0
intrinsic_7 db "DOS",0
intrinsic_8 db "EXEC",0
ENDP

get_cmd: PROC
;-544     *inp_buf=0;

 mov ax, 0
 mov  bx, [inp_buf]
 mov  [bx], al
;-545     DOS_ERR=0;

 mov ax, 0
 mov word [DOS_ERR], ax
;-546     putch(':');

 push 58
 call putch
 add  sp, 2
;-547     Prompt1(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call Prompt1
 add  sp, 2
;-548     putch(10);

 push 10
 call putch
 add  sp, 2
;-549 }

;-550 

;-551 int main() {

 ret
ENDP

main: PROC
;-552     setblock(4096);

 push 4096
 call setblock
 add  sp, 2
;-553     dohelp();

 call dohelp
;-554     do {

.main105:
;-555         get_cmd();

 call get_cmd
;-556         par_count=getpar(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call getpar
 add  sp, 2
 mov byte [par_count], al
;-557         intrinsic();

 call intrinsic
;-558         }

;-559     while(1);

 mov ax, 1
 or  al, al
 je .main106
 jmp .main105
.main106:
;-560 }

 ret
ENDP
;Glob. variables:41 (300), Functions:47 (300), Lines:561
;Constant: 221 (3000), stacksize: 40391