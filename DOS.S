;PLA compiler A.COM V1.1.2, Input: DOS.C, Output: DOS.S
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

;-8 unsigned int vAX ;unsigned int vBX ;unsigned int vCX; unsigned int vDX;

vAX dw 0
vBX dw 0
vCX dw 0
vDX dw 0
;-9 unsigned int vSP; unsigned int vBP; unsigned int vCS; unsigned int vDS;

vSP dw 0
vBP dw 0
vCS dw 0
vDS dw 0
;-10 unsigned int vSS; unsigned int vES; //debugging

vSS dw 0
vES dw 0
;-11 

;-12 unsigned char DOS_ERR;

DOS_ERR db 0
;-13 unsigned char BIOS_ERR;

BIOS_ERR db 0
;-14 unsigned int  BIOS_Status;

BIOS_Status dw 0
;-15 

;-16 unsigned char DiskBuf [512];

section .bss
absolute 8192
DiskBuf resb 512
section .text
;-17 unsigned int  DiskBufSeg;

DiskBufSeg dw 0
;-18 unsigned char Drive=0x80;

Drive db 128
;-19 unsigned long Sectors_to_read;//for readLogical

Sectors_to_read dd 0
;-20 

;-21 //Params from int13h, Function 8

;-22 unsigned int  pa_Cylinders;

pa_Cylinders dw 0
;-23 unsigned char pa_Sectors;

pa_Sectors db 0
;-24 unsigned char pa_Heads;

pa_Heads db 0
;-25 unsigned char pa_Attached;

pa_Attached db 0
;-26 

;-27 //calcFATtype     

;-28 unsigned int FatStartSector;

FatStartSector dw 0
;-29 unsigned int FatSectors;

FatSectors dw 0
;-30 unsigned int RootDirStartSector;

RootDirStartSector dw 0
;-31 unsigned int RootDirSectors;

RootDirSectors dw 0
;-32 unsigned int DataStartSector;

DataStartSector dw 0
;-33 unsigned long DataSectors32;

DataSectors32 dd 0
;-34 unsigned long CountofClusters;

CountofClusters dd 0
;-35 char          trueFATtype;

trueFATtype db 0
;-36 unsigned long Sectors_per_cylinder;

Sectors_per_cylinder dd 0
;-37 

;-38 //start hard disk partition structure 16 bytes in MBR. do not change

;-39 unsigned char pt_Bootable;		//80h = active partition, else 00

pt_Bootable db 0
;-40 unsigned char pt_StartHead;

pt_StartHead db 0
;-41 unsigned char pt_StartSector;	//bits 0-5

pt_StartSector db 0
;-42 unsigned int  pt_StartCylinder;	//bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-43 unsigned char pt_FileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=largeFAT16

pt_FileSystem db 0
;-44 unsigned char pt_EndHead;

pt_EndHead db 0
;-45 unsigned char pt_EndSector;		//bits 0-5

pt_EndSector db 0
;-46 unsigned int  pt_EndCylinder;	//bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-47 unsigned long pt_HiddenSector;	//sectors preceding partition

pt_HiddenSector dd 0
;-48 unsigned long pt_PartLen;    	//length of partition in sectors

pt_PartLen dd 0
;-49 //end hard disk partition structure

;-50 

;-51 //start boot BIOS Parameter Block structure. do not change

;-52 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-53 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-54 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-55 unsigned char bs_clust_size;// 13 sectors per cluster (1,2,4,..,128)

bs_clust_size db 0
;-56 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-57 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-58 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-59 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-60 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-61 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-62 unsigned int  bs_num_sects;	// 24 (DOS 3+)sectors per track 

bs_num_sects dw 0
;-63 unsigned int  bs_num_sides;	// 26 (DOS 3+)number of heads   

bs_num_sides dw 0
;-64 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors 

bs_hid_sects dd 0
;-65 unsigned long bs_tot_sect32;	// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-66 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-67 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-68 unsigned char bs_ext_signat;// 38 (DOS 4+) Extended signature,get next 3(29h)

bs_ext_signat db 0
;-69 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-70 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-71 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-72 // 62 end boot BIOS Parameter Block

;-73 

;-74 int test() {


test: PROC
;-75 

;-76 __asm{	

	
;-77 


;-78 }	}


;-79 

;-80 int writetty()     {//char in AL

 ret
ENDP

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
;-247 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-248 		// CX =       ---CH--- ---CL---

;-249 		// cylinder : 76543210 98

;-250 		// sector   :            543210	

;-251 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-252 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-253 //		pa_Sectors++;//1 to 64

;-254 	

;-255 		asm mov [pa_Cylinders],    cx	

 mov [pa_Cylinders],    cx	
;-256 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-257 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-258 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty	

 add [pa_Cylinders],    ch;//byte add, low byte is empty	
;-259 		

;-260 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
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

;-264 		cputs("CylHeadSec=");		printunsign(pa_Cylinders);

.Params13:
 push Params_2
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-265 		putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-266 		putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-267 		cputs(", NoDrives=");		printhex8  (pa_Attached);

 push Params_3
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
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
 ret
Params_0 db "Drive Params:",0
Params_1 db " no hard disk found",0
Params_2 db "CylHeadSec=",0
Params_3 db ", NoDrives=",0
ENDP

Status: PROC
;-274 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;62 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-275 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-276 	BIOS_Status=Int13hfunction(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hfunction
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

;-281 int getPartitionData(int PartNo) {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

getPartitionData: PROC
;-282 	unsigned int j; char c; char *p;

;-283 	j = PartNo << 4;

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
;-284 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-285 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-286 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-287 	pt_StartCylinder=(int)pt_StartSector;		

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-288 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-289 //	pt_StartSector++;//Sector start with 1 todo

;-290 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-291 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-292 	j++;

 inc  word[bp-2]
;-293 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-294 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-295 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB	

;-296 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-297 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-298 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line		

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-299 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-300 //	pt_EndSector++;//Sector start with 1 todo

;-301 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-302 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!	

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-303 	j++;

 inc  word[bp-2]
;-304 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-305 	j++;

 inc  word[bp-2]
;-306 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-307 	memcpy(&pt_HiddenSector, p, 8);	

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-308 }

;-309 	

;-310 int printPartitionData(int PartNo) {

 LEAVE
 ret
ENDP

printPartitionData: PROC
;-311 	unsigned long Lo;

;-312 	putch(10);		

;Function : printPartitionData, Number local Var: 2
; # type sign width local variables
;62 var sign word PartNo = bp+4
;63 var unsg long Lo = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-313 	cputs("No=");			printunsign(PartNo);

 push printPartitionData_0
 call cputs
 add  sp, 2
 push word [bp+4]
 call printunsign
 add  sp, 2
;-314 	cputs(",Boot=");		printhex8(pt_Bootable);

 push printPartitionData_1
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-315 	cputs(" ID=");			printunsign(pt_FileSystem);

 push printPartitionData_2
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-316 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push printPartitionData_3
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-317 	cputs("/");				printunsign(pt_StartSector);	

 push printPartitionData_4
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-318 	cputs("/");				printunsign(pt_StartCylinder);

 push printPartitionData_5
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-319 	cputs("-");				printunsign(pt_EndHead);

 push printPartitionData_6
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-320 	cputs("/");				printunsign(pt_EndSector);	

 push printPartitionData_7
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-321 	cputs("/");				printunsign(pt_EndCylinder);

 push printPartitionData_8
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-322 	cputs(",Start=");		printlong(&pt_HiddenSector);

 push printPartitionData_9
 call cputs
 add  sp, 2
 lea  ax, [pt_HiddenSector]
 push ax
 call printlong
 add  sp, 2
;-323 	cputs(",Len=");			printlong(&pt_PartLen);

 push printPartitionData_10
 call cputs
 add  sp, 2
 lea  ax, [pt_PartLen]
 push ax
 call printlong
 add  sp, 2
;-324 	cputs(" Sec=");

 push printPartitionData_11
 call cputs
 add  sp, 2
;-325 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-326 	printlong(&Lo);

 lea  ax, [bp-4]
 push ax
 call printlong
 add  sp, 2
;-327 	cputs(" MByte.");	

 push printPartitionData_12
 call cputs
 add  sp, 2
;-328 	putch(10);

 push 10
 call putch
 add  sp, 2
;-329 }

;-330 int checkBootSign() {

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
;-331 	char c; char d; int i; char ok;

;-332 	cputs(",magic number=");	

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
;-333 	i=510;		c = DiskBuf[i];		printhex8(c);

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
;-334 	i++;		d = DiskBuf[i];		printhex8(d);

 inc  word[bp-6]
 mov bx, [bp-6]
 mov al, [DiskBuf + bx]
 mov [bp-4], al
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-335 	ok=0;

 mov ax, 0
 mov [bp-8], al
;-336 	if (c == 0x55) ok=1;

 mov al, [bp-2]
 cmp al, 85
 jne .checkBootSign15
 mov ax, 1
 mov [bp-8], al
;-337 	if (d == 0xAA) ok=1;

.checkBootSign15:
 mov al, [bp-4]
 cmp al, 170
 jne .checkBootSign16
 mov ax, 1
 mov [bp-8], al
;-338 	if (ok) {

.checkBootSign16:
 mov al, [bp-8]
 or  al, al
 je .checkBootSign17
;-339 		cputs(" found.");

 push checkBootSign_1
 call cputs
 add  sp, 2
;-340 		return 1;

 mov ax, 1
 jmp .retncheckBootSign
;-341 		}

;-342 	else {

 jmp .checkBootSign18
.checkBootSign17:
;-343 		cputs(" NOT found.");

 push checkBootSign_2
 call cputs
 add  sp, 2
;-344 		return 0;	

 mov ax, 0
 jmp .retncheckBootSign
;-345 	}

;-346 }	

.checkBootSign18:
;-347 	

;-348 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db ",magic number=",0
checkBootSign_1 db " found.",0
checkBootSign_2 db " NOT found.",0
ENDP

readMBR: PROC
;-349 	int isFAT; int PartNo;

;-350 	isFAT=0;

;Function : readMBR, Number local Var: 2
; # type sign width local variables
;62 var sign word isFAT = bp-2
;63 var sign word PartNo = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-2], ax
;-351 	PartNo=0;

 mov ax, 0
 mov [bp-4], ax
;-352 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-353 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR19
;-354 		Int13hError();

 call Int13hError
;-355 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-356 		}

;-357 	else {	

 jmp .readMBR20
.readMBR19:
;-358 		putch(10);

 push 10
 call putch
 add  sp, 2
;-359 		cputs("Read partition status:");

 push readMBR_0
 call cputs
 add  sp, 2
;-360 		if(checkBootSign()==0) return 0;	

 call checkBootSign
 cmp al, 0
 jne .readMBR21
 mov ax, 0
 jmp .retnreadMBR
;-361 		do {

.readMBR21:
.readMBR22:
;-362 			getPartitionData(PartNo);

 push word [bp-4]
 call getPartitionData
 add  sp, 2
;-363 			printPartitionData(PartNo);

 push word [bp-4]
 call printPartitionData
 add  sp, 2
;-364 			

;-365 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR23
;-366 				cputs("Boot partition found");

 push readMBR_1
 call cputs
 add  sp, 2
;-367 				if (pt_FileSystem == 1) {

 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR24
;-368 					cputs(", FAT12 partition < 32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-369 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-370 					}

;-371 				if (pt_FileSystem == 4) {

.readMBR24:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR25
;-372 					cputs(", small FAT16 partition < 32MB");

 push readMBR_3
 call cputs
 add  sp, 2
;-373 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-374 					}

;-375 				if (pt_FileSystem == 6) {

.readMBR25:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR26
;-376 					cputs(", large FAT16 partition < 2GB");

 push readMBR_4
 call cputs
 add  sp, 2
;-377 					isFAT=6;

 mov ax, 6
 mov [bp-2], ax
;-378 					}

;-379 				PartNo=99;//end of loop	

.readMBR26:
 mov ax, 99
 mov [bp-4], ax
;-380 			}

;-381 			PartNo ++;

.readMBR23:
 inc  word[bp-4]
;-382 		} while (PartNo <4);

 mov ax, [bp-4]
 cmp ax, 4
 jge .readMBR27
 jmp .readMBR22
.readMBR27:
;-383 		if (isFAT==0) cputs(" no active FAT partition found");

 mov ax, [bp-2]
 cmp ax, 0
 jne .readMBR28
 push readMBR_5
 call cputs
 add  sp, 2
;-384 		return isFAT;

.readMBR28:
 mov ax, [bp-2]
 jmp .retnreadMBR
;-385 	}	

;-386 }

.readMBR20:
;-387 

;-388 int getBootSector() {

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
;-389   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

;-390   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-391 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector29
;-392 		Int13hError();

 call Int13hError
;-393 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-394 		}

;-395 	else {	

 jmp .getBootSector30
.getBootSector29:
;-396 		putch(10);

 push 10
 call putch
 add  sp, 2
;-397 		cputs("Read boot sector status:");

 push getBootSector_0
 call cputs
 add  sp, 2
;-398 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-399 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp ax, 0
 jne .getBootSector31
 mov ax, 0
 jmp .retngetBootSector
;-400 		

;-401 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector31:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-402 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector32
 push getBootSector_1
 call cputs
 add  sp, 2
;-403 		if (bs_jmp[2] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

.getBootSector32:
 mov bx, [vAX]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector33
 push getBootSector_2
 call cputs
 add  sp, 2
;-404 		putch(10);

.getBootSector33:
 push 10
 call putch
 add  sp, 2
;-405 		cputs("OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push getBootSector_3
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-406 		putch(10);

 push 10
 call putch
 add  sp, 2
;-407 		cputs("Bytes per sector(512)=");printunsign(bs_sect_size);	

 push getBootSector_4
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-408 		cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);	

 push getBootSector_5
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-409 		putch(10);

 push 10
 call putch
 add  sp, 2
;-410 		cputs("Reserved sectors=");printunsign(bs_res_sects);	

 push getBootSector_6
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-411 		cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);	

 push getBootSector_7
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-412 		putch(10);

 push 10
 call putch
 add  sp, 2
;-413 		cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push getBootSector_8
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-414 		cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push getBootSector_9
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-415 		putch(10);

 push 10
 call putch
 add  sp, 2
;-416 		cputs("Media descriptor(F8h for HD)=");printhex8(bs_media_desc);

 push getBootSector_10
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-417 		cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push getBootSector_11
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-418 		putch(10);

 push 10
 call putch
 add  sp, 2
;-419 		cputs("sectors per track=");printunsign(bs_num_sects);

 push getBootSector_12
 call cputs
 add  sp, 2
 push word [bs_num_sects]
 call printunsign
 add  sp, 2
;-420 		cputs(".number of heads=");printunsign(bs_num_sides);

 push getBootSector_13
 call cputs
 add  sp, 2
 push word [bs_num_sides]
 call printunsign
 add  sp, 2
;-421 		putch(10);

 push 10
 call putch
 add  sp, 2
;-422 		cputs("hidden sectors(long)=");printlong(&bs_hid_sects);

 push getBootSector_14
 call cputs
 add  sp, 2
 lea  ax, [bs_hid_sects]
 push ax
 call printlong
 add  sp, 2
;-423 		cputs(".sectors(long)=");printlong(&bs_tot_sect32);

 push getBootSector_15
 call cputs
 add  sp, 2
 lea  ax, [bs_tot_sect32]
 push ax
 call printlong
 add  sp, 2
;-424 		putch(10);

 push 10
 call putch
 add  sp, 2
;-425 		cputs("physical drive number=");printunsign(bs_drive_num);

 push getBootSector_16
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-426 		cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push getBootSector_17
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-427 		putch(10);

 push 10
 call putch
 add  sp, 2
;-428 		cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push getBootSector_18
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-429 		cputs(".Volume serial(long)=");printlong(&bs_serial_num);

 push getBootSector_19
 call cputs
 add  sp, 2
 lea  ax, [bs_serial_num]
 push ax
 call printlong
 add  sp, 2
;-430 		putch(10);

 push 10
 call putch
 add  sp, 2
;-431 		cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push getBootSector_20
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-432 		cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);		

 push getBootSector_21
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-433 	}

;-434 	return 1;

.getBootSector30:
 mov ax, 1
 jmp .retngetBootSector
;-435 }

;-436 

;-437 int calcFATtype() {	

 .retngetBootSector:
 ret
getBootSector_0 db "Read boot sector status:",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
getBootSector_3 db "OEM name (MSDOS5.0)=",0
getBootSector_4 db "Bytes per sector(512)=",0
getBootSector_5 db ".Sectors per cluster(1,,128)=",0
getBootSector_6 db "Reserved sectors=",0
getBootSector_7 db ".Number of FAT(1,2)=",0
getBootSector_8 db "Root directory entries(512)=",0
getBootSector_9 db ".Total sectors(0 if > 32MB=",0
getBootSector_10 db "Media descriptor(F8h for HD)=",0
getBootSector_11 db ".Sectors per FAT=",0
getBootSector_12 db "sectors per track=",0
getBootSector_13 db ".number of heads=",0
getBootSector_14 db "hidden sectors(long)=",0
getBootSector_15 db ".sectors(long)=",0
getBootSector_16 db "physical drive number=",0
getBootSector_17 db ".Windows NT check disk=",0
getBootSector_18 db "Extended signature(29h)=",0
getBootSector_19 db ".Volume serial(long)=",0
getBootSector_20 db "Volume label(NO NAME)=",0
getBootSector_21 db ".File system type(FAT16)=",0
ENDP

calcFATtype: PROC
;-438 	unsigned long templong;//converting word to dword

;-439 

;-440 	FatStartSector=bs_res_sects;	

;Function : calcFATtype, Number local Var: 1
; # type sign width local variables
;62 var unsg long templong = bp-4;
 ENTER  4,0
 mov ax, [bs_res_sects]
 mov word [FatStartSector], ax
;-441 	FatSectors=bs_fat_size;	

 mov ax, [bs_fat_size]
 mov word [FatSectors], ax
;-442 	if (bs_num_fats == 2) FatSectors=FatSectors+FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .calcFATtype34
 mov ax, [FatSectors]
 add ax, [FatSectors]
 mov word [FatSectors], ax
;-443 

;-444 	RootDirStartSector=FatStartSector + FatSectors;

.calcFATtype34:
 mov ax, [FatStartSector]
 add ax, [FatSectors]
 mov word [RootDirStartSector], ax
;-445 	RootDirSectors= bs_root_entr << 5;// *32	

 mov ax, [bs_root_entr]
 shl ax, 5
 mov word [RootDirSectors], ax
;-446 	RootDirSectors= RootDirSectors / bs_sect_size;

 mov ax, [RootDirSectors]
 xor dx, dx
 div word [bs_sect_size]
 mov word [RootDirSectors], ax
;-447 

;-448 	DataStartSector=RootDirStartSector + RootDirSectors;

 mov ax, [RootDirStartSector]
 add ax, [RootDirSectors]
 mov word [DataStartSector], ax
;-449 	templong=(long) DataStartSector;		

 xor eax, eax
 mov ax, [DataStartSector]
 mov [bp-4], eax
;-450 	

;-451 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;		

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .calcFATtype35
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-452 	DataSectors32=bs_tot_sect32 - templong;//sub 32bit		

.calcFATtype35:
 mov eax, [bs_tot_sect32]
 sub eax, [bp-4]
 mov dword [DataSectors32], eax
;-453 

;-454 	templong =(long) bs_clust_size;		

 xor eax, eax
 mov al, [bs_clust_size]
 mov [bp-4], eax
;-455 	CountofClusters=DataSectors32 / templong;

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [bp-4]
 mov dword [CountofClusters], eax
;-456 		

;-457 	Sectors_per_cylinder = bs_num_sects *  bs_num_sides;//d=w*w

 mov ax, [bs_num_sects]
;do not forget to save the high word:mov [Longvar+2],dx
 mul word [bs_num_sides]
 mov dword [Sectors_per_cylinder], eax
;-458 	asm mov [Sectors_per_cylinder + 2], dx;store high word

 mov [Sectors_per_cylinder + 2], dx;store high word
;-459 

;-460 	putch(10);

 push 10
 call putch
 add  sp, 2
;-461 	cputs("FatStartSector:");	printunsign(FatStartSector);

 push calcFATtype_0
 call cputs
 add  sp, 2
 push word [FatStartSector]
 call printunsign
 add  sp, 2
;-462 	cputs(", FatSectors=");		printunsign(FatSectors);

 push calcFATtype_1
 call cputs
 add  sp, 2
 push word [FatSectors]
 call printunsign
 add  sp, 2
;-463 	putch(10);

 push 10
 call putch
 add  sp, 2
;-464 	cputs("RootDirStartSector="); printunsign(RootDirStartSector);

 push calcFATtype_2
 call cputs
 add  sp, 2
 push word [RootDirStartSector]
 call printunsign
 add  sp, 2
;-465 	cputs(", RootDirSectors=");	printunsign(RootDirSectors);

 push calcFATtype_3
 call cputs
 add  sp, 2
 push word [RootDirSectors]
 call printunsign
 add  sp, 2
;-466 	putch(10);

 push 10
 call putch
 add  sp, 2
;-467 	cputs("DataStartSector=");	printunsign(DataStartSector);

 push calcFATtype_4
 call cputs
 add  sp, 2
 push word [DataStartSector]
 call printunsign
 add  sp, 2
;-468 	cputs(", DataSectors32=");	printlong(&DataSectors32);			

 push calcFATtype_5
 call cputs
 add  sp, 2
 lea  ax, [DataSectors32]
 push ax
 call printlong
 add  sp, 2
;-469 	putch(10);

 push 10
 call putch
 add  sp, 2
;-470 	cputs("CountofClusters=");	printlong(&CountofClusters);

 push calcFATtype_6
 call cputs
 add  sp, 2
 lea  ax, [CountofClusters]
 push ax
 call printlong
 add  sp, 2
;-471 	cputs(", Sectors_per_cylinder="); printlong(&Sectors_per_cylinder);

 push calcFATtype_7
 call cputs
 add  sp, 2
 lea  ax, [Sectors_per_cylinder]
 push ax
 call printlong
 add  sp, 2
;-472 	cputs(", trueFATtype=FAT"); 

 push calcFATtype_8
 call cputs
 add  sp, 2
;-473 	

;-474 	asm xor eax, eax ;clear bit 15-31			

 xor eax, eax ;clear bit 15-31			
;-475 	templong = 65525;			

 mov ax, 65525
 mov [bp-4], eax
;-476 	if (CountofClusters > templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jle .calcFATtype36
;-477 		trueFATtype=32; 

 mov ax, 32
 mov byte [trueFATtype], al
;-478 		cputs("32 NOT supported"); 

 push calcFATtype_9
 call cputs
 add  sp, 2
;-479 		return 1;

 mov ax, 1
 jmp .retncalcFATtype
;-480 		}

;-481 	asm xor eax, eax ;clear bit 15-31

.calcFATtype36:
 xor eax, eax ;clear bit 15-31
;-482 	templong=4086;

 mov ax, 4086
 mov [bp-4], eax
;-483 	if (CountofClusters < templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jge .calcFATtype37
;-484 		trueFATtype=12; 

 mov ax, 12
 mov byte [trueFATtype], al
;-485 		cputs("12"); 

 push calcFATtype_10
 call cputs
 add  sp, 2
;-486 		return 0;

 mov ax, 0
 jmp .retncalcFATtype
;-487 		}

;-488 	trueFATtype=16;

.calcFATtype37:
 mov ax, 16
 mov byte [trueFATtype], al
;-489 	cputs("16");

 push calcFATtype_11
 call cputs
 add  sp, 2
;-490 	return 0;

 mov ax, 0
 jmp .retncalcFATtype
;-491 }

;-492 

;-493 int Int13hExt() {

 .retncalcFATtype:
 LEAVE
 ret
calcFATtype_0 db "FatStartSector:",0
calcFATtype_1 db ", FatSectors=",0
calcFATtype_2 db "RootDirStartSector=",0
calcFATtype_3 db ", RootDirSectors=",0
calcFATtype_4 db "DataStartSector=",0
calcFATtype_5 db ", DataSectors32=",0
calcFATtype_6 db "CountofClusters=",0
calcFATtype_7 db ", Sectors_per_cylinder=",0
calcFATtype_8 db ", trueFATtype=FAT",0
calcFATtype_9 db "32 NOT supported",0
calcFATtype_10 db "12",0
calcFATtype_11 db "16",0
ENDP

Int13hExt: PROC
;-494 	bx=0x55AA;

 mov  bx, 21930
;-495 	BIOS_Status=Int13hfunction(Drive, 0x41);	

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-496 	asm mov [vAX], ax;

 mov [vAX], ax;
;-497 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-498 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported 			
;-499 	putch(10);

 push 10
 call putch
 add  sp, 2
;-500 	cputs("Int13h 41h Ext=");printhex16(vAX);

 push Int13hExt_0
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-501 	cputs(", BIOS_Status=");				printhex16(BIOS_Status);

 push Int13hExt_1
 call cputs
 add  sp, 2
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-502 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt38
;-503 		cputs(" Ext NOT present");	

 push Int13hExt_2
 call cputs
 add  sp, 2
;-504 		Int13hError();	

 call Int13hError
;-505 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-506 		}

;-507 	else {

 jmp .Int13hExt39
.Int13hExt38:
;-508 		cputs(" Extension found BX(AA55)=");printhex16(vBX);

 push Int13hExt_3
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-509 		cputs(" CX=");						printhex16(vCX);

 push Int13hExt_4
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-510 		}

;-511 	return 0;			

.Int13hExt39:
 mov ax, 0
 jmp .retnInt13hExt
;-512 }	

;-513 

;-514 int readLogical() {

 .retnInt13hExt:
 ret
Int13hExt_0 db "Int13h 41h Ext=",0
Int13hExt_1 db ", BIOS_Status=",0
Int13hExt_2 db " Ext NOT present",0
Int13hExt_3 db " Extension found BX(AA55)=",0
Int13hExt_4 db " CX=",0
ENDP

readLogical: PROC
;-515 	unsigned int track;

;-516 	Sectors_to_read = Sectors_to_read + bs_hid_sects;//d=d+d

;Function : readLogical, Number local Var: 1
; # type sign width local variables
;62 var unsg word track = bp-2;
 ENTER  2,0
 mov eax, [Sectors_to_read]
 add eax, [bs_hid_sects]
 mov dword [Sectors_to_read], eax
;-517 

;-518 //	track = Sectors_to_read / 

;-519 

;-520 

;-521 

;-522 

;-523 	DiskSectorReadWrite(2, bs_drive_num );

 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 push 2
 call DiskSectorReadWrite
 add  sp, 4
;-524 	

;-525 //int DiskSectorReadWrite(char rw, char drive, char head, int cyl, 

;-526 //char sector, char count, int BufSeg, int BufOfs)

;-527 	

;-528 }

;-529 	

;-530 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-531     unsigned char c; int i; int j; int k;

;-532     j=0;

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
;-533     k=0;

 mov ax, 0
 mov [bp-8], ax
;-534     while (j < len ) {

.mdump40:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump41
;-535 	    k++;; 

 inc  word[bp-8]
;-536 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump42
;-537 		    getkey();

 call getkey
;-538 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-539 		    }

;-540         putch(10);

.mdump42:
 push 10
 call putch
 add  sp, 2
;-541         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-542         putch(':');

 push 58
 call putch
 add  sp, 2
;-543         i=0;

 mov ax, 0
 mov [bp-4], ax
;-544         while (i < 16) {

.mdump43:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump44
;-545             putch(' ');

 push 32
 call putch
 add  sp, 2
;-546             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-547             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-548             adr++;

 inc  word[bp+4]
;-549             i++;

 inc  word[bp-4]
;-550             j++;

 inc  word[bp-6]
;-551             }

;-552         putch(' ');

 jmp .mdump43
.mdump44:
 push 32
 call putch
 add  sp, 2
;-553         adr -=16;

 sub  word[bp+4], 16
;-554         i=0;

 mov ax, 0
 mov [bp-4], ax
;-555         while(i < 16) {

.mdump45:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump46
;-556             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-557             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump47
 push 46
 call putch
 add  sp, 2
;-558                 else putch(c);

 jmp .mdump48
.mdump47:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-559             adr++;

.mdump48:
 inc  word[bp+4]
;-560             i++;

 inc  word[bp-4]
;-561         }

;-562     }

 jmp .mdump45
.mdump46:
;-563 }

 jmp .mdump40
.mdump41:
;-564 

;-565 //------------------------------------ main ---------------

;-566 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-567 	int res;

;-568 	Drive=0x80;

;Function : main, Number local Var: 1
; # type sign width local variables
;62 var sign word res = bp-2;
 ENTER  2,0
 mov ax, 128
 mov byte [Drive], al
;-569 	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf

 mov [DiskBufSeg], ds; //Offset is in DiskBuf
;-570 

;-571 	if (Params()) 			return 1;//no hard disk

 call Params
 or  al, al
 je .main49
 mov ax, 1
 jmp .retnmain
;-572 	res=readMBR();//0=error,1=FAT12,6=FAT16,11=FAT32

.main49:
 call readMBR
 mov [bp-2], ax
;-573 	if (res == 0) 			return 1;

 mov ax, [bp-2]
 cmp ax, 0
 jne .main50
 mov ax, 1
 jmp .retnmain
;-574 //	mdump(DiskBuf, 512);

;-575 //	Int13hExt(Drive);

;-576 	if(getBootSector()==0) 	return 1;

.main50:
 call getBootSector
 cmp ax, 0
 jne .main51
 mov ax, 1
 jmp .retnmain
;-577 //	mdump(DiskBuf, 512);

;-578 	if (calcFATtype())		return 1;

.main51:
 call calcFATtype
 or  al, al
 je .main52
 mov ax, 1
 jmp .retnmain
;-579 	if(trueFATtype != 16) 	return 1;

.main52:
 mov al, [trueFATtype]
 cmp al, 16
 je  .main53
 mov ax, 1
 jmp .retnmain
;-580 	Int13hExt();

.main53:
 call Int13hExt
;-581 }

 .retnmain:
 LEAVE
 ret
ENDP
;Glob. variables:61 (400):686 (4000), Functions:30 (300):302 (3000)
;Lines:582, Constant: 1052 (3000), stacksize: 56831