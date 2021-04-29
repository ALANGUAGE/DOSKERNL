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
;-40 unsigned long CurrentSectorL;	//current data sector

CurrentSectorL dd 0
;-41 unsigned long FileSizeL;

FileSizeL dd 0
;-42 unsigned int  lastBytes;		//resting bytes in a sector

lastBytes dw 0
;-43 unsigned int  lastSectors;		//resting sectors in a cluster

lastSectors dw 0
;-44 unsigned int  sectorUpto;		//??

sectorUpto dw 0
;-45 unsigned int  byteUpto;			//??

byteUpto dw 0
;-46 

;-47 unsigned int  CurPosition;		//current byte location in cur sector

CurPosition dw 0
;-48 unsigned long FilePointerL;		//current byte location in file

FilePointerL dd 0
;-49 //	end array of handles of every open file

;-50 

;-51 //FATInit

;-52 unsigned int  fat_FatStartSector;

fat_FatStartSector dw 0
;-53 unsigned long fat_FatStartSectorL;

fat_FatStartSectorL dd 0
;-54 unsigned int  fat_FatSectors;

fat_FatSectors dw 0
;-55 unsigned int  fat_Entries;

fat_Entries dw 0
;-56 unsigned long fat_RootDirStartSectorL;

fat_RootDirStartSectorL dd 0
;-57 unsigned long fat_RootDirSectorsL;

fat_RootDirSectorsL dd 0
;-58 unsigned long fat_DataStartSectorL;

fat_DataStartSectorL dd 0
;-59 unsigned long num_tracksL;

num_tracksL dd 0
;-60 unsigned long Sectors_per_cylinderL;

Sectors_per_cylinderL dd 0
;-61 unsigned long DataSectors32;

DataSectors32 dd 0
;-62 unsigned long CountofClustersL;

CountofClustersL dd 0
;-63 unsigned char trueFATtype;	//12, 16, 32 from FATInit

trueFATtype db 0
;-64 unsigned long bytes_per_clusterL;

bytes_per_clusterL dd 0
;-65 

;-66 //Params from int13h, Function 8

;-67 unsigned int  pa_Cylinders;

pa_Cylinders dw 0
;-68 unsigned char pa_Sectors;

pa_Sectors db 0
;-69 unsigned char pa_Heads;

pa_Heads db 0
;-70 unsigned char pa_Attached;

pa_Attached db 0
;-71 unsigned int  pt_PartNo;

pt_PartNo dw 0
;-72 

;-73 //start hard disk partition structure 16 bytes in MBR. do not change!!!!!

;-74 unsigned char pt_Bootable;		// 00 80h = active partition, else 00

pt_Bootable db 0
;-75 unsigned char pt_StartHead;		// 01

pt_StartHead db 0
;-76 unsigned char pt_StartSector;	// 02 bits 0-5

pt_StartSector db 0
;-77 unsigned int  pt_StartCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-78 unsigned char pt_FileSystem;	// 04 0=nu,1=FAT12,4=16,5=ExtP,6=large16

pt_FileSystem db 0
;-79 unsigned char pt_EndHead;		// 05

pt_EndHead db 0
;-80 unsigned char pt_EndSector;		// 06 bits 0-5

pt_EndSector db 0
;-81 unsigned int  pt_EndCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-82 unsigned long pt_HiddenSector;	// 08 sectors preceding partition

pt_HiddenSector dd 0
;-83 unsigned long pt_PartLen;    	// 12 length of partition in sectors

pt_PartLen dd 0
;-84 //  16 end hard disk partition structure

;-85 

;-86 //start boot BIOS Parameter Block structure. do not change!!!!!

;-87 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-88 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-89 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-90 unsigned char bs_clust_size;// 13 sectors per CurrentCluster (1,2,4,..,128)

bs_clust_size db 0
;-91 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-92 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-93 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-94 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-95 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-96 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-97 unsigned int  bs_sectors_per_track; // 24 (DOS 3+)sectors per track

bs_sectors_per_track dw 0
;-98 unsigned int  bs_num_heads;	// 26 (DOS 3+)number of heads

bs_num_heads dw 0
;-99 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors

bs_hid_sects dd 0
;-100 unsigned long bs_tot_sect32;// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-101 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-102 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-103 unsigned char bs_ext_signat;// 38 (DOS 4+) Ext. signature,get next 3(29h)

bs_ext_signat db 0
;-104 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-105 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-106 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-107 // 62 end boot BIOS Parameter Block

;-108 

;-109 //start directory entry structure, do not change!!!!!

;-110 unsigned char dir_Filename[]="1234567";	//00 +lengthbyte=11

dir_Filename db "1234567",0
;-111 unsigned char dir_Ext[]="12";	//07 +lengthbyte=3

dir_Ext db "12",0
;-112 unsigned char dir_Attrib;		//11 directory=10h, Label=08h, read only=1

dir_Attrib db 0
;-113 unsigned char dir_NTReserved;	//12 low case in body=8h, in ext=10h

dir_NTReserved db 0
;-114 unsigned char dir_TimeCreatedMS;//13 in 10 milliseconda or zero

dir_TimeCreatedMS db 0
;-115 unsigned int  dir_TimeCreated;	//14 creation time, resolution 2 sec. or 0

dir_TimeCreated dw 0
;-116 unsigned int  dir_DateCreated;	//16 creation date or zero

dir_DateCreated dw 0
;-117 unsigned int  dir_DateLastAccessd;		//18 no time info available or zero

dir_DateLastAccessd dw 0
;-118 unsigned int  dir_FirstClusterHiBytes;	//20 FAT12/16 always zero

dir_FirstClusterHiBytes dw 0
;-119 unsigned int  dir_LastModTime;	//22 modification time on closing

dir_LastModTime dw 0
;-120 unsigned int  dir_LastModDate;	//24 modification date on closing

dir_LastModDate dw 0
;-121 unsigned int  dir_FirstCluster;	//26 1.clu. of file data,if filesize=0 then0

dir_FirstCluster dw 0
;-122 unsigned long dir_FileSize;		//28 size in bytes, if directory then zero

dir_FileSize dd 0
;-123 // 32 end direcctory entry structure

;-124 

;-125 int test() {


test: PROC
;-126 	__asm{


;-127 }	}


;-128 

;-129 //------------------------------------   IO  -------------------

;-130 

;-131 int writetty()     {//char in AL

 ret
ENDP

writetty: PROC
;-132     ah=0x0E;

 mov  ah, 14
;-133     push bx;

push bx;
;-134     bx=0;			//page in BH

 mov  bx, 0
;-135     inth 0x10;		//16

 int  16
;-136     pop bx;

pop bx;
;-137 }

;-138 int putch(char c)  {

 ret
ENDP

putch: PROC
;-139     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;106 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-140         al=13;

 mov  al, 13
;-141         writetty();

 call writetty
;-142     }

;-143     al=c;

.putch1:
 mov  al, [bp+4]
;-144     writetty();

 call writetty
;-145 }

;-146 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-147     char c;

;-148     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;106 ptr sign byte s = bp+4
;107 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-149         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-150         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-151         s++;

 inc  word[bp+4]
;-152     }

;-153 }

 jmp .cputs2
.cputs3:
;-154 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-155 	char c;

;-156 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;106 ptr sign byte s = bp+4
;107 var sign word len = bp+6
;108 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-157 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-158 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-159 		s++;

 inc  word[bp+4]
;-160 		len--;

 dec  word[bp+6]
;-161 	} while (len > 0);

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-162 }

;-163 

;-164 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-165     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-166     inth 0x16;//AH=Scan code, AL=char

 int  22
;-167 }

;-168 int waitkey() {

 ret
ENDP

waitkey: PROC
;-169     ah=0x11;//get kbd status

 mov  ah, 17
;-170     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-171     //zero flag: 0=IS char, 1=NO char

;-172     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-173 }

;-174 int getkey() {

 ret
ENDP

getkey: PROC
;-175     waitkey();

 call waitkey
;-176     getch();

 call getch
;-177     ah=0;//clear scan code

 mov  ah, 0
;-178     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-179     //put ext code in AX

;-180 }

.getkey6:
;-181 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-182     getkey();

 call getkey
;-183     writetty();//destroys AH

 call writetty
;-184 }

;-185 

;-186 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-187     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;106 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-188     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-189     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-190 }

;-191 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-192     unsigned char nib;

;-193     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;106 var unsg byte c = bp+4
;107 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-194     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-195 }

;-196 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-197     unsigned int half;

;-198     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;106 var unsg word i = bp+4
;107 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-199     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-200 }

;-201 

;-202 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-203     unsigned int e;

;-204     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;106 var unsg word n = bp+4
;107 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-205         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-206         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-207         }

;-208     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-209     n+='0';

 add  word[bp+4], 48
;-210     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-211 }

;-212 

;-213 int printlong(unsigned long L) {

 LEAVE
 ret
ENDP

printlong: PROC
;-214     ax = L;     // get low in ax

;Function : printlong, Number local Var: 1
; # type sign width local variables
;106 var unsg long L = bp+4;
 ENTER  0,0
 mov  ax, [bp+4]
;-215     edx=L;

 mov  edx, [bp+4]
;-216     edx >> 16;  // get high in dx

 shr  edx, 16
;-217 __asm{


;-218   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-219     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-220 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-221     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-222     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-223 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-224     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-225     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-226     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-227     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-228     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-229     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-230     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-231     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-232 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-233 }	writetty();		__asm{


 call writetty

;-234     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-235     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-236     jb      .b             ;Not yet

    jb      .b             ;Not yet
;-237 }


;-238 }

;-239 //--------------------------------  string  ---------------------

;-240 int strlen(char *s) { int c;

 LEAVE
 ret
ENDP

strlen: PROC
;-241     c=0;

;Function : strlen, Number local Var: 2
; # type sign width local variables
;106 ptr sign byte s = bp+4
;107 var sign word c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-242     if (*s == 34) return 0; // "

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 jne .strlen9
 mov ax, 0
 jmp .retnstrlen
;-243     while (*s!=0) {s++; c++;}

.strlen9:
.strlen10:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen11
 inc  word[bp+4]
 inc  word[bp-2]
;-244     return c;

 jmp .strlen10
.strlen11:
 mov ax, [bp-2]
 jmp .retnstrlen
;-245 }

;-246 int strcpy(char *s, char *t) {//new

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-247     while (*t!=0) {

;Function : strcpy, Number local Var: 2
; # type sign width local variables
;106 ptr sign byte s = bp+4
;107 ptr sign byte t = bp+6;
 ENTER  0,0
.strcpy12:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy13
;-248     	*s=*t; s++; t++; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-249     *s=0;

 jmp .strcpy12
.strcpy13:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-250     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-251 }

;-252 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-253     while(*p) {

;Function : eqstr, Number local Var: 2
; # type sign width local variables
;106 ptr sign byte p = bp+4
;107 ptr sign byte q = bp+6;
 ENTER  0,0
.eqstr14:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr15
;-254         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr16
 mov ax, 0
 jmp .retneqstr
;-255         p++;

.eqstr16:
 inc  word[bp+4]
;-256         q++;

 inc  word[bp+6]
;-257     }

;-258     if(*q) return 0;

 jmp .eqstr14
.eqstr15:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr17
 mov ax, 0
 jmp .retneqstr
;-259     return 1;

.eqstr17:
 mov ax, 1
 jmp .retneqstr
;-260 }

;-261 

;-262 int memcmp(char *s, char *t, unsigned int i) {

 .retneqstr:
 LEAVE
 ret
ENDP

memcmp: PROC
;-263     do {

;Function : memcmp, Number local Var: 3
; # type sign width local variables
;106 ptr sign byte s = bp+4
;107 ptr sign byte t = bp+6
;108 var unsg word i = bp+8;
 ENTER  0,0
.memcmp18:
;-264         if (*s < *t) return 0xFFFF;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 jge .memcmp19
 mov ax, 65535
 jmp .retnmemcmp
;-265         if (*s > *t) return 1;

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
;-266         s++; t++; i--;

.memcmp20:
 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-267     } while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcmp21
 jmp .memcmp18
.memcmp21:
;-268     return 0;

 mov ax, 0
 jmp .retnmemcmp
;-269 }

;-270 

;-271 int strcat(char *s, char *t) {

 .retnmemcmp:
 LEAVE
 ret
ENDP

strcat: PROC
;-272     while (*s != 0) s++;

;Function : strcat, Number local Var: 2
; # type sign width local variables
;106 ptr sign byte s = bp+4
;107 ptr sign byte t = bp+6;
 ENTER  0,0
.strcat22:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat23
 inc  word[bp+4]
;-273     strcpy(s, t);

 jmp .strcat22
.strcat23:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4
;-274 }

;-275 int toupper(char *s) {

 LEAVE
 ret
ENDP

toupper: PROC
;-276     while(*s) {

;Function : toupper, Number local Var: 1
; # type sign width local variables
;106 ptr sign byte s = bp+4;
 ENTER  0,0
.toupper24:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper25
;-277         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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
;-278         s++;

.toupper27:
.toupper26:
 inc  word[bp+4]
;-279     }

;-280 }

 jmp .toupper24
.toupper25:
;-281 int strchr(char *s, char c) {

 LEAVE
 ret
ENDP

strchr: PROC
;-282     while(*s) {

;Function : strchr, Number local Var: 2
; # type sign width local variables
;106 ptr sign byte s = bp+4
;107 var sign byte c = bp+6;
 ENTER  0,0
.strchr28:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .strchr29
;-283         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .strchr30
 mov ax, [bp+4]
 jmp .retnstrchr
;-284         s++;

.strchr30:
 inc  word[bp+4]
;-285     }

;-286     return 0;

 jmp .strchr28
.strchr29:
 mov ax, 0
 jmp .retnstrchr
;-287 }

;-288 int memchr(char *s, char c, unsigned int i) {

 .retnstrchr:
 LEAVE
 ret
ENDP

memchr: PROC
;-289     while(i > 0) {

;Function : memchr, Number local Var: 3
; # type sign width local variables
;106 ptr sign byte s = bp+4
;107 var sign byte c = bp+6
;108 var unsg word i = bp+8;
 ENTER  0,0
.memchr31:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr32
;-290         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr33
 mov ax, [bp+4]
 jmp .retnmemchr
;-291         s++; i--;

.memchr33:
 inc  word[bp+4]
 dec  word[bp+8]
;-292     }

;-293     return 0;

 jmp .memchr31
.memchr32:
 mov ax, 0
 jmp .retnmemchr
;-294 }

;-295 int memchr1(char *s, char c, unsigned int i) {

 .retnmemchr:
 LEAVE
 ret
ENDP

memchr1: PROC
;-296 	unsigned int pos;

;-297 	pos=1;

;Function : memchr1, Number local Var: 4
; # type sign width local variables
;106 ptr sign byte s = bp+4
;107 var sign byte c = bp+6
;108 var unsg word i = bp+8
;109 var unsg word pos = bp-2;
 ENTER  2,0
 mov ax, 1
 mov [bp-2], ax
;-298     while(i > 0) {

.memchr134:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr135
;-299         if (*s==c) return pos;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr136
 mov ax, [bp-2]
 jmp .retnmemchr1
;-300         s++; i--; pos++;

.memchr136:
 inc  word[bp+4]
 dec  word[bp+8]
 inc  word[bp-2]
;-301     }

;-302     return 0;

 jmp .memchr134
.memchr135:
 mov ax, 0
 jmp .retnmemchr1
;-303 }

;-304 int instr1(char *s, char c) {

 .retnmemchr1:
 LEAVE
 ret
ENDP

instr1: PROC
;-305     while(*s) {

;Function : instr1, Number local Var: 2
; # type sign width local variables
;106 ptr sign byte s = bp+4
;107 var sign byte c = bp+6;
 ENTER  0,0
.instr137:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .instr138
;-306         if (*s==c) return 1;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .instr139
 mov ax, 1
 jmp .retninstr1
;-307         s++;

.instr139:
 inc  word[bp+4]
;-308     }

;-309     return 0;

 jmp .instr137
.instr138:
 mov ax, 0
 jmp .retninstr1
;-310 }

;-311 

;-312 int memcpy(char *s, char *t, unsigned int i) {

 .retninstr1:
 LEAVE
 ret
ENDP

memcpy: PROC
;-313 	unsigned int r;

;-314 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;106 ptr sign byte s = bp+4
;107 ptr sign byte t = bp+6
;108 var unsg word i = bp+8
;109 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-315 	do {

.memcpy40:
;-316 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-317 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-318 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy41
 jmp .memcpy40
.memcpy41:
;-319 	ax=r;//	return r;

 mov  ax, [bp-2]
;-320 }

;-321 

;-322 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-323     unsigned char c; unsigned char chal; int i; int j; int k;

;-324     j=0;

;Function : mdump, Number local Var: 7
; # type sign width local variables
;106 ptr unsg byte adr = bp+4
;107 var unsg word len = bp+6
;108 var unsg byte c = bp-2
;109 var unsg byte chal = bp-4
;110 var sign word i = bp-6
;111 var sign word j = bp-8
;112 var sign word k = bp-10;
 ENTER  10,0
 mov ax, 0
 mov [bp-8], ax
;-325     k=0;

 mov ax, 0
 mov [bp-10], ax
;-326 	putch(10);

 push 10
 call putch
 add  sp, 2
;-327 	cputs("Ofs=");

 push mdump_0
 call cputs
 add  sp, 2
;-328 	printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-329 	cputs(" Length=");

 push mdump_1
 call cputs
 add  sp, 2
;-330 	printunsign(len);

 push word [bp+6]
 call printunsign
 add  sp, 2
;-331     while (j < len ) {

.mdump42:
 mov ax, [bp-8]
 cmp ax, [bp+6]
 jge .mdump43
;-332 	    k++;;

 inc  word[bp-10]
;-333 	    if (k > 16) {

 mov ax, [bp-10]
 cmp ax, 16
 jle .mdump44
;-334 		    chal = getkey();//remove scan code

 call getkey
 mov [bp-4], al
;-335 		    if (chal =='q') return;

 mov al, [bp-4]
 cmp al, 113
 jne .mdump45
 jmp .retnmdump
;-336 		    k=1;

.mdump45:
 mov ax, 1
 mov [bp-10], ax
;-337 		    putch(10);

 push 10
 call putch
 add  sp, 2
;-338 		    cputs("Ofs=");

 push mdump_2
 call cputs
 add  sp, 2
;-339 		    printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-340 		    }

;-341         putch(10);

.mdump44:
 push 10
 call putch
 add  sp, 2
;-342         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-343         putch(':');

 push 58
 call putch
 add  sp, 2
;-344         i=0;

 mov ax, 0
 mov [bp-6], ax
;-345         while (i < 16) {

.mdump46:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump47
;-346             putch(' ');

 push 32
 call putch
 add  sp, 2
;-347             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-348             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-349             adr++;

 inc  word[bp+4]
;-350             i++;

 inc  word[bp-6]
;-351             j++;

 inc  word[bp-8]
;-352             }

;-353         putch(' ');

 jmp .mdump46
.mdump47:
 push 32
 call putch
 add  sp, 2
;-354         adr -=16;

 sub  word[bp+4], 16
;-355         i=0;

 mov ax, 0
 mov [bp-6], ax
;-356         while(i < 16) {

.mdump48:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump49
;-357             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-358             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump50
 push 46
 call putch
 add  sp, 2
;-359                 else putch(c);

 jmp .mdump51
.mdump50:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-360             adr++;

.mdump51:
 inc  word[bp+4]
;-361             i++;

 inc  word[bp-6]
;-362         }

;-363     }

 jmp .mdump48
.mdump49:
;-364     getkey();

 jmp .mdump42
.mdump43:
 call getkey
;-365     putch(10);

 push 10
 call putch
 add  sp, 2
;-366 

;-367 }

;-368 int dumpASCII(unsigned char *adr, unsigned int len ) {

 .retnmdump:
 LEAVE
 ret
mdump_0 db "Ofs=",0
mdump_1 db " Length=",0
mdump_2 db "Ofs=",0
ENDP

dumpASCII: PROC
;-369     unsigned char c; unsigned char chal; int i; int j; int k;

;-370     j=0;

;Function : dumpASCII, Number local Var: 7
; # type sign width local variables
;106 ptr unsg byte adr = bp+4
;107 var unsg word len = bp+6
;108 var unsg byte c = bp-2
;109 var unsg byte chal = bp-4
;110 var sign word i = bp-6
;111 var sign word j = bp-8
;112 var sign word k = bp-10;
 ENTER  10,0
 mov ax, 0
 mov [bp-8], ax
;-371     k=0;

 mov ax, 0
 mov [bp-10], ax
;-372 	putch(10);

 push 10
 call putch
 add  sp, 2
;-373 	cputs("Ofs=");

 push dumpASCII_0
 call cputs
 add  sp, 2
;-374 	printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-375 	cputs(" Length=");

 push dumpASCII_1
 call cputs
 add  sp, 2
;-376 	printunsign(len);

 push word [bp+6]
 call printunsign
 add  sp, 2
;-377 	cputs(" Handle=");

 push dumpASCII_2
 call cputs
 add  sp, 2
;-378 	printunsign(handle);

 mov al, byte [handle]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-379     while (j < len ) {

.dumpASCII52:
 mov ax, [bp-8]
 cmp ax, [bp+6]
 jge .dumpASCII53
;-380 	    k++;;

 inc  word[bp-10]
;-381 	    if (k > 16) {

 mov ax, [bp-10]
 cmp ax, 16
 jle .dumpASCII54
;-382 		    chal = getkey();//remove scan code

 call getkey
 mov [bp-4], al
;-383 		    if (chal =='q') return;

 mov al, [bp-4]
 cmp al, 113
 jne .dumpASCII55
 jmp .retndumpASCII
;-384 		    k=1;

.dumpASCII55:
 mov ax, 1
 mov [bp-10], ax
;-385 		    putch(10);

 push 10
 call putch
 add  sp, 2
;-386 		    cputs("Ofs=");

 push dumpASCII_3
 call cputs
 add  sp, 2
;-387 		    printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-388 		    }

;-389         putch(10);

.dumpASCII54:
 push 10
 call putch
 add  sp, 2
;-390         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-391         putch(':');

 push 58
 call putch
 add  sp, 2
;-392         i=0;

 mov ax, 0
 mov [bp-6], ax
;-393         while(i < 64) {

.dumpASCII56:
 mov ax, [bp-6]
 cmp ax, 64
 jge .dumpASCII57
;-394             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-395             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .dumpASCII58
 push 46
 call putch
 add  sp, 2
;-396                 else putch(c);

 jmp .dumpASCII59
.dumpASCII58:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-397             adr++;

.dumpASCII59:
 inc  word[bp+4]
;-398             i++;

 inc  word[bp-6]
;-399             j++;

 inc  word[bp-8]
;-400         }

;-401     }

 jmp .dumpASCII56
.dumpASCII57:
;-402     getkey();

 jmp .dumpASCII52
.dumpASCII53:
 call getkey
;-403     putch(10);

 push 10
 call putch
 add  sp, 2
;-404 

;-405 }

;-406 

;-407 //--------------------------------  disk IO  -------------------

;-408 

;-409 int DiskSectorReadWrite(char rw, char drive, char head, int cyl,

 .retndumpASCII:
 LEAVE
 ret
dumpASCII_0 db "Ofs=",0
dumpASCII_1 db " Length=",0
dumpASCII_2 db " Handle=",0
dumpASCII_3 db "Ofs=",0
ENDP

DiskSectorReadWrite: PROC
;-410 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-411 	BIOS_ERR=0;

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;106 var sign byte rw = bp+4
;107 var sign byte drive = bp+6
;108 var sign byte head = bp+8
;109 var sign word cyl = bp+10
;110 var sign byte sector = bp+12
;111 var sign byte count = bp+14
;112 var sign word BufSeg = bp+16
;113 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-412 	dl=drive;

 mov  dl, [bp+6]
;-413 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-414 	es=BufSeg;

 mov  es, [bp+16]
;-415 	bx=BufOfs;

 mov  bx, [bp+18]
;-416 	cx=cyl;

 mov  cx, [bp+10]
;-417 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-418 	cx >> 2;//in 2 high bits of cl

 shr  cx, 2
;-419 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-420 	cl += sector;

 add  cl, [bp+12]
;-421 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-422 	al=count;

 mov  al, [bp+14]
;-423 	ah=rw;

 mov  ah, [bp+4]
;-424 	inth 0x13;

 int  19
;-425     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-426 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-427 }

;-428 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-429 	BIOS_ERR=0;

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;106 var sign byte drive = bp+4
;107 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-430 	dl=drive;

 mov  dl, [bp+4]
;-431 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-432 	inth 0x13;

 int  19
;-433     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-434 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-435 }

;-436 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-437 	cputs("*** DISK ERROR *** AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-438 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-439 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-440 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-441 }

;-442 int Status(drive) {

 ret
Int13hError_0 db "*** DISK ERROR *** AX=",0
Int13hError_1 db ".  ",0
ENDP

Status: PROC
;-443 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;106 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-444 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-445 	BIOS_Status=Int13hfunction(drive, 1);

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-446 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Status60
 call Int13hError
;-447 	printhex16(BIOS_Status);

.Status60:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-448 }

;-449 

;-450 int Params() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

Params: PROC
;-451 	if (debug) cputs(" DriveParams");

 mov ax, 1
 or  al, al
 je .Params61
 push Params_0
 call cputs
 add  sp, 2
;-452 	BIOS_Status=Int13hfunction(Drive, 8);

.Params61:
 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-453 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params62
;-454 		Int13hError();

 call Int13hError
;-455 		return 1;

 mov ax, 1
 jmp .retnParams
;-456 		}

;-457 	else {

 jmp .Params63
.Params62:
;-458 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-459 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-460 		// CX =       ---CH--- ---CL---

;-461 		// cylinder : 76543210 98

;-462 		// sector   :            543210

;-463 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-464 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-465 //		pa_Sectors++;//1 to 64

;-466 

;-467 		asm mov [pa_Cylinders],    cx

 mov [pa_Cylinders],    cx
;-468 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-469 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-470 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty

 add [pa_Cylinders],    ch;//byte add, low byte is empty
;-471 

;-472 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params64
;-473 			cputs(" ** no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-474 			return 1;

 mov ax, 1
 jmp .retnParams
;-475 			}

;-476 	}

.Params64:
;-477 	return 0;

.Params63:
 mov ax, 0
 jmp .retnParams
;-478 }

;-479 

;-480 

;-481 int getPartitionData() {

 .retnParams:
 ret
Params_0 db " DriveParams",0
Params_1 db " ** no hard disk found",0
ENDP

getPartitionData: PROC
;-482 	unsigned int j; char c; char *p;

;-483 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;106 var unsg word j = bp-2
;107 var sign byte c = bp-4
;108 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [pt_PartNo]
 shl ax, 4
 mov [bp-2], ax
;-484 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-485 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-486 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-487 	pt_StartCylinder=(int)pt_StartSector;

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-488 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-489 //	pt_StartSector++;//Sector start with 1 todo

;-490 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-491 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-492 	j++;

 inc  word[bp-2]
;-493 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-494 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-495 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB

;-496 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-497 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-498 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-499 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-500 //	pt_EndSector++;//Sector start with 1 todo

;-501 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-502 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-503 	j++;

 inc  word[bp-2]
;-504 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-505 	j++;

 inc  word[bp-2]
;-506 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-507 	memcpy(&pt_HiddenSector, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-508 }

;-509 

;-510 int checkBootSign() {

 LEAVE
 ret
ENDP

checkBootSign: PROC
;-511 	int i;

;-512 	i=510;

;Function : checkBootSign, Number local Var: 1
; # type sign width local variables
;106 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-513 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign65
;-514 		i++;

 inc  word[bp-2]
;-515 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign66
 mov ax, 1
 jmp .retncheckBootSign
;-516 	}

.checkBootSign66:
;-517 	cputs("  **Magic number NOT found.");

.checkBootSign65:
 push checkBootSign_0
 call cputs
 add  sp, 2
;-518 	return 0;

 mov ax, 0
 jmp .retncheckBootSign
;-519 }

;-520 

;-521 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db "  **Magic number NOT found.",0
ENDP

readMBR: PROC
;-522 	int isFAT;

;-523 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;106 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-524 	pt_PartNo=0;

 mov ax, 0
 mov word [pt_PartNo], ax
;-525 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-526 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR67
;-527 		Int13hError();

 call Int13hError
;-528 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-529 		}

;-530 	else {

 jmp .readMBR68
.readMBR67:
;-531 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .readMBR69
 mov ax, 0
 jmp .retnreadMBR
;-532 		do {

.readMBR69:
.readMBR70:
;-533 			getPartitionData();

 call getPartitionData
;-534 

;-535 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR71
;-536 				if (debug) cputs(" Boot part. found");

 mov ax, 1
 or  al, al
 je .readMBR72
 push readMBR_0
 call cputs
 add  sp, 2
;-537 				if (pt_FileSystem == 1) {

.readMBR72:
 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR73
;-538 					cputs(", FAT12 part. <32MB");

 push readMBR_1
 call cputs
 add  sp, 2
;-539 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-540 					}

;-541 				if (pt_FileSystem == 4) {

.readMBR73:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR74
;-542 					cputs(", small FAT16 part.<32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-543 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-544 					}

;-545 				if (pt_FileSystem == 6) {

.readMBR74:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR75
;-546 					if (debug) cputs(", large FAT16 part.");

 mov ax, 1
 or  al, al
 je .readMBR76
 push readMBR_3
 call cputs
 add  sp, 2
;-547 					isFAT=6;

.readMBR76:
 mov ax, 6
 mov [bp-2], ax
;-548 					}

;-549 				pt_PartNo=99;//end of loop

.readMBR75:
 mov ax, 99
 mov word [pt_PartNo], ax
;-550 			}

;-551 			pt_PartNo ++;

.readMBR71:
 inc  word[pt_PartNo]
;-552 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR77
 jmp .readMBR70
.readMBR77:
;-553 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-554 	}

;-555 }

.readMBR68:
;-556 

;-557 int getBootSector() {

 .retnreadMBR:
 LEAVE
 ret
readMBR_0 db " Boot part. found",0
readMBR_1 db ", FAT12 part. <32MB",0
readMBR_2 db ", small FAT16 part.<32MB",0
readMBR_3 db ", large FAT16 part.",0
ENDP

getBootSector: PROC
;-558 	int i;

;-559 	if (debug) cputs(" Boot sector:");

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;106 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 1
 or  al, al
 je .getBootSector78
 push getBootSector_0
 call cputs
 add  sp, 2
;-560   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

.getBootSector78:
;-561   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-562 	if (debug) printhex16(BIOS_Status);

 mov ax, 1
 or  al, al
 je .getBootSector79
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-563 	if (BIOS_ERR) {

.getBootSector79:
 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector80
;-564 		Int13hError();

 call Int13hError
;-565 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-566 		}

;-567 	else {

 jmp .getBootSector81
.getBootSector80:
;-568 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .getBootSector82
 mov ax, 0
 jmp .retngetBootSector
;-569 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector82:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-570 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector83
 push getBootSector_1
 call cputs
 add  sp, 2
;-571 		i=2;

.getBootSector83:
 mov ax, 2
 mov [bp-2], ax
;-572 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector84
 push getBootSector_2
 call cputs
 add  sp, 2
;-573 	}

.getBootSector84:
;-574 	return 1;

.getBootSector81:
 mov ax, 1
 jmp .retngetBootSector
;-575 }

;-576 

;-577 int FATInit() {

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Boot sector:",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-578 	unsigned long templong;//converting word to dword

;-579 

;-580 	clust_sizeL = (long) bs_clust_size;

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;106 var unsg long templong = bp-4;
 ENTER  4,0
 xor eax, eax
 mov al, [bs_clust_size]
 mov dword [clust_sizeL], eax
;-581 	sector_sizeL= (long) bs_sect_size;

 xor eax, eax
 mov ax, [bs_sect_size]
 mov dword [sector_sizeL], eax
;-582 

;-583 	fat_FatStartSector = bs_res_sects;

 mov ax, [bs_res_sects]
 mov word [fat_FatStartSector], ax
;-584 	fat_FatStartSectorL= (long) fat_FatStartSector; 

 xor eax, eax
 mov ax, [fat_FatStartSector]
 mov dword [fat_FatStartSectorL], eax
;-585 	fat_FatSectors = bs_fat_size;

 mov ax, [bs_fat_size]
 mov word [fat_FatSectors], ax
;-586 	if (bs_num_fats == 2) fat_FatSectors=fat_FatSectors+fat_FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .FATInit85
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-587 

;-588 	fat_Entries = bs_fat_size >> 1;//2 bytes for one entry

.FATInit85:
 mov ax, [bs_fat_size]
 shr ax, 1
 mov word [fat_Entries], ax
;-589 	fat_Entries -=2;//first 2 entries not used

 sub  word[fat_Entries], 2
;-590 	

;-591 	fat_RootDirStartSectorL = (long)fat_FatStartSector + fat_FatSectors;

 xor eax, eax
 mov ax, [fat_FatStartSector]
 add ax, [fat_FatSectors]
 mov dword [fat_RootDirStartSectorL], eax
;-592 	

;-593 	fat_RootDirSectorsL = (long) bs_root_entr >> 4;//  ./. 16

 xor eax, eax
 mov ax, [bs_root_entr]
 shr ax, 4
 mov dword [fat_RootDirSectorsL], eax
;-594 		

;-595 	fat_DataStartSectorL = fat_RootDirStartSectorL + fat_RootDirSectorsL;

 mov eax, [fat_RootDirStartSectorL]
 add eax, [fat_RootDirSectorsL]
 mov dword [fat_DataStartSectorL], eax
;-596 

;-597 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .FATInit86
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-598 	DataSectors32=bs_tot_sect32 - fat_DataStartSectorL;

.FATInit86:
 mov eax, [bs_tot_sect32]
 sub eax, [fat_DataStartSectorL]
 mov dword [DataSectors32], eax
;-599 

;-600 	CountofClustersL=DataSectors32 / clust_sizeL;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [clust_sizeL]
 mov dword [CountofClustersL], eax
;-601 

;-602 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-603 	num_tracksL = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [num_tracksL], eax
;-604 

;-605 //	templong = (long) bs_num_heads;

;-606 //	fat_num_cylinders = num_tracksL / templong;//w=d/w

;-607 	

;-608 	bytes_per_clusterL = (long) bs_clust_size * bs_sect_size;

 xor eax, eax
 mov al, [bs_clust_size]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_sect_size]
 mov dword [bytes_per_clusterL], eax
;-609 

;-610 	Sectors_per_cylinderL = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinderL], eax
;-611 	asm mov [Sectors_per_cylinderL + 2], dx;store high word

 mov [Sectors_per_cylinderL + 2], dx;store high word
;-612 

;-613 	templong = (long) 65525;

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-614 	if (CountofClustersL > templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jle .FATInit87
;-615 		trueFATtype=32;

 mov ax, 32
 mov byte [trueFATtype], al
;-616 		cputs(" FAT32 NOT supported");

 push FATInit_0
 call cputs
 add  sp, 2
;-617 		return 1;

 mov ax, 1
 jmp .retnFATInit
;-618 		}

;-619 	templong= (long) 4086;

.FATInit87:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-620 	if (CountofClustersL < templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jge .FATInit88
;-621 		trueFATtype=12;

 mov ax, 12
 mov byte [trueFATtype], al
;-622 		cputs(" FAT12");

 push FATInit_1
 call cputs
 add  sp, 2
;-623 		return 0;

 mov ax, 0
 jmp .retnFATInit
;-624 		}

;-625 	trueFATtype=16;

.FATInit88:
 mov ax, 16
 mov byte [trueFATtype], al
;-626 	if (debug) cputs(" FAT16");

 mov ax, 1
 or  al, al
 je .FATInit89
 push FATInit_2
 call cputs
 add  sp, 2
;-627 	return 0;

.FATInit89:
 mov ax, 0
 jmp .retnFATInit
;-628 }

;-629 

;-630 int Int13hExt() {

 .retnFATInit:
 LEAVE
 ret
FATInit_0 db " FAT32 NOT supported",0
FATInit_1 db " FAT12",0
FATInit_2 db " FAT16",0
ENDP

Int13hExt: PROC
;-631 	bx=0x55AA;

 mov  bx, 21930
;-632 	BIOS_Status=Int13hfunction(Drive, 0x41);

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-633 	asm mov [vAX], ax;

 mov [vAX], ax;
;-634 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-635 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported
;-636 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt90
;-637 		cputs(" Ext. NOT present");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-638 		Int13hError();

 call Int13hError
;-639 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-640 		}

;-641 	else if (debug) cputs(",Int13h Ext.");

 jmp .Int13hExt91
.Int13hExt90:
 mov ax, 1
 or  al, al
 je .Int13hExt92
 push Int13hExt_1
 call cputs
 add  sp, 2
;-642 	putch(10);

.Int13hExt92:
.Int13hExt91:
 push 10
 call putch
 add  sp, 2
;-643 	return 0;

 mov ax, 0
 jmp .retnInt13hExt
;-644 }

;-645 

;-646 int PrintDriveParameter() {

 .retnInt13hExt:
 ret
Int13hExt_0 db " Ext. NOT present",0
Int13hExt_1 db ",Int13h Ext.",0
ENDP

PrintDriveParameter: PROC
;-647 	unsigned long Lo;

;-648 // from Params

;-649 	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);

;Function : PrintDriveParameter, Number local Var: 1
; # type sign width local variables
;106 var unsg long Lo = bp-4;
 ENTER  4,0
 push PrintDriveParameter_0
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-650 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-651 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-652 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-653 	putch('.');

 push 46
 call putch
 add  sp, 2
;-654 //from getPartitionData

;-655 	putch(10);

 push 10
 call putch
 add  sp, 2
;-656 	cputs("getPartitionData:No=");printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-657 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-658 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-659 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-660 	cputs("/");				printunsign(pt_StartSector);

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-661 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-662 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-663 	cputs("/");				printunsign(pt_EndSector);

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-664 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-665 	cputs(",Start=");		printlong(pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 push dword [pt_HiddenSector]
 call printlong
 add  sp, 4
;-666 	cputs(",Len=");			printlong(pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 push dword [pt_PartLen]
 call printlong
 add  sp, 4
;-667 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-668 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-669 	printlong(Lo);

 push dword [bp-4]
 call printlong
 add  sp, 4
;-670 	cputs(" MByte.");

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-671 //from getBootSector

;-672 	putch(10);

 push 10
 call putch
 add  sp, 2
;-673 	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-674 	putch(10);

 push 10
 call putch
 add  sp, 2
;-675 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-676 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-677 	putch(10);

 push 10
 call putch
 add  sp, 2
;-678 	cputs("Reserved sectors=");printunsign(bs_res_sects);

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-679 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-680 	putch(10);

 push 10
 call putch
 add  sp, 2
;-681 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-682 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-683 	putch(10);

 push 10
 call putch
 add  sp, 2
;-684 	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-685 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-686 	putch(10);

 push 10
 call putch
 add  sp, 2
;-687 	cputs("sectors per track=");printunsign(bs_sectors_per_track);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_sectors_per_track]
 call printunsign
 add  sp, 2
;-688 	cputs(".number of heads=");printunsign(bs_num_heads);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_heads]
 call printunsign
 add  sp, 2
;-689 	putch(10);

 push 10
 call putch
 add  sp, 2
;-690 	cputs("hidden sectors(long)=");printlong(bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 push dword [bs_hid_sects]
 call printlong
 add  sp, 4
;-691 	cputs(".sectors(long)=");printlong(bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 push dword [bs_tot_sect32]
 call printlong
 add  sp, 4
;-692 	putch(10);

 push 10
 call putch
 add  sp, 2
;-693 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-694 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-695 	putch(10);

 push 10
 call putch
 add  sp, 2
;-696 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-697 	cputs(".Volume serial(long)=");printlong(bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 push dword [bs_serial_num]
 call printlong
 add  sp, 4
;-698 	putch(10);

 push 10
 call putch
 add  sp, 2
;-699 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-700 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-701 //from FATInit

;-702 	putch(10);

 push 10
 call putch
 add  sp, 2
;-703 	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [fat_FatStartSector]
 call printunsign
 add  sp, 2
;-704 	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [fat_FatSectors]
 call printunsign
 add  sp, 2
;-705 	cputs(", fat_Entries=");	printunsign(fat_Entries);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push word [fat_Entries]
 call printunsign
 add  sp, 2
;-706 	putch(10);

 push 10
 call putch
 add  sp, 2
;-707 	cputs("fat_RootDirStartSectorL="); printlong(fat_RootDirStartSectorL);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push dword [fat_RootDirStartSectorL]
 call printlong
 add  sp, 4
;-708 	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectorsL);

 push PrintDriveParameter_38
 call cputs
 add  sp, 2
 push dword [fat_RootDirSectorsL]
 call printunsign
 add  sp, 4
;-709 	putch(10);

 push 10
 call putch
 add  sp, 2
;-710 	cputs("fat_DataStartSectorL=");	printunsign(fat_DataStartSectorL);

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 push dword [fat_DataStartSectorL]
 call printunsign
 add  sp, 4
;-711 	cputs(", DataSectors32=");	printlong(DataSectors32);

 push PrintDriveParameter_40
 call cputs
 add  sp, 2
 push dword [DataSectors32]
 call printlong
 add  sp, 4
;-712 	putch(10);

 push 10
 call putch
 add  sp, 2
;-713 	cputs("CountofClustersL=");	printlong(CountofClustersL);

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 push dword [CountofClustersL]
 call printlong
 add  sp, 4
;-714 	cputs(", Sectors_per_cylinderL="); printlong(Sectors_per_cylinderL);

 push PrintDriveParameter_42
 call cputs
 add  sp, 2
 push dword [Sectors_per_cylinderL]
 call printlong
 add  sp, 4
;-715 	putch(10);

 push 10
 call putch
 add  sp, 2
;-716 	cputs("num_tracksL=");	printlong(num_tracksL);

 push PrintDriveParameter_43
 call cputs
 add  sp, 2
 push dword [num_tracksL]
 call printlong
 add  sp, 4
;-717 	cputs(", bytes_per_clusterL=");	printlong(bytes_per_clusterL);

 push PrintDriveParameter_44
 call cputs
 add  sp, 2
 push dword [bytes_per_clusterL]
 call printlong
 add  sp, 4
;-718 //	cputs(", fat_num_cylinders="); printunsign(fat_num_cylinders);

;-719 	putch(10);

 push 10
 call putch
 add  sp, 2
;-720 	getkey();

 call getkey
;-721 }

;-722 

;-723 //--------------------------------  file IO  -------------------

;-724 int error2(char *s) {

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
PrintDriveParameter_36 db ", fat_Entries=",0
PrintDriveParameter_37 db "fat_RootDirStartSectorL=",0
PrintDriveParameter_38 db ", fat_RootDirSectors=",0
PrintDriveParameter_39 db "fat_DataStartSectorL=",0
PrintDriveParameter_40 db ", DataSectors32=",0
PrintDriveParameter_41 db "CountofClustersL=",0
PrintDriveParameter_42 db ", Sectors_per_cylinderL=",0
PrintDriveParameter_43 db "num_tracksL=",0
PrintDriveParameter_44 db ", bytes_per_clusterL=",0
ENDP

error2: PROC
;-725 	putch(10);

;Function : error2, Number local Var: 1
; # type sign width local variables
;106 ptr sign byte s = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-726 	cputs("*** ERROR *** ");

 push error2_0
 call cputs
 add  sp, 2
;-727 	cputs(s);

 push word [bp+4]
 call cputs
 add  sp, 2
;-728 	DOS_ERR++;

 inc  byte[DOS_ERR]
;-729 }

;-730 // 1.

;-731 int readLogical(unsigned long SectorL,unsigned int DSeg, unsigned int DOfs){

 LEAVE
 ret
error2_0 db "*** ERROR *** ",0
ENDP

readLogical: PROC
;-732 	//OUT:1 sector in DiskBuf

;-733 	unsigned int track; unsigned int head; unsigned int sect;

;-734 	SectorL = SectorL + bs_hid_sects;//d=d+d

;Function : readLogical, Number local Var: 6
; # type sign width local variables
;106 var unsg long SectorL = bp+4
;107 var unsg word DSeg = bp+8
;108 var unsg word DOfs = bp+10
;109 var unsg word track = bp-2
;110 var unsg word head = bp-4
;111 var unsg word sect = bp-6;
 ENTER  6,0
 mov eax, [bp+4]
 add eax, [bs_hid_sects]
 mov [bp+4], eax
;-735 	track = SectorL / Sectors_per_cylinderL;  //w=d/d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinderL]
 mov [bp-2], ax
;-736 	head  = SectorL % Sectors_per_cylinderL;  //w=d%d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinderL]
 mov eax, edx
 mov [bp-4], ax
;-737 	sect  = head            % bs_sectors_per_track;  //w=w%w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov ax, dx
 mov [bp-6], ax
;-738 	sect++;

 inc  word[bp-6]
;-739 	head  = head            / bs_sectors_per_track;	 //w=w/w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov [bp-4], ax
;-740 

;-741 	DiskSectorReadWrite(2, bs_drive_num, head, track/* =cyl */,

;-742 		sect, 1, DSeg , DOfs);

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
;-743 }

;-744 // 2.a

;-745 int printDirEntry(int EntryNr) {

 LEAVE
 ret
ENDP

printDirEntry: PROC
;-746     unsigned int j;

;-747 	putch(10);

;Function : printDirEntry, Number local Var: 2
; # type sign width local variables
;106 var sign word EntryNr = bp+4
;107 var unsg word j = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-748 	printunsign(EntryNr);

 push word [bp+4]
 call printunsign
 add  sp, 2
;-749 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-750 	cputs(filename);

 lea  ax, [filename]
 push ax
 call cputs
 add  sp, 2
;-751 	cputs(" ATTR:");

 push printDirEntry_0
 call cputs
 add  sp, 2
;-752 	printhex8(dir_Attrib);	

 mov al, byte [dir_Attrib]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-753 	if (dir_Attrib &  1) cputs(" r/o");

 mov al, [dir_Attrib]
 and al, 1
 or  al, al
 je .printDirEntry93
 push printDirEntry_1
 call cputs
 add  sp, 2
;-754 	if (dir_Attrib &  2) cputs(" hid");

.printDirEntry93:
 mov al, [dir_Attrib]
 and al, 2
 or  al, al
 je .printDirEntry94
 push printDirEntry_2
 call cputs
 add  sp, 2
;-755 	if (dir_Attrib &  4) cputs(" sys");

.printDirEntry94:
 mov al, [dir_Attrib]
 and al, 4
 or  al, al
 je .printDirEntry95
 push printDirEntry_3
 call cputs
 add  sp, 2
;-756 	if (dir_Attrib &  8) cputs(" vol");		

.printDirEntry95:
 mov al, [dir_Attrib]
 and al, 8
 or  al, al
 je .printDirEntry96
 push printDirEntry_4
 call cputs
 add  sp, 2
;-757 	if (dir_Attrib & 16) cputs(" dir");

.printDirEntry96:
 mov al, [dir_Attrib]
 and al, 16
 or  al, al
 je .printDirEntry97
 push printDirEntry_5
 call cputs
 add  sp, 2
;-758 	if (dir_Attrib & 32) cputs(" arc");

.printDirEntry97:
 mov al, [dir_Attrib]
 and al, 32
 or  al, al
 je .printDirEntry98
 push printDirEntry_6
 call cputs
 add  sp, 2
;-759 	if (dir_Attrib == 0) cputs("    ");

.printDirEntry98:
 mov al, [dir_Attrib]
 cmp al, 0
 jne .printDirEntry99
 push printDirEntry_7
 call cputs
 add  sp, 2
;-760 	

;-761 	putch(' ');

.printDirEntry99:
 push 32
 call putch
 add  sp, 2
;-762 	j=dir_LastModDate & 31;//day

 mov ax, [dir_LastModDate]
 and ax, 31
 mov [bp-2], ax
;-763 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry100
 push 32
 call putch
 add  sp, 2
;-764 	printunsign(j);

.printDirEntry100:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-765 	putch('.');

 push 46
 call putch
 add  sp, 2
;-766 

;-767 	j=dir_LastModDate >> 5;//month

 mov ax, [dir_LastModDate]
 shr ax, 5
 mov [bp-2], ax
;-768 	j&=  15;

 and  word[bp-2], 15
;-769 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry101
 push 48
 call putch
 add  sp, 2
;-770 	printunsign(j);

.printDirEntry101:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-771 	putch('.');

 push 46
 call putch
 add  sp, 2
;-772 

;-773 	j=dir_LastModDate >> 9;//year

 mov ax, [dir_LastModDate]
 shr ax, 9
 mov [bp-2], ax
;-774 	j+= 1980;

 add  word[bp-2], 1980
;-775 	printunsign(j);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-776 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-777 	//putch(' ');

;-778 

;-779 	j=dir_LastModTime  >>11;//hour

 mov ax, [dir_LastModTime]
 shr ax, 11
 mov [bp-2], ax
;-780 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry102
 push 32
 call putch
 add  sp, 2
;-781 	printunsign(j);

.printDirEntry102:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-782 	putch(':');

 push 58
 call putch
 add  sp, 2
;-783 

;-784 	j=dir_LastModTime  >> 5;//minute

 mov ax, [dir_LastModTime]
 shr ax, 5
 mov [bp-2], ax
;-785 	j&=  63;

 and  word[bp-2], 63
;-786 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry103
 push 48
 call putch
 add  sp, 2
;-787 	printunsign(j);

.printDirEntry103:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-788 	putch(':');

 push 58
 call putch
 add  sp, 2
;-789 

;-790 	j=dir_LastModTime & 31;// 2 seconds

 mov ax, [dir_LastModTime]
 and ax, 31
 mov [bp-2], ax
;-791 	j=j+j;

 mov ax, [bp-2]
 add ax, [bp-2]
 mov [bp-2], ax
;-792 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry104
 push 48
 call putch
 add  sp, 2
;-793 	printunsign(j);

.printDirEntry104:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-794 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-795 

;-796 	cputs(" 1.Cl:"); 

 push printDirEntry_8
 call cputs
 add  sp, 2
;-797 	printunsign(dir_FirstCluster);

 push word [dir_FirstCluster]
 call printunsign
 add  sp, 2
;-798 	cputs(" Size:");

 push printDirEntry_9
 call cputs
 add  sp, 2
;-799 	printlong(dir_FileSize);

 push dword [dir_FileSize]
 call printlong
 add  sp, 4
;-800 	

;-801 }

;-802 

;-803 // 2.b

;-804 int fatDirSectorList(unsigned long startSector, unsigned long numsectors) {

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
;-805     char *p;

;-806 	unsigned int EndDiskBuf;

;-807 	char isHide;//shows entries, NOT lfn, deleted or empty

;-808 	unsigned int EntryNr;

;-809 	EntryNr=0;

;Function : fatDirSectorList, Number local Var: 6
; # type sign width local variables
;106 var unsg long startSector = bp+4
;107 var unsg long numsectors = bp+8
;108 ptr sign byte p = bp-2
;109 var unsg word EndDiskBuf = bp-4
;110 var sign byte isHide = bp-6
;111 var unsg word EntryNr = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-8], ax
;-810 	do {

.fatDirSectorList105:
;-811 /*		putch(10);

;-812 		cputs("Sektor = "); 

;-813 		printlong(startSector);

;-814 		cputs(", numsectors = "); 

;-815 		printlong(numsectors);

;-816 		getkey();

;-817 */

;-818 		readLogical(startSector, DiskBufSeg, DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp+4]
 call readLogical
 add  sp, 8
;-819 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-820 		EndDiskBuf= p + bs_sect_size;		

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-821 		

;-822 		do {

.fatDirSectorList106:
;-823 			memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-824 			memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-825 			filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-826 			

;-827 			isHide=0;//show in listing

 mov ax, 0
 mov [bp-6], al
;-828 			if (*p ==    0) {//only empty entries following

 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorList107
;-829 				isHide++;

 inc  byte[bp-6]
;-830 				numsectors=1;//finish searching

 mov ax, 1
 mov [bp+8], eax
;-831 				p = EndDiskBuf;

 mov ax, [bp-4]
 mov [bp-2], ax
;-832 				}

;-833 			if (*p == 0xE5) isHide++;//deleted, free entry

.fatDirSectorList107:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 229
 jne .fatDirSectorList108
 inc  byte[bp-6]
;-834 			if (*p <=   31) isHide++;//part of LFN

.fatDirSectorList108:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 31
 jg  .fatDirSectorList109
 inc  byte[bp-6]
;-835 			if (dir_Attrib ==    15) isHide++;//LFN start

.fatDirSectorList109:
 mov al, [dir_Attrib]
 cmp al, 15
 jne .fatDirSectorList110
 inc  byte[bp-6]
;-836 					

;-837 			if (isHide == 0) printDirEntry(EntryNr);

.fatDirSectorList110:
 mov al, [bp-6]
 cmp al, 0
 jne .fatDirSectorList111
 push word [bp-8]
 call printDirEntry
 add  sp, 2
;-838 			p+=32;//get next entry

.fatDirSectorList111:
 add  word[bp-2], 32
;-839 			EntryNr++;

 inc  word[bp-8]
;-840 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorList112
 jmp .fatDirSectorList106
.fatDirSectorList112:
;-841 		startSector = startSector + 1;//long, do NOT use ++ or +=1

 mov eax, [bp+4]
 add eax, 1
 mov [bp+4], eax
;-842 		numsectors--;

 dec  dword[bp+8]
;-843 //mdump(DiskBuf, 512);

;-844 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorList113
 jmp .fatDirSectorList105
.fatDirSectorList113:
;-845 	CurrentCluster=0;//not found but not end

 mov ax, 0
 mov word [CurrentCluster], ax
;-846 }

;-847 

;-848 // 2.

;-849 int fatDirSectorSearch(unsigned long startSector,unsigned long numsectors) {

 LEAVE
 ret
ENDP

fatDirSectorSearch: PROC
;-850     //search for file name. IN:searchstr

;-851     char *p;

;-852 	unsigned int EndDiskBuf;

;-853 	fatfound=0;

;Function : fatDirSectorSearch, Number local Var: 4
; # type sign width local variables
;106 var unsg long startSector = bp+4
;107 var unsg long numsectors = bp+8
;108 ptr sign byte p = bp-2
;109 var unsg word EndDiskBuf = bp-4;
 ENTER  4,0
 mov ax, 0
 mov byte [fatfound], al
;-854 	do {

.fatDirSectorSearch114:
;-855 		readLogical(startSector, DiskBufSeg, DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp+4]
 call readLogical
 add  sp, 8
;-856 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-857 		EndDiskBuf= p + bs_sect_size;

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-858 		do {

.fatDirSectorSearch115:
;-859 			if (memcmp(p, searchstr, 11) == 0) {//found file name

 push 11
 lea  ax, [searchstr]
 push ax
 push word [bp-2]
 call memcmp
 add  sp, 6
 cmp ax, 0
 jne .fatDirSectorSearch116
;-860 				memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-861 				memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-862 				filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-863 				CurrentCluster   = dir_FirstCluster;

 mov ax, [dir_FirstCluster]
 mov word [CurrentCluster], ax
;-864 				FileSizeL  = dir_FileSize;

 mov eax, [dir_FileSize]
 mov dword [FileSizeL], eax
;-865 				fatfound=1;

 mov ax, 1
 mov byte [fatfound], al
;-866 			}

;-867 			if (*p == 0) return; //only empty entries following

.fatDirSectorSearch116:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorSearch117
 jmp .retnfatDirSectorSearch
;-868 			p+=32;//get next entry

.fatDirSectorSearch117:
 add  word[bp-2], 32
;-869 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorSearch118
 jmp .fatDirSectorSearch115
.fatDirSectorSearch118:
;-870 		startSector++;		

 inc  dword[bp+4]
;-871 		numsectors--;

 dec  dword[bp+8]
;-872 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorSearch119
 jmp .fatDirSectorSearch114
.fatDirSectorSearch119:
;-873 	CurrentCluster=0;//not found but not end

 mov ax, 0
 mov word [CurrentCluster], ax
;-874 }

;-875 

;-876 /*

;-877 // 3.

;-878 int fatRootSearch() {

;-879     fatDirSectorSearch(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-880 //	getkey();

;-881 //    fatDirSectorList(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-882 }

;-883 */

;-884 // 4.

;-885 int fatClusterAnalyse(unsigned int clust) {

 .retnfatDirSectorSearch:
 LEAVE
 ret
ENDP

fatClusterAnalyse: PROC
;-886 //OUT: StartSectorL, NextCluster

;-887 	unsigned long fatSectorL;

;-888 	unsigned int offset;

;-889 	char *p;

;-890 

;-891 	StartSectorL = (long) clust - 2;

;Function : fatClusterAnalyse, Number local Var: 4
; # type sign width local variables
;106 var unsg word clust = bp+4
;107 var unsg long fatSectorL = bp-4
;108 var unsg word offset = bp-6
;109 ptr sign byte p = bp-8;
 ENTER  8,0
 xor eax, eax
 mov ax, [bp+4]
 sub ax, 2
 mov dword [StartSectorL], eax
;-892 	StartSectorL = StartSectorL * clust_sizeL;

 mov eax, [StartSectorL]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul dword [clust_sizeL]
 mov dword [StartSectorL], eax
;-893 	StartSectorL = StartSectorL + fat_DataStartSectorL;

 mov eax, [StartSectorL]
 add eax, [fat_DataStartSectorL]
 mov dword [StartSectorL], eax
;-894 	

;-895 //	fatSectorL=cluster*2/512+FatStartSector

;-896 	fatSectorL = (long) clust;

 xor eax, eax
 mov ax, [bp+4]
 mov [bp-4], eax
;-897 	fatSectorL = fatSectorL + fatSectorL;

 mov eax, [bp-4]
 add eax, [bp-4]
 mov [bp-4], eax
;-898 	fatSectorL = fatSectorL / sector_sizeL;		

 mov eax, [bp-4]
 xor edx, edx
 div dword [sector_sizeL]
 mov [bp-4], eax
;-899 	fatSectorL = fatSectorL + fat_FatStartSectorL; 

 mov eax, [bp-4]
 add eax, [fat_FatStartSectorL]
 mov [bp-4], eax
;-900 	readLogical(fatSectorL, DiskBufSeg, DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp-4]
 call readLogical
 add  sp, 8
;-901 	

;-902 	offset = clust + clust;//todo overflow?

 mov ax, [bp+4]
 add ax, [bp+4]
 mov [bp-6], ax
;-903 	offset = offset % bs_sect_size;

 mov ax, [bp-6]
 xor dx, dx
 div word [bs_sect_size]
 mov ax, dx
 mov [bp-6], ax
;-904 	

;-905 	p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-8], ax
;-906 	p = p + offset;	

 mov ax, [bp-8]
 add ax, [bp-6]
 mov [bp-8], ax
;-907 	memcpy(&NextCluster, p, 2);//OUT: NextCluster

 push 2
 push word [bp-8]
 lea  ax, [NextCluster]
 push ax
 call memcpy
 add  sp, 6
;-908 }

;-909 /*

;-910 // 5.

;-911 int fatDirSearch() {//search a directory chain. IN:searchstr

;-912 	

;-913 	fatClusterAnalyse(fatfile_cluster);

;-914 	//OUT: fatfile_sectorStartL, fatfile_nextCluster

;-915 

;-916 	fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster); 

;-917 	while (fatfile_cluster == 0) {//not found but not end

;-918 		if (fatfile_nextCluster >= 0xFFF8) {

;-919 			fat_notfound=1;

;-920 			return;	

;-921 		}		

;-922 		fatfile_cluster=fatfile_nextCluster;

;-923 		fatClusterAnalyse(fatfile_cluster);

;-924 		fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster);

;-925 	}	

;-926 }

;-927 */	

;-928 

;-929 int is_delimiter(char *s) {

 LEAVE
 ret
ENDP

is_delimiter: PROC
;-930 	if (*s == '/' ) return 1;

;Function : is_delimiter, Number local Var: 1
; # type sign width local variables
;106 ptr sign byte s = bp+4;
 ENTER  0,0
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 47
 jne .is_delimiter120
 mov ax, 1
 jmp .retnis_delimiter
;-931 	if (*s == '\\') return 1;

.is_delimiter120:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 92
 jne .is_delimiter121
 mov ax, 1
 jmp .retnis_delimiter
;-932 	if (*s ==    0) return 2;

.is_delimiter121:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .is_delimiter122
 mov ax, 2
 jmp .retnis_delimiter
;-933 	if (*s ==  '.') return 3;

.is_delimiter122:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 46
 jne .is_delimiter123
 mov ax, 3
 jmp .retnis_delimiter
;-934 	return 0;

.is_delimiter123:
 mov ax, 0
 jmp .retnis_delimiter
;-935 }

;-936 

;-937 // 6.

;-938 int fatNextSearch() {//get next part of filename to do a search

 .retnis_delimiter:
 LEAVE
 ret
ENDP

fatNextSearch: PROC
;-939 //	IN:  upto: points to start of search in filename 

;-940 //	OUT: upto: points to search for next time

;-941 //	OUT: searchstr: part of filename in DIR-format with blanks (11bytes)

;-942 //	OUT: isfilename: 0=part of directory, 1=filename

;-943 //	OUT: fatfound

;-944 	char *searchstrp;

;-945 	char *p; 

;-946 	unsigned int  len;

;-947 	unsigned int delimiter;

;-948 

;-949 	delimiter=is_delimiter(upto);

;Function : fatNextSearch, Number local Var: 4
; # type sign width local variables
;106 ptr sign byte searchstrp = bp-2
;107 ptr sign byte p = bp-4
;108 var unsg word len = bp-6
;109 var unsg word delimiter = bp-8;
 ENTER  8,0
 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-950 	if (delimiter == 1) upto++;

 mov ax, [bp-8]
 cmp ax, 1
 jne .fatNextSearch124
 inc  word[upto]
;-951 	if (delimiter == 2) return; 

.fatNextSearch124:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch125
 jmp .retnfatNextSearch
;-952 

;-953 	strcpy(&searchstr, "           ");//11 blank padded

.fatNextSearch125:
 push fatNextSearch_0
 lea  ax, [searchstr]
 push ax
 call strcpy
 add  sp, 4
;-954 	searchstrp = &searchstr;//clear searchstr

 mov ax, searchstr
 mov [bp-2], ax
;-955 	len=0;

 mov ax, 0
 mov [bp-6], ax
;-956 	delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-957 	while (delimiter == 0) { //no slash, zero, point

.fatNextSearch126:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch127
;-958 		*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-959 		searchstrp++;

 inc  word[bp-2]
;-960 		upto++;	

 inc  word[upto]
;-961 		len++;

 inc  word[bp-6]
;-962 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-963 	} 

;-964 	if (len > 8) return;

 jmp .fatNextSearch126
.fatNextSearch127:
 mov ax, [bp-6]
 cmp ax, 8
 jle .fatNextSearch128
 jmp .retnfatNextSearch
;-965 	isfilename=0;//todo: default directory, not yet implemented

.fatNextSearch128:
 mov ax, 0
 mov byte [isfilename], al
;-966 	if (delimiter == 2) isfilename=1;//last name is always a file name

 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch129
 mov ax, 1
 mov byte [isfilename], al
;-967 	if (delimiter == 3) {//remove dot in name		

.fatNextSearch129:
 mov ax, [bp-8]
 cmp ax, 3
 jne .fatNextSearch130
;-968 		searchstrp = &searchstr;

 mov ax, searchstr
 mov [bp-2], ax
;-969 		searchstrp += 8;//start extension		

 add  word[bp-2], 8
;-970 		len=0;

 mov ax, 0
 mov [bp-6], ax
;-971 		upto++;

 inc  word[upto]
;-972 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-973 		while (delimiter == 0) { //no slash, zero, point

.fatNextSearch131:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch132
;-974 			*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-975 			searchstrp++;

 inc  word[bp-2]
;-976 			upto++;	

 inc  word[upto]
;-977 			len++;

 inc  word[bp-6]
;-978 			delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-979 		} 

;-980 		if (len > 3) return;

 jmp .fatNextSearch131
.fatNextSearch132:
 mov ax, [bp-6]
 cmp ax, 3
 jle .fatNextSearch133
 jmp .retnfatNextSearch
;-981 		if (delimiter == 2) isfilename=1;//last name is always a file name

.fatNextSearch133:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch134
 mov ax, 1
 mov byte [isfilename], al
;-982 	}

.fatNextSearch134:
;-983 	fatfound=1;	

.fatNextSearch130:
 mov ax, 1
 mov byte [fatfound], al
;-984 }

;-985 

;-986 // 7.

;-987 int fatGetStartCluster() {//lastBytes, lastSectors

 .retnfatNextSearch:
 LEAVE
 ret
fatNextSearch_0 db "           ",0
ENDP

fatGetStartCluster: PROC
;-988 	fatfound=0;

 mov ax, 0
 mov byte [fatfound], al
;-989 	upto = &filename;

 mov ax, filename
 mov word [upto], ax
;-990 	fatNextSearch();//6 get next part of file name

 call fatNextSearch
;-991 

;-992 	if (debug) {putch(10); cputsLen(searchstr, 11); }

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
;-993 	if (isfilename == 0) return; //todo not implemented

.fatGetStartCluster135:
 mov al, [isfilename]
 cmp al, 0
 jne .fatGetStartCluster136
 jmp .retnfatGetStartCluster
;-994 	if (fatfound) fatDirSectorSearch(fat_RootDirStartSectorL,

.fatGetStartCluster136:
 mov al, [fatfound]
 or  al, al
 je .fatGetStartCluster137
;-995 	fat_RootDirSectorsL); //2 todo: only root search

 push dword [fat_RootDirSectorsL]
 push dword [fat_RootDirStartSectorL]
 call fatDirSectorSearch
 add  sp, 8
;-996 }

.fatGetStartCluster137:
;-997 

;-998 

;-999 // 8.

;-1000 int fatOpenFile() {//set handle for root or subdir

 .retnfatGetStartCluster:
 ret
ENDP

fatOpenFile: PROC
;-1001 //	fat_notfound=0;

;-1002 	unsigned long BufSzL;

;-1003 	

;-1004 	if (debug) cputs(".fatOpenfile ");	

;Function : fatOpenFile, Number local Var: 1
; # type sign width local variables
;106 var unsg long BufSzL = bp-4;
 ENTER  4,0
 mov ax, 1
 or  al, al
 je .fatOpenFile138
 push fatOpenFile_0
 call cputs
 add  sp, 2
;-1005 	handle=3;//todo

.fatOpenFile138:
 mov ax, 3
 mov byte [handle], al
;-1006 	sectorCount = fat_RootDirSectorsL;// or clust_sizeL

 mov eax, [fat_RootDirSectorsL]
 mov word [sectorCount], ax
;-1007 	

;-1008 	fatGetStartCluster();// 7.

 call fatGetStartCluster
;-1009 	if (fatfound == 0) { cputs(" file not found"); return; }

 mov al, [fatfound]
 cmp al, 0
 jne .fatOpenFile139
 push fatOpenFile_1
 call cputs
 add  sp, 2
 jmp .retnfatOpenFile
;-1010 	lastBytes   = FileSizeL % bytes_per_clusterL;	

.fatOpenFile139:
 mov eax, [FileSizeL]
 xor edx, edx
 div dword [bytes_per_clusterL]
 mov eax, edx
 mov word [lastBytes], ax
;-1011 	lastSectors = lastBytes / sector_sizeL;//resting sectors in a cluster

 mov ax, [lastBytes]
 xor edx, edx
 div dword [sector_sizeL]
 mov word [lastSectors], ax
;-1012 	lastBytes   = lastBytes % sector_sizeL;//resting bytes in a sector

 mov ax, [lastBytes]
 xor edx, edx
 div dword [sector_sizeL]
 mov eax, edx
 mov word [lastBytes], ax
;-1013 	

;-1014 	if (FileSizeL == 0) isfilename = 0;

 mov eax, [FileSizeL]
 cmp eax, 0
 jne .fatOpenFile140
 mov ax, 0
 mov byte [isfilename], al
;-1015 	else isfilename = 1;

 jmp .fatOpenFile141
.fatOpenFile140:
 mov ax, 1
 mov byte [isfilename], al
;-1016 		

;-1017 	BufSzL = (long) BUFFERSIZE;

.fatOpenFile141:
 xor eax, eax
 mov ax, 35000
 mov [bp-4], eax
;-1018 	if (FileSizeL >=  BufSzL) {

 mov eax, [FileSizeL]
 cmp eax, [bp-4] ;unsigned : 0
 jb  .fatOpenFile142
;-1019 		cputs(" file longer than BufferSize"); 

 push fatOpenFile_2
 call cputs
 add  sp, 2
;-1020 		fatfound= 0;

 mov ax, 0
 mov byte [fatfound], al
;-1021 		return;

 jmp .retnfatOpenFile
;-1022 	}

;-1023 

;-1024 	fatClusterAnalyse(CurrentCluster);// 4. OUT:StartSectorL,NextCluster

.fatOpenFile142:
 push word [CurrentCluster]
 call fatClusterAnalyse
 add  sp, 2
;-1025 	sectorCount = clust_sizeL;//1..128 or fat_RootDirSectorsL

 mov eax, [clust_sizeL]
 mov word [sectorCount], ax
;-1026 	FilePointerL = 0;

 mov ax, 0
 mov dword [FilePointerL], eax
;-1027 	sectorUpto = 0;

 mov ax, 0
 mov word [sectorUpto], ax
;-1028 	byteUpto   = 0;

 mov ax, 0
 mov word [byteUpto], ax
;-1029 //	if (fat_notfound) return 1;

;-1030 	if (debug) {									//		DOS.COM FDCONFIG

 mov ax, 1
 or  al, al
 je .fatOpenFile143
;-1031 	cputs(" CurrentCluster="); 	printunsign(CurrentCluster);//4177	4164

 push fatOpenFile_3
 call cputs
 add  sp, 2
 push word [CurrentCluster]
 call printunsign
 add  sp, 2
;-1032 	cputs(",StartSectorL=");	printlong(StartSectorL);	//17051	16999

 push fatOpenFile_4
 call cputs
 add  sp, 2
 push dword [StartSectorL]
 call printlong
 add  sp, 4
;-1033 	cputs(",ClusterSizeL=");	printlong(clust_sizeL);		// 4	 4

 push fatOpenFile_5
 call cputs
 add  sp, 2
 push dword [clust_sizeL]
 call printlong
 add  sp, 4
;-1034 	cputs(",FileSizeL="); 		printlong(FileSizeL);		//8802	762

 push fatOpenFile_6
 call cputs
 add  sp, 2
 push dword [FileSizeL]
 call printlong
 add  sp, 4
;-1035 	cputs(",NextCluster="); 	printunsign(NextCluster);	//4178	65.535

 push fatOpenFile_7
 call cputs
 add  sp, 2
 push word [NextCluster]
 call printunsign
 add  sp, 2
;-1036 	cputs(",lastSectors=");		printunsign(lastSectors);	// 1	 1

 push fatOpenFile_8
 call cputs
 add  sp, 2
 push word [lastSectors]
 call printunsign
 add  sp, 2
;-1037 	cputs(",lastBytes="); 		printunsign(lastBytes);		// 98	250

 push fatOpenFile_9
 call cputs
 add  sp, 2
 push word [lastBytes]
 call printunsign
 add  sp, 2
;-1038 	}

;-1039 }

.fatOpenFile143:
;-1040 

;-1041 /*

;-1042 DRESULT disk_readp (	//Read Partial Sector  

;-1043 	BYTE* buff,		// Data read buffer

;-1044 	DWORD sector,	// Sector number (LBA)

;-1045 	UINT offset,	// Offset in the sector

;-1046 	UINT count		// Byte count

;-1047 )

;-1048 {

;-1049 	DRESULT res;

;-1050 	DWORD rnc;

;-1051 	LARGE_INTEGER dofs;

;-1052 

;-1053 	if (!ReadFile(Stat[0].h_drive, Buffer, 512, &rnc, NULL) || 512 != rnc) {

;-1054 		res = RES_ERROR;

;-1055 		} else {

;-1056 				if (buff) {

;-1057 					memcpy(buff, &Buffer[offset], count);

;-1058 				} else {

;-1059 					while (count--)

;-1060 						putchar(Buffer[offset++]);

;-1061 				}

;-1062 			}

;-1063 } 

;-1064 */

;-1065 

;-1066 

;-1067 

;-1068 int get_fat(unsigned int clst) {//read value of FAT entry

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
;-1069 //	OUT:1=error, else cluster status

;-1070 	if (clst < 2)            return 1;

;Function : get_fat, Number local Var: 1
; # type sign width local variables
;106 var unsg word clst = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 2
 jge .get_fat144
 mov ax, 1
 jmp .retnget_fat
;-1071 	if (clst >= fat_Entries) return 1;

.get_fat144:
 mov ax, [bp+4]
 cmp ax, [fat_Entries] ;unsigned : 0
 jb  .get_fat145
 mov ax, 1
 jmp .retnget_fat
;-1072 	

;-1073 //	if (disk_readp(buf, fs->fatbase + clst / 256, ((UINT)clst % 256) * 2, 2)

;-1074 //	) break;

;-1075 //	return *buf;

;-1076 

;-1077 // 4. fatClusterAnalyse

;-1078 //	fatSectorL=cluster*2/512+FatStartSector

;-1079 

;-1080 

;-1081 

;-1082 

;-1083 	

;-1084 	

;-1085 	

;-1086 }

.get_fat145:
;-1087 

;-1088 int clust2sect(unsigned int clst) {//250

 .retnget_fat:
 LEAVE
 ret
ENDP

clust2sect: PROC
;-1089 //	OUT:CurrentSectorL, 0=error	

;-1090 	if (clst < 2)            { CurrentSectorL = 0; return; }

;Function : clust2sect, Number local Var: 1
; # type sign width local variables
;106 var unsg word clst = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 2
 jge .clust2sect146
 mov ax, 0
 mov dword [CurrentSectorL], eax
 jmp .retnclust2sect
;-1091 	clst -=2;

.clust2sect146:
 sub  word[bp+4], 2
;-1092 	if (clst >= fat_Entries) { CurrentSectorL = 0; return; }

 mov ax, [bp+4]
 cmp ax, [fat_Entries] ;unsigned : 0
 jb  .clust2sect147
 mov ax, 0
 mov dword [CurrentSectorL], eax
 jmp .retnclust2sect
;-1093 	

;-1094 	CurrentSectorL = (long) clst * clust_sizeL;//EAX*m32=EAX

.clust2sect147:
 xor eax, eax
 mov ax, [bp+4]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul dword [clust_sizeL]
 mov dword [CurrentSectorL], eax
;-1095 	CurrentSectorL = CurrentSectorL + fat_DataStartSectorL;

 mov eax, [CurrentSectorL]
 add eax, [fat_DataStartSectorL]
 mov dword [CurrentSectorL], eax
;-1096 }

;-1097 		

;-1098 // 9a.

;-1099 int pf_read(unsigned long bytestoReadL) {

 .retnclust2sect:
 LEAVE
 ret
ENDP

pf_read: PROC
;-1100 //	IN:FileSizeL

;-1101 //	IO:FilePointerL

;-1102 //	OUT: 0=error, else byteread

;-1103 	unsigned long remainL;

;-1104 	unsigned long templong1;

;-1105 	unsigned long templong2;

;-1106 	unsigned long sectoroffsetCSL;

;-1107 	unsigned int  tempint1;

;-1108 //	unsigned char tempbyte1;//CS byte

;-1109 	unsigned int  clst;//=CurrentCluster=actual cluster

;-1110 	unsigned long rcntL;

;-1111 	unsigned int  bytesread; 

;-1112 	unsigned int  rbuff;

;-1113 	

;-1114 	unsigned long constL512;  

;-1115 	constL512 = (long) 512;//necessary for DIV

;Function : pf_read, Number local Var: 11
; # type sign width local variables
;106 var unsg long bytestoReadL = bp+4
;107 var unsg long remainL = bp-4
;108 var unsg long templong1 = bp-8
;109 var unsg long templong2 = bp-12
;110 var unsg long sectoroffsetCSL = bp-16
;111 var unsg word tempint1 = bp-18
;112 var unsg word clst = bp-20
;113 var unsg long rcntL = bp-24
;114 var unsg word bytesread = bp-26
;115 var unsg word rbuff = bp-28
;116 var unsg long constL512 = bp-32;
 ENTER  32,0
 xor eax, eax
 mov ax, 512
 mov [bp-32], eax
;-1116 	bytesread = 0;

 mov ax, 0
 mov [bp-26], ax
;-1117 	rbuff = 0;

 mov ax, 0
 mov [bp-28], ax
;-1118 	remainL = FileSizeL - FilePointerL;	

 mov eax, [FileSizeL]
 sub eax, [FilePointerL]
 mov [bp-4], eax
;-1119 

;-1120 	if (bytestoReadL > remainL) bytestoReadL = remainL;//718

 mov eax, [bp+4]
 cmp eax, [bp-4]
 jle .pf_read148
 mov eax, [bp-4]
 mov [bp+4], eax
;-1121 

;-1122 	while (bytestoReadL != 0) {//repeat until all data transferred//720

.pf_read148:
.pf_read149:
 mov eax, [bp+4]
 cmp eax, 0
 je  .pf_read150
;-1123 		tempint1 = FilePointerL % constL512;

 mov eax, [FilePointerL]
 xor edx, edx
 div dword [bp-32]
 mov eax, edx
 mov [bp-18], ax
;-1124 

;-1125 		if (tempint1  ==  0) {//on sector boundary?	//721		

 mov ax, [bp-18]
 cmp ax, 0
 jne .pf_read151
;-1126 			templong1 = FilePointerL / constL512;//sector offset in cluster	

 mov eax, [FilePointerL]
 xor edx, edx
 div dword [bp-32]
 mov [bp-8], eax
;-1127 			templong2 = clust_sizeL- 1;//0 - 127

 mov eax, [clust_sizeL]
 sub eax, 1
 mov [bp-12], eax
;-1128 			sectoroffsetCSL = templong1 & templong2;//722

 mov eax, [bp-8]
 and eax, [bp-12]
 mov [bp-16], eax
;-1129 			if (sectoroffsetCSL != 0) {//on cluster boundary?

 mov eax, [bp-16]
 cmp eax, 0
 je  .pf_read152
;-1130 				if (FilePointerL == 0) clst = dir_FirstCluster;//top file?

 mov eax, [FilePointerL]
 cmp eax, 0
 jne .pf_read153
 mov ax, [dir_FirstCluster]
 mov [bp-20], ax
;-1131 				else clst=get_fat(CurrentCluster);

 jmp .pf_read154
.pf_read153:
 push word [CurrentCluster]
 call get_fat
 add  sp, 2
 mov [bp-20], ax
;-1132 				if (clst <= 1) return 0;//729

.pf_read154:
 mov ax, [bp-20]
 cmp ax, 1
 ja  .pf_read155
 mov ax, 0
 jmp .retnpf_read
;-1133 				CurrentCluster = clst;//update current cluster

.pf_read155:
 mov ax, [bp-20]
 mov word [CurrentCluster], ax
;-1134 			}

;-1135 			clust2sect(clst);//OUT:CurrentSectorL, 0=error	//732

.pf_read152:
 push word [bp-20]
 call clust2sect
 add  sp, 2
;-1136 			if (CurrentSectorL == 0) return 0;

 mov eax, [CurrentSectorL]
 cmp eax, 0
 jne .pf_read156
 mov ax, 0
 jmp .retnpf_read
;-1137 			CurrentSectorL = CurrentSectorL + sectoroffsetCSL;	

.pf_read156:
 mov eax, [CurrentSectorL]
 add eax, [bp-16]
 mov dword [CurrentSectorL], eax
;-1138 		}

;-1139 		rcntL = constL512 - tempint1;//get partial sector data from buffer

.pf_read151:
 mov eax, [bp-32]
 sub ax, [bp-18]
 mov [bp-24], eax
;-1140 		if (rcntL > bytestoReadL) rcntL = bytestoReadL; //737

 mov eax, [bp-24]
 cmp eax, [bp+4]
 jle .pf_read157
 mov eax, [bp+4]
 mov [bp-24], eax
;-1141 		

;-1142 		readLogical(CurrentSectorL, DiskBufSeg, DiskBuf);		

.pf_read157:
 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [CurrentSectorL]
 call readLogical
 add  sp, 8
;-1143 		if (BIOS_ERR) {//739

 mov al, [BIOS_ERR]
 or  al, al
 je .pf_read158
;-1144 			Int13hError(); 

 call Int13hError
;-1145 			return 0;

 mov ax, 0
 jmp .retnpf_read
;-1146 		}

;-1147 		//Copy to Buffer[rbuff(max.BUFFERSIZE)], from DiskBuf+templong1

;-1148 			

;-1149 		

;-1150 		

;-1151 		

;-1152 		

;-1153 		

;-1154 		FilePointerL = FilePointerL + rcntL;//740//advance file read pointr	

.pf_read158:
 mov eax, [FilePointerL]
 add eax, [bp-24]
 mov dword [FilePointerL], eax
;-1155 		bytestoReadL = bytestoReadL - rcntL;//741 //update read counter		

 mov eax, [bp+4]
 sub eax, [bp-24]
 mov [bp+4], eax
;-1156 		bytesread = bytesread + rcntL;

 mov ax, [bp-26]
 add eax, [bp-24]
 mov [bp-26], ax
;-1157 		rbuff = rbuff + rcntL;//742 //advance data pointer

 mov ax, [bp-28]
 add eax, [bp-24]
 mov [bp-28], ax
;-1158 	}

;-1159 	return bytesread;		

 jmp .pf_read149
.pf_read150:
 mov ax, [bp-26]
 jmp .retnpf_read
;-1160 }	

;-1161 

;-1162 // 9.

;-1163 int fatReadFile() {// reads from an already open file

 .retnpf_read:
 LEAVE
 ret
ENDP

fatReadFile: PROC
;-1164 //	IN: CurrentCluster, FileSizeL, FilePointerL

;-1165 //	IN: lastBytes, lastSectors

;-1166 	unsigned int  sectorsAvail;	//in one cluster or rootsize

;-1167 	unsigned int  bytesAvail;	//max. in one sector

;-1168 

;-1169 	unsigned int  temp1;

;-1170 	unsigned int  temp2;

;-1171 	unsigned int  temp3;

;-1172 	unsigned int  BufSz;

;-1173 	BufSz    =    BUFFERSIZE;

;Function : fatReadFile, Number local Var: 6
; # type sign width local variables
;106 var unsg word sectorsAvail = bp-2
;107 var unsg word bytesAvail = bp-4
;108 var unsg word temp1 = bp-6
;109 var unsg word temp2 = bp-8
;110 var unsg word temp3 = bp-10
;111 var unsg word BufSz = bp-12;
 ENTER  12,0
 mov ax, 35000
 mov [bp-12], ax
;-1174 	

;-1175 	BufferPtr = &Buffer;

 mov ax, Buffer
 mov word [BufferPtr], ax
;-1176 	bytesRead = 0;

 mov ax, 0
 mov word [bytesRead], ax
;-1177 	sectorsAvail = sectorCount;	//1..128 or fat_RootDirSectorsL 

 mov ax, [sectorCount]
 mov [bp-2], ax
;-1178 	bytesAvail = bs_sect_size;

 mov ax, [bs_sect_size]
 mov [bp-4], ax
;-1179 	

;-1180 	while (CurrentCluster < 0xFFF8) {//not end of Cluster

.fatReadFile159:
 mov ax, [CurrentCluster]
 cmp ax, 65528
 jge .fatReadFile160
;-1181 		sectorsAvail = sectorCount;

 mov ax, [sectorCount]
 mov [bp-2], ax
;-1182 		if (NextCluster >= 0xFFF8) {

 mov ax, [NextCluster]
 cmp ax, 65528 ;unsigned : 0
 jb  .fatReadFile161
;-1183 			if (isfilename) sectorsAvail = lastSectors + 1;//????

 mov al, [isfilename]
 or  al, al
 je .fatReadFile162
 mov ax, [lastSectors]
 add ax, 1
 mov [bp-2], ax
;-1184 			}

.fatReadFile162:
;-1185 		while (sectorUpto != sectorsAvail) {

.fatReadFile161:
.fatReadFile163:
 mov ax, [sectorUpto]
 cmp ax, [bp-2]
 je  .fatReadFile164
;-1186 			bytesAvail = bs_sect_size;

 mov ax, [bs_sect_size]
 mov [bp-4], ax
;-1187 			if (NextCluster >= 0xFFF8) {

 mov ax, [NextCluster]
 cmp ax, 65528 ;unsigned : 0
 jb  .fatReadFile165
;-1188 				if (isfilename) {

 mov al, [isfilename]
 or  al, al
 je .fatReadFile166
;-1189 					if (sectorUpto == lastSectors) {

 mov ax, [sectorUpto]
 cmp ax, [lastSectors]
 jne .fatReadFile167
;-1190 						bytesAvail = lastBytes;

 mov ax, [lastBytes]
 mov [bp-4], ax
;-1191 					}	

;-1192 				}

.fatReadFile167:
;-1193 			}

.fatReadFile166:
;-1194 			while (byteUpto != bytesAvail) {

.fatReadFile165:
.fatReadFile168:
 mov ax, [byteUpto]
 cmp ax, [bp-4]
 je  .fatReadFile169
;-1195 				CurrentSectorL = (long) sectorUpto;

 xor eax, eax
 mov ax, [sectorUpto]
 mov dword [CurrentSectorL], eax
;-1196 				CurrentSectorL = CurrentSectorL + StartSectorL;	

 mov eax, [CurrentSectorL]
 add eax, [StartSectorL]
 mov dword [CurrentSectorL], eax
;-1197 				readLogical(CurrentSectorL, DiskBufSeg, DiskBuf);		

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [CurrentSectorL]
 call readLogical
 add  sp, 8
;-1198 				if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .fatReadFile170
;-1199 					Int13hError(); 

 call Int13hError
;-1200 					fatfound = 0;

 mov ax, 0
 mov byte [fatfound], al
;-1201 					return;

 jmp .retnfatReadFile
;-1202 				}	

;-1203 				temp1 = bytesAvail - byteUpto;

.fatReadFile170:
 mov ax, [bp-4]
 sub ax, [byteUpto]
 mov [bp-6], ax
;-1204 				temp2 = BufSz - bytesRead;

 mov ax, [bp-12]
 sub ax, [bytesRead]
 mov [bp-8], ax
;-1205 				temp3 = Buffer + byteUpto;

 mov al, [Buffer]
 add ax, [byteUpto]
 mov [bp-10], ax
;-1206 

;-1207 				BufferPtr = BufferPtr + bytesRead;////////////////

 mov ax, [BufferPtr]
 add ax, [bytesRead]
 mov word [BufferPtr], ax
;-1208 				

;-1209 				

;-1210 				if (temp1 > temp2) {//read last sector not full

 mov ax, [bp-6]
 cmp ax, [bp-8]
 jle .fatReadFile171
;-1211 					memcpy(BufferPtr, temp3, temp2);	

 push word [bp-8]
 push word [bp-10]
 push word [BufferPtr]
 call memcpy
 add  sp, 6
;-1212 					byteUpto = byteUpto + temp2;

 mov ax, [byteUpto]
 add ax, [bp-8]
 mov word [byteUpto], ax
;-1213 					bytesRead = BufSz;

 mov ax, [bp-12]
 mov word [bytesRead], ax
;-1214 					return;

 jmp .retnfatReadFile
;-1215 				}	

;-1216 				else {//read full sector

 jmp .fatReadFile172
.fatReadFile171:
;-1217 					memcpy(BufferPtr, temp3, temp1);

 push word [bp-6]
 push word [bp-10]
 push word [BufferPtr]
 call memcpy
 add  sp, 6
;-1218 					bytesRead = bytesRead + temp1;

 mov ax, [bytesRead]
 add ax, [bp-6]
 mov word [bytesRead], ax
;-1219 					byteUpto = byteUpto + temp1; 

 mov ax, [byteUpto]
 add ax, [bp-6]
 mov word [byteUpto], ax
;-1220 				}	

;-1221 			}	

.fatReadFile172:
;-1222 			sectorUpto ++;

 jmp .fatReadFile168
.fatReadFile169:
 inc  word[sectorUpto]
;-1223 			byteUpto = 0;

 mov ax, 0
 mov word [byteUpto], ax
;-1224 		}	

;-1225 		CurrentCluster = NextCluster;

 jmp .fatReadFile163
.fatReadFile164:
 mov ax, [NextCluster]
 mov word [CurrentCluster], ax
;-1226 		fatClusterAnalyse(CurrentCluster);//4.OUT:StartSectorL,NextCluster

 push word [CurrentCluster]
 call fatClusterAnalyse
 add  sp, 2
;-1227 		sectorUpto = 0;

 mov ax, 0
 mov word [sectorUpto], ax
;-1228 	}	

;-1229 }

 jmp .fatReadFile159
.fatReadFile160:
;-1230 //------------------------------- OS functions --------------

;-1231 //handle: 0=in, 1=out, 2=err, 255=error

;-1232 // 10.

;-1233 int OSOpenFile(char *name) {

 .retnfatReadFile:
 LEAVE
 ret
ENDP

OSOpenFile: PROC
;-1234 //remove drive letter, slash. uppercase and copy to filename

;-1235 	unsigned int i;

;-1236 	handle=255;//default=error

;Function : OSOpenFile, Number local Var: 2
; # type sign width local variables
;106 ptr sign byte name = bp+4
;107 var unsg word i = bp-2;
 ENTER  2,0
 mov ax, 255
 mov byte [handle], al
;-1237 	strcpy(filename, name);

 push word [bp+4]
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1238 	toupper(filename);

 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-1239 

;-1240 	if (strlen(filename) == 0) return;

 lea  ax, [filename]
 push ax
 call strlen
 add  sp, 2
 cmp ax, 0
 jne .OSOpenFile173
 jmp .retnOSOpenFile
;-1241 	i=strchr(filename, ':');

.OSOpenFile173:
 push 58
 lea  ax, [filename]
 push ax
 call strchr
 add  sp, 4
 mov [bp-2], ax
;-1242 	if (i) {

 mov ax, [bp-2]
 or  al, al
 je .OSOpenFile174
;-1243 		i++;

 inc  word[bp-2]
;-1244 		strcpy(filename, i);	

 push word [bp-2]
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1245 		if (strlen(filename) == 0) return;	

 lea  ax, [filename]
 push ax
 call strlen
 add  sp, 2
 cmp ax, 0
 jne .OSOpenFile175
 jmp .retnOSOpenFile
;-1246 	}	

.OSOpenFile175:
;-1247 //todo: add working directory page 18

;-1248 	if(is_delimiter(filename) == 1) filename++;

.OSOpenFile174:
 lea  ax, [filename]
 push ax
 call is_delimiter
 add  sp, 2
 cmp ax, 1
 jne .OSOpenFile176
 inc  byte[filename]
;-1249 //	if (debug) {cputs(" filename=");cputs(filename);}		

;-1250 	

;-1251 	fatOpenFile();

.OSOpenFile176:
 call fatOpenFile
;-1252 }

;-1253 

;-1254 // 11.

;-1255 int OSReadFile(char hd) {

 .retnOSOpenFile:
 LEAVE
 ret
ENDP

OSReadFile: PROC
;-1256 	fatReadFile(hd);//9.

;Function : OSReadFile, Number local Var: 1
; # type sign width local variables
;106 var sign byte hd = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fatReadFile
 add  sp, 2
;-1257 }

;-1258 

;-1259 int OSShowFile(char hd) {

 LEAVE
 ret
ENDP

OSShowFile: PROC
;-1260 	mdump(Buffer, 512);

;Function : OSShowFile, Number local Var: 1
; # type sign width local variables
;106 var sign byte hd = bp+4;
 ENTER  0,0
 push 512
 lea  ax, [Buffer]
 push ax
 call mdump
 add  sp, 4
;-1261 	dumpASCII(Buffer, FileSizeL);

 push dword [FileSizeL]
 lea  ax, [Buffer]
 push ax
 call dumpASCII
 add  sp, 6
;-1262 }

;-1263 

;-1264 int OSStartCOM(char hd) {

 LEAVE
 ret
ENDP

OSStartCOM: PROC
;-1265 	

;-1266 }

;Function : OSStartCOM, Number local Var: 1
; # type sign width local variables
;106 var sign byte hd = bp+4;
 ENTER  0,0
;-1267 

;-1268 

;-1269 //------------------------------- Init,  main ---------------

;-1270 int Init() {

 LEAVE
 ret
ENDP

Init: PROC
;-1271 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-1272 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-1273 	if (debug) cputs(" Init");

 mov ax, 1
 or  al, al
 je .Init177
 push Init_0
 call cputs
 add  sp, 2
;-1274 	if (Params()) cputs(" ** NO DRIVE PARAMS FOUND **");//no hard disk

.Init177:
 call Params
 or  al, al
 je .Init178
 push Init_1
 call cputs
 add  sp, 2
;-1275 	if (readMBR() == 0) {//0=error,1=FAT12,6=FAT16,11=FAT32	

.Init178:
 call readMBR
 cmp al, 0
 jne .Init179
;-1276 		cputs(" ** no active FAT partition found **");

 push Init_2
 call cputs
 add  sp, 2
;-1277 		return 1;

 mov ax, 1
 jmp .retnInit
;-1278 		}

;-1279 	if(getBootSector()==0) 	return 1;

.Init179:
 call getBootSector
 cmp al, 0
 jne .Init180
 mov ax, 1
 jmp .retnInit
;-1280 	if (FATInit())			return 1;

.Init180:
 call FATInit
 or  al, al
 je .Init181
 mov ax, 1
 jmp .retnInit
;-1281 	if(trueFATtype != 16) 	return 1;

.Init181:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init182
 mov ax, 1
 jmp .retnInit
;-1282 	Int13hExt();

.Init182:
 call Int13hExt
;-1283 	return 0;

 mov ax, 0
 jmp .retnInit
;-1284 }

;-1285 

;-1286 int main() {

 .retnInit:
 ret
Init_0 db " Init",0
Init_1 db " ** NO DRIVE PARAMS FOUND **",0
Init_2 db " ** no active FAT partition found **",0
ENDP

main: PROC
;-1287 	if (Init() != 0) return 1;

 call Init
 cmp al, 0
 je  .main183
 mov ax, 1
 jmp .retnmain
;-1288 	if (debug) PrintDriveParameter();

.main183:
 mov ax, 1
 or  al, al
 je .main184
 call PrintDriveParameter
;-1289 	

;-1290 	OSOpenFile("dos.com");	

.main184:
 push main_0
 call OSOpenFile
 add  sp, 2
;-1291 	if (handle == 255) cputs(" **no handle**");		

 mov al, [handle]
 cmp al, 255
 jne .main185
 push main_1
 call cputs
 add  sp, 2
;-1292 	if (handle < 0) cputs(" **handle < 0**");		

.main185:
 mov al, [handle]
 cmp al, 0
 jge .main186
 push main_2
 call cputs
 add  sp, 2
;-1293 	OSOpenFile("fdconfig.sys");	

.main186:
 push main_3
 call OSOpenFile
 add  sp, 2
;-1294 	if (handle == 255) cputs(" **no handle**");	

 mov al, [handle]
 cmp al, 255
 jne .main187
 push main_4
 call cputs
 add  sp, 2
;-1295 	OSReadFile(handle);

.main187:
 mov al, byte [handle]
 mov ah, 0
 push ax
 call OSReadFile
 add  sp, 2
;-1296 	OSShowFile(handle);

 mov al, byte [handle]
 mov ah, 0
 push ax
 call OSShowFile
 add  sp, 2
;-1297 

;-1298 /*	OSOpenFile("C:cm.bat");	

;-1299 	if (handle == 255) cputs(" **no handle**");		

;-1300 /*	OSOpenFile("ab:/z");	

;-1301 	if (handle == 255) cputs(" **no handle**");	

;-1302 	OSOpenFile("C:");	

;-1303 	if (handle == 255) cputs(" **no handle**");	

;-1304 	OSOpenFile("/test.ba");	

;-1305 	if (handle == 255) cputs(" **no handle**");	

;-1306 */

;-1307 	if (debug) cputs(".End.");

 mov ax, 1
 or  al, al
 je .main188
 push main_5
 call cputs
 add  sp, 2
;-1308 }

.main188:
;-1309 /*cputs(" delimiter="); printunsign(delimiter);

;-1310 cputs(", isfilename="); printunsign(isfilename);

;-1311 cputs(", upto="); printunsign(upto);

;-1312 cputs("="); cputs(upto);

;-1313 cputs(", len="); printunsign(len);

;-1314 cputs(", searchstr="); cputsLen(searchstr, len);

;-1315 */

;-1316 /*

;-1317 11	OSReadFile

;-1318 	9 fatReadFile

;-1319 	

;-1320 10	OSOpenFile drive,slash,upper,to filename

;-1321 	8 fatOpenFile

;-1322 9. fatReadFile

;-1323 	1 readLogical

;-1324 	4 fatClusterAnalyse

;-1325 8. fatOpenFile set handle, init root or subdir

;-1326 	s7 fatGetStartCluster

;-1327 	s4 fatClusterAnalyse

;-1328 7. fatGestStartCluster

;-1329 	6 fatNextSearch

;-1330 	3 fatRootSearch

;-1331 	s5 fatDirSearch

;-1332 6. fatNextSearch Upto,search,isFilename =>7

;-1333 5. fatDirSearch a directory chain for search

;-1334 	4 fatClusterAnalyse

;-1335 	2 fatDieSectorSearch

;-1336 4. fatClusterAnalyse determines sector by cluster number, next cluster

;-1337 	1 ReadLogical

;-1338 3. fatRootSearch search the root for an entry

;-1339 	2 fatDirSectorSearch

;-1340 2. fatDirSectorSearch search a block of sectors for entries,

;-1341 		get starting cluster, file size, notfound

;-1342 	1 readLogical

;-1343 2.a printDirEntry

;-1344 2.b fatDirSectorList

;-1345 	1 readLogical					

;-1346 1. readLogical

;-1347 	DiskSectorReadWrite	

;-1348 */

;-1349 /*

;-1350 bin_file=fopen("name", "rb") //binary

;-1351 int = fgetc(in_file)	     //EOF(-1)

;-1352 fputc(character, file)

;-1353 printf() = fprintf(stdout, format, parameter1) //buffered I/O

;-1354 DOS: add CR13 to LF10

;-1355 read_size=fread(data_ptr, 1, size, file) //binary read

;-1356 file_descriptor=open(name, flags, mode=0666) //unbuffered I/O

;-1357 read_size=read(file_descriptor, buffer, size) //unbufferes I/O 

;-1358 */

 .retnmain:
 ret
main_0 db "dos.com",0
main_1 db " **no handle**",0
main_2 db " **handle < 0**",0
main_3 db "fdconfig.sys",0
main_4 db " **no handle**",0
main_5 db ".End.",0
ENDP
