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

;-7 int writetty()     {


writetty: PROC
;-8     ah=0x0E;

 mov  ah, 14
;-9     bx=0;     //

 mov  bx, 0
;-10     asm int 16 ;int 10h

 int 16 ;int 10h
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

;-20 int cputs(char *s) {

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

;-56 int DosInt() {

 LEAVE
 ret
ENDP

DosInt: PROC
;-57     asm int 33; 21h

 int 33; 21h
;-58     __emit__(0x73, 04); //jnc over DOS_ERR++

 db 115,4
;-59     DOS_ERR++;

 inc  byte[DOS_ERR]
;-60 }

;-61 int KernelInt() {

 ret
ENDP

KernelInt: PROC
;-62     asm int 24; 18h

 int 24; 18h
;-63     __emit__(0x73, 04); //jnc over KERNEL_ERR++

 db 115,4
;-64     KERNEL_ERR++;

 inc  byte[KERNEL_ERR]
;-65 }

;-66 

;-67 int KERNEL_START() {

 ret
ENDP

KERNEL_START: PROC
;-68     count18h++;

 inc  word[count18h]
;-69     asm sti; set int enable

 sti; set int enable
;-70     if (ah==0x25) {//setIntVec in AL from DS:DX

 cmp  ah, 37
 jne .KERNEL_START6
;-71         asm cli; clear int enable, turn OFF int

 cli; clear int enable, turn OFF int
;-72         asm push ax

 push ax
;-73         asm push es

 push es
;-74         asm push di

 push di
;-75         asm push ds; later pop ax

 push ds; later pop ax
;-76         ax << 2;

 shl  ax, 2
;-77         ah=0;

 mov  ah, 0
;-78         di=ax;

 mov  di, ax
;-79         ax=0;

 mov  ax, 0
;-80         es=ax;//segment 0

 mov  es, ax
;-81         ax=dx;

 mov  ax, dx
;-82         asm cld; clear direction, Up

 cld; clear direction, Up
;-83         asm stosw; ofs in DX to ES:DI

 stosw; ofs in DX to ES:DI
;-84         asm pop ax; get DS

 pop ax; get DS
;-85         asm stosw; seg (DS) to ES:DI+2

 stosw; seg (DS) to ES:DI+2
;-86         asm pop di

 pop di
;-87         asm pop es

 pop es
;-88         asm pop ax

 pop ax
;-89         asm sti;set int enable, turn ON int

 sti;set int enable, turn ON int
;-90         asm iret

 iret
;-91     }

;-92     if (ah==0x30) {//getDosVer

.KERNEL_START6:
 cmp  ah, 48
 jne .KERNEL_START7
;-93         ax=0x1E03; //Ver 3.30

 mov  ax, 7683
;-94         asm iret

 iret
;-95     }

;-96     if (ah==0x35) {//getIntVec in AL to ES:BX

.KERNEL_START7:
 cmp  ah, 53
 jne .KERNEL_START8
;-97         asm cli; clear int enable, turn OFF int

 cli; clear int enable, turn OFF int
;-98         asm push ds

 push ds
;-99         bx=0;

 mov  bx, 0
;-100         ds=bx;  //Int table starts at 0000

 mov  ds, bx
;-101         bl=al;

 mov  bl, al
;-102         bx << 2;//int is 4 bytes long

 shl  bx, 2
;-103         asm les bx, [bx]; ofs in bx, seg in es

 les bx, [bx]; ofs in bx, seg in es
;-104         asm pop ds

 pop ds
;-105         asm sti; set int enable, turn ON int

 sti; set int enable, turn ON int
;-106         asm iret

 iret
;-107     }

;-108     cputs(" FUNC 18h not impl.");

.KERNEL_START8:
 push KERNEL_START_0
 call cputs
 add  sp, 2
;-109     asm iret

 iret
;-110 }

;-111 unsigned int VecOldOfs;

 ret
KERNEL_START_0 db " FUNC 18h not impl.",0
ENDP
VecOldOfs dw 0
;-112 unsigned int VecOldSeg;

VecOldSeg dw 0
;-113 

;-114 int GetIntVec(char c) {


GetIntVec: PROC
;-115     asm push es
;
 ENTER  0,0
 push es
;-116     al=c;

 mov  al, [bp+4]
;-117     ah=0x35;

 mov  ah, 53
;-118     KernelInt();

 call KernelInt
;-119     asm mov [VecOldOfs], bx

 mov [VecOldOfs], bx
;-120     asm mov [VecOldSeg], es

 mov [VecOldSeg], es
;-121     asm pop es

 pop es
;-122 }

;-123 

;-124 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-125     count18h=0;

 mov ax, 0
 mov word [count18h], ax
;-126     //set Int Vec to KERNEL_START

;-127     asm mov dx, KERNEL_START

 mov dx, KERNEL_START
;-128     ax=0x2518;

 mov  ax, 9496
;-129 //    DosInt();

;-130     KernelInt();

 call KernelInt
;-131     

;-132     GetIntVec(0x18);

 push 24
 call GetIntVec
 add  sp, 2
;-133     cputs("Int18h=");

 push main_0
 call cputs
 add  sp, 2
;-134     printhex16(VecOldSeg);

 push word [VecOldSeg]
 call printhex16
 add  sp, 2
;-135     putch(':');

 push 58
 call putch
 add  sp, 2
;-136     printhex16(VecOldOfs);

 push word [VecOldOfs]
 call printhex16
 add  sp, 2
;-137 

;-138 

;-139 /*

;-140     ah=0x30;

;-141     KernelInt();

;-142     asm mov [vAX], ax

;-143     cputs(" KernelVer:");

;-144     printhex4(vAX);

;-145     putch('.');

;-146     vAX=vAX >>8;

;-147     printunsign(vAX);

;-148 

;-149     ah=0x99;//test error function not found

;-150     KernelInt();

;-151 */

;-152     cputs(" count18h=");

 push main_1
 call cputs
 add  sp, 2
;-153     printunsign(count18h);

 push word [count18h]
 call printunsign
 add  sp, 2
;-154 //    cputs(" end main.");

;-155 }

 ret
main_0 db "Int18h=",0
main_1 db " count18h=",0
ENDP
;Glob. variables:7 (300), Functions:12 (300), Lines:156
;Constant: 49 (3000), stacksize: 40536