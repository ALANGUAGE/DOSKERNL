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
;-57 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
ENDP
fputcR: PROC;
 ENTER  0,0
lea dx, [bp+4]
;-58   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt
;-59 

;-60 

;-61 int prunsign(unsigned int n) { 
 LEAVE
 ret
ENDP
prunsign: PROC
;-62     unsigned int e;

;-63     if (n >= 10) { 
;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .prunsign5
;-64         e=n/10; 

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-65         prunsign(e); 

 push word [bp-2]
 call prunsign
 add  sp, 2
;-66         } 

;-67     n=n%10; 

.prunsign5:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-68     n+='0'; 

 add  word[bp+4], 48
;-69     putch(n); 

 push word [bp+4]
 call putch
 add  sp, 2
;-70 }

;-71 

;-72 int letter(char c) {
 LEAVE
 ret
ENDP
letter: PROC
;-73   if (c> 'z') return 0;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 122
 jle .letter6
 mov ax, 0
 jmp .retnletter
;-74   if (c< 'A') return 0;

.letter6:
 mov al, [bp+4]
 cmp al, 65
 jge .letter7
 mov ax, 0
 jmp .retnletter
;-75   if (c> 'Z') { if (c< 'a') return 0; }

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
;-76   return 1;

.letter8:
 mov ax, 1
 jmp .retnletter
;-77 }

;-78 int digit(char c){

 .retnletter: LEAVE
 ret
ENDP
digit: PROC
;-79     if(c<'0') return 0;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit10
 mov ax, 0
 jmp .retndigit
;-80     if(c>'9') return 0;

.digit10:
 mov al, [bp+4]
 cmp al, 57
 jle .digit11
 mov ax, 0
 jmp .retndigit
;-81     return 1;

.digit11:
 mov ax, 1
 jmp .retndigit
;-82 }

;-83 int strcpy(char *s, char *t) {

 .retndigit: LEAVE
 ret
ENDP
strcpy: PROC
;-84     do { *s=*t; s++; t++; }
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
;-85     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy13
 jmp .strcpy12
.strcpy13:
;-86     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-87     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-88 }

;-89 int eqstr(char *p, char *q) {

 .retnstrcpy: LEAVE
 ret
ENDP
eqstr: PROC
;-90     while(*p) {
;
 ENTER  0,0
.eqstr14:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr15
;-91         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr16
 mov ax, 0
 jmp .retneqstr
;-92             p++;

.eqstr16:
 inc  word[bp+4]
;-93             q++;

 inc  word[bp+6]
;-94         }

;-95     if(*q) return 0;

 jmp .eqstr14
.eqstr15:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr17
 mov ax, 0
 jmp .retneqstr
;-96     return 1;

.eqstr17:
 mov ax, 1
 jmp .retneqstr
;-97 }

;-98 int toupper(char *s) {

 .retneqstr: LEAVE
 ret
ENDP
toupper: PROC
;-99     while(*s) {
;
 ENTER  0,0
.toupper18:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper19
;-100         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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
;-101             s++;

.toupper21:
.toupper20:
 inc  word[bp+4]
;-102     }

;-103 }

 jmp .toupper18
.toupper19:
;-104 

;-105 int dotype() {
 LEAVE
 ret
ENDP
dotype: PROC
;-106     int fdin; int i;

;-107     fdin=openR(par2);
;
 ENTER  4,0
 push word [par2]
 call openR
 add  sp, 2
 mov [bp-2], ax
;-108     if (DOS_ERR) {

 mov ax, [DOS_ERR]
 or  al, al
 je .dotype22
;-109         putch(10); 

 push 10
 call putch
 add  sp, 2
;-110         cputs("file missing: "); 

 push dotype_0
 call cputs
 add  sp, 2
;-111         cputs(par2); 

 push word [par2]
 call cputs
 add  sp, 2
;-112         return;

 jmp .retndotype
;-113         }

;-114     do {

.dotype22:
.dotype23:
;-115         DOS_NoBytes=readR(&DOS_ByteRead, fdin);

 push word [bp-2]
 lea  ax, [DOS_ByteRead]
 push ax
 call readR
 add  sp, 4
 mov word [DOS_NoBytes], ax
;-116         putch(DOS_ByteRead); 

 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-117         } 

;-118         while (DOS_NoBytes);

 mov ax, [DOS_NoBytes]
 or  al, al
 je .dotype24
 jmp .dotype23
.dotype24:
;-119     fcloseR(fdin);

 push word [bp-2]
 call fcloseR
 add  sp, 2
;-120 }

;-121 

;-122 int Prompt1(unsigned char *s) {

 .retndotype: LEAVE
 ret
dotype_0 db "file missing: ",0
ENDP
Prompt1: PROC
;-123     char c; 

;-124     unsigned char *startstr;

;-125     startstr=s;  
;
 ENTER  4,0
 mov ax, [bp+4]
 mov [bp-4], ax
;-126     do { 

.Prompt125:
;-127         c=GetKey();  

 call GetKey
 mov [bp-2], al
;-128         if (c == 27)    exitR(1);//good bye

 mov al, [bp-2]
 cmp al, 27
 jne .Prompt126
 push 1
 call exitR
 add  sp, 2
;-129         if (c==8) {

.Prompt126:
 mov al, [bp-2]
 cmp al, 8
 jne .Prompt127
;-130             if (s > startstr){

 mov ax, [bp+4]
 cmp ax, [bp-4]
 jle .Prompt128
;-131                 s--;

 dec  word[bp+4]
;-132                 putch(8);

 push 8
 call putch
 add  sp, 2
;-133                 putch(' ');

 push 32
 call putch
 add  sp, 2
;-134                 putch(8);

 push 8
 call putch
 add  sp, 2
;-135                 }

;-136                 else putch(7);

 jmp .Prompt129
.Prompt128:
 push 7
 call putch
 add  sp, 2
;-137             }

.Prompt129:
;-138             else { 

 jmp .Prompt130
.Prompt127:
;-139                 *s=c; 

 mov al, [bp-2]
 mov  bx, [bp+4]
 mov  [bx], al
;-140                 s++; 

 inc  word[bp+4]
;-141                 putch(c); 

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-142             }

;-143     } while(c!=13); 

.Prompt130:
 mov al, [bp-2]
 cmp al, 13
 je  .Prompt131
 jmp .Prompt125
.Prompt131:
;-144     s--;  

 dec  word[bp+4]
;-145     *s=0; 

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-146 }

;-147 

;-148 char Info1[]=" commands: help,exit,cls,type";
 LEAVE
 ret
ENDP
Info1 db " commands: help,exit,cls,type",0
;-149 //char Info1[]="dir,dos,mem,dump";

;-150 char Info2[]="exec,fn,down,co,unreal,un,test,  *.COM ";

Info2 db "exec,fn,down,co,unreal,un,test,  *.COM ",0
;-151 

;-152 int dohelp() { 

dohelp: PROC
;-153     unsigned int i;   

;-154     cputs(Version1);
;
 ENTER  2,0
 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2
;-155 //    rdump();

;-156     cputs(Info1);   putch(10); 

 lea  ax, [Info1]
 push ax
 call cputs
 add  sp, 2
 push 10
 call putch
 add  sp, 2
;-157 //    cputs(Info2);

;-158 }

;-159 

;-160 int getpar(char *t) {    
 LEAVE
 ret
ENDP
getpar: PROC
;-161     while (*t == 32) t++; 
;
 ENTER  0,0
.getpar32:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar33
 inc  word[bp+4]
;-162     if (*t<=13) return 0;

 jmp .getpar32
.getpar33:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar34
 mov ax, 0
 jmp .retngetpar
;-163         

;-164     par1=t; 

.getpar34:
 mov ax, [bp+4]
 mov word [par1], ax
;-165     while(*t >= 33) t++; 

.getpar35:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar36
 inc  word[bp+4]
;-166     if (*t==0) return 1;

 jmp .getpar35
.getpar36:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar37
 mov ax, 1
 jmp .retngetpar
;-167     *t=0; 

.getpar37:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-168     t++;

 inc  word[bp+4]
;-169     while (*t == 32) t++; 

.getpar38:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar39
 inc  word[bp+4]
;-170     if (*t<=13) return 1;

 jmp .getpar38
.getpar39:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar40
 mov ax, 1
 jmp .retngetpar
;-171         

;-172     par2=t; 

.getpar40:
 mov ax, [bp+4]
 mov word [par2], ax
;-173     while(*t >= 33) t++; 

.getpar41:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar42
 inc  word[bp+4]
;-174     if (*t==0) return 2;

 jmp .getpar41
.getpar42:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .getpar43
 mov ax, 2
 jmp .retngetpar
;-175     *t=0; 

.getpar43:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-176     t++;    

 inc  word[bp+4]
;-177     while (*t == 32) t++; 

.getpar44:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .getpar45
 inc  word[bp+4]
;-178     if (*t<=13) return 2;

 jmp .getpar44
.getpar45:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 13
 jg  .getpar46
 mov ax, 2
 jmp .retngetpar
;-179          

;-180     par3=t;     

.getpar46:
 mov ax, [bp+4]
 mov word [par3], ax
;-181     while(*t >= 33) t++; 

.getpar47:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 33 ;unsigned : 1
 jl  .getpar48
 inc  word[bp+4]
;-182     *t=0;     

 jmp .getpar47
.getpar48:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-183     return 3;    

 mov ax, 3
 jmp .retngetpar
;-184 }

;-185 

;-186 int intrinsic() {

 .retngetpar: LEAVE
 ret
ENDP
intrinsic: PROC
;-187     toupper(par1);      

 push word [par1]
 call toupper
 add  sp, 2
;-188     if(eqstr(par1,"HELP")){dohelp();return;}

 push intrinsic_0
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic49
 call dohelp
 jmp .retnintrinsic
;-189     if(eqstr(par1,"EXIT"))exitR(0);

.intrinsic49:
 push intrinsic_1
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic50
 push 0
 call exitR
 add  sp, 2
;-190     if(eqstr(par1,"CLS" )){clrscr();return;}

.intrinsic50:
 push intrinsic_2
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic51
 call clrscr
 jmp .retnintrinsic
;-191     if(eqstr(par1,"TYPE")){dotype();return;}

.intrinsic51:
 push intrinsic_3
 push word [par1]
 call eqstr
 add  sp, 4
 or  al, al
 je .intrinsic52
 call dotype
 jmp .retnintrinsic
;-192 //    if(eqstr(s,"DIR" )){dir1();return;}

;-193 //    if(eqstr(s,"DOS" )){dodos(); return;}

;-194 //    if(eqstr(s,"MEM" )){domem(); return;}

;-195 //    if(eqstr(s,"DUMP")){dodump();return;}

;-196 //    if(eqstr(s,"EXEC")){exec1 ();return;}

;-197 //    if(eqstr(s,"FN"  )){doFN();  return;}

;-198 //    if(eqstr(s,"DOWN")){dodown();return;}

;-199 //    if(eqstr(s,"CO"  )){doco();  return;}

;-200 //    if(eqstr(s,"UNREAL")){dounreal();  return;}

;-201 //    if(eqstr(s,"UN")){doun();  return;}  

;-202 //    if(eqstr(s,"TEST")){test();  return;}

;-203 //    extrinsic(inp_buf);

;-204 }

.intrinsic52:
;-205 

;-206 

;-207 int get_cmd(){

 .retnintrinsic:
 ret
intrinsic_0 db "HELP",0
intrinsic_1 db "EXIT",0
intrinsic_2 db "CLS",0
intrinsic_3 db "TYPE",0
ENDP
get_cmd: PROC
;-208     *inp_buf=0;

 mov ax, 0
 mov  bx, [inp_buf]
 mov  [bx], al
;-209     DOS_ERR=0;

 mov ax, 0
 mov word [DOS_ERR], ax
;-210     putch(':');

 push 58
 call putch
 add  sp, 2
;-211     Prompt1(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call Prompt1
 add  sp, 2
;-212     putch(10);

 push 10
 call putch
 add  sp, 2
;-213 }

;-214 

;-215 int main() {

 ret
ENDP
main: PROC
;-216     dohelp();

 call dohelp
;-217     do { 

.main53:
;-218         get_cmd(); 

 call get_cmd
;-219         par_count=getpar(inp_buf);

 lea  ax, [inp_buf]
 push ax
 call getpar
 add  sp, 2
 mov byte [par_count], al
;-220         intrinsic(); 

 call intrinsic
;-221         } 

;-222     while(1);

 mov ax, 1
 or  al, al
 je .main54
 jmp .main53
.main54:
;-223 }

 ret
ENDP
;Glob. variables:11 (200), Functions:30 (300), Lines:224
;Constant: 99 (3000), stacksize: 40555