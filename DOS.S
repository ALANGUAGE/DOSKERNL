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
;-23 unsigned int  DiskBufSeg;

DiskBufSeg dw 0
;-24 unsigned char Drive=0x80;

Drive db 128
;-25 

;-26 //Params from int13h, Function 8

;-27 unsigned int  pa_Cylinders;

pa_Cylinders dw 0
;-28 unsigned char pa_Sectors;

pa_Sectors db 0
;-29 unsigned char pa_Heads;

pa_Heads db 0
;-30 unsigned char pa_Attached;

pa_Attached db 0
;-31 

;-32 //calcFATtype     

;-33 unsigned int FatStartSector;

FatStartSector dw 0
;-34 unsigned int FatSectors;

FatSectors dw 0
;-35 unsigned int RootDirStartSector;

RootDirStartSector dw 0
;-36 unsigned int RootDirSectors;

RootDirSectors dw 0
;-37 unsigned int DataStartSector;

DataStartSector dw 0
;-38 unsigned int DataSectors16;

DataSectors16 dw 0
;-39 unsigned long DataSectors32;

DataSectors32 dd 0
;-40 unsigned long CountofClusters;

CountofClusters dd 0
;-41 unsigned long templong;//converting word to dword

templong dd 0
;-42 char trueFATtype;

trueFATtype db 0
;-43 

;-44 //start hard disk partition structure 16 bytes in MBR. do not change

;-45 unsigned char pt_Bootable;		//80h = active partition, else 00

pt_Bootable db 0
;-46 unsigned char pt_StartHead;

pt_StartHead db 0
;-47 unsigned char pt_StartSector;	//bits 0-5

pt_StartSector db 0
;-48 unsigned int  pt_StartCylinder;	//bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-49 unsigned char pt_FileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=largeFAT16

pt_FileSystem db 0
;-50 unsigned char pt_EndHead;

pt_EndHead db 0
;-51 unsigned char pt_EndSector;		//bits 0-5

pt_EndSector db 0
;-52 unsigned int  pt_EndCylinder;	//bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-53 unsigned long pt_HiddenSector;	//sectors preceding partition

pt_HiddenSector dd 0
;-54 unsigned long pt_PartLen;    	//length of partition in sectors

pt_PartLen dd 0
;-55 //end hard disk partition structure

;-56 

;-57 //start boot BIOS Parameter Block structure. do not change

;-58 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-59 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-60 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-61 unsigned char bs_clust_size;// 13 sectors per cluster (1,2,4,..,128)

bs_clust_size db 0
;-62 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-63 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-64 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-65 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-66 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-67 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-68 unsigned int  bs_num_sects;	// 24 (DOS 3+)sectors per track 

bs_num_sects dw 0
;-69 unsigned int  bs_num_sides;	// 26 (DOS 3+)number of heads   

bs_num_sides dw 0
;-70 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors 

bs_hid_sects dd 0
;-71 unsigned long bs_tot_sect32;	// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-72 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-73 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-74 unsigned char bs_ext_signat;// 38 (DOS 4+) Extended signature,get next 3(29h)

bs_ext_signat db 0
;-75 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-76 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-77 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-78 // 62 end boot BIOS Parameter Block

;-79 

;-80 int writetty()     {//char in AL


writetty: PROC
;-81     ah=0x0E;

 mov  ah, 14
;-82     push bx;

push bx;
;-83     bx=0;			//page in BH

 mov  bx, 0
;-84     inth 0x10;		//16

 int  16
;-85     pop bx;

pop bx;
;-86 }

;-87 int putch(char c)  {

 ret
ENDP

putch: PROC
;-88     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;62 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-89         al=13;

 mov  al, 13
;-90         writetty();

 call writetty
;-91     }

;-92     al=c;

.putch1:
 mov  al, [bp+4]
;-93     writetty();

 call writetty
;-94 }

;-95 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-96     char c;

;-97     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;62 ptr sign byte s = bp+4
;63 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-98         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-99         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-100         s++;

 inc  word[bp+4]
;-101     }

;-102 }

 jmp .cputs2
.cputs3:
;-103 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-104 	char c;

;-105 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;62 ptr sign byte s = bp+4
;63 var sign word len = bp+6
;64 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-106 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-107 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-108 		s++;

 inc  word[bp+4]
;-109 		len--;

 dec  word[bp+6]
;-110 	} while (len > 0);	

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-111 }

;-112 

;-113 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-114     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-115     inth 0x16;//AH=Scan code, AL=char

 int  22
;-116 }

;-117 int waitkey() {

 ret
ENDP

waitkey: PROC
;-118     ah=0x11;//get kbd status

 mov  ah, 17
;-119     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-120     //zero flag: 0=IS char, 1=NO char

;-121     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-122 }

;-123 int getkey() {

 ret
ENDP

getkey: PROC
;-124     waitkey();

 call waitkey
;-125     getch();

 call getch
;-126     ah=0;//clear scan code

 mov  ah, 0
;-127     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-128     //put ext code in AX

;-129 }

.getkey6:
;-130 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-131     getkey();

 call getkey
;-132     writetty();//destroys AH

 call writetty
;-133 }

;-134 

;-135 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-136     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;62 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-137     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-138     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-139 }

;-140 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-141     unsigned char nib;

;-142     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;62 var unsg byte c = bp+4
;63 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-143     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-144 }

;-145 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-146     unsigned int half;

;-147     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;62 var unsg word i = bp+4
;63 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-148     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-149 }

;-150 

;-151 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-152     unsigned int e;

;-153     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;62 var unsg word n = bp+4
;63 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-154         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-155         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-156         }

;-157     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-158     n+='0';

 add  word[bp+4], 48
;-159     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-160 }

;-161 

;-162 int printlong(unsigned int *p) {

 LEAVE
 ret
ENDP

printlong: PROC
;-163 	unsigned int lo; unsigned int hi;

;-164 	lo = *p;

;Function : printlong, Number local Var: 3
; # type sign width local variables
;62 ptr unsg word p = bp+4
;63 var unsg word lo = bp-2
;64 var unsg word hi = bp-4;
 ENTER  4,0
 mov bx, [bp+4]
 mov ax, [bx]
 mov [bp-2], ax
;-165 	p +=2;

 add  word[bp+4], 2
;-166 	hi = *p;

 mov bx, [bp+4]
 mov ax, [bx]
 mov [bp-4], ax
;-167 	dx=hi;

 mov  dx, [bp-4]
;-168 	ax=lo;

 mov  ax, [bp-2]
;-169 __asm{	

	
;-170   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-171     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-172 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-173     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-174     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-175 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-176     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-177     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-178     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-179     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-180     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-181     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-182     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-183     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-184 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-185 }	writetty();		__asm{


 call writetty

;-186     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-187     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-188     jb      .b             ;Not yet	

    jb      .b             ;Not yet	
;-189 } 


;-190 }

;-191 

;-192 int memcpy(char *s, char *t, unsigned int i) {

 LEAVE
 ret
ENDP

memcpy: PROC
;-193 	unsigned int r;

;-194 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;62 ptr sign byte s = bp+4
;63 ptr sign byte t = bp+6
;64 var unsg word i = bp+8
;65 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-195 	do {

.memcpy9:
;-196 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-197 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-198 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy10
 jmp .memcpy9
.memcpy10:
;-199 	ax=r;//	return r;

 mov  ax, [bp-2]
;-200 }

;-201 

;-202 //--------------------------------  disk IO  -------------------

;-203 

;-204 int DiskSectorReadWrite(char rw, char drive, char head, int cyl, 

 LEAVE
 ret
ENDP

DiskSectorReadWrite: PROC
;-205 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-206 	BIOS_ERR=0;	

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;62 var sign byte rw = bp+4
;63 var sign byte drive = bp+6
;64 var sign byte head = bp+8
;65 var sign word cyl = bp+10
;66 var sign byte sector = bp+12
;67 var sign byte count = bp+14
;68 var sign word BufSeg = bp+16
;69 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-207 	dl=drive;

 mov  dl, [bp+6]
;-208 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-209 	es=BufSeg;

 mov  es, [bp+16]
;-210 	bx=BufOfs;

 mov  bx, [bp+18]
;-211 	cx=cyl;	

 mov  cx, [bp+10]
;-212 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-213 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-214 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-215 	cl += sector;

 add  cl, [bp+12]
;-216 	ch=cyl;//low byte of cyl in ch, word 2 byte	

 mov  ch, [bp+10]
;-217 	al=count;

 mov  al, [bp+14]
;-218 	ah=rw;

 mov  ah, [bp+4]
;-219 	inth 0x13;

 int  19
;-220     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-221 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-222 }

;-223 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-224 	BIOS_ERR=0;	

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;62 var sign byte drive = bp+4
;63 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-225 	dl=drive;

 mov  dl, [bp+4]
;-226 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-227 	inth 0x13;

 int  19
;-228     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-229 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-230 }

;-231 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-232 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-233 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-234 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-235 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-236 }	

;-237 

;-238 int Params() {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Params: PROC
;-239 	cputs("Drive Params:");

 push Params_0
 call cputs
 add  sp, 2
;-240 	BIOS_Status=Int13hfunction(Drive, 8);

 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-241 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params11
;-242 		Int13hError();

 call Int13hError
;-243 		return 1;

 mov ax, 1
 jmp .retnParams
;-244 		}

;-245 	else {

 jmp .Params12
.Params11:
;-246 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-247 //		pa_Heads++;

;-248 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-249 		// CX =       ---CH--- ---CL---

;-250 		// cylinder : 76543210 98

;-251 		// sector   :            543210	

;-252 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-253 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-254 //		pa_Sectors++;//1 to 64

;-255 	

;-256 		asm mov [pa_Cylinders],    cx	

 mov [pa_Cylinders],    cx	
;-257 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-258 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-259 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty	

 add [pa_Cylinders],    ch;//byte add, low byte is empty	
;-260 		

;-261 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params13
;-262 			cputs(" no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-263 			return 1;

 mov ax, 1
 jmp .retnParams
;-264 			}

;-265 		cputs("CylHeadSec=");		printunsign(pa_Cylinders);

.Params13:
 push Params_2
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-266 		putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-267 		putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-268 		cputs(", NoDrives=");		printhex8(pa_Attached);

 push Params_3
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-269 		putch('.');

 push 46
 call putch
 add  sp, 2
;-270 	}

;-271 	return 0;

.Params12:
 mov ax, 0
 jmp .retnParams
;-272 }

;-273 

;-274 int Status(drive) {

 .retnParams:
 ret
Params_0 db "Drive Params:",0
Params_1 db " no hard disk found",0
Params_2 db "CylHeadSec=",0
Params_3 db ", NoDrives=",0
ENDP

Status: PROC
;-275 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;62 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-276 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-277 	BIOS_Status=Int13hfunction(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-278 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status14
 call Int13hError
;-279 	printhex16(BIOS_Status);	

.Status14:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-280 }	

;-281 

;-282 int getPartitionData(int PartNo) {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

getPartitionData: PROC
;-283 	unsigned int j; char c; char *p;

;-284 	j = PartNo << 4;

;Function : getPartitionData, Number local Var: 4
; # type sign width local variables
;62 var sign word PartNo = bp+4
;63 var unsg word j = bp-2
;64 var sign byte c = bp-4
;65 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [bp+4]
 shl ax, 4
 mov [bp-2], ax
;-285 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-286 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-287 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-288 	ah=0;//next line convert byte to word

 mov  ah, 0
;-289 	pt_StartCylinder=pt_StartSector;	

 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-290 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-291 //	pt_StartSector++;//Sector start with 1 todo

;-292 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-293 	pt_StartCylinder = pt_StartCylinder << 2;//OK no short cut!	

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-294 	j++;

 inc  word[bp-2]
;-295 	ah=0;//byte to word

 mov  ah, 0
;-296 	pt_StartCylinder=DiskBuf[j] + pt_StartCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-297 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-298 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB	

;-299 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-300 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-301 	ah=0;//next line convert byte to word

 mov  ah, 0
;-302 	pt_EndCylinder=pt_EndSector;//see next 5 line		

 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-303 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-304 //	pt_EndSector++;//Sector start with 1 todo

;-305 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-306 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!	

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-307 	j++;

 inc  word[bp-2]
;-308 	ah=0;//byte to word

 mov  ah, 0
;-309 	pt_EndCylinder=DiskBuf[j] + pt_EndCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-310 	j++;

 inc  word[bp-2]
;-311 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-312 	memcpy(&pt_HiddenSector, p, 8);	

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-313 //	j += 8;//next partition entry

;-314 }

;-315 	

;-316 int printPartitionData(int PartNo) {

 LEAVE
 ret
ENDP

printPartitionData: PROC
;-317 	unsigned long Lo;

;-318 	putch(10);		

;Function : printPartitionData, Number local Var: 2
; # type sign width local variables
;62 var sign word PartNo = bp+4
;63 var unsg long Lo = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-319 	cputs("No=");			printunsign(PartNo);

 push printPartitionData_0
 call cputs
 add  sp, 2
 push word [bp+4]
 call printunsign
 add  sp, 2
;-320 	cputs(",Boot=");		printhex8(pt_Bootable);

 push printPartitionData_1
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-321 	cputs(" ID=");			printunsign(pt_FileSystem);

 push printPartitionData_2
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-322 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push printPartitionData_3
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-323 	cputs("/");				printunsign(pt_StartSector);	

 push printPartitionData_4
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-324 	cputs("/");				printunsign(pt_StartCylinder);

 push printPartitionData_5
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-325 	cputs("-");				printunsign(pt_EndHead);

 push printPartitionData_6
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-326 	cputs("/");				printunsign(pt_EndSector);	

 push printPartitionData_7
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-327 	cputs("/");				printunsign(pt_EndCylinder);

 push printPartitionData_8
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-328 	cputs(",Start=");		printlong(&pt_HiddenSector);

 push printPartitionData_9
 call cputs
 add  sp, 2
 lea  ax, [pt_HiddenSector]
 push ax
 call printlong
 add  sp, 2
;-329 	cputs(",Len=");			printlong(&pt_PartLen);

 push printPartitionData_10
 call cputs
 add  sp, 2
 lea  ax, [pt_PartLen]
 push ax
 call printlong
 add  sp, 2
;-330 	cputs(" Sec=");

 push printPartitionData_11
 call cputs
 add  sp, 2
;-331 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-332 	printlong(&Lo);

 lea  ax, [bp-4]
 push ax
 call printlong
 add  sp, 2
;-333 	cputs(" MByte.");	

 push printPartitionData_12
 call cputs
 add  sp, 2
;-334 	putch(10);

 push 10
 call putch
 add  sp, 2
;-335 }

;-336 int checkBootSign() {

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
;-337 	char c; char d; int i; char ok;

;-338 	cputs(",magic number=");	

;Function : checkBootSign, Number local Var: 4
; # type sign width local variables
;62 var sign byte c = bp-2
;63 var sign byte d = bp-4
;64 var sign word i = bp-6
;65 var sign byte ok = bp-8;
 ENTER  8,0
 push checkBootSign_0
 call cputs
 add  sp, 2
;-339 	i=510;		c = DiskBuf[i];		printhex8(c);

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
;-340 	i++;		d = DiskBuf[i];		printhex8(d);

 inc  word[bp-6]
 mov bx, [bp-6]
 mov al, [DiskBuf + bx]
 mov [bp-4], al
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-341 	ok=0;

 mov ax, 0
 mov [bp-8], al
;-342 	if (c == 0x55) ok=1;

 mov al, [bp-2]
 cmp al, 85
 jne .checkBootSign15
 mov ax, 1
 mov [bp-8], al
;-343 	if (d == 0xAA) ok=1;

.checkBootSign15:
 mov al, [bp-4]
 cmp al, 170
 jne .checkBootSign16
 mov ax, 1
 mov [bp-8], al
;-344 	if (ok) {

.checkBootSign16:
 mov al, [bp-8]
 or  al, al
 je .checkBootSign17
;-345 		cputs(" found.");

 push checkBootSign_1
 call cputs
 add  sp, 2
;-346 		return 1;

 mov ax, 1
 jmp .retncheckBootSign
;-347 		}

;-348 	else {

 jmp .checkBootSign18
.checkBootSign17:
;-349 		cputs(" NOT found.");

 push checkBootSign_2
 call cputs
 add  sp, 2
;-350 		return 0;	

 mov ax, 0
 jmp .retncheckBootSign
;-351 	}

;-352 }	

.checkBootSign18:
;-353 	

;-354 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db ",magic number=",0
checkBootSign_1 db " found.",0
checkBootSign_2 db " NOT found.",0
ENDP

readMBR: PROC
;-355 	int isFAT; int PartNo;

;-356 	isFAT=0;

;Function : readMBR, Number local Var: 2
; # type sign width local variables
;62 var sign word isFAT = bp-2
;63 var sign word PartNo = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-2], ax
;-357 	PartNo=0;

 mov ax, 0
 mov [bp-4], ax
;-358 	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf

 mov [DiskBufSeg], ds; //Offset is in DiskBuf
;-359 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-360 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR19
;-361 		Int13hError();

 call Int13hError
;-362 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-363 		}

;-364 	else {	

 jmp .readMBR20
.readMBR19:
;-365 		putch(10);

 push 10
 call putch
 add  sp, 2
;-366 		cputs("Read partition status:");

 push readMBR_0
 call cputs
 add  sp, 2
;-367 		if(checkBootSign()==0) return 0;	

 call checkBootSign
 cmp al, 0
 jne .readMBR21
 mov ax, 0
 jmp .retnreadMBR
;-368 		do {

.readMBR21:
.readMBR22:
;-369 			getPartitionData(PartNo);

 push word [bp-4]
 call getPartitionData
 add  sp, 2
;-370 			printPartitionData(PartNo);

 push word [bp-4]
 call printPartitionData
 add  sp, 2
;-371 			

;-372 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR23
;-373 				cputs("Boot partition found");

 push readMBR_1
 call cputs
 add  sp, 2
;-374 				if (pt_FileSystem == 1) {

 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR24
;-375 					cputs(", FAT12 partition < 32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-376 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-377 					}

;-378 				if (pt_FileSystem == 4) {

.readMBR24:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR25
;-379 					cputs(", small FAT16 partition < 32MB");

 push readMBR_3
 call cputs
 add  sp, 2
;-380 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-381 					}

;-382 				if (pt_FileSystem == 6) {

.readMBR25:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR26
;-383 					cputs(", large FAT16 partition < 2GB");

 push readMBR_4
 call cputs
 add  sp, 2
;-384 					isFAT=6;

 mov ax, 6
 mov [bp-2], ax
;-385 					}

;-386 				PartNo=99;//end of loop	

.readMBR26:
 mov ax, 99
 mov [bp-4], ax
;-387 			}

;-388 			PartNo ++;

.readMBR23:
 inc  word[bp-4]
;-389 		} while (PartNo <4);

 mov ax, [bp-4]
 cmp ax, 4
 jge .readMBR27
 jmp .readMBR22
.readMBR27:
;-390 		if (isFAT==0) cputs(" no active FAT partition found");

 mov ax, [bp-2]
 cmp ax, 0
 jne .readMBR28
 push readMBR_5
 call cputs
 add  sp, 2
;-391 		return isFAT;

.readMBR28:
 mov ax, [bp-2]
 jmp .retnreadMBR
;-392 	}	

;-393 }

.readMBR20:
;-394 

;-395 int getBootSector() {

 .retnreadMBR:
 LEAVE
 ret
readMBR_0 db "Read partition status:",0
readMBR_1 db "Boot partition found",0
readMBR_2 db ", FAT12 partition < 32MB",0
readMBR_3 db ", small FAT16 partition < 32MB",0
readMBR_4 db ", large FAT16 partition < 2GB",0
readMBR_5 db " no active FAT partition found",0
ENDP

getBootSector: PROC
;-396 	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf

 mov [DiskBufSeg], ds; //Offset is in DiskBuf
;-397   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

;-398   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push 1
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 push word [pt_StartCylinder]
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 mov al, byte [Drive]
 mov ah, 0
 push ax
 push 2
 call DiskSectorReadWrite
 add  sp, 16
 mov word [BIOS_Status], ax
;-399 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector29
;-400 		Int13hError();

 call Int13hError
;-401 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-402 		}

;-403 	else {	

 jmp .getBootSector30
.getBootSector29:
;-404 		putch(10);

 push 10
 call putch
 add  sp, 2
;-405 		cputs("Read boot sector status:");

 push getBootSector_0
 call cputs
 add  sp, 2
;-406 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-407 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp ax, 0
 jne .getBootSector31
 mov ax, 0
 jmp .retngetBootSector
;-408 		

;-409 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector31:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-410 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector32
 push getBootSector_1
 call cputs
 add  sp, 2
;-411 		putch(10);

.getBootSector32:
 push 10
 call putch
 add  sp, 2
;-412 		cputs("OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push getBootSector_2
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-413 		putch(10);

 push 10
 call putch
 add  sp, 2
;-414 		cputs("Bytes per sector(512)=");printunsign(bs_sect_size);	

 push getBootSector_3
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-415 		cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);	

 push getBootSector_4
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-416 		putch(10);

 push 10
 call putch
 add  sp, 2
;-417 		cputs("Reserved sectors=");printunsign(bs_res_sects);	

 push getBootSector_5
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-418 		cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);	

 push getBootSector_6
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-419 		putch(10);

 push 10
 call putch
 add  sp, 2
;-420 		cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push getBootSector_7
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-421 		cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push getBootSector_8
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-422 		putch(10);

 push 10
 call putch
 add  sp, 2
;-423 		cputs("Media descriptor(F8h for HD)=");printhex8(bs_media_desc);

 push getBootSector_9
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-424 		cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push getBootSector_10
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-425 		putch(10);

 push 10
 call putch
 add  sp, 2
;-426 		cputs("sectors per track=");printunsign(bs_num_sects);

 push getBootSector_11
 call cputs
 add  sp, 2
 push word [bs_num_sects]
 call printunsign
 add  sp, 2
;-427 		cputs(".number of heads=");printunsign(bs_num_sides);

 push getBootSector_12
 call cputs
 add  sp, 2
 push word [bs_num_sides]
 call printunsign
 add  sp, 2
;-428 		putch(10);

 push 10
 call putch
 add  sp, 2
;-429 		cputs("hidden sectors(long)=");printlong(&bs_hid_sects);

 push getBootSector_13
 call cputs
 add  sp, 2
 lea  ax, [bs_hid_sects]
 push ax
 call printlong
 add  sp, 2
;-430 		cputs(".sectors(long)=");printlong(&bs_tot_sect32);

 push getBootSector_14
 call cputs
 add  sp, 2
 lea  ax, [bs_tot_sect32]
 push ax
 call printlong
 add  sp, 2
;-431 		putch(10);

 push 10
 call putch
 add  sp, 2
;-432 		cputs("physical drive number=");printunsign(bs_drive_num);

 push getBootSector_15
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-433 		cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push getBootSector_16
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-434 		putch(10);

 push 10
 call putch
 add  sp, 2
;-435 		cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push getBootSector_17
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-436 		cputs(".Volume serial(long)=");printlong(&bs_serial_num);

 push getBootSector_18
 call cputs
 add  sp, 2
 lea  ax, [bs_serial_num]
 push ax
 call printlong
 add  sp, 2
;-437 		putch(10);

 push 10
 call putch
 add  sp, 2
;-438 		cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push getBootSector_19
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-439 		cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);		

 push getBootSector_20
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-440 	}

;-441 	return 1;

.getBootSector30:
 mov ax, 1
 jmp .retngetBootSector
;-442 }

;-443 

;-444 int calcFATtype() {

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
;-445 	char c;

;-446 	

;-447 	FatStartSector=bs_res_sects;	

;Function : calcFATtype, Number local Var: 1
; # type sign width local variables
;62 var sign byte c = bp-2;
 ENTER  2,0
 mov ax, [bs_res_sects]
 mov word [FatStartSector], ax
;-448 	FatSectors=bs_fat_size;	

 mov ax, [bs_fat_size]
 mov word [FatSectors], ax
;-449 	if (bs_num_fats == 2) FatSectors=FatSectors+FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .calcFATtype33
 mov ax, [FatSectors]
 add ax, [FatSectors]
 mov word [FatSectors], ax
;-450 

;-451 	RootDirStartSector=FatStartSector + FatSectors;

.calcFATtype33:
 mov ax, [FatStartSector]
 add ax, [FatSectors]
 mov word [RootDirStartSector], ax
;-452 	RootDirSectors= bs_root_entr << 5;// *32	

 mov ax, [bs_root_entr]
 shl ax, 5
 mov word [RootDirSectors], ax
;-453 	RootDirSectors= RootDirSectors / bs_sect_size;

 mov ax, [RootDirSectors]
 mov bx, [bs_sect_size]
 mov dx, 0
 div bx
 mov word [RootDirSectors], ax
;-454 

;-455 	DataStartSector=RootDirStartSector + RootDirSectors;

 mov ax, [RootDirStartSector]
 add ax, [RootDirSectors]
 mov word [DataStartSector], ax
;-456 	if (bs_tot_sect16 !=0) {

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .calcFATtype34
;-457 		DataSectors16=bs_tot_sect16 - DataStartSector;

 mov ax, [bs_tot_sect16]
 sub ax, [DataStartSector]
 mov word [DataSectors16], ax
;-458 		DataSectors32=0;//todo only word 0

 mov ax, 0
 mov dword [DataSectors32], eax
;-459 		cputs("FAT < 32 MB NOT supported");

 push calcFATtype_0
 call cputs
 add  sp, 2
;-460 		trueFATtype=0;

 mov ax, 0
 mov byte [trueFATtype], al
;-461 		return;

 jmp .retncalcFATtype
;-462 		}

;-463 	else {

 jmp .calcFATtype35
.calcFATtype34:
;-464 		asm xor eax, eax ;clear bit 15-31

 xor eax, eax ;clear bit 15-31
;-465 		templong=DataStartSector;//convert word to dword		

 mov ax, [DataStartSector]
 mov dword [templong], eax
;-466 		DataSectors32=bs_tot_sect32 - templong;//sub 32bit		

 mov eax, [bs_tot_sect32]
 sub eax, [templong]
 mov dword [DataSectors32], eax
;-467 		DataSectors16=0;	

 mov ax, 0
 mov word [DataSectors16], ax
;-468 		}

;-469 //	CountofClusters=DataSectors32 / bs_clust_size;only int divisor

;-470 		if (bs_clust_size == 32) CountofClusters=DataSectors32 >> 5;

.calcFATtype35:
 mov al, [bs_clust_size]
 cmp al, 32
 jne .calcFATtype36
 mov eax, [DataSectors32]
 shr eax, 5
 mov dword [CountofClusters], eax
;-471 		if (bs_clust_size == 16) CountofClusters=DataSectors32 >> 4;

.calcFATtype36:
 mov al, [bs_clust_size]
 cmp al, 16
 jne .calcFATtype37
 mov eax, [DataSectors32]
 shr eax, 4
 mov dword [CountofClusters], eax
;-472 		if (bs_clust_size ==  8) CountofClusters=DataSectors32 >> 3;

.calcFATtype37:
 mov al, [bs_clust_size]
 cmp al, 8
 jne .calcFATtype38
 mov eax, [DataSectors32]
 shr eax, 3
 mov dword [CountofClusters], eax
;-473 		if (bs_clust_size ==  4) CountofClusters=DataSectors32 >> 2;

.calcFATtype38:
 mov al, [bs_clust_size]
 cmp al, 4
 jne .calcFATtype39
 mov eax, [DataSectors32]
 shr eax, 2
 mov dword [CountofClusters], eax
;-474 		if (bs_clust_size ==  2) CountofClusters=DataSectors32 >> 1;

.calcFATtype39:
 mov al, [bs_clust_size]
 cmp al, 2
 jne .calcFATtype40
 mov eax, [DataSectors32]
 shr eax, 1
 mov dword [CountofClusters], eax
;-475 		if (bs_clust_size ==  1) CountofClusters=DataSectors32;

.calcFATtype40:
 mov al, [bs_clust_size]
 cmp al, 1
 jne .calcFATtype41
 mov eax, [DataSectors32]
 mov dword [CountofClusters], eax
;-476 

;-477 		putch(10);

.calcFATtype41:
 push 10
 call putch
 add  sp, 2
;-478 		cputs("FatStartSector:");	printunsign(FatStartSector);

 push calcFATtype_1
 call cputs
 add  sp, 2
 push word [FatStartSector]
 call printunsign
 add  sp, 2
;-479 		cputs(", FatSectors=");		printunsign(FatSectors);

 push calcFATtype_2
 call cputs
 add  sp, 2
 push word [FatSectors]
 call printunsign
 add  sp, 2
;-480 		putch(10);

 push 10
 call putch
 add  sp, 2
;-481 		cputs("RootDirStartSector="); printunsign(RootDirStartSector);

 push calcFATtype_3
 call cputs
 add  sp, 2
 push word [RootDirStartSector]
 call printunsign
 add  sp, 2
;-482 		cputs(", RootDirSectors=");	printunsign(RootDirSectors);

 push calcFATtype_4
 call cputs
 add  sp, 2
 push word [RootDirSectors]
 call printunsign
 add  sp, 2
;-483 		putch(10);

 push 10
 call putch
 add  sp, 2
;-484 		cputs("DataStartSector=");	printunsign(DataStartSector);

 push calcFATtype_5
 call cputs
 add  sp, 2
 push word [DataStartSector]
 call printunsign
 add  sp, 2
;-485 		cputs(", DataSectors16=");	printunsign(DataSectors16);	

 push calcFATtype_6
 call cputs
 add  sp, 2
 push word [DataSectors16]
 call printunsign
 add  sp, 2
;-486 		cputs(", DataSectors32=");	printlong(&DataSectors32);			

 push calcFATtype_7
 call cputs
 add  sp, 2
 lea  ax, [DataSectors32]
 push ax
 call printlong
 add  sp, 2
;-487 		putch(10);

 push 10
 call putch
 add  sp, 2
;-488 		cputs("CountofClusters=");	printlong(&CountofClusters);

 push calcFATtype_8
 call cputs
 add  sp, 2
 lea  ax, [CountofClusters]
 push ax
 call printlong
 add  sp, 2
;-489 		cputs(", trueFATtype=FAT"); 

 push calcFATtype_9
 call cputs
 add  sp, 2
;-490 		

;-491 		asm xor eax, eax ;clear bit 15-31

 xor eax, eax ;clear bit 15-31
;-492 		templong=4086;

 mov ax, 4086
 mov dword [templong], eax
;-493 		if (CountofClusters < templong) {

 mov eax, [CountofClusters]
 cmp eax, [templong]
 jge .calcFATtype42
;-494 			trueFATtype=1; 

 mov ax, 1
 mov byte [trueFATtype], al
;-495 			cputs("12"); 

 push calcFATtype_10
 call cputs
 add  sp, 2
;-496 			return;

 jmp .retncalcFATtype
;-497 			}

;-498 		asm xor eax, eax ;clear bit 15-31			

.calcFATtype42:
 xor eax, eax ;clear bit 15-31			
;-499 		templong = 65525;			

 mov ax, 65525
 mov dword [templong], eax
;-500 		if (CountofClusters > templong) {

 mov eax, [CountofClusters]
 cmp eax, [templong]
 jle .calcFATtype43
;-501 			trueFATtype=11; 

 mov ax, 11
 mov byte [trueFATtype], al
;-502 			cputs("32"); 

 push calcFATtype_11
 call cputs
 add  sp, 2
;-503 			return;

 jmp .retncalcFATtype
;-504 			}

;-505 			trueFATtype=6;

.calcFATtype43:
 mov ax, 6
 mov byte [trueFATtype], al
;-506 			cputs("16");

 push calcFATtype_12
 call cputs
 add  sp, 2
;-507 }//trueFATtype: 1=FAT12,6=FAT16,11=FAT32

;-508 

;-509 int Int13hExt() {

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
calcFATtype_9 db ", trueFATtype=FAT",0
calcFATtype_10 db "12",0
calcFATtype_11 db "32",0
calcFATtype_12 db "16",0
ENDP

Int13hExt: PROC
;-510 	bx=0x55AA;

 mov  bx, 21930
;-511 	BIOS_Status=Int13hfunction(Drive, 0x41);	

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-512 	asm mov [vAX], ax;

 mov [vAX], ax;
;-513 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-514 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported 			
;-515 	putch(10);

 push 10
 call putch
 add  sp, 2
;-516 	cputs("Int13h 41hExt (AX=3000=ERROR)=");printhex16(vAX);

 push Int13hExt_0
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-517 	cputs(", BIOS_Status=");				printhex16(BIOS_Status);

 push Int13hExt_1
 call cputs
 add  sp, 2
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-518 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt44
;-519 		cputs(" Ext not present");	

 push Int13hExt_2
 call cputs
 add  sp, 2
;-520 		Int13hError();	

 call Int13hError
;-521 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-522 		}

;-523 	else {

 jmp .Int13hExt45
.Int13hExt44:
;-524 		cputs(" BX(AA55)=");				printhex16(vBX);

 push Int13hExt_3
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-525 		cputs(" CX=");						printhex16(vCX);

 push Int13hExt_4
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-526 		}

;-527 	return 0;			

.Int13hExt45:
 mov ax, 0
 jmp .retnInt13hExt
;-528 }	

;-529 

;-530 int readLogical() {

 .retnInt13hExt:
 ret
Int13hExt_0 db "Int13h 41hExt (AX=3000=ERROR)=",0
Int13hExt_1 db ", BIOS_Status=",0
Int13hExt_2 db " Ext not present",0
Int13hExt_3 db " BX(AA55)=",0
Int13hExt_4 db " CX=",0
ENDP

readLogical: PROC
;-531 	

;-532 	

;-533 	

;-534 }

;-535 	

;-536 int mdump(unsigned char *adr, unsigned int len ) {

 ret
ENDP

mdump: PROC
;-537     unsigned char c; int i; int j; int k;

;-538     j=0;

;Function : mdump, Number local Var: 6
; # type sign width local variables
;62 ptr unsg byte adr = bp+4
;63 var unsg word len = bp+6
;64 var unsg byte c = bp-2
;65 var sign word i = bp-4
;66 var sign word j = bp-6
;67 var sign word k = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-6], ax
;-539     k=0;

 mov ax, 0
 mov [bp-8], ax
;-540     while (j < len ) {

.mdump46:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump47
;-541 	    k++;; 

 inc  word[bp-8]
;-542 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump48
;-543 		    getkey();

 call getkey
;-544 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-545 		    }

;-546         putch(10);

.mdump48:
 push 10
 call putch
 add  sp, 2
;-547         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-548         putch(':');

 push 58
 call putch
 add  sp, 2
;-549         i=0;

 mov ax, 0
 mov [bp-4], ax
;-550         while (i < 16) {

.mdump49:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump50
;-551             putch(' ');

 push 32
 call putch
 add  sp, 2
;-552             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-553             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-554             adr++;

 inc  word[bp+4]
;-555             i++;

 inc  word[bp-4]
;-556             j++;

 inc  word[bp-6]
;-557             }

;-558         putch(' ');

 jmp .mdump49
.mdump50:
 push 32
 call putch
 add  sp, 2
;-559         adr -=16;

 sub  word[bp+4], 16
;-560         i=0;

 mov ax, 0
 mov [bp-4], ax
;-561         while(i < 16) {

.mdump51:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump52
;-562             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-563             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump53
 push 46
 call putch
 add  sp, 2
;-564                 else putch(c);

 jmp .mdump54
.mdump53:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-565             adr++;

.mdump54:
 inc  word[bp+4]
;-566             i++;

 inc  word[bp-4]
;-567         }

;-568     }

 jmp .mdump51
.mdump52:
;-569 }

 jmp .mdump46
.mdump47:
;-570 

;-571 //------------------------------------ main ---------------

;-572 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-573 	int res;

;-574 	Drive=0x80;

;Function : main, Number local Var: 1
; # type sign width local variables
;62 var sign word res = bp-2;
 ENTER  2,0
 mov ax, 128
 mov byte [Drive], al
;-575 

;-576 	if (Params()) return 1;//no hard disk

 call Params
 or  al, al
 je .main55
 mov ax, 1
 jmp .retnmain
;-577 	res=readMBR();//0=error,1=FAT12,6=FAT16,11=FAT32

.main55:
 call readMBR
 mov [bp-2], ax
;-578 	if (res == 0) return 1;

 mov ax, [bp-2]
 cmp ax, 0
 jne .main56
 mov ax, 1
 jmp .retnmain
;-579 //	mdump(DiskBuf, 512);

;-580 //	Int13hExt(Drive);

;-581 	if(getBootSector()==0) return 1;

.main56:
 call getBootSector
 cmp ax, 0
 jne .main57
 mov ax, 1
 jmp .retnmain
;-582 //	mdump(DiskBuf, 512);

;-583 	calcFATtype();//set trueFATtype: 1=FAT12,6=FAT16,11=FAT32

.main57:
 call calcFATtype
;-584 	if(trueFATtype != 6) return 1;

 mov al, [trueFATtype]
 cmp al, 6
 je  .main58
 mov ax, 1
 jmp .retnmain
;-585 	Int13hExt();

.main58:
 call Int13hExt
;-586 }

 .retnmain:
 LEAVE
 ret
ENDP
;Glob. variables:61 (400):672 (4000), Functions:29 (300):297 (3000)
;Lines:587, Constant: 1000 (3000), stacksize: 56831