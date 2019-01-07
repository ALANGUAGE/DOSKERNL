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
;-9     bx=0;

 mov  bx, 0
;-10     asm int 16

 int 16
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
;-69     asm sti; enable interrupts

 sti; enable interrupts
;-70     if (ah==0x30) {

 cmp  ah, 48
 jne .KERNEL_START6
;-71         ax=0x1403;

 mov  ax, 5123
;-72         asm iret

 iret
;-73     }

;-74     cputs(" FUNC 18h not impl.");

.KERNEL_START6:
 push KERNEL_START_0
 call cputs
 add  sp, 2
;-75     asm iret

 iret
;-76 }

;-77 unsigned char JmpFarHook=0xEA;//start struct

 ret
KERNEL_START_0 db " FUNC 18h not impl.",0
ENDP
JmpFarHook db 234
;-78 unsigned int VecOldOfs;

VecOldOfs dw 0
;-79 unsigned int VecOldSeg;//end struct

VecOldSeg dw 0
;-80 

;-81 int GetIntVec(char c) {


GetIntVec: PROC
;-82     asm push es
;
 ENTER  0,0
 push es
;-83     al=c;

 mov  al, [bp+4]
;-84     ah=0x35;

 mov  ah, 53
;-85     DosInt();

 call DosInt
;-86     asm mov [VecOldOfs], bx

 mov [VecOldOfs], bx
;-87     asm mov [VecOldSeg], es

 mov [VecOldSeg], es
;-88     asm pop es

 pop es
;-89 }

;-90 

;-91 int SetIntVecDos(char *adr) {

 LEAVE
 ret
ENDP

SetIntVecDos: PROC
;-92     asm push ds
;
 ENTER  0,0
 push ds
;-93     ax=cs;

 mov  ax, cs
;-94     ds=ax;

 mov  ds, ax
;-95 //    dx= &adr; is mov instead of lea

;-96     asm lea dx, [bp+4]; *adr

 lea dx, [bp+4]; *adr
;-97     ax=0x2521;//new addr in ds:dx

 mov  ax, 9505
;-98     DosInt();

 call DosInt
;-99     asm pop ds

 pop ds
;-100 }

;-101 /* KERNEL_START not found because it is no variable

;-102 int SetIntVecKrnl(char *adr) {

;-103     asm push ds

;-104     ax=cs;

;-105     ds=ax;

;-106 //    dx= &adr; is mov instead of lea

;-107     asm lea dx, [bp+4]; *adr

;-108     ax=0x2518;//new addr in ds:dx

;-109     DosInt();

;-110     asm pop ds

;-111 }

;-112 */

;-113 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-114     count18h=0;

 mov ax, 0
 mov word [count18h], ax
;-115     GetIntVec(0x18);

 push 24
 call GetIntVec
 add  sp, 2
;-116 //    cputs("Int18h old=");

;-117 //    printhex16(VecOldSeg);

;-118 //    putch(':');

;-119 //    printhex16(VecOldOfs);

;-120     //set Int Vec to KERNEL_START

;-121     asm mov dx, KERNEL_START

 mov dx, KERNEL_START
;-122     ax=0x2518;

 mov  ax, 9496
;-123     DosInt();

 call DosInt
;-124 

;-125 

;-126 /*    ah=0x30;

;-127     DosInt();

;-128     asm mov [vAX], ax

;-129     cputs(" DosVer:");

;-130     printhex16(vAX);

;-131 */

;-132     ah=0x30;

 mov  ah, 48
;-133     KernelInt();

 call KernelInt
;-134     asm mov [vAX], ax

 mov [vAX], ax
;-135     cputs(" KernelVer:");

 push main_0
 call cputs
 add  sp, 2
;-136     printhex4(vAX);

 push word [vAX]
 call printhex4
 add  sp, 2
;-137     putch('.');

 push 46
 call putch
 add  sp, 2
;-138     vAX=vAX >>8;

 mov ax, [vAX]
 shr ax, 8
 mov word [vAX], ax
;-139     printunsign(vAX);

 push word [vAX]
 call printunsign
 add  sp, 2
;-140 

;-141     cputs(" count18h=");

 push main_1
 call cputs
 add  sp, 2
;-142     printunsign(count18h);

 push word [count18h]
 call printunsign
 add  sp, 2
;-143     cputs(" end main.");

 push main_2
 call cputs
 add  sp, 2
;-144 }

 ret
main_0 db " KernelVer:",0
main_1 db " count18h=",0
main_2 db " end main.",0
ENDP
;Glob. variables:8 (300), Functions:13 (300), Lines:145
;Constant: 79 (3000), stacksize: 40536