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
;-27 unsigned int  cluster;

cluster dw 0
;-28 unsigned long sector_startL;

sector_startL dd 0
;-29 unsigned long file_sizeL;

file_sizeL dd 0
;-30 

;-31 //FATInit

;-32 unsigned int  fat_FatStartSector;

fat_FatStartSector dw 0
;-33 unsigned long fat_FatStartSectorL;

fat_FatStartSectorL dd 0
;-34 unsigned int  fat_FatSectors;

fat_FatSectors dw 0
;-35 unsigned long fat_RootDirStartSectorL;

fat_RootDirStartSectorL dd 0
;-36 unsigned long fat_RootDirSectorsL;

fat_RootDirSectorsL dd 0
;-37 unsigned long fat_DataStartSectorL;

fat_DataStartSectorL dd 0
;-38 unsigned long num_tracksL;

num_tracksL dd 0
;-39 //unsigned int  fat_num_cylinders;

;-40 unsigned long Sectors_per_cylinderL;

Sectors_per_cylinderL dd 0
;-41 unsigned long DataSectors32;

DataSectors32 dd 0
;-42 unsigned long CountofClustersL;

CountofClustersL dd 0
;-43 unsigned char trueFATtype;	//12, 16, 32 from FATInit

trueFATtype db 0
;-44 unsigned int  FATtype;		//0=error,1=FAT12,6=FAT16,11=FAT32 from ReadMBR

FATtype dw 0
;-45 

;-46 //fatfile

;-47 //unsigned int  fatfile_nextCluster;

;-48 //unsigned int  fatfile_sectorCount;

;-49 //unsigned int  fatfile_lastBytes;

;-50 //unsigned int  fatfile_lastSectors;

;-51 //         int  fatfile_dir;

;-52 //unsigned int  fatfile_currentCluster;

;-53 //unsigned int  fatfile_sectorUpto;

;-54 //unsigned int  fatfile_byteUpto;

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
;-80 unsigned char bs_clust_size;// 13 sectors per cluster (1,2,4,..,128)

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
;-111 unsigned int  dir_FirstCluster;	//26 1.clu. of file data,if filesize=0 then 0

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
;90 var sign byte c = bp+4;
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
;90 ptr sign byte s = bp+4
;91 var sign byte c = bp-2;
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
;90 ptr sign byte s = bp+4
;91 var sign word len = bp+6
;92 var sign byte c = bp-2;
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
;90 var unsg byte c = bp+4;
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
;90 var unsg byte c = bp+4
;91 var unsg byte nib = bp-2;
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
;90 var unsg word i = bp+4
;91 var unsg word half = bp-2;
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
;90 var unsg word n = bp+4
;91 var unsg word e = bp-2;
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
;90 var unsg long L = bp+4;
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
;90 ptr sign byte s = bp+4
;91 var sign word c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-232     while (*s!=0) {s++; c++;}

.strlen9:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen10
 inc  word[bp+4]
 inc  word[bp-2]
;-233     return c;

 jmp .strlen9
.strlen10:
 mov ax, [bp-2]
 jmp .retnstrlen
;-234 }

;-235 int strcpy(char *s, char *t) {//new

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-236     while (*t!=0) {

;Function : strcpy, Number local Var: 2
; # type sign width local variables
;90 ptr sign byte s = bp+4
;91 ptr sign byte t = bp+6;
 ENTER  0,0
.strcpy11:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy12
;-237     	*s=*t; s++; t++; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-238     *s=0;

 jmp .strcpy11
.strcpy12:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-239     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-240 }

;-241 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-242     while(*p) {

;Function : eqstr, Number local Var: 2
; # type sign width local variables
;90 ptr sign byte p = bp+4
;91 ptr sign byte q = bp+6;
 ENTER  0,0
.eqstr13:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr14
;-243         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr15
 mov ax, 0
 jmp .retneqstr
;-244         p++;

.eqstr15:
 inc  word[bp+4]
;-245         q++;

 inc  word[bp+6]
;-246     }

;-247     if(*q) return 0;

 jmp .eqstr13
.eqstr14:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr16
 mov ax, 0
 jmp .retneqstr
;-248     return 1;

.eqstr16:
 mov ax, 1
 jmp .retneqstr
;-249 }

;-250 

;-251 int memcmp(char *s, char *t, unsigned int i) {

 .retneqstr:
 LEAVE
 ret
ENDP

memcmp: PROC
;-252     do {

;Function : memcmp, Number local Var: 3
; # type sign width local variables
;90 ptr sign byte s = bp+4
;91 ptr sign byte t = bp+6
;92 var unsg word i = bp+8;
 ENTER  0,0
.memcmp17:
;-253         if (*s < *t) return 0xFFFF;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 jge .memcmp18
 mov ax, 65535
 jmp .retnmemcmp
;-254         if (*s > *t) return 1;

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
;-255         s++; t++; i--;

.memcmp19:
 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-256     } while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcmp20
 jmp .memcmp17
.memcmp20:
;-257     return 0;

 mov ax, 0
 jmp .retnmemcmp
;-258 }

;-259 

;-260 int strcat(char *s, char *t) {

 .retnmemcmp:
 LEAVE
 ret
ENDP

strcat: PROC
;-261     while (*s != 0) s++;

;Function : strcat, Number local Var: 2
; # type sign width local variables
;90 ptr sign byte s = bp+4
;91 ptr sign byte t = bp+6;
 ENTER  0,0
.strcat21:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat22
 inc  word[bp+4]
;-262     strcpy(s, t);

 jmp .strcat21
.strcat22:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4
;-263 }

;-264 int toupper(char *s) {

 LEAVE
 ret
ENDP

toupper: PROC
;-265     while(*s) {

;Function : toupper, Number local Var: 1
; # type sign width local variables
;90 ptr sign byte s = bp+4;
 ENTER  0,0
.toupper23:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper24
;-266         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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
;-267         s++;

.toupper26:
.toupper25:
 inc  word[bp+4]
;-268     }

;-269 }

 jmp .toupper23
.toupper24:
;-270 int strchr(char *s, char c) {

 LEAVE
 ret
ENDP

strchr: PROC
;-271     while(*s) {

;Function : strchr, Number local Var: 2
; # type sign width local variables
;90 ptr sign byte s = bp+4
;91 var sign byte c = bp+6;
 ENTER  0,0
.strchr27:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .strchr28
;-272         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .strchr29
 mov ax, [bp+4]
 jmp .retnstrchr
;-273         s++;

.strchr29:
 inc  word[bp+4]
;-274     }

;-275     return 0;

 jmp .strchr27
.strchr28:
 mov ax, 0
 jmp .retnstrchr
;-276 }

;-277 int memchr(char *s, char c, unsigned int i) {

 .retnstrchr:
 LEAVE
 ret
ENDP

memchr: PROC
;-278     while(i > 0) {

;Function : memchr, Number local Var: 3
; # type sign width local variables
;90 ptr sign byte s = bp+4
;91 var sign byte c = bp+6
;92 var unsg word i = bp+8;
 ENTER  0,0
.memchr30:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr31
;-279         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr32
 mov ax, [bp+4]
 jmp .retnmemchr
;-280         s++; i--;

.memchr32:
 inc  word[bp+4]
 dec  word[bp+8]
;-281     }

;-282     return 0;

 jmp .memchr30
.memchr31:
 mov ax, 0
 jmp .retnmemchr
;-283 }

;-284 int memchr1(char *s, char c, unsigned int i) {

 .retnmemchr:
 LEAVE
 ret
ENDP

memchr1: PROC
;-285 	unsigned int pos;

;-286 	pos=1;

;Function : memchr1, Number local Var: 4
; # type sign width local variables
;90 ptr sign byte s = bp+4
;91 var sign byte c = bp+6
;92 var unsg word i = bp+8
;93 var unsg word pos = bp-2;
 ENTER  2,0
 mov ax, 1
 mov [bp-2], ax
;-287     while(i > 0) {

.memchr133:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr134
;-288         if (*s==c) return pos;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr135
 mov ax, [bp-2]
 jmp .retnmemchr1
;-289         s++; i--; pos++;

.memchr135:
 inc  word[bp+4]
 dec  word[bp+8]
 inc  word[bp-2]
;-290     }

;-291     return 0;

 jmp .memchr133
.memchr134:
 mov ax, 0
 jmp .retnmemchr1
;-292 }

;-293 int instr1(char *s, char c) {

 .retnmemchr1:
 LEAVE
 ret
ENDP

instr1: PROC
;-294     while(*s) {

;Function : instr1, Number local Var: 2
; # type sign width local variables
;90 ptr sign byte s = bp+4
;91 var sign byte c = bp+6;
 ENTER  0,0
.instr136:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .instr137
;-295         if (*s==c) return 1;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .instr138
 mov ax, 1
 jmp .retninstr1
;-296         s++;

.instr138:
 inc  word[bp+4]
;-297     }

;-298     return 0;

 jmp .instr136
.instr137:
 mov ax, 0
 jmp .retninstr1
;-299 }

;-300 

;-301 int memcpy(char *s, char *t, unsigned int i) {

 .retninstr1:
 LEAVE
 ret
ENDP

memcpy: PROC
;-302 	unsigned int r;

;-303 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;90 ptr sign byte s = bp+4
;91 ptr sign byte t = bp+6
;92 var unsg word i = bp+8
;93 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-304 	do {

.memcpy39:
;-305 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-306 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-307 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy40
 jmp .memcpy39
.memcpy40:
;-308 	ax=r;//	return r;

 mov  ax, [bp-2]
;-309 }

;-310 

;-311 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-312     unsigned char c; int i; int j; int k;

;-313     j=0;

;Function : mdump, Number local Var: 6
; # type sign width local variables
;90 ptr unsg byte adr = bp+4
;91 var unsg word len = bp+6
;92 var unsg byte c = bp-2
;93 var sign word i = bp-4
;94 var sign word j = bp-6
;95 var sign word k = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-6], ax
;-314     k=0;

 mov ax, 0
 mov [bp-8], ax
;-315     while (j < len ) {

.mdump41:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump42
;-316 	    k++;;

 inc  word[bp-8]
;-317 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump43
;-318 		    getkey();

 call getkey
;-319 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-320 		    }

;-321         putch(10);

.mdump43:
 push 10
 call putch
 add  sp, 2
;-322         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-323         putch(':');

 push 58
 call putch
 add  sp, 2
;-324         i=0;

 mov ax, 0
 mov [bp-4], ax
;-325         while (i < 16) {

.mdump44:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump45
;-326             putch(' ');

 push 32
 call putch
 add  sp, 2
;-327             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-328             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-329             adr++;

 inc  word[bp+4]
;-330             i++;

 inc  word[bp-4]
;-331             j++;

 inc  word[bp-6]
;-332             }

;-333         putch(' ');

 jmp .mdump44
.mdump45:
 push 32
 call putch
 add  sp, 2
;-334         adr -=16;

 sub  word[bp+4], 16
;-335         i=0;

 mov ax, 0
 mov [bp-4], ax
;-336         while(i < 16) {

.mdump46:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump47
;-337             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-338             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump48
 push 46
 call putch
 add  sp, 2
;-339                 else putch(c);

 jmp .mdump49
.mdump48:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-340             adr++;

.mdump49:
 inc  word[bp+4]
;-341             i++;

 inc  word[bp-4]
;-342         }

;-343     }

 jmp .mdump46
.mdump47:
;-344     getkey();

 jmp .mdump41
.mdump42:
 call getkey
;-345     putch(10);

 push 10
 call putch
 add  sp, 2
;-346 

;-347 }

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
;90 var sign byte rw = bp+4
;91 var sign byte drive = bp+6
;92 var sign byte head = bp+8
;93 var sign word cyl = bp+10
;94 var sign byte sector = bp+12
;95 var sign byte count = bp+14
;96 var sign word BufSeg = bp+16
;97 var sign word BufOfs = bp+18;
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
;90 var sign byte drive = bp+4
;91 var sign byte function = bp+6;
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
;90 var sign word drive = bp+4;
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
;-393 	if (debug) cputs(" DriveParams");

 mov ax, 1
 or  al, al
 je .Params51
 push Params_0
 call cputs
 add  sp, 2
;-394 	BIOS_Status=Int13hfunction(Drive, 8);

.Params51:
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
 je .Params52
;-396 		Int13hError();

 call Int13hError
;-397 		return 1;

 mov ax, 1
 jmp .retnParams
;-398 		}

;-399 	else {

 jmp .Params53
.Params52:
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
 jne .Params54
;-415 			cputs(" ** no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-416 			return 1;

 mov ax, 1
 jmp .retnParams
;-417 			}

;-418 	}

.Params54:
;-419 	return 0;

.Params53:
 mov ax, 0
 jmp .retnParams
;-420 }

;-421 

;-422 

;-423 int getPartitionData() {

 .retnParams:
 ret
Params_0 db " DriveParams",0
Params_1 db " ** no hard disk found",0
ENDP

getPartitionData: PROC
;-424 	unsigned int j; char c; char *p;

;-425 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;90 var unsg word j = bp-2
;91 var sign byte c = bp-4
;92 ptr sign byte p = bp-6;
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
;90 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-455 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign55
;-456 		i++;

 inc  word[bp-2]
;-457 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign56
 mov ax, 1
 jmp .retncheckBootSign
;-458 	}

.checkBootSign56:
;-459 	cputs("  **Magic number NOT found.");

.checkBootSign55:
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
checkBootSign_0 db "  **Magic number NOT found.",0
ENDP

readMBR: PROC
;-464 	int isFAT;

;-465 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;90 var sign word isFAT = bp-2;
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
 je .readMBR57
;-469 		Int13hError();

 call Int13hError
;-470 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-471 		}

;-472 	else {

 jmp .readMBR58
.readMBR57:
;-473 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .readMBR59
 mov ax, 0
 jmp .retnreadMBR
;-474 		do {

.readMBR59:
.readMBR60:
;-475 			getPartitionData();

 call getPartitionData
;-476 

;-477 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR61
;-478 				if (debug) cputs(" Boot part. found");

 mov ax, 1
 or  al, al
 je .readMBR62
 push readMBR_0
 call cputs
 add  sp, 2
;-479 				if (pt_FileSystem == 1) {

.readMBR62:
 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR63
;-480 					cputs(", FAT12 part. <32MB");

 push readMBR_1
 call cputs
 add  sp, 2
;-481 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-482 					}

;-483 				if (pt_FileSystem == 4) {

.readMBR63:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR64
;-484 					cputs(", small FAT16 part.<32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-485 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-486 					}

;-487 				if (pt_FileSystem == 6) {

.readMBR64:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR65
;-488 					if (debug) cputs(", large FAT16 part.");

 mov ax, 1
 or  al, al
 je .readMBR66
 push readMBR_3
 call cputs
 add  sp, 2
;-489 					isFAT=6;

.readMBR66:
 mov ax, 6
 mov [bp-2], ax
;-490 					}

;-491 				pt_PartNo=99;//end of loop

.readMBR65:
 mov ax, 99
 mov word [pt_PartNo], ax
;-492 			}

;-493 			pt_PartNo ++;

.readMBR61:
 inc  word[pt_PartNo]
;-494 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR67
 jmp .readMBR60
.readMBR67:
;-495 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-496 	}

;-497 }

.readMBR58:
;-498 

;-499 int getBootSector() {

 .retnreadMBR:
 LEAVE
 ret
readMBR_0 db " Boot part. found",0
readMBR_1 db ", FAT12 part. <32MB",0
readMBR_2 db ", small FAT16 part.<32MB",0
readMBR_3 db ", large FAT16 part.",0
ENDP

getBootSector: PROC
;-500 	int i;

;-501 	if (debug) cputs(" Boot sector:");

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;90 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 1
 or  al, al
 je .getBootSector68
 push getBootSector_0
 call cputs
 add  sp, 2
;-502   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

.getBootSector68:
;-503   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-504 	if (debug) printhex16(BIOS_Status);

 mov ax, 1
 or  al, al
 je .getBootSector69
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-505 	if (BIOS_ERR) {

.getBootSector69:
 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector70
;-506 		Int13hError();

 call Int13hError
;-507 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-508 		}

;-509 	else {

 jmp .getBootSector71
.getBootSector70:
;-510 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .getBootSector72
 mov ax, 0
 jmp .retngetBootSector
;-511 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector72:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-512 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector73
 push getBootSector_1
 call cputs
 add  sp, 2
;-513 		i=2;

.getBootSector73:
 mov ax, 2
 mov [bp-2], ax
;-514 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector74
 push getBootSector_2
 call cputs
 add  sp, 2
;-515 	}

.getBootSector74:
;-516 	return 1;

.getBootSector71:
 mov ax, 1
 jmp .retngetBootSector
;-517 }

;-518 

;-519 int FATInit() {

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Boot sector:",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-520 	unsigned long templong;//converting word to dword

;-521 

;-522 	clust_sizeL = (long) bs_clust_size;

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;90 var unsg long templong = bp-4;
 ENTER  4,0
 xor eax, eax
 mov al, [bs_clust_size]
 mov dword [clust_sizeL], eax
;-523 	sector_sizeL= (long) bs_sect_size;

 xor eax, eax
 mov ax, [bs_sect_size]
 mov dword [sector_sizeL], eax
;-524 

;-525 	fat_FatStartSector = bs_res_sects;

 mov ax, [bs_res_sects]
 mov word [fat_FatStartSector], ax
;-526 	fat_FatStartSectorL= (long) fat_FatStartSector; 

 xor eax, eax
 mov ax, [fat_FatStartSector]
 mov dword [fat_FatStartSectorL], eax
;-527 	fat_FatSectors = bs_fat_size;

 mov ax, [bs_fat_size]
 mov word [fat_FatSectors], ax
;-528 	if (bs_num_fats == 2) fat_FatSectors=fat_FatSectors+fat_FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .FATInit75
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-529 

;-530 	fat_RootDirStartSectorL = (long)fat_FatStartSector + fat_FatSectors;

.FATInit75:
 xor eax, eax
 mov ax, [fat_FatStartSector]
 add ax, [fat_FatSectors]
 mov dword [fat_RootDirStartSectorL], eax
;-531 	

;-532 	fat_RootDirSectorsL = (long) bs_root_entr >> 4;//  ./. 16

 xor eax, eax
 mov ax, [bs_root_entr]
 shr ax, 4
 mov dword [fat_RootDirSectorsL], eax
;-533 		

;-534 	fat_DataStartSectorL = fat_RootDirStartSectorL + fat_RootDirSectorsL;

 mov eax, [fat_RootDirStartSectorL]
 add eax, [fat_RootDirSectorsL]
 mov dword [fat_DataStartSectorL], eax
;-535 

;-536 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .FATInit76
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-537 	DataSectors32=bs_tot_sect32 - fat_DataStartSectorL;

.FATInit76:
 mov eax, [bs_tot_sect32]
 sub eax, [fat_DataStartSectorL]
 mov dword [DataSectors32], eax
;-538 

;-539 	CountofClustersL=DataSectors32 / clust_sizeL;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [clust_sizeL]
 mov dword [CountofClustersL], eax
;-540 

;-541 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-542 	num_tracksL = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [num_tracksL], eax
;-543 

;-544 //	templong = (long) bs_num_heads;

;-545 //	fat_num_cylinders = num_tracksL / templong;//w=d/w

;-546 

;-547 	Sectors_per_cylinderL = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinderL], eax
;-548 	asm mov [Sectors_per_cylinderL + 2], dx;store high word

 mov [Sectors_per_cylinderL + 2], dx;store high word
;-549 

;-550 	templong = (long) 65525;

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-551 	if (CountofClustersL > templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jle .FATInit77
;-552 		trueFATtype=32;

 mov ax, 32
 mov byte [trueFATtype], al
;-553 		cputs(" FAT32 NOT supported");

 push FATInit_0
 call cputs
 add  sp, 2
;-554 		return 1;

 mov ax, 1
 jmp .retnFATInit
;-555 		}

;-556 	templong= (long) 4086;

.FATInit77:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-557 	if (CountofClustersL < templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jge .FATInit78
;-558 		trueFATtype=12;

 mov ax, 12
 mov byte [trueFATtype], al
;-559 		cputs(" FAT12");

 push FATInit_1
 call cputs
 add  sp, 2
;-560 		return 0;

 mov ax, 0
 jmp .retnFATInit
;-561 		}

;-562 	trueFATtype=16;

.FATInit78:
 mov ax, 16
 mov byte [trueFATtype], al
;-563 	if (debug) cputs(" FAT16");

 mov ax, 1
 or  al, al
 je .FATInit79
 push FATInit_2
 call cputs
 add  sp, 2
;-564 	return 0;

.FATInit79:
 mov ax, 0
 jmp .retnFATInit
;-565 }

;-566 

;-567 int Int13hExt() {

 .retnFATInit:
 LEAVE
 ret
FATInit_0 db " FAT32 NOT supported",0
FATInit_1 db " FAT12",0
FATInit_2 db " FAT16",0
ENDP

Int13hExt: PROC
;-568 	bx=0x55AA;

 mov  bx, 21930
;-569 	BIOS_Status=Int13hfunction(Drive, 0x41);

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-570 	asm mov [vAX], ax;

 mov [vAX], ax;
;-571 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-572 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported
;-573 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt80
;-574 		cputs(" Ext. NOT present");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-575 		Int13hError();

 call Int13hError
;-576 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-577 		}

;-578 	else {

 jmp .Int13hExt81
.Int13hExt80:
;-579 	if (debug) cputs(",Int13h Ext.");

 mov ax, 1
 or  al, al
 je .Int13hExt82
 push Int13hExt_1
 call cputs
 add  sp, 2
;-580 		}

.Int13hExt82:
;-581 	return 0;

.Int13hExt81:
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
;90 var unsg long Lo = bp-4;
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
;90 ptr sign byte s = bp+4;
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
;90 var unsg long SectorL = bp+4
;91 var unsg word track = bp-2
;92 var unsg word head = bp-4
;93 var unsg word sect = bp-6;
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
;90 var sign word EntryNr = bp+4
;91 var unsg word j = bp-2;
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
 je .printDirEntry83
 push printDirEntry_1
 call cputs
 add  sp, 2
;-689 	if (dir_Attrib &  2) cputs(" hid");

.printDirEntry83:
 mov al, [dir_Attrib]
 and al, 2
 or  al, al
 je .printDirEntry84
 push printDirEntry_2
 call cputs
 add  sp, 2
;-690 	if (dir_Attrib &  4) cputs(" sys");

.printDirEntry84:
 mov al, [dir_Attrib]
 and al, 4
 or  al, al
 je .printDirEntry85
 push printDirEntry_3
 call cputs
 add  sp, 2
;-691 	if (dir_Attrib &  8) cputs(" vol");		

.printDirEntry85:
 mov al, [dir_Attrib]
 and al, 8
 or  al, al
 je .printDirEntry86
 push printDirEntry_4
 call cputs
 add  sp, 2
;-692 	if (dir_Attrib & 16) cputs(" dir");

.printDirEntry86:
 mov al, [dir_Attrib]
 and al, 16
 or  al, al
 je .printDirEntry87
 push printDirEntry_5
 call cputs
 add  sp, 2
;-693 	if (dir_Attrib & 32) cputs(" arc");

.printDirEntry87:
 mov al, [dir_Attrib]
 and al, 32
 or  al, al
 je .printDirEntry88
 push printDirEntry_6
 call cputs
 add  sp, 2
;-694 	if (dir_Attrib == 0) cputs("    ");

.printDirEntry88:
 mov al, [dir_Attrib]
 cmp al, 0
 jne .printDirEntry89
 push printDirEntry_7
 call cputs
 add  sp, 2
;-695 	

;-696 	putch(' ');

.printDirEntry89:
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
 jge .printDirEntry90
 push 32
 call putch
 add  sp, 2
;-699 	printunsign(j);

.printDirEntry90:
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
 jge .printDirEntry91
 push 48
 call putch
 add  sp, 2
;-705 	printunsign(j);

.printDirEntry91:
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
 jge .printDirEntry92
 push 32
 call putch
 add  sp, 2
;-716 	printunsign(j);

.printDirEntry92:
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
 jge .printDirEntry93
 push 48
 call putch
 add  sp, 2
;-722 	printunsign(j);

.printDirEntry93:
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
 jge .printDirEntry94
 push 48
 call putch
 add  sp, 2
;-728 	printunsign(j);

.printDirEntry94:
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
;90 var unsg long startSector = bp+4
;91 var unsg long numsectors = bp+8
;92 ptr sign byte p = bp-2
;93 var unsg word EndDiskBuf = bp-4
;94 var sign byte isHide = bp-6
;95 var unsg word EntryNr = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-8], ax
;-745 	do {

.fatDirSectorList95:
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

.fatDirSectorList96:
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
 jne .fatDirSectorList97
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

.fatDirSectorList97:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 229
 jne .fatDirSectorList98
 inc  byte[bp-6]
;-769 			if (*p <=   31) isHide++;//part of LFN

.fatDirSectorList98:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 31
 jg  .fatDirSectorList99
 inc  byte[bp-6]
;-770 			if (dir_Attrib ==    15) isHide++;//LFN start

.fatDirSectorList99:
 mov al, [dir_Attrib]
 cmp al, 15
 jne .fatDirSectorList100
 inc  byte[bp-6]
;-771 					

;-772 			if (isHide == 0) printDirEntry(EntryNr);

.fatDirSectorList100:
 mov al, [bp-6]
 cmp al, 0
 jne .fatDirSectorList101
 push word [bp-8]
 call printDirEntry
 add  sp, 2
;-773 			p+=32;//get next entry

.fatDirSectorList101:
 add  word[bp-2], 32
;-774 			EntryNr++;

 inc  word[bp-8]
;-775 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorList102
 jmp .fatDirSectorList96
.fatDirSectorList102:
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
 jle .fatDirSectorList103
 jmp .fatDirSectorList95
.fatDirSectorList103:
;-780 	cluster=0;//not found but not end

 mov ax, 0
 mov word [cluster], ax
;-781 }

;-782 

;-783 // 2.

;-784 int fatDirSectorSearch(unsigned long startSector, unsigned long numsectors) {

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
;90 var unsg long startSector = bp+4
;91 var unsg long numsectors = bp+8
;92 ptr sign byte p = bp-2
;93 var unsg word EndDiskBuf = bp-4;
 ENTER  4,0
 mov ax, 0
 mov byte [fatfound], al
;-789 	do {

.fatDirSectorSearch104:
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

.fatDirSectorSearch105:
;-794 			if (memcmp(p, searchstr, 11) == 0) {//found file name

 push 11
 lea  ax, [searchstr]
 push ax
 push word [bp-2]
 call memcmp
 add  sp, 6
 cmp ax, 0
 jne .fatDirSectorSearch106
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
;-798 				cluster   = dir_FirstCluster;

 mov ax, [dir_FirstCluster]
 mov word [cluster], ax
;-799 				file_sizeL  = dir_FileSize;

 mov eax, [dir_FileSize]
 mov dword [file_sizeL], eax
;-800 				fatfound=1;

 mov ax, 1
 mov byte [fatfound], al
;-801 			}

;-802 			if (*p == 0) return; //only empty entries following

.fatDirSectorSearch106:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorSearch107
 jmp .retnfatDirSectorSearch
;-803 			p+=32;//get next entry

.fatDirSectorSearch107:
 add  word[bp-2], 32
;-804 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorSearch108
 jmp .fatDirSectorSearch105
.fatDirSectorSearch108:
;-805 		startSector++;		

 inc  dword[bp+4]
;-806 		numsectors--;

 dec  dword[bp+8]
;-807 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorSearch109
 jmp .fatDirSectorSearch104
.fatDirSectorSearch109:
;-808 	cluster=0;//not found but not end

 mov ax, 0
 mov word [cluster], ax
;-809 }

;-810 

;-811 

;-812 int is_delimiter(char *s) {

 .retnfatDirSectorSearch:
 LEAVE
 ret
ENDP

is_delimiter: PROC
;-813 	if (*s == '/' ) return 1;

;Function : is_delimiter, Number local Var: 1
; # type sign width local variables
;90 ptr sign byte s = bp+4;
 ENTER  0,0
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 47
 jne .is_delimiter110
 mov ax, 1
 jmp .retnis_delimiter
;-814 	if (*s == '\\') return 1;

.is_delimiter110:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 92
 jne .is_delimiter111
 mov ax, 1
 jmp .retnis_delimiter
;-815 	if (*s ==    0) return 2;

.is_delimiter111:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .is_delimiter112
 mov ax, 2
 jmp .retnis_delimiter
;-816 	if (*s ==  '.') return 3;

.is_delimiter112:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 46
 jne .is_delimiter113
 mov ax, 3
 jmp .retnis_delimiter
;-817 	return 0;

.is_delimiter113:
 mov ax, 0
 jmp .retnis_delimiter
;-818 }

;-819 

;-820 // 4.

;-821 int Cluster2Sector(unsigned int clust) {

 .retnis_delimiter:
 LEAVE
 ret
ENDP

Cluster2Sector: PROC
;-822 //OUT: sector_startL

;-823 	sector_startL = (long) clust - 2;

;Function : Cluster2Sector, Number local Var: 1
; # type sign width local variables
;90 var unsg word clust = bp+4;
 ENTER  0,0
 xor eax, eax
 mov ax, [bp+4]
 sub ax, 2
 mov dword [sector_startL], eax
;-824 	sector_startL = sector_startL * clust_sizeL;

 mov eax, [sector_startL]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul dword [clust_sizeL]
 mov dword [sector_startL], eax
;-825 	sector_startL = sector_startL + fat_DataStartSectorL;

 mov eax, [sector_startL]
 add eax, [fat_DataStartSectorL]
 mov dword [sector_startL], eax
;-826 }

;-827 	

;-828 // 6.

;-829 int fatNextSearch() {//get next part of filename to do a search

 LEAVE
 ret
ENDP

fatNextSearch: PROC
;-830 //	IN:  upto: points to start of search in filename 

;-831 //	OUT: upto: points to search for next time

;-832 //	OUT: searchstr: part of filename in DIR-format with blanks (11bytes)

;-833 //	OUT: isfilename: 0=part of directory, 1=filename

;-834 //	OUT: fatfound

;-835 	char *searchstrp;

;-836 	char *p; 

;-837 	unsigned int  len;

;-838 	unsigned int delimiter;

;-839 	delimiter=is_delimiter(upto);

;Function : fatNextSearch, Number local Var: 4
; # type sign width local variables
;90 ptr sign byte searchstrp = bp-2
;91 ptr sign byte p = bp-4
;92 var unsg word len = bp-6
;93 var unsg word delimiter = bp-8;
 ENTER  8,0
 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-840 	if (delimiter == 1) upto++;

 mov ax, [bp-8]
 cmp ax, 1
 jne .fatNextSearch114
 inc  word[upto]
;-841 	if (delimiter == 2) return; 

.fatNextSearch114:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch115
 jmp .retnfatNextSearch
;-842 

;-843 	strcpy(&searchstr, "           ");//11 blank padded

.fatNextSearch115:
 push fatNextSearch_0
 lea  ax, [searchstr]
 push ax
 call strcpy
 add  sp, 4
;-844 	searchstrp = &searchstr;//clear searchstr

 mov ax, searchstr
 mov [bp-2], ax
;-845 	len=0;

 mov ax, 0
 mov [bp-6], ax
;-846 	delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-847 	while (delimiter == 0) { //no slash, zero, point

.fatNextSearch116:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch117
;-848 		*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-849 		searchstrp++;

 inc  word[bp-2]
;-850 		upto++;	

 inc  word[upto]
;-851 		len++;

 inc  word[bp-6]
;-852 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-853 	} 

;-854 	if (len > 8) return;

 jmp .fatNextSearch116
.fatNextSearch117:
 mov ax, [bp-6]
 cmp ax, 8
 jle .fatNextSearch118
 jmp .retnfatNextSearch
;-855 	isfilename=0;//todo: default directory, not yet implemented

.fatNextSearch118:
 mov ax, 0
 mov byte [isfilename], al
;-856 	if (delimiter == 2) isfilename=1;//last name is always a file name

 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch119
 mov ax, 1
 mov byte [isfilename], al
;-857 	if (delimiter == 3) {//remove dot in name		

.fatNextSearch119:
 mov ax, [bp-8]
 cmp ax, 3
 jne .fatNextSearch120
;-858 		searchstrp = &searchstr;

 mov ax, searchstr
 mov [bp-2], ax
;-859 		searchstrp += 8;//start extension		

 add  word[bp-2], 8
;-860 		len=0;

 mov ax, 0
 mov [bp-6], ax
;-861 		upto++;

 inc  word[upto]
;-862 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-863 		while (delimiter == 0) { //no slash, zero, point

.fatNextSearch121:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch122
;-864 			*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-865 			searchstrp++;

 inc  word[bp-2]
;-866 			upto++;	

 inc  word[upto]
;-867 			len++;

 inc  word[bp-6]
;-868 			delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-869 		} 

;-870 		if (len > 3) return;

 jmp .fatNextSearch121
.fatNextSearch122:
 mov ax, [bp-6]
 cmp ax, 3
 jle .fatNextSearch123
 jmp .retnfatNextSearch
;-871 		if (delimiter == 2) isfilename=1;//last name is always a file name

.fatNextSearch123:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch124
 mov ax, 1
 mov byte [isfilename], al
;-872 	}

.fatNextSearch124:
;-873 	fatfound=1;	

.fatNextSearch120:
 mov ax, 1
 mov byte [fatfound], al
;-874 }

;-875 

;-876 // 7.

;-877 int fatGetStartCluster() {//lastBytes, lastSectors

 .retnfatNextSearch:
 LEAVE
 ret
fatNextSearch_0 db "           ",0
ENDP

fatGetStartCluster: PROC
;-878 	fatfound=0;

 mov ax, 0
 mov byte [fatfound], al
;-879 	toupper(filename);

 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-880 	upto = &filename;

 mov ax, filename
 mov word [upto], ax
;-881 	fatNextSearch();

 call fatNextSearch
;-882 

;-883 	if (debug) {putch(10); cputsLen(searchstr, 11);

 mov ax, 1
 or  al, al
 je .fatGetStartCluster125
 push 10
 call putch
 add  sp, 2
 push 11
 lea  ax, [searchstr]
 push ax
 call cputsLen
 add  sp, 4
;-884 //		cputs(",FName="); printunsign(isfilename); 

;-885 		}

;-886 	if (isfilename == 0) return; //todo not implemented

.fatGetStartCluster125:
 mov al, [isfilename]
 cmp al, 0
 jne .fatGetStartCluster126
 jmp .retnfatGetStartCluster
;-887 	if (fatfound) 	fatDirSectorSearch(fat_RootDirStartSectorL, fat_RootDirSectorsL); 

.fatGetStartCluster126:
 mov al, [fatfound]
 or  al, al
 je .fatGetStartCluster127
 push dword [fat_RootDirSectorsL]
 push dword [fat_RootDirStartSectorL]
 call fatDirSectorSearch
 add  sp, 8
;-888 }

.fatGetStartCluster127:
;-889 

;-890 // 10.

;-891 int fatReadFile() {

 .retnfatGetStartCluster:
 ret
ENDP

fatReadFile: PROC
;-892 //	IN: cluster, file_sizeL

;-893 	fatGetStartCluster();

 call fatGetStartCluster
;-894 	if (fatfound == 0) return;

 mov al, [fatfound]
 cmp al, 0
 jne .fatReadFile128
 jmp .retnfatReadFile
;-895 cputs(",1.Cl="); printunsign(cluster);

.fatReadFile128:
 push fatReadFile_0
 call cputs
 add  sp, 2
 push word [cluster]
 call printunsign
 add  sp, 2
;-896 	Cluster2Sector(cluster);

 push word [cluster]
 call Cluster2Sector
 add  sp, 2
;-897 cputs(",secStartL="); printlong(sector_startL);

 push fatReadFile_1
 call cputs
 add  sp, 2
 push dword [sector_startL]
 call printlong
 add  sp, 4
;-898 cputs(",ClSz="); printlong(clust_sizeL);

 push fatReadFile_2
 call cputs
 add  sp, 2
 push dword [clust_sizeL]
 call printlong
 add  sp, 4
;-899 cputs(",Size="); printlong(file_sizeL);

 push fatReadFile_3
 call cputs
 add  sp, 2
 push dword [file_sizeL]
 call printlong
 add  sp, 4
;-900 	readLogical(sector_startL);

 push dword [sector_startL]
 call readLogical
 add  sp, 4
;-901 	mdump(DiskBuf, 512);

 push 512
 lea  ax, [DiskBuf]
 push ax
 call mdump
 add  sp, 4
;-902 	

;-903 		

;-904 }

;-905 //------------------------------- Init,  main ---------------

;-906 int Init() {

 .retnfatReadFile:
 ret
fatReadFile_0 db ",1.Cl=",0
fatReadFile_1 db ",secStartL=",0
fatReadFile_2 db ",ClSz=",0
fatReadFile_3 db ",Size=",0
ENDP

Init: PROC
;-907 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-908 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-909 	if (debug) cputs(" Init");

 mov ax, 1
 or  al, al
 je .Init129
 push Init_0
 call cputs
 add  sp, 2
;-910 	if (Params()) cputs(" ** NO DRIVE PARAMS FOUND **");//no hard disk

.Init129:
 call Params
 or  al, al
 je .Init130
 push Init_1
 call cputs
 add  sp, 2
;-911 	FATtype=readMBR();//0=error,1=FAT12,6=FAT16,11=FAT32	

.Init130:
 call readMBR
 mov word [FATtype], ax
;-912 	if (FATtype == 0) {

 mov ax, [FATtype]
 cmp ax, 0
 jne .Init131
;-913 		cputs(" ** no active FAT partition found **");

 push Init_2
 call cputs
 add  sp, 2
;-914 		return 1;

 mov ax, 1
 jmp .retnInit
;-915 		}

;-916 	if(getBootSector()==0) 	return 1;

.Init131:
 call getBootSector
 cmp ax, 0
 jne .Init132
 mov ax, 1
 jmp .retnInit
;-917 	if (FATInit())			return 1;

.Init132:
 call FATInit
 or  al, al
 je .Init133
 mov ax, 1
 jmp .retnInit
;-918 	if(trueFATtype != 16) 	return 1;

.Init133:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init134
 mov ax, 1
 jmp .retnInit
;-919 	Int13hExt();

.Init134:
 call Int13hExt
;-920 	return 0;

 mov ax, 0
 jmp .retnInit
;-921 }

;-922 int main() {

 .retnInit:
 ret
Init_0 db " Init",0
Init_1 db " ** NO DRIVE PARAMS FOUND **",0
Init_2 db " ** no active FAT partition found **",0
ENDP

main: PROC
;-923 	if (Init() != 0) return 1;

 call Init
 cmp al, 0
 je  .main135
 mov ax, 1
 jmp .retnmain
;-924 //	if (debug) PrintDriveParameter();

;-925 	

;-926 	strcpy(&filename, "dos.com");	fatReadFile();	

.main135:
 push main_0
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
 call fatReadFile
;-927 	strcpy(&filename, "readme.md");	fatReadFile();	

 push main_1
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
 call fatReadFile
;-928 	strcpy(&filename, "cm.bat");	fatReadFile();	

 push main_2
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
 call fatReadFile
;-929 	strcpy(&filename, "test1.c");	fatReadFile();

 push main_3
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
 call fatReadFile
;-930 	if (debug) cputs(" End.");

 mov ax, 1
 or  al, al
 je .main136
 push main_4
 call cputs
 add  sp, 2
;-931 }

.main136:
 .retnmain:
 ret
main_0 db "dos.com",0
main_1 db "readme.md",0
main_2 db "cm.bat",0
main_3 db "test1.c",0
main_4 db " End.",0
ENDP
