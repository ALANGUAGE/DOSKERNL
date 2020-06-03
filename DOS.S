;PLA compiler A.COM V1.0.1, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.1.2";//test bed

Version1 db "DOS.COM V0.1.2",0
;-2 //todo: resize and take own stack

;-3 //Finder / DOS1.vmdk / Rechtsclick / Öffnen / Parallels Mounter

;-4 #define ORGDATA		8192//start of arrays

;-5 unsigned int vAX;

vAX dw 0
;-6 unsigned int vBX;

vBX dw 0
;-7 unsigned int vCX;

vCX dw 0
;-8 unsigned int vDX;

vDX dw 0
;-9 unsigned int vSP;

vSP dw 0
;-10 unsigned int vBP;

vBP dw 0
;-11 unsigned int vCS;

vCS dw 0
;-12 unsigned int vDS;

vDS dw 0
;-13 unsigned int vSS;

vSS dw 0
;-14 unsigned int vES;

vES dw 0
;-15 

;-16 char DOS_ERR=0;

DOS_ERR db 0
;-17 unsigned int count21h=0;

count21h dw 0
;-18 

;-19 int writetty()     {//char in AL


writetty: PROC
;-20     ah=0x0E;

 mov  ah, 14
;-21     push bx;

push bx;
;-22     bx=0;			//page in BH

 mov  bx, 0
;-23     inth 0x10;		//16

 int  16
;-24     pop bx;

pop bx;
;-25 }

;-26 int putch(char c)  {

 ret
ENDP

putch: PROC
;-27     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;14 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-28         al=13;

 mov  al, 13
;-29         writetty();

 call writetty
;-30     }

;-31     al=c;

.putch1:
 mov  al, [bp+4]
;-32     writetty();

 call writetty
;-33 }

;-34 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-35     char c;

;-36     while(*s) {

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
;-37         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-38         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-39         s++;

 inc  word[bp+4]
;-40     }

;-41 }

 jmp .cputs2
.cputs3:
;-42 

;-43 int printhex4(unsigned char c) {

 LEAVE
 ret
ENDP

printhex4: PROC
;-44     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;14 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-45     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex44
 add  byte[bp+4], 7
;-46     putch(c);

.printhex44:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-47 }

;-48 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-49     unsigned char nib;

;-50     nib = c >> 4; printhex4(nib);

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
;-51     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-52 }

;-53 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-54     unsigned int half;

;-55     half = i >>  8; printhex8(half);

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
;-56     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-57 }

;-58 

;-59 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-60     unsigned int e;

;-61     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;14 var unsg word n = bp+4
;15 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign5
;-62         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-63         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-64         }

;-65     n=n%10;

.printunsign5:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-66     n+='0';

 add  word[bp+4], 48
;-67     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-68 }

;-69 int ShowRegister() {

 LEAVE
 ret
ENDP

ShowRegister: PROC
;-70     asm mov [vAX], ax

 mov [vAX], ax
;-71     asm mov [vBX], bx

 mov [vBX], bx
;-72     asm mov [vCX], cx

 mov [vCX], cx
;-73     asm mov [vDX], dx

 mov [vDX], dx
;-74     asm mov [vSP], sp

 mov [vSP], sp
;-75     asm mov [vBP], bp

 mov [vBP], bp
;-76     asm mov ax, cs

 mov ax, cs
;-77     asm mov [vCS], ax

 mov [vCS], ax
;-78     asm mov ax, ds

 mov ax, ds
;-79     asm mov [vDS], ax

 mov [vDS], ax
;-80     asm mov ax, ss

 mov ax, ss
;-81     asm mov [vSS], ax

 mov [vSS], ax
;-82     asm mov ax, es

 mov ax, es
;-83     asm mov [vES], ax

 mov [vES], ax
;-84     putch(10);

 push 10
 call putch
 add  sp, 2
;-85     cputs( "AX="); printhex16(vAX);

 push ShowRegister_0
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-86     cputs(",BX="); printhex16(vBX);

 push ShowRegister_1
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-87     cputs(",CX="); printhex16(vCX);

 push ShowRegister_2
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-88     cputs(",DX="); printhex16(vDX);

 push ShowRegister_3
 call cputs
 add  sp, 2
 push word [vDX]
 call printhex16
 add  sp, 2
;-89     cputs(",SP="); printhex16(vSP);

 push ShowRegister_4
 call cputs
 add  sp, 2
 push word [vSP]
 call printhex16
 add  sp, 2
;-90     cputs(",BP="); printhex16(vBP);

 push ShowRegister_5
 call cputs
 add  sp, 2
 push word [vBP]
 call printhex16
 add  sp, 2
;-91     cputs(",CS="); printhex16(vCS);

 push ShowRegister_6
 call cputs
 add  sp, 2
 push word [vCS]
 call printhex16
 add  sp, 2
;-92     cputs(",DS="); printhex16(vDS);

 push ShowRegister_7
 call cputs
 add  sp, 2
 push word [vDS]
 call printhex16
 add  sp, 2
;-93     cputs(",SS="); printhex16(vSS);

 push ShowRegister_8
 call cputs
 add  sp, 2
 push word [vSS]
 call printhex16
 add  sp, 2
;-94     cputs(",ES="); printhex16(vES);

 push ShowRegister_9
 call cputs
 add  sp, 2
 push word [vES]
 call printhex16
 add  sp, 2
;-95 }

;-96 

;-97 //--------------------------------  disk IO  -------------------

;-98 char BIOS_ERR=0;

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
;-99 unsigned int  BIOS_Status=0;

BIOS_Status dw 0
;-100 char DiskBuf [512];

section .bss
absolute 8192
DiskBuf resb 512
section .text
;-101 char Drive;

Drive db 0
;-102 unsigned int  Cylinders;

Cylinders dw 0
;-103 char Sectors;

Sectors db 0
;-104 char Heads;

Heads db 0
;-105 char Attached;

Attached db 0
;-106 int  ParmTableSeg;

ParmTableSeg dw 0
;-107 int  ParmTableOfs;

ParmTableOfs dw 0
;-108 char DriveType;

DriveType db 0
;-109 int  PartNo;

PartNo dw 0
;-110 //hard disk partition structure

;-111 unsigned char ptBootable;	//80h = active partition, else 00

ptBootable db 0
;-112 unsigned char ptStartHead;	//

ptStartHead db 0
;-113 unsigned char ptStartSector;	//bits 0-5

ptStartSector db 0
;-114 unsigned int  ptStartCylinder;//bits 8,9 in bits 6,7 of sector

ptStartCylinder dw 0
;-115 unsigned char ptFileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=hugePart

ptFileSystem db 0
;-116 unsigned char ptEndHead;		//

ptEndHead db 0
;-117 unsigned char ptEndSector;	//bits 0-5

ptEndSector db 0
;-118 unsigned int  ptEndCylinder;	//bits 8,9 in bits 6,7 of sector

ptEndCylinder dw 0
;-119 unsigned int ptStartSectorlo;//sectors preceding partition

ptStartSectorlo dw 0
;-120 unsigned int ptStartSectorhi;

ptStartSectorhi dw 0
;-121 unsigned int ptPartLenlo;    //length of partition in sectors

ptPartLenlo dw 0
;-122 unsigned int ptPartLenhi;

ptPartLenhi dw 0
;-123 

;-124 int Int13hRW(char rw, char drive, char head, int cyl, char sector,


Int13hRW: PROC
;-125 	char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-126 	BIOS_ERR=0;	

;Function : Int13hRW, Number local Var: 8
; # type sign width local variables
;38 var sign byte rw = bp+4
;39 var sign byte drive = bp+6
;40 var sign byte head = bp+8
;41 var sign word cyl = bp+10
;42 var sign byte sector = bp+12
;43 var sign byte count = bp+14
;44 var sign word BufSeg = bp+16
;45 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-127 	dl=drive;

 mov  dl, [bp+6]
;-128 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-129 	es=BufSeg;

 mov  es, [bp+16]
;-130 	bx=BufOfs;

 mov  bx, [bp+18]
;-131 	cx=cyl;	

 mov  cx, [bp+10]
;-132 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-133 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-134 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-135 	cl += sector;

 add  cl, [bp+12]
;-136 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-137 	

;-138 	al=count;

 mov  al, [bp+14]
;-139 	ah=rw;

 mov  ah, [bp+4]
;-140 	inth 0x13;

 int  19
;-141     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-142 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-143 }

;-144 int Int13hRaw(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hRaw: PROC
;-145 	BIOS_ERR=0;	

;Function : Int13hRaw, Number local Var: 2
; # type sign width local variables
;38 var sign byte drive = bp+4
;39 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-146 	dl=drive;

 mov  dl, [bp+4]
;-147 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-148 	inth 0x13;

 int  19
;-149     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-150 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-151 }

;-152 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-153 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-154 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-155 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-156 	BIOS_Status=Int13hRaw(Drive, 0);//Reset

 push 0
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-157 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-158 }	

;-159 

;-160 int Params(char drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Params: PROC
;-161 	cputs("(AH=08)Drive Params:");

;Function : Params, Number local Var: 1
; # type sign width local variables
;38 var sign byte drive = bp+4;
 ENTER  0,0
 push Params_0
 call cputs
 add  sp, 2
;-162 	BIOS_Status=Int13hRaw(drive, 8);

 push 8
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-163 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Params6
 call Int13hError
;-164 	else {

 jmp .Params7
.Params6:
;-165 		cputs("AH Return Code:");

 push Params_1
 call cputs
 add  sp, 2
;-166 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-167 		asm mov [Heads],        dh

 mov [Heads],        dh
;-168 		Heads++;

 inc  byte[Heads]
;-169 		asm mov [Attached],     dl

 mov [Attached],     dl
;-170 		// CX =       ---CH--- ---CL---

;-171 		// cylinder : 76543210 98

;-172 		// sector   :            543210	

;-173 		asm mov [Sectors],      cl

 mov [Sectors],      cl
;-174 		Sectors &= 0x3F;// 63

 and  byte[Sectors], 63
;-175 //		Sectors++;//1 to 64

;-176 	

;-177 		asm mov [Cylinders],    cx	

 mov [Cylinders],    cx	
;-178 		Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[Cylinders], 192
;-179 		Cylinders = Cylinders << 2;//compiler flaw:

 mov ax, [Cylinders]
 shl ax, 2
 mov word [Cylinders], ax
;-180 		asm add [Cylinders],    ch;//byte add, low byte is empty	

 add [Cylinders],    ch;//byte add, low byte is empty	
;-181 	

;-182 		putch(10);

 push 10
 call putch
 add  sp, 2
;-183 		cputs("CHS=");				printunsign(Cylinders);

 push Params_2
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
;-184 		putch('/');					printunsign(Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-185 		putch('/');					printunsign(Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-186 		cputs(", NoDrives=");		printhex8(Attached);

 push Params_3
 call cputs
 add  sp, 2
 mov al, byte [Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-187 		putch('.');

 push 46
 call putch
 add  sp, 2
;-188 	}

;-189 }

.Params7:
;-190 

;-191 int Status(drive) {

 LEAVE
 ret
Params_0 db "(AH=08)Drive Params:",0
Params_1 db "AH Return Code:",0
Params_2 db "CHS=",0
Params_3 db ", NoDrives=",0
ENDP

Status: PROC
;-192 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;38 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-193 	cputs("(1)Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-194 	BIOS_Status=Int13hRaw(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-195 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status8
 call Int13hError
;-196 	printhex16(BIOS_Status);	

.Status8:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-197 }	

;-198 

;-199 int getPartitionData() {

 LEAVE
 ret
Status_0 db "(1)Status last Op=",0
ENDP

getPartitionData: PROC
;-200 	unsigned int j; char c; 

;-201 	j = PartNo << 4;

;Function : getPartitionData, Number local Var: 2
; # type sign width local variables
;38 var unsg word j = bp-2
;39 var sign byte c = bp-4;
 ENTER  4,0
 mov ax, [PartNo]
 shl ax, 4
 mov [bp-2], ax
;-202 	j = j + 0x1be;			ptBootable=DiskBuf[j];

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptBootable], al
;-203 	j++;					ptStartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartHead], al
;-204 	j++;					ptStartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartSector], al
;-205 	ah=0;//next line convert byte to word

 mov  ah, 0
;-206 	ptStartCylinder=ptStartSector;	

 mov al, [ptStartSector]
 mov word [ptStartCylinder], ax
;-207 	ptStartSector &= 0x3F;

 and  byte[ptStartSector], 63
;-208 	ptStartSector++;//Sector start with 1

 inc  byte[ptStartSector]
;-209 	ptStartCylinder &= 0xC0;

 and  word[ptStartCylinder], 192
;-210 	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	

 mov ax, [ptStartCylinder]
 shl ax, 2
 mov word [ptStartCylinder], ax
;-211 	j++;

 inc  word[bp-2]
;-212 	ah=0;//byte 2 word

 mov  ah, 0
;-213 	ptStartCylinder=DiskBuf[j] + ptStartCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptStartCylinder]
 mov word [ptStartCylinder], ax
;-214 //	byte add, ok because low byte is empty

;-215 //	ptStartCylinder=ptStartCylinder + DiskBuf[j];//OK

;-216 

;-217 	j++;					ptFileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptFileSystem], al
;-218 	j++;					ptEndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndHead], al
;-219 	j++;					ptEndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndSector], al
;-220 	ah=0;//next line convert byte to word

 mov  ah, 0
;-221 	ptEndCylinder=ptEndSector;//see next 5 line		

 mov al, [ptEndSector]
 mov word [ptEndCylinder], ax
;-222 	ptEndSector &= 0x3F;

 and  byte[ptEndSector], 63
;-223 	ptEndSector++;//Sector start with 1

 inc  byte[ptEndSector]
;-224 	ptEndCylinder &= 0xC0;

 and  word[ptEndCylinder], 192
;-225 	ptEndCylinder = ptEndCylinder << 2;//OK no short cut!	

 mov ax, [ptEndCylinder]
 shl ax, 2
 mov word [ptEndCylinder], ax
;-226 	j++;

 inc  word[bp-2]
;-227 	ah=0;//byte 2 word

 mov  ah, 0
;-228 	ptEndCylinder=DiskBuf[j] + ptEndCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptEndCylinder]
 mov word [ptEndCylinder], ax
;-229 //	byte add, ok because low byte is empty

;-230 //	ptStartCylinder=ptStartCylinder + DiskBuf[j];//OK

;-231 

;-232 	j++;					ptStartSectorlo = DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov word [ptStartSectorlo], ax
;-233 	j += 2;					ptStartSectorhi = DiskBuf[j];

 add  word[bp-2], 2
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov word [ptStartSectorhi], ax
;-234 	j += 2;					ptPartLenhi = DiskBuf[j];

 add  word[bp-2], 2
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov word [ptPartLenhi], ax
;-235 	j += 2;					ptPartLenlo = DiskBuf[j];

 add  word[bp-2], 2
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov word [ptPartLenlo], ax
;-236 	j += 2;//next partition entry

 add  word[bp-2], 2
;-237 }

;-238 	

;-239 int printPartitionData() {

 LEAVE
 ret
ENDP

printPartitionData: PROC
;-240 	putch(10);		

 push 10
 call putch
 add  sp, 2
;-241 	cputs("No=");			printunsign(PartNo);

 push printPartitionData_0
 call cputs
 add  sp, 2
 push word [PartNo]
 call printunsign
 add  sp, 2
;-242 	cputs(",Boot=");		printhex8(ptBootable);

 push printPartitionData_1
 call cputs
 add  sp, 2
 mov al, byte [ptBootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-243 	cputs(" ID=");			printunsign(ptFileSystem);

 push printPartitionData_2
 call cputs
 add  sp, 2
 mov al, byte [ptFileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-244 	cputs(",Start HSC=");	printunsign(ptStartHead);

 push printPartitionData_3
 call cputs
 add  sp, 2
 mov al, byte [ptStartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-245 	cputs("/");				printunsign(ptStartSector);	

 push printPartitionData_4
 call cputs
 add  sp, 2
 mov al, byte [ptStartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-246 	cputs("/");				printunsign(ptStartCylinder);

 push printPartitionData_5
 call cputs
 add  sp, 2
 push word [ptStartCylinder]
 call printunsign
 add  sp, 2
;-247 	cputs("-");				printunsign(ptEndHead);

 push printPartitionData_6
 call cputs
 add  sp, 2
 mov al, byte [ptEndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-248 	cputs("/");				printunsign(ptEndSector);	

 push printPartitionData_7
 call cputs
 add  sp, 2
 mov al, byte [ptEndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-249 	cputs("/");				printunsign(ptEndCylinder);

 push printPartitionData_8
 call cputs
 add  sp, 2
 push word [ptEndCylinder]
 call printunsign
 add  sp, 2
;-250 //	putch(10);		

;-251 	cputs(",Start=");

 push printPartitionData_9
 call cputs
 add  sp, 2
;-252 	printhex16(ptStartSectorhi);

 push word [ptStartSectorhi]
 call printhex16
 add  sp, 2
;-253 	printhex16(ptStartSectorlo);

 push word [ptStartSectorlo]
 call printhex16
 add  sp, 2
;-254 	cputs(",Len=");

 push printPartitionData_10
 call cputs
 add  sp, 2
;-255 	printhex16(ptPartLenhi);

 push word [ptPartLenhi]
 call printhex16
 add  sp, 2
;-256 	printhex16(ptPartLenlo);

 push word [ptPartLenlo]
 call printhex16
 add  sp, 2
;-257 }

;-258 	

;-259 int testDisk(drive) {

 ret
printPartitionData_0 db "No=",0
printPartitionData_1 db ",Boot=",0
printPartitionData_2 db " ID=",0
printPartitionData_3 db ",Start HSC=",0
printPartitionData_4 db "/",0
printPartitionData_5 db "/",0
printPartitionData_6 db "-",0
printPartitionData_7 db "/",0
printPartitionData_8 db "/",0
printPartitionData_9 db ",Start=",0
printPartitionData_10 db ",Len=",0
ENDP

testDisk: PROC
;-260 	char c; int i;

;-261 	asm mov [ParmTableSeg], ds

;Function : testDisk, Number local Var: 3
; # type sign width local variables
;38 var sign word drive = bp+4
;39 var sign byte c = bp-2
;40 var sign word i = bp-4;
 ENTER  4,0
 mov [ParmTableSeg], ds
;-262 	//Offset is in DiskBuf

;-263 	BIOS_Status=Int13hRW(2,drive,0,0,1,1,ParmTableSeg,DiskBuf);

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
;-264 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .testDisk9
 call Int13hError
;-265 	else {	

 jmp .testDisk10
.testDisk9:
;-266 		putch(10);

 push 10
 call putch
 add  sp, 2
;-267 		cputs("Read Partition Status:");

 push testDisk_0
 call cputs
 add  sp, 2
;-268 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-269 		cputs(",MBR Magic=");	

 push testDisk_1
 call cputs
 add  sp, 2
;-270 		i=510;		c = DiskBuf[i];		printhex8(c);

 mov ax, 510
 mov [bp-4], ax
 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-271 		i++;		c = DiskBuf[i];		printhex8(c);

 inc  word[bp-4]
 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-272 		

;-273 		cputs(",DiskBuf=");

 push testDisk_2
 call cputs
 add  sp, 2
;-274 		printhex16(ParmTableSeg);

 push word [ParmTableSeg]
 call printhex16
 add  sp, 2
;-275 		putch(':');							

 push 58
 call putch
 add  sp, 2
;-276 		printhex16(DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 call printhex16
 add  sp, 2
;-277 		putch('.');

 push 46
 call putch
 add  sp, 2
;-278 	

;-279 		PartNo=0;

 mov ax, 0
 mov word [PartNo], ax
;-280 		do {

.testDisk11:
;-281 			getPartitionData();

 call getPartitionData
;-282 			printPartitionData();

 call printPartitionData
;-283 			PartNo ++;

 inc  word[PartNo]
;-284 		} while (PartNo <4);

 mov ax, [PartNo]
 cmp ax, 4
 jge .testDisk12
 jmp .testDisk11
.testDisk12:
;-285 	}	

;-286 }

.testDisk10:
;-287 

;-288 int Int13hExt(char drive) {

 LEAVE
 ret
testDisk_0 db "Read Partition Status:",0
testDisk_1 db ",MBR Magic=",0
testDisk_2 db ",DiskBuf=",0
ENDP

Int13hExt: PROC
;-289 	putch(10);

;Function : Int13hExt, Number local Var: 1
; # type sign width local variables
;38 var sign byte drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-290 	cputs("Int13h 41hExt AX=");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-291 	bx=0x55AA;

 mov  bx, 21930
;-292 	BIOS_Status=Int13hRaw(0x80, 0x41);	

 push 65
 push 128
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-293 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-294 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt13
;-295 		cputs(" not present");	

 push Int13hExt_1
 call cputs
 add  sp, 2
;-296 		Int13hError();	

 call Int13hError
;-297 		}

;-298 	else {

 jmp .Int13hExt14
.Int13hExt13:
;-299 		cputs(" status=1:supported");

 push Int13hExt_2
 call cputs
 add  sp, 2
;-300 		asm mov [vBX], bx;0xAA55 Extension installed

 mov [vBX], bx;0xAA55 Extension installed
;-301 		asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			
;-302 		cputs(" BX=");		printhex16(vBX);

 push Int13hExt_3
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-303 		cputs(" CX=");		printhex16(vCX);

 push Int13hExt_4
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-304 		}		

;-305 }	

.Int13hExt14:
;-306 

;-307 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
Int13hExt_0 db "Int13h 41hExt AX=",0
Int13hExt_1 db " not present",0
Int13hExt_2 db " status=1:supported",0
Int13hExt_3 db " BX=",0
Int13hExt_4 db " CX=",0
ENDP

mdump: PROC
;-308     unsigned char c;

;-309     int i;

;-310     int j;

;-311     j=0;

;Function : mdump, Number local Var: 5
; # type sign width local variables
;38 ptr unsg byte adr = bp+4
;39 var unsg word len = bp+6
;40 var unsg byte c = bp-2
;41 var sign word i = bp-4
;42 var sign word j = bp-6;
 ENTER  6,0
 mov ax, 0
 mov [bp-6], ax
;-312     while (j < len ) {

.mdump15:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump16
;-313         putch(10);

 push 10
 call putch
 add  sp, 2
;-314         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-315         putch(':');

 push 58
 call putch
 add  sp, 2
;-316         i=0;

 mov ax, 0
 mov [bp-4], ax
;-317         while (i < 16) {

.mdump17:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump18
;-318             putch(' ');

 push 32
 call putch
 add  sp, 2
;-319             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-320             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-321             adr++;

 inc  word[bp+4]
;-322             i++;

 inc  word[bp-4]
;-323             j++;

 inc  word[bp-6]
;-324             }

;-325         putch(' ');

 jmp .mdump17
.mdump18:
 push 32
 call putch
 add  sp, 2
;-326         adr -=16;

 sub  word[bp+4], 16
;-327         i=0;

 mov ax, 0
 mov [bp-4], ax
;-328         while(i < 16) {

.mdump19:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump20
;-329             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-330             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump21
 push 46
 call putch
 add  sp, 2
;-331                 else putch(c);

 jmp .mdump22
.mdump21:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-332             adr++;

.mdump22:
 inc  word[bp+4]
;-333             i++;

 inc  word[bp-4]
;-334         }

;-335     }

 jmp .mdump19
.mdump20:
;-336 }

 jmp .mdump15
.mdump16:
;-337 

;-338 //------------------------------------ main ---------------

;-339 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-340 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-341 

;-342 	Params(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Params
 add  sp, 2
;-343 	testDisk(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call testDisk
 add  sp, 2
;-344 //	mdump(DiskBuf, 512);

;-345 	Int13hExt(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hExt
 add  sp, 2
;-346 }

 ret
ENDP
;Glob. variables:37 (400):335 (4000), Functions:19 (300):188 (3000)
;Lines:347, Constant: 372 (3000), stacksize: 56831