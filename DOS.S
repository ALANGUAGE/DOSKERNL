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
;-15 unsigned int  DiskBufSeg;

DiskBufSeg dw 0
;-16 unsigned char dummy[1];//todo remove

section .bss
absolute 16384
dummy resb 1
section .text
;-17 unsigned char DiskBuf [512];

section .bss
absolute 16385
DiskBuf resb 512
section .text
;-18 unsigned char Drive=0x80;

Drive db 128
;-19 //unsigned long sect_size_long;

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
;-26 char fat_notfound;

fat_notfound db 0
;-27 

;-28 //Params from int13h, Function 8

;-29 unsigned int  pa_Cylinders;

pa_Cylinders dw 0
;-30 unsigned char pa_Sectors;

pa_Sectors db 0
;-31 unsigned char pa_Heads;

pa_Heads db 0
;-32 unsigned char pa_Attached;

pa_Attached db 0
;-33 unsigned int  pt_PartNo;

pt_PartNo dw 0
;-34 

;-35 //start hard disk partition structure 16 bytes in MBR. do not change

;-36 unsigned char pt_Bootable;		// 00 80h = active partition, else 00

pt_Bootable db 0
;-37 unsigned char pt_StartHead;		// 01

pt_StartHead db 0
;-38 unsigned char pt_StartSector;	// 02 bits 0-5

pt_StartSector db 0
;-39 unsigned int  pt_StartCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-40 unsigned char pt_FileSystem;	// 04 0=nu,1=FAT12,4=16,5=ExtP,6=large16

pt_FileSystem db 0
;-41 unsigned char pt_EndHead;		// 05

pt_EndHead db 0
;-42 unsigned char pt_EndSector;		// 06 bits 0-5

pt_EndSector db 0
;-43 unsigned int  pt_EndCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-44 unsigned long pt_HiddenSector;	// 08 sectors preceding partition

pt_HiddenSector dd 0
;-45 unsigned long pt_PartLen;    	// 12 length of partition in sectors

pt_PartLen dd 0
;-46 //  16 end hard disk partition structure

;-47 

;-48 //start boot BIOS Parameter Block structure. do not change

;-49 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-50 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-51 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-52 unsigned char bs_clust_size;// 13 sectors per cluster (1,2,4,..,128)

bs_clust_size db 0
;-53 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-54 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-55 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-56 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-57 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-58 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-59 unsigned int  bs_sectors_per_track; // 24 (DOS 3+)sectors per track

bs_sectors_per_track dw 0
;-60 unsigned int  bs_num_heads;	// 26 (DOS 3+)number of heads

bs_num_heads dw 0
;-61 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors

bs_hid_sects dd 0
;-62 unsigned long bs_tot_sect32;// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-63 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-64 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-65 unsigned char bs_ext_signat;// 38 (DOS 4+) Ext. signature,get next 3(29h)

bs_ext_signat db 0
;-66 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-67 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-68 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-69 // 62 end boot BIOS Parameter Block

;-70 

;-71 //start directory entry structure, do not change

;-72 unsigned char dir_Filename[]="1234567";	//00 +lengthbyte=11

dir_Filename db "1234567",0
;-73 unsigned char dir_Ext[]="12";	//07 +lengthbyte=3

dir_Ext db "12",0
;-74 unsigned char dir_Attrib;		//11 directory=10h, Label=08h, read only=1

dir_Attrib db 0
;-75 unsigned char dir_NTReserved;	//12 low case in body=8h, in ext=10h

dir_NTReserved db 0
;-76 unsigned char dir_TimeCreatedMS;//13 in 10 milliseconda or zero

dir_TimeCreatedMS db 0
;-77 unsigned int  dir_TimeCreated;	//14 creation time, resolution 2 sec. or 0

dir_TimeCreated dw 0
;-78 unsigned int  dir_DateCreated;	//16 creation date or zero

dir_DateCreated dw 0
;-79 unsigned int  dir_DateLastAccessd;		//18 no time info available or zero

dir_DateLastAccessd dw 0
;-80 unsigned int  dir_FirstClusterHiBytes;	//20 FAT12/16 always zero

dir_FirstClusterHiBytes dw 0
;-81 unsigned int  dir_LastModTime;	//22 modification time on closing

dir_LastModTime dw 0
;-82 unsigned int  dir_LastModDate;	//24 modification date on closing

dir_LastModDate dw 0
;-83 unsigned int  dir_FirstCluster;	//26 1.clu. of file data,if filesize=0 then 0

dir_FirstCluster dw 0
;-84 unsigned long dir_FileSize;		//28 size in bytes, if directory then zero

dir_FileSize dd 0
;-85 // 32 end direcctory entry structure

;-86 

;-87 //FATInit

;-88 unsigned int  fat_FatStartSector;

fat_FatStartSector dw 0
;-89 unsigned long fat_FatStartSectorL;

fat_FatStartSectorL dd 0
;-90 unsigned int  fat_FatSectors;

fat_FatSectors dw 0
;-91 unsigned long fat_RootDirStartSectorL;

fat_RootDirStartSectorL dd 0
;-92 unsigned long fat_RootDirSectorsL;

fat_RootDirSectorsL dd 0
;-93 unsigned long fat_DataStartSectorL;

fat_DataStartSectorL dd 0
;-94 unsigned long fat_num_tracks;

fat_num_tracks dd 0
;-95 unsigned int  fat_num_cylinders;

fat_num_cylinders dw 0
;-96 unsigned long Sectors_per_cylinder;

Sectors_per_cylinder dd 0
;-97 unsigned long DataSectors32;

DataSectors32 dd 0
;-98 unsigned long CountofClusters;

CountofClusters dd 0
;-99 unsigned char trueFATtype;	//12, 16, 32 from FATInit

trueFATtype db 0
;-100 unsigned int  FATtype;		//0=error,1=FAT12,6=FAT16,11=FAT32 from ReadMBR

FATtype dw 0
;-101 

;-102 //fatfile

;-103 //unsigned char fat_filename [8];

;-104 //unsigned char fat_fileext  [3];

;-105 		 int  fatfile_root;

fatfile_root dw 0
;-106 unsigned int  fatfile_cluster;

fatfile_cluster dw 0
;-107 unsigned int  fatfile_nextCluster;

fatfile_nextCluster dw 0
;-108 unsigned int  fatfile_sectorCount;

fatfile_sectorCount dw 0
;-109 unsigned long fatfile_sectorStartL;

fatfile_sectorStartL dd 0
;-110 unsigned int  fatfile_lastBytes;

fatfile_lastBytes dw 0
;-111 unsigned int  fatfile_lastSectors;

fatfile_lastSectors dw 0
;-112          int  fatfile_dir;

fatfile_dir dw 0
;-113 unsigned int  fatfile_currentCluster;

fatfile_currentCluster dw 0
;-114 unsigned int  fatfile_sectorUpto;

fatfile_sectorUpto dw 0
;-115 unsigned int  fatfile_byteUpto;

fatfile_byteUpto dw 0
;-116 unsigned long fatfile_fileSize;

fatfile_fileSize dd 0
;-117 

;-118 int test() {


test: PROC
;-119 	__asm{


;-120 }	}


;-121 

;-122 //------------------------------------   IO  -------------------

;-123 

;-124 int writetty()     {//char in AL

 ret
ENDP

writetty: PROC
;-125     ah=0x0E;

 mov  ah, 14
;-126     push bx;

push bx;
;-127     bx=0;			//page in BH

 mov  bx, 0
;-128     inth 0x10;		//16

 int  16
;-129     pop bx;

pop bx;
;-130 }

;-131 int putch(char c)  {

 ret
ENDP

putch: PROC
;-132     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;99 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-133         al=13;

 mov  al, 13
;-134         writetty();

 call writetty
;-135     }

;-136     al=c;

.putch1:
 mov  al, [bp+4]
;-137     writetty();

 call writetty
;-138 }

;-139 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-140     char c;

;-141     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;99 ptr sign byte s = bp+4
;100 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-142         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-143         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-144         s++;

 inc  word[bp+4]
;-145     }

;-146 }

 jmp .cputs2
.cputs3:
;-147 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-148 	char c;

;-149 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;99 ptr sign byte s = bp+4
;100 var sign word len = bp+6
;101 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-150 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-151 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-152 		s++;

 inc  word[bp+4]
;-153 		len--;

 dec  word[bp+6]
;-154 	} while (len > 0);

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-155 }

;-156 

;-157 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-158     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-159     inth 0x16;//AH=Scan code, AL=char

 int  22
;-160 }

;-161 int waitkey() {

 ret
ENDP

waitkey: PROC
;-162     ah=0x11;//get kbd status

 mov  ah, 17
;-163     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-164     //zero flag: 0=IS char, 1=NO char

;-165     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-166 }

;-167 int getkey() {

 ret
ENDP

getkey: PROC
;-168     waitkey();

 call waitkey
;-169     getch();

 call getch
;-170     ah=0;//clear scan code

 mov  ah, 0
;-171     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-172     //put ext code in AX

;-173 }

.getkey6:
;-174 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-175     getkey();

 call getkey
;-176     writetty();//destroys AH

 call writetty
;-177 }

;-178 

;-179 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-180     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;99 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-181     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-182     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-183 }

;-184 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-185     unsigned char nib;

;-186     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;99 var unsg byte c = bp+4
;100 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-187     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-188 }

;-189 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-190     unsigned int half;

;-191     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;99 var unsg word i = bp+4
;100 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-192     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-193 }

;-194 

;-195 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-196     unsigned int e;

;-197     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;99 var unsg word n = bp+4
;100 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-198         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-199         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-200         }

;-201     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-202     n+='0';

 add  word[bp+4], 48
;-203     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-204 }

;-205 

;-206 int printlong(unsigned long L) {

 LEAVE
 ret
ENDP

printlong: PROC
;-207     ax = L;     // get low in ax

;Function : printlong, Number local Var: 1
; # type sign width local variables
;99 var unsg long L = bp+4;
 ENTER  0,0
 mov  ax, [bp+4]
;-208     edx=L;

 mov  edx, [bp+4]
;-209     edx >> 16;  // get high in dx

 shr  edx, 16
;-210 __asm{


;-211   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-212     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-213 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-214     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-215     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-216 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-217     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-218     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-219     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-220     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-221     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-222     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-223     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-224     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-225 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-226 }	writetty();		__asm{


 call writetty

;-227     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-228     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-229     jb      .b             ;Not yet

    jb      .b             ;Not yet
;-230 }


;-231 }

;-232 //--------------------------------  string  ---------------------

;-233 int strlen(char *s) { int c;

 LEAVE
 ret
ENDP

strlen: PROC
;-234     c=0;

;Function : strlen, Number local Var: 2
; # type sign width local variables
;99 ptr sign byte s = bp+4
;100 var sign word c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-235     while (*s!=0) {s++; c++;}

.strlen9:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen10
 inc  word[bp+4]
 inc  word[bp-2]
;-236     return c;

 jmp .strlen9
.strlen10:
 mov ax, [bp-2]
 jmp .retnstrlen
;-237 }

;-238 int strcpy(char *s, char *t) {

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-239     do { *s=*t; s++; t++; }

;Function : strcpy, Number local Var: 2
; # type sign width local variables
;99 ptr sign byte s = bp+4
;100 ptr sign byte t = bp+6;
 ENTER  0,0
.strcpy11:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-240     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy12
 jmp .strcpy11
.strcpy12:
;-241     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-242     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-243 }

;-244 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-245     while(*p) {

;Function : eqstr, Number local Var: 2
; # type sign width local variables
;99 ptr sign byte p = bp+4
;100 ptr sign byte q = bp+6;
 ENTER  0,0
.eqstr13:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr14
;-246         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr15
 mov ax, 0
 jmp .retneqstr
;-247         p++;

.eqstr15:
 inc  word[bp+4]
;-248         q++;

 inc  word[bp+6]
;-249     }

;-250     if(*q) return 0;

 jmp .eqstr13
.eqstr14:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr16
 mov ax, 0
 jmp .retneqstr
;-251     return 1;

.eqstr16:
 mov ax, 1
 jmp .retneqstr
;-252 }

;-253 

;-254 int memcmp(char *s, char *t, unsigned int i) {

 .retneqstr:
 LEAVE
 ret
ENDP

memcmp: PROC
;-255     do {

;Function : memcmp, Number local Var: 3
; # type sign width local variables
;99 ptr sign byte s = bp+4
;100 ptr sign byte t = bp+6
;101 var unsg word i = bp+8;
 ENTER  0,0
.memcmp17:
;-256         if (*s < *t) return 0xFFFF;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 jge .memcmp18
 mov ax, 65535
 jmp .retnmemcmp
;-257         if (*s > *t) return 1;

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
;-258         s++; t++; i--;

.memcmp19:
 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-259     } while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcmp20
 jmp .memcmp17
.memcmp20:
;-260     return 0;

 mov ax, 0
 jmp .retnmemcmp
;-261 }

;-262 

;-263 int strcat(char *s, char *t) {

 .retnmemcmp:
 LEAVE
 ret
ENDP

strcat: PROC
;-264     while (*s != 0) s++;

;Function : strcat, Number local Var: 2
; # type sign width local variables
;99 ptr sign byte s = bp+4
;100 ptr sign byte t = bp+6;
 ENTER  0,0
.strcat21:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat22
 inc  word[bp+4]
;-265     strcpy(s, t);

 jmp .strcat21
.strcat22:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4
;-266 }

;-267 int toupper(char *s) {

 LEAVE
 ret
ENDP

toupper: PROC
;-268     while(*s) {

;Function : toupper, Number local Var: 1
; # type sign width local variables
;99 ptr sign byte s = bp+4;
 ENTER  0,0
.toupper23:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper24
;-269         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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
;-270         s++;

.toupper26:
.toupper25:
 inc  word[bp+4]
;-271     }

;-272 }

 jmp .toupper23
.toupper24:
;-273 int strchr(char *s, char c) {

 LEAVE
 ret
ENDP

strchr: PROC
;-274     while(*s) {

;Function : strchr, Number local Var: 2
; # type sign width local variables
;99 ptr sign byte s = bp+4
;100 var sign byte c = bp+6;
 ENTER  0,0
.strchr27:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .strchr28
;-275         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .strchr29
 mov ax, [bp+4]
 jmp .retnstrchr
;-276         s++;

.strchr29:
 inc  word[bp+4]
;-277     }

;-278     return 0;

 jmp .strchr27
.strchr28:
 mov ax, 0
 jmp .retnstrchr
;-279 }

;-280 int memchr(char *s, char c, unsigned int i) {

 .retnstrchr:
 LEAVE
 ret
ENDP

memchr: PROC
;-281     while(i > 0) {

;Function : memchr, Number local Var: 3
; # type sign width local variables
;99 ptr sign byte s = bp+4
;100 var sign byte c = bp+6
;101 var unsg word i = bp+8;
 ENTER  0,0
.memchr30:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr31
;-282         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr32
 mov ax, [bp+4]
 jmp .retnmemchr
;-283         s++; i--;

.memchr32:
 inc  word[bp+4]
 dec  word[bp+8]
;-284     }

;-285     return 0;

 jmp .memchr30
.memchr31:
 mov ax, 0
 jmp .retnmemchr
;-286 }

;-287 int memchr1(char *s, char c, unsigned int i) {

 .retnmemchr:
 LEAVE
 ret
ENDP

memchr1: PROC
;-288 	unsigned int pos;

;-289 	pos=1;

;Function : memchr1, Number local Var: 4
; # type sign width local variables
;99 ptr sign byte s = bp+4
;100 var sign byte c = bp+6
;101 var unsg word i = bp+8
;102 var unsg word pos = bp-2;
 ENTER  2,0
 mov ax, 1
 mov [bp-2], ax
;-290     while(i > 0) {

.memchr133:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr134
;-291         if (*s==c) return pos;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr135
 mov ax, [bp-2]
 jmp .retnmemchr1
;-292         s++; i--; pos++;

.memchr135:
 inc  word[bp+4]
 dec  word[bp+8]
 inc  word[bp-2]
;-293     }

;-294     return 0;

 jmp .memchr133
.memchr134:
 mov ax, 0
 jmp .retnmemchr1
;-295 }

;-296 int instr1(char *s, char c) {

 .retnmemchr1:
 LEAVE
 ret
ENDP

instr1: PROC
;-297     while(*s) {

;Function : instr1, Number local Var: 2
; # type sign width local variables
;99 ptr sign byte s = bp+4
;100 var sign byte c = bp+6;
 ENTER  0,0
.instr136:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .instr137
;-298         if (*s==c) return 1;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .instr138
 mov ax, 1
 jmp .retninstr1
;-299         s++;

.instr138:
 inc  word[bp+4]
;-300     }

;-301     return 0;

 jmp .instr136
.instr137:
 mov ax, 0
 jmp .retninstr1
;-302 }

;-303 

;-304 int memcpy(char *s, char *t, unsigned int i) {

 .retninstr1:
 LEAVE
 ret
ENDP

memcpy: PROC
;-305 	unsigned int r;

;-306 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;99 ptr sign byte s = bp+4
;100 ptr sign byte t = bp+6
;101 var unsg word i = bp+8
;102 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-307 	do {

.memcpy39:
;-308 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-309 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-310 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy40
 jmp .memcpy39
.memcpy40:
;-311 	ax=r;//	return r;

 mov  ax, [bp-2]
;-312 }

;-313 

;-314 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-315     unsigned char c; int i; int j; int k;

;-316     j=0;

;Function : mdump, Number local Var: 6
; # type sign width local variables
;99 ptr unsg byte adr = bp+4
;100 var unsg word len = bp+6
;101 var unsg byte c = bp-2
;102 var sign word i = bp-4
;103 var sign word j = bp-6
;104 var sign word k = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-6], ax
;-317     k=0;

 mov ax, 0
 mov [bp-8], ax
;-318     while (j < len ) {

.mdump41:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump42
;-319 	    k++;;

 inc  word[bp-8]
;-320 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump43
;-321 		    getkey();

 call getkey
;-322 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-323 		    }

;-324         putch(10);

.mdump43:
 push 10
 call putch
 add  sp, 2
;-325         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-326         putch(':');

 push 58
 call putch
 add  sp, 2
;-327         i=0;

 mov ax, 0
 mov [bp-4], ax
;-328         while (i < 16) {

.mdump44:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump45
;-329             putch(' ');

 push 32
 call putch
 add  sp, 2
;-330             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-331             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-332             adr++;

 inc  word[bp+4]
;-333             i++;

 inc  word[bp-4]
;-334             j++;

 inc  word[bp-6]
;-335             }

;-336         putch(' ');

 jmp .mdump44
.mdump45:
 push 32
 call putch
 add  sp, 2
;-337         adr -=16;

 sub  word[bp+4], 16
;-338         i=0;

 mov ax, 0
 mov [bp-4], ax
;-339         while(i < 16) {

.mdump46:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump47
;-340             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-341             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump48
 push 46
 call putch
 add  sp, 2
;-342                 else putch(c);

 jmp .mdump49
.mdump48:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-343             adr++;

.mdump49:
 inc  word[bp+4]
;-344             i++;

 inc  word[bp-4]
;-345         }

;-346     }

 jmp .mdump46
.mdump47:
;-347 }

 jmp .mdump41
.mdump42:
;-348 

;-349 //--------------------------------  disk IO  -------------------

;-350 

;-351 int DiskSectorReadWrite(char rw, char drive, char head, int cyl,

 LEAVE
 ret
ENDP

DiskSectorReadWrite: PROC
;-352 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-353 	BIOS_ERR=0;

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;99 var sign byte rw = bp+4
;100 var sign byte drive = bp+6
;101 var sign byte head = bp+8
;102 var sign word cyl = bp+10
;103 var sign byte sector = bp+12
;104 var sign byte count = bp+14
;105 var sign word BufSeg = bp+16
;106 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-354 	dl=drive;

 mov  dl, [bp+6]
;-355 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-356 	es=BufSeg;

 mov  es, [bp+16]
;-357 	bx=BufOfs;

 mov  bx, [bp+18]
;-358 	cx=cyl;

 mov  cx, [bp+10]
;-359 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-360 	cx >> 2;//in 2 high bits of cl

 shr  cx, 2
;-361 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-362 	cl += sector;

 add  cl, [bp+12]
;-363 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-364 	al=count;

 mov  al, [bp+14]
;-365 	ah=rw;

 mov  ah, [bp+4]
;-366 	inth 0x13;

 int  19
;-367     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-368 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-369 }

;-370 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-371 	BIOS_ERR=0;

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;99 var sign byte drive = bp+4
;100 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-372 	dl=drive;

 mov  dl, [bp+4]
;-373 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-374 	inth 0x13;

 int  19
;-375     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-376 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-377 }

;-378 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-379 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-380 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-381 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-382 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-383 }

;-384 int Status(drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Status: PROC
;-385 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;99 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-386 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-387 	BIOS_Status=Int13hfunction(drive, 1);

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-388 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Status50
 call Int13hError
;-389 	printhex16(BIOS_Status);

.Status50:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-390 }

;-391 

;-392 int Params() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

Params: PROC
;-393 	cputs("Get Drive Params ");

 push Params_0
 call cputs
 add  sp, 2
;-394 	BIOS_Status=Int13hfunction(Drive, 8);

 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-395 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params51
;-396 		Int13hError();

 call Int13hError
;-397 		return 1;

 mov ax, 1
 jmp .retnParams
;-398 		}

;-399 	else {

 jmp .Params52
.Params51:
;-400 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-401 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-402 		// CX =       ---CH--- ---CL---

;-403 		// cylinder : 76543210 98

;-404 		// sector   :            543210

;-405 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-406 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-407 //		pa_Sectors++;//1 to 64

;-408 

;-409 		asm mov [pa_Cylinders],    cx

 mov [pa_Cylinders],    cx
;-410 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-411 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-412 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty

 add [pa_Cylinders],    ch;//byte add, low byte is empty
;-413 

;-414 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params53
;-415 			cputs(" no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-416 			return 1;

 mov ax, 1
 jmp .retnParams
;-417 			}

;-418 	}

.Params53:
;-419 	return 0;

.Params52:
 mov ax, 0
 jmp .retnParams
;-420 }

;-421 

;-422 

;-423 int getPartitionData() {

 .retnParams:
 ret
Params_0 db "Get Drive Params ",0
Params_1 db " no hard disk found",0
ENDP

getPartitionData: PROC
;-424 	unsigned int j; char c; char *p;

;-425 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;99 var unsg word j = bp-2
;100 var sign byte c = bp-4
;101 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [pt_PartNo]
 shl ax, 4
 mov [bp-2], ax
;-426 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-427 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-428 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-429 	pt_StartCylinder=(int)pt_StartSector;

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-430 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-431 //	pt_StartSector++;//Sector start with 1 todo

;-432 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-433 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-434 	j++;

 inc  word[bp-2]
;-435 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-436 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-437 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB

;-438 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-439 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-440 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-441 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-442 //	pt_EndSector++;//Sector start with 1 todo

;-443 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-444 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-445 	j++;

 inc  word[bp-2]
;-446 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-447 	j++;

 inc  word[bp-2]
;-448 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-449 	memcpy(&pt_HiddenSector, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-450 }

;-451 

;-452 int checkBootSign() {

 LEAVE
 ret
ENDP

checkBootSign: PROC
;-453 	int i;

;-454 	i=510;

;Function : checkBootSign, Number local Var: 1
; # type sign width local variables
;99 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-455 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign54
;-456 		i++;

 inc  word[bp-2]
;-457 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign55
 mov ax, 1
 jmp .retncheckBootSign
;-458 	}

.checkBootSign55:
;-459 	cputs(" Magic number NOT found.");

.checkBootSign54:
 push checkBootSign_0
 call cputs
 add  sp, 2
;-460 	return 0;

 mov ax, 0
 jmp .retncheckBootSign
;-461 }

;-462 

;-463 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db " Magic number NOT found.",0
ENDP

readMBR: PROC
;-464 	int isFAT;

;-465 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;99 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-466 	pt_PartNo=0;

 mov ax, 0
 mov word [pt_PartNo], ax
;-467 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-468 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR56
;-469 		Int13hError();

 call Int13hError
;-470 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-471 		}

;-472 	else {

 jmp .readMBR57
.readMBR56:
;-473 		putch(10);

 push 10
 call putch
 add  sp, 2
;-474 //		cputs("Read partition.");

;-475 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .readMBR58
 mov ax, 0
 jmp .retnreadMBR
;-476 		do {

.readMBR58:
.readMBR59:
;-477 			getPartitionData();

 call getPartitionData
;-478 

;-479 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR60
;-480 //				cputs("Boot partition found");

;-481 				if (pt_FileSystem == 1) {

 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR61
;-482 					cputs(", FAT12 partition < 32MB");

 push readMBR_0
 call cputs
 add  sp, 2
;-483 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-484 					}

;-485 				if (pt_FileSystem == 4) {

.readMBR61:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR62
;-486 					cputs(", small FAT16 partition < 32MB");

 push readMBR_1
 call cputs
 add  sp, 2
;-487 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-488 					}

;-489 				if (pt_FileSystem == 6) {

.readMBR62:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR63
;-490 //					cputs(", large FAT16 partition < 2GB");

;-491 					isFAT=6;

 mov ax, 6
 mov [bp-2], ax
;-492 					}

;-493 				pt_PartNo=99;//end of loop

.readMBR63:
 mov ax, 99
 mov word [pt_PartNo], ax
;-494 			}

;-495 			pt_PartNo ++;

.readMBR60:
 inc  word[pt_PartNo]
;-496 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR64
 jmp .readMBR59
.readMBR64:
;-497 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-498 	}

;-499 }

.readMBR57:
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

;-503 	putch(10);

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;99 var sign word i = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-504 	cputs(" Read boot sector");

 push getBootSector_0
 call cputs
 add  sp, 2
;-505   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

;-506   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-507 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector65
;-508 		Int13hError();

 call Int13hError
;-509 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-510 		}

;-511 	else {

 jmp .getBootSector66
.getBootSector65:
;-512 //		printhex16(BIOS_Status);

;-513 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .getBootSector67
 mov ax, 0
 jmp .retngetBootSector
;-514 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector67:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-515 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector68
 push getBootSector_1
 call cputs
 add  sp, 2
;-516 		i=2;

.getBootSector68:
 mov ax, 2
 mov [bp-2], ax
;-517 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector69
 push getBootSector_2
 call cputs
 add  sp, 2
;-518 	}

.getBootSector69:
;-519 	return 1;

.getBootSector66:
 mov ax, 1
 jmp .retngetBootSector
;-520 }

;-521 

;-522 int FATInit() {

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Read boot sector",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-523 	unsigned long templong;//converting word to dword

;-524 

;-525 	clust_sizeL = (long) bs_clust_size;

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;99 var unsg long templong = bp-4;
 ENTER  4,0
 xor eax, eax
 mov al, [bs_clust_size]
 mov dword [clust_sizeL], eax
;-526 	sector_sizeL= (long) bs_sect_size;

 xor eax, eax
 mov ax, [bs_sect_size]
 mov dword [sector_sizeL], eax
;-527 

;-528 	fat_FatStartSector = bs_res_sects;

 mov ax, [bs_res_sects]
 mov word [fat_FatStartSector], ax
;-529 	fat_FatStartSectorL= (long) fat_FatStartSector; 

 xor eax, eax
 mov ax, [fat_FatStartSector]
 mov dword [fat_FatStartSectorL], eax
;-530 	fat_FatSectors = bs_fat_size;

 mov ax, [bs_fat_size]
 mov word [fat_FatSectors], ax
;-531 	if (bs_num_fats == 2) fat_FatSectors=fat_FatSectors+fat_FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .FATInit70
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-532 

;-533 	fat_RootDirStartSectorL = (long)fat_FatStartSector + fat_FatSectors;

.FATInit70:
 xor eax, eax
 mov ax, [fat_FatStartSector]
 add ax, [fat_FatSectors]
 mov dword [fat_RootDirStartSectorL], eax
;-534 	

;-535 	fat_RootDirSectorsL = (long) bs_root_entr >> 4;//  ./. 16

 xor eax, eax
 mov ax, [bs_root_entr]
 shr ax, 4
 mov dword [fat_RootDirSectorsL], eax
;-536 		

;-537 	fat_DataStartSectorL = fat_RootDirStartSectorL + fat_RootDirSectorsL;

 mov eax, [fat_RootDirStartSectorL]
 add eax, [fat_RootDirSectorsL]
 mov dword [fat_DataStartSectorL], eax
;-538 

;-539 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .FATInit71
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-540 	DataSectors32=bs_tot_sect32 - fat_DataStartSectorL;

.FATInit71:
 mov eax, [bs_tot_sect32]
 sub eax, [fat_DataStartSectorL]
 mov dword [DataSectors32], eax
;-541 

;-542 	CountofClusters=DataSectors32 / clust_sizeL;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [clust_sizeL]
 mov dword [CountofClusters], eax
;-543 

;-544 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-545 	fat_num_tracks = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [fat_num_tracks], eax
;-546 

;-547 	templong = (long) bs_num_heads;

 xor eax, eax
 mov ax, [bs_num_heads]
 mov [bp-4], eax
;-548 	fat_num_cylinders = fat_num_tracks / templong;//w=d/w

 mov eax, [fat_num_tracks]
 xor edx, edx
 div dword [bp-4]
 mov word [fat_num_cylinders], ax
;-549 

;-550 	Sectors_per_cylinder = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinder], eax
;-551 	asm mov [Sectors_per_cylinder + 2], dx;store high word

 mov [Sectors_per_cylinder + 2], dx;store high word
;-552 

;-553 //	cputs(", trueFATtype=");

;-554 

;-555 	templong = (long) 65525;

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-556 	if (CountofClusters > templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jle .FATInit72
;-557 		trueFATtype=32;

 mov ax, 32
 mov byte [trueFATtype], al
;-558 		cputs(" FAT32 NOT supported");

 push FATInit_0
 call cputs
 add  sp, 2
;-559 		return 1;

 mov ax, 1
 jmp .retnFATInit
;-560 		}

;-561 	templong= (long) 4086;

.FATInit72:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-562 	if (CountofClusters < templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jge .FATInit73
;-563 		trueFATtype=12;

 mov ax, 12
 mov byte [trueFATtype], al
;-564 		cputs(" FAT12");

 push FATInit_1
 call cputs
 add  sp, 2
;-565 		return 0;

 mov ax, 0
 jmp .retnFATInit
;-566 		}

;-567 	trueFATtype=16;

.FATInit73:
 mov ax, 16
 mov byte [trueFATtype], al
;-568 	cputs(" FAT16");

 push FATInit_2
 call cputs
 add  sp, 2
;-569 	return 0;

 mov ax, 0
 jmp .retnFATInit
;-570 }

;-571 

;-572 int Int13hExt() {

 .retnFATInit:
 LEAVE
 ret
FATInit_0 db " FAT32 NOT supported",0
FATInit_1 db " FAT12",0
FATInit_2 db " FAT16",0
ENDP

Int13hExt: PROC
;-573 	bx=0x55AA;

 mov  bx, 21930
;-574 	BIOS_Status=Int13hfunction(Drive, 0x41);

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-575 	asm mov [vAX], ax;

 mov [vAX], ax;
;-576 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-577 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported
;-578 //	putch(10);

;-579 //	cputs("Int13h 41h Ext=");	printhex16(vAX);

;-580 //	cputs(", BIOS_Status=");	printhex16(BIOS_Status);

;-581 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt74
;-582 		cputs(" Ext NOT present");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-583 		Int13hError();

 call Int13hError
;-584 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-585 		}

;-586 	else {

 jmp .Int13hExt75
.Int13hExt74:
;-587 	cputs(",Int13h Extension found");

 push Int13hExt_1
 call cputs
 add  sp, 2
;-588 //		cputs(",Extension found BX(AA55)=");printhex16(vBX);

;-589 //		cputs(" CX=");						printhex16(vCX);

;-590 		}

;-591 	return 0;

.Int13hExt75:
 mov ax, 0
 jmp .retnInt13hExt
;-592 }

;-593 

;-594 int PrintDriveParameter() {

 .retnInt13hExt:
 ret
Int13hExt_0 db " Ext NOT present",0
Int13hExt_1 db ",Int13h Extension found",0
ENDP

PrintDriveParameter: PROC
;-595 	unsigned long Lo;

;-596 // from Params

;-597 	putch(10);

;Function : PrintDriveParameter, Number local Var: 1
; # type sign width local variables
;99 var unsg long Lo = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-598 	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);

 push PrintDriveParameter_0
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-599 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-600 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-601 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-602 	putch('.');

 push 46
 call putch
 add  sp, 2
;-603 //from getPartitionData

;-604 	putch(10);

 push 10
 call putch
 add  sp, 2
;-605 	cputs("getPartitionData:No=");printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-606 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-607 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-608 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-609 	cputs("/");				printunsign(pt_StartSector);

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-610 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-611 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-612 	cputs("/");				printunsign(pt_EndSector);

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-613 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-614 	cputs(",Start=");		printlong(pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 push dword [pt_HiddenSector]
 call printlong
 add  sp, 4
;-615 	cputs(",Len=");			printlong(pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 push dword [pt_PartLen]
 call printlong
 add  sp, 4
;-616 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-617 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-618 	printlong(Lo);

 push dword [bp-4]
 call printlong
 add  sp, 4
;-619 	cputs(" MByte.");

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-620 //from getBootSector

;-621 	putch(10);

 push 10
 call putch
 add  sp, 2
;-622 	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-623 	putch(10);

 push 10
 call putch
 add  sp, 2
;-624 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-625 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-626 	putch(10);

 push 10
 call putch
 add  sp, 2
;-627 	cputs("Reserved sectors=");printunsign(bs_res_sects);

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-628 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-629 	putch(10);

 push 10
 call putch
 add  sp, 2
;-630 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-631 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-632 	putch(10);

 push 10
 call putch
 add  sp, 2
;-633 	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-634 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-635 	putch(10);

 push 10
 call putch
 add  sp, 2
;-636 	cputs("sectors per track=");printunsign(bs_sectors_per_track);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_sectors_per_track]
 call printunsign
 add  sp, 2
;-637 	cputs(".number of heads=");printunsign(bs_num_heads);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_heads]
 call printunsign
 add  sp, 2
;-638 	putch(10);

 push 10
 call putch
 add  sp, 2
;-639 	cputs("hidden sectors(long)=");printlong(bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 push dword [bs_hid_sects]
 call printlong
 add  sp, 4
;-640 	cputs(".sectors(long)=");printlong(bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 push dword [bs_tot_sect32]
 call printlong
 add  sp, 4
;-641 	putch(10);

 push 10
 call putch
 add  sp, 2
;-642 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-643 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-644 	putch(10);

 push 10
 call putch
 add  sp, 2
;-645 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-646 	cputs(".Volume serial(long)=");printlong(bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 push dword [bs_serial_num]
 call printlong
 add  sp, 4
;-647 	putch(10);

 push 10
 call putch
 add  sp, 2
;-648 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-649 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-650 //from FATInit

;-651 	putch(10);

 push 10
 call putch
 add  sp, 2
;-652 	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [fat_FatStartSector]
 call printunsign
 add  sp, 2
;-653 	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [fat_FatSectors]
 call printunsign
 add  sp, 2
;-654 	putch(10);

 push 10
 call putch
 add  sp, 2
;-655 	cputs("fat_RootDirStartSectorL="); printlong(fat_RootDirStartSectorL);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push dword [fat_RootDirStartSectorL]
 call printlong
 add  sp, 4
;-656 	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectorsL);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push dword [fat_RootDirSectorsL]
 call printunsign
 add  sp, 4
;-657 	putch(10);

 push 10
 call putch
 add  sp, 2
;-658 	cputs("fat_DataStartSectorL=");	printunsign(fat_DataStartSectorL);

 push PrintDriveParameter_38
 call cputs
 add  sp, 2
 push dword [fat_DataStartSectorL]
 call printunsign
 add  sp, 4
;-659 	cputs(", DataSectors32=");	printlong(DataSectors32);

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 push dword [DataSectors32]
 call printlong
 add  sp, 4
;-660 	putch(10);

 push 10
 call putch
 add  sp, 2
;-661 	cputs("CountofClusters=");	printlong(CountofClusters);

 push PrintDriveParameter_40
 call cputs
 add  sp, 2
 push dword [CountofClusters]
 call printlong
 add  sp, 4
;-662 	cputs(", Sectors_per_cylinder="); printlong(Sectors_per_cylinder);

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 push dword [Sectors_per_cylinder]
 call printlong
 add  sp, 4
;-663 	putch(10);

 push 10
 call putch
 add  sp, 2
;-664 	cputs("fat_num_tracks=");	printlong(fat_num_tracks);

 push PrintDriveParameter_42
 call cputs
 add  sp, 2
 push dword [fat_num_tracks]
 call printlong
 add  sp, 4
;-665 	cputs(", fat_num_cylinders="); printunsign(fat_num_cylinders);

 push PrintDriveParameter_43
 call cputs
 add  sp, 2
 push word [fat_num_cylinders]
 call printunsign
 add  sp, 2
;-666 }

;-667 

;-668 //--------------------------------  file IO  -------------------

;-669 int error2(char *s) {

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
;-670 	putch(10);

;Function : error2, Number local Var: 1
; # type sign width local variables
;99 ptr sign byte s = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-671 	cputs("*** ERROR *** ");

 push error2_0
 call cputs
 add  sp, 2
;-672 	cputs(s);

 push word [bp+4]
 call cputs
 add  sp, 2
;-673 	DOS_ERR++;

 inc  byte[DOS_ERR]
;-674 }

;-675 // 1.

;-676 int readLogical(unsigned long SectorL) {//OUT:1 sector in DiskBuf

 LEAVE
 ret
error2_0 db "*** ERROR *** ",0
ENDP

readLogical: PROC
;-677 	unsigned int track; unsigned int head; unsigned int sect;

;-678 	SectorL = SectorL + bs_hid_sects;//d=d+d

;Function : readLogical, Number local Var: 4
; # type sign width local variables
;99 var unsg long SectorL = bp+4
;100 var unsg word track = bp-2
;101 var unsg word head = bp-4
;102 var unsg word sect = bp-6;
 ENTER  6,0
 mov eax, [bp+4]
 add eax, [bs_hid_sects]
 mov [bp+4], eax
;-679 	track = SectorL / Sectors_per_cylinder;  //w=d/d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinder]
 mov [bp-2], ax
;-680 	head  = SectorL % Sectors_per_cylinder;  //w=d%d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinder]
 mov eax, edx
 mov [bp-4], ax
;-681 	sect  = head            % bs_sectors_per_track;  //w=w%w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov ax, dx
 mov [bp-6], ax
;-682 	sect++;

 inc  word[bp-6]
;-683 	head  = head            / bs_sectors_per_track;	 //w=w/w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov [bp-4], ax
;-684 

;-685 	DiskSectorReadWrite(2, bs_drive_num, head, track/* =cyl */,

;-686 		sect, 1, DiskBufSeg , DiskBuf);

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
;-687 }

;-688 

;-689 // 2.a

;-690 int printDirEntry() {

 LEAVE
 ret
ENDP

printDirEntry: PROC
;-691     unsigned int j;

;-692 	putch(10);

;Function : printDirEntry, Number local Var: 1
; # type sign width local variables
;99 var unsg word j = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-693 	cputs(filename);

 lea  ax, [filename]
 push ax
 call cputs
 add  sp, 2
;-694 	cputs(" ATTR:");

 push printDirEntry_0
 call cputs
 add  sp, 2
;-695 	printhex8(dir_Attrib);	

 mov al, byte [dir_Attrib]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-696 	if (dir_Attrib &  1) cputs(" r/o");

 mov al, [dir_Attrib]
 and al, 1
 or  al, al
 je .printDirEntry76
 push printDirEntry_1
 call cputs
 add  sp, 2
;-697 	if (dir_Attrib &  2) cputs(" hid");

.printDirEntry76:
 mov al, [dir_Attrib]
 and al, 2
 or  al, al
 je .printDirEntry77
 push printDirEntry_2
 call cputs
 add  sp, 2
;-698 	if (dir_Attrib &  4) cputs(" sys");

.printDirEntry77:
 mov al, [dir_Attrib]
 and al, 4
 or  al, al
 je .printDirEntry78
 push printDirEntry_3
 call cputs
 add  sp, 2
;-699 	if (dir_Attrib &  8) cputs(" vol");		

.printDirEntry78:
 mov al, [dir_Attrib]
 and al, 8
 or  al, al
 je .printDirEntry79
 push printDirEntry_4
 call cputs
 add  sp, 2
;-700 	if (dir_Attrib & 16) cputs(" dir");

.printDirEntry79:
 mov al, [dir_Attrib]
 and al, 16
 or  al, al
 je .printDirEntry80
 push printDirEntry_5
 call cputs
 add  sp, 2
;-701 	if (dir_Attrib & 32) cputs(" arc");

.printDirEntry80:
 mov al, [dir_Attrib]
 and al, 32
 or  al, al
 je .printDirEntry81
 push printDirEntry_6
 call cputs
 add  sp, 2
;-702 	if (dir_Attrib == 0) cputs("    ");

.printDirEntry81:
 mov al, [dir_Attrib]
 cmp al, 0
 jne .printDirEntry82
 push printDirEntry_7
 call cputs
 add  sp, 2
;-703 	

;-704 	putch(' ');

.printDirEntry82:
 push 32
 call putch
 add  sp, 2
;-705 	j=dir_LastModDate & 31;//day

 mov ax, [dir_LastModDate]
 and ax, 31
 mov [bp-2], ax
;-706 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry83
 push 32
 call putch
 add  sp, 2
;-707 	printunsign(j);

.printDirEntry83:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-708 	putch('.');

 push 46
 call putch
 add  sp, 2
;-709 

;-710 	j=dir_LastModDate >> 5;//month

 mov ax, [dir_LastModDate]
 shr ax, 5
 mov [bp-2], ax
;-711 	j&=  15;

 and  word[bp-2], 15
;-712 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry84
 push 48
 call putch
 add  sp, 2
;-713 	printunsign(j);

.printDirEntry84:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-714 	putch('.');

 push 46
 call putch
 add  sp, 2
;-715 

;-716 	j=dir_LastModDate >> 9;//year

 mov ax, [dir_LastModDate]
 shr ax, 9
 mov [bp-2], ax
;-717 	j+= 1980;

 add  word[bp-2], 1980
;-718 	printunsign(j);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-719 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-720 	//putch(' ');

;-721 

;-722 	j=dir_LastModTime  >>11;//hour

 mov ax, [dir_LastModTime]
 shr ax, 11
 mov [bp-2], ax
;-723 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry85
 push 32
 call putch
 add  sp, 2
;-724 	printunsign(j);

.printDirEntry85:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-725 	putch(':');

 push 58
 call putch
 add  sp, 2
;-726 

;-727 	j=dir_LastModTime  >> 5;//minute

 mov ax, [dir_LastModTime]
 shr ax, 5
 mov [bp-2], ax
;-728 	j&=  63;

 and  word[bp-2], 63
;-729 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry86
 push 48
 call putch
 add  sp, 2
;-730 	printunsign(j);

.printDirEntry86:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-731 	putch(':');

 push 58
 call putch
 add  sp, 2
;-732 

;-733 	j=dir_LastModTime & 31;// 2 seconds

 mov ax, [dir_LastModTime]
 and ax, 31
 mov [bp-2], ax
;-734 	j=j+j;

 mov ax, [bp-2]
 add ax, [bp-2]
 mov [bp-2], ax
;-735 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry87
 push 48
 call putch
 add  sp, 2
;-736 	printunsign(j);

.printDirEntry87:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-737 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-738 

;-739 	cputs(" 1.Cl:"); 

 push printDirEntry_8
 call cputs
 add  sp, 2
;-740 	printunsign(dir_FirstCluster);

 push word [dir_FirstCluster]
 call printunsign
 add  sp, 2
;-741 	cputs(" Size:");

 push printDirEntry_9
 call cputs
 add  sp, 2
;-742 	printlong(dir_FileSize);

 push dword [dir_FileSize]
 call printlong
 add  sp, 4
;-743 	

;-744 }

;-745 

;-746 // 2.b

;-747 int fatDirSectorList(unsigned long startSector, unsigned long numsectors) {

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
;-748     char *p;

;-749 	unsigned int EndDiskBuf;

;-750 	char isHide;//shows entries, NOT lfn, deleted or empty

;-751 	

;-752 	do {

;Function : fatDirSectorList, Number local Var: 5
; # type sign width local variables
;99 var unsg long startSector = bp+4
;100 var unsg long numsectors = bp+8
;101 ptr sign byte p = bp-2
;102 var unsg word EndDiskBuf = bp-4
;103 var sign byte isHide = bp-6;
 ENTER  6,0
.fatDirSectorList88:
;-753 /*		putch(10);

;-754 		cputs("Sektor = "); 

;-755 		printlong(startSector);

;-756 		cputs(", numsectors = "); 

;-757 		printunsign(numsectors);

;-758 		getkey();

;-759 */

;-760 		readLogical(startSector);

 push dword [bp+4]
 call readLogical
 add  sp, 4
;-761 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-762 		EndDiskBuf= p + bs_sect_size;		

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-763 		

;-764 		do {

.fatDirSectorList89:
;-765 			memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-766 			memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-767 			filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-768 			

;-769 			isHide=0;//show in listing

 mov ax, 0
 mov [bp-6], al
;-770 			if (*p ==    0) {//only empty entries following

 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorList90
;-771 				isHide++;

 inc  byte[bp-6]
;-772 				numsectors=1;//finish searching

 mov ax, 1
 mov [bp+8], eax
;-773 				p = EndDiskBuf;

 mov ax, [bp-4]
 mov [bp-2], ax
;-774 				}

;-775 			if (*p == 0xE5) isHide++;//deleted, free entry

.fatDirSectorList90:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 229
 jne .fatDirSectorList91
 inc  byte[bp-6]
;-776 			if (*p <=   31) isHide++;//part of LFN

.fatDirSectorList91:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 31
 jg  .fatDirSectorList92
 inc  byte[bp-6]
;-777 			if (dir_Attrib ==    15) isHide++;//LFN start

.fatDirSectorList92:
 mov al, [dir_Attrib]
 cmp al, 15
 jne .fatDirSectorList93
 inc  byte[bp-6]
;-778 					

;-779 			if (isHide == 0) printDirEntry();

.fatDirSectorList93:
 mov al, [bp-6]
 cmp al, 0
 jne .fatDirSectorList94
 call printDirEntry
;-780 			p+=32;//get next entry

.fatDirSectorList94:
 add  word[bp-2], 32
;-781 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorList95
 jmp .fatDirSectorList89
.fatDirSectorList95:
;-782 		startSector = startSector + 1;//long, do NOT use ++ or +=1

 mov eax, [bp+4]
 add eax, 1
 mov [bp+4], eax
;-783 		numsectors--;

 dec  dword[bp+8]
;-784 //mdump(DiskBuf, 512);

;-785 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorList96
 jmp .fatDirSectorList88
.fatDirSectorList96:
;-786 	fatfile_cluster=0;//not found but not end

 mov ax, 0
 mov word [fatfile_cluster], ax
;-787 }

;-788 

;-789 // 2.

;-790 int fatDirSectorSearch(unsigned long startSector, unsigned long numsectors) {

 LEAVE
 ret
ENDP

fatDirSectorSearch: PROC
;-791     //search for file name. IN:searchstr

;-792     char *p;

;-793 	unsigned int EndDiskBuf;

;-794 	fat_notfound=0;	

;Function : fatDirSectorSearch, Number local Var: 4
; # type sign width local variables
;99 var unsg long startSector = bp+4
;100 var unsg long numsectors = bp+8
;101 ptr sign byte p = bp-2
;102 var unsg word EndDiskBuf = bp-4;
 ENTER  4,0
 mov ax, 0
 mov byte [fat_notfound], al
;-795 	do {

.fatDirSectorSearch97:
;-796 		readLogical(startSector);

 push dword [bp+4]
 call readLogical
 add  sp, 4
;-797 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-798 		EndDiskBuf= p + bs_sect_size;

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-799 		do {

.fatDirSectorSearch98:
;-800 			if (memcmp(p, searchstr, 11) == 0) {//found file name

 push 11
 lea  ax, [searchstr]
 push ax
 push word [bp-2]
 call memcmp
 add  sp, 6
 cmp ax, 0
 jne .fatDirSectorSearch99
;-801 				memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-802 				memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-803 				filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-804 				fatfile_cluster   = dir_FirstCluster;

 mov ax, [dir_FirstCluster]
 mov word [fatfile_cluster], ax
;-805 				fatfile_fileSize  = dir_FileSize;

 mov eax, [dir_FileSize]
 mov dword [fatfile_fileSize], eax
;-806 //				fatfile_Attr      = dir_Attrib;

;-807 //				fatfile_LastModTime= dir_LastModTime;

;-808 //				fatfile_LastModDate= dir_LastModDate;

;-809 				printDirEntry();

 call printDirEntry
;-810 			}

;-811 			if (*p == 0) {//only empty entries following

.fatDirSectorSearch99:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorSearch100
;-812 					fat_notfound=1;

 mov ax, 1
 mov byte [fat_notfound], al
;-813 					return;

 jmp .retnfatDirSectorSearch
;-814 				}

;-815 			p+=32;//get next entry

.fatDirSectorSearch100:
 add  word[bp-2], 32
;-816 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorSearch101
 jmp .fatDirSectorSearch98
.fatDirSectorSearch101:
;-817 		startSector++;		

 inc  dword[bp+4]
;-818 		numsectors--;

 dec  dword[bp+8]
;-819 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorSearch102
 jmp .fatDirSectorSearch97
.fatDirSectorSearch102:
;-820 	fatfile_cluster=0;//not found but not end

 mov ax, 0
 mov word [fatfile_cluster], ax
;-821 }

;-822 

;-823 // 3.

;-824 int fatRootSearch() {

 .retnfatDirSectorSearch:
 LEAVE
 ret
ENDP

fatRootSearch: PROC
;-825     fatDirSectorSearch(fat_RootDirStartSectorL, fat_RootDirSectorsL);

 push dword [fat_RootDirSectorsL]
 push dword [fat_RootDirStartSectorL]
 call fatDirSectorSearch
 add  sp, 8
;-826 //	getkey();

;-827 //    fatDirSectorList(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-828 }

;-829 

;-830 // 4.

;-831 int fatClusterAnalyse(unsigned int cluster) {

 ret
ENDP

fatClusterAnalyse: PROC
;-832 //OUT: fatfile_sectorStartL, fatfile_nextCluster

;-833 	unsigned long fatSectorL;

;-834 	unsigned int offset;

;-835 	char *p;

;-836 	

;-837 	fatfile_sectorStartL = (long) cluster - 2;

;Function : fatClusterAnalyse, Number local Var: 4
; # type sign width local variables
;99 var unsg word cluster = bp+4
;100 var unsg long fatSectorL = bp-4
;101 var unsg word offset = bp-6
;102 ptr sign byte p = bp-8;
 ENTER  8,0
 xor eax, eax
 mov ax, [bp+4]
 sub ax, 2
 mov dword [fatfile_sectorStartL], eax
;-838 	fatfile_sectorStartL = fatfile_sectorStartL * clust_sizeL;

 mov eax, [fatfile_sectorStartL]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul dword [clust_sizeL]
 mov dword [fatfile_sectorStartL], eax
;-839 	fatfile_sectorStartL = fatfile_sectorStartL + fat_DataStartSectorL;

 mov eax, [fatfile_sectorStartL]
 add eax, [fat_DataStartSectorL]
 mov dword [fatfile_sectorStartL], eax
;-840 	

;-841 	fatSectorL = (long) cluster + cluster;

 xor eax, eax
 mov ax, [bp+4]
 add ax, [bp+4]
 mov [bp-4], eax
;-842 	fatSectorL = fatSectorL / sector_sizeL;		

 mov eax, [bp-4]
 xor edx, edx
 div dword [sector_sizeL]
 mov [bp-4], eax
;-843 	fatSectorL = fatSectorL + fat_FatStartSectorL; 

 mov eax, [bp-4]
 add eax, [fat_FatStartSectorL]
 mov [bp-4], eax
;-844 

;-845 	readLogical(fatSectorL);

 push dword [bp-4]
 call readLogical
 add  sp, 4
;-846 	

;-847 	offset = cluster + cluster;

 mov ax, [bp+4]
 add ax, [bp+4]
 mov [bp-6], ax
;-848 	offset = offset % bs_sect_size;

 mov ax, [bp-6]
 xor dx, dx
 div word [bs_sect_size]
 mov ax, dx
 mov [bp-6], ax
;-849 	

;-850 	p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-8], ax
;-851 	p = p + offset;	

 mov ax, [bp-8]
 add ax, [bp-6]
 mov [bp-8], ax
;-852 	memcpy(&fatfile_nextCluster, p, 2);

 push 2
 push word [bp-8]
 lea  ax, [fatfile_nextCluster]
 push ax
 call memcpy
 add  sp, 6
;-853 }

;-854 

;-855 // 5.

;-856 int fatDirSearch() {//search a directory chain. IN:searchstr

 LEAVE
 ret
ENDP

fatDirSearch: PROC
;-857 	

;-858 	fatClusterAnalyse(fatfile_cluster);

 push word [fatfile_cluster]
 call fatClusterAnalyse
 add  sp, 2
;-859 	//OUT: fatfile_sectorStartL, fatfile_nextCluster

;-860 

;-861 	fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster); 

 push word [fatfile_nextCluster]
 push dword [fatfile_sectorStartL]
 call fatDirSectorSearch
 add  sp, 6
;-862 	while (fatfile_cluster == 0) {//not found but not end

.fatDirSearch103:
 mov ax, [fatfile_cluster]
 cmp ax, 0
 jne .fatDirSearch104
;-863 		if (fatfile_nextCluster >= 0xFFF8) {

 mov ax, [fatfile_nextCluster]
 cmp ax, 65528 ;unsigned : 0
 jb  .fatDirSearch105
;-864 			fat_notfound=1;

 mov ax, 1
 mov byte [fat_notfound], al
;-865 			return;	

 jmp .retnfatDirSearch
;-866 		}		

;-867 		fatfile_cluster=fatfile_nextCluster;

.fatDirSearch105:
 mov ax, [fatfile_nextCluster]
 mov word [fatfile_cluster], ax
;-868 		fatClusterAnalyse(fatfile_cluster);

 push word [fatfile_cluster]
 call fatClusterAnalyse
 add  sp, 2
;-869 		fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster);

 push word [fatfile_nextCluster]
 push dword [fatfile_sectorStartL]
 call fatDirSectorSearch
 add  sp, 6
;-870 	}	

;-871 }

 jmp .fatDirSearch103
.fatDirSearch104:
;-872 

;-873 int fillstr(char *s, char filler, int start, int end) {

 .retnfatDirSearch:
 ret
ENDP

fillstr: PROC
;-874 	char *c;

;-875 	c = s + start;

;Function : fillstr, Number local Var: 5
; # type sign width local variables
;99 ptr sign byte s = bp+4
;100 var sign byte filler = bp+6
;101 var sign word start = bp+8
;102 var sign word end = bp+10
;103 ptr sign byte c = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 add ax, [bp+8]
 mov [bp-2], ax
;-876 	while (start < end) {

.fillstr106:
 mov ax, [bp+8]
 cmp ax, [bp+10]
 jge .fillstr107
;-877 		*c = filler;

 mov al, [bp+6]
 mov  bx, [bp-2]
 mov  [bx], al
;-878 		c++;

 inc  word[bp-2]
;-879 		start++;

 inc  word[bp+8]
;-880 		}

;-881 	

;-882 	}

 jmp .fillstr106
.fillstr107:
;-883 int search_delimiter(char *s) {

 LEAVE
 ret
ENDP

search_delimiter: PROC
;-884 	while (*s) {

;Function : search_delimiter, Number local Var: 1
; # type sign width local variables
;99 ptr sign byte s = bp+4;
 ENTER  0,0
.search_delimiter108:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .search_delimiter109
;-885 		if (*s == '/') return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 47
 jne .search_delimiter110
 mov ax, [bp+4]
 jmp .retnsearch_delimiter
;-886 		if (*s == '\\') return s;

.search_delimiter110:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 92
 jne .search_delimiter111
 mov ax, [bp+4]
 jmp .retnsearch_delimiter
;-887 		s++;

.search_delimiter111:
 inc  word[bp+4]
;-888 	}

;-889 	return 0;

 jmp .search_delimiter108
.search_delimiter109:
 mov ax, 0
 jmp .retnsearch_delimiter
;-890 }

;-891 

;-892 int is_delimiter(char *s) {

 .retnsearch_delimiter:
 LEAVE
 ret
ENDP

is_delimiter: PROC
;-893 	if (*s == '/' ) return 1;

;Function : is_delimiter, Number local Var: 1
; # type sign width local variables
;99 ptr sign byte s = bp+4;
 ENTER  0,0
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 47
 jne .is_delimiter112
 mov ax, 1
 jmp .retnis_delimiter
;-894 	if (*s == '\\') return 1;

.is_delimiter112:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 92
 jne .is_delimiter113
 mov ax, 1
 jmp .retnis_delimiter
;-895 	if (*s ==    0) return 2;

.is_delimiter113:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .is_delimiter114
 mov ax, 2
 jmp .retnis_delimiter
;-896 	return 0;

.is_delimiter114:
 mov ax, 0
 jmp .retnis_delimiter
;-897 }

;-898 	

;-899 // 6.

;-900 int fatNextSearch() {//get next part of filename to do a search

 .retnis_delimiter:
 LEAVE
 ret
ENDP

fatNextSearch: PROC
;-901 //	IN:  upto: points to start of search in filename 

;-902 //	OUT: upto: points to search for next time

;-903 //	OUT: searchstr: part of filename in DIR-format with blanks (11bytes)

;-904 //	OUT: isfilename: 0=part of directory, 1=filename

;-905 //	OUT: fat_notfound

;-906 	char *searchstrp;

;-907 //	char *searchstartp;

;-908 	char *p; 

;-909 	int  len;

;-910 	int is_del;

;-911 	int dot;

;-912 putch(10); cputs("fatNextSearch upto1="); cputs(upto);

;Function : fatNextSearch, Number local Var: 5
; # type sign width local variables
;99 ptr sign byte searchstrp = bp-2
;100 ptr sign byte p = bp-4
;101 var sign word len = bp-6
;102 var sign word is_del = bp-8
;103 var sign word dot = bp-10;
 ENTER  10,0
 push 10
 call putch
 add  sp, 2
 push fatNextSearch_0
 call cputs
 add  sp, 2
 push word [upto]
 call cputs
 add  sp, 2
;-913 

;-914 	isfilename=0;//default is directory

 mov ax, 0
 mov byte [isfilename], al
;-915 	if (*upto == '/' ) upto++;//remove leading delimiter

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 cmp ax, 47
 jne .fatNextSearch115
 inc  word[upto]
;-916 	if (*upto == '\\') upto++;

.fatNextSearch115:
 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 cmp ax, 92
 jne .fatNextSearch116
 inc  word[upto]
;-917 	

;-918 	searchstrp   = &searchstr;//clear searchstr

.fatNextSearch116:
 mov ax, searchstr
 mov [bp-2], ax
;-919 //	searchstartp = &searchstr;

;-920 	len=0;

 mov ax, 0
 mov [bp-6], ax
;-921 	is_del=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-922 

;-923 	while (is_del == 0) {		

.fatNextSearch117:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch118
;-924 		*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-925 		searchstrp++;

 inc  word[bp-2]
;-926 		upto++;	

 inc  word[upto]
;-927 		len++;

 inc  word[bp-6]
;-928 		is_del=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-929 	}

;-930 	isfilename=0;//default directory

 jmp .fatNextSearch117
.fatNextSearch118:
 mov ax, 0
 mov byte [isfilename], al
;-931 	if (is_del == 2) isfilename=1;//last name is always a file name

 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch119
 mov ax, 1
 mov byte [isfilename], al
;-932 	

;-933 putch(10);

.fatNextSearch119:
 push 10
 call putch
 add  sp, 2
;-934 cputs("Fertig is_del="); printunsign(is_del);

 push fatNextSearch_1
 call cputs
 add  sp, 2
 push word [bp-8]
 call printunsign
 add  sp, 2
;-935 cputs(", isfilename="); printunsign(isfilename);

 push fatNextSearch_2
 call cputs
 add  sp, 2
 mov al, byte [isfilename]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-936 cputs(", upto="); printunsign(upto);

 push fatNextSearch_3
 call cputs
 add  sp, 2
 push word [upto]
 call printunsign
 add  sp, 2
;-937 cputs("="); cputs(upto);

 push fatNextSearch_4
 call cputs
 add  sp, 2
 push word [upto]
 call cputs
 add  sp, 2
;-938 cputs(", len="); printunsign(len);

 push fatNextSearch_5
 call cputs
 add  sp, 2
 push word [bp-6]
 call printunsign
 add  sp, 2
;-939 cputs(", searchstr="); cputsLen(searchstr, len);

 push fatNextSearch_6
 call cputs
 add  sp, 2
 push word [bp-6]
 lea  ax, [searchstr]
 push ax
 call cputsLen
 add  sp, 4
;-940 

;-941 	dot=memchr1(searchstr, '.', len);

 push word [bp-6]
 push 46
 lea  ax, [searchstr]
 push ax
 call memchr1
 add  sp, 6
 mov [bp-10], ax
;-942 	if (len > 11) {

 mov ax, [bp-6]
 cmp ax, 11
 jle .fatNextSearch120
;-943 		fat_notfound=1;

 mov ax, 1
 mov byte [fat_notfound], al
;-944 		return;

 jmp .retnfatNextSearch
;-945 	}

;-946 	if (isfilename == 0) {//is directory name

.fatNextSearch120:
 mov al, [isfilename]
 cmp al, 0
 jne .fatNextSearch121
;-947 		fillstr(searchstr, ' ', len, 11);		

 push 11
 push word [bp-6]
 push 32
 lea  ax, [searchstr]
 push ax
 call fillstr
 add  sp, 8
;-948 	}	

;-949 cputs(", searchstr="); cputsLen(searchstr, 11);

.fatNextSearch121:
 push fatNextSearch_7
 call cputs
 add  sp, 2
 push 11
 lea  ax, [searchstr]
 push ax
 call cputsLen
 add  sp, 4
;-950 }

;-951 

;-952 // 7.

;-953 int fatGetStartCluster() {

 .retnfatNextSearch:
 LEAVE
 ret
fatNextSearch_0 db "fatNextSearch upto1=",0
fatNextSearch_1 db "Fertig is_del=",0
fatNextSearch_2 db ", isfilename=",0
fatNextSearch_3 db ", upto=",0
fatNextSearch_4 db "=",0
fatNextSearch_5 db ", len=",0
fatNextSearch_6 db ", searchstr=",0
fatNextSearch_7 db ", searchstr=",0
ENDP

fatGetStartCluster: PROC
;-954 	if (fat_notfound) return;

 mov al, [fat_notfound]
 or  al, al
 je .fatGetStartCluster122
 jmp .retnfatGetStartCluster
;-955 	upto = &filename;

.fatGetStartCluster122:
 mov ax, filename
 mov word [upto], ax
;-956 	fatfile_cluster = 0;

 mov ax, 0
 mov word [fatfile_cluster], ax
;-957 cputs("GetStartCluster filename=");cputs(filename);

 push fatGetStartCluster_0
 call cputs
 add  sp, 2
 lea  ax, [filename]
 push ax
 call cputs
 add  sp, 2
;-958 cputs(", upto="); cputs(upto);

 push fatGetStartCluster_1
 call cputs
 add  sp, 2
 push word [upto]
 call cputs
 add  sp, 2
;-959 	fatNextSearch();

 call fatNextSearch
;-960 

;-961 }

;-962 

;-963 // 8.

;-964 int fatOpenFile() {//set handle for root or subdir

 .retnfatGetStartCluster:
 ret
fatGetStartCluster_0 db "GetStartCluster filename=",0
fatGetStartCluster_1 db ", upto=",0
ENDP

fatOpenFile: PROC
;-965 	unsigned long bytes_per_cluster;

;-966 	fat_notfound=0;

;Function : fatOpenFile, Number local Var: 1
; # type sign width local variables
;99 var unsg long bytes_per_cluster = bp-4;
 ENTER  4,0
 mov ax, 0
 mov byte [fat_notfound], al
;-967 cputs("fatOpenfile ");	

 push fatOpenFile_0
 call cputs
 add  sp, 2
;-968 	if (filename[0] == 0) {//empty filename

 mov al, [filename]
 cmp al, 0
 jne .fatOpenFile123
;-969 		fatfile_root = 1;

 mov ax, 1
 mov word [fatfile_root], ax
;-970 		fatfile_nextCluster = 0xFFFF;

 mov ax, 65535
 mov word [fatfile_nextCluster], ax
;-971 		fatfile_sectorCount = fat_RootDirSectorsL;

 mov eax, [fat_RootDirSectorsL]
 mov word [fatfile_sectorCount], ax
;-972 		fatfile_sectorStartL = fat_RootDirStartSectorL;

 mov eax, [fat_RootDirStartSectorL]
 mov dword [fatfile_sectorStartL], eax
;-973 		fatfile_lastBytes   = 0;

 mov ax, 0
 mov word [fatfile_lastBytes], ax
;-974 		fatfile_lastSectors = fat_RootDirSectorsL;

 mov eax, [fat_RootDirSectorsL]
 mov word [fatfile_lastSectors], ax
;-975 		fatfile_cluster     = 0;

 mov ax, 0
 mov word [fatfile_cluster], ax
;-976 		fatfile_dir         = 1;

 mov ax, 1
 mov word [fatfile_dir], ax
;-977 

;-978 	} else {//search in subdir

 jmp .fatOpenFile124
.fatOpenFile123:
;-979 		fatfile_root = 0;

 mov ax, 0
 mov word [fatfile_root], ax
;-980 		fatGetStartCluster();

 call fatGetStartCluster
;-981 		if (fat_notfound) return 1;

 mov al, [fat_notfound]
 or  al, al
 je .fatOpenFile125
 mov ax, 1
 jmp .retnfatOpenFile
;-982 		bytes_per_cluster   = (long) bs_clust_size * bs_sect_size;

.fatOpenFile125:
 xor eax, eax
 mov al, [bs_clust_size]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_sect_size]
 mov [bp-4], eax
;-983 		fatfile_lastBytes   = fatfile_fileSize % bytes_per_cluster;

 mov eax, [fatfile_fileSize]
 xor edx, edx
 div dword [bp-4]
 mov eax, edx
 mov word [fatfile_lastBytes], ax
;-984 		fatfile_lastSectors = fatfile_lastBytes / bs_sect_size;

 mov ax, [fatfile_lastBytes]
 xor dx, dx
 div word [bs_sect_size]
 mov word [fatfile_lastSectors], ax
;-985 		fatfile_lastBytes   = fatfile_lastBytes % bs_sect_size;

 mov ax, [fatfile_lastBytes]
 xor dx, dx
 div word [bs_sect_size]
 mov ax, dx
 mov word [fatfile_lastBytes], ax
;-986 		if (fatfile_fileSize == 0) fatfile_dir = 1;

 mov eax, [fatfile_fileSize]
 cmp eax, 0
 jne .fatOpenFile126
 mov ax, 1
 mov word [fatfile_dir], ax
;-987 		else                       fatfile_dir = 0;

 jmp .fatOpenFile127
.fatOpenFile126:
 mov ax, 0
 mov word [fatfile_dir], ax
;-988 

;-989 //		fatClusterAnalyse();

;-990 		fatfile_sectorCount = (int) bs_clust_size;

.fatOpenFile127:
 xor ax, ax
 mov al, [bs_clust_size]
 mov word [fatfile_sectorCount], ax
;-991 	}

;-992 	fatfile_currentCluster = fatfile_cluster;

.fatOpenFile124:
 mov ax, [fatfile_cluster]
 mov word [fatfile_currentCluster], ax
;-993 	fatfile_sectorUpto = 0;

 mov ax, 0
 mov word [fatfile_sectorUpto], ax
;-994 	fatfile_byteUpto   = 0;

 mov ax, 0
 mov word [fatfile_byteUpto], ax
;-995 	if (fat_notfound) return 1;

 mov al, [fat_notfound]
 or  al, al
 je .fatOpenFile128
 mov ax, 1
 jmp .retnfatOpenFile
;-996 	return 0;

.fatOpenFile128:
 mov ax, 0
 jmp .retnfatOpenFile
;-997 }

;-998 

;-999 // 9.

;-1000 int fileOpen() {//remove drive letter and insert in drive

 .retnfatOpenFile:
 LEAVE
 ret
fatOpenFile_0 db "fatOpenfile ",0
ENDP

fileOpen: PROC
;-1001 	int rc;

;-1002 	toupper(filename);

;Function : fileOpen, Number local Var: 1
; # type sign width local variables
;99 var sign word rc = bp-2;
 ENTER  2,0
 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-1003 cputs("fileOpen ");

 push fileOpen_0
 call cputs
 add  sp, 2
;-1004 	rc=fatOpenFile();

 call fatOpenFile
 mov [bp-2], ax
;-1005 	if (rc) return 0;//error

 mov ax, [bp-2]
 or  al, al
 je .fileOpen129
 mov ax, 0
 jmp .retnfileOpen
;-1006 //	else return fhandle;

;-1007 }

.fileOpen129:
;-1008 

;-1009 //------------------------------- Init,  main ---------------

;-1010 int Init() {

 .retnfileOpen:
 LEAVE
 ret
fileOpen_0 db "fileOpen ",0
ENDP

Init: PROC
;-1011 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-1012 cputs(" Init ");

 push Init_0
 call cputs
 add  sp, 2
;-1013 

;-1014 	if (Params()) cputs("** NO DRIVE PARAMS FOUND **");//no hard disk

 call Params
 or  al, al
 je .Init130
 push Init_1
 call cputs
 add  sp, 2
;-1015 	FATtype=readMBR();//0=error,1=FAT12,6=FAT16,11=FAT32

.Init130:
 call readMBR
 mov word [FATtype], ax
;-1016 	if (FATtype == 0) {

 mov ax, [FATtype]
 cmp ax, 0
 jne .Init131
;-1017 		cputs(" no active FAT partition found. ");

 push Init_2
 call cputs
 add  sp, 2
;-1018 		return 1;

 mov ax, 1
 jmp .retnInit
;-1019 		}

;-1020 	if(getBootSector()==0) 	return 1;

.Init131:
 call getBootSector
 cmp ax, 0
 jne .Init132
 mov ax, 1
 jmp .retnInit
;-1021 	if (FATInit())			return 1;

.Init132:
 call FATInit
 or  al, al
 je .Init133
 mov ax, 1
 jmp .retnInit
;-1022 	if(trueFATtype != 16) 	return 1;

.Init133:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init134
 mov ax, 1
 jmp .retnInit
;-1023 	Int13hExt();

.Init134:
 call Int13hExt
;-1024 	return 0;

 mov ax, 0
 jmp .retnInit
;-1025 }

;-1026 

;-1027 int main() {

 .retnInit:
 ret
Init_0 db " Init ",0
Init_1 db "** NO DRIVE PARAMS FOUND **",0
Init_2 db " no active FAT partition found. ",0
ENDP

main: PROC
;-1028 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-1029 cputs("main ");

 push main_0
 call cputs
 add  sp, 2
;-1030 	if (Init() != 0) return 1;

 call Init
 cmp al, 0
 je  .main135
 mov ax, 1
 jmp .retnmain
;-1031 	strcpy(&filename, "/binslash/dos.com");

.main135:
 push main_1
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1032 /*	fileOpen();	

;-1033 	strcpy(&filename, "tet/abc.com");

;-1034 	fileOpen();	

;-1035 */

;-1036 }

 .retnmain:
 ret
main_0 db "main ",0
main_1 db "/binslash/dos.com",0
ENDP
