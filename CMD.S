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
;-9         

;-10         

;-11 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }

writetty: PROC
 mov  ah, 14
 mov  bx, 0
 db 205,16
;-12 int putch(char c)  {if (c==10) {al=13; writetty();} al=c; writetty(); }

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
;-13 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
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
;-14 

;-15 int gotoxy (char x, char y) {
 LEAVE
 ret
ENDP
gotoxy: PROC
;-16     ah=2; 
;
 ENTER  0,0
 mov  ah, 2
;-17     bx=0; 

 mov  bx, 0
;-18     dh=y; 

 mov  dh, [bp+6]
;-19     dl=x; 

 mov  dl, [bp+4]
;-20     __emit__(0xCD,0x10); 

 db 205,16
;-21 }

;-22 int clrscr()    {
 LEAVE
 ret
ENDP
clrscr: PROC
;-23     ax=0x0600; 

 mov  ax, 1536
;-24     bh=7; 

 mov  bh, 7
;-25     cx=0; 

 mov  cx, 0
;-26     dx=0x184F; 

 mov  dx, 6223
;-27     __emit__(0xCD,0x10); 

 db 205,16
;-28     gotoxy(0,0);

 push 0
 push 0
 call gotoxy
 add  sp, 4
;-29 }

;-30 

;-31 

;-32 int getch()  { ah=0x10; __emit__(0xCD,0x16); }

 ret
ENDP
getch: PROC
 mov  ah, 16
 db 205,22
;-33 int waitkey(){ ah=0x11; __emit__(0xCD,0x10); __emit__(0x74,0xFA); }

 ret
ENDP
waitkey: PROC
 mov  ah, 17
 db 205,16
 db 116,250
;-34 int GetKey() {

 ret
ENDP
GetKey: PROC
;-35     int i; 

;-36     waitkey();
;
 ENTER  2,0
 call waitkey
;-37     i=getch() & 255; 

 call getch
 and ax, 255
 mov [bp-2], ax
;-38     if(i==0)i=getch()+256; 

 mov ax, [bp-2]
 cmp ax, 0
 jne .GetKey4
 call getch
 add ax, 256
 mov [bp-2], ax
;-39         ax=i;

.GetKey4:
 mov  ax, [bp-2]
;-40 }

;-41 int getche() { GetKey(); writetty();}
 LEAVE
 ret
ENDP
getche: PROC
 call GetKey
 call writetty
;-42 

;-43 int DosInt() {

 ret
ENDP
DosInt: PROC
;-44     __emit__(0xCD,0x21);//int 0x21;

 db 205,33
;-45     __emit__(0x73, 04); //ifcarry DOS_ERR++;

 db 115,4
;-46     DOS_ERR++;

 inc  word[DOS_ERR]
;-47 }

;-48 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }

 ret
ENDP
openR: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt
;-49 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
ENDP
creatR: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt
;-50 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
 LEAVE
 ret
ENDP
fcloseR: PROC;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 call DosInt
;-51 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
 LEAVE
 ret
ENDP
exitR: PROC;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 call DosInt
;-52 int readRL(char *s, int fd, int len){
 LEAVE
 ret
ENDP
readRL: PROC
;-53     dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt
;-54 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
ENDP
fputcR: PROC;
 ENTER  0,0
lea dx, [bp+4]
;-55   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt
;-56 

;-57 

;-58 int prunsign(unsigned int n) { 
 LEAVE
 ret
ENDP
prunsign: PROC
;-59     unsigned int e;

;-60     if (n >= 10) { 
;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .prunsign5
;-61         e=n/10; 

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-62         prunsign(e); 

 push word [bp-2]
 call prunsign
 add  sp, 2
;-63         } 

;-64     n=n%10; 

.prunsign5:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-65     n+='0'; 

 add  word[bp+4], 48
;-66     putch(n); 

 push word [bp+4]
 call putch
 add  sp, 2
;-67 }

;-68 

;-69 int letter(char c) {
 LEAVE
 ret
ENDP
letter: PROC
;-70   if (c> 'z') return 0;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 122
 jle .letter6
 mov ax, 0
 jmp .retnletter
;-71   if (c< 'A') return 0;

.letter6:
 mov al, [bp+4]
 cmp al, 65
 jge .letter7
 mov ax, 0
 jmp .retnletter
;-72   if (c> 'Z') { if (c< 'a') return 0; }

.letter7:
 mov al, [bp+4]
 cmp al, 90
 jle .letter8
 mov al, [bp+4]
 cmp al, 97
 jge .letter9
 mov ax, 0
 jmp .retnletter
.letter9:
;-73   return 1;

.letter8:
 mov ax, 1
 jmp .retnletter
;-74 }

;-75 int digit(char c){

 .retnletter: LEAVE
 ret
ENDP
digit: PROC
;-76     if(c<'0') return 0;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit10
 mov ax, 0
 jmp .retndigit
;-77     if(c>'9') return 0;

.digit10:
 mov al, [bp+4]
 cmp al, 57
 jle .digit11
 mov ax, 0
 jmp .retndigit
;-78     return 1;

.digit11:
 mov ax, 1
 jmp .retndigit
;-79 }

;-80 int strcpy(char *s, char *t) {

 .retndigit: LEAVE
 ret
ENDP
strcpy: PROC
;-81     do { *s=*t; s++; t++; }
;
 ENTER  0,0
.strcpy12:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-82     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy13
 jmp .strcpy12
.strcpy13:
;-83     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-84     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-85 }

;-86 int eqstr(char *p, char *q) {

 .retnstrcpy: LEAVE
 ret
ENDP
eqstr: PROC
;-87     while(*p) {
;
 ENTER  0,0
.eqstr14:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr15
;-88         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr16
 mov ax, 0
 jmp .retneqstr
;-89             p++;

.eqstr16:
 inc  word[bp+4]
;-90             q++;

 inc  word[bp+6]
;-91         }

;-92     if(*q) return 0;

 jmp .eqstr14
.eqstr15:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr17
 mov ax, 0
 jmp .retneqstr
;-93     return 1;

.eqstr17:
 mov ax, 1
 jmp .retneqstr
;-94 }

;-95 int toupper(char *s) {

 .retneqstr: LEAVE
 ret
ENDP
toupper: PROC
;-96     while(*s) {
;
 ENTER  0,0
.toupper18:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper19
;-97         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  .toupper20
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  .toupper21
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
;-98             s++;

.toupper21:
.toupper20:
 inc  word[bp+4]
;-99     }

;-100 }

 jmp .toupper18
.toupper19:
;-101 

;-102 

;-103 int Prompt1(unsigned char *s) {
 LEAVE
 ret
ENDP
Prompt1: PROC
;-104     char c; 

;-105     unsigned char *startstr;

;-106     startstr=s;  
;
 ENTER  4,0
 mov ax, [bp+4]
 mov [bp-4], ax
;-107     do { 

.Prompt122:
;-108         c=GetKey();  

 call GetKey
 mov [bp-2], al
;-109         if (c == 27)    exitR(1);//good bye

 mov al, [bp-2]
 cmp al, 27
 jne .Prompt123
 push 1
 call exitR
 add  sp, 2
;-110         if (c==8) {

.Prompt123:
 mov al, [bp-2]
 cmp al, 8
 jne .Prompt124
;-111             if (s > startstr){

 mov ax, [bp+4]
 cmp ax, [bp-4]
 jle .Prompt125
;-112                 s--;

 dec  word[bp+4]
;-113                 putch(8);

 push 8
 call putch
 add  sp, 2
;-114                 putch(' ');

 push 32
 call putch
 add  sp, 2
;-115                 putch(8);

 push 8
 call putch
 add  sp, 2
;-116                 }

;-117                 else putch(7);

 jmp .Prompt126
.Prompt125:
 push 7
 call putch
 add  sp, 2
;-118             }

.Prompt126:
;-119             else { 

 jmp .Prompt127
.Prompt124:
;-120                 *s=c; 

 mov al, [bp-2]
 mov  bx, [bp+4]
 mov  [bx], al
;-121                 s++; 

 inc  word[bp+4]
;-122                 putch(c); 

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-123             }

;-124     } while(c!=13); 

.Prompt127:
 mov al, [bp-2]
 cmp al, 13
 je  .Prompt128
 jmp .Prompt122
.Prompt128:
;-125     s--;  

 dec  word[bp+4]
;-126     *s=0; 

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-127 }

;-128 

;-129 char Info1[]=" commands: help,exit,cls";
 LEAVE
 ret
ENDP
Info1 db " commands: help,exit,cls",0
;-130 //char Info1[]="CMD commands: cls,dir,dos,exit,type,mem,dump,help";

;-131 char Info2[]="exec,fn,down,co,unreal,un,test,  *.COM ";

Info2 db "exec,fn,down,co,unreal,un,test,  *.COM ",0
;-132 

;-133 int dohelp() { 

dohelp: PROC
;-134     unsigned int i;   

;-135     cputs(Version1);
;
 ENTER  2,0
 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2
;-136 //    rdump();

;-137     cputs(Info1);   putch(10); 

 lea  ax, [Info1]
 push ax
 call cputs
 add  sp, 2
 push 10
 call putch
 add  sp, 2
;-138 //    cputs(Info2);

;-139 }

;-140 int isspace(char c) {
 LEAVE
 ret
ENDP
isspace: PROC
;-141   if (c==32) return 1;//space
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 32
 jne .isspace29
 mov ax, 1
 jmp .retnisspace
;-142   if (c>=9) { if (c<=13) return 1; }

.isspace29:
 mov al, [bp+4]
 cmp al, 9 ;unsigned : 1
 jl  .isspace30
 mov al, [bp+4]
 cmp al, 13
 jg  .isspace31
 mov ax, 1
 jmp .retnisspace
.isspace31:
;-143   return 0;

.isspace30:
 mov ax, 0
 jmp .retnisspace
;-144 }

;-145 int isSpaceNullStr(char *s) {

 .retnisspace: LEAVE
 ret
ENDP
isSpaceNullStr: PROC
;-146   if (*s==32) return 1;//space
;
 ENTER  0,0
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .isSpaceNullStr32
 mov ax, 1
 jmp .retnisSpaceNullStr
;-147   if (*s>=9) { if (*s<=13) return 1; }

.isSpaceNullStr32:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9 ;unsigned : 1
 jl  .isSpaceNullStr33
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .isSpaceNullStr34
 mov ax, 1
 jmp .retnisSpaceNullStr
.isSpaceNullStr34:
;-148   if (*s==0) return 1;

.isSpaceNullStr33:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .isSpaceNullStr35
 mov ax, 1
 jmp .retnisSpaceNullStr
;-149   return 0;

.isSpaceNullStr35:
 mov ax, 0
 jmp .retnisSpaceNullStr
;-150 }

;-151 int isin(char *s, char c) { 

 .retnisSpaceNullStr: LEAVE
 ret
ENDP
isin: PROC
;-152     while(*s) { 
;
 ENTER  0,0
.isin36:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .isin37
;-153         if (*s==c) return s; 

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .isin38
 mov ax, [bp+4]
 jmp .retnisin
;-154             s++;

.isin38:
 inc  word[bp+4]
;-155         }  

;-156     return 0;

 jmp .isin36
.isin37:
 mov ax, 0
 jmp .retnisin
;-157 }

;-158 int head1(char *s) {

 .retnisin: LEAVE
 ret
ENDP
head1: PROC
;-159     while(*s >= 33) s++;     
;
 ENTER  0,0
.head139:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .head140
 inc  word[bp+4]
;-160     *s=0; 

 jmp .head139
.head140:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-161 }

;-162 

;-163 int removespace(char *s) {
 LEAVE
 ret
ENDP
removespace: PROC
;-164     char c;

;-165     c= *s;
;
 ENTER  2,0
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-166     while (isspace(c)) {

.removespace41:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call isspace
 add  sp, 2
 or  al, al
 je .removespace42
;-167         s++;

 inc  word[bp+4]
;-168         c= *s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-169     }

;-170 }

 jmp .removespace41
.removespace42:
;-171 

;-172 int getpar(char *t) {    
 LEAVE
 ret
ENDP
getpar: PROC
;-173     while (*t == 32) t++;     
;
 ENTER  0,0
.getpar43:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar44
 inc  word[bp+4]
;-174     if (*t<=13) return 0;

 jmp .getpar43
.getpar44:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar45
 mov ax, 0
 jmp .retngetpar
;-175         

;-176     par1=t; 

.getpar45:
 mov ax, [bp+4]
 mov word [par1], ax
;-177     while(*t >= 33) t++; 

.getpar46:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar47
 inc  word[bp+4]
;-178     if (*t==0) return 1;

 jmp .getpar46
.getpar47:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar48
 mov ax, 1
 jmp .retngetpar
;-179     *t=0; 

.getpar48:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-180     t++;

 inc  word[bp+4]
;-181     while (*t == 32) t++; 

.getpar49:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar50
 inc  word[bp+4]
;-182     if (*t<=13) return 1;

 jmp .getpar49
.getpar50:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar51
 mov ax, 1
 jmp .retngetpar
;-183         

;-184     par2=t; 

.getpar51:
 mov ax, [bp+4]
 mov word [par2], ax
;-185     while(*t >= 33) t++; 

.getpar52:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar53
 inc  word[bp+4]
;-186     if (*t==0) return 2;

 jmp .getpar52
.getpar53:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar54
 mov ax, 2
 jmp .retngetpar
;-187     *t=0; 

.getpar54:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-188     t++;    

 inc  word[bp+4]
;-189     while (*t == 32) t++; 

.getpar55:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar56
 inc  word[bp+4]
;-190     if (*t<=13) return 2;

 jmp .getpar55
.getpar56:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar57
 mov ax, 2
 jmp .retngetpar
;-191          

;-192     par3=t;     

.getpar57:
 mov ax, [bp+4]
 mov word [par3], ax
;-193     while(*t >= 33) t++; 

.getpar58:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar59
 inc  word[bp+4]
;-194     *t=0;     

 jmp .getpar58
.getpar59:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-195     return 3;    

 mov ax, 3
 jmp .retngetpar
;-196 }

;-197 

;-198 int intrinsic() {

 .retngetpar: LEAVE
 ret
ENDP
intrinsic: PROC
;-199     toupper(par1);      

 push word [par1]
 call toupper
 add  sp, 2
;-200     if(eqstr(par1,"HELP")){dohelp();return;}

 push intrinsic_0
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic60
 call dohelp
 jmp .retnintrinsic
;-201     if(eqstr(par1,"EXIT"))exitR(0);

.intrinsic60:
 push intrinsic_1
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic61
 push 0
 call exitR
 add  sp, 2
;-202     if(eqstr(par1,"CLS" )){clrscr();return;}

.intrinsic61:
 push intrinsic_2
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic62
 call clrscr
 jmp .retnintrinsic
;-203 //    if(eqstr(s,"DIR" )){dir1();return;}

;-204 //    if(eqstr(s,"DOS" )){dodos(); return;}

;-205 //    if(eqstr(s,"TYPE")){dotype();return;}

;-206 //    if(eqstr(s,"MEM" )){domem(); return;}

;-207 //    if(eqstr(s,"DUMP")){dodump();return;}

;-208 //    if(eqstr(s,"EXEC")){exec1 ();return;}

;-209 //    if(eqstr(s,"FN"  )){doFN();  return;}

;-210 //    if(eqstr(s,"DOWN")){dodown();return;}

;-211 //    if(eqstr(s,"CO"  )){doco();  return;}

;-212 //    if(eqstr(s,"UNREAL")){dounreal();  return;}

;-213 //    if(eqstr(s,"UN")){doun();  return;}  

;-214 //    if(eqstr(s,"TEST")){test();  return;}

;-215 //    extrinsic(inp_buf);

;-216 }

.intrinsic62:
;-217 

;-218 

;-219 int get_cmd(){

 .retnintrinsic:
 ret
intrinsic_0 db "HELP",0
intrinsic_1 db "EXIT",0
intrinsic_2 db "CLS",0
ENDP
get_cmd: PROC
;-220     *inp_buf=0;

 mov ax, 0
 mov  bx, [inp_buf]
 mov  [bx], al
;-221     DOS_ERR=0;

 mov ax, 0
 mov word [DOS_ERR], ax
;-222     putch(':');

 push 58
 call putch
 add  sp, 2
;-223     Prompt1(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call Prompt1
 add  sp, 2
;-224     putch(10);

 push 10
 call putch
 add  sp, 2
;-225 }

;-226 

;-227 int main() {

 ret
ENDP
main: PROC
;-228     dohelp();

 call dohelp
;-229     do { 

.main63:
;-230         get_cmd(); 

 call get_cmd
;-231         par_count=getpar(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call getpar
 add  sp, 2
 mov byte [par_count], al
;-232 cputs(" count: ");

 push main_0
 call cputs
 add  sp, 2
;-233 prunsign(par_count); 

 mov al, byte [par_count]
 mov ah, 0
 push ax
 call prunsign
 add  sp, 2
;-234 cputs(" par1:");

 push main_1
 call cputs
 add  sp, 2
;-235 cputs(par1);

 push word [par1]
 call cputs
 add  sp, 2
;-236 cputs(" par2:");

 push main_2
 call cputs
 add  sp, 2
;-237 cputs(par2);

 push word [par2]
 call cputs
 add  sp, 2
;-238 cputs(" par3:");

 push main_3
 call cputs
 add  sp, 2
;-239 cputs(par3);

 push word [par3]
 call cputs
 add  sp, 2
;-240         intrinsic(); 

 call intrinsic
;-241         } 

;-242     while(1);

 mov ax, 1
 or  al, al
 je .main64
 jmp .main63
.main64:
;-243 }

 ret
main_0 db " count: ",0
main_1 db " par1:",0
main_2 db " par2:",0
main_3 db " par3:",0
ENDP
;Glob. variables:9 (200), Functions:33 (300), Lines:244
;Constant: 90 (3000), stacksize: 40555