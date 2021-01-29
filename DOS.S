;A.COM V1.1.4, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.2.3";//test bed

Version1 db "DOS.COM V0.2.3",0
;-2 //Finder /hg/DOS/DOS3.vhd

;-3 //rigth click / open / Parallels Mounter

;-4 // (E)DX:(E)AX DIV r/m16(32) = (E)AX, remainder (E)DX

;-5 // AL*r/m8=AX; AX*r/m16=DX:AX; EAX*r/m32=EDX:EAX

;-6 // > 16.777.216 sectors (8GB) only LBA

;-7 #define ORGDATA		16384//=16K start of arrays

;-8 #define debug 0

;-9 unsigned int vAX ;unsigned int vBX ;unsigned int vCX; unsigned int vDX;

vAX dw 0
vBX dw 0
vCX dw 0
vDX dw 0
;-10 unsigned int vSP; unsigned int vBP; unsigned int vCS; unsigned int vDS;

vSP dw 0
vBP dw 0
vCS dw 0
vDS dw 0
;-11 unsigned int vSS; unsigned int vES; //debugging

vSS dw 0
vES dw 0
;-12 

;-13 unsigned char DOS_ERR;

DOS_ERR db 0
;-14 unsigned char BIOS_ERR;

BIOS_ERR db 0
;-15 unsigned int  BIOS_Status;

BIOS_Status dw 0
;-16 unsigned int  DiskBufSeg;

DiskBufSeg dw 0
;-17 unsigned char dummy[1];//todo remove

section .bss
absolute 16384
dummy resb 1
section .text
;-18 unsigned char DiskBuf [512];

section .bss
absolute 16385
DiskBuf resb 512
section .text
;-19 unsigned char Drive=0x80;

Drive db 128
;-20 unsigned long clust_sizeL;

clust_sizeL dd 0
;-21 unsigned long sector_sizeL;

sector_sizeL dd 0
;-22 unsigned char filename[67];

section .bss
absolute 16897
filename resb 67
section .text
;-23 unsigned char searchstr  [12];//with null

section .bss
absolute 16964
searchstr resb 12
section .text
;-24 char *upto;		//IN:part of filename to search/OUT:to search next time

upto dw 0
;-25 char isfilename;//is filename or part of directory?

isfilename db 0
;-26 char fatfound;

fatfound db 0
;-27 unsigned char Buffer [16394];//16K+10

section .bss
absolute 16976
Buffer resb 16394
section .text
;-28 

;-29 char          handle;

handle db 0
;-30 //start array of handles of every open file

;-31 //unsigned char FileIsOpen;

;-32 unsigned int  BegCluster;		//first cluster of file

BegCluster dw 0
;-33 unsigned int  CurCluster;		//current cluster

CurCluster dw 0
;-34 unsigned int  NextCluster;

NextCluster dw 0
;-35 unsigned long CurSectorL;		//current sector in current cluster

CurSectorL dd 0
;-36 unsigned long FileSizeL;

FileSizeL dd 0
;-37 //unsigned int  CurPosition;	//current byte location in cur sector

;-38 //unsigned long SeekL;			//current byte location in file

;-39 //	end array of handles of every open file

;-40 

;-41 //FATInit

;-42 unsigned int  fat_FatStartSector;

fat_FatStartSector dw 0
;-43 unsigned long fat_FatStartSectorL;

fat_FatStartSectorL dd 0
;-44 unsigned int  fat_FatSectors;

fat_FatSectors dw 0
;-45 unsigned long fat_RootDirStartSectorL;

fat_RootDirStartSectorL dd 0
;-46 unsigned long fat_RootDirSectorsL;

fat_RootDirSectorsL dd 0
;-47 unsigned long fat_DataStartSectorL;

fat_DataStartSectorL dd 0
;-48 unsigned long num_tracksL;

num_tracksL dd 0
;-49 //unsigned int  fat_num_cylinders;

;-50 unsigned long Sectors_per_cylinderL;

Sectors_per_cylinderL dd 0
;-51 unsigned long DataSectors32;

DataSectors32 dd 0
;-52 unsigned long CountofClustersL;

CountofClustersL dd 0
;-53 unsigned char trueFATtype;	//12, 16, 32 from FATInit

trueFATtype db 0
;-54 //unsigned int  FATtype;//0=error,1=FAT12,6=FAT16,11=FAT32 from ReadMBR

;-55 

;-56 //Params from int13h, Function 8

;-57 unsigned int  pa_Cylinders;

pa_Cylinders dw 0
;-58 unsigned char pa_Sectors;

pa_Sectors db 0
;-59 unsigned char pa_Heads;

pa_Heads db 0
;-60 unsigned char pa_Attached;

pa_Attached db 0
;-61 unsigned int  pt_PartNo;

pt_PartNo dw 0
;-62 

;-63 //start hard disk partition structure 16 bytes in MBR. do not change!!!!!

;-64 unsigned char pt_Bootable;		// 00 80h = active partition, else 00

pt_Bootable db 0
;-65 unsigned char pt_StartHead;		// 01

pt_StartHead db 0
;-66 unsigned char pt_StartSector;	// 02 bits 0-5

pt_StartSector db 0
;-67 unsigned int  pt_StartCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-68 unsigned char pt_FileSystem;	// 04 0=nu,1=FAT12,4=16,5=ExtP,6=large16

pt_FileSystem db 0
;-69 unsigned char pt_EndHead;		// 05

pt_EndHead db 0
;-70 unsigned char pt_EndSector;		// 06 bits 0-5

pt_EndSector db 0
;-71 unsigned int  pt_EndCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-72 unsigned long pt_HiddenSector;	// 08 sectors preceding partition

pt_HiddenSector dd 0
;-73 unsigned long pt_PartLen;    	// 12 length of partition in sectors

pt_PartLen dd 0
;-74 //  16 end hard disk partition structure

;-75 

;-76 //start boot BIOS Parameter Block structure. do not change!!!!!

;-77 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-78 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-79 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-80 unsigned char bs_clust_size;// 13 sectors per CurCluster (1,2,4,..,128)

bs_clust_size db 0
;-81 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-82 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-83 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-84 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-85 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-86 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-87 unsigned int  bs_sectors_per_track; // 24 (DOS 3+)sectors per track

bs_sectors_per_track dw 0
;-88 unsigned int  bs_num_heads;	// 26 (DOS 3+)number of heads

bs_num_heads dw 0
;-89 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors

bs_hid_sects dd 0
;-90 unsigned long bs_tot_sect32;// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-91 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-92 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-93 unsigned char bs_ext_signat;// 38 (DOS 4+) Ext. signature,get next 3(29h)

bs_ext_signat db 0
;-94 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-95 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-96 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-97 // 62 end boot BIOS Parameter Block

;-98 

;-99 //start directory entry structure, do not change!!!!!

;-100 unsigned char dir_Filename[]="1234567";	//00 +lengthbyte=11

dir_Filename db "1234567",0
;-101 unsigned char dir_Ext[]="12";	//07 +lengthbyte=3

dir_Ext db "12",0
;-102 unsigned char dir_Attrib;		//11 directory=10h, Label=08h, read only=1

dir_Attrib db 0
;-103 unsigned char dir_NTReserved;	//12 low case in body=8h, in ext=10h

dir_NTReserved db 0
;-104 unsigned char dir_TimeCreatedMS;//13 in 10 milliseconda or zero

dir_TimeCreatedMS db 0
;-105 unsigned int  dir_TimeCreated;	//14 creation time, resolution 2 sec. or 0

dir_TimeCreated dw 0
;-106 unsigned int  dir_DateCreated;	//16 creation date or zero

dir_DateCreated dw 0
;-107 unsigned int  dir_DateLastAccessd;		//18 no time info available or zero

dir_DateLastAccessd dw 0
;-108 unsigned int  dir_FirstClusterHiBytes;	//20 FAT12/16 always zero

dir_FirstClusterHiBytes dw 0
;-109 unsigned int  dir_LastModTime;	//22 modification time on closing

dir_LastModTime dw 0
;-110 unsigned int  dir_LastModDate;	//24 modification date on closing

dir_LastModDate dw 0
;-111 unsigned int  dir_FirstCluster;	//26 1.clu. of file data,if filesize=0 then0

dir_FirstCluster dw 0
;-112 unsigned long dir_FileSize;		//28 size in bytes, if directory then zero

dir_FileSize dd 0
;-113 // 32 end direcctory entry structure

;-114 

;-115 int test() {


test: PROC
;-116 	__asm{


;-117 }	}


;-118 

;-119 //------------------------------------   IO  -------------------

;-120 

;-121 int writetty()     {//char in AL

 ret
ENDP

writetty: PROC
;-122     ah=0x0E;

 mov  ah, 14
;-123     push bx;

push bx;
;-124     bx=0;			//page in BH

 mov  bx, 0
;-125     inth 0x10;		//16

 int  16
;-126     pop bx;

pop bx;
;-127 }

;-128 int putch(char c)  {

 ret
ENDP

putch: PROC
;-129     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;93 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-130         al=13;

 mov  al, 13
;-131         writetty();

 call writetty
;-132     }

;-133     al=c;

.putch1:
 mov  al, [bp+4]
;-134     writetty();

 call writetty
;-135 }

;-136 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-137     char c;

;-138     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;93 ptr sign byte s = bp+4
;94 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-139         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-140         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-141         s++;

 inc  word[bp+4]
;-142     }

;-143 }

 jmp .cputs2
.cputs3:
;-144 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-145 	char c;

;-146 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;93 ptr sign byte s = bp+4
;94 var sign word len = bp+6
;95 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-147 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-148 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-149 		s++;

 inc  word[bp+4]
;-150 		len--;

 dec  word[bp+6]
;-151 	} while (len > 0);

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-152 }

;-153 

;-154 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-155     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-156     inth 0x16;//AH=Scan code, AL=char

 int  22
;-157 }

;-158 int waitkey() {

 ret
ENDP

waitkey: PROC
;-159     ah=0x11;//get kbd status

 mov  ah, 17
;-160     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-161     //zero flag: 0=IS char, 1=NO char

;-162     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-163 }

;-164 int getkey() {

 ret
ENDP

getkey: PROC
;-165     waitkey();

 call waitkey
;-166     getch();

 call getch
;-167     ah=0;//clear scan code

 mov  ah, 0
;-168     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-169     //put ext code in AX

;-170 }

.getkey6:
;-171 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-172     getkey();

 call getkey
;-173     writetty();//destroys AH

 call writetty
;-174 }

;-175 

;-176 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-177     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;93 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-178     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-179     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-180 }

;-181 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-182     unsigned char nib;

;-183     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;93 var unsg byte c = bp+4
;94 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-184     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-185 }

;-186 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-187     unsigned int half;

;-188     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;93 var unsg word i = bp+4
;94 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-189     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-190 }

;-191 

;-192 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-193     unsigned int e;

;-194     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;93 var unsg word n = bp+4
;94 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-195         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-196         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-197         }

;-198     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-199     n+='0';

 add  word[bp+4], 48
;-200     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-201 }

;-202 

;-203 int printlong(unsigned long L) {

 LEAVE
 ret
ENDP

printlong: PROC
;-204     ax = L;     // get low in ax

;Function : printlong, Number local Var: 1
; # type sign width local variables
;93 var unsg long L = bp+4;
 ENTER  0,0
 mov  ax, [bp+4]
;-205     edx=L;

 mov  edx, [bp+4]
;-206     edx >> 16;  // get high in dx

 shr  edx, 16
;-207 __asm{


;-208   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-209     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-210 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-211     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-212     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-213 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-214     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-215     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-216     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-217     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-218     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-219     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-220     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-221     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-222 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-223 }	writetty();		__asm{


 call writetty

;-224     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-225     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-226     jb      .b             ;Not yet

    jb      .b             ;Not yet
;-227 }


;-228 }

;-229 //--------------------------------  string  ---------------------

;-230 int strlen(char *s) { int c;

 LEAVE
 ret
ENDP

strlen: PROC
;-231     c=0;

;Function : strlen, Number local Var: 2
; # type sign width local variables
;93 ptr sign byte s = bp+4
;94 var sign word c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-232     if (*s == 34) return 0; // "

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 jne .strlen9
 mov ax, 0
 jmp .retnstrlen
;-233     while (*s!=0) {s++; c++;}

.strlen9:
.strlen10:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen11
 inc  word[bp+4]
 inc  word[bp-2]
;-234     return c;

 jmp .strlen10
.strlen11:
 mov ax, [bp-2]
 jmp .retnstrlen
;-235 }

;-236 int strcpy(char *s, char *t) {//new

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-237     while (*t!=0) {

;Function : strcpy, Number local Var: 2
; # type sign width local variables
;93 ptr sign byte s = bp+4
;94 ptr sign byte t = bp+6;
 ENTER  0,0
.strcpy12:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy13
;-238     	*s=*t; s++; t++; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-239     *s=0;

 jmp .strcpy12
.strcpy13:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-240     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-241 }

;-242 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-243     while(*p) {

;Function : eqstr, Number local Var: 2
; # type sign width local variables
;93 ptr sign byte p = bp+4
;94 ptr sign byte q = bp+6;
 ENTER  0,0
.eqstr14:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr15
;-244         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr16
 mov ax, 0
 jmp .retneqstr
;-245         p++;

.eqstr16:
 inc  word[bp+4]
;-246         q++;

 inc  word[bp+6]
;-247     }

;-248     if(*q) return 0;

 jmp .eqstr14
.eqstr15:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr17
 mov ax, 0
 jmp .retneqstr
;-249     return 1;

.eqstr17:
 mov ax, 1
 jmp .retneqstr
;-250 }

;-251 

;-252 int memcmp(char *s, char *t, unsigned int i) {

 .retneqstr:
 LEAVE
 ret
ENDP

memcmp: PROC
;-253     do {

;Function : memcmp, Number local Var: 3
; # type sign width local variables
;93 ptr sign byte s = bp+4
;94 ptr sign byte t = bp+6
;95 var unsg word i = bp+8;
 ENTER  0,0
.memcmp18:
;-254         if (*s < *t) return 0xFFFF;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 jge .memcmp19
 mov ax, 65535
 jmp .retnmemcmp
;-255         if (*s > *t) return 1;

.memcmp19:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 jle .memcmp20
 mov ax, 1
 jmp .retnmemcmp
;-256         s++; t++; i--;

.memcmp20:
 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-257     } while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcmp21
 jmp .memcmp18
.memcmp21:
;-258     return 0;

 mov ax, 0
 jmp .retnmemcmp
;-259 }

;-260 

;-261 int strcat(char *s, char *t) {

 .retnmemcmp:
 LEAVE
 ret
ENDP

strcat: PROC
;-262     while (*s != 0) s++;

;Function : strcat, Number local Var: 2
; # type sign width local variables
;93 ptr sign byte s = bp+4
;94 ptr sign byte t = bp+6;
 ENTER  0,0
.strcat22:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat23
 inc  word[bp+4]
;-263     strcpy(s, t);

 jmp .strcat22
.strcat23:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4
;-264 }

;-265 int toupper(char *s) {

 LEAVE
 ret
ENDP

toupper: PROC
;-266     while(*s) {

;Function : toupper, Number local Var: 1
; # type sign width local variables
;93 ptr sign byte s = bp+4;
 ENTER  0,0
.toupper24:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper25
;-267         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  .toupper26
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  .toupper27
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
;-268         s++;

.toupper27:
.toupper26:
 inc  word[bp+4]
;-269     }

;-270 }

 jmp .toupper24
.toupper25:
;-271 int strchr(char *s, char c) {

 LEAVE
 ret
ENDP

strchr: PROC
;-272     while(*s) {

;Function : strchr, Number local Var: 2
; # type sign width local variables
;93 ptr sign byte s = bp+4
;94 var sign byte c = bp+6;
 ENTER  0,0
.strchr28:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .strchr29
;-273         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .strchr30
 mov ax, [bp+4]
 jmp .retnstrchr
;-274         s++;

.strchr30:
 inc  word[bp+4]
;-275     }

;-276     return 0;

 jmp .strchr28
.strchr29:
 mov ax, 0
 jmp .retnstrchr
;-277 }

;-278 int memchr(char *s, char c, unsigned int i) {

 .retnstrchr:
 LEAVE
 ret
ENDP

memchr: PROC
;-279     while(i > 0) {

;Function : memchr, Number local Var: 3
; # type sign width local variables
;93 ptr sign byte s = bp+4
;94 var sign byte c = bp+6
;95 var unsg word i = bp+8;
 ENTER  0,0
.memchr31:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr32
;-280         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr33
 mov ax, [bp+4]
 jmp .retnmemchr
;-281         s++; i--;

.memchr33:
 inc  word[bp+4]
 dec  word[bp+8]
;-282     }

;-283     return 0;

 jmp .memchr31
.memchr32:
 mov ax, 0
 jmp .retnmemchr
;-284 }

;-285 int memchr1(char *s, char c, unsigned int i) {

 .retnmemchr:
 LEAVE
 ret
ENDP

memchr1: PROC
;-286 	unsigned int pos;

;-287 	pos=1;

;Function : memchr1, Number local Var: 4
; # type sign width local variables
;93 ptr sign byte s = bp+4
;94 var sign byte c = bp+6
;95 var unsg word i = bp+8
;96 var unsg word pos = bp-2;
 ENTER  2,0
 mov ax, 1
 mov [bp-2], ax
;-288     while(i > 0) {

.memchr134:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr135
;-289         if (*s==c) return pos;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr136
 mov ax, [bp-2]
 jmp .retnmemchr1
;-290         s++; i--; pos++;

.memchr136:
 inc  word[bp+4]
 dec  word[bp+8]
 inc  word[bp-2]
;-291     }

;-292     return 0;

 jmp .memchr134
.memchr135:
 mov ax, 0
 jmp .retnmemchr1
;-293 }

;-294 int instr1(char *s, char c) {

 .retnmemchr1:
 LEAVE
 ret
ENDP

instr1: PROC
;-295     while(*s) {

;Function : instr1, Number local Var: 2
; # type sign width local variables
;93 ptr sign byte s = bp+4
;94 var sign byte c = bp+6;
 ENTER  0,0
.instr137:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .instr138
;-296         if (*s==c) return 1;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .instr139
 mov ax, 1
 jmp .retninstr1
;-297         s++;

.instr139:
 inc  word[bp+4]
;-298     }

;-299     return 0;

 jmp .instr137
.instr138:
 mov ax, 0
 jmp .retninstr1
;-300 }

;-301 

;-302 int memcpy(char *s, char *t, unsigned int i) {

 .retninstr1:
 LEAVE
 ret
ENDP

memcpy: PROC
;-303 	unsigned int r;

;-304 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;93 ptr sign byte s = bp+4
;94 ptr sign byte t = bp+6
;95 var unsg word i = bp+8
;96 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-305 	do {

.memcpy40:
;-306 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-307 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-308 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy41
 jmp .memcpy40
.memcpy41:
;-309 	ax=r;//	return r;

 mov  ax, [bp-2]
;-310 }

;-311 

;-312 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-313     unsigned char c; unsigned char chal; int i; int j; int k;

;-314     j=0;

;Function : mdump, Number local Var: 7
; # type sign width local variables
;93 ptr unsg byte adr = bp+4
;94 var unsg word len = bp+6
;95 var unsg byte c = bp-2
;96 var unsg byte chal = bp-4
;97 var sign word i = bp-6
;98 var sign word j = bp-8
;99 var sign word k = bp-10;
 ENTER  10,0
 mov ax, 0
 mov [bp-8], ax
;-315     k=0;

 mov ax, 0
 mov [bp-10], ax
;-316     while (j < len ) {

.mdump42:
 mov ax, [bp-8]
 cmp ax, [bp+6]
 jge .mdump43
;-317 	    k++;;

 inc  word[bp-10]
;-318 	    if (k > 8) {

 mov ax, [bp-10]
 cmp ax, 8
 jle .mdump44
;-319 		    chal = getkey();//remove scan code

 call getkey
 mov [bp-4], al
;-320 		    if (chal =='q') return;

 mov al, [bp-4]
 cmp al, 113
 jne .mdump45
 jmp .retnmdump
;-321 		    k=1;

.mdump45:
 mov ax, 1
 mov [bp-10], ax
;-322 		    }

;-323         putch(10);

.mdump44:
 push 10
 call putch
 add  sp, 2
;-324         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-325         putch(':');

 push 58
 call putch
 add  sp, 2
;-326         i=0;

 mov ax, 0
 mov [bp-6], ax
;-327         while (i < 16) {

.mdump46:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump47
;-328             putch(' ');

 push 32
 call putch
 add  sp, 2
;-329             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-330             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-331             adr++;

 inc  word[bp+4]
;-332             i++;

 inc  word[bp-6]
;-333             j++;

 inc  word[bp-8]
;-334             }

;-335         putch(' ');

 jmp .mdump46
.mdump47:
 push 32
 call putch
 add  sp, 2
;-336         adr -=16;

 sub  word[bp+4], 16
;-337         i=0;

 mov ax, 0
 mov [bp-6], ax
;-338         while(i < 16) {

.mdump48:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump49
;-339             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-340             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump50
 push 46
 call putch
 add  sp, 2
;-341                 else putch(c);

 jmp .mdump51
.mdump50:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-342             adr++;

.mdump51:
 inc  word[bp+4]
;-343             i++;

 inc  word[bp-6]
;-344         }

;-345     }

 jmp .mdump48
.mdump49:
;-346     getkey();

 jmp .mdump42
.mdump43:
 call getkey
;-347     putch(10);

 push 10
 call putch
 add  sp, 2
;-348 

;-349 }

;-350 

;-351 //--------------------------------  disk IO  -------------------

;-352 

;-353 int DiskSectorReadWrite(char rw, char drive, char head, int cyl,

 .retnmdump:
 LEAVE
 ret
ENDP

DiskSectorReadWrite: PROC
;-354 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-355 	BIOS_ERR=0;

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;93 var sign byte rw = bp+4
;94 var sign byte drive = bp+6
;95 var sign byte head = bp+8
;96 var sign word cyl = bp+10
;97 var sign byte sector = bp+12
;98 var sign byte count = bp+14
;99 var sign word BufSeg = bp+16
;100 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-356 	dl=drive;

 mov  dl, [bp+6]
;-357 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-358 	es=BufSeg;

 mov  es, [bp+16]
;-359 	bx=BufOfs;

 mov  bx, [bp+18]
;-360 	cx=cyl;

 mov  cx, [bp+10]
;-361 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-362 	cx >> 2;//in 2 high bits of cl

 shr  cx, 2
;-363 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-364 	cl += sector;

 add  cl, [bp+12]
;-365 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-366 	al=count;

 mov  al, [bp+14]
;-367 	ah=rw;

 mov  ah, [bp+4]
;-368 	inth 0x13;

 int  19
;-369     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-370 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-371 }

;-372 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-373 	BIOS_ERR=0;

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;93 var sign byte drive = bp+4
;94 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-374 	dl=drive;

 mov  dl, [bp+4]
;-375 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-376 	inth 0x13;

 int  19
;-377     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-378 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-379 }

;-380 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-381 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-382 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-383 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-384 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-385 }

;-386 int Status(drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Status: PROC
;-387 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;93 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-388 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-389 	BIOS_Status=Int13hfunction(drive, 1);

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-390 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Status52
 call Int13hError
;-391 	printhex16(BIOS_Status);

.Status52:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-392 }

;-393 

;-394 int Params() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

Params: PROC
;-395 	if (debug) cputs(" DriveParams");

 mov ax, 0
 or  al, al
 je .Params53
 push Params_0
 call cputs
 add  sp, 2
;-396 	BIOS_Status=Int13hfunction(Drive, 8);

.Params53:
 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-397 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params54
;-398 		Int13hError();

 call Int13hError
;-399 		return 1;

 mov ax, 1
 jmp .retnParams
;-400 		}

;-401 	else {

 jmp .Params55
.Params54:
;-402 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-403 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-404 		// CX =       ---CH--- ---CL---

;-405 		// cylinder : 76543210 98

;-406 		// sector   :            543210

;-407 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-408 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-409 //		pa_Sectors++;//1 to 64

;-410 

;-411 		asm mov [pa_Cylinders],    cx

 mov [pa_Cylinders],    cx
;-412 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-413 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-414 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty

 add [pa_Cylinders],    ch;//byte add, low byte is empty
;-415 

;-416 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params56
;-417 			cputs(" ** no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-418 			return 1;

 mov ax, 1
 jmp .retnParams
;-419 			}

;-420 	}

.Params56:
;-421 	return 0;

.Params55:
 mov ax, 0
 jmp .retnParams
;-422 }

;-423 

;-424 

;-425 int getPartitionData() {

 .retnParams:
 ret
Params_0 db " DriveParams",0
Params_1 db " ** no hard disk found",0
ENDP

getPartitionData: PROC
;-426 	unsigned int j; char c; char *p;

;-427 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;93 var unsg word j = bp-2
;94 var sign byte c = bp-4
;95 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [pt_PartNo]
 shl ax, 4
 mov [bp-2], ax
;-428 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-429 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-430 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-431 	pt_StartCylinder=(int)pt_StartSector;

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-432 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-433 //	pt_StartSector++;//Sector start with 1 todo

;-434 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-435 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-436 	j++;

 inc  word[bp-2]
;-437 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-438 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-439 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB

;-440 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-441 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-442 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-443 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-444 //	pt_EndSector++;//Sector start with 1 todo

;-445 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-446 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-447 	j++;

 inc  word[bp-2]
;-448 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-449 	j++;

 inc  word[bp-2]
;-450 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-451 	memcpy(&pt_HiddenSector, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-452 }

;-453 

;-454 int checkBootSign() {

 LEAVE
 ret
ENDP

checkBootSign: PROC
;-455 	int i;

;-456 	i=510;

;Function : checkBootSign, Number local Var: 1
; # type sign width local variables
;93 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-457 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign57
;-458 		i++;

 inc  word[bp-2]
;-459 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign58
 mov ax, 1
 jmp .retncheckBootSign
;-460 	}

.checkBootSign58:
;-461 	cputs("  **Magic number NOT found.");

.checkBootSign57:
 push checkBootSign_0
 call cputs
 add  sp, 2
;-462 	return 0;

 mov ax, 0
 jmp .retncheckBootSign
;-463 }

;-464 

;-465 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db "  **Magic number NOT found.",0
ENDP

readMBR: PROC
;-466 	int isFAT;

;-467 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;93 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-468 	pt_PartNo=0;

 mov ax, 0
 mov word [pt_PartNo], ax
;-469 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-470 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR59
;-471 		Int13hError();

 call Int13hError
;-472 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-473 		}

;-474 	else {

 jmp .readMBR60
.readMBR59:
;-475 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .readMBR61
 mov ax, 0
 jmp .retnreadMBR
;-476 		do {

.readMBR61:
.readMBR62:
;-477 			getPartitionData();

 call getPartitionData
;-478 

;-479 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR63
;-480 				if (debug) cputs(" Boot part. found");

 mov ax, 0
 or  al, al
 je .readMBR64
 push readMBR_0
 call cputs
 add  sp, 2
;-481 				if (pt_FileSystem == 1) {

.readMBR64:
 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR65
;-482 					cputs(", FAT12 part. <32MB");

 push readMBR_1
 call cputs
 add  sp, 2
;-483 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-484 					}

;-485 				if (pt_FileSystem == 4) {

.readMBR65:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR66
;-486 					cputs(", small FAT16 part.<32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-487 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-488 					}

;-489 				if (pt_FileSystem == 6) {

.readMBR66:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR67
;-490 					if (debug) cputs(", large FAT16 part.");

 mov ax, 0
 or  al, al
 je .readMBR68
 push readMBR_3
 call cputs
 add  sp, 2
;-491 					isFAT=6;

.readMBR68:
 mov ax, 6
 mov [bp-2], ax
;-492 					}

;-493 				pt_PartNo=99;//end of loop

.readMBR67:
 mov ax, 99
 mov word [pt_PartNo], ax
;-494 			}

;-495 			pt_PartNo ++;

.readMBR63:
 inc  word[pt_PartNo]
;-496 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR69
 jmp .readMBR62
.readMBR69:
;-497 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-498 	}

;-499 }

.readMBR60:
;-500 

;-501 int getBootSector() {

 .retnreadMBR:
 LEAVE
 ret
readMBR_0 db " Boot part. found",0
readMBR_1 db ", FAT12 part. <32MB",0
readMBR_2 db ", small FAT16 part.<32MB",0
readMBR_3 db ", large FAT16 part.",0
ENDP

getBootSector: PROC
;-502 	int i;

;-503 	if (debug) cputs(" Boot sector:");

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;93 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 0
 or  al, al
 je .getBootSector70
 push getBootSector_0
 call cputs
 add  sp, 2
;-504   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

.getBootSector70:
;-505   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-506 	if (debug) printhex16(BIOS_Status);

 mov ax, 0
 or  al, al
 je .getBootSector71
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-507 	if (BIOS_ERR) {

.getBootSector71:
 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector72
;-508 		Int13hError();

 call Int13hError
;-509 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-510 		}

;-511 	else {

 jmp .getBootSector73
.getBootSector72:
;-512 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .getBootSector74
 mov ax, 0
 jmp .retngetBootSector
;-513 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector74:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-514 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector75
 push getBootSector_1
 call cputs
 add  sp, 2
;-515 		i=2;

.getBootSector75:
 mov ax, 2
 mov [bp-2], ax
;-516 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector76
 push getBootSector_2
 call cputs
 add  sp, 2
;-517 	}

.getBootSector76:
;-518 	return 1;

.getBootSector73:
 mov ax, 1
 jmp .retngetBootSector
;-519 }

;-520 

;-521 int FATInit() {

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Boot sector:",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-522 	unsigned long templong;//converting word to dword

;-523 

;-524 	clust_sizeL = (long) bs_clust_size;

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;93 var unsg long templong = bp-4;
 ENTER  4,0
 xor eax, eax
 mov al, [bs_clust_size]
 mov dword [clust_sizeL], eax
;-525 	sector_sizeL= (long) bs_sect_size;

 xor eax, eax
 mov ax, [bs_sect_size]
 mov dword [sector_sizeL], eax
;-526 

;-527 	fat_FatStartSector = bs_res_sects;

 mov ax, [bs_res_sects]
 mov word [fat_FatStartSector], ax
;-528 	fat_FatStartSectorL= (long) fat_FatStartSector; 

 xor eax, eax
 mov ax, [fat_FatStartSector]
 mov dword [fat_FatStartSectorL], eax
;-529 	fat_FatSectors = bs_fat_size;

 mov ax, [bs_fat_size]
 mov word [fat_FatSectors], ax
;-530 	if (bs_num_fats == 2) fat_FatSectors=fat_FatSectors+fat_FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .FATInit77
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-531 

;-532 	fat_RootDirStartSectorL = (long)fat_FatStartSector + fat_FatSectors;

.FATInit77:
 xor eax, eax
 mov ax, [fat_FatStartSector]
 add ax, [fat_FatSectors]
 mov dword [fat_RootDirStartSectorL], eax
;-533 	

;-534 	fat_RootDirSectorsL = (long) bs_root_entr >> 4;//  ./. 16

 xor eax, eax
 mov ax, [bs_root_entr]
 shr ax, 4
 mov dword [fat_RootDirSectorsL], eax
;-535 		

;-536 	fat_DataStartSectorL = fat_RootDirStartSectorL + fat_RootDirSectorsL;

 mov eax, [fat_RootDirStartSectorL]
 add eax, [fat_RootDirSectorsL]
 mov dword [fat_DataStartSectorL], eax
;-537 

;-538 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .FATInit78
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-539 	DataSectors32=bs_tot_sect32 - fat_DataStartSectorL;

.FATInit78:
 mov eax, [bs_tot_sect32]
 sub eax, [fat_DataStartSectorL]
 mov dword [DataSectors32], eax
;-540 

;-541 	CountofClustersL=DataSectors32 / clust_sizeL;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [clust_sizeL]
 mov dword [CountofClustersL], eax
;-542 

;-543 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-544 	num_tracksL = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [num_tracksL], eax
;-545 

;-546 //	templong = (long) bs_num_heads;

;-547 //	fat_num_cylinders = num_tracksL / templong;//w=d/w

;-548 

;-549 	Sectors_per_cylinderL = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinderL], eax
;-550 	asm mov [Sectors_per_cylinderL + 2], dx;store high word

 mov [Sectors_per_cylinderL + 2], dx;store high word
;-551 

;-552 	templong = (long) 65525;

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-553 	if (CountofClustersL > templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jle .FATInit79
;-554 		trueFATtype=32;

 mov ax, 32
 mov byte [trueFATtype], al
;-555 		cputs(" FAT32 NOT supported");

 push FATInit_0
 call cputs
 add  sp, 2
;-556 		return 1;

 mov ax, 1
 jmp .retnFATInit
;-557 		}

;-558 	templong= (long) 4086;

.FATInit79:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-559 	if (CountofClustersL < templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jge .FATInit80
;-560 		trueFATtype=12;

 mov ax, 12
 mov byte [trueFATtype], al
;-561 		cputs(" FAT12");

 push FATInit_1
 call cputs
 add  sp, 2
;-562 		return 0;

 mov ax, 0
 jmp .retnFATInit
;-563 		}

;-564 	trueFATtype=16;

.FATInit80:
 mov ax, 16
 mov byte [trueFATtype], al
;-565 	if (debug) cputs(" FAT16");

 mov ax, 0
 or  al, al
 je .FATInit81
 push FATInit_2
 call cputs
 add  sp, 2
;-566 	return 0;

.FATInit81:
 mov ax, 0
 jmp .retnFATInit
;-567 }

;-568 

;-569 int Int13hExt() {

 .retnFATInit:
 LEAVE
 ret
FATInit_0 db " FAT32 NOT supported",0
FATInit_1 db " FAT12",0
FATInit_2 db " FAT16",0
ENDP

Int13hExt: PROC
;-570 	bx=0x55AA;

 mov  bx, 21930
;-571 	BIOS_Status=Int13hfunction(Drive, 0x41);

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-572 	asm mov [vAX], ax;

 mov [vAX], ax;
;-573 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-574 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported
;-575 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt82
;-576 		cputs(" Ext. NOT present");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-577 		Int13hError();

 call Int13hError
;-578 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-579 		}

;-580 	else if (debug) cputs(",Int13h Ext.");

 jmp .Int13hExt83
.Int13hExt82:
 mov ax, 0
 or  al, al
 je .Int13hExt84
 push Int13hExt_1
 call cputs
 add  sp, 2
;-581 	return 0;

.Int13hExt84:
.Int13hExt83:
 mov ax, 0
 jmp .retnInt13hExt
;-582 }

;-583 

;-584 int PrintDriveParameter() {

 .retnInt13hExt:
 ret
Int13hExt_0 db " Ext. NOT present",0
Int13hExt_1 db ",Int13h Ext.",0
ENDP

PrintDriveParameter: PROC
;-585 	unsigned long Lo;

;-586 // from Params

;-587 	putch(10);

;Function : PrintDriveParameter, Number local Var: 1
; # type sign width local variables
;93 var unsg long Lo = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-588 	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);

 push PrintDriveParameter_0
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-589 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-590 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-591 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-592 	putch('.');

 push 46
 call putch
 add  sp, 2
;-593 //from getPartitionData

;-594 	putch(10);

 push 10
 call putch
 add  sp, 2
;-595 	cputs("getPartitionData:No=");printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-596 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-597 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-598 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-599 	cputs("/");				printunsign(pt_StartSector);

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-600 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-601 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-602 	cputs("/");				printunsign(pt_EndSector);

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-603 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-604 	cputs(",Start=");		printlong(pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 push dword [pt_HiddenSector]
 call printlong
 add  sp, 4
;-605 	cputs(",Len=");			printlong(pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 push dword [pt_PartLen]
 call printlong
 add  sp, 4
;-606 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-607 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-608 	printlong(Lo);

 push dword [bp-4]
 call printlong
 add  sp, 4
;-609 	cputs(" MByte.");

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-610 //from getBootSector

;-611 	putch(10);

 push 10
 call putch
 add  sp, 2
;-612 	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-613 	putch(10);

 push 10
 call putch
 add  sp, 2
;-614 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-615 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-616 	putch(10);

 push 10
 call putch
 add  sp, 2
;-617 	cputs("Reserved sectors=");printunsign(bs_res_sects);

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-618 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-619 	putch(10);

 push 10
 call putch
 add  sp, 2
;-620 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-621 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-622 	putch(10);

 push 10
 call putch
 add  sp, 2
;-623 	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-624 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-625 	putch(10);

 push 10
 call putch
 add  sp, 2
;-626 	cputs("sectors per track=");printunsign(bs_sectors_per_track);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_sectors_per_track]
 call printunsign
 add  sp, 2
;-627 	cputs(".number of heads=");printunsign(bs_num_heads);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_heads]
 call printunsign
 add  sp, 2
;-628 	putch(10);

 push 10
 call putch
 add  sp, 2
;-629 	cputs("hidden sectors(long)=");printlong(bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 push dword [bs_hid_sects]
 call printlong
 add  sp, 4
;-630 	cputs(".sectors(long)=");printlong(bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 push dword [bs_tot_sect32]
 call printlong
 add  sp, 4
;-631 	putch(10);

 push 10
 call putch
 add  sp, 2
;-632 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-633 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-634 	putch(10);

 push 10
 call putch
 add  sp, 2
;-635 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-636 	cputs(".Volume serial(long)=");printlong(bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 push dword [bs_serial_num]
 call printlong
 add  sp, 4
;-637 	putch(10);

 push 10
 call putch
 add  sp, 2
;-638 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-639 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-640 //from FATInit

;-641 	putch(10);

 push 10
 call putch
 add  sp, 2
;-642 	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [fat_FatStartSector]
 call printunsign
 add  sp, 2
;-643 	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [fat_FatSectors]
 call printunsign
 add  sp, 2
;-644 	putch(10);

 push 10
 call putch
 add  sp, 2
;-645 	cputs("fat_RootDirStartSectorL="); printlong(fat_RootDirStartSectorL);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push dword [fat_RootDirStartSectorL]
 call printlong
 add  sp, 4
;-646 	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectorsL);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push dword [fat_RootDirSectorsL]
 call printunsign
 add  sp, 4
;-647 	putch(10);

 push 10
 call putch
 add  sp, 2
;-648 	cputs("fat_DataStartSectorL=");	printunsign(fat_DataStartSectorL);

 push PrintDriveParameter_38
 call cputs
 add  sp, 2
 push dword [fat_DataStartSectorL]
 call printunsign
 add  sp, 4
;-649 	cputs(", DataSectors32=");	printlong(DataSectors32);

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 push dword [DataSectors32]
 call printlong
 add  sp, 4
;-650 	putch(10);

 push 10
 call putch
 add  sp, 2
;-651 	cputs("CountofClustersL=");	printlong(CountofClustersL);

 push PrintDriveParameter_40
 call cputs
 add  sp, 2
 push dword [CountofClustersL]
 call printlong
 add  sp, 4
;-652 	cputs(", Sectors_per_cylinderL="); printlong(Sectors_per_cylinderL);

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 push dword [Sectors_per_cylinderL]
 call printlong
 add  sp, 4
;-653 	putch(10);

 push 10
 call putch
 add  sp, 2
;-654 	cputs("num_tracksL=");	printlong(num_tracksL);

 push PrintDriveParameter_42
 call cputs
 add  sp, 2
 push dword [num_tracksL]
 call printlong
 add  sp, 4
;-655 //	cputs(", fat_num_cylinders="); printunsign(fat_num_cylinders);

;-656 	getkey();

 call getkey
;-657 }

;-658 

;-659 //--------------------------------  file IO  -------------------

;-660 int error2(char *s) {

 LEAVE
 ret
PrintDriveParameter_0 db "Params:CylHeadSec=",0
PrintDriveParameter_1 db ", NoDrives=",0
PrintDriveParameter_2 db "getPartitionData:No=",0
PrintDriveParameter_3 db ",Boot=",0
PrintDriveParameter_4 db " ID=",0
PrintDriveParameter_5 db ",HdSeCy=",0
PrintDriveParameter_6 db "/",0
PrintDriveParameter_7 db "/",0
PrintDriveParameter_8 db "-",0
PrintDriveParameter_9 db "/",0
PrintDriveParameter_10 db "/",0
PrintDriveParameter_11 db ",Start=",0
PrintDriveParameter_12 db ",Len=",0
PrintDriveParameter_13 db " Sec=",0
PrintDriveParameter_14 db " MByte.",0
PrintDriveParameter_15 db "getBootSector:OEM name (MSDOS5.0)=",0
PrintDriveParameter_16 db "Bytes per sector(512)=",0
PrintDriveParameter_17 db ".Sectors per cluster(1,,128)=",0
PrintDriveParameter_18 db "Reserved sectors=",0
PrintDriveParameter_19 db ".Number of FAT(1,2)=",0
PrintDriveParameter_20 db "Root directory entries(512)=",0
PrintDriveParameter_21 db ".Total sectors(0 if > 32MB=",0
PrintDriveParameter_22 db "Media desc.(F8h for HD)=",0
PrintDriveParameter_23 db ".Sectors per FAT=",0
PrintDriveParameter_24 db "sectors per track=",0
PrintDriveParameter_25 db ".number of heads=",0
PrintDriveParameter_26 db "hidden sectors(long)=",0
PrintDriveParameter_27 db ".sectors(long)=",0
PrintDriveParameter_28 db "physical drive number=",0
PrintDriveParameter_29 db ".Windows NT check disk=",0
PrintDriveParameter_30 db "Extended signature(29h)=",0
PrintDriveParameter_31 db ".Volume serial(long)=",0
PrintDriveParameter_32 db "Volume label(NO NAME)=",0
PrintDriveParameter_33 db ".File system type(FAT16)=",0
PrintDriveParameter_34 db "FATInit:fat_FatStartSector:",0
PrintDriveParameter_35 db ", fat_FatSectors=",0
PrintDriveParameter_36 db "fat_RootDirStartSectorL=",0
PrintDriveParameter_37 db ", fat_RootDirSectors=",0
PrintDriveParameter_38 db "fat_DataStartSectorL=",0
PrintDriveParameter_39 db ", DataSectors32=",0
PrintDriveParameter_40 db "CountofClustersL=",0
PrintDriveParameter_41 db ", Sectors_per_cylinderL=",0
PrintDriveParameter_42 db "num_tracksL=",0
ENDP

error2: PROC
;-661 	putch(10);

;Function : error2, Number local Var: 1
; # type sign width local variables
;93 ptr sign byte s = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-662 	cputs("*** ERROR *** ");

 push error2_0
 call cputs
 add  sp, 2
;-663 	cputs(s);

 push word [bp+4]
 call cputs
 add  sp, 2
;-664 	DOS_ERR++;

 inc  byte[DOS_ERR]
;-665 }

;-666 // 1.

;-667 int readLogical(unsigned long SectorL) {//OUT:1 sector in DiskBuf

 LEAVE
 ret
error2_0 db "*** ERROR *** ",0
ENDP

readLogical: PROC
;-668 	unsigned int track; unsigned int head; unsigned int sect;

;-669 	SectorL = SectorL + bs_hid_sects;//d=d+d

;Function : readLogical, Number local Var: 4
; # type sign width local variables
;93 var unsg long SectorL = bp+4
;94 var unsg word track = bp-2
;95 var unsg word head = bp-4
;96 var unsg word sect = bp-6;
 ENTER  6,0
 mov eax, [bp+4]
 add eax, [bs_hid_sects]
 mov [bp+4], eax
;-670 	track = SectorL / Sectors_per_cylinderL;  //w=d/d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinderL]
 mov [bp-2], ax
;-671 	head  = SectorL % Sectors_per_cylinderL;  //w=d%d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinderL]
 mov eax, edx
 mov [bp-4], ax
;-672 	sect  = head            % bs_sectors_per_track;  //w=w%w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov ax, dx
 mov [bp-6], ax
;-673 	sect++;

 inc  word[bp-6]
;-674 	head  = head            / bs_sectors_per_track;	 //w=w/w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov [bp-4], ax
;-675 

;-676 	DiskSectorReadWrite(2, bs_drive_num, head, track/* =cyl */,

;-677 		sect, 1, DiskBufSeg , DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push 1
 push word [bp-6]
 push word [bp-2]
 push word [bp-4]
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 push 2
 call DiskSectorReadWrite
 add  sp, 16
;-678 }

;-679 // 2.a

;-680 int printDirEntry(int EntryNr) {

 LEAVE
 ret
ENDP

printDirEntry: PROC
;-681     unsigned int j;

;-682 	putch(10);

;Function : printDirEntry, Number local Var: 2
; # type sign width local variables
;93 var sign word EntryNr = bp+4
;94 var unsg word j = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-683 	printunsign(EntryNr);

 push word [bp+4]
 call printunsign
 add  sp, 2
;-684 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-685 	cputs(filename);

 lea  ax, [filename]
 push ax
 call cputs
 add  sp, 2
;-686 	cputs(" ATTR:");

 push printDirEntry_0
 call cputs
 add  sp, 2
;-687 	printhex8(dir_Attrib);	

 mov al, byte [dir_Attrib]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-688 	if (dir_Attrib &  1) cputs(" r/o");

 mov al, [dir_Attrib]
 and al, 1
 or  al, al
 je .printDirEntry85
 push printDirEntry_1
 call cputs
 add  sp, 2
;-689 	if (dir_Attrib &  2) cputs(" hid");

.printDirEntry85:
 mov al, [dir_Attrib]
 and al, 2
 or  al, al
 je .printDirEntry86
 push printDirEntry_2
 call cputs
 add  sp, 2
;-690 	if (dir_Attrib &  4) cputs(" sys");

.printDirEntry86:
 mov al, [dir_Attrib]
 and al, 4
 or  al, al
 je .printDirEntry87
 push printDirEntry_3
 call cputs
 add  sp, 2
;-691 	if (dir_Attrib &  8) cputs(" vol");		

.printDirEntry87:
 mov al, [dir_Attrib]
 and al, 8
 or  al, al
 je .printDirEntry88
 push printDirEntry_4
 call cputs
 add  sp, 2
;-692 	if (dir_Attrib & 16) cputs(" dir");

.printDirEntry88:
 mov al, [dir_Attrib]
 and al, 16
 or  al, al
 je .printDirEntry89
 push printDirEntry_5
 call cputs
 add  sp, 2
;-693 	if (dir_Attrib & 32) cputs(" arc");

.printDirEntry89:
 mov al, [dir_Attrib]
 and al, 32
 or  al, al
 je .printDirEntry90
 push printDirEntry_6
 call cputs
 add  sp, 2
;-694 	if (dir_Attrib == 0) cputs("    ");

.printDirEntry90:
 mov al, [dir_Attrib]
 cmp al, 0
 jne .printDirEntry91
 push printDirEntry_7
 call cputs
 add  sp, 2
;-695 	

;-696 	putch(' ');

.printDirEntry91:
 push 32
 call putch
 add  sp, 2
;-697 	j=dir_LastModDate & 31;//day

 mov ax, [dir_LastModDate]
 and ax, 31
 mov [bp-2], ax
;-698 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry92
 push 32
 call putch
 add  sp, 2
;-699 	printunsign(j);

.printDirEntry92:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-700 	putch('.');

 push 46
 call putch
 add  sp, 2
;-701 

;-702 	j=dir_LastModDate >> 5;//month

 mov ax, [dir_LastModDate]
 shr ax, 5
 mov [bp-2], ax
;-703 	j&=  15;

 and  word[bp-2], 15
;-704 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry93
 push 48
 call putch
 add  sp, 2
;-705 	printunsign(j);

.printDirEntry93:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-706 	putch('.');

 push 46
 call putch
 add  sp, 2
;-707 

;-708 	j=dir_LastModDate >> 9;//year

 mov ax, [dir_LastModDate]
 shr ax, 9
 mov [bp-2], ax
;-709 	j+= 1980;

 add  word[bp-2], 1980
;-710 	printunsign(j);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-711 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-712 	//putch(' ');

;-713 

;-714 	j=dir_LastModTime  >>11;//hour

 mov ax, [dir_LastModTime]
 shr ax, 11
 mov [bp-2], ax
;-715 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry94
 push 32
 call putch
 add  sp, 2
;-716 	printunsign(j);

.printDirEntry94:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-717 	putch(':');

 push 58
 call putch
 add  sp, 2
;-718 

;-719 	j=dir_LastModTime  >> 5;//minute

 mov ax, [dir_LastModTime]
 shr ax, 5
 mov [bp-2], ax
;-720 	j&=  63;

 and  word[bp-2], 63
;-721 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry95
 push 48
 call putch
 add  sp, 2
;-722 	printunsign(j);

.printDirEntry95:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-723 	putch(':');

 push 58
 call putch
 add  sp, 2
;-724 

;-725 	j=dir_LastModTime & 31;// 2 seconds

 mov ax, [dir_LastModTime]
 and ax, 31
 mov [bp-2], ax
;-726 	j=j+j;

 mov ax, [bp-2]
 add ax, [bp-2]
 mov [bp-2], ax
;-727 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry96
 push 48
 call putch
 add  sp, 2
;-728 	printunsign(j);

.printDirEntry96:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-729 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-730 

;-731 	cputs(" 1.Cl:"); 

 push printDirEntry_8
 call cputs
 add  sp, 2
;-732 	printunsign(dir_FirstCluster);

 push word [dir_FirstCluster]
 call printunsign
 add  sp, 2
;-733 	cputs(" Size:");

 push printDirEntry_9
 call cputs
 add  sp, 2
;-734 	printlong(dir_FileSize);

 push dword [dir_FileSize]
 call printlong
 add  sp, 4
;-735 	

;-736 }

;-737 

;-738 // 2.b

;-739 int fatDirSectorList(unsigned long startSector, unsigned long numsectors) {

 LEAVE
 ret
printDirEntry_0 db " ATTR:",0
printDirEntry_1 db " r/o",0
printDirEntry_2 db " hid",0
printDirEntry_3 db " sys",0
printDirEntry_4 db " vol",0
printDirEntry_5 db " dir",0
printDirEntry_6 db " arc",0
printDirEntry_7 db "    ",0
printDirEntry_8 db " 1.Cl:",0
printDirEntry_9 db " Size:",0
ENDP

fatDirSectorList: PROC
;-740     char *p;

;-741 	unsigned int EndDiskBuf;

;-742 	char isHide;//shows entries, NOT lfn, deleted or empty

;-743 	unsigned int EntryNr;

;-744 	EntryNr=0;

;Function : fatDirSectorList, Number local Var: 6
; # type sign width local variables
;93 var unsg long startSector = bp+4
;94 var unsg long numsectors = bp+8
;95 ptr sign byte p = bp-2
;96 var unsg word EndDiskBuf = bp-4
;97 var sign byte isHide = bp-6
;98 var unsg word EntryNr = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-8], ax
;-745 	do {

.fatDirSectorList97:
;-746 /*		putch(10);

;-747 		cputs("Sektor = "); 

;-748 		printlong(startSector);

;-749 		cputs(", numsectors = "); 

;-750 		printlong(numsectors);

;-751 		getkey();

;-752 */

;-753 		readLogical(startSector);

 push dword [bp+4]
 call readLogical
 add  sp, 4
;-754 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-755 		EndDiskBuf= p + bs_sect_size;		

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-756 		

;-757 		do {

.fatDirSectorList98:
;-758 			memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-759 			memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-760 			filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-761 			

;-762 			isHide=0;//show in listing

 mov ax, 0
 mov [bp-6], al
;-763 			if (*p ==    0) {//only empty entries following

 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorList99
;-764 				isHide++;

 inc  byte[bp-6]
;-765 				numsectors=1;//finish searching

 mov ax, 1
 mov [bp+8], eax
;-766 				p = EndDiskBuf;

 mov ax, [bp-4]
 mov [bp-2], ax
;-767 				}

;-768 			if (*p == 0xE5) isHide++;//deleted, free entry

.fatDirSectorList99:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 229
 jne .fatDirSectorList100
 inc  byte[bp-6]
;-769 			if (*p <=   31) isHide++;//part of LFN

.fatDirSectorList100:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 31
 jg  .fatDirSectorList101
 inc  byte[bp-6]
;-770 			if (dir_Attrib ==    15) isHide++;//LFN start

.fatDirSectorList101:
 mov al, [dir_Attrib]
 cmp al, 15
 jne .fatDirSectorList102
 inc  byte[bp-6]
;-771 					

;-772 			if (isHide == 0) printDirEntry(EntryNr);

.fatDirSectorList102:
 mov al, [bp-6]
 cmp al, 0
 jne .fatDirSectorList103
 push word [bp-8]
 call printDirEntry
 add  sp, 2
;-773 			p+=32;//get next entry

.fatDirSectorList103:
 add  word[bp-2], 32
;-774 			EntryNr++;

 inc  word[bp-8]
;-775 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorList104
 jmp .fatDirSectorList98
.fatDirSectorList104:
;-776 		startSector = startSector + 1;//long, do NOT use ++ or +=1

 mov eax, [bp+4]
 add eax, 1
 mov [bp+4], eax
;-777 		numsectors--;

 dec  dword[bp+8]
;-778 //mdump(DiskBuf, 512);

;-779 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorList105
 jmp .fatDirSectorList97
.fatDirSectorList105:
;-780 	CurCluster=0;//not found but not end

 mov ax, 0
 mov word [CurCluster], ax
;-781 }

;-782 

;-783 // 2.

;-784 int fatDirSectorSearch(unsigned long startSector,unsigned long numsectors) {

 LEAVE
 ret
ENDP

fatDirSectorSearch: PROC
;-785     //search for file name. IN:searchstr

;-786     char *p;

;-787 	unsigned int EndDiskBuf;

;-788 	fatfound=0;

;Function : fatDirSectorSearch, Number local Var: 4
; # type sign width local variables
;93 var unsg long startSector = bp+4
;94 var unsg long numsectors = bp+8
;95 ptr sign byte p = bp-2
;96 var unsg word EndDiskBuf = bp-4;
 ENTER  4,0
 mov ax, 0
 mov byte [fatfound], al
;-789 	do {

.fatDirSectorSearch106:
;-790 		readLogical(startSector);

 push dword [bp+4]
 call readLogical
 add  sp, 4
;-791 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-792 		EndDiskBuf= p + bs_sect_size;

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-793 		do {

.fatDirSectorSearch107:
;-794 			if (memcmp(p, searchstr, 11) == 0) {//found file name

 push 11
 lea  ax, [searchstr]
 push ax
 push word [bp-2]
 call memcmp
 add  sp, 6
 cmp ax, 0
 jne .fatDirSectorSearch108
;-795 				memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-796 				memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-797 				filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-798 				CurCluster   = dir_FirstCluster;

 mov ax, [dir_FirstCluster]
 mov word [CurCluster], ax
;-799 				FileSizeL  = dir_FileSize;

 mov eax, [dir_FileSize]
 mov dword [FileSizeL], eax
;-800 				fatfound=1;

 mov ax, 1
 mov byte [fatfound], al
;-801 			}

;-802 			if (*p == 0) return; //only empty entries following

.fatDirSectorSearch108:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorSearch109
 jmp .retnfatDirSectorSearch
;-803 			p+=32;//get next entry

.fatDirSectorSearch109:
 add  word[bp-2], 32
;-804 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorSearch110
 jmp .fatDirSectorSearch107
.fatDirSectorSearch110:
;-805 		startSector++;		

 inc  dword[bp+4]
;-806 		numsectors--;

 dec  dword[bp+8]
;-807 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorSearch111
 jmp .fatDirSectorSearch106
.fatDirSectorSearch111:
;-808 	CurCluster=0;//not found but not end

 mov ax, 0
 mov word [CurCluster], ax
;-809 }

;-810 

;-811 /*

;-812 // 3.

;-813 int fatRootSearch() {

;-814     fatDirSectorSearch(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-815 //	getkey();

;-816 //    fatDirSectorList(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-817 }

;-818 */

;-819 // 4.

;-820 int fatClusterAnalyse(unsigned int clust) {

 .retnfatDirSectorSearch:
 LEAVE
 ret
ENDP

fatClusterAnalyse: PROC
;-821 //OUT: CurSectorL, NextCluster

;-822 	unsigned long fatSectorL;

;-823 	unsigned int offset;

;-824 	char *p;

;-825 unsigned long offL;

;-826 

;-827 	CurSectorL = (long) clust - 2;

;Function : fatClusterAnalyse, Number local Var: 5
; # type sign width local variables
;93 var unsg word clust = bp+4
;94 var unsg long fatSectorL = bp-4
;95 var unsg word offset = bp-6
;96 ptr sign byte p = bp-8
;97 var unsg long offL = bp-12;
 ENTER  12,0
 xor eax, eax
 mov ax, [bp+4]
 sub ax, 2
 mov dword [CurSectorL], eax
;-828 	CurSectorL = CurSectorL * clust_sizeL;

 mov eax, [CurSectorL]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul dword [clust_sizeL]
 mov dword [CurSectorL], eax
;-829 	CurSectorL = CurSectorL + fat_DataStartSectorL;

 mov eax, [CurSectorL]
 add eax, [fat_DataStartSectorL]
 mov dword [CurSectorL], eax
;-830 	

;-831 //	fatSectorL=cluster*2/512+FatStartSector

;-832 	fatSectorL = (long) clust;

 xor eax, eax
 mov ax, [bp+4]
 mov [bp-4], eax
;-833 	fatSectorL = fatSectorL + fatSectorL;

 mov eax, [bp-4]
 add eax, [bp-4]
 mov [bp-4], eax
;-834 	fatSectorL = fatSectorL / sector_sizeL;		

 mov eax, [bp-4]
 xor edx, edx
 div dword [sector_sizeL]
 mov [bp-4], eax
;-835 	fatSectorL = fatSectorL + fat_FatStartSectorL; 

 mov eax, [bp-4]
 add eax, [fat_FatStartSectorL]
 mov [bp-4], eax
;-836 	readLogical(fatSectorL);

 push dword [bp-4]
 call readLogical
 add  sp, 4
;-837 	

;-838 	offset = clust + clust;//todo overflow?

 mov ax, [bp+4]
 add ax, [bp+4]
 mov [bp-6], ax
;-839 	offset = offset % bs_sect_size;

 mov ax, [bp-6]
 xor dx, dx
 div word [bs_sect_size]
 mov ax, dx
 mov [bp-6], ax
;-840 	

;-841 	p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-8], ax
;-842 	p = p + offset;	

 mov ax, [bp-8]
 add ax, [bp-6]
 mov [bp-8], ax
;-843 	memcpy(&NextCluster, p, 2);//OUT: NextCluster

 push 2
 push word [bp-8]
 lea  ax, [NextCluster]
 push ax
 call memcpy
 add  sp, 6
;-844 }

;-845 /*

;-846 // 5.

;-847 int fatDirSearch() {//search a directory chain. IN:searchstr

;-848 	

;-849 	fatClusterAnalyse(fatfile_cluster);

;-850 	//OUT: fatfile_sectorStartL, fatfile_nextCluster

;-851 

;-852 	fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster); 

;-853 	while (fatfile_cluster == 0) {//not found but not end

;-854 		if (fatfile_nextCluster >= 0xFFF8) {

;-855 			fat_notfound=1;

;-856 			return;	

;-857 		}		

;-858 		fatfile_cluster=fatfile_nextCluster;

;-859 		fatClusterAnalyse(fatfile_cluster);

;-860 		fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster);

;-861 	}	

;-862 }

;-863 */	

;-864 

;-865 int is_delimiter(char *s) {

 LEAVE
 ret
ENDP

is_delimiter: PROC
;-866 	if (*s == '/' ) return 1;

;Function : is_delimiter, Number local Var: 1
; # type sign width local variables
;93 ptr sign byte s = bp+4;
 ENTER  0,0
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 47
 jne .is_delimiter112
 mov ax, 1
 jmp .retnis_delimiter
;-867 	if (*s == '\\') return 1;

.is_delimiter112:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 92
 jne .is_delimiter113
 mov ax, 1
 jmp .retnis_delimiter
;-868 	if (*s ==    0) return 2;

.is_delimiter113:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .is_delimiter114
 mov ax, 2
 jmp .retnis_delimiter
;-869 	if (*s ==  '.') return 3;

.is_delimiter114:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 46
 jne .is_delimiter115
 mov ax, 3
 jmp .retnis_delimiter
;-870 	return 0;

.is_delimiter115:
 mov ax, 0
 jmp .retnis_delimiter
;-871 }

;-872 

;-873 // 6.

;-874 int fatNextSearch() {//get next part of filename to do a search

 .retnis_delimiter:
 LEAVE
 ret
ENDP

fatNextSearch: PROC
;-875 //	IN:  upto: points to start of search in filename 

;-876 //	OUT: upto: points to search for next time

;-877 //	OUT: searchstr: part of filename in DIR-format with blanks (11bytes)

;-878 //	OUT: isfilename: 0=part of directory, 1=filename

;-879 //	OUT: fatfound

;-880 	char *searchstrp;

;-881 	char *p; 

;-882 	unsigned int  len;

;-883 	unsigned int delimiter;

;-884 

;-885 	delimiter=is_delimiter(upto);

;Function : fatNextSearch, Number local Var: 4
; # type sign width local variables
;93 ptr sign byte searchstrp = bp-2
;94 ptr sign byte p = bp-4
;95 var unsg word len = bp-6
;96 var unsg word delimiter = bp-8;
 ENTER  8,0
 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-886 	if (delimiter == 1) upto++;

 mov ax, [bp-8]
 cmp ax, 1
 jne .fatNextSearch116
 inc  word[upto]
;-887 	if (delimiter == 2) return; 

.fatNextSearch116:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch117
 jmp .retnfatNextSearch
;-888 

;-889 	strcpy(&searchstr, "           ");//11 blank padded

.fatNextSearch117:
 push fatNextSearch_0
 lea  ax, [searchstr]
 push ax
 call strcpy
 add  sp, 4
;-890 	searchstrp = &searchstr;//clear searchstr

 mov ax, searchstr
 mov [bp-2], ax
;-891 	len=0;

 mov ax, 0
 mov [bp-6], ax
;-892 	delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-893 	while (delimiter == 0) { //no slash, zero, point

.fatNextSearch118:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch119
;-894 		*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-895 		searchstrp++;

 inc  word[bp-2]
;-896 		upto++;	

 inc  word[upto]
;-897 		len++;

 inc  word[bp-6]
;-898 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-899 	} 

;-900 	if (len > 8) return;

 jmp .fatNextSearch118
.fatNextSearch119:
 mov ax, [bp-6]
 cmp ax, 8
 jle .fatNextSearch120
 jmp .retnfatNextSearch
;-901 	isfilename=0;//todo: default directory, not yet implemented

.fatNextSearch120:
 mov ax, 0
 mov byte [isfilename], al
;-902 	if (delimiter == 2) isfilename=1;//last name is always a file name

 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch121
 mov ax, 1
 mov byte [isfilename], al
;-903 	if (delimiter == 3) {//remove dot in name		

.fatNextSearch121:
 mov ax, [bp-8]
 cmp ax, 3
 jne .fatNextSearch122
;-904 		searchstrp = &searchstr;

 mov ax, searchstr
 mov [bp-2], ax
;-905 		searchstrp += 8;//start extension		

 add  word[bp-2], 8
;-906 		len=0;

 mov ax, 0
 mov [bp-6], ax
;-907 		upto++;

 inc  word[upto]
;-908 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-909 		while (delimiter == 0) { //no slash, zero, point

.fatNextSearch123:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch124
;-910 			*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-911 			searchstrp++;

 inc  word[bp-2]
;-912 			upto++;	

 inc  word[upto]
;-913 			len++;

 inc  word[bp-6]
;-914 			delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-915 		} 

;-916 		if (len > 3) return;

 jmp .fatNextSearch123
.fatNextSearch124:
 mov ax, [bp-6]
 cmp ax, 3
 jle .fatNextSearch125
 jmp .retnfatNextSearch
;-917 		if (delimiter == 2) isfilename=1;//last name is always a file name

.fatNextSearch125:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch126
 mov ax, 1
 mov byte [isfilename], al
;-918 	}

.fatNextSearch126:
;-919 	fatfound=1;	

.fatNextSearch122:
 mov ax, 1
 mov byte [fatfound], al
;-920 }

;-921 

;-922 // 7.

;-923 int fatGetStartCluster() {//lastBytes, lastSectors

 .retnfatNextSearch:
 LEAVE
 ret
fatNextSearch_0 db "           ",0
ENDP

fatGetStartCluster: PROC
;-924 	fatfound=0;

 mov ax, 0
 mov byte [fatfound], al
;-925 	toupper(filename);

 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-926 	upto = &filename;

 mov ax, filename
 mov word [upto], ax
;-927 	fatNextSearch();

 call fatNextSearch
;-928 

;-929 	if (debug) {putch(10); cputsLen(searchstr, 11);

 mov ax, 0
 or  al, al
 je .fatGetStartCluster127
 push 10
 call putch
 add  sp, 2
 push 11
 lea  ax, [searchstr]
 push ax
 call cputsLen
 add  sp, 4
;-930 //		cputs(",FName="); printunsign(isfilename); 

;-931 		}

;-932 	if (isfilename == 0) return; //todo not implemented

.fatGetStartCluster127:
 mov al, [isfilename]
 cmp al, 0
 jne .fatGetStartCluster128
 jmp .retnfatGetStartCluster
;-933 	if (fatfound) 	fatDirSectorSearch(fat_RootDirStartSectorL, fat_RootDirSectorsL); 

.fatGetStartCluster128:
 mov al, [fatfound]
 or  al, al
 je .fatGetStartCluster129
 push dword [fat_RootDirSectorsL]
 push dword [fat_RootDirStartSectorL]
 call fatDirSectorSearch
 add  sp, 8
;-934 }

.fatGetStartCluster129:
;-935 

;-936 /*

;-937 // 8.

;-938 int fatOpenFile() {//set handle for root or subdir

;-939 	unsigned long bytes_per_cluster;

;-940 	fat_notfound=0;

;-941 	if (debug) cputs("fatOpenfile ");	

;-942 	if (filename[0] == 0) {//empty filename

;-943 //	if (strlen(filename) == 0) {//empty filename

;-944 		fat_notfound=1;//todo: return

;-945 		

;-946 		fatfile_root = 1;

;-947 		fatfile_nextCluster = 0xFFFF;

;-948 		fatfile_sectorCount = fat_RootDirSectorsL;

;-949 		fatfile_sectorStartL = fat_RootDirStartSectorL;

;-950 		fatfile_lastBytes   = 0;

;-951 		fatfile_lastSectors = fat_RootDirSectorsL;

;-952 		fatfile_cluster     = 0;

;-953 		fatfile_dir         = 1;

;-954 

;-955 	} else {//search in subdir

;-956 		fatfile_root = 0;

;-957 		fatGetStartCluster();

;-958 		if (fat_notfound) return 1;

;-959 		bytes_per_cluster   = (long) bs_clust_size * bs_sect_size;

;-960 		fatfile_lastBytes   = fatfile_fileSize % bytes_per_cluster;

;-961 		fatfile_lastSectors = fatfile_lastBytes / bs_sect_size;

;-962 		fatfile_lastBytes   = fatfile_lastBytes % bs_sect_size;

;-963 		if (fatfile_fileSize == 0) fatfile_dir = 1;

;-964 		else                       fatfile_dir = 0;

;-965 

;-966 //		fatClusterAnalyse();

;-967 		fatfile_sectorCount = (int) bs_clust_size;

;-968 	}

;-969 	fatfile_currentCluster = fatfile_cluster;

;-970 	fatfile_sectorUpto = 0;

;-971 	fatfile_byteUpto   = 0;

;-972 	if (fat_notfound) return 1;

;-973 	return 0;

;-974 }

;-975 */

;-976 

;-977 // 9.

;-978 int fatReadFile() {// reads 1 byte from an already open file

 .retnfatGetStartCluster:
 ret
ENDP

fatReadFile: PROC
;-979 //	IN: CurCluster, FileSizeL

;-980 	fatGetStartCluster();

 call fatGetStartCluster
;-981 	if (fatfound == 0) {

 mov al, [fatfound]
 cmp al, 0
 jne .fatReadFile130
;-982 		cputs(" file not found"); 

 push fatReadFile_0
 call cputs
 add  sp, 2
;-983 		return;

 jmp .retnfatReadFile
;-984 		}

;-985 cputs(",1.Cl="); printunsign(CurCluster);

.fatReadFile130:
 push fatReadFile_1
 call cputs
 add  sp, 2
 push word [CurCluster]
 call printunsign
 add  sp, 2
;-986 	fatClusterAnalyse(CurCluster);

 push word [CurCluster]
 call fatClusterAnalyse
 add  sp, 2
;-987 //cputs(",secStartL="); printlong(CurSectorL);

;-988 cputs(",ClSz="); printlong(clust_sizeL);

 push fatReadFile_2
 call cputs
 add  sp, 2
 push dword [clust_sizeL]
 call printlong
 add  sp, 4
;-989 cputs(",Size="); printlong(FileSizeL);

 push fatReadFile_3
 call cputs
 add  sp, 2
 push dword [FileSizeL]
 call printlong
 add  sp, 4
;-990 cputs(",NextCl="); printunsign(NextCluster);

 push fatReadFile_4
 call cputs
 add  sp, 2
 push word [NextCluster]
 call printunsign
 add  sp, 2
;-991 	readLogical(CurSectorL);

 push dword [CurSectorL]
 call readLogical
 add  sp, 4
;-992 	mdump(DiskBuf, 512);

 push 512
 lea  ax, [DiskBuf]
 push ax
 call mdump
 add  sp, 4
;-993 	

;-994 		

;-995 }

;-996 //------------------------------- OS functions --------------

;-997 //handle: 0=in, 1=out, 2=err, 3=aux, 4=prn, 255=error

;-998 int OSOpenFile(char *name) {//remove drive letter and uppercase

 .retnfatReadFile:
 ret
fatReadFile_0 db " file not found",0
fatReadFile_1 db ",1.Cl=",0
fatReadFile_2 db ",ClSz=",0
fatReadFile_3 db ",Size=",0
fatReadFile_4 db ",NextCl=",0
ENDP

OSOpenFile: PROC
;-999 	int i;

;-1000 	if (strlen(name) == 0) return 255; //empty filename

;Function : OSOpenFile, Number local Var: 2
; # type sign width local variables
;93 ptr sign byte name = bp+4
;94 var sign word i = bp-2;
 ENTER  2,0
 push word [bp+4]
 call strlen
 add  sp, 2
 cmp ax, 0
 jne .OSOpenFile131
 mov ax, 255
 jmp .retnOSOpenFile
;-1001 	

;-1002 	strcpy(filename, name);

.OSOpenFile131:
 push word [bp+4]
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1003 	toupper(filename);

 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-1004 

;-1005 cputs(",filename=");cputs(filename);

 push OSOpenFile_0
 call cputs
 add  sp, 2
 lea  ax, [filename]
 push ax
 call cputs
 add  sp, 2
;-1006 cputs(" strlen="); i=strlen(filename); printunsign(i);

 push OSOpenFile_1
 call cputs
 add  sp, 2
 lea  ax, [filename]
 push ax
 call strlen
 add  sp, 2
 mov [bp-2], ax
 push word [bp-2]
 call printunsign
 add  sp, 2
;-1007 

;-1008 

;-1009 

;-1010 //	rc=fatOpenFile();

;-1011 //	cputs(" rc="); printunsign(rc);

;-1012 

;-1013 	return 5;

 mov ax, 5
 jmp .retnOSOpenFile
;-1014 }

;-1015 

;-1016 int OSReadFile(char hd) {

 .retnOSOpenFile:
 LEAVE
 ret
OSOpenFile_0 db ",filename=",0
OSOpenFile_1 db " strlen=",0
ENDP

OSReadFile: PROC
;-1017 	

;-1018 }

;Function : OSReadFile, Number local Var: 1
; # type sign width local variables
;93 var sign byte hd = bp+4;
 ENTER  0,0
;-1019 

;-1020 //------------------------------- Init,  main ---------------

;-1021 int Init() {

 LEAVE
 ret
ENDP

Init: PROC
;-1022 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-1023 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-1024 	if (debug) cputs(" Init");

 mov ax, 0
 or  al, al
 je .Init132
 push Init_0
 call cputs
 add  sp, 2
;-1025 	if (Params()) cputs(" ** NO DRIVE PARAMS FOUND **");//no hard disk

.Init132:
 call Params
 or  al, al
 je .Init133
 push Init_1
 call cputs
 add  sp, 2
;-1026 	if (readMBR() == 0) {//0=error,1=FAT12,6=FAT16,11=FAT32	

.Init133:
 call readMBR
 cmp al, 0
 jne .Init134
;-1027 		cputs(" ** no active FAT partition found **");

 push Init_2
 call cputs
 add  sp, 2
;-1028 		return 1;

 mov ax, 1
 jmp .retnInit
;-1029 		}

;-1030 	if(getBootSector()==0) 	return 1;

.Init134:
 call getBootSector
 cmp al, 0
 jne .Init135
 mov ax, 1
 jmp .retnInit
;-1031 	if (FATInit())			return 1;

.Init135:
 call FATInit
 or  al, al
 je .Init136
 mov ax, 1
 jmp .retnInit
;-1032 	if(trueFATtype != 16) 	return 1;

.Init136:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init137
 mov ax, 1
 jmp .retnInit
;-1033 	Int13hExt();

.Init137:
 call Int13hExt
;-1034 	return 0;

 mov ax, 0
 jmp .retnInit
;-1035 }

;-1036 int main() {

 .retnInit:
 ret
Init_0 db " Init",0
Init_1 db " ** NO DRIVE PARAMS FOUND **",0
Init_2 db " ** no active FAT partition found **",0
ENDP

main: PROC
;-1037 	if (Init() != 0) return 1;

 call Init
 cmp al, 0
 je  .main138
 mov ax, 1
 jmp .retnmain
;-1038 	if (debug) PrintDriveParameter();

.main138:
 mov ax, 0
 or  al, al
 je .main139
 call PrintDriveParameter
;-1039 	

;-1040 	handle=OSOpenFile("dos.com");	

.main139:
 push main_0
 call OSOpenFile
 add  sp, 2
 mov byte [handle], al
;-1041 cputs(" handle="); printunsign(handle);

 push main_1
 call cputs
 add  sp, 2
 mov al, byte [handle]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-1042 	if (handle == 255) {

 mov al, [handle]
 cmp al, 255
 jne .main140
;-1043 		cputs(" ** no handle **");

 push main_2
 call cputs
 add  sp, 2
;-1044 

;-1045 		}

;-1046 		

;-1047 //	OSReadFile(handle);

;-1048 	

;-1049 		handle=OSOpenFile("readme.md");	

.main140:
 push main_3
 call OSOpenFile
 add  sp, 2
 mov byte [handle], al
;-1050 cputs(" handle="); printunsign(handle);

 push main_4
 call cputs
 add  sp, 2
 mov al, byte [handle]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-1051 		handle=OSOpenFile("cm.bat");	

 push main_5
 call OSOpenFile
 add  sp, 2
 mov byte [handle], al
;-1052 cputs(" handle="); printunsign(handle);

 push main_6
 call cputs
 add  sp, 2
 mov al, byte [handle]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-1053 		handle=OSOpenFile("Z");	

 push main_7
 call OSOpenFile
 add  sp, 2
 mov byte [handle], al
;-1054 cputs(" handle="); printunsign(handle);

 push main_8
 call cputs
 add  sp, 2
 mov al, byte [handle]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-1055 		handle=OSOpenFile("");	

 push main_9
 call OSOpenFile
 add  sp, 2
 mov byte [handle], al
;-1056 cputs(" handle="); printunsign(handle);

 push main_10
 call cputs
 add  sp, 2
 mov al, byte [handle]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-1057 

;-1058 

;-1059 	if (debug) cputs(" End.");

 mov ax, 0
 or  al, al
 je .main141
 push main_11
 call cputs
 add  sp, 2
;-1060 

;-1061 }

.main141:
;-1062 /*cputs(" delimiter="); printunsign(delimiter);

;-1063 cputs(", isfilename="); printunsign(isfilename);

;-1064 cputs(", upto="); printunsign(upto);

;-1065 cputs("="); cputs(upto);

;-1066 cputs(", len="); printunsign(len);

;-1067 cputs(", searchstr="); cputsLen(searchstr, len);

;-1068 */

;-1069 /*

;-1070 	OSOpenFile

;-1071 	OSReadFile

;-1072 9. fatReadFile

;-1073 8. fatOpenFile set handle, init root or subdir

;-1074 	s7 fatGetStartCluster

;-1075 	s4 fatClusterAnalyse

;-1076 7. fatGestStartCluster

;-1077 	6 fatNextSearch

;-1078 	3 fatRootSearch

;-1079 	s5 fatDirSearch

;-1080 6. fatNextSearch Upto,search,isFilename =>7

;-1081 5. fatDirSearch a directory chain for search

;-1082 	4 fatClusterAnalyse

;-1083 	2 fatDieSectorSearch

;-1084 4. fatClusterAnalysedetermines sector by cluster number, next cluster

;-1085 	1 ReadLogical

;-1086 3. fatRootSearch search the root for an entry

;-1087 	2 fatDirSectorSearch

;-1088 2. fatDirSectorSearch search a block of sectors for entries,

;-1089 		get starting cluster, file size, notfound

;-1090 	1 readLogical

;-1091 2.a printDirEntry

;-1092 2.b fatDirSectorList

;-1093 	1 readLogical					

;-1094 1. readLogical

;-1095 	DiskSectorReadWrite	

;-1096 */

;-1097 /*

;-1098 bin_file=fopen("name", "rb") //binary

;-1099 int = fgetc(in_file)	     //EOF(-1)

;-1100 fputc(character, file)

;-1101 printf() = fprintf(stdout, format, parameter1) //buffered I/O

;-1102 DOS: add CR13 to LF10

;-1103 read_size=fread(data_ptr, 1, size, file) //binary read

;-1104 file_descriptor=open(name, flags, mode=0666) //unbuffered I/O

;-1105 read_size=read(file_descriptor, buffer, size) //unbufferes I/O 

;-1106 */

 .retnmain:
 ret
main_0 db "dos.com",0
main_1 db " handle=",0
main_2 db " ** no handle **",0
main_3 db "readme.md",0
main_4 db " handle=",0
main_5 db "cm.bat",0
main_6 db " handle=",0
main_7 db "Z",0
main_8 db " handle=",0
main_9 db "",0
main_10 db " handle=",0
main_11 db " End.",0
ENDP
