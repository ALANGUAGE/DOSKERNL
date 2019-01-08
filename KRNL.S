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
;-69     asm sti; enable interrupts

 sti; enable interrupts
;-70     if (ah==0x30) {//getDosVer

 cmp  ah, 48
 jne .KERNEL_START6
;-71         ax=0x1403;

 mov  ax, 5123
;-72         asm iret

 iret
;-73     }

;-74     if (ah==0x35) {//getIntVec

.KERNEL_START6:
 cmp  ah, 53
 jne .KERNEL_START7
;-75         asm push ds

 push ds
;-76         bx=0;

 mov  bx, 0
;-77         ds=bx;  //Int table starts at 0000

 mov  ds, bx
;-78         bl=al;

 mov  bl, al
;-79         bx << 2;//int is 4 bytes long

 shl  bx, 2
;-80         asm les bx, [bx];ofs in bx, seg in es

 les bx, [bx];ofs in bx, seg in es
;-81         asm pop ds

 pop ds
;-82         asm iret

 iret
;-83     }

;-84     cputs(" FUNC 18h not impl.");

.KERNEL_START7:
 push KERNEL_START_0
 call cputs
 add  sp, 2
;-85     asm iret

 iret
;-86 }

;-87 unsigned char JmpFarHook=0xEA;//start struct

 ret
KERNEL_START_0 db " FUNC 18h not impl.",0
ENDP
JmpFarHook db 234
;-88 unsigned int VecOldOfs;

VecOldOfs dw 0
;-89 unsigned int VecOldSeg;//end struct

VecOldSeg dw 0
;-90 

;-91 int GetIntVec(char c) {


GetIntVec: PROC
;-92     asm push es
;
 ENTER  0,0
 push es
;-93     al=c;

 mov  al, [bp+4]
;-94     ah=0x35;

 mov  ah, 53
;-95     KernelInt();

 call KernelInt
;-96     asm mov [VecOldOfs], bx

 mov [VecOldOfs], bx
;-97     asm mov [VecOldSeg], es

 mov [VecOldSeg], es
;-98     asm pop es

 pop es
;-99 }

;-100 

;-101 int SetIntVecDos(char *adr) {

 LEAVE
 ret
ENDP

SetIntVecDos: PROC
;-102     asm push ds
;
 ENTER  0,0
 push ds
;-103     ax=cs;

 mov  ax, cs
;-104     ds=ax;

 mov  ds, ax
;-105 //    dx= &adr; is mov instead of lea

;-106     asm lea dx, [bp+4]; *adr

 lea dx, [bp+4]; *adr
;-107     ax=0x2521;//new addr in ds:dx

 mov  ax, 9505
;-108     DosInt();

 call DosInt
;-109     asm pop ds

 pop ds
;-110 }

;-111 /* KERNEL_START not found because it is no variable

;-112 int SetIntVecKrnl(char *adr) {

;-113     asm push ds

;-114     ax=cs;

;-115     ds=ax;

;-116 //    dx= &adr; is mov instead of lea

;-117     asm lea dx, [bp+4]; *adr

;-118     ax=0x2518;//new addr in ds:dx

;-119     DosInt();

;-120     asm pop ds

;-121 }

;-122 */

;-123 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-124     count18h=0;

 mov ax, 0
 mov word [count18h], ax
;-125     //set Int Vec to KERNEL_START

;-126     asm mov dx, KERNEL_START

 mov dx, KERNEL_START
;-127     ax=0x2518;

 mov  ax, 9496
;-128     DosInt();

 call DosInt
;-129 

;-130     GetIntVec(0x18);

 push 24
 call GetIntVec
 add  sp, 2
;-131     cputs("Int18h=");

 push main_0
 call cputs
 add  sp, 2
;-132     printhex16(VecOldSeg);

 push word [VecOldSeg]
 call printhex16
 add  sp, 2
;-133     putch(':');

 push 58
 call putch
 add  sp, 2
;-134     printhex16(VecOldOfs);

 push word [VecOldOfs]
 call printhex16
 add  sp, 2
;-135 

;-136 

;-137 /*

;-138     ah=0x30;

;-139     KernelInt();

;-140     asm mov [vAX], ax

;-141     cputs(" KernelVer:");

;-142     printhex4(vAX);

;-143     putch('.');

;-144     vAX=vAX >>8;

;-145     printunsign(vAX);

;-146 

;-147     ah=0x99;//test error function not found

;-148     KernelInt();

;-149 */

;-150     cputs(" count18h=");

 push main_1
 call cputs
 add  sp, 2
;-151     printunsign(count18h);

 push word [count18h]
 call printunsign
 add  sp, 2
;-152     cputs(" end main.");

 push main_2
 call cputs
 add  sp, 2
;-153 }

 ret
main_0 db "Int18h=",0
main_1 db " count18h=",0
main_2 db " end main.",0
ENDP
;Glob. variables:8 (300), Functions:13 (300), Lines:154
;Constant: 75 (3000), stacksize: 40536