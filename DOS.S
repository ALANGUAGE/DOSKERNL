;PLA compiler A.COM V1.0.1, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.1.4";//test bed

Version1 db "DOS.COM V0.1.4",0
;-2 //todo: resize and take own stack

;-3 //Finder /hg/VirtualBox VMs/DOS1/DOS1.vhd (.vmdk) 

;-4 // Rechtsclick / Öffnen / Parallels Mounter

;-5 //Ranish Üart, int8h: CHS 1014/15/63, Start=63,Len=1023057

;-6 #define ORGDATA		8192//start of arrays

;-7 unsigned int vAX;

vAX dw 0
;-8 unsigned int vBX;

vBX dw 0
;-9 unsigned int vCX;

vCX dw 0
;-10 unsigned int vDX;

vDX dw 0
;-11 unsigned int vSP;

vSP dw 0
;-12 unsigned int vBP;

vBP dw 0
;-13 unsigned int vCS;

vCS dw 0
;-14 unsigned int vDS;

vDS dw 0
;-15 unsigned int vSS;

vSS dw 0
;-16 unsigned int vES;

vES dw 0
;-17 

;-18 char DOS_ERR;

DOS_ERR db 0
;-19 char BIOS_ERR;

BIOS_ERR db 0
;-20 int  BIOS_Status;

BIOS_Status dw 0
;-21 char DiskBuf [512];

section .bss
absolute 8192
DiskBuf resb 512
section .text
;-22 char Drive;

Drive db 0
;-23 unsigned int  Cylinders;

Cylinders dw 0
;-24 char Sectors;

Sectors db 0
;-25 char Heads;

Heads db 0
;-26 char Attached;

Attached db 0
;-27 int  ParmTableSeg;

ParmTableSeg dw 0
;-28 int  ParmTableOfs;

ParmTableOfs dw 0
;-29 char DriveType;

DriveType db 0
;-30 int  PartNo;

PartNo dw 0
;-31 //start hard disk partition structure 16 bytes

;-32 unsigned char ptBootable;	//80h = active partition, else 00

ptBootable db 0
;-33 unsigned char ptStartHead;	//

ptStartHead db 0
;-34 unsigned char ptStartSector;	//bits 0-5

ptStartSector db 0
;-35 unsigned int  ptStartCylinder;//bits 8,9 in bits 6,7 of sector

ptStartCylinder dw 0
;-36 unsigned char ptFileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=hugePart

ptFileSystem db 0
;-37 unsigned char ptEndHead;		//

ptEndHead db 0
;-38 unsigned char ptEndSector;	//bits 0-5

ptEndSector db 0
;-39 unsigned int  ptEndCylinder;	//bits 8,9 in bits 6,7 of sector

ptEndCylinder dw 0
;-40 unsigned int ptStartSectorlo;//sectors preceding partition

ptStartSectorlo dw 0
;-41 unsigned int ptStartSectorhi;

ptStartSectorhi dw 0
;-42 unsigned int ptPartLenlo;    //length of partition in sectors

ptPartLenlo dw 0
;-43 unsigned int ptPartLenhi;

ptPartLenhi dw 0
;-44 //end hard disk partition structure

;-45 

;-46 unsigned int count21h=0;

count21h dw 0
;-47 

;-48 int writetty()     {//char in AL


writetty: PROC
;-49     ah=0x0E;

 mov  ah, 14
;-50     push bx;

push bx;
;-51     bx=0;			//page in BH

 mov  bx, 0
;-52     inth 0x10;		//16

 int  16
;-53     pop bx;

pop bx;
;-54 }

;-55 int putch(char c)  {

 ret
ENDP

putch: PROC
;-56     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;38 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-57         al=13;

 mov  al, 13
;-58         writetty();

 call writetty
;-59     }

;-60     al=c;

.putch1:
 mov  al, [bp+4]
;-61     writetty();

 call writetty
;-62 }

;-63 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-64     char c;

;-65     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;38 ptr sign byte s = bp+4
;39 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-66         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-67         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-68         s++;

 inc  word[bp+4]
;-69     }

;-70 }

 jmp .cputs2
.cputs3:
;-71 

;-72 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-73     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-74     inth 0x16;//AH=Scan code, AL=char

 int  22
;-75 }

;-76 int waitkey() {

 ret
ENDP

waitkey: PROC
;-77     ah=0x11;//get kbd status

 mov  ah, 17
;-78     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-79     //zero flag: 0=IS char, 1=NO char

;-80     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-81 }

;-82 int getkey() {

 ret
ENDP

getkey: PROC
;-83     waitkey();

 call waitkey
;-84     getch();

 call getch
;-85     ah=0;//clear scan code

 mov  ah, 0
;-86     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey4
 call getch
 add ax, 256
;-87     //put ext code in AX

;-88 }

.getkey4:
;-89 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-90     getkey();

 call getkey
;-91     writetty();//destroys AH

 call writetty
;-92 }

;-93 

;-94 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-95     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;38 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-96     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex45
 add  byte[bp+4], 7
;-97     putch(c);

.printhex45:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-98 }

;-99 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-100     unsigned char nib;

;-101     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;38 var unsg byte c = bp+4
;39 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-102     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-103 }

;-104 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-105     unsigned int half;

;-106     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;38 var unsg word i = bp+4
;39 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-107     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-108 }

;-109 

;-110 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-111     unsigned int e;

;-112     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;38 var unsg word n = bp+4
;39 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign6
;-113         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-114         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-115         }

;-116     n=n%10;

.printunsign6:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-117     n+='0';

 add  word[bp+4], 48
;-118     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-119 }

;-120 

;-121 int memcpy(char *s, char *t, int i) {

 LEAVE
 ret
ENDP

memcpy: PROC
;-122 	unsigned int r;

;-123 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;38 ptr sign byte s = bp+4
;39 ptr sign byte t = bp+6
;40 var sign word i = bp+8
;41 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-124 	do {

.memcpy7:
;-125 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-126 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-127 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy8
 jmp .memcpy7
.memcpy8:
;-128 	ax=r;//	return r;

 mov  ax, [bp-2]
;-129 }

;-130 

;-131 int printlong(unsigned int lo, unsigned int hi) {

 LEAVE
 ret
ENDP

printlong: PROC
;-132 // DX:AX DIV BX = AX remainder dx

;-133 	dx=hi;

;Function : printlong, Number local Var: 2
; # type sign width local variables
;38 var unsg word lo = bp+4
;39 var unsg word hi = bp+6;
 ENTER  0,0
 mov  dx, [bp+6]
;-134 	ax=lo;

 mov  ax, [bp+4]
;-135 __asm{	

	
;-136   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-137     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-138 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-139     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-140     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-141     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-142     db		145;=91h xchg ax,cx;Temporarily move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx;Temporarily move it to CX restoring LowDividend
;-143     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-144     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-145     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-146     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-147     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-148     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-149 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-150 }	writetty();		__asm{


 call writetty

;-151     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-152     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-153     jb      .b             ;Not yet	

    jb      .b             ;Not yet	
;-154 } }


;-155 

;-156 //--------------------------------  disk IO  -------------------

;-157 

;-158 int Int13hRW(char rw, char drive, char head, int cyl, char sector,

 LEAVE
 ret
ENDP

Int13hRW: PROC
;-159 	char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-160 	BIOS_ERR=0;	

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
;-161 	dl=drive;

 mov  dl, [bp+6]
;-162 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-163 	es=BufSeg;

 mov  es, [bp+16]
;-164 	bx=BufOfs;

 mov  bx, [bp+18]
;-165 	cx=cyl;	

 mov  cx, [bp+10]
;-166 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-167 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-168 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-169 	cl += sector;

 add  cl, [bp+12]
;-170 	ch=cyl;//low byte of cyl in ch, word 2 byte	

 mov  ch, [bp+10]
;-171 	al=count;

 mov  al, [bp+14]
;-172 	ah=rw;

 mov  ah, [bp+4]
;-173 	inth 0x13;

 int  19
;-174     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-175 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-176 }

;-177 int Int13hRaw(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hRaw: PROC
;-178 	BIOS_ERR=0;	

;Function : Int13hRaw, Number local Var: 2
; # type sign width local variables
;38 var sign byte drive = bp+4
;39 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-179 	dl=drive;

 mov  dl, [bp+4]
;-180 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-181 	inth 0x13;

 int  19
;-182     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-183 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-184 }

;-185 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-186 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-187 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-188 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-189 	BIOS_Status=Int13hRaw(Drive, 0);//Reset

 push 0
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-190 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-191 }	

;-192 

;-193 int Params(char drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Params: PROC
;-194 	cputs("(AH=08)Drive Params:");

;Function : Params, Number local Var: 1
; # type sign width local variables
;38 var sign byte drive = bp+4;
 ENTER  0,0
 push Params_0
 call cputs
 add  sp, 2
;-195 	BIOS_Status=Int13hRaw(drive, 8);

 push 8
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-196 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Params9
 call Int13hError
;-197 	else {

 jmp .Params10
.Params9:
;-198 		asm mov [Heads],        dh

 mov [Heads],        dh
;-199 //		Heads++;

;-200 		asm mov [Attached],     dl

 mov [Attached],     dl
;-201 		// CX =       ---CH--- ---CL---

;-202 		// cylinder : 76543210 98

;-203 		// sector   :            543210	

;-204 		asm mov [Sectors],      cl

 mov [Sectors],      cl
;-205 		Sectors &= 0x3F;// 63

 and  byte[Sectors], 63
;-206 //		Sectors++;//1 to 64

;-207 	

;-208 		asm mov [Cylinders],    cx	

 mov [Cylinders],    cx	
;-209 		Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[Cylinders], 192
;-210 		Cylinders = Cylinders << 2;//compiler flaw:

 mov ax, [Cylinders]
 shl ax, 2
 mov word [Cylinders], ax
;-211 		asm add [Cylinders],    ch;//byte add, low byte is empty	

 add [Cylinders],    ch;//byte add, low byte is empty	
;-212 	

;-213 		cputs("CylHeadSec=");		printunsign(Cylinders);

 push Params_1
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
;-214 		putch('/');					printunsign(Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-215 		putch('/');					printunsign(Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-216 		cputs(", NoDrives=");		printhex8(Attached);

 push Params_2
 call cputs
 add  sp, 2
 mov al, byte [Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-217 		putch('.');

 push 46
 call putch
 add  sp, 2
;-218 	}

;-219 }

.Params10:
;-220 

;-221 int Status(drive) {

 LEAVE
 ret
Params_0 db "(AH=08)Drive Params:",0
Params_1 db "CylHeadSec=",0
Params_2 db ", NoDrives=",0
ENDP

Status: PROC
;-222 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;38 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-223 	cputs("(1)Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-224 	BIOS_Status=Int13hRaw(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-225 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status11
 call Int13hError
;-226 	printhex16(BIOS_Status);	

.Status11:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-227 }	

;-228 

;-229 int getPartitionData() {

 LEAVE
 ret
Status_0 db "(1)Status last Op=",0
ENDP

getPartitionData: PROC
;-230 	unsigned int j; char c; char *p;

;-231 	j = PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;38 var unsg word j = bp-2
;39 var sign byte c = bp-4
;40 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [PartNo]
 shl ax, 4
 mov [bp-2], ax
;-232 	j = j + 0x1be;			ptBootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptBootable], al
;-233 	j++;					ptStartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartHead], al
;-234 	j++;					ptStartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartSector], al
;-235 	ah=0;//next line convert byte to word

 mov  ah, 0
;-236 	ptStartCylinder=ptStartSector;	

 mov al, [ptStartSector]
 mov word [ptStartCylinder], ax
;-237 	ptStartSector &= 0x3F;

 and  byte[ptStartSector], 63
;-238 //	ptStartSector++;//Sector start with 1 todo

;-239 	ptStartCylinder &= 0xC0;

 and  word[ptStartCylinder], 192
;-240 	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	

 mov ax, [ptStartCylinder]
 shl ax, 2
 mov word [ptStartCylinder], ax
;-241 	j++;

 inc  word[bp-2]
;-242 	ah=0;//byte to word

 mov  ah, 0
;-243 	ptStartCylinder=DiskBuf[j] + ptStartCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptStartCylinder]
 mov word [ptStartCylinder], ax
;-244 	j++;					ptFileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptFileSystem], al
;-245 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=huge<2GB MS-DOS4.0	

;-246 	j++;					ptEndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndHead], al
;-247 	j++;					ptEndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndSector], al
;-248 	ah=0;//next line convert byte to word

 mov  ah, 0
;-249 	ptEndCylinder=ptEndSector;//see next 5 line		

 mov al, [ptEndSector]
 mov word [ptEndCylinder], ax
;-250 	ptEndSector &= 0x3F;

 and  byte[ptEndSector], 63
;-251 //	ptEndSector++;//Sector start with 1 todo

;-252 	ptEndCylinder &= 0xC0;

 and  word[ptEndCylinder], 192
;-253 	ptEndCylinder = ptEndCylinder << 2;//OK no short cut!	

 mov ax, [ptEndCylinder]
 shl ax, 2
 mov word [ptEndCylinder], ax
;-254 	j++;

 inc  word[bp-2]
;-255 	ah=0;//byte to word

 mov  ah, 0
;-256 	ptEndCylinder=DiskBuf[j] + ptEndCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptEndCylinder]
 mov word [ptEndCylinder], ax
;-257 	j++;

 inc  word[bp-2]
;-258 	p = j + &DiskBuf;//copy ptStartSector, ptPartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-259 	memcpy(&ptStartSectorlo, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [ptStartSectorlo]
 push ax
 call memcpy
 add  sp, 6
;-260 	

;-261 	j += 8;//next partition entry

 add  word[bp-2], 8
;-262 }

;-263 	

;-264 int printPartitionData() {

 LEAVE
 ret
ENDP

printPartitionData: PROC
;-265 	unsigned int i; unsigned int j;

;-266 	putch(10);		

;Function : printPartitionData, Number local Var: 2
; # type sign width local variables
;38 var unsg word i = bp-2
;39 var unsg word j = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-267 	cputs("No=");			printunsign(PartNo);

 push printPartitionData_0
 call cputs
 add  sp, 2
 push word [PartNo]
 call printunsign
 add  sp, 2
;-268 	cputs(",Boot=");		printhex8(ptBootable);

 push printPartitionData_1
 call cputs
 add  sp, 2
 mov al, byte [ptBootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-269 	cputs(" ID=");			printunsign(ptFileSystem);

 push printPartitionData_2
 call cputs
 add  sp, 2
 mov al, byte [ptFileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-270 	cputs(",HdSeCy=");		printunsign(ptStartHead);

 push printPartitionData_3
 call cputs
 add  sp, 2
 mov al, byte [ptStartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-271 	cputs("/");				printunsign(ptStartSector);	

 push printPartitionData_4
 call cputs
 add  sp, 2
 mov al, byte [ptStartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-272 	cputs("/");				printunsign(ptStartCylinder);

 push printPartitionData_5
 call cputs
 add  sp, 2
 push word [ptStartCylinder]
 call printunsign
 add  sp, 2
;-273 	cputs("-");				printunsign(ptEndHead);

 push printPartitionData_6
 call cputs
 add  sp, 2
 mov al, byte [ptEndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-274 	cputs("/");				printunsign(ptEndSector);	

 push printPartitionData_7
 call cputs
 add  sp, 2
 mov al, byte [ptEndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-275 	cputs("/");				printunsign(ptEndCylinder);

 push printPartitionData_8
 call cputs
 add  sp, 2
 push word [ptEndCylinder]
 call printunsign
 add  sp, 2
;-276 //	putch(10);		

;-277 	cputs(",Start=");

 push printPartitionData_9
 call cputs
 add  sp, 2
;-278 	printlong(ptStartSectorlo, ptStartSectorhi);

 push word [ptStartSectorhi]
 push word [ptStartSectorlo]
 call printlong
 add  sp, 4
;-279 	cputs(",Len=");

 push printPartitionData_10
 call cputs
 add  sp, 2
;-280 	printlong(ptPartLenlo, ptPartLenhi);

 push word [ptPartLenhi]
 push word [ptPartLenlo]
 call printlong
 add  sp, 4
;-281 	cputs(" Sec=");

 push printPartitionData_11
 call cputs
 add  sp, 2
;-282 	i = ptPartLenhi <<  5;//64KB Sec to MB; >>4 + <<9 = <<5

 mov ax, [ptPartLenhi]
 shl ax, 5
 mov [bp-2], ax
;-283 	j = ptPartLenlo >> 11;//Sec to MB

 mov ax, [ptPartLenlo]
 shr ax, 11
 mov [bp-4], ax
;-284 	i = i + j;

 mov ax, [bp-2]
 add ax, [bp-4]
 mov [bp-2], ax
;-285 	printunsign(i);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-286 	cputs(" MByte.");

 push printPartitionData_12
 call cputs
 add  sp, 2
;-287 }

;-288 	

;-289 int testDisk(drive) {

 LEAVE
 ret
printPartitionData_0 db "No=",0
printPartitionData_1 db ",Boot=",0
printPartitionData_2 db " ID=",0
printPartitionData_3 db ",HdSeCy=",0
printPartitionData_4 db "/",0
printPartitionData_5 db "/",0
printPartitionData_6 db "-",0
printPartitionData_7 db "/",0
printPartitionData_8 db "/",0
printPartitionData_9 db ",Start=",0
printPartitionData_10 db ",Len=",0
printPartitionData_11 db " Sec=",0
printPartitionData_12 db " MByte.",0
ENDP

testDisk: PROC
;-290 	char c; int i;

;-291 	asm mov [ParmTableSeg], ds

;Function : testDisk, Number local Var: 3
; # type sign width local variables
;38 var sign word drive = bp+4
;39 var sign byte c = bp-2
;40 var sign word i = bp-4;
 ENTER  4,0
 mov [ParmTableSeg], ds
;-292 	//Offset is in DiskBuf

;-293 	BIOS_Status=Int13hRW(2,drive,0,0,1,1,ParmTableSeg,DiskBuf);

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
;-294 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .testDisk12
 call Int13hError
;-295 	else {	

 jmp .testDisk13
.testDisk12:
;-296 		putch(10);

 push 10
 call putch
 add  sp, 2
;-297 		cputs("Read Partition Status:");

 push testDisk_0
 call cputs
 add  sp, 2
;-298 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-299 		cputs(",MBR Magic=");	

 push testDisk_1
 call cputs
 add  sp, 2
;-300 		i=510;		c = DiskBuf[i];		printhex8(c);

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
;-301 		i++;		c = DiskBuf[i];		printhex8(c);

 inc  word[bp-4]
 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-302 		

;-303 		cputs(",DiskBuf=");

 push testDisk_2
 call cputs
 add  sp, 2
;-304 		printhex16(ParmTableSeg);

 push word [ParmTableSeg]
 call printhex16
 add  sp, 2
;-305 		putch(':');							

 push 58
 call putch
 add  sp, 2
;-306 		printhex16(DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 call printhex16
 add  sp, 2
;-307 		putch('.');

 push 46
 call putch
 add  sp, 2
;-308 	

;-309 		PartNo=0;

 mov ax, 0
 mov word [PartNo], ax
;-310 		do {

.testDisk14:
;-311 			getPartitionData();

 call getPartitionData
;-312 			printPartitionData();

 call printPartitionData
;-313 			if (ptBootable == 0x80) {

 mov al, [ptBootable]
 cmp al, 128
 jne .testDisk15
;-314 				cputs(" boot partition found");

 push testDisk_3
 call cputs
 add  sp, 2
;-315 				if (ptFileSystem == 6) cputs(" huge partition < 2GB");

 mov al, [ptFileSystem]
 cmp al, 6
 jne .testDisk16
 push testDisk_4
 call cputs
 add  sp, 2
;-316 				PartNo=99;//end of loop	

.testDisk16:
 mov ax, 99
 mov word [PartNo], ax
;-317 			}

;-318 			PartNo ++;

.testDisk15:
 inc  word[PartNo]
;-319 		} while (PartNo <4);

 mov ax, [PartNo]
 cmp ax, 4
 jge .testDisk17
 jmp .testDisk14
.testDisk17:
;-320 	}	

;-321 }

.testDisk13:
;-322 

;-323 int Int13hExt(char drive) {

 LEAVE
 ret
testDisk_0 db "Read Partition Status:",0
testDisk_1 db ",MBR Magic=",0
testDisk_2 db ",DiskBuf=",0
testDisk_3 db " boot partition found",0
testDisk_4 db " huge partition < 2GB",0
ENDP

Int13hExt: PROC
;-324 	putch(10);

;Function : Int13hExt, Number local Var: 1
; # type sign width local variables
;38 var sign byte drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-325 	cputs("Int13h 41hExt AX(3000=ERROR)=");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-326 	bx=0x55AA;

 mov  bx, 21930
;-327 	BIOS_Status=Int13hRaw(0x80, 0x41);	

 push 65
 push 128
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-328 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-329 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt18
;-330 		cputs(" not present");	

 push Int13hExt_1
 call cputs
 add  sp, 2
;-331 		Int13hError();	

 call Int13hError
;-332 		}

;-333 	else {

 jmp .Int13hExt19
.Int13hExt18:
;-334 		cputs(" status=1:supported");

 push Int13hExt_2
 call cputs
 add  sp, 2
;-335 		asm mov [vBX], bx;0xAA55 Extension installed

 mov [vBX], bx;0xAA55 Extension installed
;-336 		asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			
;-337 		cputs(" BX(AA55)=");				printhex16(vBX);

 push Int13hExt_3
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-338 		cputs(" CX(Interface bitmask)=");	printhex16(vCX);

 push Int13hExt_4
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-339 		}		

;-340 }	

.Int13hExt19:
;-341 

;-342 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
Int13hExt_0 db "Int13h 41hExt AX(3000=ERROR)=",0
Int13hExt_1 db " not present",0
Int13hExt_2 db " status=1:supported",0
Int13hExt_3 db " BX(AA55)=",0
Int13hExt_4 db " CX(Interface bitmask)=",0
ENDP

mdump: PROC
;-343     unsigned char c;

;-344     int i;

;-345     int j;

;-346     int k;

;-347     j=0;

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
;-348     k=0;

 mov ax, 0
 mov [bp-8], ax
;-349     while (j < len ) {

.mdump20:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump21
;-350 	    k++;; 

 inc  word[bp-8]
;-351 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump22
;-352 		    getkey();

 call getkey
;-353 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-354 		    }

;-355         putch(10);

.mdump22:
 push 10
 call putch
 add  sp, 2
;-356         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-357         putch(':');

 push 58
 call putch
 add  sp, 2
;-358         i=0;

 mov ax, 0
 mov [bp-4], ax
;-359         while (i < 16) {

.mdump23:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump24
;-360             putch(' ');

 push 32
 call putch
 add  sp, 2
;-361             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-362             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-363             adr++;

 inc  word[bp+4]
;-364             i++;

 inc  word[bp-4]
;-365             j++;

 inc  word[bp-6]
;-366             }

;-367         putch(' ');

 jmp .mdump23
.mdump24:
 push 32
 call putch
 add  sp, 2
;-368         adr -=16;

 sub  word[bp+4], 16
;-369         i=0;

 mov ax, 0
 mov [bp-4], ax
;-370         while(i < 16) {

.mdump25:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump26
;-371             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-372             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump27
 push 46
 call putch
 add  sp, 2
;-373                 else putch(c);

 jmp .mdump28
.mdump27:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-374             adr++;

.mdump28:
 inc  word[bp+4]
;-375             i++;

 inc  word[bp-4]
;-376         }

;-377     }

 jmp .mdump25
.mdump26:
;-378 }

 jmp .mdump20
.mdump21:
;-379 

;-380 //------------------------------------ main ---------------

;-381 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-382 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-383 	

;-384 	Params(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Params
 add  sp, 2
;-385 	testDisk(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call testDisk
 add  sp, 2
;-386 //	mdump(DiskBuf, 512);

;-387 	Int13hExt(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hExt
 add  sp, 2
;-388 }

 ret
ENDP
;Glob. variables:37 (400):335 (4000), Functions:24 (300):221 (3000)
;Lines:389, Constant: 443 (3000), stacksize: 56831