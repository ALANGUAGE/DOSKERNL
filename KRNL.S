;PLA compiler A.COM V0.9.6, Input: KRNL.C, Output: KRNL.S
org  256 
jmp main
;-1 char Version1[]="KERNEL.COM V0.1";

Version1 db "KERNEL.COM V0.1",0
;-2 char DOS_ERR=0;

DOS_ERR db 0
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
;-8 

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

;-79 

;-80 int BCDtoChar(char BCD) {// converts 2 digit packed BCD

 ret
ENDP

BCDtoChar: PROC
;-81     char LowNibble;

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
;-114 

;-115 int DosInt() {

 ret
GetRTCTime_0 db "ERROR no RTC",0
ENDP

DosInt: PROC
;-116     inth 0x21;

 int  33
;-117     __emit__(0x73, 04); //jnc over DOS_ERR++

 db 115,4
;-118     DOS_ERR++;

 inc  byte[DOS_ERR]
;-119 }

;-120 int KernelInt() {

 ret
ENDP

KernelInt: PROC
;-121     inth 0x18;

 int  24
;-122     __emit__(0x73, 04); //jnc over KERNEL_ERR++

 db 115,4
;-123     KERNEL_ERR++;

 inc  byte[KERNEL_ERR]
;-124 }

;-125 

;-126 int KERNEL_START() {

 ret
ENDP

KERNEL_START: PROC
;-127     count18h++;

 inc  word[count18h]
;-128     asm sti; set int enable

 sti; set int enable
;-129 

;-130     if (ah==0x25) {//setIntVec in AL from DS:DX

 cmp  ah, 37
 jne .KERNEL_START9
;-131         asm cli; clear int enable, turn OFF int

 cli; clear int enable, turn OFF int
;-132         asm push ax

 push ax
;-133         asm push es

 push es
;-134         asm push di

 push di
;-135         asm push ds; later pop ax

 push ds; later pop ax
;-136         ax << 2;

 shl  ax, 2
;-137         ah=0;

 mov  ah, 0
;-138         di=ax;

 mov  di, ax
;-139         ax=0;

 mov  ax, 0
;-140         es=ax;//segment 0

 mov  es, ax
;-141         ax=dx;

 mov  ax, dx
;-142         asm cld; clear direction, Up

 cld; clear direction, Up
;-143         asm stosw; ofs in DX to ES:DI

 stosw; ofs in DX to ES:DI
;-144         asm pop ax; get DS

 pop ax; get DS
;-145         asm stosw; seg (DS) to ES:DI+2

 stosw; seg (DS) to ES:DI+2
;-146         asm pop di

 pop di
;-147         asm pop es

 pop es
;-148         asm pop ax

 pop ax
;-149         asm sti;set int enable, turn ON int

 sti;set int enable, turn ON int
;-150         asm iret

 iret
;-151     }

;-152     if (ah==0x2A) {//GetDate

.KERNEL_START9:
 cmp  ah, 42
 jne .KERNEL_START10
;-153         GetRTCDate();// get Date in BCD

 call GetRTCDate
;-154         cent=BCDtoChar(cent);

 mov al, byte [cent]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [cent], al
;-155         year=BCDtoChar(year);

 mov al, byte [year]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [year], al
;-156         month=BCDtoChar(month);

 mov al, byte [month]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [month], al
;-157         day=BCDtoChar(day);

 mov al, byte [day]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [day], al
;-158         ch=0;

 mov  ch, 0
;-159         cl=year;

 mov  cl, [year]
;-160         asm add cx, 2000; add century

 add cx, 2000; add century
;-161         dh=month;

 mov  dh, [month]
;-162         dl=day;

 mov  dl, [day]
;-163         asm iret

 iret
;-164     }

;-165     if (ah==0x2C) {//GetTime, NO 1/100 sec

.KERNEL_START10:
 cmp  ah, 44
 jne .KERNEL_START11
;-166         GetRTCTime();

 call GetRTCTime
;-167         hour=BCDtoChar(hour);

 mov al, byte [hour]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [hour], al
;-168         min=BCDtoChar(min);

 mov al, byte [min]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [min], al
;-169         sec=BCDtoChar(sec);

 mov al, byte [sec]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [sec], al
;-170         ch=hour;

 mov  ch, [hour]
;-171         cl=min;

 mov  cl, [min]
;-172         dh=sec;

 mov  dh, [sec]
;-173         dl=0;// NO 1/100 sec

 mov  dl, 0
;-174         asm iret

 iret
;-175     }

;-176     if (ah==0x30) {//getDosVer

.KERNEL_START11:
 cmp  ah, 48
 jne .KERNEL_START12
;-177         ax=0x1E03; //Ver 3.30

 mov  ax, 7683
;-178         asm iret

 iret
;-179     }

;-180     if (ah==0x35) {//getIntVec in AL to ES:BX

.KERNEL_START12:
 cmp  ah, 53
 jne .KERNEL_START13
;-181         asm cli; clear int enable, turn OFF int

 cli; clear int enable, turn OFF int
;-182         asm push ds

 push ds
;-183         bx=0;

 mov  bx, 0
;-184         ds=bx;  //Int table starts at 0000

 mov  ds, bx
;-185         bl=al;

 mov  bl, al
;-186         bx << 2;//int is 4 bytes long

 shl  bx, 2
;-187         asm les bx, [bx]; ofs in bx, seg in es

 les bx, [bx]; ofs in bx, seg in es
;-188         asm pop ds

 pop ds
;-189         asm sti; set int enable, turn ON int

 sti; set int enable, turn ON int
;-190         asm iret

 iret
;-191     }

;-192     if (ah==0x4C) {//Terminate

.KERNEL_START13:
 cmp  ah, 76
 jne .KERNEL_START14
;-193         al=0;//returncode

 mov  al, 0
;-194         inth 0x21;

 int  33
;-195         // asm iret

;-196     }

;-197 

;-198     asm mov [vAX], ah

.KERNEL_START14:
 mov [vAX], ah
;-199     cputs(" FUNC ");

 push KERNEL_START_0
 call cputs
 add  sp, 2
;-200     printhex8(vAX);

 push word [vAX]
 call printhex8
 add  sp, 2
;-201     cputs(" not impl.");

 push KERNEL_START_1
 call cputs
 add  sp, 2
;-202     asm iret

 iret
;-203 }

;-204 unsigned int VecOldOfs;

 ret
KERNEL_START_0 db " FUNC ",0
KERNEL_START_1 db " not impl.",0
ENDP
VecOldOfs dw 0
;-205 unsigned int VecOldSeg;

VecOldSeg dw 0
;-206 

;-207 int GetIntVec(char c) {


GetIntVec: PROC
;-208     asm push es
;
 ENTER  0,0
 push es
;-209     al=c;

 mov  al, [bp+4]
;-210     ah=0x35;

 mov  ah, 53
;-211     KernelInt();

 call KernelInt
;-212     asm mov [VecOldOfs], bx

 mov [VecOldOfs], bx
;-213     asm mov [VecOldSeg], es

 mov [VecOldSeg], es
;-214     asm pop es

 pop es
;-215 }

;-216 int GetIntVecDos(char c) {

 LEAVE
 ret
ENDP

GetIntVecDos: PROC
;-217     asm push es
;
 ENTER  0,0
 push es
;-218     al=c;

 mov  al, [bp+4]
;-219     ah=0x35;

 mov  ah, 53
;-220     DosInt();

 call DosInt
;-221     asm mov [VecOldOfs], bx

 mov [VecOldOfs], bx
;-222     asm mov [VecOldSeg], es

 mov [VecOldSeg], es
;-223     asm pop es

 pop es
;-224 }

;-225 

;-226 /*

;-227 int GetDateDos() {

;-228     int year;char month;char day;int dayofweek;

;-229     cputs(" DosDate:");

;-230     ah=0x2A;

;-231     DosInt();

;-232     asm mov [bp-2], cx; year

;-233     asm mov [bp-4], dh; month

;-234     asm mov [bp-6], dl; day

;-235     asm mov [bp-8], al; dayofweek

;-236 //    printunsign(dayofweek);

;-237 //    putch('-');

;-238     printunsign(day);

;-239     putch('.');

;-240     printunsign(month);

;-241     putch('.');

;-242     printunsign(year);

;-243 }

;-244 */

;-245 /*

;-246 int GetTimeDos() {

;-247     char hour; char min; char sec; char h100;

;-248     cputs(" DosTime:");

;-249     ah=0x2C;

;-250     DosInt();

;-251     asm mov [bp-2], ch; hour

;-252     asm mov [bp-4], cl; min

;-253     asm mov [bp-6], dh; sec

;-254     asm mov [bp-8], dl; h100

;-255     printunsign(hour);

;-256     putch(':');

;-257     printunsign(min);

;-258     putch(':');

;-259     printunsign(sec);

;-260 //    putch('-');

;-261 //    printunsign(h100);

;-262 }

;-263 */

;-264 int GetTickerBios() {

 LEAVE
 ret
ENDP

GetTickerBios: PROC
;-265     cputs(" BiosTicker LO/HI:");

 push GetTickerBios_0
 call cputs
 add  sp, 2
;-266     ah=0;

 mov  ah, 0
;-267     inth 0x1A;

 int  26
;-268     printunsign(dx);

 push dx
 call printunsign
 add  sp, 2
;-269     putch(':');

 push 58
 call putch
 add  sp, 2
;-270     printunsign(cx);

 push cx
 call printunsign
 add  sp, 2
;-271 }

;-272 

;-273 int RAM046CTicks() {

 ret
GetTickerBios_0 db " BiosTicker LO/HI:",0
ENDP

RAM046CTicks: PROC
;-274     cputs(" Ticks 40:6C LO/HI:");

 push RAM046CTicks_0
 call cputs
 add  sp, 2
;-275     asm push es

 push es
;-276     ax=0x40;

 mov  ax, 64
;-277     es=ax;

 mov  es, ax
;-278     __emit__(0x26);// ES:

 db 38
;-279     asm mov ax, [108]; 6Ch

 mov ax, [108]; 6Ch
;-280     printunsign(ax);

 push ax
 call printunsign
 add  sp, 2
;-281     putch(':');

 push 58
 call putch
 add  sp, 2
;-282     __emit__(0x26);// ES:

 db 38
;-283     asm mov ax, [110]; 6Eh

 mov ax, [110]; 6Eh
;-284     printunsign(ax);

 push ax
 call printunsign
 add  sp, 2
;-285     asm pop es

 pop es
;-286 }

;-287 

;-288 int printDateTime() {

 ret
RAM046CTicks_0 db " Ticks 40:6C LO/HI:",0
ENDP

printDateTime: PROC
;-289     day=BCDtoChar(day);

 mov al, byte [day]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [day], al
;-290     printunsign(day);

 mov al, byte [day]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-291     putch('.');

 push 46
 call putch
 add  sp, 2
;-292     month=BCDtoChar(month);

 mov al, byte [month]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [month], al
;-293     printunsign(month);

 mov al, byte [month]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-294     putch('.');

 push 46
 call putch
 add  sp, 2
;-295     cent=BCDtoChar(cent);

 mov al, byte [cent]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [cent], al
;-296     printunsign(cent);

 mov al, byte [cent]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-297     year=BCDtoChar(year);

 mov al, byte [year]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [year], al
;-298     printunsign(year);

 mov al, byte [year]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-299     putch(' ');

 push 32
 call putch
 add  sp, 2
;-300     hour=BCDtoChar(hour);

 mov al, byte [hour]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [hour], al
;-301     printunsign(hour);

 mov al, byte [hour]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-302     putch(':');

 push 58
 call putch
 add  sp, 2
;-303     min=BCDtoChar(min);

 mov al, byte [min]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [min], al
;-304     printunsign(min);

 mov al, byte [min]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-305     putch(':');

 push 58
 call putch
 add  sp, 2
;-306     sec=BCDtoChar(sec);

 mov al, byte [sec]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [sec], al
;-307     printunsign(sec);

 mov al, byte [sec]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-308     putch(' ');

 push 32
 call putch
 add  sp, 2
;-309 }

;-310 int main() {

 ret
ENDP

main: PROC
;-311     count18h=0;

 mov ax, 0
 mov word [count18h], ax
;-312 //    GetIntVecDos(0x18);//new In18h is not connected

;-313 //    cputs("Int18h old=");

;-314 //    printhex16(VecOldSeg);

;-315 //    putch(':');

;-316 //    printhex16(VecOldOfs);

;-317 

;-318     //set Int Vec to KERNEL_START

;-319     asm mov dx, KERNEL_START

 mov dx, KERNEL_START
;-320     ax=0x2518;

 mov  ax, 9496
;-321     DosInt();//new In18h is not connected

 call DosInt
;-322 

;-323 //    GetIntVec(0x18);

;-324 //    cputs(" Int18h new=");

;-325 //    printhex16(VecOldSeg);

;-326 //    putch(':');

;-327 //    printhex16(VecOldOfs);

;-328 

;-329 //    RTCDate();

;-330 //    GetRTCTime();

;-331 //    printDateTime();

;-332 //    RAM046CTicks();

;-333 

;-334     ah=0x2A;

 mov  ah, 42
;-335     KernelInt();

 call KernelInt
;-336     printunsign(day);

 mov al, byte [day]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-337     putch('.');

 push 46
 call putch
 add  sp, 2
;-338     printunsign(month);

 mov al, byte [month]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-339     putch('.');

 push 46
 call putch
 add  sp, 2
;-340     printunsign(cent);

 mov al, byte [cent]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-341     printunsign(year);

 mov al, byte [year]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-342     putch(' ');

 push 32
 call putch
 add  sp, 2
;-343 

;-344     ah=0x2C;

 mov  ah, 44
;-345     KernelInt();

 call KernelInt
;-346     printunsign(hour);

 mov al, byte [hour]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-347     putch(':');

 push 58
 call putch
 add  sp, 2
;-348     printunsign(min);

 mov al, byte [min]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-349     putch(':');

 push 58
 call putch
 add  sp, 2
;-350     printunsign(sec);

 mov al, byte [sec]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-351     putch(' ');

 push 32
 call putch
 add  sp, 2
;-352 

;-353 

;-354 //    ah=0x30;

;-355 //    KernelInt();

;-356 //    asm mov [vAX], ax

;-357 //    cputs(" KernelVer:");

;-358 //    printhex4(vAX);

;-359 //    putch('.');

;-360 //    vAX=vAX >>8;

;-361 //    printunsign(vAX);

;-362 

;-363 //    ah=0x99;//test error function not found

;-364 //    KernelInt();

;-365     ah=0x4C;//Terminate

 mov  ah, 76
;-366     KernelInt();

 call KernelInt
;-367     cputs(" c18h=");

 push main_0
 call cputs
 add  sp, 2
;-368     printunsign(count18h);

 push word [count18h]
 call printunsign
 add  sp, 2
;-369 }

 ret
main_0 db " c18h=",0
ENDP
;Glob. variables:14 (300), Functions:23 (300), Lines:370
;Constant: 64 (3000), stacksize: 40536