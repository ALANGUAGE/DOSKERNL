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
;-25 char isfilename;//0=part of directory or 1=filename

isfilename db 0
;-26 char fatfound;

fatfound db 0
;-27 #define BUFFERSIZE 16384 //16K

;-28 unsigned char Buffer [BUFFERSIZE];

section .bss
absolute 16976
Buffer resb 16384
section .text
;-29 char *BufferPtr;

BufferPtr dw 0
;-30 

;-31 char          handle;

handle db 0
;-32 //start array of handles of every open file

;-33 unsigned int  BegCluster;		//first cluster of file

BegCluster dw 0
;-34 unsigned int  CurCluster;		//current cluster

CurCluster dw 0
;-35 unsigned int  NextCluster;

NextCluster dw 0
;-36 unsigned long CurSectorL;		//current sector in current cluster

CurSectorL dd 0
;-37 unsigned long FileSizeL;

FileSizeL dd 0
;-38 unsigned long lastBytesL;		//resting bytes in a sector

lastBytesL dd 0
;-39 unsigned long lastSectorsL;		//resting sectors in a cluster

lastSectorsL dd 0
;-40 

;-41 unsigned int  CurPosition;	//current byte location in cur sector

CurPosition dw 0
;-42 unsigned long SeekL;			//current byte location in file

SeekL dd 0
;-43 //	end array of handles of every open file

;-44 

;-45 //FATInit

;-46 unsigned int  fat_FatStartSector;

fat_FatStartSector dw 0
;-47 unsigned long fat_FatStartSectorL;

fat_FatStartSectorL dd 0
;-48 unsigned int  fat_FatSectors;

fat_FatSectors dw 0
;-49 unsigned long fat_RootDirStartSectorL;

fat_RootDirStartSectorL dd 0
;-50 unsigned long fat_RootDirSectorsL;

fat_RootDirSectorsL dd 0
;-51 unsigned long fat_DataStartSectorL;

fat_DataStartSectorL dd 0
;-52 unsigned long num_tracksL;

num_tracksL dd 0
;-53 unsigned long Sectors_per_cylinderL;

Sectors_per_cylinderL dd 0
;-54 unsigned long DataSectors32;

DataSectors32 dd 0
;-55 unsigned long CountofClustersL;

CountofClustersL dd 0
;-56 unsigned char trueFATtype;	//12, 16, 32 from FATInit

trueFATtype db 0
;-57 unsigned long bytes_per_clusterL;

bytes_per_clusterL dd 0
;-58 

;-59 //Params from int13h, Function 8

;-60 unsigned int  pa_Cylinders;

pa_Cylinders dw 0
;-61 unsigned char pa_Sectors;

pa_Sectors db 0
;-62 unsigned char pa_Heads;

pa_Heads db 0
;-63 unsigned char pa_Attached;

pa_Attached db 0
;-64 unsigned int  pt_PartNo;

pt_PartNo dw 0
;-65 

;-66 //start hard disk partition structure 16 bytes in MBR. do not change!!!!!

;-67 unsigned char pt_Bootable;		// 00 80h = active partition, else 00

pt_Bootable db 0
;-68 unsigned char pt_StartHead;		// 01

pt_StartHead db 0
;-69 unsigned char pt_StartSector;	// 02 bits 0-5

pt_StartSector db 0
;-70 unsigned int  pt_StartCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-71 unsigned char pt_FileSystem;	// 04 0=nu,1=FAT12,4=16,5=ExtP,6=large16

pt_FileSystem db 0
;-72 unsigned char pt_EndHead;		// 05

pt_EndHead db 0
;-73 unsigned char pt_EndSector;		// 06 bits 0-5

pt_EndSector db 0
;-74 unsigned int  pt_EndCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-75 unsigned long pt_HiddenSector;	// 08 sectors preceding partition

pt_HiddenSector dd 0
;-76 unsigned long pt_PartLen;    	// 12 length of partition in sectors

pt_PartLen dd 0
;-77 //  16 end hard disk partition structure

;-78 

;-79 //start boot BIOS Parameter Block structure. do not change!!!!!

;-80 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-81 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-82 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-83 unsigned char bs_clust_size;// 13 sectors per CurCluster (1,2,4,..,128)

bs_clust_size db 0
;-84 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-85 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-86 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-87 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-88 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-89 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-90 unsigned int  bs_sectors_per_track; // 24 (DOS 3+)sectors per track

bs_sectors_per_track dw 0
;-91 unsigned int  bs_num_heads;	// 26 (DOS 3+)number of heads

bs_num_heads dw 0
;-92 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors

bs_hid_sects dd 0
;-93 unsigned long bs_tot_sect32;// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-94 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-95 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-96 unsigned char bs_ext_signat;// 38 (DOS 4+) Ext. signature,get next 3(29h)

bs_ext_signat db 0
;-97 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-98 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-99 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-100 // 62 end boot BIOS Parameter Block

;-101 

;-102 //start directory entry structure, do not change!!!!!

;-103 unsigned char dir_Filename[]="1234567";	//00 +lengthbyte=11

dir_Filename db "1234567",0
;-104 unsigned char dir_Ext[]="12";	//07 +lengthbyte=3

dir_Ext db "12",0
;-105 unsigned char dir_Attrib;		//11 directory=10h, Label=08h, read only=1

dir_Attrib db 0
;-106 unsigned char dir_NTReserved;	//12 low case in body=8h, in ext=10h

dir_NTReserved db 0
;-107 unsigned char dir_TimeCreatedMS;//13 in 10 milliseconda or zero

dir_TimeCreatedMS db 0
;-108 unsigned int  dir_TimeCreated;	//14 creation time, resolution 2 sec. or 0

dir_TimeCreated dw 0
;-109 unsigned int  dir_DateCreated;	//16 creation date or zero

dir_DateCreated dw 0
;-110 unsigned int  dir_DateLastAccessd;		//18 no time info available or zero

dir_DateLastAccessd dw 0
;-111 unsigned int  dir_FirstClusterHiBytes;	//20 FAT12/16 always zero

dir_FirstClusterHiBytes dw 0
;-112 unsigned int  dir_LastModTime;	//22 modification time on closing

dir_LastModTime dw 0
;-113 unsigned int  dir_LastModDate;	//24 modification date on closing

dir_LastModDate dw 0
;-114 unsigned int  dir_FirstCluster;	//26 1.clu. of file data,if filesize=0 then0

dir_FirstCluster dw 0
;-115 unsigned long dir_FileSize;		//28 size in bytes, if directory then zero

dir_FileSize dd 0
;-116 // 32 end direcctory entry structure

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
;100 var sign byte c = bp+4;
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
;100 ptr sign byte s = bp+4
;101 var sign byte c = bp-2;
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
;100 ptr sign byte s = bp+4
;101 var sign word len = bp+6
;102 var sign byte c = bp-2;
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
;100 var unsg byte c = bp+4;
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
;100 var unsg word i = bp+4
;101 var unsg word half = bp-2;
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
;100 var unsg word n = bp+4
;101 var unsg word e = bp-2;
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
;100 var unsg long L = bp+4;
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
;100 ptr sign byte s = bp+4
;101 var sign word c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-235     if (*s == 34) return 0; // "

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 jne .strlen9
 mov ax, 0
 jmp .retnstrlen
;-236     while (*s!=0) {s++; c++;}

.strlen9:
.strlen10:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen11
 inc  word[bp+4]
 inc  word[bp-2]
;-237     return c;

 jmp .strlen10
.strlen11:
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
.strcpy12:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy13
;-241     	*s=*t; s++; t++; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-242     *s=0;

 jmp .strcpy12
.strcpy13:
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
.eqstr14:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr15
;-247         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr16
 mov ax, 0
 jmp .retneqstr
;-248         p++;

.eqstr16:
 inc  word[bp+4]
;-249         q++;

 inc  word[bp+6]
;-250     }

;-251     if(*q) return 0;

 jmp .eqstr14
.eqstr15:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr17
 mov ax, 0
 jmp .retneqstr
;-252     return 1;

.eqstr17:
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
.memcmp18:
;-257         if (*s < *t) return 0xFFFF;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 jge .memcmp19
 mov ax, 65535
 jmp .retnmemcmp
;-258         if (*s > *t) return 1;

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
;-259         s++; t++; i--;

.memcmp20:
 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-260     } while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcmp21
 jmp .memcmp18
.memcmp21:
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
.strcat22:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat23
 inc  word[bp+4]
;-266     strcpy(s, t);

 jmp .strcat22
.strcat23:
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
.toupper24:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper25
;-270         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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
;-271         s++;

.toupper27:
.toupper26:
 inc  word[bp+4]
;-272     }

;-273 }

 jmp .toupper24
.toupper25:
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
.strchr28:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .strchr29
;-276         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .strchr30
 mov ax, [bp+4]
 jmp .retnstrchr
;-277         s++;

.strchr30:
 inc  word[bp+4]
;-278     }

;-279     return 0;

 jmp .strchr28
.strchr29:
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
.memchr31:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr32
;-283         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr33
 mov ax, [bp+4]
 jmp .retnmemchr
;-284         s++; i--;

.memchr33:
 inc  word[bp+4]
 dec  word[bp+8]
;-285     }

;-286     return 0;

 jmp .memchr31
.memchr32:
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

.memchr134:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr135
;-292         if (*s==c) return pos;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr136
 mov ax, [bp-2]
 jmp .retnmemchr1
;-293         s++; i--; pos++;

.memchr136:
 inc  word[bp+4]
 dec  word[bp+8]
 inc  word[bp-2]
;-294     }

;-295     return 0;

 jmp .memchr134
.memchr135:
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
.instr137:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .instr138
;-299         if (*s==c) return 1;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .instr139
 mov ax, 1
 jmp .retninstr1
;-300         s++;

.instr139:
 inc  word[bp+4]
;-301     }

;-302     return 0;

 jmp .instr137
.instr138:
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

.memcpy40:
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
 je  .memcpy41
 jmp .memcpy40
.memcpy41:
;-312 	ax=r;//	return r;

 mov  ax, [bp-2]
;-313 }

;-314 

;-315 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-316     unsigned char c; unsigned char chal; int i; int j; int k;

;-317     j=0;

;Function : mdump, Number local Var: 7
; # type sign width local variables
;100 ptr unsg byte adr = bp+4
;101 var unsg word len = bp+6
;102 var unsg byte c = bp-2
;103 var unsg byte chal = bp-4
;104 var sign word i = bp-6
;105 var sign word j = bp-8
;106 var sign word k = bp-10;
 ENTER  10,0
 mov ax, 0
 mov [bp-8], ax
;-318     k=0;

 mov ax, 0
 mov [bp-10], ax
;-319 	putch(10);

 push 10
 call putch
 add  sp, 2
;-320 	cputs("Ofs=");

 push mdump_0
 call cputs
 add  sp, 2
;-321 	printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-322 	cputs(" Length=");

 push mdump_1
 call cputs
 add  sp, 2
;-323 	printunsign(len);

 push word [bp+6]
 call printunsign
 add  sp, 2
;-324     while (j < len ) {

.mdump42:
 mov ax, [bp-8]
 cmp ax, [bp+6]
 jge .mdump43
;-325 	    k++;;

 inc  word[bp-10]
;-326 	    if (k > 16) {

 mov ax, [bp-10]
 cmp ax, 16
 jle .mdump44
;-327 		    chal = getkey();//remove scan code

 call getkey
 mov [bp-4], al
;-328 		    if (chal =='q') return;

 mov al, [bp-4]
 cmp al, 113
 jne .mdump45
 jmp .retnmdump
;-329 		    k=1;

.mdump45:
 mov ax, 1
 mov [bp-10], ax
;-330 		    putch(10);

 push 10
 call putch
 add  sp, 2
;-331 		    cputs("Ofs=");

 push mdump_2
 call cputs
 add  sp, 2
;-332 		    printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-333 		    }

;-334         putch(10);

.mdump44:
 push 10
 call putch
 add  sp, 2
;-335         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-336         putch(':');

 push 58
 call putch
 add  sp, 2
;-337         i=0;

 mov ax, 0
 mov [bp-6], ax
;-338         while (i < 16) {

.mdump46:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump47
;-339             putch(' ');

 push 32
 call putch
 add  sp, 2
;-340             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-341             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-342             adr++;

 inc  word[bp+4]
;-343             i++;

 inc  word[bp-6]
;-344             j++;

 inc  word[bp-8]
;-345             }

;-346         putch(' ');

 jmp .mdump46
.mdump47:
 push 32
 call putch
 add  sp, 2
;-347         adr -=16;

 sub  word[bp+4], 16
;-348         i=0;

 mov ax, 0
 mov [bp-6], ax
;-349         while(i < 16) {

.mdump48:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump49
;-350             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-351             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump50
 push 46
 call putch
 add  sp, 2
;-352                 else putch(c);

 jmp .mdump51
.mdump50:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-353             adr++;

.mdump51:
 inc  word[bp+4]
;-354             i++;

 inc  word[bp-6]
;-355         }

;-356     }

 jmp .mdump48
.mdump49:
;-357     getkey();

 jmp .mdump42
.mdump43:
 call getkey
;-358     putch(10);

 push 10
 call putch
 add  sp, 2
;-359 

;-360 }

;-361 int dumpASCII(unsigned char *adr, unsigned int len ) {

 .retnmdump:
 LEAVE
 ret
mdump_0 db "Ofs=",0
mdump_1 db " Length=",0
mdump_2 db "Ofs=",0
ENDP

dumpASCII: PROC
;-362     unsigned char c; unsigned char chal; int i; int j; int k;

;-363     j=0;

;Function : dumpASCII, Number local Var: 7
; # type sign width local variables
;100 ptr unsg byte adr = bp+4
;101 var unsg word len = bp+6
;102 var unsg byte c = bp-2
;103 var unsg byte chal = bp-4
;104 var sign word i = bp-6
;105 var sign word j = bp-8
;106 var sign word k = bp-10;
 ENTER  10,0
 mov ax, 0
 mov [bp-8], ax
;-364     k=0;

 mov ax, 0
 mov [bp-10], ax
;-365 	putch(10);

 push 10
 call putch
 add  sp, 2
;-366 	cputs("Ofs=");

 push dumpASCII_0
 call cputs
 add  sp, 2
;-367 	printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-368 	cputs(" Length=");

 push dumpASCII_1
 call cputs
 add  sp, 2
;-369 	printunsign(len);

 push word [bp+6]
 call printunsign
 add  sp, 2
;-370     while (j < len ) {

.dumpASCII52:
 mov ax, [bp-8]
 cmp ax, [bp+6]
 jge .dumpASCII53
;-371 	    k++;;

 inc  word[bp-10]
;-372 	    if (k > 16) {

 mov ax, [bp-10]
 cmp ax, 16
 jle .dumpASCII54
;-373 		    chal = getkey();//remove scan code

 call getkey
 mov [bp-4], al
;-374 		    if (chal =='q') return;

 mov al, [bp-4]
 cmp al, 113
 jne .dumpASCII55
 jmp .retndumpASCII
;-375 		    k=1;

.dumpASCII55:
 mov ax, 1
 mov [bp-10], ax
;-376 		    putch(10);

 push 10
 call putch
 add  sp, 2
;-377 		    cputs("Ofs=");

 push dumpASCII_2
 call cputs
 add  sp, 2
;-378 		    printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-379 		    }

;-380         putch(10);

.dumpASCII54:
 push 10
 call putch
 add  sp, 2
;-381         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-382         putch(':');

 push 58
 call putch
 add  sp, 2
;-383         i=0;

 mov ax, 0
 mov [bp-6], ax
;-384         while(i < 64) {

.dumpASCII56:
 mov ax, [bp-6]
 cmp ax, 64
 jge .dumpASCII57
;-385             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-386             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .dumpASCII58
 push 46
 call putch
 add  sp, 2
;-387                 else putch(c);

 jmp .dumpASCII59
.dumpASCII58:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-388             adr++;

.dumpASCII59:
 inc  word[bp+4]
;-389             i++;

 inc  word[bp-6]
;-390             j++;

 inc  word[bp-8]
;-391         }

;-392     }

 jmp .dumpASCII56
.dumpASCII57:
;-393     getkey();

 jmp .dumpASCII52
.dumpASCII53:
 call getkey
;-394     putch(10);

 push 10
 call putch
 add  sp, 2
;-395 

;-396 }

;-397 

;-398 //--------------------------------  disk IO  -------------------

;-399 

;-400 int DiskSectorReadWrite(char rw, char drive, char head, int cyl,

 .retndumpASCII:
 LEAVE
 ret
dumpASCII_0 db "Ofs=",0
dumpASCII_1 db " Length=",0
dumpASCII_2 db "Ofs=",0
ENDP

DiskSectorReadWrite: PROC
;-401 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-402 	BIOS_ERR=0;

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
;-403 	dl=drive;

 mov  dl, [bp+6]
;-404 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-405 	es=BufSeg;

 mov  es, [bp+16]
;-406 	bx=BufOfs;

 mov  bx, [bp+18]
;-407 	cx=cyl;

 mov  cx, [bp+10]
;-408 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-409 	cx >> 2;//in 2 high bits of cl

 shr  cx, 2
;-410 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-411 	cl += sector;

 add  cl, [bp+12]
;-412 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-413 	al=count;

 mov  al, [bp+14]
;-414 	ah=rw;

 mov  ah, [bp+4]
;-415 	inth 0x13;

 int  19
;-416     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-417 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-418 }

;-419 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-420 	BIOS_ERR=0;

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;100 var sign byte drive = bp+4
;101 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-421 	dl=drive;

 mov  dl, [bp+4]
;-422 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-423 	inth 0x13;

 int  19
;-424     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-425 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-426 }

;-427 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-428 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-429 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-430 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-431 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-432 }

;-433 int Status(drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Status: PROC
;-434 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;100 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-435 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-436 	BIOS_Status=Int13hfunction(drive, 1);

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-437 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Status60
 call Int13hError
;-438 	printhex16(BIOS_Status);

.Status60:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-439 }

;-440 

;-441 int Params() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

Params: PROC
;-442 	if (debug) cputs(" DriveParams");

 mov ax, 1
 or  al, al
 je .Params61
 push Params_0
 call cputs
 add  sp, 2
;-443 	BIOS_Status=Int13hfunction(Drive, 8);

.Params61:
 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-444 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params62
;-445 		Int13hError();

 call Int13hError
;-446 		return 1;

 mov ax, 1
 jmp .retnParams
;-447 		}

;-448 	else {

 jmp .Params63
.Params62:
;-449 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-450 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-451 		// CX =       ---CH--- ---CL---

;-452 		// cylinder : 76543210 98

;-453 		// sector   :            543210

;-454 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-455 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-456 //		pa_Sectors++;//1 to 64

;-457 

;-458 		asm mov [pa_Cylinders],    cx

 mov [pa_Cylinders],    cx
;-459 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-460 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-461 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty

 add [pa_Cylinders],    ch;//byte add, low byte is empty
;-462 

;-463 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params64
;-464 			cputs(" ** no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-465 			return 1;

 mov ax, 1
 jmp .retnParams
;-466 			}

;-467 	}

.Params64:
;-468 	return 0;

.Params63:
 mov ax, 0
 jmp .retnParams
;-469 }

;-470 

;-471 

;-472 int getPartitionData() {

 .retnParams:
 ret
Params_0 db " DriveParams",0
Params_1 db " ** no hard disk found",0
ENDP

getPartitionData: PROC
;-473 	unsigned int j; char c; char *p;

;-474 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;100 var unsg word j = bp-2
;101 var sign byte c = bp-4
;102 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [pt_PartNo]
 shl ax, 4
 mov [bp-2], ax
;-475 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-476 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-477 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-478 	pt_StartCylinder=(int)pt_StartSector;

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-479 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-480 //	pt_StartSector++;//Sector start with 1 todo

;-481 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-482 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-483 	j++;

 inc  word[bp-2]
;-484 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-485 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-486 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB

;-487 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-488 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-489 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-490 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-491 //	pt_EndSector++;//Sector start with 1 todo

;-492 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-493 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-494 	j++;

 inc  word[bp-2]
;-495 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-496 	j++;

 inc  word[bp-2]
;-497 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-498 	memcpy(&pt_HiddenSector, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-499 }

;-500 

;-501 int checkBootSign() {

 LEAVE
 ret
ENDP

checkBootSign: PROC
;-502 	int i;

;-503 	i=510;

;Function : checkBootSign, Number local Var: 1
; # type sign width local variables
;100 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-504 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign65
;-505 		i++;

 inc  word[bp-2]
;-506 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign66
 mov ax, 1
 jmp .retncheckBootSign
;-507 	}

.checkBootSign66:
;-508 	cputs("  **Magic number NOT found.");

.checkBootSign65:
 push checkBootSign_0
 call cputs
 add  sp, 2
;-509 	return 0;

 mov ax, 0
 jmp .retncheckBootSign
;-510 }

;-511 

;-512 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db "  **Magic number NOT found.",0
ENDP

readMBR: PROC
;-513 	int isFAT;

;-514 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;100 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-515 	pt_PartNo=0;

 mov ax, 0
 mov word [pt_PartNo], ax
;-516 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-517 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR67
;-518 		Int13hError();

 call Int13hError
;-519 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-520 		}

;-521 	else {

 jmp .readMBR68
.readMBR67:
;-522 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .readMBR69
 mov ax, 0
 jmp .retnreadMBR
;-523 		do {

.readMBR69:
.readMBR70:
;-524 			getPartitionData();

 call getPartitionData
;-525 

;-526 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR71
;-527 				if (debug) cputs(" Boot part. found");

 mov ax, 1
 or  al, al
 je .readMBR72
 push readMBR_0
 call cputs
 add  sp, 2
;-528 				if (pt_FileSystem == 1) {

.readMBR72:
 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR73
;-529 					cputs(", FAT12 part. <32MB");

 push readMBR_1
 call cputs
 add  sp, 2
;-530 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-531 					}

;-532 				if (pt_FileSystem == 4) {

.readMBR73:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR74
;-533 					cputs(", small FAT16 part.<32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-534 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-535 					}

;-536 				if (pt_FileSystem == 6) {

.readMBR74:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR75
;-537 					if (debug) cputs(", large FAT16 part.");

 mov ax, 1
 or  al, al
 je .readMBR76
 push readMBR_3
 call cputs
 add  sp, 2
;-538 					isFAT=6;

.readMBR76:
 mov ax, 6
 mov [bp-2], ax
;-539 					}

;-540 				pt_PartNo=99;//end of loop

.readMBR75:
 mov ax, 99
 mov word [pt_PartNo], ax
;-541 			}

;-542 			pt_PartNo ++;

.readMBR71:
 inc  word[pt_PartNo]
;-543 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR77
 jmp .readMBR70
.readMBR77:
;-544 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-545 	}

;-546 }

.readMBR68:
;-547 

;-548 int getBootSector() {

 .retnreadMBR:
 LEAVE
 ret
readMBR_0 db " Boot part. found",0
readMBR_1 db ", FAT12 part. <32MB",0
readMBR_2 db ", small FAT16 part.<32MB",0
readMBR_3 db ", large FAT16 part.",0
ENDP

getBootSector: PROC
;-549 	int i;

;-550 	if (debug) cputs(" Boot sector:");

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;100 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 1
 or  al, al
 je .getBootSector78
 push getBootSector_0
 call cputs
 add  sp, 2
;-551   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

.getBootSector78:
;-552   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-553 	if (debug) printhex16(BIOS_Status);

 mov ax, 1
 or  al, al
 je .getBootSector79
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-554 	if (BIOS_ERR) {

.getBootSector79:
 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector80
;-555 		Int13hError();

 call Int13hError
;-556 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-557 		}

;-558 	else {

 jmp .getBootSector81
.getBootSector80:
;-559 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .getBootSector82
 mov ax, 0
 jmp .retngetBootSector
;-560 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector82:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-561 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector83
 push getBootSector_1
 call cputs
 add  sp, 2
;-562 		i=2;

.getBootSector83:
 mov ax, 2
 mov [bp-2], ax
;-563 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector84
 push getBootSector_2
 call cputs
 add  sp, 2
;-564 	}

.getBootSector84:
;-565 	return 1;

.getBootSector81:
 mov ax, 1
 jmp .retngetBootSector
;-566 }

;-567 

;-568 int FATInit() {

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Boot sector:",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-569 	unsigned long templong;//converting word to dword

;-570 

;-571 	clust_sizeL = (long) bs_clust_size;

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;100 var unsg long templong = bp-4;
 ENTER  4,0
 xor eax, eax
 mov al, [bs_clust_size]
 mov dword [clust_sizeL], eax
;-572 	sector_sizeL= (long) bs_sect_size;

 xor eax, eax
 mov ax, [bs_sect_size]
 mov dword [sector_sizeL], eax
;-573 

;-574 	fat_FatStartSector = bs_res_sects;

 mov ax, [bs_res_sects]
 mov word [fat_FatStartSector], ax
;-575 	fat_FatStartSectorL= (long) fat_FatStartSector; 

 xor eax, eax
 mov ax, [fat_FatStartSector]
 mov dword [fat_FatStartSectorL], eax
;-576 	fat_FatSectors = bs_fat_size;

 mov ax, [bs_fat_size]
 mov word [fat_FatSectors], ax
;-577 	if (bs_num_fats == 2) fat_FatSectors=fat_FatSectors+fat_FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .FATInit85
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-578 

;-579 	fat_RootDirStartSectorL = (long)fat_FatStartSector + fat_FatSectors;

.FATInit85:
 xor eax, eax
 mov ax, [fat_FatStartSector]
 add ax, [fat_FatSectors]
 mov dword [fat_RootDirStartSectorL], eax
;-580 	

;-581 	fat_RootDirSectorsL = (long) bs_root_entr >> 4;//  ./. 16

 xor eax, eax
 mov ax, [bs_root_entr]
 shr ax, 4
 mov dword [fat_RootDirSectorsL], eax
;-582 		

;-583 	fat_DataStartSectorL = fat_RootDirStartSectorL + fat_RootDirSectorsL;

 mov eax, [fat_RootDirStartSectorL]
 add eax, [fat_RootDirSectorsL]
 mov dword [fat_DataStartSectorL], eax
;-584 

;-585 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .FATInit86
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-586 	DataSectors32=bs_tot_sect32 - fat_DataStartSectorL;

.FATInit86:
 mov eax, [bs_tot_sect32]
 sub eax, [fat_DataStartSectorL]
 mov dword [DataSectors32], eax
;-587 

;-588 	CountofClustersL=DataSectors32 / clust_sizeL;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [clust_sizeL]
 mov dword [CountofClustersL], eax
;-589 

;-590 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-591 	num_tracksL = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [num_tracksL], eax
;-592 

;-593 //	templong = (long) bs_num_heads;

;-594 //	fat_num_cylinders = num_tracksL / templong;//w=d/w

;-595 	

;-596 	bytes_per_clusterL = (long) bs_clust_size * bs_sect_size;

 xor eax, eax
 mov al, [bs_clust_size]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_sect_size]
 mov dword [bytes_per_clusterL], eax
;-597 

;-598 	Sectors_per_cylinderL = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinderL], eax
;-599 	asm mov [Sectors_per_cylinderL + 2], dx;store high word

 mov [Sectors_per_cylinderL + 2], dx;store high word
;-600 

;-601 	templong = (long) 65525;

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-602 	if (CountofClustersL > templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jle .FATInit87
;-603 		trueFATtype=32;

 mov ax, 32
 mov byte [trueFATtype], al
;-604 		cputs(" FAT32 NOT supported");

 push FATInit_0
 call cputs
 add  sp, 2
;-605 		return 1;

 mov ax, 1
 jmp .retnFATInit
;-606 		}

;-607 	templong= (long) 4086;

.FATInit87:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-608 	if (CountofClustersL < templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jge .FATInit88
;-609 		trueFATtype=12;

 mov ax, 12
 mov byte [trueFATtype], al
;-610 		cputs(" FAT12");

 push FATInit_1
 call cputs
 add  sp, 2
;-611 		return 0;

 mov ax, 0
 jmp .retnFATInit
;-612 		}

;-613 	trueFATtype=16;

.FATInit88:
 mov ax, 16
 mov byte [trueFATtype], al
;-614 	if (debug) cputs(" FAT16");

 mov ax, 1
 or  al, al
 je .FATInit89
 push FATInit_2
 call cputs
 add  sp, 2
;-615 	return 0;

.FATInit89:
 mov ax, 0
 jmp .retnFATInit
;-616 }

;-617 

;-618 int Int13hExt() {

 .retnFATInit:
 LEAVE
 ret
FATInit_0 db " FAT32 NOT supported",0
FATInit_1 db " FAT12",0
FATInit_2 db " FAT16",0
ENDP

Int13hExt: PROC
;-619 	bx=0x55AA;

 mov  bx, 21930
;-620 	BIOS_Status=Int13hfunction(Drive, 0x41);

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-621 	asm mov [vAX], ax;

 mov [vAX], ax;
;-622 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-623 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported
;-624 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt90
;-625 		cputs(" Ext. NOT present");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-626 		Int13hError();

 call Int13hError
;-627 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-628 		}

;-629 	else if (debug) cputs(",Int13h Ext.");

 jmp .Int13hExt91
.Int13hExt90:
 mov ax, 1
 or  al, al
 je .Int13hExt92
 push Int13hExt_1
 call cputs
 add  sp, 2
;-630 	putch(10);

.Int13hExt92:
.Int13hExt91:
 push 10
 call putch
 add  sp, 2
;-631 	return 0;

 mov ax, 0
 jmp .retnInt13hExt
;-632 }

;-633 

;-634 int PrintDriveParameter() {

 .retnInt13hExt:
 ret
Int13hExt_0 db " Ext. NOT present",0
Int13hExt_1 db ",Int13h Ext.",0
ENDP

PrintDriveParameter: PROC
;-635 	unsigned long Lo;

;-636 // from Params

;-637 	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);

;Function : PrintDriveParameter, Number local Var: 1
; # type sign width local variables
;100 var unsg long Lo = bp-4;
 ENTER  4,0
 push PrintDriveParameter_0
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-638 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-639 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-640 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-641 	putch('.');

 push 46
 call putch
 add  sp, 2
;-642 //from getPartitionData

;-643 	putch(10);

 push 10
 call putch
 add  sp, 2
;-644 	cputs("getPartitionData:No=");printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-645 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-646 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-647 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-648 	cputs("/");				printunsign(pt_StartSector);

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-649 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-650 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-651 	cputs("/");				printunsign(pt_EndSector);

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-652 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-653 	cputs(",Start=");		printlong(pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 push dword [pt_HiddenSector]
 call printlong
 add  sp, 4
;-654 	cputs(",Len=");			printlong(pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 push dword [pt_PartLen]
 call printlong
 add  sp, 4
;-655 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-656 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-657 	printlong(Lo);

 push dword [bp-4]
 call printlong
 add  sp, 4
;-658 	cputs(" MByte.");

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-659 //from getBootSector

;-660 	putch(10);

 push 10
 call putch
 add  sp, 2
;-661 	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-662 	putch(10);

 push 10
 call putch
 add  sp, 2
;-663 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-664 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-665 	putch(10);

 push 10
 call putch
 add  sp, 2
;-666 	cputs("Reserved sectors=");printunsign(bs_res_sects);

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-667 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-668 	putch(10);

 push 10
 call putch
 add  sp, 2
;-669 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-670 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-671 	putch(10);

 push 10
 call putch
 add  sp, 2
;-672 	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-673 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-674 	putch(10);

 push 10
 call putch
 add  sp, 2
;-675 	cputs("sectors per track=");printunsign(bs_sectors_per_track);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_sectors_per_track]
 call printunsign
 add  sp, 2
;-676 	cputs(".number of heads=");printunsign(bs_num_heads);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_heads]
 call printunsign
 add  sp, 2
;-677 	putch(10);

 push 10
 call putch
 add  sp, 2
;-678 	cputs("hidden sectors(long)=");printlong(bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 push dword [bs_hid_sects]
 call printlong
 add  sp, 4
;-679 	cputs(".sectors(long)=");printlong(bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 push dword [bs_tot_sect32]
 call printlong
 add  sp, 4
;-680 	putch(10);

 push 10
 call putch
 add  sp, 2
;-681 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-682 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-683 	putch(10);

 push 10
 call putch
 add  sp, 2
;-684 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-685 	cputs(".Volume serial(long)=");printlong(bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 push dword [bs_serial_num]
 call printlong
 add  sp, 4
;-686 	putch(10);

 push 10
 call putch
 add  sp, 2
;-687 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-688 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-689 //from FATInit

;-690 	putch(10);

 push 10
 call putch
 add  sp, 2
;-691 	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [fat_FatStartSector]
 call printunsign
 add  sp, 2
;-692 	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [fat_FatSectors]
 call printunsign
 add  sp, 2
;-693 	putch(10);

 push 10
 call putch
 add  sp, 2
;-694 	cputs("fat_RootDirStartSectorL="); printlong(fat_RootDirStartSectorL);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push dword [fat_RootDirStartSectorL]
 call printlong
 add  sp, 4
;-695 	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectorsL);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push dword [fat_RootDirSectorsL]
 call printunsign
 add  sp, 4
;-696 	putch(10);

 push 10
 call putch
 add  sp, 2
;-697 	cputs("fat_DataStartSectorL=");	printunsign(fat_DataStartSectorL);

 push PrintDriveParameter_38
 call cputs
 add  sp, 2
 push dword [fat_DataStartSectorL]
 call printunsign
 add  sp, 4
;-698 	cputs(", DataSectors32=");	printlong(DataSectors32);

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 push dword [DataSectors32]
 call printlong
 add  sp, 4
;-699 	putch(10);

 push 10
 call putch
 add  sp, 2
;-700 	cputs("CountofClustersL=");	printlong(CountofClustersL);

 push PrintDriveParameter_40
 call cputs
 add  sp, 2
 push dword [CountofClustersL]
 call printlong
 add  sp, 4
;-701 	cputs(", Sectors_per_cylinderL="); printlong(Sectors_per_cylinderL);

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 push dword [Sectors_per_cylinderL]
 call printlong
 add  sp, 4
;-702 	putch(10);

 push 10
 call putch
 add  sp, 2
;-703 	cputs("num_tracksL=");	printlong(num_tracksL);

 push PrintDriveParameter_42
 call cputs
 add  sp, 2
 push dword [num_tracksL]
 call printlong
 add  sp, 4
;-704 	cputs(", bytes_per_clusterL=");	printlong(bytes_per_clusterL);

 push PrintDriveParameter_43
 call cputs
 add  sp, 2
 push dword [bytes_per_clusterL]
 call printlong
 add  sp, 4
;-705 //	cputs(", fat_num_cylinders="); printunsign(fat_num_cylinders);

;-706 	putch(10);

 push 10
 call putch
 add  sp, 2
;-707 	getkey();

 call getkey
;-708 }

;-709 

;-710 //--------------------------------  file IO  -------------------

;-711 int error2(char *s) {

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
;-712 	putch(10);

;Function : error2, Number local Var: 1
; # type sign width local variables
;100 ptr sign byte s = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-713 	cputs("*** ERROR *** ");

 push error2_0
 call cputs
 add  sp, 2
;-714 	cputs(s);

 push word [bp+4]
 call cputs
 add  sp, 2
;-715 	DOS_ERR++;

 inc  byte[DOS_ERR]
;-716 }

;-717 // 1.

;-718 int readLogical(unsigned long SectorL) {//OUT:1 sector in DiskBuf

 LEAVE
 ret
error2_0 db "*** ERROR *** ",0
ENDP

readLogical: PROC
;-719 	unsigned int track; unsigned int head; unsigned int sect;

;-720 	SectorL = SectorL + bs_hid_sects;//d=d+d

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
;-721 	track = SectorL / Sectors_per_cylinderL;  //w=d/d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinderL]
 mov [bp-2], ax
;-722 	head  = SectorL % Sectors_per_cylinderL;  //w=d%d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinderL]
 mov eax, edx
 mov [bp-4], ax
;-723 	sect  = head            % bs_sectors_per_track;  //w=w%w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov ax, dx
 mov [bp-6], ax
;-724 	sect++;

 inc  word[bp-6]
;-725 	head  = head            / bs_sectors_per_track;	 //w=w/w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov [bp-4], ax
;-726 

;-727 	DiskSectorReadWrite(2, bs_drive_num, head, track/* =cyl */,

;-728 		sect, 1, DiskBufSeg , DiskBuf);

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
;-729 }

;-730 // 2.a

;-731 int printDirEntry(int EntryNr) {

 LEAVE
 ret
ENDP

printDirEntry: PROC
;-732     unsigned int j;

;-733 	putch(10);

;Function : printDirEntry, Number local Var: 2
; # type sign width local variables
;100 var sign word EntryNr = bp+4
;101 var unsg word j = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-734 	printunsign(EntryNr);

 push word [bp+4]
 call printunsign
 add  sp, 2
;-735 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-736 	cputs(filename);

 lea  ax, [filename]
 push ax
 call cputs
 add  sp, 2
;-737 	cputs(" ATTR:");

 push printDirEntry_0
 call cputs
 add  sp, 2
;-738 	printhex8(dir_Attrib);	

 mov al, byte [dir_Attrib]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-739 	if (dir_Attrib &  1) cputs(" r/o");

 mov al, [dir_Attrib]
 and al, 1
 or  al, al
 je .printDirEntry93
 push printDirEntry_1
 call cputs
 add  sp, 2
;-740 	if (dir_Attrib &  2) cputs(" hid");

.printDirEntry93:
 mov al, [dir_Attrib]
 and al, 2
 or  al, al
 je .printDirEntry94
 push printDirEntry_2
 call cputs
 add  sp, 2
;-741 	if (dir_Attrib &  4) cputs(" sys");

.printDirEntry94:
 mov al, [dir_Attrib]
 and al, 4
 or  al, al
 je .printDirEntry95
 push printDirEntry_3
 call cputs
 add  sp, 2
;-742 	if (dir_Attrib &  8) cputs(" vol");		

.printDirEntry95:
 mov al, [dir_Attrib]
 and al, 8
 or  al, al
 je .printDirEntry96
 push printDirEntry_4
 call cputs
 add  sp, 2
;-743 	if (dir_Attrib & 16) cputs(" dir");

.printDirEntry96:
 mov al, [dir_Attrib]
 and al, 16
 or  al, al
 je .printDirEntry97
 push printDirEntry_5
 call cputs
 add  sp, 2
;-744 	if (dir_Attrib & 32) cputs(" arc");

.printDirEntry97:
 mov al, [dir_Attrib]
 and al, 32
 or  al, al
 je .printDirEntry98
 push printDirEntry_6
 call cputs
 add  sp, 2
;-745 	if (dir_Attrib == 0) cputs("    ");

.printDirEntry98:
 mov al, [dir_Attrib]
 cmp al, 0
 jne .printDirEntry99
 push printDirEntry_7
 call cputs
 add  sp, 2
;-746 	

;-747 	putch(' ');

.printDirEntry99:
 push 32
 call putch
 add  sp, 2
;-748 	j=dir_LastModDate & 31;//day

 mov ax, [dir_LastModDate]
 and ax, 31
 mov [bp-2], ax
;-749 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry100
 push 32
 call putch
 add  sp, 2
;-750 	printunsign(j);

.printDirEntry100:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-751 	putch('.');

 push 46
 call putch
 add  sp, 2
;-752 

;-753 	j=dir_LastModDate >> 5;//month

 mov ax, [dir_LastModDate]
 shr ax, 5
 mov [bp-2], ax
;-754 	j&=  15;

 and  word[bp-2], 15
;-755 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry101
 push 48
 call putch
 add  sp, 2
;-756 	printunsign(j);

.printDirEntry101:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-757 	putch('.');

 push 46
 call putch
 add  sp, 2
;-758 

;-759 	j=dir_LastModDate >> 9;//year

 mov ax, [dir_LastModDate]
 shr ax, 9
 mov [bp-2], ax
;-760 	j+= 1980;

 add  word[bp-2], 1980
;-761 	printunsign(j);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-762 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-763 	//putch(' ');

;-764 

;-765 	j=dir_LastModTime  >>11;//hour

 mov ax, [dir_LastModTime]
 shr ax, 11
 mov [bp-2], ax
;-766 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry102
 push 32
 call putch
 add  sp, 2
;-767 	printunsign(j);

.printDirEntry102:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-768 	putch(':');

 push 58
 call putch
 add  sp, 2
;-769 

;-770 	j=dir_LastModTime  >> 5;//minute

 mov ax, [dir_LastModTime]
 shr ax, 5
 mov [bp-2], ax
;-771 	j&=  63;

 and  word[bp-2], 63
;-772 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry103
 push 48
 call putch
 add  sp, 2
;-773 	printunsign(j);

.printDirEntry103:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-774 	putch(':');

 push 58
 call putch
 add  sp, 2
;-775 

;-776 	j=dir_LastModTime & 31;// 2 seconds

 mov ax, [dir_LastModTime]
 and ax, 31
 mov [bp-2], ax
;-777 	j=j+j;

 mov ax, [bp-2]
 add ax, [bp-2]
 mov [bp-2], ax
;-778 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry104
 push 48
 call putch
 add  sp, 2
;-779 	printunsign(j);

.printDirEntry104:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-780 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-781 

;-782 	cputs(" 1.Cl:"); 

 push printDirEntry_8
 call cputs
 add  sp, 2
;-783 	printunsign(dir_FirstCluster);

 push word [dir_FirstCluster]
 call printunsign
 add  sp, 2
;-784 	cputs(" Size:");

 push printDirEntry_9
 call cputs
 add  sp, 2
;-785 	printlong(dir_FileSize);

 push dword [dir_FileSize]
 call printlong
 add  sp, 4
;-786 	

;-787 }

;-788 

;-789 // 2.b

;-790 int fatDirSectorList(unsigned long startSector, unsigned long numsectors) {

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
;-791     char *p;

;-792 	unsigned int EndDiskBuf;

;-793 	char isHide;//shows entries, NOT lfn, deleted or empty

;-794 	unsigned int EntryNr;

;-795 	EntryNr=0;

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
;-796 	do {

.fatDirSectorList105:
;-797 /*		putch(10);

;-798 		cputs("Sektor = "); 

;-799 		printlong(startSector);

;-800 		cputs(", numsectors = "); 

;-801 		printlong(numsectors);

;-802 		getkey();

;-803 */

;-804 		readLogical(startSector);

 push dword [bp+4]
 call readLogical
 add  sp, 4
;-805 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-806 		EndDiskBuf= p + bs_sect_size;		

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-807 		

;-808 		do {

.fatDirSectorList106:
;-809 			memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-810 			memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-811 			filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-812 			

;-813 			isHide=0;//show in listing

 mov ax, 0
 mov [bp-6], al
;-814 			if (*p ==    0) {//only empty entries following

 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorList107
;-815 				isHide++;

 inc  byte[bp-6]
;-816 				numsectors=1;//finish searching

 mov ax, 1
 mov [bp+8], eax
;-817 				p = EndDiskBuf;

 mov ax, [bp-4]
 mov [bp-2], ax
;-818 				}

;-819 			if (*p == 0xE5) isHide++;//deleted, free entry

.fatDirSectorList107:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 229
 jne .fatDirSectorList108
 inc  byte[bp-6]
;-820 			if (*p <=   31) isHide++;//part of LFN

.fatDirSectorList108:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 31
 jg  .fatDirSectorList109
 inc  byte[bp-6]
;-821 			if (dir_Attrib ==    15) isHide++;//LFN start

.fatDirSectorList109:
 mov al, [dir_Attrib]
 cmp al, 15
 jne .fatDirSectorList110
 inc  byte[bp-6]
;-822 					

;-823 			if (isHide == 0) printDirEntry(EntryNr);

.fatDirSectorList110:
 mov al, [bp-6]
 cmp al, 0
 jne .fatDirSectorList111
 push word [bp-8]
 call printDirEntry
 add  sp, 2
;-824 			p+=32;//get next entry

.fatDirSectorList111:
 add  word[bp-2], 32
;-825 			EntryNr++;

 inc  word[bp-8]
;-826 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorList112
 jmp .fatDirSectorList106
.fatDirSectorList112:
;-827 		startSector = startSector + 1;//long, do NOT use ++ or +=1

 mov eax, [bp+4]
 add eax, 1
 mov [bp+4], eax
;-828 		numsectors--;

 dec  dword[bp+8]
;-829 //mdump(DiskBuf, 512);

;-830 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorList113
 jmp .fatDirSectorList105
.fatDirSectorList113:
;-831 	CurCluster=0;//not found but not end

 mov ax, 0
 mov word [CurCluster], ax
;-832 }

;-833 

;-834 // 2.

;-835 int fatDirSectorSearch(unsigned long startSector,unsigned long numsectors) {

 LEAVE
 ret
ENDP

fatDirSectorSearch: PROC
;-836     //search for file name. IN:searchstr

;-837     char *p;

;-838 	unsigned int EndDiskBuf;

;-839 	fatfound=0;

;Function : fatDirSectorSearch, Number local Var: 4
; # type sign width local variables
;100 var unsg long startSector = bp+4
;101 var unsg long numsectors = bp+8
;102 ptr sign byte p = bp-2
;103 var unsg word EndDiskBuf = bp-4;
 ENTER  4,0
 mov ax, 0
 mov byte [fatfound], al
;-840 	do {

.fatDirSectorSearch114:
;-841 		readLogical(startSector);

 push dword [bp+4]
 call readLogical
 add  sp, 4
;-842 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-843 		EndDiskBuf= p + bs_sect_size;

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-844 		do {

.fatDirSectorSearch115:
;-845 			if (memcmp(p, searchstr, 11) == 0) {//found file name

 push 11
 lea  ax, [searchstr]
 push ax
 push word [bp-2]
 call memcmp
 add  sp, 6
 cmp ax, 0
 jne .fatDirSectorSearch116
;-846 				memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-847 				memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-848 				filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-849 				CurCluster   = dir_FirstCluster;

 mov ax, [dir_FirstCluster]
 mov word [CurCluster], ax
;-850 				FileSizeL  = dir_FileSize;

 mov eax, [dir_FileSize]
 mov dword [FileSizeL], eax
;-851 				fatfound=1;

 mov ax, 1
 mov byte [fatfound], al
;-852 			}

;-853 			if (*p == 0) return; //only empty entries following

.fatDirSectorSearch116:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorSearch117
 jmp .retnfatDirSectorSearch
;-854 			p+=32;//get next entry

.fatDirSectorSearch117:
 add  word[bp-2], 32
;-855 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorSearch118
 jmp .fatDirSectorSearch115
.fatDirSectorSearch118:
;-856 		startSector++;		

 inc  dword[bp+4]
;-857 		numsectors--;

 dec  dword[bp+8]
;-858 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorSearch119
 jmp .fatDirSectorSearch114
.fatDirSectorSearch119:
;-859 	CurCluster=0;//not found but not end

 mov ax, 0
 mov word [CurCluster], ax
;-860 }

;-861 

;-862 /*

;-863 // 3.

;-864 int fatRootSearch() {

;-865     fatDirSectorSearch(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-866 //	getkey();

;-867 //    fatDirSectorList(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-868 }

;-869 */

;-870 // 4.

;-871 int fatClusterAnalyse(unsigned int clust) {

 .retnfatDirSectorSearch:
 LEAVE
 ret
ENDP

fatClusterAnalyse: PROC
;-872 //OUT: CurSectorL, NextCluster

;-873 	unsigned long fatSectorL;

;-874 	unsigned int offset;

;-875 	char *p;

;-876 unsigned long offL;

;-877 

;-878 	CurSectorL = (long) clust - 2;

;Function : fatClusterAnalyse, Number local Var: 5
; # type sign width local variables
;100 var unsg word clust = bp+4
;101 var unsg long fatSectorL = bp-4
;102 var unsg word offset = bp-6
;103 ptr sign byte p = bp-8
;104 var unsg long offL = bp-12;
 ENTER  12,0
 xor eax, eax
 mov ax, [bp+4]
 sub ax, 2
 mov dword [CurSectorL], eax
;-879 	CurSectorL = CurSectorL * clust_sizeL;

 mov eax, [CurSectorL]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul dword [clust_sizeL]
 mov dword [CurSectorL], eax
;-880 	CurSectorL = CurSectorL + fat_DataStartSectorL;

 mov eax, [CurSectorL]
 add eax, [fat_DataStartSectorL]
 mov dword [CurSectorL], eax
;-881 	

;-882 //	fatSectorL=cluster*2/512+FatStartSector

;-883 	fatSectorL = (long) clust;

 xor eax, eax
 mov ax, [bp+4]
 mov [bp-4], eax
;-884 	fatSectorL = fatSectorL + fatSectorL;

 mov eax, [bp-4]
 add eax, [bp-4]
 mov [bp-4], eax
;-885 	fatSectorL = fatSectorL / sector_sizeL;		

 mov eax, [bp-4]
 xor edx, edx
 div dword [sector_sizeL]
 mov [bp-4], eax
;-886 	fatSectorL = fatSectorL + fat_FatStartSectorL; 

 mov eax, [bp-4]
 add eax, [fat_FatStartSectorL]
 mov [bp-4], eax
;-887 	readLogical(fatSectorL);

 push dword [bp-4]
 call readLogical
 add  sp, 4
;-888 	

;-889 	offset = clust + clust;//todo overflow?

 mov ax, [bp+4]
 add ax, [bp+4]
 mov [bp-6], ax
;-890 	offset = offset % bs_sect_size;

 mov ax, [bp-6]
 xor dx, dx
 div word [bs_sect_size]
 mov ax, dx
 mov [bp-6], ax
;-891 	

;-892 	p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-8], ax
;-893 	p = p + offset;	

 mov ax, [bp-8]
 add ax, [bp-6]
 mov [bp-8], ax
;-894 	memcpy(&NextCluster, p, 2);//OUT: NextCluster

 push 2
 push word [bp-8]
 lea  ax, [NextCluster]
 push ax
 call memcpy
 add  sp, 6
;-895 }

;-896 /*

;-897 // 5.

;-898 int fatDirSearch() {//search a directory chain. IN:searchstr

;-899 	

;-900 	fatClusterAnalyse(fatfile_cluster);

;-901 	//OUT: fatfile_sectorStartL, fatfile_nextCluster

;-902 

;-903 	fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster); 

;-904 	while (fatfile_cluster == 0) {//not found but not end

;-905 		if (fatfile_nextCluster >= 0xFFF8) {

;-906 			fat_notfound=1;

;-907 			return;	

;-908 		}		

;-909 		fatfile_cluster=fatfile_nextCluster;

;-910 		fatClusterAnalyse(fatfile_cluster);

;-911 		fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster);

;-912 	}	

;-913 }

;-914 */	

;-915 

;-916 int is_delimiter(char *s) {

 LEAVE
 ret
ENDP

is_delimiter: PROC
;-917 	if (*s == '/' ) return 1;

;Function : is_delimiter, Number local Var: 1
; # type sign width local variables
;100 ptr sign byte s = bp+4;
 ENTER  0,0
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 47
 jne .is_delimiter120
 mov ax, 1
 jmp .retnis_delimiter
;-918 	if (*s == '\\') return 1;

.is_delimiter120:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 92
 jne .is_delimiter121
 mov ax, 1
 jmp .retnis_delimiter
;-919 	if (*s ==    0) return 2;

.is_delimiter121:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .is_delimiter122
 mov ax, 2
 jmp .retnis_delimiter
;-920 	if (*s ==  '.') return 3;

.is_delimiter122:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 46
 jne .is_delimiter123
 mov ax, 3
 jmp .retnis_delimiter
;-921 	return 0;

.is_delimiter123:
 mov ax, 0
 jmp .retnis_delimiter
;-922 }

;-923 

;-924 // 6.

;-925 int fatNextSearch() {//get next part of filename to do a search

 .retnis_delimiter:
 LEAVE
 ret
ENDP

fatNextSearch: PROC
;-926 //	IN:  upto: points to start of search in filename 

;-927 //	OUT: upto: points to search for next time

;-928 //	OUT: searchstr: part of filename in DIR-format with blanks (11bytes)

;-929 //	OUT: isfilename: 0=part of directory, 1=filename

;-930 //	OUT: fatfound

;-931 	char *searchstrp;

;-932 	char *p; 

;-933 	unsigned int  len;

;-934 	unsigned int delimiter;

;-935 

;-936 	delimiter=is_delimiter(upto);

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
;-937 	if (delimiter == 1) upto++;

 mov ax, [bp-8]
 cmp ax, 1
 jne .fatNextSearch124
 inc  word[upto]
;-938 	if (delimiter == 2) return; 

.fatNextSearch124:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch125
 jmp .retnfatNextSearch
;-939 

;-940 	strcpy(&searchstr, "           ");//11 blank padded

.fatNextSearch125:
 push fatNextSearch_0
 lea  ax, [searchstr]
 push ax
 call strcpy
 add  sp, 4
;-941 	searchstrp = &searchstr;//clear searchstr

 mov ax, searchstr
 mov [bp-2], ax
;-942 	len=0;

 mov ax, 0
 mov [bp-6], ax
;-943 	delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-944 	while (delimiter == 0) { //no slash, zero, point

.fatNextSearch126:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch127
;-945 		*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-946 		searchstrp++;

 inc  word[bp-2]
;-947 		upto++;	

 inc  word[upto]
;-948 		len++;

 inc  word[bp-6]
;-949 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-950 	} 

;-951 	if (len > 8) return;

 jmp .fatNextSearch126
.fatNextSearch127:
 mov ax, [bp-6]
 cmp ax, 8
 jle .fatNextSearch128
 jmp .retnfatNextSearch
;-952 	isfilename=0;//todo: default directory, not yet implemented

.fatNextSearch128:
 mov ax, 0
 mov byte [isfilename], al
;-953 	if (delimiter == 2) isfilename=1;//last name is always a file name

 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch129
 mov ax, 1
 mov byte [isfilename], al
;-954 	if (delimiter == 3) {//remove dot in name		

.fatNextSearch129:
 mov ax, [bp-8]
 cmp ax, 3
 jne .fatNextSearch130
;-955 		searchstrp = &searchstr;

 mov ax, searchstr
 mov [bp-2], ax
;-956 		searchstrp += 8;//start extension		

 add  word[bp-2], 8
;-957 		len=0;

 mov ax, 0
 mov [bp-6], ax
;-958 		upto++;

 inc  word[upto]
;-959 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-960 		while (delimiter == 0) { //no slash, zero, point

.fatNextSearch131:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch132
;-961 			*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-962 			searchstrp++;

 inc  word[bp-2]
;-963 			upto++;	

 inc  word[upto]
;-964 			len++;

 inc  word[bp-6]
;-965 			delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-966 		} 

;-967 		if (len > 3) return;

 jmp .fatNextSearch131
.fatNextSearch132:
 mov ax, [bp-6]
 cmp ax, 3
 jle .fatNextSearch133
 jmp .retnfatNextSearch
;-968 		if (delimiter == 2) isfilename=1;//last name is always a file name

.fatNextSearch133:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch134
 mov ax, 1
 mov byte [isfilename], al
;-969 	}

.fatNextSearch134:
;-970 	fatfound=1;	

.fatNextSearch130:
 mov ax, 1
 mov byte [fatfound], al
;-971 }

;-972 

;-973 // 7.

;-974 int fatGetStartCluster() {//lastBytes, lastSectors

 .retnfatNextSearch:
 LEAVE
 ret
fatNextSearch_0 db "           ",0
ENDP

fatGetStartCluster: PROC
;-975 	fatfound=0;

 mov ax, 0
 mov byte [fatfound], al
;-976 	upto = &filename;

 mov ax, filename
 mov word [upto], ax
;-977 	fatNextSearch();//6 get next part of file name

 call fatNextSearch
;-978 

;-979 	if (debug) {putch(10); cputsLen(searchstr, 11); }

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
;-980 	if (isfilename == 0) return; //todo not implemented

.fatGetStartCluster135:
 mov al, [isfilename]
 cmp al, 0
 jne .fatGetStartCluster136
 jmp .retnfatGetStartCluster
;-981 	if (fatfound) fatDirSectorSearch(fat_RootDirStartSectorL,

.fatGetStartCluster136:
 mov al, [fatfound]
 or  al, al
 je .fatGetStartCluster137
;-982 	fat_RootDirSectorsL); //2 todo: only root search

 push dword [fat_RootDirSectorsL]
 push dword [fat_RootDirStartSectorL]
 call fatDirSectorSearch
 add  sp, 8
;-983 }

.fatGetStartCluster137:
;-984 

;-985 

;-986 // 8.

;-987 int fatOpenFile() {//set handle for root or subdir

 .retnfatGetStartCluster:
 ret
ENDP

fatOpenFile: PROC
;-988 //	fat_notfound=0;

;-989 	if (debug) cputs(".fatOpenfile ");	

 mov ax, 1
 or  al, al
 je .fatOpenFile138
 push fatOpenFile_0
 call cputs
 add  sp, 2
;-990 	handle=3;//todo

.fatOpenFile138:
 mov ax, 3
 mov byte [handle], al
;-991 	

;-992 	fatGetStartCluster();// 7.

 call fatGetStartCluster
;-993 	if (fatfound == 0) { cputs(" file not found"); return; }

 mov al, [fatfound]
 cmp al, 0
 jne .fatOpenFile139
 push fatOpenFile_1
 call cputs
 add  sp, 2
 jmp .retnfatOpenFile
;-994 	lastBytesL = FileSizeL % bytes_per_clusterL;	

.fatOpenFile139:
 mov eax, [FileSizeL]
 xor edx, edx
 div dword [bytes_per_clusterL]
 mov eax, edx
 mov dword [lastBytesL], eax
;-995 	lastSectorsL = lastBytesL / sector_sizeL;

 mov eax, [lastBytesL]
 xor edx, edx
 div dword [sector_sizeL]
 mov dword [lastSectorsL], eax
;-996 	lastBytesL = lastBytesL % sector_sizeL;

 mov eax, [lastBytesL]
 xor edx, edx
 div dword [sector_sizeL]
 mov eax, edx
 mov dword [lastBytesL], eax
;-997 	

;-998 	if (FileSizeL == 0) isfilename = 0;

 mov eax, [FileSizeL]
 cmp eax, 0
 jne .fatOpenFile140
 mov ax, 0
 mov byte [isfilename], al
;-999 	else isfilename = 1;

 jmp .fatOpenFile141
.fatOpenFile140:
 mov ax, 1
 mov byte [isfilename], al
;-1000 

;-1001 	fatClusterAnalyse(CurCluster);// 4. OUT:CurSectorL,NextCluster

.fatOpenFile141:
 push word [CurCluster]
 call fatClusterAnalyse
 add  sp, 2
;-1002 //		fatfile_sectorCount = (int) bs_clust_size;

;-1003 	

;-1004 //	fatfile_currentCluster = fatfile_cluster;

;-1005 //	fatfile_sectorUpto = 0;

;-1006 //	fatfile_byteUpto   = 0;

;-1007 //	if (fat_notfound) return 1;

;-1008 

;-1009 	if (debug) {

 mov ax, 1
 or  al, al
 je .fatOpenFile142
;-1010 		cputs(" CurCluster="); 	printunsign(CurCluster);

 push fatOpenFile_2
 call cputs
 add  sp, 2
 push word [CurCluster]
 call printunsign
 add  sp, 2
;-1011 		cputs(",CurSectorL=");	printlong(CurSectorL);

 push fatOpenFile_3
 call cputs
 add  sp, 2
 push dword [CurSectorL]
 call printlong
 add  sp, 4
;-1012 		cputs(",ClusterSizeL=");printlong(clust_sizeL);

 push fatOpenFile_4
 call cputs
 add  sp, 2
 push dword [clust_sizeL]
 call printlong
 add  sp, 4
;-1013 		cputs(",FileSizeL="); 	printlong(FileSizeL);

 push fatOpenFile_5
 call cputs
 add  sp, 2
 push dword [FileSizeL]
 call printlong
 add  sp, 4
;-1014 		cputs(",NextCluster="); printunsign(NextCluster);

 push fatOpenFile_6
 call cputs
 add  sp, 2
 push word [NextCluster]
 call printunsign
 add  sp, 2
;-1015 		cputs(",lastSectorsL="); printlong(lastSectorsL);

 push fatOpenFile_7
 call cputs
 add  sp, 2
 push dword [lastSectorsL]
 call printlong
 add  sp, 4
;-1016 		cputs(",lastBytesL="); 	printlong(lastBytesL);

 push fatOpenFile_8
 call cputs
 add  sp, 2
 push dword [lastBytesL]
 call printlong
 add  sp, 4
;-1017 		putch(10); 

 push 10
 call putch
 add  sp, 2
;-1018 	}

;-1019 }

.fatOpenFile142:
;-1020 

;-1021 

;-1022 // 9.

;-1023 int fatReadFile() {// reads 1 byte from an already open file

 .retnfatOpenFile:
 ret
fatOpenFile_0 db ".fatOpenfile ",0
fatOpenFile_1 db " file not found",0
fatOpenFile_2 db " CurCluster=",0
fatOpenFile_3 db ",CurSectorL=",0
fatOpenFile_4 db ",ClusterSizeL=",0
fatOpenFile_5 db ",FileSizeL=",0
fatOpenFile_6 db ",NextCluster=",0
fatOpenFile_7 db ",lastSectorsL=",0
fatOpenFile_8 db ",lastBytesL=",0
ENDP

fatReadFile: PROC
;-1024 //	IN: CurCluster, FileSizeL

;-1025 	readLogical(CurSectorL);

 push dword [CurSectorL]
 call readLogical
 add  sp, 4
;-1026 	mdump(DiskBuf, 512);

 push 512
 lea  ax, [DiskBuf]
 push ax
 call mdump
 add  sp, 4
;-1027 	dumpASCII(DiskBuf, 512);

 push 512
 lea  ax, [DiskBuf]
 push ax
 call dumpASCII
 add  sp, 4
;-1028 	

;-1029 	BufferPtr = &Buffer;

 mov ax, Buffer
 mov word [BufferPtr], ax
;-1030 	memcpy(BufferPtr, DiskBuf, 512);

 push 512
 lea  ax, [DiskBuf]
 push ax
 push word [BufferPtr]
 call memcpy
 add  sp, 6
;-1031 	mdump(BufferPtr, 512);

 push 512
 push word [BufferPtr]
 call mdump
 add  sp, 4
;-1032 	dumpASCII(BufferPtr, 512);

 push 512
 push word [BufferPtr]
 call dumpASCII
 add  sp, 4
;-1033 	

;-1034 		

;-1035 }

;-1036 //------------------------------- OS functions --------------

;-1037 //handle: 0=in, 1=out, 2=err, 255=error

;-1038 // 10.

;-1039 int OSOpenFile(char *name) {

 ret
ENDP

OSOpenFile: PROC
;-1040 //remove drive letter, slash. uppercase and copy to filename

;-1041 	unsigned int i;

;-1042 	handle=255;//default=error

;Function : OSOpenFile, Number local Var: 2
; # type sign width local variables
;100 ptr sign byte name = bp+4
;101 var unsg word i = bp-2;
 ENTER  2,0
 mov ax, 255
 mov byte [handle], al
;-1043 	strcpy(filename, name);

 push word [bp+4]
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1044 	toupper(filename);

 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-1045 

;-1046 	if (strlen(filename) == 0) return;

 lea  ax, [filename]
 push ax
 call strlen
 add  sp, 2
 cmp ax, 0
 jne .OSOpenFile143
 jmp .retnOSOpenFile
;-1047 	i=strchr(filename, ':');

.OSOpenFile143:
 push 58
 lea  ax, [filename]
 push ax
 call strchr
 add  sp, 4
 mov [bp-2], ax
;-1048 	if (i) {

 mov ax, [bp-2]
 or  al, al
 je .OSOpenFile144
;-1049 		i++;

 inc  word[bp-2]
;-1050 		strcpy(filename, i);	

 push word [bp-2]
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1051 		if (strlen(filename) == 0) return;	

 lea  ax, [filename]
 push ax
 call strlen
 add  sp, 2
 cmp ax, 0
 jne .OSOpenFile145
 jmp .retnOSOpenFile
;-1052 	}	

.OSOpenFile145:
;-1053 //todo: add working directory page 18

;-1054 	if(is_delimiter(filename) == 1) filename++;

.OSOpenFile144:
 lea  ax, [filename]
 push ax
 call is_delimiter
 add  sp, 2
 cmp ax, 1
 jne .OSOpenFile146
 inc  byte[filename]
;-1055 //	if (debug) {cputs(" filename=");cputs(filename);}		

;-1056 	

;-1057 	fatOpenFile();

.OSOpenFile146:
 call fatOpenFile
;-1058 }

;-1059 

;-1060 // 11.

;-1061 int OSReadFile(char hd) {

 .retnOSOpenFile:
 LEAVE
 ret
ENDP

OSReadFile: PROC
;-1062 	fatReadFile();

;Function : OSReadFile, Number local Var: 1
; # type sign width local variables
;100 var sign byte hd = bp+4;
 ENTER  0,0
 call fatReadFile
;-1063 }

;-1064 

;-1065 int OSShowFile(char hd) {

 LEAVE
 ret
ENDP

OSShowFile: PROC
;-1066 	mdump(Buffer, FileSizeL);

;Function : OSShowFile, Number local Var: 1
; # type sign width local variables
;100 var sign byte hd = bp+4;
 ENTER  0,0
 push dword [FileSizeL]
 lea  ax, [Buffer]
 push ax
 call mdump
 add  sp, 6
;-1067 }

;-1068 

;-1069 int OSStartCOM(char hd) {

 LEAVE
 ret
ENDP

OSStartCOM: PROC
;-1070 	

;-1071 }

;Function : OSStartCOM, Number local Var: 1
; # type sign width local variables
;100 var sign byte hd = bp+4;
 ENTER  0,0
;-1072 

;-1073 

;-1074 //------------------------------- Init,  main ---------------

;-1075 int Init() {

 LEAVE
 ret
ENDP

Init: PROC
;-1076 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-1077 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-1078 	if (debug) cputs(" Init");

 mov ax, 1
 or  al, al
 je .Init147
 push Init_0
 call cputs
 add  sp, 2
;-1079 	if (Params()) cputs(" ** NO DRIVE PARAMS FOUND **");//no hard disk

.Init147:
 call Params
 or  al, al
 je .Init148
 push Init_1
 call cputs
 add  sp, 2
;-1080 	if (readMBR() == 0) {//0=error,1=FAT12,6=FAT16,11=FAT32	

.Init148:
 call readMBR
 cmp al, 0
 jne .Init149
;-1081 		cputs(" ** no active FAT partition found **");

 push Init_2
 call cputs
 add  sp, 2
;-1082 		return 1;

 mov ax, 1
 jmp .retnInit
;-1083 		}

;-1084 	if(getBootSector()==0) 	return 1;

.Init149:
 call getBootSector
 cmp al, 0
 jne .Init150
 mov ax, 1
 jmp .retnInit
;-1085 	if (FATInit())			return 1;

.Init150:
 call FATInit
 or  al, al
 je .Init151
 mov ax, 1
 jmp .retnInit
;-1086 	if(trueFATtype != 16) 	return 1;

.Init151:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init152
 mov ax, 1
 jmp .retnInit
;-1087 	Int13hExt();

.Init152:
 call Int13hExt
;-1088 	return 0;

 mov ax, 0
 jmp .retnInit
;-1089 }

;-1090 

;-1091 int main() {

 .retnInit:
 ret
Init_0 db " Init",0
Init_1 db " ** NO DRIVE PARAMS FOUND **",0
Init_2 db " ** no active FAT partition found **",0
ENDP

main: PROC
;-1092 	if (Init() != 0) return 1;

 call Init
 cmp al, 0
 je  .main153
 mov ax, 1
 jmp .retnmain
;-1093 	if (debug) PrintDriveParameter();

.main153:
 mov ax, 1
 or  al, al
 je .main154
 call PrintDriveParameter
;-1094 	

;-1095 	OSOpenFile("dos.co");	

.main154:
 push main_0
 call OSOpenFile
 add  sp, 2
;-1096 	if (handle == 255) cputs(" **no handle**");		

 mov al, [handle]
 cmp al, 255
 jne .main155
 push main_1
 call cputs
 add  sp, 2
;-1097 	if (handle < 0) cputs(" **handle < 0**");		

.main155:
 mov al, [handle]
 cmp al, 0
 jge .main156
 push main_2
 call cputs
 add  sp, 2
;-1098 	OSOpenFile("fdconfig.sys");	

.main156:
 push main_3
 call OSOpenFile
 add  sp, 2
;-1099 	if (handle == 255) cputs(" **no handle**");	

 mov al, [handle]
 cmp al, 255
 jne .main157
 push main_4
 call cputs
 add  sp, 2
;-1100 	OSReadFile();

.main157:
 call OSReadFile
;-1101 

;-1102 /*	OSOpenFile("C:cm.bat");	

;-1103 	if (handle == 255) cputs(" **no handle**");		

;-1104 /*	OSOpenFile("ab:/z");	

;-1105 	if (handle == 255) cputs(" **no handle**");	

;-1106 	OSOpenFile("C:");	

;-1107 	if (handle == 255) cputs(" **no handle**");	

;-1108 	OSOpenFile("/test.ba");	

;-1109 	if (handle == 255) cputs(" **no handle**");	

;-1110 */

;-1111 	if (debug) cputs(".End.");

 mov ax, 1
 or  al, al
 je .main158
 push main_5
 call cputs
 add  sp, 2
;-1112 }

.main158:
;-1113 /*cputs(" delimiter="); printunsign(delimiter);

;-1114 cputs(", isfilename="); printunsign(isfilename);

;-1115 cputs(", upto="); printunsign(upto);

;-1116 cputs("="); cputs(upto);

;-1117 cputs(", len="); printunsign(len);

;-1118 cputs(", searchstr="); cputsLen(searchstr, len);

;-1119 */

;-1120 /*

;-1121 11	OSReadFile

;-1122 	9 fatReadFile

;-1123 	

;-1124 10	OSOpenFile drive,slash,upper,to filename

;-1125 	8 fatOpenFile

;-1126 9. fatReadFile

;-1127 	1 readLogical

;-1128 	4 fatClusterAnalyse

;-1129 8. fatOpenFile set handle, init root or subdir

;-1130 	s7 fatGetStartCluster

;-1131 	s4 fatClusterAnalyse

;-1132 7. fatGestStartCluster

;-1133 	6 fatNextSearch

;-1134 	3 fatRootSearch

;-1135 	s5 fatDirSearch

;-1136 6. fatNextSearch Upto,search,isFilename =>7

;-1137 5. fatDirSearch a directory chain for search

;-1138 	4 fatClusterAnalyse

;-1139 	2 fatDieSectorSearch

;-1140 4. fatClusterAnalyse determines sector by cluster number, next cluster

;-1141 	1 ReadLogical

;-1142 3. fatRootSearch search the root for an entry

;-1143 	2 fatDirSectorSearch

;-1144 2. fatDirSectorSearch search a block of sectors for entries,

;-1145 		get starting cluster, file size, notfound

;-1146 	1 readLogical

;-1147 2.a printDirEntry

;-1148 2.b fatDirSectorList

;-1149 	1 readLogical					

;-1150 1. readLogical

;-1151 	DiskSectorReadWrite	

;-1152 */

;-1153 /*

;-1154 bin_file=fopen("name", "rb") //binary

;-1155 int = fgetc(in_file)	     //EOF(-1)

;-1156 fputc(character, file)

;-1157 printf() = fprintf(stdout, format, parameter1) //buffered I/O

;-1158 DOS: add CR13 to LF10

;-1159 read_size=fread(data_ptr, 1, size, file) //binary read

;-1160 file_descriptor=open(name, flags, mode=0666) //unbuffered I/O

;-1161 read_size=read(file_descriptor, buffer, size) //unbufferes I/O 

;-1162 */

 .retnmain:
 ret
main_0 db "dos.co",0
main_1 db " **no handle**",0
main_2 db " **handle < 0**",0
main_3 db "fdconfig.sys",0
main_4 db " **no handle**",0
main_5 db ".End.",0
ENDP
