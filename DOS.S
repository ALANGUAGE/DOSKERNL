;A.COM V1.1.4, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.2.4";//test bed

Version1 db "DOS.COM V0.2.4",0
;-2 /*	Finder /hg/DOS/DOS3.vhd

;-3 	rigth click / open / Parallels Mounter

;-4 	(E)DX:(E)AX DIV r/m16(32) = (E)AX, remainder (E)DX

;-5 	AL*r/m8=AX; AX*r/m16=DX:AX; EAX*r/m32=EDX:EAX

;-6 	> 16.777.216 sectors (8GB) only LBA

;-7 */

;-8 /*todo:

;-9 	read subdir, Line 1018

;-10 	read root dir

;-11 	lseek 42h

;-12 	mkdir 39h

;-13 	write file 40h

;-14 	create file 3Ch

;-15 */

;-16 #define ORGDATA		16384//=16K start of arrays

;-17 #define debug 1

;-18 unsigned int vAX ;unsigned int vBX ;unsigned int vCX; unsigned int vDX;

vAX dw 0
vBX dw 0
vCX dw 0
vDX dw 0
;-19 unsigned int vSP; unsigned int vBP; unsigned int vCS; unsigned int vDS;

vSP dw 0
vBP dw 0
vCS dw 0
vDS dw 0
;-20 unsigned int vSS; unsigned int vES; //debugging

vSS dw 0
vES dw 0
;-21 

;-22 unsigned char DOS_ERR;

DOS_ERR db 0
;-23 unsigned char BIOS_ERR;

BIOS_ERR db 0
;-24 unsigned int  BIOS_Status;

BIOS_Status dw 0
;-25 unsigned int  DiskBufSeg;

DiskBufSeg dw 0
;-26 unsigned char dummy1[1];//todo remove

section .bss
absolute 16384
dummy1 resb 1
section .text
;-27 unsigned char filename[67];

section .bss
absolute 16385
filename resb 67
section .text
;-28 unsigned char searchstr  [12];//with null

section .bss
absolute 16452
searchstr resb 12
section .text
;-29 unsigned char DiskBuf [512];

section .bss
absolute 16464
DiskBuf resb 512
section .text
;-30 unsigned char Drive=0x80;

Drive db 128
;-31 unsigned long clust_sizeL;

clust_sizeL dd 0
;-32 unsigned long sector_sizeL;

sector_sizeL dd 0
;-33 unsigned int  BytesAreRead;

BytesAreRead dw 0
;-34 unsigned long Sector;

Sector dd 0
;-35 

;-36 char *upto;		//IN:part of filename to search/OUT:to search next time

upto dw 0
;-37 char isfilename;//0=part of directory or 1=filename

isfilename db 0
;-38 #define BUFFERSIZE 35000

;-39 unsigned char Buffer [BUFFERSIZE];

section .bss
absolute 16976
Buffer resb 35000
section .text
;-40 char *BufferPtr;

BufferPtr dw 0
;-41 

;-42 //start array of handles of every open file

;-43 unsigned int  CurrentCluster;

CurrentCluster dw 0
;-44 unsigned int  NextCluster;

NextCluster dw 0
;-45 unsigned long StartSectorL;		//start sector in current cluster

StartSectorL dd 0
;-46 unsigned long FileSizeL;

FileSizeL dd 0
;-47 unsigned int  lastBytes;		//resting bytes in a sector

lastBytes dw 0
;-48 unsigned int  lastSectors;		//resting sectors in a cluster

lastSectors dw 0
;-49 unsigned int  sectorUpto;		//??

sectorUpto dw 0
;-50 unsigned int  byteUpto;			//??

byteUpto dw 0
;-51 

;-52 unsigned int  CurPosition;		//current byte location in cur sector

CurPosition dw 0
;-53 unsigned long FilePointerL;		//current byte location in file

FilePointerL dd 0
;-54 //	end array of handles of every open file

;-55 

;-56 //FATInit

;-57 unsigned int  fat_FatStartSector;

fat_FatStartSector dw 0
;-58 unsigned long fat_FatStartSectorL;

fat_FatStartSectorL dd 0
;-59 unsigned int  fat_FatSectors;

fat_FatSectors dw 0
;-60 unsigned int  fat_Entries;

fat_Entries dw 0
;-61 unsigned long fat_RootDirStartSectorL;

fat_RootDirStartSectorL dd 0
;-62 unsigned long fat_RootDirSectorsL;

fat_RootDirSectorsL dd 0
;-63 unsigned long fat_DataStartSectorL;

fat_DataStartSectorL dd 0
;-64 unsigned long num_tracksL;

num_tracksL dd 0
;-65 unsigned long Sectors_per_cylinderL;

Sectors_per_cylinderL dd 0
;-66 unsigned long DataSectors32;

DataSectors32 dd 0
;-67 unsigned long CountofClustersL;

CountofClustersL dd 0
;-68 unsigned char trueFATtype;	//12, 16, 32 from FATInit

trueFATtype db 0
;-69 unsigned long bytes_per_clusterL;

bytes_per_clusterL dd 0
;-70 

;-71 //Params from int13h, Function 8

;-72 unsigned int  pa_Cylinders;

pa_Cylinders dw 0
;-73 unsigned char pa_Sectors;

pa_Sectors db 0
;-74 unsigned char pa_Heads;

pa_Heads db 0
;-75 unsigned char pa_Attached;

pa_Attached db 0
;-76 unsigned int  pt_PartNo;

pt_PartNo dw 0
;-77 

;-78 //start hard disk partition structure 16 bytes in MBR. do not change!!!!!

;-79 unsigned char pt_Bootable;		// 00 80h = active partition, else 00

pt_Bootable db 0
;-80 unsigned char pt_StartHead;		// 01

pt_StartHead db 0
;-81 unsigned char pt_StartSector;	// 02 bits 0-5

pt_StartSector db 0
;-82 unsigned int  pt_StartCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-83 unsigned char pt_FileSystem;	// 04 0=nu,1=FAT12,4=16,5=ExtP,6=large16

pt_FileSystem db 0
;-84 unsigned char pt_EndHead;		// 05

pt_EndHead db 0
;-85 unsigned char pt_EndSector;		// 06 bits 0-5

pt_EndSector db 0
;-86 unsigned int  pt_EndCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-87 unsigned long pt_HiddenSector;	// 08 sectors preceding partition

pt_HiddenSector dd 0
;-88 unsigned long pt_PartLen;    	// 12 length of partition in sectors

pt_PartLen dd 0
;-89 //  16 end hard disk partition structure

;-90 

;-91 //start boot BIOS Parameter Block structure. do not change!!!!!

;-92 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-93 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-94 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-95 unsigned char bs_clust_size;// 13 sectors per CurrentCluster (1,2,4,..,128)

bs_clust_size db 0
;-96 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-97 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-98 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-99 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-100 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-101 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-102 unsigned int  bs_sectors_per_track; // 24 (DOS 3+)sectors per track

bs_sectors_per_track dw 0
;-103 unsigned int  bs_num_heads;	// 26 (DOS 3+)number of heads

bs_num_heads dw 0
;-104 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors

bs_hid_sects dd 0
;-105 unsigned long bs_tot_sect32;// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-106 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-107 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-108 unsigned char bs_ext_signat;// 38 (DOS 4+) Ext. signature,get next 3(29h)

bs_ext_signat db 0
;-109 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-110 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-111 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-112 // 62 end boot BIOS Parameter Block

;-113 

;-114 //start directory entry structure, do not change!!!!!

;-115 unsigned char dir_Filename[]="1234567";	//00 +lengthbyte=11

dir_Filename db "1234567",0
;-116 unsigned char dir_Ext[]="12";	//07 +lengthbyte=3

dir_Ext db "12",0
;-117 unsigned char dir_Attrib;		//11 directory=10h, Label=08h, read only=1

dir_Attrib db 0
;-118 unsigned char dir_NTReserved;	//12 low case in body=8h, in ext=10h

dir_NTReserved db 0
;-119 unsigned char dir_TimeCreatedMS;//13 in 10 milliseconda or zero

dir_TimeCreatedMS db 0
;-120 unsigned int  dir_TimeCreated;	//14 creation time, resolution 2 sec. or 0

dir_TimeCreated dw 0
;-121 unsigned int  dir_DateCreated;	//16 creation date or zero

dir_DateCreated dw 0
;-122 unsigned int  dir_DateLastAccessd;		//18 no time info available or zero

dir_DateLastAccessd dw 0
;-123 unsigned int  dir_FirstClusterHiBytes;	//20 FAT12/16 always zero

dir_FirstClusterHiBytes dw 0
;-124 unsigned int  dir_LastModTime;	//22 modification time on closing

dir_LastModTime dw 0
;-125 unsigned int  dir_LastModDate;	//24 modification date on closing

dir_LastModDate dw 0
;-126 unsigned int  dir_FirstCluster;	//26 1.clu. of file data,if filesize=0 then0

dir_FirstCluster dw 0
;-127 unsigned long dir_FileSize;		//28 size in bytes, if directory then zero

dir_FileSize dd 0
;-128 // 32 end direcctory entry structure

;-129 

;-130 int test() {


test: PROC
;-131 	__asm{


;-132 }	}


;-133 

;-134 //---------------------------  Start LIB.C  --------------------

;-135 //------------------------------------   IO  -------------------

;-136 

;-137 int writetty()     {//char in AL

 ret
ENDP

writetty: PROC
;-138     ah=0x0E;

 mov  ah, 14
;-139     push bx;

push bx;
;-140     bx=0;			//page in BH

 mov  bx, 0
;-141     inth 0x10;		//16

 int  16
;-142     pop bx;

pop bx;
;-143 }

;-144 int putch(char c)  {

 ret
ENDP

putch: PROC
;-145     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;102 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-146         al=13;

 mov  al, 13
;-147         writetty();

 call writetty
;-148     }

;-149     al=c;

.putch1:
 mov  al, [bp+4]
;-150     writetty();

 call writetty
;-151 }

;-152 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-153     char c;

;-154     while(*s) {

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
;-155         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-156         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-157         s++;

 inc  word[bp+4]
;-158     }

;-159 }

 jmp .cputs2
.cputs3:
;-160 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-161 	char c;

;-162 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;102 ptr sign byte s = bp+4
;103 var sign word len = bp+6
;104 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-163 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-164 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-165 		s++;

 inc  word[bp+4]
;-166 		len--;

 dec  word[bp+6]
;-167 	} while (len > 0);

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-168 }

;-169 

;-170 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-171     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-172     inth 0x16;//AH=Scan code, AL=char

 int  22
;-173 }

;-174 int waitkey() {

 ret
ENDP

waitkey: PROC
;-175     ah=0x11;//get kbd status

 mov  ah, 17
;-176     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-177     //zero flag: 0=IS char, 1=NO char

;-178     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-179 }

;-180 int getkey() {

 ret
ENDP

getkey: PROC
;-181     waitkey();

 call waitkey
;-182     getch();

 call getch
;-183     ah=0;//clear scan code

 mov  ah, 0
;-184     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-185     //put ext code in AX

;-186 }

.getkey6:
;-187 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-188     getkey();

 call getkey
;-189     writetty();//destroys AH

 call writetty
;-190 }

;-191 

;-192 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-193     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;102 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-194     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-195     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-196 }

;-197 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-198     unsigned char nib;

;-199     nib = c >> 4; printhex4(nib);

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
;-200     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-201 }

;-202 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-203     unsigned int half;

;-204     half = i >>  8; printhex8(half);

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
;-205     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-206 }

;-207 

;-208 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-209     unsigned int e;

;-210     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;102 var unsg word n = bp+4
;103 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-211         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-212         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-213         }

;-214     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-215     n+='0';

 add  word[bp+4], 48
;-216     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-217 }

;-218 

;-219 int printlong(unsigned long L) {

 LEAVE
 ret
ENDP

printlong: PROC
;-220     ax = L;     // get low in ax

;Function : printlong, Number local Var: 1
; # type sign width local variables
;102 var unsg long L = bp+4;
 ENTER  0,0
 mov  ax, [bp+4]
;-221     edx=L;

 mov  edx, [bp+4]
;-222     edx >> 16;  // get high in dx

 shr  edx, 16
;-223 __asm{


;-224   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-225     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-226 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-227     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-228     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-229 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-230     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-231     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-232     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-233     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-234     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-235     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-236     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-237     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-238 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-239 }	writetty();		__asm{


 call writetty

;-240     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-241     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-242     jb      .b             ;Not yet

    jb      .b             ;Not yet
;-243 }


;-244 }

;-245 //--------------------------------  string  ---------------------

;-246 int strlen1(char *s) { int c;

 LEAVE
 ret
ENDP

strlen1: PROC
;-247     c=0;

;Function : strlen1, Number local Var: 2
; # type sign width local variables
;102 ptr sign byte s = bp+4
;103 var sign word c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-248     if (*s == 34) return 0; // "

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 jne .strlen19
 mov ax, 0
 jmp .retnstrlen1
;-249     while (*s!=0) {s++; c++;}

.strlen19:
.strlen110:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen111
 inc  word[bp+4]
 inc  word[bp-2]
;-250     return c;

 jmp .strlen110
.strlen111:
 mov ax, [bp-2]
 jmp .retnstrlen1
;-251 }

;-252 int strcpy(char *s, char *t) {//new

 .retnstrlen1:
 LEAVE
 ret
ENDP

strcpy: PROC
;-253     while (*t!=0) {

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
;-254     	*s=*t; s++; t++; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-255     *s=0;

 jmp .strcpy12
.strcpy13:
 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-256     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-257 }

;-258 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-259     while(*p) {

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
;-260         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr16
 mov ax, 0
 jmp .retneqstr
;-261         p++;

.eqstr16:
 inc  word[bp+4]
;-262         q++;

 inc  word[bp+6]
;-263     }

;-264     if(*q) return 0;

 jmp .eqstr14
.eqstr15:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr17
 mov ax, 0
 jmp .retneqstr
;-265     return 1;

.eqstr17:
 mov ax, 1
 jmp .retneqstr
;-266 }

;-267 

;-268 int memcmp(char *s, char *t, unsigned int i) {

 .retneqstr:
 LEAVE
 ret
ENDP

memcmp: PROC
;-269     do {

;Function : memcmp, Number local Var: 3
; # type sign width local variables
;102 ptr sign byte s = bp+4
;103 ptr sign byte t = bp+6
;104 var unsg word i = bp+8;
 ENTER  0,0
.memcmp18:
;-270         if (*s < *t) return 0xFFFF;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 jge .memcmp19
 mov ax, 65535
 jmp .retnmemcmp
;-271         if (*s > *t) return 1;

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
;-272         s++; t++; i--;

.memcmp20:
 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-273     } while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcmp21
 jmp .memcmp18
.memcmp21:
;-274     return 0;

 mov ax, 0
 jmp .retnmemcmp
;-275 }

;-276 

;-277 int strcat(char *s, char *t) {

 .retnmemcmp:
 LEAVE
 ret
ENDP

strcat: PROC
;-278     while (*s != 0) s++;

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
;-279     strcpy(s, t);

 jmp .strcat22
.strcat23:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4
;-280 }

;-281 int toupper(char *s) {

 LEAVE
 ret
ENDP

toupper: PROC
;-282     while(*s) {

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
;-283         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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
;-284         s++;

.toupper27:
.toupper26:
 inc  word[bp+4]
;-285     }

;-286 }

 jmp .toupper24
.toupper25:
;-287 int strchr(char *s, char c) {

 LEAVE
 ret
ENDP

strchr: PROC
;-288     while(*s) {

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
;-289         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .strchr30
 mov ax, [bp+4]
 jmp .retnstrchr
;-290         s++;

.strchr30:
 inc  word[bp+4]
;-291     }

;-292     return 0;

 jmp .strchr28
.strchr29:
 mov ax, 0
 jmp .retnstrchr
;-293 }

;-294 int memchr(char *s, char c, unsigned int i) {

 .retnstrchr:
 LEAVE
 ret
ENDP

memchr: PROC
;-295     while(i > 0) {

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
;-296         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr33
 mov ax, [bp+4]
 jmp .retnmemchr
;-297         s++; i--;

.memchr33:
 inc  word[bp+4]
 dec  word[bp+8]
;-298     }

;-299     return 0;

 jmp .memchr31
.memchr32:
 mov ax, 0
 jmp .retnmemchr
;-300 }

;-301 int memchr1(char *s, char c, unsigned int i) {

 .retnmemchr:
 LEAVE
 ret
ENDP

memchr1: PROC
;-302 	unsigned int pos;

;-303 	pos=1;

;Function : memchr1, Number local Var: 4
; # type sign width local variables
;102 ptr sign byte s = bp+4
;103 var sign byte c = bp+6
;104 var unsg word i = bp+8
;105 var unsg word pos = bp-2;
 ENTER  2,0
 mov ax, 1
 mov [bp-2], ax
;-304     while(i > 0) {

.memchr134:
 mov ax, [bp+8]
 cmp ax, 0
 jle .memchr135
;-305         if (*s==c) return pos;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr136
 mov ax, [bp-2]
 jmp .retnmemchr1
;-306         s++; i--; pos++;

.memchr136:
 inc  word[bp+4]
 dec  word[bp+8]
 inc  word[bp-2]
;-307     }

;-308     return 0;

 jmp .memchr134
.memchr135:
 mov ax, 0
 jmp .retnmemchr1
;-309 }

;-310 int instr1(char *s, char c) {

 .retnmemchr1:
 LEAVE
 ret
ENDP

instr1: PROC
;-311     while(*s) {

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
;-312         if (*s==c) return 1;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .instr139
 mov ax, 1
 jmp .retninstr1
;-313         s++;

.instr139:
 inc  word[bp+4]
;-314     }

;-315     return 0;

 jmp .instr137
.instr138:
 mov ax, 0
 jmp .retninstr1
;-316 }

;-317 

;-318 int memcpy(char *s, char *t, unsigned int i) {

 .retninstr1:
 LEAVE
 ret
ENDP

memcpy: PROC
;-319 	unsigned int r;

;-320 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;102 ptr sign byte s = bp+4
;103 ptr sign byte t = bp+6
;104 var unsg word i = bp+8
;105 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-321 	do {

.memcpy40:
;-322 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-323 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-324 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy41
 jmp .memcpy40
.memcpy41:
;-325 	ax=r;//	return r;

 mov  ax, [bp-2]
;-326 }

;-327 

;-328 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-329     unsigned char c; unsigned char chal; int i; int j; int k;

;-330     j=0;

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
;-331     k=0;

 mov ax, 0
 mov [bp-10], ax
;-332 	putch(10);

 push 10
 call putch
 add  sp, 2
;-333 	cputs("Ofs=");

 push mdump_0
 call cputs
 add  sp, 2
;-334 	printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-335 	cputs(" Length=");

 push mdump_1
 call cputs
 add  sp, 2
;-336 	printunsign(len);

 push word [bp+6]
 call printunsign
 add  sp, 2
;-337     while (j < len ) {

.mdump42:
 mov ax, [bp-8]
 cmp ax, [bp+6]
 jge .mdump43
;-338 	    k++;;

 inc  word[bp-10]
;-339 	    if (k > 16) {

 mov ax, [bp-10]
 cmp ax, 16
 jle .mdump44
;-340 		    chal = getkey();//remove scan code

 call getkey
 mov [bp-4], al
;-341 		    if (chal =='q') return;

 mov al, [bp-4]
 cmp al, 113
 jne .mdump45
 jmp .retnmdump
;-342 		    k=1;

.mdump45:
 mov ax, 1
 mov [bp-10], ax
;-343 		    putch(10);

 push 10
 call putch
 add  sp, 2
;-344 		    cputs("Ofs=");

 push mdump_2
 call cputs
 add  sp, 2
;-345 		    printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-346 		    }

;-347         putch(10);

.mdump44:
 push 10
 call putch
 add  sp, 2
;-348         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-349         putch(':');

 push 58
 call putch
 add  sp, 2
;-350         i=0;

 mov ax, 0
 mov [bp-6], ax
;-351         while (i < 16) {

.mdump46:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump47
;-352             putch(' ');

 push 32
 call putch
 add  sp, 2
;-353             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-354             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-355             adr++;

 inc  word[bp+4]
;-356             i++;

 inc  word[bp-6]
;-357             j++;

 inc  word[bp-8]
;-358             }

;-359         putch(' ');

 jmp .mdump46
.mdump47:
 push 32
 call putch
 add  sp, 2
;-360         adr -=16;

 sub  word[bp+4], 16
;-361         i=0;

 mov ax, 0
 mov [bp-6], ax
;-362         while(i < 16) {

.mdump48:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump49
;-363             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-364             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump50
 push 46
 call putch
 add  sp, 2
;-365                 else putch(c);

 jmp .mdump51
.mdump50:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-366             adr++;

.mdump51:
 inc  word[bp+4]
;-367             i++;

 inc  word[bp-6]
;-368         }

;-369     }

 jmp .mdump48
.mdump49:
;-370     getkey();

 jmp .mdump42
.mdump43:
 call getkey
;-371     putch(10);

 push 10
 call putch
 add  sp, 2
;-372 

;-373 }

;-374 int dumpASCII(unsigned char *adr, unsigned int len ) {

 .retnmdump:
 LEAVE
 ret
mdump_0 db "Ofs=",0
mdump_1 db " Length=",0
mdump_2 db "Ofs=",0
ENDP

dumpASCII: PROC
;-375     unsigned char c; unsigned char chal; int i; int j; int k;

;-376     j=0;

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
;-377     k=0;

 mov ax, 0
 mov [bp-10], ax
;-378 	putch(10);

 push 10
 call putch
 add  sp, 2
;-379 	cputs("Ofs=");

 push dumpASCII_0
 call cputs
 add  sp, 2
;-380 	printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-381 	cputs(" Length=");

 push dumpASCII_1
 call cputs
 add  sp, 2
;-382 	printunsign(len);

 push word [bp+6]
 call printunsign
 add  sp, 2
;-383     while (j < len ) {

.dumpASCII52:
 mov ax, [bp-8]
 cmp ax, [bp+6]
 jge .dumpASCII53
;-384 	    k++;;

 inc  word[bp-10]
;-385 	    if (k > 16) {

 mov ax, [bp-10]
 cmp ax, 16
 jle .dumpASCII54
;-386 		    chal = getkey();//remove scan code

 call getkey
 mov [bp-4], al
;-387 		    if (chal =='q') return;

 mov al, [bp-4]
 cmp al, 113
 jne .dumpASCII55
 jmp .retndumpASCII
;-388 		    k=1;

.dumpASCII55:
 mov ax, 1
 mov [bp-10], ax
;-389 		    putch(10);

 push 10
 call putch
 add  sp, 2
;-390 		    cputs("Ofs=");

 push dumpASCII_2
 call cputs
 add  sp, 2
;-391 		    printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-392 		    }

;-393         putch(10);

.dumpASCII54:
 push 10
 call putch
 add  sp, 2
;-394         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-395         putch(':');

 push 58
 call putch
 add  sp, 2
;-396         i=0;

 mov ax, 0
 mov [bp-6], ax
;-397         while(i < 64) {

.dumpASCII56:
 mov ax, [bp-6]
 cmp ax, 64
 jge .dumpASCII57
;-398             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-399             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .dumpASCII58
 push 46
 call putch
 add  sp, 2
;-400                 else putch(c);

 jmp .dumpASCII59
.dumpASCII58:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-401             adr++;

.dumpASCII59:
 inc  word[bp+4]
;-402             i++;

 inc  word[bp-6]
;-403             j++;

 inc  word[bp-8]
;-404         }

;-405     }

 jmp .dumpASCII56
.dumpASCII57:
;-406     getkey();

 jmp .dumpASCII52
.dumpASCII53:
 call getkey
;-407     putch(10);

 push 10
 call putch
 add  sp, 2
;-408 

;-409 }

;-410 //---------------------------   END LIB.C   --------------------

;-411 

;-412 

;-413 

;-414 //--------------------------------  disk IO  -------------------

;-415 

;-416 int DiskSectorReadWrite(char rw, char drive, char head, int cyl,

 .retndumpASCII:
 LEAVE
 ret
dumpASCII_0 db "Ofs=",0
dumpASCII_1 db " Length=",0
dumpASCII_2 db "Ofs=",0
ENDP

DiskSectorReadWrite: PROC
;-417 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-418 	BIOS_ERR=0;

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
;-419 	dl=drive;

 mov  dl, [bp+6]
;-420 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-421 	es=BufSeg;

 mov  es, [bp+16]
;-422 	bx=BufOfs;

 mov  bx, [bp+18]
;-423 	cx=cyl;

 mov  cx, [bp+10]
;-424 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-425 	cx >> 2;//in 2 high bits of cl

 shr  cx, 2
;-426 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-427 	cl += sector;

 add  cl, [bp+12]
;-428 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-429 	al=count;

 mov  al, [bp+14]
;-430 	ah=rw;

 mov  ah, [bp+4]
;-431 	inth 0x13;

 int  19
;-432     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-433 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-434 }

;-435 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-436 	BIOS_ERR=0;

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;102 var sign byte drive = bp+4
;103 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-437 	dl=drive;

 mov  dl, [bp+4]
;-438 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-439 	inth 0x13;

 int  19
;-440     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-441 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-442 }

;-443 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-444 	cputs("*** DISK ERROR *** AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-445 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-446 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-447 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-448 }

;-449 int Status(drive) {

 ret
Int13hError_0 db "*** DISK ERROR *** AX=",0
Int13hError_1 db ".  ",0
ENDP

Status: PROC
;-450 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;102 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-451 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-452 	BIOS_Status=Int13hfunction(drive, 1);

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-453 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Status60
 call Int13hError
;-454 	printhex16(BIOS_Status);

.Status60:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-455 }

;-456 

;-457 int Params() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

Params: PROC
;-458 	if (debug) cputs(" DriveParams");

 mov ax, 1
 or  al, al
 je .Params61
 push Params_0
 call cputs
 add  sp, 2
;-459 	BIOS_Status=Int13hfunction(Drive, 8);

.Params61:
 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-460 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params62
;-461 		Int13hError();

 call Int13hError
;-462 		return 1;

 mov ax, 1
 jmp .retnParams
;-463 		}

;-464 	else {

 jmp .Params63
.Params62:
;-465 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-466 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-467 		// CX =       ---CH--- ---CL---

;-468 		// cylinder : 76543210 98

;-469 		// sector   :            543210

;-470 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-471 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-472 //		pa_Sectors++;//1 to 64

;-473 

;-474 		asm mov [pa_Cylinders],    cx

 mov [pa_Cylinders],    cx
;-475 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-476 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-477 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty

 add [pa_Cylinders],    ch;//byte add, low byte is empty
;-478 

;-479 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params64
;-480 			cputs(" ** no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-481 			return 1;

 mov ax, 1
 jmp .retnParams
;-482 			}

;-483 	}

.Params64:
;-484 	return 0;

.Params63:
 mov ax, 0
 jmp .retnParams
;-485 }

;-486 

;-487 

;-488 int getPartitionData() {

 .retnParams:
 ret
Params_0 db " DriveParams",0
Params_1 db " ** no hard disk found",0
ENDP

getPartitionData: PROC
;-489 	unsigned int j; char c; char *p;

;-490 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;102 var unsg word j = bp-2
;103 var sign byte c = bp-4
;104 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [pt_PartNo]
 shl ax, 4
 mov [bp-2], ax
;-491 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-492 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-493 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-494 	pt_StartCylinder=(int)pt_StartSector;

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-495 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-496 //	pt_StartSector++;//Sector start with 1 todo

;-497 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-498 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-499 	j++;

 inc  word[bp-2]
;-500 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-501 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-502 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB

;-503 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-504 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-505 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-506 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-507 //	pt_EndSector++;//Sector start with 1 todo

;-508 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-509 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-510 	j++;

 inc  word[bp-2]
;-511 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-512 	j++;

 inc  word[bp-2]
;-513 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-514 	memcpy(&pt_HiddenSector, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-515 }

;-516 

;-517 int checkBootSign() {

 LEAVE
 ret
ENDP

checkBootSign: PROC
;-518 	int i;

;-519 	i=510;

;Function : checkBootSign, Number local Var: 1
; # type sign width local variables
;102 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-520 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign65
;-521 		i++;

 inc  word[bp-2]
;-522 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign66
 mov ax, 1
 jmp .retncheckBootSign
;-523 	}

.checkBootSign66:
;-524 	cputs("  **Magic number NOT found.");

.checkBootSign65:
 push checkBootSign_0
 call cputs
 add  sp, 2
;-525 	return 0;

 mov ax, 0
 jmp .retncheckBootSign
;-526 }

;-527 

;-528 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db "  **Magic number NOT found.",0
ENDP

readMBR: PROC
;-529 	int isFAT;

;-530 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;102 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-531 	pt_PartNo=0;

 mov ax, 0
 mov word [pt_PartNo], ax
;-532 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-533 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR67
;-534 		Int13hError();

 call Int13hError
;-535 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-536 		}

;-537 	else {

 jmp .readMBR68
.readMBR67:
;-538 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .readMBR69
 mov ax, 0
 jmp .retnreadMBR
;-539 		do {

.readMBR69:
.readMBR70:
;-540 			getPartitionData();

 call getPartitionData
;-541 

;-542 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR71
;-543 				if (debug) cputs(" Boot part. found");

 mov ax, 1
 or  al, al
 je .readMBR72
 push readMBR_0
 call cputs
 add  sp, 2
;-544 				if (pt_FileSystem == 1) {

.readMBR72:
 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR73
;-545 					cputs(", FAT12 part. <32MB");

 push readMBR_1
 call cputs
 add  sp, 2
;-546 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-547 					}

;-548 				if (pt_FileSystem == 4) {

.readMBR73:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR74
;-549 					cputs(", small FAT16 part.<32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-550 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-551 					}

;-552 				if (pt_FileSystem == 6) {

.readMBR74:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR75
;-553 					if (debug) cputs(", large FAT16 part.");

 mov ax, 1
 or  al, al
 je .readMBR76
 push readMBR_3
 call cputs
 add  sp, 2
;-554 					isFAT=6;

.readMBR76:
 mov ax, 6
 mov [bp-2], ax
;-555 					}

;-556 				pt_PartNo=99;//end of loop

.readMBR75:
 mov ax, 99
 mov word [pt_PartNo], ax
;-557 			}

;-558 			pt_PartNo ++;

.readMBR71:
 inc  word[pt_PartNo]
;-559 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR77
 jmp .readMBR70
.readMBR77:
;-560 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-561 	}

;-562 }

.readMBR68:
;-563 

;-564 int getBootSector() {

 .retnreadMBR:
 LEAVE
 ret
readMBR_0 db " Boot part. found",0
readMBR_1 db ", FAT12 part. <32MB",0
readMBR_2 db ", small FAT16 part.<32MB",0
readMBR_3 db ", large FAT16 part.",0
ENDP

getBootSector: PROC
;-565 	int i;

;-566 	if (debug) cputs(" Boot sector:");

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
;-567   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

.getBootSector78:
;-568   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-569 	if (debug) printhex16(BIOS_Status);

 mov ax, 1
 or  al, al
 je .getBootSector79
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-570 	if (BIOS_ERR) {

.getBootSector79:
 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector80
;-571 		Int13hError();

 call Int13hError
;-572 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-573 		}

;-574 	else {

 jmp .getBootSector81
.getBootSector80:
;-575 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .getBootSector82
 mov ax, 0
 jmp .retngetBootSector
;-576 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector82:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-577 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector83
 push getBootSector_1
 call cputs
 add  sp, 2
;-578 		i=2;

.getBootSector83:
 mov ax, 2
 mov [bp-2], ax
;-579 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector84
 push getBootSector_2
 call cputs
 add  sp, 2
;-580 	}

.getBootSector84:
;-581 	return 1;

.getBootSector81:
 mov ax, 1
 jmp .retngetBootSector
;-582 }

;-583 

;-584 int FATInit() {

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Boot sector:",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-585 	unsigned long templong;//converting word to dword

;-586 

;-587 	clust_sizeL = (long) bs_clust_size;//1--127

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;102 var unsg long templong = bp-4;
 ENTER  4,0
 xor eax, eax
 mov al, [bs_clust_size]
 mov dword [clust_sizeL], eax
;-588 	sector_sizeL= (long) bs_sect_size; //512

 xor eax, eax
 mov ax, [bs_sect_size]
 mov dword [sector_sizeL], eax
;-589 

;-590 	fat_FatStartSector = bs_res_sects;

 mov ax, [bs_res_sects]
 mov word [fat_FatStartSector], ax
;-591 	fat_FatStartSectorL= (long) fat_FatStartSector; 

 xor eax, eax
 mov ax, [fat_FatStartSector]
 mov dword [fat_FatStartSectorL], eax
;-592 	fat_FatSectors = bs_fat_size;

 mov ax, [bs_fat_size]
 mov word [fat_FatSectors], ax
;-593 	if (bs_num_fats == 2) fat_FatSectors=fat_FatSectors+fat_FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .FATInit85
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-594 

;-595 	fat_Entries = bs_fat_size >> 1;//2 bytes for one entry

.FATInit85:
 mov ax, [bs_fat_size]
 shr ax, 1
 mov word [fat_Entries], ax
;-596 	fat_Entries -=2;//first 2 entries not used

 sub  word[fat_Entries], 2
;-597 	

;-598 	fat_RootDirStartSectorL = (long)fat_FatStartSector + fat_FatSectors;

 xor eax, eax
 mov ax, [fat_FatStartSector]
 add ax, [fat_FatSectors]
 mov dword [fat_RootDirStartSectorL], eax
;-599 	

;-600 	fat_RootDirSectorsL = (long) bs_root_entr >> 4;//  ./. 16

 xor eax, eax
 mov ax, [bs_root_entr]
 shr ax, 4
 mov dword [fat_RootDirSectorsL], eax
;-601 		

;-602 	fat_DataStartSectorL = fat_RootDirStartSectorL + fat_RootDirSectorsL;

 mov eax, [fat_RootDirStartSectorL]
 add eax, [fat_RootDirSectorsL]
 mov dword [fat_DataStartSectorL], eax
;-603 

;-604 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .FATInit86
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-605 	DataSectors32=bs_tot_sect32 - fat_DataStartSectorL;

.FATInit86:
 mov eax, [bs_tot_sect32]
 sub eax, [fat_DataStartSectorL]
 mov dword [DataSectors32], eax
;-606 

;-607 	CountofClustersL=DataSectors32 / clust_sizeL;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [clust_sizeL]
 mov dword [CountofClustersL], eax
;-608 

;-609 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-610 	num_tracksL = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [num_tracksL], eax
;-611 

;-612 //	templong = (long) bs_num_heads;

;-613 //	fat_num_cylinders = num_tracksL / templong;//w=d/w

;-614 	

;-615 	bytes_per_clusterL = (long) bs_clust_size * bs_sect_size;

 xor eax, eax
 mov al, [bs_clust_size]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_sect_size]
 mov dword [bytes_per_clusterL], eax
;-616 

;-617 	Sectors_per_cylinderL = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinderL], eax
;-618 	asm mov [Sectors_per_cylinderL + 2], dx;store high word

 mov [Sectors_per_cylinderL + 2], dx;store high word
;-619 

;-620 	templong = (long) 65525;

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-621 	if (CountofClustersL > templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jle .FATInit87
;-622 		trueFATtype=32;

 mov ax, 32
 mov byte [trueFATtype], al
;-623 		cputs(" FAT32 NOT supported");

 push FATInit_0
 call cputs
 add  sp, 2
;-624 		return 1;

 mov ax, 1
 jmp .retnFATInit
;-625 		}

;-626 	templong= (long) 4086;

.FATInit87:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-627 	if (CountofClustersL < templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jge .FATInit88
;-628 		trueFATtype=12;

 mov ax, 12
 mov byte [trueFATtype], al
;-629 		cputs(" FAT12");

 push FATInit_1
 call cputs
 add  sp, 2
;-630 		return 0;

 mov ax, 0
 jmp .retnFATInit
;-631 		}

;-632 	trueFATtype=16;

.FATInit88:
 mov ax, 16
 mov byte [trueFATtype], al
;-633 	if (debug) cputs(" FAT16");

 mov ax, 1
 or  al, al
 je .FATInit89
 push FATInit_2
 call cputs
 add  sp, 2
;-634 	return 0;

.FATInit89:
 mov ax, 0
 jmp .retnFATInit
;-635 }

;-636 

;-637 int Int13hExt() {

 .retnFATInit:
 LEAVE
 ret
FATInit_0 db " FAT32 NOT supported",0
FATInit_1 db " FAT12",0
FATInit_2 db " FAT16",0
ENDP

Int13hExt: PROC
;-638 	bx=0x55AA;

 mov  bx, 21930
;-639 	BIOS_Status=Int13hfunction(Drive, 0x41);

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-640 	asm mov [vAX], ax;

 mov [vAX], ax;
;-641 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-642 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported
;-643 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt90
;-644 		cputs(" Ext. NOT present");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-645 		Int13hError();

 call Int13hError
;-646 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-647 		}

;-648 	else if (debug) cputs(",Int13h Ext.");

 jmp .Int13hExt91
.Int13hExt90:
 mov ax, 1
 or  al, al
 je .Int13hExt92
 push Int13hExt_1
 call cputs
 add  sp, 2
;-649 	putch(10);

.Int13hExt92:
.Int13hExt91:
 push 10
 call putch
 add  sp, 2
;-650 	return 0;

 mov ax, 0
 jmp .retnInt13hExt
;-651 }

;-652 

;-653 int PrintDriveParameter() {

 .retnInt13hExt:
 ret
Int13hExt_0 db " Ext. NOT present",0
Int13hExt_1 db ",Int13h Ext.",0
ENDP

PrintDriveParameter: PROC
;-654 	unsigned long Lo;

;-655 // from Params

;-656 	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);

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
;-657 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-658 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-659 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-660 	putch('.');

 push 46
 call putch
 add  sp, 2
;-661 //from getPartitionData

;-662 	putch(10);

 push 10
 call putch
 add  sp, 2
;-663 	cputs("getPartitionData:No=");printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-664 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-665 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-666 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-667 	cputs("/");				printunsign(pt_StartSector);

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-668 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-669 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-670 	cputs("/");				printunsign(pt_EndSector);

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-671 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-672 	cputs(",Start=");		printlong(pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 push dword [pt_HiddenSector]
 call printlong
 add  sp, 4
;-673 	cputs(",Len=");			printlong(pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 push dword [pt_PartLen]
 call printlong
 add  sp, 4
;-674 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-675 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-676 	printlong(Lo);

 push dword [bp-4]
 call printlong
 add  sp, 4
;-677 	cputs(" MByte.");

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-678 //from getBootSector

;-679 	putch(10);

 push 10
 call putch
 add  sp, 2
;-680 	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-681 	putch(10);

 push 10
 call putch
 add  sp, 2
;-682 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-683 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-684 	putch(10);

 push 10
 call putch
 add  sp, 2
;-685 	cputs("Reserved sectors=");printunsign(bs_res_sects);

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-686 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-687 	putch(10);

 push 10
 call putch
 add  sp, 2
;-688 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-689 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-690 	putch(10);

 push 10
 call putch
 add  sp, 2
;-691 	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-692 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-693 	putch(10);

 push 10
 call putch
 add  sp, 2
;-694 	cputs("sectors per track=");printunsign(bs_sectors_per_track);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_sectors_per_track]
 call printunsign
 add  sp, 2
;-695 	cputs(".number of heads=");printunsign(bs_num_heads);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_heads]
 call printunsign
 add  sp, 2
;-696 	putch(10);

 push 10
 call putch
 add  sp, 2
;-697 	cputs("hidden sectors(long)=");printlong(bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 push dword [bs_hid_sects]
 call printlong
 add  sp, 4
;-698 	cputs(".sectors(long)=");printlong(bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 push dword [bs_tot_sect32]
 call printlong
 add  sp, 4
;-699 	putch(10);

 push 10
 call putch
 add  sp, 2
;-700 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-701 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-702 	putch(10);

 push 10
 call putch
 add  sp, 2
;-703 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-704 	cputs(".Volume serial(long)=");printlong(bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 push dword [bs_serial_num]
 call printlong
 add  sp, 4
;-705 	putch(10);

 push 10
 call putch
 add  sp, 2
;-706 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-707 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-708 //from FATInit

;-709 	putch(10);

 push 10
 call putch
 add  sp, 2
;-710 	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [fat_FatStartSector]
 call printunsign
 add  sp, 2
;-711 	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [fat_FatSectors]
 call printunsign
 add  sp, 2
;-712 	cputs(", fat_Entries=");	printunsign(fat_Entries);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push word [fat_Entries]
 call printunsign
 add  sp, 2
;-713 	putch(10);

 push 10
 call putch
 add  sp, 2
;-714 	cputs("fat_RootDirStartSectorL="); printlong(fat_RootDirStartSectorL);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push dword [fat_RootDirStartSectorL]
 call printlong
 add  sp, 4
;-715 	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectorsL);

 push PrintDriveParameter_38
 call cputs
 add  sp, 2
 push dword [fat_RootDirSectorsL]
 call printunsign
 add  sp, 4
;-716 	putch(10);

 push 10
 call putch
 add  sp, 2
;-717 	cputs("fat_DataStartSectorL=");	printunsign(fat_DataStartSectorL);

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 push dword [fat_DataStartSectorL]
 call printunsign
 add  sp, 4
;-718 	cputs(", DataSectors32=");	printlong(DataSectors32);

 push PrintDriveParameter_40
 call cputs
 add  sp, 2
 push dword [DataSectors32]
 call printlong
 add  sp, 4
;-719 	putch(10);

 push 10
 call putch
 add  sp, 2
;-720 	cputs("CountofClustersL=");	printlong(CountofClustersL);

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 push dword [CountofClustersL]
 call printlong
 add  sp, 4
;-721 	cputs(", Sectors_per_cylinderL="); printlong(Sectors_per_cylinderL);

 push PrintDriveParameter_42
 call cputs
 add  sp, 2
 push dword [Sectors_per_cylinderL]
 call printlong
 add  sp, 4
;-722 	putch(10);

 push 10
 call putch
 add  sp, 2
;-723 	cputs("num_tracksL=");	printlong(num_tracksL);

 push PrintDriveParameter_43
 call cputs
 add  sp, 2
 push dword [num_tracksL]
 call printlong
 add  sp, 4
;-724 	cputs(", bytes_per_clusterL=");	printlong(bytes_per_clusterL);

 push PrintDriveParameter_44
 call cputs
 add  sp, 2
 push dword [bytes_per_clusterL]
 call printlong
 add  sp, 4
;-725 //	cputs(", fat_num_cylinders="); printunsign(fat_num_cylinders);

;-726 	putch(10);

 push 10
 call putch
 add  sp, 2
;-727 	getkey();

 call getkey
;-728 }

;-729 

;-730 //--------------------------------  file IO  -------------------

;-731 int error2(char *s) {

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
;-732 	putch(10);

;Function : error2, Number local Var: 1
; # type sign width local variables
;102 ptr sign byte s = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-733 	cputs("*** ERROR *** ");

 push error2_0
 call cputs
 add  sp, 2
;-734 	cputs(s);

 push word [bp+4]
 call cputs
 add  sp, 2
;-735 	DOS_ERR++;

 inc  byte[DOS_ERR]
;-736 }

;-737 // 1.

;-738 int readLogical(unsigned long SectorL,unsigned int DSeg, unsigned int DOfs){

 LEAVE
 ret
error2_0 db "*** ERROR *** ",0
ENDP

readLogical: PROC
;-739 	//OUT:1 sector in DiskBuf

;-740 	unsigned int track; unsigned int head; unsigned int sect;

;-741 	SectorL = SectorL + bs_hid_sects;//d=d+d

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
;-742 	track = SectorL / Sectors_per_cylinderL;  //w=d/d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinderL]
 mov [bp-2], ax
;-743 	head  = SectorL % Sectors_per_cylinderL;  //w=d%d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinderL]
 mov eax, edx
 mov [bp-4], ax
;-744 	sect  = head            % bs_sectors_per_track;  //w=w%w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov ax, dx
 mov [bp-6], ax
;-745 	sect++;

 inc  word[bp-6]
;-746 	head  = head            / bs_sectors_per_track;	 //w=w/w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov [bp-4], ax
;-747 

;-748 	DiskSectorReadWrite(2, bs_drive_num, head, track/* =cyl */,

;-749 		sect, 1, DSeg , DOfs);

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
;-750 	if (BIOS_ERR) error2("readLogical low level");

 mov al, [BIOS_ERR]
 or  al, al
 je .readLogical93
 push readLogical_0
 call error2
 add  sp, 2
;-751 }

.readLogical93:
;-752 // 2.a

;-753 int printDirEntry(int EntryNr) {

 LEAVE
 ret
readLogical_0 db "readLogical low level",0
ENDP

printDirEntry: PROC
;-754     unsigned int j;

;-755 	putch(10);

;Function : printDirEntry, Number local Var: 2
; # type sign width local variables
;102 var sign word EntryNr = bp+4
;103 var unsg word j = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-756 	printunsign(EntryNr);

 push word [bp+4]
 call printunsign
 add  sp, 2
;-757 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-758 	cputs(filename);

 lea  ax, [filename]
 push ax
 call cputs
 add  sp, 2
;-759 	cputs(" ATTR:");

 push printDirEntry_0
 call cputs
 add  sp, 2
;-760 	printhex8(dir_Attrib);	

 mov al, byte [dir_Attrib]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-761 	if (dir_Attrib &  1) cputs(" r/o");

 mov al, [dir_Attrib]
 and al, 1
 or  al, al
 je .printDirEntry94
 push printDirEntry_1
 call cputs
 add  sp, 2
;-762 	if (dir_Attrib &  2) cputs(" hid");

.printDirEntry94:
 mov al, [dir_Attrib]
 and al, 2
 or  al, al
 je .printDirEntry95
 push printDirEntry_2
 call cputs
 add  sp, 2
;-763 	if (dir_Attrib &  4) cputs(" sys");

.printDirEntry95:
 mov al, [dir_Attrib]
 and al, 4
 or  al, al
 je .printDirEntry96
 push printDirEntry_3
 call cputs
 add  sp, 2
;-764 	if (dir_Attrib &  8) cputs(" vol");		

.printDirEntry96:
 mov al, [dir_Attrib]
 and al, 8
 or  al, al
 je .printDirEntry97
 push printDirEntry_4
 call cputs
 add  sp, 2
;-765 	if (dir_Attrib & 16) cputs(" dir");

.printDirEntry97:
 mov al, [dir_Attrib]
 and al, 16
 or  al, al
 je .printDirEntry98
 push printDirEntry_5
 call cputs
 add  sp, 2
;-766 	if (dir_Attrib & 32) cputs(" arc");

.printDirEntry98:
 mov al, [dir_Attrib]
 and al, 32
 or  al, al
 je .printDirEntry99
 push printDirEntry_6
 call cputs
 add  sp, 2
;-767 	if (dir_Attrib == 0) cputs("    ");

.printDirEntry99:
 mov al, [dir_Attrib]
 cmp al, 0
 jne .printDirEntry100
 push printDirEntry_7
 call cputs
 add  sp, 2
;-768 	

;-769 	putch(' ');

.printDirEntry100:
 push 32
 call putch
 add  sp, 2
;-770 	j=dir_LastModDate & 31;//day

 mov ax, [dir_LastModDate]
 and ax, 31
 mov [bp-2], ax
;-771 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry101
 push 32
 call putch
 add  sp, 2
;-772 	printunsign(j);

.printDirEntry101:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-773 	putch('.');

 push 46
 call putch
 add  sp, 2
;-774 

;-775 	j=dir_LastModDate >> 5;//month

 mov ax, [dir_LastModDate]
 shr ax, 5
 mov [bp-2], ax
;-776 	j&=  15;

 and  word[bp-2], 15
;-777 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry102
 push 48
 call putch
 add  sp, 2
;-778 	printunsign(j);

.printDirEntry102:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-779 	putch('.');

 push 46
 call putch
 add  sp, 2
;-780 

;-781 	j=dir_LastModDate >> 9;//year

 mov ax, [dir_LastModDate]
 shr ax, 9
 mov [bp-2], ax
;-782 	j+= 1980;

 add  word[bp-2], 1980
;-783 	printunsign(j);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-784 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-785 	//putch(' ');

;-786 

;-787 	j=dir_LastModTime  >>11;//hour

 mov ax, [dir_LastModTime]
 shr ax, 11
 mov [bp-2], ax
;-788 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry103
 push 32
 call putch
 add  sp, 2
;-789 	printunsign(j);

.printDirEntry103:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-790 	putch(':');

 push 58
 call putch
 add  sp, 2
;-791 

;-792 	j=dir_LastModTime  >> 5;//minute

 mov ax, [dir_LastModTime]
 shr ax, 5
 mov [bp-2], ax
;-793 	j&=  63;

 and  word[bp-2], 63
;-794 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry104
 push 48
 call putch
 add  sp, 2
;-795 	printunsign(j);

.printDirEntry104:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-796 	putch(':');

 push 58
 call putch
 add  sp, 2
;-797 

;-798 	j=dir_LastModTime & 31;// 2 seconds

 mov ax, [dir_LastModTime]
 and ax, 31
 mov [bp-2], ax
;-799 	j=j+j;

 mov ax, [bp-2]
 add ax, [bp-2]
 mov [bp-2], ax
;-800 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jge .printDirEntry105
 push 48
 call putch
 add  sp, 2
;-801 	printunsign(j);

.printDirEntry105:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-802 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-803 

;-804 	cputs(" 1.Cl:"); 

 push printDirEntry_8
 call cputs
 add  sp, 2
;-805 	printunsign(dir_FirstCluster);

 push word [dir_FirstCluster]
 call printunsign
 add  sp, 2
;-806 	cputs(" Size:");

 push printDirEntry_9
 call cputs
 add  sp, 2
;-807 	printlong(dir_FileSize);

 push dword [dir_FileSize]
 call printlong
 add  sp, 4
;-808 	

;-809 }

;-810 

;-811 // 2.b

;-812 int fatDirSectorList(unsigned long startSector, unsigned long numsectors) {

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
;-813     char *p;

;-814 	unsigned int EndDiskBuf;

;-815 	char isHide;//shows entries, NOT lfn, deleted or empty

;-816 	unsigned int EntryNr;

;-817 	EntryNr=0;

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
;-818 	do {

.fatDirSectorList106:
;-819 /*		putch(10);

;-820 		cputs("Sektor = "); 

;-821 		printlong(startSector);

;-822 		cputs(", numsectors = "); 

;-823 		printlong(numsectors);

;-824 		getkey();

;-825 */

;-826 		readLogical(startSector, DiskBufSeg, DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp+4]
 call readLogical
 add  sp, 8
;-827 		if (DOS_ERR) return;

 mov al, [DOS_ERR]
 or  al, al
 je .fatDirSectorList107
 jmp .retnfatDirSectorList
;-828 		p=&DiskBuf;

.fatDirSectorList107:
 mov ax, DiskBuf
 mov [bp-2], ax
;-829 		EndDiskBuf= p + bs_sect_size;		

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-830 		

;-831 		do {

.fatDirSectorList108:
;-832 			memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-833 			memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-834 			filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-835 			

;-836 			isHide=0;//show in listing

 mov ax, 0
 mov [bp-6], al
;-837 			if (*p ==    0) {//only empty entries following

 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorList109
;-838 				isHide++;

 inc  byte[bp-6]
;-839 				numsectors=1;//finish searching

 mov ax, 1
 mov [bp+8], eax
;-840 				p = EndDiskBuf;

 mov ax, [bp-4]
 mov [bp-2], ax
;-841 				}

;-842 			if (*p == 0xE5) isHide++;//deleted, free entry

.fatDirSectorList109:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 229
 jne .fatDirSectorList110
 inc  byte[bp-6]
;-843 			if (*p <=   31) isHide++;//part of LFN

.fatDirSectorList110:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 31
 jg  .fatDirSectorList111
 inc  byte[bp-6]
;-844 			if (dir_Attrib ==    15) isHide++;//LFN start

.fatDirSectorList111:
 mov al, [dir_Attrib]
 cmp al, 15
 jne .fatDirSectorList112
 inc  byte[bp-6]
;-845 					

;-846 			if (isHide == 0) printDirEntry(EntryNr);

.fatDirSectorList112:
 mov al, [bp-6]
 cmp al, 0
 jne .fatDirSectorList113
 push word [bp-8]
 call printDirEntry
 add  sp, 2
;-847 			p+=32;//get next entry

.fatDirSectorList113:
 add  word[bp-2], 32
;-848 			EntryNr++;

 inc  word[bp-8]
;-849 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorList114
 jmp .fatDirSectorList108
.fatDirSectorList114:
;-850 		startSector = startSector + 1;//long, do NOT use ++ or +=1

 mov eax, [bp+4]
 add eax, 1
 mov [bp+4], eax
;-851 		numsectors--;

 dec  dword[bp+8]
;-852 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorList115
 jmp .fatDirSectorList106
.fatDirSectorList115:
;-853 	CurrentCluster=0;//not found but not end

 mov ax, 0
 mov word [CurrentCluster], ax
;-854 }

;-855 

;-856 // 2.

;-857 int fatDirSectorSearch(unsigned long startSector,unsigned long numsectors) {

 .retnfatDirSectorList:
 LEAVE
 ret
ENDP

fatDirSectorSearch: PROC
;-858 //	search for file name. 

;-859 //	IN:  searchstr

;-860 //	OUT: 0=file not found

;-861     char *p;

;-862 	unsigned int EndDiskBuf;

;-863 	do {

;Function : fatDirSectorSearch, Number local Var: 4
; # type sign width local variables
;102 var unsg long startSector = bp+4
;103 var unsg long numsectors = bp+8
;104 ptr sign byte p = bp-2
;105 var unsg word EndDiskBuf = bp-4;
 ENTER  4,0
.fatDirSectorSearch116:
;-864 		readLogical(startSector, DiskBufSeg, DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp+4]
 call readLogical
 add  sp, 8
;-865 		if (DOS_ERR) return 0;

 mov al, [DOS_ERR]
 or  al, al
 je .fatDirSectorSearch117
 mov ax, 0
 jmp .retnfatDirSectorSearch
;-866 		p=&DiskBuf;

.fatDirSectorSearch117:
 mov ax, DiskBuf
 mov [bp-2], ax
;-867 		EndDiskBuf= p + bs_sect_size;

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-868 		do {

.fatDirSectorSearch118:
;-869 			if (memcmp(p, searchstr, 11) == 0) {//found file name

 push 11
 lea  ax, [searchstr]
 push ax
 push word [bp-2]
 call memcmp
 add  sp, 6
 cmp ax, 0
 jne .fatDirSectorSearch119
;-870 				memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-871 				memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-872 				filename[11] = 0;

 mov ax, 0
 mov bx, 11
 mov [filename+bx], al
;-873 				CurrentCluster = dir_FirstCluster;

 mov ax, [dir_FirstCluster]
 mov word [CurrentCluster], ax
;-874 				FileSizeL      = dir_FileSize;

 mov eax, [dir_FileSize]
 mov dword [FileSizeL], eax
;-875 				return 1;

 mov ax, 1
 jmp .retnfatDirSectorSearch
;-876 			}

;-877 			if (*p == 0) return 0; //only empty entries following

.fatDirSectorSearch119:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorSearch120
 mov ax, 0
 jmp .retnfatDirSectorSearch
;-878 			p+=32;//get next entry

.fatDirSectorSearch120:
 add  word[bp-2], 32
;-879 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorSearch121
 jmp .fatDirSectorSearch118
.fatDirSectorSearch121:
;-880 		startSector++;		

 inc  dword[bp+4]
;-881 		numsectors--;

 dec  dword[bp+8]
;-882 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jle .fatDirSectorSearch122
 jmp .fatDirSectorSearch116
.fatDirSectorSearch122:
;-883 	  CurrentCluster=0;//not found but not end

 mov ax, 0
 mov word [CurrentCluster], ax
;-884 	return 0;

 mov ax, 0
 jmp .retnfatDirSectorSearch
;-885 }

;-886 

;-887 /*

;-888 // 3.

;-889 int fatRootSearch() {

;-890     fatDirSectorSearch(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-891 //	getkey();

;-892 //    fatDirSectorList(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-893 }

;-894 */

;-895 

;-896 // 4.

;-897 int fatClusterAnalyse(unsigned int clust) {

 .retnfatDirSectorSearch:
 LEAVE
 ret
ENDP

fatClusterAnalyse: PROC
;-898 //	OUT: StartSectorL, NextCluster

;-899 //	OUT: 1=error

;-900 	unsigned long fatSectorL;

;-901 	unsigned int offset;

;-902 	char *p;

;-903 	if (clust < 2) { StartSectorL = 0; return 1; }

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
;-904 	if ((long) clust >= CountofClustersL) { StartSectorL = 0; return 1; }

.fatClusterAnalyse123:
 xor eax, eax
 mov ax, [bp+4]
 cmp eax, [CountofClustersL] ;unsigned : 0
 jb  .fatClusterAnalyse124
 mov ax, 0
 mov dword [StartSectorL], eax
 mov ax, 1
 jmp .retnfatClusterAnalyse
;-905 

;-906 //StartSectorL = (long) clust -2 * clust_sizeL+fat_DataStartSectorL;

;-907 	StartSectorL = (long) clust -2;

.fatClusterAnalyse124:
 xor eax, eax
 mov ax, [bp+4]
 sub ax, 2
 mov dword [StartSectorL], eax
;-908 	StartSectorL = StartSectorL * clust_sizeL;

 mov eax, [StartSectorL]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul dword [clust_sizeL]
 mov dword [StartSectorL], eax
;-909 	StartSectorL = StartSectorL + fat_DataStartSectorL;

 mov eax, [StartSectorL]
 add eax, [fat_DataStartSectorL]
 mov dword [StartSectorL], eax
;-910 

;-911 //	fatSectorL=cluster*2/512+FatStartSector

;-912 	fatSectorL = (long) clust;

 xor eax, eax
 mov ax, [bp+4]
 mov [bp-4], eax
;-913 	fatSectorL = fatSectorL + fatSectorL;

 mov eax, [bp-4]
 add eax, [bp-4]
 mov [bp-4], eax
;-914 	fatSectorL = fatSectorL / sector_sizeL;		

 mov eax, [bp-4]
 xor edx, edx
 div dword [sector_sizeL]
 mov [bp-4], eax
;-915 	fatSectorL = fatSectorL + fat_FatStartSectorL; 

 mov eax, [bp-4]
 add eax, [fat_FatStartSectorL]
 mov [bp-4], eax
;-916 	readLogical(fatSectorL, DiskBufSeg, DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp-4]
 call readLogical
 add  sp, 8
;-917 	if(DOS_ERR) { StartSectorL = 0; return 1; }

 mov al, [DOS_ERR]
 or  al, al
 je .fatClusterAnalyse125
 mov ax, 0
 mov dword [StartSectorL], eax
 mov ax, 1
 jmp .retnfatClusterAnalyse
;-918 	

;-919 	offset = clust + clust;

.fatClusterAnalyse125:
 mov ax, [bp+4]
 add ax, [bp+4]
 mov [bp-6], ax
;-920 	offset = offset % bs_sect_size;	

 mov ax, [bp-6]
 xor dx, dx
 div word [bs_sect_size]
 mov ax, dx
 mov [bp-6], ax
;-921 	p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-8], ax
;-922 	p = p + offset;	

 mov ax, [bp-8]
 add ax, [bp-6]
 mov [bp-8], ax
;-923 	memcpy(&NextCluster, p, 2);//OUT: NextCluster

 push 2
 push word [bp-8]
 lea  ax, [NextCluster]
 push ax
 call memcpy
 add  sp, 6
;-924 

;-925 	if (debug) { putch(10);

 mov ax, 1
 or  al, al
 je .fatClusterAnalyse126
 push 10
 call putch
 add  sp, 2
;-926 		cputs(" StartSectorL="); printlong(StartSectorL); 

 push fatClusterAnalyse_0
 call cputs
 add  sp, 2
 push dword [StartSectorL]
 call printlong
 add  sp, 4
;-927 		cputs(" Currentclust="); printunsign(clust);

 push fatClusterAnalyse_1
 call cputs
 add  sp, 2
 push word [bp+4]
 call printunsign
 add  sp, 2
;-928 		cputs(" NextCluster="); printunsign(NextCluster); 

 push fatClusterAnalyse_2
 call cputs
 add  sp, 2
 push word [NextCluster]
 call printunsign
 add  sp, 2
;-929 	}

;-930 	return 0;

.fatClusterAnalyse126:
 mov ax, 0
 jmp .retnfatClusterAnalyse
;-931 }

;-932 

;-933 /*

;-934 // 5.

;-935 int fatDirSearch() {//search a directory chain. IN:searchstr

;-936 	

;-937 	fatClusterAnalyse(fatfile_cluster);

;-938 	//OUT: fatfile_sectorStartL, fatfile_nextCluster

;-939 

;-940 	fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster); 

;-941 	while (fatfile_cluster == 0) {//not found but not end

;-942 		if (fatfile_nextCluster >= 0xFFF8) {

;-943 			fat_notfound=1;

;-944 			return;	

;-945 		}		

;-946 		fatfile_cluster=fatfile_nextCluster;

;-947 		fatClusterAnalyse(fatfile_cluster);

;-948 		fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster);

;-949 	}	

;-950 }

;-951 */	

;-952 

;-953 int is_delimiter(char *s) {

 .retnfatClusterAnalyse:
 LEAVE
 ret
fatClusterAnalyse_0 db " StartSectorL=",0
fatClusterAnalyse_1 db " Currentclust=",0
fatClusterAnalyse_2 db " NextCluster=",0
ENDP

is_delimiter: PROC
;-954 	if (*s == '/' ) return 1;

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
;-955 	if (*s == '\\') return 1;

.is_delimiter127:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 92
 jne .is_delimiter128
 mov ax, 1
 jmp .retnis_delimiter
;-956 	if (*s ==    0) return 2;

.is_delimiter128:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .is_delimiter129
 mov ax, 2
 jmp .retnis_delimiter
;-957 	if (*s ==  '.') return 3;

.is_delimiter129:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 46
 jne .is_delimiter130
 mov ax, 3
 jmp .retnis_delimiter
;-958 	return 0;

.is_delimiter130:
 mov ax, 0
 jmp .retnis_delimiter
;-959 }

;-960 

;-961 // 6.

;-962 int fatNextSearch() {//get next part of filename to do a search

 .retnis_delimiter:
 LEAVE
 ret
ENDP

fatNextSearch: PROC
;-963 //	IN:  upto: points to start of search in filename 

;-964 //	OUT: upto: points to search for next time

;-965 //	OUT: searchstr: part of filename in DIR-format with blanks (11bytes)

;-966 //	OUT: isfilename: 0=part of directory, 1=filename

;-967 //	OUT: 0=file not found

;-968 	char *searchstrp;

;-969 	char *p; 

;-970 	unsigned int  len;

;-971 	unsigned int delimiter;

;-972 

;-973 	delimiter=is_delimiter(upto);

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
;-974 	if (delimiter == 1) upto++;

 mov ax, [bp-8]
 cmp ax, 1
 jne .fatNextSearch131
 inc  word[upto]
;-975 	if (delimiter == 2) return 0; 

.fatNextSearch131:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch132
 mov ax, 0
 jmp .retnfatNextSearch
;-976 

;-977 	strcpy(&searchstr, "           ");//11 blank padded

.fatNextSearch132:
 push fatNextSearch_0
 lea  ax, [searchstr]
 push ax
 call strcpy
 add  sp, 4
;-978 	searchstrp = &searchstr;//clear searchstr

 mov ax, searchstr
 mov [bp-2], ax
;-979 	len=0;

 mov ax, 0
 mov [bp-6], ax
;-980 	delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-981 	while (delimiter == 0) { //no slash, zero, point

.fatNextSearch133:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch134
;-982 		*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-983 		searchstrp++;

 inc  word[bp-2]
;-984 		upto++;	

 inc  word[upto]
;-985 		len++;

 inc  word[bp-6]
;-986 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-987 	} 

;-988 	if (len > 8) return 0;

 jmp .fatNextSearch133
.fatNextSearch134:
 mov ax, [bp-6]
 cmp ax, 8
 jle .fatNextSearch135
 mov ax, 0
 jmp .retnfatNextSearch
;-989 	isfilename=0;//todo: default directory, not yet implemented

.fatNextSearch135:
 mov ax, 0
 mov byte [isfilename], al
;-990 	if (delimiter == 2) isfilename=1;//last name is always a file name

 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch136
 mov ax, 1
 mov byte [isfilename], al
;-991 	if (delimiter == 3) {//remove dot in name		

.fatNextSearch136:
 mov ax, [bp-8]
 cmp ax, 3
 jne .fatNextSearch137
;-992 		searchstrp = &searchstr;

 mov ax, searchstr
 mov [bp-2], ax
;-993 		searchstrp += 8;//start extension		

 add  word[bp-2], 8
;-994 		len=0;

 mov ax, 0
 mov [bp-6], ax
;-995 		upto++;

 inc  word[upto]
;-996 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-997 		while (delimiter == 0) { //no slash, zero, point

.fatNextSearch138:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch139
;-998 			*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-999 			searchstrp++;

 inc  word[bp-2]
;-1000 			upto++;	

 inc  word[upto]
;-1001 			len++;

 inc  word[bp-6]
;-1002 			delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-1003 		} 

;-1004 		if (len > 3) return 0;

 jmp .fatNextSearch138
.fatNextSearch139:
 mov ax, [bp-6]
 cmp ax, 3
 jle .fatNextSearch140
 mov ax, 0
 jmp .retnfatNextSearch
;-1005 		if (delimiter == 2) isfilename=1;//last name is always a file name

.fatNextSearch140:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch141
 mov ax, 1
 mov byte [isfilename], al
;-1006 	}

.fatNextSearch141:
;-1007 	return 1;	

.fatNextSearch137:
 mov ax, 1
 jmp .retnfatNextSearch
;-1008 }

;-1009 

;-1010 // 7.

;-1011 int fatGetStartCluster() {//lastBytes, lastSectors

 .retnfatNextSearch:
 LEAVE
 ret
fatNextSearch_0 db "           ",0
ENDP

fatGetStartCluster: PROC
;-1012 	upto = &filename;

 mov ax, filename
 mov word [upto], ax
;-1013 	if (fatNextSearch()) {//6 get next part of file name

 call fatNextSearch
 or  al, al
 je .fatGetStartCluster142
;-1014 		if (debug) {putch(10); cputsLen(searchstr, 11); }

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
;-1015 		if (isfilename == 0) return 0; //todo not implemented

.fatGetStartCluster143:
 mov al, [isfilename]
 cmp al, 0
 jne .fatGetStartCluster144
 mov ax, 0
 jmp .retnfatGetStartCluster
;-1016 		if (fatDirSectorSearch(fat_RootDirStartSectorL,

.fatGetStartCluster144:
;-1017 			fat_RootDirSectorsL)) return 1; 

 push dword [fat_RootDirSectorsL]
 push dword [fat_RootDirStartSectorL]
 call fatDirSectorSearch
 add  sp, 8
 or  al, al
 je .fatGetStartCluster145
 mov ax, 1
 jmp .retnfatGetStartCluster
;-1018 		//2 todo: only root search

;-1019 	}

.fatGetStartCluster145:
;-1020 	return 0;

.fatGetStartCluster142:
 mov ax, 0
 jmp .retnfatGetStartCluster
;-1021 }

;-1022 

;-1023 /*

;-1024 // 8.

;-1025 int fatOpenFile() {//set handle for root or subdir

;-1026 //	fat_notfound=0;

;-1027 	unsigned long BufSzL;

;-1028 	

;-1029 	if (debug) cputs(".fatOpenfile ");	

;-1030 	handle=3;//todo

;-1031 	sectorCount = fat_RootDirSectorsL;// or clust_sizeL

;-1032 	

;-1033 	fatGetStartCluster();// 7.

;-1034 	if (fatfound == 0) { cputs(" file not found"); return; }

;-1035 	lastBytes   = FileSizeL % bytes_per_clusterL;	

;-1036 	lastSectors = lastBytes / sector_sizeL;//resting sectors in a cluster

;-1037 	lastBytes   = lastBytes % sector_sizeL;//resting bytes in a sector

;-1038 	

;-1039 	if (FileSizeL == 0) isfilename = 0;

;-1040 	else isfilename = 1;

;-1041 		

;-1042 	BufSzL = (long) BUFFERSIZE;

;-1043 	if (FileSizeL >=  BufSzL) {

;-1044 		cputs(" file longer than BufferSize"); 

;-1045 		fatfound= 0;

;-1046 		return;

;-1047 	}

;-1048 

;-1049 	fatClusterAnalyse(CurrentCluster);// 4. OUT:StartSectorL,NextCluster

;-1050 	sectorCount = clust_sizeL;//1..128 or fat_RootDirSectorsL

;-1051 	FilePointerL = 0;

;-1052 	sectorUpto = 0;

;-1053 	byteUpto   = 0;

;-1054 //	if (fat_notfound) return 1;

;-1055 	if (debug) {									//		DOS.COM FDCONFIG

;-1056 	cputs(" CurrentCluster="); 	printunsign(CurrentCluster);//4177	4164

;-1057 	cputs(",StartSectorL=");	printlong(StartSectorL);	//17051	16999

;-1058 	cputs(",ClusterSizeL=");	printlong(clust_sizeL);		// 4	 4

;-1059 	cputs(",FileSizeL="); 		printlong(FileSizeL);		//8802	762

;-1060 	cputs(",NextCluster="); 	printunsign(NextCluster);	//4178	65.535

;-1061 	cputs(",lastSectors=");		printunsign(lastSectors);	// 1	 1

;-1062 	cputs(",lastBytes="); 		printunsign(lastBytes);		// 98	250

;-1063 	}

;-1064 }

;-1065 

;-1066 /*

;-1067 DRESULT disk_readp (	//Read Partial Sector  

;-1068 	BYTE* buff,		// Data read buffer

;-1069 	DWORD sector,	// Sector number (LBA)

;-1070 	UINT offset,	// Offset in the sector

;-1071 	UINT count		// Byte count

;-1072 )

;-1073 {

;-1074 	DRESULT res;

;-1075 	DWORD rnc;

;-1076 	LARGE_INTEGER dofs;

;-1077 

;-1078 	if (!ReadFile(Stat[0].h_drive, Buffer, 512, &rnc, NULL) || 512 != rnc) {

;-1079 		res = RES_ERROR;

;-1080 		} else {

;-1081 				if (buff) {

;-1082 					memcpy(buff, &Buffer[offset], count);

;-1083 				} else {

;-1084 					while (count--)

;-1085 						putchar(Buffer[offset++]);

;-1086 				}

;-1087 			}

;-1088 } 

;-1089 */

;-1090 

;-1091 

;-1092 /*		

;-1093 // 9a.

;-1094 int pf_read(unsigned long bytestoReadL) {

;-1095 //	IN:FileSizeL

;-1096 //	IO:FilePointerL

;-1097 //	OUT: 0=error, else byteread

;-1098 	unsigned long remainL;

;-1099 	unsigned long templong1;

;-1100 	unsigned long templong2;

;-1101 	unsigned long sectoroffsetCSL;

;-1102 	unsigned int  tempint1;

;-1103 //	unsigned char tempbyte1;//CS byte

;-1104 	unsigned int  clst;//=CurrentCluster=actual cluster

;-1105 	unsigned long rcntL;

;-1106 	unsigned int  bytesread; 

;-1107 	unsigned int  rbuff;

;-1108 	

;-1109 	unsigned long constL512;  

;-1110 	constL512 = (long) 512;//necessary for DIV

;-1111 	bytesread = 0;

;-1112 	rbuff = 0;

;-1113 	remainL = FileSizeL - FilePointerL;	

;-1114 

;-1115 	if (bytestoReadL > remainL) bytestoReadL = remainL;//718

;-1116 

;-1117 	while (bytestoReadL != 0) {//repeat until all data transferred//720

;-1118 		tempint1 = FilePointerL % constL512;

;-1119 

;-1120 		if (tempint1  ==  0) {//on sector boundary?	//721		

;-1121 			templong1 = FilePointerL / constL512;//sector offset in cluster	

;-1122 			templong2 = clust_sizeL- 1;//0 - 127

;-1123 			sectoroffsetCSL = templong1 & templong2;//722

;-1124 			if (sectoroffsetCSL != 0) {//on cluster boundary?

;-1125 				if (FilePointerL == 0) clst = dir_FirstCluster;//top file?

;-1126 				else clst=get_fat(CurrentCluster);

;-1127 				if (clst <= 1) return 0;//729

;-1128 				CurrentCluster = clst;//update current cluster

;-1129 			}

;-1130 			clust2sect(clst);//OUT:CurrentSectorL, 0=error	//732

;-1131 			if (CurrentSectorL == 0) return 0;

;-1132 			CurrentSectorL = CurrentSectorL + sectoroffsetCSL;	

;-1133 		}

;-1134 		rcntL = constL512 - tempint1;//get partial sector data from buffer

;-1135 		if (rcntL > bytestoReadL) rcntL = bytestoReadL; //737

;-1136 		

;-1137 		readLogical(CurrentSectorL, DiskBufSeg, DiskBuf);		

;-1138 		if (BIOS_ERR) {//739

;-1139 			Int13hError(); 

;-1140 			return 0;

;-1141 		}

;-1142 		//Copy to Buffer[rbuff(max.BUFFERSIZE)], from DiskBuf+templong1

;-1143 					

;-1144 		FilePointerL = FilePointerL + rcntL;//740//advance file read pointr	

;-1145 		bytestoReadL = bytestoReadL - rcntL;//741 //update read counter		

;-1146 		bytesread = bytesread + rcntL;

;-1147 		rbuff = rbuff + rcntL;//742 //advance data pointer

;-1148 	}

;-1149 	return bytesread;		

;-1150 }	

;-1151 */

;-1152 

;-1153 /*

;-1154 // 9.

;-1155 int fatReadFile() {// reads from an already open file

;-1156 //	IN: CurrentCluster, FileSizeL, FilePointerL

;-1157 //	IN: lastBytes, lastSectors

;-1158 	unsigned int  sectorsAvail;	//in one cluster or rootsize

;-1159 	unsigned int  bytesAvail;	//max. in one sector

;-1160 

;-1161 	unsigned int  temp1;

;-1162 	unsigned int  temp2;

;-1163 	unsigned int  temp3;

;-1164 	unsigned int  BufSz;

;-1165 	BufSz    =    BUFFERSIZE;

;-1166 	

;-1167 	BufferPtr = &Buffer;

;-1168 	bytesRead = 0;

;-1169 	sectorsAvail = sectorCount;	//1..128 or fat_RootDirSectorsL 

;-1170 	bytesAvail = bs_sect_size;

;-1171 	

;-1172 	while (CurrentCluster < 0xFFF8) {//not end of Cluster

;-1173 		sectorsAvail = sectorCount;

;-1174 		if (NextCluster >= 0xFFF8) {

;-1175 			if (isfilename) sectorsAvail = lastSectors + 1;//????

;-1176 			}

;-1177 		while (sectorUpto != sectorsAvail) {

;-1178 			bytesAvail = bs_sect_size;

;-1179 			if (NextCluster >= 0xFFF8) {

;-1180 				if (isfilename) {

;-1181 					if (sectorUpto == lastSectors) {

;-1182 						bytesAvail = lastBytes;

;-1183 					}	

;-1184 				}

;-1185 			}

;-1186 			while (byteUpto != bytesAvail) {

;-1187 				CurrentSectorL = (long) sectorUpto;

;-1188 				CurrentSectorL = CurrentSectorL + StartSectorL;	

;-1189 				readLogical(CurrentSectorL, DiskBufSeg, DiskBuf);		

;-1190 				if (BIOS_ERR) {

;-1191 					Int13hError(); 

;-1192 					fatfound = 0;

;-1193 					return;

;-1194 				}	

;-1195 				temp1 = bytesAvail - byteUpto;

;-1196 				temp2 = BufSz - bytesRead;

;-1197 				temp3 = Buffer + byteUpto;

;-1198 

;-1199 				BufferPtr = BufferPtr + bytesRead;////////////////

;-1200 				

;-1201 				

;-1202 				if (temp1 > temp2) {//read last sector not full

;-1203 					memcpy(BufferPtr, temp3, temp2);	

;-1204 					byteUpto = byteUpto + temp2;

;-1205 					bytesRead = BufSz;

;-1206 					return;

;-1207 				}	

;-1208 				else {//read full sector

;-1209 					memcpy(BufferPtr, temp3, temp1);

;-1210 					bytesRead = bytesRead + temp1;

;-1211 					byteUpto = byteUpto + temp1; 

;-1212 				}	

;-1213 			}	

;-1214 			sectorUpto ++;

;-1215 			byteUpto = 0;

;-1216 		}	

;-1217 		CurrentCluster = NextCluster;

;-1218 		fatClusterAnalyse(CurrentCluster);//4.OUT:StartSectorL,NextCluster

;-1219 		sectorUpto = 0;

;-1220 	}	

;-1221 }

;-1222 */

;-1223 

;-1224 		

;-1225 // 9b.

;-1226 int ReadFile(unsigned int BytestoRead) {

 .retnfatGetStartCluster:
 ret
ENDP

ReadFile: PROC
;-1227 //	IN: FileSizeL		from 2.fatDirSectorSearch

;-1228 //	IN: CurrentCluster	from 2.fatDirSectorSearch

;-1229 //	IN: StartSectorL	from 4.fatClusterAnalyse

;-1230 //	IN: NextCluster		from 4.fatClusterAnalyse

;-1231 //	IO: FilePointerL=0	from 10.OSOpenFile

;-1232 //	OUT: 0=error, else ByteRead

;-1233 

;-1234 	unsigned long CurrentSectorL;	//current data sector	

;-1235 	unsigned long EndSectorL;

;-1236 	unsigned int  ByteRead;

;-1237 	unsigned int  btr;

;-1238 	

;-1239 	if (BytestoRead == 0) return 0;

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
;-1240 	ByteRead = 0;

.ReadFile146:
 mov ax, 0
 mov [bp-10], ax
;-1241 

;-1242 	 while (CurrentCluster <= 0xFFF7) {// 65528,   < is wrong code!!!

.ReadFile147:
 mov ax, [CurrentCluster]
 cmp ax, 65527
 ja  .ReadFile148
;-1243 		CurrentSectorL = StartSectorL;

 mov eax, [StartSectorL]
 mov [bp-4], eax
;-1244 		EndSectorL = StartSectorL + clust_sizeL;//set in FATInit(1-127)

 mov eax, [StartSectorL]
 add eax, [clust_sizeL]
 mov [bp-8], eax
;-1245 			

;-1246 //		if (debug) { 

;-1247 //			cputs(" CurrentCluster="); printunsign(CurrentCluster); 

;-1248 //			cputs(" CurrentSectorL="); printlong(CurrentSectorL); 

;-1249 //			cputs(" EndSectorL="); printlong(EndSectorL); 

;-1250 //		}		

;-1251 		while (CurrentSectorL <= EndSectorL) {

.ReadFile149:
 mov eax, [bp-4]
 cmp eax, [bp-8]
 ja  .ReadFile150
;-1252 			readLogical(CurrentSectorL, DiskBufSeg, DiskBuf);		

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp-4]
 call readLogical
 add  sp, 8
;-1253 			if (BIOS_ERR) {	Int13hError(); return 0; }	

 mov al, [BIOS_ERR]
 or  al, al
 je .ReadFile151
 call Int13hError
 mov ax, 0
 jmp .retnReadFile
;-1254 			if (BytestoRead > bs_sect_size) btr = bs_sect_size;

.ReadFile151:
 mov ax, [bp+4]
 cmp ax, [bs_sect_size]
 jle .ReadFile152
 mov ax, [bs_sect_size]
 mov [bp-12], ax
;-1255 			else btr = BytestoRead;

 jmp .ReadFile153
.ReadFile152:
 mov ax, [bp+4]
 mov [bp-12], ax
;-1256 							

;-1257 			memcpy(BufferPtr, DiskBuf, btr);

.ReadFile153:
 push word [bp-12]
 lea  ax, [DiskBuf]
 push ax
 push word [BufferPtr]
 call memcpy
 add  sp, 6
;-1258 			BufferPtr   	= BufferPtr    + btr;

 mov ax, [BufferPtr]
 add ax, [bp-12]
 mov word [BufferPtr], ax
;-1259 			BytestoRead 	= BytestoRead  - btr;

 mov ax, [bp+4]
 sub ax, [bp-12]
 mov [bp+4], ax
;-1260 			ByteRead    	= ByteRead     + btr;

 mov ax, [bp-10]
 add ax, [bp-12]
 mov [bp-10], ax
;-1261 			FilePointerL	= FilePointerL + btr;

 mov eax, [FilePointerL]
 add ax, [bp-12]
 mov dword [FilePointerL], eax
;-1262 			CurrentSectorL	= CurrentSectorL + 1; 		

 mov eax, [bp-4]
 add eax, 1
 mov [bp-4], eax
;-1263 //			cputs(" C BytestoRead="); printunsign(BytestoRead);		

;-1264 			if (BytestoRead == 0) return ByteRead;

 mov ax, [bp+4]
 cmp ax, 0
 jne .ReadFile154
 mov ax, [bp-10]
 jmp .retnReadFile
;-1265 		}

.ReadFile154:
;-1266 		CurrentCluster = NextCluster;

 jmp .ReadFile149
.ReadFile150:
 mov ax, [NextCluster]
 mov word [CurrentCluster], ax
;-1267 		if (fatClusterAnalyse(CurrentCluster)) return 0;//4.OUT:StartSectorL		

 push word [CurrentCluster]
 call fatClusterAnalyse
 add  sp, 2
 or  al, al
 je .ReadFile155
 mov ax, 0
 jmp .retnReadFile
;-1268 	}

.ReadFile155:
;-1269 	return 0;//error

 jmp .ReadFile147
.ReadFile148:
 mov ax, 0
 jmp .retnReadFile
;-1270 }	

;-1271 

;-1272 

;-1273 //------------------------------- OS functions --------------

;-1274 int FileError() {

 .retnReadFile:
 LEAVE
 ret
ENDP

FileError: PROC
;-1275 	cputs(" *** file error *** ");

 push FileError_0
 call cputs
 add  sp, 2
;-1276 }	

;-1277 

;-1278 // 10.

;-1279 int OSOpenFile(char *name) {

 ret
FileError_0 db " *** file error *** ",0
ENDP

OSOpenFile: PROC
;-1280 //	NEED:CurrentCluster, FileSizeL from 2.fatDirSectorSearch

;-1281 //	OUT: 0=error

;-1282 	unsigned long BufSzL;

;-1283 	unsigned int i;

;-1284 	DOS_ERR = 0;

;Function : OSOpenFile, Number local Var: 3
; # type sign width local variables
;102 ptr sign byte name = bp+4
;103 var unsg long BufSzL = bp-4
;104 var unsg word i = bp-6;
 ENTER  6,0
 mov ax, 0
 mov byte [DOS_ERR], al
;-1285 //	remove drive letter, slash. uppercase and copy to filename

;-1286 	strcpy(filename, name);

 push word [bp+4]
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1287 	toupper(filename);

 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-1288 	if (strlen1(filename) == 0) return 0;

 lea  ax, [filename]
 push ax
 call strlen1
 add  sp, 2
 cmp ax, 0
 jne .OSOpenFile156
 mov ax, 0
 jmp .retnOSOpenFile
;-1289 	i=strchr(filename, ':');

.OSOpenFile156:
 push 58
 lea  ax, [filename]
 push ax
 call strchr
 add  sp, 4
 mov [bp-6], ax
;-1290 	if (i) {

 mov ax, [bp-6]
 or  al, al
 je .OSOpenFile157
;-1291 		i++;

 inc  word[bp-6]
;-1292 		strcpy(filename, i);	

 push word [bp-6]
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1293 		if (strlen1(filename) == 0) return 0;	

 lea  ax, [filename]
 push ax
 call strlen1
 add  sp, 2
 cmp ax, 0
 jne .OSOpenFile158
 mov ax, 0
 jmp .retnOSOpenFile
;-1294 	}

.OSOpenFile158:
;-1295 

;-1296 //todo: add working directory page 18

;-1297 			

;-1298 	if(is_delimiter(filename) == 1) filename++;

.OSOpenFile157:
 lea  ax, [filename]
 push ax
 call is_delimiter
 add  sp, 2
 cmp ax, 1
 jne .OSOpenFile159
 inc  byte[filename]
;-1299 		if (fatGetStartCluster() == 0) {// 7.fatGetStartCluster

.OSOpenFile159:
 call fatGetStartCluster
 cmp al, 0
 jne .OSOpenFile160
;-1300 		cputs(" file not found"); 

 push OSOpenFile_0
 call cputs
 add  sp, 2
;-1301 		return 0; 

 mov ax, 0
 jmp .retnOSOpenFile
;-1302 		}

;-1303 	BufferPtr = &Buffer;

.OSOpenFile160:
 mov ax, Buffer
 mov word [BufferPtr], ax
;-1304 	FilePointerL = 0;

 mov ax, 0
 mov dword [FilePointerL], eax
;-1305 	

;-1306 	BufSzL = (long) BUFFERSIZE;

 xor eax, eax
 mov ax, 35000
 mov [bp-4], eax
;-1307 	if (FileSizeL >=  BufSzL) {

 mov eax, [FileSizeL]
 cmp eax, [bp-4] ;unsigned : 0
 jb  .OSOpenFile161
;-1308 		error2(" file longer than BufferSize"); 

 push OSOpenFile_1
 call error2
 add  sp, 2
;-1309 		return 0;

 mov ax, 0
 jmp .retnOSOpenFile
;-1310 	}

;-1311 		

;-1312 	if (fatClusterAnalyse(CurrentCluster)) return 0;// 4. OUT: StartSectorL

.OSOpenFile161:
 push word [CurrentCluster]
 call fatClusterAnalyse
 add  sp, 2
 or  al, al
 je .OSOpenFile162
 mov ax, 0
 jmp .retnOSOpenFile
;-1313 //	CurrentCluster is set in 2.fatDirSectorSearch

;-1314 //	if (debug) {									//		DOS.COM FDCONFIG

;-1315 //	putch(10);

;-1316 //	cputs(" --10 OSOpenFile B:");

;-1317 //	cputs(" CurrentCluster="); 	printunsign(CurrentCluster);//4177	4164

;-1318 //	cputs(",StartSectorL=");	printlong(StartSectorL);	//17051	16999

;-1319 //	cputs(",ClusterSizeL=");	printlong(clust_sizeL);		// 4	 4

;-1320 //	cputs(",FileSizeL="); 		printlong(FileSizeL);		//8802	762

;-1321 //	cputs(",NextCluster="); 	printunsign(NextCluster);	//4178	65.535

;-1322 //	cputs(",lastSectors=");		printunsign(lastSectors);	// 1	 1

;-1323 //	cputs(",lastBytes="); 		printunsign(lastBytes);		// 98	250

;-1324 //	getkey();

;-1325 //	}

;-1326 	return 1;

.OSOpenFile162:
 mov ax, 1
 jmp .retnOSOpenFile
;-1327 }

;-1328 

;-1329 // 11.

;-1330 int OSReadFile() {

 .retnOSOpenFile:
 LEAVE
 ret
OSOpenFile_0 db " file not found",0
OSOpenFile_1 db " file longer than BufferSize",0
ENDP

OSReadFile: PROC
;-1331 	unsigned int BytesToReadInt;

;-1332 	BytesToReadInt = FileSizeL;//long2int	

;Function : OSReadFile, Number local Var: 1
; # type sign width local variables
;102 var unsg word BytesToReadInt = bp-2;
 ENTER  2,0
 mov eax, [FileSizeL]
 mov [bp-2], ax
;-1333 	BytesAreRead=ReadFile(BytesToReadInt);//9.

 push word [bp-2]
 call ReadFile
 add  sp, 2
 mov word [BytesAreRead], ax
;-1334 	if (BytesToReadInt != BytesAreRead) {

 mov ax, [bp-2]
 cmp ax, [BytesAreRead]
 je  .OSReadFile163
;-1335 		FileError();

 call FileError
;-1336 		cputs(" --11 OSReadFile BytesAreRead="); 

 push OSReadFile_0
 call cputs
 add  sp, 2
;-1337 		printunsign(BytesAreRead);  

 push word [BytesAreRead]
 call printunsign
 add  sp, 2
;-1338 	}

;-1339 	if (debug) getkey();	

.OSReadFile163:
 mov ax, 1
 or  al, al
 je .OSReadFile164
 call getkey
;-1340 }

.OSReadFile164:
;-1341 

;-1342 

;-1343 // 12.

;-1344 int OSShowFile() {

 LEAVE
 ret
OSReadFile_0 db " --11 OSReadFile BytesAreRead=",0
ENDP

OSShowFile: PROC
;-1345 //	mdump(DiskBuf, 512);

;-1346 	dumpASCII(Buffer, BytesAreRead);

 push word [BytesAreRead]
 lea  ax, [Buffer]
 push ax
 call dumpASCII
 add  sp, 4
;-1347 }

;-1348 

;-1349 

;-1350 //------------------------------- Init,  main ---------------

;-1351 int Init() {

 ret
ENDP

Init: PROC
;-1352 	DOS_ERR = 0;

 mov ax, 0
 mov byte [DOS_ERR], al
;-1353 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-1354 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-1355 	if (debug) cputs(" Init");

 mov ax, 1
 or  al, al
 je .Init165
 push Init_0
 call cputs
 add  sp, 2
;-1356 	if (Params()) cputs(" ** NO DRIVE PARAMS FOUND **");//no hard disk

.Init165:
 call Params
 or  al, al
 je .Init166
 push Init_1
 call cputs
 add  sp, 2
;-1357 	if (readMBR() == 0) {//0=error,1=FAT12,6=FAT16,11=FAT32	

.Init166:
 call readMBR
 cmp al, 0
 jne .Init167
;-1358 		cputs(" ** no active FAT partition found **");

 push Init_2
 call cputs
 add  sp, 2
;-1359 		return 1;

 mov ax, 1
 jmp .retnInit
;-1360 		}

;-1361 	if(getBootSector()==0) 	return 1;

.Init167:
 call getBootSector
 cmp al, 0
 jne .Init168
 mov ax, 1
 jmp .retnInit
;-1362 	if (FATInit())			return 1;

.Init168:
 call FATInit
 or  al, al
 je .Init169
 mov ax, 1
 jmp .retnInit
;-1363 	if(trueFATtype != 16) 	return 1;

.Init169:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init170
 mov ax, 1
 jmp .retnInit
;-1364 	Int13hExt();

.Init170:
 call Int13hExt
;-1365 	return 0;

 mov ax, 0
 jmp .retnInit
;-1366 }

;-1367 

;-1368 int main() {

 .retnInit:
 ret
Init_0 db " Init",0
Init_1 db " ** NO DRIVE PARAMS FOUND **",0
Init_2 db " ** no active FAT partition found **",0
ENDP

main: PROC
;-1369 	if (Init() ) return 1;

 call Init
 or  al, al
 je .main171
 mov ax, 1
 jmp .retnmain
;-1370 //	if (debug) PrintDriveParameter();

;-1371 	

;-1372 	if (OSOpenFile("fat.h"       ) > 0) { OSReadFile(); OSShowFile(); }

.main171:
 push main_0
 call OSOpenFile
 add  sp, 2
 cmp al, 0
 jle .main172
 call OSReadFile
 call OSShowFile
;-1373 	else FileError();

 jmp .main173
.main172:
 call FileError
;-1374 	if (OSOpenFile("r.bat"       ) > 0) { OSReadFile(); OSShowFile(); }

.main173:
 push main_1
 call OSOpenFile
 add  sp, 2
 cmp al, 0
 jle .main174
 call OSReadFile
 call OSShowFile
;-1375 	else FileError();

 jmp .main175
.main174:
 call FileError
;-1376 	if (OSOpenFile("int13.asm"   ) > 0) { OSReadFile(); OSShowFile(); }

.main175:
 push main_2
 call OSOpenFile
 add  sp, 2
 cmp al, 0
 jle .main176
 call OSReadFile
 call OSShowFile
;-1377 	else FileError();

 jmp .main177
.main176:
 call FileError
;-1378 	if (debug) cputs(".End.");

.main177:
 mov ax, 1
 or  al, al
 je .main178
 push main_3
 call cputs
 add  sp, 2
;-1379 }

.main178:
;-1380 /*

;-1381 11	OSReadFile

;-1382 	9 fatReadFile

;-1383 	

;-1384 10	OSOpenFile drive,slash,upper,to filename

;-1385 	8 fatOpenFile

;-1386 9. fatReadFile

;-1387 	1 readLogical

;-1388 	4 fatClusterAnalyse

;-1389 8. fatOpenFile set handle, init root or subdir

;-1390 	s7 fatGetStartCluster

;-1391 	s4 fatClusterAnalyse

;-1392 7. fatGestStartCluster

;-1393 	6 fatNextSearch

;-1394 	3 fatRootSearch

;-1395 	s5 fatDirSearch

;-1396 6. fatNextSearch Upto,search,isFilename =>7

;-1397 5. fatDirSearch a directory chain for search

;-1398 	4 fatClusterAnalyse

;-1399 	2 fatDieSectorSearch

;-1400 4. fatClusterAnalyse determines sector by cluster number, next cluster

;-1401 	1 ReadLogical

;-1402 3. fatRootSearch search the root for an entry

;-1403 	2 fatDirSectorSearch

;-1404 2. fatDirSectorSearch search a block of sectors for entries,

;-1405 		get starting cluster, file size, notfound

;-1406 	1 readLogical

;-1407 2.a printDirEntry

;-1408 2.b fatDirSectorList

;-1409 	1 readLogical					

;-1410 1. readLogical

;-1411 	DiskSectorReadWrite	

;-1412 */

;-1413 /*

;-1414 bin_file=fopen("name", "rb") //binary

;-1415 int = fgetc(in_file)	     //EOF(-1)

;-1416 fputc(character, file)

;-1417 printf() = fprintf(stdout, format, parameter1) //buffered I/O

;-1418 DOS: add CR13 to LF10

;-1419 read_size=fread(data_ptr, 1, size, file) //binary read

;-1420 file_descriptor=open(name, flags, mode=0666) //unbuffered I/O

;-1421 read_size=read(file_descriptor, buffer, size) //unbufferes I/O 

;-1422 */

 .retnmain:
 ret
main_0 db "fat.h",0
main_1 db "r.bat",0
main_2 db "int13.asm",0
main_3 db ".End.",0
ENDP
