;PLA compiler A.COM V0.9.6, Input: CMD.C, Output: CMD.S
org  256 
jmp main
;-1 char Version1[]="CMD V0.5";//Command.com for 1OS        

Version1 db "CMD V0.5",0
;-2 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }


writetty: PROC
 mov  ah, 14
 mov  bx, 0
 db 205,16
;-3 int putch(char c)  {if (c==10) {al=13; writetty();} al=c; writetty(); }

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
;-4 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }

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
;-5 

;-6 int gotoxy (char x, char y) {

 LEAVE
 ret
ENDP

gotoxy: PROC
;-7     ah=2;
;
 ENTER  0,0
 mov  ah, 2
;-8     bx=0;

 mov  bx, 0
;-9     dh=y;

 mov  dh, [bp+6]
;-10     dl=x;

 mov  dl, [bp+4]
;-11     __emit__(0xCD,0x10);

 db 205,16
;-12 }

;-13 int clrscr()    {

 LEAVE
 ret
ENDP

clrscr: PROC
;-14     ax=0x0600;

 mov  ax, 1536
;-15     bh=7;

 mov  bh, 7
;-16     cx=0;

 mov  cx, 0
;-17     dx=0x184F;

 mov  dx, 6223
;-18     __emit__(0xCD,0x10);

 db 205,16
;-19     gotoxy(0,0);

 push 0
 push 0
 call gotoxy
 add  sp, 4
;-20 }

;-21 

;-22 

;-23 int getch()  { ah=0x10; __emit__(0xCD,0x16); }

 ret
ENDP

getch: PROC
 mov  ah, 16
 db 205,22
;-24 int waitkey(){ ah=0x11; __emit__(0xCD,0x16); __emit__(0x74,0xFA); }

 ret
ENDP

waitkey: PROC
 mov  ah, 17
 db 205,22
 db 116,250
;-25 int GetKey() {

 ret
ENDP

GetKey: PROC
;-26     int i;

;-27     waitkey();
;
 ENTER  2,0
 call waitkey
;-28     i=getch() & 255;

 call getch
 and ax, 255
 mov [bp-2], ax
;-29     if(i==0)i=getch()+256;

 mov ax, [bp-2]
 cmp ax, 0
 jne .GetKey4
 call getch
 add ax, 256
 mov [bp-2], ax
;-30         ax=i;

.GetKey4:
 mov  ax, [bp-2]
;-31 }

;-32 int getche() { GetKey(); writetty();}

 LEAVE
 ret
ENDP

getche: PROC
 call GetKey
 call writetty
;-33 

;-34 unsigned int vAX;

 ret
ENDP
vAX dw 0
;-35 unsigned int vBX;

vBX dw 0
;-36 unsigned int vES;

vES dw 0
;-37 

;-38 char par_count=0;

par_count db 0
;-39 char *par1;

par1 dw 0
;-40 char *par2;

par2 dw 0
;-41 char *par3;

par3 dw 0
;-42 

;-43 int DOS_ERR=0;

DOS_ERR dw 0
;-44 int DOS_NoBytes;        //number of bytes read (0 or 1)

DOS_NoBytes dw 0
;-45 char DOS_ByteRead;      //the byte just read by DOS

DOS_ByteRead db 0
;-46 

;-47 int DosInt() {


DosInt: PROC
;-48     __emit__(0xCD,0x21);//int 0x21;

 db 205,33
;-49     __emit__(0x73, 04); //ifcarry DOS_ERR++;

 db 115,4
;-50     DOS_ERR++;

 inc  word[DOS_ERR]
;-51 }

;-52 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }

 ret
ENDP

openR: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt
;-53 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }

 LEAVE
 ret
ENDP

creatR: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt
;-54 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }

 LEAVE
 ret
ENDP

fcloseR: PROC;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 call DosInt
;-55 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }

 LEAVE
 ret
ENDP

exitR: PROC;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 call DosInt
;-56 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }

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
;-57 int readRL(char *s, int fd, int len){

 LEAVE
 ret
ENDP

readRL: PROC
;-58     dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt
;-59 int fputcR(char *n, int fd) {

 LEAVE
 ret
ENDP

fputcR: PROC
;-60 //    dx=n;

;-61     __asm{lea dx, [bp+4]}; /* = *n */
;
 ENTER  0,0
lea dx, [bp+4]
;-62     cx=1;

 mov  cx, 1
;-63     bx=fd;

 mov  bx, [bp+6]
;-64     ax=0x4000;

 mov  ax, 16384
;-65     DosInt();

 call DosInt
;-66 }

;-67 int setdta(char *s) {dx=s; ah=0x1A; __emit__(0xCD,0x21); }

 LEAVE
 ret
ENDP

setdta: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ah, 26
 db 205,33
;-68 int ffirst(char *s) {dx=s; ah=0x4E; cx=0x1E; DosInt(); }

 LEAVE
 ret
ENDP

ffirst: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ah, 78
 mov  cx, 30
 call DosInt
;-69 int fnext (char *s) {dx=s; ah=0x4F; cx=0x1E; DosInt(); }

 LEAVE
 ret
ENDP

fnext: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ah, 79
 mov  cx, 30
 call DosInt
;-70 

;-71 int printhex4(unsigned char c) {

 LEAVE
 ret
ENDP

printhex4: PROC
;-72     c += 48;
;
 ENTER  0,0
 add  byte[bp+4], 48
;-73     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex45
 add  byte[bp+4], 7
;-74     putch(c);

.printhex45:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-75 }

;-76 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-77     unsigned char nib;

;-78     nib = c >> 4; printhex4(nib);
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
;-79     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-80 }

;-81 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-82     unsigned int half;

;-83     half = i >>  8; printhex8(half);
;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-84     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-85 }

;-86 

;-87 int prunsign(unsigned int n) {

 LEAVE
 ret
ENDP

prunsign: PROC
;-88     unsigned int e;

;-89     if (n >= 10) {
;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .prunsign6
;-90         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-91         prunsign(e);

 push word [bp-2]
 call prunsign
 add  sp, 2
;-92         }

;-93     n=n%10;

.prunsign6:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-94     n+='0';

 add  word[bp+4], 48
;-95     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-96 }

;-97 int letter(char c) {

 LEAVE
 ret
ENDP

letter: PROC
;-98   if (c> 'z') return 0;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 122
 jle .letter7
 mov ax, 0
 jmp .retnletter
;-99   if (c< 'A') return 0;

.letter7:
 mov al, [bp+4]
 cmp al, 65
 jge .letter8
 mov ax, 0
 jmp .retnletter
;-100   if (c> 'Z') { if (c< 'a') return 0; }

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
;-101   return 1;

.letter9:
 mov ax, 1
 jmp .retnletter
;-102 }

;-103 int digit(char c){

 .retnletter:
 LEAVE
 ret
ENDP

digit: PROC
;-104     if(c<'0') return 0;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit11
 mov ax, 0
 jmp .retndigit
;-105     if(c>'9') return 0;

.digit11:
 mov al, [bp+4]
 cmp al, 57
 jle .digit12
 mov ax, 0
 jmp .retndigit
;-106     return 1;

.digit12:
 mov ax, 1
 jmp .retndigit
;-107 }

;-108 int strlen(char *s) { int c;

 .retndigit:
 LEAVE
 ret
ENDP

strlen: PROC
;-109     c=0;
;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-110     while (*s!=0) {s++; c++;}

.strlen13:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen14
 inc  word[bp+4]
 inc  word[bp-2]
;-111     return c;

 jmp .strlen13
.strlen14:
 mov ax, [bp-2]
 jmp .retnstrlen
;-112     }

;-113 int strcpy(char *s, char *t) {

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-114     do { *s=*t; s++; t++; }
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
;-115     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy16
 jmp .strcpy15
.strcpy16:
;-116     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-117     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-118 }

;-119 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-120     while(*p) {
;
 ENTER  0,0
.eqstr17:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr18
;-121         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr19
 mov ax, 0
 jmp .retneqstr
;-122             p++;

.eqstr19:
 inc  word[bp+4]
;-123             q++;

 inc  word[bp+6]
;-124         }

;-125     if(*q) return 0;

 jmp .eqstr17
.eqstr18:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr20
 mov ax, 0
 jmp .retneqstr
;-126     return 1;

.eqstr20:
 mov ax, 1
 jmp .retneqstr
;-127 }

;-128 int toupper(char *s) {

 .retneqstr:
 LEAVE
 ret
ENDP

toupper: PROC
;-129     while(*s) {
;
 ENTER  0,0
.toupper21:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper22
;-130         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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
;-131             s++;

.toupper24:
.toupper23:
 inc  word[bp+4]
;-132     }

;-133 }

 jmp .toupper21
.toupper22:
;-134 int atoi(char *s) {

 LEAVE
 ret
ENDP

atoi: PROC
;-135     char c;

;-136     unsigned int i; unsigned int j;

;-137     i=0;
;
 ENTER  6,0
 mov ax, 0
 mov [bp-4], ax
;-138     while (*s) {

.atoi25:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .atoi26
;-139         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-140         c-=48;

 sub  byte[bp-2], 48
;-141         i=i*10;

 mov ax, [bp-4]
 mov bx, 10
 mul bx
 mov [bp-4], ax
;-142         j=0;

 mov ax, 0
 mov [bp-6], ax
;-143         j=c;//c2i

 mov al, [bp-2]
 mov [bp-6], ax
;-144         i=i+j;

 mov ax, [bp-4]
 add ax, [bp-6]
 mov [bp-4], ax
;-145         s++;

 inc  word[bp+4]
;-146         }

;-147     return i;

 jmp .atoi25
.atoi26:
 mov ax, [bp-4]
 jmp .retnatoi
;-148 }

;-149 

;-150 

;-151 int setblock(unsigned int i) {

 .retnatoi:
 LEAVE
 ret
ENDP

setblock: PROC
;-152     DOS_ERR=0;
;
 ENTER  0,0
 mov ax, 0
 mov word [DOS_ERR], ax
;-153     bx=i;

 mov  bx, [bp+4]
;-154     ax=cs;

 mov  ax, cs
;-155     es=ax;

 mov  es, ax
;-156     ax=0x4A00;

 mov  ax, 18944
;-157     DosInt();

 call DosInt
;-158 //modify memory Allocation. IN: ES=Block Seg, BX=size in para

;-159     asm mov [vAX], ax; vAX=ax;

 mov [vAX], ax; vAX=ax;
;-160     asm mov [vBX], bx; vBX=bx;

 mov [vBX], bx; vBX=bx;
;-161     if (DOS_ERR) cputs(" ***Error SetBlock***");

 mov ax, [DOS_ERR]
 or  al, al
 je .setblock27
 push setblock_0
 call cputs
 add  sp, 2
;-162 //    7=MCB destroyed, 8=Insufficient memory, 90=Invalid block address

;-163 //    BX=Max mem available, if CF & AX=8

;-164 //    cputs(" AX:"); printhex16(vAX);

;-165 //    cputs(", BX:"); printhex16(vBX);

;-166 }

.setblock27:
;-167 

;-168 int Env_seg=0; //Take over Master Environment, do not change

 LEAVE
 ret
setblock_0 db " ***Error SetBlock***",0
ENDP
Env_seg dw 0
;-169 int Cmd_ofs=0;     int Cmd_seg=0;

Cmd_ofs dw 0
Cmd_seg dw 0
;-170 int FCB_ofs1=0x5C; int FCB_seg1=0;

FCB_ofs1 dw 92
FCB_seg1 dw 0
;-171 int FCB_ofs2=0x6C; int FCB_seg2=0;

FCB_ofs2 dw 108
FCB_seg2 dw 0
;-172 char FCB1=0; char FCB1A[]="           ";

FCB1 db 0
FCB1A db "           ",0
;-173 char FCB1B[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

FCB1B db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;-174 char FCB2=0; char FCB2A[]="           ";

FCB2 db 0
FCB2A db "           ",0
;-175 char FCB2B[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

FCB2B db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;-176 // structure until here

;-177 char FNBuf[64];

section .bss
absolute 25000
FNBuf resb 64
section .text
;-178 char inp_buf[81];

section .bss
absolute 25064
inp_buf resb 81
section .text
;-179 

;-180 int getcurdir() {


getcurdir: PROC
;-181     si=&FNBuf;

 mov  si, FNBuf
;-182     dl=0;

 mov  dl, 0
;-183     ah=0x47;

 mov  ah, 71
;-184     DosInt();

 call DosInt
;-185     asm mov [vAX], ax; vAX=ax;

 mov [vAX], ax; vAX=ax;
;-186     asm mov [vBX], bx; vBX=bx;

 mov [vBX], bx; vBX=bx;
;-187     if (DOS_ERR) cputs(" ***Error GetCurrentDir***");

 mov ax, [DOS_ERR]
 or  al, al
 je .getcurdir28
 push getcurdir_0
 call cputs
 add  sp, 2
;-188 }

.getcurdir28:
;-189 

;-190     int stkseg;

 ret
getcurdir_0 db " ***Error GetCurrentDir***",0
ENDP
stkseg dw 0
;-191     int stkptr;

stkptr dw 0
;-192 int exec1(char *Datei1, char *ParmBlk, char *CmdLine1) {


exec1: PROC
;-193     putch(10);
;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-194     __emit__(0x26,0xA1,0x2C,0);//asm mov ax, [es:2ch]

 db 38,161,44,0
;-195 

;-196     asm mov [Env_seg], ax

 mov [Env_seg], ax
;-197     Cmd_ofs = CmdLine1;

 mov ax, [bp+8]
 mov word [Cmd_ofs], ax
;-198     ax      =es;

 mov  ax, es
;-199     asm mov [Cmd_seg],  ds

 mov [Cmd_seg],  ds
;-200     asm mov [FCB_seg1], ax

 mov [FCB_seg1], ax
;-201     asm mov [FCB_seg2], ax

 mov [FCB_seg2], ax
;-202     asm mov [stkseg],   ss

 mov [stkseg],   ss
;-203     asm mov [stkptr],   sp

 mov [stkptr],   sp
;-204     dx=Datei1;

 mov  dx, [bp+4]
;-205     bx=ParmBlk;

 mov  bx, [bp+6]
;-206     ax=0x4B00;

 mov  ax, 19200
;-207     DosInt();

 call DosInt
;-208     asm mov [vAX], ax

 mov [vAX], ax
;-209     ss=stkseg;

 mov  ss, [stkseg]
;-210     sp=stkptr;

 mov  sp, [stkptr]
;-211     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .exec129
;-212         cputs("*****EXEC ERROR Code: ");

 push exec1_0
 call cputs
 add  sp, 2
;-213         printhex16(vAX);

 push word [vAX]
 call printhex16
 add  sp, 2
;-214 }       }

.exec129:
;-215 

;-216 char inp_len=0;

 LEAVE
 ret
exec1_0 db "*****EXEC ERROR Code: ",0
ENDP
inp_len db 0
;-217 

;-218 int dodos() {


dodos: PROC
;-219     char *p; int h;

;-220     strcpy(inp_buf, " ");
;
 ENTER  4,0
 push dodos_0
 lea  ax, [inp_buf]
 push ax
 call strcpy
 add  sp, 4
;-221     h=strlen(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call strlen
 add  sp, 2
 mov [bp-4], ax
;-222     inp_len=h & 255;

 mov ax, [bp-4]
 and ax, 255
 mov byte [inp_len], al
;-223     p=&inp_buf+h;

 mov ax, inp_buf
 add ax, [bp-4]
 mov [bp-2], ax
;-224     *p=0;

 mov ax, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-225     cputs("Before DOS: ");

 push dodos_1
 call cputs
 add  sp, 2
;-226     cputs(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call cputs
 add  sp, 2
;-227     exec1("Z:\COMMAND.COM", &Env_seg, &inp_len);

 lea  ax, [inp_len]
 push ax
 lea  ax, [Env_seg]
 push ax
 push dodos_2
 call exec1
 add  sp, 6
;-228 }

;-229 

;-230 int extrinsic(char *s) {

 LEAVE
 ret
dodos_0 db " ",0
dodos_1 db "Before DOS: ",0
dodos_2 db "Z:\COMMAND.COM",0
ENDP

extrinsic: PROC
;-231     char *p;

;-232     inp_len=strlen(inp_buf);
;
 ENTER  2,0
 lea  ax, [inp_buf]
 push ax
 call strlen
 add  sp, 2
 mov byte [inp_len], al
;-233     if (inp_len == 0) return;

 mov al, [inp_len]
 cmp al, 0
 jne .extrinsic30
 jmp .retnextrinsic
;-234     p=&inp_buf+inp_len;

.extrinsic30:
 mov ax, inp_buf
 add al, [inp_len]
 mov [bp-2], ax
;-235     *p=0;

 mov ax, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-236     waitkey();

 call waitkey
;-237     exec1(inp_buf, &Env_seg, &inp_len);

 lea  ax, [inp_len]
 push ax
 lea  ax, [Env_seg]
 push ax
 lea  ax, [inp_buf]
 push ax
 call exec1
 add  sp, 6
;-238 }

;-239 

;-240 

;-241 int mdump(unsigned char *adr, unsigned int len ) {

 .retnextrinsic:
 LEAVE
 ret
ENDP

mdump: PROC
;-242     unsigned char c;

;-243     int i;

;-244     int j;

;-245     j=0;
;
 ENTER  6,0
 mov ax, 0
 mov [bp-6], ax
;-246     while (j < len ) {

.mdump31:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump32
;-247         putch(10);

 push 10
 call putch
 add  sp, 2
;-248         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-249         putch(':');

 push 58
 call putch
 add  sp, 2
;-250         i=0;

 mov ax, 0
 mov [bp-4], ax
;-251         while (i < 16) {

.mdump33:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump34
;-252             putch(' ');

 push 32
 call putch
 add  sp, 2
;-253             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-254             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-255             adr++;

 inc  word[bp+4]
;-256             i++;

 inc  word[bp-4]
;-257             j++;

 inc  word[bp-6]
;-258             }

;-259         putch(' ');

 jmp .mdump33
.mdump34:
 push 32
 call putch
 add  sp, 2
;-260         adr -=16;

 sub  word[bp+4], 16
;-261         i=0;

 mov ax, 0
 mov [bp-4], ax
;-262         while(i < 16) {

.mdump35:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump36
;-263             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-264             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump37
 push 46
 call putch
 add  sp, 2
;-265                 else putch(c);

 jmp .mdump38
.mdump37:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-266             adr++;

.mdump38:
 inc  word[bp+4]
;-267             i++;

 inc  word[bp-4]
;-268         }

;-269     }

 jmp .mdump35
.mdump36:
;-270 }

 jmp .mdump31
.mdump32:
;-271 

;-272 int dodump() {

 LEAVE
 ret
ENDP

dodump: PROC
;-273     unsigned int i;

;-274     i=atoi(par2);
;
 ENTER  2,0
 push word [par2]
 call atoi
 add  sp, 2
 mov [bp-2], ax
;-275     mdump(i, 120);

 push 120
 push word [bp-2]
 call mdump
 add  sp, 4
;-276     putch(10);

 push 10
 call putch
 add  sp, 2
;-277 }

;-278 

;-279 char path[]="*.*";

 LEAVE
 ret
ENDP
path db "*.*",0
;-280 char direcord[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};//21 do not change

direcord db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;-281 char dirattr=0;

dirattr db 0
;-282 int  dirtime=0;

dirtime dw 0
;-283 int  dirdate=0;

dirdate dw 0
;-284 int  dirlenlo=0;

dirlenlo dw 0
;-285 int  dirlenhi=0;

dirlenhi dw 0
;-286 char dirdatname[]={0,0,0,0,0,0,0,0,0,0,0,0,0};//13 structure until here

dirdatname db 0,0,0,0,0,0,0,0,0,0,0,0,0
;-287 

;-288 int dodir() {


dodir: PROC
;-289     int j;

;-290     char c;

;-291     getcurdir();
;
 ENTER  4,0
 call getcurdir
;-292     cputs("Current directory: ");

 push dodir_0
 call cputs
 add  sp, 2
;-293     cputs(FNBuf);

 lea  ax, [FNBuf]
 push ax
 call cputs
 add  sp, 2
;-294     putch(10);

 push 10
 call putch
 add  sp, 2
;-295 

;-296     setdta(direcord);

 lea  ax, [direcord]
 push ax
 call setdta
 add  sp, 2
;-297 

;-298     ffirst(path);

 lea  ax, [path]
 push ax
 call ffirst
 add  sp, 2
;-299     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dodir39
;-300         cputs("Empty directory ");

 push dodir_1
 call cputs
 add  sp, 2
;-301         return;

 jmp .retndodir
;-302         }

;-303     cputs("Name             Date   Time Attr   Size");

.dodir39:
 push dodir_2
 call cputs
 add  sp, 2
;-304   do {

.dodir40:
;-305         putch(10);

 push 10
 call putch
 add  sp, 2
;-306         cputs(dirdatname);

 lea  ax, [dirdatname]
 push ax
 call cputs
 add  sp, 2
;-307         j=strlen(dirdatname);

 lea  ax, [dirdatname]
 push ax
 call strlen
 add  sp, 2
 mov [bp-2], ax
;-308         do {

.dodir41:
;-309             putch(' ');

 push 32
 call putch
 add  sp, 2
;-310             j++;

 inc  word[bp-2]
;-311             } while (j<13);

 mov ax, [bp-2]
 cmp ax, 13
 jge .dodir42
 jmp .dodir41
.dodir42:
;-312 

;-313         j=dirdate & 31;

 mov ax, [dirdate]
 and ax, 31
 mov [bp-2], ax
;-314         if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir43
 push 32
 call putch
 add  sp, 2
;-315         prunsign(j);

.dodir43:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-316         putch('.');

 push 46
 call putch
 add  sp, 2
;-317 

;-318         j=dirdate >> 5;

 mov ax, [dirdate]
 shr ax, 5
 mov [bp-2], ax
;-319         j&=  15;

 and  word[bp-2], 15
;-320         if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir44
 push 48
 call putch
 add  sp, 2
;-321         prunsign(j);

.dodir44:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-322         putch('.');

 push 46
 call putch
 add  sp, 2
;-323 

;-324         j=dirdate >> 9;

 mov ax, [dirdate]
 shr ax, 9
 mov [bp-2], ax
;-325         j+=  80;

 add  word[bp-2], 80
;-326         if (j>=100) j-=100;

 mov ax, [bp-2]
 cmp ax, 100 ;unsigned : 1
 jl  .dodir45
 sub  word[bp-2], 100
;-327         if (j<10) putch('0');

.dodir45:
 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir46
 push 48
 call putch
 add  sp, 2
;-328         prunsign(j);

.dodir46:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-329         putch(' ');

 push 32
 call putch
 add  sp, 2
;-330         putch(' ');

 push 32
 call putch
 add  sp, 2
;-331 

;-332         j=dirtime  >>11;

 mov ax, [dirtime]
 shr ax, 11
 mov [bp-2], ax
;-333         if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir47
 push 32
 call putch
 add  sp, 2
;-334         prunsign(j);

.dodir47:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-335         putch(':');

 push 58
 call putch
 add  sp, 2
;-336 

;-337         j=dirtime  >> 5;

 mov ax, [dirtime]
 shr ax, 5
 mov [bp-2], ax
;-338         j&=  63;

 and  word[bp-2], 63
;-339         if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir48
 push 48
 call putch
 add  sp, 2
;-340         prunsign(j);

.dodir48:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-341         putch(' ');

 push 32
 call putch
 add  sp, 2
;-342 

;-343         c = dirattr & 32;

 mov al, [dirattr]
 and al, 32
 mov [bp-4], al
;-344         if (c) putch('A'); else putch(' ');

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
;-345         c = dirattr & 16;

.dodir50:
 mov al, [dirattr]
 and al, 16
 mov [bp-4], al
;-346         if (c) putch('D'); else putch(' ');

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
;-347         c = dirattr & 8;

.dodir52:
 mov al, [dirattr]
 and al, 8
 mov [bp-4], al
;-348         if (c) putch('V'); else putch(' ');

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
;-349         c = dirattr & 4;

.dodir54:
 mov al, [dirattr]
 and al, 4
 mov [bp-4], al
;-350         if (c) putch('S'); else putch(' ');

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
;-351         c = dirattr & 2;

.dodir56:
 mov al, [dirattr]
 and al, 2
 mov [bp-4], al
;-352         if (c) putch('H'); else putch(' ');

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
;-353         c = dirattr & 1;

.dodir58:
 mov al, [dirattr]
 and al, 1
 mov [bp-4], al
;-354         if (c) putch('R'); else putch(' ');

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
;-355 

;-356         if (dirlenhi) {

.dodir60:
 mov ax, [dirlenhi]
 or  al, al
 je .dodir61
;-357             dirlenlo=dirlenlo >>10;

 mov ax, [dirlenlo]
 shr ax, 10
 mov word [dirlenlo], ax
;-358             dirlenhi=dirlenhi << 6;

 mov ax, [dirlenhi]
 shl ax, 6
 mov word [dirlenhi], ax
;-359             dirlenhi=dirlenhi+dirlenlo;

 mov ax, [dirlenhi]
 add ax, [dirlenlo]
 mov word [dirlenhi], ax
;-360             putch(' ');

 push 32
 call putch
 add  sp, 2
;-361             prunsign(dirlenhi);

 push word [dirlenhi]
 call prunsign
 add  sp, 2
;-362             cputs(" KB");

 push dodir_3
 call cputs
 add  sp, 2
;-363             }

;-364         else {

 jmp .dodir62
.dodir61:
;-365             putch(' ');

 push 32
 call putch
 add  sp, 2
;-366             prunsign(dirlenlo);

 push word [dirlenlo]
 call prunsign
 add  sp, 2
;-367             }

;-368     j=fnext(path);

.dodir62:
 lea  ax, [path]
 push ax
 call fnext
 add  sp, 2
 mov [bp-2], ax
;-369     } while (j!=18);

 mov ax, [bp-2]
 cmp ax, 18
 je  .dodir63
 jmp .dodir40
.dodir63:
;-370     putch(10);

 push 10
 call putch
 add  sp, 2
;-371 }

;-372 

;-373 

;-374 char memSignature;

 .retndodir:
 LEAVE
 ret
dodir_0 db "Current directory: ",0
dodir_1 db "Empty directory ",0
dodir_2 db "Name             Date   Time Attr   Size",0
dodir_3 db " KB",0
ENDP
memSignature db 0
;-375 unsigned int memOwner;

memOwner dw 0
;-376 unsigned int memSize;

memSize dw 0
;-377 

;-378 int domem() {


domem: PROC
;-379     unsigned int i;

;-380     char c;

;-381     ah=0x52;//DOS list of lists
;
 ENTER  4,0
 mov  ah, 82
;-382     asm int 33 ; // out= ES:BX ptr to invars

 int 33 ; // out= ES:BX ptr to invars
;-383     asm mov [vBX], bx

 mov [vBX], bx
;-384 //    asm mov es, [es:bx-2]//first memory control block

;-385     __emit__(0x26,0x8E,0x47,0xFE);

 db 38,142,71,254
;-386     asm mov [vES], es

 mov [vES], es
;-387     do {

.domem64:
;-388         putch(10);

 push 10
 call putch
 add  sp, 2
;-389         cputs("Start:");

 push domem_0
 call cputs
 add  sp, 2
;-390         printhex16(vES);

 push word [vES]
 call printhex16
 add  sp, 2
;-391         if (vES >= 0xA000) cputs(" MCB in UMB");

 mov ax, [vES]
 cmp ax, 40960 ;unsigned : 0
 jb  .domem65
 push domem_1
 call cputs
 add  sp, 2
;-392 //        asm mov al, [es:0]// M or Z

;-393         __emit__(0x26,0xA0,0,0);

.domem65:
 db 38,160,0,0
;-394         asm mov [memSignature], al

 mov [memSignature], al
;-395 //        cputs(", ");

;-396 //        putch(memSignature);

;-397 //        asm mov ax, [es:1]//program segment prefix

;-398         __emit__(0x26,0xA1,1,0);

 db 38,161,1,0
;-399         asm mov [memOwner], ax

 mov [memOwner], ax
;-400         cputs(", PSP:");

 push domem_2
 call cputs
 add  sp, 2
;-401         printhex16(memOwner);

 push word [memOwner]
 call printhex16
 add  sp, 2
;-402 //        asm mov ax, [es:3]//size in para

;-403         __emit__(0x26,0xA1,3,0);

 db 38,161,3,0
;-404         asm mov [memSize], ax

 mov [memSize], ax
;-405         cputs(", Size:");

 push domem_3
 call cputs
 add  sp, 2
;-406         printhex16(memSize);

 push word [memSize]
 call printhex16
 add  sp, 2
;-407         if (memOwner == 0) cputs(" free");

 mov ax, [memOwner]
 cmp ax, 0
 jne .domem66
 push domem_4
 call cputs
 add  sp, 2
;-408         if (memOwner == 8) cputs(" DOS ");

.domem66:
 mov ax, [memOwner]
 cmp ax, 8
 jne .domem67
 push domem_5
 call cputs
 add  sp, 2
;-409         i=memOwner-vES;

.domem67:
 mov ax, [memOwner]
 sub ax, [vES]
 mov [bp-2], ax
;-410     vES = vES + memSize;

 mov ax, [vES]
 add ax, [memSize]
 mov word [vES], ax
;-411     vES++;

 inc  word[vES]
;-412     asm mov es, vES

 mov es, vES
;-413     es = vES;

 mov  es, [vES]
;-414     }

;-415     while (memSignature == 'M');

 mov al, [memSignature]
 cmp al, 77
 jne .domem68
 jmp .domem64
.domem68:
;-416     putch(10);

 push 10
 call putch
 add  sp, 2
;-417 }

;-418 

;-419 int dotype() {

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
;-420     int fdin; int i;

;-421     fdin=openR(par2);
;
 ENTER  4,0
 push word [par2]
 call openR
 add  sp, 2
 mov [bp-2], ax
;-422     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dotype69
;-423         cputs("file missing");

 push dotype_0
 call cputs
 add  sp, 2
;-424         putch(10);

 push 10
 call putch
 add  sp, 2
;-425         return;

 jmp .retndotype
;-426         }

;-427     do {

.dotype69:
.dotype70:
;-428         DOS_NoBytes=readR(&DOS_ByteRead, fdin);

 push word [bp-2]
 lea  ax, [DOS_ByteRead]
 push ax
 call readR
 add  sp, 4
 mov word [DOS_NoBytes], ax
;-429         putch(DOS_ByteRead);

 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-430         }

;-431         while (DOS_NoBytes);

 mov ax, [DOS_NoBytes]
 or  al, al
 je .dotype71
 jmp .dotype70
.dotype71:
;-432     fcloseR(fdin);

 push word [bp-2]
 call fcloseR
 add  sp, 2
;-433 }

;-434 

;-435 int Prompt1(unsigned char *s) {

 .retndotype:
 LEAVE
 ret
dotype_0 db "file missing",0
ENDP

Prompt1: PROC
;-436     char c;

;-437     unsigned char *startstr;

;-438     startstr=s;
;
 ENTER  4,0
 mov ax, [bp+4]
 mov [bp-4], ax
;-439     do {

.Prompt172:
;-440         c=GetKey();

 call GetKey
 mov [bp-2], al
;-441         if (c == 27)    exitR(1);//good bye

 mov al, [bp-2]
 cmp al, 27
 jne .Prompt173
 push 1
 call exitR
 add  sp, 2
;-442         if (c==8) {

.Prompt173:
 mov al, [bp-2]
 cmp al, 8
 jne .Prompt174
;-443             if (s > startstr){

 mov ax, [bp+4]
 cmp ax, [bp-4]
 jle .Prompt175
;-444                 s--;

 dec  word[bp+4]
;-445                 putch(8);

 push 8
 call putch
 add  sp, 2
;-446                 putch(' ');

 push 32
 call putch
 add  sp, 2
;-447                 putch(8);

 push 8
 call putch
 add  sp, 2
;-448                 }

;-449                 else putch(7);

 jmp .Prompt176
.Prompt175:
 push 7
 call putch
 add  sp, 2
;-450             }

.Prompt176:
;-451             else {

 jmp .Prompt177
.Prompt174:
;-452                 *s=c;

 mov al, [bp-2]
 mov  bx, [bp+4]
 mov  [bx], al
;-453                 s++;

 inc  word[bp+4]
;-454                 putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-455             }

;-456     } while(c!=13);

.Prompt177:
 mov al, [bp-2]
 cmp al, 13
 je  .Prompt178
 jmp .Prompt172
.Prompt178:
;-457     s--;

 dec  word[bp+4]
;-458     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-459 }

;-460 

;-461 char Info1[]=" commands: help,exit,cls,type,mem,dir,dump (adr),exec,dos,*COM";

 LEAVE
 ret
ENDP
Info1 db " commands: help,exit,cls,type,mem,dir,dump (adr),exec,dos,*COM",0
;-462 

;-463 int dohelp() {


dohelp: PROC
;-464     unsigned int i;

;-465     cputs(Version1);
;
 ENTER  2,0
 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2
;-466     cputs(Info1);

 lea  ax, [Info1]
 push ax
 call cputs
 add  sp, 2
;-467     putch(10);

 push 10
 call putch
 add  sp, 2
;-468 }

;-469 

;-470 

;-471 int getpar(char *t) {

 LEAVE
 ret
ENDP

getpar: PROC
;-472     while (*t == 32) t++;
;
 ENTER  0,0
.getpar79:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar80
 inc  word[bp+4]
;-473     if (*t<=13) return 0;

 jmp .getpar79
.getpar80:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar81
 mov ax, 0
 jmp .retngetpar
;-474 

;-475     par1=t;

.getpar81:
 mov ax, [bp+4]
 mov word [par1], ax
;-476     while(*t >= 33) t++;

.getpar82:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar83
 inc  word[bp+4]
;-477     if (*t==0) return 1;

 jmp .getpar82
.getpar83:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar84
 mov ax, 1
 jmp .retngetpar
;-478     *t=0;

.getpar84:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-479     t++;

 inc  word[bp+4]
;-480     while (*t == 32) t++;

.getpar85:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar86
 inc  word[bp+4]
;-481     if (*t<=13) return 1;

 jmp .getpar85
.getpar86:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar87
 mov ax, 1
 jmp .retngetpar
;-482 

;-483     par2=t;

.getpar87:
 mov ax, [bp+4]
 mov word [par2], ax
;-484     while(*t >= 33) t++;

.getpar88:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar89
 inc  word[bp+4]
;-485     if (*t==0) return 2;

 jmp .getpar88
.getpar89:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar90
 mov ax, 2
 jmp .retngetpar
;-486     *t=0;

.getpar90:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-487     t++;

 inc  word[bp+4]
;-488     while (*t == 32) t++;

.getpar91:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar92
 inc  word[bp+4]
;-489     if (*t<=13) return 2;

 jmp .getpar91
.getpar92:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar93
 mov ax, 2
 jmp .retngetpar
;-490 

;-491     par3=t;

.getpar93:
 mov ax, [bp+4]
 mov word [par3], ax
;-492     while(*t >= 33) t++;

.getpar94:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar95
 inc  word[bp+4]
;-493     *t=0;

 jmp .getpar94
.getpar95:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-494     return 3;

 mov ax, 3
 jmp .retngetpar
;-495 }

;-496 

;-497 int intrinsic() {

 .retngetpar:
 LEAVE
 ret
ENDP

intrinsic: PROC
;-498     toupper(par1);

 push word [par1]
 call toupper
 add  sp, 2
;-499     if(eqstr(par1,"HELP")){dohelp();return;}

 push intrinsic_0
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic96
 call dohelp
 jmp .retnintrinsic
;-500     if(eqstr(par1,"EXIT"))exitR(0);

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
;-501     if(eqstr(par1,"CLS" )){clrscr();return;}

.intrinsic97:
 push intrinsic_2
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic98
 call clrscr
 jmp .retnintrinsic
;-502     if(eqstr(par1,"TYPE")){dotype();return;}

.intrinsic98:
 push intrinsic_3
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic99
 call dotype
 jmp .retnintrinsic
;-503     if(eqstr(par1,"MEM" )){domem(); return;}

.intrinsic99:
 push intrinsic_4
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic100
 call domem
 jmp .retnintrinsic
;-504     if(eqstr(par1,"DIR" )){dodir();return;}

.intrinsic100:
 push intrinsic_5
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic101
 call dodir
 jmp .retnintrinsic
;-505     if(eqstr(par1,"DUMP")){dodump();return;}

.intrinsic101:
 push intrinsic_6
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic102
 call dodump
 jmp .retnintrinsic
;-506     if(eqstr(par1,"DOS" )){dodos(); return;}

.intrinsic102:
 push intrinsic_7
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic103
 call dodos
 jmp .retnintrinsic
;-507     if(eqstr(par1,"EXEC")){exec1 ();return;}

.intrinsic103:
 push intrinsic_8
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic104
 call exec1
 jmp .retnintrinsic
;-508     extrinsic(inp_buf);

.intrinsic104:
 lea  ax, [inp_buf]
 push ax
 call extrinsic
 add  sp, 2
;-509 }

;-510 

;-511 

;-512 int get_cmd(){

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
;-513     *inp_buf=0;

 mov ax, 0
 mov  bx, [inp_buf]
 mov  [bx], al
;-514     DOS_ERR=0;

 mov ax, 0
 mov word [DOS_ERR], ax
;-515     putch(':');

 push 58
 call putch
 add  sp, 2
;-516     Prompt1(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call Prompt1
 add  sp, 2
;-517     putch(10);

 push 10
 call putch
 add  sp, 2
;-518 }

;-519 

;-520 int main() {

 ret
ENDP

main: PROC
;-521     setblock(4096);

 push 4096
 call setblock
 add  sp, 2
;-522     dohelp();

 call dohelp
;-523     do {

.main105:
;-524         get_cmd();

 call get_cmd
;-525         par_count=getpar(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call getpar
 add  sp, 2
 mov byte [par_count], al
;-526         intrinsic();

 call intrinsic
;-527         }

;-528     while(1);

 mov ax, 1
 or  al, al
 je .main106
 jmp .main105
.main106:
;-529 }

 ret
ENDP
;Glob. variables:41 (300), Functions:47 (300), Lines:530
;Constant: 221 (3000), stacksize: 40391