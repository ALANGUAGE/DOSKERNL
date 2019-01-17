;PLA compiler A.COM V0.9.6, Input: KRNL.C, Output: KRNL.S
org  256 
jmp main
;-1 char Version1[]="KERNEL.COM V0.1b";

Version1 db "KERNEL.COM V0.1b",0
;-2 //--------------------------- Bios Routines I/O ---------------------

;-3 int writetty()     {//char in AL


writetty: PROC
;-4     ah=0x0E;

 mov  ah, 14
;-5     bx=0;     //page

 mov  bx, 0
;-6     inth 0x10;

 int  16
;-7 }

;-8 int putch(char c)  {

 ret
ENDP

putch: PROC
;-9     if (c==10)  {
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-10         al=13;

 mov  al, 13
;-11         writetty();

 call writetty
;-12     }

;-13     al=c;

.putch1:
 mov  al, [bp+4]
;-14     writetty();

 call writetty
;-15 }

;-16 int cputs(char *s) {//only with correct DS !!!

 LEAVE
 ret
ENDP

cputs: PROC
;-17     char c;

;-18     while(*s) {
;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-19         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-20         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-21         s++;

 inc  word[bp+4]
;-22     }

;-23 }

 jmp .cputs2
.cputs3:
;-24 

;-25 int printhex4(unsigned char c) {

 LEAVE
 ret
ENDP

printhex4: PROC
;-26     c += 48;
;
 ENTER  0,0
 add  byte[bp+4], 48
;-27     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex44
 add  byte[bp+4], 7
;-28     putch(c);

.printhex44:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-29 }

;-30 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-31     unsigned char nib;

;-32     nib = c >> 4; printhex4(nib);
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
;-33     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-34 }

;-35 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-36     unsigned int half;

;-37     half = i >>  8; printhex8(half);
;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-38     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-39 }

;-40 

;-41 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-42     unsigned int e;

;-43     if (n >= 10) {
;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign5
;-44         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-45         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-46         }

;-47     n=n%10;

.printunsign5:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-48     n+='0';

 add  word[bp+4], 48
;-49     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-50 }

;-51 

;-52 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-53     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-54     inth 0x16;//AH=Scan code, AL=char

 int  22
;-55 }

;-56 int waitkey() {

 ret
ENDP

waitkey: PROC
;-57     ah=0x11;//get kbd status

 mov  ah, 17
;-58     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-59     //zero flag: 0=IS char, 1=NO char

;-60     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-61 }

;-62 int getkey() {

 ret
ENDP

getkey: PROC
;-63     waitkey();

 call waitkey
;-64     getch();

 call getch
;-65     ah=0;//clear scan code

 mov  ah, 0
;-66     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-67     //put ext code in AX

;-68 }

.getkey6:
;-69 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-70     getkey();

 call getkey
;-71     writetty();

 call writetty
;-72 }

;-73 // ------------------------- Bios Functions -------------------------

;-74 int BCDtoChar(char BCD) { // converts 2 digit packed BCD

 ret
ENDP

BCDtoChar: PROC
;-75     char LowNibble;       // to Integer

;-76     LowNibble = BCD & 0xF;// save ones digit
;
 ENTER  2,0
 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
;-77     BCD >> 4;// extract tens digit, result in AX

 mov al, [bp+4]
 shr al, 4
;-78     asm push dx

 push dx
;-79     dl = 10;

 mov  dl, 10
;-80     asm mul dl; result in AX

 mul dl; result in AX
;-81     asm pop dx

 pop dx
;-82     al += LowNibble;

 add  al, [bp-2]
;-83     ah=0;//result is byte

 mov  ah, 0
;-84 }

;-85 //---------------------------- Kernel Data Area ---------------------

;-86 char KERNEL_ERR=0;

 LEAVE
 ret
ENDP
KERNEL_ERR db 0
;-87 unsigned int count18h=0;// counts all interrups calls

count18h dw 0
;-88 char cent;char year;char month;char day;

cent db 0
year db 0
month db 0
day db 0
;-89 char hour; char min; char sec;

hour db 0
min db 0
sec db 0
;-90 unsigned int mode_IOData=0x8280;

mode_IOData dw 33408
;-91 

;-92 //--------------------------- Kernel Routines -----------------------

;-93 int KernelInt() {


KernelInt: PROC
;-94     inth 0x18;

 int  24
;-95     __emit__(0x73, 04); //jnc over KERNEL_ERR++

 db 115,4
;-96     KERNEL_ERR++;

 inc  byte[KERNEL_ERR]
;-97 }

;-98 unsigned int VecOldOfs;

 ret
ENDP
VecOldOfs dw 0
;-99 unsigned int VecOldSeg;

VecOldSeg dw 0
;-100 

;-101 int GetIntVec(char c) {


GetIntVec: PROC
;-102     asm push es
;
 ENTER  0,0
 push es
;-103     al=c;

 mov  al, [bp+4]
;-104     ah=0x35;

 mov  ah, 53
;-105     KernelInt();

 call KernelInt
;-106     __emit__(0x2E);//CS override

 db 46
;-107     asm mov [VecOldOfs], bx

 mov [VecOldOfs], bx
;-108     __emit__(0x2E);//CS override

 db 46
;-109     asm mov [VecOldSeg], es

 mov [VecOldSeg], es
;-110     asm pop es

 pop es
;-111 }

;-112 

;-113 //--------------------------- Start of new Interrupt 18h ------------

;-114 int KERNEL_START() {

 LEAVE
 ret
ENDP

KERNEL_START: PROC
;-115     count18h++;

 inc  word[count18h]
;-116     asm sti; set interrupt enable

 sti; set interrupt enable
;-117 

;-118     if (ah==0x01) {//Read Keyboard and Echo

 cmp  ah, 1
 jne .KERNEL_START7
;-119         kbdEcho();

 call kbdEcho
;-120         asm iret

 iret
;-121     }

;-122     if (ah==0x02) {//Display Character

.KERNEL_START7:
 cmp  ah, 2
 jne .KERNEL_START8
;-123         al=dl;

 mov  al, dl
;-124         writetty();

 call writetty
;-125         asm iret

 iret
;-126     }

;-127     if (ah==0x06) {//Direct Console I/O

.KERNEL_START8:
 cmp  ah, 6
 jne .KERNEL_START9
;-128         if (dl == 0xFF) {// then read character

 cmp  dl, 255
 jne .KERNEL_START10
;-129             getch();

 call getch
;-130             asm iret

 iret
;-131         }

;-132         al=dl;           // else display character

.KERNEL_START10:
 mov  al, dl
;-133         writetty();

 call writetty
;-134         asm iret

 iret
;-135     }

;-136     if (ah==0x07) {//Direct Console Input

.KERNEL_START9:
 cmp  ah, 7
 jne .KERNEL_START11
;-137         getch();

 call getch
;-138         asm iret

 iret
;-139     }

;-140     if (ah==0x09) {//display string in DS:DX

.KERNEL_START11:
 cmp  ah, 9
 jne .KERNEL_START12
;-141         asm push si

 push si
;-142         si=dx;

 mov  si, dx
;-143         asm cld; clear direction, string up

 cld; clear direction, string up
;-144         asm lodsb; from DS:SI to AL

 lodsb; from DS:SI to AL
;-145         while (al != '$') {

.KERNEL_START13:
 cmp  al, 36
 je  .KERNEL_START14
;-146             writetty();

 call writetty
;-147             asm lodsb

 lodsb
;-148         }

;-149         asm pop si

 jmp .KERNEL_START13
.KERNEL_START14:
 pop si
;-150         asm iret

 iret
;-151     }

;-152 

;-153     if (ah==0x25) {//setIntVec in AL from DS:DX

.KERNEL_START12:
 cmp  ah, 37
 jne .KERNEL_START15
;-154         asm cli; clear int enable, turn OFF int

 cli; clear int enable, turn OFF int
;-155         asm push ax

 push ax
;-156         asm push es

 push es
;-157         asm push di

 push di
;-158         asm push ds; later pop ax

 push ds; later pop ax
;-159         ax << 2;

 shl  ax, 2
;-160         ah=0;

 mov  ah, 0
;-161         di=ax;

 mov  di, ax
;-162         ax=0;

 mov  ax, 0
;-163         es=ax;//segment 0

 mov  es, ax
;-164         ax=dx;

 mov  ax, dx
;-165         asm cld; clear direction, string up

 cld; clear direction, string up
;-166         asm stosw; ofs in DX to ES:DI

 stosw; ofs in DX to ES:DI
;-167         asm pop ax; get DS

 pop ax; get DS
;-168         asm stosw; seg (DS) to ES:DI+2

 stosw; seg (DS) to ES:DI+2
;-169         asm pop di

 pop di
;-170         asm pop es

 pop es
;-171         asm pop ax

 pop ax
;-172         asm sti;set int enable, turn ON int

 sti;set int enable, turn ON int
;-173         asm iret

 iret
;-174     }

;-175     if (ah==0x2A) {//GetDate

.KERNEL_START15:
 cmp  ah, 42
 jne .KERNEL_START16
;-176         ah=4;

 mov  ah, 4
;-177         inth 0x1A;

 int  26
;-178         __emit__(0x73, 04); //jnc over KERNEL_ERR++

 db 115,4
;-179         KERNEL_ERR++;

 inc  byte[KERNEL_ERR]
;-180         asm mov [cent], ch; cent ... are used by GetDate

 mov [cent], ch; cent ... are used by GetDate
;-181         asm mov [year], cl

 mov [year], cl
;-182         asm mov [month],dh

 mov [month],dh
;-183         asm mov [day],  dl

 mov [day],  dl
;-184         if (KERNEL_ERR > 0) cputs("ERROR no RTC");

 mov al, [KERNEL_ERR]
 cmp al, 0
 jle .KERNEL_START17
 push KERNEL_START_0
 call cputs
 add  sp, 2
;-185         cent=BCDtoChar(cent);

.KERNEL_START17:
 mov al, byte [cent]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [cent], al
;-186         year=BCDtoChar(year);

 mov al, byte [year]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [year], al
;-187         month=BCDtoChar(month);

 mov al, byte [month]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [month], al
;-188         day=BCDtoChar(day);

 mov al, byte [day]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [day], al
;-189         ch=0;

 mov  ch, 0
;-190         cl=year;

 mov  cl, [year]
;-191         asm add cx, 2000; add century

 add cx, 2000; add century
;-192         dh=month;

 mov  dh, [month]
;-193         dl=day;

 mov  dl, [day]
;-194         asm iret

 iret
;-195     }

;-196     if (ah==0x2C) {//GetTime, NO 1/100 sec

.KERNEL_START16:
 cmp  ah, 44
 jne .KERNEL_START18
;-197         ah=2;

 mov  ah, 2
;-198         inth 0x1A;

 int  26
;-199         __emit__(0x73, 04); //jnc over KERNEL_ERR++

 db 115,4
;-200         KERNEL_ERR++;

 inc  byte[KERNEL_ERR]
;-201         asm mov [hour], ch

 mov [hour], ch
;-202         asm mov [min],  cl

 mov [min],  cl
;-203         asm mov [sec],  dh

 mov [sec],  dh
;-204         if (KERNEL_ERR > 0) cputs("ERROR no RTC");

 mov al, [KERNEL_ERR]
 cmp al, 0
 jle .KERNEL_START19
 push KERNEL_START_1
 call cputs
 add  sp, 2
;-205         hour=BCDtoChar(hour);

.KERNEL_START19:
 mov al, byte [hour]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [hour], al
;-206         min=BCDtoChar(min);

 mov al, byte [min]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [min], al
;-207         sec=BCDtoChar(sec);

 mov al, byte [sec]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [sec], al
;-208         ch=hour;

 mov  ch, [hour]
;-209         cl=min;

 mov  cl, [min]
;-210         dh=sec;

 mov  dh, [sec]
;-211         dl=0;// NO 1/100 sec

 mov  dl, 0
;-212         asm iret

 iret
;-213     }

;-214     if (ah==0x30) {//getDosVer

.KERNEL_START18:
 cmp  ah, 48
 jne .KERNEL_START20
;-215         ax=0x1E03; //Ver 3.30

 mov  ax, 7683
;-216         asm iret

 iret
;-217     }

;-218     if (ah==0x33) {//Control C Check (break)

.KERNEL_START20:
 cmp  ah, 51
 jne .KERNEL_START21
;-219         al=0xFF;// error for all subcodes

 mov  al, 255
;-220         dl=0;// always off

 mov  dl, 0
;-221         asm iret

 iret
;-222     }

;-223     if (ah==0x35) {//getIntVec in AL to ES:BX

.KERNEL_START21:
 cmp  ah, 53
 jne .KERNEL_START22
;-224         asm cli; clear int enable, turn OFF int

 cli; clear int enable, turn OFF int
;-225         asm push ds

 push ds
;-226         bx=0;

 mov  bx, 0
;-227         ds=bx;  //Int table starts at 0000

 mov  ds, bx
;-228         bl=al;

 mov  bl, al
;-229         bx << 2;//int is 4 bytes long

 shl  bx, 2
;-230         asm les bx, [bx]; ofs in bx, seg in es

 les bx, [bx]; ofs in bx, seg in es
;-231         asm pop ds

 pop ds
;-232         asm sti; set int enable, turn ON int

 sti; set int enable, turn ON int
;-233         asm iret

 iret
;-234     }

;-235 

;-236     if (ah==0x3F) {//read file or device

.KERNEL_START22:
 cmp  ah, 63
 jne .KERNEL_START23
;-237         if (bx == 0) {//handle = stdin

 cmp  bx, 0
 jne .KERNEL_START24
;-238             asm push cx;later pop ax, byte read

 push cx;later pop ax, byte read
;-239             asm push bx;buffer in DS:DX

 push bx;buffer in DS:DX
;-240             // cooked or raw

;-241 

;-242 

;-243 

;-244 

;-245             bx=dx;//set offset to index register, loose handle

 mov  bx, dx
;-246             while (cx > 0) {//number to read

.KERNEL_START25:
 cmp  cx, 0
 jle .KERNEL_START26
;-247 

;-248 

;-249 

;-250                 asm push bx

 push bx
;-251                 getch();

 call getch
;-252                 asm pop bx

 pop bx
;-253                 asm mov [bx], al;//DS:BX is buffer

 mov [bx], al;//DS:BX is buffer
;-254 

;-255 

;-256                 asm dec cx;

 dec cx;
;-257             }

;-258             asm pop bx

 jmp .KERNEL_START25
.KERNEL_START26:
 pop bx
;-259             asm pop ax; from CX, byte read

 pop ax; from CX, byte read
;-260             asm iret

 iret
;-261         }

;-262         ax=6;//error handle invalid

.KERNEL_START24:
 mov  ax, 6
;-263         asm stc

 stc
;-264         asm iret

 iret
;-265     }

;-266     if (ah==0x40) {//write to file or device

.KERNEL_START23:
 cmp  ah, 64
 jne .KERNEL_START27
;-267         if (bx <= 2) {//handle = stdin,stdout,error device

 cmp  bx, 2
 ja  .KERNEL_START28
;-268             asm push cx;later pop ax, byte written

 push cx;later pop ax, byte written
;-269             asm push bx

 push bx
;-270             bx=dx;//set offset to index register, loose handle

 mov  bx, dx
;-271             while (cx > 0) {//number to write

.KERNEL_START29:
 cmp  cx, 0
 jle .KERNEL_START30
;-272                 asm mov al, [bx];//DS:BX is buffer

 mov al, [bx];//DS:BX is buffer
;-273                 writetty();

 call writetty
;-274                 asm mov al, [bx]

 mov al, [bx]
;-275                 if (al  == 10) {//add CR to LF

 cmp  al, 10
 jne .KERNEL_START31
;-276                     al=13;

 mov  al, 13
;-277                     writetty();

 call writetty
;-278                 }

;-279                 asm dec cx;

.KERNEL_START31:
 dec cx;
;-280             }

;-281             asm pop bx

 jmp .KERNEL_START29
.KERNEL_START30:
 pop bx
;-282             asm pop ax; from CX, byte written

 pop ax; from CX, byte written
;-283             asm iret

 iret
;-284         }

;-285         ax=6;//error handle invalid

.KERNEL_START28:
 mov  ax, 6
;-286         asm stc

 stc
;-287         asm iret

 iret
;-288     }

;-289 

;-290     if (ah==0x44) {//IOCTL Data

.KERNEL_START27:
 cmp  ah, 68
 jne .KERNEL_START32
;-291         if (al == 0) {// 0=get data

 cmp  al, 0
 jne .KERNEL_START33
;-292             if (bx == 0) {//handle:sdtin

 cmp  bx, 0
 jne .KERNEL_START34
;-293                 dx=mode_IOData;//8080=cooked, 8280=raw

 mov  dx, [mode_IOData]
;-294                 asm iret

 iret
;-295             }

;-296         }

.KERNEL_START34:
;-297         if (al == 1) {//set data

.KERNEL_START33:
 cmp  al, 1
 jne .KERNEL_START35
;-298             if (bx == 0) {//handle:sdtin

 cmp  bx, 0
 jne .KERNEL_START36
;-299                 asm mov [mode_IOData], dx;//8080=cooked, 8280=raw

 mov [mode_IOData], dx;//8080=cooked, 8280=raw
;-300                 asm iret

 iret
;-301             }

;-302         }

.KERNEL_START36:
;-303             ax=15;//error unvalid Data

.KERNEL_START35:
 mov  ax, 15
;-304             asm stc; set carry flag

 stc; set carry flag
;-305             asm iret

 iret
;-306         // IOCTL function not supported,fall through to error

;-307     }

;-308     if (ah==0x4C) {//Terminate

.KERNEL_START32:
 cmp  ah, 76
 jne .KERNEL_START37
;-309         al=0;//returncode

 mov  al, 0
;-310         inth 0x21;

 int  33
;-311         // asm iret

;-312     }

;-313     if (ah==0x54) {//GetVerifyState

.KERNEL_START37:
 cmp  ah, 84
 jne .KERNEL_START38
;-314         al=0;// always off

 mov  al, 0
;-315         asm iret

 iret
;-316     }

;-317 

;-318     // function not implemented

;-319     asm push ax

.KERNEL_START38:
 push ax
;-320     cputs(" FUNC ");

 push KERNEL_START_2
 call cputs
 add  sp, 2
;-321     asm pop ax

 pop ax
;-322     ax >> 8;

 shr  ax, 8
;-323     printhex8(ax);

 push ax
 call printhex8
 add  sp, 2
;-324     cputs("h not supported");

 push KERNEL_START_3
 call cputs
 add  sp, 2
;-325 //    inth 3;// break, call debug

;-326     asm iret

 iret
;-327 }// END OF TSR

;-328 

;-329 //--------------------------- Kernel Programs for separate use ------

;-330 int GetTickerBios() {

 ret
KERNEL_START_0 db "ERROR no RTC",0
KERNEL_START_1 db "ERROR no RTC",0
KERNEL_START_2 db " FUNC ",0
KERNEL_START_3 db "h not supported",0
ENDP

GetTickerBios: PROC
;-331     cputs(" BiosTicker LO/HI:");

 push GetTickerBios_0
 call cputs
 add  sp, 2
;-332     ah=0;

 mov  ah, 0
;-333     inth 0x1A;

 int  26
;-334     printunsign(dx);

 push dx
 call printunsign
 add  sp, 2
;-335     putch(':');

 push 58
 call putch
 add  sp, 2
;-336     printunsign(cx);

 push cx
 call printunsign
 add  sp, 2
;-337 }

;-338 

;-339 int RAM046CTicks() {

 ret
GetTickerBios_0 db " BiosTicker LO/HI:",0
ENDP

RAM046CTicks: PROC
;-340     cputs(" Ticks @40:6C LO/HI:");

 push RAM046CTicks_0
 call cputs
 add  sp, 2
;-341     asm push es

 push es
;-342     ax=0x40;

 mov  ax, 64
;-343     es=ax;

 mov  es, ax
;-344     __emit__(0x26);// ES:

 db 38
;-345     asm mov ax, [108]; 6Ch

 mov ax, [108]; 6Ch
;-346     printunsign(ax);

 push ax
 call printunsign
 add  sp, 2
;-347     putch(':');

 push 58
 call putch
 add  sp, 2
;-348     __emit__(0x26);// ES:

 db 38
;-349     asm mov ax, [110]; 6Eh

 mov ax, [110]; 6Eh
;-350     printunsign(ax);

 push ax
 call printunsign
 add  sp, 2
;-351     asm pop es

 pop es
;-352 }

;-353 

;-354 int printDateTime() {

 ret
RAM046CTicks_0 db " Ticks @40:6C LO/HI:",0
ENDP

printDateTime: PROC
;-355     ah=0x2A;

 mov  ah, 42
;-356     KernelInt();

 call KernelInt
;-357     printunsign(day);

 mov al, byte [day]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-358     putch('.');

 push 46
 call putch
 add  sp, 2
;-359     printunsign(month);

 mov al, byte [month]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-360     putch('.');

 push 46
 call putch
 add  sp, 2
;-361     printunsign(cent);

 mov al, byte [cent]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-362     printunsign(year);

 mov al, byte [year]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-363     putch(' ');

 push 32
 call putch
 add  sp, 2
;-364     ah=0x2C;

 mov  ah, 44
;-365     KernelInt();

 call KernelInt
;-366     printunsign(hour);

 mov al, byte [hour]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-367     putch(':');

 push 58
 call putch
 add  sp, 2
;-368     printunsign(min);

 mov al, byte [min]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-369     putch(':');

 push 58
 call putch
 add  sp, 2
;-370     printunsign(sec);

 mov al, byte [sec]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-371 }

;-372 int printVersion() {

 ret
ENDP

printVersion: PROC
;-373     int vAX;

;-374     ah=0x30;
;
 ENTER  2,0
 mov  ah, 48
;-375     KernelInt();

 call KernelInt
;-376     asm mov [bp-2], ax;

 mov [bp-2], ax;
;-377     cputs(" KernelVer:");

 push printVersion_0
 call cputs
 add  sp, 2
;-378     printhex4(vAX);

 push word [bp-2]
 call printhex4
 add  sp, 2
;-379     putch('.');

 push 46
 call putch
 add  sp, 2
;-380     vAX=vAX >> 8;

 mov ax, [bp-2]
 shr ax, 8
 mov [bp-2], ax
;-381     printunsign(vAX);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-382 }

;-383 int main() {

 LEAVE
 ret
printVersion_0 db " KernelVer:",0
ENDP

main: PROC
;-384     count18h=0;

 mov ax, 0
 mov word [count18h], ax
;-385     asm mov dx, KERNEL_START;set Int Vec

 mov dx, KERNEL_START;set Int Vec
;-386     ax=0x2518;

 mov  ax, 9496
;-387     inth 0x21;//new In18h is not yet connected

 int  33
;-388 

;-389     printDateTime();

 call printDateTime
;-390     printVersion();

 call printVersion
;-391 ah=0x99;

 mov  ah, 153
;-392 KernelInt();

 call KernelInt
;-393     cputs(" c18h=");

 push main_0
 call cputs
 add  sp, 2
;-394     printunsign(count18h);

 push word [count18h]
 call printunsign
 add  sp, 2
;-395     ah=0x4C;//Terminate

 mov  ah, 76
;-396     KernelInt();

 call KernelInt
;-397 }

 ret
main_0 db " c18h=",0
ENDP
;Glob. variables:13 (300), Functions:20 (300), Lines:398
;Constant: 141 (3000), stacksize: 40536