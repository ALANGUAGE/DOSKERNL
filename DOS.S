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

;-8 #define debug 1

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
;-348     getkey();

 jmp .mdump41
.mdump42:
 call getkey
;-349     putch(10);

 push 10
 call putch
 add  sp, 2
;-350 

;-351 }

;-352 

;-353 //--------------------------------  disk IO  -------------------

;-354 

;-355 int DiskSectorReadWrite(char rw, char drive, char head, int cyl,

 LEAVE
 ret
ENDP

DiskSectorReadWrite: PROC
;-356 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-357 	BIOS_ERR=0;

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
;-358 	dl=drive;

 mov  dl, [bp+6]
;-359 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-360 	es=BufSeg;

 mov  es, [bp+16]
;-361 	bx=BufOfs;

 mov  bx, [bp+18]
;-362 	cx=cyl;

 mov  cx, [bp+10]
;-363 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-364 	cx >> 2;//in 2 high bits of cl

 shr  cx, 2
;-365 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-366 	cl += sector;

 add  cl, [bp+12]
;-367 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-368 	al=count;

 mov  al, [bp+14]
;-369 	ah=rw;

 mov  ah, [bp+4]
;-370 	inth 0x13;

 int  19
;-371     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-372 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-373 }

;-374 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-375 	BIOS_ERR=0;

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;100 var sign byte drive = bp+4
;101 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-376 	dl=drive;

 mov  dl, [bp+4]
;-377 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-378 	inth 0x13;

 int  19
;-379     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-380 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-381 }

;-382 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-383 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-384 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-385 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-386 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-387 }

;-388 int Status(drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Status: PROC
;-389 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;100 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-390 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-391 	BIOS_Status=Int13hfunction(drive, 1);

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-392 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Status50
 call Int13hError
;-393 	printhex16(BIOS_Status);

.Status50:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-394 }

;-395 

;-396 int Params() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

Params: PROC
;-397 	if (debug) cputs(" DriveParams");

 mov ax, 1
 or  al, al
 je .Params51
 push Params_0
 call cputs
 add  sp, 2
;-398 	BIOS_Status=Int13hfunction(Drive, 8);

.Params51:
 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-399 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params52
;-400 		Int13hError();

 call Int13hError
;-401 		return 1;

 mov ax, 1
 jmp .retnParams
;-402 		}

;-403 	else {

 jmp .Params53
.Params52:
;-404 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-405 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-406 		// CX =       ---CH--- ---CL---

;-407 		// cylinder : 76543210 98

;-408 		// sector   :            543210

;-409 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-410 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-411 //		pa_Sectors++;//1 to 64

;-412 

;-413 		asm mov [pa_Cylinders],    cx

 mov [pa_Cylinders],    cx
;-414 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-415 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-416 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty

 add [pa_Cylinders],    ch;//byte add, low byte is empty
;-417 

;-418 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params54
;-419 			cputs(" ** no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-420 			return 1;

 mov ax, 1
 jmp .retnParams
;-421 			}

;-422 	}

.Params54:
;-423 	return 0;

.Params53:
 mov ax, 0
 jmp .retnParams
;-424 }

;-425 

;-426 

;-427 int getPartitionData() {

 .retnParams:
 ret
Params_0 db " DriveParams",0
Params_1 db " ** no hard disk found",0
ENDP

getPartitionData: PROC
;-428 	unsigned int j; char c; char *p;

;-429 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;100 var unsg word j = bp-2
;101 var sign byte c = bp-4
;102 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [pt_PartNo]
 shl ax, 4
 mov [bp-2], ax
;-430 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-431 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-432 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-433 	pt_StartCylinder=(int)pt_StartSector;

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-434 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-435 //	pt_StartSector++;//Sector start with 1 todo

;-436 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-437 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-438 	j++;

 inc  word[bp-2]
;-439 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-440 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-441 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB

;-442 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-443 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-444 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-445 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-446 //	pt_EndSector++;//Sector start with 1 todo

;-447 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-448 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-449 	j++;

 inc  word[bp-2]
;-450 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-451 	j++;

 inc  word[bp-2]
;-452 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-453 	memcpy(&pt_HiddenSector, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-454 }

;-455 

;-456 int checkBootSign() {

 LEAVE
 ret
ENDP

checkBootSign: PROC
;-457 	int i;

;-458 	i=510;

;Function : checkBootSign, Number local Var: 1
; # type sign width local variables
;100 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-459 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign55
;-460 		i++;

 inc  word[bp-2]
;-461 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign56
 mov ax, 1
 jmp .retncheckBootSign
;-462 	}

.checkBootSign56:
;-463 	cputs("  **Magic number NOT found.");

.checkBootSign55:
 push checkBootSign_0
 call cputs
 add  sp, 2
;-464 	return 0;

 mov ax, 0
 jmp .retncheckBootSign
;-465 }

;-466 

;-467 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db "  **Magic number NOT found.",0
ENDP

readMBR: PROC
;-468 	int isFAT;

;-469 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;100 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-470 	pt_PartNo=0;

 mov ax, 0
 mov word [pt_PartNo], ax
;-471 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-472 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR57
;-473 		Int13hError();

 call Int13hError
;-474 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-475 		}

;-476 	else {

 jmp .readMBR58
.readMBR57:
;-477 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .readMBR59
 mov ax, 0
 jmp .retnreadMBR
;-478 		do {

.readMBR59:
.readMBR60:
;-479 			getPartitionData();

 call getPartitionData
;-480 

;-481 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR61
;-482 				if (debug) cputs(" Boot part. found");

 mov ax, 1
 or  al, al
 je .readMBR62
 push readMBR_0
 call cputs
 add  sp, 2
;-483 				if (pt_FileSystem == 1) {

.readMBR62:
 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR63
;-484 					cputs(", FAT12 part. <32MB");

 push readMBR_1
 call cputs
 add  sp, 2
;-485 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-486 					}

;-487 				if (pt_FileSystem == 4) {

.readMBR63:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR64
;-488 					cputs(", small FAT16 part.<32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-489 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-490 					}

;-491 				if (pt_FileSystem == 6) {

.readMBR64:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR65
;-492 					if (debug) cputs(", large FAT16 part.");

 mov ax, 1
 or  al, al
 je .readMBR66
 push readMBR_3
 call cputs
 add  sp, 2
;-493 					isFAT=6;

.readMBR66:
 mov ax, 6
 mov [bp-2], ax
;-494 					}

;-495 				pt_PartNo=99;//end of loop

.readMBR65:
 mov ax, 99
 mov word [pt_PartNo], ax
;-496 			}

;-497 			pt_PartNo ++;

.readMBR61:
 inc  word[pt_PartNo]
;-498 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR67
 jmp .readMBR60
.readMBR67:
;-499 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-500 	}

;-501 }

.readMBR58:
;-502 

;-503 int getBootSector() {

 .retnreadMBR:
 LEAVE
 ret
readMBR_0 db " Boot part. found",0
readMBR_1 db ", FAT12 part. <32MB",0
readMBR_2 db ", small FAT16 part.<32MB",0
readMBR_3 db ", large FAT16 part.",0
ENDP

getBootSector: PROC
;-504 	int i;

;-505 	if (debug) cputs(" Boot sector:");

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;100 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 1
 or  al, al
 je .getBootSector68
 push getBootSector_0
 call cputs
 add  sp, 2
;-506   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

.getBootSector68:
;-507   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-508 	if (debug) printhex16(BIOS_Status);

 mov ax, 1
 or  al, al
 je .getBootSector69
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-509 	if (BIOS_ERR) {

.getBootSector69:
 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector70
;-510 		Int13hError();

 call Int13hError
;-511 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-512 		}

;-513 	else {

 jmp .getBootSector71
.getBootSector70:
;-514 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .getBootSector72
 mov ax, 0
 jmp .retngetBootSector
;-515 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector72:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-516 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector73
 push getBootSector_1
 call cputs
 add  sp, 2
;-517 		i=2;

.getBootSector73:
 mov ax, 2
 mov [bp-2], ax
;-518 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector74
 push getBootSector_2
 call cputs
 add  sp, 2
;-519 	}

.getBootSector74:
;-520 	return 1;

.getBootSector71:
 mov ax, 1
 jmp .retngetBootSector
;-521 }

;-522 

;-523 int FATInit() {

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Boot sector:",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-524 	unsigned long templong;//converting word to dword

;-525 

;-526 	clust_sizeL = (long) bs_clust_size;

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;100 var unsg long templong = bp-4;
 ENTER  4,0
 xor eax, eax
 mov al, [bs_clust_size]
 mov dword [clust_sizeL], eax
;-527 	sector_sizeL= (long) bs_sect_size;

 xor eax, eax
 mov ax, [bs_sect_size]
 mov dword [sector_sizeL], eax
;-528 

;-529 	fat_FatStartSector = bs_res_sects;

 mov ax, [bs_res_sects]
 mov word [fat_FatStartSector], ax
;-530 	fat_FatStartSectorL= (long) fat_FatStartSector; 

 xor eax, eax
 mov ax, [fat_FatStartSector]
 mov dword [fat_FatStartSectorL], eax
;-531 	fat_FatSectors = bs_fat_size;

 mov ax, [bs_fat_size]
 mov word [fat_FatSectors], ax
;-532 	if (bs_num_fats == 2) fat_FatSectors=fat_FatSectors+fat_FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .FATInit75
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-533 

;-534 	fat_RootDirStartSectorL = (long)fat_FatStartSector + fat_FatSectors;

.FATInit75:
 xor eax, eax
 mov ax, [fat_FatStartSector]
 add ax, [fat_FatSectors]
 mov dword [fat_RootDirStartSectorL], eax
;-535 	

;-536 	fat_RootDirSectorsL = (long) bs_root_entr >> 4;//  ./. 16

 xor eax, eax
 mov ax, [bs_root_entr]
 shr ax, 4
 mov dword [fat_RootDirSectorsL], eax
;-537 		

;-538 	fat_DataStartSectorL = fat_RootDirStartSectorL + fat_RootDirSectorsL;

 mov eax, [fat_RootDirStartSectorL]
 add eax, [fat_RootDirSectorsL]
 mov dword [fat_DataStartSectorL], eax
;-539 

;-540 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .FATInit76
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-541 	DataSectors32=bs_tot_sect32 - fat_DataStartSectorL;

.FATInit76:
 mov eax, [bs_tot_sect32]
 sub eax, [fat_DataStartSectorL]
 mov dword [DataSectors32], eax
;-542 

;-543 	CountofClusters=DataSectors32 / clust_sizeL;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [clust_sizeL]
 mov dword [CountofClusters], eax
;-544 

;-545 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-546 	fat_num_tracks = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [fat_num_tracks], eax
;-547 

;-548 	templong = (long) bs_num_heads;

 xor eax, eax
 mov ax, [bs_num_heads]
 mov [bp-4], eax
;-549 	fat_num_cylinders = fat_num_tracks / templong;//w=d/w

 mov eax, [fat_num_tracks]
 xor edx, edx
 div dword [bp-4]
 mov word [fat_num_cylinders], ax
;-550 

;-551 	Sectors_per_cylinder = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinder], eax
;-552 	asm mov [Sectors_per_cylinder + 2], dx;store high word

 mov [Sectors_per_cylinder + 2], dx;store high word
;-553 

;-554 	templong = (long) 65525;

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-555 	if (CountofClusters > templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jle .FATInit77
;-556 		trueFATtype=32;

 mov ax, 32
 mov byte [trueFATtype], al
;-557 		cputs(" FAT32 NOT supported");

 push FATInit_0
 call cputs
 add  sp, 2
;-558 		return 1;

 mov ax, 1
 jmp .retnFATInit
;-559 		}

;-560 	templong= (long) 4086;

.FATInit77:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-561 	if (CountofClusters < templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jge .FATInit78
;-562 		trueFATtype=12;

 mov ax, 12
 mov byte [trueFATtype], al
;-563 		cputs(" FAT12");

 push FATInit_1
 call cputs
 add  sp, 2
;-564 		return 0;

 mov ax, 0
 jmp .retnFATInit
;-565 		}

;-566 	trueFATtype=16;

.FATInit78:
 mov ax, 16
 mov byte [trueFATtype], al
;-567 	if (debug) cputs(" FAT16");

 mov ax, 1
 or  al, al
 je .FATInit79
 push FATInit_2
 call cputs
 add  sp, 2
;-568 	return 0;

.FATInit79:
 mov ax, 0
 jmp .retnFATInit
;-569 }

;-570 

;-571 int Int13hExt() {

 .retnFATInit:
 LEAVE
 ret
FATInit_0 db " FAT32 NOT supported",0
FATInit_1 db " FAT12",0
FATInit_2 db " FAT16",0
ENDP

Int13hExt: PROC
;-572 	bx=0x55AA;

 mov  bx, 21930
;-573 	BIOS_Status=Int13hfunction(Drive, 0x41);

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-574 	asm mov [vAX], ax;

 mov [vAX], ax;
;-575 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-576 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported
;-577 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt80
;-578 		cputs(" Ext. NOT present");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-579 		Int13hError();

 call Int13hError
;-580 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-581 		}

;-582 	else {

 jmp .Int13hExt81
.Int13hExt80:
;-583 	if (debug) cputs(",Int13h Ext.");

 mov ax, 1
 or  al, al
 je .Int13hExt82
 push Int13hExt_1
 call cputs
 add  sp, 2
;-584 		}

.Int13hExt82:
;-585 	return 0;

.Int13hExt81:
 mov ax, 0
 jmp .retnInt13hExt
;-586 }

;-587 

;-588 int PrintDriveParameter() {

 .retnInt13hExt:
 ret
Int13hExt_0 db " Ext. NOT present",0
Int13hExt_1 db ",Int13h Ext.",0
ENDP

PrintDriveParameter: PROC
;-589 	unsigned long Lo;

;-590 // from Params

;-591 	putch(10);

;Function : PrintDriveParameter, Number local Var: 1
; # type sign width local variables
;100 var unsg long Lo = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-592 	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);

 push PrintDriveParameter_0
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-593 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-594 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-595 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-596 	putch('.');

 push 46
 call putch
 add  sp, 2
;-597 //from getPartitionData

;-598 	putch(10);

 push 10
 call putch
 add  sp, 2
;-599 	cputs("getPartitionData:No=");printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-600 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-601 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-602 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-603 	cputs("/");				printunsign(pt_StartSector);

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-604 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-605 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-606 	cputs("/");				printunsign(pt_EndSector);

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-607 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-608 	cputs(",Start=");		printlong(pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 push dword [pt_HiddenSector]
 call printlong
 add  sp, 4
;-609 	cputs(",Len=");			printlong(pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 push dword [pt_PartLen]
 call printlong
 add  sp, 4
;-610 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-611 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-612 	printlong(Lo);

 push dword [bp-4]
 call printlong
 add  sp, 4
;-613 	cputs(" MByte.");

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-614 //from getBootSector

;-615 	putch(10);

 push 10
 call putch
 add  sp, 2
;-616 	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-617 	putch(10);

 push 10
 call putch
 add  sp, 2
;-618 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-619 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-620 	putch(10);

 push 10
 call putch
 add  sp, 2
;-621 	cputs("Reserved sectors=");printunsign(bs_res_sects);

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-622 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-623 	putch(10);

 push 10
 call putch
 add  sp, 2
;-624 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-625 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-626 	putch(10);

 push 10
 call putch
 add  sp, 2
;-627 	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-628 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-629 	putch(10);

 push 10
 call putch
 add  sp, 2
;-630 	cputs("sectors per track=");printunsign(bs_sectors_per_track);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_sectors_per_track]
 call printunsign
 add  sp, 2
;-631 	cputs(".number of heads=");printunsign(bs_num_heads);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_heads]
 call printunsign
 add  sp, 2
;-632 	putch(10);

 push 10
 call putch
 add  sp, 2
;-633 	cputs("hidden sectors(long)=");printlong(bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 push dword [bs_hid_sects]
 call printlong
 add  sp, 4
;-634 	cputs(".sectors(long)=");printlong(bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 push dword [bs_tot_sect32]
 call printlong
 add  sp, 4
;-635 	putch(10);

 push 10
 call putch
 add  sp, 2
;-636 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-637 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-638 	putch(10);

 push 10
 call putch
 add  sp, 2
;-639 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-640 	cputs(".Volume serial(long)=");printlong(bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 push dword [bs_serial_num]
 call printlong
 add  sp, 4
;-641 	putch(10);

 push 10
 call putch
 add  sp, 2
;-642 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-643 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-644 //from FATInit

;-645 	putch(10);

 push 10
 call putch
 add  sp, 2
;-646 	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [fat_FatStartSector]
 call printunsign
 add  sp, 2
;-647 	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [fat_FatSectors]
 call printunsign
 add  sp, 2
;-648 	putch(10);

 push 10
 call putch
 add  sp, 2
;-649 	cputs("fat_RootDirStartSectorL="); printlong(fat_RootDirStartSectorL);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push dword [fat_RootDirStartSectorL]
 call printlong
 add  sp, 4
;-650 	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectorsL);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push dword [fat_RootDirSectorsL]
 call printunsign
 add  sp, 4
;-651 	putch(10);

 push 10
 call putch
 add  sp, 2
;-652 	cputs("fat_DataStartSectorL=");	printunsign(fat_DataStartSectorL);

 push PrintDriveParameter_38
 call cputs
 add  sp, 2
 push dword [fat_DataStartSectorL]
 call printunsign
 add  sp, 4
;-653 	cputs(", DataSectors32=");	printlong(DataSectors32);

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 push dword [DataSectors32]
 call printlong
 add  sp, 4
;-654 	putch(10);

 push 10
 call putch
 add  sp, 2
;-655 	cputs("CountofClusters=");	printlong(CountofClusters);

 push PrintDriveParameter_40
 call cputs
 add  sp, 2
 push dword [CountofClusters]
 call printlong
 add  sp, 4
;-656 	cputs(", Sectors_per_cylinder="); printlong(Sectors_per_cylinder);

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 push dword [Sectors_per_cylinder]
 call printlong
 add  sp, 4
;-657 	putch(10);

 push 10
 call putch
 add  sp, 2
;-658 	cputs("fat_num_tracks=");	printlong(fat_num_tracks);

 push PrintDriveParameter_42
 call cputs
 add  sp, 2
 push dword [fat_num_tracks]
 call printlong
 add  sp, 4
;-659 	cputs(", fat_num_cylinders="); printunsign(fat_num_cylinders);

 push PrintDriveParameter_43
 call cputs
 add  sp, 2
 push word [fat_num_cylinders]
 call printunsign
 add  sp, 2
;-660 	getkey();

 call getkey
;-661 }

;-662 

;-663 //--------------------------------  file IO  -------------------

;-664 int error2(char *s) {

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
;-665 	putch(10);

;Function : error2, Number local Var: 1
; # type sign width local variables
;100 ptr sign byte s = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-666 	cputs("*** ERROR *** ");

 push error2_0
 call cputs
 add  sp, 2
;-667 	cputs(s);

 push word [bp+4]
 call cputs
 add  sp, 2
;-668 	DOS_ERR++;

 inc  byte[DOS_ERR]
;-669 }

;-670 // 1.

;-671 int readLogical(unsigned long SectorL) {//OUT:1 sector in DiskBuf

 LEAVE
 ret
error2_0 db "*** ERROR *** ",0
ENDP

readLogical: PROC
;-672 	unsigned int track; unsigned int head; unsigned int sect;

;-673 	SectorL = SectorL + bs_hid_sects;//d=d+d

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
;-674 	track = SectorL / Sectors_per_cylinder;  //w=d/d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinder]
 mov [bp-2], ax
;-675 	head  = SectorL % Sectors_per_cylinder;  //w=d%d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinder]
 mov eax, edx
 mov [bp-4], ax
;-676 	sect  = head            % bs_sectors_per_track;  //w=w%w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov ax, dx
 mov [bp-6], ax
;-677 	sect++;

 inc  word[bp-6]
;-678 	head  = head            / bs_sectors_per_track;	 //w=w/w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov [bp-4], ax
;-679 

;-680 	DiskSectorReadWrite(2, bs_drive_num, head, track/* =cyl */,

;-681 		sect, 1, DiskBufSeg , DiskBuf);

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
;-682 }

;-683 // 2.a

;-684 int printDirEntry(int EntryNr) {

 LEAVE
 ret
ENDP

printDirEntry: PROC
;-685     unsigned int j;

;-686 	putch(10);

;Function : printDirEntry, Number local Var: 2
; # type sign width local variables
;100 var sign word EntryNr = bp+4
;101 var unsg word j = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-687 	printunsign(EntryNr);

 push word [bp+4]
 call printunsign
 add  sp, 2
;-688 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-689 	cputs(filename);

 lea  ax, [filename]
 push ax
 call cputs
 add  sp, 2
;-690 	cputs(" ATTR:");

 push printDirEntry_0
 call cputs
 add  sp, 2
;-691 	printhex8(dir_Attrib);	

 mov al, byte [dir_Attrib]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-692 	if (dir_Attrib &  1) cputs(" r/o");

 mov al, [dir_Attrib]
 and al, 1
 or  al, al
 je .printDirEntry83
 push printDirEntry_1
 call cputs
 add  sp, 2
;-693 	if (dir_Attrib &  2) cputs(" hid");

.printDirEntry83:
 mov al, [dir_Attrib]
 and al, 2
 or  al, al
 je .printDirEntry84
 push printDirEntry_2
 call cputs
 add  sp, 2
;-694 	if (dir_Attrib &  4) cputs(" sys");

.printDirEntry84:
 mov al, [dir_Attrib]
 and al, 4
 or  al, al
 je .printDirEntry85
 push printDirEntry_3
 call cputs
 add  sp, 2
;-695 	if (dir_Attrib &  8) cputs(" vol");		

.printDirEntry85:
 mov al, [dir_Attrib]
 and al, 8
 or  al, al
 je .printDirEntry86
 push printDirEntry_4
 call cputs
 add  sp, 2
;-696 	if (dir_Attrib & 16) cputs(" dir");

.printDirEntry86:
 mov al, [dir_Attrib]
 and al, 16
 or  al, al
 je .printDirEntry87
 push printDirEntry_5
 call cputs
 add  sp, 2
;-697 	if (dir_Attrib & 32) cputs(" arc");

.printDirEntry87:
 mov al, [dir_Attrib]
 and al, 32
 or  al, al
 je .printDirEntry88
 push printDirEntry_6
 call cputs
 add  sp, 2
;-698 	if (dir_Attrib == 0) cputs("    ");

.printDirEntry88:
 mov al, [dir_Attrib]
 cmp al, 0
 jne .printDirEntry89
 push printDirEntry_7
 call cputs
 add  sp, 2
;-699 	

;-700 	putch(' ');

.printDirEntry89:
 push 32
 call putch
 add  sp, 2
;-701 	j=dir_LastModDate & 31;//day

 mov ax, [dir_LastModDate]
 and ax, 31
 mov [bp-2], ax
;-702 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry90
 push 32
 call putch
 add  sp, 2
;-703 	printunsign(j);

.printDirEntry90:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-704 	putch('.');

 push 46
 call putch
 add  sp, 2
;-705 

;-706 	j=dir_LastModDate >> 5;//month

 mov ax, [dir_LastModDate]
 shr ax, 5
 mov [bp-2], ax
;-707 	j&=  15;

 and  word[bp-2], 15
;-708 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry91
 push 48
 call putch
 add  sp, 2
;-709 	printunsign(j);

.printDirEntry91:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-710 	putch('.');

 push 46
 call putch
 add  sp, 2
;-711 

;-712 	j=dir_LastModDate >> 9;//year

 mov ax, [dir_LastModDate]
 shr ax, 9
 mov [bp-2], ax
;-713 	j+= 1980;

 add  word[bp-2], 1980
;-714 	printunsign(j);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-715 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-716 	//putch(' ');

;-717 

;-718 	j=dir_LastModTime  >>11;//hour

 mov ax, [dir_LastModTime]
 shr ax, 11
 mov [bp-2], ax
;-719 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry92
 push 32
 call putch
 add  sp, 2
;-720 	printunsign(j);

.printDirEntry92:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-721 	putch(':');

 push 58
 call putch
 add  sp, 2
;-722 

;-723 	j=dir_LastModTime  >> 5;//minute

 mov ax, [dir_LastModTime]
 shr ax, 5
 mov [bp-2], ax
;-724 	j&=  63;

 and  word[bp-2], 63
;-725 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry93
 push 48
 call putch
 add  sp, 2
;-726 	printunsign(j);

.printDirEntry93:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-727 	putch(':');

 push 58
 call putch
 add  sp, 2
;-728 

;-729 	j=dir_LastModTime & 31;// 2 seconds

 mov ax, [dir_LastModTime]
 and ax, 31
 mov [bp-2], ax
;-730 	j=j+j;

 mov ax, [bp-2]
 add ax, [bp-2]
 mov [bp-2], ax
;-731 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry94
 push 48
 call putch
 add  sp, 2
;-732 	printunsign(j);

.printDirEntry94:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-733 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-734 

;-735 	cputs(" 1.Cl:"); 

 push printDirEntry_8
 call cputs
 add  sp, 2
;-736 	printunsign(dir_FirstCluster);

 push word [dir_FirstCluster]
 call printunsign
 add  sp, 2
;-737 	cputs(" Size:");

 push printDirEntry_9
 call cputs
 add  sp, 2
;-738 	printlong(dir_FileSize);

 push dword [dir_FileSize]
 call printlong
 add  sp, 4
;-739 	

;-740 }

;-741 

;-742 // 2.b

;-743 int fatDirSectorList(unsigned long startSector, unsigned long numsectors) {

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
;-744     char *p;

;-745 	unsigned int EndDiskBuf;

;-746 	char isHide;//shows entries, NOT lfn, deleted or empty

;-747 	unsigned int EntryNr;

;-748 	EntryNr=0;

;Function : fatDirSectorList, Number local Var: 6
; # type sign width local variables
;100 var unsg long startSector = bp+4
;101 var unsg long numsectors = bp+8
;102 ptr sign byte p = bp-2
;103 var unsg word EndDiskBuf = bp-4
;104 var sign byte isHide = bp-6
;105 var unsg word EntryNr = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-8], ax
;-749 	do {

.fatDirSectorList95:
;-750 /*		putch(10);

;-751 		cputs("Sektor = "); 

;-752 		printlong(startSector);

;-753 		cputs(", numsectors = "); 

;-754 		printlong(numsectors);

;-755 		getkey();

;-756 */

;-757 		readLogical(startSector);

 push dword [bp+4]
 call readLogical
 add  sp, 4
;-758 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-759 		EndDiskBuf= p + bs_sect_size;		

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-760 		

;-761 		do {

.fatDirSectorList96:
;-762 			memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-763 			memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-764 			filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-765 			

;-766 			isHide=0;//show in listing

 mov ax, 0
 mov [bp-6], al
;-767 			if (*p ==    0) {//only empty entries following

 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorList97
;-768 				isHide++;

 inc  byte[bp-6]
;-769 				numsectors=1;//finish searching

 mov ax, 1
 mov [bp+8], eax
;-770 				p = EndDiskBuf;

 mov ax, [bp-4]
 mov [bp-2], ax
;-771 				}

;-772 			if (*p == 0xE5) isHide++;//deleted, free entry

.fatDirSectorList97:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 229
 jne .fatDirSectorList98
 inc  byte[bp-6]
;-773 			if (*p <=   31) isHide++;//part of LFN

.fatDirSectorList98:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 31
 jg  .fatDirSectorList99
 inc  byte[bp-6]
;-774 			if (dir_Attrib ==    15) isHide++;//LFN start

.fatDirSectorList99:
 mov al, [dir_Attrib]
 cmp al, 15
 jne .fatDirSectorList100
 inc  byte[bp-6]
;-775 					

;-776 			if (isHide == 0) printDirEntry(EntryNr);

.fatDirSectorList100:
 mov al, [bp-6]
 cmp al, 0
 jne .fatDirSectorList101
 push word [bp-8]
 call printDirEntry
 add  sp, 2
;-777 			p+=32;//get next entry

.fatDirSectorList101:
 add  word[bp-2], 32
;-778 			EntryNr++;

 inc  word[bp-8]
;-779 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorList102
 jmp .fatDirSectorList96
.fatDirSectorList102:
;-780 		startSector = startSector + 1;//long, do NOT use ++ or +=1

 mov eax, [bp+4]
 add eax, 1
 mov [bp+4], eax
;-781 		numsectors--;

 dec  dword[bp+8]
;-782 //mdump(DiskBuf, 512);

;-783 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorList103
 jmp .fatDirSectorList95
.fatDirSectorList103:
;-784 	fatfile_cluster=0;//not found but not end

 mov ax, 0
 mov word [fatfile_cluster], ax
;-785 }

;-786 

;-787 // 2.

;-788 int fatDirSectorSearch(unsigned long startSector, unsigned long numsectors) {

 LEAVE
 ret
ENDP

fatDirSectorSearch: PROC
;-789     //search for file name. IN:searchstr

;-790     char *p;

;-791 	unsigned int EndDiskBuf;

;-792 	fat_notfound=0;	

;Function : fatDirSectorSearch, Number local Var: 4
; # type sign width local variables
;100 var unsg long startSector = bp+4
;101 var unsg long numsectors = bp+8
;102 ptr sign byte p = bp-2
;103 var unsg word EndDiskBuf = bp-4;
 ENTER  4,0
 mov ax, 0
 mov byte [fat_notfound], al
;-793 	do {

.fatDirSectorSearch104:
;-794 		readLogical(startSector);

 push dword [bp+4]
 call readLogical
 add  sp, 4
;-795 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-796 		EndDiskBuf= p + bs_sect_size;

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-797 		do {

.fatDirSectorSearch105:
;-798 			if (memcmp(p, searchstr, 11) == 0) {//found file name

 push 11
 lea  ax, [searchstr]
 push ax
 push word [bp-2]
 call memcmp
 add  sp, 6
 cmp ax, 0
 jne .fatDirSectorSearch106
;-799 				memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-800 				memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-801 				filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-802 				fatfile_cluster   = dir_FirstCluster;

 mov ax, [dir_FirstCluster]
 mov word [fatfile_cluster], ax
;-803 				fatfile_fileSize  = dir_FileSize;

 mov eax, [dir_FileSize]
 mov dword [fatfile_fileSize], eax
;-804 			}

;-805 			if (*p == 0) {//only empty entries following

.fatDirSectorSearch106:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorSearch107
;-806 					fat_notfound=1;

 mov ax, 1
 mov byte [fat_notfound], al
;-807 					return;

 jmp .retnfatDirSectorSearch
;-808 				}

;-809 			p+=32;//get next entry

.fatDirSectorSearch107:
 add  word[bp-2], 32
;-810 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorSearch108
 jmp .fatDirSectorSearch105
.fatDirSectorSearch108:
;-811 		startSector++;		

 inc  dword[bp+4]
;-812 		numsectors--;

 dec  dword[bp+8]
;-813 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorSearch109
 jmp .fatDirSectorSearch104
.fatDirSectorSearch109:
;-814 	fatfile_cluster=0;//not found but not end

 mov ax, 0
 mov word [fatfile_cluster], ax
;-815 cputs(",NF2="); printunsign(fat_notfound);		

 push fatDirSectorSearch_0
 call cputs
 add  sp, 2
 mov al, byte [fat_notfound]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-816 	

;-817 }

;-818 

;-819 // 4.

;-820 int fatClusterAnalyse(unsigned int cluster) {

 .retnfatDirSectorSearch:
 LEAVE
 ret
fatDirSectorSearch_0 db ",NF2=",0
ENDP

fatClusterAnalyse: PROC
;-821 //OUT: fatfile_sectorStartL, fatfile_nextCluster

;-822 	unsigned long fatSectorL;

;-823 	unsigned int offset;

;-824 	char *p;

;-825 	

;-826 	fatfile_sectorStartL = (long) cluster - 2;

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
;-827 	fatfile_sectorStartL = fatfile_sectorStartL * clust_sizeL;

 mov eax, [fatfile_sectorStartL]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul dword [clust_sizeL]
 mov dword [fatfile_sectorStartL], eax
;-828 	fatfile_sectorStartL = fatfile_sectorStartL + fat_DataStartSectorL;

 mov eax, [fatfile_sectorStartL]
 add eax, [fat_DataStartSectorL]
 mov dword [fatfile_sectorStartL], eax
;-829 	

;-830 	fatSectorL = (long) cluster + cluster;

 xor eax, eax
 mov ax, [bp+4]
 add ax, [bp+4]
 mov [bp-4], eax
;-831 	fatSectorL = fatSectorL / sector_sizeL;		

 mov eax, [bp-4]
 xor edx, edx
 div dword [sector_sizeL]
 mov [bp-4], eax
;-832 	fatSectorL = fatSectorL + fat_FatStartSectorL; 

 mov eax, [bp-4]
 add eax, [fat_FatStartSectorL]
 mov [bp-4], eax
;-833 

;-834 	readLogical(fatSectorL);

 push dword [bp-4]
 call readLogical
 add  sp, 4
;-835 	

;-836 	offset = cluster + cluster;

 mov ax, [bp+4]
 add ax, [bp+4]
 mov [bp-6], ax
;-837 	offset = offset % bs_sect_size;

 mov ax, [bp-6]
 xor dx, dx
 div word [bs_sect_size]
 mov ax, dx
 mov [bp-6], ax
;-838 	

;-839 	p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-8], ax
;-840 	p = p + offset;	

 mov ax, [bp-8]
 add ax, [bp-6]
 mov [bp-8], ax
;-841 	memcpy(&fatfile_nextCluster, p, 2);

 push 2
 push word [bp-8]
 lea  ax, [fatfile_nextCluster]
 push ax
 call memcpy
 add  sp, 6
;-842 }

;-843 

;-844 // 5.

;-845 int fatDirSearch() {//search a directory chain. IN:searchstr

 LEAVE
 ret
ENDP

fatDirSearch: PROC
;-846 	

;-847 //	fatClusterAnalyse(fatfile_cluster);

;-848 	//OUT: fatfile_sectorStartL, fatfile_nextCluster

;-849 	

;-850 	

;-851 //cputs(",RDirStartSecL="); printlong(fat_RootDirStartSectorL);

;-852 //cputs(",nextClus="); printunsign(fatfile_nextCluster);		

;-853 //cputs(",RootDirsecL="); printlong(fat_RootDirSectorsL);

;-854 

;-855 //fatDirSectorList(fat_RootDirStartSectorL, fat_RootDirSectorsL); 

;-856 //getkey();

;-857 

;-858 	fatDirSectorSearch(fat_RootDirStartSectorL, fat_RootDirSectorsL); 

 push dword [fat_RootDirSectorsL]
 push dword [fat_RootDirStartSectorL]
 call fatDirSectorSearch
 add  sp, 8
;-859 

;-860 	while (fatfile_cluster == 0) {//not found but not end

.fatDirSearch110:
 mov ax, [fatfile_cluster]
 cmp ax, 0
 jne .fatDirSearch111
;-861 cputs(",NC5=");	 printhex16(fatfile_nextCluster);		

 push fatDirSearch_0
 call cputs
 add  sp, 2
 push word [fatfile_nextCluster]
 call printhex16
 add  sp, 2
;-862 		if (fatfile_nextCluster >= 0xFFF8) {

 mov ax, [fatfile_nextCluster]
 cmp ax, 65528 ;unsigned : 0
 jb  .fatDirSearch112
;-863 			fat_notfound=1;

 mov ax, 1
 mov byte [fat_notfound], al
;-864 			return;	

 jmp .retnfatDirSearch
;-865 		}		

;-866 		fatfile_cluster=fatfile_nextCluster;

.fatDirSearch112:
 mov ax, [fatfile_nextCluster]
 mov word [fatfile_cluster], ax
;-867 		fatClusterAnalyse(fatfile_cluster);

 push word [fatfile_cluster]
 call fatClusterAnalyse
 add  sp, 2
;-868 		fatDirSectorSearch(fatfile_sectorStartL, fat_RootDirSectorsL);

 push dword [fat_RootDirSectorsL]
 push dword [fatfile_sectorStartL]
 call fatDirSectorSearch
 add  sp, 8
;-869 	}

;-870 cputs(",NF5="); printunsign(fat_notfound);		

 jmp .fatDirSearch110
.fatDirSearch111:
 push fatDirSearch_1
 call cputs
 add  sp, 2
 mov al, byte [fat_notfound]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-871 

;-872 }

;-873 

;-874 int is_delimiter(char *s) {

 .retnfatDirSearch:
 ret
fatDirSearch_0 db ",NC5=",0
fatDirSearch_1 db ",NF5=",0
ENDP

is_delimiter: PROC
;-875 	if (*s == '/' ) return 1;

;Function : is_delimiter, Number local Var: 1
; # type sign width local variables
;100 ptr sign byte s = bp+4;
 ENTER  0,0
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 47
 jne .is_delimiter113
 mov ax, 1
 jmp .retnis_delimiter
;-876 	if (*s == '\\') return 1;

.is_delimiter113:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 92
 jne .is_delimiter114
 mov ax, 1
 jmp .retnis_delimiter
;-877 	if (*s ==    0) return 2;

.is_delimiter114:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .is_delimiter115
 mov ax, 2
 jmp .retnis_delimiter
;-878 	if (*s ==  '.') return 3;

.is_delimiter115:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 46
 jne .is_delimiter116
 mov ax, 3
 jmp .retnis_delimiter
;-879 	return 0;

.is_delimiter116:
 mov ax, 0
 jmp .retnis_delimiter
;-880 }	

;-881 // 6.

;-882 int fatNextSearch() {//get next part of filename to do a search

 .retnis_delimiter:
 LEAVE
 ret
ENDP

fatNextSearch: PROC
;-883 //	IN:  upto: points to start of search in filename 

;-884 //	OUT: upto: points to search for next time

;-885 //	OUT: searchstr: part of filename in DIR-format with blanks (11bytes)

;-886 //	OUT: isfilename: 0=part of directory, 1=filename

;-887 //	OUT: fat_notfound

;-888 	char *searchstrp;

;-889 	char *p; 

;-890 	unsigned int  len;

;-891 	unsigned int delimiter;

;-892 	delimiter=is_delimiter(upto);

;Function : fatNextSearch, Number local Var: 4
; # type sign width local variables
;100 ptr sign byte searchstrp = bp-2
;101 ptr sign byte p = bp-4
;102 var unsg word len = bp-6
;103 var unsg word delimiter = bp-8;
 ENTER  8,0
 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-893 	if (delimiter == 1) upto++;

 mov ax, [bp-8]
 cmp ax, 1
 jne .fatNextSearch117
 inc  word[upto]
;-894 	if (delimiter == 2) {fat_notfound=1; return; }

.fatNextSearch117:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch118
 mov ax, 1
 mov byte [fat_notfound], al
 jmp .retnfatNextSearch
;-895 

;-896 	strcpy(&searchstr, "           ");//11 blank padded

.fatNextSearch118:
 push fatNextSearch_0
 lea  ax, [searchstr]
 push ax
 call strcpy
 add  sp, 4
;-897 	searchstrp = &searchstr;//clear searchstr

 mov ax, searchstr
 mov [bp-2], ax
;-898 	len=0;

 mov ax, 0
 mov [bp-6], ax
;-899 	delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-900 	while (delimiter == 0) { //no slash, zero, point

.fatNextSearch119:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch120
;-901 		*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-902 		searchstrp++;

 inc  word[bp-2]
;-903 		upto++;	

 inc  word[upto]
;-904 		len++;

 inc  word[bp-6]
;-905 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-906 	} 

;-907 	if (len > 8) {fat_notfound=1; return; }

 jmp .fatNextSearch119
.fatNextSearch120:
 mov ax, [bp-6]
 cmp ax, 8
 jle .fatNextSearch121
 mov ax, 1
 mov byte [fat_notfound], al
 jmp .retnfatNextSearch
;-908 	isfilename=0;//todo: default directory, not yet implemented

.fatNextSearch121:
 mov ax, 0
 mov byte [isfilename], al
;-909 	if (delimiter == 2) isfilename=1;//last name is always a file name

 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch122
 mov ax, 1
 mov byte [isfilename], al
;-910 	if (delimiter == 3) {//remove dot in name		

.fatNextSearch122:
 mov ax, [bp-8]
 cmp ax, 3
 jne .fatNextSearch123
;-911 		searchstrp = &searchstr;

 mov ax, searchstr
 mov [bp-2], ax
;-912 		searchstrp += 8;//start extension		

 add  word[bp-2], 8
;-913 		len=0;

 mov ax, 0
 mov [bp-6], ax
;-914 		upto++;

 inc  word[upto]
;-915 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-916 		while (delimiter == 0) { //no slash, zero, point

.fatNextSearch124:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch125
;-917 			*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-918 			searchstrp++;

 inc  word[bp-2]
;-919 			upto++;	

 inc  word[upto]
;-920 			len++;

 inc  word[bp-6]
;-921 			delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-922 		} 

;-923 		if (len > 3) {fat_notfound=1; return; }

 jmp .fatNextSearch124
.fatNextSearch125:
 mov ax, [bp-6]
 cmp ax, 3
 jle .fatNextSearch126
 mov ax, 1
 mov byte [fat_notfound], al
 jmp .retnfatNextSearch
;-924 		if (delimiter == 2) isfilename=1;//last name is always a file name

.fatNextSearch126:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch127
 mov ax, 1
 mov byte [isfilename], al
;-925 	}	

.fatNextSearch127:
;-926 }

.fatNextSearch123:
;-927 

;-928 // 7.

;-929 int fatGetStartCluster() {//lastBytes, lastSectors

 .retnfatNextSearch:
 LEAVE
 ret
fatNextSearch_0 db "           ",0
ENDP

fatGetStartCluster: PROC
;-930 	fat_notfound=0;

 mov ax, 0
 mov byte [fat_notfound], al
;-931 	toupper(filename);

 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-932 	upto = &filename;

 mov ax, filename
 mov word [upto], ax
;-933 	fatNextSearch();

 call fatNextSearch
;-934 

;-935 	if (debug) {

 mov ax, 1
 or  al, al
 je .fatGetStartCluster128
;-936 		putch(10);

 push 10
 call putch
 add  sp, 2
;-937  		cputsLen(searchstr, 11);

 push 11
 lea  ax, [searchstr]
 push ax
 call cputsLen
 add  sp, 4
;-938 		cputs(",FName="); 

 push fatGetStartCluster_0
 call cputs
 add  sp, 2
;-939 		printunsign(isfilename);

 mov al, byte [isfilename]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-940 		}

;-941 	if (isfilename == 0) { //todo not implemented

.fatGetStartCluster128:
 mov al, [isfilename]
 cmp al, 0
 jne .fatGetStartCluster129
;-942 		fat_notfound=1;

 mov ax, 1
 mov byte [fat_notfound], al
;-943 		return;

 jmp .retnfatGetStartCluster
;-944 		}	

;-945 	fatDirSearch();

.fatGetStartCluster129:
 call fatDirSearch
;-946 cputs(",NF7="); printunsign(fat_notfound);		

 push fatGetStartCluster_1
 call cputs
 add  sp, 2
 mov al, byte [fat_notfound]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-947 			

;-948 }

;-949 

;-950 //------------------------------- Init,  main ---------------

;-951 int Init() {

 .retnfatGetStartCluster:
 ret
fatGetStartCluster_0 db ",FName=",0
fatGetStartCluster_1 db ",NF7=",0
ENDP

Init: PROC
;-952 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-953 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-954 	if (debug) cputs(" Init");

 mov ax, 1
 or  al, al
 je .Init130
 push Init_0
 call cputs
 add  sp, 2
;-955 	if (Params()) cputs(" ** NO DRIVE PARAMS FOUND **");//no hard disk

.Init130:
 call Params
 or  al, al
 je .Init131
 push Init_1
 call cputs
 add  sp, 2
;-956 	FATtype=readMBR();//0=error,1=FAT12,6=FAT16,11=FAT32	

.Init131:
 call readMBR
 mov word [FATtype], ax
;-957 	if (FATtype == 0) {

 mov ax, [FATtype]
 cmp ax, 0
 jne .Init132
;-958 		cputs(" ** no active FAT partition found **");

 push Init_2
 call cputs
 add  sp, 2
;-959 		return 1;

 mov ax, 1
 jmp .retnInit
;-960 		}

;-961 	if(getBootSector()==0) 	return 1;

.Init132:
 call getBootSector
 cmp ax, 0
 jne .Init133
 mov ax, 1
 jmp .retnInit
;-962 	if (FATInit())			return 1;

.Init133:
 call FATInit
 or  al, al
 je .Init134
 mov ax, 1
 jmp .retnInit
;-963 	if(trueFATtype != 16) 	return 1;

.Init134:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init135
 mov ax, 1
 jmp .retnInit
;-964 	Int13hExt();

.Init135:
 call Int13hExt
;-965 	return 0;

 mov ax, 0
 jmp .retnInit
;-966 }

;-967 int main() {

 .retnInit:
 ret
Init_0 db " Init",0
Init_1 db " ** NO DRIVE PARAMS FOUND **",0
Init_2 db " ** no active FAT partition found **",0
ENDP

main: PROC
;-968 	if (Init() != 0) return 1;

 call Init
 cmp al, 0
 je  .main136
 mov ax, 1
 jmp .retnmain
;-969 //	PrintDriveParameter();

;-970 	

;-971 	strcpy(&filename, "dos.com");

.main136:
 push main_0
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-972 	fatGetStartCluster();	

 call fatGetStartCluster
;-973 //	strcpy(&filename, "abc.qwe");

;-974 //	fatGetStartCluster();	

;-975 	strcpy(&filename, "test1.c");

 push main_1
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-976 	fatGetStartCluster();//fatfile_sectorStartL,fatfile_nextCluster	

 call fatGetStartCluster
;-977 	if (debug) cputs(" End.");

 mov ax, 1
 or  al, al
 je .main137
 push main_2
 call cputs
 add  sp, 2
;-978 }

.main137:
;-979 /*

;-980 10. fatReadFile

;-981 9. fileOpen toupper, remove drive letter

;-982 8. fatOpenFile set handle, init root or subdir

;-983 	s7 fatGetStartCluster

;-984 	s4 fatClusterAnalyse

;-985 7. fatGestStartCluster

;-986 	6 fatNextSearch

;-987 	3 fatRootSearch

;-988 	s5 fatDirSearch

;-989 6. fatNextSearch Upto,search,isFilename =>7

;-990 5. fatDirSearch a directory chain for search

;-991 	4 fatClusterAnalyse

;-992 	2 fatDirSectorSearch

;-993 4. fatClusterAnalysedetermines sector by cluster number, next cluster

;-994 	1 ReadLogical

;-995 3. fatRootSearch search the root for an entry

;-996 	2 fatDirSectorSearch

;-997 2. fatDirSectorSearch search a block of sectors for entries,

;-998 		get starting cluster, file size, notfound

;-999 	1 readLogical

;-1000 2.a printDirEntry

;-1001 2.b fatDirSectorList

;-1002 	1 readLogical					

;-1003 1. readLogical

;-1004 	DiskSectorReadWrite	 */

 .retnmain:
 ret
main_0 db "dos.com",0
main_1 db "test1.c",0
main_2 db " End.",0
ENDP
