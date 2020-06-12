;PLA compiler A.COM V1.0.1, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.1.5";//test bed

Version1 db "DOS.COM V0.1.5",0
;-2 //todo: resize and take own stack

;-3 //Finder /hg/VirtualBox VMs/DOS1/DOS1.vhd (.vmdk) 

;-4 // Rechtsclick / Öffnen / Parallels Mounter

;-5 //Ranish Part, int8h: CHS 1014/15/63, Start=63,Len=1.023.057

;-6 //Boot Sec=63, head=16, hidden=63, Sec=983.121

;-7 #define ORGDATA		8192//start of arrays

;-8 unsigned int vAX;

vAX dw 0
;-9 unsigned int vBX;

vBX dw 0
;-10 unsigned int vCX;

vCX dw 0
;-11 unsigned int vDX;

vDX dw 0
;-12 unsigned int vSP;

vSP dw 0
;-13 unsigned int vBP;

vBP dw 0
;-14 unsigned int vCS;

vCS dw 0
;-15 unsigned int vDS;

vDS dw 0
;-16 unsigned int vSS;

vSS dw 0
;-17 unsigned int vES;

vES dw 0
;-18 

;-19 char DOS_ERR;

DOS_ERR db 0
;-20 char BIOS_ERR;

BIOS_ERR db 0
;-21 int  BIOS_Status;

BIOS_Status dw 0
;-22 char DiskBuf [512];

section .bss
absolute 8192
DiskBuf resb 512
section .text
;-23 char Drive;

Drive db 0
;-24 unsigned int  Cylinders;

Cylinders dw 0
;-25 char Sectors;

Sectors db 0
;-26 char Heads;

Heads db 0
;-27 char Attached;

Attached db 0
;-28 int  DiskBufSeg;

DiskBufSeg dw 0
;-29 char DriveType;

DriveType db 0
;-30 int  PartNo;

PartNo dw 0
;-31 /*     unsigned short disk;

;-32      unsigned short num_cyls;

;-33      unsigned short num_heads;

;-34      unsigned short num_sects;

;-35      unsigned long  total_sects;

;-36      unsigned short sect_per_cyl;

;-37      unsigned short sect_per_track;

;-38      unsigned short sect_size;

;-39      unsigned short bios_num_cyls; */

;-40 

;-41 //start hard disk partition structure 16 bytes in MBR

;-42 unsigned char ptBootable;		//80h = active partition, else 00

ptBootable db 0
;-43 unsigned char ptStartHead;

ptStartHead db 0
;-44 unsigned char ptStartSector;	//bits 0-5

ptStartSector db 0
;-45 unsigned int  ptStartCylinder;	//bits 8,9 in bits 6,7 of sector

ptStartCylinder dw 0
;-46 unsigned char ptFileSystem;		//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=largeFAT16

ptFileSystem db 0
;-47 unsigned char ptEndHead;

ptEndHead db 0
;-48 unsigned char ptEndSector;		//bits 0-5

ptEndSector db 0
;-49 unsigned int  ptEndCylinder;	//bits 8,9 in bits 6,7 of sector

ptEndCylinder dw 0
;-50 unsigned int ptStartSectorlo;	//sectors preceding partition

ptStartSectorlo dw 0
;-51 unsigned int ptStartSectorhi;

ptStartSectorhi dw 0
;-52 unsigned int ptPartLenlo;    	//length of partition in sectors

ptPartLenlo dw 0
;-53 unsigned int ptPartLenhi;

ptPartLenhi dw 0
;-54 //end hard disk partition structure

;-55 

;-56 //start boot BIOS Parameter Block

;-57 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-58 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-59 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-60 unsigned char bs_clust_size;// 13 sectors per cluster (1,2,4,..,128)

bs_clust_size db 0
;-61 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-62 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-63 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-64 unsigned int  bs_total_sect;// 19 number of total sectors (0 if > 32Mb)

bs_total_sect dw 0
;-65 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-66 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-67 unsigned int  bs_num_sects;	// 24 (DOS 3+)sectors per track 

bs_num_sects dw 0
;-68 unsigned int  bs_num_sides;	// 26 (DOS 3+)number of heads   

bs_num_sides dw 0
;-69 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors 

bs_hid_sects dd 0
;-70 unsigned long bs_big_total;	// 32 (DOS 4+) number of sectors if ofs 13 is 0

bs_big_total dd 0
;-71 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-72 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-73 unsigned char bs_ext_signat;// 38 (DOS 4+) Extended signature,get next 3(29h)

bs_ext_signat db 0
;-74 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-75 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-76 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-77 // 62 end boot BIOS Parameter Block

;-78 

;-79 int writetty()     {//char in AL


writetty: PROC
;-80     ah=0x0E;

 mov  ah, 14
;-81     push bx;

push bx;
;-82     bx=0;			//page in BH

 mov  bx, 0
;-83     inth 0x10;		//16

 int  16
;-84     pop bx;

pop bx;
;-85 }

;-86 int putch(char c)  {

 ret
ENDP

putch: PROC
;-87     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;56 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-88         al=13;

 mov  al, 13
;-89         writetty();

 call writetty
;-90     }

;-91     al=c;

.putch1:
 mov  al, [bp+4]
;-92     writetty();

 call writetty
;-93 }

;-94 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-95     char c;

;-96     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;56 ptr sign byte s = bp+4
;57 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-97         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-98         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-99         s++;

 inc  word[bp+4]
;-100     }

;-101 }

 jmp .cputs2
.cputs3:
;-102 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-103 	char c;

;-104 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;56 ptr sign byte s = bp+4
;57 var sign word len = bp+6
;58 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-105 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-106 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-107 		s++;

 inc  word[bp+4]
;-108 		len--;

 dec  word[bp+6]
;-109 	} while (len > 0);	

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-110 }

;-111 

;-112 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-113     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-114     inth 0x16;//AH=Scan code, AL=char

 int  22
;-115 }

;-116 int waitkey() {

 ret
ENDP

waitkey: PROC
;-117     ah=0x11;//get kbd status

 mov  ah, 17
;-118     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-119     //zero flag: 0=IS char, 1=NO char

;-120     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-121 }

;-122 int getkey() {

 ret
ENDP

getkey: PROC
;-123     waitkey();

 call waitkey
;-124     getch();

 call getch
;-125     ah=0;//clear scan code

 mov  ah, 0
;-126     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-127     //put ext code in AX

;-128 }

.getkey6:
;-129 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-130     getkey();

 call getkey
;-131     writetty();//destroys AH

 call writetty
;-132 }

;-133 

;-134 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-135     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;56 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-136     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-137     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-138 }

;-139 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-140     unsigned char nib;

;-141     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;56 var unsg byte c = bp+4
;57 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-142     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-143 }

;-144 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-145     unsigned int half;

;-146     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;56 var unsg word i = bp+4
;57 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-147     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-148 }

;-149 

;-150 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-151     unsigned int e;

;-152     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;56 var unsg word n = bp+4
;57 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-153         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-154         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-155         }

;-156     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-157     n+='0';

 add  word[bp+4], 48
;-158     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-159 }

;-160 

;-161 int memcpy(char *s, char *t, int i) {

 LEAVE
 ret
ENDP

memcpy: PROC
;-162 	unsigned int r;

;-163 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;56 ptr sign byte s = bp+4
;57 ptr sign byte t = bp+6
;58 var sign word i = bp+8
;59 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-164 	do {

.memcpy9:
;-165 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-166 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-167 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy10
 jmp .memcpy9
.memcpy10:
;-168 	ax=r;//	return r;

 mov  ax, [bp-2]
;-169 }

;-170 

;-171 int printlong1(unsigned int lo, unsigned int hi) {

 LEAVE
 ret
ENDP

printlong1: PROC
;-172 // DX:AX DIV BX = AX remainder dx

;-173 	dx=hi;

;Function : printlong1, Number local Var: 2
; # type sign width local variables
;56 var unsg word lo = bp+4
;57 var unsg word hi = bp+6;
 ENTER  0,0
 mov  dx, [bp+6]
;-174 	ax=lo;

 mov  ax, [bp+4]
;-175 __asm{	

	
;-176   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-177     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-178 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-179     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-180     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-181     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-182     db		145;=91h xchg ax,cx;Temporarily move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx;Temporarily move it to CX restoring LowDividend
;-183     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-184     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-185     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-186     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-187     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-188     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-189 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-190 }	writetty();		__asm{


 call writetty

;-191     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-192     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-193     jb      .b             ;Not yet	

    jb      .b             ;Not yet	
;-194 } }


;-195 int printL(char *p) {

 LEAVE
 ret
ENDP

printL: PROC
;-196 	unsigned int lo; unsigned int hi;

;-197 	lo = *p;

;Function : printL, Number local Var: 3
; # type sign width local variables
;56 ptr sign byte p = bp+4
;57 var unsg word lo = bp-2
;58 var unsg word hi = bp-4;
 ENTER  4,0
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], ax
;-198 	p +=2;

 add  word[bp+4], 2
;-199 	hi = *p;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-4], ax
;-200 	printlong1(lo, hi);

 push word [bp-4]
 push word [bp-2]
 call printlong1
 add  sp, 4
;-201 	}

;-202 	

;-203 //--------------------------------  disk IO  -------------------

;-204 

;-205 int Int13hRW(char rw, char drive, char head, int cyl, char sector,

 LEAVE
 ret
ENDP

Int13hRW: PROC
;-206 	char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-207 	BIOS_ERR=0;	

;Function : Int13hRW, Number local Var: 8
; # type sign width local variables
;56 var sign byte rw = bp+4
;57 var sign byte drive = bp+6
;58 var sign byte head = bp+8
;59 var sign word cyl = bp+10
;60 var sign byte sector = bp+12
;61 var sign byte count = bp+14
;62 var sign word BufSeg = bp+16
;63 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-208 	dl=drive;

 mov  dl, [bp+6]
;-209 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-210 	es=BufSeg;

 mov  es, [bp+16]
;-211 	bx=BufOfs;

 mov  bx, [bp+18]
;-212 	cx=cyl;	

 mov  cx, [bp+10]
;-213 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-214 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-215 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-216 	cl += sector;

 add  cl, [bp+12]
;-217 	ch=cyl;//low byte of cyl in ch, word 2 byte	

 mov  ch, [bp+10]
;-218 	al=count;

 mov  al, [bp+14]
;-219 	ah=rw;

 mov  ah, [bp+4]
;-220 	inth 0x13;

 int  19
;-221     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-222 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-223 }

;-224 int Int13hRaw(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hRaw: PROC
;-225 	BIOS_ERR=0;	

;Function : Int13hRaw, Number local Var: 2
; # type sign width local variables
;56 var sign byte drive = bp+4
;57 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-226 	dl=drive;

 mov  dl, [bp+4]
;-227 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-228 	inth 0x13;

 int  19
;-229     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-230 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-231 }

;-232 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-233 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-234 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-235 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-236 	BIOS_Status=Int13hRaw(Drive, 0);//Reset

 push 0
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-237 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-238 }	

;-239 

;-240 int Params(char drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Params: PROC
;-241 	cputs("(AH=08)Drive Params:");

;Function : Params, Number local Var: 1
; # type sign width local variables
;56 var sign byte drive = bp+4;
 ENTER  0,0
 push Params_0
 call cputs
 add  sp, 2
;-242 	BIOS_Status=Int13hRaw(drive, 8);

 push 8
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-243 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Params11
 call Int13hError
;-244 	else {

 jmp .Params12
.Params11:
;-245 		asm mov [Heads],        dh

 mov [Heads],        dh
;-246 //		Heads++;

;-247 		asm mov [Attached],     dl

 mov [Attached],     dl
;-248 		// CX =       ---CH--- ---CL---

;-249 		// cylinder : 76543210 98

;-250 		// sector   :            543210	

;-251 		asm mov [Sectors],      cl

 mov [Sectors],      cl
;-252 		Sectors &= 0x3F;// 63

 and  byte[Sectors], 63
;-253 //		Sectors++;//1 to 64

;-254 	

;-255 		asm mov [Cylinders],    cx	

 mov [Cylinders],    cx	
;-256 		Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[Cylinders], 192
;-257 		Cylinders = Cylinders << 2;//compiler flaw:

 mov ax, [Cylinders]
 shl ax, 2
 mov word [Cylinders], ax
;-258 		asm add [Cylinders],    ch;//byte add, low byte is empty	

 add [Cylinders],    ch;//byte add, low byte is empty	
;-259 	

;-260 		cputs("CylHeadSec=");		printunsign(Cylinders);

 push Params_1
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
;-261 		putch('/');					printunsign(Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-262 		putch('/');					printunsign(Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-263 		cputs(", NoDrives=");		printhex8(Attached);

 push Params_2
 call cputs
 add  sp, 2
 mov al, byte [Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-264 		putch('.');

 push 46
 call putch
 add  sp, 2
;-265 	}

;-266 }

.Params12:
;-267 

;-268 int Status(drive) {

 LEAVE
 ret
Params_0 db "(AH=08)Drive Params:",0
Params_1 db "CylHeadSec=",0
Params_2 db ", NoDrives=",0
ENDP

Status: PROC
;-269 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;56 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-270 	cputs("(1)Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-271 	BIOS_Status=Int13hRaw(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-272 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status13
 call Int13hError
;-273 	printhex16(BIOS_Status);	

.Status13:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-274 }	

;-275 

;-276 int getPartitionData() {

 LEAVE
 ret
Status_0 db "(1)Status last Op=",0
ENDP

getPartitionData: PROC
;-277 	unsigned int j; char c; char *p;

;-278 	j = PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;56 var unsg word j = bp-2
;57 var sign byte c = bp-4
;58 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [PartNo]
 shl ax, 4
 mov [bp-2], ax
;-279 	j = j + 0x1be;			ptBootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptBootable], al
;-280 	j++;					ptStartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartHead], al
;-281 	j++;					ptStartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartSector], al
;-282 	ah=0;//next line convert byte to word

 mov  ah, 0
;-283 	ptStartCylinder=ptStartSector;	

 mov al, [ptStartSector]
 mov word [ptStartCylinder], ax
;-284 	ptStartSector &= 0x3F;

 and  byte[ptStartSector], 63
;-285 //	ptStartSector++;//Sector start with 1 todo

;-286 	ptStartCylinder &= 0xC0;

 and  word[ptStartCylinder], 192
;-287 	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	

 mov ax, [ptStartCylinder]
 shl ax, 2
 mov word [ptStartCylinder], ax
;-288 	j++;

 inc  word[bp-2]
;-289 	ah=0;//byte to word

 mov  ah, 0
;-290 	ptStartCylinder=DiskBuf[j] + ptStartCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptStartCylinder]
 mov word [ptStartCylinder], ax
;-291 	j++;					ptFileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptFileSystem], al
;-292 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=huge<2GB MS-DOS4.0	

;-293 	j++;					ptEndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndHead], al
;-294 	j++;					ptEndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndSector], al
;-295 	ah=0;//next line convert byte to word

 mov  ah, 0
;-296 	ptEndCylinder=ptEndSector;//see next 5 line		

 mov al, [ptEndSector]
 mov word [ptEndCylinder], ax
;-297 	ptEndSector &= 0x3F;

 and  byte[ptEndSector], 63
;-298 //	ptEndSector++;//Sector start with 1 todo

;-299 	ptEndCylinder &= 0xC0;

 and  word[ptEndCylinder], 192
;-300 	ptEndCylinder = ptEndCylinder << 2;//OK no short cut!	

 mov ax, [ptEndCylinder]
 shl ax, 2
 mov word [ptEndCylinder], ax
;-301 	j++;

 inc  word[bp-2]
;-302 	ah=0;//byte to word

 mov  ah, 0
;-303 	ptEndCylinder=DiskBuf[j] + ptEndCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptEndCylinder]
 mov word [ptEndCylinder], ax
;-304 	j++;

 inc  word[bp-2]
;-305 	p = j + &DiskBuf;//copy ptStartSector, ptPartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-306 	memcpy(&ptStartSectorlo, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [ptStartSectorlo]
 push ax
 call memcpy
 add  sp, 6
;-307 	

;-308 	j += 8;//next partition entry

 add  word[bp-2], 8
;-309 }

;-310 	

;-311 int printPartitionData() {

 LEAVE
 ret
ENDP

printPartitionData: PROC
;-312 	unsigned int i; unsigned int j;

;-313 	putch(10);		

;Function : printPartitionData, Number local Var: 2
; # type sign width local variables
;56 var unsg word i = bp-2
;57 var unsg word j = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-314 	cputs("No=");			printunsign(PartNo);

 push printPartitionData_0
 call cputs
 add  sp, 2
 push word [PartNo]
 call printunsign
 add  sp, 2
;-315 	cputs(",Boot=");		printhex8(ptBootable);

 push printPartitionData_1
 call cputs
 add  sp, 2
 mov al, byte [ptBootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-316 	cputs(" ID=");			printunsign(ptFileSystem);

 push printPartitionData_2
 call cputs
 add  sp, 2
 mov al, byte [ptFileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-317 	cputs(",HdSeCy=");		printunsign(ptStartHead);

 push printPartitionData_3
 call cputs
 add  sp, 2
 mov al, byte [ptStartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-318 	cputs("/");				printunsign(ptStartSector);	

 push printPartitionData_4
 call cputs
 add  sp, 2
 mov al, byte [ptStartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-319 	cputs("/");				printunsign(ptStartCylinder);

 push printPartitionData_5
 call cputs
 add  sp, 2
 push word [ptStartCylinder]
 call printunsign
 add  sp, 2
;-320 	cputs("-");				printunsign(ptEndHead);

 push printPartitionData_6
 call cputs
 add  sp, 2
 mov al, byte [ptEndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-321 	cputs("/");				printunsign(ptEndSector);	

 push printPartitionData_7
 call cputs
 add  sp, 2
 mov al, byte [ptEndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-322 	cputs("/");				printunsign(ptEndCylinder);

 push printPartitionData_8
 call cputs
 add  sp, 2
 push word [ptEndCylinder]
 call printunsign
 add  sp, 2
;-323 	cputs(",Start=");		printlong1(ptStartSectorlo, ptStartSectorhi);

 push printPartitionData_9
 call cputs
 add  sp, 2
 push word [ptStartSectorhi]
 push word [ptStartSectorlo]
 call printlong1
 add  sp, 4
;-324 	cputs(",Len=");			printlong1(ptPartLenlo, ptPartLenhi);

 push printPartitionData_10
 call cputs
 add  sp, 2
 push word [ptPartLenhi]
 push word [ptPartLenlo]
 call printlong1
 add  sp, 4
;-325 	cputs(" Sec=");

 push printPartitionData_11
 call cputs
 add  sp, 2
;-326 	i = ptPartLenhi <<  5;//64KB Sec to MB; >>4 + <<9 = <<5

 mov ax, [ptPartLenhi]
 shl ax, 5
 mov [bp-2], ax
;-327 	j = ptPartLenlo >> 11;//Sec to MB

 mov ax, [ptPartLenlo]
 shr ax, 11
 mov [bp-4], ax
;-328 	i = i + j;				printunsign(i);

 mov ax, [bp-2]
 add ax, [bp-4]
 mov [bp-2], ax
 push word [bp-2]
 call printunsign
 add  sp, 2
;-329 	cputs(" MByte.");

 push printPartitionData_12
 call cputs
 add  sp, 2
;-330 }

;-331 int checkMagicNumber() {

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

checkMagicNumber: PROC
;-332 	char c; char d; int i; char ok;

;-333 	cputs(",magic number=");	

;Function : checkMagicNumber, Number local Var: 4
; # type sign width local variables
;56 var sign byte c = bp-2
;57 var sign byte d = bp-4
;58 var sign word i = bp-6
;59 var sign byte ok = bp-8;
 ENTER  8,0
 push checkMagicNumber_0
 call cputs
 add  sp, 2
;-334 	i=510;		c = DiskBuf[i];		printhex8(c);

 mov ax, 510
 mov [bp-6], ax
 mov bx, [bp-6]
 mov al, [DiskBuf + bx]
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-335 	i++;		d = DiskBuf[i];		printhex8(d);

 inc  word[bp-6]
 mov bx, [bp-6]
 mov al, [DiskBuf + bx]
 mov [bp-4], al
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-336 	ok=0;

 mov ax, 0
 mov [bp-8], al
;-337 	if (c == 0x55) ok=1;

 mov al, [bp-2]
 cmp al, 85
 jne .checkMagicNumber14
 mov ax, 1
 mov [bp-8], al
;-338 	if (d == 0xAA) ok=1;

.checkMagicNumber14:
 mov al, [bp-4]
 cmp al, 170
 jne .checkMagicNumber15
 mov ax, 1
 mov [bp-8], al
;-339 	if (ok) {

.checkMagicNumber15:
 mov al, [bp-8]
 or  al, al
 je .checkMagicNumber16
;-340 		cputs(" found");

 push checkMagicNumber_1
 call cputs
 add  sp, 2
;-341 		return 1;

 mov ax, 1
 jmp .retncheckMagicNumber
;-342 		}

;-343 	else {

 jmp .checkMagicNumber17
.checkMagicNumber16:
;-344 		cputs(" NOT found");

 push checkMagicNumber_2
 call cputs
 add  sp, 2
;-345 		return 0;	

 mov ax, 0
 jmp .retncheckMagicNumber
;-346 	}

;-347 }	

.checkMagicNumber17:
;-348 	

;-349 int testDisk(drive) {

 .retncheckMagicNumber:
 LEAVE
 ret
checkMagicNumber_0 db ",magic number=",0
checkMagicNumber_1 db " found",0
checkMagicNumber_2 db " NOT found",0
ENDP

testDisk: PROC
;-350 	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf

;Function : testDisk, Number local Var: 1
; # type sign width local variables
;56 var sign word drive = bp+4;
 ENTER  0,0
 mov [DiskBufSeg], ds; //Offset is in DiskBuf
;-351 	BIOS_Status=Int13hRW(2,drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-352 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .testDisk18
 call Int13hError
;-353 	else {	

 jmp .testDisk19
.testDisk18:
;-354 		putch(10);

 push 10
 call putch
 add  sp, 2
;-355 		cputs("Read partition status:");

 push testDisk_0
 call cputs
 add  sp, 2
;-356 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-357 		cputs(",DiskBuf=");

 push testDisk_1
 call cputs
 add  sp, 2
;-358 		printhex16(DiskBufSeg);

 push word [DiskBufSeg]
 call printhex16
 add  sp, 2
;-359 		putch(':');							

 push 58
 call putch
 add  sp, 2
;-360 		printhex16(DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 call printhex16
 add  sp, 2
;-361 		putch('.');

 push 46
 call putch
 add  sp, 2
;-362 		checkMagicNumber();	

 call checkMagicNumber
;-363 		PartNo=0;

 mov ax, 0
 mov word [PartNo], ax
;-364 		do {

.testDisk20:
;-365 			getPartitionData();

 call getPartitionData
;-366 			printPartitionData();

 call printPartitionData
;-367 			if (ptBootable == 0x80) {

 mov al, [ptBootable]
 cmp al, 128
 jne .testDisk21
;-368 				cputs(" boot partition found");

 push testDisk_2
 call cputs
 add  sp, 2
;-369 				if (ptFileSystem == 6) cputs(", large FAT16 part. < 2GB");

 mov al, [ptFileSystem]
 cmp al, 6
 jne .testDisk22
 push testDisk_3
 call cputs
 add  sp, 2
;-370 				if (ptFileSystem == 4) cputs(", small FAT16 part. < 32MB");

.testDisk22:
 mov al, [ptFileSystem]
 cmp al, 4
 jne .testDisk23
 push testDisk_4
 call cputs
 add  sp, 2
;-371 				PartNo=99;//end of loop	

.testDisk23:
 mov ax, 99
 mov word [PartNo], ax
;-372 			}

;-373 			PartNo ++;

.testDisk21:
 inc  word[PartNo]
;-374 		} while (PartNo <4);

 mov ax, [PartNo]
 cmp ax, 4
 jge .testDisk24
 jmp .testDisk20
.testDisk24:
;-375 	}	

;-376 }

.testDisk19:
;-377 

;-378 int getBootSector() {

 LEAVE
 ret
testDisk_0 db "Read partition status:",0
testDisk_1 db ",DiskBuf=",0
testDisk_2 db " boot partition found",0
testDisk_3 db ", large FAT16 part. < 2GB",0
testDisk_4 db ", small FAT16 part. < 32MB",0
ENDP

getBootSector: PROC
;-379 	Cylinders=ptStartCylinder;

 mov ax, [ptStartCylinder]
 mov word [Cylinders], ax
;-380 	Heads=ptStartHead;

 mov al, [ptStartHead]
 mov byte [Heads], al
;-381 	Sectors=ptStartSector ; // +1

 mov al, [ptStartSector]
 mov byte [Sectors], al
;-382 	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf

 mov [DiskBufSeg], ds; //Offset is in DiskBuf
;-383   BIOS_Status=Int13hRW(2,Drive,Heads,Cylinders,Sectors,1,DiskBufSeg,DiskBuf);

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
;-384 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector25
 call Int13hError
;-385 	else {	

 jmp .getBootSector26
.getBootSector25:
;-386 		putch(10);

 push 10
 call putch
 add  sp, 2
;-387 		cputs("Read boot sector status:");

 push getBootSector_0
 call cputs
 add  sp, 2
;-388 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-389 		checkMagicNumber();	

 call checkMagicNumber
;-390 		memcpy(&bs_jmp, &DiskBuf, 62);

 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-391 		putch(10);

 push 10
 call putch
 add  sp, 2
;-392 		cputs("OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push getBootSector_1
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-393 		putch(10);

 push 10
 call putch
 add  sp, 2
;-394 		cputs("Bytes per sector(512)=");printunsign(bs_sect_size);	

 push getBootSector_2
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-395 		cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);	

 push getBootSector_3
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-396 		putch(10);

 push 10
 call putch
 add  sp, 2
;-397 		cputs("Reserved sectors=");printunsign(bs_res_sects);	

 push getBootSector_4
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-398 		cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);	

 push getBootSector_5
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-399 		putch(10);

 push 10
 call putch
 add  sp, 2
;-400 		cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push getBootSector_6
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-401 		cputs(".Total sectors(0 if > 32MB=");printunsign(bs_total_sect);

 push getBootSector_7
 call cputs
 add  sp, 2
 push word [bs_total_sect]
 call printunsign
 add  sp, 2
;-402 		putch(10);

 push 10
 call putch
 add  sp, 2
;-403 		cputs("Media descriptor(F8h for HD)=");printhex8(bs_media_desc);

 push getBootSector_8
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-404 		cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push getBootSector_9
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-405 		putch(10);

 push 10
 call putch
 add  sp, 2
;-406 		cputs("sectors per track=");printunsign(bs_num_sects);

 push getBootSector_10
 call cputs
 add  sp, 2
 push word [bs_num_sects]
 call printunsign
 add  sp, 2
;-407 		cputs(".number of heads=");printunsign(bs_num_sides);

 push getBootSector_11
 call cputs
 add  sp, 2
 push word [bs_num_sides]
 call printunsign
 add  sp, 2
;-408 		putch(10);

 push 10
 call putch
 add  sp, 2
;-409 		cputs("hidden sectors(long)=");printL(&bs_hid_sects);

 push getBootSector_12
 call cputs
 add  sp, 2
 lea  ax, [bs_hid_sects]
 push ax
 call printL
 add  sp, 2
;-410 		cputs(".sectors(long)=");printL(&bs_big_total);

 push getBootSector_13
 call cputs
 add  sp, 2
 lea  ax, [bs_big_total]
 push ax
 call printL
 add  sp, 2
;-411 		putch(10);

 push 10
 call putch
 add  sp, 2
;-412 		cputs("physical drive number=");printunsign(bs_drive_num);

 push getBootSector_14
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-413 		cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push getBootSector_15
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-414 		putch(10);

 push 10
 call putch
 add  sp, 2
;-415 		cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push getBootSector_16
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-416 		cputs(".Volume serial(long)=");printL(&bs_serial_num);

 push getBootSector_17
 call cputs
 add  sp, 2
 lea  ax, [bs_serial_num]
 push ax
 call printL
 add  sp, 2
;-417 		putch(10);

 push 10
 call putch
 add  sp, 2
;-418 		cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push getBootSector_18
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-419 		cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);		

 push getBootSector_19
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-420 	}

;-421 }

.getBootSector26:
;-422 /*	

;-423 int Int13hExt(char drive) {

;-424 	putch(10);

;-425 	cputs("Int13h 41hExt AX(3000=ERROR)=");

;-426 	bx=0x55AA;

;-427 	BIOS_Status=Int13hRaw(0x80, 0x41);	

;-428 	printhex16(BIOS_Status);

;-429 	if (BIOS_ERR) {

;-430 		cputs(" not present");	

;-431 		Int13hError();	

;-432 		}

;-433 	else {

;-434 		cputs(" status=1:supported");

;-435 		asm mov [vBX], bx;0xAA55 Extension installed

;-436 		asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

;-437 		cputs(" BX(AA55)=");				printhex16(vBX);

;-438 		cputs(" CX(Interface bitmask)=");	printhex16(vCX);

;-439 		}		

;-440 }	

;-441 */

;-442 int mdump(unsigned char *adr, unsigned int len ) {

 ret
getBootSector_0 db "Read boot sector status:",0
getBootSector_1 db "OEM name (MSDOS5.0)=",0
getBootSector_2 db "Bytes per sector(512)=",0
getBootSector_3 db ".Sectors per cluster(1,,128)=",0
getBootSector_4 db "Reserved sectors=",0
getBootSector_5 db ".Number of FAT(1,2)=",0
getBootSector_6 db "Root directory entries(512)=",0
getBootSector_7 db ".Total sectors(0 if > 32MB=",0
getBootSector_8 db "Media descriptor(F8h for HD)=",0
getBootSector_9 db ".Sectors per FAT=",0
getBootSector_10 db "sectors per track=",0
getBootSector_11 db ".number of heads=",0
getBootSector_12 db "hidden sectors(long)=",0
getBootSector_13 db ".sectors(long)=",0
getBootSector_14 db "physical drive number=",0
getBootSector_15 db ".Windows NT check disk=",0
getBootSector_16 db "Extended signature(29h)=",0
getBootSector_17 db ".Volume serial(long)=",0
getBootSector_18 db "Volume label(NO NAME)=",0
getBootSector_19 db ".File system type(FAT16)=",0
ENDP

mdump: PROC
;-443     unsigned char c;

;-444     int i;

;-445     int j;

;-446     int k;

;-447     j=0;

;Function : mdump, Number local Var: 6
; # type sign width local variables
;56 ptr unsg byte adr = bp+4
;57 var unsg word len = bp+6
;58 var unsg byte c = bp-2
;59 var sign word i = bp-4
;60 var sign word j = bp-6
;61 var sign word k = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-6], ax
;-448     k=0;

 mov ax, 0
 mov [bp-8], ax
;-449     while (j < len ) {

.mdump27:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump28
;-450 	    k++;; 

 inc  word[bp-8]
;-451 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump29
;-452 		    getkey();

 call getkey
;-453 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-454 		    }

;-455         putch(10);

.mdump29:
 push 10
 call putch
 add  sp, 2
;-456         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-457         putch(':');

 push 58
 call putch
 add  sp, 2
;-458         i=0;

 mov ax, 0
 mov [bp-4], ax
;-459         while (i < 16) {

.mdump30:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump31
;-460             putch(' ');

 push 32
 call putch
 add  sp, 2
;-461             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-462             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-463             adr++;

 inc  word[bp+4]
;-464             i++;

 inc  word[bp-4]
;-465             j++;

 inc  word[bp-6]
;-466             }

;-467         putch(' ');

 jmp .mdump30
.mdump31:
 push 32
 call putch
 add  sp, 2
;-468         adr -=16;

 sub  word[bp+4], 16
;-469         i=0;

 mov ax, 0
 mov [bp-4], ax
;-470         while(i < 16) {

.mdump32:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump33
;-471             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-472             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump34
 push 46
 call putch
 add  sp, 2
;-473                 else putch(c);

 jmp .mdump35
.mdump34:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-474             adr++;

.mdump35:
 inc  word[bp+4]
;-475             i++;

 inc  word[bp-4]
;-476         }

;-477     }

 jmp .mdump32
.mdump33:
;-478 }

 jmp .mdump27
.mdump28:
;-479 

;-480 //------------------------------------ main ---------------

;-481 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-482 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-483 	

;-484 	Params(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Params
 add  sp, 2
;-485 	testDisk(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call testDisk
 add  sp, 2
;-486 //	Int13hExt(Drive);

;-487 	getBootSector();

 call getBootSector
;-488 	mdump(DiskBuf, 512);

 push 512
 lea  ax, [DiskBuf]
 push ax
 call mdump
 add  sp, 4
;-489 }

 ret
ENDP
;Glob. variables:55 (400):556 (4000), Functions:27 (300):259 (3000)
;Lines:490, Constant: 951 (3000), stacksize: 56831