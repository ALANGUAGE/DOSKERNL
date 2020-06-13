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
;-50 unsigned long ptHiddenSector;	//sectors preceding partition

ptHiddenSector dd 0
;-51 unsigned int  ptPartLenlo;    	//length of partition in sectors

ptPartLenlo dw 0
;-52 unsigned int  ptPartLenhi;

ptPartLenhi dw 0
;-53 //end hard disk partition structure

;-54 

;-55 //start boot BIOS Parameter Block

;-56 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-57 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-58 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-59 unsigned char bs_clust_size;// 13 sectors per cluster (1,2,4,..,128)

bs_clust_size db 0
;-60 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-61 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-62 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-63 unsigned int  bs_total_sect;// 19 number of total sectors (0 if > 32Mb)

bs_total_sect dw 0
;-64 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-65 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-66 unsigned int  bs_num_sects;	// 24 (DOS 3+)sectors per track 

bs_num_sects dw 0
;-67 unsigned int  bs_num_sides;	// 26 (DOS 3+)number of heads   

bs_num_sides dw 0
;-68 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors 

bs_hid_sects dd 0
;-69 unsigned long bs_big_total;	// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_big_total dd 0
;-70 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-71 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-72 unsigned char bs_ext_signat;// 38 (DOS 4+) Extended signature,get next 3(29h)

bs_ext_signat db 0
;-73 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-74 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-75 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-76 // 62 end boot BIOS Parameter Block

;-77 

;-78 int writetty()     {//char in AL


writetty: PROC
;-79     ah=0x0E;

 mov  ah, 14
;-80     push bx;

push bx;
;-81     bx=0;			//page in BH

 mov  bx, 0
;-82     inth 0x10;		//16

 int  16
;-83     pop bx;

pop bx;
;-84 }

;-85 int putch(char c)  {

 ret
ENDP

putch: PROC
;-86     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;55 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-87         al=13;

 mov  al, 13
;-88         writetty();

 call writetty
;-89     }

;-90     al=c;

.putch1:
 mov  al, [bp+4]
;-91     writetty();

 call writetty
;-92 }

;-93 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-94     char c;

;-95     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;55 ptr sign byte s = bp+4
;56 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-96         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-97         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-98         s++;

 inc  word[bp+4]
;-99     }

;-100 }

 jmp .cputs2
.cputs3:
;-101 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-102 	char c;

;-103 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;55 ptr sign byte s = bp+4
;56 var sign word len = bp+6
;57 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-104 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-105 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-106 		s++;

 inc  word[bp+4]
;-107 		len--;

 dec  word[bp+6]
;-108 	} while (len > 0);	

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-109 }

;-110 

;-111 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-112     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-113     inth 0x16;//AH=Scan code, AL=char

 int  22
;-114 }

;-115 int waitkey() {

 ret
ENDP

waitkey: PROC
;-116     ah=0x11;//get kbd status

 mov  ah, 17
;-117     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-118     //zero flag: 0=IS char, 1=NO char

;-119     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-120 }

;-121 int getkey() {

 ret
ENDP

getkey: PROC
;-122     waitkey();

 call waitkey
;-123     getch();

 call getch
;-124     ah=0;//clear scan code

 mov  ah, 0
;-125     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-126     //put ext code in AX

;-127 }

.getkey6:
;-128 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-129     getkey();

 call getkey
;-130     writetty();//destroys AH

 call writetty
;-131 }

;-132 

;-133 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-134     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;55 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-135     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-136     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-137 }

;-138 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-139     unsigned char nib;

;-140     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;55 var unsg byte c = bp+4
;56 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-141     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-142 }

;-143 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-144     unsigned int half;

;-145     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;55 var unsg word i = bp+4
;56 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-146     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-147 }

;-148 

;-149 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-150     unsigned int e;

;-151     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;55 var unsg word n = bp+4
;56 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-152         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-153         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-154         }

;-155     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-156     n+='0';

 add  word[bp+4], 48
;-157     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-158 }

;-159 

;-160 int printlong(unsigned int *p) {

 LEAVE
 ret
ENDP

printlong: PROC
;-161 	unsigned int lo; unsigned int hi;

;-162 	lo = *p;

;Function : printlong, Number local Var: 3
; # type sign width local variables
;55 ptr unsg word p = bp+4
;56 var unsg word lo = bp-2
;57 var unsg word hi = bp-4;
 ENTER  4,0
 mov bx, [bp+4]
 mov ax, [bx]
 mov [bp-2], ax
;-163 	p +=2;

 add  word[bp+4], 2
;-164 	hi = *p;

 mov bx, [bp+4]
 mov ax, [bx]
 mov [bp-4], ax
;-165 	dx=hi;

 mov  dx, [bp-4]
;-166 	ax=lo;

 mov  ax, [bp-2]
;-167 __asm{	

	
;-168   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-169     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-170 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-171     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-172     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-173     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-174     db		145;=91h xchg ax,cx;Temporarily move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx;Temporarily move it to CX restoring LowDividend
;-175 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-176     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-177     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-178     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-179     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-180     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-181     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-182 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-183 }	writetty();		__asm{


 call writetty

;-184     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-185     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-186     jb      .b             ;Not yet	

    jb      .b             ;Not yet	
;-187 } 


;-188 }

;-189 

;-190 int memcpy(char *s, char *t, unsigned int i) {

 LEAVE
 ret
ENDP

memcpy: PROC
;-191 	unsigned int r;

;-192 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;55 ptr sign byte s = bp+4
;56 ptr sign byte t = bp+6
;57 var unsg word i = bp+8
;58 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-193 	do {

.memcpy9:
;-194 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-195 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-196 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy10
 jmp .memcpy9
.memcpy10:
;-197 	ax=r;//	return r;

 mov  ax, [bp-2]
;-198 }

;-199 

;-200 //--------------------------------  disk IO  -------------------

;-201 

;-202 int Int13hRW(char rw, char drive, char head, int cyl, char sector,

 LEAVE
 ret
ENDP

Int13hRW: PROC
;-203 	char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-204 	BIOS_ERR=0;	

;Function : Int13hRW, Number local Var: 8
; # type sign width local variables
;55 var sign byte rw = bp+4
;56 var sign byte drive = bp+6
;57 var sign byte head = bp+8
;58 var sign word cyl = bp+10
;59 var sign byte sector = bp+12
;60 var sign byte count = bp+14
;61 var sign word BufSeg = bp+16
;62 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-205 	dl=drive;

 mov  dl, [bp+6]
;-206 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-207 	es=BufSeg;

 mov  es, [bp+16]
;-208 	bx=BufOfs;

 mov  bx, [bp+18]
;-209 	cx=cyl;	

 mov  cx, [bp+10]
;-210 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-211 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-212 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-213 	cl += sector;

 add  cl, [bp+12]
;-214 	ch=cyl;//low byte of cyl in ch, word 2 byte	

 mov  ch, [bp+10]
;-215 	al=count;

 mov  al, [bp+14]
;-216 	ah=rw;

 mov  ah, [bp+4]
;-217 	inth 0x13;

 int  19
;-218     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-219 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-220 }

;-221 int Int13hRaw(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hRaw: PROC
;-222 	BIOS_ERR=0;	

;Function : Int13hRaw, Number local Var: 2
; # type sign width local variables
;55 var sign byte drive = bp+4
;56 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-223 	dl=drive;

 mov  dl, [bp+4]
;-224 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-225 	inth 0x13;

 int  19
;-226     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-227 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-228 }

;-229 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-230 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-231 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-232 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-233 	BIOS_Status=Int13hRaw(Drive, 0);//Reset

 push 0
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-234 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-235 }	

;-236 

;-237 int Params(char drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Params: PROC
;-238 	cputs("(AH=08)Drive Params:");

;Function : Params, Number local Var: 1
; # type sign width local variables
;55 var sign byte drive = bp+4;
 ENTER  0,0
 push Params_0
 call cputs
 add  sp, 2
;-239 	BIOS_Status=Int13hRaw(drive, 8);

 push 8
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-240 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params11
;-241 		Int13hError();

 call Int13hError
;-242 		return 1;

 mov ax, 1
 jmp .retnParams
;-243 		}

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

;-260 		if (Attached == 0) {

 mov al, [Attached]
 cmp al, 0
 jne .Params13
;-261 			cputs(" no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-262 			return 1;

 mov ax, 1
 jmp .retnParams
;-263 			}

;-264 		cputs("CylHeadSec=");		printunsign(Cylinders);

.Params13:
 push Params_2
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
;-265 		putch('/');					printunsign(Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-266 		putch('/');					printunsign(Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-267 		cputs(", NoDrives=");		printhex8(Attached);

 push Params_3
 call cputs
 add  sp, 2
 mov al, byte [Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-268 		putch('.');

 push 46
 call putch
 add  sp, 2
;-269 	}

;-270 	return 0;

.Params12:
 mov ax, 0
 jmp .retnParams
;-271 }

;-272 

;-273 int Status(drive) {

 .retnParams:
 LEAVE
 ret
Params_0 db "(AH=08)Drive Params:",0
Params_1 db " no hard disk found",0
Params_2 db "CylHeadSec=",0
Params_3 db ", NoDrives=",0
ENDP

Status: PROC
;-274 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;55 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-275 	cputs("(1)Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-276 	BIOS_Status=Int13hRaw(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-277 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status14
 call Int13hError
;-278 	printhex16(BIOS_Status);	

.Status14:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-279 }	

;-280 

;-281 int getPartitionData() {

 LEAVE
 ret
Status_0 db "(1)Status last Op=",0
ENDP

getPartitionData: PROC
;-282 	unsigned int j; char c; char *p;

;-283 	j = PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;55 var unsg word j = bp-2
;56 var sign byte c = bp-4
;57 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [PartNo]
 shl ax, 4
 mov [bp-2], ax
;-284 	j = j + 0x1be;			ptBootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptBootable], al
;-285 	j++;					ptStartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartHead], al
;-286 	j++;					ptStartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartSector], al
;-287 	ah=0;//next line convert byte to word

 mov  ah, 0
;-288 	ptStartCylinder=ptStartSector;	

 mov al, [ptStartSector]
 mov word [ptStartCylinder], ax
;-289 	ptStartSector &= 0x3F;

 and  byte[ptStartSector], 63
;-290 //	ptStartSector++;//Sector start with 1 todo

;-291 	ptStartCylinder &= 0xC0;

 and  word[ptStartCylinder], 192
;-292 	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	

 mov ax, [ptStartCylinder]
 shl ax, 2
 mov word [ptStartCylinder], ax
;-293 	j++;

 inc  word[bp-2]
;-294 	ah=0;//byte to word

 mov  ah, 0
;-295 	ptStartCylinder=DiskBuf[j] + ptStartCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptStartCylinder]
 mov word [ptStartCylinder], ax
;-296 	j++;					ptFileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptFileSystem], al
;-297 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=huge<2GB MS-DOS4.0	

;-298 	j++;					ptEndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndHead], al
;-299 	j++;					ptEndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndSector], al
;-300 	ah=0;//next line convert byte to word

 mov  ah, 0
;-301 	ptEndCylinder=ptEndSector;//see next 5 line		

 mov al, [ptEndSector]
 mov word [ptEndCylinder], ax
;-302 	ptEndSector &= 0x3F;

 and  byte[ptEndSector], 63
;-303 //	ptEndSector++;//Sector start with 1 todo

;-304 	ptEndCylinder &= 0xC0;

 and  word[ptEndCylinder], 192
;-305 	ptEndCylinder = ptEndCylinder << 2;//OK no short cut!	

 mov ax, [ptEndCylinder]
 shl ax, 2
 mov word [ptEndCylinder], ax
;-306 	j++;

 inc  word[bp-2]
;-307 	ah=0;//byte to word

 mov  ah, 0
;-308 	ptEndCylinder=DiskBuf[j] + ptEndCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptEndCylinder]
 mov word [ptEndCylinder], ax
;-309 	j++;

 inc  word[bp-2]
;-310 	p = j + &DiskBuf;//copy ptHiddenSector, ptPartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-311 	memcpy(&ptHiddenSector, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [ptHiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-312 	

;-313 	j += 8;//next partition entry

 add  word[bp-2], 8
;-314 }

;-315 	

;-316 int printPartitionData() {

 LEAVE
 ret
ENDP

printPartitionData: PROC
;-317 	unsigned int i; unsigned int j;

;-318 	putch(10);		

;Function : printPartitionData, Number local Var: 2
; # type sign width local variables
;55 var unsg word i = bp-2
;56 var unsg word j = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-319 	cputs("No=");			printunsign(PartNo);

 push printPartitionData_0
 call cputs
 add  sp, 2
 push word [PartNo]
 call printunsign
 add  sp, 2
;-320 	cputs(",Boot=");		printhex8(ptBootable);

 push printPartitionData_1
 call cputs
 add  sp, 2
 mov al, byte [ptBootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-321 	cputs(" ID=");			printunsign(ptFileSystem);

 push printPartitionData_2
 call cputs
 add  sp, 2
 mov al, byte [ptFileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-322 	cputs(",HdSeCy=");		printunsign(ptStartHead);

 push printPartitionData_3
 call cputs
 add  sp, 2
 mov al, byte [ptStartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-323 	cputs("/");				printunsign(ptStartSector);	

 push printPartitionData_4
 call cputs
 add  sp, 2
 mov al, byte [ptStartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-324 	cputs("/");				printunsign(ptStartCylinder);

 push printPartitionData_5
 call cputs
 add  sp, 2
 push word [ptStartCylinder]
 call printunsign
 add  sp, 2
;-325 	cputs("-");				printunsign(ptEndHead);

 push printPartitionData_6
 call cputs
 add  sp, 2
 mov al, byte [ptEndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-326 	cputs("/");				printunsign(ptEndSector);	

 push printPartitionData_7
 call cputs
 add  sp, 2
 mov al, byte [ptEndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-327 	cputs("/");				printunsign(ptEndCylinder);

 push printPartitionData_8
 call cputs
 add  sp, 2
 push word [ptEndCylinder]
 call printunsign
 add  sp, 2
;-328 	cputs(",Start=");		printlong(&ptHiddenSector);

 push printPartitionData_9
 call cputs
 add  sp, 2
 lea  ax, [ptHiddenSector]
 push ax
 call printlong
 add  sp, 2
;-329 	cputs(",Len=");			printlong(&ptPartLenlo);

 push printPartitionData_10
 call cputs
 add  sp, 2
 lea  ax, [ptPartLenlo]
 push ax
 call printlong
 add  sp, 2
;-330 	cputs(" Sec=");

 push printPartitionData_11
 call cputs
 add  sp, 2
;-331 	i = ptPartLenhi <<  5;//64KB Sec to MB; >>4 + <<9 = <<5

 mov ax, [ptPartLenhi]
 shl ax, 5
 mov [bp-2], ax
;-332 	j = ptPartLenlo >> 11;//Sec to MB

 mov ax, [ptPartLenlo]
 shr ax, 11
 mov [bp-4], ax
;-333 	i = i + j;				printunsign(i);

 mov ax, [bp-2]
 add ax, [bp-4]
 mov [bp-2], ax
 push word [bp-2]
 call printunsign
 add  sp, 2
;-334 	cputs(" MByte.");

 push printPartitionData_12
 call cputs
 add  sp, 2
;-335 	

;-336 	putch(10);

 push 10
 call putch
 add  sp, 2
;-337 }

;-338 int checkMagicNumber() {

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
;-339 	char c; char d; int i; char ok;

;-340 	cputs(",magic number=");	

;Function : checkMagicNumber, Number local Var: 4
; # type sign width local variables
;55 var sign byte c = bp-2
;56 var sign byte d = bp-4
;57 var sign word i = bp-6
;58 var sign byte ok = bp-8;
 ENTER  8,0
 push checkMagicNumber_0
 call cputs
 add  sp, 2
;-341 	i=510;		c = DiskBuf[i];		printhex8(c);

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
;-342 	i++;		d = DiskBuf[i];		printhex8(d);

 inc  word[bp-6]
 mov bx, [bp-6]
 mov al, [DiskBuf + bx]
 mov [bp-4], al
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-343 	ok=0;

 mov ax, 0
 mov [bp-8], al
;-344 	if (c == 0x55) ok=1;

 mov al, [bp-2]
 cmp al, 85
 jne .checkMagicNumber15
 mov ax, 1
 mov [bp-8], al
;-345 	if (d == 0xAA) ok=1;

.checkMagicNumber15:
 mov al, [bp-4]
 cmp al, 170
 jne .checkMagicNumber16
 mov ax, 1
 mov [bp-8], al
;-346 	if (ok) {

.checkMagicNumber16:
 mov al, [bp-8]
 or  al, al
 je .checkMagicNumber17
;-347 		cputs(" found");

 push checkMagicNumber_1
 call cputs
 add  sp, 2
;-348 		return 1;

 mov ax, 1
 jmp .retncheckMagicNumber
;-349 		}

;-350 	else {

 jmp .checkMagicNumber18
.checkMagicNumber17:
;-351 		cputs(" NOT found");

 push checkMagicNumber_2
 call cputs
 add  sp, 2
;-352 		return 0;	

 mov ax, 0
 jmp .retncheckMagicNumber
;-353 	}

;-354 }	

.checkMagicNumber18:
;-355 	

;-356 int getFATtype(drive) {

 .retncheckMagicNumber:
 LEAVE
 ret
checkMagicNumber_0 db ",magic number=",0
checkMagicNumber_1 db " found",0
checkMagicNumber_2 db " NOT found",0
ENDP

getFATtype: PROC
;-357 	int isFAT;

;-358 	isFAT=0;

;Function : getFATtype, Number local Var: 2
; # type sign width local variables
;55 var sign word drive = bp+4
;56 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-359 	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf

 mov [DiskBufSeg], ds; //Offset is in DiskBuf
;-360 	BIOS_Status=Int13hRW(2,drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-361 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .getFATtype19
;-362 		Int13hError();

 call Int13hError
;-363 		return 0;

 mov ax, 0
 jmp .retngetFATtype
;-364 		}

;-365 	else {	

 jmp .getFATtype20
.getFATtype19:
;-366 		putch(10);

 push 10
 call putch
 add  sp, 2
;-367 		cputs("Read partition status:");

 push getFATtype_0
 call cputs
 add  sp, 2
;-368 /*		printhex16(BIOS_Status);	

;-369 		cputs(",DiskBuf=");

;-370 		printhex16(DiskBufSeg);

;-371 		putch(':');							

;-372 		printhex16(DiskBuf);

;-373 		putch('.');

;-374 */		

;-375 		if(checkMagicNumber()==0) return 0;	

 call checkMagicNumber
 cmp al, 0
 jne .getFATtype21
 mov ax, 0
 jmp .retngetFATtype
;-376 		PartNo=0;

.getFATtype21:
 mov ax, 0
 mov word [PartNo], ax
;-377 		do {

.getFATtype22:
;-378 			getPartitionData();

 call getPartitionData
;-379 			printPartitionData();

 call printPartitionData
;-380 			if (ptBootable == 0x80) {

 mov al, [ptBootable]
 cmp al, 128
 jne .getFATtype23
;-381 				cputs(" boot partition found");

 push getFATtype_1
 call cputs
 add  sp, 2
;-382 				if (ptFileSystem == 1) {

 mov al, [ptFileSystem]
 cmp al, 1
 jne .getFATtype24
;-383 					cputs(", FAT12 partition < 32MB");

 push getFATtype_2
 call cputs
 add  sp, 2
;-384 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-385 					}

;-386 				if (ptFileSystem == 4) {

.getFATtype24:
 mov al, [ptFileSystem]
 cmp al, 4
 jne .getFATtype25
;-387 					cputs(", small FAT16 partition < 32MB");

 push getFATtype_3
 call cputs
 add  sp, 2
;-388 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-389 					}

;-390 				if (ptFileSystem == 6) {

.getFATtype25:
 mov al, [ptFileSystem]
 cmp al, 6
 jne .getFATtype26
;-391 					cputs(", large FAT16 partition < 2GB");

 push getFATtype_4
 call cputs
 add  sp, 2
;-392 					isFAT=6;

 mov ax, 6
 mov [bp-2], ax
;-393 					}

;-394 				PartNo=99;//end of loop	

.getFATtype26:
 mov ax, 99
 mov word [PartNo], ax
;-395 			}

;-396 			PartNo ++;

.getFATtype23:
 inc  word[PartNo]
;-397 		} while (PartNo <4);

 mov ax, [PartNo]
 cmp ax, 4
 jge .getFATtype27
 jmp .getFATtype22
.getFATtype27:
;-398 		if (isFAT==0) cputs(" no FAT active partition found");

 mov ax, [bp-2]
 cmp ax, 0
 jne .getFATtype28
 push getFATtype_5
 call cputs
 add  sp, 2
;-399 		return isFAT;

.getFATtype28:
 mov ax, [bp-2]
 jmp .retngetFATtype
;-400 	}	

;-401 }

.getFATtype20:
;-402 

;-403 int getBootSector() {

 .retngetFATtype:
 LEAVE
 ret
getFATtype_0 db "Read partition status:",0
getFATtype_1 db " boot partition found",0
getFATtype_2 db ", FAT12 partition < 32MB",0
getFATtype_3 db ", small FAT16 partition < 32MB",0
getFATtype_4 db ", large FAT16 partition < 2GB",0
getFATtype_5 db " no FAT active partition found",0
ENDP

getBootSector: PROC
;-404 	Cylinders=ptStartCylinder;

 mov ax, [ptStartCylinder]
 mov word [Cylinders], ax
;-405 	Heads=ptStartHead;

 mov al, [ptStartHead]
 mov byte [Heads], al
;-406 	Sectors=ptStartSector ; // +1

 mov al, [ptStartSector]
 mov byte [Sectors], al
;-407 	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf

 mov [DiskBufSeg], ds; //Offset is in DiskBuf
;-408   BIOS_Status=Int13hRW(2,Drive,Heads,Cylinders,Sectors,1,DiskBufSeg,DiskBuf);

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
;-409 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector29
;-410 		Int13hError();

 call Int13hError
;-411 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-412 		}

;-413 	else {	

 jmp .getBootSector30
.getBootSector29:
;-414 		putch(10);

 push 10
 call putch
 add  sp, 2
;-415 		cputs("Read boot sector status:");

 push getBootSector_0
 call cputs
 add  sp, 2
;-416 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-417 		if(checkMagicNumber()==0) return 0;	

 call checkMagicNumber
 cmp ax, 0
 jne .getBootSector31
 mov ax, 0
 jmp .retngetBootSector
;-418 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector31:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-419 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector32
 push getBootSector_1
 call cputs
 add  sp, 2
;-420 		putch(10);

.getBootSector32:
 push 10
 call putch
 add  sp, 2
;-421 		cputs("OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push getBootSector_2
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-422 		putch(10);

 push 10
 call putch
 add  sp, 2
;-423 		cputs("Bytes per sector(512)=");printunsign(bs_sect_size);	

 push getBootSector_3
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-424 		cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);	

 push getBootSector_4
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-425 		putch(10);

 push 10
 call putch
 add  sp, 2
;-426 		cputs("Reserved sectors=");printunsign(bs_res_sects);	

 push getBootSector_5
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-427 		cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);	

 push getBootSector_6
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-428 		putch(10);

 push 10
 call putch
 add  sp, 2
;-429 		cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push getBootSector_7
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-430 		cputs(".Total sectors(0 if > 32MB=");printunsign(bs_total_sect);

 push getBootSector_8
 call cputs
 add  sp, 2
 push word [bs_total_sect]
 call printunsign
 add  sp, 2
;-431 		putch(10);

 push 10
 call putch
 add  sp, 2
;-432 		cputs("Media descriptor(F8h for HD)=");printhex8(bs_media_desc);

 push getBootSector_9
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-433 		cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push getBootSector_10
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-434 		putch(10);

 push 10
 call putch
 add  sp, 2
;-435 		cputs("sectors per track=");printunsign(bs_num_sects);

 push getBootSector_11
 call cputs
 add  sp, 2
 push word [bs_num_sects]
 call printunsign
 add  sp, 2
;-436 		cputs(".number of heads=");printunsign(bs_num_sides);

 push getBootSector_12
 call cputs
 add  sp, 2
 push word [bs_num_sides]
 call printunsign
 add  sp, 2
;-437 		putch(10);

 push 10
 call putch
 add  sp, 2
;-438 		cputs("hidden sectors(long)=");printlong(&bs_hid_sects);

 push getBootSector_13
 call cputs
 add  sp, 2
 lea  ax, [bs_hid_sects]
 push ax
 call printlong
 add  sp, 2
;-439 		cputs(".sectors(long)=");printlong(&bs_big_total);

 push getBootSector_14
 call cputs
 add  sp, 2
 lea  ax, [bs_big_total]
 push ax
 call printlong
 add  sp, 2
;-440 		putch(10);

 push 10
 call putch
 add  sp, 2
;-441 		cputs("physical drive number=");printunsign(bs_drive_num);

 push getBootSector_15
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-442 		cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push getBootSector_16
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-443 		putch(10);

 push 10
 call putch
 add  sp, 2
;-444 		cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push getBootSector_17
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-445 		cputs(".Volume serial(long)=");printlong(&bs_serial_num);

 push getBootSector_18
 call cputs
 add  sp, 2
 lea  ax, [bs_serial_num]
 push ax
 call printlong
 add  sp, 2
;-446 		putch(10);

 push 10
 call putch
 add  sp, 2
;-447 		cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push getBootSector_19
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-448 		cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);		

 push getBootSector_20
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-449 	}

;-450 	return 1;

.getBootSector30:
 mov ax, 1
 jmp .retngetBootSector
;-451 }

;-452 /*	

;-453 int Int13hExt(char drive) {

;-454 	putch(10);

;-455 	cputs("Int13h 41hExt AX(3000=ERROR)=");

;-456 	bx=0x55AA;

;-457 	BIOS_Status=Int13hRaw(0x80, 0x41);	

;-458 	printhex16(BIOS_Status);

;-459 	if (BIOS_ERR) {

;-460 		cputs(" not present");	

;-461 		Int13hError();	

;-462 		}

;-463 	else {

;-464 		cputs(" status=1:supported");

;-465 		asm mov [vBX], bx;0xAA55 Extension installed

;-466 		asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

;-467 		cputs(" BX(AA55)=");				printhex16(vBX);

;-468 		cputs(" CX(Interface bitmask)=");	printhex16(vCX);

;-469 		}		

;-470 }	

;-471 */

;-472 int mdump(unsigned char *adr, unsigned int len ) {

 .retngetBootSector:
 ret
getBootSector_0 db "Read boot sector status:",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db "OEM name (MSDOS5.0)=",0
getBootSector_3 db "Bytes per sector(512)=",0
getBootSector_4 db ".Sectors per cluster(1,,128)=",0
getBootSector_5 db "Reserved sectors=",0
getBootSector_6 db ".Number of FAT(1,2)=",0
getBootSector_7 db "Root directory entries(512)=",0
getBootSector_8 db ".Total sectors(0 if > 32MB=",0
getBootSector_9 db "Media descriptor(F8h for HD)=",0
getBootSector_10 db ".Sectors per FAT=",0
getBootSector_11 db "sectors per track=",0
getBootSector_12 db ".number of heads=",0
getBootSector_13 db "hidden sectors(long)=",0
getBootSector_14 db ".sectors(long)=",0
getBootSector_15 db "physical drive number=",0
getBootSector_16 db ".Windows NT check disk=",0
getBootSector_17 db "Extended signature(29h)=",0
getBootSector_18 db ".Volume serial(long)=",0
getBootSector_19 db "Volume label(NO NAME)=",0
getBootSector_20 db ".File system type(FAT16)=",0
ENDP

mdump: PROC
;-473     unsigned char c;

;-474     int i;

;-475     int j;

;-476     int k;

;-477     j=0;

;Function : mdump, Number local Var: 6
; # type sign width local variables
;55 ptr unsg byte adr = bp+4
;56 var unsg word len = bp+6
;57 var unsg byte c = bp-2
;58 var sign word i = bp-4
;59 var sign word j = bp-6
;60 var sign word k = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-6], ax
;-478     k=0;

 mov ax, 0
 mov [bp-8], ax
;-479     while (j < len ) {

.mdump33:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump34
;-480 	    k++;; 

 inc  word[bp-8]
;-481 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump35
;-482 		    getkey();

 call getkey
;-483 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-484 		    }

;-485         putch(10);

.mdump35:
 push 10
 call putch
 add  sp, 2
;-486         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-487         putch(':');

 push 58
 call putch
 add  sp, 2
;-488         i=0;

 mov ax, 0
 mov [bp-4], ax
;-489         while (i < 16) {

.mdump36:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump37
;-490             putch(' ');

 push 32
 call putch
 add  sp, 2
;-491             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-492             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-493             adr++;

 inc  word[bp+4]
;-494             i++;

 inc  word[bp-4]
;-495             j++;

 inc  word[bp-6]
;-496             }

;-497         putch(' ');

 jmp .mdump36
.mdump37:
 push 32
 call putch
 add  sp, 2
;-498         adr -=16;

 sub  word[bp+4], 16
;-499         i=0;

 mov ax, 0
 mov [bp-4], ax
;-500         while(i < 16) {

.mdump38:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump39
;-501             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-502             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump40
 push 46
 call putch
 add  sp, 2
;-503                 else putch(c);

 jmp .mdump41
.mdump40:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-504             adr++;

.mdump41:
 inc  word[bp+4]
;-505             i++;

 inc  word[bp-4]
;-506         }

;-507     }

 jmp .mdump38
.mdump39:
;-508 }

 jmp .mdump33
.mdump34:
;-509 

;-510 //------------------------------------ main ---------------

;-511 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-512 	int res;

;-513 	Drive=0x80;

;Function : main, Number local Var: 1
; # type sign width local variables
;55 var sign word res = bp-2;
 ENTER  2,0
 mov ax, 128
 mov byte [Drive], al
;-514 

;-515 	if (Params(Drive)) return 1;//no hard disk

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Params
 add  sp, 2
 or  al, al
 je .main42
 mov ax, 1
 jmp .retnmain
;-516 	res=getFATtype(Drive);//

.main42:
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call getFATtype
 add  sp, 2
 mov [bp-2], ax
;-517 	if (res == 0) return 1;

 mov ax, [bp-2]
 cmp ax, 0
 jne .main43
 mov ax, 1
 jmp .retnmain
;-518 //	mdump(DiskBuf, 512);

;-519 //	Int13hExt(Drive);

;-520 	if(getBootSector()==0) return 1; ;

.main43:
 call getBootSector
 cmp ax, 0
 jne .main44
 mov ax, 1
 jmp .retnmain
.main44:
;-521 	mdump(DiskBuf, 512);

 push 512
 lea  ax, [DiskBuf]
 push ax
 call mdump
 add  sp, 4
;-522 }

 .retnmain:
 LEAVE
 ret
ENDP
;Glob. variables:54 (400):539 (4000), Functions:26 (300):253 (3000)
;Lines:523, Constant: 1000 (3000), stacksize: 56831