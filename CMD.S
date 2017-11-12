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
;-5 

;-6 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }

writetty: PROC
 mov  ah, 14
 mov  bx, 0
 db 205,16
;-7 int putch(char c)  {if (c==10) {al=13; writetty();} al=c; writetty(); }

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
;-8 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
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
;-9 

;-10 int gotoxy (char x, char y) {
 LEAVE
 ret
ENDP
gotoxy: PROC
;-11     ah=2; 
;
 ENTER  0,0
 mov  ah, 2
;-12     bx=0; 

 mov  bx, 0
;-13     dh=y; 

 mov  dh, [bp+6]
;-14     dl=x; 

 mov  dl, [bp+4]
;-15     __emit__(0xCD,0x10); 

 db 205,16
;-16 }

;-17 int clrscr()    {
 LEAVE
 ret
ENDP
clrscr: PROC
;-18     ax=0x0600; 

 mov  ax, 1536
;-19     bh=7; 

 mov  bh, 7
;-20     cx=0; 

 mov  cx, 0
;-21     dx=0x184F; 

 mov  dx, 6223
;-22     __emit__(0xCD,0x10); 

 db 205,16
;-23     gotoxy(0,0);

 push 0
 push 0
 call gotoxy
 add  sp, 4
;-24 }

;-25 

;-26 

;-27 int getch()  { ah=0x10; __emit__(0xCD,0x16); }

 ret
ENDP
getch: PROC
 mov  ah, 16
 db 205,22
;-28 int waitkey(){ ah=0x11; __emit__(0xCD,0x10); __emit__(0x74,0xFA); }

 ret
ENDP
waitkey: PROC
 mov  ah, 17
 db 205,16
 db 116,250
;-29 int GetKey() {

 ret
ENDP
GetKey: PROC
;-30     int i; 

;-31     waitkey();
;
 ENTER  2,0
 call waitkey
;-32     i=getch() & 255; 

 call getch
 and ax, 255
 mov [bp-2], ax
;-33     if(i==0)i=getch()+256; 

 mov ax, [bp-2]
 cmp ax, 0
 jne .GetKey4
 call getch
 add ax, 256
 mov [bp-2], ax
;-34         ax=i;

.GetKey4:
 mov  ax, [bp-2]
;-35 }

;-36 int getche() { GetKey(); writetty();}
 LEAVE
 ret
ENDP
getche: PROC
 call GetKey
 call writetty
;-37 

;-38 int DosInt() {

 ret
ENDP
DosInt: PROC
;-39     __emit__(0xCD,0x21);//inth 0x21;

 db 205,33
;-40     __emit__(0x73, 04); //ifcarry DOS_ERR++;

 db 115,4
;-41     DOS_ERR++;

 inc  word[DOS_ERR]
;-42 }

;-43 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }

 ret
ENDP
openR: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt
;-44 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
ENDP
creatR: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt
;-45 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
 LEAVE
 ret
ENDP
fcloseR: PROC;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 call DosInt
;-46 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
 LEAVE
 ret
ENDP
exitR: PROC;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 call DosInt
;-47 int readRL(char *s, int fd, int len){
 LEAVE
 ret
ENDP
readRL: PROC
;-48     dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt
;-49 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
ENDP
fputcR: PROC;
 ENTER  0,0
lea dx, [bp+4]
;-50   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt
;-51 

;-52 

;-53 int prunsign(unsigned int n) { 
 LEAVE
 ret
ENDP
prunsign: PROC
;-54     unsigned int e;

;-55     if (n >= 10) { 
;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .prunsign5
;-56         e=n/10; 

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-57         prunsign(e); 

 push word [bp-2]
 call prunsign
 add  sp, 2
;-58         } 

;-59     n=n%10; 

.prunsign5:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-60     n+='0'; 

 add  word[bp+4], 48
;-61     putch(n); 

 push word [bp+4]
 call putch
 add  sp, 2
;-62 }

;-63 

;-64 int isin(char *s, char c) { 
 LEAVE
 ret
ENDP
isin: PROC
;-65     while(*s) { 
;
 ENTER  0,0
.isin6:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .isin7
;-66         if (*s==c) return s; 

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .isin8
 mov ax, [bp+4]
 jmp .retnisin
;-67             s++;

.isin8:
 inc  word[bp+4]
;-68         }  

;-69     return 0;

 jmp .isin6
.isin7:
 mov ax, 0
 jmp .retnisin
;-70 }

;-71 int strcpy(char *s, char *t) {

 .retnisin: LEAVE
 ret
ENDP
strcpy: PROC
;-72     do { *s=*t; s++; t++; }
;
 ENTER  0,0
.strcpy9:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-73     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy10
 jmp .strcpy9
.strcpy10:
;-74     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-75     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-76 }

;-77 int eqstr(char *p, char *q) {

 .retnstrcpy: LEAVE
 ret
ENDP
eqstr: PROC
;-78     while(*p) {
;
 ENTER  0,0
.eqstr11:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr12
;-79         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr13
 mov ax, 0
 jmp .retneqstr
;-80             p++;

.eqstr13:
 inc  word[bp+4]
;-81             q++;

 inc  word[bp+6]
;-82         }

;-83     if(*q) return 0;

 jmp .eqstr11
.eqstr12:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr14
 mov ax, 0
 jmp .retneqstr
;-84     return 1;

.eqstr14:
 mov ax, 1
 jmp .retneqstr
;-85 }

;-86 int toupper(char *s) {

 .retneqstr: LEAVE
 ret
ENDP
toupper: PROC
;-87     while(*s) {
;
 ENTER  0,0
.toupper15:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper16
;-88         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  .toupper17
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  .toupper18
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
;-89             s++;

.toupper18:
.toupper17:
 inc  word[bp+4]
;-90     }

;-91 }

 jmp .toupper15
.toupper16:
;-92 int head1(char *s) {
 LEAVE
 ret
ENDP
head1: PROC
;-93     while(*s >= 'A') s++;     
;
 ENTER  0,0
.head119:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 65 ;unsigned : 1
 jl  .head120
 inc  word[bp+4]
;-94     *s=0; 

 jmp .head119
.head120:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-95 }

;-96 

;-97 

;-98 int Prompt1(unsigned char *s) {
 LEAVE
 ret
ENDP
Prompt1: PROC
;-99     char c; 

;-100     unsigned char *starts;

;-101     starts=s;  
;
 ENTER  4,0
 mov ax, [bp+4]
 mov [bp-4], ax
;-102     do { 

.Prompt121:
;-103         c=GetKey();  

 call GetKey
 mov [bp-2], al
;-104         if (c == 27)    exitR(1);

 mov al, [bp-2]
 cmp al, 27
 jne .Prompt122
 push 1
 call exitR
 add  sp, 2
;-105         if (c==8) {

.Prompt122:
 mov al, [bp-2]
 cmp al, 8
 jne .Prompt123
;-106             if (s > starts){

 mov ax, [bp+4]
 cmp ax, [bp-4]
 jle .Prompt124
;-107                 s--;

 dec  word[bp+4]
;-108                 putch(8);

 push 8
 call putch
 add  sp, 2
;-109                 putch(' ');

 push 32
 call putch
 add  sp, 2
;-110                 putch(8);

 push 8
 call putch
 add  sp, 2
;-111                 }

;-112                 else putch(7);

 jmp .Prompt125
.Prompt124:
 push 7
 call putch
 add  sp, 2
;-113             }

.Prompt125:
;-114             else { 

 jmp .Prompt126
.Prompt123:
;-115                 *s=c; 

 mov al, [bp-2]
 mov  bx, [bp+4]
 mov  [bx], al
;-116                 s++; 

 inc  word[bp+4]
;-117                 putch(c); 

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-118             }

;-119     } while(c!=13); 

.Prompt126:
 mov al, [bp-2]
 cmp al, 13
 je  .Prompt127
 jmp .Prompt121
.Prompt127:
;-120     s--;  

 dec  word[bp+4]
;-121     *s=0; 

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-122 }

;-123 

;-124 char Info1[]=" commands: help,exit,cls";
 LEAVE
 ret
ENDP
Info1 db " commands: help,exit,cls",0
;-125 //char Info1[]="CMD commands: cls,dir,dos,exit,type,mem,dump,help";

;-126 char Info2[]="exec,fn,down,co,unreal,un,test,  *.COM ";

Info2 db "exec,fn,down,co,unreal,un,test,  *.COM ",0
;-127 

;-128 int dohelp() { 

dohelp: PROC
;-129     unsigned int i;   

;-130     cputs(Version1);
;
 ENTER  2,0
 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2
;-131 //    rdump();

;-132     cputs(Info1);   putch(10); 

 lea  ax, [Info1]
 push ax
 call cputs
 add  sp, 2
 push 10
 call putch
 add  sp, 2
;-133 //    cputs(Info2);

;-134 }

;-135 

;-136 int intrinsic(char *t) {  
 LEAVE
 ret
ENDP
intrinsic: PROC
;-137     char s[81];  

;-138     char c; int i;

;-139     DOS_ERR=0;    
;
 ENTER  85,0
 mov ax, 0
 mov word [DOS_ERR], ax
;-140     while (*t == ' ') t++;

.intrinsic28:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .intrinsic29
 inc  word[bp+4]
;-141     strcpy(s, t); 

 jmp .intrinsic28
.intrinsic29:
 push word [bp+4]
 lea  ax, [bp-81]
 push ax
 call strcpy
 add  sp, 4
;-142     toupper(s);   

 lea  ax, [bp-81]
 push ax
 call toupper
 add  sp, 2
;-143     head1(s);

 lea  ax, [bp-81]
 push ax
 call head1
 add  sp, 2
;-144     if(eqstr(s,"HELP")){dohelp();return;}

 push intrinsic_0
 lea  ax, [bp-81]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic30
 call dohelp
 jmp .retnintrinsic
;-145     if(eqstr(s,"EXIT"))exitR(0);

.intrinsic30:
 push intrinsic_1
 lea  ax, [bp-81]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic31
 push 0
 call exitR
 add  sp, 2
;-146     if(eqstr(s,"CLS" )){clrscr();return;}

.intrinsic31:
 push intrinsic_2
 lea  ax, [bp-81]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic32
 call clrscr
 jmp .retnintrinsic
;-147 //    if(eqstr(s,"DIR" )){dir1();return;}

;-148 //    if(eqstr(s,"DOS" )){dodos(); return;}

;-149 //    if(eqstr(s,"TYPE")){dotype();return;}

;-150 //    if(eqstr(s,"MEM" )){domem(); return;}

;-151 //    if(eqstr(s,"DUMP")){dodump();return;}

;-152 //    if(eqstr(s,"EXEC")){exec1 ();return;}

;-153 //    if(eqstr(s,"FN"  )){doFN();  return;}

;-154 //    if(eqstr(s,"DOWN")){dodown();return;}

;-155 //    if(eqstr(s,"CO"  )){doco();  return;}

;-156 //    if(eqstr(s,"UNREAL")){dounreal();  return;}

;-157 //    if(eqstr(s,"UN")){doun();  return;}  

;-158 //    if(eqstr(s,"TEST")){test();  return;}

;-159 //    extrinsic(inp_buf);

;-160 }

.intrinsic32:
;-161 

;-162 

;-163 int get_cmd(char *s){

 .retnintrinsic: LEAVE
 ret
intrinsic_0 db "HELP",0
intrinsic_1 db "EXIT",0
intrinsic_2 db "CLS",0
ENDP
get_cmd: PROC
;-164     inp_buf=0;
;
 ENTER  0,0
 mov ax, 0
 mov byte [inp_buf], al
;-165     DOS_ERR=0;

 mov ax, 0
 mov word [DOS_ERR], ax
;-166     putch(':');

 push 58
 call putch
 add  sp, 2
;-167     Prompt1(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call Prompt1
 add  sp, 2
;-168     putch(10);

 push 10
 call putch
 add  sp, 2
;-169 }

;-170 

;-171 int main() {
 LEAVE
 ret
ENDP
main: PROC
;-172     dohelp();

 call dohelp
;-173     do { 

.main33:
;-174         get_cmd(inp_buf); 

 lea  ax, [inp_buf]
 push ax
 call get_cmd
 add  sp, 2
;-175         intrinsic(inp_buf); 

 lea  ax, [inp_buf]
 push ax
 call intrinsic
 add  sp, 2
;-176         } 

;-177     while(1);

 mov ax, 1
 or  al, al
 je .main34
 jmp .main33
.main34:
;-178 }

 ret
ENDP
;Glob. variables:5 (200), Functions:27 (300), Lines:179
;Constant: 74 (3000), stacksize: 40555