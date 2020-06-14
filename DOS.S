;PLA compiler A.COM V1.0.1, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.1.6";//test bed

Version1 db "DOS.COM V0.1.6",0
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

;-19 unsigned char DOS_ERR;

DOS_ERR db 0
;-20 unsigned char BIOS_ERR;

BIOS_ERR db 0
;-21 unsigned int  BIOS_Status;

BIOS_Status dw 0
;-22 unsigned char DiskBuf [512];

section .bss
absolute 8192
DiskBuf resb 512
section .text
;-23 unsigned char Drive;

Drive db 0
;-24 unsigned int  Cylinders;

Cylinders dw 0
;-25 unsigned char Sectors;

Sectors db 0
;-26 unsigned char Heads;

Heads db 0
;-27 unsigned char Attached;

Attached db 0
;-28 unsigned int  DiskBufSeg;

DiskBufSeg dw 0
;-29 unsigned char DriveType;

DriveType db 0
;-30 unsigned int  PartNo;

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

;-41 unsigned int FatStartSector;

FatStartSector dw 0
;-42 unsigned int FatSectors;

FatSectors dw 0
;-43 unsigned int RootDirStartSector;

RootDirStartSector dw 0
;-44 unsigned int RootDirSectors;

RootDirSectors dw 0
;-45 unsigned int DataStartSector;

DataStartSector dw 0
;-46 unsigned int DataSectors16;

DataSectors16 dw 0
;-47 unsigned long DataSectors32;

DataSectors32 dd 0
;-48 unsigned long CountofClusters;

CountofClusters dd 0
;-49 unsigned long templong;

templong dd 0
;-50 char trueFATtype;

trueFATtype db 0
;-51 

;-52 //start hard disk partition structure 16 bytes in MBR. do not change

;-53 unsigned char pt_Bootable;		//80h = active partition, else 00

pt_Bootable db 0
;-54 unsigned char pt_StartHead;

pt_StartHead db 0
;-55 unsigned char pt_StartSector;	//bits 0-5

pt_StartSector db 0
;-56 unsigned int  pt_StartCylinder;	//bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-57 unsigned char pt_FileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=largeFAT16

pt_FileSystem db 0
;-58 unsigned char pt_EndHead;

pt_EndHead db 0
;-59 unsigned char pt_EndSector;		//bits 0-5

pt_EndSector db 0
;-60 unsigned int  pt_EndCylinder;	//bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-61 unsigned long pt_HiddenSector;	//sectors preceding partition

pt_HiddenSector dd 0
;-62 unsigned long pt_PartLen;    	//length of partition in sectors

pt_PartLen dd 0
;-63 //end hard disk partition structure

;-64 

;-65 //start boot BIOS Parameter Block structure. do not change

;-66 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-67 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-68 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-69 unsigned char bs_clust_size;// 13 sectors per cluster (1,2,4,..,128)

bs_clust_size db 0
;-70 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-71 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-72 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-73 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-74 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-75 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-76 unsigned int  bs_num_sects;	// 24 (DOS 3+)sectors per track 

bs_num_sects dw 0
;-77 unsigned int  bs_num_sides;	// 26 (DOS 3+)number of heads   

bs_num_sides dw 0
;-78 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors 

bs_hid_sects dd 0
;-79 unsigned long bs_tot_sect32;	// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-80 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-81 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-82 unsigned char bs_ext_signat;// 38 (DOS 4+) Extended signature,get next 3(29h)

bs_ext_signat db 0
;-83 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-84 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-85 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-86 // 62 end boot BIOS Parameter Block

;-87 

;-88 int writetty()     {//char in AL


writetty: PROC
;-89     ah=0x0E;

 mov  ah, 14
;-90     push bx;

push bx;
;-91     bx=0;			//page in BH

 mov  bx, 0
;-92     inth 0x10;		//16

 int  16
;-93     pop bx;

pop bx;
;-94 }

;-95 int putch(char c)  {

 ret
ENDP

putch: PROC
;-96     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;64 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-97         al=13;

 mov  al, 13
;-98         writetty();

 call writetty
;-99     }

;-100     al=c;

.putch1:
 mov  al, [bp+4]
;-101     writetty();

 call writetty
;-102 }

;-103 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-104     char c;

;-105     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;64 ptr sign byte s = bp+4
;65 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-106         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-107         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-108         s++;

 inc  word[bp+4]
;-109     }

;-110 }

 jmp .cputs2
.cputs3:
;-111 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-112 	char c;

;-113 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;64 ptr sign byte s = bp+4
;65 var sign word len = bp+6
;66 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-114 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-115 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-116 		s++;

 inc  word[bp+4]
;-117 		len--;

 dec  word[bp+6]
;-118 	} while (len > 0);	

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-119 }

;-120 

;-121 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-122     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-123     inth 0x16;//AH=Scan code, AL=char

 int  22
;-124 }

;-125 int waitkey() {

 ret
ENDP

waitkey: PROC
;-126     ah=0x11;//get kbd status

 mov  ah, 17
;-127     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-128     //zero flag: 0=IS char, 1=NO char

;-129     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-130 }

;-131 int getkey() {

 ret
ENDP

getkey: PROC
;-132     waitkey();

 call waitkey
;-133     getch();

 call getch
;-134     ah=0;//clear scan code

 mov  ah, 0
;-135     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-136     //put ext code in AX

;-137 }

.getkey6:
;-138 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-139     getkey();

 call getkey
;-140     writetty();//destroys AH

 call writetty
;-141 }

;-142 

;-143 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-144     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;64 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-145     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-146     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-147 }

;-148 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-149     unsigned char nib;

;-150     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;64 var unsg byte c = bp+4
;65 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-151     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-152 }

;-153 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-154     unsigned int half;

;-155     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;64 var unsg word i = bp+4
;65 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-156     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-157 }

;-158 

;-159 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-160     unsigned int e;

;-161     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;64 var unsg word n = bp+4
;65 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-162         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-163         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-164         }

;-165     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-166     n+='0';

 add  word[bp+4], 48
;-167     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-168 }

;-169 

;-170 int printlong(unsigned int *p) {

 LEAVE
 ret
ENDP

printlong: PROC
;-171 	unsigned int lo; unsigned int hi;

;-172 	lo = *p;

;Function : printlong, Number local Var: 3
; # type sign width local variables
;64 ptr unsg word p = bp+4
;65 var unsg word lo = bp-2
;66 var unsg word hi = bp-4;
 ENTER  4,0
 mov bx, [bp+4]
 mov ax, [bx]
 mov [bp-2], ax
;-173 	p +=2;

 add  word[bp+4], 2
;-174 	hi = *p;

 mov bx, [bp+4]
 mov ax, [bx]
 mov [bp-4], ax
;-175 	dx=hi;

 mov  dx, [bp-4]
;-176 	ax=lo;

 mov  ax, [bp-2]
;-177 __asm{	

	
;-178   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-179     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-180 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-181     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-182     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-183 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-184     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-185     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-186     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-187     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-188     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-189     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-190     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-191     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-192 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-193 }	writetty();		__asm{


 call writetty

;-194     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-195     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-196     jb      .b             ;Not yet	

    jb      .b             ;Not yet	
;-197 } 


;-198 }

;-199 

;-200 int memcpy(char *s, char *t, unsigned int i) {

 LEAVE
 ret
ENDP

memcpy: PROC
;-201 	unsigned int r;

;-202 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;64 ptr sign byte s = bp+4
;65 ptr sign byte t = bp+6
;66 var unsg word i = bp+8
;67 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-203 	do {

.memcpy9:
;-204 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-205 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-206 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy10
 jmp .memcpy9
.memcpy10:
;-207 	ax=r;//	return r;

 mov  ax, [bp-2]
;-208 }

;-209 

;-210 //--------------------------------  disk IO  -------------------

;-211 

;-212 int DiskSectorReadWrite(char rw, char drive, char head, int cyl, 

 LEAVE
 ret
ENDP

DiskSectorReadWrite: PROC
;-213 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-214 	BIOS_ERR=0;	

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;64 var sign byte rw = bp+4
;65 var sign byte drive = bp+6
;66 var sign byte head = bp+8
;67 var sign word cyl = bp+10
;68 var sign byte sector = bp+12
;69 var sign byte count = bp+14
;70 var sign word BufSeg = bp+16
;71 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-215 	dl=drive;

 mov  dl, [bp+6]
;-216 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-217 	es=BufSeg;

 mov  es, [bp+16]
;-218 	bx=BufOfs;

 mov  bx, [bp+18]
;-219 	cx=cyl;	

 mov  cx, [bp+10]
;-220 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-221 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-222 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-223 	cl += sector;

 add  cl, [bp+12]
;-224 	ch=cyl;//low byte of cyl in ch, word 2 byte	

 mov  ch, [bp+10]
;-225 	al=count;

 mov  al, [bp+14]
;-226 	ah=rw;

 mov  ah, [bp+4]
;-227 	inth 0x13;

 int  19
;-228     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-229 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-230 }

;-231 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-232 	BIOS_ERR=0;	

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;64 var sign byte drive = bp+4
;65 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-233 	dl=drive;

 mov  dl, [bp+4]
;-234 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-235 	inth 0x13;

 int  19
;-236     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-237 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-238 }

;-239 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-240 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-241 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-242 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-243 	BIOS_Status=Int13hfunction(Drive, 0);//Reset

 push 0
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-244 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-245 }	

;-246 

;-247 int Params() {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Params: PROC
;-248 	cputs("Drive Params:");

 push Params_0
 call cputs
 add  sp, 2
;-249 	BIOS_Status=Int13hfunction(Drive, 8);

 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-250 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params11
;-251 		Int13hError();

 call Int13hError
;-252 		return 1;

 mov ax, 1
 jmp .retnParams
;-253 		}

;-254 	else {

 jmp .Params12
.Params11:
;-255 		asm mov [Heads],        dh

 mov [Heads],        dh
;-256 //		Heads++;

;-257 		asm mov [Attached],     dl

 mov [Attached],     dl
;-258 		// CX =       ---CH--- ---CL---

;-259 		// cylinder : 76543210 98

;-260 		// sector   :            543210	

;-261 		asm mov [Sectors],      cl

 mov [Sectors],      cl
;-262 		Sectors &= 0x3F;// 63

 and  byte[Sectors], 63
;-263 //		Sectors++;//1 to 64

;-264 	

;-265 		asm mov [Cylinders],    cx	

 mov [Cylinders],    cx	
;-266 		Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[Cylinders], 192
;-267 		Cylinders = Cylinders << 2;//compiler flaw:

 mov ax, [Cylinders]
 shl ax, 2
 mov word [Cylinders], ax
;-268 		asm add [Cylinders],    ch;//byte add, low byte is empty	

 add [Cylinders],    ch;//byte add, low byte is empty	
;-269 		

;-270 		if (Attached == 0) {

 mov al, [Attached]
 cmp al, 0
 jne .Params13
;-271 			cputs(" no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-272 			return 1;

 mov ax, 1
 jmp .retnParams
;-273 			}

;-274 		cputs("CylHeadSec=");		printunsign(Cylinders);

.Params13:
 push Params_2
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
;-275 		putch('/');					printunsign(Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-276 		putch('/');					printunsign(Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-277 		cputs(", NoDrives=");		printhex8(Attached);

 push Params_3
 call cputs
 add  sp, 2
 mov al, byte [Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-278 		putch('.');

 push 46
 call putch
 add  sp, 2
;-279 	}

;-280 	return 0;

.Params12:
 mov ax, 0
 jmp .retnParams
;-281 }

;-282 

;-283 int Status(drive) {

 .retnParams:
 ret
Params_0 db "Drive Params:",0
Params_1 db " no hard disk found",0
Params_2 db "CylHeadSec=",0
Params_3 db ", NoDrives=",0
ENDP

Status: PROC
;-284 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;64 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-285 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-286 	BIOS_Status=Int13hfunction(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-287 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status14
 call Int13hError
;-288 	printhex16(BIOS_Status);	

.Status14:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-289 }	

;-290 

;-291 int getPartitionData() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

getPartitionData: PROC
;-292 	unsigned int j; char c; char *p;

;-293 	j = PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;64 var unsg word j = bp-2
;65 var sign byte c = bp-4
;66 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [PartNo]
 shl ax, 4
 mov [bp-2], ax
;-294 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-295 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-296 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-297 	ah=0;//next line convert byte to word

 mov  ah, 0
;-298 	pt_StartCylinder=pt_StartSector;	

 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-299 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-300 //	pt_StartSector++;//Sector start with 1 todo

;-301 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-302 	pt_StartCylinder = pt_StartCylinder << 2;//OK no short cut!	

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-303 	j++;

 inc  word[bp-2]
;-304 	ah=0;//byte to word

 mov  ah, 0
;-305 	pt_StartCylinder=DiskBuf[j] + pt_StartCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-306 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-307 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB	

;-308 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-309 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-310 	ah=0;//next line convert byte to word

 mov  ah, 0
;-311 	pt_EndCylinder=pt_EndSector;//see next 5 line		

 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-312 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-313 //	pt_EndSector++;//Sector start with 1 todo

;-314 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-315 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!	

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-316 	j++;

 inc  word[bp-2]
;-317 	ah=0;//byte to word

 mov  ah, 0
;-318 	pt_EndCylinder=DiskBuf[j] + pt_EndCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-319 	j++;

 inc  word[bp-2]
;-320 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-321 	memcpy(&pt_HiddenSector, p, 8);	

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-322 //	j += 8;//next partition entry

;-323 }

;-324 	

;-325 int printPartitionData() {

 LEAVE
 ret
ENDP

printPartitionData: PROC
;-326 	unsigned long Lo;

;-327 	putch(10);		

;Function : printPartitionData, Number local Var: 1
; # type sign width local variables
;64 var unsg long Lo = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-328 	cputs("No=");			printunsign(PartNo);

 push printPartitionData_0
 call cputs
 add  sp, 2
 push word [PartNo]
 call printunsign
 add  sp, 2
;-329 	cputs(",Boot=");		printhex8(pt_Bootable);

 push printPartitionData_1
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-330 	cputs(" ID=");			printunsign(pt_FileSystem);

 push printPartitionData_2
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-331 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push printPartitionData_3
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-332 	cputs("/");				printunsign(pt_StartSector);	

 push printPartitionData_4
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-333 	cputs("/");				printunsign(pt_StartCylinder);

 push printPartitionData_5
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-334 	cputs("-");				printunsign(pt_EndHead);

 push printPartitionData_6
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-335 	cputs("/");				printunsign(pt_EndSector);	

 push printPartitionData_7
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-336 	cputs("/");				printunsign(pt_EndCylinder);

 push printPartitionData_8
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-337 	cputs(",Start=");		printlong(&pt_HiddenSector);

 push printPartitionData_9
 call cputs
 add  sp, 2
 lea  ax, [pt_HiddenSector]
 push ax
 call printlong
 add  sp, 2
;-338 	cputs(",Len=");			printlong(&pt_PartLen);

 push printPartitionData_10
 call cputs
 add  sp, 2
 lea  ax, [pt_PartLen]
 push ax
 call printlong
 add  sp, 2
;-339 	cputs(" Sec=");

 push printPartitionData_11
 call cputs
 add  sp, 2
;-340 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-341 	printlong(&Lo);

 lea  ax, [bp-4]
 push ax
 call printlong
 add  sp, 2
;-342 	cputs(" MByte.");	

 push printPartitionData_12
 call cputs
 add  sp, 2
;-343 	putch(10);

 push 10
 call putch
 add  sp, 2
;-344 }

;-345 int checkBootSign() {

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

checkBootSign: PROC
;-346 	char c; char d; int i; char ok;

;-347 	cputs(",magic number=");	

;Function : checkBootSign, Number local Var: 4
; # type sign width local variables
;64 var sign byte c = bp-2
;65 var sign byte d = bp-4
;66 var sign word i = bp-6
;67 var sign byte ok = bp-8;
 ENTER  8,0
 push checkBootSign_0
 call cputs
 add  sp, 2
;-348 	i=510;		c = DiskBuf[i];		printhex8(c);

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
;-349 	i++;		d = DiskBuf[i];		printhex8(d);

 inc  word[bp-6]
 mov bx, [bp-6]
 mov al, [DiskBuf + bx]
 mov [bp-4], al
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-350 	ok=0;

 mov ax, 0
 mov [bp-8], al
;-351 	if (c == 0x55) ok=1;

 mov al, [bp-2]
 cmp al, 85
 jne .checkBootSign15
 mov ax, 1
 mov [bp-8], al
;-352 	if (d == 0xAA) ok=1;

.checkBootSign15:
 mov al, [bp-4]
 cmp al, 170
 jne .checkBootSign16
 mov ax, 1
 mov [bp-8], al
;-353 	if (ok) {

.checkBootSign16:
 mov al, [bp-8]
 or  al, al
 je .checkBootSign17
;-354 		cputs(" found.");

 push checkBootSign_1
 call cputs
 add  sp, 2
;-355 		return 1;

 mov ax, 1
 jmp .retncheckBootSign
;-356 		}

;-357 	else {

 jmp .checkBootSign18
.checkBootSign17:
;-358 		cputs(" NOT found.");

 push checkBootSign_2
 call cputs
 add  sp, 2
;-359 		return 0;	

 mov ax, 0
 jmp .retncheckBootSign
;-360 	}

;-361 }	

.checkBootSign18:
;-362 	

;-363 int getFATtype() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db ",magic number=",0
checkBootSign_1 db " found.",0
checkBootSign_2 db " NOT found.",0
ENDP

getFATtype: PROC
;-364 	int isFAT;

;-365 	isFAT=0;

;Function : getFATtype, Number local Var: 1
; # type sign width local variables
;64 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-366 	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf

 mov [DiskBufSeg], ds; //Offset is in DiskBuf
;-367 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push 1
 push 1
 push 0
 push 0
 mov al, byte [Drive]
 mov ah, 0
 push ax
 push 2
 call DiskSectorReadWrite
 add  sp, 16
 mov word [BIOS_Status], ax
;-368 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .getFATtype19
;-369 		Int13hError();

 call Int13hError
;-370 		return 0;

 mov ax, 0
 jmp .retngetFATtype
;-371 		}

;-372 	else {	

 jmp .getFATtype20
.getFATtype19:
;-373 		putch(10);

 push 10
 call putch
 add  sp, 2
;-374 		cputs("Read partition status:");

 push getFATtype_0
 call cputs
 add  sp, 2
;-375 /*		printhex16(BIOS_Status);	

;-376 		cputs(",DiskBuf=");

;-377 		printhex16(DiskBufSeg);

;-378 		putch(':');							

;-379 		printhex16(DiskBuf);

;-380 		putch('.');

;-381 */		

;-382 		if(checkBootSign()==0) return 0;	

 call checkBootSign
 cmp al, 0
 jne .getFATtype21
 mov ax, 0
 jmp .retngetFATtype
;-383 		PartNo=0;

.getFATtype21:
 mov ax, 0
 mov word [PartNo], ax
;-384 		do {

.getFATtype22:
;-385 			getPartitionData();

 call getPartitionData
;-386 			printPartitionData();

 call printPartitionData
;-387 			

;-388 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .getFATtype23
;-389 				cputs("Boot partition found");

 push getFATtype_1
 call cputs
 add  sp, 2
;-390 				if (pt_FileSystem == 1) {

 mov al, [pt_FileSystem]
 cmp al, 1
 jne .getFATtype24
;-391 					cputs(", FAT12 partition < 32MB");

 push getFATtype_2
 call cputs
 add  sp, 2
;-392 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-393 					}

;-394 				if (pt_FileSystem == 4) {

.getFATtype24:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .getFATtype25
;-395 					cputs(", small FAT16 partition < 32MB");

 push getFATtype_3
 call cputs
 add  sp, 2
;-396 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-397 					}

;-398 				if (pt_FileSystem == 6) {

.getFATtype25:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .getFATtype26
;-399 					cputs(", large FAT16 partition < 2GB");

 push getFATtype_4
 call cputs
 add  sp, 2
;-400 					isFAT=6;

 mov ax, 6
 mov [bp-2], ax
;-401 					}

;-402 				PartNo=99;//end of loop	

.getFATtype26:
 mov ax, 99
 mov word [PartNo], ax
;-403 			}

;-404 			PartNo ++;

.getFATtype23:
 inc  word[PartNo]
;-405 		} while (PartNo <4);

 mov ax, [PartNo]
 cmp ax, 4
 jge .getFATtype27
 jmp .getFATtype22
.getFATtype27:
;-406 		if (isFAT==0) cputs(" no active FAT partition found");

 mov ax, [bp-2]
 cmp ax, 0
 jne .getFATtype28
 push getFATtype_5
 call cputs
 add  sp, 2
;-407 		return isFAT;

.getFATtype28:
 mov ax, [bp-2]
 jmp .retngetFATtype
;-408 	}	

;-409 }

.getFATtype20:
;-410 

;-411 int getBootSector() {

 .retngetFATtype:
 LEAVE
 ret
getFATtype_0 db "Read partition status:",0
getFATtype_1 db "Boot partition found",0
getFATtype_2 db ", FAT12 partition < 32MB",0
getFATtype_3 db ", small FAT16 partition < 32MB",0
getFATtype_4 db ", large FAT16 partition < 2GB",0
getFATtype_5 db " no active FAT partition found",0
ENDP

getBootSector: PROC
;-412 	Cylinders=pt_StartCylinder;

 mov ax, [pt_StartCylinder]
 mov word [Cylinders], ax
;-413 	Heads=pt_StartHead;

 mov al, [pt_StartHead]
 mov byte [Heads], al
;-414 	Sectors=pt_StartSector ; // +1

 mov al, [pt_StartSector]
 mov byte [Sectors], al
;-415 	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf

 mov [DiskBufSeg], ds; //Offset is in DiskBuf
;-416   BIOS_Status=DiskSectorReadWrite(2,Drive,Heads,Cylinders,Sectors,1,DiskBufSeg,DiskBuf);

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
 call DiskSectorReadWrite
 add  sp, 16
 mov word [BIOS_Status], ax
;-417 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector29
;-418 		Int13hError();

 call Int13hError
;-419 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-420 		}

;-421 	else {	

 jmp .getBootSector30
.getBootSector29:
;-422 		putch(10);

 push 10
 call putch
 add  sp, 2
;-423 		cputs("Read boot sector status:");

 push getBootSector_0
 call cputs
 add  sp, 2
;-424 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-425 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp ax, 0
 jne .getBootSector31
 mov ax, 0
 jmp .retngetBootSector
;-426 		

;-427 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector31:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-428 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector32
 push getBootSector_1
 call cputs
 add  sp, 2
;-429 		putch(10);

.getBootSector32:
 push 10
 call putch
 add  sp, 2
;-430 		cputs("OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push getBootSector_2
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-431 		putch(10);

 push 10
 call putch
 add  sp, 2
;-432 		cputs("Bytes per sector(512)=");printunsign(bs_sect_size);	

 push getBootSector_3
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-433 		cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);	

 push getBootSector_4
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-434 		putch(10);

 push 10
 call putch
 add  sp, 2
;-435 		cputs("Reserved sectors=");printunsign(bs_res_sects);	

 push getBootSector_5
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-436 		cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);	

 push getBootSector_6
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-437 		putch(10);

 push 10
 call putch
 add  sp, 2
;-438 		cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push getBootSector_7
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-439 		cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push getBootSector_8
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-440 		putch(10);

 push 10
 call putch
 add  sp, 2
;-441 		cputs("Media descriptor(F8h for HD)=");printhex8(bs_media_desc);

 push getBootSector_9
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-442 		cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push getBootSector_10
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-443 		putch(10);

 push 10
 call putch
 add  sp, 2
;-444 		cputs("sectors per track=");printunsign(bs_num_sects);

 push getBootSector_11
 call cputs
 add  sp, 2
 push word [bs_num_sects]
 call printunsign
 add  sp, 2
;-445 		cputs(".number of heads=");printunsign(bs_num_sides);

 push getBootSector_12
 call cputs
 add  sp, 2
 push word [bs_num_sides]
 call printunsign
 add  sp, 2
;-446 		putch(10);

 push 10
 call putch
 add  sp, 2
;-447 		cputs("hidden sectors(long)=");printlong(&bs_hid_sects);

 push getBootSector_13
 call cputs
 add  sp, 2
 lea  ax, [bs_hid_sects]
 push ax
 call printlong
 add  sp, 2
;-448 		cputs(".sectors(long)=");printlong(&bs_tot_sect32);

 push getBootSector_14
 call cputs
 add  sp, 2
 lea  ax, [bs_tot_sect32]
 push ax
 call printlong
 add  sp, 2
;-449 		putch(10);

 push 10
 call putch
 add  sp, 2
;-450 		cputs("physical drive number=");printunsign(bs_drive_num);

 push getBootSector_15
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-451 		cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push getBootSector_16
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-452 		putch(10);

 push 10
 call putch
 add  sp, 2
;-453 		cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push getBootSector_17
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-454 		cputs(".Volume serial(long)=");printlong(&bs_serial_num);

 push getBootSector_18
 call cputs
 add  sp, 2
 lea  ax, [bs_serial_num]
 push ax
 call printlong
 add  sp, 2
;-455 		putch(10);

 push 10
 call putch
 add  sp, 2
;-456 		cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push getBootSector_19
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-457 		cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);		

 push getBootSector_20
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-458 	}

;-459 	return 1;

.getBootSector30:
 mov ax, 1
 jmp .retngetBootSector
;-460 }

;-461 

;-462 int calcFATtype() {

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

calcFATtype: PROC
;-463 	char c;

;-464 	

;-465 	FatStartSector=bs_res_sects;	

;Function : calcFATtype, Number local Var: 1
; # type sign width local variables
;64 var sign byte c = bp-2;
 ENTER  2,0
 mov ax, [bs_res_sects]
 mov word [FatStartSector], ax
;-466 	FatSectors=bs_fat_size;	

 mov ax, [bs_fat_size]
 mov word [FatSectors], ax
;-467 	if (bs_num_fats == 2) FatSectors=FatSectors+FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .calcFATtype33
 mov ax, [FatSectors]
 add ax, [FatSectors]
 mov word [FatSectors], ax
;-468 

;-469 	RootDirStartSector=FatStartSector + FatSectors;

.calcFATtype33:
 mov ax, [FatStartSector]
 add ax, [FatSectors]
 mov word [RootDirStartSector], ax
;-470 	RootDirSectors= bs_root_entr << 5;// *32	

 mov ax, [bs_root_entr]
 shl ax, 5
 mov word [RootDirSectors], ax
;-471 	RootDirSectors= RootDirSectors / bs_sect_size;

 mov ax, [RootDirSectors]
 mov bx, [bs_sect_size]
 mov dx, 0
 div bx
 mov word [RootDirSectors], ax
;-472 

;-473 	DataStartSector=RootDirStartSector + RootDirSectors;

 mov ax, [RootDirStartSector]
 add ax, [RootDirSectors]
 mov word [DataStartSector], ax
;-474 	if (bs_tot_sect16 !=0) {

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .calcFATtype34
;-475 		DataSectors16=bs_tot_sect16 - DataStartSector;

 mov ax, [bs_tot_sect16]
 sub ax, [DataStartSector]
 mov word [DataSectors16], ax
;-476 		DataSectors32=0;//todo only word 0

 mov ax, 0
 mov dword [DataSectors32], eax
;-477 		cputs("FAT < 32 MB NOT supported");

 push calcFATtype_0
 call cputs
 add  sp, 2
;-478 		trueFATtype=0;

 mov ax, 0
 mov byte [trueFATtype], al
;-479 		return;

 jmp .retncalcFATtype
;-480 		}

;-481 	else {

 jmp .calcFATtype35
.calcFATtype34:
;-482 		asm xor eax, eax ;clear bit 15-31

 xor eax, eax ;clear bit 15-31
;-483 		templong=DataStartSector;//convert word to dword		

 mov ax, [DataStartSector]
 mov dword [templong], eax
;-484 		DataSectors32=bs_tot_sect32 - templong;//sub 32bit		

 mov eax, [bs_tot_sect32]
 sub eax, [templong]
 mov dword [DataSectors32], eax
;-485 		DataSectors16=0;	

 mov ax, 0
 mov word [DataSectors16], ax
;-486 		}

;-487 //	CountofClusters=DataSectors32 / bs_clust_size;only int divisor

;-488 		if (bs_clust_size == 32) CountofClusters=DataSectors32 >> 5;

.calcFATtype35:
 mov al, [bs_clust_size]
 cmp al, 32
 jne .calcFATtype36
 mov eax, [DataSectors32]
 shr eax, 5
 mov dword [CountofClusters], eax
;-489 		if (bs_clust_size == 16) CountofClusters=DataSectors32 >> 4;

.calcFATtype36:
 mov al, [bs_clust_size]
 cmp al, 16
 jne .calcFATtype37
 mov eax, [DataSectors32]
 shr eax, 4
 mov dword [CountofClusters], eax
;-490 		if (bs_clust_size ==  8) CountofClusters=DataSectors32 >> 3;

.calcFATtype37:
 mov al, [bs_clust_size]
 cmp al, 8
 jne .calcFATtype38
 mov eax, [DataSectors32]
 shr eax, 3
 mov dword [CountofClusters], eax
;-491 		if (bs_clust_size ==  4) CountofClusters=DataSectors32 >> 2;

.calcFATtype38:
 mov al, [bs_clust_size]
 cmp al, 4
 jne .calcFATtype39
 mov eax, [DataSectors32]
 shr eax, 2
 mov dword [CountofClusters], eax
;-492 		if (bs_clust_size ==  2) CountofClusters=DataSectors32 >> 1;

.calcFATtype39:
 mov al, [bs_clust_size]
 cmp al, 2
 jne .calcFATtype40
 mov eax, [DataSectors32]
 shr eax, 1
 mov dword [CountofClusters], eax
;-493 		if (bs_clust_size ==  1) CountofClusters=DataSectors32;

.calcFATtype40:
 mov al, [bs_clust_size]
 cmp al, 1
 jne .calcFATtype41
 mov eax, [DataSectors32]
 mov dword [CountofClusters], eax
;-494 

;-495 		putch(10);

.calcFATtype41:
 push 10
 call putch
 add  sp, 2
;-496 		cputs("FatStartSector:");	printunsign(FatStartSector);

 push calcFATtype_1
 call cputs
 add  sp, 2
 push word [FatStartSector]
 call printunsign
 add  sp, 2
;-497 		cputs(", FatSectors=");		printunsign(FatSectors);

 push calcFATtype_2
 call cputs
 add  sp, 2
 push word [FatSectors]
 call printunsign
 add  sp, 2
;-498 		putch(10);

 push 10
 call putch
 add  sp, 2
;-499 		cputs("RootDirStartSector="); printunsign(RootDirStartSector);

 push calcFATtype_3
 call cputs
 add  sp, 2
 push word [RootDirStartSector]
 call printunsign
 add  sp, 2
;-500 		cputs(", RootDirSectors=");	printunsign(RootDirSectors);

 push calcFATtype_4
 call cputs
 add  sp, 2
 push word [RootDirSectors]
 call printunsign
 add  sp, 2
;-501 		putch(10);

 push 10
 call putch
 add  sp, 2
;-502 		cputs("DataStartSector=");	printunsign(DataStartSector);

 push calcFATtype_5
 call cputs
 add  sp, 2
 push word [DataStartSector]
 call printunsign
 add  sp, 2
;-503 		cputs(", DataSectors16=");	printunsign(DataSectors16);	

 push calcFATtype_6
 call cputs
 add  sp, 2
 push word [DataSectors16]
 call printunsign
 add  sp, 2
;-504 		cputs(", DataSectors32=");	printlong(&DataSectors32);			

 push calcFATtype_7
 call cputs
 add  sp, 2
 lea  ax, [DataSectors32]
 push ax
 call printlong
 add  sp, 2
;-505 		putch(10);

 push 10
 call putch
 add  sp, 2
;-506 		cputs("CountofClusters=");	printlong(&CountofClusters);

 push calcFATtype_8
 call cputs
 add  sp, 2
 lea  ax, [CountofClusters]
 push ax
 call printlong
 add  sp, 2
;-507 		putch(10);

 push 10
 call putch
 add  sp, 2
;-508 		cputs(", true FAT type=FAT"); 

 push calcFATtype_9
 call cputs
 add  sp, 2
;-509 		

;-510 		asm xor eax, eax ;clear bit 15-31

 xor eax, eax ;clear bit 15-31
;-511 		templong=4086;

 mov ax, 4086
 mov dword [templong], eax
;-512 		if (CountofClusters < templong) {

 mov eax, [CountofClusters]
 cmp eax, [templong]
 jge .calcFATtype42
;-513 			trueFATtype=1; 

 mov ax, 1
 mov byte [trueFATtype], al
;-514 			cputs("12"); 

 push calcFATtype_10
 call cputs
 add  sp, 2
;-515 			return;

 jmp .retncalcFATtype
;-516 			}

;-517 		asm xor eax, eax ;clear bit 15-31			

.calcFATtype42:
 xor eax, eax ;clear bit 15-31			
;-518 		templong = 65525;			

 mov ax, 65525
 mov dword [templong], eax
;-519 		if (CountofClusters > templong) {

 mov eax, [CountofClusters]
 cmp eax, [templong]
 jle .calcFATtype43
;-520 			trueFATtype=11; 

 mov ax, 11
 mov byte [trueFATtype], al
;-521 			cputs("32"); 

 push calcFATtype_11
 call cputs
 add  sp, 2
;-522 			return;

 jmp .retncalcFATtype
;-523 			}

;-524 			trueFATtype=6;

.calcFATtype43:
 mov ax, 6
 mov byte [trueFATtype], al
;-525 			cputs("16");

 push calcFATtype_12
 call cputs
 add  sp, 2
;-526 }//trueFATtype: 1=FAT12,6=FAT16,11=FAT32

;-527 

;-528 /*int Int13hExt(char drive) {

;-529 	putch(10);

;-530 	cputs("Int13h 41hExt AX(3000=ERROR)=");

;-531 	bx=0x55AA;

;-532 	BIOS_Status=Int13hfunction(0x80, 0x41);	

;-533 	printhex16(BIOS_Status);

;-534 	if (BIOS_ERR) {

;-535 		cputs(" not present");	

;-536 		Int13hError();	

;-537 		}

;-538 	else {

;-539 		cputs(" status=1:supported");

;-540 		asm mov [vBX], bx;0xAA55 Extension installed

;-541 		asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

;-542 		cputs(" BX(AA55)=");				printhex16(vBX);

;-543 		cputs(" CX(Interface bitmask)=");	printhex16(vCX);

;-544 		}		

;-545 }	

;-546 */

;-547 int mdump(unsigned char *adr, unsigned int len ) {

 .retncalcFATtype:
 LEAVE
 ret
calcFATtype_0 db "FAT < 32 MB NOT supported",0
calcFATtype_1 db "FatStartSector:",0
calcFATtype_2 db ", FatSectors=",0
calcFATtype_3 db "RootDirStartSector=",0
calcFATtype_4 db ", RootDirSectors=",0
calcFATtype_5 db "DataStartSector=",0
calcFATtype_6 db ", DataSectors16=",0
calcFATtype_7 db ", DataSectors32=",0
calcFATtype_8 db "CountofClusters=",0
calcFATtype_9 db ", true FAT type=FAT",0
calcFATtype_10 db "12",0
calcFATtype_11 db "32",0
calcFATtype_12 db "16",0
ENDP

mdump: PROC
;-548     unsigned char c; int i; int j; int k;

;-549     j=0;

;Function : mdump, Number local Var: 6
; # type sign width local variables
;64 ptr unsg byte adr = bp+4
;65 var unsg word len = bp+6
;66 var unsg byte c = bp-2
;67 var sign word i = bp-4
;68 var sign word j = bp-6
;69 var sign word k = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-6], ax
;-550     k=0;

 mov ax, 0
 mov [bp-8], ax
;-551     while (j < len ) {

.mdump44:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump45
;-552 	    k++;; 

 inc  word[bp-8]
;-553 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump46
;-554 		    getkey();

 call getkey
;-555 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-556 		    }

;-557         putch(10);

.mdump46:
 push 10
 call putch
 add  sp, 2
;-558         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-559         putch(':');

 push 58
 call putch
 add  sp, 2
;-560         i=0;

 mov ax, 0
 mov [bp-4], ax
;-561         while (i < 16) {

.mdump47:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump48
;-562             putch(' ');

 push 32
 call putch
 add  sp, 2
;-563             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-564             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-565             adr++;

 inc  word[bp+4]
;-566             i++;

 inc  word[bp-4]
;-567             j++;

 inc  word[bp-6]
;-568             }

;-569         putch(' ');

 jmp .mdump47
.mdump48:
 push 32
 call putch
 add  sp, 2
;-570         adr -=16;

 sub  word[bp+4], 16
;-571         i=0;

 mov ax, 0
 mov [bp-4], ax
;-572         while(i < 16) {

.mdump49:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump50
;-573             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-574             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump51
 push 46
 call putch
 add  sp, 2
;-575                 else putch(c);

 jmp .mdump52
.mdump51:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-576             adr++;

.mdump52:
 inc  word[bp+4]
;-577             i++;

 inc  word[bp-4]
;-578         }

;-579     }

 jmp .mdump49
.mdump50:
;-580 }

 jmp .mdump44
.mdump45:
;-581 

;-582 //------------------------------------ main ---------------

;-583 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-584 	int res;

;-585 	Drive=0x80;

;Function : main, Number local Var: 1
; # type sign width local variables
;64 var sign word res = bp-2;
 ENTER  2,0
 mov ax, 128
 mov byte [Drive], al
;-586 

;-587 	if (Params()) return 1;//no hard disk

 call Params
 or  al, al
 je .main53
 mov ax, 1
 jmp .retnmain
;-588 	res=getFATtype();//0=error,1=FAT12,6=FAT16,11=FAT32

.main53:
 call getFATtype
 mov [bp-2], ax
;-589 	if (res == 0) return 1;

 mov ax, [bp-2]
 cmp ax, 0
 jne .main54
 mov ax, 1
 jmp .retnmain
;-590 //	mdump(DiskBuf, 512);

;-591 //	Int13hExt(Drive);

;-592 	if(getBootSector()==0) return 1;

.main54:
 call getBootSector
 cmp ax, 0
 jne .main55
 mov ax, 1
 jmp .retnmain
;-593 //	mdump(DiskBuf, 512);

;-594 	calcFATtype();//set trueFATtype: 1=FAT12,6=FAT16,11=FAT32

.main55:
 call calcFATtype
;-595 	if(trueFATtype != 6) return 1;

 mov al, [trueFATtype]
 cmp al, 6
 je  .main56
 mov ax, 1
 jmp .retnmain
;-596 	

;-597 }

.main56:
 .retnmain:
 LEAVE
 ret
ENDP
;Glob. variables:63 (400):677 (4000), Functions:27 (300):278 (3000)
;Lines:598, Constant: 1000 (3000), stacksize: 56831