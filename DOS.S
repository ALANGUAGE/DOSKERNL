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
;-84 unsigned int  dir_FirstCluster;	//26 1.clu. file data,if filesize=0 then 0

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
;-434 	pt_StartCylinder = pt_StartCylindfatfile_c	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 mov ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
Expected ASCII(dez): 59
 	pt_StartCylinder = pt_StartCylindfatfile_c	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;
;Line: 434 ************** ERROR:  not found  in column: 61
Token: 256, Symbol: pt_StartCylinder