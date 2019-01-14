;PLA compiler A.COM V0.9.6, Input: KRNL.C, Output: KRNL.S
org  256 
jmp main
;-1 char Version1[]="KERNEL.COM V0.1b";

Version1 db "KERNEL.COM V0.1b",0
;-2 //---------------------------- Kernel Data Area ---------------------

;-3 char KERNEL_ERR=0;

KERNEL_ERR db 0
;-4 unsigned int count18h=0;

count18h dw 0
;-5 unsigned int vAX;

vAX dw 0
;-6 char cent;char year;char month;char day;

cent db 0
year db 0
month db 0
day db 0
;-7 char hour; char min; char sec;

hour db 0
min db 0
sec db 0
;-8 //--------------------------- Bios Routines I/O ---------------------

;-9 int writetty()     {//char in AL


writetty: PROC
;-10     ah=0x0E;

 mov  ah, 14
;-11     bx=0;     //page

 mov  bx, 0
;-12     inth 0x10;

 int  16
;-13 }

;-14 int putch(char c)  {

 ret
ENDP

putch: PROC
;-15     if (c==10)  {
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-16         al=13;

 mov  al, 13
;-17         writetty();

 call writetty
;-18     }

;-19     al=c;

.putch1:
 mov  al, [bp+4]
;-20     writetty();

 call writetty
;-21 }

;-22 int cputs(char *s) {//only with correct DS !!!

 LEAVE
 ret
ENDP

cputs: PROC
;-23     char c;

;-24     while(*s) {
;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-25         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-26         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-27         s++;

 inc  word[bp+4]
;-28     }

;-29 }

 jmp .cputs2
.cputs3:
;-30 

;-31 int printhex4(unsigned char c) {

 LEAVE
 ret
ENDP

printhex4: PROC
;-32     c += 48;
;
 ENTER  0,0
 add  byte[bp+4], 48
;-33     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex44
 add  byte[bp+4], 7
;-34     putch(c);

.printhex44:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-35 }

;-36 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-37     unsigned char nib;

;-38     nib = c >> 4; printhex4(nib);
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
;-39     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-40 }

;-41 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-42     unsigned int half;

;-43     half = i >>  8; printhex8(half);
;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-44     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-45 }

;-46 

;-47 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-48     unsigned int e;

;-49     if (n >= 10) {
;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign5
;-50         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-51         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-52         }

;-53     n=n%10;

.printunsign5:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-54     n+='0';

 add  word[bp+4], 48
;-55     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-56 }

;-57 

;-58 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-59     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-60     inth 0x16;//AH=Scan code, AL=char

 int  22
;-61 }

;-62 int waitkey() {

 ret
ENDP

waitkey: PROC
;-63     ah=0x11;//get kbd status

 mov  ah, 17
;-64     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-65     //zero flag: 0=IS char, 1=NO char

;-66     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-67 }

;-68 int getkey() {

 ret
ENDP

getkey: PROC
;-69     waitkey();

 call waitkey
;-70     getch();

 call getch
;-71     ah=0;//clear scan code

 mov  ah, 0
;-72     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-73     //put ext code in AX

;-74 }

.getkey6:
;-75 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-76     getkey();

 call getkey
;-77     writetty();

 call writetty
;-78 }

;-79 // ------------------------- Bios Functions -------------------------

;-80 int BCDtoChar(char BCD) { // converts 2 digit packed BCD

 ret
ENDP

BCDtoChar: PROC
;-81     char LowNibble;       // to Integer

;-82     LowNibble = BCD & 0xF;// save ones digit
;
 ENTER  2,0
 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
;-83     BCD >> 4;// extract tens digit, result in AX

 mov al, [bp+4]
 shr al, 4
;-84     asm push dx

 push dx
;-85     dl = 10;

 mov  dl, 10
;-86     asm mul dl; result in AX

 mul dl; result in AX
;-87     asm pop dx

 pop dx
;-88     al += LowNibble;

 add  al, [bp-2]
;-89     ah=0;//result is byte

 mov  ah, 0
;-90 }

;-91 int GetRTCDate() {

 LEAVE
 ret
ENDP

GetRTCDate: PROC
;-92 //    cputs(" RTC Date:");

;-93     ah=4;

 mov  ah, 4
;-94     inth 0x1A;

 int  26
;-95     __emit__(0x73, 04); //jnc over KERNEL_ERR++

 db 115,4
;-96     KERNEL_ERR++;

 inc  byte[KERNEL_ERR]
;-97     asm mov [cent], ch; cent ... are used by GetDate

 mov [cent], ch; cent ... are used by GetDate
;-98     asm mov [year], cl

 mov [year], cl
;-99     asm mov [month],dh

 mov [month],dh
;-100     asm mov [day],  dl

 mov [day],  dl
;-101     if (KERNEL_ERR > 0) cputs("ERROR no RTC");

 mov al, [KERNEL_ERR]
 cmp al, 0
 jle .GetRTCDate7
 push GetRTCDate_0
 call cputs
 add  sp, 2
;-102 }

.GetRTCDate7:
;-103 int GetRTCTime() {

 ret
GetRTCDate_0 db "ERROR no RTC",0
ENDP

GetRTCTime: PROC
;-104 //    cputs(" RTCTime:");

;-105     ah=2;

 mov  ah, 2
;-106     inth 0x1A;

 int  26
;-107     __emit__(0x73, 04); //jnc over KERNEL_ERR++

 db 115,4
;-108     KERNEL_ERR++;

 inc  byte[KERNEL_ERR]
;-109     asm mov [hour], ch

 mov [hour], ch
;-110     asm mov [min],  cl

 mov [min],  cl
;-111     asm mov [sec],  dh

 mov [sec],  dh
;-112     if (KERNEL_ERR > 0) cputs("ERROR no RTC");

 mov al, [KERNEL_ERR]
 cmp al, 0
 jle .GetRTCTime8
 push GetRTCTime_0
 call cputs
 add  sp, 2
;-113 }

.GetRTCTime8:
;-114 //--------------------------- Kernel Routines -----------------------

;-115 int KernelInt() {

 ret
GetRTCTime_0 db "ERROR no RTC",0
ENDP

KernelInt: PROC
;-116     inth 0x18;

 int  24
;-117     __emit__(0x73, 04); //jnc over KERNEL_ERR++

 db 115,4
;-118     KERNEL_ERR++;

 inc  byte[KERNEL_ERR]
;-119 }

;-120 unsigned int VecOldOfs;

 ret
ENDP
VecOldOfs dw 0
;-121 unsigned int VecOldSeg;

VecOldSeg dw 0
;-122 

;-123 int GetIntVec(char c) {


GetIntVec: PROC
;-124     asm push es
;
 ENTER  0,0
 push es
;-125     al=c;

 mov  al, [bp+4]
;-126     ah=0x35;

 mov  ah, 53
;-127     KernelInt();

 call KernelInt
;-128     asm mov [VecOldOfs], bx

 mov [VecOldOfs], bx
;-129     asm mov [VecOldSeg], es

 mov [VecOldSeg], es
;-130     asm pop es

 pop es
;-131 }

;-132 

;-133 //--------------------------- Start of new Interrupt 18h ------------

;-134 int KERNEL_START() {

 LEAVE
 ret
ENDP

KERNEL_START: PROC
;-135     count18h++;

 inc  word[count18h]
;-136     asm sti; set interrupt enable

 sti; set interrupt enable
;-137     if (ah==0x09) {//display string in DS:DX

 cmp  ah, 9
 jne .KERNEL_START9
;-138         asm push si

 push si
;-139         si=dx;

 mov  si, dx
;-140         asm cld; clear direction, string up

 cld; clear direction, string up
;-141         asm lodsb; from DS:SI to AL

 lodsb; from DS:SI to AL
;-142         while (al != '$') {

.KERNEL_START10:
 cmp  al, 36
 je  .KERNEL_START11
;-143             writetty();

 call writetty
;-144             asm lodsb

 lodsb
;-145         }

;-146         asm pop si

 jmp .KERNEL_START10
.KERNEL_START11:
 pop si
;-147         asm iret

 iret
;-148     }

;-149 

;-150     if (ah==0x25) {//setIntVec in AL from DS:DX

.KERNEL_START9:
 cmp  ah, 37
 jne .KERNEL_START12
;-151         asm cli; clear int enable, turn OFF int

 cli; clear int enable, turn OFF int
;-152         asm push ax

 push ax
;-153         asm push es

 push es
;-154         asm push di

 push di
;-155         asm push ds; later pop ax

 push ds; later pop ax
;-156         ax << 2;

 shl  ax, 2
;-157         ah=0;

 mov  ah, 0
;-158         di=ax;

 mov  di, ax
;-159         ax=0;

 mov  ax, 0
;-160         es=ax;//segment 0

 mov  es, ax
;-161         ax=dx;

 mov  ax, dx
;-162         asm cld; clear direction, string up

 cld; clear direction, string up
;-163         asm stosw; ofs in DX to ES:DI

 stosw; ofs in DX to ES:DI
;-164         asm pop ax; get DS

 pop ax; get DS
;-165         asm stosw; seg (DS) to ES:DI+2

 stosw; seg (DS) to ES:DI+2
;-166         asm pop di

 pop di
;-167         asm pop es

 pop es
;-168         asm pop ax

 pop ax
;-169         asm sti;set int enable, turn ON int

 sti;set int enable, turn ON int
;-170         asm iret

 iret
;-171     }

;-172     if (ah==0x2A) {//GetDate

.KERNEL_START12:
 cmp  ah, 42
 jne .KERNEL_START13
;-173         GetRTCDate();// get Date in BCD

 call GetRTCDate
;-174         cent=BCDtoChar(cent);

 mov al, byte [cent]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [cent], al
;-175         year=BCDtoChar(year);

 mov al, byte [year]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [year], al
;-176         month=BCDtoChar(month);

 mov al, byte [month]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [month], al
;-177         day=BCDtoChar(day);

 mov al, byte [day]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [day], al
;-178         ch=0;

 mov  ch, 0
;-179         cl=year;

 mov  cl, [year]
;-180         asm add cx, 2000; add century

 add cx, 2000; add century
;-181         dh=month;

 mov  dh, [month]
;-182         dl=day;

 mov  dl, [day]
;-183         asm iret

 iret
;-184     }

;-185     if (ah==0x2C) {//GetTime, NO 1/100 sec

.KERNEL_START13:
 cmp  ah, 44
 jne .KERNEL_START14
;-186         GetRTCTime();

 call GetRTCTime
;-187         hour=BCDtoChar(hour);

 mov al, byte [hour]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [hour], al
;-188         min=BCDtoChar(min);

 mov al, byte [min]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [min], al
;-189         sec=BCDtoChar(sec);

 mov al, byte [sec]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [sec], al
;-190         ch=hour;

 mov  ch, [hour]
;-191         cl=min;

 mov  cl, [min]
;-192         dh=sec;

 mov  dh, [sec]
;-193         dl=0;// NO 1/100 sec

 mov  dl, 0
;-194         asm iret

 iret
;-195     }

;-196     if (ah==0x30) {//getDosVer

.KERNEL_START14:
 cmp  ah, 48
 jne .KERNEL_START15
;-197         ax=0x1E03; //Ver 3.30

 mov  ax, 7683
;-198         asm iret

 iret
;-199     }

;-200     if (ah==0x35) {//getIntVec in AL to ES:BX

.KERNEL_START15:
 cmp  ah, 53
 jne .KERNEL_START16
;-201         asm cli; clear int enable, turn OFF int

 cli; clear int enable, turn OFF int
;-202         asm push ds

 push ds
;-203         bx=0;

 mov  bx, 0
;-204         ds=bx;  //Int table starts at 0000

 mov  ds, bx
;-205         bl=al;

 mov  bl, al
;-206         bx << 2;//int is 4 bytes long

 shl  bx, 2
;-207         asm les bx, [bx]; ofs in bx, seg in es

 les bx, [bx]; ofs in bx, seg in es
;-208         asm pop ds

 pop ds
;-209         asm sti; set int enable, turn ON int

 sti; set int enable, turn ON int
;-210         asm iret

 iret
;-211     }

;-212     if (ah==0x4C) {//Terminate

.KERNEL_START16:
 cmp  ah, 76
 jne .KERNEL_START17
;-213         al=0;//returncode

 mov  al, 0
;-214         inth 0x21;

 int  33
;-215         // asm iret

;-216     }

;-217     // function not implemented

;-218     asm mov [vAX], ah

.KERNEL_START17:
 mov [vAX], ah
;-219     cputs(" FUNC ");

 push KERNEL_START_0
 call cputs
 add  sp, 2
;-220     printhex8(vAX);

 push word [vAX]
 call printhex8
 add  sp, 2
;-221     cputs(" not impl.");

 push KERNEL_START_1
 call cputs
 add  sp, 2
;-222     asm iret

 iret
;-223 }// END OF TSR

;-224 

;-225 //--------------------------- Kernel Programs for separate use

;-226 int GetTickerBios() {

 ret
KERNEL_START_0 db " FUNC ",0
KERNEL_START_1 db " not impl.",0
ENDP

GetTickerBios: PROC
;-227     cputs(" BiosTicker LO/HI:");

 push GetTickerBios_0
 call cputs
 add  sp, 2
;-228     ah=0;

 mov  ah, 0
;-229     inth 0x1A;

 int  26
;-230     printunsign(dx);

 push dx
 call printunsign
 add  sp, 2
;-231     putch(':');

 push 58
 call putch
 add  sp, 2
;-232     printunsign(cx);

 push cx
 call printunsign
 add  sp, 2
;-233 }

;-234 

;-235 int RAM046CTicks() {

 ret
GetTickerBios_0 db " BiosTicker LO/HI:",0
ENDP

RAM046CTicks: PROC
;-236     cputs(" Ticks @40:6C LO/HI:");

 push RAM046CTicks_0
 call cputs
 add  sp, 2
;-237     asm push es

 push es
;-238     ax=0x40;

 mov  ax, 64
;-239     es=ax;

 mov  es, ax
;-240     __emit__(0x26);// ES:

 db 38
;-241     asm mov ax, [108]; 6Ch

 mov ax, [108]; 6Ch
;-242     printunsign(ax);

 push ax
 call printunsign
 add  sp, 2
;-243     putch(':');

 push 58
 call putch
 add  sp, 2
;-244     __emit__(0x26);// ES:

 db 38
;-245     asm mov ax, [110]; 6Eh

 mov ax, [110]; 6Eh
;-246     printunsign(ax);

 push ax
 call printunsign
 add  sp, 2
;-247     asm pop es

 pop es
;-248 }

;-249 

;-250 int printDateTime() {

 ret
RAM046CTicks_0 db " Ticks @40:6C LO/HI:",0
ENDP

printDateTime: PROC
;-251     ah=0x2A;

 mov  ah, 42
;-252     KernelInt();

 call KernelInt
;-253     printunsign(day);

 mov al, byte [day]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-254     putch('.');

 push 46
 call putch
 add  sp, 2
;-255     printunsign(month);

 mov al, byte [month]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-256     putch('.');

 push 46
 call putch
 add  sp, 2
;-257     printunsign(cent);

 mov al, byte [cent]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-258     printunsign(year);

 mov al, byte [year]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-259     putch(' ');

 push 32
 call putch
 add  sp, 2
;-260 

;-261     ah=0x2C;

 mov  ah, 44
;-262     KernelInt();

 call KernelInt
;-263     printunsign(hour);

 mov al, byte [hour]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-264     putch(':');

 push 58
 call putch
 add  sp, 2
;-265     printunsign(min);

 mov al, byte [min]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-266     putch(':');

 push 58
 call putch
 add  sp, 2
;-267     printunsign(sec);

 mov al, byte [sec]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-268 }

;-269 int printVersion() {

 ret
ENDP

printVersion: PROC
;-270     ah=0x30;

 mov  ah, 48
;-271     KernelInt();

 call KernelInt
;-272     asm mov [vAX], ax

 mov [vAX], ax
;-273     cputs(" KernelVer:");

 push printVersion_0
 call cputs
 add  sp, 2
;-274     printhex4(vAX);

 push word [vAX]
 call printhex4
 add  sp, 2
;-275     putch('.');

 push 46
 call putch
 add  sp, 2
;-276     vAX=vAX >>8;

 mov ax, [vAX]
 shr ax, 8
 mov word [vAX], ax
;-277     printunsign(vAX);

 push word [vAX]
 call printunsign
 add  sp, 2
;-278 }

;-279 int main() {

 ret
printVersion_0 db " KernelVer:",0
ENDP

main: PROC
;-280     count18h=0;

 mov ax, 0
 mov word [count18h], ax
;-281     //set Int Vec to KERNEL_START

;-282     asm mov dx, KERNEL_START

 mov dx, KERNEL_START
;-283     ax=0x2518;

 mov  ax, 9496
;-284     inth 0x21;//new In18h is not connected

 int  33
;-285 

;-286     printDateTime();

 call printDateTime
;-287 

;-288     cputs(" c18h=");

 push main_0
 call cputs
 add  sp, 2
;-289     printunsign(count18h);

 push word [count18h]
 call printunsign
 add  sp, 2
;-290     ah=0x4C;//Terminate

 mov  ah, 76
;-291     KernelInt();

 call KernelInt
;-292 }

 ret
main_0 db " c18h=",0
ENDP
;Glob. variables:13 (300), Functions:22 (300), Lines:293
;Constant: 64 (3000), stacksize: 40536