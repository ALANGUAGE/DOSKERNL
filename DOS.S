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
;-75 //CountofClusters=DataSectors32 / bs_serial_num;//only int divisor alllowed

;-76 

;-77 //CountofClusters=DataSectors32 % bs_serial_num;

;-78 

;-79 __asm{	

	
;-80 	div word 8				; F7 30

	div word 8				; F7 30
;-81 	div word [bs_clust_size]; F7 36 6C 01

	div word [bs_clust_size]; F7 36 6C 01
;-82 	div dword [bs_serial_num];66 F7 36 6C 01 dword

	div dword [bs_serial_num];66 F7 36 6C 01 dword
;-83 


;-84 	

	
;-85 	mul word 8				; F7 20 ????

	mul word 8				; F7 20 ????
;-86 	mul bx					; F7 E3

	mul bx					; F7 E3
;-87 	mul word [bs_clust_size]; F7 

	mul word [bs_clust_size]; F7 
;-88 	mul dword [bs_serial_num];

	mul dword [bs_serial_num];
;-89 }	}


;-90 

;-91 int writetty()     {//char in AL

 ret
ENDP

writetty: PROC
;-92     ah=0x0E;

 mov  ah, 14
;-93     push bx;

push bx;
;-94     bx=0;			//page in BH

 mov  bx, 0
;-95     inth 0x10;		//16

 int  16
;-96     pop bx;

pop bx;
;-97 }

;-98 int putch(char c)  {

 ret
ENDP

putch: PROC
;-99     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;62 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-100         al=13;

 mov  al, 13
;-101         writetty();

 call writetty
;-102     }

;-103     al=c;

.putch1:
 mov  al, [bp+4]
;-104     writetty();

 call writetty
;-105 }

;-106 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-107     char c;

;-108     while(*s) {

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
;-109         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-110         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-111         s++;

 inc  word[bp+4]
;-112     }

;-113 }

 jmp .cputs2
.cputs3:
;-114 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-115 	char c;

;-116 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;62 ptr sign byte s = bp+4
;63 var sign word len = bp+6
;64 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-117 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-118 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-119 		s++;

 inc  word[bp+4]
;-120 		len--;

 dec  word[bp+6]
;-121 	} while (len > 0);	

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-122 }

;-123 

;-124 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-125     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-126     inth 0x16;//AH=Scan code, AL=char

 int  22
;-127 }

;-128 int waitkey() {

 ret
ENDP

waitkey: PROC
;-129     ah=0x11;//get kbd status

 mov  ah, 17
;-130     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-131     //zero flag: 0=IS char, 1=NO char

;-132     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-133 }

;-134 int getkey() {

 ret
ENDP

getkey: PROC
;-135     waitkey();

 call waitkey
;-136     getch();

 call getch
;-137     ah=0;//clear scan code

 mov  ah, 0
;-138     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-139     //put ext code in AX

;-140 }

.getkey6:
;-141 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-142     getkey();

 call getkey
;-143     writetty();//destroys AH

 call writetty
;-144 }

;-145 

;-146 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-147     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;62 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-148     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-149     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-150 }

;-151 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-152     unsigned char nib;

;-153     nib = c >> 4; printhex4(nib);

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
;-154     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-155 }

;-156 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-157     unsigned int half;

;-158     half = i >>  8; printhex8(half);

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
;-159     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-160 }

;-161 

;-162 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-163     unsigned int e;

;-164     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;62 var unsg word n = bp+4
;63 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-165         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-166         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-167         }

;-168     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-169     n+='0';

 add  word[bp+4], 48
;-170     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-171 }

;-172 

;-173 int printlong(unsigned int *p) {

 LEAVE
 ret
ENDP

printlong: PROC
;-174 	unsigned int lo; unsigned int hi;

;-175 	lo = *p;

;Function : printlong, Number local Var: 3
; # type sign width local variables
;62 ptr unsg word p = bp+4
;63 var unsg word lo = bp-2
;64 var unsg word hi = bp-4;
 ENTER  4,0
 mov bx, [bp+4]
 mov ax, [bx]
 mov [bp-2], ax
;-176 	p +=2;

 add  word[bp+4], 2
;-177 	hi = *p;

 mov bx, [bp+4]
 mov ax, [bx]
 mov [bp-4], ax
;-178 	dx=hi;

 mov  dx, [bp-4]
;-179 	ax=lo;

 mov  ax, [bp-2]
;-180 __asm{	

	
;-181   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-182     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-183 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-184     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-185     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-186 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-187     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-188     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-189     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-190     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-191     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-192     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-193     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-194     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-195 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-196 }	writetty();		__asm{


 call writetty

;-197     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-198     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-199     jb      .b             ;Not yet	

    jb      .b             ;Not yet	
;-200 } 


;-201 }

;-202 

;-203 int memcpy(char *s, char *t, unsigned int i) {

 LEAVE
 ret
ENDP

memcpy: PROC
;-204 	unsigned int r;

;-205 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;62 ptr sign byte s = bp+4
;63 ptr sign byte t = bp+6
;64 var unsg word i = bp+8
;65 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-206 	do {

.memcpy9:
;-207 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-208 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-209 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy10
 jmp .memcpy9
.memcpy10:
;-210 	ax=r;//	return r;

 mov  ax, [bp-2]
;-211 }

;-212 

;-213 //--------------------------------  disk IO  -------------------

;-214 

;-215 int DiskSectorReadWrite(char rw, char drive, char head, int cyl, 

 LEAVE
 ret
ENDP

DiskSectorReadWrite: PROC
;-216 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-217 	BIOS_ERR=0;	

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
;-218 	dl=drive;

 mov  dl, [bp+6]
;-219 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-220 	es=BufSeg;

 mov  es, [bp+16]
;-221 	bx=BufOfs;

 mov  bx, [bp+18]
;-222 	cx=cyl;	

 mov  cx, [bp+10]
;-223 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-224 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-225 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-226 	cl += sector;

 add  cl, [bp+12]
;-227 	ch=cyl;//low byte of cyl in ch, word 2 byte	

 mov  ch, [bp+10]
;-228 	al=count;

 mov  al, [bp+14]
;-229 	ah=rw;

 mov  ah, [bp+4]
;-230 	inth 0x13;

 int  19
;-231     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-232 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-233 }

;-234 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-235 	BIOS_ERR=0;	

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;62 var sign byte drive = bp+4
;63 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-236 	dl=drive;

 mov  dl, [bp+4]
;-237 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-238 	inth 0x13;

 int  19
;-239     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-240 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-241 }

;-242 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-243 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-244 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-245 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-246 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-247 }	

;-248 

;-249 int Params() {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Params: PROC
;-250 	cputs("Drive Params:");

 push Params_0
 call cputs
 add  sp, 2
;-251 	BIOS_Status=Int13hfunction(Drive, 8);

 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-252 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params11
;-253 		Int13hError();

 call Int13hError
;-254 		return 1;

 mov ax, 1
 jmp .retnParams
;-255 		}

;-256 	else {

 jmp .Params12
.Params11:
;-257 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-258 //		pa_Heads++;

;-259 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-260 		// CX =       ---CH--- ---CL---

;-261 		// cylinder : 76543210 98

;-262 		// sector   :            543210	

;-263 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-264 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-265 //		pa_Sectors++;//1 to 64

;-266 	

;-267 		asm mov [pa_Cylinders],    cx	

 mov [pa_Cylinders],    cx	
;-268 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-269 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-270 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty	

 add [pa_Cylinders],    ch;//byte add, low byte is empty	
;-271 		

;-272 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params13
;-273 			cputs(" no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-274 			return 1;

 mov ax, 1
 jmp .retnParams
;-275 			}

;-276 		cputs("CylHeadSec=");		printunsign(pa_Cylinders);

.Params13:
 push Params_2
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-277 		putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-278 		putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-279 		cputs(", NoDrives=");		printhex8(pa_Attached);

 push Params_3
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-280 		putch('.');

 push 46
 call putch
 add  sp, 2
;-281 	}

;-282 	return 0;

.Params12:
 mov ax, 0
 jmp .retnParams
;-283 }

;-284 

;-285 int Status(drive) {

 .retnParams:
 ret
Params_0 db "Drive Params:",0
Params_1 db " no hard disk found",0
Params_2 db "CylHeadSec=",0
Params_3 db ", NoDrives=",0
ENDP

Status: PROC
;-286 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;62 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-287 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-288 	BIOS_Status=Int13hfunction(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-289 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status14
 call Int13hError
;-290 	printhex16(BIOS_Status);	

.Status14:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-291 }	

;-292 

;-293 int getPartitionData(int PartNo) {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

getPartitionData: PROC
;-294 	unsigned int j; char c; char *p;

;-295 	j = PartNo << 4;

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
;-296 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-297 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-298 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-299 	ah=0;//next line convert byte to word

 mov  ah, 0
;-300 	pt_StartCylinder=pt_StartSector;	

 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-301 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-302 //	pt_StartSector++;//Sector start with 1 todo

;-303 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-304 	pt_StartCylinder = pt_StartCylinder << 2;//OK no short cut!	

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-305 	j++;

 inc  word[bp-2]
;-306 	ah=0;//byte to word

 mov  ah, 0
;-307 	pt_StartCylinder=DiskBuf[j] + pt_StartCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-308 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-309 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB	

;-310 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-311 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-312 	ah=0;//next line convert byte to word

 mov  ah, 0
;-313 	pt_EndCylinder=pt_EndSector;//see next 5 line		

 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-314 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-315 //	pt_EndSector++;//Sector start with 1 todo

;-316 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-317 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!	

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-318 	j++;

 inc  word[bp-2]
;-319 	ah=0;//byte to word

 mov  ah, 0
;-320 	pt_EndCylinder=DiskBuf[j] + pt_EndCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-321 	j++;

 inc  word[bp-2]
;-322 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-323 	memcpy(&pt_HiddenSector, p, 8);	

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-324 //	j += 8;//next partition entry

;-325 }

;-326 	

;-327 int printPartitionData(int PartNo) {

 LEAVE
 ret
ENDP

printPartitionData: PROC
;-328 	unsigned long Lo;

;-329 	putch(10);		

;Function : printPartitionData, Number local Var: 2
; # type sign width local variables
;62 var sign word PartNo = bp+4
;63 var unsg long Lo = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-330 	cputs("No=");			printunsign(PartNo);

 push printPartitionData_0
 call cputs
 add  sp, 2
 push word [bp+4]
 call printunsign
 add  sp, 2
;-331 	cputs(",Boot=");		printhex8(pt_Bootable);

 push printPartitionData_1
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-332 	cputs(" ID=");			printunsign(pt_FileSystem);

 push printPartitionData_2
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-333 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push printPartitionData_3
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-334 	cputs("/");				printunsign(pt_StartSector);	

 push printPartitionData_4
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-335 	cputs("/");				printunsign(pt_StartCylinder);

 push printPartitionData_5
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-336 	cputs("-");				printunsign(pt_EndHead);

 push printPartitionData_6
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-337 	cputs("/");				printunsign(pt_EndSector);	

 push printPartitionData_7
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-338 	cputs("/");				printunsign(pt_EndCylinder);

 push printPartitionData_8
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-339 	cputs(",Start=");		printlong(&pt_HiddenSector);

 push printPartitionData_9
 call cputs
 add  sp, 2
 lea  ax, [pt_HiddenSector]
 push ax
 call printlong
 add  sp, 2
;-340 	cputs(",Len=");			printlong(&pt_PartLen);

 push printPartitionData_10
 call cputs
 add  sp, 2
 lea  ax, [pt_PartLen]
 push ax
 call printlong
 add  sp, 2
;-341 	cputs(" Sec=");

 push printPartitionData_11
 call cputs
 add  sp, 2
;-342 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-343 	printlong(&Lo);

 lea  ax, [bp-4]
 push ax
 call printlong
 add  sp, 2
;-344 	cputs(" MByte.");	

 push printPartitionData_12
 call cputs
 add  sp, 2
;-345 	putch(10);

 push 10
 call putch
 add  sp, 2
;-346 }

;-347 int checkBootSign() {

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
;-348 	char c; char d; int i; char ok;

;-349 	cputs(",magic number=");	

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
;-350 	i=510;		c = DiskBuf[i];		printhex8(c);

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
;-351 	i++;		d = DiskBuf[i];		printhex8(d);

 inc  word[bp-6]
 mov bx, [bp-6]
 mov al, [DiskBuf + bx]
 mov [bp-4], al
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-352 	ok=0;

 mov ax, 0
 mov [bp-8], al
;-353 	if (c == 0x55) ok=1;

 mov al, [bp-2]
 cmp al, 85
 jne .checkBootSign15
 mov ax, 1
 mov [bp-8], al
;-354 	if (d == 0xAA) ok=1;

.checkBootSign15:
 mov al, [bp-4]
 cmp al, 170
 jne .checkBootSign16
 mov ax, 1
 mov [bp-8], al
;-355 	if (ok) {

.checkBootSign16:
 mov al, [bp-8]
 or  al, al
 je .checkBootSign17
;-356 		cputs(" found.");

 push checkBootSign_1
 call cputs
 add  sp, 2
;-357 		return 1;

 mov ax, 1
 jmp .retncheckBootSign
;-358 		}

;-359 	else {

 jmp .checkBootSign18
.checkBootSign17:
;-360 		cputs(" NOT found.");

 push checkBootSign_2
 call cputs
 add  sp, 2
;-361 		return 0;	

 mov ax, 0
 jmp .retncheckBootSign
;-362 	}

;-363 }	

.checkBootSign18:
;-364 	

;-365 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db ",magic number=",0
checkBootSign_1 db " found.",0
checkBootSign_2 db " NOT found.",0
ENDP

readMBR: PROC
;-366 	int isFAT; int PartNo;

;-367 	isFAT=0;

;Function : readMBR, Number local Var: 2
; # type sign width local variables
;62 var sign word isFAT = bp-2
;63 var sign word PartNo = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-2], ax
;-368 	PartNo=0;

 mov ax, 0
 mov [bp-4], ax
;-369 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-370 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR19
;-371 		Int13hError();

 call Int13hError
;-372 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-373 		}

;-374 	else {	

 jmp .readMBR20
.readMBR19:
;-375 		putch(10);

 push 10
 call putch
 add  sp, 2
;-376 		cputs("Read partition status:");

 push readMBR_0
 call cputs
 add  sp, 2
;-377 		if(checkBootSign()==0) return 0;	

 call checkBootSign
 cmp al, 0
 jne .readMBR21
 mov ax, 0
 jmp .retnreadMBR
;-378 		do {

.readMBR21:
.readMBR22:
;-379 			getPartitionData(PartNo);

 push word [bp-4]
 call getPartitionData
 add  sp, 2
;-380 			printPartitionData(PartNo);

 push word [bp-4]
 call printPartitionData
 add  sp, 2
;-381 			

;-382 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR23
;-383 				cputs("Boot partition found");

 push readMBR_1
 call cputs
 add  sp, 2
;-384 				if (pt_FileSystem == 1) {

 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR24
;-385 					cputs(", FAT12 partition < 32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-386 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-387 					}

;-388 				if (pt_FileSystem == 4) {

.readMBR24:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR25
;-389 					cputs(", small FAT16 partition < 32MB");

 push readMBR_3
 call cputs
 add  sp, 2
;-390 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-391 					}

;-392 				if (pt_FileSystem == 6) {

.readMBR25:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR26
;-393 					cputs(", large FAT16 partition < 2GB");

 push readMBR_4
 call cputs
 add  sp, 2
;-394 					isFAT=6;

 mov ax, 6
 mov [bp-2], ax
;-395 					}

;-396 				PartNo=99;//end of loop	

.readMBR26:
 mov ax, 99
 mov [bp-4], ax
;-397 			}

;-398 			PartNo ++;

.readMBR23:
 inc  word[bp-4]
;-399 		} while (PartNo <4);

 mov ax, [bp-4]
 cmp ax, 4
 jge .readMBR27
 jmp .readMBR22
.readMBR27:
;-400 		if (isFAT==0) cputs(" no active FAT partition found");

 mov ax, [bp-2]
 cmp ax, 0
 jne .readMBR28
 push readMBR_5
 call cputs
 add  sp, 2
;-401 		return isFAT;

.readMBR28:
 mov ax, [bp-2]
 jmp .retnreadMBR
;-402 	}	

;-403 }

.readMBR20:
;-404 

;-405 int getBootSector() {

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
;-406   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

;-407   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-408 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector29
;-409 		Int13hError();

 call Int13hError
;-410 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-411 		}

;-412 	else {	

 jmp .getBootSector30
.getBootSector29:
;-413 		putch(10);

 push 10
 call putch
 add  sp, 2
;-414 		cputs("Read boot sector status:");

 push getBootSector_0
 call cputs
 add  sp, 2
;-415 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-416 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp ax, 0
 jne .getBootSector31
 mov ax, 0
 jmp .retngetBootSector
;-417 		

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
;-430 		cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push getBootSector_8
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
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
;-439 		cputs(".sectors(long)=");printlong(&bs_tot_sect32);

 push getBootSector_14
 call cputs
 add  sp, 2
 lea  ax, [bs_tot_sect32]
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

;-452 

;-453 int calcFATtype() {	

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
;-454 	unsigned long templong;//converting word to dword

;-455 

;-456 	FatStartSector=bs_res_sects;	

;Function : calcFATtype, Number local Var: 1
; # type sign width local variables
;62 var unsg long templong = bp-4;
 ENTER  4,0
 mov ax, [bs_res_sects]
 mov word [FatStartSector], ax
;-457 	FatSectors=bs_fat_size;	

 mov ax, [bs_fat_size]
 mov word [FatSectors], ax
;-458 	if (bs_num_fats == 2) FatSectors=FatSectors+FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .calcFATtype33
 mov ax, [FatSectors]
 add ax, [FatSectors]
 mov word [FatSectors], ax
;-459 

;-460 	RootDirStartSector=FatStartSector + FatSectors;

.calcFATtype33:
 mov ax, [FatStartSector]
 add ax, [FatSectors]
 mov word [RootDirStartSector], ax
;-461 	RootDirSectors= bs_root_entr << 5;// *32	

 mov ax, [bs_root_entr]
 shl ax, 5
 mov word [RootDirSectors], ax
;-462 	RootDirSectors= RootDirSectors / bs_sect_size;

 mov ax, [RootDirSectors]
 mov bx, [bs_sect_size]
 mov dx, 0
 div bx
 mov word [RootDirSectors], ax
;-463 

;-464 	DataStartSector=RootDirStartSector + RootDirSectors;

 mov ax, [RootDirStartSector]
 add ax, [RootDirSectors]
 mov word [DataStartSector], ax
;-465 	asm xor eax, eax

 xor eax, eax
;-466 	templong=DataStartSector;//convert word to dword		

 mov ax, [DataStartSector]
 mov [bp-4], eax
;-467 	

;-468 	if (bs_tot_sect16 !=0) {

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .calcFATtype34
;-469 		asm xor eax, eax

 xor eax, eax
;-470 		bs_tot_sect32=bs_tot_sect16;//convert word to dword		

 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-471 	}

;-472 	DataSectors32=bs_tot_sect32 - templong;//sub 32bit		

.calcFATtype34:
 mov eax, [bs_tot_sect32]
 sub eax, [bp-4]
 mov dword [DataSectors32], eax
;-473 

;-474 //	CountofClusters=DataSectors32 / bs_clust_size;only int divisor

;-475 //DX:AX   DIV r/m16    AX ← Quotient, DX ← Remainder

;-476 //EDX:EAX DIV r/m32   EAX ← Quotient, EDX ← Remainder

;-477 

;-478 // AX * r/m16 = DX:AX

;-479 //EAX * r/m32 = EDX:EAX

;-480 

;-481 /*	CountofClusters=DataSectors32 / BIOS_Status;

;-482 019D 66 A1 40 01     mov eax, [DataSectors32]

;-483 01A1 8B 1E 28 01     mov bx, [BIOS_Status]

;-484 01A5 BA 00 00        mov dx, 0

;-485 01A8 F7 F3           div bx

;-486 01AA 66 A3 44 01     mov dword [CountofClusters], eax

;-487 */	

;-488 

;-489 	if (bs_clust_size == 32) CountofClusters=DataSectors32 >> 5;

 mov al, [bs_clust_size]
 cmp al, 32
 jne .calcFATtype35
 mov eax, [DataSectors32]
 shr eax, 5
 mov dword [CountofClusters], eax
;-490 	if (bs_clust_size == 16) CountofClusters=DataSectors32 >> 4;

.calcFATtype35:
 mov al, [bs_clust_size]
 cmp al, 16
 jne .calcFATtype36
 mov eax, [DataSectors32]
 shr eax, 4
 mov dword [CountofClusters], eax
;-491 	if (bs_clust_size ==  8) CountofClusters=DataSectors32 >> 3;

.calcFATtype36:
 mov al, [bs_clust_size]
 cmp al, 8
 jne .calcFATtype37
 mov eax, [DataSectors32]
 shr eax, 3
 mov dword [CountofClusters], eax
;-492 	if (bs_clust_size ==  4) CountofClusters=DataSectors32 >> 2;

.calcFATtype37:
 mov al, [bs_clust_size]
 cmp al, 4
 jne .calcFATtype38
 mov eax, [DataSectors32]
 shr eax, 2
 mov dword [CountofClusters], eax
;-493 	if (bs_clust_size ==  2) CountofClusters=DataSectors32 >> 1;

.calcFATtype38:
 mov al, [bs_clust_size]
 cmp al, 2
 jne .calcFATtype39
 mov eax, [DataSectors32]
 shr eax, 1
 mov dword [CountofClusters], eax
;-494 	if (bs_clust_size ==  1) CountofClusters=DataSectors32;

.calcFATtype39:
 mov al, [bs_clust_size]
 cmp al, 1
 jne .calcFATtype40
 mov eax, [DataSectors32]
 mov dword [CountofClusters], eax
;-495 

;-496 //	Sectors_per_cylinder = bs_num_sects *  bs_num_sides;//mul mit zahl!

;-497 

;-498 

;-499 

;-500 

;-501 

;-502 

;-503 

;-504 	putch(10);

.calcFATtype40:
 push 10
 call putch
 add  sp, 2
;-505 	cputs("FatStartSector:");	printunsign(FatStartSector);

 push calcFATtype_0
 call cputs
 add  sp, 2
 push word [FatStartSector]
 call printunsign
 add  sp, 2
;-506 	cputs(", FatSectors=");		printunsign(FatSectors);

 push calcFATtype_1
 call cputs
 add  sp, 2
 push word [FatSectors]
 call printunsign
 add  sp, 2
;-507 	putch(10);

 push 10
 call putch
 add  sp, 2
;-508 	cputs("RootDirStartSector="); printunsign(RootDirStartSector);

 push calcFATtype_2
 call cputs
 add  sp, 2
 push word [RootDirStartSector]
 call printunsign
 add  sp, 2
;-509 	cputs(", RootDirSectors=");	printunsign(RootDirSectors);

 push calcFATtype_3
 call cputs
 add  sp, 2
 push word [RootDirSectors]
 call printunsign
 add  sp, 2
;-510 	putch(10);

 push 10
 call putch
 add  sp, 2
;-511 	cputs("DataStartSector=");	printunsign(DataStartSector);

 push calcFATtype_4
 call cputs
 add  sp, 2
 push word [DataStartSector]
 call printunsign
 add  sp, 2
;-512 	cputs(", DataSectors32=");	printlong(&DataSectors32);			

 push calcFATtype_5
 call cputs
 add  sp, 2
 lea  ax, [DataSectors32]
 push ax
 call printlong
 add  sp, 2
;-513 	putch(10);

 push 10
 call putch
 add  sp, 2
;-514 	cputs("CountofClusters=");	printlong(&CountofClusters);

 push calcFATtype_6
 call cputs
 add  sp, 2
 lea  ax, [CountofClusters]
 push ax
 call printlong
 add  sp, 2
;-515 	cputs(", Sectors_per_cylinder="); printlong(&Sectors_per_cylinder);

 push calcFATtype_7
 call cputs
 add  sp, 2
 lea  ax, [Sectors_per_cylinder]
 push ax
 call printlong
 add  sp, 2
;-516 	cputs(", trueFATtype=FAT"); 

 push calcFATtype_8
 call cputs
 add  sp, 2
;-517 	

;-518 	asm xor eax, eax ;clear bit 15-31			

 xor eax, eax ;clear bit 15-31			
;-519 	templong = 65525;			

 mov ax, 65525
 mov [bp-4], eax
;-520 	if (CountofClusters > templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jle .calcFATtype41
;-521 		trueFATtype=32; 

 mov ax, 32
 mov byte [trueFATtype], al
;-522 		cputs("32 NOT supported"); 

 push calcFATtype_9
 call cputs
 add  sp, 2
;-523 		return 1;

 mov ax, 1
 jmp .retncalcFATtype
;-524 		}

;-525 	asm xor eax, eax ;clear bit 15-31

.calcFATtype41:
 xor eax, eax ;clear bit 15-31
;-526 	templong=4086;

 mov ax, 4086
 mov [bp-4], eax
;-527 	if (CountofClusters < templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jge .calcFATtype42
;-528 		trueFATtype=12; 

 mov ax, 12
 mov byte [trueFATtype], al
;-529 		cputs("12"); 

 push calcFATtype_10
 call cputs
 add  sp, 2
;-530 		return 0;

 mov ax, 0
 jmp .retncalcFATtype
;-531 		}

;-532 	trueFATtype=16;

.calcFATtype42:
 mov ax, 16
 mov byte [trueFATtype], al
;-533 	cputs("16");

 push calcFATtype_11
 call cputs
 add  sp, 2
;-534 	return 0;

 mov ax, 0
 jmp .retncalcFATtype
;-535 }

;-536 

;-537 int Int13hExt() {

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
;-538 	bx=0x55AA;

 mov  bx, 21930
;-539 	BIOS_Status=Int13hfunction(Drive, 0x41);	

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-540 	asm mov [vAX], ax;

 mov [vAX], ax;
;-541 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-542 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported 			
;-543 	putch(10);

 push 10
 call putch
 add  sp, 2
;-544 	cputs("Int13h 41h Ext=");printhex16(vAX);

 push Int13hExt_0
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-545 	cputs(", BIOS_Status=");				printhex16(BIOS_Status);

 push Int13hExt_1
 call cputs
 add  sp, 2
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-546 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt43
;-547 		cputs(" Ext NOT present");	

 push Int13hExt_2
 call cputs
 add  sp, 2
;-548 		Int13hError();	

 call Int13hError
;-549 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-550 		}

;-551 	else {

 jmp .Int13hExt44
.Int13hExt43:
;-552 		cputs(" Extension found BX(AA55)=");printhex16(vBX);

 push Int13hExt_3
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-553 		cputs(" CX=");						printhex16(vCX);

 push Int13hExt_4
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-554 		}

;-555 	return 0;			

.Int13hExt44:
 mov ax, 0
 jmp .retnInt13hExt
;-556 }	

;-557 

;-558 int readLogical() {

 .retnInt13hExt:
 ret
Int13hExt_0 db "Int13h 41h Ext=",0
Int13hExt_1 db ", BIOS_Status=",0
Int13hExt_2 db " Ext NOT present",0
Int13hExt_3 db " Extension found BX(AA55)=",0
Int13hExt_4 db " CX=",0
ENDP

readLogical: PROC
;-559 	unsigned long track;

;-560 	Sectors_to_read = Sectors_to_read + bs_hid_sects;

;Function : readLogical, Number local Var: 1
; # type sign width local variables
;62 var unsg long track = bp-4;
 ENTER  4,0
 mov eax, [Sectors_to_read]
 add eax, [bs_hid_sects]
 mov dword [Sectors_to_read], eax
;-561 //	track = Sectors_to_read / 

;-562 

;-563 

;-564 

;-565 

;-566 	DiskSectorReadWrite(2, bs_drive_num );

 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 push 2
 call DiskSectorReadWrite
 add  sp, 4
;-567 	

;-568 //int DiskSectorReadWrite(char rw, char drive, char head, int cyl, 

;-569 //char sector, char count, int BufSeg, int BufOfs)

;-570 	

;-571 }

;-572 	

;-573 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-574     unsigned char c; int i; int j; int k;

;-575     j=0;

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
;-576     k=0;

 mov ax, 0
 mov [bp-8], ax
;-577     while (j < len ) {

.mdump45:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump46
;-578 	    k++;; 

 inc  word[bp-8]
;-579 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump47
;-580 		    getkey();

 call getkey
;-581 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-582 		    }

;-583         putch(10);

.mdump47:
 push 10
 call putch
 add  sp, 2
;-584         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-585         putch(':');

 push 58
 call putch
 add  sp, 2
;-586         i=0;

 mov ax, 0
 mov [bp-4], ax
;-587         while (i < 16) {

.mdump48:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump49
;-588             putch(' ');

 push 32
 call putch
 add  sp, 2
;-589             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-590             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-591             adr++;

 inc  word[bp+4]
;-592             i++;

 inc  word[bp-4]
;-593             j++;

 inc  word[bp-6]
;-594             }

;-595         putch(' ');

 jmp .mdump48
.mdump49:
 push 32
 call putch
 add  sp, 2
;-596         adr -=16;

 sub  word[bp+4], 16
;-597         i=0;

 mov ax, 0
 mov [bp-4], ax
;-598         while(i < 16) {

.mdump50:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump51
;-599             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-600             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump52
 push 46
 call putch
 add  sp, 2
;-601                 else putch(c);

 jmp .mdump53
.mdump52:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-602             adr++;

.mdump53:
 inc  word[bp+4]
;-603             i++;

 inc  word[bp-4]
;-604         }

;-605     }

 jmp .mdump50
.mdump51:
;-606 }

 jmp .mdump45
.mdump46:
;-607 

;-608 //------------------------------------ main ---------------

;-609 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-610 	int res;

;-611 	Drive=0x80;

;Function : main, Number local Var: 1
; # type sign width local variables
;62 var sign word res = bp-2;
 ENTER  2,0
 mov ax, 128
 mov byte [Drive], al
;-612 	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf

 mov [DiskBufSeg], ds; //Offset is in DiskBuf
;-613 

;-614 	if (Params()) 			return 1;//no hard disk

 call Params
 or  al, al
 je .main54
 mov ax, 1
 jmp .retnmain
;-615 	res=readMBR();//0=error,1=FAT12,6=FAT16,11=FAT32

.main54:
 call readMBR
 mov [bp-2], ax
;-616 	if (res == 0) 			return 1;

 mov ax, [bp-2]
 cmp ax, 0
 jne .main55
 mov ax, 1
 jmp .retnmain
;-617 //	mdump(DiskBuf, 512);

;-618 //	Int13hExt(Drive);

;-619 	if(getBootSector()==0) 	return 1;

.main55:
 call getBootSector
 cmp ax, 0
 jne .main56
 mov ax, 1
 jmp .retnmain
;-620 //	mdump(DiskBuf, 512);

;-621 	if (calcFATtype())		return 1;

.main56:
 call calcFATtype
 or  al, al
 je .main57
 mov ax, 1
 jmp .retnmain
;-622 	if(trueFATtype != 16) 	return 1;

.main57:
 mov al, [trueFATtype]
 cmp al, 16
 je  .main58
 mov ax, 1
 jmp .retnmain
;-623 	Int13hExt();

.main58:
 call Int13hExt
;-624 }

 .retnmain:
 LEAVE
 ret
ENDP
;Glob. variables:61 (400):686 (4000), Functions:30 (300):302 (3000)
;Lines:625, Constant: 1000 (3000), stacksize: 56831