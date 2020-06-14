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

;-41 //start hard disk partition structure 16 bytes in MBR. do not change

;-42 unsigned char pt_Bootable;		//80h = active partition, else 00

pt_Bootable db 0
;-43 unsigned char pt_StartHead;

pt_StartHead db 0
;-44 unsigned char pt_StartSector;	//bits 0-5

pt_StartSector db 0
;-45 unsigned int  pt_StartCylinder;	//bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-46 unsigned char pt_FileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=largeFAT16

pt_FileSystem db 0
;-47 unsigned char pt_EndHead;

pt_EndHead db 0
;-48 unsigned char pt_EndSector;		//bits 0-5

pt_EndSector db 0
;-49 unsigned int  pt_EndCylinder;	//bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-50 unsigned long pt_HiddenSector;	//sectors preceding partition

pt_HiddenSector dd 0
;-51 unsigned long pt_PartLen;    	//length of partition in sectors

pt_PartLen dd 0
;-52 //end hard disk partition structure

;-53 

;-54 //start boot BIOS Parameter Block structure. do not change

;-55 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-56 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-57 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-58 unsigned char bs_clust_size;// 13 sectors per cluster (1,2,4,..,128)

bs_clust_size db 0
;-59 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-60 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-61 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-62 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-63 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-64 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-65 unsigned int  bs_num_sects;	// 24 (DOS 3+)sectors per track 

bs_num_sects dw 0
;-66 unsigned int  bs_num_sides;	// 26 (DOS 3+)number of heads   

bs_num_sides dw 0
;-67 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors 

bs_hid_sects dd 0
;-68 unsigned long bs_tot_sect32;	// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-69 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-70 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-71 unsigned char bs_ext_signat;// 38 (DOS 4+) Extended signature,get next 3(29h)

bs_ext_signat db 0
;-72 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-73 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-74 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-75 // 62 end boot BIOS Parameter Block

;-76 

;-77 int writetty()     {//char in AL


writetty: PROC
;-78     ah=0x0E;

 mov  ah, 14
;-79     push bx;

push bx;
;-80     bx=0;			//page in BH

 mov  bx, 0
;-81     inth 0x10;		//16

 int  16
;-82     pop bx;

pop bx;
;-83 }

;-84 int putch(char c)  {

 ret
ENDP

putch: PROC
;-85     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;54 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-86         al=13;

 mov  al, 13
;-87         writetty();

 call writetty
;-88     }

;-89     al=c;

.putch1:
 mov  al, [bp+4]
;-90     writetty();

 call writetty
;-91 }

;-92 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-93     char c;

;-94     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;54 ptr sign byte s = bp+4
;55 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-95         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-96         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-97         s++;

 inc  word[bp+4]
;-98     }

;-99 }

 jmp .cputs2
.cputs3:
;-100 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-101 	char c;

;-102 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;54 ptr sign byte s = bp+4
;55 var sign word len = bp+6
;56 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-103 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-104 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-105 		s++;

 inc  word[bp+4]
;-106 		len--;

 dec  word[bp+6]
;-107 	} while (len > 0);	

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-108 }

;-109 

;-110 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-111     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-112     inth 0x16;//AH=Scan code, AL=char

 int  22
;-113 }

;-114 int waitkey() {

 ret
ENDP

waitkey: PROC
;-115     ah=0x11;//get kbd status

 mov  ah, 17
;-116     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-117     //zero flag: 0=IS char, 1=NO char

;-118     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-119 }

;-120 int getkey() {

 ret
ENDP

getkey: PROC
;-121     waitkey();

 call waitkey
;-122     getch();

 call getch
;-123     ah=0;//clear scan code

 mov  ah, 0
;-124     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-125     //put ext code in AX

;-126 }

.getkey6:
;-127 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-128     getkey();

 call getkey
;-129     writetty();//destroys AH

 call writetty
;-130 }

;-131 

;-132 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-133     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;54 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-134     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-135     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-136 }

;-137 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-138     unsigned char nib;

;-139     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;54 var unsg byte c = bp+4
;55 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-140     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-141 }

;-142 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-143     unsigned int half;

;-144     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;54 var unsg word i = bp+4
;55 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-145     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-146 }

;-147 

;-148 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-149     unsigned int e;

;-150     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;54 var unsg word n = bp+4
;55 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-151         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-152         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-153         }

;-154     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-155     n+='0';

 add  word[bp+4], 48
;-156     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-157 }

;-158 

;-159 int printlong(unsigned int *p) {

 LEAVE
 ret
ENDP

printlong: PROC
;-160 	unsigned int lo; unsigned int hi;

;-161 	lo = *p;

;Function : printlong, Number local Var: 3
; # type sign width local variables
;54 ptr unsg word p = bp+4
;55 var unsg word lo = bp-2
;56 var unsg word hi = bp-4;
 ENTER  4,0
 mov bx, [bp+4]
 mov ax, [bx]
 mov [bp-2], ax
;-162 	p +=2;

 add  word[bp+4], 2
;-163 	hi = *p;

 mov bx, [bp+4]
 mov ax, [bx]
 mov [bp-4], ax
;-164 	dx=hi;

 mov  dx, [bp-4]
;-165 	ax=lo;

 mov  ax, [bp-2]
;-166 __asm{	

	
;-167   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-168     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-169 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-170     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-171     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-172 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-173     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-174     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-175     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-176     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-177     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-178     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-179     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-180     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-181 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-182 }	writetty();		__asm{


 call writetty

;-183     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-184     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-185     jb      .b             ;Not yet	

    jb      .b             ;Not yet	
;-186 } 


;-187 }

;-188 

;-189 int memcpy(char *s, char *t, unsigned int i) {

 LEAVE
 ret
ENDP

memcpy: PROC
;-190 	unsigned int r;

;-191 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;54 ptr sign byte s = bp+4
;55 ptr sign byte t = bp+6
;56 var unsg word i = bp+8
;57 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-192 	do {

.memcpy9:
;-193 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-194 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-195 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy10
 jmp .memcpy9
.memcpy10:
;-196 	ax=r;//	return r;

 mov  ax, [bp-2]
;-197 }

;-198 

;-199 //--------------------------------  disk IO  -------------------

;-200 

;-201 int DiskSectorReadWrite(char rw, char drive, char head, int cyl, 

 LEAVE
 ret
ENDP

DiskSectorReadWrite: PROC
;-202 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-203 	BIOS_ERR=0;	

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;54 var sign byte rw = bp+4
;55 var sign byte drive = bp+6
;56 var sign byte head = bp+8
;57 var sign word cyl = bp+10
;58 var sign byte sector = bp+12
;59 var sign byte count = bp+14
;60 var sign word BufSeg = bp+16
;61 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-204 	dl=drive;

 mov  dl, [bp+6]
;-205 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-206 	es=BufSeg;

 mov  es, [bp+16]
;-207 	bx=BufOfs;

 mov  bx, [bp+18]
;-208 	cx=cyl;	

 mov  cx, [bp+10]
;-209 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-210 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-211 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-212 	cl += sector;

 add  cl, [bp+12]
;-213 	ch=cyl;//low byte of cyl in ch, word 2 byte	

 mov  ch, [bp+10]
;-214 	al=count;

 mov  al, [bp+14]
;-215 	ah=rw;

 mov  ah, [bp+4]
;-216 	inth 0x13;

 int  19
;-217     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-218 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-219 }

;-220 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-221 	BIOS_ERR=0;	

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;54 var sign byte drive = bp+4
;55 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-222 	dl=drive;

 mov  dl, [bp+4]
;-223 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-224 	inth 0x13;

 int  19
;-225     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-226 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-227 }

;-228 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-229 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-230 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-231 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-232 	BIOS_Status=Int13hfunction(Drive, 0);//Reset

 push 0
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-233 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-234 }	

;-235 

;-236 int Params() {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Params: PROC
;-237 	cputs("Drive Params:");

 push Params_0
 call cputs
 add  sp, 2
;-238 	BIOS_Status=Int13hfunction(Drive, 8);

 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-239 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params11
;-240 		Int13hError();

 call Int13hError
;-241 		return 1;

 mov ax, 1
 jmp .retnParams
;-242 		}

;-243 	else {

 jmp .Params12
.Params11:
;-244 		asm mov [Heads],        dh

 mov [Heads],        dh
;-245 //		Heads++;

;-246 		asm mov [Attached],     dl

 mov [Attached],     dl
;-247 		// CX =       ---CH--- ---CL---

;-248 		// cylinder : 76543210 98

;-249 		// sector   :            543210	

;-250 		asm mov [Sectors],      cl

 mov [Sectors],      cl
;-251 		Sectors &= 0x3F;// 63

 and  byte[Sectors], 63
;-252 //		Sectors++;//1 to 64

;-253 	

;-254 		asm mov [Cylinders],    cx	

 mov [Cylinders],    cx	
;-255 		Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[Cylinders], 192
;-256 		Cylinders = Cylinders << 2;//compiler flaw:

 mov ax, [Cylinders]
 shl ax, 2
 mov word [Cylinders], ax
;-257 		asm add [Cylinders],    ch;//byte add, low byte is empty	

 add [Cylinders],    ch;//byte add, low byte is empty	
;-258 		

;-259 		if (Attached == 0) {

 mov al, [Attached]
 cmp al, 0
 jne .Params13
;-260 			cputs(" no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-261 			return 1;

 mov ax, 1
 jmp .retnParams
;-262 			}

;-263 		cputs("CylHeadSec=");		printunsign(Cylinders);

.Params13:
 push Params_2
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
;-264 		putch('/');					printunsign(Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-265 		putch('/');					printunsign(Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-266 		cputs(", NoDrives=");		printhex8(Attached);

 push Params_3
 call cputs
 add  sp, 2
 mov al, byte [Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-267 		putch('.');

 push 46
 call putch
 add  sp, 2
;-268 	}

;-269 	return 0;

.Params12:
 mov ax, 0
 jmp .retnParams
;-270 }

;-271 

;-272 int Status(drive) {

 .retnParams:
 ret
Params_0 db "Drive Params:",0
Params_1 db " no hard disk found",0
Params_2 db "CylHeadSec=",0
Params_3 db ", NoDrives=",0
ENDP

Status: PROC
;-273 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;54 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-274 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-275 	BIOS_Status=Int13hfunction(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-276 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status14
 call Int13hError
;-277 	printhex16(BIOS_Status);	

.Status14:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-278 }	

;-279 

;-280 int getPartitionData() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

getPartitionData: PROC
;-281 	unsigned int j; char c; char *p;

;-282 	j = PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;54 var unsg word j = bp-2
;55 var sign byte c = bp-4
;56 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [PartNo]
 shl ax, 4
 mov [bp-2], ax
;-283 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-284 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-285 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-286 	ah=0;//next line convert byte to word

 mov  ah, 0
;-287 	pt_StartCylinder=pt_StartSector;	

 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-288 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-289 //	pt_StartSector++;//Sector start with 1 todo

;-290 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-291 	pt_StartCylinder = pt_StartCylinder << 2;//OK no short cut!	

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-292 	j++;

 inc  word[bp-2]
;-293 	ah=0;//byte to word

 mov  ah, 0
;-294 	pt_StartCylinder=DiskBuf[j] + pt_StartCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-295 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-296 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB	

;-297 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-298 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-299 	ah=0;//next line convert byte to word

 mov  ah, 0
;-300 	pt_EndCylinder=pt_EndSector;//see next 5 line		

 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-301 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-302 //	pt_EndSector++;//Sector start with 1 todo

;-303 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-304 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!	

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-305 	j++;

 inc  word[bp-2]
;-306 	ah=0;//byte to word

 mov  ah, 0
;-307 	pt_EndCylinder=DiskBuf[j] + pt_EndCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-308 	j++;

 inc  word[bp-2]
;-309 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-310 	memcpy(&pt_HiddenSector, p, 8);	

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-311 //	j += 8;//next partition entry

;-312 }

;-313 	

;-314 int printPartitionData() {

 LEAVE
 ret
ENDP

printPartitionData: PROC
;-315 	unsigned long Lo;

;-316 	putch(10);		

;Function : printPartitionData, Number local Var: 1
; # type sign width local variables
;54 var unsg long Lo = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-317 	cputs("No=");			printunsign(PartNo);

 push printPartitionData_0
 call cputs
 add  sp, 2
 push word [PartNo]
 call printunsign
 add  sp, 2
;-318 	cputs(",Boot=");		printhex8(pt_Bootable);

 push printPartitionData_1
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-319 	cputs(" ID=");			printunsign(pt_FileSystem);

 push printPartitionData_2
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-320 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push printPartitionData_3
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-321 	cputs("/");				printunsign(pt_StartSector);	

 push printPartitionData_4
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-322 	cputs("/");				printunsign(pt_StartCylinder);

 push printPartitionData_5
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-323 	cputs("-");				printunsign(pt_EndHead);

 push printPartitionData_6
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-324 	cputs("/");				printunsign(pt_EndSector);	

 push printPartitionData_7
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-325 	cputs("/");				printunsign(pt_EndCylinder);

 push printPartitionData_8
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-326 	cputs(",Start=");		printlong(&pt_HiddenSector);

 push printPartitionData_9
 call cputs
 add  sp, 2
 lea  ax, [pt_HiddenSector]
 push ax
 call printlong
 add  sp, 2
;-327 	cputs(",Len=");			printlong(&pt_PartLen);

 push printPartitionData_10
 call cputs
 add  sp, 2
 lea  ax, [pt_PartLen]
 push ax
 call printlong
 add  sp, 2
;-328 	cputs(" Sec=");

 push printPartitionData_11
 call cputs
 add  sp, 2
;-329 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-330 	printlong(&Lo);

 lea  ax, [bp-4]
 push ax
 call printlong
 add  sp, 2
;-331 	cputs(" MByte.");	

 push printPartitionData_12
 call cputs
 add  sp, 2
;-332 	putch(10);

 push 10
 call putch
 add  sp, 2
;-333 }

;-334 int checkBootSign() {

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
;-335 	char c; char d; int i; char ok;

;-336 	cputs(",magic number=");	

;Function : checkBootSign, Number local Var: 4
; # type sign width local variables
;54 var sign byte c = bp-2
;55 var sign byte d = bp-4
;56 var sign word i = bp-6
;57 var sign byte ok = bp-8;
 ENTER  8,0
 push checkBootSign_0
 call cputs
 add  sp, 2
;-337 	i=510;		c = DiskBuf[i];		printhex8(c);

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
;-338 	i++;		d = DiskBuf[i];		printhex8(d);

 inc  word[bp-6]
 mov bx, [bp-6]
 mov al, [DiskBuf + bx]
 mov [bp-4], al
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-339 	ok=0;

 mov ax, 0
 mov [bp-8], al
;-340 	if (c == 0x55) ok=1;

 mov al, [bp-2]
 cmp al, 85
 jne .checkBootSign15
 mov ax, 1
 mov [bp-8], al
;-341 	if (d == 0xAA) ok=1;

.checkBootSign15:
 mov al, [bp-4]
 cmp al, 170
 jne .checkBootSign16
 mov ax, 1
 mov [bp-8], al
;-342 	if (ok) {

.checkBootSign16:
 mov al, [bp-8]
 or  al, al
 je .checkBootSign17
;-343 		cputs(" found.");

 push checkBootSign_1
 call cputs
 add  sp, 2
;-344 		return 1;

 mov ax, 1
 jmp .retncheckBootSign
;-345 		}

;-346 	else {

 jmp .checkBootSign18
.checkBootSign17:
;-347 		cputs(" NOT found.");

 push checkBootSign_2
 call cputs
 add  sp, 2
;-348 		return 0;	

 mov ax, 0
 jmp .retncheckBootSign
;-349 	}

;-350 }	

.checkBootSign18:
;-351 	

;-352 int getFATtype() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db ",magic number=",0
checkBootSign_1 db " found.",0
checkBootSign_2 db " NOT found.",0
ENDP

getFATtype: PROC
;-353 	int isFAT;

;-354 	isFAT=0;

;Function : getFATtype, Number local Var: 1
; # type sign width local variables
;54 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-355 	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf

 mov [DiskBufSeg], ds; //Offset is in DiskBuf
;-356 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-357 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .getFATtype19
;-358 		Int13hError();

 call Int13hError
;-359 		return 0;

 mov ax, 0
 jmp .retngetFATtype
;-360 		}

;-361 	else {	

 jmp .getFATtype20
.getFATtype19:
;-362 		putch(10);

 push 10
 call putch
 add  sp, 2
;-363 		cputs("Read partition status:");

 push getFATtype_0
 call cputs
 add  sp, 2
;-364 /*		printhex16(BIOS_Status);	

;-365 		cputs(",DiskBuf=");

;-366 		printhex16(DiskBufSeg);

;-367 		putch(':');							

;-368 		printhex16(DiskBuf);

;-369 		putch('.');

;-370 */		

;-371 		if(checkBootSign()==0) return 0;	

 call checkBootSign
 cmp al, 0
 jne .getFATtype21
 mov ax, 0
 jmp .retngetFATtype
;-372 		PartNo=0;

.getFATtype21:
 mov ax, 0
 mov word [PartNo], ax
;-373 		do {

.getFATtype22:
;-374 			getPartitionData();

 call getPartitionData
;-375 			printPartitionData();

 call printPartitionData
;-376 			

;-377 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .getFATtype23
;-378 				cputs("Boot partition found");

 push getFATtype_1
 call cputs
 add  sp, 2
;-379 				if (pt_FileSystem == 1) {

 mov al, [pt_FileSystem]
 cmp al, 1
 jne .getFATtype24
;-380 					cputs(", FAT12 partition < 32MB");

 push getFATtype_2
 call cputs
 add  sp, 2
;-381 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-382 					}

;-383 				if (pt_FileSystem == 4) {

.getFATtype24:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .getFATtype25
;-384 					cputs(", small FAT16 partition < 32MB");

 push getFATtype_3
 call cputs
 add  sp, 2
;-385 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-386 					}

;-387 				if (pt_FileSystem == 6) {

.getFATtype25:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .getFATtype26
;-388 					cputs(", large FAT16 partition < 2GB");

 push getFATtype_4
 call cputs
 add  sp, 2
;-389 					isFAT=6;

 mov ax, 6
 mov [bp-2], ax
;-390 					}

;-391 				PartNo=99;//end of loop	

.getFATtype26:
 mov ax, 99
 mov word [PartNo], ax
;-392 			}

;-393 			PartNo ++;

.getFATtype23:
 inc  word[PartNo]
;-394 		} while (PartNo <4);

 mov ax, [PartNo]
 cmp ax, 4
 jge .getFATtype27
 jmp .getFATtype22
.getFATtype27:
;-395 		if (isFAT==0) cputs(" no active FAT partition found");

 mov ax, [bp-2]
 cmp ax, 0
 jne .getFATtype28
 push getFATtype_5
 call cputs
 add  sp, 2
;-396 		return isFAT;

.getFATtype28:
 mov ax, [bp-2]
 jmp .retngetFATtype
;-397 	}	

;-398 }

.getFATtype20:
;-399 

;-400 int getBootSector() {

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
;-401 	Cylinders=pt_StartCylinder;

 mov ax, [pt_StartCylinder]
 mov word [Cylinders], ax
;-402 	Heads=pt_StartHead;

 mov al, [pt_StartHead]
 mov byte [Heads], al
;-403 	Sectors=pt_StartSector ; // +1

 mov al, [pt_StartSector]
 mov byte [Sectors], al
;-404 	asm mov [DiskBufSeg], ds; //Offset is in DiskBuf

 mov [DiskBufSeg], ds; //Offset is in DiskBuf
;-405   BIOS_Status=DiskSectorReadWrite(2,Drive,Heads,Cylinders,Sectors,1,DiskBufSeg,DiskBuf);

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
;-406 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector29
;-407 		Int13hError();

 call Int13hError
;-408 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-409 		}

;-410 	else {	

 jmp .getBootSector30
.getBootSector29:
;-411 		putch(10);

 push 10
 call putch
 add  sp, 2
;-412 		cputs("Read boot sector status:");

 push getBootSector_0
 call cputs
 add  sp, 2
;-413 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-414 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp ax, 0
 jne .getBootSector31
 mov ax, 0
 jmp .retngetBootSector
;-415 		

;-416 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector31:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-417 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector32
 push getBootSector_1
 call cputs
 add  sp, 2
;-418 		putch(10);

.getBootSector32:
 push 10
 call putch
 add  sp, 2
;-419 		cputs("OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push getBootSector_2
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-420 		putch(10);

 push 10
 call putch
 add  sp, 2
;-421 		cputs("Bytes per sector(512)=");printunsign(bs_sect_size);	

 push getBootSector_3
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-422 		cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);	

 push getBootSector_4
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-423 		putch(10);

 push 10
 call putch
 add  sp, 2
;-424 		cputs("Reserved sectors=");printunsign(bs_res_sects);	

 push getBootSector_5
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-425 		cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);	

 push getBootSector_6
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-426 		putch(10);

 push 10
 call putch
 add  sp, 2
;-427 		cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push getBootSector_7
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-428 		cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push getBootSector_8
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-429 		putch(10);

 push 10
 call putch
 add  sp, 2
;-430 		cputs("Media descriptor(F8h for HD)=");printhex8(bs_media_desc);

 push getBootSector_9
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-431 		cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push getBootSector_10
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-432 		putch(10);

 push 10
 call putch
 add  sp, 2
;-433 		cputs("sectors per track=");printunsign(bs_num_sects);

 push getBootSector_11
 call cputs
 add  sp, 2
 push word [bs_num_sects]
 call printunsign
 add  sp, 2
;-434 		cputs(".number of heads=");printunsign(bs_num_sides);

 push getBootSector_12
 call cputs
 add  sp, 2
 push word [bs_num_sides]
 call printunsign
 add  sp, 2
;-435 		putch(10);

 push 10
 call putch
 add  sp, 2
;-436 		cputs("hidden sectors(long)=");printlong(&bs_hid_sects);

 push getBootSector_13
 call cputs
 add  sp, 2
 lea  ax, [bs_hid_sects]
 push ax
 call printlong
 add  sp, 2
;-437 		cputs(".sectors(long)=");printlong(&bs_tot_sect32);

 push getBootSector_14
 call cputs
 add  sp, 2
 lea  ax, [bs_tot_sect32]
 push ax
 call printlong
 add  sp, 2
;-438 		putch(10);

 push 10
 call putch
 add  sp, 2
;-439 		cputs("physical drive number=");printunsign(bs_drive_num);

 push getBootSector_15
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-440 		cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push getBootSector_16
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-441 		putch(10);

 push 10
 call putch
 add  sp, 2
;-442 		cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push getBootSector_17
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-443 		cputs(".Volume serial(long)=");printlong(&bs_serial_num);

 push getBootSector_18
 call cputs
 add  sp, 2
 lea  ax, [bs_serial_num]
 push ax
 call printlong
 add  sp, 2
;-444 		putch(10);

 push 10
 call putch
 add  sp, 2
;-445 		cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push getBootSector_19
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-446 		cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);		

 push getBootSector_20
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-447 	}

;-448 	return 1;

.getBootSector30:
 mov ax, 1
 jmp .retngetBootSector
;-449 }

;-450 

;-451 int calcFATtype() {

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
;-452 	

;-453 	

;-454 }

;-455 /*	

;-456 int Int13hExt(char drive) {

;-457 	putch(10);

;-458 	cputs("Int13h 41hExt AX(3000=ERROR)=");

;-459 	bx=0x55AA;

;-460 	BIOS_Status=Int13hfunction(0x80, 0x41);	

;-461 	printhex16(BIOS_Status);

;-462 	if (BIOS_ERR) {

;-463 		cputs(" not present");	

;-464 		Int13hError();	

;-465 		}

;-466 	else {

;-467 		cputs(" status=1:supported");

;-468 		asm mov [vBX], bx;0xAA55 Extension installed

;-469 		asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

;-470 		cputs(" BX(AA55)=");				printhex16(vBX);

;-471 		cputs(" CX(Interface bitmask)=");	printhex16(vCX);

;-472 		}		

;-473 }	

;-474 */

;-475 int mdump(unsigned char *adr, unsigned int len ) {

 ret
ENDP

mdump: PROC
;-476     unsigned char c; int i; int j; int k;

;-477     j=0;

;Function : mdump, Number local Var: 6
; # type sign width local variables
;54 ptr unsg byte adr = bp+4
;55 var unsg word len = bp+6
;56 var unsg byte c = bp-2
;57 var sign word i = bp-4
;58 var sign word j = bp-6
;59 var sign word k = bp-8;
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
;54 var sign word res = bp-2;
 ENTER  2,0
 mov ax, 128
 mov byte [Drive], al
;-514 

;-515 	if (Params()) return 1;//no hard disk

 call Params
 or  al, al
 je .main42
 mov ax, 1
 jmp .retnmain
;-516 	res=getFATtype();//0=error,1=FAT12,4=FAT16,6=largeFAT16

.main42:
 call getFATtype
 mov [bp-2], ax
;-517 	if (res == 0) return 1;

 mov ax, [bp-2]
 cmp ax, 0
 jne .main43
 mov ax, 1
 jmp .retnmain
;-518 //	mdump(DiskBuf, 512);

;-519 //	Int13hExt(Drive);

;-520 	if(getBootSector()==0) return 1;

.main43:
 call getBootSector
 cmp ax, 0
 jne .main44
 mov ax, 1
 jmp .retnmain
;-521 //	mdump(DiskBuf, 512);

;-522 	calcFATtype();

.main44:
 call calcFATtype
;-523 }

 .retnmain:
 LEAVE
 ret
ENDP
;Glob. variables:53 (400):536 (4000), Functions:27 (300):278 (3000)
;Lines:524, Constant: 1000 (3000), stacksize: 56831