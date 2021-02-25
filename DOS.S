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
;-27 unsigned char Buffer [16394];//16K+10

section .bss
absolute 16976
Buffer resb 16394
section .text
;-28 

;-29 char          handle;

handle db 0
;-30 //start array of handles of every open file

;-31 unsigned int  BegCluster;		//first cluster of file

BegCluster dw 0
;-32 unsigned int  CurCluster;		//current cluster

CurCluster dw 0
;-33 unsigned int  NextCluster;

NextCluster dw 0
;-34 unsigned long CurSectorL;		//current sector in current cluster

CurSectorL dd 0
;-35 unsigned long FileSizeL;

FileSizeL dd 0
;-36 unsigned long lastBytesL;		//resting bytes in a sector

lastBytesL dd 0
;-37 unsigned long lastSectorsL;		//resting sectors in a cluster

lastSectorsL dd 0
;-38 

;-39 unsigned int  CurPosition;	//current byte location in cur sector

CurPosition dw 0
;-40 unsigned long SeekL;			//current byte location in file

SeekL dd 0
;-41 //	end array of handles of every open file

;-42 

;-43 //FATInit

;-44 unsigned int  fat_FatStartSector;

fat_FatStartSector dw 0
;-45 unsigned long fat_FatStartSectorL;

fat_FatStartSectorL dd 0
;-46 unsigned int  fat_FatSectors;

fat_FatSectors dw 0
;-47 unsigned long fat_RootDirStartSectorL;

fat_RootDirStartSectorL dd 0
;-48 unsigned long fat_RootDirSectorsL;

fat_RootDirSectorsL dd 0
;-49 unsigned long fat_DataStartSectorL;

fat_DataStartSectorL dd 0
;-50 unsigned long num_tracksL;

num_tracksL dd 0
;-51 unsigned long Sectors_per_cylinderL;

Sectors_per_cylinderL dd 0
;-52 unsigned long DataSectors32;

DataSectors32 dd 0
;-53 unsigned long CountofClustersL;

CountofClustersL dd 0
;-54 unsigned char trueFATtype;	//12, 16, 32 from FATInit

trueFATtype db 0
;-55 unsigned long bytes_per_clusterL;

bytes_per_clusterL dd 0
;-56 

;-57 //Params from int13h, Function 8

;-58 unsigned int  pa_Cylinders;

pa_Cylinders dw 0
;-59 unsigned char pa_Sectors;

pa_Sectors db 0
;-60 unsigned char pa_Heads;

pa_Heads db 0
;-61 unsigned char pa_Attached;

pa_Attached db 0
;-62 unsigned int  pt_PartNo;

pt_PartNo dw 0
;-63 

;-64 //start hard disk partition structure 16 bytes in MBR. do not change!!!!!

;-65 unsigned char pt_Bootable;		// 00 80h = active partition, else 00

pt_Bootable db 0
;-66 unsigned char pt_StartHead;		// 01

pt_StartHead db 0
;-67 unsigned char pt_StartSector;	// 02 bits 0-5

pt_StartSector db 0
;-68 unsigned int  pt_StartCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-69 unsigned char pt_FileSystem;	// 04 0=nu,1=FAT12,4=16,5=ExtP,6=large16

pt_FileSystem db 0
;-70 unsigned char pt_EndHead;		// 05

pt_EndHead db 0
;-71 unsigned char pt_EndSector;		// 06 bits 0-5

pt_EndSector db 0
;-72 unsigned int  pt_EndCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-73 unsigned long pt_HiddenSector;	// 08 sectors preceding partition

pt_HiddenSector dd 0
;-74 unsigned long pt_PartLen;    	// 12 length of partition in sectors

pt_PartLen dd 0
;-75 //  16 end hard disk partition structure

;-76 

;-77 //start boot BIOS Parameter Block structure. do not change!!!!!

;-78 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-79 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-80 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-81 unsigned char bs_clust_size;// 13 sectors per CurCluster (1,2,4,..,128)

bs_clust_size db 0
;-82 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-83 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-84 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-85 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-86 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-87 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-88 unsigned int  bs_sectors_per_track; // 24 (DOS 3+)sectors per track

bs_sectors_per_track dw 0
;-89 unsigned int  bs_num_heads;	// 26 (DOS 3+)number of heads

bs_num_heads dw 0
;-90 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors

bs_hid_sects dd 0
;-91 unsigned long bs_tot_sect32;// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-92 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-93 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-94 unsigned char bs_ext_signat;// 38 (DOS 4+) Ext. signature,get next 3(29h)

bs_ext_signat db 0
;-95 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-96 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-97 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-98 // 62 end boot BIOS Parameter Block

;-99 

;-100 //start directory entry structure, do not change!!!!!

;-101 unsigned char dir_Filename[]="1234567";	//00 +lengthbyte=11

dir_Filename db "1234567",0
;-102 unsigned char dir_Ext[]="12";	//07 +lengthbyte=3

dir_Ext db "12",0
;-103 unsigned char dir_Attrib;		//11 directory=10h, Label=08h, read only=1

dir_Attrib db 0
;-104 unsigned char dir_NTReserved;	//12 low case in body=8h, in ext=10h

dir_NTReserved db 0
;-105 unsigned char dir_TimeCreatedMS;//13 in 10 milliseconda or zero

dir_TimeCreatedMS db 0
;-106 unsigned int  dir_TimeCreated;	//14 creation time, resolution 2 sec. or 0

dir_TimeCreated dw 0
;-107 unsigned int  dir_DateCreated;	//16 creation date or zero

dir_DateCreated dw 0
;-108 unsigned int  dir_DateLastAccessd;		//18 no time info available or zero

dir_DateLastAccessd dw 0
;-109 unsigned int  dir_FirstClusterHiBytes;	//20 FAT12/16 always zero

dir_FirstClusterHiBytes dw 0
;-110 unsigned int  dir_LastModTime;	//22 modification time on closing

dir_LastModTime dw 0
;-111 unsigned int  dir_LastModDate;	//24 modification date on closing

dir_LastModDate dw 0
;-112 unsigned int  dir_FirstCluster;	//26 1.clu. of file data,if filesize=0 then0

dir_FirstCluster dw 0
;-113 unsigned long dir_FileSize;		//28 size in bytes, if directory then zero

dir_FileSize dd 0
;-114 // 32 end direcctory entry structure

;-115 

;-116 int test() {


test: PROC
;-117 	__asm{


;-118 }	}


;-119 

;-120 //------------------------------------   IO  -------------------

;-121 

;-122 int writetty()     {//char in AL

 ret
ENDP

writetty: PROC
;-123     ah=0x0E;

 mov  ah, 14
;-124     push bx;

push bx;
;-125     bx=0;			//page in BH

 mov  bx, 0
;-126     inth 0x10;		//16

 int  16
;-127     pop bx;

pop bx;
;-128 }

;-129 int putch(char c)  {

 ret
ENDP

putch: PROC
;-130     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;98 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-131         al=13;

 mov  al, 13
;-132         writetty();

 call writetty
;-133     }

;-134     al=c;

.putch1:
 mov  al, [bp+4]
;-135     writetty();

 call writetty
;-136 }

;-137 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-138     char c;

;-139     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;98 ptr sign byte s = bp+4
;99 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-140         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-141         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-142         s++;

 inc  word[bp+4]
;-143     }

;-144 }

 jmp .cputs2
.cputs3:
;-145 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-146 	char c;

;-147 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;98 ptr sign byte s = bp+4
;99 var sign word len = bp+6
;100 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-148 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-149 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-150 		s++;

 inc  word[bp+4]
;-151 		len--;

 dec  word[bp+6]
;-152 	} while (len > 0);

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-153 }

;-154 

;-155 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-156     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-157     inth 0x16;//AH=Scan code, AL=char

 int  22
;-158 }

;-159 int waitkey() {

 ret
ENDP

waitkey: PROC
;-160     ah=0x11;//get kbd status

 mov  ah, 17
;-161     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-162     //zero flag: 0=IS char, 1=NO char

;-163     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-164 }

;-165 int getkey() {

 ret
ENDP

getkey: PROC
;-166     waitkey();

 call waitkey
;-167     getch();

 call getch
;-168     ah=0;//clear scan code

 mov  ah, 0
;-169     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-170     //put ext code in AX

;-171 }

.getkey6:
;-172 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-173     getkey();

 call getkey
;-174     writetty();//destroys AH

 call writetty
;-175 }

;-176 

;-177 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-178     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;98 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-179     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-180     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-181 }

;-182 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-183     unsigned char nib;

;-184     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;98 var unsg byte c = bp+4
;99 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-185     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-186 }

;-187 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-188     unsigned int half;

;-189     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;98 var unsg word i = bp+4
;99 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-190     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-191 }

;-192 

;-193 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-194     unsigned int e;

;-195     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;98 var unsg word n = bp+4
;99 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-196         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-197         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-198         }

;-199     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-200     n+='0';

 add  word[bp+4], 48
;-201     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-202 }

;-203 

;-204 int printlong(unsigned long L) {

 LEAVE
 ret
ENDP

printlong: PROC
;-205     ax = L;     // get low in ax

;Function : printlong, Number local Var: 1
; # type sign width local variables
;98 var unsg long L = bp+4;
 ENTER  0,0
 mov  ax, [bp+4]
;-206     edx=L;

 mov  edx, [bp+4]
;-207     edx >> 16;  // get high in dx

 shr  edx, 16
;-208 __asm{


;-209   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-210     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-211 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-212     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-213     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-214 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-215     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-216     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-217     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-218     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-219     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-220     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-221     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-222     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-223 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-224 }	writetty();		__asm{


 call writetty

;-225     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-226     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-227     jb      .b             ;Not yet

    jb      .b             ;Not yet
;-228 }


;-229 }

;-230 //--------------------------------  string  ---------------------

;-231 int strlen(char *s) { int c;

 LEAVE
 ret
ENDP

strlen: PROC
;-232     c=0;

;Function : strlen, Number local Var: 2
; # type sign width local variables
;98 ptr sign byte s = bp+4
;99 var sign word c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-233     if (*s == 34) return 0; // "

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 jne .strlen9
 mov ax, 0
 jmp .retnstrlen
;-234     while (*s!=0) {s++; c++;}

.strlen9:
.strlen10:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen11
 inc  word[bp+4]
 inc  word[bp-2]
;-235     return c;

 jmp .strlen10
.strlen11:
 mov ax, [bp-2]
 jmp .retnstrlen
;-236 }

;-237 int strcpy(char *s, char *t) {//new

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-238     while (*t!=0) {

;Function : strcpy, Number local Var: 2
; # type sign width local variables
;98 ptr sign byte s = bp+4
;99 ptr sign byte t = bp+6;
 ENTER  0,0
.strcpy12:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy13
;-239     	*s=*t; s++; t++; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-240     *s=0;

 jmp .strcpy12
.strcpy13:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-241     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-242 }

;-243 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-244     while(*p) {

;Function : eqstr, Number local Var: 2
; # type sign width local variables
;98 ptr sign byte p = bp+4
;99 ptr sign byte q = bp+6;
 ENTER  0,0
.eqstr14:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr15
;-245         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr16
 mov ax, 0
 jmp .retneqstr
;-246         p++;

.eqstr16:
 inc  word[bp+4]
;-247         q++;

 inc  word[bp+6]
;-248     }

;-249     if(*q) return 0;

 jmp .eqstr14
.eqstr15:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr17
 mov ax, 0
 jmp .retneqstr
;-250     return 1;

.eqstr17:
 mov ax, 1
 jmp .retneqstr
;-251 }

;-252 

;-253 int memcmp(char *s, char *t, unsigned int i) {

 .retneqstr:
 LEAVE
 ret
ENDP

memcmp: PROC
;-254     do {

;Function : memcmp, Number local Var: 3
; # type sign width local variables
;98 ptr sign byte s = bp+4
;99 ptr sign byte t = bp+6
;100 var unsg word i = bp+8;
 ENTER  0,0
.memcmp18:
;-255         if (*s < *t) return 0xFFFF;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 jge .memcmp19
 mov ax, 65535
 jmp .retnmemcmp
;-256         if (*s > *t) return 1;

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
;-257         s++; t++; i--;

.memcmp20:
 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-258     } while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcmp21
 jmp .memcmp18
.memcmp21:
;-259     return 0;

 mov ax, 0
 jmp .retnmemcmp
;-260 }

;-261 

;-262 int strcat(char *s, char *t) {

 .retnmemcmp:
 LEAVE
 ret
ENDP

strcat: PROC
;-263     while (*s != 0) s++;

;Function : strcat, Number local Var: 2
; # type sign width local variables
;98 ptr sign byte s = bp+4
;99 ptr sign byte t = bp+6;
 ENTER  0,0
.strcat22:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat23
 inc  word[bp+4]
;-264     strcpy(s, t);

 jmp .strcat22
.strcat23:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4
;-265 }

;-266 int toupper(char *s) {

 LEAVE
 ret
ENDP

toupper: PROC
;-267     while(*s) {

;Function : toupper, Number local Var: 1
; # type sign width local variables
;98 ptr sign byte s = bp+4;
 ENTER  0,0
.toupper24:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper25
;-268         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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
;-269         s++;

.toupper27:
.toupper26:
 inc  word[bp+4]
;-270     }

;-271 }

 jmp .toupper24
.toupper25:
;-272 int strchr(char *s, char c) {

 LEAVE
 ret
ENDP

strchr: PROC
;-273     while(*s) {

;Function : strchr, Number local Var: 2
; # type sign width local variables
;98 ptr sign byte s = bp+4
;99 var sign byte c = bp+6;
 ENTER  0,0
.strchr28:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .strchr29
;-274         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .strchr30
 mov ax, [bp+4]
 jmp .retnstrchr
;-275         s++;

.strchr30:
 inc  word[bp+4]
;-276     }

;-277     return 0;

 jmp .strchr28
.strchr29:
 mov ax, 0
 jmp .retnstrchr
;-278 }

;-279 int memchr(char *s, char c, unsigned int i) {

 .retnstrchr:
 LEAVE
 ret
ENDP

memchr: PROC
;-280     while(i > 0) {

;Function : memchr, Number local Var: 3
; # type sign width local variables
;98 ptr sign byte s = bp+4
;99 var sign byte c = bp+6
;100 var unsg word i = bp+8;
 ENTER  0,0
.memchr31:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr32
;-281         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr33
 mov ax, [bp+4]
 jmp .retnmemchr
;-282         s++; i--;

.memchr33:
 inc  word[bp+4]
 dec  word[bp+8]
;-283     }

;-284     return 0;

 jmp .memchr31
.memchr32:
 mov ax, 0
 jmp .retnmemchr
;-285 }

;-286 int memchr1(char *s, char c, unsigned int i) {

 .retnmemchr:
 LEAVE
 ret
ENDP

memchr1: PROC
;-287 	unsigned int pos;

;-288 	pos=1;

;Function : memchr1, Number local Var: 4
; # type sign width local variables
;98 ptr sign byte s = bp+4
;99 var sign byte c = bp+6
;100 var unsg word i = bp+8
;101 var unsg word pos = bp-2;
 ENTER  2,0
 mov ax, 1
 mov [bp-2], ax
;-289     while(i > 0) {

.memchr134:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr135
;-290         if (*s==c) return pos;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr136
 mov ax, [bp-2]
 jmp .retnmemchr1
;-291         s++; i--; pos++;

.memchr136:
 inc  word[bp+4]
 dec  word[bp+8]
 inc  word[bp-2]
;-292     }

;-293     return 0;

 jmp .memchr134
.memchr135:
 mov ax, 0
 jmp .retnmemchr1
;-294 }

;-295 int instr1(char *s, char c) {

 .retnmemchr1:
 LEAVE
 ret
ENDP

instr1: PROC
;-296     while(*s) {

;Function : instr1, Number local Var: 2
; # type sign width local variables
;98 ptr sign byte s = bp+4
;99 var sign byte c = bp+6;
 ENTER  0,0
.instr137:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .instr138
;-297         if (*s==c) return 1;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .instr139
 mov ax, 1
 jmp .retninstr1
;-298         s++;

.instr139:
 inc  word[bp+4]
;-299     }

;-300     return 0;

 jmp .instr137
.instr138:
 mov ax, 0
 jmp .retninstr1
;-301 }

;-302 

;-303 int memcpy(char *s, char *t, unsigned int i) {

 .retninstr1:
 LEAVE
 ret
ENDP

memcpy: PROC
;-304 	unsigned int r;

;-305 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;98 ptr sign byte s = bp+4
;99 ptr sign byte t = bp+6
;100 var unsg word i = bp+8
;101 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-306 	do {

.memcpy40:
;-307 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-308 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-309 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy41
 jmp .memcpy40
.memcpy41:
;-310 	ax=r;//	return r;

 mov  ax, [bp-2]
;-311 }

;-312 

;-313 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-314     unsigned char c; unsigned char chal; int i; int j; int k;

;-315     j=0;

;Function : mdump, Number local Var: 7
; # type sign width local variables
;98 ptr unsg byte adr = bp+4
;99 var unsg word len = bp+6
;100 var unsg byte c = bp-2
;101 var unsg byte chal = bp-4
;102 var sign word i = bp-6
;103 var sign word j = bp-8
;104 var sign word k = bp-10;
 ENTER  10,0
 mov ax, 0
 mov [bp-8], ax
;-316     k=0;

 mov ax, 0
 mov [bp-10], ax
;-317     while (j < len ) {

.mdump42:
 mov ax, [bp-8]
 cmp ax, [bp+6]
 jge .mdump43
;-318 	    k++;;

 inc  word[bp-10]
;-319 	    if (k > 8) {

 mov ax, [bp-10]
 cmp ax, 8
 jle .mdump44
;-320 		    chal = getkey();//remove scan code

 call getkey
 mov [bp-4], al
;-321 		    if (chal =='q') return;

 mov al, [bp-4]
 cmp al, 113
 jne .mdump45
 jmp .retnmdump
;-322 		    k=1;

.mdump45:
 mov ax, 1
 mov [bp-10], ax
;-323 		    }

;-324         putch(10);

.mdump44:
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
 mov [bp-6], ax
;-328         while (i < 16) {

.mdump46:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump47
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

 inc  word[bp-6]
;-334             j++;

 inc  word[bp-8]
;-335             }

;-336         putch(' ');

 jmp .mdump46
.mdump47:
 push 32
 call putch
 add  sp, 2
;-337         adr -=16;

 sub  word[bp+4], 16
;-338         i=0;

 mov ax, 0
 mov [bp-6], ax
;-339         while(i < 16) {

.mdump48:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump49
;-340             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-341             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump50
 push 46
 call putch
 add  sp, 2
;-342                 else putch(c);

 jmp .mdump51
.mdump50:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-343             adr++;

.mdump51:
 inc  word[bp+4]
;-344             i++;

 inc  word[bp-6]
;-345         }

;-346     }

 jmp .mdump48
.mdump49:
;-347     getkey();

 jmp .mdump42
.mdump43:
 call getkey
;-348     putch(10);

 push 10
 call putch
 add  sp, 2
;-349 

;-350 }

;-351 

;-352 //--------------------------------  disk IO  -------------------

;-353 

;-354 int DiskSectorReadWrite(char rw, char drive, char head, int cyl,

 .retnmdump:
 LEAVE
 ret
ENDP

DiskSectorReadWrite: PROC
;-355 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-356 	BIOS_ERR=0;

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;98 var sign byte rw = bp+4
;99 var sign byte drive = bp+6
;100 var sign byte head = bp+8
;101 var sign word cyl = bp+10
;102 var sign byte sector = bp+12
;103 var sign byte count = bp+14
;104 var sign word BufSeg = bp+16
;105 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-357 	dl=drive;

 mov  dl, [bp+6]
;-358 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-359 	es=BufSeg;

 mov  es, [bp+16]
;-360 	bx=BufOfs;

 mov  bx, [bp+18]
;-361 	cx=cyl;

 mov  cx, [bp+10]
;-362 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-363 	cx >> 2;//in 2 high bits of cl

 shr  cx, 2
;-364 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-365 	cl += sector;

 add  cl, [bp+12]
;-366 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-367 	al=count;

 mov  al, [bp+14]
;-368 	ah=rw;

 mov  ah, [bp+4]
;-369 	inth 0x13;

 int  19
;-370     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-371 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-372 }

;-373 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-374 	BIOS_ERR=0;

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;98 var sign byte drive = bp+4
;99 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-375 	dl=drive;

 mov  dl, [bp+4]
;-376 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-377 	inth 0x13;

 int  19
;-378     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-379 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-380 }

;-381 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-382 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-383 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-384 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-385 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-386 }

;-387 int Status(drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Status: PROC
;-388 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;98 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-389 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-390 	BIOS_Status=Int13hfunction(drive, 1);

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-391 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Status52
 call Int13hError
;-392 	printhex16(BIOS_Status);

.Status52:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-393 }

;-394 

;-395 int Params() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

Params: PROC
;-396 	if (debug) cputs(" DriveParams");

 mov ax, 1
 or  al, al
 je .Params53
 push Params_0
 call cputs
 add  sp, 2
;-397 	BIOS_Status=Int13hfunction(Drive, 8);

.Params53:
 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-398 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params54
;-399 		Int13hError();

 call Int13hError
;-400 		return 1;

 mov ax, 1
 jmp .retnParams
;-401 		}

;-402 	else {

 jmp .Params55
.Params54:
;-403 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-404 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-405 		// CX =       ---CH--- ---CL---

;-406 		// cylinder : 76543210 98

;-407 		// sector   :            543210

;-408 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-409 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-410 //		pa_Sectors++;//1 to 64

;-411 

;-412 		asm mov [pa_Cylinders],    cx

 mov [pa_Cylinders],    cx
;-413 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-414 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-415 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty

 add [pa_Cylinders],    ch;//byte add, low byte is empty
;-416 

;-417 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params56
;-418 			cputs(" ** no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-419 			return 1;

 mov ax, 1
 jmp .retnParams
;-420 			}

;-421 	}

.Params56:
;-422 	return 0;

.Params55:
 mov ax, 0
 jmp .retnParams
;-423 }

;-424 

;-425 

;-426 int getPartitionData() {

 .retnParams:
 ret
Params_0 db " DriveParams",0
Params_1 db " ** no hard disk found",0
ENDP

getPartitionData: PROC
;-427 	unsigned int j; char c; char *p;

;-428 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;98 var unsg word j = bp-2
;99 var sign byte c = bp-4
;100 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [pt_PartNo]
 shl ax, 4
 mov [bp-2], ax
;-429 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-430 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-431 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-432 	pt_StartCylinder=(int)pt_StartSector;

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-433 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-434 //	pt_StartSector++;//Sector start with 1 todo

;-435 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-436 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-437 	j++;

 inc  word[bp-2]
;-438 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-439 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-440 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB

;-441 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-442 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-443 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-444 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-445 //	pt_EndSector++;//Sector start with 1 todo

;-446 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-447 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-448 	j++;

 inc  word[bp-2]
;-449 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-450 	j++;

 inc  word[bp-2]
;-451 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-452 	memcpy(&pt_HiddenSector, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-453 }

;-454 

;-455 int checkBootSign() {

 LEAVE
 ret
ENDP

checkBootSign: PROC
;-456 	int i;

;-457 	i=510;

;Function : checkBootSign, Number local Var: 1
; # type sign width local variables
;98 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-458 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign57
;-459 		i++;

 inc  word[bp-2]
;-460 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign58
 mov ax, 1
 jmp .retncheckBootSign
;-461 	}

.checkBootSign58:
;-462 	cputs("  **Magic number NOT found.");

.checkBootSign57:
 push checkBootSign_0
 call cputs
 add  sp, 2
;-463 	return 0;

 mov ax, 0
 jmp .retncheckBootSign
;-464 }

;-465 

;-466 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db "  **Magic number NOT found.",0
ENDP

readMBR: PROC
;-467 	int isFAT;

;-468 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;98 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-469 	pt_PartNo=0;

 mov ax, 0
 mov word [pt_PartNo], ax
;-470 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-471 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR59
;-472 		Int13hError();

 call Int13hError
;-473 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-474 		}

;-475 	else {

 jmp .readMBR60
.readMBR59:
;-476 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .readMBR61
 mov ax, 0
 jmp .retnreadMBR
;-477 		do {

.readMBR61:
.readMBR62:
;-478 			getPartitionData();

 call getPartitionData
;-479 

;-480 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR63
;-481 				if (debug) cputs(" Boot part. found");

 mov ax, 1
 or  al, al
 je .readMBR64
 push readMBR_0
 call cputs
 add  sp, 2
;-482 				if (pt_FileSystem == 1) {

.readMBR64:
 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR65
;-483 					cputs(", FAT12 part. <32MB");

 push readMBR_1
 call cputs
 add  sp, 2
;-484 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-485 					}

;-486 				if (pt_FileSystem == 4) {

.readMBR65:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR66
;-487 					cputs(", small FAT16 part.<32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-488 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-489 					}

;-490 				if (pt_FileSystem == 6) {

.readMBR66:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR67
;-491 					if (debug) cputs(", large FAT16 part.");

 mov ax, 1
 or  al, al
 je .readMBR68
 push readMBR_3
 call cputs
 add  sp, 2
;-492 					isFAT=6;

.readMBR68:
 mov ax, 6
 mov [bp-2], ax
;-493 					}

;-494 				pt_PartNo=99;//end of loop

.readMBR67:
 mov ax, 99
 mov word [pt_PartNo], ax
;-495 			}

;-496 			pt_PartNo ++;

.readMBR63:
 inc  word[pt_PartNo]
;-497 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR69
 jmp .readMBR62
.readMBR69:
;-498 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-499 	}

;-500 }

.readMBR60:
;-501 

;-502 int getBootSector() {

 .retnreadMBR:
 LEAVE
 ret
readMBR_0 db " Boot part. found",0
readMBR_1 db ", FAT12 part. <32MB",0
readMBR_2 db ", small FAT16 part.<32MB",0
readMBR_3 db ", large FAT16 part.",0
ENDP

getBootSector: PROC
;-503 	int i;

;-504 	if (debug) cputs(" Boot sector:");

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;98 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 1
 or  al, al
 je .getBootSector70
 push getBootSector_0
 call cputs
 add  sp, 2
;-505   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

.getBootSector70:
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
;-507 	if (debug) printhex16(BIOS_Status);

 mov ax, 1
 or  al, al
 je .getBootSector71
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-508 	if (BIOS_ERR) {

.getBootSector71:
 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector72
;-509 		Int13hError();

 call Int13hError
;-510 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-511 		}

;-512 	else {

 jmp .getBootSector73
.getBootSector72:
;-513 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .getBootSector74
 mov ax, 0
 jmp .retngetBootSector
;-514 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector74:
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
 je  .getBootSector75
 push getBootSector_1
 call cputs
 add  sp, 2
;-516 		i=2;

.getBootSector75:
 mov ax, 2
 mov [bp-2], ax
;-517 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector76
 push getBootSector_2
 call cputs
 add  sp, 2
;-518 	}

.getBootSector76:
;-519 	return 1;

.getBootSector73:
 mov ax, 1
 jmp .retngetBootSector
;-520 }

;-521 

;-522 int FATInit() {

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Boot sector:",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-523 	unsigned long templong;//converting word to dword

;-524 

;-525 	clust_sizeL = (long) bs_clust_size;

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;98 var unsg long templong = bp-4;
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
 jne .FATInit77
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-532 

;-533 	fat_RootDirStartSectorL = (long)fat_FatStartSector + fat_FatSectors;

.FATInit77:
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
 je  .FATInit78
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-540 	DataSectors32=bs_tot_sect32 - fat_DataStartSectorL;

.FATInit78:
 mov eax, [bs_tot_sect32]
 sub eax, [fat_DataStartSectorL]
 mov dword [DataSectors32], eax
;-541 

;-542 	CountofClustersL=DataSectors32 / clust_sizeL;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [clust_sizeL]
 mov dword [CountofClustersL], eax
;-543 

;-544 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-545 	num_tracksL = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [num_tracksL], eax
;-546 

;-547 //	templong = (long) bs_num_heads;

;-548 //	fat_num_cylinders = num_tracksL / templong;//w=d/w

;-549 	

;-550 	bytes_per_clusterL = (long) bs_clust_size * bs_sect_size;

 xor eax, eax
 mov al, [bs_clust_size]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_sect_size]
 mov dword [bytes_per_clusterL], eax
;-551 

;-552 	Sectors_per_cylinderL = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinderL], eax
;-553 	asm mov [Sectors_per_cylinderL + 2], dx;store high word

 mov [Sectors_per_cylinderL + 2], dx;store high word
;-554 

;-555 	templong = (long) 65525;

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-556 	if (CountofClustersL > templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jle .FATInit79
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

.FATInit79:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-562 	if (CountofClustersL < templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jge .FATInit80
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

.FATInit80:
 mov ax, 16
 mov byte [trueFATtype], al
;-568 	if (debug) cputs(" FAT16");

 mov ax, 1
 or  al, al
 je .FATInit81
 push FATInit_2
 call cputs
 add  sp, 2
;-569 	return 0;

.FATInit81:
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
;-578 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt82
;-579 		cputs(" Ext. NOT present");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-580 		Int13hError();

 call Int13hError
;-581 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-582 		}

;-583 	else if (debug) cputs(",Int13h Ext.");

 jmp .Int13hExt83
.Int13hExt82:
 mov ax, 1
 or  al, al
 je .Int13hExt84
 push Int13hExt_1
 call cputs
 add  sp, 2
;-584 	putch(10);

.Int13hExt84:
.Int13hExt83:
 push 10
 call putch
 add  sp, 2
;-585 	return 0;

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

;-591 	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);

;Function : PrintDriveParameter, Number local Var: 1
; # type sign width local variables
;98 var unsg long Lo = bp-4;
 ENTER  4,0
 push PrintDriveParameter_0
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-592 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-593 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-594 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-595 	putch('.');

 push 46
 call putch
 add  sp, 2
;-596 //from getPartitionData

;-597 	putch(10);

 push 10
 call putch
 add  sp, 2
;-598 	cputs("getPartitionData:No=");printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-599 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-600 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-601 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-602 	cputs("/");				printunsign(pt_StartSector);

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-603 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-604 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-605 	cputs("/");				printunsign(pt_EndSector);

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-606 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-607 	cputs(",Start=");		printlong(pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 push dword [pt_HiddenSector]
 call printlong
 add  sp, 4
;-608 	cputs(",Len=");			printlong(pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 push dword [pt_PartLen]
 call printlong
 add  sp, 4
;-609 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-610 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-611 	printlong(Lo);

 push dword [bp-4]
 call printlong
 add  sp, 4
;-612 	cputs(" MByte.");

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-613 //from getBootSector

;-614 	putch(10);

 push 10
 call putch
 add  sp, 2
;-615 	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-616 	putch(10);

 push 10
 call putch
 add  sp, 2
;-617 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-618 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-619 	putch(10);

 push 10
 call putch
 add  sp, 2
;-620 	cputs("Reserved sectors=");printunsign(bs_res_sects);

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-621 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-622 	putch(10);

 push 10
 call putch
 add  sp, 2
;-623 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-624 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-625 	putch(10);

 push 10
 call putch
 add  sp, 2
;-626 	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-627 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-628 	putch(10);

 push 10
 call putch
 add  sp, 2
;-629 	cputs("sectors per track=");printunsign(bs_sectors_per_track);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_sectors_per_track]
 call printunsign
 add  sp, 2
;-630 	cputs(".number of heads=");printunsign(bs_num_heads);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_heads]
 call printunsign
 add  sp, 2
;-631 	putch(10);

 push 10
 call putch
 add  sp, 2
;-632 	cputs("hidden sectors(long)=");printlong(bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 push dword [bs_hid_sects]
 call printlong
 add  sp, 4
;-633 	cputs(".sectors(long)=");printlong(bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 push dword [bs_tot_sect32]
 call printlong
 add  sp, 4
;-634 	putch(10);

 push 10
 call putch
 add  sp, 2
;-635 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-636 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-637 	putch(10);

 push 10
 call putch
 add  sp, 2
;-638 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-639 	cputs(".Volume serial(long)=");printlong(bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 push dword [bs_serial_num]
 call printlong
 add  sp, 4
;-640 	putch(10);

 push 10
 call putch
 add  sp, 2
;-641 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-642 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-643 //from FATInit

;-644 	putch(10);

 push 10
 call putch
 add  sp, 2
;-645 	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [fat_FatStartSector]
 call printunsign
 add  sp, 2
;-646 	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [fat_FatSectors]
 call printunsign
 add  sp, 2
;-647 	putch(10);

 push 10
 call putch
 add  sp, 2
;-648 	cputs("fat_RootDirStartSectorL="); printlong(fat_RootDirStartSectorL);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push dword [fat_RootDirStartSectorL]
 call printlong
 add  sp, 4
;-649 	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectorsL);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push dword [fat_RootDirSectorsL]
 call printunsign
 add  sp, 4
;-650 	putch(10);

 push 10
 call putch
 add  sp, 2
;-651 	cputs("fat_DataStartSectorL=");	printunsign(fat_DataStartSectorL);

 push PrintDriveParameter_38
 call cputs
 add  sp, 2
 push dword [fat_DataStartSectorL]
 call printunsign
 add  sp, 4
;-652 	cputs(", DataSectors32=");	printlong(DataSectors32);

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 push dword [DataSectors32]
 call printlong
 add  sp, 4
;-653 	putch(10);

 push 10
 call putch
 add  sp, 2
;-654 	cputs("CountofClustersL=");	printlong(CountofClustersL);

 push PrintDriveParameter_40
 call cputs
 add  sp, 2
 push dword [CountofClustersL]
 call printlong
 add  sp, 4
;-655 	cputs(", Sectors_per_cylinderL="); printlong(Sectors_per_cylinderL);

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 push dword [Sectors_per_cylinderL]
 call printlong
 add  sp, 4
;-656 	putch(10);

 push 10
 call putch
 add  sp, 2
;-657 	cputs("num_tracksL=");	printlong(num_tracksL);

 push PrintDriveParameter_42
 call cputs
 add  sp, 2
 push dword [num_tracksL]
 call printlong
 add  sp, 4
;-658 	cputs(", bytes_per_clusterL=");	printlong(bytes_per_clusterL);

 push PrintDriveParameter_43
 call cputs
 add  sp, 2
 push dword [bytes_per_clusterL]
 call printlong
 add  sp, 4
;-659 //	cputs(", fat_num_cylinders="); printunsign(fat_num_cylinders);

;-660 	putch(10);

 push 10
 call putch
 add  sp, 2
;-661 	getkey();

 call getkey
;-662 }

;-663 

;-664 //--------------------------------  file IO  -------------------

;-665 int error2(char *s) {

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
;-666 	putch(10);

;Function : error2, Number local Var: 1
; # type sign width local variables
;98 ptr sign byte s = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-667 	cputs("*** ERROR *** ");

 push error2_0
 call cputs
 add  sp, 2
;-668 	cputs(s);

 push word [bp+4]
 call cputs
 add  sp, 2
;-669 	DOS_ERR++;

 inc  byte[DOS_ERR]
;-670 }

;-671 // 1.

;-672 int readLogical(unsigned long SectorL) {//OUT:1 sector in DiskBuf

 LEAVE
 ret
error2_0 db "*** ERROR *** ",0
ENDP

readLogical: PROC
;-673 	unsigned int track; unsigned int head; unsigned int sect;

;-674 	SectorL = SectorL + bs_hid_sects;//d=d+d

;Function : readLogical, Number local Var: 4
; # type sign width local variables
;98 var unsg long SectorL = bp+4
;99 var unsg word track = bp-2
;100 var unsg word head = bp-4
;101 var unsg word sect = bp-6;
 ENTER  6,0
 mov eax, [bp+4]
 add eax, [bs_hid_sects]
 mov [bp+4], eax
;-675 	track = SectorL / Sectors_per_cylinderL;  //w=d/d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinderL]
 mov [bp-2], ax
;-676 	head  = SectorL % Sectors_per_cylinderL;  //w=d%d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinderL]
 mov eax, edx
 mov [bp-4], ax
;-677 	sect  = head            % bs_sectors_per_track;  //w=w%w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov ax, dx
 mov [bp-6], ax
;-678 	sect++;

 inc  word[bp-6]
;-679 	head  = head            / bs_sectors_per_track;	 //w=w/w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov [bp-4], ax
;-680 

;-681 	DiskSectorReadWrite(2, bs_drive_num, head, track/* =cyl */,

;-682 		sect, 1, DiskBufSeg , DiskBuf);

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
;-683 }

;-684 // 2.a

;-685 int printDirEntry(int EntryNr) {

 LEAVE
 ret
ENDP

printDirEntry: PROC
;-686     unsigned int j;

;-687 	putch(10);

;Function : printDirEntry, Number local Var: 2
; # type sign width local variables
;98 var sign word EntryNr = bp+4
;99 var unsg word j = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-688 	printunsign(EntryNr);

 push word [bp+4]
 call printunsign
 add  sp, 2
;-689 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-690 	cputs(filename);

 lea  ax, [filename]
 push ax
 call cputs
 add  sp, 2
;-691 	cputs(" ATTR:");

 push printDirEntry_0
 call cputs
 add  sp, 2
;-692 	printhex8(dir_Attrib);	

 mov al, byte [dir_Attrib]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-693 	if (dir_Attrib &  1) cputs(" r/o");

 mov al, [dir_Attrib]
 and al, 1
 or  al, al
 je .printDirEntry85
 push printDirEntry_1
 call cputs
 add  sp, 2
;-694 	if (dir_Attrib &  2) cputs(" hid");

.printDirEntry85:
 mov al, [dir_Attrib]
 and al, 2
 or  al, al
 je .printDirEntry86
 push printDirEntry_2
 call cputs
 add  sp, 2
;-695 	if (dir_Attrib &  4) cputs(" sys");

.printDirEntry86:
 mov al, [dir_Attrib]
 and al, 4
 or  al, al
 je .printDirEntry87
 push printDirEntry_3
 call cputs
 add  sp, 2
;-696 	if (dir_Attrib &  8) cputs(" vol");		

.printDirEntry87:
 mov al, [dir_Attrib]
 and al, 8
 or  al, al
 je .printDirEntry88
 push printDirEntry_4
 call cputs
 add  sp, 2
;-697 	if (dir_Attrib & 16) cputs(" dir");

.printDirEntry88:
 mov al, [dir_Attrib]
 and al, 16
 or  al, al
 je .printDirEntry89
 push printDirEntry_5
 call cputs
 add  sp, 2
;-698 	if (dir_Attrib & 32) cputs(" arc");

.printDirEntry89:
 mov al, [dir_Attrib]
 and al, 32
 or  al, al
 je .printDirEntry90
 push printDirEntry_6
 call cputs
 add  sp, 2
;-699 	if (dir_Attrib == 0) cputs("    ");

.printDirEntry90:
 mov al, [dir_Attrib]
 cmp al, 0
 jne .printDirEntry91
 push printDirEntry_7
 call cputs
 add  sp, 2
;-700 	

;-701 	putch(' ');

.printDirEntry91:
 push 32
 call putch
 add  sp, 2
;-702 	j=dir_LastModDate & 31;//day

 mov ax, [dir_LastModDate]
 and ax, 31
 mov [bp-2], ax
;-703 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry92
 push 32
 call putch
 add  sp, 2
;-704 	printunsign(j);

.printDirEntry92:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-705 	putch('.');

 push 46
 call putch
 add  sp, 2
;-706 

;-707 	j=dir_LastModDate >> 5;//month

 mov ax, [dir_LastModDate]
 shr ax, 5
 mov [bp-2], ax
;-708 	j&=  15;

 and  word[bp-2], 15
;-709 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry93
 push 48
 call putch
 add  sp, 2
;-710 	printunsign(j);

.printDirEntry93:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-711 	putch('.');

 push 46
 call putch
 add  sp, 2
;-712 

;-713 	j=dir_LastModDate >> 9;//year

 mov ax, [dir_LastModDate]
 shr ax, 9
 mov [bp-2], ax
;-714 	j+= 1980;

 add  word[bp-2], 1980
;-715 	printunsign(j);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-716 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-717 	//putch(' ');

;-718 

;-719 	j=dir_LastModTime  >>11;//hour

 mov ax, [dir_LastModTime]
 shr ax, 11
 mov [bp-2], ax
;-720 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry94
 push 32
 call putch
 add  sp, 2
;-721 	printunsign(j);

.printDirEntry94:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-722 	putch(':');

 push 58
 call putch
 add  sp, 2
;-723 

;-724 	j=dir_LastModTime  >> 5;//minute

 mov ax, [dir_LastModTime]
 shr ax, 5
 mov [bp-2], ax
;-725 	j&=  63;

 and  word[bp-2], 63
;-726 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry95
 push 48
 call putch
 add  sp, 2
;-727 	printunsign(j);

.printDirEntry95:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-728 	putch(':');

 push 58
 call putch
 add  sp, 2
;-729 

;-730 	j=dir_LastModTime & 31;// 2 seconds

 mov ax, [dir_LastModTime]
 and ax, 31
 mov [bp-2], ax
;-731 	j=j+j;

 mov ax, [bp-2]
 add ax, [bp-2]
 mov [bp-2], ax
;-732 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry96
 push 48
 call putch
 add  sp, 2
;-733 	printunsign(j);

.printDirEntry96:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-734 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-735 

;-736 	cputs(" 1.Cl:"); 

 push printDirEntry_8
 call cputs
 add  sp, 2
;-737 	printunsign(dir_FirstCluster);

 push word [dir_FirstCluster]
 call printunsign
 add  sp, 2
;-738 	cputs(" Size:");

 push printDirEntry_9
 call cputs
 add  sp, 2
;-739 	printlong(dir_FileSize);

 push dword [dir_FileSize]
 call printlong
 add  sp, 4
;-740 	

;-741 }

;-742 

;-743 // 2.b

;-744 int fatDirSectorList(unsigned long startSector, unsigned long numsectors) {

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
;-745     char *p;

;-746 	unsigned int EndDiskBuf;

;-747 	char isHide;//shows entries, NOT lfn, deleted or empty

;-748 	unsigned int EntryNr;

;-749 	EntryNr=0;

;Function : fatDirSectorList, Number local Var: 6
; # type sign width local variables
;98 var unsg long startSector = bp+4
;99 var unsg long numsectors = bp+8
;100 ptr sign byte p = bp-2
;101 var unsg word EndDiskBuf = bp-4
;102 var sign byte isHide = bp-6
;103 var unsg word EntryNr = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-8], ax
;-750 	do {

.fatDirSectorList97:
;-751 /*		putch(10);

;-752 		cputs("Sektor = "); 

;-753 		printlong(startSector);

;-754 		cputs(", numsectors = "); 

;-755 		printlong(numsectors);

;-756 		getkey();

;-757 */

;-758 		readLogical(startSector);

 push dword [bp+4]
 call readLogical
 add  sp, 4
;-759 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-760 		EndDiskBuf= p + bs_sect_size;		

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-761 		

;-762 		do {

.fatDirSectorList98:
;-763 			memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-764 			memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-765 			filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-766 			

;-767 			isHide=0;//show in listing

 mov ax, 0
 mov [bp-6], al
;-768 			if (*p ==    0) {//only empty entries following

 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorList99
;-769 				isHide++;

 inc  byte[bp-6]
;-770 				numsectors=1;//finish searching

 mov ax, 1
 mov [bp+8], eax
;-771 				p = EndDiskBuf;

 mov ax, [bp-4]
 mov [bp-2], ax
;-772 				}

;-773 			if (*p == 0xE5) isHide++;//deleted, free entry

.fatDirSectorList99:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 229
 jne .fatDirSectorList100
 inc  byte[bp-6]
;-774 			if (*p <=   31) isHide++;//part of LFN

.fatDirSectorList100:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 31
 jg  .fatDirSectorList101
 inc  byte[bp-6]
;-775 			if (dir_Attrib ==    15) isHide++;//LFN start

.fatDirSectorList101:
 mov al, [dir_Attrib]
 cmp al, 15
 jne .fatDirSectorList102
 inc  byte[bp-6]
;-776 					

;-777 			if (isHide == 0) printDirEntry(EntryNr);

.fatDirSectorList102:
 mov al, [bp-6]
 cmp al, 0
 jne .fatDirSectorList103
 push word [bp-8]
 call printDirEntry
 add  sp, 2
;-778 			p+=32;//get next entry

.fatDirSectorList103:
 add  word[bp-2], 32
;-779 			EntryNr++;

 inc  word[bp-8]
;-780 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorList104
 jmp .fatDirSectorList98
.fatDirSectorList104:
;-781 		startSector = startSector + 1;//long, do NOT use ++ or +=1

 mov eax, [bp+4]
 add eax, 1
 mov [bp+4], eax
;-782 		numsectors--;

 dec  dword[bp+8]
;-783 //mdump(DiskBuf, 512);

;-784 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorList105
 jmp .fatDirSectorList97
.fatDirSectorList105:
;-785 	CurCluster=0;//not found but not end

 mov ax, 0
 mov word [CurCluster], ax
;-786 }

;-787 

;-788 // 2.

;-789 int fatDirSectorSearch(unsigned long startSector,unsigned long numsectors) {

 LEAVE
 ret
ENDP

fatDirSectorSearch: PROC
;-790     //search for file name. IN:searchstr

;-791     char *p;

;-792 	unsigned int EndDiskBuf;

;-793 	fatfound=0;

;Function : fatDirSectorSearch, Number local Var: 4
; # type sign width local variables
;98 var unsg long startSector = bp+4
;99 var unsg long numsectors = bp+8
;100 ptr sign byte p = bp-2
;101 var unsg word EndDiskBuf = bp-4;
 ENTER  4,0
 mov ax, 0
 mov byte [fatfound], al
;-794 	do {

.fatDirSectorSearch106:
;-795 		readLogical(startSector);

 push dword [bp+4]
 call readLogical
 add  sp, 4
;-796 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-797 		EndDiskBuf= p + bs_sect_size;

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-798 		do {

.fatDirSectorSearch107:
;-799 			if (memcmp(p, searchstr, 11) == 0) {//found file name

 push 11
 lea  ax, [searchstr]
 push ax
 push word [bp-2]
 call memcmp
 add  sp, 6
 cmp ax, 0
 jne .fatDirSectorSearch108
;-800 				memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-801 				memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-802 				filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-803 				CurCluster   = dir_FirstCluster;

 mov ax, [dir_FirstCluster]
 mov word [CurCluster], ax
;-804 				FileSizeL  = dir_FileSize;

 mov eax, [dir_FileSize]
 mov dword [FileSizeL], eax
;-805 				fatfound=1;

 mov ax, 1
 mov byte [fatfound], al
;-806 			}

;-807 			if (*p == 0) return; //only empty entries following

.fatDirSectorSearch108:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorSearch109
 jmp .retnfatDirSectorSearch
;-808 			p+=32;//get next entry

.fatDirSectorSearch109:
 add  word[bp-2], 32
;-809 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorSearch110
 jmp .fatDirSectorSearch107
.fatDirSectorSearch110:
;-810 		startSector++;		

 inc  dword[bp+4]
;-811 		numsectors--;

 dec  dword[bp+8]
;-812 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorSearch111
 jmp .fatDirSectorSearch106
.fatDirSectorSearch111:
;-813 	CurCluster=0;//not found but not end

 mov ax, 0
 mov word [CurCluster], ax
;-814 }

;-815 

;-816 /*

;-817 // 3.

;-818 int fatRootSearch() {

;-819     fatDirSectorSearch(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-820 //	getkey();

;-821 //    fatDirSectorList(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-822 }

;-823 */

;-824 // 4.

;-825 int fatClusterAnalyse(unsigned int clust) {

 .retnfatDirSectorSearch:
 LEAVE
 ret
ENDP

fatClusterAnalyse: PROC
;-826 //OUT: CurSectorL, NextCluster

;-827 	unsigned long fatSectorL;

;-828 	unsigned int offset;

;-829 	char *p;

;-830 unsigned long offL;

;-831 

;-832 	CurSectorL = (long) clust - 2;

;Function : fatClusterAnalyse, Number local Var: 5
; # type sign width local variables
;98 var unsg word clust = bp+4
;99 var unsg long fatSectorL = bp-4
;100 var unsg word offset = bp-6
;101 ptr sign byte p = bp-8
;102 var unsg long offL = bp-12;
 ENTER  12,0
 xor eax, eax
 mov ax, [bp+4]
 sub ax, 2
 mov dword [CurSectorL], eax
;-833 	CurSectorL = CurSectorL * clust_sizeL;

 mov eax, [CurSectorL]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul dword [clust_sizeL]
 mov dword [CurSectorL], eax
;-834 	CurSectorL = CurSectorL + fat_DataStartSectorL;

 mov eax, [CurSectorL]
 add eax, [fat_DataStartSectorL]
 mov dword [CurSectorL], eax
;-835 	

;-836 //	fatSectorL=cluster*2/512+FatStartSector

;-837 	fatSectorL = (long) clust;

 xor eax, eax
 mov ax, [bp+4]
 mov [bp-4], eax
;-838 	fatSectorL = fatSectorL + fatSectorL;

 mov eax, [bp-4]
 add eax, [bp-4]
 mov [bp-4], eax
;-839 	fatSectorL = fatSectorL / sector_sizeL;		

 mov eax, [bp-4]
 xor edx, edx
 div dword [sector_sizeL]
 mov [bp-4], eax
;-840 	fatSectorL = fatSectorL + fat_FatStartSectorL; 

 mov eax, [bp-4]
 add eax, [fat_FatStartSectorL]
 mov [bp-4], eax
;-841 	readLogical(fatSectorL);

 push dword [bp-4]
 call readLogical
 add  sp, 4
;-842 	

;-843 	offset = clust + clust;//todo overflow?

 mov ax, [bp+4]
 add ax, [bp+4]
 mov [bp-6], ax
;-844 	offset = offset % bs_sect_size;

 mov ax, [bp-6]
 xor dx, dx
 div word [bs_sect_size]
 mov ax, dx
 mov [bp-6], ax
;-845 	

;-846 	p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-8], ax
;-847 	p = p + offset;	

 mov ax, [bp-8]
 add ax, [bp-6]
 mov [bp-8], ax
;-848 	memcpy(&NextCluster, p, 2);//OUT: NextCluster

 push 2
 push word [bp-8]
 lea  ax, [NextCluster]
 push ax
 call memcpy
 add  sp, 6
;-849 }

;-850 /*

;-851 // 5.

;-852 int fatDirSearch() {//search a directory chain. IN:searchstr

;-853 	

;-854 	fatClusterAnalyse(fatfile_cluster);

;-855 	//OUT: fatfile_sectorStartL, fatfile_nextCluster

;-856 

;-857 	fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster); 

;-858 	while (fatfile_cluster == 0) {//not found but not end

;-859 		if (fatfile_nextCluster >= 0xFFF8) {

;-860 			fat_notfound=1;

;-861 			return;	

;-862 		}		

;-863 		fatfile_cluster=fatfile_nextCluster;

;-864 		fatClusterAnalyse(fatfile_cluster);

;-865 		fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster);

;-866 	}	

;-867 }

;-868 */	

;-869 

;-870 int is_delimiter(char *s) {

 LEAVE
 ret
ENDP

is_delimiter: PROC
;-871 	if (*s == '/' ) return 1;

;Function : is_delimiter, Number local Var: 1
; # type sign width local variables
;98 ptr sign byte s = bp+4;
 ENTER  0,0
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 47
 jne .is_delimiter112
 mov ax, 1
 jmp .retnis_delimiter
;-872 	if (*s == '\\') return 1;

.is_delimiter112:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 92
 jne .is_delimiter113
 mov ax, 1
 jmp .retnis_delimiter
;-873 	if (*s ==    0) return 2;

.is_delimiter113:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .is_delimiter114
 mov ax, 2
 jmp .retnis_delimiter
;-874 	if (*s ==  '.') return 3;

.is_delimiter114:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 46
 jne .is_delimiter115
 mov ax, 3
 jmp .retnis_delimiter
;-875 	return 0;

.is_delimiter115:
 mov ax, 0
 jmp .retnis_delimiter
;-876 }

;-877 

;-878 // 6.

;-879 int fatNextSearch() {//get next part of filename to do a search

 .retnis_delimiter:
 LEAVE
 ret
ENDP

fatNextSearch: PROC
;-880 //	IN:  upto: points to start of search in filename 

;-881 //	OUT: upto: points to search for next time

;-882 //	OUT: searchstr: part of filename in DIR-format with blanks (11bytes)

;-883 //	OUT: isfilename: 0=part of directory, 1=filename

;-884 //	OUT: fatfound

;-885 	char *searchstrp;

;-886 	char *p; 

;-887 	unsigned int  len;

;-888 	unsigned int delimiter;

;-889 

;-890 	delimiter=is_delimiter(upto);

;Function : fatNextSearch, Number local Var: 4
; # type sign width local variables
;98 ptr sign byte searchstrp = bp-2
;99 ptr sign byte p = bp-4
;100 var unsg word len = bp-6
;101 var unsg word delimiter = bp-8;
 ENTER  8,0
 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-891 	if (delimiter == 1) upto++;

 mov ax, [bp-8]
 cmp ax, 1
 jne .fatNextSearch116
 inc  word[upto]
;-892 	if (delimiter == 2) return; 

.fatNextSearch116:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch117
 jmp .retnfatNextSearch
;-893 

;-894 	strcpy(&searchstr, "           ");//11 blank padded

.fatNextSearch117:
 push fatNextSearch_0
 lea  ax, [searchstr]
 push ax
 call strcpy
 add  sp, 4
;-895 	searchstrp = &searchstr;//clear searchstr

 mov ax, searchstr
 mov [bp-2], ax
;-896 	len=0;

 mov ax, 0
 mov [bp-6], ax
;-897 	delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-898 	while (delimiter == 0) { //no slash, zero, point

.fatNextSearch118:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch119
;-899 		*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-900 		searchstrp++;

 inc  word[bp-2]
;-901 		upto++;	

 inc  word[upto]
;-902 		len++;

 inc  word[bp-6]
;-903 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-904 	} 

;-905 	if (len > 8) return;

 jmp .fatNextSearch118
.fatNextSearch119:
 mov ax, [bp-6]
 cmp ax, 8
 jle .fatNextSearch120
 jmp .retnfatNextSearch
;-906 	isfilename=0;//todo: default directory, not yet implemented

.fatNextSearch120:
 mov ax, 0
 mov byte [isfilename], al
;-907 	if (delimiter == 2) isfilename=1;//last name is always a file name

 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch121
 mov ax, 1
 mov byte [isfilename], al
;-908 	if (delimiter == 3) {//remove dot in name		

.fatNextSearch121:
 mov ax, [bp-8]
 cmp ax, 3
 jne .fatNextSearch122
;-909 		searchstrp = &searchstr;

 mov ax, searchstr
 mov [bp-2], ax
;-910 		searchstrp += 8;//start extension		

 add  word[bp-2], 8
;-911 		len=0;

 mov ax, 0
 mov [bp-6], ax
;-912 		upto++;

 inc  word[upto]
;-913 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-914 		while (delimiter == 0) { //no slash, zero, point

.fatNextSearch123:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch124
;-915 			*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-916 			searchstrp++;

 inc  word[bp-2]
;-917 			upto++;	

 inc  word[upto]
;-918 			len++;

 inc  word[bp-6]
;-919 			delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-920 		} 

;-921 		if (len > 3) return;

 jmp .fatNextSearch123
.fatNextSearch124:
 mov ax, [bp-6]
 cmp ax, 3
 jle .fatNextSearch125
 jmp .retnfatNextSearch
;-922 		if (delimiter == 2) isfilename=1;//last name is always a file name

.fatNextSearch125:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch126
 mov ax, 1
 mov byte [isfilename], al
;-923 	}

.fatNextSearch126:
;-924 	fatfound=1;	

.fatNextSearch122:
 mov ax, 1
 mov byte [fatfound], al
;-925 }

;-926 

;-927 // 7.

;-928 int fatGetStartCluster() {//lastBytes, lastSectors

 .retnfatNextSearch:
 LEAVE
 ret
fatNextSearch_0 db "           ",0
ENDP

fatGetStartCluster: PROC
;-929 	fatfound=0;

 mov ax, 0
 mov byte [fatfound], al
;-930 	upto = &filename;

 mov ax, filename
 mov word [upto], ax
;-931 	fatNextSearch();//6 get next part of file name

 call fatNextSearch
;-932 

;-933 	if (debug) {putch(10); cputsLen(searchstr, 11); }

 mov ax, 1
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
;-934 	if (isfilename == 0) return; //todo not implemented

.fatGetStartCluster127:
 mov al, [isfilename]
 cmp al, 0
 jne .fatGetStartCluster128
 jmp .retnfatGetStartCluster
;-935 	if (fatfound) fatDirSectorSearch(fat_RootDirStartSectorL,

.fatGetStartCluster128:
 mov al, [fatfound]
 or  al, al
 je .fatGetStartCluster129
;-936 	fat_RootDirSectorsL); //2 todo: only root search

 push dword [fat_RootDirSectorsL]
 push dword [fat_RootDirStartSectorL]
 call fatDirSectorSearch
 add  sp, 8
;-937 }

.fatGetStartCluster129:
;-938 

;-939 

;-940 // 8.

;-941 int fatOpenFile() {//set handle for root or subdir

 .retnfatGetStartCluster:
 ret
ENDP

fatOpenFile: PROC
;-942 //	fat_notfound=0;

;-943 	if (debug) cputs(".fatOpenfile ");	

 mov ax, 1
 or  al, al
 je .fatOpenFile130
 push fatOpenFile_0
 call cputs
 add  sp, 2
;-944 	handle=3;//todo

.fatOpenFile130:
 mov ax, 3
 mov byte [handle], al
;-945 	

;-946 	fatGetStartCluster();// 7.

 call fatGetStartCluster
;-947 	if (fatfound == 0) { cputs(" file not found"); return; }

 mov al, [fatfound]
 cmp al, 0
 jne .fatOpenFile131
 push fatOpenFile_1
 call cputs
 add  sp, 2
 jmp .retnfatOpenFile
;-948 	lastBytesL = FileSizeL % bytes_per_clusterL;	

.fatOpenFile131:
 mov eax, [FileSizeL]
 xor edx, edx
 div dword [bytes_per_clusterL]
 mov eax, edx
 mov dword [lastBytesL], eax
;-949 	lastSectorsL = lastBytesL / sector_sizeL;

 mov eax, [lastBytesL]
 xor edx, edx
 div dword [sector_sizeL]
 mov dword [lastSectorsL], eax
;-950 	lastBytesL = lastBytesL % sector_sizeL;

 mov eax, [lastBytesL]
 xor edx, edx
 div dword [sector_sizeL]
 mov eax, edx
 mov dword [lastBytesL], eax
;-951 	

;-952 	if (FileSizeL == 0) isfilename = 0;

 mov eax, [FileSizeL]
 cmp eax, 0
 jne .fatOpenFile132
 mov ax, 0
 mov byte [isfilename], al
;-953 	else isfilename = 1;

 jmp .fatOpenFile133
.fatOpenFile132:
 mov ax, 1
 mov byte [isfilename], al
;-954 

;-955 	fatClusterAnalyse(CurCluster);// 4. OUT:CurSectorL,NextCluster

.fatOpenFile133:
 push word [CurCluster]
 call fatClusterAnalyse
 add  sp, 2
;-956 //		fatfile_sectorCount = (int) bs_clust_size;

;-957 	

;-958 //	fatfile_currentCluster = fatfile_cluster;

;-959 //	fatfile_sectorUpto = 0;

;-960 //	fatfile_byteUpto   = 0;

;-961 //	if (fat_notfound) return 1;

;-962 

;-963 	if (debug) {

 mov ax, 1
 or  al, al
 je .fatOpenFile134
;-964 		cputs(" CurCluster="); 	printunsign(CurCluster);

 push fatOpenFile_2
 call cputs
 add  sp, 2
 push word [CurCluster]
 call printunsign
 add  sp, 2
;-965 		cputs(",CurSectorL=");	printlong(CurSectorL);

 push fatOpenFile_3
 call cputs
 add  sp, 2
 push dword [CurSectorL]
 call printlong
 add  sp, 4
;-966 		cputs(",ClusterSizeL=");printlong(clust_sizeL);

 push fatOpenFile_4
 call cputs
 add  sp, 2
 push dword [clust_sizeL]
 call printlong
 add  sp, 4
;-967 		cputs(",FileSizeL="); 	printlong(FileSizeL);

 push fatOpenFile_5
 call cputs
 add  sp, 2
 push dword [FileSizeL]
 call printlong
 add  sp, 4
;-968 		cputs(",NextCluster="); printunsign(NextCluster);

 push fatOpenFile_6
 call cputs
 add  sp, 2
 push word [NextCluster]
 call printunsign
 add  sp, 2
;-969 		cputs(",lastSectorsL="); printlong(lastSectorsL);

 push fatOpenFile_7
 call cputs
 add  sp, 2
 push dword [lastSectorsL]
 call printlong
 add  sp, 4
;-970 		cputs(",lastBytesL="); 	printlong(lastBytesL);

 push fatOpenFile_8
 call cputs
 add  sp, 2
 push dword [lastBytesL]
 call printlong
 add  sp, 4
;-971 	}

;-972 }

.fatOpenFile134:
;-973 

;-974 

;-975 // 9.

;-976 int fatReadFile() {// reads 1 byte from an already open file

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
;-977 //	IN: CurCluster, FileSizeL

;-978 	readLogical(CurSectorL);

 push dword [CurSectorL]
 call readLogical
 add  sp, 4
;-979 	mdump(DiskBuf, 512);

 push 512
 lea  ax, [DiskBuf]
 push ax
 call mdump
 add  sp, 4
;-980 	

;-981 		

;-982 }

;-983 //------------------------------- OS functions --------------

;-984 //handle: 0=in, 1=out, 2=err, 255=error

;-985 // 10.

;-986 int OSOpenFile(char *name) {

 ret
ENDP

OSOpenFile: PROC
;-987 //remove drive letter, slash. uppercase and copy to filename

;-988 	unsigned int i;

;-989 	handle=255;//default=error

;Function : OSOpenFile, Number local Var: 2
; # type sign width local variables
;98 ptr sign byte name = bp+4
;99 var unsg word i = bp-2;
 ENTER  2,0
 mov ax, 255
 mov byte [handle], al
;-990 	strcpy(filename, name);

 push word [bp+4]
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-991 	toupper(filename);

 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-992 

;-993 	if (strlen(filename) == 0) return;

 lea  ax, [filename]
 push ax
 call strlen
 add  sp, 2
 cmp ax, 0
 jne .OSOpenFile135
 jmp .retnOSOpenFile
;-994 	i=strchr(filename, ':');

.OSOpenFile135:
 push 58
 lea  ax, [filename]
 push ax
 call strchr
 add  sp, 4
 mov [bp-2], ax
;-995 	if (i) {

 mov ax, [bp-2]
 or  al, al
 je .OSOpenFile136
;-996 		i++;

 inc  word[bp-2]
;-997 		strcpy(filename, i);	

 push word [bp-2]
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-998 		if (strlen(filename) == 0) return;	

 lea  ax, [filename]
 push ax
 call strlen
 add  sp, 2
 cmp ax, 0
 jne .OSOpenFile137
 jmp .retnOSOpenFile
;-999 	}	

.OSOpenFile137:
;-1000 //todo: add working directory page 18

;-1001 	if(is_delimiter(filename) == 1) filename++;

.OSOpenFile136:
 lea  ax, [filename]
 push ax
 call is_delimiter
 add  sp, 2
 cmp ax, 1
 jne .OSOpenFile138
 inc  byte[filename]
;-1002 //	if (debug) {cputs(" filename=");cputs(filename);}		

;-1003 	

;-1004 	fatOpenFile();

.OSOpenFile138:
 call fatOpenFile
;-1005 }

;-1006 

;-1007 // 11.

;-1008 int OSReadFile(char hd) {

 .retnOSOpenFile:
 LEAVE
 ret
ENDP

OSReadFile: PROC
;-1009 	

;-1010 }

;Function : OSReadFile, Number local Var: 1
; # type sign width local variables
;98 var sign byte hd = bp+4;
 ENTER  0,0
;-1011 

;-1012 //------------------------------- Init,  main ---------------

;-1013 int Init() {

 LEAVE
 ret
ENDP

Init: PROC
;-1014 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-1015 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-1016 	if (debug) cputs(" Init");

 mov ax, 1
 or  al, al
 je .Init139
 push Init_0
 call cputs
 add  sp, 2
;-1017 	if (Params()) cputs(" ** NO DRIVE PARAMS FOUND **");//no hard disk

.Init139:
 call Params
 or  al, al
 je .Init140
 push Init_1
 call cputs
 add  sp, 2
;-1018 	if (readMBR() == 0) {//0=error,1=FAT12,6=FAT16,11=FAT32	

.Init140:
 call readMBR
 cmp al, 0
 jne .Init141
;-1019 		cputs(" ** no active FAT partition found **");

 push Init_2
 call cputs
 add  sp, 2
;-1020 		return 1;

 mov ax, 1
 jmp .retnInit
;-1021 		}

;-1022 	if(getBootSector()==0) 	return 1;

.Init141:
 call getBootSector
 cmp al, 0
 jne .Init142
 mov ax, 1
 jmp .retnInit
;-1023 	if (FATInit())			return 1;

.Init142:
 call FATInit
 or  al, al
 je .Init143
 mov ax, 1
 jmp .retnInit
;-1024 	if(trueFATtype != 16) 	return 1;

.Init143:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init144
 mov ax, 1
 jmp .retnInit
;-1025 	Int13hExt();

.Init144:
 call Int13hExt
;-1026 	return 0;

 mov ax, 0
 jmp .retnInit
;-1027 }

;-1028 

;-1029 int main() {

 .retnInit:
 ret
Init_0 db " Init",0
Init_1 db " ** NO DRIVE PARAMS FOUND **",0
Init_2 db " ** no active FAT partition found **",0
ENDP

main: PROC
;-1030 	if (Init() != 0) return 1;

 call Init
 cmp al, 0
 je  .main145
 mov ax, 1
 jmp .retnmain
;-1031 	if (debug) PrintDriveParameter();

.main145:
 mov ax, 1
 or  al, al
 je .main146
 call PrintDriveParameter
;-1032 	

;-1033 	OSOpenFile("dos.com");	

.main146:
 push main_0
 call OSOpenFile
 add  sp, 2
;-1034 	if (handle == 255) cputs(" **no handle**");		

 mov al, [handle]
 cmp al, 255
 jne .main147
 push main_1
 call cputs
 add  sp, 2
;-1035 	OSOpenFile("readme.md");	

.main147:
 push main_2
 call OSOpenFile
 add  sp, 2
;-1036 	if (handle == 255) cputs(" **no handle**");	

 mov al, [handle]
 cmp al, 255
 jne .main148
 push main_3
 call cputs
 add  sp, 2
;-1037 	OSOpenFile("C:cm.bat");	

.main148:
 push main_4
 call OSOpenFile
 add  sp, 2
;-1038 	if (handle == 255) cputs(" **no handle**");	

 mov al, [handle]
 cmp al, 255
 jne .main149
 push main_5
 call cputs
 add  sp, 2
;-1039 /*	OSOpenFile("ab:/z");	

;-1040 	if (handle == 255) cputs(" **no handle**");	

;-1041 	OSOpenFile("C:");	

;-1042 	if (handle == 255) cputs(" **no handle**");	

;-1043 	OSOpenFile("/test.ba");	

;-1044 	if (handle == 255) cputs(" **no handle**");	

;-1045 */

;-1046 	if (debug) cputs(".End.");

.main149:
 mov ax, 1
 or  al, al
 je .main150
 push main_6
 call cputs
 add  sp, 2
;-1047 }

.main150:
;-1048 /*cputs(" delimiter="); printunsign(delimiter);

;-1049 cputs(", isfilename="); printunsign(isfilename);

;-1050 cputs(", upto="); printunsign(upto);

;-1051 cputs("="); cputs(upto);

;-1052 cputs(", len="); printunsign(len);

;-1053 cputs(", searchstr="); cputsLen(searchstr, len);

;-1054 */

;-1055 /*

;-1056 11	OSReadFile

;-1057 	9 fatReadFile

;-1058 	

;-1059 10	OSOpenFile drive,slash,upper,to filename

;-1060 	8 fatOpenFile

;-1061 9. fatReadFile

;-1062 	1 readLogical

;-1063 	4 fatClusterAnalyse

;-1064 8. fatOpenFile set handle, init root or subdir

;-1065 	s7 fatGetStartCluster

;-1066 	s4 fatClusterAnalyse

;-1067 7. fatGestStartCluster

;-1068 	6 fatNextSearch

;-1069 	3 fatRootSearch

;-1070 	s5 fatDirSearch

;-1071 6. fatNextSearch Upto,search,isFilename =>7

;-1072 5. fatDirSearch a directory chain for search

;-1073 	4 fatClusterAnalyse

;-1074 	2 fatDieSectorSearch

;-1075 4. fatClusterAnalyse determines sector by cluster number, next cluster

;-1076 	1 ReadLogical

;-1077 3. fatRootSearch search the root for an entry

;-1078 	2 fatDirSectorSearch

;-1079 2. fatDirSectorSearch search a block of sectors for entries,

;-1080 		get starting cluster, file size, notfound

;-1081 	1 readLogical

;-1082 2.a printDirEntry

;-1083 2.b fatDirSectorList

;-1084 	1 readLogical					

;-1085 1. readLogical

;-1086 	DiskSectorReadWrite	

;-1087 */

;-1088 /*

;-1089 bin_file=fopen("name", "rb") //binary

;-1090 int = fgetc(in_file)	     //EOF(-1)

;-1091 fputc(character, file)

;-1092 printf() = fprintf(stdout, format, parameter1) //buffered I/O

;-1093 DOS: add CR13 to LF10

;-1094 read_size=fread(data_ptr, 1, size, file) //binary read

;-1095 file_descriptor=open(name, flags, mode=0666) //unbuffered I/O

;-1096 read_size=read(file_descriptor, buffer, size) //unbufferes I/O 

;-1097 */

 .retnmain:
 ret
main_0 db "dos.com",0
main_1 db " **no handle**",0
main_2 db "readme.md",0
main_3 db " **no handle**",0
main_4 db "C:cm.bat",0
main_5 db " **no handle**",0
main_6 db ".End.",0
ENDP
