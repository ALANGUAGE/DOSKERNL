;PLA compiler A.COM V0.9.5, Input: CMD.C, Output: CMD.S
org  256 
jmp main
;-1 char Version1[]="CMD V0.5";//Command.com for 1OS

Version1 db "CMD V0.5",0
;-2 

;-3 int DOS_ERR=0;

DOS_ERR dw 0
;-4 char inp_buf[81]; 

section .bss
absolute 25000
inp_buf resb 81
section .text
;-5 char par_count=0;

par_count db 0
;-6 char *par1;

par1 dw 0
;-7 char *par2;

par2 dw 0
;-8 char *par3;

par3 dw 0
;-9 int DOS_NoBytes;        //number of bytes read (0 or 1)

DOS_NoBytes dw 0
;-10 char DOS_ByteRead;      //the byte just read by DOS

DOS_ByteRead db 0
;-11         

;-12         

;-13 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }

writetty: PROC
 mov  ah, 14
 mov  bx, 0
 db 205,16
;-14 int putch(char c)  {if (c==10) {al=13; writetty();} al=c; writetty(); }

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
;-15 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
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
;-16 

;-17 int gotoxy (char x, char y) {
 LEAVE
 ret
ENDP
gotoxy: PROC
;-18     ah=2; 
;
 ENTER  0,0
 mov  ah, 2
;-19     bx=0; 

 mov  bx, 0
;-20     dh=y; 

 mov  dh, [bp+6]
;-21     dl=x; 

 mov  dl, [bp+4]
;-22     __emit__(0xCD,0x10); 

 db 205,16
;-23 }

;-24 int clrscr()    {
 LEAVE
 ret
ENDP
clrscr: PROC
;-25     ax=0x0600; 

 mov  ax, 1536
;-26     bh=7; 

 mov  bh, 7
;-27     cx=0; 

 mov  cx, 0
;-28     dx=0x184F; 

 mov  dx, 6223
;-29     __emit__(0xCD,0x10); 

 db 205,16
;-30     gotoxy(0,0);

 push 0
 push 0
 call gotoxy
 add  sp, 4
;-31 }

;-32 

;-33 

;-34 int getch()  { ah=0x10; __emit__(0xCD,0x16); }

 ret
ENDP
getch: PROC
 mov  ah, 16
 db 205,22
;-35 int waitkey(){ ah=0x11; __emit__(0xCD,0x10); __emit__(0x74,0xFA); }

 ret
ENDP
waitkey: PROC
 mov  ah, 17
 db 205,16
 db 116,250
;-36 int GetKey() {

 ret
ENDP
GetKey: PROC
;-37     int i; 

;-38     waitkey();
;
 ENTER  2,0
 call waitkey
;-39     i=getch() & 255; 

 call getch
 and ax, 255
 mov [bp-2], ax
;-40     if(i==0)i=getch()+256; 

 mov ax, [bp-2]
 cmp ax, 0
 jne .GetKey4
 call getch
 add ax, 256
 mov [bp-2], ax
;-41         ax=i;

.GetKey4:
 mov  ax, [bp-2]
;-42 }

;-43 int getche() { GetKey(); writetty();}
 LEAVE
 ret
ENDP
getche: PROC
 call GetKey
 call writetty
;-44 

;-45 int DosInt() {

 ret
ENDP
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

;-65 

;-66 int printhex4(unsigned char c) {
 LEAVE
 ret
ENDP
printhex4: PROC
;-67     c += 48;
;
 ENTER  0,0
 add  byte[bp+4], 48
;-68     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex45
 add  byte[bp+4], 7
;-69     putch(c);

.printhex45:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-70 }

;-71 int printhex8a(unsigned char c) {
 LEAVE
 ret
ENDP
printhex8a: PROC
;-72     unsigned char nib;

;-73     nib = c >> 4; printhex4(nib);
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
;-74     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-75 }

;-76 int printhex16(unsigned int i) {
 LEAVE
 ret
ENDP
printhex16: PROC
;-77     unsigned int half;

;-78     half = i >>  8; printhex8a(half);
;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2
;-79     half = i & 255; printhex8a(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2
;-80 }

;-81 

;-82 int prunsign(unsigned int n) { 
 LEAVE
 ret
ENDP
prunsign: PROC
;-83     unsigned int e;

;-84     if (n >= 10) { 
;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .prunsign6
;-85         e=n/10; 

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-86         prunsign(e); 

 push word [bp-2]
 call prunsign
 add  sp, 2
;-87         } 

;-88     n=n%10; 

.prunsign6:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-89     n+='0'; 

 add  word[bp+4], 48
;-90     putch(n); 

 push word [bp+4]
 call putch
 add  sp, 2
;-91 }

;-92 

;-93 int letter(char c) {
 LEAVE
 ret
ENDP
letter: PROC
;-94   if (c> 'z') return 0;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 122
 jle .letter7
 mov ax, 0
 jmp .retnletter
;-95   if (c< 'A') return 0;

.letter7:
 mov al, [bp+4]
 cmp al, 65
 jge .letter8
 mov ax, 0
 jmp .retnletter
;-96   if (c> 'Z') { if (c< 'a') return 0; }

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
;-97   return 1;

.letter9:
 mov ax, 1
 jmp .retnletter
;-98 }

;-99 int digit(char c){

 .retnletter: LEAVE
 ret
ENDP
digit: PROC
;-100     if(c<'0') return 0;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit11
 mov ax, 0
 jmp .retndigit
;-101     if(c>'9') return 0;

.digit11:
 mov al, [bp+4]
 cmp al, 57
 jle .digit12
 mov ax, 0
 jmp .retndigit
;-102     return 1;

.digit12:
 mov ax, 1
 jmp .retndigit
;-103 }

;-104 int strcpy(char *s, char *t) {

 .retndigit: LEAVE
 ret
ENDP
strcpy: PROC
;-105     do { *s=*t; s++; t++; }
;
 ENTER  0,0
.strcpy13:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-106     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy14
 jmp .strcpy13
.strcpy14:
;-107     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-108     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-109 }

;-110 int eqstr(char *p, char *q) {

 .retnstrcpy: LEAVE
 ret
ENDP
eqstr: PROC
;-111     while(*p) {
;
 ENTER  0,0
.eqstr15:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr16
;-112         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr17
 mov ax, 0
 jmp .retneqstr
;-113             p++;

.eqstr17:
 inc  word[bp+4]
;-114             q++;

 inc  word[bp+6]
;-115         }

;-116     if(*q) return 0;

 jmp .eqstr15
.eqstr16:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr18
 mov ax, 0
 jmp .retneqstr
;-117     return 1;

.eqstr18:
 mov ax, 1
 jmp .retneqstr
;-118 }

;-119 int toupper(char *s) {

 .retneqstr: LEAVE
 ret
ENDP
toupper: PROC
;-120     while(*s) {
;
 ENTER  0,0
.toupper19:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper20
;-121         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  .toupper21
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  .toupper22
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
;-122             s++;

.toupper22:
.toupper21:
 inc  word[bp+4]
;-123     }

;-124 }

 jmp .toupper19
.toupper20:
;-125 

;-126 char memSignature; 
 LEAVE
 ret
ENDP
memSignature db 0
;-127 unsigned int memOwner; 

memOwner dw 0
;-128 unsigned int memSize;

memSize dw 0
;-129 unsigned int vES; 

vES dw 0
;-130 unsigned int vBX; 

vBX dw 0
;-131 

;-132 int domem() { 

domem: PROC
;-133     unsigned int i;

;-134     char c;

;-135     ah=0x52;//DOS list of lists 
;
 ENTER  4,0
 mov  ah, 82
;-136     asm int 33 ; // out= ES:BX ptr to invars

 int 33 ; // out= ES:BX ptr to invars
;-137     asm mov [vBX], bx 

 mov [vBX], bx 
;-138     asm mov [vES], es

 mov [vES], es
;-139 //    asm mov es, [es:bx-2]//first memory control block

;-140     __emit__(0x26,0x8E,0x47,0xFE);    

 db 38,142,71,254
;-141         

;-142     asm mov [vES], es

 mov [vES], es
;-143     

;-144     do {

.domem23:
;-145         putch(10); 

 push 10
 call putch
 add  sp, 2
;-146         cputs("ES:"); 

 push domem_0
 call cputs
 add  sp, 2
;-147         printhex16(vES);

 push word [vES]
 call printhex16
 add  sp, 2
;-148         if (vES >= 0xA000) cputs(" MCB in UMB");

 mov ax, [vES]
 cmp ax, 40960 ;unsigned : 0
 jb  .domem24
 push domem_1
 call cputs
 add  sp, 2
;-149 //        asm mov al, [es:0]// M or Z 

;-150         __emit__(0x26,0xA0,0,0);     

.domem24:
 db 38,160,0,0
;-151         asm mov [memSignature], al  

 mov [memSignature], al  
;-152         

;-153         cputs(", ");

 push domem_2
 call cputs
 add  sp, 2
;-154         putch(memSignature);

 mov al, byte [memSignature]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-155 //        asm mov ax, [es:1]//program segment prefix  

;-156         __emit__(0x26,0xA1,1,0);           

 db 38,161,1,0
;-157         asm mov [memOwner], ax  

 mov [memOwner], ax  
;-158         cputs(", PSP:"); 

 push domem_3
 call cputs
 add  sp, 2
;-159         printhex16(memOwner);

 push word [memOwner]
 call printhex16
 add  sp, 2
;-160 //        asm mov ax, [es:3]//size in para

;-161         __emit__(0x26,0xA1,3,0);                       

 db 38,161,3,0
;-162         asm mov [memSize], ax  

 mov [memSize], ax  
;-163         cputs(", Size:"); 

 push domem_4
 call cputs
 add  sp, 2
;-164         printhex16(memSize);

 push word [memSize]
 call printhex16
 add  sp, 2
;-165         if (memOwner == 0) cputs(" free");

 mov ax, [memOwner]
 cmp ax, 0
 jne .domem25
 push domem_5
 call cputs
 add  sp, 2
;-166         if (memOwner == 8) cputs(" DOS ");

.domem25:
 mov ax, [memOwner]
 cmp ax, 8
 jne .domem26
 push domem_6
 call cputs
 add  sp, 2
;-167         i=memOwner-vES; 

.domem26:
 mov ax, [memOwner]
 sub ax, [vES]
 mov [bp-2], ax
;-168     vES = vES + memSize;  

 mov ax, [vES]
 add ax, [memSize]
 mov word [vES], ax
;-169     vES++;

 inc  word[vES]
;-170     asm mov es, vES 

 mov es, vES 
;-171     es = vES;

 mov  es, [vES]
;-172     } 

;-173     while (memSignature == 'M');

 mov al, [memSignature]
 cmp al, 77
 jne .domem27
 jmp .domem23
.domem27:
;-174 }

;-175 

;-176 int dotype() {
 LEAVE
 ret
domem_0 db "ES:",0
domem_1 db " MCB in UMB",0
domem_2 db ", ",0
domem_3 db ", PSP:",0
domem_4 db ", Size:",0
domem_5 db " free",0
domem_6 db " DOS ",0
ENDP
dotype: PROC
;-177     int fdin; int i;

;-178     fdin=openR(par2);
;
 ENTER  4,0
 push word [par2]
 call openR
 add  sp, 2
 mov [bp-2], ax
;-179     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dotype28
;-180         putch(10); 

 push 10
 call putch
 add  sp, 2
;-181         cputs("file missing: "); 

 push dotype_0
 call cputs
 add  sp, 2
;-182         cputs(par2); 

 push word [par2]
 call cputs
 add  sp, 2
;-183         return;

 jmp .retndotype
;-184         }

;-185     do {

.dotype28:
.dotype29:
;-186         DOS_NoBytes=readR(&DOS_ByteRead, fdin);

 push word [bp-2]
 lea  ax, [DOS_ByteRead]
 push ax
 call readR
 add  sp, 4
 mov word [DOS_NoBytes], ax
;-187         putch(DOS_ByteRead); 

 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-188         } 

;-189         while (DOS_NoBytes);

 mov ax, [DOS_NoBytes]
 or  al, al
 je .dotype30
 jmp .dotype29
.dotype30:
;-190     fcloseR(fdin);

 push word [bp-2]
 call fcloseR
 add  sp, 2
;-191 }

;-192 

;-193 int Prompt1(unsigned char *s) {

 .retndotype: LEAVE
 ret
dotype_0 db "file missing: ",0
ENDP
Prompt1: PROC
;-194     char c; 

;-195     unsigned char *startstr;

;-196     startstr=s;  
;
 ENTER  4,0
 mov ax, [bp+4]
 mov [bp-4], ax
;-197     do { 

.Prompt131:
;-198         c=GetKey();  

 call GetKey
 mov [bp-2], al
;-199         if (c == 27)    exitR(1);//good bye

 mov al, [bp-2]
 cmp al, 27
 jne .Prompt132
 push 1
 call exitR
 add  sp, 2
;-200         if (c==8) {

.Prompt132:
 mov al, [bp-2]
 cmp al, 8
 jne .Prompt133
;-201             if (s > startstr){

 mov ax, [bp+4]
 cmp ax, [bp-4]
 jle .Prompt134
;-202                 s--;

 dec  word[bp+4]
;-203                 putch(8);

 push 8
 call putch
 add  sp, 2
;-204                 putch(' ');

 push 32
 call putch
 add  sp, 2
;-205                 putch(8);

 push 8
 call putch
 add  sp, 2
;-206                 }

;-207                 else putch(7);

 jmp .Prompt135
.Prompt134:
 push 7
 call putch
 add  sp, 2
;-208             }

.Prompt135:
;-209             else { 

 jmp .Prompt136
.Prompt133:
;-210                 *s=c; 

 mov al, [bp-2]
 mov  bx, [bp+4]
 mov  [bx], al
;-211                 s++; 

 inc  word[bp+4]
;-212                 putch(c); 

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-213             }

;-214     } while(c!=13); 

.Prompt136:
 mov al, [bp-2]
 cmp al, 13
 je  .Prompt137
 jmp .Prompt131
.Prompt137:
;-215     s--;  

 dec  word[bp+4]
;-216     *s=0; 

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-217 }

;-218 

;-219 char Info1[]=" commands: help,exit,cls,type,mem";
 LEAVE
 ret
ENDP
Info1 db " commands: help,exit,cls,type,mem",0
;-220 //char Info1[]="dir,dos,dump,exec,fn, *.COM";

;-221 

;-222 int dohelp() { 

dohelp: PROC
;-223     unsigned int i;   

;-224     cputs(Version1);
;
 ENTER  2,0
 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2
;-225 //    rdump();

;-226     cputs(Info1);   putch(10); 

 lea  ax, [Info1]
 push ax
 call cputs
 add  sp, 2
 push 10
 call putch
 add  sp, 2
;-227 }

;-228 

;-229 int getpar(char *t) {    
 LEAVE
 ret
ENDP
getpar: PROC
;-230     while (*t == 32) t++; 
;
 ENTER  0,0
.getpar38:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar39
 inc  word[bp+4]
;-231     if (*t<=13) return 0;

 jmp .getpar38
.getpar39:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar40
 mov ax, 0
 jmp .retngetpar
;-232         

;-233     par1=t; 

.getpar40:
 mov ax, [bp+4]
 mov word [par1], ax
;-234     while(*t >= 33) t++; 

.getpar41:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar42
 inc  word[bp+4]
;-235     if (*t==0) return 1;

 jmp .getpar41
.getpar42:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar43
 mov ax, 1
 jmp .retngetpar
;-236     *t=0; 

.getpar43:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-237     t++;

 inc  word[bp+4]
;-238     while (*t == 32) t++; 

.getpar44:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar45
 inc  word[bp+4]
;-239     if (*t<=13) return 1;

 jmp .getpar44
.getpar45:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar46
 mov ax, 1
 jmp .retngetpar
;-240         

;-241     par2=t; 

.getpar46:
 mov ax, [bp+4]
 mov word [par2], ax
;-242     while(*t >= 33) t++; 

.getpar47:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar48
 inc  word[bp+4]
;-243     if (*t==0) return 2;

 jmp .getpar47
.getpar48:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar49
 mov ax, 2
 jmp .retngetpar
;-244     *t=0; 

.getpar49:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-245     t++;    

 inc  word[bp+4]
;-246     while (*t == 32) t++; 

.getpar50:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar51
 inc  word[bp+4]
;-247     if (*t<=13) return 2;

 jmp .getpar50
.getpar51:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar52
 mov ax, 2
 jmp .retngetpar
;-248          

;-249     par3=t;     

.getpar52:
 mov ax, [bp+4]
 mov word [par3], ax
;-250     while(*t >= 33) t++; 

.getpar53:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar54
 inc  word[bp+4]
;-251     *t=0;     

 jmp .getpar53
.getpar54:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-252     return 3;    

 mov ax, 3
 jmp .retngetpar
;-253 }

;-254 

;-255 int intrinsic() {

 .retngetpar: LEAVE
 ret
ENDP
intrinsic: PROC
;-256     toupper(par1);      

 push word [par1]
 call toupper
 add  sp, 2
;-257     if(eqstr(par1,"HELP")){dohelp();return;}

 push intrinsic_0
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic55
 call dohelp
 jmp .retnintrinsic
;-258     if(eqstr(par1,"EXIT"))exitR(0);

.intrinsic55:
 push intrinsic_1
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic56
 push 0
 call exitR
 add  sp, 2
;-259     if(eqstr(par1,"CLS" )){clrscr();return;}

.intrinsic56:
 push intrinsic_2
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic57
 call clrscr
 jmp .retnintrinsic
;-260     if(eqstr(par1,"TYPE")){dotype();return;}

.intrinsic57:
 push intrinsic_3
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic58
 call dotype
 jmp .retnintrinsic
;-261     if(eqstr(par1,"MEM" )){domem(); return;}

.intrinsic58:
 push intrinsic_4
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic59
 call domem
 jmp .retnintrinsic
;-262 //    if(eqstr(s,"DIR" )){dir1();return;}

;-263 //    if(eqstr(s,"DOS" )){dodos(); return;}

;-264 //    if(eqstr(s,"DUMP")){dodump();return;}

;-265 //    if(eqstr(s,"EXEC")){exec1 ();return;}

;-266 //    if(eqstr(s,"FN"  )){doFN();  return;}

;-267 //    extrinsic(inp_buf);

;-268 }

.intrinsic59:
;-269 

;-270 

;-271 int get_cmd(){

 .retnintrinsic:
 ret
intrinsic_0 db "HELP",0
intrinsic_1 db "EXIT",0
intrinsic_2 db "CLS",0
intrinsic_3 db "TYPE",0
intrinsic_4 db "MEM",0
ENDP
get_cmd: PROC
;-272     *inp_buf=0;

 mov ax, 0
 mov  bx, [inp_buf]
 mov  [bx], al
;-273     DOS_ERR=0;

 mov ax, 0
 mov word [DOS_ERR], ax
;-274     putch(':');

 push 58
 call putch
 add  sp, 2
;-275     Prompt1(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call Prompt1
 add  sp, 2
;-276     putch(10);

 push 10
 call putch
 add  sp, 2
;-277 }

;-278 

;-279 int main() {

 ret
ENDP
main: PROC
;-280     dohelp();

 call dohelp
;-281     do { 

.main60:
;-282         get_cmd(); 

 call get_cmd
;-283         par_count=getpar(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call getpar
 add  sp, 2
 mov byte [par_count], al
;-284         intrinsic(); 

 call intrinsic
;-285         } 

;-286     while(1);

 mov ax, 1
 or  al, al
 je .main61
 jmp .main60
.main61:
;-287 }

 ret
ENDP
;Glob. variables:15 (200), Functions:34 (300), Lines:288
;Constant: 158 (3000), stacksize: 40555