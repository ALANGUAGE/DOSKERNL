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
;-25 char isfilename;//is filename or part of directory?

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

;-31 //unsigned char FileIsOpen;

;-32 unsigned int  BegCluster;		//first cluster of file

BegCluster dw 0
;-33 unsigned int  CurCluster;		//current cluster

CurCluster dw 0
;-34 unsigned int  NextCluster;

NextCluster dw 0
;-35 unsigned long CurSectorL;		//current sector in current cluster

CurSectorL dd 0
;-36 unsigned long FileSizeL;

FileSizeL dd 0
;-37 //unsigned int  CurPosition;	//current byte location in cur sector

;-38 //unsigned long SeekL;			//current byte location in file

;-39 //	end array of handles of every open file

;-40 

;-41 //FATInit

;-42 unsigned int  fat_FatStartSector;

fat_FatStartSector dw 0
;-43 unsigned long fat_FatStartSectorL;

fat_FatStartSectorL dd 0
;-44 unsigned int  fat_FatSectors;

fat_FatSectors dw 0
;-45 unsigned long fat_RootDirStartSectorL;

fat_RootDirStartSectorL dd 0
;-46 unsigned long fat_RootDirSectorsL;

fat_RootDirSectorsL dd 0
;-47 unsigned long fat_DataStartSectorL;

fat_DataStartSectorL dd 0
;-48 unsigned long num_tracksL;

num_tracksL dd 0
;-49 //unsigned int  fat_num_cylinders;

;-50 unsigned long Sectors_per_cylinderL;

Sectors_per_cylinderL dd 0
;-51 unsigned long DataSectors32;

DataSectors32 dd 0
;-52 unsigned long CountofClustersL;

CountofClustersL dd 0
;-53 unsigned char trueFATtype;	//12, 16, 32 from FATInit

trueFATtype db 0
;-54 //unsigned int  FATtype;//0=error,1=FAT12,6=FAT16,11=FAT32 from ReadMBR

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
;-80 unsigned char bs_clust_size;// 13 sectors per CurCluster (1,2,4,..,128)

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
;-111 unsigned int  dir_FirstCluster;	//26 1.clu. of file data,if filesize=0 then0

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
;93 var sign byte c = bp+4;
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
;93 ptr sign byte s = bp+4
;94 var sign byte c = bp-2;
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
;93 ptr sign byte s = bp+4
;94 var sign word len = bp+6
;95 var sign byte c = bp-2;
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
;93 var unsg byte c = bp+4;
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
;93 var unsg byte c = bp+4
;94 var unsg byte nib = bp-2;
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
;93 var unsg word i = bp+4
;94 var unsg word half = bp-2;
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
;93 var unsg word n = bp+4
;94 var unsg word e = bp-2;
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
;93 var unsg long L = bp+4;
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
;93 ptr sign byte s = bp+4
;94 var sign word c = bp-2;
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
;93 ptr sign byte s = bp+4
;94 ptr sign byte t = bp+6;
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
;93 ptr sign byte p = bp+4
;94 ptr sign byte q = bp+6;
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
;93 ptr sign byte s = bp+4
;94 ptr sign byte t = bp+6
;95 var unsg word i = bp+8;
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
;93 ptr sign byte s = bp+4
;94 ptr sign byte t = bp+6;
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
;93 ptr sign byte s = bp+4;
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
;93 ptr sign byte s = bp+4
;94 var sign byte c = bp+6;
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
;93 ptr sign byte s = bp+4
;94 var sign byte c = bp+6
;95 var unsg word i = bp+8;
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
;93 ptr sign byte s = bp+4
;94 var sign byte c = bp+6
;95 var unsg word i = bp+8
;96 var unsg word pos = bp-2;
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
;93 ptr sign byte s = bp+4
;94 var sign byte c = bp+6;
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
;93 ptr sign byte s = bp+4
;94 ptr sign byte t = bp+6
;95 var unsg word i = bp+8
;96 var unsg word r = bp-2;
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
;-312     unsigned char c; unsigned char chal; int i; int j; int k;

;-313     j=0;

;Function : mdump, Number local Var: 7
; # type sign width local variables
;93 ptr unsg byte adr = bp+4
;94 var unsg word len = bp+6
;95 var unsg byte c = bp-2
;96 var unsg byte chal = bp-4
;97 var sign word i = bp-6
;98 var sign word j = bp-8
;99 var sign word k = bp-10;
 ENTER  10,0
 mov ax, 0
 mov [bp-8], ax
;-314     k=0;

 mov ax, 0
 mov [bp-10], ax
;-315     while (j < len ) {

.mdump41:
 mov ax, [bp-8]
 cmp ax, [bp+6]
 jge .mdump42
;-316 	    k++;;

 inc  word[bp-10]
;-317 	    if (k > 8) {

 mov ax, [bp-10]
 cmp ax, 8
 jle .mdump43
;-318 		    chal = getkey();//remove scan code

 call getkey
 mov [bp-4], al
;-319 		    if (chal =='q') return;

 mov al, [bp-4]
 cmp al, 113
 jne .mdump44
 jmp .retnmdump
;-320 		    k=1;

.mdump44:
 mov ax, 1
 mov [bp-10], ax
;-321 		    }

;-322         putch(10);

.mdump43:
 push 10
 call putch
 add  sp, 2
;-323         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-324         putch(':');

 push 58
 call putch
 add  sp, 2
;-325         i=0;

 mov ax, 0
 mov [bp-6], ax
;-326         while (i < 16) {

.mdump45:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump46
;-327             putch(' ');

 push 32
 call putch
 add  sp, 2
;-328             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-329             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-330             adr++;

 inc  word[bp+4]
;-331             i++;

 inc  word[bp-6]
;-332             j++;

 inc  word[bp-8]
;-333             }

;-334         putch(' ');

 jmp .mdump45
.mdump46:
 push 32
 call putch
 add  sp, 2
;-335         adr -=16;

 sub  word[bp+4], 16
;-336         i=0;

 mov ax, 0
 mov [bp-6], ax
;-337         while(i < 16) {

.mdump47:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump48
;-338             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-339             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump49
 push 46
 call putch
 add  sp, 2
;-340                 else putch(c);

 jmp .mdump50
.mdump49:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-341             adr++;

.mdump50:
 inc  word[bp+4]
;-342             i++;

 inc  word[bp-6]
;-343         }

;-344     }

 jmp .mdump47
.mdump48:
;-345     getkey();

 jmp .mdump41
.mdump42:
 call getkey
;-346     putch(10);

 push 10
 call putch
 add  sp, 2
;-347 

;-348 }

;-349 

;-350 //--------------------------------  disk IO  -------------------

;-351 

;-352 int DiskSectorReadWrite(char rw, char drive, char head, int cyl,

 .retnmdump:
 LEAVE
 ret
ENDP

DiskSectorReadWrite: PROC
;-353 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-354 	BIOS_ERR=0;

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;93 var sign byte rw = bp+4
;94 var sign byte drive = bp+6
;95 var sign byte head = bp+8
;96 var sign word cyl = bp+10
;97 var sign byte sector = bp+12
;98 var sign byte count = bp+14
;99 var sign word BufSeg = bp+16
;100 var sign word BufOfs = bp+18;
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
;93 var sign byte drive = bp+4
;94 var sign byte function = bp+6;
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
;93 var sign word drive = bp+4;
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
 je .Status51
 call Int13hError
;-390 	printhex16(BIOS_Status);

.Status51:
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
;-394 	if (debug) cputs(" DriveParams");

 mov ax, 1
 or  al, al
 je .Params52
 push Params_0
 call cputs
 add  sp, 2
;-395 	BIOS_Status=Int13hfunction(Drive, 8);

.Params52:
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
 je .Params53
;-397 		Int13hError();

 call Int13hError
;-398 		return 1;

 mov ax, 1
 jmp .retnParams
;-399 		}

;-400 	else {

 jmp .Params54
.Params53:
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
 jne .Params55
;-416 			cputs(" ** no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-417 			return 1;

 mov ax, 1
 jmp .retnParams
;-418 			}

;-419 	}

.Params55:
;-420 	return 0;

.Params54:
 mov ax, 0
 jmp .retnParams
;-421 }

;-422 

;-423 

;-424 int getPartitionData() {

 .retnParams:
 ret
Params_0 db " DriveParams",0
Params_1 db " ** no hard disk found",0
ENDP

getPartitionData: PROC
;-425 	unsigned int j; char c; char *p;

;-426 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;93 var unsg word j = bp-2
;94 var sign byte c = bp-4
;95 ptr sign byte p = bp-6;
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
;93 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-456 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign56
;-457 		i++;

 inc  word[bp-2]
;-458 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign57
 mov ax, 1
 jmp .retncheckBootSign
;-459 	}

.checkBootSign57:
;-460 	cputs("  **Magic number NOT found.");

.checkBootSign56:
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
checkBootSign_0 db "  **Magic number NOT found.",0
ENDP

readMBR: PROC
;-465 	int isFAT;

;-466 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;93 var sign word isFAT = bp-2;
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
 je .readMBR58
;-470 		Int13hError();

 call Int13hError
;-471 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-472 		}

;-473 	else {

 jmp .readMBR59
.readMBR58:
;-474 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .readMBR60
 mov ax, 0
 jmp .retnreadMBR
;-475 		do {

.readMBR60:
.readMBR61:
;-476 			getPartitionData();

 call getPartitionData
;-477 

;-478 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR62
;-479 				if (debug) cputs(" Boot part. found");

 mov ax, 1
 or  al, al
 je .readMBR63
 push readMBR_0
 call cputs
 add  sp, 2
;-480 				if (pt_FileSystem == 1) {

.readMBR63:
 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR64
;-481 					cputs(", FAT12 part. <32MB");

 push readMBR_1
 call cputs
 add  sp, 2
;-482 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-483 					}

;-484 				if (pt_FileSystem == 4) {

.readMBR64:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR65
;-485 					cputs(", small FAT16 part.<32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-486 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-487 					}

;-488 				if (pt_FileSystem == 6) {

.readMBR65:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR66
;-489 					if (debug) cputs(", large FAT16 part.");

 mov ax, 1
 or  al, al
 je .readMBR67
 push readMBR_3
 call cputs
 add  sp, 2
;-490 					isFAT=6;

.readMBR67:
 mov ax, 6
 mov [bp-2], ax
;-491 					}

;-492 				pt_PartNo=99;//end of loop

.readMBR66:
 mov ax, 99
 mov word [pt_PartNo], ax
;-493 			}

;-494 			pt_PartNo ++;

.readMBR62:
 inc  word[pt_PartNo]
;-495 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR68
 jmp .readMBR61
.readMBR68:
;-496 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-497 	}

;-498 }

.readMBR59:
;-499 

;-500 int getBootSector() {

 .retnreadMBR:
 LEAVE
 ret
readMBR_0 db " Boot part. found",0
readMBR_1 db ", FAT12 part. <32MB",0
readMBR_2 db ", small FAT16 part.<32MB",0
readMBR_3 db ", large FAT16 part.",0
ENDP

getBootSector: PROC
;-501 	int i;

;-502 	if (debug) cputs(" Boot sector:");

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;93 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 1
 or  al, al
 je .getBootSector69
 push getBootSector_0
 call cputs
 add  sp, 2
;-503   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

.getBootSector69:
;-504   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-505 	if (debug) printhex16(BIOS_Status);

 mov ax, 1
 or  al, al
 je .getBootSector70
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-506 	if (BIOS_ERR) {

.getBootSector70:
 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector71
;-507 		Int13hError();

 call Int13hError
;-508 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-509 		}

;-510 	else {

 jmp .getBootSector72
.getBootSector71:
;-511 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .getBootSector73
 mov ax, 0
 jmp .retngetBootSector
;-512 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector73:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-513 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector74
 push getBootSector_1
 call cputs
 add  sp, 2
;-514 		i=2;

.getBootSector74:
 mov ax, 2
 mov [bp-2], ax
;-515 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector75
 push getBootSector_2
 call cputs
 add  sp, 2
;-516 	}

.getBootSector75:
;-517 	return 1;

.getBootSector72:
 mov ax, 1
 jmp .retngetBootSector
;-518 }

;-519 

;-520 int FATInit() {

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Boot sector:",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-521 	unsigned long templong;//converting word to dword

;-522 

;-523 	clust_sizeL = (long) bs_clust_size;

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;93 var unsg long templong = bp-4;
 ENTER  4,0
 xor eax, eax
 mov al, [bs_clust_size]
 mov dword [clust_sizeL], eax
;-524 	sector_sizeL= (long) bs_sect_size;

 xor eax, eax
 mov ax, [bs_sect_size]
 mov dword [sector_sizeL], eax
;-525 

;-526 	fat_FatStartSector = bs_res_sects;

 mov ax, [bs_res_sects]
 mov word [fat_FatStartSector], ax
;-527 	fat_FatStartSectorL= (long) fat_FatStartSector; 

 xor eax, eax
 mov ax, [fat_FatStartSector]
 mov dword [fat_FatStartSectorL], eax
;-528 	fat_FatSectors = bs_fat_size;

 mov ax, [bs_fat_size]
 mov word [fat_FatSectors], ax
;-529 	if (bs_num_fats == 2) fat_FatSectors=fat_FatSectors+fat_FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .FATInit76
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-530 

;-531 	fat_RootDirStartSectorL = (long)fat_FatStartSector + fat_FatSectors;

.FATInit76:
 xor eax, eax
 mov ax, [fat_FatStartSector]
 add ax, [fat_FatSectors]
 mov dword [fat_RootDirStartSectorL], eax
;-532 	

;-533 	fat_RootDirSectorsL = (long) bs_root_entr >> 4;//  ./. 16

 xor eax, eax
 mov ax, [bs_root_entr]
 shr ax, 4
 mov dword [fat_RootDirSectorsL], eax
;-534 		

;-535 	fat_DataStartSectorL = fat_RootDirStartSectorL + fat_RootDirSectorsL;

 mov eax, [fat_RootDirStartSectorL]
 add eax, [fat_RootDirSectorsL]
 mov dword [fat_DataStartSectorL], eax
;-536 

;-537 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .FATInit77
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-538 	DataSectors32=bs_tot_sect32 - fat_DataStartSectorL;

.FATInit77:
 mov eax, [bs_tot_sect32]
 sub eax, [fat_DataStartSectorL]
 mov dword [DataSectors32], eax
;-539 

;-540 	CountofClustersL=DataSectors32 / clust_sizeL;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [clust_sizeL]
 mov dword [CountofClustersL], eax
;-541 

;-542 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-543 	num_tracksL = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [num_tracksL], eax
;-544 

;-545 //	templong = (long) bs_num_heads;

;-546 //	fat_num_cylinders = num_tracksL / templong;//w=d/w

;-547 

;-548 	Sectors_per_cylinderL = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinderL], eax
;-549 	asm mov [Sectors_per_cylinderL + 2], dx;store high word

 mov [Sectors_per_cylinderL + 2], dx;store high word
;-550 

;-551 	templong = (long) 65525;

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-552 	if (CountofClustersL > templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jle .FATInit78
;-553 		trueFATtype=32;

 mov ax, 32
 mov byte [trueFATtype], al
;-554 		cputs(" FAT32 NOT supported");

 push FATInit_0
 call cputs
 add  sp, 2
;-555 		return 1;

 mov ax, 1
 jmp .retnFATInit
;-556 		}

;-557 	templong= (long) 4086;

.FATInit78:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-558 	if (CountofClustersL < templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jge .FATInit79
;-559 		trueFATtype=12;

 mov ax, 12
 mov byte [trueFATtype], al
;-560 		cputs(" FAT12");

 push FATInit_1
 call cputs
 add  sp, 2
;-561 		return 0;

 mov ax, 0
 jmp .retnFATInit
;-562 		}

;-563 	trueFATtype=16;

.FATInit79:
 mov ax, 16
 mov byte [trueFATtype], al
;-564 	if (debug) cputs(" FAT16");

 mov ax, 1
 or  al, al
 je .FATInit80
 push FATInit_2
 call cputs
 add  sp, 2
;-565 	return 0;

.FATInit80:
 mov ax, 0
 jmp .retnFATInit
;-566 }

;-567 

;-568 int Int13hExt() {

 .retnFATInit:
 LEAVE
 ret
FATInit_0 db " FAT32 NOT supported",0
FATInit_1 db " FAT12",0
FATInit_2 db " FAT16",0
ENDP

Int13hExt: PROC
;-569 	bx=0x55AA;

 mov  bx, 21930
;-570 	BIOS_Status=Int13hfunction(Drive, 0x41);

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-571 	asm mov [vAX], ax;

 mov [vAX], ax;
;-572 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-573 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported
;-574 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt81
;-575 		cputs(" Ext. NOT present");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-576 		Int13hError();

 call Int13hError
;-577 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-578 		}

;-579 	else if (debug) cputs(",Int13h Ext.");

 jmp .Int13hExt82
.Int13hExt81:
 mov ax, 1
 or  al, al
 je .Int13hExt83
 push Int13hExt_1
 call cputs
 add  sp, 2
;-580 	return 0;

.Int13hExt83:
.Int13hExt82:
 mov ax, 0
 jmp .retnInt13hExt
;-581 }

;-582 

;-583 int PrintDriveParameter() {

 .retnInt13hExt:
 ret
Int13hExt_0 db " Ext. NOT present",0
Int13hExt_1 db ",Int13h Ext.",0
ENDP

PrintDriveParameter: PROC
;-584 	unsigned long Lo;

;-585 // from Params

;-586 	putch(10);

;Function : PrintDriveParameter, Number local Var: 1
; # type sign width local variables
;93 var unsg long Lo = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-587 	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);

 push PrintDriveParameter_0
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-588 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-589 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-590 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-591 	putch('.');

 push 46
 call putch
 add  sp, 2
;-592 //from getPartitionData

;-593 	putch(10);

 push 10
 call putch
 add  sp, 2
;-594 	cputs("getPartitionData:No=");printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-595 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-596 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-597 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-598 	cputs("/");				printunsign(pt_StartSector);

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-599 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-600 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-601 	cputs("/");				printunsign(pt_EndSector);

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-602 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-603 	cputs(",Start=");		printlong(pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 push dword [pt_HiddenSector]
 call printlong
 add  sp, 4
;-604 	cputs(",Len=");			printlong(pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 push dword [pt_PartLen]
 call printlong
 add  sp, 4
;-605 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-606 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-607 	printlong(Lo);

 push dword [bp-4]
 call printlong
 add  sp, 4
;-608 	cputs(" MByte.");

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-609 //from getBootSector

;-610 	putch(10);

 push 10
 call putch
 add  sp, 2
;-611 	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-612 	putch(10);

 push 10
 call putch
 add  sp, 2
;-613 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-614 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-615 	putch(10);

 push 10
 call putch
 add  sp, 2
;-616 	cputs("Reserved sectors=");printunsign(bs_res_sects);

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-617 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-618 	putch(10);

 push 10
 call putch
 add  sp, 2
;-619 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-620 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-621 	putch(10);

 push 10
 call putch
 add  sp, 2
;-622 	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-623 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-624 	putch(10);

 push 10
 call putch
 add  sp, 2
;-625 	cputs("sectors per track=");printunsign(bs_sectors_per_track);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_sectors_per_track]
 call printunsign
 add  sp, 2
;-626 	cputs(".number of heads=");printunsign(bs_num_heads);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_heads]
 call printunsign
 add  sp, 2
;-627 	putch(10);

 push 10
 call putch
 add  sp, 2
;-628 	cputs("hidden sectors(long)=");printlong(bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 push dword [bs_hid_sects]
 call printlong
 add  sp, 4
;-629 	cputs(".sectors(long)=");printlong(bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 push dword [bs_tot_sect32]
 call printlong
 add  sp, 4
;-630 	putch(10);

 push 10
 call putch
 add  sp, 2
;-631 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-632 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-633 	putch(10);

 push 10
 call putch
 add  sp, 2
;-634 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-635 	cputs(".Volume serial(long)=");printlong(bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 push dword [bs_serial_num]
 call printlong
 add  sp, 4
;-636 	putch(10);

 push 10
 call putch
 add  sp, 2
;-637 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-638 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-639 //from FATInit

;-640 	putch(10);

 push 10
 call putch
 add  sp, 2
;-641 	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [fat_FatStartSector]
 call printunsign
 add  sp, 2
;-642 	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [fat_FatSectors]
 call printunsign
 add  sp, 2
;-643 	putch(10);

 push 10
 call putch
 add  sp, 2
;-644 	cputs("fat_RootDirStartSectorL="); printlong(fat_RootDirStartSectorL);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push dword [fat_RootDirStartSectorL]
 call printlong
 add  sp, 4
;-645 	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectorsL);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push dword [fat_RootDirSectorsL]
 call printunsign
 add  sp, 4
;-646 	putch(10);

 push 10
 call putch
 add  sp, 2
;-647 	cputs("fat_DataStartSectorL=");	printunsign(fat_DataStartSectorL);

 push PrintDriveParameter_38
 call cputs
 add  sp, 2
 push dword [fat_DataStartSectorL]
 call printunsign
 add  sp, 4
;-648 	cputs(", DataSectors32=");	printlong(DataSectors32);

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 push dword [DataSectors32]
 call printlong
 add  sp, 4
;-649 	putch(10);

 push 10
 call putch
 add  sp, 2
;-650 	cputs("CountofClustersL=");	printlong(CountofClustersL);

 push PrintDriveParameter_40
 call cputs
 add  sp, 2
 push dword [CountofClustersL]
 call printlong
 add  sp, 4
;-651 	cputs(", Sectors_per_cylinderL="); printlong(Sectors_per_cylinderL);

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 push dword [Sectors_per_cylinderL]
 call printlong
 add  sp, 4
;-652 	putch(10);

 push 10
 call putch
 add  sp, 2
;-653 	cputs("num_tracksL=");	printlong(num_tracksL);

 push PrintDriveParameter_42
 call cputs
 add  sp, 2
 push dword [num_tracksL]
 call printlong
 add  sp, 4
;-654 //	cputs(", fat_num_cylinders="); printunsign(fat_num_cylinders);

;-655 	getkey();

 call getkey
;-656 }

;-657 

;-658 //--------------------------------  file IO  -------------------

;-659 int error2(char *s) {

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
;-660 	putch(10);

;Function : error2, Number local Var: 1
; # type sign width local variables
;93 ptr sign byte s = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-661 	cputs("*** ERROR *** ");

 push error2_0
 call cputs
 add  sp, 2
;-662 	cputs(s);

 push word [bp+4]
 call cputs
 add  sp, 2
;-663 	DOS_ERR++;

 inc  byte[DOS_ERR]
;-664 }

;-665 // 1.

;-666 int readLogical(unsigned long SectorL) {//OUT:1 sector in DiskBuf

 LEAVE
 ret
error2_0 db "*** ERROR *** ",0
ENDP

readLogical: PROC
;-667 	unsigned int track; unsigned int head; unsigned int sect;

;-668 	SectorL = SectorL + bs_hid_sects;//d=d+d

;Function : readLogical, Number local Var: 4
; # type sign width local variables
;93 var unsg long SectorL = bp+4
;94 var unsg word track = bp-2
;95 var unsg word head = bp-4
;96 var unsg word sect = bp-6;
 ENTER  6,0
 mov eax, [bp+4]
 add eax, [bs_hid_sects]
 mov [bp+4], eax
;-669 	track = SectorL / Sectors_per_cylinderL;  //w=d/d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinderL]
 mov [bp-2], ax
;-670 	head  = SectorL % Sectors_per_cylinderL;  //w=d%d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinderL]
 mov eax, edx
 mov [bp-4], ax
;-671 	sect  = head            % bs_sectors_per_track;  //w=w%w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov ax, dx
 mov [bp-6], ax
;-672 	sect++;

 inc  word[bp-6]
;-673 	head  = head            / bs_sectors_per_track;	 //w=w/w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov [bp-4], ax
;-674 

;-675 	DiskSectorReadWrite(2, bs_drive_num, head, track/* =cyl */,

;-676 		sect, 1, DiskBufSeg , DiskBuf);

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
;-677 }

;-678 // 2.a

;-679 int printDirEntry(int EntryNr) {

 LEAVE
 ret
ENDP

printDirEntry: PROC
;-680     unsigned int j;

;-681 	putch(10);

;Function : printDirEntry, Number local Var: 2
; # type sign width local variables
;93 var sign word EntryNr = bp+4
;94 var unsg word j = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-682 	printunsign(EntryNr);

 push word [bp+4]
 call printunsign
 add  sp, 2
;-683 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-684 	cputs(filename);

 lea  ax, [filename]
 push ax
 call cputs
 add  sp, 2
;-685 	cputs(" ATTR:");

 push printDirEntry_0
 call cputs
 add  sp, 2
;-686 	printhex8(dir_Attrib);	

 mov al, byte [dir_Attrib]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-687 	if (dir_Attrib &  1) cputs(" r/o");

 mov al, [dir_Attrib]
 and al, 1
 or  al, al
 je .printDirEntry84
 push printDirEntry_1
 call cputs
 add  sp, 2
;-688 	if (dir_Attrib &  2) cputs(" hid");

.printDirEntry84:
 mov al, [dir_Attrib]
 and al, 2
 or  al, al
 je .printDirEntry85
 push printDirEntry_2
 call cputs
 add  sp, 2
;-689 	if (dir_Attrib &  4) cputs(" sys");

.printDirEntry85:
 mov al, [dir_Attrib]
 and al, 4
 or  al, al
 je .printDirEntry86
 push printDirEntry_3
 call cputs
 add  sp, 2
;-690 	if (dir_Attrib &  8) cputs(" vol");		

.printDirEntry86:
 mov al, [dir_Attrib]
 and al, 8
 or  al, al
 je .printDirEntry87
 push printDirEntry_4
 call cputs
 add  sp, 2
;-691 	if (dir_Attrib & 16) cputs(" dir");

.printDirEntry87:
 mov al, [dir_Attrib]
 and al, 16
 or  al, al
 je .printDirEntry88
 push printDirEntry_5
 call cputs
 add  sp, 2
;-692 	if (dir_Attrib & 32) cputs(" arc");

.printDirEntry88:
 mov al, [dir_Attrib]
 and al, 32
 or  al, al
 je .printDirEntry89
 push printDirEntry_6
 call cputs
 add  sp, 2
;-693 	if (dir_Attrib == 0) cputs("    ");

.printDirEntry89:
 mov al, [dir_Attrib]
 cmp al, 0
 jne .printDirEntry90
 push printDirEntry_7
 call cputs
 add  sp, 2
;-694 	

;-695 	putch(' ');

.printDirEntry90:
 push 32
 call putch
 add  sp, 2
;-696 	j=dir_LastModDate & 31;//day

 mov ax, [dir_LastModDate]
 and ax, 31
 mov [bp-2], ax
;-697 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry91
 push 32
 call putch
 add  sp, 2
;-698 	printunsign(j);

.printDirEntry91:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-699 	putch('.');

 push 46
 call putch
 add  sp, 2
;-700 

;-701 	j=dir_LastModDate >> 5;//month

 mov ax, [dir_LastModDate]
 shr ax, 5
 mov [bp-2], ax
;-702 	j&=  15;

 and  word[bp-2], 15
;-703 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry92
 push 48
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

;-707 	j=dir_LastModDate >> 9;//year

 mov ax, [dir_LastModDate]
 shr ax, 9
 mov [bp-2], ax
;-708 	j+= 1980;

 add  word[bp-2], 1980
;-709 	printunsign(j);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-710 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-711 	//putch(' ');

;-712 

;-713 	j=dir_LastModTime  >>11;//hour

 mov ax, [dir_LastModTime]
 shr ax, 11
 mov [bp-2], ax
;-714 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry93
 push 32
 call putch
 add  sp, 2
;-715 	printunsign(j);

.printDirEntry93:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-716 	putch(':');

 push 58
 call putch
 add  sp, 2
;-717 

;-718 	j=dir_LastModTime  >> 5;//minute

 mov ax, [dir_LastModTime]
 shr ax, 5
 mov [bp-2], ax
;-719 	j&=  63;

 and  word[bp-2], 63
;-720 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry94
 push 48
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

;-724 	j=dir_LastModTime & 31;// 2 seconds

 mov ax, [dir_LastModTime]
 and ax, 31
 mov [bp-2], ax
;-725 	j=j+j;

 mov ax, [bp-2]
 add ax, [bp-2]
 mov [bp-2], ax
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
;-728 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-729 

;-730 	cputs(" 1.Cl:"); 

 push printDirEntry_8
 call cputs
 add  sp, 2
;-731 	printunsign(dir_FirstCluster);

 push word [dir_FirstCluster]
 call printunsign
 add  sp, 2
;-732 	cputs(" Size:");

 push printDirEntry_9
 call cputs
 add  sp, 2
;-733 	printlong(dir_FileSize);

 push dword [dir_FileSize]
 call printlong
 add  sp, 4
;-734 	

;-735 }

;-736 

;-737 // 2.b

;-738 int fatDirSectorList(unsigned long startSector, unsigned long numsectors) {

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
;-739     char *p;

;-740 	unsigned int EndDiskBuf;

;-741 	char isHide;//shows entries, NOT lfn, deleted or empty

;-742 	unsigned int EntryNr;

;-743 	EntryNr=0;

;Function : fatDirSectorList, Number local Var: 6
; # type sign width local variables
;93 var unsg long startSector = bp+4
;94 var unsg long numsectors = bp+8
;95 ptr sign byte p = bp-2
;96 var unsg word EndDiskBuf = bp-4
;97 var sign byte isHide = bp-6
;98 var unsg word EntryNr = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-8], ax
;-744 	do {

.fatDirSectorList96:
;-745 /*		putch(10);

;-746 		cputs("Sektor = "); 

;-747 		printlong(startSector);

;-748 		cputs(", numsectors = "); 

;-749 		printlong(numsectors);

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

.fatDirSectorList97:
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
 jne .fatDirSectorList98
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

.fatDirSectorList98:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 229
 jne .fatDirSectorList99
 inc  byte[bp-6]
;-768 			if (*p <=   31) isHide++;//part of LFN

.fatDirSectorList99:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 31
 jg  .fatDirSectorList100
 inc  byte[bp-6]
;-769 			if (dir_Attrib ==    15) isHide++;//LFN start

.fatDirSectorList100:
 mov al, [dir_Attrib]
 cmp al, 15
 jne .fatDirSectorList101
 inc  byte[bp-6]
;-770 					

;-771 			if (isHide == 0) printDirEntry(EntryNr);

.fatDirSectorList101:
 mov al, [bp-6]
 cmp al, 0
 jne .fatDirSectorList102
 push word [bp-8]
 call printDirEntry
 add  sp, 2
;-772 			p+=32;//get next entry

.fatDirSectorList102:
 add  word[bp-2], 32
;-773 			EntryNr++;

 inc  word[bp-8]
;-774 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorList103
 jmp .fatDirSectorList97
.fatDirSectorList103:
;-775 		startSector = startSector + 1;//long, do NOT use ++ or +=1

 mov eax, [bp+4]
 add eax, 1
 mov [bp+4], eax
;-776 		numsectors--;

 dec  dword[bp+8]
;-777 //mdump(DiskBuf, 512);

;-778 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorList104
 jmp .fatDirSectorList96
.fatDirSectorList104:
;-779 	CurCluster=0;//not found but not end

 mov ax, 0
 mov word [CurCluster], ax
;-780 }

;-781 

;-782 // 2.

;-783 int fatDirSectorSearch(unsigned long startSector,unsigned long numsectors) {

 LEAVE
 ret
ENDP

fatDirSectorSearch: PROC
;-784     //search for file name. IN:searchstr

;-785     char *p;

;-786 	unsigned int EndDiskBuf;

;-787 	fatfound=0;

;Function : fatDirSectorSearch, Number local Var: 4
; # type sign width local variables
;93 var unsg long startSector = bp+4
;94 var unsg long numsectors = bp+8
;95 ptr sign byte p = bp-2
;96 var unsg word EndDiskBuf = bp-4;
 ENTER  4,0
 mov ax, 0
 mov byte [fatfound], al
;-788 	do {

.fatDirSectorSearch105:
;-789 		readLogical(startSector);

 push dword [bp+4]
 call readLogical
 add  sp, 4
;-790 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-791 		EndDiskBuf= p + bs_sect_size;

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-792 		do {

.fatDirSectorSearch106:
;-793 			if (memcmp(p, searchstr, 11) == 0) {//found file name

 push 11
 lea  ax, [searchstr]
 push ax
 push word [bp-2]
 call memcmp
 add  sp, 6
 cmp ax, 0
 jne .fatDirSectorSearch107
;-794 				memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-795 				memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-796 				filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-797 				CurCluster   = dir_FirstCluster;

 mov ax, [dir_FirstCluster]
 mov word [CurCluster], ax
;-798 				FileSizeL  = dir_FileSize;

 mov eax, [dir_FileSize]
 mov dword [FileSizeL], eax
;-799 				fatfound=1;

 mov ax, 1
 mov byte [fatfound], al
;-800 			}

;-801 			if (*p == 0) return; //only empty entries following

.fatDirSectorSearch107:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorSearch108
 jmp .retnfatDirSectorSearch
;-802 			p+=32;//get next entry

.fatDirSectorSearch108:
 add  word[bp-2], 32
;-803 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorSearch109
 jmp .fatDirSectorSearch106
.fatDirSectorSearch109:
;-804 		startSector++;		

 inc  dword[bp+4]
;-805 		numsectors--;

 dec  dword[bp+8]
;-806 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorSearch110
 jmp .fatDirSectorSearch105
.fatDirSectorSearch110:
;-807 	CurCluster=0;//not found but not end

 mov ax, 0
 mov word [CurCluster], ax
;-808 }

;-809 

;-810 /*

;-811 // 3.

;-812 int fatRootSearch() {

;-813     fatDirSectorSearch(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-814 //	getkey();

;-815 //    fatDirSectorList(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-816 }

;-817 */

;-818 // 4.

;-819 int fatClusterAnalyse(unsigned int clust) {

 .retnfatDirSectorSearch:
 LEAVE
 ret
ENDP

fatClusterAnalyse: PROC
;-820 //OUT: CurSectorL, NextCluster

;-821 	unsigned long fatSectorL;

;-822 	unsigned int offset;

;-823 	char *p;

;-824 unsigned long offL;

;-825 

;-826 	CurSectorL = (long) clust - 2;

;Function : fatClusterAnalyse, Number local Var: 5
; # type sign width local variables
;93 var unsg word clust = bp+4
;94 var unsg long fatSectorL = bp-4
;95 var unsg word offset = bp-6
;96 ptr sign byte p = bp-8
;97 var unsg long offL = bp-12;
 ENTER  12,0
 xor eax, eax
 mov ax, [bp+4]
 sub ax, 2
 mov dword [CurSectorL], eax
;-827 	CurSectorL = CurSectorL * clust_sizeL;

 mov eax, [CurSectorL]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul dword [clust_sizeL]
 mov dword [CurSectorL], eax
;-828 	CurSectorL = CurSectorL + fat_DataStartSectorL;

 mov eax, [CurSectorL]
 add eax, [fat_DataStartSectorL]
 mov dword [CurSectorL], eax
;-829 	

;-830 //	fatSectorL=cluster*2/512+FatStartSector

;-831 	fatSectorL = (long) clust;

 xor eax, eax
 mov ax, [bp+4]
 mov [bp-4], eax
;-832 	fatSectorL = fatSectorL + fatSectorL;

 mov eax, [bp-4]
 add eax, [bp-4]
 mov [bp-4], eax
;-833 	fatSectorL = fatSectorL / sector_sizeL;		

 mov eax, [bp-4]
 xor edx, edx
 div dword [sector_sizeL]
 mov [bp-4], eax
;-834 	fatSectorL = fatSectorL + fat_FatStartSectorL; 

 mov eax, [bp-4]
 add eax, [fat_FatStartSectorL]
 mov [bp-4], eax
;-835 	readLogical(fatSectorL);

 push dword [bp-4]
 call readLogical
 add  sp, 4
;-836 	

;-837 	offset = clust + clust;//todo overflow?

 mov ax, [bp+4]
 add ax, [bp+4]
 mov [bp-6], ax
;-838 	offset = offset % bs_sect_size;

 mov ax, [bp-6]
 xor dx, dx
 div word [bs_sect_size]
 mov ax, dx
 mov [bp-6], ax
;-839 	

;-840 	p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-8], ax
;-841 	p = p + offset;	

 mov ax, [bp-8]
 add ax, [bp-6]
 mov [bp-8], ax
;-842 	memcpy(&NextCluster, p, 2);//OUT: NextCluster

 push 2
 push word [bp-8]
 lea  ax, [NextCluster]
 push ax
 call memcpy
 add  sp, 6
;-843 }

;-844 /*

;-845 // 5.

;-846 int fatDirSearch() {//search a directory chain. IN:searchstr

;-847 	

;-848 	fatClusterAnalyse(fatfile_cluster);

;-849 	//OUT: fatfile_sectorStartL, fatfile_nextCluster

;-850 

;-851 	fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster); 

;-852 	while (fatfile_cluster == 0) {//not found but not end

;-853 		if (fatfile_nextCluster >= 0xFFF8) {

;-854 			fat_notfound=1;

;-855 			return;	

;-856 		}		

;-857 		fatfile_cluster=fatfile_nextCluster;

;-858 		fatClusterAnalyse(fatfile_cluster);

;-859 		fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster);

;-860 	}	

;-861 }

;-862 */	

;-863 

;-864 int is_delimiter(char *s) {

 LEAVE
 ret
ENDP

is_delimiter: PROC
;-865 	if (*s == '/' ) return 1;

;Function : is_delimiter, Number local Var: 1
; # type sign width local variables
;93 ptr sign byte s = bp+4;
 ENTER  0,0
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 47
 jne .is_delimiter111
 mov ax, 1
 jmp .retnis_delimiter
;-866 	if (*s == '\\') return 1;

.is_delimiter111:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 92
 jne .is_delimiter112
 mov ax, 1
 jmp .retnis_delimiter
;-867 	if (*s ==    0) return 2;

.is_delimiter112:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .is_delimiter113
 mov ax, 2
 jmp .retnis_delimiter
;-868 	if (*s ==  '.') return 3;

.is_delimiter113:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 46
 jne .is_delimiter114
 mov ax, 3
 jmp .retnis_delimiter
;-869 	return 0;

.is_delimiter114:
 mov ax, 0
 jmp .retnis_delimiter
;-870 }

;-871 

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

;-878 //	OUT: fatfound

;-879 	char *searchstrp;

;-880 	char *p; 

;-881 	unsigned int  len;

;-882 	unsigned int delimiter;

;-883 

;-884 	delimiter=is_delimiter(upto);

;Function : fatNextSearch, Number local Var: 4
; # type sign width local variables
;93 ptr sign byte searchstrp = bp-2
;94 ptr sign byte p = bp-4
;95 var unsg word len = bp-6
;96 var unsg word delimiter = bp-8;
 ENTER  8,0
 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-885 	if (delimiter == 1) upto++;

 mov ax, [bp-8]
 cmp ax, 1
 jne .fatNextSearch115
 inc  word[upto]
;-886 	if (delimiter == 2) return; 

.fatNextSearch115:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch116
 jmp .retnfatNextSearch
;-887 

;-888 	strcpy(&searchstr, "           ");//11 blank padded

.fatNextSearch116:
 push fatNextSearch_0
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

.fatNextSearch117:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch118
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

;-899 	if (len > 8) return;

 jmp .fatNextSearch117
.fatNextSearch118:
 mov ax, [bp-6]
 cmp ax, 8
 jle .fatNextSearch119
 jmp .retnfatNextSearch
;-900 	isfilename=0;//todo: default directory, not yet implemented

.fatNextSearch119:
 mov ax, 0
 mov byte [isfilename], al
;-901 	if (delimiter == 2) isfilename=1;//last name is always a file name

 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch120
 mov ax, 1
 mov byte [isfilename], al
;-902 	if (delimiter == 3) {//remove dot in name		

.fatNextSearch120:
 mov ax, [bp-8]
 cmp ax, 3
 jne .fatNextSearch121
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

.fatNextSearch122:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch123
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

;-915 		if (len > 3) return;

 jmp .fatNextSearch122
.fatNextSearch123:
 mov ax, [bp-6]
 cmp ax, 3
 jle .fatNextSearch124
 jmp .retnfatNextSearch
;-916 		if (delimiter == 2) isfilename=1;//last name is always a file name

.fatNextSearch124:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch125
 mov ax, 1
 mov byte [isfilename], al
;-917 	}

.fatNextSearch125:
;-918 	fatfound=1;	

.fatNextSearch121:
 mov ax, 1
 mov byte [fatfound], al
;-919 }

;-920 

;-921 // 7.

;-922 int fatGetStartCluster() {//lastBytes, lastSectors

 .retnfatNextSearch:
 LEAVE
 ret
fatNextSearch_0 db "           ",0
ENDP

fatGetStartCluster: PROC
;-923 	fatfound=0;

 mov ax, 0
 mov byte [fatfound], al
;-924 	toupper(filename);

 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-925 	upto = &filename;

 mov ax, filename
 mov word [upto], ax
;-926 	fatNextSearch();

 call fatNextSearch
;-927 

;-928 	if (debug) {putch(10); cputsLen(searchstr, 11);

 mov ax, 1
 or  al, al
 je .fatGetStartCluster126
 push 10
 call putch
 add  sp, 2
 push 11
 lea  ax, [searchstr]
 push ax
 call cputsLen
 add  sp, 4
;-929 //		cputs(",FName="); printunsign(isfilename); 

;-930 		}

;-931 	if (isfilename == 0) return; //todo not implemented

.fatGetStartCluster126:
 mov al, [isfilename]
 cmp al, 0
 jne .fatGetStartCluster127
 jmp .retnfatGetStartCluster
;-932 	if (fatfound) 	fatDirSectorSearch(fat_RootDirStartSectorL, fat_RootDirSectorsL); 

.fatGetStartCluster127:
 mov al, [fatfound]
 or  al, al
 je .fatGetStartCluster128
 push dword [fat_RootDirSectorsL]
 push dword [fat_RootDirStartSectorL]
 call fatDirSectorSearch
 add  sp, 8
;-933 }

.fatGetStartCluster128:
;-934 

;-935 /*

;-936 // 8.

;-937 int fatOpenFile() {//set handle for root or subdir

;-938 	unsigned long bytes_per_cluster;

;-939 	fat_notfound=0;

;-940 	if (debug) cputs("fatOpenfile ");	

;-941 	if (filename[0] == 0) {//empty filename

;-942 //	if (strlen(filename) == 0) {//empty filename

;-943 		fat_notfound=1;//todo: return

;-944 		

;-945 		fatfile_root = 1;

;-946 		fatfile_nextCluster = 0xFFFF;

;-947 		fatfile_sectorCount = fat_RootDirSectorsL;

;-948 		fatfile_sectorStartL = fat_RootDirStartSectorL;

;-949 		fatfile_lastBytes   = 0;

;-950 		fatfile_lastSectors = fat_RootDirSectorsL;

;-951 		fatfile_cluster     = 0;

;-952 		fatfile_dir         = 1;

;-953 

;-954 	} else {//search in subdir

;-955 		fatfile_root = 0;

;-956 		fatGetStartCluster();

;-957 		if (fat_notfound) return 1;

;-958 		bytes_per_cluster   = (long) bs_clust_size * bs_sect_size;

;-959 		fatfile_lastBytes   = fatfile_fileSize % bytes_per_cluster;

;-960 		fatfile_lastSectors = fatfile_lastBytes / bs_sect_size;

;-961 		fatfile_lastBytes   = fatfile_lastBytes % bs_sect_size;

;-962 		if (fatfile_fileSize == 0) fatfile_dir = 1;

;-963 		else                       fatfile_dir = 0;

;-964 

;-965 //		fatClusterAnalyse();

;-966 		fatfile_sectorCount = (int) bs_clust_size;

;-967 	}

;-968 	fatfile_currentCluster = fatfile_cluster;

;-969 	fatfile_sectorUpto = 0;

;-970 	fatfile_byteUpto   = 0;

;-971 	if (fat_notfound) return 1;

;-972 	return 0;

;-973 }

;-974 */

;-975 

;-976 // 9.

;-977 int fatReadFile() {// reads 1 byte from an already open file

 .retnfatGetStartCluster:
 ret
ENDP

fatReadFile: PROC
;-978 //	IN: CurCluster, FileSizeL

;-979 	fatGetStartCluster();

 call fatGetStartCluster
;-980 	if (fatfound == 0) {

 mov al, [fatfound]
 cmp al, 0
 jne .fatReadFile129
;-981 		cputs(" file not found"); 

 push fatReadFile_0
 call cputs
 add  sp, 2
;-982 		return;

 jmp .retnfatReadFile
;-983 		}

;-984 cputs(",1.Cl="); printunsign(CurCluster);

.fatReadFile129:
 push fatReadFile_1
 call cputs
 add  sp, 2
 push word [CurCluster]
 call printunsign
 add  sp, 2
;-985 	fatClusterAnalyse(CurCluster);

 push word [CurCluster]
 call fatClusterAnalyse
 add  sp, 2
;-986 //cputs(",secStartL="); printlong(CurSectorL);

;-987 cputs(",ClSz="); printlong(clust_sizeL);

 push fatReadFile_2
 call cputs
 add  sp, 2
 push dword [clust_sizeL]
 call printlong
 add  sp, 4
;-988 cputs(",Size="); printlong(FileSizeL);

 push fatReadFile_3
 call cputs
 add  sp, 2
 push dword [FileSizeL]
 call printlong
 add  sp, 4
;-989 cputs(",NextCl="); printunsign(NextCluster);

 push fatReadFile_4
 call cputs
 add  sp, 2
 push word [NextCluster]
 call printunsign
 add  sp, 2
;-990 	readLogical(CurSectorL);

 push dword [CurSectorL]
 call readLogical
 add  sp, 4
;-991 	mdump(DiskBuf, 512);

 push 512
 lea  ax, [DiskBuf]
 push ax
 call mdump
 add  sp, 4
;-992 	

;-993 		

;-994 }

;-995 //------------------------------- OS functions --------------

;-996 //handle: 0=in, 1=out, 2=err, 3=aux, 4=prn, 255=error

;-997 int OSOpenFile(char *name) {//remove drive letter and uppercase

 .retnfatReadFile:
 ret
fatReadFile_0 db " file not found",0
fatReadFile_1 db ",1.Cl=",0
fatReadFile_2 db ",ClSz=",0
fatReadFile_3 db ",Size=",0
fatReadFile_4 db ",NextCl=",0
ENDP

OSOpenFile: PROC
;-998 	if (filename[0] == 0) return 255; //empty filename

;Function : OSOpenFile, Number local Var: 1
; # type sign width local variables
;93 ptr sign byte name = bp+4;
 ENTER  0,0
 mov al, [filename]
 cmp al, 0
 jne .OSOpenFile130
 mov ax, 255
 jmp .retnOSOpenFile
;-999 	

;-1000 	strcpy(filename, name);

.OSOpenFile130:
 push word [bp+4]
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1001 	toupper(filename);

 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-1002 

;-1003 cputs(",filename=");cputs(filename);

 push OSOpenFile_0
 call cputs
 add  sp, 2
 lea  ax, [filename]
 push ax
 call cputs
 add  sp, 2
;-1004 

;-1005 

;-1006 

;-1007 //	rc=fatOpenFile();

;-1008 //	cputs(" rc="); printunsign(rc);

;-1009 

;-1010 	return 5;

 mov ax, 5
 jmp .retnOSOpenFile
;-1011 }

;-1012 

;-1013 int OSReadFile(char hd) {

 .retnOSOpenFile:
 LEAVE
 ret
OSOpenFile_0 db ",filename=",0
ENDP

OSReadFile: PROC
;-1014 	

;-1015 }

;Function : OSReadFile, Number local Var: 1
; # type sign width local variables
;93 var sign byte hd = bp+4;
 ENTER  0,0
;-1016 

;-1017 //------------------------------- Init,  main ---------------

;-1018 int Init() {

 LEAVE
 ret
ENDP

Init: PROC
;-1019 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-1020 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-1021 	if (debug) cputs(" Init");

 mov ax, 1
 or  al, al
 je .Init131
 push Init_0
 call cputs
 add  sp, 2
;-1022 	if (Params()) cputs(" ** NO DRIVE PARAMS FOUND **");//no hard disk

.Init131:
 call Params
 or  al, al
 je .Init132
 push Init_1
 call cputs
 add  sp, 2
;-1023 	if (readMBR() == 0) {//0=error,1=FAT12,6=FAT16,11=FAT32	

.Init132:
 call readMBR
 cmp al, 0
 jne .Init133
;-1024 		cputs(" ** no active FAT partition found **");

 push Init_2
 call cputs
 add  sp, 2
;-1025 		return 1;

 mov ax, 1
 jmp .retnInit
;-1026 		}

;-1027 	if(getBootSector()==0) 	return 1;

.Init133:
 call getBootSector
 cmp al, 0
 jne .Init134
 mov ax, 1
 jmp .retnInit
;-1028 	if (FATInit())			return 1;

.Init134:
 call FATInit
 or  al, al
 je .Init135
 mov ax, 1
 jmp .retnInit
;-1029 	if(trueFATtype != 16) 	return 1;

.Init135:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init136
 mov ax, 1
 jmp .retnInit
;-1030 	Int13hExt();

.Init136:
 call Int13hExt
;-1031 	return 0;

 mov ax, 0
 jmp .retnInit
;-1032 }

;-1033 int main() {

 .retnInit:
 ret
Init_0 db " Init",0
Init_1 db " ** NO DRIVE PARAMS FOUND **",0
Init_2 db " ** no active FAT partition found **",0
ENDP

main: PROC
;-1034 	if (Init() != 0) return 1;

 call Init
 cmp al, 0
 je  .main137
 mov ax, 1
 jmp .retnmain
;-1035 	if (debug) PrintDriveParameter();

.main137:
 mov ax, 1
 or  al, al
 je .main138
 call PrintDriveParameter
;-1036 	

;-1037 	handle=OSOpenFile("dos.com");	

.main138:
 push main_0
 call OSOpenFile
 add  sp, 2
 mov byte [handle], al
;-1038 cputs(" handle="); printunsign(handle);

 push main_1
 call cputs
 add  sp, 2
 mov al, byte [handle]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-1039 

;-1040 	if (handle == 255) {

 mov al, [handle]
 cmp al, 255
 jne .main139
;-1041 		cputs(" ** no handle **");

 push main_2
 call cputs
 add  sp, 2
;-1042 

;-1043 		}

;-1044 		

;-1045 //	OSReadFile(handle);

;-1046 	

;-1047 		handle=OSOpenFile("readme.md");	

.main139:
 push main_3
 call OSOpenFile
 add  sp, 2
 mov byte [handle], al
;-1048 cputs(" handle="); printunsign(handle);

 push main_4
 call cputs
 add  sp, 2
 mov al, byte [handle]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-1049 		handle=OSOpenFile("cm.bat");	

 push main_5
 call OSOpenFile
 add  sp, 2
 mov byte [handle], al
;-1050 cputs(" handle="); printunsign(handle);

 push main_6
 call cputs
 add  sp, 2
 mov al, byte [handle]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-1051 		handle=OSOpenFile("test1.c");	

 push main_7
 call OSOpenFile
 add  sp, 2
 mov byte [handle], al
;-1052 cputs(" handle="); printunsign(handle);

 push main_8
 call cputs
 add  sp, 2
 mov al, byte [handle]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-1053 		handle=OSOpenFile("");	

 push main_9
 call OSOpenFile
 add  sp, 2
 mov byte [handle], al
;-1054 cputs(" handle="); printunsign(handle);

 push main_10
 call cputs
 add  sp, 2
 mov al, byte [handle]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-1055 

;-1056 

;-1057 	if (debug) cputs(" End.");

 mov ax, 1
 or  al, al
 je .main140
 push main_11
 call cputs
 add  sp, 2
;-1058 

;-1059 }

.main140:
;-1060 /*cputs(" delimiter="); printunsign(delimiter);

;-1061 cputs(", isfilename="); printunsign(isfilename);

;-1062 cputs(", upto="); printunsign(upto);

;-1063 cputs("="); cputs(upto);

;-1064 cputs(", len="); printunsign(len);

;-1065 cputs(", searchstr="); cputsLen(searchstr, len);

;-1066 */

;-1067 /*

;-1068 	OSOpenFile

;-1069 	OSReadFile

;-1070 9. fatReadFile

;-1071 8. fatOpenFile set handle, init root or subdir

;-1072 	s7 fatGetStartCluster

;-1073 	s4 fatClusterAnalyse

;-1074 7. fatGestStartCluster

;-1075 	6 fatNextSearch

;-1076 	3 fatRootSearch

;-1077 	s5 fatDirSearch

;-1078 6. fatNextSearch Upto,search,isFilename =>7

;-1079 5. fatDirSearch a directory chain for search

;-1080 	4 fatClusterAnalyse

;-1081 	2 fatDieSectorSearch

;-1082 4. fatClusterAnalysedetermines sector by cluster number, next cluster

;-1083 	1 ReadLogical

;-1084 3. fatRootSearch search the root for an entry

;-1085 	2 fatDirSectorSearch

;-1086 2. fatDirSectorSearch search a block of sectors for entries,

;-1087 		get starting cluster, file size, notfound

;-1088 	1 readLogical

;-1089 2.a printDirEntry

;-1090 2.b fatDirSectorList

;-1091 	1 readLogical					

;-1092 1. readLogical

;-1093 	DiskSectorReadWrite	

;-1094 */

;-1095 /*

;-1096 bin_file=fopen("name", "rb") //binary

;-1097 int = fgetc(in_file)	     //EOF(-1)

;-1098 fputc(character, file)

;-1099 printf() = fprintf(stdout, format, parameter1) //buffered I/O

;-1100 DOS: add CR13 to LF10

;-1101 read_size=fread(data_ptr, 1, size, file) //binary read

;-1102 file_descriptor=open(name, flags, mode=0666) //unbuffered I/O

;-1103 read_size=read(file_descriptor, buffer, size) //unbufferes I/O 

;-1104 */

 .retnmain:
 ret
main_0 db "dos.com",0
main_1 db " handle=",0
main_2 db " ** no handle **",0
main_3 db "readme.md",0
main_4 db " handle=",0
main_5 db "cm.bat",0
main_6 db " handle=",0
main_7 db "test1.c",0
main_8 db " handle=",0
main_9 db "",0
main_10 db " handle=",0
main_11 db " End.",0
ENDP
