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
;-27 int  DiskBufSeg;

DiskBufSeg dw 0
;-28 char DriveType;

DriveType db 0
;-29 int  PartNo;

PartNo dw 0
;-30 //start hard disk partition structure 16 bytes

;-31 unsigned char ptBootable;	//80h = active partition, else 00

ptBootable db 0
;-32 unsigned char ptStartHead;	//

ptStartHead db 0
;-33 unsigned char ptStartSector;	//bits 0-5

ptStartSector db 0
;-34 unsigned int  ptStartCylinder;//bits 8,9 in bits 6,7 of sector

ptStartCylinder dw 0
;-35 unsigned char ptFileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=hugePart

ptFileSystem db 0
;-36 unsigned char ptEndHead;		//

ptEndHead db 0
;-37 unsigned char ptEndSector;	//bits 0-5

ptEndSector db 0
;-38 unsigned int  ptEndCylinder;	//bits 8,9 in bits 6,7 of sector

ptEndCylinder dw 0
;-39 unsigned int ptStartSectorlo;//sectors preceding partition

ptStartSectorlo dw 0
;-40 unsigned int ptStartSectorhi;

ptStartSectorhi dw 0
;-41 unsigned int ptPartLenlo;    //length of partition in sectors

ptPartLenlo dw 0
;-42 unsigned int ptPartLenhi;

ptPartLenhi dw 0
;-43 //end hard disk partition structure

;-44 

;-45 //start boot ms-dos

;-46 //unsigned char  jmp[3];	/* Must be 0xEB, 0x3C, 0x90		*/

;-47 //unsigned char  sys_id[8];	/* Probably:   "MSDOS5.0"		*/

;-48 unsigned int   sect_size;	/* Sector size in bytes (512)		*/

sect_size dw 0
;-49 unsigned char  clust_size;	/* Sectors per cluster (1,2,4,...,128)	*/

clust_size db 0
;-50 unsigned int   res_sects;	/* Reserved sectors at the beginning	*/

res_sects dw 0
;-51 unsigned char  num_fats;	/* Number of FAT copies (1 or 2)	*/

num_fats db 0
;-52 unsigned int   root_entr;	/* Root directory entries		*/

root_entr dw 0
;-53 unsigned int   total_sect;	/* Total sectors (if less 64k)		*/

total_sect dw 0
;-54 unsigned char  media_desc;	/* Media descriptor byte (F8h for HD)	*/

media_desc db 0
;-55 unsigned int   fat_size;	/* Sectors per fat			*/

fat_size dw 0
;-56 unsigned int   num_sects;	/* Sectors per track			*/

num_sects dw 0
;-57 unsigned int   num_sides;	/* Sides				*/

num_sides dw 0
;-58 unsigned long  hid_sects;	/* Special hidden sectors		*/

hid_sects dd 0
;-59 unsigned long  big_total;	/* Big total number of sectors  	*/

big_total dd 0
;-60 unsigned int   drive_num;	/* Drive number				*/

drive_num dw 0
;-61 unsigned char  ext_signat;	/* Extended Boot Record signature (29h)	*/

ext_signat db 0
;-62 unsigned long  serial_num;	/* Volume serial number			*/

serial_num dd 0
;-63 //unsigned char  label[11];	/* Volume label				*/

;-64 //unsigned char  fs_id[8];	/* File system id			*/

;-65 //unsigned char  xcode[448];	/* Loader executable code		*/

;-66 //unsigned short magic_num;	/* Magic number (Must be 0xAA55) 	*/

;-67 //end boot ms-dos

;-68 

;-69 

;-70 long L1;

L1 dd 0
;-71 long L2;

L2 dd 0
;-72 int test() {


test: PROC
;-73 L2 = L1;//OK	

 mov eax, [L1]
 mov dword [L2], eax
;-74 	}

;-75 	

;-76 int writetty()     {//char in AL

 ret
ENDP

writetty: PROC
;-77     ah=0x0E;

 mov  ah, 14
;-78     push bx;

push bx;
;-79     bx=0;			//page in BH

 mov  bx, 0
;-80     inth 0x10;		//16

 int  16
;-81     pop bx;

pop bx;
;-82 }

;-83 int putch(char c)  {

 ret
ENDP

putch: PROC
;-84     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;53 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-85         al=13;

 mov  al, 13
;-86         writetty();

 call writetty
;-87     }

;-88     al=c;

.putch1:
 mov  al, [bp+4]
;-89     writetty();

 call writetty
;-90 }

;-91 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-92     char c;

;-93     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;53 ptr sign byte s = bp+4
;54 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-94         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-95         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-96         s++;

 inc  word[bp+4]
;-97     }

;-98 }

 jmp .cputs2
.cputs3:
;-99 

;-100 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-101     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-102     inth 0x16;//AH=Scan code, AL=char

 int  22
;-103 }

;-104 int waitkey() {

 ret
ENDP

waitkey: PROC
;-105     ah=0x11;//get kbd status

 mov  ah, 17
;-106     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-107     //zero flag: 0=IS char, 1=NO char

;-108     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-109 }

;-110 int getkey() {

 ret
ENDP

getkey: PROC
;-111     waitkey();

 call waitkey
;-112     getch();

 call getch
;-113     ah=0;//clear scan code

 mov  ah, 0
;-114     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey4
 call getch
 add ax, 256
;-115     //put ext code in AX

;-116 }

.getkey4:
;-117 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-118     getkey();

 call getkey
;-119     writetty();//destroys AH

 call writetty
;-120 }

;-121 

;-122 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-123     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;53 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-124     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex45
 add  byte[bp+4], 7
;-125     putch(c);

.printhex45:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-126 }

;-127 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-128     unsigned char nib;

;-129     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;53 var unsg byte c = bp+4
;54 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-130     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-131 }

;-132 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-133     unsigned int half;

;-134     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;53 var unsg word i = bp+4
;54 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-135     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-136 }

;-137 

;-138 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-139     unsigned int e;

;-140     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;53 var unsg word n = bp+4
;54 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign6
;-141         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-142         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-143         }

;-144     n=n%10;

.printunsign6:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-145     n+='0';

 add  word[bp+4], 48
;-146     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-147 }

;-148 

;-149 int memcpy(char *s, char *t, int i) {

 LEAVE
 ret
ENDP

memcpy: PROC
;-150 	unsigned int r;

;-151 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;53 ptr sign byte s = bp+4
;54 ptr sign byte t = bp+6
;55 var sign word i = bp+8
;56 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-152 	do {

.memcpy7:
;-153 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-154 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-155 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy8
 jmp .memcpy7
.memcpy8:
;-156 	ax=r;//	return r;

 mov  ax, [bp-2]
;-157 }

;-158 

;-159 int printlong(unsigned int lo, unsigned int hi) {

 LEAVE
 ret
ENDP

printlong: PROC
;-160 // DX:AX DIV BX = AX remainder dx

;-161 	dx=hi;

;Function : printlong, Number local Var: 2
; # type sign width local variables
;53 var unsg word lo = bp+4
;54 var unsg word hi = bp+6;
 ENTER  0,0
 mov  dx, [bp+6]
;-162 	ax=lo;

 mov  ax, [bp+4]
;-163 __asm{	

	
;-164   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-165     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-166 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-167     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-168     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-169     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-170     db		145;=91h xchg ax,cx;Temporarily move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx;Temporarily move it to CX restoring LowDividend
;-171     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-172     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-173     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-174     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-175     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-176     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-177 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-178 }	writetty();		__asm{


 call writetty

;-179     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-180     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-181     jb      .b             ;Not yet	

    jb      .b             ;Not yet	
;-182 } }


;-183 

;-184 //--------------------------------  disk IO  -------------------

;-185 

;-186 int Int13hRW(char rw, char drive, char head, int cyl, char sector,

 LEAVE
 ret
ENDP

Int13hRW: PROC
;-187 	char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-188 	BIOS_ERR=0;	

;Function : Int13hRW, Number local Var: 8
; # type sign width local variables
;53 var sign byte rw = bp+4
;54 var sign byte drive = bp+6
;55 var sign byte head = bp+8
;56 var sign word cyl = bp+10
;57 var sign byte sector = bp+12
;58 var sign byte count = bp+14
;59 var sign word BufSeg = bp+16
;60 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-189 	dl=drive;

 mov  dl, [bp+6]
;-190 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-191 	es=BufSeg;

 mov  es, [bp+16]
;-192 	bx=BufOfs;

 mov  bx, [bp+18]
;-193 	cx=cyl;	

 mov  cx, [bp+10]
;-194 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-195 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-196 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-197 	cl += sector;

 add  cl, [bp+12]
;-198 	ch=cyl;//low byte of cyl in ch, word 2 byte	

 mov  ch, [bp+10]
;-199 	al=count;

 mov  al, [bp+14]
;-200 	ah=rw;

 mov  ah, [bp+4]
;-201 	inth 0x13;

 int  19
;-202     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-203 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-204 }

;-205 int Int13hRaw(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hRaw: PROC
;-206 	BIOS_ERR=0;	

;Function : Int13hRaw, Number local Var: 2
; # type sign width local variables
;53 var sign byte drive = bp+4
;54 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-207 	dl=drive;

 mov  dl, [bp+4]
;-208 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-209 	inth 0x13;

 int  19
;-210     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-211 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-212 }

;-213 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-214 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-215 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-216 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-217 	BIOS_Status=Int13hRaw(Drive, 0);//Reset

 push 0
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-218 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-219 }	

;-220 

;-221 int Params(char drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Params: PROC
;-222 	cputs("(AH=08)Drive Params:");

;Function : Params, Number local Var: 1
; # type sign width local variables
;53 var sign byte drive = bp+4;
 ENTER  0,0
 push Params_0
 call cputs
 add  sp, 2
;-223 	BIOS_Status=Int13hRaw(drive, 8);

 push 8
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-224 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Params9
 call Int13hError
;-225 	else {

 jmp .Params10
.Params9:
;-226 		asm mov [Heads],        dh

 mov [Heads],        dh
;-227 //		Heads++;

;-228 		asm mov [Attached],     dl

 mov [Attached],     dl
;-229 		// CX =       ---CH--- ---CL---

;-230 		// cylinder : 76543210 98

;-231 		// sector   :            543210	

;-232 		asm mov [Sectors],      cl

 mov [Sectors],      cl
;-233 		Sectors &= 0x3F;// 63

 and  byte[Sectors], 63
;-234 //		Sectors++;//1 to 64

;-235 	

;-236 		asm mov [Cylinders],    cx	

 mov [Cylinders],    cx	
;-237 		Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[Cylinders], 192
;-238 		Cylinders = Cylinders << 2;//compiler flaw:

 mov ax, [Cylinders]
 shl ax, 2
 mov word [Cylinders], ax
;-239 		asm add [Cylinders],    ch;//byte add, low byte is empty	

 add [Cylinders],    ch;//byte add, low byte is empty	
;-240 	

;-241 		cputs("CylHeadSec=");		printunsign(Cylinders);

 push Params_1
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
;-242 		putch('/');					printunsign(Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-243 		putch('/');					printunsign(Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-244 		cputs(", NoDrives=");		printhex8(Attached);

 push Params_2
 call cputs
 add  sp, 2
 mov al, byte [Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-245 		putch('.');

 push 46
 call putch
 add  sp, 2
;-246 	}

;-247 }

.Params10:
;-248 

;-249 int Status(drive) {

 LEAVE
 ret
Params_0 db "(AH=08)Drive Params:",0
Params_1 db "CylHeadSec=",0
Params_2 db ", NoDrives=",0
ENDP

Status: PROC
;-250 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;53 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-251 	cputs("(1)Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-252 	BIOS_Status=Int13hRaw(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-253 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status11
 call Int13hError
;-254 	printhex16(BIOS_Status);	

.Status11:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-255 }	

;-256 

;-257 int getPartitionData() {

 LEAVE
 ret
Status_0 db "(1)Status last Op=",0
ENDP

getPartitionData: PROC
;-258 	unsigned int j; char c; char *p;

;-259 	j = PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;53 var unsg word j = bp-2
;54 var sign byte c = bp-4
;55 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [PartNo]
 shl ax, 4
 mov [bp-2], ax
;-260 	j = j + 0x1be;			ptBootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptBootable], al
;-261 	j++;					ptStartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartHead], al
;-262 	j++;					ptStartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartSector], al
;-263 	ah=0;//next line convert byte to word

 mov  ah, 0
;-264 	ptStartCylinder=ptStartSector;	

 mov al, [ptStartSector]
 mov word [ptStartCylinder], ax
;-265 	ptStartSector &= 0x3F;

 and  byte[ptStartSector], 63
;-266 //	ptStartSector++;//Sector start with 1 todo

;-267 	ptStartCylinder &= 0xC0;

 and  word[ptStartCylinder], 192
;-268 	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	

 mov ax, [ptStartCylinder]
 shl ax, 2
 mov word [ptStartCylinder], ax
;-269 	j++;

 inc  word[bp-2]
;-270 	ah=0;//byte to word

 mov  ah, 0
;-271 	ptStartCylinder=DiskBuf[j] + ptStartCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptStartCylinder]
 mov word [ptStartCylinder], ax
;-272 	j++;					ptFileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptFileSystem], al
;-273 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=huge<2GB MS-DOS4.0	

;-274 	j++;					ptEndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndHead], al
;-275 	j++;					ptEndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndSector], al
;-276 	ah=0;//next line convert byte to word

 mov  ah, 0
;-277 	ptEndCylinder=ptEndSector;//see next 5 line		

 mov al, [ptEndSector]
 mov word [ptEndCylinder], ax
;-278 	ptEndSector &= 0x3F;

 and  byte[ptEndSector], 63
;-279 //	ptEndSector++;//Sector start with 1 todo

;-280 	ptEndCylinder &= 0xC0;

 and  word[ptEndCylinder], 192
;-281 	ptEndCylinder = ptEndCylinder << 2;//OK no short cut!	

 mov ax, [ptEndCylinder]
 shl ax, 2
 mov word [ptEndCylinder], ax
;-282 	j++;

 inc  word[bp-2]
;-283 	ah=0;//byte to word

 mov  ah, 0
;-284 	ptEndCylinder=DiskBuf[j] + ptEndCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptEndCylinder]
 mov word [ptEndCylinder], ax
;-285 	j++;

 inc  word[bp-2]
;-286 	p = j + &DiskBuf;//copy ptStartSector, ptPartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-287 	memcpy(&ptStartSectorlo, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [ptStartSectorlo]
 push ax
 call memcpy
 add  sp, 6
;-288 	

;-289 	j += 8;//next partition entry

 add  word[bp-2], 8
;-290 }

;-291 	

;-292 int printPartitionData() {

 LEAVE
 ret
ENDP

printPartitionData: PROC
;-293 	unsigned int i; unsigned int j;

;-294 	putch(10);		

;Function : printPartitionData, Number local Var: 2
; # type sign width local variables
;53 var unsg word i = bp-2
;54 var unsg word j = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-295 	cputs("No=");			printunsign(PartNo);

 push printPartitionData_0
 call cputs
 add  sp, 2
 push word [PartNo]
 call printunsign
 add  sp, 2
;-296 	cputs(",Boot=");		printhex8(ptBootable);

 push printPartitionData_1
 call cputs
 add  sp, 2
 mov al, byte [ptBootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-297 	cputs(" ID=");			printunsign(ptFileSystem);

 push printPartitionData_2
 call cputs
 add  sp, 2
 mov al, byte [ptFileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-298 	cputs(",HdSeCy=");		printunsign(ptStartHead);

 push printPartitionData_3
 call cputs
 add  sp, 2
 mov al, byte [ptStartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-299 	cputs("/");				printunsign(ptStartSector);	

 push printPartitionData_4
 call cputs
 add  sp, 2
 mov al, byte [ptStartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-300 	cputs("/");				printunsign(ptStartCylinder);

 push printPartitionData_5
 call cputs
 add  sp, 2
 push word [ptStartCylinder]
 call printunsign
 add  sp, 2
;-301 	cputs("-");				printunsign(ptEndHead);

 push printPartitionData_6
 call cputs
 add  sp, 2
 mov al, byte [ptEndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-302 	cputs("/");				printunsign(ptEndSector);	

 push printPartitionData_7
 call cputs
 add  sp, 2
 mov al, byte [ptEndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-303 	cputs("/");				printunsign(ptEndCylinder);

 push printPartitionData_8
 call cputs
 add  sp, 2
 push word [ptEndCylinder]
 call printunsign
 add  sp, 2
;-304 //	putch(10);		

;-305 	cputs(",Start=");

 push printPartitionData_9
 call cputs
 add  sp, 2
;-306 	printlong(ptStartSectorlo, ptStartSectorhi);

 push word [ptStartSectorhi]
 push word [ptStartSectorlo]
 call printlong
 add  sp, 4
;-307 	cputs(",Len=");

 push printPartitionData_10
 call cputs
 add  sp, 2
;-308 	printlong(ptPartLenlo, ptPartLenhi);

 push word [ptPartLenhi]
 push word [ptPartLenlo]
 call printlong
 add  sp, 4
;-309 	cputs(" Sec=");

 push printPartitionData_11
 call cputs
 add  sp, 2
;-310 	i = ptPartLenhi <<  5;//64KB Sec to MB; >>4 + <<9 = <<5

 mov ax, [ptPartLenhi]
 shl ax, 5
 mov [bp-2], ax
;-311 	j = ptPartLenlo >> 11;//Sec to MB

 mov ax, [ptPartLenlo]
 shr ax, 11
 mov [bp-4], ax
;-312 	i = i + j;

 mov ax, [bp-2]
 add ax, [bp-4]
 mov [bp-2], ax
;-313 	printunsign(i);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-314 	cputs(" MByte.");

 push printPartitionData_12
 call cputs
 add  sp, 2
;-315 }

;-316 	

;-317 int testDisk(drive) {

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
;-318 	char c; int i;

;-319 	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf

;Function : testDisk, Number local Var: 3
; # type sign width local variables
;53 var sign word drive = bp+4
;54 var sign byte c = bp-2
;55 var sign word i = bp-4;
 ENTER  4,0
 mov [DiskBufSeg], ds; //Offset is in DiskBuf
;-320 	BIOS_Status=Int13hRW(2,drive,0,0,1,1,DiskBufSeg,DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push 1
 push 1
 push 0
 push 0
 push word [bp+4]
 push 2
 call Int13hRW
 add  sp, 16
 mov word [BIOS_Status], ax
;-321 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .testDisk12
 call Int13hError
;-322 	else {	

 jmp .testDisk13
.testDisk12:
;-323 		putch(10);

 push 10
 call putch
 add  sp, 2
;-324 		cputs("Read Partition Status:");

 push testDisk_0
 call cputs
 add  sp, 2
;-325 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-326 		cputs(",MBR Magic=");	

 push testDisk_1
 call cputs
 add  sp, 2
;-327 		i=510;		c = DiskBuf[i];		printhex8(c);

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
;-328 		i++;		c = DiskBuf[i];		printhex8(c);

 inc  word[bp-4]
 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-329 		

;-330 		cputs(",DiskBuf=");

 push testDisk_2
 call cputs
 add  sp, 2
;-331 		printhex16(DiskBufSeg);

 push word [DiskBufSeg]
 call printhex16
 add  sp, 2
;-332 		putch(':');							

 push 58
 call putch
 add  sp, 2
;-333 		printhex16(DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 call printhex16
 add  sp, 2
;-334 		putch('.');

 push 46
 call putch
 add  sp, 2
;-335 	

;-336 		PartNo=0;

 mov ax, 0
 mov word [PartNo], ax
;-337 		do {

.testDisk14:
;-338 			getPartitionData();

 call getPartitionData
;-339 			printPartitionData();

 call printPartitionData
;-340 			if (ptBootable == 0x80) {

 mov al, [ptBootable]
 cmp al, 128
 jne .testDisk15
;-341 				cputs(" boot partition found");

 push testDisk_3
 call cputs
 add  sp, 2
;-342 				if (ptFileSystem == 6) cputs(" huge partition < 2GB");

 mov al, [ptFileSystem]
 cmp al, 6
 jne .testDisk16
 push testDisk_4
 call cputs
 add  sp, 2
;-343 				PartNo=99;//end of loop	

.testDisk16:
 mov ax, 99
 mov word [PartNo], ax
;-344 			}

;-345 			PartNo ++;

.testDisk15:
 inc  word[PartNo]
;-346 		} while (PartNo <4);

 mov ax, [PartNo]
 cmp ax, 4
 jge .testDisk17
 jmp .testDisk14
.testDisk17:
;-347 	}	

;-348 }

.testDisk13:
;-349 

;-350 int getMBR() {

 LEAVE
 ret
testDisk_0 db "Read Partition Status:",0
testDisk_1 db ",MBR Magic=",0
testDisk_2 db ",DiskBuf=",0
testDisk_3 db " boot partition found",0
testDisk_4 db " huge partition < 2GB",0
ENDP

getMBR: PROC
;-351 	Cylinders=ptStartCylinder;

 mov ax, [ptStartCylinder]
 mov word [Cylinders], ax
;-352 	Heads=ptStartHead;

 mov al, [ptStartHead]
 mov byte [Heads], al
;-353 	Sectors=ptStartSector ; // +1

 mov al, [ptStartSector]
 mov byte [Sectors], al
;-354 	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf

 mov [DiskBufSeg], ds; //Offset is in DiskBuf
;-355   BIOS_Status=Int13hRW(2,Drive,Heads,Cylinders,Sectors,1,DiskBufSeg,DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push 1
 mov al, byte [Sectors]
 mov ah, 0
 push ax
 push word [Cylinders]
 mov al, byte [Heads]
 mov ah, 0
 push ax
 mov al, byte [Drive]
 mov ah, 0
 push ax
 push 2
 call Int13hRW
 add  sp, 16
 mov word [BIOS_Status], ax
;-356 		

;-357 	

;-358 }

;-359 

;-360 int Int13hExt(char drive) {

 ret
ENDP

Int13hExt: PROC
;-361 	putch(10);

;Function : Int13hExt, Number local Var: 1
; # type sign width local variables
;53 var sign byte drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-362 	cputs("Int13h 41hExt AX(3000=ERROR)=");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-363 	bx=0x55AA;

 mov  bx, 21930
;-364 	BIOS_Status=Int13hRaw(0x80, 0x41);	

 push 65
 push 128
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-365 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-366 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt18
;-367 		cputs(" not present");	

 push Int13hExt_1
 call cputs
 add  sp, 2
;-368 		Int13hError();	

 call Int13hError
;-369 		}

;-370 	else {

 jmp .Int13hExt19
.Int13hExt18:
;-371 		cputs(" status=1:supported");

 push Int13hExt_2
 call cputs
 add  sp, 2
;-372 		asm mov [vBX], bx;0xAA55 Extension installed

 mov [vBX], bx;0xAA55 Extension installed
;-373 		asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			
;-374 		cputs(" BX(AA55)=");				printhex16(vBX);

 push Int13hExt_3
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-375 		cputs(" CX(Interface bitmask)=");	printhex16(vCX);

 push Int13hExt_4
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-376 		}		

;-377 }	

.Int13hExt19:
;-378 

;-379 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
Int13hExt_0 db "Int13h 41hExt AX(3000=ERROR)=",0
Int13hExt_1 db " not present",0
Int13hExt_2 db " status=1:supported",0
Int13hExt_3 db " BX(AA55)=",0
Int13hExt_4 db " CX(Interface bitmask)=",0
ENDP

mdump: PROC
;-380     unsigned char c;

;-381     int i;

;-382     int j;

;-383     int k;

;-384     j=0;

;Function : mdump, Number local Var: 6
; # type sign width local variables
;53 ptr unsg byte adr = bp+4
;54 var unsg word len = bp+6
;55 var unsg byte c = bp-2
;56 var sign word i = bp-4
;57 var sign word j = bp-6
;58 var sign word k = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-6], ax
;-385     k=0;

 mov ax, 0
 mov [bp-8], ax
;-386     while (j < len ) {

.mdump20:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump21
;-387 	    k++;; 

 inc  word[bp-8]
;-388 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump22
;-389 		    getkey();

 call getkey
;-390 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-391 		    }

;-392         putch(10);

.mdump22:
 push 10
 call putch
 add  sp, 2
;-393         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-394         putch(':');

 push 58
 call putch
 add  sp, 2
;-395         i=0;

 mov ax, 0
 mov [bp-4], ax
;-396         while (i < 16) {

.mdump23:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump24
;-397             putch(' ');

 push 32
 call putch
 add  sp, 2
;-398             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-399             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-400             adr++;

 inc  word[bp+4]
;-401             i++;

 inc  word[bp-4]
;-402             j++;

 inc  word[bp-6]
;-403             }

;-404         putch(' ');

 jmp .mdump23
.mdump24:
 push 32
 call putch
 add  sp, 2
;-405         adr -=16;

 sub  word[bp+4], 16
;-406         i=0;

 mov ax, 0
 mov [bp-4], ax
;-407         while(i < 16) {

.mdump25:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump26
;-408             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-409             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump27
 push 46
 call putch
 add  sp, 2
;-410                 else putch(c);

 jmp .mdump28
.mdump27:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-411             adr++;

.mdump28:
 inc  word[bp+4]
;-412             i++;

 inc  word[bp-4]
;-413         }

;-414     }

 jmp .mdump25
.mdump26:
;-415 }

 jmp .mdump20
.mdump21:
;-416 

;-417 //------------------------------------ main ---------------

;-418 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-419 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-420 	

;-421 	Params(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Params
 add  sp, 2
;-422 	testDisk(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call testDisk
 add  sp, 2
;-423 //	Int13hExt(Drive);

;-424 	getMBR();

 call getMBR
;-425 	mdump(DiskBuf, 512);

 push 512
 lea  ax, [DiskBuf]
 push ax
 call mdump
 add  sp, 4
;-426 }

 ret
ENDP
;Glob. variables:52 (400):470 (4000), Functions:26 (300):233 (3000)
;Lines:427, Constant: 443 (3000), stacksize: 56831