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

;-43 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-44     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-45     inth 0x16;//AH=Scan code, AL=char

 int  22
;-46 }

;-47 int waitkey() {

 ret
ENDP

waitkey: PROC
;-48     ah=0x11;//get kbd status

 mov  ah, 17
;-49     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-50     //zero flag: 0=IS char, 1=NO char

;-51     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-52 }

;-53 int getkey() {

 ret
ENDP

getkey: PROC
;-54     waitkey();

 call waitkey
;-55     getch();

 call getch
;-56     ah=0;//clear scan code

 mov  ah, 0
;-57     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey4
 call getch
 add ax, 256
;-58     //put ext code in AX

;-59 }

.getkey4:
;-60 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-61     getkey();

 call getkey
;-62     writetty();//destroys AH

 call writetty
;-63 }

;-64 

;-65 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-66     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;14 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-67     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex45
 add  byte[bp+4], 7
;-68     putch(c);

.printhex45:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-69 }

;-70 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-71     unsigned char nib;

;-72     nib = c >> 4; printhex4(nib);

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
;-73     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-74 }

;-75 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-76     unsigned int half;

;-77     half = i >>  8; printhex8(half);

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
;-78     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-79 }

;-80 

;-81 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-82     unsigned int e;

;-83     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;14 var unsg word n = bp+4
;15 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign6
;-84         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-85         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-86         }

;-87     n=n%10;

.printunsign6:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-88     n+='0';

 add  word[bp+4], 48
;-89     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-90 }

;-91 int ShowRegister() {

 LEAVE
 ret
ENDP

ShowRegister: PROC
;-92     asm mov [vAX], ax

 mov [vAX], ax
;-93     asm mov [vBX], bx

 mov [vBX], bx
;-94     asm mov [vCX], cx

 mov [vCX], cx
;-95     asm mov [vDX], dx

 mov [vDX], dx
;-96     asm mov [vSP], sp

 mov [vSP], sp
;-97     asm mov [vBP], bp

 mov [vBP], bp
;-98     asm mov ax, cs

 mov ax, cs
;-99     asm mov [vCS], ax

 mov [vCS], ax
;-100     asm mov ax, ds

 mov ax, ds
;-101     asm mov [vDS], ax

 mov [vDS], ax
;-102     asm mov ax, ss

 mov ax, ss
;-103     asm mov [vSS], ax

 mov [vSS], ax
;-104     asm mov ax, es

 mov ax, es
;-105     asm mov [vES], ax

 mov [vES], ax
;-106     putch(10);

 push 10
 call putch
 add  sp, 2
;-107     cputs( "AX="); printhex16(vAX);

 push ShowRegister_0
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-108     cputs(",BX="); printhex16(vBX);

 push ShowRegister_1
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-109     cputs(",CX="); printhex16(vCX);

 push ShowRegister_2
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-110     cputs(",DX="); printhex16(vDX);

 push ShowRegister_3
 call cputs
 add  sp, 2
 push word [vDX]
 call printhex16
 add  sp, 2
;-111     cputs(",SP="); printhex16(vSP);

 push ShowRegister_4
 call cputs
 add  sp, 2
 push word [vSP]
 call printhex16
 add  sp, 2
;-112     cputs(",BP="); printhex16(vBP);

 push ShowRegister_5
 call cputs
 add  sp, 2
 push word [vBP]
 call printhex16
 add  sp, 2
;-113     cputs(",CS="); printhex16(vCS);

 push ShowRegister_6
 call cputs
 add  sp, 2
 push word [vCS]
 call printhex16
 add  sp, 2
;-114     cputs(",DS="); printhex16(vDS);

 push ShowRegister_7
 call cputs
 add  sp, 2
 push word [vDS]
 call printhex16
 add  sp, 2
;-115     cputs(",SS="); printhex16(vSS);

 push ShowRegister_8
 call cputs
 add  sp, 2
 push word [vSS]
 call printhex16
 add  sp, 2
;-116     cputs(",ES="); printhex16(vES);

 push ShowRegister_9
 call cputs
 add  sp, 2
 push word [vES]
 call printhex16
 add  sp, 2
;-117 }

;-118 

;-119 //--------------------------------  disk IO  -------------------

;-120 char BIOS_ERR=0;

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
;-121 unsigned int  BIOS_Status=0;

BIOS_Status dw 0
;-122 char DiskBuf [512];

section .bss
absolute 8192
DiskBuf resb 512
section .text
;-123 char Drive;

Drive db 0
;-124 unsigned int  Cylinders;

Cylinders dw 0
;-125 char Sectors;

Sectors db 0
;-126 char Heads;

Heads db 0
;-127 char Attached;

Attached db 0
;-128 int  ParmTableSeg;

ParmTableSeg dw 0
;-129 int  ParmTableOfs;

ParmTableOfs dw 0
;-130 char DriveType;

DriveType db 0
;-131 int  PartNo;

PartNo dw 0
;-132 //hard disk partition structure

;-133 unsigned char ptBootable;	//80h = active partition, else 00

ptBootable db 0
;-134 unsigned char ptStartHead;	//

ptStartHead db 0
;-135 unsigned char ptStartSector;	//bits 0-5

ptStartSector db 0
;-136 unsigned int  ptStartCylinder;//bits 8,9 in bits 6,7 of sector

ptStartCylinder dw 0
;-137 unsigned char ptFileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=hugePart

ptFileSystem db 0
;-138 unsigned char ptEndHead;		//

ptEndHead db 0
;-139 unsigned char ptEndSector;	//bits 0-5

ptEndSector db 0
;-140 unsigned int  ptEndCylinder;	//bits 8,9 in bits 6,7 of sector

ptEndCylinder dw 0
;-141 unsigned int ptStartSectorlo;//sectors preceding partition

ptStartSectorlo dw 0
;-142 unsigned int ptStartSectorhi;

ptStartSectorhi dw 0
;-143 unsigned int ptPartLenlo;    //length of partition in sectors

ptPartLenlo dw 0
;-144 unsigned int ptPartLenhi;

ptPartLenhi dw 0
;-145 

;-146 int Int13hRW(char rw, char drive, char head, int cyl, char sector,


Int13hRW: PROC
;-147 	char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-148 	BIOS_ERR=0;	

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
;-149 	dl=drive;

 mov  dl, [bp+6]
;-150 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-151 	es=BufSeg;

 mov  es, [bp+16]
;-152 	bx=BufOfs;

 mov  bx, [bp+18]
;-153 	cx=cyl;	

 mov  cx, [bp+10]
;-154 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-155 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-156 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-157 	cl += sector;

 add  cl, [bp+12]
;-158 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-159 	

;-160 	al=count;

 mov  al, [bp+14]
;-161 	ah=rw;

 mov  ah, [bp+4]
;-162 	inth 0x13;

 int  19
;-163     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-164 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-165 }

;-166 int Int13hRaw(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hRaw: PROC
;-167 	BIOS_ERR=0;	

;Function : Int13hRaw, Number local Var: 2
; # type sign width local variables
;38 var sign byte drive = bp+4
;39 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-168 	dl=drive;

 mov  dl, [bp+4]
;-169 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-170 	inth 0x13;

 int  19
;-171     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-172 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-173 }

;-174 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-175 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-176 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-177 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-178 	BIOS_Status=Int13hRaw(Drive, 0);//Reset

 push 0
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-179 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-180 }	

;-181 

;-182 int Params(char drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Params: PROC
;-183 	cputs("(AH=08)Drive Params:");

;Function : Params, Number local Var: 1
; # type sign width local variables
;38 var sign byte drive = bp+4;
 ENTER  0,0
 push Params_0
 call cputs
 add  sp, 2
;-184 	BIOS_Status=Int13hRaw(drive, 8);

 push 8
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-185 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Params7
 call Int13hError
;-186 	else {

 jmp .Params8
.Params7:
;-187 		cputs("AH Return Code:");

 push Params_1
 call cputs
 add  sp, 2
;-188 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-189 		asm mov [Heads],        dh

 mov [Heads],        dh
;-190 		Heads++;

 inc  byte[Heads]
;-191 		asm mov [Attached],     dl

 mov [Attached],     dl
;-192 		// CX =       ---CH--- ---CL---

;-193 		// cylinder : 76543210 98

;-194 		// sector   :            543210	

;-195 		asm mov [Sectors],      cl

 mov [Sectors],      cl
;-196 		Sectors &= 0x3F;// 63

 and  byte[Sectors], 63
;-197 //		Sectors++;//1 to 64

;-198 	

;-199 		asm mov [Cylinders],    cx	

 mov [Cylinders],    cx	
;-200 		Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[Cylinders], 192
;-201 		Cylinders = Cylinders << 2;//compiler flaw:

 mov ax, [Cylinders]
 shl ax, 2
 mov word [Cylinders], ax
;-202 		asm add [Cylinders],    ch;//byte add, low byte is empty	

 add [Cylinders],    ch;//byte add, low byte is empty	
;-203 	

;-204 		putch(10);

 push 10
 call putch
 add  sp, 2
;-205 		cputs("CHS=");				printunsign(Cylinders);

 push Params_2
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
;-206 		putch('/');					printunsign(Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-207 		putch('/');					printunsign(Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-208 		cputs(", NoDrives=");		printhex8(Attached);

 push Params_3
 call cputs
 add  sp, 2
 mov al, byte [Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-209 		putch('.');

 push 46
 call putch
 add  sp, 2
;-210 	}

;-211 }

.Params8:
;-212 

;-213 int Status(drive) {

 LEAVE
 ret
Params_0 db "(AH=08)Drive Params:",0
Params_1 db "AH Return Code:",0
Params_2 db "CHS=",0
Params_3 db ", NoDrives=",0
ENDP

Status: PROC
;-214 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;38 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-215 	cputs("(1)Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-216 	BIOS_Status=Int13hRaw(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-217 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status9
 call Int13hError
;-218 	printhex16(BIOS_Status);	

.Status9:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-219 }	

;-220 

;-221 int Init() {

 LEAVE
 ret
Status_0 db "(1)Status last Op=",0
ENDP

Init: PROC
;-222 	int i;

;-223 	i=0;

;Function : Init, Number local Var: 1
; # type sign width local variables
;38 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-224 	do {

.Init10:
;-225 		DiskBuf[i] = i;

 mov ax, [bp-2]
 mov bx, [bp-2]
 mov [DiskBuf+bx], al
;-226 		i++;

 inc  word[bp-2]
;-227 	} while (i < 512);	

 mov ax, [bp-2]
 cmp ax, 512
 jge .Init11
 jmp .Init10
.Init11:
;-228 	}

;-229 	

;-230 int getPartitionData() {

 LEAVE
 ret
ENDP

getPartitionData: PROC
;-231 	unsigned int j; char c; 

;-232 	j = PartNo << 4;

;Function : getPartitionData, Number local Var: 2
; # type sign width local variables
;38 var unsg word j = bp-2
;39 var sign byte c = bp-4;
 ENTER  4,0
 mov ax, [PartNo]
 shl ax, 4
 mov [bp-2], ax
;-233 	j = j + 0x1be;			ptBootable=DiskBuf[j];

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptBootable], al
;-234 	j++;					ptStartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartHead], al
;-235 	j++;					ptStartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartSector], al
;-236 	ah=0;//next line convert byte to word

 mov  ah, 0
;-237 	ptStartCylinder=ptStartSector;	

 mov al, [ptStartSector]
 mov word [ptStartCylinder], ax
;-238 	ptStartSector &= 0x3F;

 and  byte[ptStartSector], 63
;-239 	ptStartSector++;//Sector start with 1

 inc  byte[ptStartSector]
;-240 	ptStartCylinder &= 0xC0;

 and  word[ptStartCylinder], 192
;-241 	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	

 mov ax, [ptStartCylinder]
 shl ax, 2
 mov word [ptStartCylinder], ax
;-242 	j++;

 inc  word[bp-2]
;-243 	ah=0;//byte 2 word

 mov  ah, 0
;-244 	ptStartCylinder=DiskBuf[j] + ptStartCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptStartCylinder]
 mov word [ptStartCylinder], ax
;-245 //	byte add, ok because low byte is empty

;-246 //	ptStartCylinder=ptStartCylinder + DiskBuf[j];//OK

;-247 

;-248 	j++;					ptFileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptFileSystem], al
;-249 	j++;					ptEndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndHead], al
;-250 	j++;					ptEndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndSector], al
;-251 	ah=0;//next line convert byte to word

 mov  ah, 0
;-252 	ptEndCylinder=ptEndSector;//see next 5 line		

 mov al, [ptEndSector]
 mov word [ptEndCylinder], ax
;-253 	ptEndSector &= 0x3F;

 and  byte[ptEndSector], 63
;-254 	ptEndSector++;//Sector start with 1

 inc  byte[ptEndSector]
;-255 	ptEndCylinder &= 0xC0;

 and  word[ptEndCylinder], 192
;-256 	ptEndCylinder = ptEndCylinder << 2;//OK no short cut!	

 mov ax, [ptEndCylinder]
 shl ax, 2
 mov word [ptEndCylinder], ax
;-257 	j++;

 inc  word[bp-2]
;-258 	ah=0;//byte 2 word

 mov  ah, 0
;-259 	ptEndCylinder=DiskBuf[j] + ptEndCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptEndCylinder]
 mov word [ptEndCylinder], ax
;-260 //	byte add, ok because low byte is empty

;-261 //	ptStartCylinder=ptStartCylinder + DiskBuf[j];//OK

;-262 

;-263 	j++;					ptStartSectorlo = DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov word [ptStartSectorlo], ax
;-264 	j += 2;					ptStartSectorhi = DiskBuf[j];

 add  word[bp-2], 2
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov word [ptStartSectorhi], ax
;-265 	j += 2;					ptPartLenhi = DiskBuf[j];

 add  word[bp-2], 2
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov word [ptPartLenhi], ax
;-266 	j += 2;					ptPartLenlo = DiskBuf[j];

 add  word[bp-2], 2
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov word [ptPartLenlo], ax
;-267 	j += 2;//next partition entry

 add  word[bp-2], 2
;-268 }

;-269 	

;-270 int printPartitionData() {

 LEAVE
 ret
ENDP

printPartitionData: PROC
;-271 	putch(10);		

 push 10
 call putch
 add  sp, 2
;-272 	cputs("No=");			printunsign(PartNo);

 push printPartitionData_0
 call cputs
 add  sp, 2
 push word [PartNo]
 call printunsign
 add  sp, 2
;-273 	cputs(",Boot=");		printhex8(ptBootable);

 push printPartitionData_1
 call cputs
 add  sp, 2
 mov al, byte [ptBootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-274 	cputs(" ID=");			printunsign(ptFileSystem);

 push printPartitionData_2
 call cputs
 add  sp, 2
 mov al, byte [ptFileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-275 	cputs(",Start HSC=");	printunsign(ptStartHead);

 push printPartitionData_3
 call cputs
 add  sp, 2
 mov al, byte [ptStartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-276 	cputs("/");				printunsign(ptStartSector);	

 push printPartitionData_4
 call cputs
 add  sp, 2
 mov al, byte [ptStartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-277 	cputs("/");				printunsign(ptStartCylinder);

 push printPartitionData_5
 call cputs
 add  sp, 2
 push word [ptStartCylinder]
 call printunsign
 add  sp, 2
;-278 	cputs("-");				printunsign(ptEndHead);

 push printPartitionData_6
 call cputs
 add  sp, 2
 mov al, byte [ptEndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-279 	cputs("/");				printunsign(ptEndSector);	

 push printPartitionData_7
 call cputs
 add  sp, 2
 mov al, byte [ptEndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-280 	cputs("/");				printunsign(ptEndCylinder);

 push printPartitionData_8
 call cputs
 add  sp, 2
 push word [ptEndCylinder]
 call printunsign
 add  sp, 2
;-281 //	putch(10);		

;-282 	cputs(",Start=");

 push printPartitionData_9
 call cputs
 add  sp, 2
;-283 	printhex16(ptStartSectorhi);

 push word [ptStartSectorhi]
 call printhex16
 add  sp, 2
;-284 	printhex16(ptStartSectorlo);

 push word [ptStartSectorlo]
 call printhex16
 add  sp, 2
;-285 	cputs(",Len=");

 push printPartitionData_10
 call cputs
 add  sp, 2
;-286 	printhex16(ptPartLenhi);

 push word [ptPartLenhi]
 call printhex16
 add  sp, 2
;-287 	printhex16(ptPartLenlo);

 push word [ptPartLenlo]
 call printhex16
 add  sp, 2
;-288 }

;-289 	

;-290 int testDisk(drive) {

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
;-291 	char c; int i;

;-292 	asm mov [ParmTableSeg], ds

;Function : testDisk, Number local Var: 3
; # type sign width local variables
;38 var sign word drive = bp+4
;39 var sign byte c = bp-2
;40 var sign word i = bp-4;
 ENTER  4,0
 mov [ParmTableSeg], ds
;-293 	//Offset is in DiskBuf

;-294 	BIOS_Status=Int13hRW(2,drive,0,0,1,1,ParmTableSeg,DiskBuf);

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
;-295 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .testDisk12
 call Int13hError
;-296 	else {	

 jmp .testDisk13
.testDisk12:
;-297 		putch(10);

 push 10
 call putch
 add  sp, 2
;-298 		cputs("Read Partition Status:");

 push testDisk_0
 call cputs
 add  sp, 2
;-299 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-300 		cputs(",MBR Magic=");	

 push testDisk_1
 call cputs
 add  sp, 2
;-301 		i=510;		c = DiskBuf[i];		printhex8(c);

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
;-302 		i++;		c = DiskBuf[i];		printhex8(c);

 inc  word[bp-4]
 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-303 		

;-304 		cputs(",DiskBuf=");

 push testDisk_2
 call cputs
 add  sp, 2
;-305 		printhex16(ParmTableSeg);

 push word [ParmTableSeg]
 call printhex16
 add  sp, 2
;-306 		putch(':');							

 push 58
 call putch
 add  sp, 2
;-307 		printhex16(DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 call printhex16
 add  sp, 2
;-308 		putch('.');

 push 46
 call putch
 add  sp, 2
;-309 	

;-310 		PartNo=0;

 mov ax, 0
 mov word [PartNo], ax
;-311 		do {

.testDisk14:
;-312 			getPartitionData();

 call getPartitionData
;-313 			printPartitionData();

 call printPartitionData
;-314 			PartNo ++;

 inc  word[PartNo]
;-315 		} while (PartNo <4);

 mov ax, [PartNo]
 cmp ax, 4
 jge .testDisk15
 jmp .testDisk14
.testDisk15:
;-316 	}	

;-317 }

.testDisk13:
;-318 

;-319 int Int13hExt(char drive) {

 LEAVE
 ret
testDisk_0 db "Read Partition Status:",0
testDisk_1 db ",MBR Magic=",0
testDisk_2 db ",DiskBuf=",0
ENDP

Int13hExt: PROC
;-320 	putch(10);

;Function : Int13hExt, Number local Var: 1
; # type sign width local variables
;38 var sign byte drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-321 	cputs("Int13h 41hExt AX=");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-322 	bx=0x55AA;

 mov  bx, 21930
;-323 	BIOS_Status=Int13hRaw(0x80, 0x41);	

 push 65
 push 128
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-324 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-325 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt16
;-326 		cputs(" not present");	

 push Int13hExt_1
 call cputs
 add  sp, 2
;-327 		Int13hError();	

 call Int13hError
;-328 		}

;-329 	else {

 jmp .Int13hExt17
.Int13hExt16:
;-330 		cputs(" status=1:supported");

 push Int13hExt_2
 call cputs
 add  sp, 2
;-331 		asm mov [vBX], bx;0xAA55 Extension installed

 mov [vBX], bx;0xAA55 Extension installed
;-332 		asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			
;-333 		cputs(" BX=");		printhex16(vBX);

 push Int13hExt_3
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-334 		cputs(" CX=");		printhex16(vCX);

 push Int13hExt_4
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-335 		}		

;-336 }	

.Int13hExt17:
;-337 

;-338 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
Int13hExt_0 db "Int13h 41hExt AX=",0
Int13hExt_1 db " not present",0
Int13hExt_2 db " status=1:supported",0
Int13hExt_3 db " BX=",0
Int13hExt_4 db " CX=",0
ENDP

mdump: PROC
;-339     unsigned char c;

;-340     int i;

;-341     int j;

;-342     int k;

;-343     j=0;

;Function : mdump, Number local Var: 6
; # type sign width local variables
;38 ptr unsg byte adr = bp+4
;39 var unsg word len = bp+6
;40 var unsg byte c = bp-2
;41 var sign word i = bp-4
;42 var sign word j = bp-6
;43 var sign word k = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-6], ax
;-344     k=0;

 mov ax, 0
 mov [bp-8], ax
;-345     while (j < len ) {

.mdump18:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump19
;-346 	    k++;; 

 inc  word[bp-8]
;-347 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump20
;-348 		    getkey();

 call getkey
;-349 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-350 		    }

;-351         putch(10);

.mdump20:
 push 10
 call putch
 add  sp, 2
;-352         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-353         putch(':');

 push 58
 call putch
 add  sp, 2
;-354         i=0;

 mov ax, 0
 mov [bp-4], ax
;-355         while (i < 16) {

.mdump21:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump22
;-356             putch(' ');

 push 32
 call putch
 add  sp, 2
;-357             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-358             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-359             adr++;

 inc  word[bp+4]
;-360             i++;

 inc  word[bp-4]
;-361             j++;

 inc  word[bp-6]
;-362             }

;-363         putch(' ');

 jmp .mdump21
.mdump22:
 push 32
 call putch
 add  sp, 2
;-364         adr -=16;

 sub  word[bp+4], 16
;-365         i=0;

 mov ax, 0
 mov [bp-4], ax
;-366         while(i < 16) {

.mdump23:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump24
;-367             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-368             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump25
 push 46
 call putch
 add  sp, 2
;-369                 else putch(c);

 jmp .mdump26
.mdump25:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-370             adr++;

.mdump26:
 inc  word[bp+4]
;-371             i++;

 inc  word[bp-4]
;-372         }

;-373     }

 jmp .mdump23
.mdump24:
;-374 }

 jmp .mdump18
.mdump19:
;-375 

;-376 //------------------------------------ main ---------------

;-377 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-378 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-379 	Init();

 call Init
;-380 	mdump(DiskBuf, 512);

 push 512
 lea  ax, [DiskBuf]
 push ax
 call mdump
 add  sp, 4
;-381 	

;-382 	Params(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Params
 add  sp, 2
;-383 	testDisk(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call testDisk
 add  sp, 2
;-384 	getkey();

 call getkey
;-385 	mdump(DiskBuf, 512);

 push 512
 lea  ax, [DiskBuf]
 push ax
 call mdump
 add  sp, 4
;-386 	Int13hExt(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hExt
 add  sp, 2
;-387 }

 ret
ENDP
;Glob. variables:37 (400):335 (4000), Functions:24 (300):222 (3000)
;Lines:388, Constant: 372 (3000), stacksize: 56831