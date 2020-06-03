;PLA compiler A.COM V1.0.1, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.1.2";//test bed

Version1 db "DOS.COM V0.1.2",0
;-2 //todo: resize and take own stack

;-3 #define ORGDATA		4096//start of arrays

;-4 unsigned int vAX;

vAX dw 0
;-5 unsigned int vBX;

vBX dw 0
;-6 unsigned int vCX;

vCX dw 0
;-7 unsigned int vDX;

vDX dw 0
;-8 unsigned int vSP;

vSP dw 0
;-9 unsigned int vBP;

vBP dw 0
;-10 unsigned int vCS;

vCS dw 0
;-11 unsigned int vDS;

vDS dw 0
;-12 unsigned int vSS;

vSS dw 0
;-13 unsigned int vES;

vES dw 0
;-14 

;-15 int writetty()     {


writetty: PROC
;-16     ah=0x0E;

 mov  ah, 14
;-17     bx=0;

 mov  bx, 0
;-18     asm int 16

 int 16
;-19 }

;-20 int putch(char c)  {

 ret
ENDP

putch: PROC
;-21     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;12 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-22         al=13;

 mov  al, 13
;-23         writetty();

 call writetty
;-24     }

;-25     al=c;

.putch1:
 mov  al, [bp+4]
;-26     writetty();

 call writetty
;-27 }

;-28 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-29     char c;

;-30     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;12 ptr sign byte s = bp+4
;13 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-31         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-32         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-33         s++;

 inc  word[bp+4]
;-34     }

;-35 }

 jmp .cputs2
.cputs3:
;-36 

;-37 int printhex4(unsigned char c) {

 LEAVE
 ret
ENDP

printhex4: PROC
;-38     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;12 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-39     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex44
 add  byte[bp+4], 7
;-40     putch(c);

.printhex44:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-41 }

;-42 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-43     unsigned char nib;

;-44     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;12 var unsg byte c = bp+4
;13 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-45     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-46 }

;-47 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-48     unsigned int half;

;-49     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;12 var unsg word i = bp+4
;13 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-50     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-51 }

;-52 

;-53 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-54     unsigned int e;

;-55     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;12 var unsg word n = bp+4
;13 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign5
;-56         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-57         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-58         }

;-59     n=n%10;

.printunsign5:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-60     n+='0';

 add  word[bp+4], 48
;-61     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-62 }

;-63 

;-64 int ShowRegister() {

 LEAVE
 ret
ENDP

ShowRegister: PROC
;-65     asm mov [vAX], ax

 mov [vAX], ax
;-66     asm mov [vBX], bx

 mov [vBX], bx
;-67     asm mov [vCX], cx

 mov [vCX], cx
;-68     asm mov [vDX], dx

 mov [vDX], dx
;-69     asm mov [vSP], sp

 mov [vSP], sp
;-70     asm mov [vBP], bp

 mov [vBP], bp
;-71     asm mov ax, cs

 mov ax, cs
;-72     asm mov [vCS], ax

 mov [vCS], ax
;-73     asm mov ax, ds

 mov ax, ds
;-74     asm mov [vDS], ax

 mov [vDS], ax
;-75     asm mov ax, ss

 mov ax, ss
;-76     asm mov [vSS], ax

 mov [vSS], ax
;-77     asm mov ax, es

 mov ax, es
;-78     asm mov [vES], ax

 mov [vES], ax
;-79     putch(10);

 push 10
 call putch
 add  sp, 2
;-80     cputs( "AX="); printhex16(vAX);

 push ShowRegister_0
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-81     cputs(",BX="); printhex16(vBX);

 push ShowRegister_1
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-82     cputs(",CX="); printhex16(vCX);

 push ShowRegister_2
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-83     cputs(",DX="); printhex16(vDX);

 push ShowRegister_3
 call cputs
 add  sp, 2
 push word [vDX]
 call printhex16
 add  sp, 2
;-84     cputs(",SP="); printhex16(vSP);

 push ShowRegister_4
 call cputs
 add  sp, 2
 push word [vSP]
 call printhex16
 add  sp, 2
;-85     cputs(",BP="); printhex16(vBP);

 push ShowRegister_5
 call cputs
 add  sp, 2
 push word [vBP]
 call printhex16
 add  sp, 2
;-86     cputs(",CS="); printhex16(vCS);

 push ShowRegister_6
 call cputs
 add  sp, 2
 push word [vCS]
 call printhex16
 add  sp, 2
;-87     cputs(",DS="); printhex16(vDS);

 push ShowRegister_7
 call cputs
 add  sp, 2
 push word [vDS]
 call printhex16
 add  sp, 2
;-88     cputs(",SS="); printhex16(vSS);

 push ShowRegister_8
 call cputs
 add  sp, 2
 push word [vSS]
 call printhex16
 add  sp, 2
;-89     cputs(",ES="); printhex16(vES);

 push ShowRegister_9
 call cputs
 add  sp, 2
 push word [vES]
 call printhex16
 add  sp, 2
;-90 }

;-91 

;-92 //Int = pushf + call far

;-93 //Int = pushf + push cs + push offset DOS_START + jmp far cs:VecOldOfs

;-94 char DOS_ERR=0;

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
DOS_ERR db 0
;-95 int count21h;

count21h dw 0
;-96 

;-97 int DosInt() {


DosInt: PROC
;-98     inth 0x21;

 int  33
;-99     __emit__(0x73, 04); //jnc over DOS_ERR++

 db 115,4
;-100     DOS_ERR++;

 inc  byte[DOS_ERR]
;-101 }

;-102 

;-103 unsigned char JmpFarHook=0xEA;//start struct

 ret
ENDP
JmpFarHook db 234
;-104 unsigned int VecOldOfs;

VecOldOfs dw 0
;-105 unsigned int VecOldSeg;//end struct

VecOldSeg dw 0
;-106 

;-107 int GetIntVec(char c) {


GetIntVec: PROC
;-108     asm push es

;Function : GetIntVec, Number local Var: 1
; # type sign width local variables
;17 var sign byte c = bp+4;
 ENTER  0,0
 push es
;-109     al=c;

 mov  al, [bp+4]
;-110     ah=0x35;

 mov  ah, 53
;-111     DosInt();

 call DosInt
;-112     asm mov [VecOldOfs], bx

 mov [VecOldOfs], bx
;-113     asm mov [VecOldSeg], es

 mov [VecOldSeg], es
;-114     asm pop es

 pop es
;-115 }

;-116 

;-117 unsigned int VecNewOfs;

 LEAVE
 ret
ENDP
VecNewOfs dw 0
;-118 unsigned int VecNewSeg;

VecNewSeg dw 0
;-119 

;-120 int GetIntVecNew(char c) {


GetIntVecNew: PROC
;-121     asm push es

;Function : GetIntVecNew, Number local Var: 1
; # type sign width local variables
;19 var sign byte c = bp+4;
 ENTER  0,0
 push es
;-122     al=c;

 mov  al, [bp+4]
;-123     ah=0x35;

 mov  ah, 53
;-124     DosInt();

 call DosInt
;-125     asm mov [VecNewOfs], bx

 mov [VecNewOfs], bx
;-126     asm mov [VecNewSeg], es

 mov [VecNewSeg], es
;-127     asm pop es

 pop es
;-128 }

;-129 /*

;-130 int SetIntVecDos(char *adr) {

;-131     asm push ds

;-132     ax=cs;

;-133     ds=ax;

;-134 //    dx= &adr; is mov instead of lea

;-135     asm lea dx, [bp+4]; *adr

;-136     ax=0x2521;//new addr in ds:dx

;-137     DosInt();

;-138     asm pop ds

;-139 }

;-140 */

;-141 unsigned int DS_old;

 LEAVE
 ret
ENDP
DS_old dw 0
;-142 

;-143 int DOS_START() {


DOS_START: PROC
;-144     count21h++;

 inc  word[count21h]
;-145     if (ah != 0x80) {

 cmp  ah, 128
 je  .DOS_START6
;-146         asm jmp JmpFarHook; goto old kernel

 jmp JmpFarHook; goto old kernel
;-147     }

;-148         ax=ds;

.DOS_START6:
 mov  ax, ds
;-149         __emit__(0x2E);//cs seg for next instruction

 db 46
;-150         asm mov [DS_old], ax

 mov [DS_old], ax
;-151         ax=cs;// cs seg is the only seg we know the value

 mov  ax, cs
;-152         ds=ax;

 mov  ds, ax
;-153 

;-154         asm sti; enable interrupts

 sti; enable interrupts
;-155         cputs("Inside DOS_START:");

 push DOS_START_0
 call cputs
 add  sp, 2
;-156         ShowRegister();

 call ShowRegister
;-157 

;-158         cputs(" count21h=");

 push DOS_START_1
 call cputs
 add  sp, 2
;-159         printunsign(count21h);

 push word [count21h]
 call printunsign
 add  sp, 2
;-160         cputs(" DS: old=");

 push DOS_START_2
 call cputs
 add  sp, 2
;-161         printunsign(DS_old);

 push word [DS_old]
 call printunsign
 add  sp, 2
;-162 

;-163         ax=DS_old;//restore ds Seg

 mov  ax, [DS_old]
;-164         ds=ax;

 mov  ds, ax
;-165         asm iret

 iret
;-166 }

;-167 

;-168 int setblock(unsigned int i) {

 ret
DOS_START_0 db "Inside DOS_START:",0
DOS_START_1 db " count21h=",0
DOS_START_2 db " DS: old=",0
ENDP

setblock: PROC
;-169     DOS_ERR=0;

;Function : setblock, Number local Var: 1
; # type sign width local variables
;20 var unsg word i = bp+4;
 ENTER  0,0
 mov ax, 0
 mov byte [DOS_ERR], al
;-170     bx=i;

 mov  bx, [bp+4]
;-171     ax=cs;

 mov  ax, cs
;-172     es=ax;

 mov  es, ax
;-173     ax=0x4A00;

 mov  ax, 18944
;-174     //modify mem Alloc. IN: ES=Block Seg, BX=size in para

;-175     DosInt();

 call DosInt
;-176     asm mov [vAX], ax

 mov [vAX], ax
;-177     asm mov [vBX], bx

 mov [vBX], bx
;-178     if (DOS_ERR) cputs(" ***Error SetBlock***");

 mov al, [DOS_ERR]
 or  al, al
 je .setblock7
 push setblock_0
 call cputs
 add  sp, 2
;-179     cputs("SetBlock AX:"); printhex16(vAX);

.setblock7:
 push setblock_1
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-180     cputs(",BX:"); printhex16(vBX);

 push setblock_2
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-181 }

;-182 

;-183 

;-184 //--------------------------------  disk IO  -------------------

;-185 char BIOS_ERR=0;

 LEAVE
 ret
setblock_0 db " ***Error SetBlock***",0
setblock_1 db "SetBlock AX:",0
setblock_2 db ",BX:",0
ENDP
BIOS_ERR db 0
;-186 int  BIOS_Status=0;

BIOS_Status dw 0
;-187 char DiskBuf [512];

section .bss
absolute 4096
DiskBuf resb 512
section .text
;-188 char Drive;

Drive db 0
;-189 int  Cylinders;

Cylinders dw 0
;-190 char Sectors;

Sectors db 0
;-191 char Heads;

Heads db 0
;-192 char Attached;

Attached db 0
;-193 int  ParmTableSeg;

ParmTableSeg dw 0
;-194 int  ParmTableOfs;

ParmTableOfs dw 0
;-195 char DriveType;

DriveType db 0
;-196 //hard disk partition structure

;-197 unsigned char ptBootable;	//80h = active partition, else 00

ptBootable db 0
;-198 unsigned char ptStartHead;	//

ptStartHead db 0
;-199 unsigned char ptStartSector;	//bits 0-5

ptStartSector db 0
;-200 unsigned int  ptStartCylinder;//bits 8,9 in bits 6,7 of sector

ptStartCylinder dw 0
;-201 unsigned char ptFileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=hugePart

ptFileSystem db 0
;-202 unsigned char ptEndHead;		//

ptEndHead db 0
;-203 unsigned char ptEndSector;	//bits 0-5

ptEndSector db 0
;-204 unsigned int  ptEndCylinder;	//bits 8,9 in bits 6,7 of sector

ptEndCylinder dw 0
;-205 unsigned int ptStartSectorlo;//sectors preceding partition

ptStartSectorlo dw 0
;-206 unsigned int ptStartSectorhi;

ptStartSectorhi dw 0
;-207 unsigned int ptPartLenlo;    //length of partition in sectors

ptPartLenlo dw 0
;-208 unsigned int ptPartLenhi;

ptPartLenhi dw 0
;-209 

;-210 

;-211 int Int13hRW(char rw, char drive, char head, int cyl, int sector,


Int13hRW: PROC
;-212 	int count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-213 	BIOS_ERR=0;	

;Function : Int13hRW, Number local Var: 8
; # type sign width local variables
;43 var sign byte rw = bp+4
;44 var sign byte drive = bp+6
;45 var sign byte head = bp+8
;46 var sign word cyl = bp+10
;47 var sign word sector = bp+12
;48 var sign word count = bp+14
;49 var sign word BufSeg = bp+16
;50 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-214 	dl=drive;

 mov  dl, [bp+6]
;-215 	dh=head;

 mov  dh, [bp+8]
;-216 	es=BufSeg;

 mov  es, [bp+16]
;-217 	bx=BufOfs;

 mov  bx, [bp+18]
;-218 	cx=cyl;	

 mov  cx, [bp+10]
;-219 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-220 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-221 	sector &= 0x3F;//only 6 bits for sector

 and  word[bp+12], 63
;-222 	cl += sector;

 add  cl, [bp+12]
;-223 	ch=cyl;//low byte of cyl in ch

 mov  ch, [bp+10]
;-224 	

;-225 	al=count;

 mov  al, [bp+14]
;-226 	ah=rw;

 mov  ah, [bp+4]
;-227 	inth 0x13;

 int  19
;-228     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-229 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-230 }

;-231 int Int13hRawIO(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hRawIO: PROC
;-232 	BIOS_ERR=0;	

;Function : Int13hRawIO, Number local Var: 2
; # type sign width local variables
;43 var sign byte drive = bp+4
;44 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-233 	dl=drive;

 mov  dl, [bp+4]
;-234 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-235 	inth 0x13;

 int  19
;-236     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-237 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-238 }

;-239 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-240 	cputs(" ** disk error AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-241 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-242 //	cputs(" BIOS_ERR=");

;-243 //	printunsign(BIOS_ERR);

;-244 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-245 //	putch(10);

;-246 	BIOS_Status=Int13hRawIO(Drive, 0);//Reset

 push 0
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-247 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-248 }	

;-249 

;-250 int PrintDriveParms() {

 ret
Int13hError_0 db " ** disk error AX=",0
Int13hError_1 db ".  ",0
ENDP

PrintDriveParms: PROC
;-251 	asm mov [Heads],        dh

 mov [Heads],        dh
;-252 	Heads++;//1 to 256

 inc  byte[Heads]
;-253 	asm mov [Attached],     dl

 mov [Attached],     dl
;-254 	asm mov [ParmTableSeg], es

 mov [ParmTableSeg], es
;-255 	asm mov [ParmTableOfs], di

 mov [ParmTableOfs], di
;-256 	asm mov [DriveType],    bl;BiosType(biosval)

 mov [DriveType],    bl;BiosType(biosval)
;-257 	// CX =       ---CH--- ---CL---

;-258 	// cylinder : 76543210 98

;-259 	// sector   :            543210	

;-260 	asm mov [Sectors],      cl

 mov [Sectors],      cl
;-261 	Sectors &= 0x3F;// 63

 and  byte[Sectors], 63
;-262 	Sectors++;//1 to 64

 inc  byte[Sectors]
;-263 

;-264 	asm mov [Cylinders],    cl	

 mov [Cylinders],    cl	
;-265 	Cylinders &= 0xC0;//;bit 9 and 10

 and  word[Cylinders], 192
;-266 	Cylinders = Cylinders << 2;//compiler flaw:

 mov ax, [Cylinders]
 shl ax, 2
 mov word [Cylinders], ax
;-267 	asm add [Cylinders],    ch;//byte add, low byte is empty	

 add [Cylinders],    ch;//byte add, low byte is empty	
;-268 //	Cylinders++;//1 to 1024	

;-269 

;-270 	putch(10);

 push 10
 call putch
 add  sp, 2
;-271 	cputs("HD Params:");		 	//printhex8(Drive);

 push PrintDriveParms_0
 call cputs
 add  sp, 2
;-272 	cputs(" Cyl=");						printunsign(Cylinders);

 push PrintDriveParms_1
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
;-273 	cputs(", Sec=");					printunsign(Sectors);

 push PrintDriveParms_2
 call cputs
 add  sp, 2
 mov al, byte [Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-274 	cputs(", Hd=");						printunsign(Heads);

 push PrintDriveParms_3
 call cputs
 add  sp, 2
 mov al, byte [Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-275 	cputs(", Attached=");				printhex8(Attached);

 push PrintDriveParms_4
 call cputs
 add  sp, 2
 mov al, byte [Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-276 	putch(10);	

 push 10
 call putch
 add  sp, 2
;-277 //	cputs("DriveType (FL)=");			printhex8(DriveType);

;-278 //	cputs(", ParmTable=");				printhex16(ParmTableSeg);

;-279 //	putch(':');							printhex16(ParmTableOfs);

;-280 	putch('.');

 push 46
 call putch
 add  sp, 2
;-281 }

;-282 

;-283 int Params(drive) {

 ret
PrintDriveParms_0 db "HD Params:",0
PrintDriveParms_1 db " Cyl=",0
PrintDriveParms_2 db ", Sec=",0
PrintDriveParms_3 db ", Hd=",0
PrintDriveParms_4 db ", Attached=",0
ENDP

Params: PROC
;-284 	putch(10);	

;Function : Params, Number local Var: 1
; # type sign width local variables
;43 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-285 	cputs("(8)Drive Params :");

 push Params_0
 call cputs
 add  sp, 2
;-286 	BIOS_Status=Int13hRawIO(drive, 8);//error

 push 8
 push word [bp+4]
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-287 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Params8
 call Int13hError
;-288 	printhex16(BIOS_Status);	

.Params8:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-289     PrintDriveParms();

 call PrintDriveParms
;-290 

;-291 	putch(10);

 push 10
 call putch
 add  sp, 2
;-292 	cputs("(10h)Status :");

 push Params_1
 call cputs
 add  sp, 2
;-293 	BIOS_Status=Int13hRawIO(drive, 0x10);	

 push 16
 push word [bp+4]
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-294 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Params9
 call Int13hError
;-295 	printhex16(BIOS_Status);	

.Params9:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-296 }

;-297 

;-298 int Status(drive) {

 LEAVE
 ret
Params_0 db "(8)Drive Params :",0
Params_1 db "(10h)Status :",0
ENDP

Status: PROC
;-299 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;43 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-300 	cputs("(1)Status last Op: AH=FL, AL=HD :");

 push Status_0
 call cputs
 add  sp, 2
;-301 	BIOS_Status=Int13hRawIO(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-302 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status10
 call Int13hError
;-303 	printhex16(BIOS_Status);	

.Status10:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-304 }	

;-305 

;-306 int testDisk(drive) {

 LEAVE
 ret
Status_0 db "(1)Status last Op: AH=FL, AL=HD :",0
ENDP

testDisk: PROC
;-307 	int i; int j; char c;

;-308 	putch(10);

;Function : testDisk, Number local Var: 4
; # type sign width local variables
;43 var sign word drive = bp+4
;44 var sign word i = bp-2
;45 var sign word j = bp-4
;46 var sign byte c = bp-6;
 ENTER  6,0
 push 10
 call putch
 add  sp, 2
;-309 	cputs("ReadStat=");	

 push testDisk_0
 call cputs
 add  sp, 2
;-310 	asm mov [ParmTableSeg], ds

 mov [ParmTableSeg], ds
;-311 	//Offset is in DiskBuf

;-312 	BIOS_Status=Int13hRW(2,drive,0,0,1,1,ParmTableSeg,DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [ParmTableSeg]
 push 1
 push 1
 push 0
 push 0
 push word [bp+4]
 push 2
 call Int13hRW
 add  sp, 16
 mov word [BIOS_Status], ax
;-313 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .testDisk11
 call Int13hError
;-314 //	printhex16(BIOS_Status);	

;-315 	cputs(", Part.Info: Magic=");

.testDisk11:
 push testDisk_1
 call cputs
 add  sp, 2
;-316 	i=510;

 mov ax, 510
 mov [bp-2], ax
;-317 	c = DiskBuf[i];

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov [bp-6], al
;-318 	printhex8(c);

 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-319 	i++;

 inc  word[bp-2]
;-320 	c = DiskBuf[i];

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov [bp-6], al
;-321 	printhex8(c);

 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-322 	

;-323 	cputs(",DiskBuf=");

 push testDisk_2
 call cputs
 add  sp, 2
;-324 	printhex16(ParmTableSeg);

 push word [ParmTableSeg]
 call printhex16
 add  sp, 2
;-325 	putch(':');							

 push 58
 call putch
 add  sp, 2
;-326 	printhex16(DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 call printhex16
 add  sp, 2
;-327 	putch('.');

 push 46
 call putch
 add  sp, 2
;-328 

;-329     putch(10);		

 push 10
 call putch
 add  sp, 2
;-330 	i=0;

 mov ax, 0
 mov [bp-2], ax
;-331 	cputs("Part=");

 push testDisk_3
 call cputs
 add  sp, 2
;-332 	printhex8(i);

 push word [bp-2]
 call printhex8
 add  sp, 2
;-333 	j=0x1be;

 mov ax, 446
 mov [bp-4], ax
;-334 	ptBootable=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptBootable], al
;-335 	cputs(",BootId=");

 push testDisk_4
 call cputs
 add  sp, 2
;-336 	printhex8(ptBootable);

 mov al, byte [ptBootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-337 	j++;

 inc  word[bp-4]
;-338 	ptStartHead=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptStartHead], al
;-339 	cputs(",StartHd=");

 push testDisk_5
 call cputs
 add  sp, 2
;-340 	printhex8(ptStartHead);

 mov al, byte [ptStartHead]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-341 	j++;

 inc  word[bp-4]
;-342 	ptStartSector=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptStartSector], al
;-343 	ah=0;//next line convert byte to word

 mov  ah, 0
;-344 	ptStartCylinder=ptStartSector;//see next 5 line		

 mov al, [ptStartSector]
 mov word [ptStartCylinder], ax
;-345 	ptStartSector &= 0x3F;

 and  byte[ptStartSector], 63
;-346 	ptStartSector++;//Sector start with 1

 inc  byte[ptStartSector]
;-347 	cputs(",StartSec=");

 push testDisk_6
 call cputs
 add  sp, 2
;-348 	printhex8(ptStartSector);	

 mov al, byte [ptStartSector]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-349 	ptStartCylinder &= 0xC0;

 and  word[ptStartCylinder], 192
;-350 	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	

 mov ax, [ptStartCylinder]
 shl ax, 2
 mov word [ptStartCylinder], ax
;-351 	j++;

 inc  word[bp-4]
;-352 	ah=0;//byte 2 word

 mov  ah, 0
;-353 	ptStartCylinder=DiskBuf[j] + ptStartCylinder;

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 add ax, [ptStartCylinder]
 mov word [ptStartCylinder], ax
;-354 //	byte add, ok because low byte is empty

;-355 //	ptStartCylinder=ptStartCylinder + DiskBuf[j];//OK

;-356 	cputs(",StartCyl=");

 push testDisk_7
 call cputs
 add  sp, 2
;-357 	printhex16(ptStartCylinder);

 push word [ptStartCylinder]
 call printhex16
 add  sp, 2
;-358 	j++;

 inc  word[bp-4]
;-359 	ptFileSystem=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptFileSystem], al
;-360 	cputs(",FileID=");

 push testDisk_8
 call cputs
 add  sp, 2
;-361 	printhex8(ptFileSystem);

 mov al, byte [ptFileSystem]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-362 	j++;

 inc  word[bp-4]
;-363 	ptEndHead=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptEndHead], al
;-364 	cputs(",EndHd=");

 push testDisk_9
 call cputs
 add  sp, 2
;-365 	printhex8(ptEndHead);

 mov al, byte [ptEndHead]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-366 	j++;

 inc  word[bp-4]
;-367 	ptEndSector=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptEndSector], al
;-368 	

;-369 		

;-370 	

;-371 }	

;-372 

;-373 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
testDisk_0 db "ReadStat=",0
testDisk_1 db ", Part.Info: Magic=",0
testDisk_2 db ",DiskBuf=",0
testDisk_3 db "Part=",0
testDisk_4 db ",BootId=",0
testDisk_5 db ",StartHd=",0
testDisk_6 db ",StartSec=",0
testDisk_7 db ",StartCyl=",0
testDisk_8 db ",FileID=",0
testDisk_9 db ",EndHd=",0
ENDP

mdump: PROC
;-374     unsigned char c;

;-375     int i;

;-376     int j;

;-377     j=0;

;Function : mdump, Number local Var: 5
; # type sign width local variables
;43 ptr unsg byte adr = bp+4
;44 var unsg word len = bp+6
;45 var unsg byte c = bp-2
;46 var sign word i = bp-4
;47 var sign word j = bp-6;
 ENTER  6,0
 mov ax, 0
 mov [bp-6], ax
;-378     while (j < len ) {

.mdump12:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump13
;-379         putch(10);

 push 10
 call putch
 add  sp, 2
;-380         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-381         putch(':');

 push 58
 call putch
 add  sp, 2
;-382         i=0;

 mov ax, 0
 mov [bp-4], ax
;-383         while (i < 16) {

.mdump14:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump15
;-384             putch(' ');

 push 32
 call putch
 add  sp, 2
;-385             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-386             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-387             adr++;

 inc  word[bp+4]
;-388             i++;

 inc  word[bp-4]
;-389             j++;

 inc  word[bp-6]
;-390             }

;-391         putch(' ');

 jmp .mdump14
.mdump15:
 push 32
 call putch
 add  sp, 2
;-392         adr -=16;

 sub  word[bp+4], 16
;-393         i=0;

 mov ax, 0
 mov [bp-4], ax
;-394         while(i < 16) {

.mdump16:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump17
;-395             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-396             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump18
 push 46
 call putch
 add  sp, 2
;-397                 else putch(c);

 jmp .mdump19
.mdump18:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-398             adr++;

.mdump19:
 inc  word[bp+4]
;-399             i++;

 inc  word[bp-4]
;-400         }

;-401     }

 jmp .mdump16
.mdump17:
;-402 }

 jmp .mdump12
.mdump13:
;-403 char Dummy[10];

 LEAVE
 ret
ENDP
section .bss
absolute 4608
Dummy resb 10
section .text
;-404 

;-405 

;-406 //------------------------------------ main ---------------

;-407 int main() {


main: PROC
;-408 //	unsigned int i;

;-409 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-410 //	i = 0;

;-411 

;-412 //  LabelAddr[LabelMaxIx] = AbsoluteLab;

;-413 

;-414 

;-415 //	asm  mov [DiskBuf+bx], al

;-416 	

;-417 //	asm mov [Dummy+bx], al

;-418 		

;-419 //	DiskBuf [i] = 0;

;-420 	

;-421 //	do {

;-422 //		DiskBuf[i] = 0;

;-423 //		i++;

;-424 //	} while (i < 100);

;-425 

;-426 	Params(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Params
 add  sp, 2
;-427 	testDisk(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call testDisk
 add  sp, 2
;-428 

;-429 //	mdump(DiskBuf, 256);

;-430 	

;-431 

;-432 	putch(10);

 push 10
 call putch
 add  sp, 2
;-433 	cputs("(41)Ext present :");

 push main_0
 call cputs
 add  sp, 2
;-434 	bx=0x55AA;

 mov  bx, 21930
;-435 	BIOS_Status=Int13hRawIO(0x80, 0x41);	

 push 65
 push 128
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-436 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .main20
 call Int13hError
;-437 	//BIOS_Status=ax;01: Extension supported

;-438 	asm mov [vBX], bx;0xAA55 Extension installed

.main20:
 mov [vBX], bx;0xAA55 Extension installed
;-439 	asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			
;-440 	printhex16(BIOS_Status);		

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-441 

;-442 /*	DosBox Disk Services Int13h:

;-443 	00	Reset Disk System

;-444 	01	Get Status of Last Drive Operation

;-445 	02	Read Sectors

;-446 	03	Write Sectors

;-447 	08	Get Drive Parameters

;-448 	only DosBox_X:

;-449 	41	EXT Extension Available

;-450 	42	EXT Read Sectors

;-451 	43	EXT Write Sectors

;-452 	48	EXT Read Drive Parameter

;-453 */

;-454 /*

;-455     setblock(4096);// 64KB

;-456 

;-457     GetIntVec(0x21);

;-458     cputs(" Main Int21h old=");

;-459     printhex16(VecOldSeg);

;-460     putch(':');

;-461     printhex16(VecOldOfs);

;-462 

;-463     asm mov dx, DOS_START

;-464 //    asm lea dx, [DOS_START]

;-465     ax=0x2521;

;-466     DosInt();

;-467 //    ShowRegister();

;-468 

;-469     GetIntVecNew(0x21);

;-470     cputs(" Int21h new=");

;-471     printhex16(VecNewSeg);

;-472     putch(':');

;-473     printhex16(VecNewOfs);

;-474 

;-475     cputs(" count21h=");

;-476     printunsign(count21h);

;-477     cputs(" end main.");

;-478 

;-479 //    asm int 32;20h exit

;-480 

;-481     asm mov dx, main;get adr of main in dx//Terminate stay resident

;-482     asm shr dx, 4   ;make para

;-483     asm add dx, 17  ;PSP in para + align to next para

;-484     ax=0x3100;

;-485     DosInt();

;-486 */

;-487 

;-488 }

 ret
main_0 db "(41)Ext present :",0
ENDP
;Glob. variables:43 (400):392 (4000), Functions:22 (300):209 (3000)
;Lines:489, Constant: 294 (3000), stacksize: 60917