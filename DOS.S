;PLA compiler A.COM V0.9.6, Input: DOS.C, Output: DOS.S
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

;-14 char DOS_ERR=0;

DOS_ERR db 0
;-15 unsigned int count21h=0;

count21h dw 0
;-16 

;-17 int writetty()     {


writetty: PROC
;-18     ah=0x0E;

 mov  ah, 14
;-19     bx=0;

 mov  bx, 0
;-20     asm int 16

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
;-24         al=13;

 mov  al, 13
;-25         writetty();

 call writetty
;-26     }

;-27     al=c;

.putch1:
 mov  al, [bp+4]
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

;-39 int printhex4(unsigned char c) {

 LEAVE
 ret
ENDP

printhex4: PROC
;-40     c += 48;
;
 ENTER  0,0
 add  byte[bp+4], 48
;-41     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex44
 add  byte[bp+4], 7
;-42     putch(c);

.printhex44:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-43 }

;-44 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-45     unsigned char nib;

;-46     nib = c >> 4; printhex4(nib);
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
;-47     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-48 }

;-49 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-50     unsigned int half;

;-51     half = i >>  8; printhex8(half);
;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-52     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-53 }

;-54 

;-55 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-56     unsigned int e;

;-57     if (n >= 10) {
;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign5
;-58         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-59         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-60         }

;-61     n=n%10;

.printunsign5:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-62     n+='0';

 add  word[bp+4], 48
;-63     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-64 }

;-65 

;-66 int ShowRegister() {

 LEAVE
 ret
ENDP

ShowRegister: PROC
;-67     asm mov [vAX], ax

 mov [vAX], ax
;-68     asm mov [vBX], bx

 mov [vBX], bx
;-69     asm mov [vCX], cx

 mov [vCX], cx
;-70     asm mov [vDX], dx

 mov [vDX], dx
;-71     asm mov [vSP], sp

 mov [vSP], sp
;-72     asm mov [vBP], bp

 mov [vBP], bp
;-73     asm mov ax, cs

 mov ax, cs
;-74     asm mov [vCS], ax

 mov [vCS], ax
;-75     asm mov ax, ds

 mov ax, ds
;-76     asm mov [vDS], ax

 mov [vDS], ax
;-77     asm mov ax, ss

 mov ax, ss
;-78     asm mov [vSS], ax

 mov [vSS], ax
;-79     asm mov ax, es

 mov ax, es
;-80     asm mov [vES], ax

 mov [vES], ax
;-81     putch(10);

 push 10
 call putch
 add  sp, 2
;-82     cputs( "AX="); printhex16(vAX);

 push ShowRegister_0
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-83     cputs(",BX="); printhex16(vBX);

 push ShowRegister_1
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-84     cputs(",CX="); printhex16(vCX);

 push ShowRegister_2
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-85     cputs(",DX="); printhex16(vDX);

 push ShowRegister_3
 call cputs
 add  sp, 2
 push word [vDX]
 call printhex16
 add  sp, 2
;-86     cputs(",SP="); printhex16(vSP);

 push ShowRegister_4
 call cputs
 add  sp, 2
 push word [vSP]
 call printhex16
 add  sp, 2
;-87     cputs(",BP="); printhex16(vBP);

 push ShowRegister_5
 call cputs
 add  sp, 2
 push word [vBP]
 call printhex16
 add  sp, 2
;-88     cputs(",CS="); printhex16(vCS);

 push ShowRegister_6
 call cputs
 add  sp, 2
 push word [vCS]
 call printhex16
 add  sp, 2
;-89     cputs(",DS="); printhex16(vDS);

 push ShowRegister_7
 call cputs
 add  sp, 2
 push word [vDS]
 call printhex16
 add  sp, 2
;-90     cputs(",SS="); printhex16(vSS);

 push ShowRegister_8
 call cputs
 add  sp, 2
 push word [vSS]
 call printhex16
 add  sp, 2
;-91     cputs(",ES="); printhex16(vES);

 push ShowRegister_9
 call cputs
 add  sp, 2
 push word [vES]
 call printhex16
 add  sp, 2
;-92 }

;-93 

;-94 //Int = pushf + call far

;-95 //Int = pushf + push cs + push offset DOS_START + jmp far cs:VecOldOfs

;-96 int DosInt() {

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

DosInt: PROC
;-97     asm int 33; 21h

 int 33; 21h
;-98     __emit__(0x73, 04); //jnc over DOS_ERR++

 db 115,4
;-99     DOS_ERR++;

 inc  byte[DOS_ERR]
;-100 }

;-101 

;-102 unsigned char JmpFarHook=0xEA;//start struct

 ret
ENDP
JmpFarHook db 234
;-103 unsigned int VecOldOfs;

VecOldOfs dw 0
;-104 unsigned int VecOldSeg;//end struct

VecOldSeg dw 0
;-105 

;-106 int GetIntVec(char c) {


GetIntVec: PROC
;-107     asm push es
;
 ENTER  0,0
 push es
;-108     al=c;

 mov  al, [bp+4]
;-109     ah=0x35;

 mov  ah, 53
;-110     DosInt();

 call DosInt
;-111     asm mov [VecOldOfs], bx

 mov [VecOldOfs], bx
;-112     asm mov [VecOldSeg], es

 mov [VecOldSeg], es
;-113     asm pop es

 pop es
;-114 }

;-115 

;-116 unsigned int VecNewOfs;

 LEAVE
 ret
ENDP
VecNewOfs dw 0
;-117 unsigned int VecNewSeg;

VecNewSeg dw 0
;-118 

;-119 int GetIntVecNew(char c) {


GetIntVecNew: PROC
;-120     asm push es
;
 ENTER  0,0
 push es
;-121     al=c;

 mov  al, [bp+4]
;-122     ah=0x35;

 mov  ah, 53
;-123     DosInt();

 call DosInt
;-124     asm mov [VecNewOfs], bx

 mov [VecNewOfs], bx
;-125     asm mov [VecNewSeg], es

 mov [VecNewSeg], es
;-126     asm pop es

 pop es
;-127 }

;-128 /*

;-129 int SetIntVecDos(char *adr) {

;-130     asm push ds

;-131     ax=cs;

;-132     ds=ax;

;-133 //    dx= &adr; is mov instead of lea

;-134     asm lea dx, [bp+4]; *adr

;-135     ax=0x2521;//new addr in ds:dx

;-136     DosInt();

;-137     asm pop ds

;-138 }

;-139 */

;-140 unsigned int DS_old;

 LEAVE
 ret
ENDP
DS_old dw 0
;-141 

;-142 int DOS_START() {


DOS_START: PROC
;-143     count21h++;

 inc  word[count21h]
;-144     if (ah != 0x80) {

 cmp  ah, 128
 je  .DOS_START6
;-145         asm jmp JmpFarHook; goto old kernel

 jmp JmpFarHook; goto old kernel
;-146     }

;-147         ax=ds;

.DOS_START6:
 mov  ax, ds
;-148         __emit__(0x2E);//cs seg for next instruction

 db 46
;-149         asm mov [DS_old], ax

 mov [DS_old], ax
;-150         ax=cs;// cs seg is the only seg we know the value

 mov  ax, cs
;-151         ds=ax;

 mov  ds, ax
;-152 

;-153         asm sti; enable interrupts

 sti; enable interrupts
;-154         cputs("Inside DOS_START:");

 push DOS_START_0
 call cputs
 add  sp, 2
;-155         ShowRegister();

 call ShowRegister
;-156 

;-157         cputs(" count21h=");

 push DOS_START_1
 call cputs
 add  sp, 2
;-158         printunsign(count21h);

 push word [count21h]
 call printunsign
 add  sp, 2
;-159         cputs(" DS: old=");

 push DOS_START_2
 call cputs
 add  sp, 2
;-160         printunsign(DS_old);

 push word [DS_old]
 call printunsign
 add  sp, 2
;-161 

;-162         ax=DS_old;//restore ds Seg

 mov  ax, [DS_old]
;-163         ds=ax;

 mov  ds, ax
;-164         asm iret

 iret
;-165 }

;-166 

;-167 int setblock(unsigned int i) {

 ret
DOS_START_0 db "Inside DOS_START:",0
DOS_START_1 db " count21h=",0
DOS_START_2 db " DS: old=",0
ENDP

setblock: PROC
;-168     DOS_ERR=0;
;
 ENTER  0,0
 mov ax, 0
 mov byte [DOS_ERR], al
;-169     bx=i;

 mov  bx, [bp+4]
;-170     ax=cs;

 mov  ax, cs
;-171     es=ax;

 mov  es, ax
;-172     ax=0x4A00;

 mov  ax, 18944
;-173     //modify mem Alloc. IN: ES=Block Seg, BX=size in para

;-174     DosInt();

 call DosInt
;-175     asm mov [vAX], ax

 mov [vAX], ax
;-176     asm mov [vBX], bx

 mov [vBX], bx
;-177     if (DOS_ERR) cputs(" ***Error SetBlock***");

 mov al, [DOS_ERR]
 or  al, al
 je .setblock7
 push setblock_0
 call cputs
 add  sp, 2
;-178     cputs("SetBlock AX:"); printhex16(vAX);

.setblock7:
 push setblock_1
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-179     cputs(",BX:"); printhex16(vBX);

 push setblock_2
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-180 }

;-181 

;-182 int main() {

 LEAVE
 ret
setblock_0 db " ***Error SetBlock***",0
setblock_1 db "SetBlock AX:",0
setblock_2 db ",BX:",0
ENDP

main: PROC
;-183     DOS_ERR = 0;

 mov ax, 0
 mov byte [DOS_ERR], al
;-184     setblock(4096);// 64KB

 push 4096
 call setblock
 add  sp, 2
;-185 

;-186     GetIntVec(0x21);

 push 33
 call GetIntVec
 add  sp, 2
;-187     cputs(" Main Int21h old=");

 push main_0
 call cputs
 add  sp, 2
;-188     printhex16(VecOldSeg);

 push word [VecOldSeg]
 call printhex16
 add  sp, 2
;-189     putch(':');

 push 58
 call putch
 add  sp, 2
;-190     printhex16(VecOldOfs);

 push word [VecOldOfs]
 call printhex16
 add  sp, 2
;-191 

;-192     asm mov dx, DOS_START

 mov dx, DOS_START
;-193 //    asm lea dx, [DOS_START]

;-194     ax=0x2521;

 mov  ax, 9505
;-195     DosInt();

 call DosInt
;-196     ShowRegister();

 call ShowRegister
;-197 

;-198     GetIntVecNew(0x21);

 push 33
 call GetIntVecNew
 add  sp, 2
;-199     cputs(" Int21h new=");

 push main_1
 call cputs
 add  sp, 2
;-200     printhex16(VecNewSeg);

 push word [VecNewSeg]
 call printhex16
 add  sp, 2
;-201     putch(':');

 push 58
 call putch
 add  sp, 2
;-202     printhex16(VecNewOfs);

 push word [VecNewOfs]
 call printhex16
 add  sp, 2
;-203 

;-204     cputs(" count21h=");

 push main_2
 call cputs
 add  sp, 2
;-205     printunsign(count21h);

 push word [count21h]
 call printunsign
 add  sp, 2
;-206     cputs(" end main.");

 push main_3
 call cputs
 add  sp, 2
;-207 

;-208     asm int 32;20h exit

 int 32;20h exit
;-209 

;-210     asm mov dx, main;get adr of main in dx//Terminate stay resident

 mov dx, main;get adr of main in dx//Terminate stay resident
;-211     asm shr dx, 4   ;make para

 shr dx, 4   ;make para
;-212     asm add dx, 17  ;PSP in para + align to next para

 add dx, 17  ;PSP in para + align to next para
;-213     ax=0x3100;

 mov  ax, 12544
;-214     DosInt();

 call DosInt
;-215 }

 ret
main_0 db " Main Int21h old=",0
main_1 db " Int21h new=",0
main_2 db " count21h=",0
main_3 db " end main.",0
ENDP
;Glob. variables:19 (300), Functions:14 (300), Lines:216
;Constant: 279 (3000), stacksize: 40536