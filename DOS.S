;A.COM V1.1.4, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.2.0";//test bed

Version1 db "DOS.COM V0.2.0",0
;-2 //Finder /hg/DOS/DOS3.vhd

;-3 //rigth click / open / Parallels Mounter

;-4 // (E)DX:(E)AX DIV r/m16(32) = (E)AX, remainder (E)DX

;-5 // AL*r/m8=AX; AX*r/m16=DX:AX; EAX*r/m32=EDX:EAX

;-6 // > 16.777.216 sectors (8GB) only LBA

;-7 #define ORGDATA		16384//start of arrays

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
;-20 //unsigned long sect_size_long;

;-21 unsigned long clust_sizeL;

clust_sizeL dd 0
;-22 unsigned long sector_sizeL;

sector_sizeL dd 0
;-23 unsigned char filename[67];

section .bss
absolute 16897
filename resb 67
section .text
;-24 unsigned char searchstr  [12];//with null

section .bss
absolute 16964
searchstr resb 12
section .text
;-25 char *upto;		//IN:part of filename to search/OUT:to search next time

upto dw 0
;-26 char isfilename;//is filename or part of directory?

isfilename db 0
;-27 char fat_notfound;

fat_notfound db 0
;-28 

;-29 //Params from int13h, Function 8

;-30 unsigned int  pa_Cylinders;

pa_Cylinders dw 0
;-31 unsigned char pa_Sectors;

pa_Sectors db 0
;-32 unsigned char pa_Heads;

pa_Heads db 0
;-33 unsigned char pa_Attached;

pa_Attached db 0
;-34 unsigned int  pt_PartNo;

pt_PartNo dw 0
;-35 

;-36 //start hard disk partition structure 16 bytes in MBR. do not change

;-37 unsigned char pt_Bootable;		// 00 80h = active partition, else 00

pt_Bootable db 0
;-38 unsigned char pt_StartHead;		// 01

pt_StartHead db 0
;-39 unsigned char pt_StartSector;	// 02 bits 0-5

pt_StartSector db 0
;-40 unsigned int  pt_StartCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-41 unsigned char pt_FileSystem;	// 04 0=nu,1=FAT12,4=16,5=ExtP,6=large16

pt_FileSystem db 0
;-42 unsigned char pt_EndHead;		// 05

pt_EndHead db 0
;-43 unsigned char pt_EndSector;		// 06 bits 0-5

pt_EndSector db 0
;-44 unsigned int  pt_EndCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-45 unsigned long pt_HiddenSector;	// 08 sectors preceding partition

pt_HiddenSector dd 0
;-46 unsigned long pt_PartLen;    	// 12 length of partition in sectors

pt_PartLen dd 0
;-47 //  16 end hard disk partition structure

;-48 

;-49 //start boot BIOS Parameter Block structure. do not change

;-50 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-51 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-52 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-53 unsigned char bs_clust_size;// 13 sectors per cluster (1,2,4,..,128)

bs_clust_size db 0
;-54 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-55 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-56 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-57 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-58 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-59 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-60 unsigned int  bs_sectors_per_track; // 24 (DOS 3+)sectors per track

bs_sectors_per_track dw 0
;-61 unsigned int  bs_num_heads;	// 26 (DOS 3+)number of heads

bs_num_heads dw 0
;-62 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors

bs_hid_sects dd 0
;-63 unsigned long bs_tot_sect32;// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-64 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-65 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-66 unsigned char bs_ext_signat;// 38 (DOS 4+) Ext. signature,get next 3(29h)

bs_ext_signat db 0
;-67 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-68 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-69 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-70 // 62 end boot BIOS Parameter Block

;-71 

;-72 //start directory entry structure, do not change

;-73 unsigned char dir_Filename[]="1234567";	//00 +lengthbyte=11

dir_Filename db "1234567",0
;-74 unsigned char dir_Ext[]="12";	//07 +lengthbyte=3

dir_Ext db "12",0
;-75 unsigned char dir_Attrib;		//11 directory=10h, Label=08h, read only=1

dir_Attrib db 0
;-76 unsigned char dir_NTReserved;	//12 low case in body=8h, in ext=10h

dir_NTReserved db 0
;-77 unsigned char dir_TimeCreatedMS;//13 in 10 milliseconda or zero

dir_TimeCreatedMS db 0
;-78 unsigned int  dir_TimeCreated;	//14 creation time, resolution 2 sec. or 0

dir_TimeCreated dw 0
;-79 unsigned int  dir_DateCreated;	//16 creation date or zero

dir_DateCreated dw 0
;-80 unsigned int  dir_DateLastAccessd;		//18 no time info available or zero

dir_DateLastAccessd dw 0
;-81 unsigned int  dir_FirstClusterHiBytes;	//20 FAT12/16 always zero

dir_FirstClusterHiBytes dw 0
;-82 unsigned int  dir_LastModTime;	//22 modification time on closing

dir_LastModTime dw 0
;-83 unsigned int  dir_LastModDate;	//24 modification date on closing

dir_LastModDate dw 0
;-84 unsigned int  dir_FirstCluster;	//26 1.clu. of file data,if filesize=0 then 0

dir_FirstCluster dw 0
;-85 unsigned long dir_FileSize;		//28 size in bytes, if directory then zero

dir_FileSize dd 0
;-86 // 32 end direcctory entry structure

;-87 

;-88 //FATInit

;-89 unsigned int  fat_FatStartSector;

fat_FatStartSector dw 0
;-90 unsigned long fat_FatStartSectorL;

fat_FatStartSectorL dd 0
;-91 unsigned int  fat_FatSectors;

fat_FatSectors dw 0
;-92 unsigned long fat_RootDirStartSectorL;

fat_RootDirStartSectorL dd 0
;-93 unsigned long fat_RootDirSectorsL;

fat_RootDirSectorsL dd 0
;-94 unsigned long fat_DataStartSectorL;

fat_DataStartSectorL dd 0
;-95 unsigned long fat_num_tracks;

fat_num_tracks dd 0
;-96 unsigned int  fat_num_cylinders;

fat_num_cylinders dw 0
;-97 unsigned long Sectors_per_cylinder;

Sectors_per_cylinder dd 0
;-98 unsigned long DataSectors32;

DataSectors32 dd 0
;-99 unsigned long CountofClusters;

CountofClusters dd 0
;-100 unsigned char trueFATtype;	//12, 16, 32 from FATInit

trueFATtype db 0
;-101 unsigned int  FATtype;		//0=error,1=FAT12,6=FAT16,11=FAT32 from ReadMBR

FATtype dw 0
;-102 

;-103 //fatfile

;-104 //unsigned char fat_filename [8];

;-105 //unsigned char fat_fileext  [3];

;-106 		 int  fatfile_root;

fatfile_root dw 0
;-107 unsigned int  fatfile_cluster;

fatfile_cluster dw 0
;-108 unsigned int  fatfile_nextCluster;

fatfile_nextCluster dw 0
;-109 unsigned int  fatfile_sectorCount;

fatfile_sectorCount dw 0
;-110 unsigned long fatfile_sectorStartL;

fatfile_sectorStartL dd 0
;-111 unsigned int  fatfile_lastBytes;

fatfile_lastBytes dw 0
;-112 unsigned int  fatfile_lastSectors;

fatfile_lastSectors dw 0
;-113          int  fatfile_dir;

fatfile_dir dw 0
;-114 unsigned int  fatfile_currentCluster;

fatfile_currentCluster dw 0
;-115 unsigned int  fatfile_sectorUpto;

fatfile_sectorUpto dw 0
;-116 unsigned int  fatfile_byteUpto;

fatfile_byteUpto dw 0
;-117 unsigned long fatfile_fileSize;

fatfile_fileSize dd 0
;-118 

;-119 int test() {


test: PROC
;-120 	__asm{


;-121 }	}


;-122 

;-123 //------------------------------------   IO  -------------------

;-124 

;-125 int writetty()     {//char in AL

 ret
ENDP

writetty: PROC
;-126     ah=0x0E;

 mov  ah, 14
;-127     push bx;

push bx;
;-128     bx=0;			//page in BH

 mov  bx, 0
;-129     inth 0x10;		//16

 int  16
;-130     pop bx;

pop bx;
;-131 }

;-132 int putch(char c)  {

 ret
ENDP

putch: PROC
;-133     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;100 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-134         al=13;

 mov  al, 13
;-135         writetty();

 call writetty
;-136     }

;-137     al=c;

.putch1:
 mov  al, [bp+4]
;-138     writetty();

 call writetty
;-139 }

;-140 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-141     char c;

;-142     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;100 ptr sign byte s = bp+4
;101 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-143         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-144         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-145         s++;

 inc  word[bp+4]
;-146     }

;-147 }

 jmp .cputs2
.cputs3:
;-148 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-149 	char c;

;-150 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;100 ptr sign byte s = bp+4
;101 var sign word len = bp+6
;102 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-151 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-152 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-153 		s++;

 inc  word[bp+4]
;-154 		len--;

 dec  word[bp+6]
;-155 	} while (len > 0);

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-156 }

;-157 

;-158 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-159     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-160     inth 0x16;//AH=Scan code, AL=char

 int  22
;-161 }

;-162 int waitkey() {

 ret
ENDP

waitkey: PROC
;-163     ah=0x11;//get kbd status

 mov  ah, 17
;-164     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-165     //zero flag: 0=IS char, 1=NO char

;-166     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-167 }

;-168 int getkey() {

 ret
ENDP

getkey: PROC
;-169     waitkey();

 call waitkey
;-170     getch();

 call getch
;-171     ah=0;//clear scan code

 mov  ah, 0
;-172     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-173     //put ext code in AX

;-174 }

.getkey6:
;-175 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-176     getkey();

 call getkey
;-177     writetty();//destroys AH

 call writetty
;-178 }

;-179 

;-180 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-181     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;100 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-182     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-183     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-184 }

;-185 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-186     unsigned char nib;

;-187     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;100 var unsg byte c = bp+4
;101 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-188     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-189 }

;-190 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-191     unsigned int half;

;-192     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;100 var unsg word i = bp+4
;101 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-193     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-194 }

;-195 

;-196 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-197     unsigned int e;

;-198     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;100 var unsg word n = bp+4
;101 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-199         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-200         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-201         }

;-202     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-203     n+='0';

 add  word[bp+4], 48
;-204     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-205 }

;-206 

;-207 int printlong(unsigned long L) {

 LEAVE
 ret
ENDP

printlong: PROC
;-208     ax = L;     // get low in ax

;Function : printlong, Number local Var: 1
; # type sign width local variables
;100 var unsg long L = bp+4;
 ENTER  0,0
 mov  ax, [bp+4]
;-209     edx=L;

 mov  edx, [bp+4]
;-210     edx >> 16;  // get high in dx

 shr  edx, 16
;-211 __asm{


;-212   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-213     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-214 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-215     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-216     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-217 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-218     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-219     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-220     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-221     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-222     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-223     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-224     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-225     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-226 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-227 }	writetty();		__asm{


 call writetty

;-228     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-229     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-230     jb      .b             ;Not yet

    jb      .b             ;Not yet
;-231 }


;-232 }

;-233 //--------------------------------  string  ---------------------

;-234 int strlen(char *s) { int c;

 LEAVE
 ret
ENDP

strlen: PROC
;-235     c=0;

;Function : strlen, Number local Var: 2
; # type sign width local variables
;100 ptr sign byte s = bp+4
;101 var sign word c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-236     while (*s!=0) {s++; c++;}

.strlen9:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen10
 inc  word[bp+4]
 inc  word[bp-2]
;-237     return c;

 jmp .strlen9
.strlen10:
 mov ax, [bp-2]
 jmp .retnstrlen
;-238 }

;-239 int strcpy(char *s, char *t) {//new

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-240     while (*t!=0) {

;Function : strcpy, Number local Var: 2
; # type sign width local variables
;100 ptr sign byte s = bp+4
;101 ptr sign byte t = bp+6;
 ENTER  0,0
.strcpy11:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy12
;-241     	*s=*t; s++; t++; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-242     *s=0;

 jmp .strcpy11
.strcpy12:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-243     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-244 }

;-245 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-246     while(*p) {

;Function : eqstr, Number local Var: 2
; # type sign width local variables
;100 ptr sign byte p = bp+4
;101 ptr sign byte q = bp+6;
 ENTER  0,0
.eqstr13:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr14
;-247         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr15
 mov ax, 0
 jmp .retneqstr
;-248         p++;

.eqstr15:
 inc  word[bp+4]
;-249         q++;

 inc  word[bp+6]
;-250     }

;-251     if(*q) return 0;

 jmp .eqstr13
.eqstr14:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr16
 mov ax, 0
 jmp .retneqstr
;-252     return 1;

.eqstr16:
 mov ax, 1
 jmp .retneqstr
;-253 }

;-254 

;-255 int memcmp(char *s, char *t, unsigned int i) {

 .retneqstr:
 LEAVE
 ret
ENDP

memcmp: PROC
;-256     do {

;Function : memcmp, Number local Var: 3
; # type sign width local variables
;100 ptr sign byte s = bp+4
;101 ptr sign byte t = bp+6
;102 var unsg word i = bp+8;
 ENTER  0,0
.memcmp17:
;-257         if (*s < *t) return 0xFFFF;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 jge .memcmp18
 mov ax, 65535
 jmp .retnmemcmp
;-258         if (*s > *t) return 1;

.memcmp18:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 jle .memcmp19
 mov ax, 1
 jmp .retnmemcmp
;-259         s++; t++; i--;

.memcmp19:
 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-260     } while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcmp20
 jmp .memcmp17
.memcmp20:
;-261     return 0;

 mov ax, 0
 jmp .retnmemcmp
;-262 }

;-263 

;-264 int strcat(char *s, char *t) {

 .retnmemcmp:
 LEAVE
 ret
ENDP

strcat: PROC
;-265     while (*s != 0) s++;

;Function : strcat, Number local Var: 2
; # type sign width local variables
;100 ptr sign byte s = bp+4
;101 ptr sign byte t = bp+6;
 ENTER  0,0
.strcat21:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat22
 inc  word[bp+4]
;-266     strcpy(s, t);

 jmp .strcat21
.strcat22:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4
;-267 }

;-268 int toupper(char *s) {

 LEAVE
 ret
ENDP

toupper: PROC
;-269     while(*s) {

;Function : toupper, Number local Var: 1
; # type sign width local variables
;100 ptr sign byte s = bp+4;
 ENTER  0,0
.toupper23:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper24
;-270         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  .toupper25
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  .toupper26
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
;-271         s++;

.toupper26:
.toupper25:
 inc  word[bp+4]
;-272     }

;-273 }

 jmp .toupper23
.toupper24:
;-274 int strchr(char *s, char c) {

 LEAVE
 ret
ENDP

strchr: PROC
;-275     while(*s) {

;Function : strchr, Number local Var: 2
; # type sign width local variables
;100 ptr sign byte s = bp+4
;101 var sign byte c = bp+6;
 ENTER  0,0
.strchr27:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .strchr28
;-276         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .strchr29
 mov ax, [bp+4]
 jmp .retnstrchr
;-277         s++;

.strchr29:
 inc  word[bp+4]
;-278     }

;-279     return 0;

 jmp .strchr27
.strchr28:
 mov ax, 0
 jmp .retnstrchr
;-280 }

;-281 int memchr(char *s, char c, unsigned int i) {

 .retnstrchr:
 LEAVE
 ret
ENDP

memchr: PROC
;-282     while(i > 0) {

;Function : memchr, Number local Var: 3
; # type sign width local variables
;100 ptr sign byte s = bp+4
;101 var sign byte c = bp+6
;102 var unsg word i = bp+8;
 ENTER  0,0
.memchr30:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr31
;-283         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr32
 mov ax, [bp+4]
 jmp .retnmemchr
;-284         s++; i--;

.memchr32:
 inc  word[bp+4]
 dec  word[bp+8]
;-285     }

;-286     return 0;

 jmp .memchr30
.memchr31:
 mov ax, 0
 jmp .retnmemchr
;-287 }

;-288 int memchr1(char *s, char c, unsigned int i) {

 .retnmemchr:
 LEAVE
 ret
ENDP

memchr1: PROC
;-289 	unsigned int pos;

;-290 	pos=1;

;Function : memchr1, Number local Var: 4
; # type sign width local variables
;100 ptr sign byte s = bp+4
;101 var sign byte c = bp+6
;102 var unsg word i = bp+8
;103 var unsg word pos = bp-2;
 ENTER  2,0
 mov ax, 1
 mov [bp-2], ax
;-291     while(i > 0) {

.memchr133:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr134
;-292         if (*s==c) return pos;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr135
 mov ax, [bp-2]
 jmp .retnmemchr1
;-293         s++; i--; pos++;

.memchr135:
 inc  word[bp+4]
 dec  word[bp+8]
 inc  word[bp-2]
;-294     }

;-295     return 0;

 jmp .memchr133
.memchr134:
 mov ax, 0
 jmp .retnmemchr1
;-296 }

;-297 int instr1(char *s, char c) {

 .retnmemchr1:
 LEAVE
 ret
ENDP

instr1: PROC
;-298     while(*s) {

;Function : instr1, Number local Var: 2
; # type sign width local variables
;100 ptr sign byte s = bp+4
;101 var sign byte c = bp+6;
 ENTER  0,0
.instr136:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .instr137
;-299         if (*s==c) return 1;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .instr138
 mov ax, 1
 jmp .retninstr1
;-300         s++;

.instr138:
 inc  word[bp+4]
;-301     }

;-302     return 0;

 jmp .instr136
.instr137:
 mov ax, 0
 jmp .retninstr1
;-303 }

;-304 

;-305 int memcpy(char *s, char *t, unsigned int i) {

 .retninstr1:
 LEAVE
 ret
ENDP

memcpy: PROC
;-306 	unsigned int r;

;-307 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;100 ptr sign byte s = bp+4
;101 ptr sign byte t = bp+6
;102 var unsg word i = bp+8
;103 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-308 	do {

.memcpy39:
;-309 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-310 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-311 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy40
 jmp .memcpy39
.memcpy40:
;-312 	ax=r;//	return r;

 mov  ax, [bp-2]
;-313 }

;-314 

;-315 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-316     unsigned char c; int i; int j; int k;

;-317     j=0;

;Function : mdump, Number local Var: 6
; # type sign width local variables
;100 ptr unsg byte adr = bp+4
;101 var unsg word len = bp+6
;102 var unsg byte c = bp-2
;103 var sign word i = bp-4
;104 var sign word j = bp-6
;105 var sign word k = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-6], ax
;-318     k=0;

 mov ax, 0
 mov [bp-8], ax
;-319     while (j < len ) {

.mdump41:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump42
;-320 	    k++;;

 inc  word[bp-8]
;-321 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump43
;-322 		    getkey();

 call getkey
;-323 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-324 		    }

;-325         putch(10);

.mdump43:
 push 10
 call putch
 add  sp, 2
;-326         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-327         putch(':');

 push 58
 call putch
 add  sp, 2
;-328         i=0;

 mov ax, 0
 mov [bp-4], ax
;-329         while (i < 16) {

.mdump44:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump45
;-330             putch(' ');

 push 32
 call putch
 add  sp, 2
;-331             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-332             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-333             adr++;

 inc  word[bp+4]
;-334             i++;

 inc  word[bp-4]
;-335             j++;

 inc  word[bp-6]
;-336             }

;-337         putch(' ');

 jmp .mdump44
.mdump45:
 push 32
 call putch
 add  sp, 2
;-338         adr -=16;

 sub  word[bp+4], 16
;-339         i=0;

 mov ax, 0
 mov [bp-4], ax
;-340         while(i < 16) {

.mdump46:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump47
;-341             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-342             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump48
 push 46
 call putch
 add  sp, 2
;-343                 else putch(c);

 jmp .mdump49
.mdump48:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-344             adr++;

.mdump49:
 inc  word[bp+4]
;-345             i++;

 inc  word[bp-4]
;-346         }

;-347     }

 jmp .mdump46
.mdump47:
;-348 }

 jmp .mdump41
.mdump42:
;-349 

;-350 //--------------------------------  disk IO  -------------------

;-351 

;-352 int DiskSectorReadWrite(char rw, char drive, char head, int cyl,

 LEAVE
 ret
ENDP

DiskSectorReadWrite: PROC
;-353 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-354 	BIOS_ERR=0;

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;100 var sign byte rw = bp+4
;101 var sign byte drive = bp+6
;102 var sign byte head = bp+8
;103 var sign word cyl = bp+10
;104 var sign byte sector = bp+12
;105 var sign byte count = bp+14
;106 var sign word BufSeg = bp+16
;107 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-355 	dl=drive;

 mov  dl, [bp+6]
;-356 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-357 	es=BufSeg;

 mov  es, [bp+16]
;-358 	bx=BufOfs;

 mov  bx, [bp+18]
;-359 	cx=cyl;

 mov  cx, [bp+10]
;-360 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-361 	cx >> 2;//in 2 high bits of cl

 shr  cx, 2
;-362 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-363 	cl += sector;

 add  cl, [bp+12]
;-364 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-365 	al=count;

 mov  al, [bp+14]
;-366 	ah=rw;

 mov  ah, [bp+4]
;-367 	inth 0x13;

 int  19
;-368     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-369 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-370 }

;-371 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-372 	BIOS_ERR=0;

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;100 var sign byte drive = bp+4
;101 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-373 	dl=drive;

 mov  dl, [bp+4]
;-374 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-375 	inth 0x13;

 int  19
;-376     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-377 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-378 }

;-379 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-380 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-381 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-382 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-383 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-384 }

;-385 int Status(drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Status: PROC
;-386 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;100 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-387 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-388 	BIOS_Status=Int13hfunction(drive, 1);

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-389 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Status50
 call Int13hError
;-390 	printhex16(BIOS_Status);

.Status50:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-391 }

;-392 

;-393 int Params() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

Params: PROC
;-394 	if (debug) cputs(" DriveParams ");

 mov ax, 0
 or  al, al
 je .Params51
 push Params_0
 call cputs
 add  sp, 2
;-395 	BIOS_Status=Int13hfunction(Drive, 8);

.Params51:
 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-396 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params52
;-397 		Int13hError();

 call Int13hError
;-398 		return 1;

 mov ax, 1
 jmp .retnParams
;-399 		}

;-400 	else {

 jmp .Params53
.Params52:
;-401 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-402 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-403 		// CX =       ---CH--- ---CL---

;-404 		// cylinder : 76543210 98

;-405 		// sector   :            543210

;-406 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-407 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-408 //		pa_Sectors++;//1 to 64

;-409 

;-410 		asm mov [pa_Cylinders],    cx

 mov [pa_Cylinders],    cx
;-411 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-412 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-413 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty

 add [pa_Cylinders],    ch;//byte add, low byte is empty
;-414 

;-415 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params54
;-416 			cputs(" no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-417 			return 1;

 mov ax, 1
 jmp .retnParams
;-418 			}

;-419 	}

.Params54:
;-420 	return 0;

.Params53:
 mov ax, 0
 jmp .retnParams
;-421 }

;-422 

;-423 

;-424 int getPartitionData() {

 .retnParams:
 ret
Params_0 db " DriveParams ",0
Params_1 db " no hard disk found",0
ENDP

getPartitionData: PROC
;-425 	unsigned int j; char c; char *p;

;-426 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;100 var unsg word j = bp-2
;101 var sign byte c = bp-4
;102 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [pt_PartNo]
 shl ax, 4
 mov [bp-2], ax
;-427 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-428 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-429 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-430 	pt_StartCylinder=(int)pt_StartSector;

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-431 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-432 //	pt_StartSector++;//Sector start with 1 todo

;-433 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-434 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-435 	j++;

 inc  word[bp-2]
;-436 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-437 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-438 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB

;-439 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-440 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-441 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-442 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-443 //	pt_EndSector++;//Sector start with 1 todo

;-444 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-445 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-446 	j++;

 inc  word[bp-2]
;-447 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-448 	j++;

 inc  word[bp-2]
;-449 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-450 	memcpy(&pt_HiddenSector, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-451 }

;-452 

;-453 int checkBootSign() {

 LEAVE
 ret
ENDP

checkBootSign: PROC
;-454 	int i;

;-455 	i=510;

;Function : checkBootSign, Number local Var: 1
; # type sign width local variables
;100 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-456 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign55
;-457 		i++;

 inc  word[bp-2]
;-458 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign56
 mov ax, 1
 jmp .retncheckBootSign
;-459 	}

.checkBootSign56:
;-460 	cputs(" Magic number NOT found.");

.checkBootSign55:
 push checkBootSign_0
 call cputs
 add  sp, 2
;-461 	return 0;

 mov ax, 0
 jmp .retncheckBootSign
;-462 }

;-463 

;-464 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db " Magic number NOT found.",0
ENDP

readMBR: PROC
;-465 	int isFAT;

;-466 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;100 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-467 	pt_PartNo=0;

 mov ax, 0
 mov word [pt_PartNo], ax
;-468 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-469 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR57
;-470 		Int13hError();

 call Int13hError
;-471 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-472 		}

;-473 	else {

 jmp .readMBR58
.readMBR57:
;-474 //		cputs(" Read partition.");

;-475 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .readMBR59
 mov ax, 0
 jmp .retnreadMBR
;-476 		do {

.readMBR59:
.readMBR60:
;-477 			getPartitionData();

 call getPartitionData
;-478 

;-479 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR61
;-480 //				cputs("Boot partition found");

;-481 				if (pt_FileSystem == 1) {

 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR62
;-482 					cputs(", FAT12 partition < 32MB");

 push readMBR_0
 call cputs
 add  sp, 2
;-483 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-484 					}

;-485 				if (pt_FileSystem == 4) {

.readMBR62:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR63
;-486 					cputs(", small FAT16 partition < 32MB");

 push readMBR_1
 call cputs
 add  sp, 2
;-487 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-488 					}

;-489 				if (pt_FileSystem == 6) {

.readMBR63:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR64
;-490 //					cputs(", large FAT16 partition < 2GB");

;-491 					isFAT=6;

 mov ax, 6
 mov [bp-2], ax
;-492 					}

;-493 				pt_PartNo=99;//end of loop

.readMBR64:
 mov ax, 99
 mov word [pt_PartNo], ax
;-494 			}

;-495 			pt_PartNo ++;

.readMBR61:
 inc  word[pt_PartNo]
;-496 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR65
 jmp .readMBR60
.readMBR65:
;-497 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-498 	}

;-499 }

.readMBR58:
;-500 

;-501 int getBootSector() {

 .retnreadMBR:
 LEAVE
 ret
readMBR_0 db ", FAT12 partition < 32MB",0
readMBR_1 db ", small FAT16 partition < 32MB",0
ENDP

getBootSector: PROC
;-502 	int i;

;-503 	if (debug) cputs(" Read boot sector");

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;100 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 0
 or  al, al
 je .getBootSector66
 push getBootSector_0
 call cputs
 add  sp, 2
;-504   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

.getBootSector66:
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
;-506 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector67
;-507 		Int13hError();

 call Int13hError
;-508 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-509 		}

;-510 	else {

 jmp .getBootSector68
.getBootSector67:
;-511 //		printhex16(BIOS_Status);

;-512 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .getBootSector69
 mov ax, 0
 jmp .retngetBootSector
;-513 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector69:
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
 je  .getBootSector70
 push getBootSector_1
 call cputs
 add  sp, 2
;-515 		i=2;

.getBootSector70:
 mov ax, 2
 mov [bp-2], ax
;-516 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector71
 push getBootSector_2
 call cputs
 add  sp, 2
;-517 	}

.getBootSector71:
;-518 	return 1;

.getBootSector68:
 mov ax, 1
 jmp .retngetBootSector
;-519 }

;-520 

;-521 int FATInit() {

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Read boot sector",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-522 	unsigned long templong;//converting word to dword

;-523 

;-524 	clust_sizeL = (long) bs_clust_size;

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;100 var unsg long templong = bp-4;
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
 jne .FATInit72
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-531 

;-532 	fat_RootDirStartSectorL = (long)fat_FatStartSector + fat_FatSectors;

.FATInit72:
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
 je  .FATInit73
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-539 	DataSectors32=bs_tot_sect32 - fat_DataStartSectorL;

.FATInit73:
 mov eax, [bs_tot_sect32]
 sub eax, [fat_DataStartSectorL]
 mov dword [DataSectors32], eax
;-540 

;-541 	CountofClusters=DataSectors32 / clust_sizeL;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [clust_sizeL]
 mov dword [CountofClusters], eax
;-542 

;-543 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-544 	fat_num_tracks = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [fat_num_tracks], eax
;-545 

;-546 	templong = (long) bs_num_heads;

 xor eax, eax
 mov ax, [bs_num_heads]
 mov [bp-4], eax
;-547 	fat_num_cylinders = fat_num_tracks / templong;//w=d/w

 mov eax, [fat_num_tracks]
 xor edx, edx
 div dword [bp-4]
 mov word [fat_num_cylinders], ax
;-548 

;-549 	Sectors_per_cylinder = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinder], eax
;-550 	asm mov [Sectors_per_cylinder + 2], dx;store high word

 mov [Sectors_per_cylinder + 2], dx;store high word
;-551 

;-552 	templong = (long) 65525;

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-553 	if (CountofClusters > templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jle .FATInit74
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

.FATInit74:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-559 	if (CountofClusters < templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jge .FATInit75
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

.FATInit75:
 mov ax, 16
 mov byte [trueFATtype], al
;-565 	if (debug) cputs(" FAT16");

 mov ax, 0
 or  al, al
 je .FATInit76
 push FATInit_2
 call cputs
 add  sp, 2
;-566 	return 0;

.FATInit76:
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
 je .Int13hExt77
;-576 		cputs(" Ext NOT present");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-577 		Int13hError();

 call Int13hError
;-578 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-579 		}

;-580 	else {

 jmp .Int13hExt78
.Int13hExt77:
;-581 	if (debug) cputs(",Int13h Ext");

 mov ax, 0
 or  al, al
 je .Int13hExt79
 push Int13hExt_1
 call cputs
 add  sp, 2
;-582 		}

.Int13hExt79:
;-583 	return 0;

.Int13hExt78:
 mov ax, 0
 jmp .retnInt13hExt
;-584 }

;-585 

;-586 int PrintDriveParameter() {

 .retnInt13hExt:
 ret
Int13hExt_0 db " Ext NOT present",0
Int13hExt_1 db ",Int13h Ext",0
ENDP

PrintDriveParameter: PROC
;-587 	unsigned long Lo;

;-588 // from Params

;-589 	putch(10);

;Function : PrintDriveParameter, Number local Var: 1
; # type sign width local variables
;100 var unsg long Lo = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-590 	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);

 push PrintDriveParameter_0
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-591 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-592 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-593 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-594 	putch('.');

 push 46
 call putch
 add  sp, 2
;-595 //from getPartitionData

;-596 	putch(10);

 push 10
 call putch
 add  sp, 2
;-597 	cputs("getPartitionData:No=");printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-598 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-599 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-600 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-601 	cputs("/");				printunsign(pt_StartSector);

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-602 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-603 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-604 	cputs("/");				printunsign(pt_EndSector);

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-605 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-606 	cputs(",Start=");		printlong(pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 push dword [pt_HiddenSector]
 call printlong
 add  sp, 4
;-607 	cputs(",Len=");			printlong(pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 push dword [pt_PartLen]
 call printlong
 add  sp, 4
;-608 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-609 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-610 	printlong(Lo);

 push dword [bp-4]
 call printlong
 add  sp, 4
;-611 	cputs(" MByte.");

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-612 //from getBootSector

;-613 	putch(10);

 push 10
 call putch
 add  sp, 2
;-614 	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-615 	putch(10);

 push 10
 call putch
 add  sp, 2
;-616 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-617 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-618 	putch(10);

 push 10
 call putch
 add  sp, 2
;-619 	cputs("Reserved sectors=");printunsign(bs_res_sects);

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-620 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-621 	putch(10);

 push 10
 call putch
 add  sp, 2
;-622 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-623 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-624 	putch(10);

 push 10
 call putch
 add  sp, 2
;-625 	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-626 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-627 	putch(10);

 push 10
 call putch
 add  sp, 2
;-628 	cputs("sectors per track=");printunsign(bs_sectors_per_track);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_sectors_per_track]
 call printunsign
 add  sp, 2
;-629 	cputs(".number of heads=");printunsign(bs_num_heads);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_heads]
 call printunsign
 add  sp, 2
;-630 	putch(10);

 push 10
 call putch
 add  sp, 2
;-631 	cputs("hidden sectors(long)=");printlong(bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 push dword [bs_hid_sects]
 call printlong
 add  sp, 4
;-632 	cputs(".sectors(long)=");printlong(bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 push dword [bs_tot_sect32]
 call printlong
 add  sp, 4
;-633 	putch(10);

 push 10
 call putch
 add  sp, 2
;-634 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-635 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-636 	putch(10);

 push 10
 call putch
 add  sp, 2
;-637 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-638 	cputs(".Volume serial(long)=");printlong(bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 push dword [bs_serial_num]
 call printlong
 add  sp, 4
;-639 	putch(10);

 push 10
 call putch
 add  sp, 2
;-640 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-641 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-642 //from FATInit

;-643 	putch(10);

 push 10
 call putch
 add  sp, 2
;-644 	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [fat_FatStartSector]
 call printunsign
 add  sp, 2
;-645 	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [fat_FatSectors]
 call printunsign
 add  sp, 2
;-646 	putch(10);

 push 10
 call putch
 add  sp, 2
;-647 	cputs("fat_RootDirStartSectorL="); printlong(fat_RootDirStartSectorL);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push dword [fat_RootDirStartSectorL]
 call printlong
 add  sp, 4
;-648 	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectorsL);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push dword [fat_RootDirSectorsL]
 call printunsign
 add  sp, 4
;-649 	putch(10);

 push 10
 call putch
 add  sp, 2
;-650 	cputs("fat_DataStartSectorL=");	printunsign(fat_DataStartSectorL);

 push PrintDriveParameter_38
 call cputs
 add  sp, 2
 push dword [fat_DataStartSectorL]
 call printunsign
 add  sp, 4
;-651 	cputs(", DataSectors32=");	printlong(DataSectors32);

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 push dword [DataSectors32]
 call printlong
 add  sp, 4
;-652 	putch(10);

 push 10
 call putch
 add  sp, 2
;-653 	cputs("CountofClusters=");	printlong(CountofClusters);

 push PrintDriveParameter_40
 call cputs
 add  sp, 2
 push dword [CountofClusters]
 call printlong
 add  sp, 4
;-654 	cputs(", Sectors_per_cylinder="); printlong(Sectors_per_cylinder);

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 push dword [Sectors_per_cylinder]
 call printlong
 add  sp, 4
;-655 	putch(10);

 push 10
 call putch
 add  sp, 2
;-656 	cputs("fat_num_tracks=");	printlong(fat_num_tracks);

 push PrintDriveParameter_42
 call cputs
 add  sp, 2
 push dword [fat_num_tracks]
 call printlong
 add  sp, 4
;-657 	cputs(", fat_num_cylinders="); printunsign(fat_num_cylinders);

 push PrintDriveParameter_43
 call cputs
 add  sp, 2
 push word [fat_num_cylinders]
 call printunsign
 add  sp, 2
;-658 }

;-659 

;-660 //--------------------------------  file IO  -------------------

;-661 int error2(char *s) {

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
PrintDriveParameter_40 db "CountofClusters=",0
PrintDriveParameter_41 db ", Sectors_per_cylinder=",0
PrintDriveParameter_42 db "fat_num_tracks=",0
PrintDriveParameter_43 db ", fat_num_cylinders=",0
ENDP

error2: PROC
;-662 	putch(10);

;Function : error2, Number local Var: 1
; # type sign width local variables
;100 ptr sign byte s = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-663 	cputs("*** ERROR *** ");

 push error2_0
 call cputs
 add  sp, 2
;-664 	cputs(s);

 push word [bp+4]
 call cputs
 add  sp, 2
;-665 	DOS_ERR++;

 inc  byte[DOS_ERR]
;-666 }

;-667 // 1.

;-668 int readLogical(unsigned long SectorL) {//OUT:1 sector in DiskBuf

 LEAVE
 ret
error2_0 db "*** ERROR *** ",0
ENDP

readLogical: PROC
;-669 	unsigned int track; unsigned int head; unsigned int sect;

;-670 	SectorL = SectorL + bs_hid_sects;//d=d+d

;Function : readLogical, Number local Var: 4
; # type sign width local variables
;100 var unsg long SectorL = bp+4
;101 var unsg word track = bp-2
;102 var unsg word head = bp-4
;103 var unsg word sect = bp-6;
 ENTER  6,0
 mov eax, [bp+4]
 add eax, [bs_hid_sects]
 mov [bp+4], eax
;-671 	track = SectorL / Sectors_per_cylinder;  //w=d/d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinder]
 mov [bp-2], ax
;-672 	head  = SectorL % Sectors_per_cylinder;  //w=d%d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinder]
 mov eax, edx
 mov [bp-4], ax
;-673 	sect  = head            % bs_sectors_per_track;  //w=w%w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov ax, dx
 mov [bp-6], ax
;-674 	sect++;

 inc  word[bp-6]
;-675 	head  = head            / bs_sectors_per_track;	 //w=w/w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov [bp-4], ax
;-676 

;-677 	DiskSectorReadWrite(2, bs_drive_num, head, track/* =cyl */,

;-678 		sect, 1, DiskBufSeg , DiskBuf);

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
;-679 }

;-680 

;-681 // 2.a

;-682 int printDirEntry() {

 LEAVE
 ret
ENDP

printDirEntry: PROC
;-683     unsigned int j;

;-684 	putch(10);

;Function : printDirEntry, Number local Var: 1
; # type sign width local variables
;100 var unsg word j = bp-2;
 ENTER  2,0
 push 10
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
 je .printDirEntry80
 push printDirEntry_1
 call cputs
 add  sp, 2
;-689 	if (dir_Attrib &  2) cputs(" hid");

.printDirEntry80:
 mov al, [dir_Attrib]
 and al, 2
 or  al, al
 je .printDirEntry81
 push printDirEntry_2
 call cputs
 add  sp, 2
;-690 	if (dir_Attrib &  4) cputs(" sys");

.printDirEntry81:
 mov al, [dir_Attrib]
 and al, 4
 or  al, al
 je .printDirEntry82
 push printDirEntry_3
 call cputs
 add  sp, 2
;-691 	if (dir_Attrib &  8) cputs(" vol");		

.printDirEntry82:
 mov al, [dir_Attrib]
 and al, 8
 or  al, al
 je .printDirEntry83
 push printDirEntry_4
 call cputs
 add  sp, 2
;-692 	if (dir_Attrib & 16) cputs(" dir");

.printDirEntry83:
 mov al, [dir_Attrib]
 and al, 16
 or  al, al
 je .printDirEntry84
 push printDirEntry_5
 call cputs
 add  sp, 2
;-693 	if (dir_Attrib & 32) cputs(" arc");

.printDirEntry84:
 mov al, [dir_Attrib]
 and al, 32
 or  al, al
 je .printDirEntry85
 push printDirEntry_6
 call cputs
 add  sp, 2
;-694 	if (dir_Attrib == 0) cputs("    ");

.printDirEntry85:
 mov al, [dir_Attrib]
 cmp al, 0
 jne .printDirEntry86
 push printDirEntry_7
 call cputs
 add  sp, 2
;-695 	

;-696 	putch(' ');

.printDirEntry86:
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
 jge .printDirEntry87
 push 32
 call putch
 add  sp, 2
;-699 	printunsign(j);

.printDirEntry87:
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
 jge .printDirEntry88
 push 48
 call putch
 add  sp, 2
;-705 	printunsign(j);

.printDirEntry88:
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
 jge .printDirEntry89
 push 32
 call putch
 add  sp, 2
;-716 	printunsign(j);

.printDirEntry89:
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
 jge .printDirEntry90
 push 48
 call putch
 add  sp, 2
;-722 	printunsign(j);

.printDirEntry90:
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
 jge .printDirEntry91
 push 48
 call putch
 add  sp, 2
;-728 	printunsign(j);

.printDirEntry91:
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

;-743 	

;-744 	do {

;Function : fatDirSectorList, Number local Var: 5
; # type sign width local variables
;100 var unsg long startSector = bp+4
;101 var unsg long numsectors = bp+8
;102 ptr sign byte p = bp-2
;103 var unsg word EndDiskBuf = bp-4
;104 var sign byte isHide = bp-6;
 ENTER  6,0
.fatDirSectorList92:
;-745 /*		putch(10);

;-746 		cputs("Sektor = "); 

;-747 		printlong(startSector);

;-748 		cputs(", numsectors = "); 

;-749 		printunsign(numsectors);

;-750 		getkey();

;-751 */

;-752 		readLogical(startSector);

 push dword [bp+4]
 call readLogical
 add  sp, 4
;-753 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-754 		EndDiskBuf= p + bs_sect_size;		

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-755 		

;-756 		do {

.fatDirSectorList93:
;-757 			memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-758 			memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-759 			filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-760 			

;-761 			isHide=0;//show in listing

 mov ax, 0
 mov [bp-6], al
;-762 			if (*p ==    0) {//only empty entries following

 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorList94
;-763 				isHide++;

 inc  byte[bp-6]
;-764 				numsectors=1;//finish searching

 mov ax, 1
 mov [bp+8], eax
;-765 				p = EndDiskBuf;

 mov ax, [bp-4]
 mov [bp-2], ax
;-766 				}

;-767 			if (*p == 0xE5) isHide++;//deleted, free entry

.fatDirSectorList94:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 229
 jne .fatDirSectorList95
 inc  byte[bp-6]
;-768 			if (*p <=   31) isHide++;//part of LFN

.fatDirSectorList95:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 31
 jg  .fatDirSectorList96
 inc  byte[bp-6]
;-769 			if (dir_Attrib ==    15) isHide++;//LFN start

.fatDirSectorList96:
 mov al, [dir_Attrib]
 cmp al, 15
 jne .fatDirSectorList97
 inc  byte[bp-6]
;-770 					

;-771 			if (isHide == 0) printDirEntry();

.fatDirSectorList97:
 mov al, [bp-6]
 cmp al, 0
 jne .fatDirSectorList98
 call printDirEntry
;-772 			p+=32;//get next entry

.fatDirSectorList98:
 add  word[bp-2], 32
;-773 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorList99
 jmp .fatDirSectorList93
.fatDirSectorList99:
;-774 		startSector = startSector + 1;//long, do NOT use ++ or +=1

 mov eax, [bp+4]
 add eax, 1
 mov [bp+4], eax
;-775 		numsectors--;

 dec  dword[bp+8]
;-776 //mdump(DiskBuf, 512);

;-777 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorList100
 jmp .fatDirSectorList92
.fatDirSectorList100:
;-778 	fatfile_cluster=0;//not found but not end

 mov ax, 0
 mov word [fatfile_cluster], ax
;-779 }

;-780 

;-781 // 2.

;-782 int fatDirSectorSearch(unsigned long startSector, unsigned long numsectors) {

 LEAVE
 ret
ENDP

fatDirSectorSearch: PROC
;-783     //search for file name. IN:searchstr

;-784     char *p;

;-785 	unsigned int EndDiskBuf;

;-786 	fat_notfound=0;	

;Function : fatDirSectorSearch, Number local Var: 4
; # type sign width local variables
;100 var unsg long startSector = bp+4
;101 var unsg long numsectors = bp+8
;102 ptr sign byte p = bp-2
;103 var unsg word EndDiskBuf = bp-4;
 ENTER  4,0
 mov ax, 0
 mov byte [fat_notfound], al
;-787 	do {

.fatDirSectorSearch101:
;-788 		readLogical(startSector);

 push dword [bp+4]
 call readLogical
 add  sp, 4
;-789 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-790 		EndDiskBuf= p + bs_sect_size;

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-791 		do {

.fatDirSectorSearch102:
;-792 			if (memcmp(p, searchstr, 11) == 0) {//found file name

 push 11
 lea  ax, [searchstr]
 push ax
 push word [bp-2]
 call memcmp
 add  sp, 6
 cmp ax, 0
 jne .fatDirSectorSearch103
;-793 				memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-794 				memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-795 				filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-796 				fatfile_cluster   = dir_FirstCluster;

 mov ax, [dir_FirstCluster]
 mov word [fatfile_cluster], ax
;-797 				fatfile_fileSize  = dir_FileSize;

 mov eax, [dir_FileSize]
 mov dword [fatfile_fileSize], eax
;-798 //				fatfile_Attr      = dir_Attrib;

;-799 //				fatfile_LastModTime= dir_LastModTime;

;-800 //				fatfile_LastModDate= dir_LastModDate;

;-801 				printDirEntry();

 call printDirEntry
;-802 			}

;-803 			if (*p == 0) {//only empty entries following

.fatDirSectorSearch103:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorSearch104
;-804 					fat_notfound=1;

 mov ax, 1
 mov byte [fat_notfound], al
;-805 					return;

 jmp .retnfatDirSectorSearch
;-806 				}

;-807 			p+=32;//get next entry

.fatDirSectorSearch104:
 add  word[bp-2], 32
;-808 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorSearch105
 jmp .fatDirSectorSearch102
.fatDirSectorSearch105:
;-809 		startSector++;		

 inc  dword[bp+4]
;-810 		numsectors--;

 dec  dword[bp+8]
;-811 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorSearch106
 jmp .fatDirSectorSearch101
.fatDirSectorSearch106:
;-812 	fatfile_cluster=0;//not found but not end

 mov ax, 0
 mov word [fatfile_cluster], ax
;-813 }

;-814 

;-815 // 3.

;-816 int fatRootSearch() {

 .retnfatDirSectorSearch:
 LEAVE
 ret
ENDP

fatRootSearch: PROC
;-817     fatDirSectorSearch(fat_RootDirStartSectorL, fat_RootDirSectorsL);

 push dword [fat_RootDirSectorsL]
 push dword [fat_RootDirStartSectorL]
 call fatDirSectorSearch
 add  sp, 8
;-818 //	getkey();

;-819 //    fatDirSectorList(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-820 }

;-821 

;-822 // 4.

;-823 int fatClusterAnalyse(unsigned int cluster) {

 ret
ENDP

fatClusterAnalyse: PROC
;-824 //OUT: fatfile_sectorStartL, fatfile_nextCluster

;-825 	unsigned long fatSectorL;

;-826 	unsigned int offset;

;-827 	char *p;

;-828 	

;-829 	fatfile_sectorStartL = (long) cluster - 2;

;Function : fatClusterAnalyse, Number local Var: 4
; # type sign width local variables
;100 var unsg word cluster = bp+4
;101 var unsg long fatSectorL = bp-4
;102 var unsg word offset = bp-6
;103 ptr sign byte p = bp-8;
 ENTER  8,0
 xor eax, eax
 mov ax, [bp+4]
 sub ax, 2
 mov dword [fatfile_sectorStartL], eax
;-830 	fatfile_sectorStartL = fatfile_sectorStartL * clust_sizeL;

 mov eax, [fatfile_sectorStartL]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul dword [clust_sizeL]
 mov dword [fatfile_sectorStartL], eax
;-831 	fatfile_sectorStartL = fatfile_sectorStartL + fat_DataStartSectorL;

 mov eax, [fatfile_sectorStartL]
 add eax, [fat_DataStartSectorL]
 mov dword [fatfile_sectorStartL], eax
;-832 	

;-833 	fatSectorL = (long) cluster + cluster;

 xor eax, eax
 mov ax, [bp+4]
 add ax, [bp+4]
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
;-836 

;-837 	readLogical(fatSectorL);

 push dword [bp-4]
 call readLogical
 add  sp, 4
;-838 	

;-839 	offset = cluster + cluster;

 mov ax, [bp+4]
 add ax, [bp+4]
 mov [bp-6], ax
;-840 	offset = offset % bs_sect_size;

 mov ax, [bp-6]
 xor dx, dx
 div word [bs_sect_size]
 mov ax, dx
 mov [bp-6], ax
;-841 	

;-842 	p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-8], ax
;-843 	p = p + offset;	

 mov ax, [bp-8]
 add ax, [bp-6]
 mov [bp-8], ax
;-844 	memcpy(&fatfile_nextCluster, p, 2);

 push 2
 push word [bp-8]
 lea  ax, [fatfile_nextCluster]
 push ax
 call memcpy
 add  sp, 6
;-845 }

;-846 

;-847 // 5.

;-848 int fatDirSearch() {//search a directory chain. IN:searchstr

 LEAVE
 ret
ENDP

fatDirSearch: PROC
;-849 	

;-850 	fatClusterAnalyse(fatfile_cluster);

 push word [fatfile_cluster]
 call fatClusterAnalyse
 add  sp, 2
;-851 	//OUT: fatfile_sectorStartL, fatfile_nextCluster

;-852 

;-853 	fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster); 

 push word [fatfile_nextCluster]
 push dword [fatfile_sectorStartL]
 call fatDirSectorSearch
 add  sp, 6
;-854 	while (fatfile_cluster == 0) {//not found but not end

.fatDirSearch107:
 mov ax, [fatfile_cluster]
 cmp ax, 0
 jne .fatDirSearch108
;-855 		if (fatfile_nextCluster >= 0xFFF8) {

 mov ax, [fatfile_nextCluster]
 cmp ax, 65528 ;unsigned : 0
 jb  .fatDirSearch109
;-856 			fat_notfound=1;

 mov ax, 1
 mov byte [fat_notfound], al
;-857 			return;	

 jmp .retnfatDirSearch
;-858 		}		

;-859 		fatfile_cluster=fatfile_nextCluster;

.fatDirSearch109:
 mov ax, [fatfile_nextCluster]
 mov word [fatfile_cluster], ax
;-860 		fatClusterAnalyse(fatfile_cluster);

 push word [fatfile_cluster]
 call fatClusterAnalyse
 add  sp, 2
;-861 		fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster);

 push word [fatfile_nextCluster]
 push dword [fatfile_sectorStartL]
 call fatDirSectorSearch
 add  sp, 6
;-862 	}	

;-863 }

 jmp .fatDirSearch107
.fatDirSearch108:
;-864 

;-865 int is_delimiter(char *s) {

 .retnfatDirSearch:
 ret
ENDP

is_delimiter: PROC
;-866 	if (*s == '/' ) return 1;

;Function : is_delimiter, Number local Var: 1
; # type sign width local variables
;100 ptr sign byte s = bp+4;
 ENTER  0,0
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 47
 jne .is_delimiter110
 mov ax, 1
 jmp .retnis_delimiter
;-867 	if (*s == '\\') return 1;

.is_delimiter110:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 92
 jne .is_delimiter111
 mov ax, 1
 jmp .retnis_delimiter
;-868 	if (*s ==    0) return 2;

.is_delimiter111:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .is_delimiter112
 mov ax, 2
 jmp .retnis_delimiter
;-869 	if (*s ==  '.') return 3;

.is_delimiter112:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 46
 jne .is_delimiter113
 mov ax, 3
 jmp .retnis_delimiter
;-870 	return 0;

.is_delimiter113:
 mov ax, 0
 jmp .retnis_delimiter
;-871 }	

;-872 // 6.

;-873 int fatNextSearch() {//get next part of filename to do a search

 .retnis_delimiter:
 LEAVE
 ret
ENDP

fatNextSearch: PROC
;-874 //	IN:  upto: points to start of search in filename 

;-875 //	OUT: upto: points to search for next time

;-876 //	OUT: searchstr: part of filename in DIR-format with blanks (11bytes)

;-877 //	OUT: isfilename: 0=part of directory, 1=filename

;-878 //	OUT: fat_notfound

;-879 	char *searchstrp;

;-880 	char *p; 

;-881 	unsigned int  len;

;-882 	unsigned int delimiter;

;-883 putch(10); cputs("A:"); cputs(upto);

;Function : fatNextSearch, Number local Var: 4
; # type sign width local variables
;100 ptr sign byte searchstrp = bp-2
;101 ptr sign byte p = bp-4
;102 var unsg word len = bp-6
;103 var unsg word delimiter = bp-8;
 ENTER  8,0
 push 10
 call putch
 add  sp, 2
 push fatNextSearch_0
 call cputs
 add  sp, 2
 push word [upto]
 call cputs
 add  sp, 2
;-884 	delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-885 	if (delimiter == 1) upto++;

 mov ax, [bp-8]
 cmp ax, 1
 jne .fatNextSearch114
 inc  word[upto]
;-886 	if (delimiter == 2) {fat_notfound=1; return; }

.fatNextSearch114:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch115
 mov ax, 1
 mov byte [fat_notfound], al
 jmp .retnfatNextSearch
;-887 

;-888 	strcpy(&searchstr, "           ");//11 blank padded

.fatNextSearch115:
 push fatNextSearch_1
 lea  ax, [searchstr]
 push ax
 call strcpy
 add  sp, 4
;-889 	searchstrp = &searchstr;//clear searchstr

 mov ax, searchstr
 mov [bp-2], ax
;-890 	len=0;

 mov ax, 0
 mov [bp-6], ax
;-891 	delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-892 	while (delimiter == 0) { //no slash, zero, point

.fatNextSearch116:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch117
;-893 		*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-894 		searchstrp++;

 inc  word[bp-2]
;-895 		upto++;	

 inc  word[upto]
;-896 		len++;

 inc  word[bp-6]
;-897 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-898 	} 

;-899 	if (len > 8) {fat_notfound=1; return; }

 jmp .fatNextSearch116
.fatNextSearch117:
 mov ax, [bp-6]
 cmp ax, 8
 jle .fatNextSearch118
 mov ax, 1
 mov byte [fat_notfound], al
 jmp .retnfatNextSearch
;-900 	isfilename=0;//default directory

.fatNextSearch118:
 mov ax, 0
 mov byte [isfilename], al
;-901 	if (delimiter == 2) isfilename=1;//last name is always a file name

 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch119
 mov ax, 1
 mov byte [isfilename], al
;-902 	if (delimiter == 3) {//remove dot in name		

.fatNextSearch119:
 mov ax, [bp-8]
 cmp ax, 3
 jne .fatNextSearch120
;-903 		searchstrp = &searchstr;

 mov ax, searchstr
 mov [bp-2], ax
;-904 		searchstrp += 8;//start extension		

 add  word[bp-2], 8
;-905 		len=0;

 mov ax, 0
 mov [bp-6], ax
;-906 		upto++;

 inc  word[upto]
;-907 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-908 		while (delimiter == 0) { //no slash, zero, point

.fatNextSearch121:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch122
;-909 			*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-910 			searchstrp++;

 inc  word[bp-2]
;-911 			upto++;	

 inc  word[upto]
;-912 			len++;

 inc  word[bp-6]
;-913 			delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-914 		} 

;-915 		if (len > 3) {fat_notfound=1; return; }

 jmp .fatNextSearch121
.fatNextSearch122:
 mov ax, [bp-6]
 cmp ax, 3
 jle .fatNextSearch123
 mov ax, 1
 mov byte [fat_notfound], al
 jmp .retnfatNextSearch
;-916 		if (delimiter == 2) isfilename=1;//last name is always a file name

.fatNextSearch123:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch124
 mov ax, 1
 mov byte [isfilename], al
;-917 	}	

.fatNextSearch124:
;-918 putch(10);

.fatNextSearch120:
 push 10
 call putch
 add  sp, 2
;-919 cputs("End:"); cputsLen(searchstr, 11);

 push fatNextSearch_2
 call cputs
 add  sp, 2
 push 11
 lea  ax, [searchstr]
 push ax
 call cputsLen
 add  sp, 4
;-920 cputs(",isFN="); printunsign(isfilename);

 push fatNextSearch_3
 call cputs
 add  sp, 2
 mov al, byte [isfilename]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-921 cputs(",upto="); cputs(upto);

 push fatNextSearch_4
 call cputs
 add  sp, 2
 push word [upto]
 call cputs
 add  sp, 2
;-922 }

;-923 

;-924 // 7.

;-925 int fatGetStartCluster() {

 .retnfatNextSearch:
 LEAVE
 ret
fatNextSearch_0 db "A:",0
fatNextSearch_1 db "           ",0
fatNextSearch_2 db "End:",0
fatNextSearch_3 db ",isFN=",0
fatNextSearch_4 db ",upto=",0
ENDP

fatGetStartCluster: PROC
;-926 	if (fat_notfound) return;

 mov al, [fat_notfound]
 or  al, al
 je .fatGetStartCluster125
 jmp .retnfatGetStartCluster
;-927 	upto = &filename;

.fatGetStartCluster125:
 mov ax, filename
 mov word [upto], ax
;-928 	fatfile_cluster = 0;

 mov ax, 0
 mov word [fatfile_cluster], ax
;-929 	if (debug) {

 mov ax, 0
 or  al, al
 je .fatGetStartCluster126
;-930 		cputs("GetStartCluster filename=");cputs(filename);

 push fatGetStartCluster_0
 call cputs
 add  sp, 2
 lea  ax, [filename]
 push ax
 call cputs
 add  sp, 2
;-931 		cputs(", upto="); cputs(upto); }

 push fatGetStartCluster_1
 call cputs
 add  sp, 2
 push word [upto]
 call cputs
 add  sp, 2
;-932 	fatNextSearch();

.fatGetStartCluster126:
 call fatNextSearch
;-933 }

;-934 

;-935 // 8.

;-936 int fatOpenFile() {//set handle for root or subdir

 .retnfatGetStartCluster:
 ret
fatGetStartCluster_0 db "GetStartCluster filename=",0
fatGetStartCluster_1 db ", upto=",0
ENDP

fatOpenFile: PROC
;-937 	unsigned long bytes_per_cluster;

;-938 	fat_notfound=0;

;Function : fatOpenFile, Number local Var: 1
; # type sign width local variables
;100 var unsg long bytes_per_cluster = bp-4;
 ENTER  4,0
 mov ax, 0
 mov byte [fat_notfound], al
;-939 	if (debug) cputs("fatOpenfile ");	

 mov ax, 0
 or  al, al
 je .fatOpenFile127
 push fatOpenFile_0
 call cputs
 add  sp, 2
;-940 	if (filename[0] == 0) {//empty filename

.fatOpenFile127:
 mov al, [filename]
 cmp al, 0
 jne .fatOpenFile128
;-941 //	if (strlen(filename) == 0) {//empty filename

;-942 		fat_notfound=1;//todo: return

 mov ax, 1
 mov byte [fat_notfound], al
;-943 		

;-944 		fatfile_root = 1;

 mov ax, 1
 mov word [fatfile_root], ax
;-945 		fatfile_nextCluster = 0xFFFF;

 mov ax, 65535
 mov word [fatfile_nextCluster], ax
;-946 		fatfile_sectorCount = fat_RootDirSectorsL;

 mov eax, [fat_RootDirSectorsL]
 mov word [fatfile_sectorCount], ax
;-947 		fatfile_sectorStartL = fat_RootDirStartSectorL;

 mov eax, [fat_RootDirStartSectorL]
 mov dword [fatfile_sectorStartL], eax
;-948 		fatfile_lastBytes   = 0;

 mov ax, 0
 mov word [fatfile_lastBytes], ax
;-949 		fatfile_lastSectors = fat_RootDirSectorsL;

 mov eax, [fat_RootDirSectorsL]
 mov word [fatfile_lastSectors], ax
;-950 		fatfile_cluster     = 0;

 mov ax, 0
 mov word [fatfile_cluster], ax
;-951 		fatfile_dir         = 1;

 mov ax, 1
 mov word [fatfile_dir], ax
;-952 

;-953 	} else {//search in subdir

 jmp .fatOpenFile129
.fatOpenFile128:
;-954 		fatfile_root = 0;

 mov ax, 0
 mov word [fatfile_root], ax
;-955 		fatGetStartCluster();

 call fatGetStartCluster
;-956 		if (fat_notfound) return 1;

 mov al, [fat_notfound]
 or  al, al
 je .fatOpenFile130
 mov ax, 1
 jmp .retnfatOpenFile
;-957 		bytes_per_cluster   = (long) bs_clust_size * bs_sect_size;

.fatOpenFile130:
 xor eax, eax
 mov al, [bs_clust_size]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_sect_size]
 mov [bp-4], eax
;-958 		fatfile_lastBytes   = fatfile_fileSize % bytes_per_cluster;

 mov eax, [fatfile_fileSize]
 xor edx, edx
 div dword [bp-4]
 mov eax, edx
 mov word [fatfile_lastBytes], ax
;-959 		fatfile_lastSectors = fatfile_lastBytes / bs_sect_size;

 mov ax, [fatfile_lastBytes]
 xor dx, dx
 div word [bs_sect_size]
 mov word [fatfile_lastSectors], ax
;-960 		fatfile_lastBytes   = fatfile_lastBytes % bs_sect_size;

 mov ax, [fatfile_lastBytes]
 xor dx, dx
 div word [bs_sect_size]
 mov ax, dx
 mov word [fatfile_lastBytes], ax
;-961 		if (fatfile_fileSize == 0) fatfile_dir = 1;

 mov eax, [fatfile_fileSize]
 cmp eax, 0
 jne .fatOpenFile131
 mov ax, 1
 mov word [fatfile_dir], ax
;-962 		else                       fatfile_dir = 0;

 jmp .fatOpenFile132
.fatOpenFile131:
 mov ax, 0
 mov word [fatfile_dir], ax
;-963 

;-964 //		fatClusterAnalyse();

;-965 		fatfile_sectorCount = (int) bs_clust_size;

.fatOpenFile132:
 xor ax, ax
 mov al, [bs_clust_size]
 mov word [fatfile_sectorCount], ax
;-966 	}

;-967 	fatfile_currentCluster = fatfile_cluster;

.fatOpenFile129:
 mov ax, [fatfile_cluster]
 mov word [fatfile_currentCluster], ax
;-968 	fatfile_sectorUpto = 0;

 mov ax, 0
 mov word [fatfile_sectorUpto], ax
;-969 	fatfile_byteUpto   = 0;

 mov ax, 0
 mov word [fatfile_byteUpto], ax
;-970 	if (fat_notfound) return 1;

 mov al, [fat_notfound]
 or  al, al
 je .fatOpenFile133
 mov ax, 1
 jmp .retnfatOpenFile
;-971 	return 0;

.fatOpenFile133:
 mov ax, 0
 jmp .retnfatOpenFile
;-972 }

;-973 

;-974 // 9.

;-975 int fileOpen() {//remove drive letter and insert in drive

 .retnfatOpenFile:
 LEAVE
 ret
fatOpenFile_0 db "fatOpenfile ",0
ENDP

fileOpen: PROC
;-976 	int rc;

;-977 	toupper(filename);

;Function : fileOpen, Number local Var: 1
; # type sign width local variables
;100 var sign word rc = bp-2;
 ENTER  2,0
 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-978 	rc=fatOpenFile();

 call fatOpenFile
 mov [bp-2], ax
;-979 	cputs(" rc="); printunsign(rc);

 push fileOpen_0
 call cputs
 add  sp, 2
 push word [bp-2]
 call printunsign
 add  sp, 2
;-980 	if (rc) return 0;//error

 mov ax, [bp-2]
 or  al, al
 je .fileOpen134
 mov ax, 0
 jmp .retnfileOpen
;-981 //	else return fhandle;

;-982 }

.fileOpen134:
;-983 

;-984 //------------------------------- Init,  main ---------------

;-985 int Init() {

 .retnfileOpen:
 LEAVE
 ret
fileOpen_0 db " rc=",0
ENDP

Init: PROC
;-986 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-987 	if (debug) cputs("Init ");

 mov ax, 0
 or  al, al
 je .Init135
 push Init_0
 call cputs
 add  sp, 2
;-988 

;-989 	if (Params()) cputs("** NO DRIVE PARAMS FOUND **");//no hard disk

.Init135:
 call Params
 or  al, al
 je .Init136
 push Init_1
 call cputs
 add  sp, 2
;-990 	FATtype=readMBR();//0=error,1=FAT12,6=FAT16,11=FAT32

.Init136:
 call readMBR
 mov word [FATtype], ax
;-991 	if (FATtype == 0) {

 mov ax, [FATtype]
 cmp ax, 0
 jne .Init137
;-992 		cputs("** no active FAT partition found **");

 push Init_2
 call cputs
 add  sp, 2
;-993 		return 1;

 mov ax, 1
 jmp .retnInit
;-994 		}

;-995 	if(getBootSector()==0) 	return 1;

.Init137:
 call getBootSector
 cmp ax, 0
 jne .Init138
 mov ax, 1
 jmp .retnInit
;-996 	if (FATInit())			return 1;

.Init138:
 call FATInit
 or  al, al
 je .Init139
 mov ax, 1
 jmp .retnInit
;-997 	if(trueFATtype != 16) 	return 1;

.Init139:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init140
 mov ax, 1
 jmp .retnInit
;-998 	Int13hExt();

.Init140:
 call Int13hExt
;-999 	return 0;

 mov ax, 0
 jmp .retnInit
;-1000 }

;-1001 

;-1002 int main() {

 .retnInit:
 ret
Init_0 db "Init ",0
Init_1 db "** NO DRIVE PARAMS FOUND **",0
Init_2 db "** no active FAT partition found **",0
ENDP

main: PROC
;-1003 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-1004 	if (Init() != 0) return 1;

 call Init
 cmp al, 0
 je  .main141
 mov ax, 1
 jmp .retnmain
;-1005 	strcpy(&filename, "alfa5/binslash/dos.com");

.main141:
 push main_0
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1006 	fileOpen();	

 call fileOpen
;-1007 	fatNextSearch();	

 call fatNextSearch
;-1008 	strcpy(&filename, "tet/abc.d");

 push main_1
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1009 	fileOpen();	

 call fileOpen
;-1010 	strcpy(&filename, "T.dot/abc.");

 push main_2
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1011 	fileOpen();	

 call fileOpen
;-1012 	fatNextSearch();

 call fatNextSearch
;-1013 	strcpy(&filename, "test1.c");

 push main_3
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1014 	fileOpen();	

 call fileOpen
;-1015 	strcpy(&filename, "123456789.123");

 push main_4
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1016 	fileOpen();	

 call fileOpen
;-1017 	strcpy(&filename, "test2");

 push main_5
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1018 	fileOpen();	

 call fileOpen
;-1019 	fatNextSearch();

 call fatNextSearch
;-1020 	strcpy(&filename, " ");

 push main_6
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1021 	fileOpen();	

 call fileOpen
;-1022 	strcpy(&filename, "");

 push main_7
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1023 	fileOpen();	

 call fileOpen
;-1024 }

;-1025 /*cputs(" delimiter="); printunsign(delimiter);

;-1026 cputs(", isfilename="); printunsign(isfilename);

;-1027 cputs(", upto="); printunsign(upto);

;-1028 cputs("="); cputs(upto);

;-1029 cputs(", len="); printunsign(len);

;-1030 cputs(", searchstr="); cputsLen(searchstr, len);

;-1031 */

;-1032 

 .retnmain:
 ret
main_0 db "alfa5/binslash/dos.com",0
main_1 db "tet/abc.d",0
main_2 db "T.dot/abc.",0
main_3 db "test1.c",0
main_4 db "123456789.123",0
main_5 db "test2",0
main_6 db " ",0
main_7 db "",0
ENDP
