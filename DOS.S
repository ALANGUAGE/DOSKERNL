;PLA compiler A.COM V1.0.1, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.1.2";//test bed

Version1 db "DOS.COM V0.1.2",0
;-2 //todo: resize and take own stack

;-3 #define ORGDATA		4000//start of arrays

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

;-18 int writetty()     {


writetty: PROC
;-19     ah=0x0E;

 mov  ah, 14
;-20     bx=0;

 mov  bx, 0
;-21     asm int 16

 int 16
;-22 }

;-23 int putch(char c)  {

 ret
ENDP

putch: PROC
;-24     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;14 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-25         al=13;

 mov  al, 13
;-26         writetty();

 call writetty
;-27     }

;-28     al=c;

.putch1:
 mov  al, [bp+4]
;-29     writetty();

 call writetty
;-30 }

;-31 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-32     char c;

;-33     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;14 ptr sign byte s = bp+4
;15 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-34         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-35         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-36         s++;

 inc  word[bp+4]
;-37     }

;-38 }

 jmp .cputs2
.cputs3:
;-39 

;-40 int printhex4(unsigned char c) {

 LEAVE
 ret
ENDP

printhex4: PROC
;-41     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;14 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-42     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex44
 add  byte[bp+4], 7
;-43     putch(c);

.printhex44:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-44 }

;-45 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-46     unsigned char nib;

;-47     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;14 var unsg byte c = bp+4
;15 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-48     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-49 }

;-50 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-51     unsigned int half;

;-52     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;14 var unsg word i = bp+4
;15 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-53     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-54 }

;-55 

;-56 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-57     unsigned int e;

;-58     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;14 var unsg word n = bp+4
;15 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign5
;-59         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-60         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-61         }

;-62     n=n%10;

.printunsign5:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-63     n+='0';

 add  word[bp+4], 48
;-64     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-65 }

;-66 

;-67 int ShowRegister() {

 LEAVE
 ret
ENDP

ShowRegister: PROC
;-68     asm mov [vAX], ax

 mov [vAX], ax
;-69     asm mov [vBX], bx

 mov [vBX], bx
;-70     asm mov [vCX], cx

 mov [vCX], cx
;-71     asm mov [vDX], dx

 mov [vDX], dx
;-72     asm mov [vSP], sp

 mov [vSP], sp
;-73     asm mov [vBP], bp

 mov [vBP], bp
;-74     asm mov ax, cs

 mov ax, cs
;-75     asm mov [vCS], ax

 mov [vCS], ax
;-76     asm mov ax, ds

 mov ax, ds
;-77     asm mov [vDS], ax

 mov [vDS], ax
;-78     asm mov ax, ss

 mov ax, ss
;-79     asm mov [vSS], ax

 mov [vSS], ax
;-80     asm mov ax, es

 mov ax, es
;-81     asm mov [vES], ax

 mov [vES], ax
;-82     putch(10);

 push 10
 call putch
 add  sp, 2
;-83     cputs( "AX="); printhex16(vAX);

 push ShowRegister_0
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-84     cputs(",BX="); printhex16(vBX);

 push ShowRegister_1
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-85     cputs(",CX="); printhex16(vCX);

 push ShowRegister_2
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-86     cputs(",DX="); printhex16(vDX);

 push ShowRegister_3
 call cputs
 add  sp, 2
 push word [vDX]
 call printhex16
 add  sp, 2
;-87     cputs(",SP="); printhex16(vSP);

 push ShowRegister_4
 call cputs
 add  sp, 2
 push word [vSP]
 call printhex16
 add  sp, 2
;-88     cputs(",BP="); printhex16(vBP);

 push ShowRegister_5
 call cputs
 add  sp, 2
 push word [vBP]
 call printhex16
 add  sp, 2
;-89     cputs(",CS="); printhex16(vCS);

 push ShowRegister_6
 call cputs
 add  sp, 2
 push word [vCS]
 call printhex16
 add  sp, 2
;-90     cputs(",DS="); printhex16(vDS);

 push ShowRegister_7
 call cputs
 add  sp, 2
 push word [vDS]
 call printhex16
 add  sp, 2
;-91     cputs(",SS="); printhex16(vSS);

 push ShowRegister_8
 call cputs
 add  sp, 2
 push word [vSS]
 call printhex16
 add  sp, 2
;-92     cputs(",ES="); printhex16(vES);

 push ShowRegister_9
 call cputs
 add  sp, 2
 push word [vES]
 call printhex16
 add  sp, 2
;-93 }

;-94 

;-95 //Int = pushf + call far

;-96 //Int = pushf + push cs + push offset DOS_START + jmp far cs:VecOldOfs

;-97 int DosInt() {

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

;-183 //-------------------  disk IO  -----------------

;-184 char BIOS_ERR=0;

 LEAVE
 ret
setblock_0 db " ***Error SetBlock***",0
setblock_1 db "SetBlock AX:",0
setblock_2 db ",BX:",0
ENDP
BIOS_ERR db 0
;-185 int  BIOS_Status=0;

BIOS_Status dw 0
;-186 char DiskBuf[512];

section .bss
absolute 4000
DiskBuf resb 512
section .text
;-187 char Drive;

Drive db 0
;-188 int  Cylinders;

Cylinders dw 0
;-189 int  Sectors;

Sectors dw 0
;-190 int  Heads;

Heads dw 0
;-191 char Attached;

Attached db 0
;-192 int  ParmTableSeg;

ParmTableSeg dw 0
;-193 int  ParmTableOfs;

ParmTableOfs dw 0
;-194 char DriveType;

DriveType db 0
;-195 

;-196 int Int13hError() {


Int13hError: PROC
;-197 	cputs("*** disk error #(hex) :");

 push Int13hError_0
 call cputs
 add  sp, 2
;-198 	printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-199 }	

;-200 int Int13hRawIO(char drive, char function) {

 ret
Int13hError_0 db "*** disk error #(hex) :",0
ENDP

Int13hRawIO: PROC
;-201 	BIOS_ERR=0;	

;Function : Int13hRawIO, Number local Var: 2
; # type sign width local variables
;31 var sign byte drive = bp+4
;32 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-202 	dl=drive;

 mov  dl, [bp+4]
;-203 	ah=function;//0=reset, 1=status, 8=parms, 10h=hd status

 mov  ah, [bp+6]
;-204 	inth 0x13;

 int  19
;-205     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-206 	BIOS_ERR++;//Status or error code in AH

 inc  byte[BIOS_ERR]
;-207 }

;-208 

;-209 int Int13hRW(char rw, char drive, int head, int cyl, int sector,

 LEAVE
 ret
ENDP

Int13hRW: PROC
;-210 	int count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-211 	BIOS_ERR=0;	

;Function : Int13hRW, Number local Var: 8
; # type sign width local variables
;31 var sign byte rw = bp+4
;32 var sign byte drive = bp+6
;33 var sign word head = bp+8
;34 var sign word cyl = bp+10
;35 var sign word sector = bp+12
;36 var sign word count = bp+14
;37 var sign word BufSeg = bp+16
;38 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-212 	dl=drive;

 mov  dl, [bp+6]
;-213 	dh=head;

 mov  dh, [bp+8]
;-214 	es=BufSeg;

 mov  es, [bp+16]
;-215 	bx=BufOfs;

 mov  bx, [bp+18]
;-216 	cx=cyl;	

 mov  cx, [bp+10]
;-217 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-218 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-219 	sector &= 0x3F;//only 6 bits for sector

 and  word[bp+12], 63
;-220 	cl += sector;

 add  cl, [bp+12]
;-221 	ch=cyl;//low byte of cyl in ch

 mov  ch, [bp+10]
;-222 	

;-223 	al=count;

 mov  al, [bp+14]
;-224 	ah=rw;

 mov  ah, [bp+4]
;-225 	inth 0x13;

 int  19
;-226     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-227 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-228 }

;-229 int Int13hReset() {

 LEAVE
 ret
ENDP

Int13hReset: PROC
;-230 	BIOS_Status=Int13hRawIO(0x80, 0);

 push 0
 push 128
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-231 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hReset8
 call Int13hError
;-232 }

.Int13hReset8:
;-233 int Int13hStatusRead() {

 ret
ENDP

Int13hStatusRead: PROC
;-234 	BIOS_Status=Int13hRawIO(0x80, 1);

 push 1
 push 128
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-235 	//AH=Status Floppy, AL=Status fixed disk	

;-236 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hStatusRead9
 call Int13hError
;-237 	// AL is destroyed but we have AX in BIOS_Status 

;-238 }				 

.Int13hStatusRead9:
;-239 int Int13hDriveParams() {

 ret
ENDP

Int13hDriveParams: PROC
;-240 	BIOS_Status=Int13hRawIO(0x80, 8);

 push 8
 push 128
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-241 	asm mov [Sectors],      cl

 mov [Sectors],      cl
;-242 	Sectors &= 0x3F;

 and  word[Sectors], 63
;-243 	Sectors++;//1 to 64

 inc  word[Sectors]
;-244 

;-245 	asm mov [Cylinders],    cl	

 mov [Cylinders],    cl	
;-246 	Cylinders &= 0xC0;//;bit 9 and 10

 and  word[Cylinders], 192
;-247 	Cylinders << 2;//compiler flaw: forget to store in Cylinders

 mov ax, [Cylinders]
 shl ax, 2
;-248 	asm mov [Cylinders],    ax

 mov [Cylinders],    ax
;-249 	asm add [Cylinders],    ch;low byte	

 add [Cylinders],    ch;low byte	
;-250 	Cylinders++;//1 to 1024

 inc  word[Cylinders]
;-251 

;-252 	asm mov [Heads],        dh

 mov [Heads],        dh
;-253 	Heads++;//1 to 256

 inc  word[Heads]
;-254 	asm mov [Attached],     dl

 mov [Attached],     dl
;-255 	asm mov [ParmTableSeg], es

 mov [ParmTableSeg], es
;-256 	asm mov [ParmTableOfs], di

 mov [ParmTableOfs], di
;-257 	asm mov [DriveType],    bl

 mov [DriveType],    bl
;-258 	if (BIOS_ERR) Int13hError();//the above params are invalid	

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hDriveParams10
 call Int13hError
;-259 }	

.Int13hDriveParams10:
;-260 int Int13hHardDriveStatus() {

 ret
ENDP

Int13hHardDriveStatus: PROC
;-261 	BIOS_Status=Int13hRawIO(0x80, 0x10);

 push 16
 push 128
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-262 	

;-263 	if (BIOS_ERR) Int13hError();//the above params are invalid			

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hHardDriveStatus11
 call Int13hError
;-264 }	

.Int13hHardDriveStatus11:
;-265 

;-266 int PrintDriveParms() {

 ret
ENDP

PrintDriveParms: PROC
;-267 	cputs(" HD Params: Drive :"); 		printhex8(Drive);

 push PrintDriveParms_0
 call cputs
 add  sp, 2
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-268 	cputs(", Cyl :");					printunsign(Cylinders);

 push PrintDriveParms_1
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
;-269 	cputs(", Sec :");					printunsign(Sectors);

 push PrintDriveParms_2
 call cputs
 add  sp, 2
 push word [Sectors]
 call printunsign
 add  sp, 2
;-270 	cputs(", Hd :");

 push PrintDriveParms_3
 call cputs
 add  sp, 2
;-271 }

;-272 	

;-273 int main() {

 ret
PrintDriveParms_0 db " HD Params: Drive :",0
PrintDriveParms_1 db ", Cyl :",0
PrintDriveParms_2 db ", Sec :",0
PrintDriveParms_3 db ", Hd :",0
ENDP

main: PROC
;-274     DOS_ERR = 0;

 mov ax, 0
 mov byte [DOS_ERR], al
;-275     Int13hDriveParams();

 call Int13hDriveParams
;-276     PrintDriveParms();

 call PrintDriveParms
;-277 /*

;-278     setblock(4096);// 64KB

;-279 

;-280     GetIntVec(0x21);

;-281     cputs(" Main Int21h old=");

;-282     printhex16(VecOldSeg);

;-283     putch(':');

;-284     printhex16(VecOldOfs);

;-285 

;-286     asm mov dx, DOS_START

;-287 //    asm lea dx, [DOS_START]

;-288     ax=0x2521;

;-289     DosInt();

;-290 //    ShowRegister();

;-291 

;-292     GetIntVecNew(0x21);

;-293     cputs(" Int21h new=");

;-294     printhex16(VecNewSeg);

;-295     putch(':');

;-296     printhex16(VecNewOfs);

;-297 

;-298     cputs(" count21h=");

;-299     printunsign(count21h);

;-300     cputs(" end main.");

;-301 

;-302 //    asm int 32;20h exit

;-303 

;-304     asm mov dx, main;get adr of main in dx//Terminate stay resident

;-305     asm shr dx, 4   ;make para

;-306     asm add dx, 17  ;PSP in para + align to next para

;-307     ax=0x3100;

;-308     DosInt();

;-309 */

;-310 

;-311 }

 ret
ENDP
;Glob. variables:30 (400):228 (4000), Functions:22 (300):249 (3000)
;Lines:312, Constant: 279 (3000), stacksize: 61023