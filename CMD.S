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

;-35 unsigned int vAX; 

 ret
ENDP
vAX dw 0
;-36 unsigned int vBX;

vBX dw 0
;-37 unsigned int vES; 

vES dw 0
;-38 

;-39 char par_count=0;

par_count db 0
;-40 char *par1;

par1 dw 0
;-41 char *par2;

par2 dw 0
;-42 char *par3;

par3 dw 0
;-43         

;-44 int DOS_ERR=0;        

DOS_ERR dw 0
;-45 int DOS_NoBytes;        //number of bytes read (0 or 1)

DOS_NoBytes dw 0
;-46 char DOS_ByteRead;      //the byte just read by DOS

DOS_ByteRead db 0
;-47         

;-48 int DosInt() {

DosInt: PROC
;-49     __emit__(0xCD,0x21);//int 0x21;

 db 205,33
;-50     __emit__(0x73, 04); //ifcarry DOS_ERR++;

 db 115,4
;-51     DOS_ERR++;

 inc  word[DOS_ERR]
;-52 }

;-53 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }

 ret
ENDP
openR: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt
;-54 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
ENDP
creatR: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt
;-55 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
 LEAVE
 ret
ENDP
fcloseR: PROC;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 call DosInt
;-56 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
 LEAVE
 ret
ENDP
exitR: PROC;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 call DosInt
;-57 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
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
;-58 int readRL(char *s, int fd, int len){
 LEAVE
 ret
ENDP
readRL: PROC
;-59     dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt
;-60 int fputcR(char *n, int fd) { 
 LEAVE
 ret
ENDP
fputcR: PROC
;-61 //    dx=n;

;-62     __asm{lea dx, [bp+4]}; /* = *n */  
;
 ENTER  0,0
lea dx, [bp+4]
;-63     cx=1; 

 mov  cx, 1
;-64     bx=fd; 

 mov  bx, [bp+6]
;-65     ax=0x4000; 

 mov  ax, 16384
;-66     DosInt(); 

 call DosInt
;-67 }

;-68 int setdta(char *s) {dx=s; ah=0x1A; __emit__(0xCD,0x21); }
 LEAVE
 ret
ENDP
setdta: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ah, 26
 db 205,33
;-69 int ffirst(char *s) {dx=s; ah=0x4E; cx=0x1E; DosInt(); }
 LEAVE
 ret
ENDP
ffirst: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ah, 78
 mov  cx, 30
 call DosInt
;-70 int fnext (char *s) {dx=s; ah=0x4F; cx=0x1E; DosInt(); }
 LEAVE
 ret
ENDP
fnext: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ah, 79
 mov  cx, 30
 call DosInt
;-71 

;-72 int printhex4(unsigned char c) {
 LEAVE
 ret
ENDP
printhex4: PROC
;-73     c += 48;
;
 ENTER  0,0
 add  byte[bp+4], 48
;-74     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex45
 add  byte[bp+4], 7
;-75     putch(c);

.printhex45:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-76 }

;-77 int printhex8(unsigned char c) {
 LEAVE
 ret
ENDP
printhex8: PROC
;-78     unsigned char nib;

;-79     nib = c >> 4; printhex4(nib);
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
;-80     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-81 }

;-82 int printhex16(unsigned int i) {
 LEAVE
 ret
ENDP
printhex16: PROC
;-83     unsigned int half;

;-84     half = i >>  8; printhex8(half);
;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-85     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-86 }

;-87 

;-88 int prunsign(unsigned int n) { 
 LEAVE
 ret
ENDP
prunsign: PROC
;-89     unsigned int e;

;-90     if (n >= 10) { 
;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .prunsign6
;-91         e=n/10; 

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-92         prunsign(e); 

 push word [bp-2]
 call prunsign
 add  sp, 2
;-93         } 

;-94     n=n%10; 

.prunsign6:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-95     n+='0'; 

 add  word[bp+4], 48
;-96     putch(n); 

 push word [bp+4]
 call putch
 add  sp, 2
;-97 }

;-98 int letter(char c) {
 LEAVE
 ret
ENDP
letter: PROC
;-99   if (c> 'z') return 0;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 122
 jle .letter7
 mov ax, 0
 jmp .retnletter
;-100   if (c< 'A') return 0;

.letter7:
 mov al, [bp+4]
 cmp al, 65
 jge .letter8
 mov ax, 0
 jmp .retnletter
;-101   if (c> 'Z') { if (c< 'a') return 0; }

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
;-102   return 1;

.letter9:
 mov ax, 1
 jmp .retnletter
;-103 }

;-104 int digit(char c){

 .retnletter: LEAVE
 ret
ENDP
digit: PROC
;-105     if(c<'0') return 0;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit11
 mov ax, 0
 jmp .retndigit
;-106     if(c>'9') return 0;

.digit11:
 mov al, [bp+4]
 cmp al, 57
 jle .digit12
 mov ax, 0
 jmp .retndigit
;-107     return 1;

.digit12:
 mov ax, 1
 jmp .retndigit
;-108 }

;-109 int strlen(char *s) { int c;

 .retndigit: LEAVE
 ret
ENDP
strlen: PROC
;-110     c=0;
;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-111     while (*s!=0) {s++; c++;}

.strlen13:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen14
 inc  word[bp+4]
 inc  word[bp-2]
;-112     return c;

 jmp .strlen13
.strlen14:
 mov ax, [bp-2]
 jmp .retnstrlen
;-113     }

;-114 int strcpy(char *s, char *t) {

 .retnstrlen: LEAVE
 ret
ENDP
strcpy: PROC
;-115     do { *s=*t; s++; t++; }
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
;-116     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy16
 jmp .strcpy15
.strcpy16:
;-117     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-118     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-119 }

;-120 int eqstr(char *p, char *q) {

 .retnstrcpy: LEAVE
 ret
ENDP
eqstr: PROC
;-121     while(*p) {
;
 ENTER  0,0
.eqstr17:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr18
;-122         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr19
 mov ax, 0
 jmp .retneqstr
;-123             p++;

.eqstr19:
 inc  word[bp+4]
;-124             q++;

 inc  word[bp+6]
;-125         }

;-126     if(*q) return 0;

 jmp .eqstr17
.eqstr18:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr20
 mov ax, 0
 jmp .retneqstr
;-127     return 1;

.eqstr20:
 mov ax, 1
 jmp .retneqstr
;-128 }

;-129 int toupper(char *s) {

 .retneqstr: LEAVE
 ret
ENDP
toupper: PROC
;-130     while(*s) {
;
 ENTER  0,0
.toupper21:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper22
;-131         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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
;-132             s++;

.toupper24:
.toupper23:
 inc  word[bp+4]
;-133     }

;-134 }

 jmp .toupper21
.toupper22:
;-135 int atoi(char *s) { 
 LEAVE
 ret
ENDP
atoi: PROC
;-136     char c; 

;-137     unsigned int i; unsigned int j; 

;-138     i=0;
;
 ENTER  6,0
 mov ax, 0
 mov [bp-4], ax
;-139     while (*s) { 

.atoi25:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .atoi26
;-140         c=*s; 

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-141         c-=48; 

 sub  byte[bp-2], 48
;-142         i=i*10; 

 mov ax, [bp-4]
 mov bx, 10
 mul bx
 mov [bp-4], ax
;-143         j=0;

 mov ax, 0
 mov [bp-6], ax
;-144         j=c;//c2i

 mov al, [bp-2]
 mov [bp-6], ax
;-145         i=i+j; 

 mov ax, [bp-4]
 add ax, [bp-6]
 mov [bp-4], ax
;-146         s++; 

 inc  word[bp+4]
;-147         }  

;-148     return i; 

 jmp .atoi25
.atoi26:
 mov ax, [bp-4]
 jmp .retnatoi
;-149 }

;-150 

;-151 

;-152 int setblock(unsigned int i) { 

 .retnatoi: LEAVE
 ret
ENDP
setblock: PROC
;-153     DOS_ERR=0; 
;
 ENTER  0,0
 mov ax, 0
 mov word [DOS_ERR], ax
;-154     bx=i; 

 mov  bx, [bp+4]
;-155     ax=cs; 

 mov  ax, cs
;-156     es=ax; 

 mov  es, ax
;-157     ax=0x4A00; 

 mov  ax, 18944
;-158     DosInt();

 call DosInt
;-159 //modify memory Allocation. IN: ES=Block Seg, BX=size in para

;-160     asm mov [vAX], ax; vAX=ax;    

 mov [vAX], ax; vAX=ax;    
;-161     asm mov [vBX], bx; vBX=bx;

 mov [vBX], bx; vBX=bx;
;-162     if (DOS_ERR) cputs(" ***Error SetBlock***");

 mov ax, [DOS_ERR]
 or  al, al
 je .setblock27
 push setblock_0
 call cputs
 add  sp, 2
;-163 //    7=MCB destroyed, 8=Insufficient memory, 90=Invalid block address

;-164 //    BX=Max mem available, if CF & AX=8 

;-165 //    cputs(" AX:"); printhex16(vAX);

;-166 //    cputs(", BX:"); printhex16(vBX);

;-167 }

.setblock27:
;-168 

;-169 int Env_seg=0; /*Take over Master Environment*/
 LEAVE
 ret
setblock_0 db " ***Error SetBlock***",0
ENDP
Env_seg dw 0
;-170 int Cmd_ofs=0;     int Cmd_seg=0;

Cmd_ofs dw 0
Cmd_seg dw 0
;-171 int FCB_ofs1=0x5C; int FCB_seg1=0;

FCB_ofs1 dw 92
FCB_seg1 dw 0
;-172 int FCB_ofs2=0x6C; int FCB_seg2=0;

FCB_ofs2 dw 108
FCB_seg2 dw 0
;-173 char FCB1=0; char FCB1A[]="           ";

FCB1 db 0
FCB1A db "           ",0
;-174 char FCB1B[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

FCB1B db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;-175 char FCB2=0; char FCB2A[]="           ";

FCB2 db 0
FCB2A db "           ",0
;-176 char FCB2B[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

FCB2B db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;-177 

;-178 char FNBuf[64];

section .bss
absolute 25000
FNBuf resb 64
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

;-190 

;-191 /*

;-192 int exec1(char *Datei1, char *ParmBlk, char *CmdLine1) { 

;-193     int stkseg; int stkptr; unsigned int vAX;

;-194 //    setblock(4096); 

;-195     putch(10);

;-196     asm mov ax, [es:2ch]

;-197     _ Env_seg=ax;

;-198     Cmd_ofs = CmdLine1;

;-199     _ ax      =es;   

;-200     _ Cmd_seg =ds;

;-201     _ FCB_seg1=ax;   

;-202     _ FCB_seg2=ax;

;-203     _ stkseg  =ss;   

;-204     _ stkptr  =sp;

;-205     dx=Datei1; 

;-206     bx=ParmBlk; 

;-207     ax=0x4B00; 

;-208     DosInt();

;-209     _ vAX=ax;  

;-210     _ ss=stkseg;  

;-211     _ sp=stkptr;

;-212     if (DOS_ERR) cputs(" ***Error EXEC*** ");

;-213 }

;-214 

;-215 int extrinsic(char *s) {

;-216     char *p; 

;-217     inp_len=strlen(inp_buf);

;-218     if (inp_len == 0) return;

;-219     p=&inp_buf+inp_len; 

;-220     *p=0;

;-221     doFN();

;-222     waitkey();

;-223     exec1(inp_buf, &Env_seg, &inp_len);

;-224 }

;-225 

;-226 int dodos() { 

;-227     char *p; int h;

;-228     strcpy(inp_buf, "");

;-229     h=strlen(inp_buf); 

;-230     inp_len=h & 255; 

;-231     p=&inp_buf+h; 

;-232     *p=0;

;-233     cputs("Before DOS: "); 

;-234     cputs(inp_buf);

;-235     exec1("COMMAND.COM", &Env_seg, &inp_len);

;-236 }

;-237 */

;-238 

;-239 

;-240 int mdump(unsigned char *adr, unsigned int len ) {

 ret
getcurdir_0 db " ***Error GetCurrentDir***",0
ENDP
mdump: PROC
;-241     unsigned char c; 

;-242     int i; 

;-243     int j;

;-244     j=0; 
;
 ENTER  6,0
 mov ax, 0
 mov [bp-6], ax
;-245     while (j < len ) {

.mdump29:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump30
;-246         putch(10);  

 push 10
 call putch
 add  sp, 2
;-247         printhex16(adr); 

 push word [bp+4]
 call printhex16
 add  sp, 2
;-248         putch(':');

 push 58
 call putch
 add  sp, 2
;-249         i=0; 

 mov ax, 0
 mov [bp-4], ax
;-250         while (i < 16) {

.mdump31:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump32
;-251             putch(' '); 

 push 32
 call putch
 add  sp, 2
;-252             c = *adr; 

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-253             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-254             adr++;

 inc  word[bp+4]
;-255             i++;

 inc  word[bp-4]
;-256             j++;

 inc  word[bp-6]
;-257             }

;-258         putch(' '); 

 jmp .mdump31
.mdump32:
 push 32
 call putch
 add  sp, 2
;-259         adr -=16; 

 sub  word[bp+4], 16
;-260         i=0; 

 mov ax, 0
 mov [bp-4], ax
;-261         while(i < 16) {

.mdump33:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump34
;-262             c= *adr; 

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-263             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump35
 push 46
 call putch
 add  sp, 2
;-264                 else putch(c); 

 jmp .mdump36
.mdump35:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-265             adr++;

.mdump36:
 inc  word[bp+4]
;-266             i++; 

 inc  word[bp-4]
;-267         }  

;-268     }  

 jmp .mdump33
.mdump34:
;-269 }

 jmp .mdump29
.mdump30:
;-270 

;-271 int dodump() { 
 LEAVE
 ret
ENDP
dodump: PROC
;-272     unsigned int i;

;-273     i=atoi(par2);
;
 ENTER  2,0
 push word [par2]
 call atoi
 add  sp, 2
 mov [bp-2], ax
;-274     mdump(i, 120);

 push 120
 push word [bp-2]
 call mdump
 add  sp, 4
;-275     putch(10);      

 push 10
 call putch
 add  sp, 2
;-276 }

;-277 

;-278 char path[]="*.*";
 LEAVE
 ret
ENDP
path db "*.*",0
;-279 char direcord[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};//21 do not change

direcord db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;-280 char dirattr=0;   

dirattr db 0
;-281 int  dirtime=0;  

dirtime dw 0
;-282 int  dirdate=0;

dirdate dw 0
;-283 int  dirlenlo=0;  

dirlenlo dw 0
;-284 int  dirlenhi=0; 

dirlenhi dw 0
;-285 char dirdatname[]={0,0,0,0,0,0,0,0,0,0,0,0,0};//13 structure until here

dirdatname db 0,0,0,0,0,0,0,0,0,0,0,0,0
;-286 

;-287 int dodir() { 

dodir: PROC
;-288     int j;

;-289     char c; 

;-290     getcurdir(); 
;
 ENTER  4,0
 call getcurdir
;-291     cputs("Current directory: "); 

 push dodir_0
 call cputs
 add  sp, 2
;-292     cputs(FNBuf); 

 lea  ax, [FNBuf]
 push ax
 call cputs
 add  sp, 2
;-293     putch(10);

 push 10
 call putch
 add  sp, 2
;-294  

;-295     setdta(direcord);

 lea  ax, [direcord]
 push ax
 call setdta
 add  sp, 2
;-296       

;-297     ffirst(path);

 lea  ax, [path]
 push ax
 call ffirst
 add  sp, 2
;-298     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dodir37
;-299         cputs("Empty directory "); 

 push dodir_1
 call cputs
 add  sp, 2
;-300         return;

 jmp .retndodir
;-301         }

;-302     cputs("Name             Date   Time Attr   Size");

.dodir37:
 push dodir_2
 call cputs
 add  sp, 2
;-303   do {

.dodir38:
;-304         putch(10);  

 push 10
 call putch
 add  sp, 2
;-305         cputs(dirdatname);  

 lea  ax, [dirdatname]
 push ax
 call cputs
 add  sp, 2
;-306         j=strlen(dirdatname);

 lea  ax, [dirdatname]
 push ax
 call strlen
 add  sp, 2
 mov [bp-2], ax
;-307         do {

.dodir39:
;-308             putch(' '); 

 push 32
 call putch
 add  sp, 2
;-309             j++; 

 inc  word[bp-2]
;-310             } while (j<13);

 mov ax, [bp-2]
 cmp ax, 13
 jge .dodir40
 jmp .dodir39
.dodir40:
;-311             

;-312         j=dirdate & 31;         

 mov ax, [dirdate]
 and ax, 31
 mov [bp-2], ax
;-313         if (j<10) putch(' '); 

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir41
 push 32
 call putch
 add  sp, 2
;-314         prunsign(j); 

.dodir41:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-315         putch('.');

 push 46
 call putch
 add  sp, 2
;-316             

;-317         j=dirdate >> 5; 

 mov ax, [dirdate]
 shr ax, 5
 mov [bp-2], ax
;-318         j&=  15;

 and  word[bp-2], 15
;-319         if (j<10) putch('0'); 

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir42
 push 48
 call putch
 add  sp, 2
;-320         prunsign(j); 

.dodir42:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-321         putch('.');

 push 46
 call putch
 add  sp, 2
;-322             

;-323         j=dirdate >> 9; 

 mov ax, [dirdate]
 shr ax, 9
 mov [bp-2], ax
;-324         j+=  80;

 add  word[bp-2], 80
;-325         if (j>=100) j-=100;

 mov ax, [bp-2]
 cmp ax, 100 ;unsigned : 1
 jl  .dodir43
 sub  word[bp-2], 100
;-326         if (j<10) putch('0'); 

.dodir43:
 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir44
 push 48
 call putch
 add  sp, 2
;-327         prunsign(j); 

.dodir44:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-328         putch(' ');

 push 32
 call putch
 add  sp, 2
;-329         putch(' ');

 push 32
 call putch
 add  sp, 2
;-330             

;-331         j=dirtime  >>11;         

 mov ax, [dirtime]
 shr ax, 11
 mov [bp-2], ax
;-332         if (j<10) putch(' '); 

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir45
 push 32
 call putch
 add  sp, 2
;-333         prunsign(j); 

.dodir45:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-334         putch(':');

 push 58
 call putch
 add  sp, 2
;-335             

;-336         j=dirtime  >> 5; 

 mov ax, [dirtime]
 shr ax, 5
 mov [bp-2], ax
;-337         j&=  63;

 and  word[bp-2], 63
;-338         if (j<10) putch('0'); 

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir46
 push 48
 call putch
 add  sp, 2
;-339         prunsign(j); 

.dodir46:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-340         putch(' ');

 push 32
 call putch
 add  sp, 2
;-341                        

;-342         c = dirattr & 32;

 mov al, [dirattr]
 and al, 32
 mov [bp-4], al
;-343         if (c) putch('A'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir47
 push 65
 call putch
 add  sp, 2
 jmp .dodir48
.dodir47:
 push 32
 call putch
 add  sp, 2
;-344         c = dirattr & 16;

.dodir48:
 mov al, [dirattr]
 and al, 16
 mov [bp-4], al
;-345         if (c) putch('D'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir49
 push 68
 call putch
 add  sp, 2
 jmp .dodir50
.dodir49:
 push 32
 call putch
 add  sp, 2
;-346         c = dirattr & 8;

.dodir50:
 mov al, [dirattr]
 and al, 8
 mov [bp-4], al
;-347         if (c) putch('V'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir51
 push 86
 call putch
 add  sp, 2
 jmp .dodir52
.dodir51:
 push 32
 call putch
 add  sp, 2
;-348         c = dirattr & 4;

.dodir52:
 mov al, [dirattr]
 and al, 4
 mov [bp-4], al
;-349         if (c) putch('S'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir53
 push 83
 call putch
 add  sp, 2
 jmp .dodir54
.dodir53:
 push 32
 call putch
 add  sp, 2
;-350         c = dirattr & 2;

.dodir54:
 mov al, [dirattr]
 and al, 2
 mov [bp-4], al
;-351         if (c) putch('H'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir55
 push 72
 call putch
 add  sp, 2
 jmp .dodir56
.dodir55:
 push 32
 call putch
 add  sp, 2
;-352         c = dirattr & 1;

.dodir56:
 mov al, [dirattr]
 and al, 1
 mov [bp-4], al
;-353         if (c) putch('R'); else putch(' ');

 mov al, [bp-4]
 or  al, al
 je .dodir57
 push 82
 call putch
 add  sp, 2
 jmp .dodir58
.dodir57:
 push 32
 call putch
 add  sp, 2
;-354                               

;-355         if (dirlenhi) { 

.dodir58:
 mov ax, [dirlenhi]
 or  al, al
 je .dodir59
;-356             dirlenlo=dirlenlo >>10; 

 mov ax, [dirlenlo]
 shr ax, 10
 mov word [dirlenlo], ax
;-357             dirlenhi=dirlenhi << 6;

 mov ax, [dirlenhi]
 shl ax, 6
 mov word [dirlenhi], ax
;-358             dirlenhi=dirlenhi+dirlenlo;

 mov ax, [dirlenhi]
 add ax, [dirlenlo]
 mov word [dirlenhi], ax
;-359             putch(' ');

 push 32
 call putch
 add  sp, 2
;-360             prunsign(dirlenhi); 

 push word [dirlenhi]
 call prunsign
 add  sp, 2
;-361             cputs(" KB"); 

 push dodir_3
 call cputs
 add  sp, 2
;-362             }

;-363         else {

 jmp .dodir60
.dodir59:
;-364             putch(' ');

 push 32
 call putch
 add  sp, 2
;-365             prunsign(dirlenlo);

 push word [dirlenlo]
 call prunsign
 add  sp, 2
;-366             }   

;-367     j=fnext(path);  

.dodir60:
 lea  ax, [path]
 push ax
 call fnext
 add  sp, 2
 mov [bp-2], ax
;-368     } while (j!=18);

 mov ax, [bp-2]
 cmp ax, 18
 je  .dodir61
 jmp .dodir38
.dodir61:
;-369     putch(10);    

 push 10
 call putch
 add  sp, 2
;-370 }

;-371 

;-372 

;-373 char memSignature; 

 .retndodir: LEAVE
 ret
dodir_0 db "Current directory: ",0
dodir_1 db "Empty directory ",0
dodir_2 db "Name             Date   Time Attr   Size",0
dodir_3 db " KB",0
ENDP
memSignature db 0
;-374 unsigned int memOwner; 

memOwner dw 0
;-375 unsigned int memSize;

memSize dw 0
;-376 

;-377 int domem() { 

domem: PROC
;-378     unsigned int i;

;-379     char c;

;-380     ah=0x52;//DOS list of lists 
;
 ENTER  4,0
 mov  ah, 82
;-381     asm int 33 ; // out= ES:BX ptr to invars

 int 33 ; // out= ES:BX ptr to invars
;-382     asm mov [vBX], bx 

 mov [vBX], bx 
;-383 //    asm mov es, [es:bx-2]//first memory control block

;-384     __emit__(0x26,0x8E,0x47,0xFE);            

 db 38,142,71,254
;-385     asm mov [vES], es   

 mov [vES], es   
;-386     do {

.domem62:
;-387         putch(10); 

 push 10
 call putch
 add  sp, 2
;-388         cputs("Start:"); 

 push domem_0
 call cputs
 add  sp, 2
;-389         printhex16(vES);

 push word [vES]
 call printhex16
 add  sp, 2
;-390         if (vES >= 0xA000) cputs(" MCB in UMB");

 mov ax, [vES]
 cmp ax, 40960 ;unsigned : 0
 jb  .domem63
 push domem_1
 call cputs
 add  sp, 2
;-391 //        asm mov al, [es:0]// M or Z 

;-392         __emit__(0x26,0xA0,0,0);     

.domem63:
 db 38,160,0,0
;-393         asm mov [memSignature], al         

 mov [memSignature], al         
;-394 //        cputs(", ");

;-395 //        putch(memSignature);

;-396 //        asm mov ax, [es:1]//program segment prefix  

;-397         __emit__(0x26,0xA1,1,0);           

 db 38,161,1,0
;-398         asm mov [memOwner], ax  

 mov [memOwner], ax  
;-399         cputs(", PSP:"); 

 push domem_2
 call cputs
 add  sp, 2
;-400         printhex16(memOwner);

 push word [memOwner]
 call printhex16
 add  sp, 2
;-401 //        asm mov ax, [es:3]//size in para

;-402         __emit__(0x26,0xA1,3,0);                       

 db 38,161,3,0
;-403         asm mov [memSize], ax  

 mov [memSize], ax  
;-404         cputs(", Size:"); 

 push domem_3
 call cputs
 add  sp, 2
;-405         printhex16(memSize);

 push word [memSize]
 call printhex16
 add  sp, 2
;-406         if (memOwner == 0) cputs(" free");

 mov ax, [memOwner]
 cmp ax, 0
 jne .domem64
 push domem_4
 call cputs
 add  sp, 2
;-407         if (memOwner == 8) cputs(" DOS ");

.domem64:
 mov ax, [memOwner]
 cmp ax, 8
 jne .domem65
 push domem_5
 call cputs
 add  sp, 2
;-408         i=memOwner-vES; 

.domem65:
 mov ax, [memOwner]
 sub ax, [vES]
 mov [bp-2], ax
;-409     vES = vES + memSize;  

 mov ax, [vES]
 add ax, [memSize]
 mov word [vES], ax
;-410     vES++;

 inc  word[vES]
;-411     asm mov es, vES 

 mov es, vES 
;-412     es = vES;

 mov  es, [vES]
;-413     } 

;-414     while (memSignature == 'M');

 mov al, [memSignature]
 cmp al, 77
 jne .domem66
 jmp .domem62
.domem66:
;-415     putch(10); 

 push 10
 call putch
 add  sp, 2
;-416 }

;-417 

;-418 int dotype() {
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
;-419     int fdin; int i;

;-420     fdin=openR(par2);
;
 ENTER  4,0
 push word [par2]
 call openR
 add  sp, 2
 mov [bp-2], ax
;-421     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dotype67
;-422         cputs("file missing");

 push dotype_0
 call cputs
 add  sp, 2
;-423         putch(10); 

 push 10
 call putch
 add  sp, 2
;-424         return;

 jmp .retndotype
;-425         }

;-426     do {

.dotype67:
.dotype68:
;-427         DOS_NoBytes=readR(&DOS_ByteRead, fdin);

 push word [bp-2]
 lea  ax, [DOS_ByteRead]
 push ax
 call readR
 add  sp, 4
 mov word [DOS_NoBytes], ax
;-428         putch(DOS_ByteRead); 

 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-429         } 

;-430         while (DOS_NoBytes);

 mov ax, [DOS_NoBytes]
 or  al, al
 je .dotype69
 jmp .dotype68
.dotype69:
;-431     fcloseR(fdin);

 push word [bp-2]
 call fcloseR
 add  sp, 2
;-432 }

;-433 

;-434 int Prompt1(unsigned char *s) {

 .retndotype: LEAVE
 ret
dotype_0 db "file missing",0
ENDP
Prompt1: PROC
;-435     char c; 

;-436     unsigned char *startstr;

;-437     startstr=s;  
;
 ENTER  4,0
 mov ax, [bp+4]
 mov [bp-4], ax
;-438     do { 

.Prompt170:
;-439         c=GetKey();  

 call GetKey
 mov [bp-2], al
;-440         if (c == 27)    exitR(1);//good bye

 mov al, [bp-2]
 cmp al, 27
 jne .Prompt171
 push 1
 call exitR
 add  sp, 2
;-441         if (c==8) {

.Prompt171:
 mov al, [bp-2]
 cmp al, 8
 jne .Prompt172
;-442             if (s > startstr){

 mov ax, [bp+4]
 cmp ax, [bp-4]
 jle .Prompt173
;-443                 s--;

 dec  word[bp+4]
;-444                 putch(8);

 push 8
 call putch
 add  sp, 2
;-445                 putch(' ');

 push 32
 call putch
 add  sp, 2
;-446                 putch(8);

 push 8
 call putch
 add  sp, 2
;-447                 }

;-448                 else putch(7);

 jmp .Prompt174
.Prompt173:
 push 7
 call putch
 add  sp, 2
;-449             }

.Prompt174:
;-450             else { 

 jmp .Prompt175
.Prompt172:
;-451                 *s=c; 

 mov al, [bp-2]
 mov  bx, [bp+4]
 mov  [bx], al
;-452                 s++; 

 inc  word[bp+4]
;-453                 putch(c); 

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-454             }

;-455     } while(c!=13); 

.Prompt175:
 mov al, [bp-2]
 cmp al, 13
 je  .Prompt176
 jmp .Prompt170
.Prompt176:
;-456     s--;  

 dec  word[bp+4]
;-457     *s=0; 

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-458 }

;-459 

;-460 char Info1[]=" commands: help,exit,cls,type,mem,dir,dump (adr)";
 LEAVE
 ret
ENDP
Info1 db " commands: help,exit,cls,type,mem,dir,dump (adr)",0
;-461 //dos,exec, *.COM

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

;-470 char inp_buf[81]; 
 LEAVE
 ret
ENDP
section .bss
absolute 25064
inp_buf resb 81
section .text
;-471 

;-472 int getpar(char *t) {    

getpar: PROC
;-473     while (*t == 32) t++; 
;
 ENTER  0,0
.getpar77:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar78
 inc  word[bp+4]
;-474     if (*t<=13) return 0;

 jmp .getpar77
.getpar78:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar79
 mov ax, 0
 jmp .retngetpar
;-475         

;-476     par1=t; 

.getpar79:
 mov ax, [bp+4]
 mov word [par1], ax
;-477     while(*t >= 33) t++; 

.getpar80:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar81
 inc  word[bp+4]
;-478     if (*t==0) return 1;

 jmp .getpar80
.getpar81:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar82
 mov ax, 1
 jmp .retngetpar
;-479     *t=0; 

.getpar82:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-480     t++;

 inc  word[bp+4]
;-481     while (*t == 32) t++; 

.getpar83:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar84
 inc  word[bp+4]
;-482     if (*t<=13) return 1;

 jmp .getpar83
.getpar84:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar85
 mov ax, 1
 jmp .retngetpar
;-483         

;-484     par2=t; 

.getpar85:
 mov ax, [bp+4]
 mov word [par2], ax
;-485     while(*t >= 33) t++; 

.getpar86:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar87
 inc  word[bp+4]
;-486     if (*t==0) return 2;

 jmp .getpar86
.getpar87:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar88
 mov ax, 2
 jmp .retngetpar
;-487     *t=0; 

.getpar88:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-488     t++;    

 inc  word[bp+4]
;-489     while (*t == 32) t++; 

.getpar89:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar90
 inc  word[bp+4]
;-490     if (*t<=13) return 2;

 jmp .getpar89
.getpar90:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar91
 mov ax, 2
 jmp .retngetpar
;-491          

;-492     par3=t;     

.getpar91:
 mov ax, [bp+4]
 mov word [par3], ax
;-493     while(*t >= 33) t++; 

.getpar92:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar93
 inc  word[bp+4]
;-494     *t=0;     

 jmp .getpar92
.getpar93:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-495     return 3;    

 mov ax, 3
 jmp .retngetpar
;-496 }

;-497 

;-498 int intrinsic() {

 .retngetpar: LEAVE
 ret
ENDP
intrinsic: PROC
;-499     toupper(par1);      

 push word [par1]
 call toupper
 add  sp, 2
;-500     if(eqstr(par1,"HELP")){dohelp();return;}

 push intrinsic_0
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic94
 call dohelp
 jmp .retnintrinsic
;-501     if(eqstr(par1,"EXIT"))exitR(0);

.intrinsic94:
 push intrinsic_1
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic95
 push 0
 call exitR
 add  sp, 2
;-502     if(eqstr(par1,"CLS" )){clrscr();return;}

.intrinsic95:
 push intrinsic_2
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic96
 call clrscr
 jmp .retnintrinsic
;-503     if(eqstr(par1,"TYPE")){dotype();return;}

.intrinsic96:
 push intrinsic_3
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic97
 call dotype
 jmp .retnintrinsic
;-504     if(eqstr(par1,"MEM" )){domem(); return;}

.intrinsic97:
 push intrinsic_4
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic98
 call domem
 jmp .retnintrinsic
;-505     if(eqstr(par1,"DIR" )){dodir();return;}

.intrinsic98:
 push intrinsic_5
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic99
 call dodir
 jmp .retnintrinsic
;-506     if(eqstr(par1,"DUMP")){dodump();return;}

.intrinsic99:
 push intrinsic_6
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic100
 call dodump
 jmp .retnintrinsic
;-507 //    if(eqstr(par1,"DOS" )){dodos(); return;}

;-508 //    if(eqstr(par1,"EXEC")){exec1 ();return;}

;-509 //    extrinsic(inp_buf);

;-510 }

.intrinsic100:
;-511 

;-512 

;-513 int get_cmd(){

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
;-514     *inp_buf=0;

 mov ax, 0
 mov  bx, [inp_buf]
 mov  [bx], al
;-515     DOS_ERR=0;

 mov ax, 0
 mov word [DOS_ERR], ax
;-516     putch(':');

 push 58
 call putch
 add  sp, 2
;-517     Prompt1(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call Prompt1
 add  sp, 2
;-518     putch(10);

 push 10
 call putch
 add  sp, 2
;-519 }

;-520 

;-521 int main() {

 ret
ENDP
main: PROC
;-522     setblock(4096);

 push 4096
 call setblock
 add  sp, 2
;-523     dohelp();

 call dohelp
;-524     do { 

.main101:
;-525         get_cmd(); 

 call get_cmd
;-526         par_count=getpar(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call getpar
 add  sp, 2
 mov byte [par_count], al
;-527         intrinsic(); 

 call intrinsic
;-528         } 

;-529     while(1);

 mov ax, 1
 or  al, al
 je .main102
 jmp .main101
.main102:
;-530 }

 ret
ENDP
;Glob. variables:38 (200), Functions:44 (300), Lines:531
;Constant: 172 (3000), stacksize: 40491