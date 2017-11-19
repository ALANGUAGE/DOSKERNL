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
;-61     __asm{lea dx, [bp+4]}; /* = *n */  
;
 ENTER  0,0
lea dx, [bp+4]
;-62 //    dx=n;

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

;-165     cputs(" AX:");

.setblock27:
 push setblock_1
 call cputs
 add  sp, 2
;-166     printhex16(vAX);

 push word [vAX]
 call printhex16
 add  sp, 2
;-167     cputs(", BX:");

 push setblock_2
 call cputs
 add  sp, 2
;-168     printhex16(vBX);

 push word [vBX]
 call printhex16
 add  sp, 2
;-169 }

;-170 

;-171 int Env_seg=0; /*Take over Master Environment*/
 LEAVE
 ret
setblock_0 db " ***Error SetBlock***",0
setblock_1 db " AX:",0
setblock_2 db ", BX:",0
ENDP
Env_seg dw 0
;-172 int Cmd_ofs=0;     int Cmd_seg=0;

Cmd_ofs dw 0
Cmd_seg dw 0
;-173 int FCB_ofs1=0x5C; int FCB_seg1=0;

FCB_ofs1 dw 92
FCB_seg1 dw 0
;-174 int FCB_ofs2=0x6C; int FCB_seg2=0;

FCB_ofs2 dw 108
FCB_seg2 dw 0
;-175 char FCB1=0; char FCB1A[]="           ";

FCB1 db 0
FCB1A db "           ",0
;-176 char FCB1B[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

FCB1B db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;-177 char FCB2=0; char FCB2A[]="           ";

FCB2 db 0
FCB2A db "           ",0
;-178 char FCB2B[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

FCB2B db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;-179 /*

;-180 int exec1(char *Datei1, char *ParmBlk, char *CmdLine1) { 

;-181     int stkseg; int stkptr; unsigned int vAX;

;-182     setblock(4096); 

;-183     putch(10);

;-184     asm mov ax, [es:2ch]

;-185     _ Env_seg=ax;

;-186     Cmd_ofs = CmdLine1;

;-187     _ ax      =es;   

;-188     _ Cmd_seg =ds;

;-189     _ FCB_seg1=ax;   

;-190     _ FCB_seg2=ax;

;-191     _ stkseg  =ss;   

;-192     _ stkptr  =sp;

;-193     dx=Datei1; 

;-194     bx=ParmBlk; 

;-195     ax=0x4B00; 

;-196     DosInt();

;-197     _ vAX=ax;  

;-198     _ ss=stkseg;  

;-199     _ sp=stkptr;

;-200     if (DOS_ERR) cputs(" ***Error EXEC*** ");

;-201 }

;-202 

;-203 int doFN() {  

;-204     __asm{mov si, FNBuf}; // _ si=&FNBuf;

;-205     dx=0;  

;-206     ax=0x4700; 

;-207     DosInt();  

;-208     _ vAX=ax; 

;-209     _ vBX=bx;

;-210     if (DOS_ERR) cputs(" ***Error GetCurrentDir***, AX=");

;-211         //1=OK, 2=LW ungültig

;-212     __asm{mov si, inp_buf};// _ si=&inp_buf;

;-213     __asm{mov di, FNBuf};  // _ di=&FNBuf;

;-214     ax=0x6000; 

;-215     DosInt(); 

;-216     _ vAX=ax; 

;-217     _ vBX=bx;//2=LW ungültig,3=falsch aufgebaut

;-218     if (DOS_ERR) cputs(" ***Error Expand Filename***, AX=");

;-219     cputs("Expanded filename: "); 

;-220     cputs(&FNBuf);

;-221 }

;-222 

;-223 int extrinsic(char *s) {

;-224     char *p; 

;-225     inp_len=strlen(inp_buf);

;-226     if (inp_len == 0) return;

;-227     p=&inp_buf+inp_len; 

;-228     *p=0;

;-229     doFN();

;-230     waitkey();

;-231     exec1(inp_buf, &Env_seg, &inp_len);

;-232 }

;-233 

;-234 int dodos() { 

;-235     char *p; int h;

;-236     strcpy(inp_buf, "");

;-237     h=strlen(inp_buf); 

;-238     inp_len=h & 255; 

;-239     p=&inp_buf+h; 

;-240     *p=0;

;-241     cputs("Before DOS: "); 

;-242     cputs(inp_buf);

;-243     exec1("COMMAND.COM", &Env_seg, &inp_len);

;-244 }

;-245 */

;-246 

;-247 

;-248 int mdump(unsigned char *adr, unsigned int len ) {

mdump: PROC
;-249     unsigned char c; 

;-250     int i; 

;-251     int j;

;-252     j=0; 
;
 ENTER  6,0
 mov ax, 0
 mov [bp-6], ax
;-253     while (j < len ) {

.mdump28:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump29
;-254         putch(10);  

 push 10
 call putch
 add  sp, 2
;-255         printhex16(adr); 

 push word [bp+4]
 call printhex16
 add  sp, 2
;-256         putch(':');

 push 58
 call putch
 add  sp, 2
;-257         i=0; 

 mov ax, 0
 mov [bp-4], ax
;-258         while (i < 16) {

.mdump30:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump31
;-259             putch(' '); 

 push 32
 call putch
 add  sp, 2
;-260             c = *adr; 

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-261             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-262             adr++;

 inc  word[bp+4]
;-263             i++;

 inc  word[bp-4]
;-264             j++;

 inc  word[bp-6]
;-265             }

;-266         putch(' '); 

 jmp .mdump30
.mdump31:
 push 32
 call putch
 add  sp, 2
;-267         adr -=16; 

 sub  word[bp+4], 16
;-268         i=0; 

 mov ax, 0
 mov [bp-4], ax
;-269         while(i < 16) {

.mdump32:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump33
;-270             c= *adr; 

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-271             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump34
 push 46
 call putch
 add  sp, 2
;-272                 else putch(c); 

 jmp .mdump35
.mdump34:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-273             adr++;

.mdump35:
 inc  word[bp+4]
;-274             i++; 

 inc  word[bp-4]
;-275         }  

;-276     }  

 jmp .mdump32
.mdump33:
;-277 }

 jmp .mdump28
.mdump29:
;-278 

;-279 int dodump() { 
 LEAVE
 ret
ENDP
dodump: PROC
;-280     unsigned int i;

;-281     i=atoi(par2);
;
 ENTER  2,0
 push word [par2]
 call atoi
 add  sp, 2
 mov [bp-2], ax
;-282     mdump(i, 120);

 push 120
 push word [bp-2]
 call mdump
 add  sp, 4
;-283     putch(10);      

 push 10
 call putch
 add  sp, 2
;-284 }

;-285 

;-286 char FNBuf[64];
 LEAVE
 ret
ENDP
section .bss
absolute 25000
FNBuf resb 64
section .text
;-287 char Pfad[]="*.*";

Pfad db "*.*",0
;-288 char direcord[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};//21 do not change

direcord db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;-289 char dirattr=0;   

dirattr db 0
;-290 int  dirtime=0;  

dirtime dw 0
;-291 int  dirdate=0;

dirdate dw 0
;-292 int  dirlenlo=0;  

dirlenlo dw 0
;-293 int  dirlenhi=0; 

dirlenhi dw 0
;-294 char dirdatname[]={0,0,0,0,0,0,0,0,0,0,0,0,0};//13 structure until here

dirdatname db 0,0,0,0,0,0,0,0,0,0,0,0,0
;-295 

;-296 int dodir() { 

dodir: PROC
;-297     int j;

;-298     char c;

;-299     si= &FNBuf; 
;
 ENTER  4,0
 mov  si, FNBuf
;-300     dl=0;  

 mov  dl, 0
;-301     ax=0x4700;//get current directory 

 mov  ax, 18176
;-302     DosInt(); 

 call DosInt
;-303     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dodir36
;-304         cputs(" error reading directory");

 push dodir_0
 call cputs
 add  sp, 2
;-305         return;

 jmp .retndodir
;-306     }

;-307     cputs("Current directory: "); 

.dodir36:
 push dodir_1
 call cputs
 add  sp, 2
;-308     cputs(FNBuf); 

 lea  ax, [FNBuf]
 push ax
 call cputs
 add  sp, 2
;-309     putch(10);

 push 10
 call putch
 add  sp, 2
;-310  

;-311     setdta(direcord);

 lea  ax, [direcord]
 push ax
 call setdta
 add  sp, 2
;-312       

;-313     ffirst(Pfad);

 lea  ax, [Pfad]
 push ax
 call ffirst
 add  sp, 2
;-314     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dodir37
;-315         cputs("Empty directory "); 

 push dodir_2
 call cputs
 add  sp, 2
;-316         return;

 jmp .retndodir
;-317         }

;-318     cputs("Name             Date   Time Attr   Size");

.dodir37:
 push dodir_3
 call cputs
 add  sp, 2
;-319   do {

.dodir38:
;-320         putch(10);  

 push 10
 call putch
 add  sp, 2
;-321         cputs(dirdatname);  

 lea  ax, [dirdatname]
 push ax
 call cputs
 add  sp, 2
;-322         j=strlen(dirdatname);

 lea  ax, [dirdatname]
 push ax
 call strlen
 add  sp, 2
 mov [bp-2], ax
;-323         do {

.dodir39:
;-324             putch(' '); 

 push 32
 call putch
 add  sp, 2
;-325             j++; 

 inc  word[bp-2]
;-326             } while (j<13);

 mov ax, [bp-2]
 cmp ax, 13
 jge .dodir40
 jmp .dodir39
.dodir40:
;-327             

;-328         j=dirdate & 31;         

 mov ax, [dirdate]
 and ax, 31
 mov [bp-2], ax
;-329         if (j<10) putch(' '); 

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir41
 push 32
 call putch
 add  sp, 2
;-330         prunsign(j); 

.dodir41:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-331         putch('.');

 push 46
 call putch
 add  sp, 2
;-332             

;-333         j=dirdate >> 5; 

 mov ax, [dirdate]
 shr ax, 5
 mov [bp-2], ax
;-334         j&=  15;

 and  word[bp-2], 15
;-335         if (j<10) putch('0'); 

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir42
 push 48
 call putch
 add  sp, 2
;-336         prunsign(j); 

.dodir42:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-337         putch('.');

 push 46
 call putch
 add  sp, 2
;-338             

;-339         j=dirdate >> 9; 

 mov ax, [dirdate]
 shr ax, 9
 mov [bp-2], ax
;-340         j+=  80;

 add  word[bp-2], 80
;-341         if (j>=100) j-=100;

 mov ax, [bp-2]
 cmp ax, 100 ;unsigned : 1
 jl  .dodir43
 sub  word[bp-2], 100
;-342         if (j<10) putch('0'); 

.dodir43:
 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir44
 push 48
 call putch
 add  sp, 2
;-343         prunsign(j); 

.dodir44:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-344         putch(' ');

 push 32
 call putch
 add  sp, 2
;-345         putch(' ');

 push 32
 call putch
 add  sp, 2
;-346             

;-347         j=dirtime  >>11;         

 mov ax, [dirtime]
 shr ax, 11
 mov [bp-2], ax
;-348         if (j<10) putch(' '); 

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir45
 push 32
 call putch
 add  sp, 2
;-349         prunsign(j); 

.dodir45:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-350         putch(':');

 push 58
 call putch
 add  sp, 2
;-351             

;-352         j=dirtime  >> 5; 

 mov ax, [dirtime]
 shr ax, 5
 mov [bp-2], ax
;-353         j&=  63;

 and  word[bp-2], 63
;-354         if (j<10) putch('0'); 

 mov ax, [bp-2]
 cmp ax, 10
 jge .dodir46
 push 48
 call putch
 add  sp, 2
;-355         prunsign(j); 

.dodir46:
 push word [bp-2]
 call prunsign
 add  sp, 2
;-356         putch(' ');

 push 32
 call putch
 add  sp, 2
;-357                        

;-358         c = dirattr & 32;

 mov al, [dirattr]
 and al, 32
 mov [bp-4], al
;-359         if (c) putch('A'); else putch(' ');

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
;-360         c = dirattr & 16;

.dodir48:
 mov al, [dirattr]
 and al, 16
 mov [bp-4], al
;-361         if (c) putch('D'); else putch(' ');

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
;-362         c = dirattr & 8;

.dodir50:
 mov al, [dirattr]
 and al, 8
 mov [bp-4], al
;-363         if (c) putch('V'); else putch(' ');

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
;-364         c = dirattr & 4;

.dodir52:
 mov al, [dirattr]
 and al, 4
 mov [bp-4], al
;-365         if (c) putch('S'); else putch(' ');

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
;-366         c = dirattr & 2;

.dodir54:
 mov al, [dirattr]
 and al, 2
 mov [bp-4], al
;-367         if (c) putch('H'); else putch(' ');

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
;-368         c = dirattr & 1;

.dodir56:
 mov al, [dirattr]
 and al, 1
 mov [bp-4], al
;-369         if (c) putch('R'); else putch(' ');

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
;-370                               

;-371         if (dirlenhi) { 

.dodir58:
 mov ax, [dirlenhi]
 or  al, al
 je .dodir59
;-372             dirlenlo=dirlenlo >>10; 

 mov ax, [dirlenlo]
 shr ax, 10
 mov word [dirlenlo], ax
;-373             dirlenhi=dirlenhi << 6;

 mov ax, [dirlenhi]
 shl ax, 6
 mov word [dirlenhi], ax
;-374             dirlenhi=dirlenhi+dirlenlo;

 mov ax, [dirlenhi]
 add ax, [dirlenlo]
 mov word [dirlenhi], ax
;-375             putch(' ');

 push 32
 call putch
 add  sp, 2
;-376             prunsign(dirlenhi); 

 push word [dirlenhi]
 call prunsign
 add  sp, 2
;-377             cputs(" KB"); 

 push dodir_4
 call cputs
 add  sp, 2
;-378             }

;-379         else {

 jmp .dodir60
.dodir59:
;-380             putch(' ');

 push 32
 call putch
 add  sp, 2
;-381             prunsign(dirlenlo);

 push word [dirlenlo]
 call prunsign
 add  sp, 2
;-382             }   

;-383     j=fnext(Pfad);  

.dodir60:
 lea  ax, [Pfad]
 push ax
 call fnext
 add  sp, 2
 mov [bp-2], ax
;-384     } while (j!=18);

 mov ax, [bp-2]
 cmp ax, 18
 je  .dodir61
 jmp .dodir38
.dodir61:
;-385     putch(10);    

 push 10
 call putch
 add  sp, 2
;-386 }

;-387 

;-388 

;-389 char memSignature; 

 .retndodir: LEAVE
 ret
dodir_0 db " error reading directory",0
dodir_1 db "Current directory: ",0
dodir_2 db "Empty directory ",0
dodir_3 db "Name             Date   Time Attr   Size",0
dodir_4 db " KB",0
ENDP
memSignature db 0
;-390 unsigned int memOwner; 

memOwner dw 0
;-391 unsigned int memSize;

memSize dw 0
;-392 

;-393 int domem() { 

domem: PROC
;-394     unsigned int i;

;-395     char c;

;-396     ah=0x52;//DOS list of lists 
;
 ENTER  4,0
 mov  ah, 82
;-397     asm int 33 ; // out= ES:BX ptr to invars

 int 33 ; // out= ES:BX ptr to invars
;-398     asm mov [vBX], bx 

 mov [vBX], bx 
;-399 //    asm mov es, [es:bx-2]//first memory control block

;-400     __emit__(0x26,0x8E,0x47,0xFE);            

 db 38,142,71,254
;-401     asm mov [vES], es   

 mov [vES], es   
;-402     do {

.domem62:
;-403         putch(10); 

 push 10
 call putch
 add  sp, 2
;-404         cputs("Start:"); 

 push domem_0
 call cputs
 add  sp, 2
;-405         printhex16(vES);

 push word [vES]
 call printhex16
 add  sp, 2
;-406         if (vES >= 0xA000) cputs(" MCB in UMB");

 mov ax, [vES]
 cmp ax, 40960 ;unsigned : 0
 jb  .domem63
 push domem_1
 call cputs
 add  sp, 2
;-407 //        asm mov al, [es:0]// M or Z 

;-408         __emit__(0x26,0xA0,0,0);     

.domem63:
 db 38,160,0,0
;-409         asm mov [memSignature], al         

 mov [memSignature], al         
;-410 //        cputs(", ");

;-411 //        putch(memSignature);

;-412 //        asm mov ax, [es:1]//program segment prefix  

;-413         __emit__(0x26,0xA1,1,0);           

 db 38,161,1,0
;-414         asm mov [memOwner], ax  

 mov [memOwner], ax  
;-415         cputs(", PSP:"); 

 push domem_2
 call cputs
 add  sp, 2
;-416         printhex16(memOwner);

 push word [memOwner]
 call printhex16
 add  sp, 2
;-417 //        asm mov ax, [es:3]//size in para

;-418         __emit__(0x26,0xA1,3,0);                       

 db 38,161,3,0
;-419         asm mov [memSize], ax  

 mov [memSize], ax  
;-420         cputs(", Size:"); 

 push domem_3
 call cputs
 add  sp, 2
;-421         printhex16(memSize);

 push word [memSize]
 call printhex16
 add  sp, 2
;-422         if (memOwner == 0) cputs(" free");

 mov ax, [memOwner]
 cmp ax, 0
 jne .domem64
 push domem_4
 call cputs
 add  sp, 2
;-423         if (memOwner == 8) cputs(" DOS ");

.domem64:
 mov ax, [memOwner]
 cmp ax, 8
 jne .domem65
 push domem_5
 call cputs
 add  sp, 2
;-424         i=memOwner-vES; 

.domem65:
 mov ax, [memOwner]
 sub ax, [vES]
 mov [bp-2], ax
;-425     vES = vES + memSize;  

 mov ax, [vES]
 add ax, [memSize]
 mov word [vES], ax
;-426     vES++;

 inc  word[vES]
;-427     asm mov es, vES 

 mov es, vES 
;-428     es = vES;

 mov  es, [vES]
;-429     } 

;-430     while (memSignature == 'M');

 mov al, [memSignature]
 cmp al, 77
 jne .domem66
 jmp .domem62
.domem66:
;-431     putch(10); 

 push 10
 call putch
 add  sp, 2
;-432 }

;-433 

;-434 int dotype() {
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
;-435     int fdin; int i;

;-436     fdin=openR(par2);
;
 ENTER  4,0
 push word [par2]
 call openR
 add  sp, 2
 mov [bp-2], ax
;-437     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dotype67
;-438         cputs("file missing");

 push dotype_0
 call cputs
 add  sp, 2
;-439         putch(10); 

 push 10
 call putch
 add  sp, 2
;-440         return;

 jmp .retndotype
;-441         }

;-442     do {

.dotype67:
.dotype68:
;-443         DOS_NoBytes=readR(&DOS_ByteRead, fdin);

 push word [bp-2]
 lea  ax, [DOS_ByteRead]
 push ax
 call readR
 add  sp, 4
 mov word [DOS_NoBytes], ax
;-444         putch(DOS_ByteRead); 

 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-445         } 

;-446         while (DOS_NoBytes);

 mov ax, [DOS_NoBytes]
 or  al, al
 je .dotype69
 jmp .dotype68
.dotype69:
;-447     fcloseR(fdin);

 push word [bp-2]
 call fcloseR
 add  sp, 2
;-448 }

;-449 

;-450 int Prompt1(unsigned char *s) {

 .retndotype: LEAVE
 ret
dotype_0 db "file missing",0
ENDP
Prompt1: PROC
;-451     char c; 

;-452     unsigned char *startstr;

;-453     startstr=s;  
;
 ENTER  4,0
 mov ax, [bp+4]
 mov [bp-4], ax
;-454     do { 

.Prompt170:
;-455         c=GetKey();  

 call GetKey
 mov [bp-2], al
;-456         if (c == 27)    exitR(1);//good bye

 mov al, [bp-2]
 cmp al, 27
 jne .Prompt171
 push 1
 call exitR
 add  sp, 2
;-457         if (c==8) {

.Prompt171:
 mov al, [bp-2]
 cmp al, 8
 jne .Prompt172
;-458             if (s > startstr){

 mov ax, [bp+4]
 cmp ax, [bp-4]
 jle .Prompt173
;-459                 s--;

 dec  word[bp+4]
;-460                 putch(8);

 push 8
 call putch
 add  sp, 2
;-461                 putch(' ');

 push 32
 call putch
 add  sp, 2
;-462                 putch(8);

 push 8
 call putch
 add  sp, 2
;-463                 }

;-464                 else putch(7);

 jmp .Prompt174
.Prompt173:
 push 7
 call putch
 add  sp, 2
;-465             }

.Prompt174:
;-466             else { 

 jmp .Prompt175
.Prompt172:
;-467                 *s=c; 

 mov al, [bp-2]
 mov  bx, [bp+4]
 mov  [bx], al
;-468                 s++; 

 inc  word[bp+4]
;-469                 putch(c); 

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-470             }

;-471     } while(c!=13); 

.Prompt175:
 mov al, [bp-2]
 cmp al, 13
 je  .Prompt176
 jmp .Prompt170
.Prompt176:
;-472     s--;  

 dec  word[bp+4]
;-473     *s=0; 

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-474 }

;-475 

;-476 char Info1[]=" commands: help,exit,cls,type,mem,dir,dump (adr)";
 LEAVE
 ret
ENDP
Info1 db " commands: help,exit,cls,type,mem,dir,dump (adr)",0
;-477 //dos,exec,fn, *.COM

;-478 

;-479 int dohelp() { 

dohelp: PROC
;-480     unsigned int i;   

;-481     cputs(Version1);
;
 ENTER  2,0
 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2
;-482 //    rdump();

;-483     cputs(Info1);   putch(10); 

 lea  ax, [Info1]
 push ax
 call cputs
 add  sp, 2
 push 10
 call putch
 add  sp, 2
;-484 }

;-485 

;-486 char inp_buf[81]; 
 LEAVE
 ret
ENDP
section .bss
absolute 25064
inp_buf resb 81
section .text
;-487 

;-488 int getpar(char *t) {    

getpar: PROC
;-489     while (*t == 32) t++; 
;
 ENTER  0,0
.getpar77:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar78
 inc  word[bp+4]
;-490     if (*t<=13) return 0;

 jmp .getpar77
.getpar78:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar79
 mov ax, 0
 jmp .retngetpar
;-491         

;-492     par1=t; 

.getpar79:
 mov ax, [bp+4]
 mov word [par1], ax
;-493     while(*t >= 33) t++; 

.getpar80:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar81
 inc  word[bp+4]
;-494     if (*t==0) return 1;

 jmp .getpar80
.getpar81:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar82
 mov ax, 1
 jmp .retngetpar
;-495     *t=0; 

.getpar82:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-496     t++;

 inc  word[bp+4]
;-497     while (*t == 32) t++; 

.getpar83:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar84
 inc  word[bp+4]
;-498     if (*t<=13) return 1;

 jmp .getpar83
.getpar84:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar85
 mov ax, 1
 jmp .retngetpar
;-499         

;-500     par2=t; 

.getpar85:
 mov ax, [bp+4]
 mov word [par2], ax
;-501     while(*t >= 33) t++; 

.getpar86:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar87
 inc  word[bp+4]
;-502     if (*t==0) return 2;

 jmp .getpar86
.getpar87:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar88
 mov ax, 2
 jmp .retngetpar
;-503     *t=0; 

.getpar88:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-504     t++;    

 inc  word[bp+4]
;-505     while (*t == 32) t++; 

.getpar89:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar90
 inc  word[bp+4]
;-506     if (*t<=13) return 2;

 jmp .getpar89
.getpar90:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar91
 mov ax, 2
 jmp .retngetpar
;-507          

;-508     par3=t;     

.getpar91:
 mov ax, [bp+4]
 mov word [par3], ax
;-509     while(*t >= 33) t++; 

.getpar92:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar93
 inc  word[bp+4]
;-510     *t=0;     

 jmp .getpar92
.getpar93:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-511     return 3;    

 mov ax, 3
 jmp .retngetpar
;-512 }

;-513 

;-514 int intrinsic() {

 .retngetpar: LEAVE
 ret
ENDP
intrinsic: PROC
;-515     toupper(par1);      

 push word [par1]
 call toupper
 add  sp, 2
;-516     if(eqstr(par1,"HELP")){dohelp();return;}

 push intrinsic_0
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic94
 call dohelp
 jmp .retnintrinsic
;-517     if(eqstr(par1,"EXIT"))exitR(0);

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
;-518     if(eqstr(par1,"CLS" )){clrscr();return;}

.intrinsic95:
 push intrinsic_2
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic96
 call clrscr
 jmp .retnintrinsic
;-519     if(eqstr(par1,"TYPE")){dotype();return;}

.intrinsic96:
 push intrinsic_3
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic97
 call dotype
 jmp .retnintrinsic
;-520     if(eqstr(par1,"MEM" )){domem(); return;}

.intrinsic97:
 push intrinsic_4
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic98
 call domem
 jmp .retnintrinsic
;-521     if(eqstr(par1,"DIR" )){dodir();return;}

.intrinsic98:
 push intrinsic_5
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic99
 call dodir
 jmp .retnintrinsic
;-522     if(eqstr(par1,"DUMP")){dodump();return;}

.intrinsic99:
 push intrinsic_6
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic100
 call dodump
 jmp .retnintrinsic
;-523 //    if(eqstr(par1,"DOS" )){dodos(); return;}

;-524 //    if(eqstr(par1,"EXEC")){exec1 ();return;}

;-525     if(eqstr(par1,"FN"  )){    setblock(4096); return;}

.intrinsic100:
 push intrinsic_7
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic101
 push 4096
 call setblock
 add  sp, 2
 jmp .retnintrinsic
;-526 //    extrinsic(inp_buf);

;-527 }

.intrinsic101:
;-528 

;-529 

;-530 int get_cmd(){

 .retnintrinsic:
 ret
intrinsic_0 db "HELP",0
intrinsic_1 db "EXIT",0
intrinsic_2 db "CLS",0
intrinsic_3 db "TYPE",0
intrinsic_4 db "MEM",0
intrinsic_5 db "DIR",0
intrinsic_6 db "DUMP",0
intrinsic_7 db "FN",0
ENDP
get_cmd: PROC
;-531     *inp_buf=0;

 mov ax, 0
 mov  bx, [inp_buf]
 mov  [bx], al
;-532     DOS_ERR=0;

 mov ax, 0
 mov word [DOS_ERR], ax
;-533     putch(':');

 push 58
 call putch
 add  sp, 2
;-534     Prompt1(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call Prompt1
 add  sp, 2
;-535     putch(10);

 push 10
 call putch
 add  sp, 2
;-536 }

;-537 

;-538 int main() {

 ret
ENDP
main: PROC
;-539     dohelp();

 call dohelp
;-540     do { 

.main102:
;-541         get_cmd(); 

 call get_cmd
;-542         par_count=getpar(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call getpar
 add  sp, 2
 mov byte [par_count], al
;-543         intrinsic(); 

 call intrinsic
;-544         } 

;-545     while(1);

 mov ax, 1
 or  al, al
 je .main103
 jmp .main102
.main103:
;-546 }

 ret
ENDP
;Glob. variables:38 (200), Functions:43 (300), Lines:547
;Constant: 195 (3000), stacksize: 40491