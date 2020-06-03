;PLA compiler A.COM V1.0.1, Input: DOS_ALT1.C, Output: DOS_ALT1.S
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

;-15 char DOS_ERR=0;

DOS_ERR db 0
;-16 unsigned int count21h=0;

count21h dw 0
;-17 

;-18 #define LABELADRMAX 600

;-19 unsigned int LabelAddr[LABELADRMAX];//addr of each label

section .bss
absolute 4096
LabelAddr resw 600
section .text
;-20 int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1

LabelMaxIx dw 0
;-21 

;-22 unsigned int AbsoluteLab=0;//uninitialised data

AbsoluteLab dw 0
;-23 

;-24 

;-25 int writetty()     {


writetty: PROC
;-26     ah=0x0E;

 mov  ah, 14
;-27     bx=0;

 mov  bx, 0
;-28     asm int 16

 int 16
;-29 }

;-30 int putch(char c)  {

 ret
ENDP

putch: PROC
;-31     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;18 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-32         al=13;

 mov  al, 13
;-33         writetty();

 call writetty
;-34     }

;-35     al=c;

.putch1:
 mov  al, [bp+4]
;-36     writetty();

 call writetty
;-37 }

;-38 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-39     char c;

;-40     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;18 ptr sign byte s = bp+4
;19 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-41         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-42         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-43         s++;

 inc  word[bp+4]
;-44     }

;-45 }

 jmp .cputs2
.cputs3:
;-46 

;-47 int printhex4(unsigned char c) {

 LEAVE
 ret
ENDP

printhex4: PROC
;-48     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;18 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-49     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex44
 add  byte[bp+4], 7
;-50     putch(c);

.printhex44:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-51 }

;-52 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-53     unsigned char nib;

;-54     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;18 var unsg byte c = bp+4
;19 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-55     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-56 }

;-57 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-58     unsigned int half;

;-59     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;18 var unsg word i = bp+4
;19 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-60     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-61 }

;-62 

;-63 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-64     unsigned int e;

;-65     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;18 var unsg word n = bp+4
;19 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign5
;-66         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-67         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-68         }

;-69     n=n%10;

.printunsign5:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-70     n+='0';

 add  word[bp+4], 48
;-71     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-72 }

;-73 

;-74 int ShowRegister() {

 LEAVE
 ret
ENDP

ShowRegister: PROC
;-75     asm mov [vAX], ax

 mov [vAX], ax
;-76     asm mov [vBX], bx

 mov [vBX], bx
;-77     asm mov [vCX], cx

 mov [vCX], cx
;-78     asm mov [vDX], dx

 mov [vDX], dx
;-79     asm mov [vSP], sp

 mov [vSP], sp
;-80     asm mov [vBP], bp

 mov [vBP], bp
;-81     asm mov ax, cs

 mov ax, cs
;-82     asm mov [vCS], ax

 mov [vCS], ax
;-83     asm mov ax, ds

 mov ax, ds
;-84     asm mov [vDS], ax

 mov [vDS], ax
;-85     asm mov ax, ss

 mov ax, ss
;-86     asm mov [vSS], ax

 mov [vSS], ax
;-87     asm mov ax, es

 mov ax, es
;-88     asm mov [vES], ax

 mov [vES], ax
;-89     putch(10);

 push 10
 call putch
 add  sp, 2
;-90     cputs( "AX="); printhex16(vAX);

 push ShowRegister_0
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-91     cputs(",BX="); printhex16(vBX);

 push ShowRegister_1
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-92     cputs(",CX="); printhex16(vCX);

 push ShowRegister_2
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-93     cputs(",DX="); printhex16(vDX);

 push ShowRegister_3
 call cputs
 add  sp, 2
 push word [vDX]
 call printhex16
 add  sp, 2
;-94     cputs(",SP="); printhex16(vSP);

 push ShowRegister_4
 call cputs
 add  sp, 2
 push word [vSP]
 call printhex16
 add  sp, 2
;-95     cputs(",BP="); printhex16(vBP);

 push ShowRegister_5
 call cputs
 add  sp, 2
 push word [vBP]
 call printhex16
 add  sp, 2
;-96     cputs(",CS="); printhex16(vCS);

 push ShowRegister_6
 call cputs
 add  sp, 2
 push word [vCS]
 call printhex16
 add  sp, 2
;-97     cputs(",DS="); printhex16(vDS);

 push ShowRegister_7
 call cputs
 add  sp, 2
 push word [vDS]
 call printhex16
 add  sp, 2
;-98     cputs(",SS="); printhex16(vSS);

 push ShowRegister_8
 call cputs
 add  sp, 2
 push word [vSS]
 call printhex16
 add  sp, 2
;-99     cputs(",ES="); printhex16(vES);

 push ShowRegister_9
 call cputs
 add  sp, 2
 push word [vES]
 call printhex16
 add  sp, 2
;-100 }

;-101 

;-102 //Int = pushf + call far

;-103 //Int = pushf + push cs + push offset DOS_START + jmp far cs:VecOldOfs

;-104 int DosInt() {

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
;-105     inth 0x21;

 int  33
;-106     __emit__(0x73, 04); //jnc over DOS_ERR++

 db 115,4
;-107     DOS_ERR++;

 inc  byte[DOS_ERR]
;-108 }

;-109 

;-110 unsigned char JmpFarHook=0xEA;//start struct

 ret
ENDP
JmpFarHook db 234
;-111 unsigned int VecOldOfs;

VecOldOfs dw 0
;-112 unsigned int VecOldSeg;//end struct

VecOldSeg dw 0
;-113 

;-114 int GetIntVec(char c) {


GetIntVec: PROC
;-115     asm push es

;Function : GetIntVec, Number local Var: 1
; # type sign width local variables
;21 var sign byte c = bp+4;
 ENTER  0,0
 push es
;-116     al=c;

 mov  al, [bp+4]
;-117     ah=0x35;

 mov  ah, 53
;-118     DosInt();

 call DosInt
;-119     asm mov [VecOldOfs], bx

 mov [VecOldOfs], bx
;-120     asm mov [VecOldSeg], es

 mov [VecOldSeg], es
;-121     asm pop es

 pop es
;-122 }

;-123 

;-124 unsigned int VecNewOfs;

 LEAVE
 ret
ENDP
VecNewOfs dw 0
;-125 unsigned int VecNewSeg;

VecNewSeg dw 0
;-126 

;-127 int GetIntVecNew(char c) {


GetIntVecNew: PROC
;-128     asm push es

;Function : GetIntVecNew, Number local Var: 1
; # type sign width local variables
;23 var sign byte c = bp+4;
 ENTER  0,0
 push es
;-129     al=c;

 mov  al, [bp+4]
;-130     ah=0x35;

 mov  ah, 53
;-131     DosInt();

 call DosInt
;-132     asm mov [VecNewOfs], bx

 mov [VecNewOfs], bx
;-133     asm mov [VecNewSeg], es

 mov [VecNewSeg], es
;-134     asm pop es

 pop es
;-135 }

;-136 /*

;-137 int SetIntVecDos(char *adr) {

;-138     asm push ds

;-139     ax=cs;

;-140     ds=ax;

;-141 //    dx= &adr; is mov instead of lea

;-142     asm lea dx, [bp+4]; *adr

;-143     ax=0x2521;//new addr in ds:dx

;-144     DosInt();

;-145     asm pop ds

;-146 }

;-147 */

;-148 unsigned int DS_old;

 LEAVE
 ret
ENDP
DS_old dw 0
;-149 

;-150 int DOS_START() {


DOS_START: PROC
;-151     count21h++;

 inc  word[count21h]
;-152     if (ah != 0x80) {

 cmp  ah, 128
 je  .DOS_START6
;-153         asm jmp JmpFarHook; goto old kernel

 jmp JmpFarHook; goto old kernel
;-154     }

;-155         ax=ds;

.DOS_START6:
 mov  ax, ds
;-156         __emit__(0x2E);//cs seg for next instruction

 db 46
;-157         asm mov [DS_old], ax

 mov [DS_old], ax
;-158         ax=cs;// cs seg is the only seg we know the value

 mov  ax, cs
;-159         ds=ax;

 mov  ds, ax
;-160 

;-161         asm sti; enable interrupts

 sti; enable interrupts
;-162         cputs("Inside DOS_START:");

 push DOS_START_0
 call cputs
 add  sp, 2
;-163         ShowRegister();

 call ShowRegister
;-164 

;-165         cputs(" count21h=");

 push DOS_START_1
 call cputs
 add  sp, 2
;-166         printunsign(count21h);

 push word [count21h]
 call printunsign
 add  sp, 2
;-167         cputs(" DS: old=");

 push DOS_START_2
 call cputs
 add  sp, 2
;-168         printunsign(DS_old);

 push word [DS_old]
 call printunsign
 add  sp, 2
;-169 

;-170         ax=DS_old;//restore ds Seg

 mov  ax, [DS_old]
;-171         ds=ax;

 mov  ds, ax
;-172         asm iret

 iret
;-173 }

;-174 

;-175 int setblock(unsigned int i) {

 ret
DOS_START_0 db "Inside DOS_START:",0
DOS_START_1 db " count21h=",0
DOS_START_2 db " DS: old=",0
ENDP

setblock: PROC
;-176     DOS_ERR=0;

;Function : setblock, Number local Var: 1
; # type sign width local variables
;24 var unsg word i = bp+4;
 ENTER  0,0
 mov ax, 0
 mov byte [DOS_ERR], al
;-177     bx=i;

 mov  bx, [bp+4]
;-178     ax=cs;

 mov  ax, cs
;-179     es=ax;

 mov  es, ax
;-180     ax=0x4A00;

 mov  ax, 18944
;-181     //modify mem Alloc. IN: ES=Block Seg, BX=size in para

;-182     DosInt();

 call DosInt
;-183     asm mov [vAX], ax

 mov [vAX], ax
;-184     asm mov [vBX], bx

 mov [vBX], bx
;-185     if (DOS_ERR) cputs(" ***Error SetBlock***");

 mov al, [DOS_ERR]
 or  al, al
 je .setblock7
 push setblock_0
 call cputs
 add  sp, 2
;-186     cputs("SetBlock AX:"); printhex16(vAX);

.setblock7:
 push setblock_1
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-187     cputs(",BX:"); printhex16(vBX);

 push setblock_2
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-188 }

;-189 

;-190 

;-191 //--------------------------------  disk IO  -------------------

;-192 char BIOS_ERR=0;

 LEAVE
 ret
setblock_0 db " ***Error SetBlock***",0
setblock_1 db "SetBlock AX:",0
setblock_2 db ",BX:",0
ENDP
BIOS_ERR db 0
;-193 int  BIOS_Status=0;

BIOS_Status dw 0
;-194 char DiskBuf [512];

section .bss
absolute 5296
DiskBuf resb 512
section .text
;-195 char Drive;

Drive db 0
;-196 int  Cylinders;

Cylinders dw 0
;-197 char Sectors;

Sectors db 0
;-198 char Heads;

Heads db 0
;-199 char Attached;

Attached db 0
;-200 int  ParmTableSeg;

ParmTableSeg dw 0
;-201 int  ParmTableOfs;

ParmTableOfs dw 0
;-202 char DriveType;

DriveType db 0
;-203 //hard disk partition structure

;-204 unsigned char ptBootable;	//80h = active partition, else 00

ptBootable db 0
;-205 unsigned char ptStartHead;	//

ptStartHead db 0
;-206 unsigned char ptStartSector;	//bits 0-5

ptStartSector db 0
;-207 unsigned int  ptStartCylinder;//bits 8,9 in bits 6,7 of sector

ptStartCylinder dw 0
;-208 unsigned char ptFileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=hugePart

ptFileSystem db 0
;-209 unsigned char ptEndHead;		//

ptEndHead db 0
;-210 unsigned char ptEndSector;	//bits 0-5

ptEndSector db 0
;-211 unsigned int  ptEndCylinder;	//bits 8,9 in bits 6,7 of sector

ptEndCylinder dw 0
;-212 unsigned int ptStartSectorlo;//sectors preceding partition

ptStartSectorlo dw 0
;-213 unsigned int ptStartSectorhi;

ptStartSectorhi dw 0
;-214 unsigned int ptPartLenlo;    //length of partition in sectors

ptPartLenlo dw 0
;-215 unsigned int ptPartLenhi;

ptPartLenhi dw 0
;-216 

;-217 

;-218 int Int13hRW(char rw, char drive, char head, int cyl, int sector,


Int13hRW: PROC
;-219 	int count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-220 	BIOS_ERR=0;	

;Function : Int13hRW, Number local Var: 8
; # type sign width local variables
;47 var sign byte rw = bp+4
;48 var sign byte drive = bp+6
;49 var sign byte head = bp+8
;50 var sign word cyl = bp+10
;51 var sign word sector = bp+12
;52 var sign word count = bp+14
;53 var sign word BufSeg = bp+16
;54 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-221 	dl=drive;

 mov  dl, [bp+6]
;-222 	dh=head;

 mov  dh, [bp+8]
;-223 	es=BufSeg;

 mov  es, [bp+16]
;-224 	bx=BufOfs;

 mov  bx, [bp+18]
;-225 	cx=cyl;	

 mov  cx, [bp+10]
;-226 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-227 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-228 	sector &= 0x3F;//only 6 bits for sector

 and  word[bp+12], 63
;-229 	cl += sector;

 add  cl, [bp+12]
;-230 	ch=cyl;//low byte of cyl in ch

 mov  ch, [bp+10]
;-231 	

;-232 	al=count;

 mov  al, [bp+14]
;-233 	ah=rw;

 mov  ah, [bp+4]
;-234 	inth 0x13;

 int  19
;-235     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-236 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-237 }

;-238 int Int13hRawIO(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hRawIO: PROC
;-239 	BIOS_ERR=0;	

;Function : Int13hRawIO, Number local Var: 2
; # type sign width local variables
;47 var sign byte drive = bp+4
;48 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-240 	dl=drive;

 mov  dl, [bp+4]
;-241 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-242 	inth 0x13;

 int  19
;-243     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-244 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-245 }

;-246 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-247 	cputs(" ** disk error AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-248 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-249 //	cputs(" BIOS_ERR=");

;-250 //	printunsign(BIOS_ERR);

;-251 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-252 //	putch(10);

;-253 	BIOS_Status=Int13hRawIO(Drive, 0);//Reset

 push 0
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-254 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-255 }	

;-256 

;-257 int PrintDriveParms() {

 ret
Int13hError_0 db " ** disk error AX=",0
Int13hError_1 db ".  ",0
ENDP

PrintDriveParms: PROC
;-258 	asm mov [Heads],        dh

 mov [Heads],        dh
;-259 	Heads++;//1 to 256

 inc  byte[Heads]
;-260 	asm mov [Attached],     dl

 mov [Attached],     dl
;-261 	asm mov [ParmTableSeg], es

 mov [ParmTableSeg], es
;-262 	asm mov [ParmTableOfs], di

 mov [ParmTableOfs], di
;-263 	asm mov [DriveType],    bl;BiosType(biosval)

 mov [DriveType],    bl;BiosType(biosval)
;-264 	// CX =       ---CH--- ---CL---

;-265 	// cylinder : 76543210 98

;-266 	// sector   :            543210	

;-267 	asm mov [Sectors],      cl

 mov [Sectors],      cl
;-268 	Sectors &= 0x3F;// 63

 and  byte[Sectors], 63
;-269 	Sectors++;//1 to 64

 inc  byte[Sectors]
;-270 

;-271 	asm mov [Cylinders],    cl	

 mov [Cylinders],    cl	
;-272 	Cylinders &= 0xC0;//;bit 9 and 10

 and  word[Cylinders], 192
;-273 	Cylinders = Cylinders << 2;//compiler flaw:

 mov ax, [Cylinders]
 shl ax, 2
 mov word [Cylinders], ax
;-274 	asm add [Cylinders],    ch;//byte add, low byte is empty	

 add [Cylinders],    ch;//byte add, low byte is empty	
;-275 //	Cylinders++;//1 to 1024	

;-276 

;-277 	putch(10);

 push 10
 call putch
 add  sp, 2
;-278 	cputs("HD Params:");		 	//printhex8(Drive);

 push PrintDriveParms_0
 call cputs
 add  sp, 2
;-279 	cputs(" Cyl=");						printunsign(Cylinders);

 push PrintDriveParms_1
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
;-280 	cputs(", Sec=");					printunsign(Sectors);

 push PrintDriveParms_2
 call cputs
 add  sp, 2
 mov al, byte [Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-281 	cputs(", Hd=");						printunsign(Heads);

 push PrintDriveParms_3
 call cputs
 add  sp, 2
 mov al, byte [Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-282 	cputs(", Attached=");				printhex8(Attached);

 push PrintDriveParms_4
 call cputs
 add  sp, 2
 mov al, byte [Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-283 	putch(10);	

 push 10
 call putch
 add  sp, 2
;-284 	cputs("DriveType (FL)=");			printhex8(DriveType);

 push PrintDriveParms_5
 call cputs
 add  sp, 2
 mov al, byte [DriveType]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-285 	cputs(", ParmTable=");				printhex16(ParmTableSeg);

 push PrintDriveParms_6
 call cputs
 add  sp, 2
 push word [ParmTableSeg]
 call printhex16
 add  sp, 2
;-286 	putch(':');							printhex16(ParmTableOfs);

 push 58
 call putch
 add  sp, 2
 push word [ParmTableOfs]
 call printhex16
 add  sp, 2
;-287 	putch('.');

 push 46
 call putch
 add  sp, 2
;-288 }

;-289 

;-290 int Params(drive) {

 ret
PrintDriveParms_0 db "HD Params:",0
PrintDriveParms_1 db " Cyl=",0
PrintDriveParms_2 db ", Sec=",0
PrintDriveParms_3 db ", Hd=",0
PrintDriveParms_4 db ", Attached=",0
PrintDriveParms_5 db "DriveType (FL)=",0
PrintDriveParms_6 db ", ParmTable=",0
ENDP

Params: PROC
;-291 	putch(10);	

;Function : Params, Number local Var: 1
; # type sign width local variables
;47 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-292 	cputs("(8)Drive Params :");

 push Params_0
 call cputs
 add  sp, 2
;-293 	BIOS_Status=Int13hRawIO(drive, 8);//error

 push 8
 push word [bp+4]
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-294 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Params8
 call Int13hError
;-295 	printhex16(BIOS_Status);	

.Params8:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-296     PrintDriveParms();

 call PrintDriveParms
;-297 

;-298 	putch(10);

 push 10
 call putch
 add  sp, 2
;-299 	cputs("(10h)Status :");

 push Params_1
 call cputs
 add  sp, 2
;-300 	BIOS_Status=Int13hRawIO(drive, 0x10);	

 push 16
 push word [bp+4]
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-301 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Params9
 call Int13hError
;-302 	printhex16(BIOS_Status);	

.Params9:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-303 }

;-304 

;-305 int Status(drive) {

 LEAVE
 ret
Params_0 db "(8)Drive Params :",0
Params_1 db "(10h)Status :",0
ENDP

Status: PROC
;-306 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;47 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-307 	cputs("(1)Status last Op: AH=FL, AL=HD :");

 push Status_0
 call cputs
 add  sp, 2
;-308 	BIOS_Status=Int13hRawIO(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-309 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status10
 call Int13hError
;-310 	printhex16(BIOS_Status);	

.Status10:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-311 }	

;-312 

;-313 int testDisk(drive) {

 LEAVE
 ret
Status_0 db "(1)Status last Op: AH=FL, AL=HD :",0
ENDP

testDisk: PROC
;-314 	int i; int j; char c;

;-315 	putch(10);

;Function : testDisk, Number local Var: 4
; # type sign width local variables
;47 var sign word drive = bp+4
;48 var sign word i = bp-2
;49 var sign word j = bp-4
;50 var sign byte c = bp-6;
 ENTER  6,0
 push 10
 call putch
 add  sp, 2
;-316 	cputs("ReadStat=");	

 push testDisk_0
 call cputs
 add  sp, 2
;-317 	asm mov [ParmTableSeg], ds

 mov [ParmTableSeg], ds
;-318 	//Offset is in DiskBuf

;-319 	BIOS_Status=Int13hRW(2,drive,0,0,1,1,ParmTableSeg,DiskBuf);

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
;-320 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .testDisk11
 call Int13hError
;-321 //	printhex16(BIOS_Status);	

;-322 	cputs(", Part.Info: Magic=");

.testDisk11:
 push testDisk_1
 call cputs
 add  sp, 2
;-323 	i=510;

 mov ax, 510
 mov [bp-2], ax
;-324 	c = DiskBuf[i];

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov [bp-6], al
;-325 	printhex8(c);

 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-326 	i++;

 inc  word[bp-2]
;-327 	c = DiskBuf[i];

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov [bp-6], al
;-328 	printhex8(c);

 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-329 	

;-330 	cputs(",DiskBuf=");

 push testDisk_2
 call cputs
 add  sp, 2
;-331 	printhex16(ParmTableSeg);

 push word [ParmTableSeg]
 call printhex16
 add  sp, 2
;-332 	putch(':');							

 push 58
 call putch
 add  sp, 2
;-333 	printhex16(DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 call printhex16
 add  sp, 2
;-334 	putch('.');

 push 46
 call putch
 add  sp, 2
;-335 

;-336     putch(10);		

 push 10
 call putch
 add  sp, 2
;-337 	i=0;

 mov ax, 0
 mov [bp-2], ax
;-338 	cputs("Part=");

 push testDisk_3
 call cputs
 add  sp, 2
;-339 	printhex8(i);

 push word [bp-2]
 call printhex8
 add  sp, 2
;-340 	j=0x1be;

 mov ax, 446
 mov [bp-4], ax
;-341 	ptBootable=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptBootable], al
;-342 	cputs(",BootId=");

 push testDisk_4
 call cputs
 add  sp, 2
;-343 	printhex8(ptBootable);

 mov al, byte [ptBootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-344 	j++;

 inc  word[bp-4]
;-345 	ptStartHead=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptStartHead], al
;-346 	cputs(",StartHd=");

 push testDisk_5
 call cputs
 add  sp, 2
;-347 	printhex8(ptStartHead);

 mov al, byte [ptStartHead]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-348 	j++;

 inc  word[bp-4]
;-349 	ptStartSector=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptStartSector], al
;-350 	ah=0;//next line convert byte to word

 mov  ah, 0
;-351 	ptStartCylinder=ptStartSector;//see next 5 line		

 mov al, [ptStartSector]
 mov word [ptStartCylinder], ax
;-352 	ptStartSector &= 0x3F;

 and  byte[ptStartSector], 63
;-353 	ptStartSector++;//Sector start with 1

 inc  byte[ptStartSector]
;-354 	cputs(",StartSec=");

 push testDisk_6
 call cputs
 add  sp, 2
;-355 	printhex8(ptStartSector);	

 mov al, byte [ptStartSector]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-356 	ptStartCylinder &= 0xC0;

 and  word[ptStartCylinder], 192
;-357 	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	

 mov ax, [ptStartCylinder]
 shl ax, 2
 mov word [ptStartCylinder], ax
;-358 	j++;

 inc  word[bp-4]
;-359 	ah=0;//byte 2 word

 mov  ah, 0
;-360 	ptStartCylinder=DiskBuf[j] + ptStartCylinder;

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 add ax, [ptStartCylinder]
 mov word [ptStartCylinder], ax
;-361 //	byte add, ok because low byte is empty

;-362 //	ptStartCylinder=ptStartCylinder + DiskBuf[j];//OK

;-363 	cputs(",StartCyl=");

 push testDisk_7
 call cputs
 add  sp, 2
;-364 	printhex16(ptStartCylinder);

 push word [ptStartCylinder]
 call printhex16
 add  sp, 2
;-365 	j++;

 inc  word[bp-4]
;-366 	ptFileSystem=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptFileSystem], al
;-367 	cputs(",FileID=");

 push testDisk_8
 call cputs
 add  sp, 2
;-368 	printhex8(ptFileSystem);

 mov al, byte [ptFileSystem]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-369 	j++;

 inc  word[bp-4]
;-370 	ptEndHead=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptEndHead], al
;-371 	cputs(",EndHd=");

 push testDisk_9
 call cputs
 add  sp, 2
;-372 	printhex8(ptEndHead);

 mov al, byte [ptEndHead]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-373 	j++;

 inc  word[bp-4]
;-374 	ptEndSector=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptEndSector], al
;-375 	

;-376 		

;-377 	

;-378 }	

;-379 

;-380 int mdump(unsigned char *adr, unsigned int len ) {

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
;-381     unsigned char c;

;-382     int i;

;-383     int j;

;-384     j=0;

;Function : mdump, Number local Var: 5
; # type sign width local variables
;47 ptr unsg byte adr = bp+4
;48 var unsg word len = bp+6
;49 var unsg byte c = bp-2
;50 var sign word i = bp-4
;51 var sign word j = bp-6;
 ENTER  6,0
 mov ax, 0
 mov [bp-6], ax
;-385     while (j < len ) {

.mdump12:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump13
;-386         putch(10);

 push 10
 call putch
 add  sp, 2
;-387         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-388         putch(':');

 push 58
 call putch
 add  sp, 2
;-389         i=0;

 mov ax, 0
 mov [bp-4], ax
;-390         while (i < 16) {

.mdump14:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump15
;-391             putch(' ');

 push 32
 call putch
 add  sp, 2
;-392             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-393             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-394             adr++;

 inc  word[bp+4]
;-395             i++;

 inc  word[bp-4]
;-396             j++;

 inc  word[bp-6]
;-397             }

;-398         putch(' ');

 jmp .mdump14
.mdump15:
 push 32
 call putch
 add  sp, 2
;-399         adr -=16;

 sub  word[bp+4], 16
;-400         i=0;

 mov ax, 0
 mov [bp-4], ax
;-401         while(i < 16) {

.mdump16:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump17
;-402             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-403             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump18
 push 46
 call putch
 add  sp, 2
;-404                 else putch(c);

 jmp .mdump19
.mdump18:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-405             adr++;

.mdump19:
 inc  word[bp+4]
;-406             i++;

 inc  word[bp-4]
;-407         }

;-408     }

 jmp .mdump16
.mdump17:
;-409 }

 jmp .mdump12
.mdump13:
;-410 char Dummy[10];

 LEAVE
 ret
ENDP
section .bss
absolute 5808
Dummy resb 10
section .text
;-411 

;-412 

;-413 //------------------------------------ main ---------------

;-414 int main() {


main: PROC
;-415 //	unsigned int i;

;-416 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-417 //	i = 0;

;-418 

;-419 //  LabelAddr[LabelMaxIx] = AbsoluteLab;

;-420 

;-421 

;-422 //	asm  mov [DiskBuf+bx], al

;-423 	

;-424 //	asm mov [Dummy+bx], al

;-425 		

;-426 //	DiskBuf [i] = 0;

;-427 	

;-428 //	do {

;-429 //		DiskBuf[i] = 0;

;-430 //		i++;

;-431 //	} while (i < 100);

;-432 

;-433 	Params(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Params
 add  sp, 2
;-434 	testDisk(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call testDisk
 add  sp, 2
;-435 

;-436 //	mdump(DiskBuf, 256);

;-437 	

;-438 

;-439 	putch(10);

 push 10
 call putch
 add  sp, 2
;-440 	cputs("(41)Ext present :");

 push main_0
 call cputs
 add  sp, 2
;-441 	bx=0x55AA;

 mov  bx, 21930
;-442 	BIOS_Status=Int13hRawIO(0x80, 0x41);	

 push 65
 push 128
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-443 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .main20
 call Int13hError
;-444 	//BIOS_Status=ax;01: Extension supported

;-445 	asm mov [vBX], bx;0xAA55 Extension installed

.main20:
 mov [vBX], bx;0xAA55 Extension installed
;-446 	asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			
;-447 	printhex16(BIOS_Status);		

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-448 

;-449 /*	DosBox Disk Services Int13h:

;-450 	00	Reset Disk System

;-451 	01	Get Status of Last Drive Operation

;-452 	02	Read Sectors

;-453 	03	Write Sectors

;-454 	08	Get Drive Parameters

;-455 	only DosBox_X:

;-456 	41	EXT Extension Available

;-457 	42	EXT Read Sectors

;-458 	43	EXT Write Sectors

;-459 	48	EXT Read Drive Parameter

;-460 */

;-461 /*

;-462     setblock(4096);// 64KB

;-463 

;-464     GetIntVec(0x21);

;-465     cputs(" Main Int21h old=");

;-466     printhex16(VecOldSeg);

;-467     putch(':');

;-468     printhex16(VecOldOfs);

;-469 

;-470     asm mov dx, DOS_START

;-471 //    asm lea dx, [DOS_START]

;-472     ax=0x2521;

;-473     DosInt();

;-474 //    ShowRegister();

;-475 

;-476     GetIntVecNew(0x21);

;-477     cputs(" Int21h new=");

;-478     printhex16(VecNewSeg);

;-479     putch(':');

;-480     printhex16(VecNewOfs);

;-481 

;-482     cputs(" count21h=");

;-483     printunsign(count21h);

;-484     cputs(" end main.");

;-485 

;-486 //    asm int 32;20h exit

;-487 

;-488     asm mov dx, main;get adr of main in dx//Terminate stay resident

;-489     asm shr dx, 4   ;make para

;-490     asm add dx, 17  ;PSP in para + align to next para

;-491     ax=0x3100;

;-492     DosInt();

;-493 */

;-494 

;-495 }

 ret
main_0 db "(41)Ext present :",0
ENDP
;Glob. variables:47 (400):437 (4000), Functions:22 (300):209 (3000)
;Lines:496, Constant: 294 (3000), stacksize: 59717