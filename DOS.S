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

;-18 char DOS_ERR=0;

DOS_ERR db 0
;-19 unsigned int count21h=0;

count21h dw 0
;-20 

;-21 int writetty()     {//char in AL


writetty: PROC
;-22     ah=0x0E;

 mov  ah, 14
;-23     push bx;

push bx;
;-24     bx=0;			//page in BH

 mov  bx, 0
;-25     inth 0x10;		//16

 int  16
;-26     pop bx;

pop bx;
;-27 }

;-28 int putch(char c)  {

 ret
ENDP

putch: PROC
;-29     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;14 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-30         al=13;

 mov  al, 13
;-31         writetty();

 call writetty
;-32     }

;-33     al=c;

.putch1:
 mov  al, [bp+4]
;-34     writetty();

 call writetty
;-35 }

;-36 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-37     char c;

;-38     while(*s) {

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
;-39         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-40         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-41         s++;

 inc  word[bp+4]
;-42     }

;-43 }

 jmp .cputs2
.cputs3:
;-44 

;-45 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-46     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-47     inth 0x16;//AH=Scan code, AL=char

 int  22
;-48 }

;-49 int waitkey() {

 ret
ENDP

waitkey: PROC
;-50     ah=0x11;//get kbd status

 mov  ah, 17
;-51     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-52     //zero flag: 0=IS char, 1=NO char

;-53     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-54 }

;-55 int getkey() {

 ret
ENDP

getkey: PROC
;-56     waitkey();

 call waitkey
;-57     getch();

 call getch
;-58     ah=0;//clear scan code

 mov  ah, 0
;-59     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey4
 call getch
 add ax, 256
;-60     //put ext code in AX

;-61 }

.getkey4:
;-62 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-63     getkey();

 call getkey
;-64     writetty();//destroys AH

 call writetty
;-65 }

;-66 

;-67 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-68     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;14 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-69     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex45
 add  byte[bp+4], 7
;-70     putch(c);

.printhex45:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-71 }

;-72 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-73     unsigned char nib;

;-74     nib = c >> 4; printhex4(nib);

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
;-75     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-76 }

;-77 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-78     unsigned int half;

;-79     half = i >>  8; printhex8(half);

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
;-80     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-81 }

;-82 

;-83 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-84     unsigned int e;

;-85     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;14 var unsg word n = bp+4
;15 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign6
;-86         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-87         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-88         }

;-89     n=n%10;

.printunsign6:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-90     n+='0';

 add  word[bp+4], 48
;-91     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-92 }

;-93 

;-94 int memcpy(char *s, char *t, int i) {

 LEAVE
 ret
ENDP

memcpy: PROC
;-95 	unsigned int r;

;-96 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;14 ptr sign byte s = bp+4
;15 ptr sign byte t = bp+6
;16 var sign word i = bp+8
;17 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-97 	do {

.memcpy7:
;-98 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-99 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-100 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy8
 jmp .memcpy7
.memcpy8:
;-101 	ax=r;//	return r;

 mov  ax, [bp-2]
;-102 }

;-103 

;-104 int printlong(unsigned int lo, unsigned int hi) {

 LEAVE
 ret
ENDP

printlong: PROC
;-105 // DX:AX DIV BX = AX remainder dx

;-106 	dx=hi;

;Function : printlong, Number local Var: 2
; # type sign width local variables
;14 var unsg word lo = bp+4
;15 var unsg word hi = bp+6;
 ENTER  0,0
 mov  dx, [bp+6]
;-107 	ax=lo;

 mov  ax, [bp+4]
;-108 __asm{	

	
;-109   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-110     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-111 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-112     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-113     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-114     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-115     db		145;=91h xchg ax,cx;Temporarily move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx;Temporarily move it to CX restoring LowDividend
;-116     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-117     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-118     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-119     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-120     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-121     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-122 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-123 }


;-124     writetty();

 call writetty
;-125 __asm{


;-126     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-127     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-128     jb      .b             ;Not yet	

    jb      .b             ;Not yet	
;-129 }		


;-130 }

;-131 

;-132 //--------------------------------  disk IO  -------------------

;-133 char BIOS_ERR=0;

 LEAVE
 ret
ENDP
BIOS_ERR db 0
;-134 unsigned int  BIOS_Status=0;

BIOS_Status dw 0
;-135 char DiskBuf [512];

section .bss
absolute 8192
DiskBuf resb 512
section .text
;-136 char Drive;

Drive db 0
;-137 unsigned int  Cylinders;

Cylinders dw 0
;-138 char Sectors;

Sectors db 0
;-139 char Heads;

Heads db 0
;-140 char Attached;

Attached db 0
;-141 int  ParmTableSeg;

ParmTableSeg dw 0
;-142 int  ParmTableOfs;

ParmTableOfs dw 0
;-143 char DriveType;

DriveType db 0
;-144 int  PartNo;

PartNo dw 0
;-145 //start hard disk partition structure 16 bytes

;-146 unsigned char ptBootable;	//80h = active partition, else 00

ptBootable db 0
;-147 unsigned char ptStartHead;	//

ptStartHead db 0
;-148 unsigned char ptStartSector;	//bits 0-5

ptStartSector db 0
;-149 unsigned int  ptStartCylinder;//bits 8,9 in bits 6,7 of sector

ptStartCylinder dw 0
;-150 unsigned char ptFileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=hugePart

ptFileSystem db 0
;-151 unsigned char ptEndHead;		//

ptEndHead db 0
;-152 unsigned char ptEndSector;	//bits 0-5

ptEndSector db 0
;-153 unsigned int  ptEndCylinder;	//bits 8,9 in bits 6,7 of sector

ptEndCylinder dw 0
;-154 unsigned int ptStartSectorlo;//sectors preceding partition

ptStartSectorlo dw 0
;-155 unsigned int ptStartSectorhi;

ptStartSectorhi dw 0
;-156 unsigned int ptPartLenlo;    //length of partition in sectors

ptPartLenlo dw 0
;-157 unsigned int ptPartLenhi;

ptPartLenhi dw 0
;-158 //end hard disk partition structure

;-159 

;-160 int Int13hRW(char rw, char drive, char head, int cyl, char sector,


Int13hRW: PROC
;-161 	char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-162 	BIOS_ERR=0;	

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
;-163 	dl=drive;

 mov  dl, [bp+6]
;-164 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-165 	es=BufSeg;

 mov  es, [bp+16]
;-166 	bx=BufOfs;

 mov  bx, [bp+18]
;-167 	cx=cyl;	

 mov  cx, [bp+10]
;-168 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-169 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-170 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-171 	cl += sector;

 add  cl, [bp+12]
;-172 	ch=cyl;//low byte of cyl in ch, word 2 byte	

 mov  ch, [bp+10]
;-173 	al=count;

 mov  al, [bp+14]
;-174 	ah=rw;

 mov  ah, [bp+4]
;-175 	inth 0x13;

 int  19
;-176     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-177 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-178 }

;-179 int Int13hRaw(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hRaw: PROC
;-180 	BIOS_ERR=0;	

;Function : Int13hRaw, Number local Var: 2
; # type sign width local variables
;38 var sign byte drive = bp+4
;39 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-181 	dl=drive;

 mov  dl, [bp+4]
;-182 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-183 	inth 0x13;

 int  19
;-184     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-185 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-186 }

;-187 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-188 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-189 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-190 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-191 	BIOS_Status=Int13hRaw(Drive, 0);//Reset

 push 0
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-192 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-193 }	

;-194 

;-195 int Params(char drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Params: PROC
;-196 	cputs("(AH=08)Drive Params:");

;Function : Params, Number local Var: 1
; # type sign width local variables
;38 var sign byte drive = bp+4;
 ENTER  0,0
 push Params_0
 call cputs
 add  sp, 2
;-197 	BIOS_Status=Int13hRaw(drive, 8);

 push 8
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-198 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Params9
 call Int13hError
;-199 	else {

 jmp .Params10
.Params9:
;-200 		asm mov [Heads],        dh

 mov [Heads],        dh
;-201 //		Heads++;

;-202 		asm mov [Attached],     dl

 mov [Attached],     dl
;-203 		// CX =       ---CH--- ---CL---

;-204 		// cylinder : 76543210 98

;-205 		// sector   :            543210	

;-206 		asm mov [Sectors],      cl

 mov [Sectors],      cl
;-207 		Sectors &= 0x3F;// 63

 and  byte[Sectors], 63
;-208 //		Sectors++;//1 to 64

;-209 	

;-210 		asm mov [Cylinders],    cx	

 mov [Cylinders],    cx	
;-211 		Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[Cylinders], 192
;-212 		Cylinders = Cylinders << 2;//compiler flaw:

 mov ax, [Cylinders]
 shl ax, 2
 mov word [Cylinders], ax
;-213 		asm add [Cylinders],    ch;//byte add, low byte is empty	

 add [Cylinders],    ch;//byte add, low byte is empty	
;-214 	

;-215 		cputs("CyHdSc=");			printunsign(Cylinders);

 push Params_1
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
;-216 		putch('/');					printunsign(Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-217 		putch('/');					printunsign(Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-218 		cputs(", NoDrives=");		printhex8(Attached);

 push Params_2
 call cputs
 add  sp, 2
 mov al, byte [Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-219 		putch('.');

 push 46
 call putch
 add  sp, 2
;-220 	}

;-221 }

.Params10:
;-222 

;-223 int Status(drive) {

 LEAVE
 ret
Params_0 db "(AH=08)Drive Params:",0
Params_1 db "CyHdSc=",0
Params_2 db ", NoDrives=",0
ENDP

Status: PROC
;-224 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;38 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-225 	cputs("(1)Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-226 	BIOS_Status=Int13hRaw(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-227 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status11
 call Int13hError
;-228 	printhex16(BIOS_Status);	

.Status11:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-229 }	

;-230 

;-231 int getPartitionData() {

 LEAVE
 ret
Status_0 db "(1)Status last Op=",0
ENDP

getPartitionData: PROC
;-232 	unsigned int j; char c; char *p;

;-233 	j = PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;38 var unsg word j = bp-2
;39 var sign byte c = bp-4
;40 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [PartNo]
 shl ax, 4
 mov [bp-2], ax
;-234 	j = j + 0x1be;			ptBootable=DiskBuf[j];

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptBootable], al
;-235 	j++;					ptStartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartHead], al
;-236 	j++;					ptStartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartSector], al
;-237 	ah=0;//next line convert byte to word

 mov  ah, 0
;-238 	ptStartCylinder=ptStartSector;	

 mov al, [ptStartSector]
 mov word [ptStartCylinder], ax
;-239 	ptStartSector &= 0x3F;

 and  byte[ptStartSector], 63
;-240 //	ptStartSector++;//Sector start with 1 todo

;-241 	ptStartCylinder &= 0xC0;

 and  word[ptStartCylinder], 192
;-242 	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	

 mov ax, [ptStartCylinder]
 shl ax, 2
 mov word [ptStartCylinder], ax
;-243 	j++;

 inc  word[bp-2]
;-244 	ah=0;//byte to word

 mov  ah, 0
;-245 	ptStartCylinder=DiskBuf[j] + ptStartCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptStartCylinder]
 mov word [ptStartCylinder], ax
;-246 //	byte add, ok because low byte is empty

;-247 	j++;					ptFileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptFileSystem], al
;-248 	j++;					ptEndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndHead], al
;-249 	j++;					ptEndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndSector], al
;-250 	ah=0;//next line convert byte to word

 mov  ah, 0
;-251 	ptEndCylinder=ptEndSector;//see next 5 line		

 mov al, [ptEndSector]
 mov word [ptEndCylinder], ax
;-252 	ptEndSector &= 0x3F;

 and  byte[ptEndSector], 63
;-253 //	ptEndSector++;//Sector start with 1 todo

;-254 	ptEndCylinder &= 0xC0;

 and  word[ptEndCylinder], 192
;-255 	ptEndCylinder = ptEndCylinder << 2;//OK no short cut!	

 mov ax, [ptEndCylinder]
 shl ax, 2
 mov word [ptEndCylinder], ax
;-256 	j++;

 inc  word[bp-2]
;-257 	ah=0;//byte to word

 mov  ah, 0
;-258 	ptEndCylinder=DiskBuf[j] + ptEndCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptEndCylinder]
 mov word [ptEndCylinder], ax
;-259 //	byte add, ok because low byte is empty	

;-260 	j++;

 inc  word[bp-2]
;-261 	p = j + &DiskBuf;//copy ptStartSector, ptPartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-262 	memcpy(&ptStartSectorlo, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [ptStartSectorlo]
 push ax
 call memcpy
 add  sp, 6
;-263 	

;-264 	j += 8;//next partition entry

 add  word[bp-2], 8
;-265 }

;-266 	

;-267 int printPartitionData() {

 LEAVE
 ret
ENDP

printPartitionData: PROC
;-268 	putch(10);		

 push 10
 call putch
 add  sp, 2
;-269 	cputs("No=");			printunsign(PartNo);

 push printPartitionData_0
 call cputs
 add  sp, 2
 push word [PartNo]
 call printunsign
 add  sp, 2
;-270 	cputs(",Boot=");		printhex8(ptBootable);

 push printPartitionData_1
 call cputs
 add  sp, 2
 mov al, byte [ptBootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-271 	cputs(" ID=");			printunsign(ptFileSystem);

 push printPartitionData_2
 call cputs
 add  sp, 2
 mov al, byte [ptFileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-272 	cputs(",HdSeCy=");		printunsign(ptStartHead);

 push printPartitionData_3
 call cputs
 add  sp, 2
 mov al, byte [ptStartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-273 	cputs("/");				printunsign(ptStartSector);	

 push printPartitionData_4
 call cputs
 add  sp, 2
 mov al, byte [ptStartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-274 	cputs("/");				printunsign(ptStartCylinder);

 push printPartitionData_5
 call cputs
 add  sp, 2
 push word [ptStartCylinder]
 call printunsign
 add  sp, 2
;-275 	cputs("-");				printunsign(ptEndHead);

 push printPartitionData_6
 call cputs
 add  sp, 2
 mov al, byte [ptEndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-276 	cputs("/");				printunsign(ptEndSector);	

 push printPartitionData_7
 call cputs
 add  sp, 2
 mov al, byte [ptEndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-277 	cputs("/");				printunsign(ptEndCylinder);

 push printPartitionData_8
 call cputs
 add  sp, 2
 push word [ptEndCylinder]
 call printunsign
 add  sp, 2
;-278 //	putch(10);		

;-279 	cputs(",Start=");

 push printPartitionData_9
 call cputs
 add  sp, 2
;-280 	printlong(ptStartSectorlo, ptStartSectorhi);

 push word [ptStartSectorhi]
 push word [ptStartSectorlo]
 call printlong
 add  sp, 4
;-281 	cputs(",Len=");

 push printPartitionData_10
 call cputs
 add  sp, 2
;-282 	printlong(ptPartLenlo, ptPartLenhi);

 push word [ptPartLenhi]
 push word [ptPartLenlo]
 call printlong
 add  sp, 4
;-283 }

;-284 	

;-285 int testDisk(drive) {

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
ENDP

testDisk: PROC
;-286 	char c; int i;

;-287 	asm mov [ParmTableSeg], ds

;Function : testDisk, Number local Var: 3
; # type sign width local variables
;38 var sign word drive = bp+4
;39 var sign byte c = bp-2
;40 var sign word i = bp-4;
 ENTER  4,0
 mov [ParmTableSeg], ds
;-288 	//Offset is in DiskBuf

;-289 	BIOS_Status=Int13hRW(2,drive,0,0,1,1,ParmTableSeg,DiskBuf);

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
;-290 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .testDisk12
 call Int13hError
;-291 	else {	

 jmp .testDisk13
.testDisk12:
;-292 		putch(10);

 push 10
 call putch
 add  sp, 2
;-293 		cputs("Read Partition Status:");

 push testDisk_0
 call cputs
 add  sp, 2
;-294 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-295 		cputs(",MBR Magic=");	

 push testDisk_1
 call cputs
 add  sp, 2
;-296 		i=510;		c = DiskBuf[i];		printhex8(c);

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
;-297 		i++;		c = DiskBuf[i];		printhex8(c);

 inc  word[bp-4]
 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-298 		

;-299 		cputs(",DiskBuf=");

 push testDisk_2
 call cputs
 add  sp, 2
;-300 		printhex16(ParmTableSeg);

 push word [ParmTableSeg]
 call printhex16
 add  sp, 2
;-301 		putch(':');							

 push 58
 call putch
 add  sp, 2
;-302 		printhex16(DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 call printhex16
 add  sp, 2
;-303 		putch('.');

 push 46
 call putch
 add  sp, 2
;-304 	

;-305 		PartNo=0;

 mov ax, 0
 mov word [PartNo], ax
;-306 		do {

.testDisk14:
;-307 			getPartitionData();

 call getPartitionData
;-308 			printPartitionData();

 call printPartitionData
;-309 			PartNo ++;

 inc  word[PartNo]
;-310 		} while (PartNo <4);

 mov ax, [PartNo]
 cmp ax, 4
 jge .testDisk15
 jmp .testDisk14
.testDisk15:
;-311 	}	

;-312 }

.testDisk13:
;-313 

;-314 int Int13hExt(char drive) {

 LEAVE
 ret
testDisk_0 db "Read Partition Status:",0
testDisk_1 db ",MBR Magic=",0
testDisk_2 db ",DiskBuf=",0
ENDP

Int13hExt: PROC
;-315 	putch(10);

;Function : Int13hExt, Number local Var: 1
; # type sign width local variables
;38 var sign byte drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-316 	cputs("Int13h 41hExt AX(3000=ERROR)=");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-317 	bx=0x55AA;

 mov  bx, 21930
;-318 	BIOS_Status=Int13hRaw(0x80, 0x41);	

 push 65
 push 128
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-319 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-320 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt16
;-321 		cputs(" not present");	

 push Int13hExt_1
 call cputs
 add  sp, 2
;-322 		Int13hError();	

 call Int13hError
;-323 		}

;-324 	else {

 jmp .Int13hExt17
.Int13hExt16:
;-325 		cputs(" status=1:supported");

 push Int13hExt_2
 call cputs
 add  sp, 2
;-326 		asm mov [vBX], bx;0xAA55 Extension installed

 mov [vBX], bx;0xAA55 Extension installed
;-327 		asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			
;-328 		cputs(" BX(AA55)=");				printhex16(vBX);

 push Int13hExt_3
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-329 		cputs(" CX(Interface bitmask)=");	printhex16(vCX);

 push Int13hExt_4
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-330 		}		

;-331 }	

.Int13hExt17:
;-332 

;-333 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
Int13hExt_0 db "Int13h 41hExt AX(3000=ERROR)=",0
Int13hExt_1 db " not present",0
Int13hExt_2 db " status=1:supported",0
Int13hExt_3 db " BX(AA55)=",0
Int13hExt_4 db " CX(Interface bitmask)=",0
ENDP

mdump: PROC
;-334     unsigned char c;

;-335     int i;

;-336     int j;

;-337     int k;

;-338     j=0;

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
;-339     k=0;

 mov ax, 0
 mov [bp-8], ax
;-340     while (j < len ) {

.mdump18:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump19
;-341 	    k++;; 

 inc  word[bp-8]
;-342 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump20
;-343 		    getkey();

 call getkey
;-344 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-345 		    }

;-346         putch(10);

.mdump20:
 push 10
 call putch
 add  sp, 2
;-347         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-348         putch(':');

 push 58
 call putch
 add  sp, 2
;-349         i=0;

 mov ax, 0
 mov [bp-4], ax
;-350         while (i < 16) {

.mdump21:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump22
;-351             putch(' ');

 push 32
 call putch
 add  sp, 2
;-352             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-353             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-354             adr++;

 inc  word[bp+4]
;-355             i++;

 inc  word[bp-4]
;-356             j++;

 inc  word[bp-6]
;-357             }

;-358         putch(' ');

 jmp .mdump21
.mdump22:
 push 32
 call putch
 add  sp, 2
;-359         adr -=16;

 sub  word[bp+4], 16
;-360         i=0;

 mov ax, 0
 mov [bp-4], ax
;-361         while(i < 16) {

.mdump23:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump24
;-362             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-363             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump25
 push 46
 call putch
 add  sp, 2
;-364                 else putch(c);

 jmp .mdump26
.mdump25:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-365             adr++;

.mdump26:
 inc  word[bp+4]
;-366             i++;

 inc  word[bp-4]
;-367         }

;-368     }

 jmp .mdump23
.mdump24:
;-369 }

 jmp .mdump18
.mdump19:
;-370 

;-371 //------------------------------------ main ---------------

;-372 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-373 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-374 	

;-375 	Params(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Params
 add  sp, 2
;-376 	testDisk(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call testDisk
 add  sp, 2
;-377 //	mdump(DiskBuf, 512);

;-378 	Int13hExt(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hExt
 add  sp, 2
;-379 }

 ret
ENDP
;Glob. variables:37 (400):335 (4000), Functions:24 (300):221 (3000)
;Lines:380, Constant: 369 (3000), stacksize: 56831