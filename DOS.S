;PLA comp. A.COM V0.9.5, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.1.1";//IO.SYS and MSDS.SYS for 1OS

Version1 db "DOS.COM V0.1.1",0
;-2 //todo: resize and take own stack

;-3 unsigned int vAX;

vAX dw 0
;-4 unsigned int vBX;

vBX dw 0
;-5 unsigned int vCX;

vCX dw 0
;-6 unsigned int vDX;

vDX dw 0
;-7 unsigned int vSP;

vSP dw 0
;-8 unsigned int vBP;

vBP dw 0
;-9 unsigned int vCS;

vCS dw 0
;-10 unsigned int vDS;

vDS dw 0
;-11 unsigned int vSS;

vSS dw 0
;-12 unsigned int vES;

vES dw 0
;-13 

;-14 int DOS_ERR=0;

DOS_ERR dw 0
;-15 unsigned int count21h=0;

count21h dw 0
;-16 

;-17 int writetty()     {//ah=0x0E; bx=0; __emit__(0xCD,0x10);


writetty: PROC
;-18 asm mov ah, 14

 mov ah, 14
;-19 asm mov bx, 0

 mov bx, 0
;-20 asm int 16

 int 16
;-21 }

;-22 int putch(char c)  {

 ret
ENDP

putch: PROC
;-23     if (c==10)  {
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-24         asm mov al, 13

 mov al, 13
;-25         writetty();

 call writetty
;-26     }

;-27     asm mov al, [bp+4]; parameter c

.putch1:
 mov al, [bp+4]; parameter c
;-28     writetty();

 call writetty
;-29 }

;-30 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-31     char c;

;-32     while(*s) {
;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-33         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-34         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-35         s++;

 inc  word[bp+4]
;-36     }

;-37 }

 jmp .cputs2
.cputs3:
;-38 

;-39 //Int = pushf + call far

;-40 //Int = pushf + push cs + push offset DOS_START + jmp far cs:VecOldOfs

;-41 int DosInt() {

 LEAVE
 ret
ENDP

DosInt: PROC
;-42     asm int 33; 21h

 int 33; 21h
;-43     __emit__(0x73, 04); //jnc over DOS_ERR++

 db 115,4
;-44     DOS_ERR++;

 inc  word[DOS_ERR]
;-45 }

;-46 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-47     c += 48;
;
 ENTER  0,0
 add  byte[bp+4], 48
;-48     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex44
 add  byte[bp+4], 7
;-49     putch(c);

.printhex44:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-50 }

;-51 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-52     unsigned char nib;

;-53     nib = c >> 4; printhex4(nib);
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
;-54     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-55 }

;-56 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-57     unsigned int half;

;-58     half = i >>  8; printhex8(half);
;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-59     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-60 }

;-61 

;-62 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-63     unsigned int e;

;-64     if (n >= 10) {
;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign5
;-65         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-66         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-67         }

;-68     n=n%10;

.printunsign5:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-69     n+='0';

 add  word[bp+4], 48
;-70     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-71 }

;-72 

;-73 int ShowRegister() {

 LEAVE
 ret
ENDP

ShowRegister: PROC
;-74     asm mov [vAX], ax

 mov [vAX], ax
;-75     asm mov [vBX], bx

 mov [vBX], bx
;-76     asm mov [vCX], cx

 mov [vCX], cx
;-77     asm mov [vDX], dx

 mov [vDX], dx
;-78     asm mov [vSP], sp

 mov [vSP], sp
;-79     asm mov [vBP], bp

 mov [vBP], bp
;-80     asm mov ax, cs

 mov ax, cs
;-81     asm mov [vCS], ax

 mov [vCS], ax
;-82     asm mov ax, ds

 mov ax, ds
;-83     asm mov [vDS], ax

 mov [vDS], ax
;-84     asm mov ax, ss

 mov ax, ss
;-85     asm mov [vSS], ax

 mov [vSS], ax
;-86     asm mov ax, es

 mov ax, es
;-87     asm mov [vES], ax

 mov [vES], ax
;-88     putch(10);

 push 10
 call putch
 add  sp, 2
;-89     cputs( "AX="); printhex16(vAX);

 push ShowRegister_0
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-90     cputs(",BX="); printhex16(vBX);

 push ShowRegister_1
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-91     cputs(",CX="); printhex16(vCX);

 push ShowRegister_2
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-92     cputs(",DX="); printhex16(vDX);

 push ShowRegister_3
 call cputs
 add  sp, 2
 push word [vDX]
 call printhex16
 add  sp, 2
;-93     cputs(",SP="); printhex16(vSP);

 push ShowRegister_4
 call cputs
 add  sp, 2
 push word [vSP]
 call printhex16
 add  sp, 2
;-94     cputs(",BP="); printhex16(vBP);

 push ShowRegister_5
 call cputs
 add  sp, 2
 push word [vBP]
 call printhex16
 add  sp, 2
;-95     cputs(",CS="); printhex16(vCS);

 push ShowRegister_6
 call cputs
 add  sp, 2
 push word [vCS]
 call printhex16
 add  sp, 2
;-96     cputs(",DS="); printhex16(vDS);

 push ShowRegister_7
 call cputs
 add  sp, 2
 push word [vDS]
 call printhex16
 add  sp, 2
;-97     cputs(",SS="); printhex16(vSS);

 push ShowRegister_8
 call cputs
 add  sp, 2
 push word [vSS]
 call printhex16
 add  sp, 2
;-98     cputs(",ES="); printhex16(vES);

 push ShowRegister_9
 call cputs
 add  sp, 2
 push word [vES]
 call printhex16
 add  sp, 2
;-99 }

;-100 

;-101 unsigned char JmpFarHook=0xEA;//start struct

 ret
ShowRegister_0 db "AX=",0
ShowRegister_1 db ",BX=",0
ShowRegister_2 db ",CX=",0
ShowRegister_3 db ",DX=",0
ShowRegister_4 db ",SP=",0
ShowRegister_5 db ",BP=",0
ShowRegister_6 db ",CS=",0
ShowRegister_7 db ",DS=",0
ShowRegister_8 db ",SS=",0
ShowRegister_9 db ",ES=",0
ENDP
JmpFarHook db 234
;-102 unsigned int VecOldOfs;

VecOldOfs dw 0
;-103 unsigned int VecOldSeg;//end struct

VecOldSeg dw 0
;-104 

;-105 int GetIntVec(char c) {


GetIntVec: PROC
;-106     asm push es
;
 ENTER  0,0
 push es
;-107     asm mov al, [bp+4]; c

 mov al, [bp+4]; c
;-108     asm mov ah, 53; 0x35

 mov ah, 53; 0x35
;-109     DosInt();

 call DosInt
;-110     asm mov [VecOldOfs], bx

 mov [VecOldOfs], bx
;-111     asm mov [VecOldSeg], es

 mov [VecOldSeg], es
;-112     asm pop es

 pop es
;-113 }

;-114 

;-115 unsigned int VecNewOfs;

 LEAVE
 ret
ENDP
VecNewOfs dw 0
;-116 unsigned int VecNewSeg;

VecNewSeg dw 0
;-117 

;-118 int GetIntVecNew(char c) {


GetIntVecNew: PROC
;-119     asm push es
;
 ENTER  0,0
 push es
;-120     asm mov al, [bp+4];  c

 mov al, [bp+4];  c
;-121     asm mov ah, 53; 0x35

 mov ah, 53; 0x35
;-122     DosInt();

 call DosInt
;-123     asm mov [VecNewOfs], bx

 mov [VecNewOfs], bx
;-124     asm mov [VecNewSeg], es

 mov [VecNewSeg], es
;-125     asm pop es

 pop es
;-126 }

;-127 

;-128 unsigned int DS_old;

 LEAVE
 ret
ENDP
DS_old dw 0
;-129 

;-130 int DOS_START() {


DOS_START: PROC
;-131     char c;

;-132     count21h++;
;
 ENTER  2,0
 inc  word[count21h]
;-133     asm mov [bp-2], ah; c

 mov [bp-2], ah; c
;-134     if (c != 0x80) {

 mov al, [bp-2]
 cmp al, 128
 je  .DOS_START6
;-135         asm jmp JmpFarHook; goto new kernel

 jmp JmpFarHook; goto new kernel
;-136     }

;-137         asm mov ax, ds

.DOS_START6:
 mov ax, ds
;-138         __emit__(0x2E);//cs seg for next instruction

 db 46
;-139         asm mov [DS_old], ax

 mov [DS_old], ax
;-140         asm mov ax, cs; cs seg is the only seg we know the value

 mov ax, cs; cs seg is the only seg we know the value
;-141         asm mov ds, ax

 mov ds, ax
;-142 

;-143         asm sti; enable interrupts

 sti; enable interrupts
;-144         cputs("Inside DOS_START:");

 push DOS_START_0
 call cputs
 add  sp, 2
;-145         ShowRegister();

 call ShowRegister
;-146 

;-147         cputs(" count21h=");

 push DOS_START_1
 call cputs
 add  sp, 2
;-148         printunsign(count21h);

 push word [count21h]
 call printunsign
 add  sp, 2
;-149         cputs(" DS: old=");

 push DOS_START_2
 call cputs
 add  sp, 2
;-150         printunsign(DS_old);

 push word [DS_old]
 call printunsign
 add  sp, 2
;-151 

;-152         asm mov ax, DS_old;//restore ds Seg

 mov ax, DS_old;//restore ds Seg
;-153         asm mov ds, ax

 mov ds, ax
;-154         asm iret

 iret
;-155 }

;-156 

;-157 int setblock(unsigned int i) {

 LEAVE
 ret
DOS_START_0 db "Inside DOS_START:",0
DOS_START_1 db " count21h=",0
DOS_START_2 db " DS: old=",0
ENDP

setblock: PROC
;-158     DOS_ERR=0;
;
 ENTER  0,0
 mov ax, 0
 mov word [DOS_ERR], ax
;-159     asm mov bx, [bp+4]; i

 mov bx, [bp+4]; i
;-160     asm mov ax, cs

 mov ax, cs
;-161     asm mov es, ax

 mov es, ax
;-162     asm mov ax, 18944; 0x4A00

 mov ax, 18944; 0x4A00
;-163     //modify mem Alloc. IN: ES=Block Seg, BX=size in para

;-164     DosInt();

 call DosInt
;-165     asm mov [vAX], ax

 mov [vAX], ax
;-166     asm mov [vBX], bx

 mov [vBX], bx
;-167     if (DOS_ERR) cputs(" ***Error SetBlock***");

 mov ax, [DOS_ERR]
 or  al, al
 je .setblock7
 push setblock_0
 call cputs
 add  sp, 2
;-168 //    cputs("SetBlock AX:"); printhex16(vAX);

;-169 //    cputs(",BX:"); printhex16(vBX);

;-170 }

.setblock7:
;-171 

;-172 int TermStayRes(char *s) {

 LEAVE
 ret
setblock_0 db " ***Error SetBlock***",0
ENDP

TermStayRes: PROC
;-173     asm mov  dx, [bp+4]; dx = s; get adr of main in dx
;
 ENTER  0,0
 mov  dx, [bp+4]; dx = s; get adr of main in dx
;-174     asm shr  dx, 4; dx >> 4;  make paragraph

 shr  dx, 4; dx >> 4;  make paragraph
;-175     asm inc dx  ;dx ++;

 inc dx  ;dx ++;
;-176     asm mov ax, 12544;  0x3100

 mov ax, 12544;  0x3100
;-177     DosInt();

 call DosInt
;-178 }

;-179 

;-180 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-181     DOS_ERR = 0;

 mov ax, 0
 mov word [DOS_ERR], ax
;-182     setblock(4096);

 push 4096
 call setblock
 add  sp, 2
;-183 

;-184     GetIntVec(0x21);

 push 33
 call GetIntVec
 add  sp, 2
;-185     cputs(" Main Int21h old=");

 push main_0
 call cputs
 add  sp, 2
;-186     printhex16(VecOldSeg);

 push word [VecOldSeg]
 call printhex16
 add  sp, 2
;-187     putch(':');

 push 58
 call putch
 add  sp, 2
;-188     printhex16(VecOldOfs);

 push word [VecOldOfs]
 call printhex16
 add  sp, 2
;-189 

;-190     asm mov dx, DOS_START ;put adr in dx

 mov dx, DOS_START ;put adr in dx
;-191     asm mov ax, 9505; 0x2521 SetIntVec, assume ds=cs

 mov ax, 9505; 0x2521 SetIntVec, assume ds=cs
;-192     DosInt();

 call DosInt
;-193     ShowRegister();

 call ShowRegister
;-194 

;-195     GetIntVecNew(0x21);

 push 33
 call GetIntVecNew
 add  sp, 2
;-196     cputs(" Int21h new=");

 push main_1
 call cputs
 add  sp, 2
;-197     printhex16(VecNewSeg);

 push word [VecNewSeg]
 call printhex16
 add  sp, 2
;-198     putch(':');

 push 58
 call putch
 add  sp, 2
;-199     printhex16(VecNewOfs);

 push word [VecNewOfs]
 call printhex16
 add  sp, 2
;-200 

;-201     cputs(" count21h=");

 push main_2
 call cputs
 add  sp, 2
;-202     printunsign(count21h);

 push word [count21h]
 call printunsign
 add  sp, 2
;-203 

;-204     asm mov dx, main;get adr of main in dx//Terminate stay resident

 mov dx, main;get adr of main in dx//Terminate stay resident
;-205     asm shr dx, 4   ;make para

 shr dx, 4   ;make para
;-206     asm inc dx      ;align to next para

 inc dx      ;align to next para
;-207     asm mov ax, 12544; 0x3100

 mov ax, 12544; 0x3100
;-208     DosInt();

 call DosInt
;-209 }

 ret
main_0 db " Main Int21h old=",0
main_1 db " Int21h new=",0
main_2 db " count21h=",0
ENDP
;Glob. variables:19 (400), Functions:15 (400), Lines:210
;Constant: 279 (3000), stacksize: 40536