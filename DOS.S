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
;-24 unsigned int  BytesAreRead;

BytesAreRead dw 0
;-25 unsigned long Sector;

Sector dd 0
;-26 

;-27 char *upto;		//IN:part of filename to search/OUT:to search next time

upto dw 0
;-28 char isfilename;//0=part of directory or 1=filename

isfilename db 0
;-29 #define BUFFERSIZE 35000

;-30 unsigned char Buffer [BUFFERSIZE];

section .bss
absolute 16976
Buffer resb 35000
section .text
;-31 char *BufferPtr;

BufferPtr dw 0
;-32 

;-33 //start array of handles of every open file

;-34 unsigned int  CurrentCluster;

CurrentCluster dw 0
;-35 unsigned int  NextCluster;

NextCluster dw 0
;-36 unsigned long StartSectorL;		//start sector in current cluster

StartSectorL dd 0
;-37 unsigned long FileSizeL;

FileSizeL dd 0
;-38 unsigned int  lastBytes;		//resting bytes in a sector

lastBytes dw 0
;-39 unsigned int  lastSectors;		//resting sectors in a cluster

lastSectors dw 0
;-40 unsigned int  sectorUpto;		//??

sectorUpto dw 0
;-41 unsigned int  byteUpto;			//??

byteUpto dw 0
;-42 

;-43 unsigned int  CurPosition;		//current byte location in cur sector

CurPosition dw 0
;-44 unsigned long FilePointerL;		//current byte location in file

FilePointerL dd 0
;-45 //	end array of handles of every open file

;-46 

;-47 //FATInit

;-48 unsigned int  fat_FatStartSector;

fat_FatStartSector dw 0
;-49 unsigned long fat_FatStartSectorL;

fat_FatStartSectorL dd 0
;-50 unsigned int  fat_FatSectors;

fat_FatSectors dw 0
;-51 unsigned int  fat_Entries;

fat_Entries dw 0
;-52 unsigned long fat_RootDirStartSectorL;

fat_RootDirStartSectorL dd 0
;-53 unsigned long fat_RootDirSectorsL;

fat_RootDirSectorsL dd 0
;-54 unsigned long fat_DataStartSectorL;

fat_DataStartSectorL dd 0
;-55 unsigned long num_tracksL;

num_tracksL dd 0
;-56 unsigned long Sectors_per_cylinderL;

Sectors_per_cylinderL dd 0
;-57 unsigned long DataSectors32;

DataSectors32 dd 0
;-58 unsigned long CountofClustersL;

CountofClustersL dd 0
;-59 unsigned char trueFATtype;	//12, 16, 32 from FATInit

trueFATtype db 0
;-60 unsigned long bytes_per_clusterL;

bytes_per_clusterL dd 0
;-61 

;-62 //Params from int13h, Function 8

;-63 unsigned int  pa_Cylinders;

pa_Cylinders dw 0
;-64 unsigned char pa_Sectors;

pa_Sectors db 0
;-65 unsigned char pa_Heads;

pa_Heads db 0
;-66 unsigned char pa_Attached;

pa_Attached db 0
;-67 unsigned int  pt_PartNo;

pt_PartNo dw 0
;-68 

;-69 //start hard disk partition structure 16 bytes in MBR. do not change!!!!!

;-70 unsigned char pt_Bootable;		// 00 80h = active partition, else 00

pt_Bootable db 0
;-71 unsigned char pt_StartHead;		// 01

pt_StartHead db 0
;-72 unsigned char pt_StartSector;	// 02 bits 0-5

pt_StartSector db 0
;-73 unsigned int  pt_StartCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-74 unsigned char pt_FileSystem;	// 04 0=nu,1=FAT12,4=16,5=ExtP,6=large16

pt_FileSystem db 0
;-75 unsigned char pt_EndHead;		// 05

pt_EndHead db 0
;-76 unsigned char pt_EndSector;		// 06 bits 0-5

pt_EndSector db 0
;-77 unsigned int  pt_EndCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-78 unsigned long pt_HiddenSector;	// 08 sectors preceding partition

pt_HiddenSector dd 0
;-79 unsigned long pt_PartLen;    	// 12 length of partition in sectors

pt_PartLen dd 0
;-80 //  16 end hard disk partition structure

;-81 

;-82 //start boot BIOS Parameter Block structure. do not change!!!!!

;-83 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-84 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-85 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-86 unsigned char bs_clust_size;// 13 sectors per CurrentCluster (1,2,4,..,128)

bs_clust_size db 0
;-87 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-88 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-89 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-90 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-91 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-92 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-93 unsigned int  bs_sectors_per_track; // 24 (DOS 3+)sectors per track

bs_sectors_per_track dw 0
;-94 unsigned int  bs_num_heads;	// 26 (DOS 3+)number of heads

bs_num_heads dw 0
;-95 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors

bs_hid_sects dd 0
;-96 unsigned long bs_tot_sect32;// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-97 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-98 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-99 unsigned char bs_ext_signat;// 38 (DOS 4+) Ext. signature,get next 3(29h)

bs_ext_signat db 0
;-100 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-101 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-102 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-103 // 62 end boot BIOS Parameter Block

;-104 

;-105 //start directory entry structure, do not change!!!!!

;-106 unsigned char dir_Filename[]="1234567";	//00 +lengthbyte=11

dir_Filename db "1234567",0
;-107 unsigned char dir_Ext[]="12";	//07 +lengthbyte=3

dir_Ext db "12",0
;-108 unsigned char dir_Attrib;		//11 directory=10h, Label=08h, read only=1

dir_Attrib db 0
;-109 unsigned char dir_NTReserved;	//12 low case in body=8h, in ext=10h

dir_NTReserved db 0
;-110 unsigned char dir_TimeCreatedMS;//13 in 10 milliseconda or zero

dir_TimeCreatedMS db 0
;-111 unsigned int  dir_TimeCreated;	//14 creation time, resolution 2 sec. or 0

dir_TimeCreated dw 0
;-112 unsigned int  dir_DateCreated;	//16 creation date or zero

dir_DateCreated dw 0
;-113 unsigned int  dir_DateLastAccessd;		//18 no time info available or zero

dir_DateLastAccessd dw 0
;-114 unsigned int  dir_FirstClusterHiBytes;	//20 FAT12/16 always zero

dir_FirstClusterHiBytes dw 0
;-115 unsigned int  dir_LastModTime;	//22 modification time on closing

dir_LastModTime dw 0
;-116 unsigned int  dir_LastModDate;	//24 modification date on closing

dir_LastModDate dw 0
;-117 unsigned int  dir_FirstCluster;	//26 1.clu. of file data,if filesize=0 then0

dir_FirstCluster dw 0
;-118 unsigned long dir_FileSize;		//28 size in bytes, if directory then zero

dir_FileSize dd 0
;-119 // 32 end direcctory entry structure

;-120 

;-121 int test() {


test: PROC
;-122 	__asm{


;-123 }	}


;-124 

;-125 //------------------------------------   IO  -------------------

;-126 

;-127 int writetty()     {//char in AL

 ret
ENDP

writetty: PROC
;-128     ah=0x0E;

 mov  ah, 14
;-129     push bx;

push bx;
;-130     bx=0;			//page in BH

 mov  bx, 0
;-131     inth 0x10;		//16

 int  16
;-132     pop bx;

pop bx;
;-133 }

;-134 int putch(char c)  {

 ret
ENDP

putch: PROC
;-135     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;102 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-136         al=13;

 mov  al, 13
;-137         writetty();

 call writetty
;-138     }

;-139     al=c;

.putch1:
 mov  al, [bp+4]
;-140     writetty();

 call writetty
;-141 }

;-142 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-143     char c;

;-144     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;102 ptr sign byte s = bp+4
;103 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-145         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-146         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-147         s++;

 inc  word[bp+4]
;-148     }

;-149 }

 jmp .cputs2
.cputs3:
;-150 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-151 	char c;

;-152 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;102 ptr sign byte s = bp+4
;103 var sign word len = bp+6
;104 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-153 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-154 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-155 		s++;

 inc  word[bp+4]
;-156 		len--;

 dec  word[bp+6]
;-157 	} while (len > 0);

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-158 }

;-159 

;-160 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-161     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-162     inth 0x16;//AH=Scan code, AL=char

 int  22
;-163 }

;-164 int waitkey() {

 ret
ENDP

waitkey: PROC
;-165     ah=0x11;//get kbd status

 mov  ah, 17
;-166     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-167     //zero flag: 0=IS char, 1=NO char

;-168     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-169 }

;-170 int getkey() {

 ret
ENDP

getkey: PROC
;-171     waitkey();

 call waitkey
;-172     getch();

 call getch
;-173     ah=0;//clear scan code

 mov  ah, 0
;-174     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-175     //put ext code in AX

;-176 }

.getkey6:
;-177 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-178     getkey();

 call getkey
;-179     writetty();//destroys AH

 call writetty
;-180 }

;-181 

;-182 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-183     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;102 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-184     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-185     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-186 }

;-187 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-188     unsigned char nib;

;-189     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;102 var unsg byte c = bp+4
;103 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-190     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-191 }

;-192 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-193     unsigned int half;

;-194     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;102 var unsg word i = bp+4
;103 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-195     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-196 }

;-197 

;-198 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-199     unsigned int e;

;-200     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;102 var unsg word n = bp+4
;103 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-201         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-202         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-203         }

;-204     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-205     n+='0';

 add  word[bp+4], 48
;-206     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-207 }

;-208 

;-209 int printlong(unsigned long L) {

 LEAVE
 ret
ENDP

printlong: PROC
;-210     ax = L;     // get low in ax

;Function : printlong, Number local Var: 1
; # type sign width local variables
;102 var unsg long L = bp+4;
 ENTER  0,0
 mov  ax, [bp+4]
;-211     edx=L;

 mov  edx, [bp+4]
;-212     edx >> 16;  // get high in dx

 shr  edx, 16
;-213 __asm{


;-214   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-215     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-216 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-217     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-218     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-219 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-220     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-221     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-222     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-223     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-224     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-225     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-226     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-227     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-228 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-229 }	writetty();		__asm{


 call writetty

;-230     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-231     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-232     jb      .b             ;Not yet

    jb      .b             ;Not yet
;-233 }


;-234 }

;-235 //--------------------------------  string  ---------------------

;-236 int strlen(char *s) { int c;

 LEAVE
 ret
ENDP

strlen: PROC
;-237     c=0;

;Function : strlen, Number local Var: 2
; # type sign width local variables
;102 ptr sign byte s = bp+4
;103 var sign word c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-238     if (*s == 34) return 0; // "

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 jne .strlen9
 mov ax, 0
 jmp .retnstrlen
;-239     while (*s!=0) {s++; c++;}

.strlen9:
.strlen10:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen11
 inc  word[bp+4]
 inc  word[bp-2]
;-240     return c;

 jmp .strlen10
.strlen11:
 mov ax, [bp-2]
 jmp .retnstrlen
;-241 }

;-242 int strcpy(char *s, char *t) {//new

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-243     while (*t!=0) {

;Function : strcpy, Number local Var: 2
; # type sign width local variables
;102 ptr sign byte s = bp+4
;103 ptr sign byte t = bp+6;
 ENTER  0,0
.strcpy12:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy13
;-244     	*s=*t; s++; t++; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-245     *s=0;

 jmp .strcpy12
.strcpy13:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-246     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-247 }

;-248 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-249     while(*p) {

;Function : eqstr, Number local Var: 2
; # type sign width local variables
;102 ptr sign byte p = bp+4
;103 ptr sign byte q = bp+6;
 ENTER  0,0
.eqstr14:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr15
;-250         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr16
 mov ax, 0
 jmp .retneqstr
;-251         p++;

.eqstr16:
 inc  word[bp+4]
;-252         q++;

 inc  word[bp+6]
;-253     }

;-254     if(*q) return 0;

 jmp .eqstr14
.eqstr15:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr17
 mov ax, 0
 jmp .retneqstr
;-255     return 1;

.eqstr17:
 mov ax, 1
 jmp .retneqstr
;-256 }

;-257 

;-258 int memcmp(char *s, char *t, unsigned int i) {

 .retneqstr:
 LEAVE
 ret
ENDP

memcmp: PROC
;-259     do {

;Function : memcmp, Number local Var: 3
; # type sign width local variables
;102 ptr sign byte s = bp+4
;103 ptr sign byte t = bp+6
;104 var unsg word i = bp+8;
 ENTER  0,0
.memcmp18:
;-260         if (*s < *t) return 0xFFFF;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 jge .memcmp19
 mov ax, 65535
 jmp .retnmemcmp
;-261         if (*s > *t) return 1;

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
;-262         s++; t++; i--;

.memcmp20:
 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-263     } while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcmp21
 jmp .memcmp18
.memcmp21:
;-264     return 0;

 mov ax, 0
 jmp .retnmemcmp
;-265 }

;-266 

;-267 int strcat(char *s, char *t) {

 .retnmemcmp:
 LEAVE
 ret
ENDP

strcat: PROC
;-268     while (*s != 0) s++;

;Function : strcat, Number local Var: 2
; # type sign width local variables
;102 ptr sign byte s = bp+4
;103 ptr sign byte t = bp+6;
 ENTER  0,0
.strcat22:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat23
 inc  word[bp+4]
;-269     strcpy(s, t);

 jmp .strcat22
.strcat23:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4
;-270 }

;-271 int toupper(char *s) {

 LEAVE
 ret
ENDP

toupper: PROC
;-272     while(*s) {

;Function : toupper, Number local Var: 1
; # type sign width local variables
;102 ptr sign byte s = bp+4;
 ENTER  0,0
.toupper24:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper25
;-273         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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
;-274         s++;

.toupper27:
.toupper26:
 inc  word[bp+4]
;-275     }

;-276 }

 jmp .toupper24
.toupper25:
;-277 int strchr(char *s, char c) {

 LEAVE
 ret
ENDP

strchr: PROC
;-278     while(*s) {

;Function : strchr, Number local Var: 2
; # type sign width local variables
;102 ptr sign byte s = bp+4
;103 var sign byte c = bp+6;
 ENTER  0,0
.strchr28:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .strchr29
;-279         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .strchr30
 mov ax, [bp+4]
 jmp .retnstrchr
;-280         s++;

.strchr30:
 inc  word[bp+4]
;-281     }

;-282     return 0;

 jmp .strchr28
.strchr29:
 mov ax, 0
 jmp .retnstrchr
;-283 }

;-284 int memchr(char *s, char c, unsigned int i) {

 .retnstrchr:
 LEAVE
 ret
ENDP

memchr: PROC
;-285     while(i > 0) {

;Function : memchr, Number local Var: 3
; # type sign width local variables
;102 ptr sign byte s = bp+4
;103 var sign byte c = bp+6
;104 var unsg word i = bp+8;
 ENTER  0,0
.memchr31:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr32
;-286         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr33
 mov ax, [bp+4]
 jmp .retnmemchr
;-287         s++; i--;

.memchr33:
 inc  word[bp+4]
 dec  word[bp+8]
;-288     }

;-289     return 0;

 jmp .memchr31
.memchr32:
 mov ax, 0
 jmp .retnmemchr
;-290 }

;-291 int memchr1(char *s, char c, unsigned int i) {

 .retnmemchr:
 LEAVE
 ret
ENDP

memchr1: PROC
;-292 	unsigned int pos;

;-293 	pos=1;

;Function : memchr1, Number local Var: 4
; # type sign width local variables
;102 ptr sign byte s = bp+4
;103 var sign byte c = bp+6
;104 var unsg word i = bp+8
;105 var unsg word pos = bp-2;
 ENTER  2,0
 mov ax, 1
 mov [bp-2], ax
;-294     while(i > 0) {

.memchr134:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr135
;-295         if (*s==c) return pos;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr136
 mov ax, [bp-2]
 jmp .retnmemchr1
;-296         s++; i--; pos++;

.memchr136:
 inc  word[bp+4]
 dec  word[bp+8]
 inc  word[bp-2]
;-297     }

;-298     return 0;

 jmp .memchr134
.memchr135:
 mov ax, 0
 jmp .retnmemchr1
;-299 }

;-300 int instr1(char *s, char c) {

 .retnmemchr1:
 LEAVE
 ret
ENDP

instr1: PROC
;-301     while(*s) {

;Function : instr1, Number local Var: 2
; # type sign width local variables
;102 ptr sign byte s = bp+4
;103 var sign byte c = bp+6;
 ENTER  0,0
.instr137:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .instr138
;-302         if (*s==c) return 1;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .instr139
 mov ax, 1
 jmp .retninstr1
;-303         s++;

.instr139:
 inc  word[bp+4]
;-304     }

;-305     return 0;

 jmp .instr137
.instr138:
 mov ax, 0
 jmp .retninstr1
;-306 }

;-307 

;-308 int memcpy(char *s, char *t, unsigned int i) {

 .retninstr1:
 LEAVE
 ret
ENDP

memcpy: PROC
;-309 	unsigned int r;

;-310 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;102 ptr sign byte s = bp+4
;103 ptr sign byte t = bp+6
;104 var unsg word i = bp+8
;105 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-311 	do {

.memcpy40:
;-312 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-313 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-314 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy41
 jmp .memcpy40
.memcpy41:
;-315 	ax=r;//	return r;

 mov  ax, [bp-2]
;-316 }

;-317 

;-318 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-319     unsigned char c; unsigned char chal; int i; int j; int k;

;-320     j=0;

;Function : mdump, Number local Var: 7
; # type sign width local variables
;102 ptr unsg byte adr = bp+4
;103 var unsg word len = bp+6
;104 var unsg byte c = bp-2
;105 var unsg byte chal = bp-4
;106 var sign word i = bp-6
;107 var sign word j = bp-8
;108 var sign word k = bp-10;
 ENTER  10,0
 mov ax, 0
 mov [bp-8], ax
;-321     k=0;

 mov ax, 0
 mov [bp-10], ax
;-322 	putch(10);

 push 10
 call putch
 add  sp, 2
;-323 	cputs("Ofs=");

 push mdump_0
 call cputs
 add  sp, 2
;-324 	printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-325 	cputs(" Length=");

 push mdump_1
 call cputs
 add  sp, 2
;-326 	printunsign(len);

 push word [bp+6]
 call printunsign
 add  sp, 2
;-327     while (j < len ) {

.mdump42:
 mov ax, [bp-8]
 cmp ax, [bp+6]
 jge .mdump43
;-328 	    k++;;

 inc  word[bp-10]
;-329 	    if (k > 16) {

 mov ax, [bp-10]
 cmp ax, 16
 jle .mdump44
;-330 		    chal = getkey();//remove scan code

 call getkey
 mov [bp-4], al
;-331 		    if (chal =='q') return;

 mov al, [bp-4]
 cmp al, 113
 jne .mdump45
 jmp .retnmdump
;-332 		    k=1;

.mdump45:
 mov ax, 1
 mov [bp-10], ax
;-333 		    putch(10);

 push 10
 call putch
 add  sp, 2
;-334 		    cputs("Ofs=");

 push mdump_2
 call cputs
 add  sp, 2
;-335 		    printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-336 		    }

;-337         putch(10);

.mdump44:
 push 10
 call putch
 add  sp, 2
;-338         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-339         putch(':');

 push 58
 call putch
 add  sp, 2
;-340         i=0;

 mov ax, 0
 mov [bp-6], ax
;-341         while (i < 16) {

.mdump46:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump47
;-342             putch(' ');

 push 32
 call putch
 add  sp, 2
;-343             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-344             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-345             adr++;

 inc  word[bp+4]
;-346             i++;

 inc  word[bp-6]
;-347             j++;

 inc  word[bp-8]
;-348             }

;-349         putch(' ');

 jmp .mdump46
.mdump47:
 push 32
 call putch
 add  sp, 2
;-350         adr -=16;

 sub  word[bp+4], 16
;-351         i=0;

 mov ax, 0
 mov [bp-6], ax
;-352         while(i < 16) {

.mdump48:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump49
;-353             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-354             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump50
 push 46
 call putch
 add  sp, 2
;-355                 else putch(c);

 jmp .mdump51
.mdump50:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-356             adr++;

.mdump51:
 inc  word[bp+4]
;-357             i++;

 inc  word[bp-6]
;-358         }

;-359     }

 jmp .mdump48
.mdump49:
;-360     getkey();

 jmp .mdump42
.mdump43:
 call getkey
;-361     putch(10);

 push 10
 call putch
 add  sp, 2
;-362 

;-363 }

;-364 int dumpASCII(unsigned char *adr, unsigned int len ) {

 .retnmdump:
 LEAVE
 ret
mdump_0 db "Ofs=",0
mdump_1 db " Length=",0
mdump_2 db "Ofs=",0
ENDP

dumpASCII: PROC
;-365     unsigned char c; unsigned char chal; int i; int j; int k;

;-366     j=0;

;Function : dumpASCII, Number local Var: 7
; # type sign width local variables
;102 ptr unsg byte adr = bp+4
;103 var unsg word len = bp+6
;104 var unsg byte c = bp-2
;105 var unsg byte chal = bp-4
;106 var sign word i = bp-6
;107 var sign word j = bp-8
;108 var sign word k = bp-10;
 ENTER  10,0
 mov ax, 0
 mov [bp-8], ax
;-367     k=0;

 mov ax, 0
 mov [bp-10], ax
;-368 	putch(10);

 push 10
 call putch
 add  sp, 2
;-369 	cputs("Ofs=");

 push dumpASCII_0
 call cputs
 add  sp, 2
;-370 	printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-371 	cputs(" Length=");

 push dumpASCII_1
 call cputs
 add  sp, 2
;-372 	printunsign(len);

 push word [bp+6]
 call printunsign
 add  sp, 2
;-373     while (j < len ) {

.dumpASCII52:
 mov ax, [bp-8]
 cmp ax, [bp+6]
 jge .dumpASCII53
;-374 	    k++;;

 inc  word[bp-10]
;-375 	    if (k > 16) {

 mov ax, [bp-10]
 cmp ax, 16
 jle .dumpASCII54
;-376 		    chal = getkey();//remove scan code

 call getkey
 mov [bp-4], al
;-377 		    if (chal =='q') return;

 mov al, [bp-4]
 cmp al, 113
 jne .dumpASCII55
 jmp .retndumpASCII
;-378 		    k=1;

.dumpASCII55:
 mov ax, 1
 mov [bp-10], ax
;-379 		    putch(10);

 push 10
 call putch
 add  sp, 2
;-380 		    cputs("Ofs=");

 push dumpASCII_2
 call cputs
 add  sp, 2
;-381 		    printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-382 		    }

;-383         putch(10);

.dumpASCII54:
 push 10
 call putch
 add  sp, 2
;-384         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-385         putch(':');

 push 58
 call putch
 add  sp, 2
;-386         i=0;

 mov ax, 0
 mov [bp-6], ax
;-387         while(i < 64) {

.dumpASCII56:
 mov ax, [bp-6]
 cmp ax, 64
 jge .dumpASCII57
;-388             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-389             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .dumpASCII58
 push 46
 call putch
 add  sp, 2
;-390                 else putch(c);

 jmp .dumpASCII59
.dumpASCII58:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-391             adr++;

.dumpASCII59:
 inc  word[bp+4]
;-392             i++;

 inc  word[bp-6]
;-393             j++;

 inc  word[bp-8]
;-394         }

;-395     }

 jmp .dumpASCII56
.dumpASCII57:
;-396     getkey();

 jmp .dumpASCII52
.dumpASCII53:
 call getkey
;-397     putch(10);

 push 10
 call putch
 add  sp, 2
;-398 

;-399 }

;-400 

;-401 //--------------------------------  disk IO  -------------------

;-402 

;-403 int DiskSectorReadWrite(char rw, char drive, char head, int cyl,

 .retndumpASCII:
 LEAVE
 ret
dumpASCII_0 db "Ofs=",0
dumpASCII_1 db " Length=",0
dumpASCII_2 db "Ofs=",0
ENDP

DiskSectorReadWrite: PROC
;-404 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-405 	BIOS_ERR=0;

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;102 var sign byte rw = bp+4
;103 var sign byte drive = bp+6
;104 var sign byte head = bp+8
;105 var sign word cyl = bp+10
;106 var sign byte sector = bp+12
;107 var sign byte count = bp+14
;108 var sign word BufSeg = bp+16
;109 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-406 	dl=drive;

 mov  dl, [bp+6]
;-407 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-408 	es=BufSeg;

 mov  es, [bp+16]
;-409 	bx=BufOfs;

 mov  bx, [bp+18]
;-410 	cx=cyl;

 mov  cx, [bp+10]
;-411 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-412 	cx >> 2;//in 2 high bits of cl

 shr  cx, 2
;-413 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-414 	cl += sector;

 add  cl, [bp+12]
;-415 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-416 	al=count;

 mov  al, [bp+14]
;-417 	ah=rw;

 mov  ah, [bp+4]
;-418 	inth 0x13;

 int  19
;-419     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-420 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-421 }

;-422 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-423 	BIOS_ERR=0;

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;102 var sign byte drive = bp+4
;103 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-424 	dl=drive;

 mov  dl, [bp+4]
;-425 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-426 	inth 0x13;

 int  19
;-427     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-428 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-429 }

;-430 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-431 	cputs("*** DISK ERROR *** AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-432 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-433 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-434 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-435 }

;-436 int Status(drive) {

 ret
Int13hError_0 db "*** DISK ERROR *** AX=",0
Int13hError_1 db ".  ",0
ENDP

Status: PROC
;-437 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;102 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-438 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-439 	BIOS_Status=Int13hfunction(drive, 1);

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-440 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Status60
 call Int13hError
;-441 	printhex16(BIOS_Status);

.Status60:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-442 }

;-443 

;-444 int Params() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

Params: PROC
;-445 	if (debug) cputs(" DriveParams");

 mov ax, 1
 or  al, al
 je .Params61
 push Params_0
 call cputs
 add  sp, 2
;-446 	BIOS_Status=Int13hfunction(Drive, 8);

.Params61:
 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-447 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params62
;-448 		Int13hError();

 call Int13hError
;-449 		return 1;

 mov ax, 1
 jmp .retnParams
;-450 		}

;-451 	else {

 jmp .Params63
.Params62:
;-452 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-453 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-454 		// CX =       ---CH--- ---CL---

;-455 		// cylinder : 76543210 98

;-456 		// sector   :            543210

;-457 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-458 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-459 //		pa_Sectors++;//1 to 64

;-460 

;-461 		asm mov [pa_Cylinders],    cx

 mov [pa_Cylinders],    cx
;-462 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-463 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-464 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty

 add [pa_Cylinders],    ch;//byte add, low byte is empty
;-465 

;-466 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params64
;-467 			cputs(" ** no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-468 			return 1;

 mov ax, 1
 jmp .retnParams
;-469 			}

;-470 	}

.Params64:
;-471 	return 0;

.Params63:
 mov ax, 0
 jmp .retnParams
;-472 }

;-473 

;-474 

;-475 int getPartitionData() {

 .retnParams:
 ret
Params_0 db " DriveParams",0
Params_1 db " ** no hard disk found",0
ENDP

getPartitionData: PROC
;-476 	unsigned int j; char c; char *p;

;-477 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;102 var unsg word j = bp-2
;103 var sign byte c = bp-4
;104 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [pt_PartNo]
 shl ax, 4
 mov [bp-2], ax
;-478 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-479 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-480 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-481 	pt_StartCylinder=(int)pt_StartSector;

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-482 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-483 //	pt_StartSector++;//Sector start with 1 todo

;-484 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-485 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-486 	j++;

 inc  word[bp-2]
;-487 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-488 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-489 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB

;-490 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-491 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-492 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-493 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-494 //	pt_EndSector++;//Sector start with 1 todo

;-495 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-496 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-497 	j++;

 inc  word[bp-2]
;-498 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-499 	j++;

 inc  word[bp-2]
;-500 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-501 	memcpy(&pt_HiddenSector, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-502 }

;-503 

;-504 int checkBootSign() {

 LEAVE
 ret
ENDP

checkBootSign: PROC
;-505 	int i;

;-506 	i=510;

;Function : checkBootSign, Number local Var: 1
; # type sign width local variables
;102 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-507 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign65
;-508 		i++;

 inc  word[bp-2]
;-509 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign66
 mov ax, 1
 jmp .retncheckBootSign
;-510 	}

.checkBootSign66:
;-511 	cputs("  **Magic number NOT found.");

.checkBootSign65:
 push checkBootSign_0
 call cputs
 add  sp, 2
;-512 	return 0;

 mov ax, 0
 jmp .retncheckBootSign
;-513 }

;-514 

;-515 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db "  **Magic number NOT found.",0
ENDP

readMBR: PROC
;-516 	int isFAT;

;-517 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;102 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-518 	pt_PartNo=0;

 mov ax, 0
 mov word [pt_PartNo], ax
;-519 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-520 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR67
;-521 		Int13hError();

 call Int13hError
;-522 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-523 		}

;-524 	else {

 jmp .readMBR68
.readMBR67:
;-525 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .readMBR69
 mov ax, 0
 jmp .retnreadMBR
;-526 		do {

.readMBR69:
.readMBR70:
;-527 			getPartitionData();

 call getPartitionData
;-528 

;-529 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR71
;-530 				if (debug) cputs(" Boot part. found");

 mov ax, 1
 or  al, al
 je .readMBR72
 push readMBR_0
 call cputs
 add  sp, 2
;-531 				if (pt_FileSystem == 1) {

.readMBR72:
 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR73
;-532 					cputs(", FAT12 part. <32MB");

 push readMBR_1
 call cputs
 add  sp, 2
;-533 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-534 					}

;-535 				if (pt_FileSystem == 4) {

.readMBR73:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR74
;-536 					cputs(", small FAT16 part.<32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-537 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-538 					}

;-539 				if (pt_FileSystem == 6) {

.readMBR74:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR75
;-540 					if (debug) cputs(", large FAT16 part.");

 mov ax, 1
 or  al, al
 je .readMBR76
 push readMBR_3
 call cputs
 add  sp, 2
;-541 					isFAT=6;

.readMBR76:
 mov ax, 6
 mov [bp-2], ax
;-542 					}

;-543 				pt_PartNo=99;//end of loop

.readMBR75:
 mov ax, 99
 mov word [pt_PartNo], ax
;-544 			}

;-545 			pt_PartNo ++;

.readMBR71:
 inc  word[pt_PartNo]
;-546 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR77
 jmp .readMBR70
.readMBR77:
;-547 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-548 	}

;-549 }

.readMBR68:
;-550 

;-551 int getBootSector() {

 .retnreadMBR:
 LEAVE
 ret
readMBR_0 db " Boot part. found",0
readMBR_1 db ", FAT12 part. <32MB",0
readMBR_2 db ", small FAT16 part.<32MB",0
readMBR_3 db ", large FAT16 part.",0
ENDP

getBootSector: PROC
;-552 	int i;

;-553 	if (debug) cputs(" Boot sector:");

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;102 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 1
 or  al, al
 je .getBootSector78
 push getBootSector_0
 call cputs
 add  sp, 2
;-554   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

.getBootSector78:
;-555   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-556 	if (debug) printhex16(BIOS_Status);

 mov ax, 1
 or  al, al
 je .getBootSector79
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-557 	if (BIOS_ERR) {

.getBootSector79:
 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector80
;-558 		Int13hError();

 call Int13hError
;-559 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-560 		}

;-561 	else {

 jmp .getBootSector81
.getBootSector80:
;-562 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .getBootSector82
 mov ax, 0
 jmp .retngetBootSector
;-563 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector82:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-564 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector83
 push getBootSector_1
 call cputs
 add  sp, 2
;-565 		i=2;

.getBootSector83:
 mov ax, 2
 mov [bp-2], ax
;-566 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector84
 push getBootSector_2
 call cputs
 add  sp, 2
;-567 	}

.getBootSector84:
;-568 	return 1;

.getBootSector81:
 mov ax, 1
 jmp .retngetBootSector
;-569 }

;-570 

;-571 int FATInit() {

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Boot sector:",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-572 	unsigned long templong;//converting word to dword

;-573 

;-574 	clust_sizeL = (long) bs_clust_size;//1--127

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;102 var unsg long templong = bp-4;
 ENTER  4,0
 xor eax, eax
 mov al, [bs_clust_size]
 mov dword [clust_sizeL], eax
;-575 	sector_sizeL= (long) bs_sect_size; //512

 xor eax, eax
 mov ax, [bs_sect_size]
 mov dword [sector_sizeL], eax
;-576 

;-577 	fat_FatStartSector = bs_res_sects;

 mov ax, [bs_res_sects]
 mov word [fat_FatStartSector], ax
;-578 	fat_FatStartSectorL= (long) fat_FatStartSector; 

 xor eax, eax
 mov ax, [fat_FatStartSector]
 mov dword [fat_FatStartSectorL], eax
;-579 	fat_FatSectors = bs_fat_size;

 mov ax, [bs_fat_size]
 mov word [fat_FatSectors], ax
;-580 	if (bs_num_fats == 2) fat_FatSectors=fat_FatSectors+fat_FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .FATInit85
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-581 

;-582 	fat_Entries = bs_fat_size >> 1;//2 bytes for one entry

.FATInit85:
 mov ax, [bs_fat_size]
 shr ax, 1
 mov word [fat_Entries], ax
;-583 	fat_Entries -=2;//first 2 entries not used

 sub  word[fat_Entries], 2
;-584 	

;-585 	fat_RootDirStartSectorL = (long)fat_FatStartSector + fat_FatSectors;

 xor eax, eax
 mov ax, [fat_FatStartSector]
 add ax, [fat_FatSectors]
 mov dword [fat_RootDirStartSectorL], eax
;-586 	

;-587 	fat_RootDirSectorsL = (long) bs_root_entr >> 4;//  ./. 16

 xor eax, eax
 mov ax, [bs_root_entr]
 shr ax, 4
 mov dword [fat_RootDirSectorsL], eax
;-588 		

;-589 	fat_DataStartSectorL = fat_RootDirStartSectorL + fat_RootDirSectorsL;

 mov eax, [fat_RootDirStartSectorL]
 add eax, [fat_RootDirSectorsL]
 mov dword [fat_DataStartSectorL], eax
;-590 

;-591 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .FATInit86
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-592 	DataSectors32=bs_tot_sect32 - fat_DataStartSectorL;

.FATInit86:
 mov eax, [bs_tot_sect32]
 sub eax, [fat_DataStartSectorL]
 mov dword [DataSectors32], eax
;-593 

;-594 	CountofClustersL=DataSectors32 / clust_sizeL;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [clust_sizeL]
 mov dword [CountofClustersL], eax
;-595 

;-596 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-597 	num_tracksL = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [num_tracksL], eax
;-598 

;-599 //	templong = (long) bs_num_heads;

;-600 //	fat_num_cylinders = num_tracksL / templong;//w=d/w

;-601 	

;-602 	bytes_per_clusterL = (long) bs_clust_size * bs_sect_size;

 xor eax, eax
 mov al, [bs_clust_size]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_sect_size]
 mov dword [bytes_per_clusterL], eax
;-603 

;-604 	Sectors_per_cylinderL = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinderL], eax
;-605 	asm mov [Sectors_per_cylinderL + 2], dx;store high word

 mov [Sectors_per_cylinderL + 2], dx;store high word
;-606 

;-607 	templong = (long) 65525;

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-608 	if (CountofClustersL > templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jle .FATInit87
;-609 		trueFATtype=32;

 mov ax, 32
 mov byte [trueFATtype], al
;-610 		cputs(" FAT32 NOT supported");

 push FATInit_0
 call cputs
 add  sp, 2
;-611 		return 1;

 mov ax, 1
 jmp .retnFATInit
;-612 		}

;-613 	templong= (long) 4086;

.FATInit87:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-614 	if (CountofClustersL < templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jge .FATInit88
;-615 		trueFATtype=12;

 mov ax, 12
 mov byte [trueFATtype], al
;-616 		cputs(" FAT12");

 push FATInit_1
 call cputs
 add  sp, 2
;-617 		return 0;

 mov ax, 0
 jmp .retnFATInit
;-618 		}

;-619 	trueFATtype=16;

.FATInit88:
 mov ax, 16
 mov byte [trueFATtype], al
;-620 	if (debug) cputs(" FAT16");

 mov ax, 1
 or  al, al
 je .FATInit89
 push FATInit_2
 call cputs
 add  sp, 2
;-621 	return 0;

.FATInit89:
 mov ax, 0
 jmp .retnFATInit
;-622 }

;-623 

;-624 int Int13hExt() {

 .retnFATInit:
 LEAVE
 ret
FATInit_0 db " FAT32 NOT supported",0
FATInit_1 db " FAT12",0
FATInit_2 db " FAT16",0
ENDP

Int13hExt: PROC
;-625 	bx=0x55AA;

 mov  bx, 21930
;-626 	BIOS_Status=Int13hfunction(Drive, 0x41);

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-627 	asm mov [vAX], ax;

 mov [vAX], ax;
;-628 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-629 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported
;-630 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt90
;-631 		cputs(" Ext. NOT present");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-632 		Int13hError();

 call Int13hError
;-633 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-634 		}

;-635 	else if (debug) cputs(",Int13h Ext.");

 jmp .Int13hExt91
.Int13hExt90:
 mov ax, 1
 or  al, al
 je .Int13hExt92
 push Int13hExt_1
 call cputs
 add  sp, 2
;-636 	putch(10);

.Int13hExt92:
.Int13hExt91:
 push 10
 call putch
 add  sp, 2
;-637 	return 0;

 mov ax, 0
 jmp .retnInt13hExt
;-638 }

;-639 

;-640 int PrintDriveParameter() {

 .retnInt13hExt:
 ret
Int13hExt_0 db " Ext. NOT present",0
Int13hExt_1 db ",Int13h Ext.",0
ENDP

PrintDriveParameter: PROC
;-641 	unsigned long Lo;

;-642 // from Params

;-643 	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);

;Function : PrintDriveParameter, Number local Var: 1
; # type sign width local variables
;102 var unsg long Lo = bp-4;
 ENTER  4,0
 push PrintDriveParameter_0
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-644 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-645 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-646 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-647 	putch('.');

 push 46
 call putch
 add  sp, 2
;-648 //from getPartitionData

;-649 	putch(10);

 push 10
 call putch
 add  sp, 2
;-650 	cputs("getPartitionData:No=");printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-651 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-652 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-653 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-654 	cputs("/");				printunsign(pt_StartSector);

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-655 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-656 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-657 	cputs("/");				printunsign(pt_EndSector);

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-658 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-659 	cputs(",Start=");		printlong(pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 push dword [pt_HiddenSector]
 call printlong
 add  sp, 4
;-660 	cputs(",Len=");			printlong(pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 push dword [pt_PartLen]
 call printlong
 add  sp, 4
;-661 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-662 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-663 	printlong(Lo);

 push dword [bp-4]
 call printlong
 add  sp, 4
;-664 	cputs(" MByte.");

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-665 //from getBootSector

;-666 	putch(10);

 push 10
 call putch
 add  sp, 2
;-667 	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-668 	putch(10);

 push 10
 call putch
 add  sp, 2
;-669 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-670 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-671 	putch(10);

 push 10
 call putch
 add  sp, 2
;-672 	cputs("Reserved sectors=");printunsign(bs_res_sects);

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-673 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-674 	putch(10);

 push 10
 call putch
 add  sp, 2
;-675 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-676 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-677 	putch(10);

 push 10
 call putch
 add  sp, 2
;-678 	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-679 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-680 	putch(10);

 push 10
 call putch
 add  sp, 2
;-681 	cputs("sectors per track=");printunsign(bs_sectors_per_track);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_sectors_per_track]
 call printunsign
 add  sp, 2
;-682 	cputs(".number of heads=");printunsign(bs_num_heads);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_heads]
 call printunsign
 add  sp, 2
;-683 	putch(10);

 push 10
 call putch
 add  sp, 2
;-684 	cputs("hidden sectors(long)=");printlong(bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 push dword [bs_hid_sects]
 call printlong
 add  sp, 4
;-685 	cputs(".sectors(long)=");printlong(bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 push dword [bs_tot_sect32]
 call printlong
 add  sp, 4
;-686 	putch(10);

 push 10
 call putch
 add  sp, 2
;-687 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-688 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-689 	putch(10);

 push 10
 call putch
 add  sp, 2
;-690 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-691 	cputs(".Volume serial(long)=");printlong(bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 push dword [bs_serial_num]
 call printlong
 add  sp, 4
;-692 	putch(10);

 push 10
 call putch
 add  sp, 2
;-693 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-694 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-695 //from FATInit

;-696 	putch(10);

 push 10
 call putch
 add  sp, 2
;-697 	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [fat_FatStartSector]
 call printunsign
 add  sp, 2
;-698 	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [fat_FatSectors]
 call printunsign
 add  sp, 2
;-699 	cputs(", fat_Entries=");	printunsign(fat_Entries);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push word [fat_Entries]
 call printunsign
 add  sp, 2
;-700 	putch(10);

 push 10
 call putch
 add  sp, 2
;-701 	cputs("fat_RootDirStartSectorL="); printlong(fat_RootDirStartSectorL);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push dword [fat_RootDirStartSectorL]
 call printlong
 add  sp, 4
;-702 	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectorsL);

 push PrintDriveParameter_38
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

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 push dword [fat_DataStartSectorL]
 call printunsign
 add  sp, 4
;-705 	cputs(", DataSectors32=");	printlong(DataSectors32);

 push PrintDriveParameter_40
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

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 push dword [CountofClustersL]
 call printlong
 add  sp, 4
;-708 	cputs(", Sectors_per_cylinderL="); printlong(Sectors_per_cylinderL);

 push PrintDriveParameter_42
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

 push PrintDriveParameter_43
 call cputs
 add  sp, 2
 push dword [num_tracksL]
 call printlong
 add  sp, 4
;-711 	cputs(", bytes_per_clusterL=");	printlong(bytes_per_clusterL);

 push PrintDriveParameter_44
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
;-719 	putch(10);

;Function : error2, Number local Var: 1
; # type sign width local variables
;102 ptr sign byte s = bp+4;
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
;102 var unsg long SectorL = bp+4
;103 var unsg word DSeg = bp+8
;104 var unsg word DOfs = bp+10
;105 var unsg word track = bp-2
;106 var unsg word head = bp-4
;107 var unsg word sect = bp-6;
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
;-737 	if (BIOS_ERR) error2("readLogical low level");

 mov al, [BIOS_ERR]
 or  al, al
 je .readLogical93
 push readLogical_0
 call error2
 add  sp, 2
;-738 }

.readLogical93:
;-739 // 2.a

;-740 int printDirEntry(int EntryNr) {

 LEAVE
 ret
readLogical_0 db "readLogical low level",0
ENDP

printDirEntry: PROC
;-741     unsigned int j;

;-742 	putch(10);

;Function : printDirEntry, Number local Var: 2
; # type sign width local variables
;102 var sign word EntryNr = bp+4
;103 var unsg word j = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-743 	printunsign(EntryNr);

 push word [bp+4]
 call printunsign
 add  sp, 2
;-744 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-745 	cputs(filename);

 lea  ax, [filename]
 push ax
 call cputs
 add  sp, 2
;-746 	cputs(" ATTR:");

 push printDirEntry_0
 call cputs
 add  sp, 2
;-747 	printhex8(dir_Attrib);	

 mov al, byte [dir_Attrib]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-748 	if (dir_Attrib &  1) cputs(" r/o");

 mov al, [dir_Attrib]
 and al, 1
 or  al, al
 je .printDirEntry94
 push printDirEntry_1
 call cputs
 add  sp, 2
;-749 	if (dir_Attrib &  2) cputs(" hid");

.printDirEntry94:
 mov al, [dir_Attrib]
 and al, 2
 or  al, al
 je .printDirEntry95
 push printDirEntry_2
 call cputs
 add  sp, 2
;-750 	if (dir_Attrib &  4) cputs(" sys");

.printDirEntry95:
 mov al, [dir_Attrib]
 and al, 4
 or  al, al
 je .printDirEntry96
 push printDirEntry_3
 call cputs
 add  sp, 2
;-751 	if (dir_Attrib &  8) cputs(" vol");		

.printDirEntry96:
 mov al, [dir_Attrib]
 and al, 8
 or  al, al
 je .printDirEntry97
 push printDirEntry_4
 call cputs
 add  sp, 2
;-752 	if (dir_Attrib & 16) cputs(" dir");

.printDirEntry97:
 mov al, [dir_Attrib]
 and al, 16
 or  al, al
 je .printDirEntry98
 push printDirEntry_5
 call cputs
 add  sp, 2
;-753 	if (dir_Attrib & 32) cputs(" arc");

.printDirEntry98:
 mov al, [dir_Attrib]
 and al, 32
 or  al, al
 je .printDirEntry99
 push printDirEntry_6
 call cputs
 add  sp, 2
;-754 	if (dir_Attrib == 0) cputs("    ");

.printDirEntry99:
 mov al, [dir_Attrib]
 cmp al, 0
 jne .printDirEntry100
 push printDirEntry_7
 call cputs
 add  sp, 2
;-755 	

;-756 	putch(' ');

.printDirEntry100:
 push 32
 call putch
 add  sp, 2
;-757 	j=dir_LastModDate & 31;//day

 mov ax, [dir_LastModDate]
 and ax, 31
 mov [bp-2], ax
;-758 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry101
 push 32
 call putch
 add  sp, 2
;-759 	printunsign(j);

.printDirEntry101:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-760 	putch('.');

 push 46
 call putch
 add  sp, 2
;-761 

;-762 	j=dir_LastModDate >> 5;//month

 mov ax, [dir_LastModDate]
 shr ax, 5
 mov [bp-2], ax
;-763 	j&=  15;

 and  word[bp-2], 15
;-764 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry102
 push 48
 call putch
 add  sp, 2
;-765 	printunsign(j);

.printDirEntry102:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-766 	putch('.');

 push 46
 call putch
 add  sp, 2
;-767 

;-768 	j=dir_LastModDate >> 9;//year

 mov ax, [dir_LastModDate]
 shr ax, 9
 mov [bp-2], ax
;-769 	j+= 1980;

 add  word[bp-2], 1980
;-770 	printunsign(j);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-771 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-772 	//putch(' ');

;-773 

;-774 	j=dir_LastModTime  >>11;//hour

 mov ax, [dir_LastModTime]
 shr ax, 11
 mov [bp-2], ax
;-775 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry103
 push 32
 call putch
 add  sp, 2
;-776 	printunsign(j);

.printDirEntry103:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-777 	putch(':');

 push 58
 call putch
 add  sp, 2
;-778 

;-779 	j=dir_LastModTime  >> 5;//minute

 mov ax, [dir_LastModTime]
 shr ax, 5
 mov [bp-2], ax
;-780 	j&=  63;

 and  word[bp-2], 63
;-781 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry104
 push 48
 call putch
 add  sp, 2
;-782 	printunsign(j);

.printDirEntry104:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-783 	putch(':');

 push 58
 call putch
 add  sp, 2
;-784 

;-785 	j=dir_LastModTime & 31;// 2 seconds

 mov ax, [dir_LastModTime]
 and ax, 31
 mov [bp-2], ax
;-786 	j=j+j;

 mov ax, [bp-2]
 add ax, [bp-2]
 mov [bp-2], ax
;-787 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry105
 push 48
 call putch
 add  sp, 2
;-788 	printunsign(j);

.printDirEntry105:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-789 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-790 

;-791 	cputs(" 1.Cl:"); 

 push printDirEntry_8
 call cputs
 add  sp, 2
;-792 	printunsign(dir_FirstCluster);

 push word [dir_FirstCluster]
 call printunsign
 add  sp, 2
;-793 	cputs(" Size:");

 push printDirEntry_9
 call cputs
 add  sp, 2
;-794 	printlong(dir_FileSize);

 push dword [dir_FileSize]
 call printlong
 add  sp, 4
;-795 	

;-796 }

;-797 

;-798 // 2.b

;-799 int fatDirSectorList(unsigned long startSector, unsigned long numsectors) {

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
;-800     char *p;

;-801 	unsigned int EndDiskBuf;

;-802 	char isHide;//shows entries, NOT lfn, deleted or empty

;-803 	unsigned int EntryNr;

;-804 	EntryNr=0;

;Function : fatDirSectorList, Number local Var: 6
; # type sign width local variables
;102 var unsg long startSector = bp+4
;103 var unsg long numsectors = bp+8
;104 ptr sign byte p = bp-2
;105 var unsg word EndDiskBuf = bp-4
;106 var sign byte isHide = bp-6
;107 var unsg word EntryNr = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-8], ax
;-805 	do {

.fatDirSectorList106:
;-806 /*		putch(10);

;-807 		cputs("Sektor = "); 

;-808 		printlong(startSector);

;-809 		cputs(", numsectors = "); 

;-810 		printlong(numsectors);

;-811 		getkey();

;-812 */

;-813 		readLogical(startSector, DiskBufSeg, DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp+4]
 call readLogical
 add  sp, 8
;-814 		if (DOS_ERR) return;

 mov al, [DOS_ERR]
 or  al, al
 je .fatDirSectorList107
 jmp .retnfatDirSectorList
;-815 		p=&DiskBuf;

.fatDirSectorList107:
 mov ax, DiskBuf
 mov [bp-2], ax
;-816 		EndDiskBuf= p + bs_sect_size;		

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-817 		

;-818 		do {

.fatDirSectorList108:
;-819 			memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-820 			memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-821 			filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-822 			

;-823 			isHide=0;//show in listing

 mov ax, 0
 mov [bp-6], al
;-824 			if (*p ==    0) {//only empty entries following

 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorList109
;-825 				isHide++;

 inc  byte[bp-6]
;-826 				numsectors=1;//finish searching

 mov ax, 1
 mov [bp+8], eax
;-827 				p = EndDiskBuf;

 mov ax, [bp-4]
 mov [bp-2], ax
;-828 				}

;-829 			if (*p == 0xE5) isHide++;//deleted, free entry

.fatDirSectorList109:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 229
 jne .fatDirSectorList110
 inc  byte[bp-6]
;-830 			if (*p <=   31) isHide++;//part of LFN

.fatDirSectorList110:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 31
 jg  .fatDirSectorList111
 inc  byte[bp-6]
;-831 			if (dir_Attrib ==    15) isHide++;//LFN start

.fatDirSectorList111:
 mov al, [dir_Attrib]
 cmp al, 15
 jne .fatDirSectorList112
 inc  byte[bp-6]
;-832 					

;-833 			if (isHide == 0) printDirEntry(EntryNr);

.fatDirSectorList112:
 mov al, [bp-6]
 cmp al, 0
 jne .fatDirSectorList113
 push word [bp-8]
 call printDirEntry
 add  sp, 2
;-834 			p+=32;//get next entry

.fatDirSectorList113:
 add  word[bp-2], 32
;-835 			EntryNr++;

 inc  word[bp-8]
;-836 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorList114
 jmp .fatDirSectorList108
.fatDirSectorList114:
;-837 		startSector = startSector + 1;//long, do NOT use ++ or +=1

 mov eax, [bp+4]
 add eax, 1
 mov [bp+4], eax
;-838 		numsectors--;

 dec  dword[bp+8]
;-839 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorList115
 jmp .fatDirSectorList106
.fatDirSectorList115:
;-840 	CurrentCluster=0;//not found but not end

 mov ax, 0
 mov word [CurrentCluster], ax
;-841 }

;-842 

;-843 // 2.

;-844 int fatDirSectorSearch(unsigned long startSector,unsigned long numsectors) {

 .retnfatDirSectorList:
 LEAVE
 ret
ENDP

fatDirSectorSearch: PROC
;-845 //	search for file name. 

;-846 //	IN:  searchstr

;-847 //	OUT: 0=file not found

;-848     char *p;

;-849 	unsigned int EndDiskBuf;

;-850 	do {

;Function : fatDirSectorSearch, Number local Var: 4
; # type sign width local variables
;102 var unsg long startSector = bp+4
;103 var unsg long numsectors = bp+8
;104 ptr sign byte p = bp-2
;105 var unsg word EndDiskBuf = bp-4;
 ENTER  4,0
.fatDirSectorSearch116:
;-851 		readLogical(startSector, DiskBufSeg, DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp+4]
 call readLogical
 add  sp, 8
;-852 		if (DOS_ERR) return 0;

 mov al, [DOS_ERR]
 or  al, al
 je .fatDirSectorSearch117
 mov ax, 0
 jmp .retnfatDirSectorSearch
;-853 		p=&DiskBuf;

.fatDirSectorSearch117:
 mov ax, DiskBuf
 mov [bp-2], ax
;-854 		EndDiskBuf= p + bs_sect_size;

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-855 		do {

.fatDirSectorSearch118:
;-856 			if (memcmp(p, searchstr, 11) == 0) {//found file name

 push 11
 lea  ax, [searchstr]
 push ax
 push word [bp-2]
 call memcmp
 add  sp, 6
 cmp ax, 0
 jne .fatDirSectorSearch119
;-857 				memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-858 				memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-859 				filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-860 				CurrentCluster = dir_FirstCluster;

 mov ax, [dir_FirstCluster]
 mov word [CurrentCluster], ax
;-861 				FileSizeL      = dir_FileSize;

 mov eax, [dir_FileSize]
 mov dword [FileSizeL], eax
;-862 				return 1;

 mov ax, 1
 jmp .retnfatDirSectorSearch
;-863 			}

;-864 			if (*p == 0) return 0; //only empty entries following

.fatDirSectorSearch119:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorSearch120
 mov ax, 0
 jmp .retnfatDirSectorSearch
;-865 			p+=32;//get next entry

.fatDirSectorSearch120:
 add  word[bp-2], 32
;-866 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorSearch121
 jmp .fatDirSectorSearch118
.fatDirSectorSearch121:
;-867 		startSector++;		

 inc  dword[bp+4]
;-868 		numsectors--;

 dec  dword[bp+8]
;-869 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorSearch122
 jmp .fatDirSectorSearch116
.fatDirSectorSearch122:
;-870 	  CurrentCluster=0;//not found but not end

 mov ax, 0
 mov word [CurrentCluster], ax
;-871 	return 0;

 mov ax, 0
 jmp .retnfatDirSectorSearch
;-872 }

;-873 

;-874 // 4.

;-875 int fatClusterAnalyse(unsigned int clust) {

 .retnfatDirSectorSearch:
 LEAVE
 ret
ENDP

fatClusterAnalyse: PROC
;-876 //	OUT: StartSectorL, NextCluster

;-877 //	OUT: 1=error

;-878 	unsigned long fatSectorL;

;-879 	unsigned int offset;

;-880 	char *p;

;-881 	if (clust < 2) { StartSectorL = 0; return 1; }

;Function : fatClusterAnalyse, Number local Var: 4
; # type sign width local variables
;102 var unsg word clust = bp+4
;103 var unsg long fatSectorL = bp-4
;104 var unsg word offset = bp-6
;105 ptr sign byte p = bp-8;
 ENTER  8,0
 mov ax, [bp+4]
 cmp ax, 2
 jge .fatClusterAnalyse123
 mov ax, 0
 mov dword [StartSectorL], eax
 mov ax, 1
 jmp .retnfatClusterAnalyse
;-882 	if ((long) clust >= CountofClustersL) { StartSectorL = 0; return 1; }

.fatClusterAnalyse123:
 xor eax, eax
 mov ax, [bp+4]
 cmp eax, [CountofClustersL] ;unsigned : 0
 jb  .fatClusterAnalyse124
 mov ax, 0
 mov dword [StartSectorL], eax
 mov ax, 1
 jmp .retnfatClusterAnalyse
;-883 

;-884 //StartSectorL = (long) clust -2 * clust_sizeL+fat_DataStartSectorL;

;-885 	StartSectorL = (long) clust -2;

.fatClusterAnalyse124:
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
;-895 	if(DOS_ERR) { StartSectorL = 0; return 1; }

 mov al, [DOS_ERR]
 or  al, al
 je .fatClusterAnalyse125
 mov ax, 0
 mov dword [StartSectorL], eax
 mov ax, 1
 jmp .retnfatClusterAnalyse
;-896 	

;-897 	offset = clust + clust;

.fatClusterAnalyse125:
 mov ax, [bp+4]
 add ax, [bp+4]
 mov [bp-6], ax
;-898 	offset = offset % bs_sect_size;	

 mov ax, [bp-6]
 xor dx, dx
 div word [bs_sect_size]
 mov ax, dx
 mov [bp-6], ax
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
;-902 

;-903 	if (debug) { 

 mov ax, 1
 or  al, al
 je .fatClusterAnalyse126
;-904 		cputs(" StartSectorL="); printlong(StartSectorL); 

 push fatClusterAnalyse_0
 call cputs
 add  sp, 2
 push dword [StartSectorL]
 call printlong
 add  sp, 4
;-905 		cputs(" Currentclust="); printunsign(clust);

 push fatClusterAnalyse_1
 call cputs
 add  sp, 2
 push word [bp+4]
 call printunsign
 add  sp, 2
;-906 		cputs(" NextCluster="); printunsign(NextCluster); 

 push fatClusterAnalyse_2
 call cputs
 add  sp, 2
 push word [NextCluster]
 call printunsign
 add  sp, 2
;-907 	}

;-908 	return 0;

.fatClusterAnalyse126:
 mov ax, 0
 jmp .retnfatClusterAnalyse
;-909 }

;-910 

;-911 int is_delimiter(char *s) {

 .retnfatClusterAnalyse:
 LEAVE
 ret
fatClusterAnalyse_0 db " StartSectorL=",0
fatClusterAnalyse_1 db " Currentclust=",0
fatClusterAnalyse_2 db " NextCluster=",0
ENDP

is_delimiter: PROC
;-912 	if (*s == '/' ) return 1;

;Function : is_delimiter, Number local Var: 1
; # type sign width local variables
;102 ptr sign byte s = bp+4;
 ENTER  0,0
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 47
 jne .is_delimiter127
 mov ax, 1
 jmp .retnis_delimiter
;-913 	if (*s == '\\') return 1;

.is_delimiter127:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 92
 jne .is_delimiter128
 mov ax, 1
 jmp .retnis_delimiter
;-914 	if (*s ==    0) return 2;

.is_delimiter128:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .is_delimiter129
 mov ax, 2
 jmp .retnis_delimiter
;-915 	if (*s ==  '.') return 3;

.is_delimiter129:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 46
 jne .is_delimiter130
 mov ax, 3
 jmp .retnis_delimiter
;-916 	return 0;

.is_delimiter130:
 mov ax, 0
 jmp .retnis_delimiter
;-917 }

;-918 

;-919 // 6.

;-920 int fatNextSearch() {//get next part of filename to do a search

 .retnis_delimiter:
 LEAVE
 ret
ENDP

fatNextSearch: PROC
;-921 //	IN:  upto: points to start of search in filename 

;-922 //	OUT: upto: points to search for next time

;-923 //	OUT: searchstr: part of filename in DIR-format with blanks (11bytes)

;-924 //	OUT: isfilename: 0=part of directory, 1=filename

;-925 //	OUT: 0=file not found

;-926 	char *searchstrp;

;-927 	char *p; 

;-928 	unsigned int  len;

;-929 	unsigned int delimiter;

;-930 

;-931 	delimiter=is_delimiter(upto);

;Function : fatNextSearch, Number local Var: 4
; # type sign width local variables
;102 ptr sign byte searchstrp = bp-2
;103 ptr sign byte p = bp-4
;104 var unsg word len = bp-6
;105 var unsg word delimiter = bp-8;
 ENTER  8,0
 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-932 	if (delimiter == 1) upto++;

 mov ax, [bp-8]
 cmp ax, 1
 jne .fatNextSearch131
 inc  word[upto]
;-933 	if (delimiter == 2) return 0; 

.fatNextSearch131:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch132
 mov ax, 0
 jmp .retnfatNextSearch
;-934 

;-935 	strcpy(&searchstr, "           ");//11 blank padded

.fatNextSearch132:
 push fatNextSearch_0
 lea  ax, [searchstr]
 push ax
 call strcpy
 add  sp, 4
;-936 	searchstrp = &searchstr;//clear searchstr

 mov ax, searchstr
 mov [bp-2], ax
;-937 	len=0;

 mov ax, 0
 mov [bp-6], ax
;-938 	delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-939 	while (delimiter == 0) { //no slash, zero, point

.fatNextSearch133:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch134
;-940 		*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-941 		searchstrp++;

 inc  word[bp-2]
;-942 		upto++;	

 inc  word[upto]
;-943 		len++;

 inc  word[bp-6]
;-944 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-945 	} 

;-946 	if (len > 8) return 0;

 jmp .fatNextSearch133
.fatNextSearch134:
 mov ax, [bp-6]
 cmp ax, 8
 jle .fatNextSearch135
 mov ax, 0
 jmp .retnfatNextSearch
;-947 	isfilename=0;//todo: default directory, not yet implemented

.fatNextSearch135:
 mov ax, 0
 mov byte [isfilename], al
;-948 	if (delimiter == 2) isfilename=1;//last name is always a file name

 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch136
 mov ax, 1
 mov byte [isfilename], al
;-949 	if (delimiter == 3) {//remove dot in name		

.fatNextSearch136:
 mov ax, [bp-8]
 cmp ax, 3
 jne .fatNextSearch137
;-950 		searchstrp = &searchstr;

 mov ax, searchstr
 mov [bp-2], ax
;-951 		searchstrp += 8;//start extension		

 add  word[bp-2], 8
;-952 		len=0;

 mov ax, 0
 mov [bp-6], ax
;-953 		upto++;

 inc  word[upto]
;-954 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-955 		while (delimiter == 0) { //no slash, zero, point

.fatNextSearch138:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch139
;-956 			*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-957 			searchstrp++;

 inc  word[bp-2]
;-958 			upto++;	

 inc  word[upto]
;-959 			len++;

 inc  word[bp-6]
;-960 			delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-961 		} 

;-962 		if (len > 3) return 0;

 jmp .fatNextSearch138
.fatNextSearch139:
 mov ax, [bp-6]
 cmp ax, 3
 jle .fatNextSearch140
 mov ax, 0
 jmp .retnfatNextSearch
;-963 		if (delimiter == 2) isfilename=1;//last name is always a file name

.fatNextSearch140:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch141
 mov ax, 1
 mov byte [isfilename], al
;-964 	}

.fatNextSearch141:
;-965 	return 1;	

.fatNextSearch137:
 mov ax, 1
 jmp .retnfatNextSearch
;-966 }

;-967 

;-968 // 7.

;-969 int fatGetStartCluster() {//lastBytes, lastSectors

 .retnfatNextSearch:
 LEAVE
 ret
fatNextSearch_0 db "           ",0
ENDP

fatGetStartCluster: PROC
;-970 	upto = &filename;

 mov ax, filename
 mov word [upto], ax
;-971 	if (fatNextSearch()) {//6 get next part of file name

 call fatNextSearch
 or  al, al
 je .fatGetStartCluster142
;-972 		if (debug) {putch(10); cputsLen(searchstr, 11); }

 mov ax, 1
 or  al, al
 je .fatGetStartCluster143
 push 10
 call putch
 add  sp, 2
 push 11
 lea  ax, [searchstr]
 push ax
 call cputsLen
 add  sp, 4
;-973 		if (isfilename == 0) return 0; //todo not implemented

.fatGetStartCluster143:
 mov al, [isfilename]
 cmp al, 0
 jne .fatGetStartCluster144
 mov ax, 0
 jmp .retnfatGetStartCluster
;-974 		if (fatDirSectorSearch(fat_RootDirStartSectorL,

.fatGetStartCluster144:
;-975 			fat_RootDirSectorsL)) return 1; 

 push dword [fat_RootDirSectorsL]
 push dword [fat_RootDirStartSectorL]
 call fatDirSectorSearch
 add  sp, 8
 or  al, al
 je .fatGetStartCluster145
 mov ax, 1
 jmp .retnfatGetStartCluster
;-976 		//2 todo: only root search

;-977 	}

.fatGetStartCluster145:
;-978 	return 0;

.fatGetStartCluster142:
 mov ax, 0
 jmp .retnfatGetStartCluster
;-979 }

;-980 		

;-981 // 9b.

;-982 int ReadFile(unsigned int BytestoRead) {

 .retnfatGetStartCluster:
 ret
ENDP

ReadFile: PROC
;-983 //	IN: FileSizeL		from 2.fatDirSectorSearch

;-984 //	IN: CurrentCluster	from 2.fatDirSectorSearch

;-985 //	IN: StartSectorL	from 4.fatClusterAnalyse

;-986 //	IN: NextCluster		from 4.fatClusterAnalyse

;-987 //	IO: FilePointerL=0	from 10.OSOpenFile

;-988 //	OUT: 0=error, else ByteRead

;-989 

;-990 	unsigned long CurrentSectorL;	//current data sector	

;-991 	unsigned long EndSectorL;

;-992 	unsigned int  ByteRead;

;-993 	unsigned int  btr;

;-994 	

;-995 	if (BytestoRead == 0) return 0;

;Function : ReadFile, Number local Var: 5
; # type sign width local variables
;102 var unsg word BytestoRead = bp+4
;103 var unsg long CurrentSectorL = bp-4
;104 var unsg long EndSectorL = bp-8
;105 var unsg word ByteRead = bp-10
;106 var unsg word btr = bp-12;
 ENTER  12,0
 mov ax, [bp+4]
 cmp ax, 0
 jne .ReadFile146
 mov ax, 0
 jmp .retnReadFile
;-996 	ByteRead = 0;

.ReadFile146:
 mov ax, 0
 mov [bp-10], ax
;-997 

;-998 	 while (CurrentCluster <= 0xFFF7) {// 65528,   < is wrong code!!!

.ReadFile147:
 mov ax, [CurrentCluster]
 cmp ax, 65527
 ja  .ReadFile148
;-999 		CurrentSectorL = StartSectorL;

 mov eax, [StartSectorL]
 mov [bp-4], eax
;-1000 		EndSectorL = StartSectorL + clust_sizeL;//set in FATInit(1-127)

 mov eax, [StartSectorL]
 add eax, [clust_sizeL]
 mov [bp-8], eax
;-1001 			

;-1002 //		if (debug) { 

;-1003 //			cputs(" CurrentCluster="); printunsign(CurrentCluster); 

;-1004 //			cputs(" CurrentSectorL="); printlong(CurrentSectorL); 

;-1005 //			cputs(" EndSectorL="); printlong(EndSectorL); 

;-1006 //		}		

;-1007 		while (CurrentSectorL <= EndSectorL) {

.ReadFile149:
 mov eax, [bp-4]
 cmp eax, [bp-8]
 ja  .ReadFile150
;-1008 			readLogical(CurrentSectorL, DiskBufSeg, DiskBuf);		

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp-4]
 call readLogical
 add  sp, 8
;-1009 			if (BIOS_ERR) {	Int13hError(); return 0; }	

 mov al, [BIOS_ERR]
 or  al, al
 je .ReadFile151
 call Int13hError
 mov ax, 0
 jmp .retnReadFile
;-1010 			if (BytestoRead > bs_sect_size) btr = bs_sect_size;

.ReadFile151:
 mov ax, [bp+4]
 cmp ax, [bs_sect_size]
 jle .ReadFile152
 mov ax, [bs_sect_size]
 mov [bp-12], ax
;-1011 			else btr = BytestoRead;

 jmp .ReadFile153
.ReadFile152:
 mov ax, [bp+4]
 mov [bp-12], ax
;-1012 							

;-1013 			memcpy(BufferPtr, DiskBuf, btr);

.ReadFile153:
 push word [bp-12]
 lea  ax, [DiskBuf]
 push ax
 push word [BufferPtr]
 call memcpy
 add  sp, 6
;-1014 			BufferPtr   	= BufferPtr    + btr;

 mov ax, [BufferPtr]
 add ax, [bp-12]
 mov word [BufferPtr], ax
;-1015 			BytestoRead 	= BytestoRead  - btr;

 mov ax, [bp+4]
 sub ax, [bp-12]
 mov [bp+4], ax
;-1016 			ByteRead    	= ByteRead     + btr;

 mov ax, [bp-10]
 add ax, [bp-12]
 mov [bp-10], ax
;-1017 			FilePointerL	= FilePointerL + btr;

 mov eax, [FilePointerL]
 add ax, [bp-12]
 mov dword [FilePointerL], eax
;-1018 			CurrentSectorL	= CurrentSectorL + 1; 		

 mov eax, [bp-4]
 add eax, 1
 mov [bp-4], eax
;-1019 //			cputs(" C BytestoRead="); printunsign(BytestoRead);		

;-1020 			if (BytestoRead == 0) return ByteRead;

 mov ax, [bp+4]
 cmp ax, 0
 jne .ReadFile154
 mov ax, [bp-10]
 jmp .retnReadFile
;-1021 		}

.ReadFile154:
;-1022 		CurrentCluster = NextCluster;

 jmp .ReadFile149
.ReadFile150:
 mov ax, [NextCluster]
 mov word [CurrentCluster], ax
;-1023 		if (fatClusterAnalyse(CurrentCluster)) return 0;//4.OUT:StartSectorL		

 push word [CurrentCluster]
 call fatClusterAnalyse
 add  sp, 2
 or  al, al
 je .ReadFile155
 mov ax, 0
 jmp .retnReadFile
;-1024 	}

.ReadFile155:
;-1025 	return 0;//error

 jmp .ReadFile147
.ReadFile148:
 mov ax, 0
 jmp .retnReadFile
;-1026 }	

;-1027 

;-1028 //------------------------------- OS functions --------------

;-1029 int FileError() {

 .retnReadFile:
 LEAVE
 ret
ENDP

FileError: PROC
;-1030 	cputs(" *** file error *** ");

 push FileError_0
 call cputs
 add  sp, 2
;-1031 }	

;-1032 

;-1033 // 10.

;-1034 int OSOpenFile(char *name) {

 ret
FileError_0 db " *** file error *** ",0
ENDP

OSOpenFile: PROC
;-1035 //	NEED:CurrentCluster, FileSizeL from 2.fatDirSectorSearch

;-1036 //	OUT: 0=error

;-1037 	unsigned long BufSzL;

;-1038 	unsigned int i;

;-1039 	DOS_ERR = 0;

;Function : OSOpenFile, Number local Var: 3
; # type sign width local variables
;102 ptr sign byte name = bp+4
;103 var unsg long BufSzL = bp-4
;104 var unsg word i = bp-6;
 ENTER  6,0
 mov ax, 0
 mov byte [DOS_ERR], al
;-1040 //	remove drive letter, slash. uppercase and copy to filename

;-1041 	strcpy(filename, name);

 push word [bp+4]
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1042 	toupper(filename);

 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-1043 	if (strlen(filename) == 0) return 0;

 lea  ax, [filename]
 push ax
 call strlen
 add  sp, 2
 cmp ax, 0
 jne .OSOpenFile156
 mov ax, 0
 jmp .retnOSOpenFile
;-1044 	i=strchr(filename, ':');

.OSOpenFile156:
 push 58
 lea  ax, [filename]
 push ax
 call strchr
 add  sp, 4
 mov [bp-6], ax
;-1045 	if (i) {

 mov ax, [bp-6]
 or  al, al
 je .OSOpenFile157
;-1046 		i++;

 inc  word[bp-6]
;-1047 		strcpy(filename, i);	

 push word [bp-6]
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1048 		if (strlen(filename) == 0) return 0;	

 lea  ax, [filename]
 push ax
 call strlen
 add  sp, 2
 cmp ax, 0
 jne .OSOpenFile158
 mov ax, 0
 jmp .retnOSOpenFile
;-1049 	}	

.OSOpenFile158:
;-1050 	if(is_delimiter(filename) == 1) filename++;

.OSOpenFile157:
 lea  ax, [filename]
 push ax
 call is_delimiter
 add  sp, 2
 cmp ax, 1
 jne .OSOpenFile159
 inc  byte[filename]
;-1051 		if (fatGetStartCluster() == 0) {// 7.fatGetStartCluster

.OSOpenFile159:
 call fatGetStartCluster
 cmp al, 0
 jne .OSOpenFile160
;-1052 		cputs(" file not found"); 

 push OSOpenFile_0
 call cputs
 add  sp, 2
;-1053 		return 0; 

 mov ax, 0
 jmp .retnOSOpenFile
;-1054 		}

;-1055 	BufferPtr = &Buffer;

.OSOpenFile160:
 mov ax, Buffer
 mov word [BufferPtr], ax
;-1056 	FilePointerL = 0;

 mov ax, 0
 mov dword [FilePointerL], eax
;-1057 	

;-1058 	BufSzL = (long) BUFFERSIZE;

 xor eax, eax
 mov ax, 35000
 mov [bp-4], eax
;-1059 	if (FileSizeL >=  BufSzL) {

 mov eax, [FileSizeL]
 cmp eax, [bp-4] ;unsigned : 0
 jb  .OSOpenFile161
;-1060 		error2(" file longer than BufferSize"); 

 push OSOpenFile_1
 call error2
 add  sp, 2
;-1061 		return 0;

 mov ax, 0
 jmp .retnOSOpenFile
;-1062 	}

;-1063 		

;-1064 	if (fatClusterAnalyse(CurrentCluster)) return 0;// 4. OUT: StartSectorL

.OSOpenFile161:
 push word [CurrentCluster]
 call fatClusterAnalyse
 add  sp, 2
 or  al, al
 je .OSOpenFile162
 mov ax, 0
 jmp .retnOSOpenFile
;-1065 //	CurrentCluster is set in 2.fatDirSectorSearch

;-1066 //	if (debug) {									//		DOS.COM FDCONFIG

;-1067 //	putch(10);

;-1068 //	cputs(" --10 OSOpenFile B:");

;-1069 //	cputs(" CurrentCluster="); 	printunsign(CurrentCluster);//4177	4164

;-1070 //	cputs(",StartSectorL=");	printlong(StartSectorL);	//17051	16999

;-1071 //	cputs(",ClusterSizeL=");	printlong(clust_sizeL);		// 4	 4

;-1072 //	cputs(",FileSizeL="); 		printlong(FileSizeL);		//8802	762

;-1073 //	cputs(",NextCluster="); 	printunsign(NextCluster);	//4178	65.535

;-1074 //	cputs(",lastSectors=");		printunsign(lastSectors);	// 1	 1

;-1075 //	cputs(",lastBytes="); 		printunsign(lastBytes);		// 98	250

;-1076 //	getkey();

;-1077 //	}

;-1078 	return 1;

.OSOpenFile162:
 mov ax, 1
 jmp .retnOSOpenFile
;-1079 }

;-1080 

;-1081 // 11.

;-1082 int OSReadFile() {

 .retnOSOpenFile:
 LEAVE
 ret
OSOpenFile_0 db " file not found",0
OSOpenFile_1 db " file longer than BufferSize",0
ENDP

OSReadFile: PROC
;-1083 	unsigned int BytesToReadInt;

;-1084 	BytesToReadInt = FileSizeL;//long2int	

;Function : OSReadFile, Number local Var: 1
; # type sign width local variables
;102 var unsg word BytesToReadInt = bp-2;
 ENTER  2,0
 mov eax, [FileSizeL]
 mov [bp-2], ax
;-1085 	BytesAreRead=ReadFile(BytesToReadInt);//9.

 push word [bp-2]
 call ReadFile
 add  sp, 2
 mov word [BytesAreRead], ax
;-1086 	if (BytesToReadInt != BytesAreRead) {

 mov ax, [bp-2]
 cmp ax, [BytesAreRead]
 je  .OSReadFile163
;-1087 		FileError();

 call FileError
;-1088 		cputs(" --11 OSReadFile BytesAreRead="); 

 push OSReadFile_0
 call cputs
 add  sp, 2
;-1089 		printunsign(BytesAreRead);  

 push word [BytesAreRead]
 call printunsign
 add  sp, 2
;-1090 	}

;-1091 	if (debug) getkey();	

.OSReadFile163:
 mov ax, 1
 or  al, al
 je .OSReadFile164
 call getkey
;-1092 }

.OSReadFile164:
;-1093 

;-1094 

;-1095 // 12.

;-1096 int OSShowFile() {

 LEAVE
 ret
OSReadFile_0 db " --11 OSReadFile BytesAreRead=",0
ENDP

OSShowFile: PROC
;-1097 //	mdump(DiskBuf, 512);

;-1098 	dumpASCII(Buffer, BytesAreRead);

 push word [BytesAreRead]
 lea  ax, [Buffer]
 push ax
 call dumpASCII
 add  sp, 4
;-1099 }

;-1100 

;-1101 

;-1102 //------------------------------- Init,  main ---------------

;-1103 int Init() {

 ret
ENDP

Init: PROC
;-1104 	DOS_ERR = 0;

 mov ax, 0
 mov byte [DOS_ERR], al
;-1105 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-1106 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-1107 	if (debug) cputs(" Init");

 mov ax, 1
 or  al, al
 je .Init165
 push Init_0
 call cputs
 add  sp, 2
;-1108 	if (Params()) cputs(" ** NO DRIVE PARAMS FOUND **");//no hard disk

.Init165:
 call Params
 or  al, al
 je .Init166
 push Init_1
 call cputs
 add  sp, 2
;-1109 	if (readMBR() == 0) {//0=error,1=FAT12,6=FAT16,11=FAT32	

.Init166:
 call readMBR
 cmp al, 0
 jne .Init167
;-1110 		cputs(" ** no active FAT partition found **");

 push Init_2
 call cputs
 add  sp, 2
;-1111 		return 1;

 mov ax, 1
 jmp .retnInit
;-1112 		}

;-1113 	if(getBootSector()==0) 	return 1;

.Init167:
 call getBootSector
 cmp al, 0
 jne .Init168
 mov ax, 1
 jmp .retnInit
;-1114 	if (FATInit())			return 1;

.Init168:
 call FATInit
 or  al, al
 je .Init169
 mov ax, 1
 jmp .retnInit
;-1115 	if(trueFATtype != 16) 	return 1;

.Init169:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init170
 mov ax, 1
 jmp .retnInit
;-1116 	Int13hExt();

.Init170:
 call Int13hExt
;-1117 	return 0;

 mov ax, 0
 jmp .retnInit
;-1118 }

;-1119 

;-1120 int main() {

 .retnInit:
 ret
Init_0 db " Init",0
Init_1 db " ** NO DRIVE PARAMS FOUND **",0
Init_2 db " ** no active FAT partition found **",0
ENDP

main: PROC
;-1121 	if (Init() ) return 1;

 call Init
 or  al, al
 je .main171
 mov ax, 1
 jmp .retnmain
;-1122 //	if (debug) PrintDriveParameter();

;-1123 	

;-1124 	if (OSOpenFile("fat.h"       ) > 0) { OSReadFile(); OSShowFile(); }

.main171:
 push main_0
 call OSOpenFile
 add  sp, 2
 cmp al, 0
 jle .main172
 call OSReadFile
 call OSShowFile
;-1125 	else FileError();

 jmp .main173
.main172:
 call FileError
;-1126 	if (OSOpenFile("r.bat"       ) > 0) { OSReadFile(); OSShowFile(); }

.main173:
 push main_1
 call OSOpenFile
 add  sp, 2
 cmp al, 0
 jle .main174
 call OSReadFile
 call OSShowFile
;-1127 	else FileError();

 jmp .main175
.main174:
 call FileError
;-1128 	if (OSOpenFile("int13.asm"   ) > 0) { OSReadFile(); OSShowFile(); }

.main175:
 push main_2
 call OSOpenFile
 add  sp, 2
 cmp al, 0
 jle .main176
 call OSReadFile
 call OSShowFile
;-1129 	else FileError();

 jmp .main177
.main176:
 call FileError
;-1130 	if (debug) cputs(".End.");

.main177:
 mov ax, 1
 or  al, al
 je .main178
 push main_3
 call cputs
 add  sp, 2
;-1131 }

.main178:
 .retnmain:
 ret
main_0 db "fat.h",0
main_1 db "r.bat",0
main_2 db "int13.asm",0
main_3 db ".End.",0
ENDP
