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
;-6 

;-7 int writetty()     {//char in AL


writetty: PROC
;-8     ah=0x0E;

 mov  ah, 14
;-9     bx=0;     //page

 mov  bx, 0
;-10     inth 0x10;

 int  16
;-11 }

;-12 int putch(char c)  {

 ret
ENDP

putch: PROC
;-13     if (c==10)  {
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-14         al=13;

 mov  al, 13
;-15         writetty();

 call writetty
;-16     }

;-17     al=c;

.putch1:
 mov  al, [bp+4]
;-18     writetty();

 call writetty
;-19 }

;-20 int cputs(char *s) {//only with correct DS !!!

 LEAVE
 ret
ENDP

cputs: PROC
;-21     char c;

;-22     while(*s) {
;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-23         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-24         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-25         s++;

 inc  word[bp+4]
;-26     }

;-27 }

 jmp .cputs2
.cputs3:
;-28 

;-29 int printhex4(unsigned char c) {

 LEAVE
 ret
ENDP

printhex4: PROC
;-30     c += 48;
;
 ENTER  0,0
 add  byte[bp+4], 48
;-31     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex44
 add  byte[bp+4], 7
;-32     putch(c);

.printhex44:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-33 }

;-34 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-35     unsigned char nib;

;-36     nib = c >> 4; printhex4(nib);
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
;-37     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-38 }

;-39 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-40     unsigned int half;

;-41     half = i >>  8; printhex8(half);
;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-42     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-43 }

;-44 

;-45 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-46     unsigned int e;

;-47     if (n >= 10) {
;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign5
;-48         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-49         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-50         }

;-51     n=n%10;

.printunsign5:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-52     n+='0';

 add  word[bp+4], 48
;-53     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-54 }

;-55 

;-56 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-57     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-58     inth 0x16;//AH=Scan code, AL=char

 int  22
;-59 }

;-60 int waitkey() {

 ret
ENDP

waitkey: PROC
;-61     ah=0x11;//get kbd status

 mov  ah, 17
;-62     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-63     //zero flag: 0=IS char, 1=NO char

;-64     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-65 }

;-66 int getkey() {

 ret
ENDP

getkey: PROC
;-67     waitkey();

 call waitkey
;-68     getch();

 call getch
;-69     ah=0;//clear scan code

 mov  ah, 0
;-70     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-71     //put ext code in AX

;-72 }

.getkey6:
;-73 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-74     getkey();

 call getkey
;-75     writetty();

 call writetty
;-76 }

;-77 

;-78 int DosInt() {

 ret
ENDP

DosInt: PROC
;-79     inth 0x21;

 int  33
;-80     __emit__(0x73, 04); //jnc over DOS_ERR++

 db 115,4
;-81     DOS_ERR++;

 inc  byte[DOS_ERR]
;-82 }

;-83 int KernelInt() {

 ret
ENDP

KernelInt: PROC
;-84     inth 0x18;

 int  24
;-85     __emit__(0x73, 04); //jnc over KERNEL_ERR++

 db 115,4
;-86     KERNEL_ERR++;

 inc  byte[KERNEL_ERR]
;-87 }

;-88 

;-89 int KERNEL_START() {

 ret
ENDP

KERNEL_START: PROC
;-90     count18h++;

 inc  word[count18h]
;-91     asm sti; set int enable

 sti; set int enable
;-92 

;-93     if (ah==0x25) {//setIntVec in AL from DS:DX

 cmp  ah, 37
 jne .KERNEL_START7
;-94         asm cli; clear int enable, turn OFF int

 cli; clear int enable, turn OFF int
;-95         asm push ax

 push ax
;-96         asm push es

 push es
;-97         asm push di

 push di
;-98         asm push ds; later pop ax

 push ds; later pop ax
;-99         ax << 2;

 shl  ax, 2
;-100         ah=0;

 mov  ah, 0
;-101         di=ax;

 mov  di, ax
;-102         ax=0;

 mov  ax, 0
;-103         es=ax;//segment 0

 mov  es, ax
;-104         ax=dx;

 mov  ax, dx
;-105         asm cld; clear direction, Up

 cld; clear direction, Up
;-106         asm stosw; ofs in DX to ES:DI

 stosw; ofs in DX to ES:DI
;-107         asm pop ax; get DS

 pop ax; get DS
;-108         asm stosw; seg (DS) to ES:DI+2

 stosw; seg (DS) to ES:DI+2
;-109         asm pop di

 pop di
;-110         asm pop es

 pop es
;-111         asm pop ax

 pop ax
;-112         asm sti;set int enable, turn ON int

 sti;set int enable, turn ON int
;-113         asm iret

 iret
;-114     }

;-115     if (ah==0x30) {//getDosVer

.KERNEL_START7:
 cmp  ah, 48
 jne .KERNEL_START8
;-116         ax=0x1E03; //Ver 3.30

 mov  ax, 7683
;-117         asm iret

 iret
;-118     }

;-119     if (ah==0x35) {//getIntVec in AL to ES:BX

.KERNEL_START8:
 cmp  ah, 53
 jne .KERNEL_START9
;-120         asm cli; clear int enable, turn OFF int

 cli; clear int enable, turn OFF int
;-121         asm push ds

 push ds
;-122         bx=0;

 mov  bx, 0
;-123         ds=bx;  //Int table starts at 0000

 mov  ds, bx
;-124         bl=al;

 mov  bl, al
;-125         bx << 2;//int is 4 bytes long

 shl  bx, 2
;-126         asm les bx, [bx]; ofs in bx, seg in es

 les bx, [bx]; ofs in bx, seg in es
;-127         asm pop ds

 pop ds
;-128         asm sti; set int enable, turn ON int

 sti; set int enable, turn ON int
;-129         asm iret

 iret
;-130     }

;-131     cputs(" FUNC 18h not impl.");

.KERNEL_START9:
 push KERNEL_START_0
 call cputs
 add  sp, 2
;-132     asm iret

 iret
;-133 }

;-134 unsigned int VecOldOfs;

 ret
KERNEL_START_0 db " FUNC 18h not impl.",0
ENDP
VecOldOfs dw 0
;-135 unsigned int VecOldSeg;

VecOldSeg dw 0
;-136 

;-137 int GetIntVec(char c) {


GetIntVec: PROC
;-138     asm push es
;
 ENTER  0,0
 push es
;-139     al=c;

 mov  al, [bp+4]
;-140     ah=0x35;

 mov  ah, 53
;-141     KernelInt();

 call KernelInt
;-142     asm mov [VecOldOfs], bx

 mov [VecOldOfs], bx
;-143     asm mov [VecOldSeg], es

 mov [VecOldSeg], es
;-144     asm pop es

 pop es
;-145 }

;-146 

;-147 int GetDate() {

 LEAVE
 ret
ENDP

GetDate: PROC
;-148     int year;char month;char day;char dayofweek;

;-149     ah=0x2A;
;
 ENTER  8,0
 mov  ah, 42
;-150     DosInt();

 call DosInt
;-151     asm mov [bp-2], cx; year

 mov [bp-2], cx; year
;-152     asm mov [bp-4], dh; month

 mov [bp-4], dh; month
;-153     asm mov [bp-6], dl; day

 mov [bp-6], dl; day
;-154     asm mov [bp-8], al; dayofweek

 mov [bp-8], al; dayofweek
;-155     printunsign(dayofweek);

 mov al, byte [bp-8]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-156     putch(':');

 push 58
 call putch
 add  sp, 2
;-157     printunsign(day);

 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-158     putch('.');

 push 46
 call putch
 add  sp, 2
;-159     printunsign(month);

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-160     putch('.');

 push 46
 call putch
 add  sp, 2
;-161     printunsign(year);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-162 }

;-163 

;-164 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-165     count18h=0;

 mov ax, 0
 mov word [count18h], ax
;-166     //set Int Vec to KERNEL_START

;-167     asm mov dx, KERNEL_START

 mov dx, KERNEL_START
;-168     ax=0x2518;

 mov  ax, 9496
;-169 //    DosInt();

;-170     KernelInt();

 call KernelInt
;-171 

;-172     GetDate();

 call GetDate
;-173 //    cputs(datestr);

;-174 //    putch(' ');

;-175 

;-176 /*    GetIntVec(0x18);

;-177     cputs("Int18h=");

;-178     printhex16(VecOldSeg);

;-179     putch(':');

;-180     printhex16(VecOldOfs);

;-181 */

;-182 

;-183 /*

;-184     ah=0x30;

;-185     KernelInt();

;-186     asm mov [vAX], ax

;-187     cputs(" KernelVer:");

;-188     printhex4(vAX);

;-189     putch('.');

;-190     vAX=vAX >>8;

;-191     printunsign(vAX);

;-192 */

;-193 //    ah=0x99;//test error function not found

;-194 //    KernelInt();

;-195 

;-196     cputs(" c18h=");

 push main_0
 call cputs
 add  sp, 2
;-197     printunsign(count18h);

 push word [count18h]
 call printunsign
 add  sp, 2
;-198 }

 ret
main_0 db " c18h=",0
ENDP
;Glob. variables:7 (300), Functions:17 (300), Lines:199
;Constant: 43 (3000), stacksize: 40536