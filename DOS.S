;PLA compiler A.COM V1.0.1, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.1.2";//Int13 branch

Version1 db "DOS.COM V0.1.2",0
;-2 #define ORGDATA		4096//start of arrays

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

;-17 #define LABELADRMAX 600

;-18 unsigned int LabelAddr[LABELADRMAX];//addr of each label

section .bss
absolute 4096
LabelAddr resw 600
section .text
;-19 int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1

LabelMaxIx dw 0
;-20 

;-21 unsigned int AbsoluteLab=0;//uninitialised data

AbsoluteLab dw 0
;-22 

;-23 

;-24 int writetty()     {


writetty: PROC
;-25     ah=0x0E;

 mov  ah, 14
;-26     bx=0;

 mov  bx, 0
;-27     asm int 16

 int 16
;-28 }

;-29 int putch(char c)  {

 ret
ENDP

putch: PROC
;-30     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;18 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-31         al=13;

 mov  al, 13
;-32         writetty();

 call writetty
;-33     }

;-34     al=c;

.putch1:
 mov  al, [bp+4]
;-35     writetty();

 call writetty
;-36 }

;-37 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-38     char c;

;-39     while(*s) {

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
;-40         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-41         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-42         s++;

 inc  word[bp+4]
;-43     }

;-44 }

 jmp .cputs2
.cputs3:
;-45 

;-46 int printhex4(unsigned char c) {

 LEAVE
 ret
ENDP

printhex4: PROC
;-47     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;18 var unsg byte c = bp+4;
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

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;18 var unsg word n = bp+4
;19 var unsg word e = bp-2;
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

;-101 

;-102 //--------------------------------  disk IO  -------------------

;-103 char BIOS_ERR=0;

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
BIOS_ERR db 0
;-104 int  BIOS_Status=0;

BIOS_Status dw 0
;-105 char DiskBuf [512];

section .bss
absolute 5296
DiskBuf resb 512
section .text
;-106 char Drive;

Drive db 0
;-107 int  Cylinders;

Cylinders dw 0
;-108 char Sectors;

Sectors db 0
;-109 char Heads;

Heads db 0
;-110 char Attached;

Attached db 0
;-111 int  ParmTableSeg;

ParmTableSeg dw 0
;-112 int  ParmTableOfs;

ParmTableOfs dw 0
;-113 char DriveType;

DriveType db 0
;-114 //hard disk partition structure

;-115 unsigned char ptBootable;	//80h = active partition, else 00

ptBootable db 0
;-116 unsigned char ptStartHead;	//

ptStartHead db 0
;-117 unsigned char ptStartSector;	//bits 0-5

ptStartSector db 0
;-118 unsigned int  ptStartCylinder;//bits 8,9 in bits 6,7 of sector

ptStartCylinder dw 0
;-119 unsigned char ptFileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=hugePart

ptFileSystem db 0
;-120 unsigned char ptEndHead;		//

ptEndHead db 0
;-121 unsigned char ptEndSector;	//bits 0-5

ptEndSector db 0
;-122 unsigned int  ptEndCylinder;	//bits 8,9 in bits 6,7 of sector

ptEndCylinder dw 0
;-123 unsigned int ptStartSectorlo;//sectors preceding partition

ptStartSectorlo dw 0
;-124 unsigned int ptStartSectorhi;

ptStartSectorhi dw 0
;-125 unsigned int ptPartLenlo;    //length of partition in sectors

ptPartLenlo dw 0
;-126 unsigned int ptPartLenhi;

ptPartLenhi dw 0
;-127 

;-128 

;-129 int Int13hRW(char rw, char drive, char head, int cyl, int sector,


Int13hRW: PROC
;-130 	int count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-131 	BIOS_ERR=0;	

;Function : Int13hRW, Number local Var: 8
; # type sign width local variables
;41 var sign byte rw = bp+4
;42 var sign byte drive = bp+6
;43 var sign byte head = bp+8
;44 var sign word cyl = bp+10
;45 var sign word sector = bp+12
;46 var sign word count = bp+14
;47 var sign word BufSeg = bp+16
;48 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-132 	dl=drive;

 mov  dl, [bp+6]
;-133 	dh=head;

 mov  dh, [bp+8]
;-134 	es=BufSeg;

 mov  es, [bp+16]
;-135 	bx=BufOfs;

 mov  bx, [bp+18]
;-136 	cx=cyl;	

 mov  cx, [bp+10]
;-137 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-138 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-139 	sector &= 0x3F;//only 6 bits for sector

 and  word[bp+12], 63
;-140 	cl += sector;

 add  cl, [bp+12]
;-141 	ch=cyl;//low byte of cyl in ch

 mov  ch, [bp+10]
;-142 	

;-143 	al=count;

 mov  al, [bp+14]
;-144 	ah=rw;

 mov  ah, [bp+4]
;-145 	inth 0x13;

 int  19
;-146     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-147 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-148 }

;-149 int Int13hRawIO(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hRawIO: PROC
;-150 	BIOS_ERR=0;	

;Function : Int13hRawIO, Number local Var: 2
; # type sign width local variables
;41 var sign byte drive = bp+4
;42 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-151 	dl=drive;

 mov  dl, [bp+4]
;-152 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-153 	inth 0x13;

 int  19
;-154     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-155 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-156 }

;-157 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-158 	cputs(" ** disk error AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-159 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-160 //	cputs(" BIOS_ERR=");

;-161 //	printunsign(BIOS_ERR);

;-162 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-163 //	putch(10);

;-164 	BIOS_Status=Int13hRawIO(Drive, 0);//Reset

 push 0
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-165 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-166 }	

;-167 

;-168 int PrintDriveParms() {

 ret
Int13hError_0 db " ** disk error AX=",0
Int13hError_1 db ".  ",0
ENDP

PrintDriveParms: PROC
;-169 	asm mov [Heads],        dh

 mov [Heads],        dh
;-170 	Heads++;//1 to 256

 inc  byte[Heads]
;-171 	asm mov [Attached],     dl

 mov [Attached],     dl
;-172 	asm mov [ParmTableSeg], es

 mov [ParmTableSeg], es
;-173 	asm mov [ParmTableOfs], di

 mov [ParmTableOfs], di
;-174 	asm mov [DriveType],    bl;BiosType(biosval)

 mov [DriveType],    bl;BiosType(biosval)
;-175 	// CX =       ---CH--- ---CL---

;-176 	// cylinder : 76543210 98

;-177 	// sector   :            543210	

;-178 	asm mov [Sectors],      cl

 mov [Sectors],      cl
;-179 	Sectors &= 0x3F;// 63

 and  byte[Sectors], 63
;-180 	Sectors++;//1 to 64

 inc  byte[Sectors]
;-181 

;-182 	asm mov [Cylinders],    cl	

 mov [Cylinders],    cl	
;-183 	Cylinders &= 0xC0;//;bit 9 and 10

 and  word[Cylinders], 192
;-184 	Cylinders = Cylinders << 2;//compiler flaw:

 mov ax, [Cylinders]
 shl ax, 2
 mov word [Cylinders], ax
;-185 	asm add [Cylinders],    ch;//byte add, low byte is empty	

 add [Cylinders],    ch;//byte add, low byte is empty	
;-186 //	Cylinders++;//1 to 1024	

;-187 

;-188 	putch(10);

 push 10
 call putch
 add  sp, 2
;-189 	cputs("HD Params:");		 	//printhex8(Drive);

 push PrintDriveParms_0
 call cputs
 add  sp, 2
;-190 	cputs(" Cyl=");						printunsign(Cylinders);

 push PrintDriveParms_1
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
;-191 	cputs(", Sec=");					printunsign(Sectors);

 push PrintDriveParms_2
 call cputs
 add  sp, 2
 mov al, byte [Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-192 	cputs(", Hd=");						printunsign(Heads);

 push PrintDriveParms_3
 call cputs
 add  sp, 2
 mov al, byte [Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-193 	cputs(", Attached=");				printhex8(Attached);

 push PrintDriveParms_4
 call cputs
 add  sp, 2
 mov al, byte [Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-194 	putch(10);	

 push 10
 call putch
 add  sp, 2
;-195 	cputs("DriveType (FL)=");			printhex8(DriveType);

 push PrintDriveParms_5
 call cputs
 add  sp, 2
 mov al, byte [DriveType]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-196 	cputs(", ParmTable=");				printhex16(ParmTableSeg);

 push PrintDriveParms_6
 call cputs
 add  sp, 2
 push word [ParmTableSeg]
 call printhex16
 add  sp, 2
;-197 	putch(':');							printhex16(ParmTableOfs);

 push 58
 call putch
 add  sp, 2
 push word [ParmTableOfs]
 call printhex16
 add  sp, 2
;-198 	putch('.');

 push 46
 call putch
 add  sp, 2
;-199 }

;-200 

;-201 int Params(drive) {

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
;-202 	putch(10);	

;Function : Params, Number local Var: 1
; # type sign width local variables
;41 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-203 	cputs("(8)Drive Params :");

 push Params_0
 call cputs
 add  sp, 2
;-204 	BIOS_Status=Int13hRawIO(drive, 8);//error

 push 8
 push word [bp+4]
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-205 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Params6
 call Int13hError
;-206 	printhex16(BIOS_Status);	

.Params6:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-207     PrintDriveParms();

 call PrintDriveParms
;-208 

;-209 	putch(10);

 push 10
 call putch
 add  sp, 2
;-210 	cputs("(10h)Status :");

 push Params_1
 call cputs
 add  sp, 2
;-211 	BIOS_Status=Int13hRawIO(drive, 0x10);	

 push 16
 push word [bp+4]
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-212 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Params7
 call Int13hError
;-213 	printhex16(BIOS_Status);	

.Params7:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-214 }

;-215 

;-216 int Status(drive) {

 LEAVE
 ret
Params_0 db "(8)Drive Params :",0
Params_1 db "(10h)Status :",0
ENDP

Status: PROC
;-217 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;41 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-218 	cputs("(1)Status last Op: AH=FL, AL=HD :");

 push Status_0
 call cputs
 add  sp, 2
;-219 	BIOS_Status=Int13hRawIO(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-220 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status8
 call Int13hError
;-221 	printhex16(BIOS_Status);	

.Status8:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-222 }	

;-223 

;-224 int testDisk(drive) {

 LEAVE
 ret
Status_0 db "(1)Status last Op: AH=FL, AL=HD :",0
ENDP

testDisk: PROC
;-225 	int i; int j; char c;

;-226 	putch(10);

;Function : testDisk, Number local Var: 4
; # type sign width local variables
;41 var sign word drive = bp+4
;42 var sign word i = bp-2
;43 var sign word j = bp-4
;44 var sign byte c = bp-6;
 ENTER  6,0
 push 10
 call putch
 add  sp, 2
;-227 	cputs("ReadStat=");	

 push testDisk_0
 call cputs
 add  sp, 2
;-228 	asm mov [ParmTableSeg], ds

 mov [ParmTableSeg], ds
;-229 	//Offset is in DiskBuf

;-230 	BIOS_Status=Int13hRW(2,drive,0,0,1,1,ParmTableSeg,DiskBuf);

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
;-231 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .testDisk9
 call Int13hError
;-232 //	printhex16(BIOS_Status);	

;-233 	cputs(", Part.Info: Magic=");

.testDisk9:
 push testDisk_1
 call cputs
 add  sp, 2
;-234 	i=510;

 mov ax, 510
 mov [bp-2], ax
;-235 	c = DiskBuf[i];

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov [bp-6], al
;-236 	printhex8(c);

 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-237 	i++;

 inc  word[bp-2]
;-238 	c = DiskBuf[i];

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov [bp-6], al
;-239 	printhex8(c);

 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-240 	

;-241 	cputs(",DiskBuf=");

 push testDisk_2
 call cputs
 add  sp, 2
;-242 	printhex16(ParmTableSeg);

 push word [ParmTableSeg]
 call printhex16
 add  sp, 2
;-243 	putch(':');							

 push 58
 call putch
 add  sp, 2
;-244 	printhex16(DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 call printhex16
 add  sp, 2
;-245 	putch('.');

 push 46
 call putch
 add  sp, 2
;-246 

;-247     putch(10);		

 push 10
 call putch
 add  sp, 2
;-248 	i=0;

 mov ax, 0
 mov [bp-2], ax
;-249 	cputs("Part=");

 push testDisk_3
 call cputs
 add  sp, 2
;-250 	printhex8(i);

 push word [bp-2]
 call printhex8
 add  sp, 2
;-251 	j=0x1be;

 mov ax, 446
 mov [bp-4], ax
;-252 	ptBootable=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptBootable], al
;-253 	cputs(",BootId=");

 push testDisk_4
 call cputs
 add  sp, 2
;-254 	printhex8(ptBootable);

 mov al, byte [ptBootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-255 	j++;

 inc  word[bp-4]
;-256 	ptStartHead=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptStartHead], al
;-257 	cputs(",StartHd=");

 push testDisk_5
 call cputs
 add  sp, 2
;-258 	printhex8(ptStartHead);

 mov al, byte [ptStartHead]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-259 	j++;

 inc  word[bp-4]
;-260 	ptStartSector=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptStartSector], al
;-261 	ah=0;//next line convert byte to word

 mov  ah, 0
;-262 	ptStartCylinder=ptStartSector;//see next 5 line		

 mov al, [ptStartSector]
 mov word [ptStartCylinder], ax
;-263 	ptStartSector &= 0x3F;

 and  byte[ptStartSector], 63
;-264 	ptStartSector++;//Sector start with 1

 inc  byte[ptStartSector]
;-265 	cputs(",StartSec=");

 push testDisk_6
 call cputs
 add  sp, 2
;-266 	printhex8(ptStartSector);	

 mov al, byte [ptStartSector]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-267 	ptStartCylinder &= 0xC0;

 and  word[ptStartCylinder], 192
;-268 	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	

 mov ax, [ptStartCylinder]
 shl ax, 2
 mov word [ptStartCylinder], ax
;-269 	j++;

 inc  word[bp-4]
;-270 	ah=0;//byte 2 word

 mov  ah, 0
;-271 	ptStartCylinder=DiskBuf[j] + ptStartCylinder;

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 add ax, [ptStartCylinder]
 mov word [ptStartCylinder], ax
;-272 //	byte add, ok because low byte is empty

;-273 //	ptStartCylinder=ptStartCylinder + DiskBuf[j];//OK

;-274 	cputs(",StartCyl=");

 push testDisk_7
 call cputs
 add  sp, 2
;-275 	printhex16(ptStartCylinder);

 push word [ptStartCylinder]
 call printhex16
 add  sp, 2
;-276 	j++;

 inc  word[bp-4]
;-277 	ptFileSystem=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptFileSystem], al
;-278 	cputs(",FileID=");

 push testDisk_8
 call cputs
 add  sp, 2
;-279 	printhex8(ptFileSystem);

 mov al, byte [ptFileSystem]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-280 	j++;

 inc  word[bp-4]
;-281 	ptEndHead=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptEndHead], al
;-282 	cputs(",EndHd=");

 push testDisk_9
 call cputs
 add  sp, 2
;-283 	printhex8(ptEndHead);

 mov al, byte [ptEndHead]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-284 	j++;

 inc  word[bp-4]
;-285 	ptEndSector=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptEndSector], al
;-286 	

;-287 		

;-288 	

;-289 }	

;-290 

;-291 //------------------------------------ main ---------------

;-292 int main() {

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

main: PROC
;-293 //	unsigned int i;

;-294 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-295 

;-296 	Params(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Params
 add  sp, 2
;-297 	testDisk(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call testDisk
 add  sp, 2
;-298 

;-299 //	mdump(DiskBuf, 256);

;-300 	

;-301 

;-302 	putch(10);

 push 10
 call putch
 add  sp, 2
;-303 	cputs("(41)Ext present :");

 push main_0
 call cputs
 add  sp, 2
;-304 	bx=0x55AA;

 mov  bx, 21930
;-305 	BIOS_Status=Int13hRawIO(0x80, 0x41);	

 push 65
 push 128
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-306 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .main10
 call Int13hError
;-307 	//BIOS_Status=ax;01: Extension supported

;-308 	asm mov [vBX], bx;0xAA55 Extension installed

.main10:
 mov [vBX], bx;0xAA55 Extension installed
;-309 	asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			
;-310 	printhex16(BIOS_Status);		

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-311 

;-312 /*	DosBox Disk Services Int13h:

;-313 	00	Reset Disk System

;-314 	01	Get Status of Last Drive Operation

;-315 	02	Read Sectors

;-316 	03	Write Sectors

;-317 	08	Get Drive Parameters

;-318 	only DosBox_X:

;-319 	41	EXT Extension Available

;-320 	42	EXT Read Sectors

;-321 	43	EXT Write Sectors

;-322 	48	EXT Read Drive Parameter

;-323 */

;-324 

;-325 }

 ret
main_0 db "(41)Ext present :",0
ENDP
;Glob. variables:40 (400):373 (4000), Functions:16 (300):154 (3000)
;Lines:326, Constant: 294 (3000), stacksize: 59727