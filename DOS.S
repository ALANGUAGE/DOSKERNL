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
;-17 unsigned char dummy1[1];//todo remove

section .bss
absolute 16384
dummy1 resb 1
section .text
;-18 unsigned char filename[67];

section .bss
absolute 16385
filename resb 67
section .text
;-19 unsigned char searchstr  [12];//with null

section .bss
absolute 16452
searchstr resb 12
section .text
;-20 unsigned char DiskBuf [512];

section .bss
absolute 16464
DiskBuf resb 512
section .text
;-21 unsigned char Drive=0x80;

Drive db 128
;-22 unsigned long clust_sizeL;

clust_sizeL dd 0
;-23 unsigned long sector_sizeL;

sector_sizeL dd 0
;-24 unsigned int  sectorCount;

sectorCount dw 0
;-25 unsigned int  bytesRead;

bytesRead dw 0
;-26 unsigned long Sector;

Sector dd 0
;-27 

;-28 char *upto;		//IN:part of filename to search/OUT:to search next time

upto dw 0
;-29 char isfilename;//0=part of directory or 1=filename

isfilename db 0
;-30 char fatfound;

fatfound db 0
;-31 #define BUFFERSIZE 35000

;-32 unsigned char Buffer [BUFFERSIZE];

section .bss
absolute 16976
Buffer resb 35000
section .text
;-33 char *BufferPtr;

BufferPtr dw 0
;-34 

;-35 char          handle;

handle db 0
;-36 //start array of handles of every open file

;-37 unsigned int  CurrentCluster;

CurrentCluster dw 0
;-38 unsigned int  NextCluster;

NextCluster dw 0
;-39 unsigned long StartSectorL;		//start sector in current cluster

StartSectorL dd 0
;-40 unsigned long FileSizeL;

FileSizeL dd 0
;-41 unsigned int  lastBytes;		//resting bytes in a sector

lastBytes dw 0
;-42 unsigned int  lastSectors;		//resting sectors in a cluster

lastSectors dw 0
;-43 unsigned int  sectorUpto;		//??

sectorUpto dw 0
;-44 unsigned int  byteUpto;			//??

byteUpto dw 0
;-45 

;-46 unsigned int  CurPosition;		//current byte location in cur sector

CurPosition dw 0
;-47 unsigned long FilePointerL;		//current byte location in file

FilePointerL dd 0
;-48 //	end array of handles of every open file

;-49 

;-50 //FATInit

;-51 unsigned int  fat_FatStartSector;

fat_FatStartSector dw 0
;-52 unsigned long fat_FatStartSectorL;

fat_FatStartSectorL dd 0
;-53 unsigned int  fat_FatSectors;

fat_FatSectors dw 0
;-54 unsigned long fat_RootDirStartSectorL;

fat_RootDirStartSectorL dd 0
;-55 unsigned long fat_RootDirSectorsL;

fat_RootDirSectorsL dd 0
;-56 unsigned long fat_DataStartSectorL;

fat_DataStartSectorL dd 0
;-57 unsigned long num_tracksL;

num_tracksL dd 0
;-58 unsigned long Sectors_per_cylinderL;

Sectors_per_cylinderL dd 0
;-59 unsigned long DataSectors32;

DataSectors32 dd 0
;-60 unsigned long CountofClustersL;

CountofClustersL dd 0
;-61 unsigned char trueFATtype;	//12, 16, 32 from FATInit

trueFATtype db 0
;-62 unsigned long bytes_per_clusterL;

bytes_per_clusterL dd 0
;-63 

;-64 //Params from int13h, Function 8

;-65 unsigned int  pa_Cylinders;

pa_Cylinders dw 0
;-66 unsigned char pa_Sectors;

pa_Sectors db 0
;-67 unsigned char pa_Heads;

pa_Heads db 0
;-68 unsigned char pa_Attached;

pa_Attached db 0
;-69 unsigned int  pt_PartNo;

pt_PartNo dw 0
;-70 

;-71 //start hard disk partition structure 16 bytes in MBR. do not change!!!!!

;-72 unsigned char pt_Bootable;		// 00 80h = active partition, else 00

pt_Bootable db 0
;-73 unsigned char pt_StartHead;		// 01

pt_StartHead db 0
;-74 unsigned char pt_StartSector;	// 02 bits 0-5

pt_StartSector db 0
;-75 unsigned int  pt_StartCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-76 unsigned char pt_FileSystem;	// 04 0=nu,1=FAT12,4=16,5=ExtP,6=large16

pt_FileSystem db 0
;-77 unsigned char pt_EndHead;		// 05

pt_EndHead db 0
;-78 unsigned char pt_EndSector;		// 06 bits 0-5

pt_EndSector db 0
;-79 unsigned int  pt_EndCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-80 unsigned long pt_HiddenSector;	// 08 sectors preceding partition

pt_HiddenSector dd 0
;-81 unsigned long pt_PartLen;    	// 12 length of partition in sectors

pt_PartLen dd 0
;-82 //  16 end hard disk partition structure

;-83 

;-84 //start boot BIOS Parameter Block structure. do not change!!!!!

;-85 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-86 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-87 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-88 unsigned char bs_clust_size;// 13 sectors per CurrentCluster (1,2,4,..,128)

bs_clust_size db 0
;-89 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-90 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-91 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-92 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-93 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-94 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-95 unsigned int  bs_sectors_per_track; // 24 (DOS 3+)sectors per track

bs_sectors_per_track dw 0
;-96 unsigned int  bs_num_heads;	// 26 (DOS 3+)number of heads

bs_num_heads dw 0
;-97 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors

bs_hid_sects dd 0
;-98 unsigned long bs_tot_sect32;// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-99 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-100 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-101 unsigned char bs_ext_signat;// 38 (DOS 4+) Ext. signature,get next 3(29h)

bs_ext_signat db 0
;-102 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-103 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-104 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-105 // 62 end boot BIOS Parameter Block

;-106 

;-107 //start directory entry structure, do not change!!!!!

;-108 unsigned char dir_Filename[]="1234567";	//00 +lengthbyte=11

dir_Filename db "1234567",0
;-109 unsigned char dir_Ext[]="12";	//07 +lengthbyte=3

dir_Ext db "12",0
;-110 unsigned char dir_Attrib;		//11 directory=10h, Label=08h, read only=1

dir_Attrib db 0
;-111 unsigned char dir_NTReserved;	//12 low case in body=8h, in ext=10h

dir_NTReserved db 0
;-112 unsigned char dir_TimeCreatedMS;//13 in 10 milliseconda or zero

dir_TimeCreatedMS db 0
;-113 unsigned int  dir_TimeCreated;	//14 creation time, resolution 2 sec. or 0

dir_TimeCreated dw 0
;-114 unsigned int  dir_DateCreated;	//16 creation date or zero

dir_DateCreated dw 0
;-115 unsigned int  dir_DateLastAccessd;		//18 no time info available or zero

dir_DateLastAccessd dw 0
;-116 unsigned int  dir_FirstClusterHiBytes;	//20 FAT12/16 always zero

dir_FirstClusterHiBytes dw 0
;-117 unsigned int  dir_LastModTime;	//22 modification time on closing

dir_LastModTime dw 0
;-118 unsigned int  dir_LastModDate;	//24 modification date on closing

dir_LastModDate dw 0
;-119 unsigned int  dir_FirstCluster;	//26 1.clu. of file data,if filesize=0 then0

dir_FirstCluster dw 0
;-120 unsigned long dir_FileSize;		//28 size in bytes, if directory then zero

dir_FileSize dd 0
;-121 // 32 end direcctory entry structure

;-122 

;-123 int test() {


test: PROC
;-124 	__asm{


;-125 }	}


;-126 

;-127 //------------------------------------   IO  -------------------

;-128 

;-129 int writetty()     {//char in AL

 ret
ENDP

writetty: PROC
;-130     ah=0x0E;

 mov  ah, 14
;-131     push bx;

push bx;
;-132     bx=0;			//page in BH

 mov  bx, 0
;-133     inth 0x10;		//16

 int  16
;-134     pop bx;

pop bx;
;-135 }

;-136 int putch(char c)  {

 ret
ENDP

putch: PROC
;-137     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;104 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-138         al=13;

 mov  al, 13
;-139         writetty();

 call writetty
;-140     }

;-141     al=c;

.putch1:
 mov  al, [bp+4]
;-142     writetty();

 call writetty
;-143 }

;-144 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-145     char c;

;-146     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;104 ptr sign byte s = bp+4
;105 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-147         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-148         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-149         s++;

 inc  word[bp+4]
;-150     }

;-151 }

 jmp .cputs2
.cputs3:
;-152 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-153 	char c;

;-154 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;104 ptr sign byte s = bp+4
;105 var sign word len = bp+6
;106 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-155 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-156 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-157 		s++;

 inc  word[bp+4]
;-158 		len--;

 dec  word[bp+6]
;-159 	} while (len > 0);

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-160 }

;-161 

;-162 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-163     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-164     inth 0x16;//AH=Scan code, AL=char

 int  22
;-165 }

;-166 int waitkey() {

 ret
ENDP

waitkey: PROC
;-167     ah=0x11;//get kbd status

 mov  ah, 17
;-168     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-169     //zero flag: 0=IS char, 1=NO char

;-170     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-171 }

;-172 int getkey() {

 ret
ENDP

getkey: PROC
;-173     waitkey();

 call waitkey
;-174     getch();

 call getch
;-175     ah=0;//clear scan code

 mov  ah, 0
;-176     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-177     //put ext code in AX

;-178 }

.getkey6:
;-179 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-180     getkey();

 call getkey
;-181     writetty();//destroys AH

 call writetty
;-182 }

;-183 

;-184 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-185     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;104 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-186     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-187     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-188 }

;-189 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-190     unsigned char nib;

;-191     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;104 var unsg byte c = bp+4
;105 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-192     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-193 }

;-194 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-195     unsigned int half;

;-196     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;104 var unsg word i = bp+4
;105 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-197     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-198 }

;-199 

;-200 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-201     unsigned int e;

;-202     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;104 var unsg word n = bp+4
;105 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-203         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-204         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-205         }

;-206     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-207     n+='0';

 add  word[bp+4], 48
;-208     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-209 }

;-210 

;-211 int printlong(unsigned long L) {

 LEAVE
 ret
ENDP

printlong: PROC
;-212     ax = L;     // get low in ax

;Function : printlong, Number local Var: 1
; # type sign width local variables
;104 var unsg long L = bp+4;
 ENTER  0,0
 mov  ax, [bp+4]
;-213     edx=L;

 mov  edx, [bp+4]
;-214     edx >> 16;  // get high in dx

 shr  edx, 16
;-215 __asm{


;-216   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-217     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-218 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-219     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-220     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-221 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-222     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-223     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-224     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-225     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-226     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-227     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-228     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-229     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-230 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-231 }	writetty();		__asm{


 call writetty

;-232     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-233     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-234     jb      .b             ;Not yet

    jb      .b             ;Not yet
;-235 }


;-236 }

;-237 //--------------------------------  string  ---------------------

;-238 int strlen(char *s) { int c;

 LEAVE
 ret
ENDP

strlen: PROC
;-239     c=0;

;Function : strlen, Number local Var: 2
; # type sign width local variables
;104 ptr sign byte s = bp+4
;105 var sign word c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-240     if (*s == 34) return 0; // "

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 jne .strlen9
 mov ax, 0
 jmp .retnstrlen
;-241     while (*s!=0) {s++; c++;}

.strlen9:
.strlen10:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen11
 inc  word[bp+4]
 inc  word[bp-2]
;-242     return c;

 jmp .strlen10
.strlen11:
 mov ax, [bp-2]
 jmp .retnstrlen
;-243 }

;-244 int strcpy(char *s, char *t) {//new

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-245     while (*t!=0) {

;Function : strcpy, Number local Var: 2
; # type sign width local variables
;104 ptr sign byte s = bp+4
;105 ptr sign byte t = bp+6;
 ENTER  0,0
.strcpy12:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy13
;-246     	*s=*t; s++; t++; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-247     *s=0;

 jmp .strcpy12
.strcpy13:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-248     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-249 }

;-250 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-251     while(*p) {

;Function : eqstr, Number local Var: 2
; # type sign width local variables
;104 ptr sign byte p = bp+4
;105 ptr sign byte q = bp+6;
 ENTER  0,0
.eqstr14:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr15
;-252         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr16
 mov ax, 0
 jmp .retneqstr
;-253         p++;

.eqstr16:
 inc  word[bp+4]
;-254         q++;

 inc  word[bp+6]
;-255     }

;-256     if(*q) return 0;

 jmp .eqstr14
.eqstr15:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr17
 mov ax, 0
 jmp .retneqstr
;-257     return 1;

.eqstr17:
 mov ax, 1
 jmp .retneqstr
;-258 }

;-259 

;-260 int memcmp(char *s, char *t, unsigned int i) {

 .retneqstr:
 LEAVE
 ret
ENDP

memcmp: PROC
;-261     do {

;Function : memcmp, Number local Var: 3
; # type sign width local variables
;104 ptr sign byte s = bp+4
;105 ptr sign byte t = bp+6
;106 var unsg word i = bp+8;
 ENTER  0,0
.memcmp18:
;-262         if (*s < *t) return 0xFFFF;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 jge .memcmp19
 mov ax, 65535
 jmp .retnmemcmp
;-263         if (*s > *t) return 1;

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
;-264         s++; t++; i--;

.memcmp20:
 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-265     } while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcmp21
 jmp .memcmp18
.memcmp21:
;-266     return 0;

 mov ax, 0
 jmp .retnmemcmp
;-267 }

;-268 

;-269 int strcat(char *s, char *t) {

 .retnmemcmp:
 LEAVE
 ret
ENDP

strcat: PROC
;-270     while (*s != 0) s++;

;Function : strcat, Number local Var: 2
; # type sign width local variables
;104 ptr sign byte s = bp+4
;105 ptr sign byte t = bp+6;
 ENTER  0,0
.strcat22:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat23
 inc  word[bp+4]
;-271     strcpy(s, t);

 jmp .strcat22
.strcat23:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4
;-272 }

;-273 int toupper(char *s) {

 LEAVE
 ret
ENDP

toupper: PROC
;-274     while(*s) {

;Function : toupper, Number local Var: 1
; # type sign width local variables
;104 ptr sign byte s = bp+4;
 ENTER  0,0
.toupper24:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper25
;-275         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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
;-276         s++;

.toupper27:
.toupper26:
 inc  word[bp+4]
;-277     }

;-278 }

 jmp .toupper24
.toupper25:
;-279 int strchr(char *s, char c) {

 LEAVE
 ret
ENDP

strchr: PROC
;-280     while(*s) {

;Function : strchr, Number local Var: 2
; # type sign width local variables
;104 ptr sign byte s = bp+4
;105 var sign byte c = bp+6;
 ENTER  0,0
.strchr28:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .strchr29
;-281         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .strchr30
 mov ax, [bp+4]
 jmp .retnstrchr
;-282         s++;

.strchr30:
 inc  word[bp+4]
;-283     }

;-284     return 0;

 jmp .strchr28
.strchr29:
 mov ax, 0
 jmp .retnstrchr
;-285 }

;-286 int memchr(char *s, char c, unsigned int i) {

 .retnstrchr:
 LEAVE
 ret
ENDP

memchr: PROC
;-287     while(i > 0) {

;Function : memchr, Number local Var: 3
; # type sign width local variables
;104 ptr sign byte s = bp+4
;105 var sign byte c = bp+6
;106 var unsg word i = bp+8;
 ENTER  0,0
.memchr31:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr32
;-288         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr33
 mov ax, [bp+4]
 jmp .retnmemchr
;-289         s++; i--;

.memchr33:
 inc  word[bp+4]
 dec  word[bp+8]
;-290     }

;-291     return 0;

 jmp .memchr31
.memchr32:
 mov ax, 0
 jmp .retnmemchr
;-292 }

;-293 int memchr1(char *s, char c, unsigned int i) {

 .retnmemchr:
 LEAVE
 ret
ENDP

memchr1: PROC
;-294 	unsigned int pos;

;-295 	pos=1;

;Function : memchr1, Number local Var: 4
; # type sign width local variables
;104 ptr sign byte s = bp+4
;105 var sign byte c = bp+6
;106 var unsg word i = bp+8
;107 var unsg word pos = bp-2;
 ENTER  2,0
 mov ax, 1
 mov [bp-2], ax
;-296     while(i > 0) {

.memchr134:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr135
;-297         if (*s==c) return pos;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr136
 mov ax, [bp-2]
 jmp .retnmemchr1
;-298         s++; i--; pos++;

.memchr136:
 inc  word[bp+4]
 dec  word[bp+8]
 inc  word[bp-2]
;-299     }

;-300     return 0;

 jmp .memchr134
.memchr135:
 mov ax, 0
 jmp .retnmemchr1
;-301 }

;-302 int instr1(char *s, char c) {

 .retnmemchr1:
 LEAVE
 ret
ENDP

instr1: PROC
;-303     while(*s) {

;Function : instr1, Number local Var: 2
; # type sign width local variables
;104 ptr sign byte s = bp+4
;105 var sign byte c = bp+6;
 ENTER  0,0
.instr137:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .instr138
;-304         if (*s==c) return 1;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .instr139
 mov ax, 1
 jmp .retninstr1
;-305         s++;

.instr139:
 inc  word[bp+4]
;-306     }

;-307     return 0;

 jmp .instr137
.instr138:
 mov ax, 0
 jmp .retninstr1
;-308 }

;-309 

;-310 int memcpy(char *s, char *t, unsigned int i) {

 .retninstr1:
 LEAVE
 ret
ENDP

memcpy: PROC
;-311 	unsigned int r;

;-312 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;104 ptr sign byte s = bp+4
;105 ptr sign byte t = bp+6
;106 var unsg word i = bp+8
;107 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-313 	do {

.memcpy40:
;-314 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-315 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-316 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy41
 jmp .memcpy40
.memcpy41:
;-317 	ax=r;//	return r;

 mov  ax, [bp-2]
;-318 }

;-319 

;-320 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-321     unsigned char c; unsigned char chal; int i; int j; int k;

;-322     j=0;

;Function : mdump, Number local Var: 7
; # type sign width local variables
;104 ptr unsg byte adr = bp+4
;105 var unsg word len = bp+6
;106 var unsg byte c = bp-2
;107 var unsg byte chal = bp-4
;108 var sign word i = bp-6
;109 var sign word j = bp-8
;110 var sign word k = bp-10;
 ENTER  10,0
 mov ax, 0
 mov [bp-8], ax
;-323     k=0;

 mov ax, 0
 mov [bp-10], ax
;-324 	putch(10);

 push 10
 call putch
 add  sp, 2
;-325 	cputs("Ofs=");

 push mdump_0
 call cputs
 add  sp, 2
;-326 	printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-327 	cputs(" Length=");

 push mdump_1
 call cputs
 add  sp, 2
;-328 	printunsign(len);

 push word [bp+6]
 call printunsign
 add  sp, 2
;-329     while (j < len ) {

.mdump42:
 mov ax, [bp-8]
 cmp ax, [bp+6]
 jge .mdump43
;-330 	    k++;;

 inc  word[bp-10]
;-331 	    if (k > 16) {

 mov ax, [bp-10]
 cmp ax, 16
 jle .mdump44
;-332 		    chal = getkey();//remove scan code

 call getkey
 mov [bp-4], al
;-333 		    if (chal =='q') return;

 mov al, [bp-4]
 cmp al, 113
 jne .mdump45
 jmp .retnmdump
;-334 		    k=1;

.mdump45:
 mov ax, 1
 mov [bp-10], ax
;-335 		    putch(10);

 push 10
 call putch
 add  sp, 2
;-336 		    cputs("Ofs=");

 push mdump_2
 call cputs
 add  sp, 2
;-337 		    printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-338 		    }

;-339         putch(10);

.mdump44:
 push 10
 call putch
 add  sp, 2
;-340         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-341         putch(':');

 push 58
 call putch
 add  sp, 2
;-342         i=0;

 mov ax, 0
 mov [bp-6], ax
;-343         while (i < 16) {

.mdump46:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump47
;-344             putch(' ');

 push 32
 call putch
 add  sp, 2
;-345             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-346             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-347             adr++;

 inc  word[bp+4]
;-348             i++;

 inc  word[bp-6]
;-349             j++;

 inc  word[bp-8]
;-350             }

;-351         putch(' ');

 jmp .mdump46
.mdump47:
 push 32
 call putch
 add  sp, 2
;-352         adr -=16;

 sub  word[bp+4], 16
;-353         i=0;

 mov ax, 0
 mov [bp-6], ax
;-354         while(i < 16) {

.mdump48:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump49
;-355             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-356             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump50
 push 46
 call putch
 add  sp, 2
;-357                 else putch(c);

 jmp .mdump51
.mdump50:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-358             adr++;

.mdump51:
 inc  word[bp+4]
;-359             i++;

 inc  word[bp-6]
;-360         }

;-361     }

 jmp .mdump48
.mdump49:
;-362     getkey();

 jmp .mdump42
.mdump43:
 call getkey
;-363     putch(10);

 push 10
 call putch
 add  sp, 2
;-364 

;-365 }

;-366 int dumpASCII(unsigned char *adr, unsigned int len ) {

 .retnmdump:
 LEAVE
 ret
mdump_0 db "Ofs=",0
mdump_1 db " Length=",0
mdump_2 db "Ofs=",0
ENDP

dumpASCII: PROC
;-367     unsigned char c; unsigned char chal; int i; int j; int k;

;-368     j=0;

;Function : dumpASCII, Number local Var: 7
; # type sign width local variables
;104 ptr unsg byte adr = bp+4
;105 var unsg word len = bp+6
;106 var unsg byte c = bp-2
;107 var unsg byte chal = bp-4
;108 var sign word i = bp-6
;109 var sign word j = bp-8
;110 var sign word k = bp-10;
 ENTER  10,0
 mov ax, 0
 mov [bp-8], ax
;-369     k=0;

 mov ax, 0
 mov [bp-10], ax
;-370 	putch(10);

 push 10
 call putch
 add  sp, 2
;-371 	cputs("Ofs=");

 push dumpASCII_0
 call cputs
 add  sp, 2
;-372 	printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-373 	cputs(" Length=");

 push dumpASCII_1
 call cputs
 add  sp, 2
;-374 	printunsign(len);

 push word [bp+6]
 call printunsign
 add  sp, 2
;-375 	cputs(" Handle=");

 push dumpASCII_2
 call cputs
 add  sp, 2
;-376 	printunsign(handle);

 mov al, byte [handle]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-377     while (j < len ) {

.dumpASCII52:
 mov ax, [bp-8]
 cmp ax, [bp+6]
 jge .dumpASCII53
;-378 	    k++;;

 inc  word[bp-10]
;-379 	    if (k > 16) {

 mov ax, [bp-10]
 cmp ax, 16
 jle .dumpASCII54
;-380 		    chal = getkey();//remove scan code

 call getkey
 mov [bp-4], al
;-381 		    if (chal =='q') return;

 mov al, [bp-4]
 cmp al, 113
 jne .dumpASCII55
 jmp .retndumpASCII
;-382 		    k=1;

.dumpASCII55:
 mov ax, 1
 mov [bp-10], ax
;-383 		    putch(10);

 push 10
 call putch
 add  sp, 2
;-384 		    cputs("Ofs=");

 push dumpASCII_3
 call cputs
 add  sp, 2
;-385 		    printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-386 		    }

;-387         putch(10);

.dumpASCII54:
 push 10
 call putch
 add  sp, 2
;-388         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-389         putch(':');

 push 58
 call putch
 add  sp, 2
;-390         i=0;

 mov ax, 0
 mov [bp-6], ax
;-391         while(i < 64) {

.dumpASCII56:
 mov ax, [bp-6]
 cmp ax, 64
 jge .dumpASCII57
;-392             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-393             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .dumpASCII58
 push 46
 call putch
 add  sp, 2
;-394                 else putch(c);

 jmp .dumpASCII59
.dumpASCII58:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-395             adr++;

.dumpASCII59:
 inc  word[bp+4]
;-396             i++;

 inc  word[bp-6]
;-397             j++;

 inc  word[bp-8]
;-398         }

;-399     }

 jmp .dumpASCII56
.dumpASCII57:
;-400     getkey();

 jmp .dumpASCII52
.dumpASCII53:
 call getkey
;-401     putch(10);

 push 10
 call putch
 add  sp, 2
;-402 

;-403 }

;-404 

;-405 //--------------------------------  disk IO  -------------------

;-406 

;-407 int DiskSectorReadWrite(char rw, char drive, char head, int cyl,

 .retndumpASCII:
 LEAVE
 ret
dumpASCII_0 db "Ofs=",0
dumpASCII_1 db " Length=",0
dumpASCII_2 db " Handle=",0
dumpASCII_3 db "Ofs=",0
ENDP

DiskSectorReadWrite: PROC
;-408 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-409 	BIOS_ERR=0;

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;104 var sign byte rw = bp+4
;105 var sign byte drive = bp+6
;106 var sign byte head = bp+8
;107 var sign word cyl = bp+10
;108 var sign byte sector = bp+12
;109 var sign byte count = bp+14
;110 var sign word BufSeg = bp+16
;111 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-410 	dl=drive;

 mov  dl, [bp+6]
;-411 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-412 	es=BufSeg;

 mov  es, [bp+16]
;-413 	bx=BufOfs;

 mov  bx, [bp+18]
;-414 	cx=cyl;

 mov  cx, [bp+10]
;-415 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-416 	cx >> 2;//in 2 high bits of cl

 shr  cx, 2
;-417 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-418 	cl += sector;

 add  cl, [bp+12]
;-419 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-420 	al=count;

 mov  al, [bp+14]
;-421 	ah=rw;

 mov  ah, [bp+4]
;-422 	inth 0x13;

 int  19
;-423     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-424 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-425 }

;-426 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-427 	BIOS_ERR=0;

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;104 var sign byte drive = bp+4
;105 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-428 	dl=drive;

 mov  dl, [bp+4]
;-429 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-430 	inth 0x13;

 int  19
;-431     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-432 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-433 }

;-434 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-435 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-436 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-437 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-438 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-439 }

;-440 int Status(drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Status: PROC
;-441 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;104 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-442 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-443 	BIOS_Status=Int13hfunction(drive, 1);

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-444 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Status60
 call Int13hError
;-445 	printhex16(BIOS_Status);

.Status60:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-446 }

;-447 

;-448 int Params() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

Params: PROC
;-449 	if (debug) cputs(" DriveParams");

 mov ax, 1
 or  al, al
 je .Params61
 push Params_0
 call cputs
 add  sp, 2
;-450 	BIOS_Status=Int13hfunction(Drive, 8);

.Params61:
 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-451 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params62
;-452 		Int13hError();

 call Int13hError
;-453 		return 1;

 mov ax, 1
 jmp .retnParams
;-454 		}

;-455 	else {

 jmp .Params63
.Params62:
;-456 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-457 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-458 		// CX =       ---CH--- ---CL---

;-459 		// cylinder : 76543210 98

;-460 		// sector   :            543210

;-461 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-462 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-463 //		pa_Sectors++;//1 to 64

;-464 

;-465 		asm mov [pa_Cylinders],    cx

 mov [pa_Cylinders],    cx
;-466 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-467 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-468 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty

 add [pa_Cylinders],    ch;//byte add, low byte is empty
;-469 

;-470 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params64
;-471 			cputs(" ** no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-472 			return 1;

 mov ax, 1
 jmp .retnParams
;-473 			}

;-474 	}

.Params64:
;-475 	return 0;

.Params63:
 mov ax, 0
 jmp .retnParams
;-476 }

;-477 

;-478 

;-479 int getPartitionData() {

 .retnParams:
 ret
Params_0 db " DriveParams",0
Params_1 db " ** no hard disk found",0
ENDP

getPartitionData: PROC
;-480 	unsigned int j; char c; char *p;

;-481 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;104 var unsg word j = bp-2
;105 var sign byte c = bp-4
;106 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [pt_PartNo]
 shl ax, 4
 mov [bp-2], ax
;-482 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-483 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-484 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-485 	pt_StartCylinder=(int)pt_StartSector;

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-486 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-487 //	pt_StartSector++;//Sector start with 1 todo

;-488 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-489 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-490 	j++;

 inc  word[bp-2]
;-491 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-492 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-493 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB

;-494 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-495 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-496 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-497 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-498 //	pt_EndSector++;//Sector start with 1 todo

;-499 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-500 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-501 	j++;

 inc  word[bp-2]
;-502 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-503 	j++;

 inc  word[bp-2]
;-504 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-505 	memcpy(&pt_HiddenSector, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-506 }

;-507 

;-508 int checkBootSign() {

 LEAVE
 ret
ENDP

checkBootSign: PROC
;-509 	int i;

;-510 	i=510;

;Function : checkBootSign, Number local Var: 1
; # type sign width local variables
;104 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-511 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign65
;-512 		i++;

 inc  word[bp-2]
;-513 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign66
 mov ax, 1
 jmp .retncheckBootSign
;-514 	}

.checkBootSign66:
;-515 	cputs("  **Magic number NOT found.");

.checkBootSign65:
 push checkBootSign_0
 call cputs
 add  sp, 2
;-516 	return 0;

 mov ax, 0
 jmp .retncheckBootSign
;-517 }

;-518 

;-519 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db "  **Magic number NOT found.",0
ENDP

readMBR: PROC
;-520 	int isFAT;

;-521 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;104 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-522 	pt_PartNo=0;

 mov ax, 0
 mov word [pt_PartNo], ax
;-523 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-524 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR67
;-525 		Int13hError();

 call Int13hError
;-526 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-527 		}

;-528 	else {

 jmp .readMBR68
.readMBR67:
;-529 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .readMBR69
 mov ax, 0
 jmp .retnreadMBR
;-530 		do {

.readMBR69:
.readMBR70:
;-531 			getPartitionData();

 call getPartitionData
;-532 

;-533 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR71
;-534 				if (debug) cputs(" Boot part. found");

 mov ax, 1
 or  al, al
 je .readMBR72
 push readMBR_0
 call cputs
 add  sp, 2
;-535 				if (pt_FileSystem == 1) {

.readMBR72:
 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR73
;-536 					cputs(", FAT12 part. <32MB");

 push readMBR_1
 call cputs
 add  sp, 2
;-537 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-538 					}

;-539 				if (pt_FileSystem == 4) {

.readMBR73:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR74
;-540 					cputs(", small FAT16 part.<32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-541 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-542 					}

;-543 				if (pt_FileSystem == 6) {

.readMBR74:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR75
;-544 					if (debug) cputs(", large FAT16 part.");

 mov ax, 1
 or  al, al
 je .readMBR76
 push readMBR_3
 call cputs
 add  sp, 2
;-545 					isFAT=6;

.readMBR76:
 mov ax, 6
 mov [bp-2], ax
;-546 					}

;-547 				pt_PartNo=99;//end of loop

.readMBR75:
 mov ax, 99
 mov word [pt_PartNo], ax
;-548 			}

;-549 			pt_PartNo ++;

.readMBR71:
 inc  word[pt_PartNo]
;-550 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR77
 jmp .readMBR70
.readMBR77:
;-551 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-552 	}

;-553 }

.readMBR68:
;-554 

;-555 int getBootSector() {

 .retnreadMBR:
 LEAVE
 ret
readMBR_0 db " Boot part. found",0
readMBR_1 db ", FAT12 part. <32MB",0
readMBR_2 db ", small FAT16 part.<32MB",0
readMBR_3 db ", large FAT16 part.",0
ENDP

getBootSector: PROC
;-556 	int i;

;-557 	if (debug) cputs(" Boot sector:");

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;104 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 1
 or  al, al
 je .getBootSector78
 push getBootSector_0
 call cputs
 add  sp, 2
;-558   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

.getBootSector78:
;-559   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-560 	if (debug) printhex16(BIOS_Status);

 mov ax, 1
 or  al, al
 je .getBootSector79
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-561 	if (BIOS_ERR) {

.getBootSector79:
 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector80
;-562 		Int13hError();

 call Int13hError
;-563 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-564 		}

;-565 	else {

 jmp .getBootSector81
.getBootSector80:
;-566 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .getBootSector82
 mov ax, 0
 jmp .retngetBootSector
;-567 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector82:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-568 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector83
 push getBootSector_1
 call cputs
 add  sp, 2
;-569 		i=2;

.getBootSector83:
 mov ax, 2
 mov [bp-2], ax
;-570 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector84
 push getBootSector_2
 call cputs
 add  sp, 2
;-571 	}

.getBootSector84:
;-572 	return 1;

.getBootSector81:
 mov ax, 1
 jmp .retngetBootSector
;-573 }

;-574 

;-575 int FATInit() {

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Boot sector:",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-576 	unsigned long templong;//converting word to dword

;-577 

;-578 	clust_sizeL = (long) bs_clust_size;

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;104 var unsg long templong = bp-4;
 ENTER  4,0
 xor eax, eax
 mov al, [bs_clust_size]
 mov dword [clust_sizeL], eax
;-579 	sector_sizeL= (long) bs_sect_size;

 xor eax, eax
 mov ax, [bs_sect_size]
 mov dword [sector_sizeL], eax
;-580 

;-581 	fat_FatStartSector = bs_res_sects;

 mov ax, [bs_res_sects]
 mov word [fat_FatStartSector], ax
;-582 	fat_FatStartSectorL= (long) fat_FatStartSector; 

 xor eax, eax
 mov ax, [fat_FatStartSector]
 mov dword [fat_FatStartSectorL], eax
;-583 	fat_FatSectors = bs_fat_size;

 mov ax, [bs_fat_size]
 mov word [fat_FatSectors], ax
;-584 	if (bs_num_fats == 2) fat_FatSectors=fat_FatSectors+fat_FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .FATInit85
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-585 

;-586 	fat_RootDirStartSectorL = (long)fat_FatStartSector + fat_FatSectors;

.FATInit85:
 xor eax, eax
 mov ax, [fat_FatStartSector]
 add ax, [fat_FatSectors]
 mov dword [fat_RootDirStartSectorL], eax
;-587 	

;-588 	fat_RootDirSectorsL = (long) bs_root_entr >> 4;//  ./. 16

 xor eax, eax
 mov ax, [bs_root_entr]
 shr ax, 4
 mov dword [fat_RootDirSectorsL], eax
;-589 		

;-590 	fat_DataStartSectorL = fat_RootDirStartSectorL + fat_RootDirSectorsL;

 mov eax, [fat_RootDirStartSectorL]
 add eax, [fat_RootDirSectorsL]
 mov dword [fat_DataStartSectorL], eax
;-591 

;-592 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .FATInit86
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-593 	DataSectors32=bs_tot_sect32 - fat_DataStartSectorL;

.FATInit86:
 mov eax, [bs_tot_sect32]
 sub eax, [fat_DataStartSectorL]
 mov dword [DataSectors32], eax
;-594 

;-595 	CountofClustersL=DataSectors32 / clust_sizeL;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [clust_sizeL]
 mov dword [CountofClustersL], eax
;-596 

;-597 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-598 	num_tracksL = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [num_tracksL], eax
;-599 

;-600 //	templong = (long) bs_num_heads;

;-601 //	fat_num_cylinders = num_tracksL / templong;//w=d/w

;-602 	

;-603 	bytes_per_clusterL = (long) bs_clust_size * bs_sect_size;

 xor eax, eax
 mov al, [bs_clust_size]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_sect_size]
 mov dword [bytes_per_clusterL], eax
;-604 

;-605 	Sectors_per_cylinderL = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinderL], eax
;-606 	asm mov [Sectors_per_cylinderL + 2], dx;store high word

 mov [Sectors_per_cylinderL + 2], dx;store high word
;-607 

;-608 	templong = (long) 65525;

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-609 	if (CountofClustersL > templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jle .FATInit87
;-610 		trueFATtype=32;

 mov ax, 32
 mov byte [trueFATtype], al
;-611 		cputs(" FAT32 NOT supported");

 push FATInit_0
 call cputs
 add  sp, 2
;-612 		return 1;

 mov ax, 1
 jmp .retnFATInit
;-613 		}

;-614 	templong= (long) 4086;

.FATInit87:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-615 	if (CountofClustersL < templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jge .FATInit88
;-616 		trueFATtype=12;

 mov ax, 12
 mov byte [trueFATtype], al
;-617 		cputs(" FAT12");

 push FATInit_1
 call cputs
 add  sp, 2
;-618 		return 0;

 mov ax, 0
 jmp .retnFATInit
;-619 		}

;-620 	trueFATtype=16;

.FATInit88:
 mov ax, 16
 mov byte [trueFATtype], al
;-621 	if (debug) cputs(" FAT16");

 mov ax, 1
 or  al, al
 je .FATInit89
 push FATInit_2
 call cputs
 add  sp, 2
;-622 	return 0;

.FATInit89:
 mov ax, 0
 jmp .retnFATInit
;-623 }

;-624 

;-625 int Int13hExt() {

 .retnFATInit:
 LEAVE
 ret
FATInit_0 db " FAT32 NOT supported",0
FATInit_1 db " FAT12",0
FATInit_2 db " FAT16",0
ENDP

Int13hExt: PROC
;-626 	bx=0x55AA;

 mov  bx, 21930
;-627 	BIOS_Status=Int13hfunction(Drive, 0x41);

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-628 	asm mov [vAX], ax;

 mov [vAX], ax;
;-629 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-630 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported
;-631 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt90
;-632 		cputs(" Ext. NOT present");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-633 		Int13hError();

 call Int13hError
;-634 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-635 		}

;-636 	else if (debug) cputs(",Int13h Ext.");

 jmp .Int13hExt91
.Int13hExt90:
 mov ax, 1
 or  al, al
 je .Int13hExt92
 push Int13hExt_1
 call cputs
 add  sp, 2
;-637 	putch(10);

.Int13hExt92:
.Int13hExt91:
 push 10
 call putch
 add  sp, 2
;-638 	return 0;

 mov ax, 0
 jmp .retnInt13hExt
;-639 }

;-640 

;-641 int PrintDriveParameter() {

 .retnInt13hExt:
 ret
Int13hExt_0 db " Ext. NOT present",0
Int13hExt_1 db ",Int13h Ext.",0
ENDP

PrintDriveParameter: PROC
;-642 	unsigned long Lo;

;-643 // from Params

;-644 	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);

;Function : PrintDriveParameter, Number local Var: 1
; # type sign width local variables
;104 var unsg long Lo = bp-4;
 ENTER  4,0
 push PrintDriveParameter_0
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-645 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-646 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-647 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-648 	putch('.');

 push 46
 call putch
 add  sp, 2
;-649 //from getPartitionData

;-650 	putch(10);

 push 10
 call putch
 add  sp, 2
;-651 	cputs("getPartitionData:No=");printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-652 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-653 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-654 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-655 	cputs("/");				printunsign(pt_StartSector);

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-656 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-657 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-658 	cputs("/");				printunsign(pt_EndSector);

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-659 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-660 	cputs(",Start=");		printlong(pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 push dword [pt_HiddenSector]
 call printlong
 add  sp, 4
;-661 	cputs(",Len=");			printlong(pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 push dword [pt_PartLen]
 call printlong
 add  sp, 4
;-662 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-663 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-664 	printlong(Lo);

 push dword [bp-4]
 call printlong
 add  sp, 4
;-665 	cputs(" MByte.");

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-666 //from getBootSector

;-667 	putch(10);

 push 10
 call putch
 add  sp, 2
;-668 	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-669 	putch(10);

 push 10
 call putch
 add  sp, 2
;-670 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-671 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-672 	putch(10);

 push 10
 call putch
 add  sp, 2
;-673 	cputs("Reserved sectors=");printunsign(bs_res_sects);

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-674 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-675 	putch(10);

 push 10
 call putch
 add  sp, 2
;-676 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-677 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-678 	putch(10);

 push 10
 call putch
 add  sp, 2
;-679 	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-680 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-681 	putch(10);

 push 10
 call putch
 add  sp, 2
;-682 	cputs("sectors per track=");printunsign(bs_sectors_per_track);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_sectors_per_track]
 call printunsign
 add  sp, 2
;-683 	cputs(".number of heads=");printunsign(bs_num_heads);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_heads]
 call printunsign
 add  sp, 2
;-684 	putch(10);

 push 10
 call putch
 add  sp, 2
;-685 	cputs("hidden sectors(long)=");printlong(bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 push dword [bs_hid_sects]
 call printlong
 add  sp, 4
;-686 	cputs(".sectors(long)=");printlong(bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 push dword [bs_tot_sect32]
 call printlong
 add  sp, 4
;-687 	putch(10);

 push 10
 call putch
 add  sp, 2
;-688 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-689 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-690 	putch(10);

 push 10
 call putch
 add  sp, 2
;-691 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-692 	cputs(".Volume serial(long)=");printlong(bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 push dword [bs_serial_num]
 call printlong
 add  sp, 4
;-693 	putch(10);

 push 10
 call putch
 add  sp, 2
;-694 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-695 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-696 //from FATInit

;-697 	putch(10);

 push 10
 call putch
 add  sp, 2
;-698 	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [fat_FatStartSector]
 call printunsign
 add  sp, 2
;-699 	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [fat_FatSectors]
 call printunsign
 add  sp, 2
;-700 	putch(10);

 push 10
 call putch
 add  sp, 2
;-701 	cputs("fat_RootDirStartSectorL="); printlong(fat_RootDirStartSectorL);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push dword [fat_RootDirStartSectorL]
 call printlong
 add  sp, 4
;-702 	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectorsL);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push dword [fat_RootDirSectorsL]
 call printunsign
 add  sp, 4
;-703 	putch(10);

 push 10
 call putch
 add  sp, 2
;-704 	cputs("fat_DataStartSectorL=");	printunsign(fat_DataStartSectorL);

 push PrintDriveParameter_38
 call cputs
 add  sp, 2
 push dword [fat_DataStartSectorL]
 call printunsign
 add  sp, 4
;-705 	cputs(", DataSectors32=");	printlong(DataSectors32);

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 push dword [DataSectors32]
 call printlong
 add  sp, 4
;-706 	putch(10);

 push 10
 call putch
 add  sp, 2
;-707 	cputs("CountofClustersL=");	printlong(CountofClustersL);

 push PrintDriveParameter_40
 call cputs
 add  sp, 2
 push dword [CountofClustersL]
 call printlong
 add  sp, 4
;-708 	cputs(", Sectors_per_cylinderL="); printlong(Sectors_per_cylinderL);

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 push dword [Sectors_per_cylinderL]
 call printlong
 add  sp, 4
;-709 	putch(10);

 push 10
 call putch
 add  sp, 2
;-710 	cputs("num_tracksL=");	printlong(num_tracksL);

 push PrintDriveParameter_42
 call cputs
 add  sp, 2
 push dword [num_tracksL]
 call printlong
 add  sp, 4
;-711 	cputs(", bytes_per_clusterL=");	printlong(bytes_per_clusterL);

 push PrintDriveParameter_43
 call cputs
 add  sp, 2
 push dword [bytes_per_clusterL]
 call printlong
 add  sp, 4
;-712 //	cputs(", fat_num_cylinders="); printunsign(fat_num_cylinders);

;-713 	putch(10);

 push 10
 call putch
 add  sp, 2
;-714 	getkey();

 call getkey
;-715 }

;-716 

;-717 //--------------------------------  file IO  -------------------

;-718 int error2(char *s) {

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
PrintDriveParameter_43 db ", bytes_per_clusterL=",0
ENDP

error2: PROC
;-719 	putch(10);

;Function : error2, Number local Var: 1
; # type sign width local variables
;104 ptr sign byte s = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-720 	cputs("*** ERROR *** ");

 push error2_0
 call cputs
 add  sp, 2
;-721 	cputs(s);

 push word [bp+4]
 call cputs
 add  sp, 2
;-722 	DOS_ERR++;

 inc  byte[DOS_ERR]
;-723 }

;-724 // 1.

;-725 int readLogical(unsigned long SectorL,unsigned int DSeg, unsigned int DOfs){

 LEAVE
 ret
error2_0 db "*** ERROR *** ",0
ENDP

readLogical: PROC
;-726 	//OUT:1 sector in DiskBuf

;-727 	unsigned int track; unsigned int head; unsigned int sect;

;-728 	SectorL = SectorL + bs_hid_sects;//d=d+d

;Function : readLogical, Number local Var: 6
; # type sign width local variables
;104 var unsg long SectorL = bp+4
;105 var unsg word DSeg = bp+8
;106 var unsg word DOfs = bp+10
;107 var unsg word track = bp-2
;108 var unsg word head = bp-4
;109 var unsg word sect = bp-6;
 ENTER  6,0
 mov eax, [bp+4]
 add eax, [bs_hid_sects]
 mov [bp+4], eax
;-729 	track = SectorL / Sectors_per_cylinderL;  //w=d/d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinderL]
 mov [bp-2], ax
;-730 	head  = SectorL % Sectors_per_cylinderL;  //w=d%d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinderL]
 mov eax, edx
 mov [bp-4], ax
;-731 	sect  = head            % bs_sectors_per_track;  //w=w%w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov ax, dx
 mov [bp-6], ax
;-732 	sect++;

 inc  word[bp-6]
;-733 	head  = head            / bs_sectors_per_track;	 //w=w/w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov [bp-4], ax
;-734 

;-735 	DiskSectorReadWrite(2, bs_drive_num, head, track/* =cyl */,

;-736 		sect, 1, DSeg , DOfs);

 push word [bp+10]
 push word [bp+8]
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
;-737 }

;-738 // 2.a

;-739 int printDirEntry(int EntryNr) {

 LEAVE
 ret
ENDP

printDirEntry: PROC
;-740     unsigned int j;

;-741 	putch(10);

;Function : printDirEntry, Number local Var: 2
; # type sign width local variables
;104 var sign word EntryNr = bp+4
;105 var unsg word j = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-742 	printunsign(EntryNr);

 push word [bp+4]
 call printunsign
 add  sp, 2
;-743 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-744 	cputs(filename);

 lea  ax, [filename]
 push ax
 call cputs
 add  sp, 2
;-745 	cputs(" ATTR:");

 push printDirEntry_0
 call cputs
 add  sp, 2
;-746 	printhex8(dir_Attrib);	

 mov al, byte [dir_Attrib]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-747 	if (dir_Attrib &  1) cputs(" r/o");

 mov al, [dir_Attrib]
 and al, 1
 or  al, al
 je .printDirEntry93
 push printDirEntry_1
 call cputs
 add  sp, 2
;-748 	if (dir_Attrib &  2) cputs(" hid");

.printDirEntry93:
 mov al, [dir_Attrib]
 and al, 2
 or  al, al
 je .printDirEntry94
 push printDirEntry_2
 call cputs
 add  sp, 2
;-749 	if (dir_Attrib &  4) cputs(" sys");

.printDirEntry94:
 mov al, [dir_Attrib]
 and al, 4
 or  al, al
 je .printDirEntry95
 push printDirEntry_3
 call cputs
 add  sp, 2
;-750 	if (dir_Attrib &  8) cputs(" vol");		

.printDirEntry95:
 mov al, [dir_Attrib]
 and al, 8
 or  al, al
 je .printDirEntry96
 push printDirEntry_4
 call cputs
 add  sp, 2
;-751 	if (dir_Attrib & 16) cputs(" dir");

.printDirEntry96:
 mov al, [dir_Attrib]
 and al, 16
 or  al, al
 je .printDirEntry97
 push printDirEntry_5
 call cputs
 add  sp, 2
;-752 	if (dir_Attrib & 32) cputs(" arc");

.printDirEntry97:
 mov al, [dir_Attrib]
 and al, 32
 or  al, al
 je .printDirEntry98
 push printDirEntry_6
 call cputs
 add  sp, 2
;-753 	if (dir_Attrib == 0) cputs("    ");

.printDirEntry98:
 mov al, [dir_Attrib]
 cmp al, 0
 jne .printDirEntry99
 push printDirEntry_7
 call cputs
 add  sp, 2
;-754 	

;-755 	putch(' ');

.printDirEntry99:
 push 32
 call putch
 add  sp, 2
;-756 	j=dir_LastModDate & 31;//day

 mov ax, [dir_LastModDate]
 and ax, 31
 mov [bp-2], ax
;-757 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry100
 push 32
 call putch
 add  sp, 2
;-758 	printunsign(j);

.printDirEntry100:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-759 	putch('.');

 push 46
 call putch
 add  sp, 2
;-760 

;-761 	j=dir_LastModDate >> 5;//month

 mov ax, [dir_LastModDate]
 shr ax, 5
 mov [bp-2], ax
;-762 	j&=  15;

 and  word[bp-2], 15
;-763 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry101
 push 48
 call putch
 add  sp, 2
;-764 	printunsign(j);

.printDirEntry101:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-765 	putch('.');

 push 46
 call putch
 add  sp, 2
;-766 

;-767 	j=dir_LastModDate >> 9;//year

 mov ax, [dir_LastModDate]
 shr ax, 9
 mov [bp-2], ax
;-768 	j+= 1980;

 add  word[bp-2], 1980
;-769 	printunsign(j);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-770 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-771 	//putch(' ');

;-772 

;-773 	j=dir_LastModTime  >>11;//hour

 mov ax, [dir_LastModTime]
 shr ax, 11
 mov [bp-2], ax
;-774 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry102
 push 32
 call putch
 add  sp, 2
;-775 	printunsign(j);

.printDirEntry102:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-776 	putch(':');

 push 58
 call putch
 add  sp, 2
;-777 

;-778 	j=dir_LastModTime  >> 5;//minute

 mov ax, [dir_LastModTime]
 shr ax, 5
 mov [bp-2], ax
;-779 	j&=  63;

 and  word[bp-2], 63
;-780 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry103
 push 48
 call putch
 add  sp, 2
;-781 	printunsign(j);

.printDirEntry103:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-782 	putch(':');

 push 58
 call putch
 add  sp, 2
;-783 

;-784 	j=dir_LastModTime & 31;// 2 seconds

 mov ax, [dir_LastModTime]
 and ax, 31
 mov [bp-2], ax
;-785 	j=j+j;

 mov ax, [bp-2]
 add ax, [bp-2]
 mov [bp-2], ax
;-786 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry104
 push 48
 call putch
 add  sp, 2
;-787 	printunsign(j);

.printDirEntry104:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-788 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-789 

;-790 	cputs(" 1.Cl:"); 

 push printDirEntry_8
 call cputs
 add  sp, 2
;-791 	printunsign(dir_FirstCluster);

 push word [dir_FirstCluster]
 call printunsign
 add  sp, 2
;-792 	cputs(" Size:");

 push printDirEntry_9
 call cputs
 add  sp, 2
;-793 	printlong(dir_FileSize);

 push dword [dir_FileSize]
 call printlong
 add  sp, 4
;-794 	

;-795 }

;-796 

;-797 // 2.b

;-798 int fatDirSectorList(unsigned long startSector, unsigned long numsectors) {

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
;-799     char *p;

;-800 	unsigned int EndDiskBuf;

;-801 	char isHide;//shows entries, NOT lfn, deleted or empty

;-802 	unsigned int EntryNr;

;-803 	EntryNr=0;

;Function : fatDirSectorList, Number local Var: 6
; # type sign width local variables
;104 var unsg long startSector = bp+4
;105 var unsg long numsectors = bp+8
;106 ptr sign byte p = bp-2
;107 var unsg word EndDiskBuf = bp-4
;108 var sign byte isHide = bp-6
;109 var unsg word EntryNr = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-8], ax
;-804 	do {

.fatDirSectorList105:
;-805 /*		putch(10);

;-806 		cputs("Sektor = "); 

;-807 		printlong(startSector);

;-808 		cputs(", numsectors = "); 

;-809 		printlong(numsectors);

;-810 		getkey();

;-811 */

;-812 		readLogical(startSector, DiskBufSeg, DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp+4]
 call readLogical
 add  sp, 8
;-813 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-814 		EndDiskBuf= p + bs_sect_size;		

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-815 		

;-816 		do {

.fatDirSectorList106:
;-817 			memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-818 			memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-819 			filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-820 			

;-821 			isHide=0;//show in listing

 mov ax, 0
 mov [bp-6], al
;-822 			if (*p ==    0) {//only empty entries following

 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorList107
;-823 				isHide++;

 inc  byte[bp-6]
;-824 				numsectors=1;//finish searching

 mov ax, 1
 mov [bp+8], eax
;-825 				p = EndDiskBuf;

 mov ax, [bp-4]
 mov [bp-2], ax
;-826 				}

;-827 			if (*p == 0xE5) isHide++;//deleted, free entry

.fatDirSectorList107:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 229
 jne .fatDirSectorList108
 inc  byte[bp-6]
;-828 			if (*p <=   31) isHide++;//part of LFN

.fatDirSectorList108:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 31
 jg  .fatDirSectorList109
 inc  byte[bp-6]
;-829 			if (dir_Attrib ==    15) isHide++;//LFN start

.fatDirSectorList109:
 mov al, [dir_Attrib]
 cmp al, 15
 jne .fatDirSectorList110
 inc  byte[bp-6]
;-830 					

;-831 			if (isHide == 0) printDirEntry(EntryNr);

.fatDirSectorList110:
 mov al, [bp-6]
 cmp al, 0
 jne .fatDirSectorList111
 push word [bp-8]
 call printDirEntry
 add  sp, 2
;-832 			p+=32;//get next entry

.fatDirSectorList111:
 add  word[bp-2], 32
;-833 			EntryNr++;

 inc  word[bp-8]
;-834 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorList112
 jmp .fatDirSectorList106
.fatDirSectorList112:
;-835 		startSector = startSector + 1;//long, do NOT use ++ or +=1

 mov eax, [bp+4]
 add eax, 1
 mov [bp+4], eax
;-836 		numsectors--;

 dec  dword[bp+8]
;-837 //mdump(DiskBuf, 512);

;-838 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorList113
 jmp .fatDirSectorList105
.fatDirSectorList113:
;-839 	CurrentCluster=0;//not found but not end

 mov ax, 0
 mov word [CurrentCluster], ax
;-840 }

;-841 

;-842 // 2.

;-843 int fatDirSectorSearch(unsigned long startSector,unsigned long numsectors) {

 LEAVE
 ret
ENDP

fatDirSectorSearch: PROC
;-844     //search for file name. IN:searchstr

;-845     char *p;

;-846 	unsigned int EndDiskBuf;

;-847 	fatfound=0;

;Function : fatDirSectorSearch, Number local Var: 4
; # type sign width local variables
;104 var unsg long startSector = bp+4
;105 var unsg long numsectors = bp+8
;106 ptr sign byte p = bp-2
;107 var unsg word EndDiskBuf = bp-4;
 ENTER  4,0
 mov ax, 0
 mov byte [fatfound], al
;-848 	do {

.fatDirSectorSearch114:
;-849 		readLogical(startSector, DiskBufSeg, DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp+4]
 call readLogical
 add  sp, 8
;-850 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-851 		EndDiskBuf= p + bs_sect_size;

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-852 		do {

.fatDirSectorSearch115:
;-853 			if (memcmp(p, searchstr, 11) == 0) {//found file name

 push 11
 lea  ax, [searchstr]
 push ax
 push word [bp-2]
 call memcmp
 add  sp, 6
 cmp ax, 0
 jne .fatDirSectorSearch116
;-854 				memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-855 				memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-856 				filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-857 				CurrentCluster   = dir_FirstCluster;

 mov ax, [dir_FirstCluster]
 mov word [CurrentCluster], ax
;-858 				FileSizeL  = dir_FileSize;

 mov eax, [dir_FileSize]
 mov dword [FileSizeL], eax
;-859 				fatfound=1;

 mov ax, 1
 mov byte [fatfound], al
;-860 			}

;-861 			if (*p == 0) return; //only empty entries following

.fatDirSectorSearch116:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorSearch117
 jmp .retnfatDirSectorSearch
;-862 			p+=32;//get next entry

.fatDirSectorSearch117:
 add  word[bp-2], 32
;-863 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorSearch118
 jmp .fatDirSectorSearch115
.fatDirSectorSearch118:
;-864 		startSector++;		

 inc  dword[bp+4]
;-865 		numsectors--;

 dec  dword[bp+8]
;-866 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorSearch119
 jmp .fatDirSectorSearch114
.fatDirSectorSearch119:
;-867 	CurrentCluster=0;//not found but not end

 mov ax, 0
 mov word [CurrentCluster], ax
;-868 }

;-869 

;-870 /*

;-871 // 3.

;-872 int fatRootSearch() {

;-873     fatDirSectorSearch(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-874 //	getkey();

;-875 //    fatDirSectorList(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-876 }

;-877 */

;-878 // 4.

;-879 int fatClusterAnalyse(unsigned int clust) {

 .retnfatDirSectorSearch:
 LEAVE
 ret
ENDP

fatClusterAnalyse: PROC
;-880 //OUT: StartSectorL, NextCluster

;-881 	unsigned long fatSectorL;

;-882 	unsigned int offset;

;-883 	char *p;

;-884 

;-885 	StartSectorL = (long) clust - 2;

;Function : fatClusterAnalyse, Number local Var: 4
; # type sign width local variables
;104 var unsg word clust = bp+4
;105 var unsg long fatSectorL = bp-4
;106 var unsg word offset = bp-6
;107 ptr sign byte p = bp-8;
 ENTER  8,0
 xor eax, eax
 mov ax, [bp+4]
 sub ax, 2
 mov dword [StartSectorL], eax
;-886 	StartSectorL = StartSectorL * clust_sizeL;

 mov eax, [StartSectorL]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul dword [clust_sizeL]
 mov dword [StartSectorL], eax
;-887 	StartSectorL = StartSectorL + fat_DataStartSectorL;

 mov eax, [StartSectorL]
 add eax, [fat_DataStartSectorL]
 mov dword [StartSectorL], eax
;-888 	

;-889 //	fatSectorL=cluster*2/512+FatStartSector

;-890 	fatSectorL = (long) clust;

 xor eax, eax
 mov ax, [bp+4]
 mov [bp-4], eax
;-891 	fatSectorL = fatSectorL + fatSectorL;

 mov eax, [bp-4]
 add eax, [bp-4]
 mov [bp-4], eax
;-892 	fatSectorL = fatSectorL / sector_sizeL;		

 mov eax, [bp-4]
 xor edx, edx
 div dword [sector_sizeL]
 mov [bp-4], eax
;-893 	fatSectorL = fatSectorL + fat_FatStartSectorL; 

 mov eax, [bp-4]
 add eax, [fat_FatStartSectorL]
 mov [bp-4], eax
;-894 	readLogical(fatSectorL, DiskBufSeg, DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp-4]
 call readLogical
 add  sp, 8
;-895 	

;-896 	offset = clust + clust;//todo overflow?

 mov ax, [bp+4]
 add ax, [bp+4]
 mov [bp-6], ax
;-897 	offset = offset % bs_sect_size;

 mov ax, [bp-6]
 xor dx, dx
 div word [bs_sect_size]
 mov ax, dx
 mov [bp-6], ax
;-898 	

;-899 	p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-8], ax
;-900 	p = p + offset;	

 mov ax, [bp-8]
 add ax, [bp-6]
 mov [bp-8], ax
;-901 	memcpy(&NextCluster, p, 2);//OUT: NextCluster

 push 2
 push word [bp-8]
 lea  ax, [NextCluster]
 push ax
 call memcpy
 add  sp, 6
;-902 }

;-903 /*

;-904 // 5.

;-905 int fatDirSearch() {//search a directory chain. IN:searchstr

;-906 	

;-907 	fatClusterAnalyse(fatfile_cluster);

;-908 	//OUT: fatfile_sectorStartL, fatfile_nextCluster

;-909 

;-910 	fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster); 

;-911 	while (fatfile_cluster == 0) {//not found but not end

;-912 		if (fatfile_nextCluster >= 0xFFF8) {

;-913 			fat_notfound=1;

;-914 			return;	

;-915 		}		

;-916 		fatfile_cluster=fatfile_nextCluster;

;-917 		fatClusterAnalyse(fatfile_cluster);

;-918 		fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster);

;-919 	}	

;-920 }

;-921 */	

;-922 

;-923 int is_delimiter(char *s) {

 LEAVE
 ret
ENDP

is_delimiter: PROC
;-924 	if (*s == '/' ) return 1;

;Function : is_delimiter, Number local Var: 1
; # type sign width local variables
;104 ptr sign byte s = bp+4;
 ENTER  0,0
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 47
 jne .is_delimiter120
 mov ax, 1
 jmp .retnis_delimiter
;-925 	if (*s == '\\') return 1;

.is_delimiter120:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 92
 jne .is_delimiter121
 mov ax, 1
 jmp .retnis_delimiter
;-926 	if (*s ==    0) return 2;

.is_delimiter121:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .is_delimiter122
 mov ax, 2
 jmp .retnis_delimiter
;-927 	if (*s ==  '.') return 3;

.is_delimiter122:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 46
 jne .is_delimiter123
 mov ax, 3
 jmp .retnis_delimiter
;-928 	return 0;

.is_delimiter123:
 mov ax, 0
 jmp .retnis_delimiter
;-929 }

;-930 

;-931 // 6.

;-932 int fatNextSearch() {//get next part of filename to do a search

 .retnis_delimiter:
 LEAVE
 ret
ENDP

fatNextSearch: PROC
;-933 //	IN:  upto: points to start of search in filename 

;-934 //	OUT: upto: points to search for next time

;-935 //	OUT: searchstr: part of filename in DIR-format with blanks (11bytes)

;-936 //	OUT: isfilename: 0=part of directory, 1=filename

;-937 //	OUT: fatfound

;-938 	char *searchstrp;

;-939 	char *p; 

;-940 	unsigned int  len;

;-941 	unsigned int delimiter;

;-942 

;-943 	delimiter=is_delimiter(upto);

;Function : fatNextSearch, Number local Var: 4
; # type sign width local variables
;104 ptr sign byte searchstrp = bp-2
;105 ptr sign byte p = bp-4
;106 var unsg word len = bp-6
;107 var unsg word delimiter = bp-8;
 ENTER  8,0
 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-944 	if (delimiter == 1) upto++;

 mov ax, [bp-8]
 cmp ax, 1
 jne .fatNextSearch124
 inc  word[upto]
;-945 	if (delimiter == 2) return; 

.fatNextSearch124:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch125
 jmp .retnfatNextSearch
;-946 

;-947 	strcpy(&searchstr, "           ");//11 blank padded

.fatNextSearch125:
 push fatNextSearch_0
 lea  ax, [searchstr]
 push ax
 call strcpy
 add  sp, 4
;-948 	searchstrp = &searchstr;//clear searchstr

 mov ax, searchstr
 mov [bp-2], ax
;-949 	len=0;

 mov ax, 0
 mov [bp-6], ax
;-950 	delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-951 	while (delimiter == 0) { //no slash, zero, point

.fatNextSearch126:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch127
;-952 		*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-953 		searchstrp++;

 inc  word[bp-2]
;-954 		upto++;	

 inc  word[upto]
;-955 		len++;

 inc  word[bp-6]
;-956 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-957 	} 

;-958 	if (len > 8) return;

 jmp .fatNextSearch126
.fatNextSearch127:
 mov ax, [bp-6]
 cmp ax, 8
 jle .fatNextSearch128
 jmp .retnfatNextSearch
;-959 	isfilename=0;//todo: default directory, not yet implemented

.fatNextSearch128:
 mov ax, 0
 mov byte [isfilename], al
;-960 	if (delimiter == 2) isfilename=1;//last name is always a file name

 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch129
 mov ax, 1
 mov byte [isfilename], al
;-961 	if (delimiter == 3) {//remove dot in name		

.fatNextSearch129:
 mov ax, [bp-8]
 cmp ax, 3
 jne .fatNextSearch130
;-962 		searchstrp = &searchstr;

 mov ax, searchstr
 mov [bp-2], ax
;-963 		searchstrp += 8;//start extension		

 add  word[bp-2], 8
;-964 		len=0;

 mov ax, 0
 mov [bp-6], ax
;-965 		upto++;

 inc  word[upto]
;-966 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-967 		while (delimiter == 0) { //no slash, zero, point

.fatNextSearch131:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch132
;-968 			*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-969 			searchstrp++;

 inc  word[bp-2]
;-970 			upto++;	

 inc  word[upto]
;-971 			len++;

 inc  word[bp-6]
;-972 			delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-973 		} 

;-974 		if (len > 3) return;

 jmp .fatNextSearch131
.fatNextSearch132:
 mov ax, [bp-6]
 cmp ax, 3
 jle .fatNextSearch133
 jmp .retnfatNextSearch
;-975 		if (delimiter == 2) isfilename=1;//last name is always a file name

.fatNextSearch133:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch134
 mov ax, 1
 mov byte [isfilename], al
;-976 	}

.fatNextSearch134:
;-977 	fatfound=1;	

.fatNextSearch130:
 mov ax, 1
 mov byte [fatfound], al
;-978 }

;-979 

;-980 // 7.

;-981 int fatGetStartCluster() {//lastBytes, lastSectors

 .retnfatNextSearch:
 LEAVE
 ret
fatNextSearch_0 db "           ",0
ENDP

fatGetStartCluster: PROC
;-982 	fatfound=0;

 mov ax, 0
 mov byte [fatfound], al
;-983 	upto = &filename;

 mov ax, filename
 mov word [upto], ax
;-984 	fatNextSearch();//6 get next part of file name

 call fatNextSearch
;-985 

;-986 	if (debug) {putch(10); cputsLen(searchstr, 11); }

 mov ax, 1
 or  al, al
 je .fatGetStartCluster135
 push 10
 call putch
 add  sp, 2
 push 11
 lea  ax, [searchstr]
 push ax
 call cputsLen
 add  sp, 4
;-987 	if (isfilename == 0) return; //todo not implemented

.fatGetStartCluster135:
 mov al, [isfilename]
 cmp al, 0
 jne .fatGetStartCluster136
 jmp .retnfatGetStartCluster
;-988 	if (fatfound) fatDirSectorSearch(fat_RootDirStartSectorL,

.fatGetStartCluster136:
 mov al, [fatfound]
 or  al, al
 je .fatGetStartCluster137
;-989 	fat_RootDirSectorsL); //2 todo: only root search

 push dword [fat_RootDirSectorsL]
 push dword [fat_RootDirStartSectorL]
 call fatDirSectorSearch
 add  sp, 8
;-990 }

.fatGetStartCluster137:
;-991 

;-992 

;-993 // 8.

;-994 int fatOpenFile() {//set handle for root or subdir

 .retnfatGetStartCluster:
 ret
ENDP

fatOpenFile: PROC
;-995 //	fat_notfound=0;

;-996 	unsigned long BufSzL;

;-997 	

;-998 	if (debug) cputs(".fatOpenfile ");	

;Function : fatOpenFile, Number local Var: 1
; # type sign width local variables
;104 var unsg long BufSzL = bp-4;
 ENTER  4,0
 mov ax, 1
 or  al, al
 je .fatOpenFile138
 push fatOpenFile_0
 call cputs
 add  sp, 2
;-999 	handle=3;//todo

.fatOpenFile138:
 mov ax, 3
 mov byte [handle], al
;-1000 	sectorCount = fat_RootDirSectorsL;// or clust_sizeL

 mov eax, [fat_RootDirSectorsL]
 mov word [sectorCount], ax
;-1001 	

;-1002 	fatGetStartCluster();// 7.

 call fatGetStartCluster
;-1003 	if (fatfound == 0) { cputs(" file not found"); return; }

 mov al, [fatfound]
 cmp al, 0
 jne .fatOpenFile139
 push fatOpenFile_1
 call cputs
 add  sp, 2
 jmp .retnfatOpenFile
;-1004 	lastBytes   = FileSizeL % bytes_per_clusterL;	

.fatOpenFile139:
 mov eax, [FileSizeL]
 xor edx, edx
 div dword [bytes_per_clusterL]
 mov eax, edx
 mov word [lastBytes], ax
;-1005 	lastSectors = lastBytes / sector_sizeL;//resting sectors in a cluster

 mov ax, [lastBytes]
 xor edx, edx
 div dword [sector_sizeL]
 mov word [lastSectors], ax
;-1006 	lastBytes   = lastBytes % sector_sizeL;//resting bytes in a sector

 mov ax, [lastBytes]
 xor edx, edx
 div dword [sector_sizeL]
 mov eax, edx
 mov word [lastBytes], ax
;-1007 	

;-1008 	if (FileSizeL == 0) isfilename = 0;

 mov eax, [FileSizeL]
 cmp eax, 0
 jne .fatOpenFile140
 mov ax, 0
 mov byte [isfilename], al
;-1009 	else isfilename = 1;

 jmp .fatOpenFile141
.fatOpenFile140:
 mov ax, 1
 mov byte [isfilename], al
;-1010 		

;-1011 	BufSzL = (long) BUFFERSIZE;

.fatOpenFile141:
 xor eax, eax
 mov ax, 35000
 mov [bp-4], eax
;-1012 	if (FileSizeL >=  BufSzL) {

 mov eax, [FileSizeL]
 cmp eax, [bp-4] ;unsigned : 0
 jb  .fatOpenFile142
;-1013 		cputs(" file longer than BufferSize"); 

 push fatOpenFile_2
 call cputs
 add  sp, 2
;-1014 		fatfound= 0;

 mov ax, 0
 mov byte [fatfound], al
;-1015 		return;

 jmp .retnfatOpenFile
;-1016 	}

;-1017 

;-1018 	fatClusterAnalyse(CurrentCluster);// 4. OUT:StartSectorL,NextCluster

.fatOpenFile142:
 push word [CurrentCluster]
 call fatClusterAnalyse
 add  sp, 2
;-1019 	sectorCount = clust_sizeL;//1..128 or fat_RootDirSectorsL

 mov eax, [clust_sizeL]
 mov word [sectorCount], ax
;-1020 	FilePointerL = 0;

 mov ax, 0
 mov dword [FilePointerL], eax
;-1021 	sectorUpto = 0;

 mov ax, 0
 mov word [sectorUpto], ax
;-1022 	byteUpto   = 0;

 mov ax, 0
 mov word [byteUpto], ax
;-1023 //	if (fat_notfound) return 1;

;-1024 	if (debug) {									//		DOS.COM FDCONFIG

 mov ax, 1
 or  al, al
 je .fatOpenFile143
;-1025 	cputs(" CurrentCluster="); 	printunsign(CurrentCluster);//4177	4164

 push fatOpenFile_3
 call cputs
 add  sp, 2
 push word [CurrentCluster]
 call printunsign
 add  sp, 2
;-1026 	cputs(",StartSectorL=");	printlong(StartSectorL);	//17051	16999

 push fatOpenFile_4
 call cputs
 add  sp, 2
 push dword [StartSectorL]
 call printlong
 add  sp, 4
;-1027 	cputs(",ClusterSizeL=");	printlong(clust_sizeL);		// 4	 4

 push fatOpenFile_5
 call cputs
 add  sp, 2
 push dword [clust_sizeL]
 call printlong
 add  sp, 4
;-1028 	cputs(",FileSizeL="); 		printlong(FileSizeL);		//8802	762

 push fatOpenFile_6
 call cputs
 add  sp, 2
 push dword [FileSizeL]
 call printlong
 add  sp, 4
;-1029 	cputs(",NextCluster="); 	printunsign(NextCluster);	//4178	65.535

 push fatOpenFile_7
 call cputs
 add  sp, 2
 push word [NextCluster]
 call printunsign
 add  sp, 2
;-1030 	cputs(",lastSectors=");		printunsign(lastSectors);	// 1	 1

 push fatOpenFile_8
 call cputs
 add  sp, 2
 push word [lastSectors]
 call printunsign
 add  sp, 2
;-1031 	cputs(",lastBytes="); 		printunsign(lastBytes);		// 98	250

 push fatOpenFile_9
 call cputs
 add  sp, 2
 push word [lastBytes]
 call printunsign
 add  sp, 2
;-1032 	}

;-1033 }

.fatOpenFile143:
;-1034 

;-1035 

;-1036 int get_fat(unsigned int cl) {

 .retnfatOpenFile:
 LEAVE
 ret
fatOpenFile_0 db ".fatOpenfile ",0
fatOpenFile_1 db " file not found",0
fatOpenFile_2 db " file longer than BufferSize",0
fatOpenFile_3 db " CurrentCluster=",0
fatOpenFile_4 db ",StartSectorL=",0
fatOpenFile_5 db ",ClusterSizeL=",0
fatOpenFile_6 db ",FileSizeL=",0
fatOpenFile_7 db ",NextCluster=",0
fatOpenFile_8 db ",lastSectors=",0
fatOpenFile_9 db ",lastBytes=",0
ENDP

get_fat: PROC
;-1037 	

;-1038 	

;-1039 }

;Function : get_fat, Number local Var: 1
; # type sign width local variables
;104 var unsg word cl = bp+4;
 ENTER  0,0
;-1040 	

;-1041 // 9a.

;-1042 int pf_read(unsigned long bytestoReadL) {

 LEAVE
 ret
ENDP

pf_read: PROC
;-1043 //	IN:FileSizeL

;-1044 //	IO:FilePointerL

;-1045 //	OUT: 0=OK, 1=error

;-1046 	unsigned long remainL;

;-1047 	unsigned long templong1;

;-1048 	unsigned long templong2;

;-1049 	unsigned int  tempint1;

;-1050 	unsigned char tempbyte1;//CS byte

;-1051 	unsigned int  clst;//=CurrentCluster=actual cluster

;-1052 	

;-1053 	unsigned long constL512;

;-1054 	constL512 = (long) 512;

;Function : pf_read, Number local Var: 8
; # type sign width local variables
;104 var unsg long bytestoReadL = bp+4
;105 var unsg long remainL = bp-4
;106 var unsg long templong1 = bp-8
;107 var unsg long templong2 = bp-12
;108 var unsg word tempint1 = bp-14
;109 var unsg byte tempbyte1 = bp-16
;110 var unsg word clst = bp-18
;111 var unsg long constL512 = bp-22;
 ENTER  22,0
 xor eax, eax
 mov ax, 512
 mov [bp-22], eax
;-1055 	

;-1056 	remainL = FileSizeL - FilePointerL;	

 mov eax, [FileSizeL]
 sub eax, [FilePointerL]
 mov [bp-4], eax
;-1057 

;-1058 	if (bytestoReadL > remainL) bytestoReadL = remainL;

 mov eax, [bp+4]
 cmp eax, [bp-4]
 jle .pf_read144
 mov eax, [bp-4]
 mov [bp+4], eax
;-1059 

;-1060 	while (bytestoReadL != 0) {//repeat until all data transferred

.pf_read144:
.pf_read145:
 mov eax, [bp+4]
 cmp eax, 0
 je  .pf_read146
;-1061 		tempint1 = FilePointerL % constL512;

 mov eax, [FilePointerL]
 xor edx, edx
 div dword [bp-22]
 mov eax, edx
 mov [bp-14], ax
;-1062 

;-1063 		if (tempint1  ==  0) {//on sector boundary?			

 mov ax, [bp-14]
 cmp ax, 0
 jne .pf_read147
;-1064 			templong1 = FilePointerL / constL512;//sector offset in cluster	

 mov eax, [FilePointerL]
 xor edx, edx
 div dword [bp-22]
 mov [bp-8], eax
;-1065 			templong2 = clust_sizeL- 1;//0 - 127

 mov eax, [clust_sizeL]
 sub eax, 1
 mov [bp-12], eax
;-1066 			tempbyte1 = templong1 & templong2;

 mov eax, [bp-8]
 and eax, [bp-12]
 mov [bp-16], al
;-1067 			if (tempbyte1 != 0) {//on cluster boundary?

 mov al, [bp-16]
 cmp al, 0
 je  .pf_read148
;-1068 				if (FilePointerL == 0) clst = dir_FirstCluster;//top file?

 mov eax, [FilePointerL]
 cmp eax, 0
 jne .pf_read149
 mov ax, [dir_FirstCluster]
 mov [bp-18], ax
;-1069 				else clst=get_fat(CurrentCluster);

 jmp .pf_read150
.pf_read149:
 push word [CurrentCluster]
 call get_fat
 add  sp, 2
 mov [bp-18], ax
;-1070 				if (clst <= 1) return 1;

.pf_read150:
 mov ax, [bp-18]
 cmp ax, 1
 ja  .pf_read151
 mov ax, 1
 jmp .retnpf_read
;-1071 				CurrentCluster = clst;//update current cluster

.pf_read151:
 mov ax, [bp-18]
 mov word [CurrentCluster], ax
;-1072 				

;-1073 			}		

;-1074 		}	

.pf_read148:
;-1075 	}		

.pf_read147:
;-1076 }	

 jmp .pf_read145
.pf_read146:
;-1077 

;-1078 // 9.

;-1079 int fatReadFile() {// reads from an already open file

 .retnpf_read:
 LEAVE
 ret
ENDP

fatReadFile: PROC
;-1080 //	IN: CurrentCluster, FileSizeL, FilePointerL

;-1081 //	IN: lastBytes, lastSectors

;-1082 	unsigned int  sectorsAvail;	//in one cluster or rootsize

;-1083 	unsigned int  bytesAvail;	//max. in one sector

;-1084 	unsigned long CurrentSectorL;

;-1085 

;-1086 	unsigned int  temp1;

;-1087 	unsigned int  temp2;

;-1088 	unsigned int  temp3;

;-1089 	unsigned int  BufSz;

;-1090 	BufSz    =    BUFFERSIZE;

;Function : fatReadFile, Number local Var: 7
; # type sign width local variables
;104 var unsg word sectorsAvail = bp-2
;105 var unsg word bytesAvail = bp-4
;106 var unsg long CurrentSectorL = bp-8
;107 var unsg word temp1 = bp-10
;108 var unsg word temp2 = bp-12
;109 var unsg word temp3 = bp-14
;110 var unsg word BufSz = bp-16;
 ENTER  16,0
 mov ax, 35000
 mov [bp-16], ax
;-1091 	

;-1092 	BufferPtr = &Buffer;

 mov ax, Buffer
 mov word [BufferPtr], ax
;-1093 	bytesRead = 0;

 mov ax, 0
 mov word [bytesRead], ax
;-1094 	sectorsAvail = sectorCount;	//1..128 or fat_RootDirSectorsL 

 mov ax, [sectorCount]
 mov [bp-2], ax
;-1095 	bytesAvail = bs_sect_size;

 mov ax, [bs_sect_size]
 mov [bp-4], ax
;-1096 	

;-1097 	while (CurrentCluster < 0xFFF8) {//not end of Cluster

.fatReadFile152:
 mov ax, [CurrentCluster]
 cmp ax, 65528
 jge .fatReadFile153
;-1098 		sectorsAvail = sectorCount;

 mov ax, [sectorCount]
 mov [bp-2], ax
;-1099 		if (NextCluster >= 0xFFF8) {

 mov ax, [NextCluster]
 cmp ax, 65528 ;unsigned : 0
 jb  .fatReadFile154
;-1100 			if (isfilename) sectorsAvail = lastSectors + 1;//????

 mov al, [isfilename]
 or  al, al
 je .fatReadFile155
 mov ax, [lastSectors]
 add ax, 1
 mov [bp-2], ax
;-1101 			}

.fatReadFile155:
;-1102 		while (sectorUpto != sectorsAvail) {

.fatReadFile154:
.fatReadFile156:
 mov ax, [sectorUpto]
 cmp ax, [bp-2]
 je  .fatReadFile157
;-1103 			bytesAvail = bs_sect_size;

 mov ax, [bs_sect_size]
 mov [bp-4], ax
;-1104 			if (NextCluster >= 0xFFF8) {

 mov ax, [NextCluster]
 cmp ax, 65528 ;unsigned : 0
 jb  .fatReadFile158
;-1105 				if (isfilename) {

 mov al, [isfilename]
 or  al, al
 je .fatReadFile159
;-1106 					if (sectorUpto == lastSectors) {

 mov ax, [sectorUpto]
 cmp ax, [lastSectors]
 jne .fatReadFile160
;-1107 						bytesAvail = lastBytes;

 mov ax, [lastBytes]
 mov [bp-4], ax
;-1108 					}	

;-1109 				}

.fatReadFile160:
;-1110 			}

.fatReadFile159:
;-1111 			while (byteUpto != bytesAvail) {

.fatReadFile158:
.fatReadFile161:
 mov ax, [byteUpto]
 cmp ax, [bp-4]
 je  .fatReadFile162
;-1112 				CurrentSectorL = (long) sectorUpto;

 xor eax, eax
 mov ax, [sectorUpto]
 mov [bp-8], eax
;-1113 				CurrentSectorL = CurrentSectorL + StartSectorL;	

 mov eax, [bp-8]
 add eax, [StartSectorL]
 mov [bp-8], eax
;-1114 				readLogical(CurrentSectorL, DiskBufSeg, DiskBuf);		

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp-8]
 call readLogical
 add  sp, 8
;-1115 				

;-1116 				temp1 = bytesAvail - byteUpto;

 mov ax, [bp-4]
 sub ax, [byteUpto]
 mov [bp-10], ax
;-1117 				temp2 = BufSz - bytesRead;

 mov ax, [bp-16]
 sub ax, [bytesRead]
 mov [bp-12], ax
;-1118 				temp3 = Buffer + byteUpto;

 mov al, [Buffer]
 add ax, [byteUpto]
 mov [bp-14], ax
;-1119 

;-1120 				BufferPtr = BufferPtr + bytesRead;////////////////

 mov ax, [BufferPtr]
 add ax, [bytesRead]
 mov word [BufferPtr], ax
;-1121 				

;-1122 				

;-1123 				if (temp1 > temp2) {//read last sector not full

 mov ax, [bp-10]
 cmp ax, [bp-12]
 jle .fatReadFile163
;-1124 					memcpy(BufferPtr, temp3, temp2);	

 push word [bp-12]
 push word [bp-14]
 push word [BufferPtr]
 call memcpy
 add  sp, 6
;-1125 					byteUpto = byteUpto + temp2;

 mov ax, [byteUpto]
 add ax, [bp-12]
 mov word [byteUpto], ax
;-1126 					bytesRead = BufSz;

 mov ax, [bp-16]
 mov word [bytesRead], ax
;-1127 					return;

 jmp .retnfatReadFile
;-1128 				}	

;-1129 				else {//read full sector

 jmp .fatReadFile164
.fatReadFile163:
;-1130 					memcpy(BufferPtr, temp3, temp1);

 push word [bp-10]
 push word [bp-14]
 push word [BufferPtr]
 call memcpy
 add  sp, 6
;-1131 					bytesRead = bytesRead + temp1;

 mov ax, [bytesRead]
 add ax, [bp-10]
 mov word [bytesRead], ax
;-1132 					byteUpto = byteUpto + temp1; 

 mov ax, [byteUpto]
 add ax, [bp-10]
 mov word [byteUpto], ax
;-1133 				}	

;-1134 			}	

.fatReadFile164:
;-1135 			sectorUpto ++;

 jmp .fatReadFile161
.fatReadFile162:
 inc  word[sectorUpto]
;-1136 			byteUpto = 0;

 mov ax, 0
 mov word [byteUpto], ax
;-1137 		}	

;-1138 		CurrentCluster = NextCluster;

 jmp .fatReadFile156
.fatReadFile157:
 mov ax, [NextCluster]
 mov word [CurrentCluster], ax
;-1139 		fatClusterAnalyse(CurrentCluster);//4.OUT:StartSectorL,NextCluster

 push word [CurrentCluster]
 call fatClusterAnalyse
 add  sp, 2
;-1140 		sectorUpto = 0;

 mov ax, 0
 mov word [sectorUpto], ax
;-1141 	}	

;-1142 }

 jmp .fatReadFile152
.fatReadFile153:
;-1143 //------------------------------- OS functions --------------

;-1144 //handle: 0=in, 1=out, 2=err, 255=error

;-1145 // 10.

;-1146 int OSOpenFile(char *name) {

 .retnfatReadFile:
 LEAVE
 ret
ENDP

OSOpenFile: PROC
;-1147 //remove drive letter, slash. uppercase and copy to filename

;-1148 	unsigned int i;

;-1149 	handle=255;//default=error

;Function : OSOpenFile, Number local Var: 2
; # type sign width local variables
;104 ptr sign byte name = bp+4
;105 var unsg word i = bp-2;
 ENTER  2,0
 mov ax, 255
 mov byte [handle], al
;-1150 	strcpy(filename, name);

 push word [bp+4]
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1151 	toupper(filename);

 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-1152 

;-1153 	if (strlen(filename) == 0) return;

 lea  ax, [filename]
 push ax
 call strlen
 add  sp, 2
 cmp ax, 0
 jne .OSOpenFile165
 jmp .retnOSOpenFile
;-1154 	i=strchr(filename, ':');

.OSOpenFile165:
 push 58
 lea  ax, [filename]
 push ax
 call strchr
 add  sp, 4
 mov [bp-2], ax
;-1155 	if (i) {

 mov ax, [bp-2]
 or  al, al
 je .OSOpenFile166
;-1156 		i++;

 inc  word[bp-2]
;-1157 		strcpy(filename, i);	

 push word [bp-2]
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1158 		if (strlen(filename) == 0) return;	

 lea  ax, [filename]
 push ax
 call strlen
 add  sp, 2
 cmp ax, 0
 jne .OSOpenFile167
 jmp .retnOSOpenFile
;-1159 	}	

.OSOpenFile167:
;-1160 //todo: add working directory page 18

;-1161 	if(is_delimiter(filename) == 1) filename++;

.OSOpenFile166:
 lea  ax, [filename]
 push ax
 call is_delimiter
 add  sp, 2
 cmp ax, 1
 jne .OSOpenFile168
 inc  byte[filename]
;-1162 //	if (debug) {cputs(" filename=");cputs(filename);}		

;-1163 	

;-1164 	fatOpenFile();

.OSOpenFile168:
 call fatOpenFile
;-1165 }

;-1166 

;-1167 // 11.

;-1168 int OSReadFile(char hd) {

 .retnOSOpenFile:
 LEAVE
 ret
ENDP

OSReadFile: PROC
;-1169 	fatReadFile(hd);//9.

;Function : OSReadFile, Number local Var: 1
; # type sign width local variables
;104 var sign byte hd = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fatReadFile
 add  sp, 2
;-1170 }

;-1171 

;-1172 int OSShowFile(char hd) {

 LEAVE
 ret
ENDP

OSShowFile: PROC
;-1173 	mdump(Buffer, 512);

;Function : OSShowFile, Number local Var: 1
; # type sign width local variables
;104 var sign byte hd = bp+4;
 ENTER  0,0
 push 512
 lea  ax, [Buffer]
 push ax
 call mdump
 add  sp, 4
;-1174 	dumpASCII(Buffer, FileSizeL);

 push dword [FileSizeL]
 lea  ax, [Buffer]
 push ax
 call dumpASCII
 add  sp, 6
;-1175 }

;-1176 

;-1177 int OSStartCOM(char hd) {

 LEAVE
 ret
ENDP

OSStartCOM: PROC
;-1178 	

;-1179 }

;Function : OSStartCOM, Number local Var: 1
; # type sign width local variables
;104 var sign byte hd = bp+4;
 ENTER  0,0
;-1180 

;-1181 

;-1182 //------------------------------- Init,  main ---------------

;-1183 int Init() {

 LEAVE
 ret
ENDP

Init: PROC
;-1184 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-1185 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-1186 	if (debug) cputs(" Init");

 mov ax, 1
 or  al, al
 je .Init169
 push Init_0
 call cputs
 add  sp, 2
;-1187 	if (Params()) cputs(" ** NO DRIVE PARAMS FOUND **");//no hard disk

.Init169:
 call Params
 or  al, al
 je .Init170
 push Init_1
 call cputs
 add  sp, 2
;-1188 	if (readMBR() == 0) {//0=error,1=FAT12,6=FAT16,11=FAT32	

.Init170:
 call readMBR
 cmp al, 0
 jne .Init171
;-1189 		cputs(" ** no active FAT partition found **");

 push Init_2
 call cputs
 add  sp, 2
;-1190 		return 1;

 mov ax, 1
 jmp .retnInit
;-1191 		}

;-1192 	if(getBootSector()==0) 	return 1;

.Init171:
 call getBootSector
 cmp al, 0
 jne .Init172
 mov ax, 1
 jmp .retnInit
;-1193 	if (FATInit())			return 1;

.Init172:
 call FATInit
 or  al, al
 je .Init173
 mov ax, 1
 jmp .retnInit
;-1194 	if(trueFATtype != 16) 	return 1;

.Init173:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init174
 mov ax, 1
 jmp .retnInit
;-1195 	Int13hExt();

.Init174:
 call Int13hExt
;-1196 	return 0;

 mov ax, 0
 jmp .retnInit
;-1197 }

;-1198 

;-1199 int main() {

 .retnInit:
 ret
Init_0 db " Init",0
Init_1 db " ** NO DRIVE PARAMS FOUND **",0
Init_2 db " ** no active FAT partition found **",0
ENDP

main: PROC
;-1200 	if (Init() != 0) return 1;

 call Init
 cmp al, 0
 je  .main175
 mov ax, 1
 jmp .retnmain
;-1201 	if (debug) PrintDriveParameter();

.main175:
 mov ax, 1
 or  al, al
 je .main176
 call PrintDriveParameter
;-1202 	

;-1203 	OSOpenFile("dos.com");	

.main176:
 push main_0
 call OSOpenFile
 add  sp, 2
;-1204 	if (handle == 255) cputs(" **no handle**");		

 mov al, [handle]
 cmp al, 255
 jne .main177
 push main_1
 call cputs
 add  sp, 2
;-1205 	if (handle < 0) cputs(" **handle < 0**");		

.main177:
 mov al, [handle]
 cmp al, 0
 jge .main178
 push main_2
 call cputs
 add  sp, 2
;-1206 	OSOpenFile("fdconfig.sys");	

.main178:
 push main_3
 call OSOpenFile
 add  sp, 2
;-1207 	if (handle == 255) cputs(" **no handle**");	

 mov al, [handle]
 cmp al, 255
 jne .main179
 push main_4
 call cputs
 add  sp, 2
;-1208 	OSReadFile(handle);

.main179:
 mov al, byte [handle]
 mov ah, 0
 push ax
 call OSReadFile
 add  sp, 2
;-1209 	OSShowFile(handle);

 mov al, byte [handle]
 mov ah, 0
 push ax
 call OSShowFile
 add  sp, 2
;-1210 

;-1211 /*	OSOpenFile("C:cm.bat");	

;-1212 	if (handle == 255) cputs(" **no handle**");		

;-1213 /*	OSOpenFile("ab:/z");	

;-1214 	if (handle == 255) cputs(" **no handle**");	

;-1215 	OSOpenFile("C:");	

;-1216 	if (handle == 255) cputs(" **no handle**");	

;-1217 	OSOpenFile("/test.ba");	

;-1218 	if (handle == 255) cputs(" **no handle**");	

;-1219 */

;-1220 	if (debug) cputs(".End.");

 mov ax, 1
 or  al, al
 je .main180
 push main_5
 call cputs
 add  sp, 2
;-1221 }

.main180:
;-1222 /*cputs(" delimiter="); printunsign(delimiter);

;-1223 cputs(", isfilename="); printunsign(isfilename);

;-1224 cputs(", upto="); printunsign(upto);

;-1225 cputs("="); cputs(upto);

;-1226 cputs(", len="); printunsign(len);

;-1227 cputs(", searchstr="); cputsLen(searchstr, len);

;-1228 */

;-1229 /*

;-1230 11	OSReadFile

;-1231 	9 fatReadFile

;-1232 	

;-1233 10	OSOpenFile drive,slash,upper,to filename

;-1234 	8 fatOpenFile

;-1235 9. fatReadFile

;-1236 	1 readLogical

;-1237 	4 fatClusterAnalyse

;-1238 8. fatOpenFile set handle, init root or subdir

;-1239 	s7 fatGetStartCluster

;-1240 	s4 fatClusterAnalyse

;-1241 7. fatGestStartCluster

;-1242 	6 fatNextSearch

;-1243 	3 fatRootSearch

;-1244 	s5 fatDirSearch

;-1245 6. fatNextSearch Upto,search,isFilename =>7

;-1246 5. fatDirSearch a directory chain for search

;-1247 	4 fatClusterAnalyse

;-1248 	2 fatDieSectorSearch

;-1249 4. fatClusterAnalyse determines sector by cluster number, next cluster

;-1250 	1 ReadLogical

;-1251 3. fatRootSearch search the root for an entry

;-1252 	2 fatDirSectorSearch

;-1253 2. fatDirSectorSearch search a block of sectors for entries,

;-1254 		get starting cluster, file size, notfound

;-1255 	1 readLogical

;-1256 2.a printDirEntry

;-1257 2.b fatDirSectorList

;-1258 	1 readLogical					

;-1259 1. readLogical

;-1260 	DiskSectorReadWrite	

;-1261 */

;-1262 /*

;-1263 bin_file=fopen("name", "rb") //binary

;-1264 int = fgetc(in_file)	     //EOF(-1)

;-1265 fputc(character, file)

;-1266 printf() = fprintf(stdout, format, parameter1) //buffered I/O

;-1267 DOS: add CR13 to LF10

;-1268 read_size=fread(data_ptr, 1, size, file) //binary read

;-1269 file_descriptor=open(name, flags, mode=0666) //unbuffered I/O

;-1270 read_size=read(file_descriptor, buffer, size) //unbufferes I/O 

;-1271 */

 .retnmain:
 ret
main_0 db "dos.com",0
main_1 db " **no handle**",0
main_2 db " **handle < 0**",0
main_3 db "fdconfig.sys",0
main_4 db " **no handle**",0
main_5 db ".End.",0
ENDP
