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

;-14 int writetty()     {


writetty: PROC
;-15     ah=0x0E;

 mov  ah, 14
;-16     bx=0;

 mov  bx, 0
;-17     asm int 16

 int 16
;-18 }

;-19 int putch(char c)  {

 ret
ENDP

putch: PROC
;-20     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;12 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-21         al=13;

 mov  al, 13
;-22         writetty();

 call writetty
;-23     }

;-24     al=c;

.putch1:
 mov  al, [bp+4]
;-25     writetty();

 call writetty
;-26 }

;-27 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-28     char c;

;-29     while(*s) {

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
;-30         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-31         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-32         s++;

 inc  word[bp+4]
;-33     }

;-34 }

 jmp .cputs2
.cputs3:
;-35 

;-36 int printhex4(unsigned char c) {

 LEAVE
 ret
ENDP

printhex4: PROC
;-37     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;12 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-38     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex44
 add  byte[bp+4], 7
;-39     putch(c);

.printhex44:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-40 }

;-41 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-42     unsigned char nib;

;-43     nib = c >> 4; printhex4(nib);

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
;-44     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-45 }

;-46 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-47     unsigned int half;

;-48     half = i >>  8; printhex8(half);

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
;-49     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-50 }

;-51 

;-52 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-53     unsigned int e;

;-54     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;12 var unsg word n = bp+4
;13 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign5
;-55         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-56         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-57         }

;-58     n=n%10;

.printunsign5:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-59     n+='0';

 add  word[bp+4], 48
;-60     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-61 }

;-62 

;-63 int ShowRegister() {

 LEAVE
 ret
ENDP

ShowRegister: PROC
;-64     asm mov [vAX], ax

 mov [vAX], ax
;-65     asm mov [vBX], bx

 mov [vBX], bx
;-66     asm mov [vCX], cx

 mov [vCX], cx
;-67     asm mov [vDX], dx

 mov [vDX], dx
;-68     asm mov [vSP], sp

 mov [vSP], sp
;-69     asm mov [vBP], bp

 mov [vBP], bp
;-70     asm mov ax, cs

 mov ax, cs
;-71     asm mov [vCS], ax

 mov [vCS], ax
;-72     asm mov ax, ds

 mov ax, ds
;-73     asm mov [vDS], ax

 mov [vDS], ax
;-74     asm mov ax, ss

 mov ax, ss
;-75     asm mov [vSS], ax

 mov [vSS], ax
;-76     asm mov ax, es

 mov ax, es
;-77     asm mov [vES], ax

 mov [vES], ax
;-78     putch(10);

 push 10
 call putch
 add  sp, 2
;-79     cputs( "AX="); printhex16(vAX);

 push ShowRegister_0
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-80     cputs(",BX="); printhex16(vBX);

 push ShowRegister_1
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-81     cputs(",CX="); printhex16(vCX);

 push ShowRegister_2
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-82     cputs(",DX="); printhex16(vDX);

 push ShowRegister_3
 call cputs
 add  sp, 2
 push word [vDX]
 call printhex16
 add  sp, 2
;-83     cputs(",SP="); printhex16(vSP);

 push ShowRegister_4
 call cputs
 add  sp, 2
 push word [vSP]
 call printhex16
 add  sp, 2
;-84     cputs(",BP="); printhex16(vBP);

 push ShowRegister_5
 call cputs
 add  sp, 2
 push word [vBP]
 call printhex16
 add  sp, 2
;-85     cputs(",CS="); printhex16(vCS);

 push ShowRegister_6
 call cputs
 add  sp, 2
 push word [vCS]
 call printhex16
 add  sp, 2
;-86     cputs(",DS="); printhex16(vDS);

 push ShowRegister_7
 call cputs
 add  sp, 2
 push word [vDS]
 call printhex16
 add  sp, 2
;-87     cputs(",SS="); printhex16(vSS);

 push ShowRegister_8
 call cputs
 add  sp, 2
 push word [vSS]
 call printhex16
 add  sp, 2
;-88     cputs(",ES="); printhex16(vES);

 push ShowRegister_9
 call cputs
 add  sp, 2
 push word [vES]
 call printhex16
 add  sp, 2
;-89 }

;-90 

;-91 

;-92 //--------------------------------  disk IO  -------------------

;-93 char BIOS_ERR=0;

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
;-94 int  BIOS_Status=0;

BIOS_Status dw 0
;-95 char DiskBuf [512];

section .bss
absolute 4096
DiskBuf resb 512
section .text
;-96 char Drive;

Drive db 0
;-97 int  Cylinders;

Cylinders dw 0
;-98 char Sectors;

Sectors db 0
;-99 char Heads;

Heads db 0
;-100 char Attached;

Attached db 0
;-101 int  ParmTableSeg;

ParmTableSeg dw 0
;-102 int  ParmTableOfs;

ParmTableOfs dw 0
;-103 char DriveType;

DriveType db 0
;-104 //hard disk partition structure

;-105 unsigned char ptBootable;	//80h = active partition, else 00

ptBootable db 0
;-106 unsigned char ptStartHead;	//

ptStartHead db 0
;-107 unsigned char ptStartSector;	//bits 0-5

ptStartSector db 0
;-108 unsigned int  ptStartCylinder;//bits 8,9 in bits 6,7 of sector

ptStartCylinder dw 0
;-109 unsigned char ptFileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=hugePart

ptFileSystem db 0
;-110 unsigned char ptEndHead;		//

ptEndHead db 0
;-111 unsigned char ptEndSector;	//bits 0-5

ptEndSector db 0
;-112 unsigned int  ptEndCylinder;	//bits 8,9 in bits 6,7 of sector

ptEndCylinder dw 0
;-113 unsigned int ptStartSectorlo;//sectors preceding partition

ptStartSectorlo dw 0
;-114 unsigned int ptStartSectorhi;

ptStartSectorhi dw 0
;-115 unsigned int ptPartLenlo;    //length of partition in sectors

ptPartLenlo dw 0
;-116 unsigned int ptPartLenhi;

ptPartLenhi dw 0
;-117 

;-118 

;-119 int Int13hRW(char rw, char drive, char head, int cyl, int sector,


Int13hRW: PROC
;-120 	int count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-121 	BIOS_ERR=0;	

;Function : Int13hRW, Number local Var: 8
; # type sign width local variables
;35 var sign byte rw = bp+4
;36 var sign byte drive = bp+6
;37 var sign byte head = bp+8
;38 var sign word cyl = bp+10
;39 var sign word sector = bp+12
;40 var sign word count = bp+14
;41 var sign word BufSeg = bp+16
;42 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-122 	dl=drive;

 mov  dl, [bp+6]
;-123 	dh=head;

 mov  dh, [bp+8]
;-124 	es=BufSeg;

 mov  es, [bp+16]
;-125 	bx=BufOfs;

 mov  bx, [bp+18]
;-126 	cx=cyl;	

 mov  cx, [bp+10]
;-127 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-128 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-129 	sector &= 0x3F;//only 6 bits for sector

 and  word[bp+12], 63
;-130 	cl += sector;

 add  cl, [bp+12]
;-131 	ch=cyl;//low byte of cyl in ch

 mov  ch, [bp+10]
;-132 	

;-133 	al=count;

 mov  al, [bp+14]
;-134 	ah=rw;

 mov  ah, [bp+4]
;-135 	inth 0x13;

 int  19
;-136     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-137 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-138 }

;-139 int Int13hRawIO(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hRawIO: PROC
;-140 	BIOS_ERR=0;	

;Function : Int13hRawIO, Number local Var: 2
; # type sign width local variables
;35 var sign byte drive = bp+4
;36 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-141 	dl=drive;

 mov  dl, [bp+4]
;-142 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-143 	inth 0x13;

 int  19
;-144     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-145 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-146 }

;-147 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-148 	cputs(" ** disk error AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-149 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-150 //	cputs(" BIOS_ERR=");

;-151 //	printunsign(BIOS_ERR);

;-152 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-153 //	putch(10);

;-154 	BIOS_Status=Int13hRawIO(Drive, 0);//Reset

 push 0
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-155 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-156 }	

;-157 

;-158 int PrintDriveParms() {

 ret
Int13hError_0 db " ** disk error AX=",0
Int13hError_1 db ".  ",0
ENDP

PrintDriveParms: PROC
;-159 	asm mov [Heads],        dh

 mov [Heads],        dh
;-160 	Heads++;//1 to 256

 inc  byte[Heads]
;-161 	asm mov [Attached],     dl

 mov [Attached],     dl
;-162 	asm mov [ParmTableSeg], es

 mov [ParmTableSeg], es
;-163 	asm mov [ParmTableOfs], di

 mov [ParmTableOfs], di
;-164 	asm mov [DriveType],    bl;BiosType(biosval)

 mov [DriveType],    bl;BiosType(biosval)
;-165 	// CX =       ---CH--- ---CL---

;-166 	// cylinder : 76543210 98

;-167 	// sector   :            543210	

;-168 	asm mov [Sectors],      cl

 mov [Sectors],      cl
;-169 	Sectors &= 0x3F;// 63

 and  byte[Sectors], 63
;-170 	Sectors++;//1 to 64

 inc  byte[Sectors]
;-171 

;-172 	asm mov [Cylinders],    cl	

 mov [Cylinders],    cl	
;-173 	Cylinders &= 0xC0;//;bit 9 and 10

 and  word[Cylinders], 192
;-174 	Cylinders = Cylinders << 2;//compiler flaw:

 mov ax, [Cylinders]
 shl ax, 2
 mov word [Cylinders], ax
;-175 	asm add [Cylinders],    ch;//byte add, low byte is empty	

 add [Cylinders],    ch;//byte add, low byte is empty	
;-176 //	Cylinders++;//1 to 1024	

;-177 

;-178 	putch(10);

 push 10
 call putch
 add  sp, 2
;-179 	cputs("HD Params:");		 	//printhex8(Drive);

 push PrintDriveParms_0
 call cputs
 add  sp, 2
;-180 	cputs(" Cyl=");						printunsign(Cylinders);

 push PrintDriveParms_1
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
;-181 	cputs(", Sec=");					printunsign(Sectors);

 push PrintDriveParms_2
 call cputs
 add  sp, 2
 mov al, byte [Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-182 	cputs(", Hd=");						printunsign(Heads);

 push PrintDriveParms_3
 call cputs
 add  sp, 2
 mov al, byte [Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-183 	cputs(", Attached=");				printhex8(Attached);

 push PrintDriveParms_4
 call cputs
 add  sp, 2
 mov al, byte [Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-184 	putch(10);	

 push 10
 call putch
 add  sp, 2
;-185 	cputs("DriveType (FL)=");			printhex8(DriveType);

 push PrintDriveParms_5
 call cputs
 add  sp, 2
 mov al, byte [DriveType]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-186 	cputs(", ParmTable=");				printhex16(ParmTableSeg);

 push PrintDriveParms_6
 call cputs
 add  sp, 2
 push word [ParmTableSeg]
 call printhex16
 add  sp, 2
;-187 	putch(':');							printhex16(ParmTableOfs);

 push 58
 call putch
 add  sp, 2
 push word [ParmTableOfs]
 call printhex16
 add  sp, 2
;-188 	putch('.');

 push 46
 call putch
 add  sp, 2
;-189 }

;-190 

;-191 int Params(drive) {

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
;-192 	putch(10);	

;Function : Params, Number local Var: 1
; # type sign width local variables
;35 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-193 	cputs("(8)Drive Params :");

 push Params_0
 call cputs
 add  sp, 2
;-194 	BIOS_Status=Int13hRawIO(drive, 8);//error

 push 8
 push word [bp+4]
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-195 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Params6
 call Int13hError
;-196 	printhex16(BIOS_Status);	

.Params6:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-197     PrintDriveParms();

 call PrintDriveParms
;-198 

;-199 	putch(10);

 push 10
 call putch
 add  sp, 2
;-200 	cputs("(10h)Status :");

 push Params_1
 call cputs
 add  sp, 2
;-201 	BIOS_Status=Int13hRawIO(drive, 0x10);	

 push 16
 push word [bp+4]
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-202 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Params7
 call Int13hError
;-203 	printhex16(BIOS_Status);	

.Params7:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-204 }

;-205 

;-206 int Status(drive) {

 LEAVE
 ret
Params_0 db "(8)Drive Params :",0
Params_1 db "(10h)Status :",0
ENDP

Status: PROC
;-207 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;35 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-208 	cputs("(1)Status last Op: AH=FL, AL=HD :");

 push Status_0
 call cputs
 add  sp, 2
;-209 	BIOS_Status=Int13hRawIO(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-210 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status8
 call Int13hError
;-211 	printhex16(BIOS_Status);	

.Status8:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-212 }	

;-213 

;-214 int testDisk(drive) {

 LEAVE
 ret
Status_0 db "(1)Status last Op: AH=FL, AL=HD :",0
ENDP

testDisk: PROC
;-215 	int i; int j; char c;

;-216 	putch(10);

;Function : testDisk, Number local Var: 4
; # type sign width local variables
;35 var sign word drive = bp+4
;36 var sign word i = bp-2
;37 var sign word j = bp-4
;38 var sign byte c = bp-6;
 ENTER  6,0
 push 10
 call putch
 add  sp, 2
;-217 	cputs("ReadStat=");	

 push testDisk_0
 call cputs
 add  sp, 2
;-218 	asm mov [ParmTableSeg], ds

 mov [ParmTableSeg], ds
;-219 	//Offset is in DiskBuf

;-220 	BIOS_Status=Int13hRW(2,drive,0,0,1,1,ParmTableSeg,DiskBuf);

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
;-221 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .testDisk9
 call Int13hError
;-222 //	printhex16(BIOS_Status);	

;-223 	cputs(", Part.Info: Magic=");

.testDisk9:
 push testDisk_1
 call cputs
 add  sp, 2
;-224 	i=510;

 mov ax, 510
 mov [bp-2], ax
;-225 	c = DiskBuf[i];

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov [bp-6], al
;-226 	printhex8(c);

 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-227 	i++;

 inc  word[bp-2]
;-228 	c = DiskBuf[i];

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov [bp-6], al
;-229 	printhex8(c);

 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-230 	

;-231 	cputs(",DiskBuf=");

 push testDisk_2
 call cputs
 add  sp, 2
;-232 	printhex16(ParmTableSeg);

 push word [ParmTableSeg]
 call printhex16
 add  sp, 2
;-233 	putch(':');							

 push 58
 call putch
 add  sp, 2
;-234 	printhex16(DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 call printhex16
 add  sp, 2
;-235 	putch('.');

 push 46
 call putch
 add  sp, 2
;-236 

;-237     putch(10);		

 push 10
 call putch
 add  sp, 2
;-238 	i=0;

 mov ax, 0
 mov [bp-2], ax
;-239 	cputs("Part=");

 push testDisk_3
 call cputs
 add  sp, 2
;-240 	printhex8(i);

 push word [bp-2]
 call printhex8
 add  sp, 2
;-241 	j=0x1be;

 mov ax, 446
 mov [bp-4], ax
;-242 	ptBootable=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptBootable], al
;-243 	cputs(",BootId=");

 push testDisk_4
 call cputs
 add  sp, 2
;-244 	printhex8(ptBootable);

 mov al, byte [ptBootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-245 	j++;

 inc  word[bp-4]
;-246 	ptStartHead=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptStartHead], al
;-247 	cputs(",StartHd=");

 push testDisk_5
 call cputs
 add  sp, 2
;-248 	printhex8(ptStartHead);

 mov al, byte [ptStartHead]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-249 	j++;

 inc  word[bp-4]
;-250 	ptStartSector=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptStartSector], al
;-251 	ah=0;//next line convert byte to word

 mov  ah, 0
;-252 	ptStartCylinder=ptStartSector;//see next 5 line		

 mov al, [ptStartSector]
 mov word [ptStartCylinder], ax
;-253 	ptStartSector &= 0x3F;

 and  byte[ptStartSector], 63
;-254 	ptStartSector++;//Sector start with 1

 inc  byte[ptStartSector]
;-255 	cputs(",StartSec=");

 push testDisk_6
 call cputs
 add  sp, 2
;-256 	printhex8(ptStartSector);	

 mov al, byte [ptStartSector]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-257 	ptStartCylinder &= 0xC0;

 and  word[ptStartCylinder], 192
;-258 	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	

 mov ax, [ptStartCylinder]
 shl ax, 2
 mov word [ptStartCylinder], ax
;-259 	j++;

 inc  word[bp-4]
;-260 	ah=0;//byte 2 word

 mov  ah, 0
;-261 	ptStartCylinder=DiskBuf[j] + ptStartCylinder;

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 add ax, [ptStartCylinder]
 mov word [ptStartCylinder], ax
;-262 //	byte add, ok because low byte is empty

;-263 //	ptStartCylinder=ptStartCylinder + DiskBuf[j];//OK

;-264 	cputs(",StartCyl=");

 push testDisk_7
 call cputs
 add  sp, 2
;-265 	printhex16(ptStartCylinder);

 push word [ptStartCylinder]
 call printhex16
 add  sp, 2
;-266 	j++;

 inc  word[bp-4]
;-267 	ptFileSystem=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptFileSystem], al
;-268 	cputs(",FileID=");

 push testDisk_8
 call cputs
 add  sp, 2
;-269 	printhex8(ptFileSystem);

 mov al, byte [ptFileSystem]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-270 	j++;

 inc  word[bp-4]
;-271 	ptEndHead=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptEndHead], al
;-272 	cputs(",EndHd=");

 push testDisk_9
 call cputs
 add  sp, 2
;-273 	printhex8(ptEndHead);

 mov al, byte [ptEndHead]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-274 	j++;

 inc  word[bp-4]
;-275 	ptEndSector=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptEndSector], al
;-276 	

;-277 		

;-278 	

;-279 }	

;-280 

;-281 //------------------------------------ main ---------------

;-282 int main() {

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
;-283 //	unsigned int i;

;-284 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-285 

;-286 	Params(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Params
 add  sp, 2
;-287 	testDisk(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call testDisk
 add  sp, 2
;-288 

;-289 //	mdump(DiskBuf, 256);

;-290 	

;-291 

;-292 	putch(10);

 push 10
 call putch
 add  sp, 2
;-293 	cputs("(41)Ext present :");

 push main_0
 call cputs
 add  sp, 2
;-294 	bx=0x55AA;

 mov  bx, 21930
;-295 	BIOS_Status=Int13hRawIO(0x80, 0x41);	

 push 65
 push 128
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-296 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .main10
 call Int13hError
;-297 	//BIOS_Status=ax;01: Extension supported

;-298 	asm mov [vBX], bx;0xAA55 Extension installed

.main10:
 mov [vBX], bx;0xAA55 Extension installed
;-299 	asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			
;-300 	printhex16(BIOS_Status);		

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-301 

;-302 /*	DosBox Disk Services Int13h:

;-303 	00	Reset Disk System

;-304 	01	Get Status of Last Drive Operation

;-305 	02	Read Sectors

;-306 	03	Write Sectors

;-307 	08	Get Drive Parameters

;-308 	only DosBox_X:

;-309 	41	EXT Extension Available

;-310 	42	EXT Read Sectors

;-311 	43	EXT Write Sectors

;-312 	48	EXT Read Drive Parameter

;-313 */

;-314 

;-315 }

 ret
main_0 db "(41)Ext present :",0
ENDP
;Glob. variables:34 (400):311 (4000), Functions:16 (300):154 (3000)
;Lines:316, Constant: 294 (3000), stacksize: 60927