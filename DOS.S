;PLA compiler A.COM V1.1.3, Input: DOS.C, Output: DOS.S
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
;-15 

;-16 

;-17 unsigned int  DiskBufSeg;

DiskBufSeg dw 0
;-18 unsigned char dummy[1];//todo remove

section .bss
absolute 16384
dummy resb 1
section .text
;-19 unsigned char DiskBuf [512];

section .bss
absolute 16385
DiskBuf resb 512
section .text
;-20 unsigned char Drive=0x80;

Drive db 128
;-21 

;-22 //Params from int13h, Function 8

;-23 unsigned int  pa_Cylinders;

pa_Cylinders dw 0
;-24 unsigned char pa_Sectors;

pa_Sectors db 0
;-25 unsigned char pa_Heads;

pa_Heads db 0
;-26 unsigned char pa_Attached;

pa_Attached db 0
;-27 

;-28 unsigned int  pt_PartNo;

pt_PartNo dw 0
;-29 //start hard disk partition structure 16 bytes in MBR. do not change

;-30 unsigned char pt_Bootable;		// 00 80h = active partition, else 00

pt_Bootable db 0
;-31 unsigned char pt_StartHead;		// 01

pt_StartHead db 0
;-32 unsigned char pt_StartSector;	// 02 bits 0-5

pt_StartSector db 0
;-33 unsigned int  pt_StartCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-34 unsigned char pt_FileSystem;	// 04 0=nu,1=FAT12,4=16,5=ExtP,6=large16

pt_FileSystem db 0
;-35 unsigned char pt_EndHead;		// 05

pt_EndHead db 0
;-36 unsigned char pt_EndSector;		// 06 bits 0-5

pt_EndSector db 0
;-37 unsigned int  pt_EndCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-38 unsigned long pt_HiddenSector;	// 08 sectors preceding partition

pt_HiddenSector dd 0
;-39 unsigned long pt_PartLen;    	// 12 length of partition in sectors

pt_PartLen dd 0
;-40 //  16 end hard disk partition structure

;-41 

;-42 //start boot BIOS Parameter Block structure. do not change

;-43 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-44 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-45 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-46 unsigned char bs_clust_size;// 13 sectors per cluster (1,2,4,..,128)

bs_clust_size db 0
;-47 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-48 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-49 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-50 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-51 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-52 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-53 unsigned int  bs_sectors_per_track; // 24 (DOS 3+)sectors per track

bs_sectors_per_track dw 0
;-54 unsigned int  bs_num_heads;	// 26 (DOS 3+)number of heads

bs_num_heads dw 0
;-55 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors

bs_hid_sects dd 0
;-56 unsigned long bs_tot_sect32;// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-57 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-58 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-59 unsigned char bs_ext_signat;// 38 (DOS 4+) Ext. signature,get next 3(29h)

bs_ext_signat db 0
;-60 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-61 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-62 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-63 // 62 end boot BIOS Parameter Block

;-64 

;-65 //unsigned long sect_size_long;

;-66 unsigned long clust_sizeL;

clust_sizeL dd 0
;-67 unsigned long sector_sizeL;

sector_sizeL dd 0
;-68 unsigned char filename[67];

section .bss
absolute 16897
filename resb 67
section .text
;-69 unsigned char searchstr  [12];//with null

section .bss
absolute 16964
searchstr resb 12
section .text
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

;-105 unsigned int  fat_notfound;

fat_notfound dw 0
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
;97 var sign byte c = bp+4;
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
;97 ptr sign byte s = bp+4
;98 var sign byte c = bp-2;
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
;97 ptr sign byte s = bp+4
;98 var sign word len = bp+6
;99 var sign byte c = bp-2;
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
;97 var unsg byte c = bp+4;
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
;97 var unsg byte c = bp+4
;98 var unsg byte nib = bp-2;
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
;97 var unsg word i = bp+4
;98 var unsg word half = bp-2;
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
;97 var unsg word n = bp+4
;98 var unsg word e = bp-2;
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
;97 var unsg long L = bp+4;
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
;97 ptr sign byte s = bp+4
;98 var sign word c = bp-2;
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

;-239 int strcpy(char *s, char *t) {

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-240     do { *s=*t; s++; t++; }

;Function : strcpy, Number local Var: 2
; # type sign width local variables
;97 ptr sign byte s = bp+4
;98 ptr sign byte t = bp+6;
 ENTER  0,0
.strcpy11:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-241     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy12
 jmp .strcpy11
.strcpy12:
;-242     *s=0;

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
;97 ptr sign byte p = bp+4
;98 ptr sign byte q = bp+6;
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
;97 ptr sign byte s = bp+4
;98 ptr sign byte t = bp+6
;99 var unsg word i = bp+8;
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
;97 ptr sign byte s = bp+4
;98 ptr sign byte t = bp+6;
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
;97 ptr sign byte s = bp+4;
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
;97 ptr sign byte s = bp+4
;98 var sign byte c = bp+6;
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

;-281 int instr1(char *s, char c) {

 .retnstrchr:
 LEAVE
 ret
ENDP

instr1: PROC
;-282     while(*s) {

;Function : instr1, Number local Var: 2
; # type sign width local variables
;97 ptr sign byte s = bp+4
;98 var sign byte c = bp+6;
 ENTER  0,0
.instr130:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .instr131
;-283         if (*s==c) return 1;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .instr132
 mov ax, 1
 jmp .retninstr1
;-284         s++;

.instr132:
 inc  word[bp+4]
;-285     }

;-286     return 0;

 jmp .instr130
.instr131:
 mov ax, 0
 jmp .retninstr1
;-287 }

;-288 

;-289 int memcpy(char *s, char *t, unsigned int i) {

 .retninstr1:
 LEAVE
 ret
ENDP

memcpy: PROC
;-290 	unsigned int r;

;-291 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;97 ptr sign byte s = bp+4
;98 ptr sign byte t = bp+6
;99 var unsg word i = bp+8
;100 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-292 	do {

.memcpy33:
;-293 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-294 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-295 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy34
 jmp .memcpy33
.memcpy34:
;-296 	ax=r;//	return r;

 mov  ax, [bp-2]
;-297 }

;-298 

;-299 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-300     unsigned char c; int i; int j; int k;

;-301     j=0;

;Function : mdump, Number local Var: 6
; # type sign width local variables
;97 ptr unsg byte adr = bp+4
;98 var unsg word len = bp+6
;99 var unsg byte c = bp-2
;100 var sign word i = bp-4
;101 var sign word j = bp-6
;102 var sign word k = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-6], ax
;-302     k=0;

 mov ax, 0
 mov [bp-8], ax
;-303     while (j < len ) {

.mdump35:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump36
;-304 	    k++;;

 inc  word[bp-8]
;-305 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump37
;-306 		    getkey();

 call getkey
;-307 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-308 		    }

;-309         putch(10);

.mdump37:
 push 10
 call putch
 add  sp, 2
;-310         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-311         putch(':');

 push 58
 call putch
 add  sp, 2
;-312         i=0;

 mov ax, 0
 mov [bp-4], ax
;-313         while (i < 16) {

.mdump38:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump39
;-314             putch(' ');

 push 32
 call putch
 add  sp, 2
;-315             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-316             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-317             adr++;

 inc  word[bp+4]
;-318             i++;

 inc  word[bp-4]
;-319             j++;

 inc  word[bp-6]
;-320             }

;-321         putch(' ');

 jmp .mdump38
.mdump39:
 push 32
 call putch
 add  sp, 2
;-322         adr -=16;

 sub  word[bp+4], 16
;-323         i=0;

 mov ax, 0
 mov [bp-4], ax
;-324         while(i < 16) {

.mdump40:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump41
;-325             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-326             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump42
 push 46
 call putch
 add  sp, 2
;-327                 else putch(c);

 jmp .mdump43
.mdump42:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-328             adr++;

.mdump43:
 inc  word[bp+4]
;-329             i++;

 inc  word[bp-4]
;-330         }

;-331     }

 jmp .mdump40
.mdump41:
;-332 }

 jmp .mdump35
.mdump36:
;-333 /*

;-334 int makePowerOfTwo(unsigned char c) {

;-335 	if (c ==  2) return 1;

;-336 	if (c ==  4) return 2;

;-337 	if (c ==  8) return 3;

;-338 	if (c == 16) return 4; 

;-339 	if (c == 32) return 5;

;-340 	if (c == 64) return 6;

;-341 	if (c ==128) return 7;

;-342 	return 0;

;-343 }

;-344 */

;-345 //--------------------------------  disk IO  -------------------

;-346 

;-347 int DiskSectorReadWrite(char rw, char drive, char head, int cyl,

 LEAVE
 ret
ENDP

DiskSectorReadWrite: PROC
;-348 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-349 	BIOS_ERR=0;

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;97 var sign byte rw = bp+4
;98 var sign byte drive = bp+6
;99 var sign byte head = bp+8
;100 var sign word cyl = bp+10
;101 var sign byte sector = bp+12
;102 var sign byte count = bp+14
;103 var sign word BufSeg = bp+16
;104 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-350 	dl=drive;

 mov  dl, [bp+6]
;-351 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-352 	es=BufSeg;

 mov  es, [bp+16]
;-353 	bx=BufOfs;

 mov  bx, [bp+18]
;-354 	cx=cyl;

 mov  cx, [bp+10]
;-355 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-356 	cx >> 2;//in 2 high bits of cl

 shr  cx, 2
;-357 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-358 	cl += sector;

 add  cl, [bp+12]
;-359 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-360 	al=count;

 mov  al, [bp+14]
;-361 	ah=rw;

 mov  ah, [bp+4]
;-362 	inth 0x13;

 int  19
;-363     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-364 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-365 }

;-366 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-367 	BIOS_ERR=0;

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;97 var sign byte drive = bp+4
;98 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-368 	dl=drive;

 mov  dl, [bp+4]
;-369 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-370 	inth 0x13;

 int  19
;-371     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-372 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-373 }

;-374 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-375 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-376 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-377 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-378 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-379 }

;-380 int Status(drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Status: PROC
;-381 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;97 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-382 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-383 	BIOS_Status=Int13hfunction(drive, 1);

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-384 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Status44
 call Int13hError
;-385 	printhex16(BIOS_Status);

.Status44:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-386 }

;-387 

;-388 int Params() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

Params: PROC
;-389 	cputs("Get Drive Params ");

 push Params_0
 call cputs
 add  sp, 2
;-390 	BIOS_Status=Int13hfunction(Drive, 8);

 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-391 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params45
;-392 		Int13hError();

 call Int13hError
;-393 		return 1;

 mov ax, 1
 jmp .retnParams
;-394 		}

;-395 	else {

 jmp .Params46
.Params45:
;-396 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-397 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-398 		// CX =       ---CH--- ---CL---

;-399 		// cylinder : 76543210 98

;-400 		// sector   :            543210

;-401 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-402 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-403 //		pa_Sectors++;//1 to 64

;-404 

;-405 		asm mov [pa_Cylinders],    cx

 mov [pa_Cylinders],    cx
;-406 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-407 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-408 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty

 add [pa_Cylinders],    ch;//byte add, low byte is empty
;-409 

;-410 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params47
;-411 			cputs(" no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-412 			return 1;

 mov ax, 1
 jmp .retnParams
;-413 			}

;-414 	}

.Params47:
;-415 	return 0;

.Params46:
 mov ax, 0
 jmp .retnParams
;-416 }

;-417 

;-418 

;-419 int getPartitionData() {

 .retnParams:
 ret
Params_0 db "Get Drive Params ",0
Params_1 db " no hard disk found",0
ENDP

getPartitionData: PROC
;-420 	unsigned int j; char c; char *p;

;-421 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;97 var unsg word j = bp-2
;98 var sign byte c = bp-4
;99 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [pt_PartNo]
 shl ax, 4
 mov [bp-2], ax
;-422 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-423 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-424 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-425 	pt_StartCylinder=(int)pt_StartSector;

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-426 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-427 //	pt_StartSector++;//Sector start with 1 todo

;-428 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-429 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-430 	j++;

 inc  word[bp-2]
;-431 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-432 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-433 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB

;-434 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-435 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-436 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-437 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-438 //	pt_EndSector++;//Sector start with 1 todo

;-439 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-440 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-441 	j++;

 inc  word[bp-2]
;-442 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-443 	j++;

 inc  word[bp-2]
;-444 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-445 	memcpy(&pt_HiddenSector, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-446 }

;-447 

;-448 int checkBootSign() {

 LEAVE
 ret
ENDP

checkBootSign: PROC
;-449 	int i;

;-450 	i=510;

;Function : checkBootSign, Number local Var: 1
; # type sign width local variables
;97 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-451 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign48
;-452 		i++;

 inc  word[bp-2]
;-453 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign49
 mov ax, 1
 jmp .retncheckBootSign
;-454 	}

.checkBootSign49:
;-455 	cputs(" Magic number NOT found.");

.checkBootSign48:
 push checkBootSign_0
 call cputs
 add  sp, 2
;-456 	return 0;

 mov ax, 0
 jmp .retncheckBootSign
;-457 }

;-458 

;-459 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db " Magic number NOT found.",0
ENDP

readMBR: PROC
;-460 	int isFAT;

;-461 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;97 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-462 	pt_PartNo=0;

 mov ax, 0
 mov word [pt_PartNo], ax
;-463 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-464 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR50
;-465 		Int13hError();

 call Int13hError
;-466 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-467 		}

;-468 	else {

 jmp .readMBR51
.readMBR50:
;-469 		putch(10);

 push 10
 call putch
 add  sp, 2
;-470 		cputs("Read partition.");

 push readMBR_0
 call cputs
 add  sp, 2
;-471 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .readMBR52
 mov ax, 0
 jmp .retnreadMBR
;-472 		do {

.readMBR52:
.readMBR53:
;-473 			getPartitionData();

 call getPartitionData
;-474 

;-475 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR54
;-476 				cputs("Boot partition found");

 push readMBR_1
 call cputs
 add  sp, 2
;-477 				if (pt_FileSystem == 1) {

 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR55
;-478 					cputs(", FAT12 partition < 32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-479 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-480 					}

;-481 				if (pt_FileSystem == 4) {

.readMBR55:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR56
;-482 					cputs(", small FAT16 partition < 32MB");

 push readMBR_3
 call cputs
 add  sp, 2
;-483 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-484 					}

;-485 				if (pt_FileSystem == 6) {

.readMBR56:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR57
;-486 					cputs(", large FAT16 partition < 2GB");

 push readMBR_4
 call cputs
 add  sp, 2
;-487 					isFAT=6;

 mov ax, 6
 mov [bp-2], ax
;-488 					}

;-489 				pt_PartNo=99;//end of loop

.readMBR57:
 mov ax, 99
 mov word [pt_PartNo], ax
;-490 			}

;-491 			pt_PartNo ++;

.readMBR54:
 inc  word[pt_PartNo]
;-492 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR58
 jmp .readMBR53
.readMBR58:
;-493 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-494 	}

;-495 }

.readMBR51:
;-496 

;-497 int getBootSector() {

 .retnreadMBR:
 LEAVE
 ret
readMBR_0 db "Read partition.",0
readMBR_1 db "Boot partition found",0
readMBR_2 db ", FAT12 partition < 32MB",0
readMBR_3 db ", small FAT16 partition < 32MB",0
readMBR_4 db ", large FAT16 partition < 2GB",0
ENDP

getBootSector: PROC
;-498 	int i;

;-499 	putch(10);

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;97 var sign word i = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-500 	cputs(" Read boot sector");

 push getBootSector_0
 call cputs
 add  sp, 2
;-501   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

;-502   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-503 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector59
;-504 		Int13hError();

 call Int13hError
;-505 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-506 		}

;-507 	else {

 jmp .getBootSector60
.getBootSector59:
;-508 //		printhex16(BIOS_Status);

;-509 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .getBootSector61
 mov ax, 0
 jmp .retngetBootSector
;-510 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector61:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-511 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector62
 push getBootSector_1
 call cputs
 add  sp, 2
;-512 		i=2;

.getBootSector62:
 mov ax, 2
 mov [bp-2], ax
;-513 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector63
 push getBootSector_2
 call cputs
 add  sp, 2
;-514 	}

.getBootSector63:
;-515 	return 1;

.getBootSector60:
 mov ax, 1
 jmp .retngetBootSector
;-516 }

;-517 

;-518 int FATInit() {

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Read boot sector",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-519 	unsigned long templong;//converting word to dword

;-520 

;-521 	clust_sizeL = (long) bs_clust_size;

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;97 var unsg long templong = bp-4;
 ENTER  4,0
 xor eax, eax
 mov al, [bs_clust_size]
 mov dword [clust_sizeL], eax
;-522 	sector_sizeL= (long) bs_sect_size;

 xor eax, eax
 mov ax, [bs_sect_size]
 mov dword [sector_sizeL], eax
;-523 

;-524 	fat_FatStartSector = bs_res_sects;

 mov ax, [bs_res_sects]
 mov word [fat_FatStartSector], ax
;-525 	fat_FatStartSectorL= (long) fat_FatStartSector; 

 xor eax, eax
 mov ax, [fat_FatStartSector]
 mov dword [fat_FatStartSectorL], eax
;-526 	fat_FatSectors = bs_fat_size;

 mov ax, [bs_fat_size]
 mov word [fat_FatSectors], ax
;-527 	if (bs_num_fats == 2) fat_FatSectors=fat_FatSectors+fat_FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .FATInit64
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-528 

;-529 	fat_RootDirStartSectorL = (long)fat_FatStartSector + fat_FatSectors;

.FATInit64:
 xor eax, eax
 mov ax, [fat_FatStartSector]
 add ax, [fat_FatSectors]
 mov dword [fat_RootDirStartSectorL], eax
;-530 	

;-531 	fat_RootDirSectorsL = (long) bs_root_entr >> 4;//  ./. 16

 xor eax, eax
 mov ax, [bs_root_entr]
 shr ax, 4
 mov dword [fat_RootDirSectorsL], eax
;-532 		

;-533 	fat_DataStartSectorL = fat_RootDirStartSectorL + fat_RootDirSectorsL;

 mov eax, [fat_RootDirStartSectorL]
 add eax, [fat_RootDirSectorsL]
 mov dword [fat_DataStartSectorL], eax
;-534 

;-535 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .FATInit65
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-536 	DataSectors32=bs_tot_sect32 - fat_DataStartSectorL;

.FATInit65:
 mov eax, [bs_tot_sect32]
 sub eax, [fat_DataStartSectorL]
 mov dword [DataSectors32], eax
;-537 

;-538 	CountofClusters=DataSectors32 / clust_sizeL;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [clust_sizeL]
 mov dword [CountofClusters], eax
;-539 

;-540 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-541 	fat_num_tracks = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [fat_num_tracks], eax
;-542 

;-543 	templong = (long) bs_num_heads;

 xor eax, eax
 mov ax, [bs_num_heads]
 mov [bp-4], eax
;-544 	fat_num_cylinders = fat_num_tracks / templong;//w=d/w

 mov eax, [fat_num_tracks]
 xor edx, edx
 div dword [bp-4]
 mov word [fat_num_cylinders], ax
;-545 

;-546 	Sectors_per_cylinder = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinder], eax
;-547 	asm mov [Sectors_per_cylinder + 2], dx;store high word

 mov [Sectors_per_cylinder + 2], dx;store high word
;-548 

;-549 	cputs(", trueFATtype=FAT");

 push FATInit_0
 call cputs
 add  sp, 2
;-550 

;-551 	templong = (long) 65525;

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-552 	if (CountofClusters > templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jle .FATInit66
;-553 		trueFATtype=32;

 mov ax, 32
 mov byte [trueFATtype], al
;-554 		cputs("32 NOT supported");

 push FATInit_1
 call cputs
 add  sp, 2
;-555 		return 1;

 mov ax, 1
 jmp .retnFATInit
;-556 		}

;-557 	templong= (long) 4086;

.FATInit66:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-558 	if (CountofClusters < templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jge .FATInit67
;-559 		trueFATtype=12;

 mov ax, 12
 mov byte [trueFATtype], al
;-560 		cputs("12");

 push FATInit_2
 call cputs
 add  sp, 2
;-561 		return 0;

 mov ax, 0
 jmp .retnFATInit
;-562 		}

;-563 	trueFATtype=16;

.FATInit67:
 mov ax, 16
 mov byte [trueFATtype], al
;-564 	cputs("16");

 push FATInit_3
 call cputs
 add  sp, 2
;-565 	return 0;

 mov ax, 0
 jmp .retnFATInit
;-566 }

;-567 

;-568 int Int13hExt() {

 .retnFATInit:
 LEAVE
 ret
FATInit_0 db ", trueFATtype=FAT",0
FATInit_1 db "32 NOT supported",0
FATInit_2 db "12",0
FATInit_3 db "16",0
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
;-574 //	putch(10);

;-575 //	cputs("Int13h 41h Ext=");	printhex16(vAX);

;-576 //	cputs(", BIOS_Status=");	printhex16(BIOS_Status);

;-577 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt68
;-578 		cputs(" Ext NOT present");

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

 jmp .Int13hExt69
.Int13hExt68:
;-583 		cputs(",Extension found BX(AA55)=");printhex16(vBX);

 push Int13hExt_1
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-584 //		cputs(" CX=");						printhex16(vCX);

;-585 		}

;-586 	return 0;

.Int13hExt69:
 mov ax, 0
 jmp .retnInt13hExt
;-587 }

;-588 

;-589 int PrintDriveParameter() {

 .retnInt13hExt:
 ret
Int13hExt_0 db " Ext NOT present",0
Int13hExt_1 db ",Extension found BX(AA55)=",0
ENDP

PrintDriveParameter: PROC
;-590 	unsigned long Lo;

;-591 // from Params

;-592 	putch(10);

;Function : PrintDriveParameter, Number local Var: 1
; # type sign width local variables
;97 var unsg long Lo = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-593 	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);

 push PrintDriveParameter_0
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-594 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-595 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-596 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-597 	putch('.');

 push 46
 call putch
 add  sp, 2
;-598 //from getPartitionData

;-599 	putch(10);

 push 10
 call putch
 add  sp, 2
;-600 	cputs("getPartitionData:No=");printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-601 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-602 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-603 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-604 	cputs("/");				printunsign(pt_StartSector);

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-605 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-606 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-607 	cputs("/");				printunsign(pt_EndSector);

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-608 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-609 	cputs(",Start=");		printlong(pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 push dword [pt_HiddenSector]
 call printlong
 add  sp, 4
;-610 	cputs(",Len=");			printlong(pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 push dword [pt_PartLen]
 call printlong
 add  sp, 4
;-611 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-612 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-613 	printlong(Lo);

 push dword [bp-4]
 call printlong
 add  sp, 4
;-614 	cputs(" MByte.");

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-615 //from getBootSector

;-616 	putch(10);

 push 10
 call putch
 add  sp, 2
;-617 	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-618 	putch(10);

 push 10
 call putch
 add  sp, 2
;-619 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-620 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-621 	putch(10);

 push 10
 call putch
 add  sp, 2
;-622 	cputs("Reserved sectors=");printunsign(bs_res_sects);

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-623 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-624 	putch(10);

 push 10
 call putch
 add  sp, 2
;-625 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-626 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-627 	putch(10);

 push 10
 call putch
 add  sp, 2
;-628 	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-629 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-630 	putch(10);

 push 10
 call putch
 add  sp, 2
;-631 	cputs("sectors per track=");printunsign(bs_sectors_per_track);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_sectors_per_track]
 call printunsign
 add  sp, 2
;-632 	cputs(".number of heads=");printunsign(bs_num_heads);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_heads]
 call printunsign
 add  sp, 2
;-633 	putch(10);

 push 10
 call putch
 add  sp, 2
;-634 	cputs("hidden sectors(long)=");printlong(bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 push dword [bs_hid_sects]
 call printlong
 add  sp, 4
;-635 	cputs(".sectors(long)=");printlong(bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 push dword [bs_tot_sect32]
 call printlong
 add  sp, 4
;-636 	putch(10);

 push 10
 call putch
 add  sp, 2
;-637 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-638 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-639 	putch(10);

 push 10
 call putch
 add  sp, 2
;-640 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-641 	cputs(".Volume serial(long)=");printlong(bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 push dword [bs_serial_num]
 call printlong
 add  sp, 4
;-642 	putch(10);

 push 10
 call putch
 add  sp, 2
;-643 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-644 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-645 //from FATInit

;-646 	putch(10);

 push 10
 call putch
 add  sp, 2
;-647 	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [fat_FatStartSector]
 call printunsign
 add  sp, 2
;-648 	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [fat_FatSectors]
 call printunsign
 add  sp, 2
;-649 	putch(10);

 push 10
 call putch
 add  sp, 2
;-650 	cputs("fat_RootDirStartSectorL="); printlong(fat_RootDirStartSectorL);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push dword [fat_RootDirStartSectorL]
 call printlong
 add  sp, 4
;-651 	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectorsL);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push dword [fat_RootDirSectorsL]
 call printunsign
 add  sp, 4
;-652 	putch(10);

 push 10
 call putch
 add  sp, 2
;-653 	cputs("fat_DataStartSectorL=");	printunsign(fat_DataStartSectorL);

 push PrintDriveParameter_38
 call cputs
 add  sp, 2
 push dword [fat_DataStartSectorL]
 call printunsign
 add  sp, 4
;-654 	cputs(", DataSectors32=");	printlong(DataSectors32);

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 push dword [DataSectors32]
 call printlong
 add  sp, 4
;-655 	putch(10);

 push 10
 call putch
 add  sp, 2
;-656 	cputs("CountofClusters=");	printlong(CountofClusters);

 push PrintDriveParameter_40
 call cputs
 add  sp, 2
 push dword [CountofClusters]
 call printlong
 add  sp, 4
;-657 	cputs(", Sectors_per_cylinder="); printlong(Sectors_per_cylinder);

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 push dword [Sectors_per_cylinder]
 call printlong
 add  sp, 4
;-658 	putch(10);

 push 10
 call putch
 add  sp, 2
;-659 	cputs("fat_num_tracks=");	printlong(fat_num_tracks);

 push PrintDriveParameter_42
 call cputs
 add  sp, 2
 push dword [fat_num_tracks]
 call printlong
 add  sp, 4
;-660 	cputs(", fat_num_cylinders="); printunsign(fat_num_cylinders);

 push PrintDriveParameter_43
 call cputs
 add  sp, 2
 push word [fat_num_cylinders]
 call printunsign
 add  sp, 2
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
;97 ptr sign byte s = bp+4;
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
;97 var unsg long SectorL = bp+4
;98 var unsg word track = bp-2
;99 var unsg word head = bp-4
;100 var unsg word sect = bp-6;
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

;-683 

;-684 // 2.a

;-685 int printDirEntry() {

 LEAVE
 ret
ENDP

printDirEntry: PROC
;-686     unsigned int j;

;-687 	putch(10);

;Function : printDirEntry, Number local Var: 1
; # type sign width local variables
;97 var unsg word j = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-688 	cputs(filename);

 lea  ax, [filename]
 push ax
 call cputs
 add  sp, 2
;-689 	cputs(" ATTR:");

 push printDirEntry_0
 call cputs
 add  sp, 2
;-690 	printhex8(dir_Attrib);	

 mov al, byte [dir_Attrib]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-691 	if (dir_Attrib &  1) cputs(" r/o");

 mov al, [dir_Attrib]
 and al, 1
 or  al, al
 je .printDirEntry70
 push printDirEntry_1
 call cputs
 add  sp, 2
;-692 	if (dir_Attrib &  2) cputs(" hid");

.printDirEntry70:
 mov al, [dir_Attrib]
 and al, 2
 or  al, al
 je .printDirEntry71
 push printDirEntry_2
 call cputs
 add  sp, 2
;-693 	if (dir_Attrib &  4) cputs(" sys");

.printDirEntry71:
 mov al, [dir_Attrib]
 and al, 4
 or  al, al
 je .printDirEntry72
 push printDirEntry_3
 call cputs
 add  sp, 2
;-694 	if (dir_Attrib &  8) cputs(" vol");		

.printDirEntry72:
 mov al, [dir_Attrib]
 and al, 8
 or  al, al
 je .printDirEntry73
 push printDirEntry_4
 call cputs
 add  sp, 2
;-695 	if (dir_Attrib & 16) cputs(" dir");

.printDirEntry73:
 mov al, [dir_Attrib]
 and al, 16
 or  al, al
 je .printDirEntry74
 push printDirEntry_5
 call cputs
 add  sp, 2
;-696 	if (dir_Attrib & 32) cputs(" arc");

.printDirEntry74:
 mov al, [dir_Attrib]
 and al, 32
 or  al, al
 je .printDirEntry75
 push printDirEntry_6
 call cputs
 add  sp, 2
;-697 	if (dir_Attrib == 0) cputs("    ");

.printDirEntry75:
 mov al, [dir_Attrib]
 cmp al, 0
 jne .printDirEntry76
 push printDirEntry_7
 call cputs
 add  sp, 2
;-698 	

;-699 	putch(' ');

.printDirEntry76:
 push 32
 call putch
 add  sp, 2
;-700 	j=dir_LastModDate & 31;//day

 mov ax, [dir_LastModDate]
 and ax, 31
 mov [bp-2], ax
;-701 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry77
 push 32
 call putch
 add  sp, 2
;-702 	printunsign(j);

.printDirEntry77:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-703 	putch('.');

 push 46
 call putch
 add  sp, 2
;-704 

;-705 	j=dir_LastModDate >> 5;//month

 mov ax, [dir_LastModDate]
 shr ax, 5
 mov [bp-2], ax
;-706 	j&=  15;

 and  word[bp-2], 15
;-707 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry78
 push 48
 call putch
 add  sp, 2
;-708 	printunsign(j);

.printDirEntry78:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-709 	putch('.');

 push 46
 call putch
 add  sp, 2
;-710 

;-711 	j=dir_LastModDate >> 9;//year

 mov ax, [dir_LastModDate]
 shr ax, 9
 mov [bp-2], ax
;-712 	j+= 1980;

 add  word[bp-2], 1980
;-713 	printunsign(j);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-714 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-715 	//putch(' ');

;-716 

;-717 	j=dir_LastModTime  >>11;//hour

 mov ax, [dir_LastModTime]
 shr ax, 11
 mov [bp-2], ax
;-718 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry79
 push 32
 call putch
 add  sp, 2
;-719 	printunsign(j);

.printDirEntry79:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-720 	putch(':');

 push 58
 call putch
 add  sp, 2
;-721 

;-722 	j=dir_LastModTime  >> 5;//minute

 mov ax, [dir_LastModTime]
 shr ax, 5
 mov [bp-2], ax
;-723 	j&=  63;

 and  word[bp-2], 63
;-724 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry80
 push 48
 call putch
 add  sp, 2
;-725 	printunsign(j);

.printDirEntry80:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-726 	putch(':');

 push 58
 call putch
 add  sp, 2
;-727 

;-728 	j=dir_LastModTime & 31;// 2 seconds

 mov ax, [dir_LastModTime]
 and ax, 31
 mov [bp-2], ax
;-729 	j=j+j;

 mov ax, [bp-2]
 add ax, [bp-2]
 mov [bp-2], ax
;-730 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry81
 push 48
 call putch
 add  sp, 2
;-731 	printunsign(j);

.printDirEntry81:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-732 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-733 

;-734 	cputs(" 1.Cl:"); 

 push printDirEntry_8
 call cputs
 add  sp, 2
;-735 	printunsign(dir_FirstCluster);

 push word [dir_FirstCluster]
 call printunsign
 add  sp, 2
;-736 	cputs(" Size:");

 push printDirEntry_9
 call cputs
 add  sp, 2
;-737 	printlong(dir_FileSize);

 push dword [dir_FileSize]
 call printlong
 add  sp, 4
;-738 	

;-739 }

;-740 

;-741 // 2.b

;-742 int fatDirSectorList(unsigned long startSector, unsigned long numsectors) {

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
;-743     char *p;

;-744 	unsigned int EndDiskBuf;

;-745 	char isHide;//shows entries, NOT lfn, deleted or empty

;-746 	

;-747 	do {

;Function : fatDirSectorList, Number local Var: 5
; # type sign width local variables
;97 var unsg long startSector = bp+4
;98 var unsg long numsectors = bp+8
;99 ptr sign byte p = bp-2
;100 var unsg word EndDiskBuf = bp-4
;101 var sign byte isHide = bp-6;
 ENTER  6,0
.fatDirSectorList82:
;-748 /*		putch(10);

;-749 		cputs("Sektor = "); 

;-750 		printlong(startSector);

;-751 		cputs(", numsectors = "); 

;-752 		printunsign(numsectors);

;-753 		getkey();

;-754 */

;-755 		readLogical(startSector);

 push dword [bp+4]
 call readLogical
 add  sp, 4
;-756 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-757 		EndDiskBuf= p + bs_sect_size;		

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-758 		

;-759 		do {

.fatDirSectorList83:
;-760 			memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-761 			memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-762 			filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-763 			

;-764 			isHide=0;//show in listing

 mov ax, 0
 mov [bp-6], al
;-765 			if (*p ==    0) {//only empty entries following

 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorList84
;-766 				isHide++;

 inc  byte[bp-6]
;-767 				numsectors=1;//finish searching

 mov ax, 1
 mov [bp+8], eax
;-768 				p = EndDiskBuf;

 mov ax, [bp-4]
 mov [bp-2], ax
;-769 				}

;-770 			if (*p == 0xE5) isHide++;//deleted, free entry

.fatDirSectorList84:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 229
 jne .fatDirSectorList85
 inc  byte[bp-6]
;-771 			if (*p <=   31) isHide++;//part of LFN

.fatDirSectorList85:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 31
 jg  .fatDirSectorList86
 inc  byte[bp-6]
;-772 			if (dir_Attrib ==    15) isHide++;//LFN start

.fatDirSectorList86:
 mov al, [dir_Attrib]
 cmp al, 15
 jne .fatDirSectorList87
 inc  byte[bp-6]
;-773 					

;-774 			if (isHide == 0) printDirEntry();

.fatDirSectorList87:
 mov al, [bp-6]
 cmp al, 0
 jne .fatDirSectorList88
 call printDirEntry
;-775 			p+=32;//get next entry

.fatDirSectorList88:
 add  word[bp-2], 32
;-776 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorList89
 jmp .fatDirSectorList83
.fatDirSectorList89:
;-777 		startSector = startSector + 1;//long, do NOT use ++ or +=1

 mov eax, [bp+4]
 add eax, 1
 mov [bp+4], eax
;-778 		numsectors--;

 dec  dword[bp+8]
;-779 //mdump(DiskBuf, 512);

;-780 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorList90
 jmp .fatDirSectorList82
.fatDirSectorList90:
;-781 	fatfile_cluster=0;//not found but not end

 mov ax, 0
 mov word [fatfile_cluster], ax
;-782 }

;-783 

;-784 // 2.

;-785 int fatDirSectorSearch(unsigned long startSector, unsigned long numsectors) {

 LEAVE
 ret
ENDP

fatDirSectorSearch: PROC
;-786     //search for file name. IN:searchstr

;-787     char *p;

;-788 	unsigned int EndDiskBuf;

;-789 	fat_notfound=0;	

;Function : fatDirSectorSearch, Number local Var: 4
; # type sign width local variables
;97 var unsg long startSector = bp+4
;98 var unsg long numsectors = bp+8
;99 ptr sign byte p = bp-2
;100 var unsg word EndDiskBuf = bp-4;
 ENTER  4,0
 mov ax, 0
 mov word [fat_notfound], ax
;-790 	do {

.fatDirSectorSearch91:
;-791 		readLogical(startSector);

 push dword [bp+4]
 call readLogical
 add  sp, 4
;-792 		p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-2], ax
;-793 		EndDiskBuf= p + bs_sect_size;

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-794 		do {

.fatDirSectorSearch92:
;-795 			if (memcmp(p, searchstr, 11) == 0) {//found file name

 push 11
 lea  ax, [searchstr]
 push ax
 push word [bp-2]
 call memcmp
 add  sp, 6
 cmp ax, 0
 jne .fatDirSectorSearch93
;-796 				memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-797 				memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-798 				filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-799 				fatfile_cluster   = dir_FirstCluster;

 mov ax, [dir_FirstCluster]
 mov word [fatfile_cluster], ax
;-800 				fatfile_fileSize  = dir_FileSize;

 mov eax, [dir_FileSize]
 mov dword [fatfile_fileSize], eax
;-801 //				fatfile_Attr      = dir_Attrib;

;-802 //				fatfile_LastModTime= dir_LastModTime;

;-803 //				fatfile_LastModDate= dir_LastModDate;

;-804 				printDirEntry();

 call printDirEntry
;-805 			}

;-806 			if (*p == 0) {//only empty entries following

.fatDirSectorSearch93:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorSearch94
;-807 					fat_notfound=1;

 mov ax, 1
 mov word [fat_notfound], ax
;-808 					return;

 jmp .retnfatDirSectorSearch
;-809 				}

;-810 			p+=32;//get next entry

.fatDirSectorSearch94:
 add  word[bp-2], 32
;-811 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorSearch95
 jmp .fatDirSectorSearch92
.fatDirSectorSearch95:
;-812 		startSector++;		

 inc  dword[bp+4]
;-813 		numsectors--;

 dec  dword[bp+8]
;-814 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorSearch96
 jmp .fatDirSectorSearch91
.fatDirSectorSearch96:
;-815 	fatfile_cluster=0;//not found but not end

 mov ax, 0
 mov word [fatfile_cluster], ax
;-816 }

;-817 

;-818 // 3.

;-819 int fatRootSearch() {

 .retnfatDirSectorSearch:
 LEAVE
 ret
ENDP

fatRootSearch: PROC
;-820 	memcpy(&searchstr, "DOS     COM", 11);//only for test

 push 11
 push fatRootSearch_0
 lea  ax, [searchstr]
 push ax
 call memcpy
 add  sp, 6
;-821     fatDirSectorSearch(fat_RootDirStartSectorL, fat_RootDirSectorsL);

 push dword [fat_RootDirSectorsL]
 push dword [fat_RootDirStartSectorL]
 call fatDirSectorSearch
 add  sp, 8
;-822 //	getkey();

;-823 //    fatDirSectorList(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-824 }

;-825 

;-826 // 4.

;-827 int fatClusterAnalyse(unsigned int cluster) {

 ret
fatRootSearch_0 db "DOS     COM",0
ENDP

fatClusterAnalyse: PROC
;-828 //OUT: fatfile_sectorStartL, fatfile_nextCluster

;-829 	unsigned long fatSectorL;

;-830 	unsigned int offset;

;-831 	char *p;

;-832 	

;-833 	fatfile_sectorStartL = (long) cluster - 2;

;Function : fatClusterAnalyse, Number local Var: 4
; # type sign width local variables
;97 var unsg word cluster = bp+4
;98 var unsg long fatSectorL = bp-4
;99 var unsg word offset = bp-6
;100 ptr sign byte p = bp-8;
 ENTER  8,0
 xor eax, eax
 mov ax, [bp+4]
 sub ax, 2
 mov dword [fatfile_sectorStartL], eax
;-834 	fatfile_sectorStartL = fatfile_sectorStartL * clust_sizeL;

 mov eax, [fatfile_sectorStartL]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul dword [clust_sizeL]
 mov dword [fatfile_sectorStartL], eax
;-835 	fatfile_sectorStartL = fatfile_sectorStartL + fat_DataStartSectorL;

 mov eax, [fatfile_sectorStartL]
 add eax, [fat_DataStartSectorL]
 mov dword [fatfile_sectorStartL], eax
;-836 	

;-837 	fatSectorL = (long) cluster + cluster;

 xor eax, eax
 mov ax, [bp+4]
 add ax, [bp+4]
 mov [bp-4], eax
;-838 	fatSectorL = fatSectorL / sector_sizeL;		

 mov eax, [bp-4]
 xor edx, edx
 div dword [sector_sizeL]
 mov [bp-4], eax
;-839 	fatSectorL = fatSectorL + fat_FatStartSectorL; 

 mov eax, [bp-4]
 add eax, [fat_FatStartSectorL]
 mov [bp-4], eax
;-840 

;-841 	readLogical(fatSectorL);

 push dword [bp-4]
 call readLogical
 add  sp, 4
;-842 	

;-843 	offset = cluster + cluster;

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
;-848 	memcpy(&fatfile_nextCluster, p, 2);

 push 2
 push word [bp-8]
 lea  ax, [fatfile_nextCluster]
 push ax
 call memcpy
 add  sp, 6
;-849 }

;-850 

;-851 // 5.

;-852 int fatDirSearch() {//search a directory chain. IN:searchstr

 LEAVE
 ret
ENDP

fatDirSearch: PROC
;-853 	

;-854 	fatClusterAnalyse(fatfile_cluster);

 push word [fatfile_cluster]
 call fatClusterAnalyse
 add  sp, 2
;-855 	//OUT: fatfile_sectorStartL, fatfile_nextCluster

;-856 

;-857 	fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster); 

 push word [fatfile_nextCluster]
 push dword [fatfile_sectorStartL]
 call fatDirSectorSearch
 add  sp, 6
;-858 	while (fatfile_cluster == 0) {//not found but not end

.fatDirSearch97:
 mov ax, [fatfile_cluster]
 cmp ax, 0
 jne .fatDirSearch98
;-859 		if (fatfile_nextCluster >= 0xFFF8) {

 mov ax, [fatfile_nextCluster]
 cmp ax, 65528 ;unsigned : 0
 jb  .fatDirSearch99
;-860 			fat_notfound=1;

 mov ax, 1
 mov word [fat_notfound], ax
;-861 			return;	

 jmp .retnfatDirSearch
;-862 		}		

;-863 		fatfile_cluster=fatfile_nextCluster;

.fatDirSearch99:
 mov ax, [fatfile_nextCluster]
 mov word [fatfile_cluster], ax
;-864 		fatClusterAnalyse(fatfile_cluster);

 push word [fatfile_cluster]
 call fatClusterAnalyse
 add  sp, 2
;-865 		fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster);

 push word [fatfile_nextCluster]
 push dword [fatfile_sectorStartL]
 call fatDirSectorSearch
 add  sp, 6
;-866 	}	

;-867 

;-868 }

 jmp .fatDirSearch97
.fatDirSearch98:
;-869 

;-870 

;-871 

;-872 int fatNextSearch(/*char *searchstr, */ char *upto, int *last) {

 .retnfatDirSearch:
 ret
ENDP

fatNextSearch: PROC
;-873 //todo parameter must be:    char **upto

;-874 

;-875 

;-876 }

;Function : fatNextSearch, Number local Var: 2
; # type sign width local variables
;97 ptr sign byte upto = bp+4
;98 ptr sign word last = bp+6;
 ENTER  0,0
;-877 

;-878 int fatGetStartCluster() {

 LEAVE
 ret
ENDP

fatGetStartCluster: PROC
;-879 	char *upto;

;-880 	int last;

;-881 

;-882 	if (fat_notfound) return;

;Function : fatGetStartCluster, Number local Var: 2
; # type sign width local variables
;97 ptr sign byte upto = bp-2
;98 var sign word last = bp-4;
 ENTER  4,0
 mov ax, [fat_notfound]
 or  al, al
 je .fatGetStartCluster100
 jmp .retnfatGetStartCluster
;-883 	*upto = filename;

.fatGetStartCluster100:
 mov al, [filename]
 mov  bx, [bp-2]
 mov  [bx], al
;-884 	fatfile_cluster = 0;

 mov ax, 0
 mov word [fatfile_cluster], ax
;-885 

;-886 	fatNextSearch(searchstr, &upto, &last);

 lea  ax, [bp-4]
 push ax
 lea  ax, [bp-2]
 push ax
 lea  ax, [searchstr]
 push ax
 call fatNextSearch
 add  sp, 6
;-887 

;-888 }

;-889 

;-890 int fatOpenFile() {//remove backslash, set handle for root or subdir

 .retnfatGetStartCluster:
 LEAVE
 ret
ENDP

fatOpenFile: PROC
;-891 	unsigned long bytes_per_cluster;

;-892 	fat_notfound=0;

;Function : fatOpenFile, Number local Var: 1
; # type sign width local variables
;97 var unsg long bytes_per_cluster = bp-4;
 ENTER  4,0
 mov ax, 0
 mov word [fat_notfound], ax
;-893 	if (filename[0] == 0) {//empty filename

 mov al, [filename]
 cmp al, 0
 jne .fatOpenFile101
;-894 		fatfile_root = 1;

 mov ax, 1
 mov word [fatfile_root], ax
;-895 		fatfile_nextCluster = 0xFFFF;

 mov ax, 65535
 mov word [fatfile_nextCluster], ax
;-896 		fatfile_sectorCount = fat_RootDirSectorsL;

 mov eax, [fat_RootDirSectorsL]
 mov word [fatfile_sectorCount], ax
;-897 		fatfile_sectorStartL = fat_RootDirStartSectorL;

 mov eax, [fat_RootDirStartSectorL]
 mov dword [fatfile_sectorStartL], eax
;-898 		fatfile_lastBytes   = 0;

 mov ax, 0
 mov word [fatfile_lastBytes], ax
;-899 		fatfile_lastSectors = fat_RootDirSectorsL;

 mov eax, [fat_RootDirSectorsL]
 mov word [fatfile_lastSectors], ax
;-900 		fatfile_cluster     = 0;

 mov ax, 0
 mov word [fatfile_cluster], ax
;-901 		fatfile_dir         = 1;

 mov ax, 1
 mov word [fatfile_dir], ax
;-902 

;-903 	} else {//search in subdir

 jmp .fatOpenFile102
.fatOpenFile101:
;-904 		fatfile_root = 0;

 mov ax, 0
 mov word [fatfile_root], ax
;-905 		fatGetStartCluster();

 call fatGetStartCluster
;-906 		if (fat_notfound) return 1;

 mov ax, [fat_notfound]
 or  al, al
 je .fatOpenFile103
 mov ax, 1
 jmp .retnfatOpenFile
;-907 		bytes_per_cluster   = (long) bs_clust_size * bs_sect_size;

.fatOpenFile103:
 xor eax, eax
 mov al, [bs_clust_size]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_sect_size]
 mov [bp-4], eax
;-908 		fatfile_lastBytes   = fatfile_fileSize % bytes_per_cluster;

 mov eax, [fatfile_fileSize]
 xor edx, edx
 div dword [bp-4]
 mov eax, edx
 mov word [fatfile_lastBytes], ax
;-909 		fatfile_lastSectors = fatfile_lastBytes / bs_sect_size;

 mov ax, [fatfile_lastBytes]
 xor dx, dx
 div word [bs_sect_size]
 mov word [fatfile_lastSectors], ax
;-910 		fatfile_lastBytes   = fatfile_lastBytes % bs_sect_size;

 mov ax, [fatfile_lastBytes]
 xor dx, dx
 div word [bs_sect_size]
 mov ax, dx
 mov word [fatfile_lastBytes], ax
;-911 		if (fatfile_fileSize == 0) fatfile_dir = 1;

 mov eax, [fatfile_fileSize]
 cmp eax, 0
 jne .fatOpenFile104
 mov ax, 1
 mov word [fatfile_dir], ax
;-912 		else                       fatfile_dir = 0;

 jmp .fatOpenFile105
.fatOpenFile104:
 mov ax, 0
 mov word [fatfile_dir], ax
;-913 

;-914 //		fatClusterAnalyse();

;-915 		fatfile_sectorCount = (int) bs_clust_size;

.fatOpenFile105:
 xor ax, ax
 mov al, [bs_clust_size]
 mov word [fatfile_sectorCount], ax
;-916 

;-917 	}

;-918 	fatfile_currentCluster = fatfile_cluster;

.fatOpenFile102:
 mov ax, [fatfile_cluster]
 mov word [fatfile_currentCluster], ax
;-919 	fatfile_sectorUpto = 0;

 mov ax, 0
 mov word [fatfile_sectorUpto], ax
;-920 	fatfile_byteUpto   = 0;

 mov ax, 0
 mov word [fatfile_byteUpto], ax
;-921 	if (fat_notfound) return 1;

 mov ax, [fat_notfound]
 or  al, al
 je .fatOpenFile106
 mov ax, 1
 jmp .retnfatOpenFile
;-922 	return 0;

.fatOpenFile106:
 mov ax, 0
 jmp .retnfatOpenFile
;-923 }

;-924 

;-925 int make_filename() {

 .retnfatOpenFile:
 LEAVE
 ret
ENDP

make_filename: PROC
;-926 	char *p;

;-927 	toupper(&filename);

;Function : make_filename, Number local Var: 1
; # type sign width local variables
;97 ptr sign byte p = bp-2;
 ENTER  2,0
 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-928 	p = strchr(filename, ':' );

 push 58
 lea  ax, [filename]
 push ax
 call strchr
 add  sp, 4
 mov [bp-2], ax
;-929 //	if (p == 0) fat_drive = fat_currentdrive;

;-930 //	else error2("drive, patth not impl. yet");

;-931 

;-932 }

;-933 

;-934 int fileOpen() {//remove drive letter and insert in drive

 LEAVE
 ret
ENDP

fileOpen: PROC
;-935 	int rc;

;-936 	strcpy(filename, "dos.com");

;Function : fileOpen, Number local Var: 1
; # type sign width local variables
;97 var sign word rc = bp-2;
 ENTER  2,0
 push fileOpen_0
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-937 

;-938 	make_filename();

 call make_filename
;-939 	rc=fatOpenFile();

 call fatOpenFile
 mov [bp-2], ax
;-940 	if (rc) return 0;//error

 mov ax, [bp-2]
 or  al, al
 je .fileOpen107
 mov ax, 0
 jmp .retnfileOpen
;-941 //	else return fhandle;

;-942 }

.fileOpen107:
;-943 

;-944 //------------------------------- Init,  main ---------------

;-945 int Init() {

 .retnfileOpen:
 LEAVE
 ret
fileOpen_0 db "dos.com",0
ENDP

Init: PROC
;-946 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-947 

;-948 	if (Params()) cputs("** NO DRIVE PARAMS FOUND **");//no hard disk

 call Params
 or  al, al
 je .Init108
 push Init_0
 call cputs
 add  sp, 2
;-949 	FATtype=readMBR();//0=error,1=FAT12,6=FAT16,11=FAT32

.Init108:
 call readMBR
 mov word [FATtype], ax
;-950 	if (FATtype == 0) {

 mov ax, [FATtype]
 cmp ax, 0
 jne .Init109
;-951 		cputs(" no active FAT partition found. ");

 push Init_1
 call cputs
 add  sp, 2
;-952 //		return 1;

;-953 		}

;-954 	if(getBootSector()==0) 	return 1;

.Init109:
 call getBootSector
 cmp ax, 0
 jne .Init110
 mov ax, 1
 jmp .retnInit
;-955 	if (FATInit())			return 1;

.Init110:
 call FATInit
 or  al, al
 je .Init111
 mov ax, 1
 jmp .retnInit
;-956 	if(trueFATtype != 16) 	return 1;

.Init111:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init112
 mov ax, 1
 jmp .retnInit
;-957 	Int13hExt();

.Init112:
 call Int13hExt
;-958 	return 0;

 mov ax, 0
 jmp .retnInit
;-959 }

;-960 

;-961 //	unsigned long Sector_to_read;

;-962 int main() {

 .retnInit:
 ret
Init_0 db "** NO DRIVE PARAMS FOUND **",0
Init_1 db " no active FAT partition found. ",0
ENDP

main: PROC
;-963 //	char c;

;-964 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-965 	if (Init() != 0) return 1;

 call Init
 cmp al, 0
 je  .main113
 mov ax, 1
 jmp .retnmain
;-966 //	PrintDriveParameter();

;-967 //	getkey();

;-968 	//	Sector_to_read = (long) 0;

;-969 //	readLogical( Sector_to_read);

;-970 

;-971 	fatRootSearch();

.main113:
 call fatRootSearch
;-972 //putch(10);

;-973 //c=2; printunsign(c); c=makePowerOfTwo(c); cputs(" two:");printunsign(c);

;-974 //c=makePowerOfTwo2(c); cputs(" two2:");printunsign(c);

;-975 }

 .retnmain:
 ret
ENDP
;Glob. variables:96 (400):1254 (4000), Functions:51 (300):530 (3000)
;Lines:976, Constant: 2120 (4000), stacksize: 48559