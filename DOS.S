;Comp A.COM V1.2, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.2.4";//test bed

Version1 db "DOS.COM V0.2.4",0
;-2 /*	Finder /hg/DOS/DOS3.vhd

;-3 	rigth click / open / Parallels Mounter

;-4 	(E)DX:(E)AX DIV r/m16(32) = (E)AX, remainder (E)DX

;-5 	AL*r/m8=AX; AX*r/m16=DX:AX; EAX*r/m32=EDX:EAX

;-6 todo:

;-7 	read subdir, Line 1018

;-8 	read root dir

;-9 	lseek 42h

;-10 	mkdir 39h

;-11 	write file 40h

;-12 	create file 3Ch

;-13 */

;-14 #define ORGDATA		16384//=16K start of arrays

;-15 #define debug 1

;-16 unsigned int vAX ;unsigned int vBX ;unsigned int vCX; unsigned int vDX;

vAX dw 0
vBX dw 0
vCX dw 0
vDX dw 0
;-17 unsigned int vSP; unsigned int vBP; unsigned int vCS; unsigned int vDS;

vSP dw 0
vBP dw 0
vCS dw 0
vDS dw 0
;-18 unsigned int vSS; unsigned int vES; //debugging

vSS dw 0
vES dw 0
;-19 

;-20 unsigned char DOS_ERR;

DOS_ERR db 0
;-21 unsigned char BIOS_ERR;

BIOS_ERR db 0
;-22 unsigned int  BIOS_Status;

BIOS_Status dw 0
;-23 unsigned int  DiskBufSeg;

DiskBufSeg dw 0
;-24 //unsigned char dummy1[1];//todo remove

;-25 unsigned char filename[67];

section .bss
absolute 16384
filename resb 67
section .text
;-26 unsigned char searchstr  [12];//with null

section .bss
absolute 16451
searchstr resb 12
section .text
;-27 unsigned char DiskBuf [512];

section .bss
absolute 16463
DiskBuf resb 512
section .text
;-28 unsigned char Drive=0x80;

Drive db 128
;-29 unsigned long clust_sizeL;

clust_sizeL dd 0
;-30 unsigned long sector_sizeL;

sector_sizeL dd 0
;-31 unsigned int  BytesAreRead;

BytesAreRead dw 0
;-32 unsigned long Sector;

Sector dd 0
;-33 

;-34 char *upto;		//IN:part of filename to search/OUT:to search next time

upto dw 0
;-35 char isfilename;//0=part of directory or 1=filename

isfilename db 0
;-36 #define BUFFERSIZE 35000

;-37 unsigned char Buffer [BUFFERSIZE];

section .bss
absolute 16975
Buffer resb 35000
section .text
;-38 char *BufferPtr;

BufferPtr dw 0
;-39 

;-40 //start array of handles of every open file

;-41 unsigned int  CurrentCluster;

CurrentCluster dw 0
;-42 unsigned int  NextCluster;

NextCluster dw 0
;-43 unsigned long StartSectorL;		//start sector in current cluster

StartSectorL dd 0
;-44 unsigned long FileSizeL;

FileSizeL dd 0
;-45 unsigned int  lastBytes;		//resting bytes in a sector

lastBytes dw 0
;-46 unsigned int  lastSectors;		//resting sectors in a cluster

lastSectors dw 0
;-47 unsigned int  sectorUpto;		//??

sectorUpto dw 0
;-48 unsigned int  byteUpto;			//??

byteUpto dw 0
;-49 

;-50 unsigned int  CurPosition;		//current byte location in cur sector

CurPosition dw 0
;-51 unsigned long FilePointerL;		//current byte location in file

FilePointerL dd 0
;-52 //	end array of handles of every open file

;-53 

;-54 //FATInit

;-55 unsigned int  fat_FatStartSector;

fat_FatStartSector dw 0
;-56 unsigned long fat_FatStartSectorL;

fat_FatStartSectorL dd 0
;-57 unsigned int  fat_FatSectors;

fat_FatSectors dw 0
;-58 unsigned int  fat_Entries;

fat_Entries dw 0
;-59 unsigned long fat_RootDirStartSectorL;

fat_RootDirStartSectorL dd 0
;-60 unsigned long fat_RootDirSectorsL;

fat_RootDirSectorsL dd 0
;-61 unsigned long fat_DataStartSectorL;

fat_DataStartSectorL dd 0
;-62 unsigned long num_tracksL;

num_tracksL dd 0
;-63 unsigned long Sectors_per_cylinderL;

Sectors_per_cylinderL dd 0
;-64 unsigned long DataSectors32;

DataSectors32 dd 0
;-65 unsigned long CountofClustersL;

CountofClustersL dd 0
;-66 unsigned char trueFATtype;	//12, 16, 32 from FATInit

trueFATtype db 0
;-67 unsigned long bytes_per_clusterL;

bytes_per_clusterL dd 0
;-68 

;-69 //Params from int13h, Function 8

;-70 unsigned int  pa_Cylinders;

pa_Cylinders dw 0
;-71 unsigned char pa_Sectors;

pa_Sectors db 0
;-72 unsigned char pa_Heads;

pa_Heads db 0
;-73 unsigned char pa_Attached;

pa_Attached db 0
;-74 unsigned int  pt_PartNo;

pt_PartNo dw 0
;-75 

;-76 //start hard disk partition structure 16 bytes in MBR. do not change!!!!!

;-77 unsigned char pt_Bootable;		// 00 80h = active partition, else 00

pt_Bootable db 0
;-78 unsigned char pt_StartHead;		// 01

pt_StartHead db 0
;-79 unsigned char pt_StartSector;	// 02 bits 0-5

pt_StartSector db 0
;-80 unsigned int  pt_StartCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-81 unsigned char pt_FileSystem;	// 04 0=nu,1=FAT12,4=16,5=ExtP,6=large16

pt_FileSystem db 0
;-82 unsigned char pt_EndHead;		// 05

pt_EndHead db 0
;-83 unsigned char pt_EndSector;		// 06 bits 0-5

pt_EndSector db 0
;-84 unsigned int  pt_EndCylinder;	//    bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-85 unsigned long pt_HiddenSector;	// 08 sectors preceding partition

pt_HiddenSector dd 0
;-86 unsigned long pt_PartLen;    	// 12 length of partition in sectors

pt_PartLen dd 0
;-87 //  16 end hard disk partition structure

;-88 

;-89 //start boot BIOS Parameter Block structure. do not change!!!!!

;-90 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-91 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-92 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-93 unsigned char bs_clust_size;// 13 sectors per CurrentCluster (1,2,4,..,128)

bs_clust_size db 0
;-94 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-95 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-96 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-97 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-98 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-99 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-100 unsigned int  bs_sectors_per_track; // 24 (DOS 3+)sectors per track

bs_sectors_per_track dw 0
;-101 unsigned int  bs_num_heads;	// 26 (DOS 3+)number of heads

bs_num_heads dw 0
;-102 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors

bs_hid_sects dd 0
;-103 unsigned long bs_tot_sect32;// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-104 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-105 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-106 unsigned char bs_ext_signat;// 38 (DOS 4+) Ext. signature,get next 3(29h)

bs_ext_signat db 0
;-107 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-108 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-109 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-110 // 62 end boot BIOS Parameter Block

;-111 

;-112 //start directory entry structure, do not change!!!!!

;-113 unsigned char dir_Filename[]="1234567";	//00 +lengthbyte=11

dir_Filename db "1234567",0
;-114 unsigned char dir_Ext[]="12";	//07 +lengthbyte=3

dir_Ext db "12",0
;-115 unsigned char dir_Attrib;		//11 directory=10h, Label=08h, read only=1

dir_Attrib db 0
;-116 unsigned char dir_NTReserved;	//12 low case in body=8h, in ext=10h

dir_NTReserved db 0
;-117 unsigned char dir_TimeCreatedMS;//13 in 10 milliseconda or zero

dir_TimeCreatedMS db 0
;-118 unsigned int  dir_TimeCreated;	//14 creation time, resolution 2 sec. or 0

dir_TimeCreated dw 0
;-119 unsigned int  dir_DateCreated;	//16 creation date or zero

dir_DateCreated dw 0
;-120 unsigned int  dir_DateLastAccessd;		//18 no time info available or zero

dir_DateLastAccessd dw 0
;-121 unsigned int  dir_FirstClusterHiBytes;	//20 FAT12/16 always zero

dir_FirstClusterHiBytes dw 0
;-122 unsigned int  dir_LastModTime;	//22 modification time on closing

dir_LastModTime dw 0
;-123 unsigned int  dir_LastModDate;	//24 modification date on closing

dir_LastModDate dw 0
;-124 unsigned int  dir_FirstCluster;	//26 1.clu. of file data,if filesize=0 then0

dir_FirstCluster dw 0
;-125 unsigned long dir_FileSize;		//28 size in bytes, if directory then zero

dir_FileSize dd 0
;-126 // 32 end direcctory entry structure

;-127 

;-128 int test() {


test: PROC
;-129 	__asm{


;-130 }	}


;-131 

;-132 //---------------------------  Start LIB.C  --------------------

;-133 //------------------------------------   IO  -------------------

;-134 

;-135 int writetty()     {//char in AL

 ret
ENDP

writetty: PROC
;-136     ah=0x0E;

 mov  ah, 14
;-137     push bx;

push bx;
;-138     bx=0;			//page in BH

 mov  bx, 0
;-139     inth 0x10;		//16

 int  16
;-140     pop bx;

pop bx;
;-141 }

;-142 int putch(char c)  {

 ret
ENDP

putch: PROC
;-143     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;101 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-144         al=13;

 mov  al, 13
;-145         writetty();

 call writetty
;-146     }

;-147     al=c;

.putch1:
 mov  al, [bp+4]
;-148     writetty();

 call writetty
;-149 }

;-150 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-151     char c;

;-152     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;101 ptr sign byte s = bp+4
;102 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-153         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-154         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-155         s++;

 inc  word[bp+4]
;-156     }

;-157 }

 jmp .cputs2
.cputs3:
;-158 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-159 	char c;

;-160 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;101 ptr sign byte s = bp+4
;102 var sign word len = bp+6
;103 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-161 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-162 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-163 		s++;

 inc  word[bp+4]
;-164 		len--;

 dec  word[bp+6]
;-165 	} while (len > 0);

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-166 }

;-167 

;-168 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-169     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-170     inth 0x16;//AH=Scan code, AL=char

 int  22
;-171 }

;-172 int waitkey() {

 ret
ENDP

waitkey: PROC
;-173     ah=0x11;//get kbd status

 mov  ah, 17
;-174     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-175     //zero flag: 0=IS char, 1=NO char

;-176     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-177 }

;-178 int getkey() {

 ret
ENDP

getkey: PROC
;-179     waitkey();

 call waitkey
;-180     getch();

 call getch
;-181     ah=0;//clear scan code

 mov  ah, 0
;-182     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-183     //put ext code in AX

;-184 }

.getkey6:
;-185 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-186     getkey();

 call getkey
;-187     writetty();//destroys AH

 call writetty
;-188 }

;-189 

;-190 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-191     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;101 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-192     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jbe .printhex47
 add  byte[bp+4], 7
;-193     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-194 }

;-195 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-196     unsigned char nib;

;-197     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;101 var unsg byte c = bp+4
;102 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-198     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-199 }

;-200 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-201     unsigned int half;

;-202     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;101 var unsg word i = bp+4
;102 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-203     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-204 }

;-205 

;-206 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-207     unsigned int e;

;-208     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;101 var unsg word n = bp+4
;102 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10
 jb  .printunsign8
;-209         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-210         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-211         }

;-212     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-213     n+='0';

 add  word[bp+4], 48
;-214     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-215 }

;-216 

;-217 int printunsignedlong(unsigned long n) {

 LEAVE
 ret
ENDP

printunsignedlong: PROC
;-218     unsigned long e;

;-219     unsigned char c;

;-220     if (n >= 10) {

;Function : printunsignedlong, Number local Var: 3
; # type sign width local variables
;101 var unsg long n = bp+4
;102 var unsg long e = bp-4
;103 var unsg byte c = bp-6;
 ENTER  6,0
 mov eax, [bp+4]
 cmp eax, 10
 jb  .printunsignedlong9
;-221         	//emulate e=n/10;

;-222         n;	//asm mov eax, [bp+4] ;n

 mov eax, [bp+4]
;-223         edx = 0;

 mov  edx, 0
;-224         ebx = 10;

 mov  ebx, 10
;-225         asm div ebx

 div ebx
;-226         asm mov [bp-4], eax ;e

 mov [bp-4], eax ;e
;-227         printunsignedlong(e);

 push dword [bp-4]
 call printunsignedlong
 add  sp, 4
;-228     }

;-229     //emulate: c = n % 10; //unsigned mod

;-230         n;	//asm mov eax, [bp+4] ;n

.printunsignedlong9:
 mov eax, [bp+4]
;-231         edx = 0;

 mov  edx, 0
;-232         ebx = 10;

 mov  ebx, 10
;-233         asm div ebx

 div ebx
;-234         asm mov [bp-4], eax ;e

 mov [bp-4], eax ;e
;-235 //    	eax = edx; //modulo

;-236 //    	asm mov [bp-6], al ;c ,convert long2byte	  	

;-237     	asm mov [bp-6], dl ;short for eax = edx; asm mov [bp-6], al	

 mov [bp-6], dl ;short for eax = edx; asm mov [bp-6], al	
;-238     		

;-239     c += '0';

 add  byte[bp-6], 48
;-240     putch(c);//only print with isPrint=on

 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-241 }

;-242 

;-243 int printlong(unsigned long L) {

 LEAVE
 ret
ENDP

printlong: PROC
;-244     ax = L;     // get low in ax

;Function : printlong, Number local Var: 1
; # type sign width local variables
;101 var unsg long L = bp+4;
 ENTER  0,0
 mov  ax, [bp+4]
;-245     edx=L;

 mov  edx, [bp+4]
;-246     edx >> 16;  // get high in dx

 shr  edx, 16
;-247 __asm{


;-248   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-249     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-250 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-251     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-252     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-253 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-254     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-255     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-256     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-257     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-258     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-259     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-260     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-261     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-262 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-263 }	writetty();		__asm{


 call writetty

;-264     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-265     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-266     jb      .b             ;Not yet

    jb      .b             ;Not yet
;-267 }


;-268 }

;-269 //--------------------------------  string  ---------------------

;-270 int strlen1(char *s) { int c;

 LEAVE
 ret
ENDP

strlen1: PROC
;-271     c=0;

;Function : strlen1, Number local Var: 2
; # type sign width local variables
;101 ptr sign byte s = bp+4
;102 var sign word c = bp-2;
 ENTER  2,0
 mov eax, 0
 mov [bp-2], ax
;-272     if (*s == 34) return 0; // "

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 jne .strlen110
 mov eax, 0
 jmp .retnstrlen1
;-273     while (*s!=0) {s++; c++;}

.strlen110:
.strlen111:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen112
 inc  word[bp+4]
 inc  word[bp-2]
;-274     return c;

 jmp .strlen111
.strlen112:
 mov ax, [bp-2]
 jmp .retnstrlen1
;-275 }

;-276 int strcpy(char *s, char *t) {//new

 .retnstrlen1:
 LEAVE
 ret
ENDP

strcpy: PROC
;-277     while (*t!=0) {

;Function : strcpy, Number local Var: 2
; # type sign width local variables
;101 ptr sign byte s = bp+4
;102 ptr sign byte t = bp+6;
 ENTER  0,0
.strcpy13:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy14
;-278     	*s=*t; s++; t++; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-279     *s=0;

 jmp .strcpy13
.strcpy14:
 mov eax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-280     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-281 }

;-282 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-283     while(*p) {

;Function : eqstr, Number local Var: 2
; # type sign width local variables
;101 ptr sign byte p = bp+4
;102 ptr sign byte q = bp+6;
 ENTER  0,0
.eqstr15:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr16
;-284         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr17
 mov eax, 0
 jmp .retneqstr
;-285         p++;

.eqstr17:
 inc  word[bp+4]
;-286         q++;

 inc  word[bp+6]
;-287     }

;-288     if(*q) return 0;

 jmp .eqstr15
.eqstr16:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr18
 mov eax, 0
 jmp .retneqstr
;-289     return 1;

.eqstr18:
 mov eax, 1
 jmp .retneqstr
;-290 }

;-291 

;-292 int memcmp(char *s, char *t, unsigned int i) {

 .retneqstr:
 LEAVE
 ret
ENDP

memcmp: PROC
;-293     do {

;Function : memcmp, Number local Var: 3
; # type sign width local variables
;101 ptr sign byte s = bp+4
;102 ptr sign byte t = bp+6
;103 var unsg word i = bp+8;
 ENTER  0,0
.memcmp19:
;-294         if (*s < *t) return 0xFFFF;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 jge .memcmp20
 mov eax, 65535
 jmp .retnmemcmp
;-295         if (*s > *t) return 1;

.memcmp20:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 jle .memcmp21
 mov eax, 1
 jmp .retnmemcmp
;-296         s++; t++; i--;

.memcmp21:
 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-297     } while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcmp22
 jmp .memcmp19
.memcmp22:
;-298     return 0;

 mov eax, 0
 jmp .retnmemcmp
;-299 }

;-300 

;-301 int strcat(char *s, char *t) {

 .retnmemcmp:
 LEAVE
 ret
ENDP

strcat: PROC
;-302     while (*s != 0) s++;

;Function : strcat, Number local Var: 2
; # type sign width local variables
;101 ptr sign byte s = bp+4
;102 ptr sign byte t = bp+6;
 ENTER  0,0
.strcat23:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat24
 inc  word[bp+4]
;-303     strcpy(s, t);

 jmp .strcat23
.strcat24:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4
;-304 }

;-305 int toupper(char *s) {

 LEAVE
 ret
ENDP

toupper: PROC
;-306     while(*s) {

;Function : toupper, Number local Var: 1
; # type sign width local variables
;101 ptr sign byte s = bp+4;
 ENTER  0,0
.toupper25:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper26
;-307         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97
 jl  .toupper27
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  .toupper28
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
;-308         s++;

.toupper28:
.toupper27:
 inc  word[bp+4]
;-309     }

;-310 }

 jmp .toupper25
.toupper26:
;-311 int strchr(char *s, char c) {

 LEAVE
 ret
ENDP

strchr: PROC
;-312     while(*s) {

;Function : strchr, Number local Var: 2
; # type sign width local variables
;101 ptr sign byte s = bp+4
;102 var sign byte c = bp+6;
 ENTER  0,0
.strchr29:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .strchr30
;-313         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .strchr31
 mov ax, [bp+4]
 jmp .retnstrchr
;-314         s++;

.strchr31:
 inc  word[bp+4]
;-315     }

;-316     return 0;

 jmp .strchr29
.strchr30:
 mov eax, 0
 jmp .retnstrchr
;-317 }

;-318 int memchr(char *s, char c, unsigned int i) {

 .retnstrchr:
 LEAVE
 ret
ENDP

memchr: PROC
;-319     while(i > 0) {

;Function : memchr, Number local Var: 3
; # type sign width local variables
;101 ptr sign byte s = bp+4
;102 var sign byte c = bp+6
;103 var unsg word i = bp+8;
 ENTER  0,0
.memchr32:
 mov ax, [bp+8]
 cmp ax, 0
 jbe .memchr33
;-320         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr34
 mov ax, [bp+4]
 jmp .retnmemchr
;-321         s++; i--;

.memchr34:
 inc  word[bp+4]
 dec  word[bp+8]
;-322     }

;-323     return 0;

 jmp .memchr32
.memchr33:
 mov eax, 0
 jmp .retnmemchr
;-324 }

;-325 int memchr1(char *s, char c, unsigned int i) {

 .retnmemchr:
 LEAVE
 ret
ENDP

memchr1: PROC
;-326 	unsigned int pos;

;-327 	pos=1;

;Function : memchr1, Number local Var: 4
; # type sign width local variables
;101 ptr sign byte s = bp+4
;102 var sign byte c = bp+6
;103 var unsg word i = bp+8
;104 var unsg word pos = bp-2;
 ENTER  2,0
 mov eax, 1
 mov [bp-2], ax
;-328     while(i > 0) {

.memchr135:
 mov ax, [bp+8]
 cmp ax, 0
 jbe .memchr136
;-329         if (*s==c) return pos;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .memchr137
 mov ax, [bp-2]
 jmp .retnmemchr1
;-330         s++; i--; pos++;

.memchr137:
 inc  word[bp+4]
 dec  word[bp+8]
 inc  word[bp-2]
;-331     }

;-332     return 0;

 jmp .memchr135
.memchr136:
 mov eax, 0
 jmp .retnmemchr1
;-333 }

;-334 int instr1(char *s, char c) {

 .retnmemchr1:
 LEAVE
 ret
ENDP

instr1: PROC
;-335     while(*s) {

;Function : instr1, Number local Var: 2
; # type sign width local variables
;101 ptr sign byte s = bp+4
;102 var sign byte c = bp+6;
 ENTER  0,0
.instr138:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .instr139
;-336         if (*s==c) return 1;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .instr140
 mov eax, 1
 jmp .retninstr1
;-337         s++;

.instr140:
 inc  word[bp+4]
;-338     }

;-339     return 0;

 jmp .instr138
.instr139:
 mov eax, 0
 jmp .retninstr1
;-340 }

;-341 

;-342 int memcpy(char *s, char *t, unsigned int i) {

 .retninstr1:
 LEAVE
 ret
ENDP

memcpy: PROC
;-343 	unsigned int r;

;-344 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;101 ptr sign byte s = bp+4
;102 ptr sign byte t = bp+6
;103 var unsg word i = bp+8
;104 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-345 	do {

.memcpy41:
;-346 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-347 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-348 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy42
 jmp .memcpy41
.memcpy42:
;-349 	ax=r;//	return r;

 mov  ax, [bp-2]
;-350 }

;-351 

;-352 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-353     unsigned char c; unsigned char chal; int i; int j; int k;

;-354     j=0;

;Function : mdump, Number local Var: 7
; # type sign width local variables
;101 ptr unsg byte adr = bp+4
;102 var unsg word len = bp+6
;103 var unsg byte c = bp-2
;104 var unsg byte chal = bp-4
;105 var sign word i = bp-6
;106 var sign word j = bp-8
;107 var sign word k = bp-10;
 ENTER  10,0
 mov eax, 0
 mov [bp-8], ax
;-355     k=0;

 mov eax, 0
 mov [bp-10], ax
;-356 	putch(10);

 push 10
 call putch
 add  sp, 2
;-357 	cputs("Ofs=");

 push mdump_0
 call cputs
 add  sp, 2
;-358 	printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-359 	cputs(" Length=");

 push mdump_1
 call cputs
 add  sp, 2
;-360 	printunsign(len);

 push word [bp+6]
 call printunsign
 add  sp, 2
;-361     while (j < len ) {

.mdump43:
 mov ax, [bp-8]
 cmp ax, [bp+6]
 jge .mdump44
;-362 	    k++;;

 inc  word[bp-10]
;-363 	    if (k > 16) {

 mov ax, [bp-10]
 cmp ax, 16
 jle .mdump45
;-364 		    chal = getkey();//remove scan code

 call getkey
 mov [bp-4], al
;-365 		    if (chal =='q') return;

 mov al, [bp-4]
 cmp al, 113
 jne .mdump46
 jmp .retnmdump
;-366 		    k=1;

.mdump46:
 mov eax, 1
 mov [bp-10], ax
;-367 		    putch(10);

 push 10
 call putch
 add  sp, 2
;-368 		    cputs("Ofs=");

 push mdump_2
 call cputs
 add  sp, 2
;-369 		    printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-370 		    }

;-371         putch(10);

.mdump45:
 push 10
 call putch
 add  sp, 2
;-372         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-373         putch(':');

 push 58
 call putch
 add  sp, 2
;-374         i=0;

 mov eax, 0
 mov [bp-6], ax
;-375         while (i < 16) {

.mdump47:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump48
;-376             putch(' ');

 push 32
 call putch
 add  sp, 2
;-377             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-378             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-379             adr++;

 inc  word[bp+4]
;-380             i++;

 inc  word[bp-6]
;-381             j++;

 inc  word[bp-8]
;-382             }

;-383         putch(' ');

 jmp .mdump47
.mdump48:
 push 32
 call putch
 add  sp, 2
;-384         adr -=16;

 sub  word[bp+4], 16
;-385         i=0;

 mov eax, 0
 mov [bp-6], ax
;-386         while(i < 16) {

.mdump49:
 mov ax, [bp-6]
 cmp ax, 16
 jge .mdump50
;-387             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-388             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jae .mdump51
 push 46
 call putch
 add  sp, 2
;-389                 else putch(c);

 jmp .mdump52
.mdump51:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-390             adr++;

.mdump52:
 inc  word[bp+4]
;-391             i++;

 inc  word[bp-6]
;-392         }

;-393     }

 jmp .mdump49
.mdump50:
;-394     getkey();

 jmp .mdump43
.mdump44:
 call getkey
;-395     putch(10);

 push 10
 call putch
 add  sp, 2
;-396 

;-397 }

;-398 int dumpASCII(unsigned char *adr, unsigned int len ) {

 .retnmdump:
 LEAVE
 ret
mdump_0 db "Ofs=",0
mdump_1 db " Length=",0
mdump_2 db "Ofs=",0
ENDP

dumpASCII: PROC
;-399     unsigned char c; unsigned char chal; int i; int j; int k;

;-400     j=0;

;Function : dumpASCII, Number local Var: 7
; # type sign width local variables
;101 ptr unsg byte adr = bp+4
;102 var unsg word len = bp+6
;103 var unsg byte c = bp-2
;104 var unsg byte chal = bp-4
;105 var sign word i = bp-6
;106 var sign word j = bp-8
;107 var sign word k = bp-10;
 ENTER  10,0
 mov eax, 0
 mov [bp-8], ax
;-401     k=0;

 mov eax, 0
 mov [bp-10], ax
;-402 	putch(10);

 push 10
 call putch
 add  sp, 2
;-403 	cputs("Ofs=");

 push dumpASCII_0
 call cputs
 add  sp, 2
;-404 	printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-405 	cputs(" Length=");

 push dumpASCII_1
 call cputs
 add  sp, 2
;-406 	printunsign(len);

 push word [bp+6]
 call printunsign
 add  sp, 2
;-407     while (j < len ) {

.dumpASCII53:
 mov ax, [bp-8]
 cmp ax, [bp+6]
 jge .dumpASCII54
;-408 	    k++;;

 inc  word[bp-10]
;-409 	    if (k > 16) {

 mov ax, [bp-10]
 cmp ax, 16
 jle .dumpASCII55
;-410 		    chal = getkey();//remove scan code

 call getkey
 mov [bp-4], al
;-411 		    if (chal =='q') return;

 mov al, [bp-4]
 cmp al, 113
 jne .dumpASCII56
 jmp .retndumpASCII
;-412 		    k=1;

.dumpASCII56:
 mov eax, 1
 mov [bp-10], ax
;-413 		    putch(10);

 push 10
 call putch
 add  sp, 2
;-414 		    cputs("Ofs=");

 push dumpASCII_2
 call cputs
 add  sp, 2
;-415 		    printunsign(j);

 push word [bp-8]
 call printunsign
 add  sp, 2
;-416 		    }

;-417         putch(10);

.dumpASCII55:
 push 10
 call putch
 add  sp, 2
;-418         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-419         putch(':');

 push 58
 call putch
 add  sp, 2
;-420         i=0;

 mov eax, 0
 mov [bp-6], ax
;-421         while(i < 64) {

.dumpASCII57:
 mov ax, [bp-6]
 cmp ax, 64
 jge .dumpASCII58
;-422             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-423             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jae .dumpASCII59
 push 46
 call putch
 add  sp, 2
;-424                 else putch(c);

 jmp .dumpASCII60
.dumpASCII59:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-425             adr++;

.dumpASCII60:
 inc  word[bp+4]
;-426             i++;

 inc  word[bp-6]
;-427             j++;

 inc  word[bp-8]
;-428         }

;-429     }

 jmp .dumpASCII57
.dumpASCII58:
;-430     getkey();

 jmp .dumpASCII53
.dumpASCII54:
 call getkey
;-431     putch(10);

 push 10
 call putch
 add  sp, 2
;-432 

;-433 }

;-434 //---------------------------   END LIB.C   --------------------

;-435 

;-436 

;-437 

;-438 //--------------------------------  disk IO  -------------------

;-439 

;-440 int DiskSectorReadWrite(char rw, char drive, char head, int cyl,

 .retndumpASCII:
 LEAVE
 ret
dumpASCII_0 db "Ofs=",0
dumpASCII_1 db " Length=",0
dumpASCII_2 db "Ofs=",0
ENDP

DiskSectorReadWrite: PROC
;-441 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-442 	BIOS_ERR=0;

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;101 var sign byte rw = bp+4
;102 var sign byte drive = bp+6
;103 var sign byte head = bp+8
;104 var sign word cyl = bp+10
;105 var sign byte sector = bp+12
;106 var sign byte count = bp+14
;107 var sign word BufSeg = bp+16
;108 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov eax, 0
 mov byte [BIOS_ERR], al
;-443 	dl=drive;

 mov  dl, [bp+6]
;-444 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-445 	es=BufSeg;

 mov  es, [bp+16]
;-446 	bx=BufOfs;

 mov  bx, [bp+18]
;-447 	cx=cyl;

 mov  cx, [bp+10]
;-448 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-449 	cx >> 2;//in 2 high bits of cl

 shr  cx, 2
;-450 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-451 	cl += sector;

 add  cl, [bp+12]
;-452 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-453 	al=count;

 mov  al, [bp+14]
;-454 	ah=rw;

 mov  ah, [bp+4]
;-455 	inth 0x13;

 int  19
;-456     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-457 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-458 }

;-459 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-460 	BIOS_ERR=0;

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;101 var sign byte drive = bp+4
;102 var sign byte function = bp+6;
 ENTER  0,0
 mov eax, 0
 mov byte [BIOS_ERR], al
;-461 	dl=drive;

 mov  dl, [bp+4]
;-462 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-463 	inth 0x13;

 int  19
;-464     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-465 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-466 }

;-467 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-468 	cputs("*** DISK ERROR *** AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-469 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-470 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-471 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-472 }

;-473 int Status(drive) {

 ret
Int13hError_0 db "*** DISK ERROR *** AX=",0
Int13hError_1 db ".  ",0
ENDP

Status: PROC
;-474 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;101 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-475 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-476 	BIOS_Status=Int13hfunction(drive, 1);

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-477 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Status61
 call Int13hError
;-478 	printhex16(BIOS_Status);

.Status61:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-479 }

;-480 

;-481 int Params() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

Params: PROC
;-482 	if (debug) cputs(" DriveParams");

 mov eax, 1
 or  al, al
 je .Params62
 push Params_0
 call cputs
 add  sp, 2
;-483 	BIOS_Status=Int13hfunction(Drive, 8);

.Params62:
 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-484 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params63
;-485 		Int13hError();

 call Int13hError
;-486 		return 1;

 mov eax, 1
 jmp .retnParams
;-487 		}

;-488 	else {

 jmp .Params64
.Params63:
;-489 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-490 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-491 		// CX =       ---CH--- ---CL---

;-492 		// cylinder : 76543210 98

;-493 		// sector   :            543210

;-494 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-495 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-496 //		pa_Sectors++;//1 to 64

;-497 

;-498 		asm mov [pa_Cylinders],    cx

 mov [pa_Cylinders],    cx
;-499 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-500 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-501 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty

 add [pa_Cylinders],    ch;//byte add, low byte is empty
;-502 

;-503 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params65
;-504 			cputs(" ** no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-505 			return 1;

 mov eax, 1
 jmp .retnParams
;-506 			}

;-507 	}

.Params65:
;-508 	return 0;

.Params64:
 mov eax, 0
 jmp .retnParams
;-509 }

;-510 

;-511 

;-512 int getPartitionData() {

 .retnParams:
 ret
Params_0 db " DriveParams",0
Params_1 db " ** no hard disk found",0
ENDP

getPartitionData: PROC
;-513 	unsigned int j; char c; char *p;

;-514 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;101 var unsg word j = bp-2
;102 var sign byte c = bp-4
;103 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [pt_PartNo]
 shl ax, 4
 mov [bp-2], ax
;-515 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-516 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-517 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-518 	pt_StartCylinder=(int)pt_StartSector;

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-519 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-520 //	pt_StartSector++;//Sector start with 1 todo

;-521 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-522 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-523 	j++;

 inc  word[bp-2]
;-524 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-525 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-526 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB

;-527 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-528 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-529 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-530 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-531 //	pt_EndSector++;//Sector start with 1 todo

;-532 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-533 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-534 	j++;

 inc  word[bp-2]
;-535 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-536 	j++;

 inc  word[bp-2]
;-537 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-538 	memcpy(&pt_HiddenSector, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-539 }

;-540 

;-541 int checkBootSign() {

 LEAVE
 ret
ENDP

checkBootSign: PROC
;-542 	int i;

;-543 	i=510;

;Function : checkBootSign, Number local Var: 1
; # type sign width local variables
;101 var sign word i = bp-2;
 ENTER  2,0
 mov eax, 510
 mov [bp-2], ax
;-544 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign66
;-545 		i++;

 inc  word[bp-2]
;-546 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign67
 mov eax, 1
 jmp .retncheckBootSign
;-547 	}

.checkBootSign67:
;-548 	cputs("  **Magic number NOT found.");

.checkBootSign66:
 push checkBootSign_0
 call cputs
 add  sp, 2
;-549 	return 0;

 mov eax, 0
 jmp .retncheckBootSign
;-550 }

;-551 

;-552 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db "  **Magic number NOT found.",0
ENDP

readMBR: PROC
;-553 	int isFAT;

;-554 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;101 var sign word isFAT = bp-2;
 ENTER  2,0
 mov eax, 0
 mov [bp-2], ax
;-555 	pt_PartNo=0;

 mov eax, 0
 mov word [pt_PartNo], ax
;-556 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-557 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR68
;-558 		Int13hError();

 call Int13hError
;-559 		return 0;

 mov eax, 0
 jmp .retnreadMBR
;-560 		}

;-561 	else {

 jmp .readMBR69
.readMBR68:
;-562 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .readMBR70
 mov eax, 0
 jmp .retnreadMBR
;-563 		do {

.readMBR70:
.readMBR71:
;-564 			getPartitionData();

 call getPartitionData
;-565 

;-566 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR72
;-567 				if (debug) cputs(" Boot part. found");

 mov eax, 1
 or  al, al
 je .readMBR73
 push readMBR_0
 call cputs
 add  sp, 2
;-568 				if (pt_FileSystem == 1) {

.readMBR73:
 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR74
;-569 					cputs(", FAT12 part. <32MB");

 push readMBR_1
 call cputs
 add  sp, 2
;-570 					isFAT=1;

 mov eax, 1
 mov [bp-2], ax
;-571 					}

;-572 				if (pt_FileSystem == 4) {

.readMBR74:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR75
;-573 					cputs(", small FAT16 part.<32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-574 					isFAT=4;

 mov eax, 4
 mov [bp-2], ax
;-575 					}

;-576 				if (pt_FileSystem == 6) {

.readMBR75:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR76
;-577 					if (debug) cputs(", large FAT16 part.");

 mov eax, 1
 or  al, al
 je .readMBR77
 push readMBR_3
 call cputs
 add  sp, 2
;-578 					isFAT=6;

.readMBR77:
 mov eax, 6
 mov [bp-2], ax
;-579 					}

;-580 				pt_PartNo=99;//end of loop

.readMBR76:
 mov eax, 99
 mov word [pt_PartNo], ax
;-581 			}

;-582 			pt_PartNo ++;

.readMBR72:
 inc  word[pt_PartNo]
;-583 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jae .readMBR78
 jmp .readMBR71
.readMBR78:
;-584 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-585 	}

;-586 }

.readMBR69:
;-587 

;-588 int getBootSector() {

 .retnreadMBR:
 LEAVE
 ret
readMBR_0 db " Boot part. found",0
readMBR_1 db ", FAT12 part. <32MB",0
readMBR_2 db ", small FAT16 part.<32MB",0
readMBR_3 db ", large FAT16 part.",0
ENDP

getBootSector: PROC
;-589 	int i;

;-590 	if (debug) cputs(" Boot sector:");

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;101 var sign word i = bp-2;
 ENTER  2,0
 mov eax, 1
 or  al, al
 je .getBootSector79
 push getBootSector_0
 call cputs
 add  sp, 2
;-591   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

.getBootSector79:
;-592   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-593 	if (debug) printhex16(BIOS_Status);

 mov eax, 1
 or  al, al
 je .getBootSector80
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-594 	if (BIOS_ERR) {

.getBootSector80:
 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector81
;-595 		Int13hError();

 call Int13hError
;-596 		return 0;

 mov eax, 0
 jmp .retngetBootSector
;-597 		}

;-598 	else {

 jmp .getBootSector82
.getBootSector81:
;-599 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .getBootSector83
 mov eax, 0
 jmp .retngetBootSector
;-600 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector83:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-601 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector84
 push getBootSector_1
 call cputs
 add  sp, 2
;-602 		i=2;

.getBootSector84:
 mov eax, 2
 mov [bp-2], ax
;-603 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector85
 push getBootSector_2
 call cputs
 add  sp, 2
;-604 	}

.getBootSector85:
;-605 	return 1;

.getBootSector82:
 mov eax, 1
 jmp .retngetBootSector
;-606 }

;-607 

;-608 int FATInit() {

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Boot sector:",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-609 	unsigned long templong;//converting word to dword

;-610 

;-611 	clust_sizeL = (long) bs_clust_size;//1--127

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;101 var unsg long templong = bp-4;
 ENTER  4,0
 xor eax, eax
 mov al, [bs_clust_size]
 mov dword [clust_sizeL], eax
;-612 	sector_sizeL= (long) bs_sect_size; //512

 xor eax, eax
 mov ax, [bs_sect_size]
 mov dword [sector_sizeL], eax
;-613 

;-614 	fat_FatStartSector = bs_res_sects;

 mov ax, [bs_res_sects]
 mov word [fat_FatStartSector], ax
;-615 	fat_FatStartSectorL= (long) fat_FatStartSector; 

 xor eax, eax
 mov ax, [fat_FatStartSector]
 mov dword [fat_FatStartSectorL], eax
;-616 	fat_FatSectors = bs_fat_size;

 mov ax, [bs_fat_size]
 mov word [fat_FatSectors], ax
;-617 	if (bs_num_fats == 2) fat_FatSectors=fat_FatSectors+fat_FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .FATInit86
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-618 

;-619 	fat_Entries = bs_fat_size >> 1;//2 bytes for one entry

.FATInit86:
 mov ax, [bs_fat_size]
 shr ax, 1
 mov word [fat_Entries], ax
;-620 	fat_Entries -=2;//first 2 entries not used

 sub  word[fat_Entries], 2
;-621 	

;-622 	fat_RootDirStartSectorL = (long)fat_FatStartSector + fat_FatSectors;

 xor eax, eax
 mov ax, [fat_FatStartSector]
 add ax, [fat_FatSectors]
 mov dword [fat_RootDirStartSectorL], eax
;-623 	

;-624 	fat_RootDirSectorsL = (long) bs_root_entr >> 4;//  ./. 16

 xor eax, eax
 mov ax, [bs_root_entr]
 shr ax, 4
 mov dword [fat_RootDirSectorsL], eax
;-625 		

;-626 	fat_DataStartSectorL = fat_RootDirStartSectorL + fat_RootDirSectorsL;

 mov eax, [fat_RootDirStartSectorL]
 add eax, [fat_RootDirSectorsL]
 mov dword [fat_DataStartSectorL], eax
;-627 

;-628 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .FATInit87
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-629 	DataSectors32=bs_tot_sect32 - fat_DataStartSectorL;

.FATInit87:
 mov eax, [bs_tot_sect32]
 sub eax, [fat_DataStartSectorL]
 mov dword [DataSectors32], eax
;-630 

;-631 	CountofClustersL=DataSectors32 / clust_sizeL;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [clust_sizeL]
 mov dword [CountofClustersL], eax
;-632 

;-633 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-634 	num_tracksL = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [num_tracksL], eax
;-635 

;-636 //	templong = (long) bs_num_heads;

;-637 //	fat_num_cylinders = num_tracksL / templong;//w=d/w

;-638 	

;-639 	bytes_per_clusterL = (long) bs_clust_size * bs_sect_size;

 xor eax, eax
 mov al, [bs_clust_size]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_sect_size]
 mov dword [bytes_per_clusterL], eax
;-640 

;-641 	Sectors_per_cylinderL = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinderL], eax
;-642 	asm mov [Sectors_per_cylinderL + 2], dx;store high word

 mov [Sectors_per_cylinderL + 2], dx;store high word
;-643 

;-644 	templong = (long) 65525;

 xor eax, eax
 mov eax, 65525
 mov [bp-4], eax
;-645 	if (CountofClustersL > templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jbe .FATInit88
;-646 		trueFATtype=32;

 mov eax, 32
 mov byte [trueFATtype], al
;-647 		cputs(" FAT32 NOT supported");

 push FATInit_0
 call cputs
 add  sp, 2
;-648 		return 1;

 mov eax, 1
 jmp .retnFATInit
;-649 		}

;-650 	templong= (long) 4086;

.FATInit88:
 xor eax, eax
 mov eax, 4086
 mov [bp-4], eax
;-651 	if (CountofClustersL < templong) {

 mov eax, [CountofClustersL]
 cmp eax, [bp-4]
 jae .FATInit89
;-652 		trueFATtype=12;

 mov eax, 12
 mov byte [trueFATtype], al
;-653 		cputs(" FAT12");

 push FATInit_1
 call cputs
 add  sp, 2
;-654 		return 0;

 mov eax, 0
 jmp .retnFATInit
;-655 		}

;-656 	trueFATtype=16;

.FATInit89:
 mov eax, 16
 mov byte [trueFATtype], al
;-657 	if (debug) cputs(" FAT16");

 mov eax, 1
 or  al, al
 je .FATInit90
 push FATInit_2
 call cputs
 add  sp, 2
;-658 	return 0;

.FATInit90:
 mov eax, 0
 jmp .retnFATInit
;-659 }

;-660 

;-661 int Int13hExt() {

 .retnFATInit:
 LEAVE
 ret
FATInit_0 db " FAT32 NOT supported",0
FATInit_1 db " FAT12",0
FATInit_2 db " FAT16",0
ENDP

Int13hExt: PROC
;-662 	bx=0x55AA;

 mov  bx, 21930
;-663 	BIOS_Status=Int13hfunction(Drive, 0x41);

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-664 	asm mov [vAX], ax;

 mov [vAX], ax;
;-665 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-666 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported
;-667 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt91
;-668 		cputs(" Ext. NOT present");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-669 		Int13hError();

 call Int13hError
;-670 		return 1;

 mov eax, 1
 jmp .retnInt13hExt
;-671 		}

;-672 	else if (debug) cputs(",Int13h Ext.");

 jmp .Int13hExt92
.Int13hExt91:
 mov eax, 1
 or  al, al
 je .Int13hExt93
 push Int13hExt_1
 call cputs
 add  sp, 2
;-673 	putch(10);

.Int13hExt93:
.Int13hExt92:
 push 10
 call putch
 add  sp, 2
;-674 	return 0;

 mov eax, 0
 jmp .retnInt13hExt
;-675 }

;-676 

;-677 int PrintDriveParameter() {

 .retnInt13hExt:
 ret
Int13hExt_0 db " Ext. NOT present",0
Int13hExt_1 db ",Int13h Ext.",0
ENDP

PrintDriveParameter: PROC
;-678 	unsigned long Lo;

;-679 // from Params

;-680 	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);

;Function : PrintDriveParameter, Number local Var: 1
; # type sign width local variables
;101 var unsg long Lo = bp-4;
 ENTER  4,0
 push PrintDriveParameter_0
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-681 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-682 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-683 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-684 	putch('.');

 push 46
 call putch
 add  sp, 2
;-685 //from getPartitionData

;-686 	putch(10);

 push 10
 call putch
 add  sp, 2
;-687 	cputs("getPartitionData:No=");printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-688 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-689 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-690 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-691 	cputs("/");				printunsign(pt_StartSector);

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-692 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-693 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-694 	cputs("/");				printunsign(pt_EndSector);

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-695 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-696 	cputs(",Start=");		printlong(pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 push dword [pt_HiddenSector]
 call printlong
 add  sp, 4
;-697 	cputs(",Len=");			printlong(pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 push dword [pt_PartLen]
 call printlong
 add  sp, 4
;-698 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-699 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-700 	printlong(Lo);

 push dword [bp-4]
 call printlong
 add  sp, 4
;-701 	cputs(" MByte.");

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-702 //from getBootSector

;-703 	putch(10);

 push 10
 call putch
 add  sp, 2
;-704 	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-705 	putch(10);

 push 10
 call putch
 add  sp, 2
;-706 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-707 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-708 	putch(10);

 push 10
 call putch
 add  sp, 2
;-709 	cputs("Reserved sectors=");printunsign(bs_res_sects);

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-710 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-711 	putch(10);

 push 10
 call putch
 add  sp, 2
;-712 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-713 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-714 	putch(10);

 push 10
 call putch
 add  sp, 2
;-715 	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-716 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-717 	putch(10);

 push 10
 call putch
 add  sp, 2
;-718 	cputs("sectors per track=");printunsign(bs_sectors_per_track);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_sectors_per_track]
 call printunsign
 add  sp, 2
;-719 	cputs(".number of heads=");printunsign(bs_num_heads);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_heads]
 call printunsign
 add  sp, 2
;-720 	putch(10);

 push 10
 call putch
 add  sp, 2
;-721 	cputs("hidden sectors(long)=");printlong(bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 push dword [bs_hid_sects]
 call printlong
 add  sp, 4
;-722 	cputs(".sectors(long)=");printlong(bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 push dword [bs_tot_sect32]
 call printlong
 add  sp, 4
;-723 	putch(10);

 push 10
 call putch
 add  sp, 2
;-724 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-725 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-726 	putch(10);

 push 10
 call putch
 add  sp, 2
;-727 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-728 	cputs(".Volume serial(long)=");printlong(bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 push dword [bs_serial_num]
 call printlong
 add  sp, 4
;-729 	putch(10);

 push 10
 call putch
 add  sp, 2
;-730 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-731 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-732 //from FATInit

;-733 	putch(10);

 push 10
 call putch
 add  sp, 2
;-734 	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [fat_FatStartSector]
 call printunsign
 add  sp, 2
;-735 	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [fat_FatSectors]
 call printunsign
 add  sp, 2
;-736 	cputs(", fat_Entries=");	printunsign(fat_Entries);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push word [fat_Entries]
 call printunsign
 add  sp, 2
;-737 	putch(10);

 push 10
 call putch
 add  sp, 2
;-738 	cputs("fat_RootDirStartSectorL="); printlong(fat_RootDirStartSectorL);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push dword [fat_RootDirStartSectorL]
 call printlong
 add  sp, 4
;-739 	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectorsL);

 push PrintDriveParameter_38
 call cputs
 add  sp, 2
 push dword [fat_RootDirSectorsL]
 call printunsign
 add  sp, 4
;-740 	putch(10);

 push 10
 call putch
 add  sp, 2
;-741 	cputs("fat_DataStartSectorL=");	printunsign(fat_DataStartSectorL);

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 push dword [fat_DataStartSectorL]
 call printunsign
 add  sp, 4
;-742 	cputs(", DataSectors32=");	printlong(DataSectors32);

 push PrintDriveParameter_40
 call cputs
 add  sp, 2
 push dword [DataSectors32]
 call printlong
 add  sp, 4
;-743 	putch(10);

 push 10
 call putch
 add  sp, 2
;-744 	cputs("CountofClustersL=");	printlong(CountofClustersL);

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 push dword [CountofClustersL]
 call printlong
 add  sp, 4
;-745 	cputs(", Sectors_per_cylinderL="); printlong(Sectors_per_cylinderL);

 push PrintDriveParameter_42
 call cputs
 add  sp, 2
 push dword [Sectors_per_cylinderL]
 call printlong
 add  sp, 4
;-746 	putch(10);

 push 10
 call putch
 add  sp, 2
;-747 	cputs("num_tracksL=");	printlong(num_tracksL);

 push PrintDriveParameter_43
 call cputs
 add  sp, 2
 push dword [num_tracksL]
 call printlong
 add  sp, 4
;-748 	cputs(", bytes_per_clusterL=");	printlong(bytes_per_clusterL);

 push PrintDriveParameter_44
 call cputs
 add  sp, 2
 push dword [bytes_per_clusterL]
 call printlong
 add  sp, 4
;-749 //	cputs(", fat_num_cylinders="); printunsign(fat_num_cylinders);

;-750 	putch(10);

 push 10
 call putch
 add  sp, 2
;-751 	getkey();

 call getkey
;-752 }

;-753 

;-754 //--------------------------------  file IO  -------------------

;-755 int error2(char *s) {

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
;-756 	putch(10);

;Function : error2, Number local Var: 1
; # type sign width local variables
;101 ptr sign byte s = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-757 	cputs("*** ERROR *** ");

 push error2_0
 call cputs
 add  sp, 2
;-758 	cputs(s);

 push word [bp+4]
 call cputs
 add  sp, 2
;-759 	DOS_ERR++;

 inc  byte[DOS_ERR]
;-760 }

;-761 // 1.

;-762 int readLogical(unsigned long SectorL,unsigned int DSeg, unsigned int DOfs){

 LEAVE
 ret
error2_0 db "*** ERROR *** ",0
ENDP

readLogical: PROC
;-763 	//OUT:1 sector in DiskBuf

;-764 	unsigned int track; unsigned int head; unsigned int sect;

;-765 	SectorL = SectorL + bs_hid_sects;//d=d+d

;Function : readLogical, Number local Var: 6
; # type sign width local variables
;101 var unsg long SectorL = bp+4
;102 var unsg word DSeg = bp+8
;103 var unsg word DOfs = bp+10
;104 var unsg word track = bp-2
;105 var unsg word head = bp-4
;106 var unsg word sect = bp-6;
 ENTER  6,0
 mov eax, [bp+4]
 add eax, [bs_hid_sects]
 mov [bp+4], eax
;-766 	track = SectorL / Sectors_per_cylinderL;  //w=d/d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinderL]
 mov [bp-2], ax
;-767 	head  = SectorL % Sectors_per_cylinderL;  //w=d%d

 mov eax, [bp+4]
 xor edx, edx
 div dword [Sectors_per_cylinderL]
 mov eax, edx
 mov [bp-4], ax
;-768 	sect  = head            % bs_sectors_per_track;  //w=w%w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov ax, dx
 mov [bp-6], ax
;-769 	sect++;

 inc  word[bp-6]
;-770 	head  = head            / bs_sectors_per_track;	 //w=w/w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov [bp-4], ax
;-771 

;-772 	DiskSectorReadWrite(2, bs_drive_num, head, track/* =cyl */,

;-773 		sect, 1, DSeg , DOfs);

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
;-774 	if (BIOS_ERR) error2("readLogical low level");

 mov al, [BIOS_ERR]
 or  al, al
 je .readLogical94
 push readLogical_0
 call error2
 add  sp, 2
;-775 }

.readLogical94:
;-776 // 2.a

;-777 int printDirEntry(int EntryNr) {

 LEAVE
 ret
readLogical_0 db "readLogical low level",0
ENDP

printDirEntry: PROC
;-778     unsigned int j;

;-779 	putch(10);

;Function : printDirEntry, Number local Var: 2
; # type sign width local variables
;101 var sign word EntryNr = bp+4
;102 var unsg word j = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-780 	printunsign(EntryNr);

 push word [bp+4]
 call printunsign
 add  sp, 2
;-781 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-782 	cputs(filename);

 lea  ax, [filename]
 push ax
 call cputs
 add  sp, 2
;-783 	cputs(" ATTR:");

 push printDirEntry_0
 call cputs
 add  sp, 2
;-784 	printhex8(dir_Attrib);	

 mov al, byte [dir_Attrib]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-785 	if (dir_Attrib &  1) cputs(" r/o");

 mov al, [dir_Attrib]
 and al, 1
 or  al, al
 je .printDirEntry95
 push printDirEntry_1
 call cputs
 add  sp, 2
;-786 	if (dir_Attrib &  2) cputs(" hid");

.printDirEntry95:
 mov al, [dir_Attrib]
 and al, 2
 or  al, al
 je .printDirEntry96
 push printDirEntry_2
 call cputs
 add  sp, 2
;-787 	if (dir_Attrib &  4) cputs(" sys");

.printDirEntry96:
 mov al, [dir_Attrib]
 and al, 4
 or  al, al
 je .printDirEntry97
 push printDirEntry_3
 call cputs
 add  sp, 2
;-788 	if (dir_Attrib &  8) cputs(" vol");		

.printDirEntry97:
 mov al, [dir_Attrib]
 and al, 8
 or  al, al
 je .printDirEntry98
 push printDirEntry_4
 call cputs
 add  sp, 2
;-789 	if (dir_Attrib & 16) cputs(" dir");

.printDirEntry98:
 mov al, [dir_Attrib]
 and al, 16
 or  al, al
 je .printDirEntry99
 push printDirEntry_5
 call cputs
 add  sp, 2
;-790 	if (dir_Attrib & 32) cputs(" arc");

.printDirEntry99:
 mov al, [dir_Attrib]
 and al, 32
 or  al, al
 je .printDirEntry100
 push printDirEntry_6
 call cputs
 add  sp, 2
;-791 	if (dir_Attrib == 0) cputs("    ");

.printDirEntry100:
 mov al, [dir_Attrib]
 cmp al, 0
 jne .printDirEntry101
 push printDirEntry_7
 call cputs
 add  sp, 2
;-792 	

;-793 	putch(' ');

.printDirEntry101:
 push 32
 call putch
 add  sp, 2
;-794 	j=dir_LastModDate & 31;//day

 mov ax, [dir_LastModDate]
 and ax, 31
 mov [bp-2], ax
;-795 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jae .printDirEntry102
 push 32
 call putch
 add  sp, 2
;-796 	printunsign(j);

.printDirEntry102:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-797 	putch('.');

 push 46
 call putch
 add  sp, 2
;-798 

;-799 	j=dir_LastModDate >> 5;//month

 mov ax, [dir_LastModDate]
 shr ax, 5
 mov [bp-2], ax
;-800 	j&=  15;

 and  word[bp-2], 15
;-801 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jae .printDirEntry103
 push 48
 call putch
 add  sp, 2
;-802 	printunsign(j);

.printDirEntry103:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-803 	putch('.');

 push 46
 call putch
 add  sp, 2
;-804 

;-805 	j=dir_LastModDate >> 9;//year

 mov ax, [dir_LastModDate]
 shr ax, 9
 mov [bp-2], ax
;-806 	j+= 1980;

 add  word[bp-2], 1980
;-807 	printunsign(j);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-808 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-809 	//putch(' ');

;-810 

;-811 	j=dir_LastModTime  >>11;//hour

 mov ax, [dir_LastModTime]
 shr ax, 11
 mov [bp-2], ax
;-812 	if (j<10) putch(' ');

 mov ax, [bp-2]
 cmp ax, 10
 jae .printDirEntry104
 push 32
 call putch
 add  sp, 2
;-813 	printunsign(j);

.printDirEntry104:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-814 	putch(':');

 push 58
 call putch
 add  sp, 2
;-815 

;-816 	j=dir_LastModTime  >> 5;//minute

 mov ax, [dir_LastModTime]
 shr ax, 5
 mov [bp-2], ax
;-817 	j&=  63;

 and  word[bp-2], 63
;-818 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jae .printDirEntry105
 push 48
 call putch
 add  sp, 2
;-819 	printunsign(j);

.printDirEntry105:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-820 	putch(':');

 push 58
 call putch
 add  sp, 2
;-821 

;-822 	j=dir_LastModTime & 31;// 2 seconds

 mov ax, [dir_LastModTime]
 and ax, 31
 mov [bp-2], ax
;-823 	j=j+j;

 mov ax, [bp-2]
 add ax, [bp-2]
 mov [bp-2], ax
;-824 	if (j<10) putch('0');

 mov ax, [bp-2]
 cmp ax, 10
 jae .printDirEntry106
 push 48
 call putch
 add  sp, 2
;-825 	printunsign(j);

.printDirEntry106:
 push word [bp-2]
 call printunsign
 add  sp, 2
;-826 	putch(' ');

 push 32
 call putch
 add  sp, 2
;-827 

;-828 	cputs(" 1.Cl:"); 

 push printDirEntry_8
 call cputs
 add  sp, 2
;-829 	printunsign(dir_FirstCluster);

 push word [dir_FirstCluster]
 call printunsign
 add  sp, 2
;-830 	cputs(" Size:");

 push printDirEntry_9
 call cputs
 add  sp, 2
;-831 	printlong(dir_FileSize);

 push dword [dir_FileSize]
 call printlong
 add  sp, 4
;-832 	

;-833 }

;-834 

;-835 // 2.b

;-836 int fatDirSectorList(unsigned long startSector, unsigned long numsectors) {

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
;-837     char *p;

;-838 	unsigned int EndDiskBuf;

;-839 	char isHide;//shows entries, NOT lfn, deleted or empty

;-840 	unsigned int EntryNr;

;-841 	EntryNr=0;

;Function : fatDirSectorList, Number local Var: 6
; # type sign width local variables
;101 var unsg long startSector = bp+4
;102 var unsg long numsectors = bp+8
;103 ptr sign byte p = bp-2
;104 var unsg word EndDiskBuf = bp-4
;105 var sign byte isHide = bp-6
;106 var unsg word EntryNr = bp-8;
 ENTER  8,0
 mov eax, 0
 mov [bp-8], ax
;-842 	do {

.fatDirSectorList107:
;-843 /*		putch(10);

;-844 		cputs("Sektor = "); 

;-845 		printlong(startSector);

;-846 		cputs(", numsectors = "); 

;-847 		printlong(numsectors);

;-848 		getkey();

;-849 */

;-850 		readLogical(startSector, DiskBufSeg, DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp+4]
 call readLogical
 add  sp, 8
;-851 		if (DOS_ERR) return;

 mov al, [DOS_ERR]
 or  al, al
 je .fatDirSectorList108
 jmp .retnfatDirSectorList
;-852 		p=&DiskBuf;

.fatDirSectorList108:
 mov ax, DiskBuf
 mov [bp-2], ax
;-853 		EndDiskBuf= p + bs_sect_size;		

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-854 		

;-855 		do {

.fatDirSectorList109:
;-856 			memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-857 			memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-858 			filename[11] = 0;

 mov eax, 0
 mov bx, 11
 mov [filename+bx], al
;-859 			

;-860 			isHide=0;//show in listing

 mov eax, 0
 mov [bp-6], al
;-861 			if (*p ==    0) {//only empty entries following

 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorList110
;-862 				isHide++;

 inc  byte[bp-6]
;-863 				numsectors=1;//finish searching

 mov eax, 1
 mov [bp+8], eax
;-864 				p = EndDiskBuf;

 mov ax, [bp-4]
 mov [bp-2], ax
;-865 				}

;-866 			if (*p == 0xE5) isHide++;//deleted, free entry

.fatDirSectorList110:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 229
 jne .fatDirSectorList111
 inc  byte[bp-6]
;-867 			if (*p <=   31) isHide++;//part of LFN

.fatDirSectorList111:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 31
 jg  .fatDirSectorList112
 inc  byte[bp-6]
;-868 			if (dir_Attrib ==    15) isHide++;//LFN start

.fatDirSectorList112:
 mov al, [dir_Attrib]
 cmp al, 15
 jne .fatDirSectorList113
 inc  byte[bp-6]
;-869 					

;-870 			if (isHide == 0) printDirEntry(EntryNr);

.fatDirSectorList113:
 mov al, [bp-6]
 cmp al, 0
 jne .fatDirSectorList114
 push word [bp-8]
 call printDirEntry
 add  sp, 2
;-871 			p+=32;//get next entry

.fatDirSectorList114:
 add  word[bp-2], 32
;-872 			EntryNr++;

 inc  word[bp-8]
;-873 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorList115
 jmp .fatDirSectorList109
.fatDirSectorList115:
;-874 		startSector = startSector + 1;//long, do NOT use ++ or +=1

 mov eax, [bp+4]
 add eax, 1
 mov [bp+4], eax
;-875 		numsectors--;

 dec  dword[bp+8]
;-876 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jbe .fatDirSectorList116
 jmp .fatDirSectorList107
.fatDirSectorList116:
;-877 	CurrentCluster=0;//not found but not end

 mov eax, 0
 mov word [CurrentCluster], ax
;-878 }

;-879 

;-880 // 2.

;-881 int fatDirSectorSearch(unsigned long startSector,unsigned long numsectors) {

 .retnfatDirSectorList:
 LEAVE
 ret
ENDP

fatDirSectorSearch: PROC
;-882 //	search for file name. 

;-883 //	IN:  searchstr

;-884 //	OUT: 0=file not found

;-885     char *p;

;-886 	unsigned int EndDiskBuf;

;-887 	do {

;Function : fatDirSectorSearch, Number local Var: 4
; # type sign width local variables
;101 var unsg long startSector = bp+4
;102 var unsg long numsectors = bp+8
;103 ptr sign byte p = bp-2
;104 var unsg word EndDiskBuf = bp-4;
 ENTER  4,0
.fatDirSectorSearch117:
;-888 		readLogical(startSector, DiskBufSeg, DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp+4]
 call readLogical
 add  sp, 8
;-889 		if (DOS_ERR) return 0;

 mov al, [DOS_ERR]
 or  al, al
 je .fatDirSectorSearch118
 mov eax, 0
 jmp .retnfatDirSectorSearch
;-890 		p=&DiskBuf;

.fatDirSectorSearch118:
 mov ax, DiskBuf
 mov [bp-2], ax
;-891 		EndDiskBuf= p + bs_sect_size;

 mov ax, [bp-2]
 add ax, [bs_sect_size]
 mov [bp-4], ax
;-892 		do {

.fatDirSectorSearch119:
;-893 			if (memcmp(p, searchstr, 11) == 0) {//found file name

 push 11
 lea  ax, [searchstr]
 push ax
 push word [bp-2]
 call memcmp
 add  sp, 6
 cmp ax, 0
 jne .fatDirSectorSearch120
;-894 				memcpy(dir_Filename, p, 32);//copy whole dir structure

 push 32
 push word [bp-2]
 lea  ax, [dir_Filename]
 push ax
 call memcpy
 add  sp, 6
;-895 				memcpy(filename, p, 11);

 push 11
 push word [bp-2]
 lea  ax, [filename]
 push ax
 call memcpy
 add  sp, 6
;-896 				filename[11] = 0;

 mov eax, 0
 mov bx, 11
 mov [filename+bx], al
;-897 				CurrentCluster = dir_FirstCluster;

 mov ax, [dir_FirstCluster]
 mov word [CurrentCluster], ax
;-898 				FileSizeL      = dir_FileSize;

 mov eax, [dir_FileSize]
 mov dword [FileSizeL], eax
;-899 				return 1;

 mov eax, 1
 jmp .retnfatDirSectorSearch
;-900 			}

;-901 			if (*p == 0) return 0; //only empty entries following

.fatDirSectorSearch120:
 mov bx, [bp-2]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .fatDirSectorSearch121
 mov eax, 0
 jmp .retnfatDirSectorSearch
;-902 			p+=32;//get next entry

.fatDirSectorSearch121:
 add  word[bp-2], 32
;-903 		} while (p < EndDiskBuf);

 mov ax, [bp-2]
 cmp ax, [bp-4]
 jge .fatDirSectorSearch122
 jmp .fatDirSectorSearch119
.fatDirSectorSearch122:
;-904 		startSector++;		

 inc  dword[bp+4]
;-905 		numsectors--;

 dec  dword[bp+8]
;-906 	} while (numsectors > 0);

 mov eax, [bp+8]
 cmp eax, 0
 jbe .fatDirSectorSearch123
 jmp .fatDirSectorSearch117
.fatDirSectorSearch123:
;-907 	  CurrentCluster=0;//not found but not end

 mov eax, 0
 mov word [CurrentCluster], ax
;-908 	return 0;

 mov eax, 0
 jmp .retnfatDirSectorSearch
;-909 }

;-910 

;-911 /*

;-912 // 3.

;-913 int fatRootSearch() {

;-914     fatDirSectorSearch(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-915 //	getkey();

;-916 //    fatDirSectorList(fat_RootDirStartSectorL, fat_RootDirSectorsL);

;-917 }

;-918 */

;-919 

;-920 // 4.

;-921 int fatClusterAnalyse(unsigned int clust) {

 .retnfatDirSectorSearch:
 LEAVE
 ret
ENDP

fatClusterAnalyse: PROC
;-922 //	OUT: StartSectorL, NextCluster

;-923 //	OUT: 1=error

;-924 	unsigned long fatSectorL;

;-925 	unsigned int offset;

;-926 	char *p;

;-927 	if (clust < 2) { StartSectorL = 0; return 1; }

;Function : fatClusterAnalyse, Number local Var: 4
; # type sign width local variables
;101 var unsg word clust = bp+4
;102 var unsg long fatSectorL = bp-4
;103 var unsg word offset = bp-6
;104 ptr sign byte p = bp-8;
 ENTER  8,0
 mov ax, [bp+4]
 cmp ax, 2
 jae .fatClusterAnalyse124
 mov eax, 0
 mov dword [StartSectorL], eax
 mov eax, 1
 jmp .retnfatClusterAnalyse
;-928 	if ((long) clust >= CountofClustersL) { StartSectorL = 0; return 1; }

.fatClusterAnalyse124:
 xor eax, eax
 mov ax, [bp+4]
 cmp eax, [CountofClustersL]
 jb  .fatClusterAnalyse125
 mov eax, 0
 mov dword [StartSectorL], eax
 mov eax, 1
 jmp .retnfatClusterAnalyse
;-929 

;-930 //StartSectorL = (long) clust -2 * clust_sizeL+fat_DataStartSectorL;

;-931 	StartSectorL = (long) clust -2;

.fatClusterAnalyse125:
 xor eax, eax
 mov ax, [bp+4]
 sub ax, 2
 mov dword [StartSectorL], eax
;-932 	StartSectorL = StartSectorL * clust_sizeL;

 mov eax, [StartSectorL]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul dword [clust_sizeL]
 mov dword [StartSectorL], eax
;-933 	StartSectorL = StartSectorL + fat_DataStartSectorL;

 mov eax, [StartSectorL]
 add eax, [fat_DataStartSectorL]
 mov dword [StartSectorL], eax
;-934 

;-935 //	fatSectorL=cluster*2/512+FatStartSector

;-936 	fatSectorL = (long) clust;

 xor eax, eax
 mov ax, [bp+4]
 mov [bp-4], eax
;-937 	fatSectorL = fatSectorL + fatSectorL;

 mov eax, [bp-4]
 add eax, [bp-4]
 mov [bp-4], eax
;-938 	fatSectorL = fatSectorL / sector_sizeL;		

 mov eax, [bp-4]
 xor edx, edx
 div dword [sector_sizeL]
 mov [bp-4], eax
;-939 	fatSectorL = fatSectorL + fat_FatStartSectorL; 

 mov eax, [bp-4]
 add eax, [fat_FatStartSectorL]
 mov [bp-4], eax
;-940 	readLogical(fatSectorL, DiskBufSeg, DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp-4]
 call readLogical
 add  sp, 8
;-941 	if(DOS_ERR) { StartSectorL = 0; return 1; }

 mov al, [DOS_ERR]
 or  al, al
 je .fatClusterAnalyse126
 mov eax, 0
 mov dword [StartSectorL], eax
 mov eax, 1
 jmp .retnfatClusterAnalyse
;-942 	

;-943 	offset = clust + clust;

.fatClusterAnalyse126:
 mov ax, [bp+4]
 add ax, [bp+4]
 mov [bp-6], ax
;-944 	offset = offset % bs_sect_size;	

 mov ax, [bp-6]
 xor dx, dx
 div word [bs_sect_size]
 mov ax, dx
 mov [bp-6], ax
;-945 	p=&DiskBuf;

 mov ax, DiskBuf
 mov [bp-8], ax
;-946 	p = p + offset;	

 mov ax, [bp-8]
 add ax, [bp-6]
 mov [bp-8], ax
;-947 	memcpy(&NextCluster, p, 2);//OUT: NextCluster

 push 2
 push word [bp-8]
 lea  ax, [NextCluster]
 push ax
 call memcpy
 add  sp, 6
;-948 

;-949 	if (debug) { putch(10);

 mov eax, 1
 or  al, al
 je .fatClusterAnalyse127
 push 10
 call putch
 add  sp, 2
;-950 		cputs(" StartSectorL="); printlong(StartSectorL); 

 push fatClusterAnalyse_0
 call cputs
 add  sp, 2
 push dword [StartSectorL]
 call printlong
 add  sp, 4
;-951 		cputs(" Currentclust="); printunsign(clust);

 push fatClusterAnalyse_1
 call cputs
 add  sp, 2
 push word [bp+4]
 call printunsign
 add  sp, 2
;-952 		cputs(" NextCluster="); printunsign(NextCluster); 

 push fatClusterAnalyse_2
 call cputs
 add  sp, 2
 push word [NextCluster]
 call printunsign
 add  sp, 2
;-953 	}

;-954 	return 0;

.fatClusterAnalyse127:
 mov eax, 0
 jmp .retnfatClusterAnalyse
;-955 }

;-956 

;-957 /*

;-958 // 5.

;-959 int fatDirSearch() {//search a directory chain. IN:searchstr

;-960 	

;-961 	fatClusterAnalyse(fatfile_cluster);

;-962 	//OUT: fatfile_sectorStartL, fatfile_nextCluster

;-963 

;-964 	fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster); 

;-965 	while (fatfile_cluster == 0) {//not found but not end

;-966 		if (fatfile_nextCluster >= 0xFFF8) {

;-967 			fat_notfound=1;

;-968 			return;	

;-969 		}		

;-970 		fatfile_cluster=fatfile_nextCluster;

;-971 		fatClusterAnalyse(fatfile_cluster);

;-972 		fatDirSectorSearch(fatfile_sectorStartL, fatfile_nextCluster);

;-973 	}	

;-974 }

;-975 */	

;-976 

;-977 int is_delimiter(char *s) {

 .retnfatClusterAnalyse:
 LEAVE
 ret
fatClusterAnalyse_0 db " StartSectorL=",0
fatClusterAnalyse_1 db " Currentclust=",0
fatClusterAnalyse_2 db " NextCluster=",0
ENDP

is_delimiter: PROC
;-978 	if (*s == '/' ) return 1;

;Function : is_delimiter, Number local Var: 1
; # type sign width local variables
;101 ptr sign byte s = bp+4;
 ENTER  0,0
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 47
 jne .is_delimiter128
 mov eax, 1
 jmp .retnis_delimiter
;-979 	if (*s == '\\') return 1;

.is_delimiter128:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 92
 jne .is_delimiter129
 mov eax, 1
 jmp .retnis_delimiter
;-980 	if (*s ==    0) return 2;

.is_delimiter129:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 jne .is_delimiter130
 mov eax, 2
 jmp .retnis_delimiter
;-981 	if (*s ==  '.') return 3;

.is_delimiter130:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 46
 jne .is_delimiter131
 mov eax, 3
 jmp .retnis_delimiter
;-982 	return 0;

.is_delimiter131:
 mov eax, 0
 jmp .retnis_delimiter
;-983 }

;-984 

;-985 // 6.

;-986 int fatNextSearch() {//get next part of filename to do a search

 .retnis_delimiter:
 LEAVE
 ret
ENDP

fatNextSearch: PROC
;-987 //	IN:  upto: points to start of search in filename 

;-988 //	OUT: upto: points to search for next time

;-989 //	OUT: searchstr: part of filename in DIR-format with blanks (11bytes)

;-990 //	OUT: isfilename: 0=part of directory, 1=filename

;-991 //	OUT: 0=file not found

;-992 	char *searchstrp;

;-993 	char *p; 

;-994 	unsigned int  len;

;-995 	unsigned int delimiter;

;-996 

;-997 	delimiter=is_delimiter(upto);

;Function : fatNextSearch, Number local Var: 4
; # type sign width local variables
;101 ptr sign byte searchstrp = bp-2
;102 ptr sign byte p = bp-4
;103 var unsg word len = bp-6
;104 var unsg word delimiter = bp-8;
 ENTER  8,0
 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-998 	if (delimiter == 1) upto++;

 mov ax, [bp-8]
 cmp ax, 1
 jne .fatNextSearch132
 inc  word[upto]
;-999 	if (delimiter == 2) return 0; 

.fatNextSearch132:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch133
 mov eax, 0
 jmp .retnfatNextSearch
;-1000 

;-1001 	strcpy(&searchstr, "           ");//11 blank padded

.fatNextSearch133:
 push fatNextSearch_0
 lea  ax, [searchstr]
 push ax
 call strcpy
 add  sp, 4
;-1002 	searchstrp = &searchstr;//clear searchstr

 mov ax, searchstr
 mov [bp-2], ax
;-1003 	len=0;

 mov eax, 0
 mov [bp-6], ax
;-1004 	delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-1005 	while (delimiter == 0) { //no slash, zero, point

.fatNextSearch134:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch135
;-1006 		*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-1007 		searchstrp++;

 inc  word[bp-2]
;-1008 		upto++;	

 inc  word[upto]
;-1009 		len++;

 inc  word[bp-6]
;-1010 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-1011 	} 

;-1012 	if (len > 8) return 0;

 jmp .fatNextSearch134
.fatNextSearch135:
 mov ax, [bp-6]
 cmp ax, 8
 jbe .fatNextSearch136
 mov eax, 0
 jmp .retnfatNextSearch
;-1013 	isfilename=0;//todo: default directory, not yet implemented

.fatNextSearch136:
 mov eax, 0
 mov byte [isfilename], al
;-1014 	if (delimiter == 2) isfilename=1;//last name is always a file name

 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch137
 mov eax, 1
 mov byte [isfilename], al
;-1015 	if (delimiter == 3) {//remove dot in name		

.fatNextSearch137:
 mov ax, [bp-8]
 cmp ax, 3
 jne .fatNextSearch138
;-1016 		searchstrp = &searchstr;

 mov ax, searchstr
 mov [bp-2], ax
;-1017 		searchstrp += 8;//start extension		

 add  word[bp-2], 8
;-1018 		len=0;

 mov eax, 0
 mov [bp-6], ax
;-1019 		upto++;

 inc  word[upto]
;-1020 		delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-1021 		while (delimiter == 0) { //no slash, zero, point

.fatNextSearch139:
 mov ax, [bp-8]
 cmp ax, 0
 jne .fatNextSearch140
;-1022 			*searchstrp = *upto;

 mov bx, [upto]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-1023 			searchstrp++;

 inc  word[bp-2]
;-1024 			upto++;	

 inc  word[upto]
;-1025 			len++;

 inc  word[bp-6]
;-1026 			delimiter=is_delimiter(upto);

 push word [upto]
 call is_delimiter
 add  sp, 2
 mov [bp-8], ax
;-1027 		} 

;-1028 		if (len > 3) return 0;

 jmp .fatNextSearch139
.fatNextSearch140:
 mov ax, [bp-6]
 cmp ax, 3
 jbe .fatNextSearch141
 mov eax, 0
 jmp .retnfatNextSearch
;-1029 		if (delimiter == 2) isfilename=1;//last name is always a file name

.fatNextSearch141:
 mov ax, [bp-8]
 cmp ax, 2
 jne .fatNextSearch142
 mov eax, 1
 mov byte [isfilename], al
;-1030 	}

.fatNextSearch142:
;-1031 	return 1;	

.fatNextSearch138:
 mov eax, 1
 jmp .retnfatNextSearch
;-1032 }

;-1033 

;-1034 // 7.

;-1035 int fatGetStartCluster() {//lastBytes, lastSectors

 .retnfatNextSearch:
 LEAVE
 ret
fatNextSearch_0 db "           ",0
ENDP

fatGetStartCluster: PROC
;-1036 	upto = &filename;

 mov ax, filename
 mov word [upto], ax
;-1037 	if (fatNextSearch()) {//6 get next part of file name

 call fatNextSearch
 or  al, al
 je .fatGetStartCluster143
;-1038 		if (debug) {putch(10); cputsLen(searchstr, 11); }

 mov eax, 1
 or  al, al
 je .fatGetStartCluster144
 push 10
 call putch
 add  sp, 2
 push 11
 lea  ax, [searchstr]
 push ax
 call cputsLen
 add  sp, 4
;-1039 		if (isfilename == 0) return 0; //todo not implemented

.fatGetStartCluster144:
 mov al, [isfilename]
 cmp al, 0
 jne .fatGetStartCluster145
 mov eax, 0
 jmp .retnfatGetStartCluster
;-1040 		if (fatDirSectorSearch(fat_RootDirStartSectorL,

.fatGetStartCluster145:
;-1041 			fat_RootDirSectorsL)) return 1; 

 push dword [fat_RootDirSectorsL]
 push dword [fat_RootDirStartSectorL]
 call fatDirSectorSearch
 add  sp, 8
 or  al, al
 je .fatGetStartCluster146
 mov eax, 1
 jmp .retnfatGetStartCluster
;-1042 		//2 todo: only root search

;-1043 	}

.fatGetStartCluster146:
;-1044 	return 0;

.fatGetStartCluster143:
 mov eax, 0
 jmp .retnfatGetStartCluster
;-1045 }

;-1046 

;-1047 /*

;-1048 // 8.

;-1049 int fatOpenFile() {//set handle for root or subdir

;-1050 //	fat_notfound=0;

;-1051 	unsigned long BufSzL;

;-1052 	

;-1053 	if (debug) cputs(".fatOpenfile ");	

;-1054 	handle=3;//todo

;-1055 	sectorCount = fat_RootDirSectorsL;// or clust_sizeL

;-1056 	

;-1057 	fatGetStartCluster();// 7.

;-1058 	if (fatfound == 0) { cputs(" file not found"); return; }

;-1059 	lastBytes   = FileSizeL % bytes_per_clusterL;	

;-1060 	lastSectors = lastBytes / sector_sizeL;//resting sectors in a cluster

;-1061 	lastBytes   = lastBytes % sector_sizeL;//resting bytes in a sector

;-1062 	

;-1063 	if (FileSizeL == 0) isfilename = 0;

;-1064 	else isfilename = 1;

;-1065 		

;-1066 	BufSzL = (long) BUFFERSIZE;

;-1067 	if (FileSizeL >=  BufSzL) {

;-1068 		cputs(" file longer than BufferSize"); 

;-1069 		fatfound= 0;

;-1070 		return;

;-1071 	}

;-1072 

;-1073 	fatClusterAnalyse(CurrentCluster);// 4. OUT:StartSectorL,NextCluster

;-1074 	sectorCount = clust_sizeL;//1..128 or fat_RootDirSectorsL

;-1075 	FilePointerL = 0;

;-1076 	sectorUpto = 0;

;-1077 	byteUpto   = 0;

;-1078 //	if (fat_notfound) return 1;

;-1079 	if (debug) {									//		DOS.COM FDCONFIG

;-1080 	cputs(" CurrentCluster="); 	printunsign(CurrentCluster);//4177	4164

;-1081 	cputs(",StartSectorL=");	printlong(StartSectorL);	//17051	16999

;-1082 	cputs(",ClusterSizeL=");	printlong(clust_sizeL);		// 4	 4

;-1083 	cputs(",FileSizeL="); 		printlong(FileSizeL);		//8802	762

;-1084 	cputs(",NextCluster="); 	printunsign(NextCluster);	//4178	65.535

;-1085 	cputs(",lastSectors=");		printunsign(lastSectors);	// 1	 1

;-1086 	cputs(",lastBytes="); 		printunsign(lastBytes);		// 98	250

;-1087 	}

;-1088 }

;-1089 

;-1090 /*

;-1091 DRESULT disk_readp (	//Read Partial Sector  

;-1092 	BYTE* buff,		// Data read buffer

;-1093 	DWORD sector,	// Sector number (LBA)

;-1094 	UINT offset,	// Offset in the sector

;-1095 	UINT count		// Byte count

;-1096 )

;-1097 {

;-1098 	DRESULT res;

;-1099 	DWORD rnc;

;-1100 	LARGE_INTEGER dofs;

;-1101 

;-1102 	if (!ReadFile(Stat[0].h_drive, Buffer, 512, &rnc, NULL) || 512 != rnc) {

;-1103 		res = RES_ERROR;

;-1104 		} else {

;-1105 				if (buff) {

;-1106 					memcpy(buff, &Buffer[offset], count);

;-1107 				} else {

;-1108 					while (count--)

;-1109 						putchar(Buffer[offset++]);

;-1110 				}

;-1111 			}

;-1112 } 

;-1113 */

;-1114 

;-1115 

;-1116 /*		

;-1117 // 9a.

;-1118 int pf_read(unsigned long bytestoReadL) {

;-1119 //	IN:FileSizeL

;-1120 //	IO:FilePointerL

;-1121 //	OUT: 0=error, else byteread

;-1122 	unsigned long remainL;

;-1123 	unsigned long templong1;

;-1124 	unsigned long templong2;

;-1125 	unsigned long sectoroffsetCSL;

;-1126 	unsigned int  tempint1;

;-1127 //	unsigned char tempbyte1;//CS byte

;-1128 	unsigned int  clst;//=CurrentCluster=actual cluster

;-1129 	unsigned long rcntL;

;-1130 	unsigned int  bytesread; 

;-1131 	unsigned int  rbuff;

;-1132 	

;-1133 	unsigned long constL512;  

;-1134 	constL512 = (long) 512;//necessary for DIV

;-1135 	bytesread = 0;

;-1136 	rbuff = 0;

;-1137 	remainL = FileSizeL - FilePointerL;	

;-1138 

;-1139 	if (bytestoReadL > remainL) bytestoReadL = remainL;//718

;-1140 

;-1141 	while (bytestoReadL != 0) {//repeat until all data transferred//720

;-1142 		tempint1 = FilePointerL % constL512;

;-1143 

;-1144 		if (tempint1  ==  0) {//on sector boundary?	//721		

;-1145 			templong1 = FilePointerL / constL512;//sector offset in cluster	

;-1146 			templong2 = clust_sizeL- 1;//0 - 127

;-1147 			sectoroffsetCSL = templong1 & templong2;//722

;-1148 			if (sectoroffsetCSL != 0) {//on cluster boundary?

;-1149 				if (FilePointerL == 0) clst = dir_FirstCluster;//top file?

;-1150 				else clst=get_fat(CurrentCluster);

;-1151 				if (clst <= 1) return 0;//729

;-1152 				CurrentCluster = clst;//update current cluster

;-1153 			}

;-1154 			clust2sect(clst);//OUT:CurrentSectorL, 0=error	//732

;-1155 			if (CurrentSectorL == 0) return 0;

;-1156 			CurrentSectorL = CurrentSectorL + sectoroffsetCSL;	

;-1157 		}

;-1158 		rcntL = constL512 - tempint1;//get partial sector data from buffer

;-1159 		if (rcntL > bytestoReadL) rcntL = bytestoReadL; //737

;-1160 		

;-1161 		readLogical(CurrentSectorL, DiskBufSeg, DiskBuf);		

;-1162 		if (BIOS_ERR) {//739

;-1163 			Int13hError(); 

;-1164 			return 0;

;-1165 		}

;-1166 		//Copy to Buffer[rbuff(max.BUFFERSIZE)], from DiskBuf+templong1

;-1167 					

;-1168 		FilePointerL = FilePointerL + rcntL;//740//advance file read pointr	

;-1169 		bytestoReadL = bytestoReadL - rcntL;//741 //update read counter		

;-1170 		bytesread = bytesread + rcntL;

;-1171 		rbuff = rbuff + rcntL;//742 //advance data pointer

;-1172 	}

;-1173 	return bytesread;		

;-1174 }	

;-1175 */

;-1176 

;-1177 /*

;-1178 // 9.

;-1179 int fatReadFile() {// reads from an already open file

;-1180 //	IN: CurrentCluster, FileSizeL, FilePointerL

;-1181 //	IN: lastBytes, lastSectors

;-1182 	unsigned int  sectorsAvail;	//in one cluster or rootsize

;-1183 	unsigned int  bytesAvail;	//max. in one sector

;-1184 

;-1185 	unsigned int  temp1;

;-1186 	unsigned int  temp2;

;-1187 	unsigned int  temp3;

;-1188 	unsigned int  BufSz;

;-1189 	BufSz    =    BUFFERSIZE;

;-1190 	

;-1191 	BufferPtr = &Buffer;

;-1192 	bytesRead = 0;

;-1193 	sectorsAvail = sectorCount;	//1..128 or fat_RootDirSectorsL 

;-1194 	bytesAvail = bs_sect_size;

;-1195 	

;-1196 	while (CurrentCluster < 0xFFF8) {//not end of Cluster

;-1197 		sectorsAvail = sectorCount;

;-1198 		if (NextCluster >= 0xFFF8) {

;-1199 			if (isfilename) sectorsAvail = lastSectors + 1;//????

;-1200 			}

;-1201 		while (sectorUpto != sectorsAvail) {

;-1202 			bytesAvail = bs_sect_size;

;-1203 			if (NextCluster >= 0xFFF8) {

;-1204 				if (isfilename) {

;-1205 					if (sectorUpto == lastSectors) {

;-1206 						bytesAvail = lastBytes;

;-1207 					}	

;-1208 				}

;-1209 			}

;-1210 			while (byteUpto != bytesAvail) {

;-1211 				CurrentSectorL = (long) sectorUpto;

;-1212 				CurrentSectorL = CurrentSectorL + StartSectorL;	

;-1213 				readLogical(CurrentSectorL, DiskBufSeg, DiskBuf);		

;-1214 				if (BIOS_ERR) {

;-1215 					Int13hError(); 

;-1216 					fatfound = 0;

;-1217 					return;

;-1218 				}	

;-1219 				temp1 = bytesAvail - byteUpto;

;-1220 				temp2 = BufSz - bytesRead;

;-1221 				temp3 = Buffer + byteUpto;

;-1222 

;-1223 				BufferPtr = BufferPtr + bytesRead;////////////////

;-1224 				

;-1225 				

;-1226 				if (temp1 > temp2) {//read last sector not full

;-1227 					memcpy(BufferPtr, temp3, temp2);	

;-1228 					byteUpto = byteUpto + temp2;

;-1229 					bytesRead = BufSz;

;-1230 					return;

;-1231 				}	

;-1232 				else {//read full sector

;-1233 					memcpy(BufferPtr, temp3, temp1);

;-1234 					bytesRead = bytesRead + temp1;

;-1235 					byteUpto = byteUpto + temp1; 

;-1236 				}	

;-1237 			}	

;-1238 			sectorUpto ++;

;-1239 			byteUpto = 0;

;-1240 		}	

;-1241 		CurrentCluster = NextCluster;

;-1242 		fatClusterAnalyse(CurrentCluster);//4.OUT:StartSectorL,NextCluster

;-1243 		sectorUpto = 0;

;-1244 	}	

;-1245 }

;-1246 */

;-1247 

;-1248 		

;-1249 // 9b.

;-1250 int ReadFile(unsigned int BytestoRead) {

 .retnfatGetStartCluster:
 ret
ENDP

ReadFile: PROC
;-1251 //	IN: FileSizeL		from 2.fatDirSectorSearch

;-1252 //	IN: CurrentCluster	from 2.fatDirSectorSearch

;-1253 //	IN: StartSectorL	from 4.fatClusterAnalyse

;-1254 //	IN: NextCluster		from 4.fatClusterAnalyse

;-1255 //	IO: FilePointerL=0	from 10.OSOpenFile

;-1256 //	OUT: 0=error, else ByteRead

;-1257 

;-1258 	unsigned long CurrentSectorL;	//current data sector	

;-1259 	unsigned long EndSectorL;

;-1260 	unsigned int  ByteRead;

;-1261 	unsigned int  btr;

;-1262 	

;-1263 	if (BytestoRead == 0) return 0;

;Function : ReadFile, Number local Var: 5
; # type sign width local variables
;101 var unsg word BytestoRead = bp+4
;102 var unsg long CurrentSectorL = bp-4
;103 var unsg long EndSectorL = bp-8
;104 var unsg word ByteRead = bp-10
;105 var unsg word btr = bp-12;
 ENTER  12,0
 mov ax, [bp+4]
 cmp ax, 0
 jne .ReadFile147
 mov eax, 0
 jmp .retnReadFile
;-1264 	ByteRead = 0;

.ReadFile147:
 mov eax, 0
 mov [bp-10], ax
;-1265 

;-1266 	 while (CurrentCluster <= 0xFFF7) {// 65528,   < is wrong code!!!

.ReadFile148:
 mov ax, [CurrentCluster]
 cmp ax, 65527
 ja  .ReadFile149
;-1267 		CurrentSectorL = StartSectorL;

 mov eax, [StartSectorL]
 mov [bp-4], eax
;-1268 		EndSectorL = StartSectorL + clust_sizeL;//set in FATInit(1-127)

 mov eax, [StartSectorL]
 add eax, [clust_sizeL]
 mov [bp-8], eax
;-1269 			

;-1270 //		if (debug) { 

;-1271 //			cputs(" CurrentCluster="); printunsign(CurrentCluster); 

;-1272 //			cputs(" CurrentSectorL="); printlong(CurrentSectorL); 

;-1273 //			cputs(" EndSectorL="); printlong(EndSectorL); 

;-1274 //		}		

;-1275 		while (CurrentSectorL <= EndSectorL) {

.ReadFile150:
 mov eax, [bp-4]
 cmp eax, [bp-8]
 ja  .ReadFile151
;-1276 			readLogical(CurrentSectorL, DiskBufSeg, DiskBuf);		

 lea  ax, [DiskBuf]
 push ax
 push word [DiskBufSeg]
 push dword [bp-4]
 call readLogical
 add  sp, 8
;-1277 			if (BIOS_ERR) {	Int13hError(); return 0; }	

 mov al, [BIOS_ERR]
 or  al, al
 je .ReadFile152
 call Int13hError
 mov eax, 0
 jmp .retnReadFile
;-1278 			if (BytestoRead > bs_sect_size) btr = bs_sect_size;

.ReadFile152:
 mov ax, [bp+4]
 cmp ax, [bs_sect_size]
 jbe .ReadFile153
 mov ax, [bs_sect_size]
 mov [bp-12], ax
;-1279 			else btr = BytestoRead;

 jmp .ReadFile154
.ReadFile153:
 mov ax, [bp+4]
 mov [bp-12], ax
;-1280 							

;-1281 			memcpy(BufferPtr, DiskBuf, btr);

.ReadFile154:
 push word [bp-12]
 lea  ax, [DiskBuf]
 push ax
 push word [BufferPtr]
 call memcpy
 add  sp, 6
;-1282 			BufferPtr   	= BufferPtr    + btr;

 mov ax, [BufferPtr]
 add ax, [bp-12]
 mov word [BufferPtr], ax
;-1283 			BytestoRead 	= BytestoRead  - btr;

 mov ax, [bp+4]
 sub ax, [bp-12]
 mov [bp+4], ax
;-1284 			ByteRead    	= ByteRead     + btr;

 mov ax, [bp-10]
 add ax, [bp-12]
 mov [bp-10], ax
;-1285 			FilePointerL	= FilePointerL + btr;

 mov eax, [FilePointerL]
 add ax, [bp-12]
 mov dword [FilePointerL], eax
;-1286 			CurrentSectorL	= CurrentSectorL + 1; 		

 mov eax, [bp-4]
 add eax, 1
 mov [bp-4], eax
;-1287 //			cputs(" C BytestoRead="); printunsign(BytestoRead);		

;-1288 			if (BytestoRead == 0) return ByteRead;

 mov ax, [bp+4]
 cmp ax, 0
 jne .ReadFile155
 mov ax, [bp-10]
 jmp .retnReadFile
;-1289 		}

.ReadFile155:
;-1290 		CurrentCluster = NextCluster;

 jmp .ReadFile150
.ReadFile151:
 mov ax, [NextCluster]
 mov word [CurrentCluster], ax
;-1291 		if (fatClusterAnalyse(CurrentCluster)) return 0;//4.OUT:StartSectorL		

 push word [CurrentCluster]
 call fatClusterAnalyse
 add  sp, 2
 or  al, al
 je .ReadFile156
 mov eax, 0
 jmp .retnReadFile
;-1292 	}

.ReadFile156:
;-1293 	return 0;//error

 jmp .ReadFile148
.ReadFile149:
 mov eax, 0
 jmp .retnReadFile
;-1294 }	

;-1295 

;-1296 

;-1297 //------------------------------- OS functions --------------

;-1298 int FileError() {

 .retnReadFile:
 LEAVE
 ret
ENDP

FileError: PROC
;-1299 	cputs(" *** file error *** ");

 push FileError_0
 call cputs
 add  sp, 2
;-1300 }	

;-1301 

;-1302 // 10.

;-1303 int OSOpenFile(char *name) {

 ret
FileError_0 db " *** file error *** ",0
ENDP

OSOpenFile: PROC
;-1304 //	NEED:CurrentCluster, FileSizeL from 2.fatDirSectorSearch

;-1305 //	OUT: 0=error

;-1306 	unsigned long BufSzL;

;-1307 	unsigned int i;

;-1308 	DOS_ERR = 0;

;Function : OSOpenFile, Number local Var: 3
; # type sign width local variables
;101 ptr sign byte name = bp+4
;102 var unsg long BufSzL = bp-4
;103 var unsg word i = bp-6;
 ENTER  6,0
 mov eax, 0
 mov byte [DOS_ERR], al
;-1309 //	remove drive letter, slash. uppercase and copy to filename

;-1310 	strcpy(filename, name);

 push word [bp+4]
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1311 	toupper(filename);

 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-1312 	if (strlen1(filename) == 0) return 0;

 lea  ax, [filename]
 push ax
 call strlen1
 add  sp, 2
 cmp ax, 0
 jne .OSOpenFile157
 mov eax, 0
 jmp .retnOSOpenFile
;-1313 	i=strchr(filename, ':');

.OSOpenFile157:
 push 58
 lea  ax, [filename]
 push ax
 call strchr
 add  sp, 4
 mov [bp-6], ax
;-1314 	if (i) {

 mov ax, [bp-6]
 or  al, al
 je .OSOpenFile158
;-1315 		i++;

 inc  word[bp-6]
;-1316 		strcpy(filename, i);	

 push word [bp-6]
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-1317 		if (strlen1(filename) == 0) return 0;	

 lea  ax, [filename]
 push ax
 call strlen1
 add  sp, 2
 cmp ax, 0
 jne .OSOpenFile159
 mov eax, 0
 jmp .retnOSOpenFile
;-1318 	}

.OSOpenFile159:
;-1319 

;-1320 //todo: add working directory page 18

;-1321 			

;-1322 	if(is_delimiter(filename) == 1) filename++;

.OSOpenFile158:
 lea  ax, [filename]
 push ax
 call is_delimiter
 add  sp, 2
 cmp ax, 1
 jne .OSOpenFile160
 inc  byte[filename]
;-1323 		if (fatGetStartCluster() == 0) {// 7.fatGetStartCluster

.OSOpenFile160:
 call fatGetStartCluster
 cmp al, 0
 jne .OSOpenFile161
;-1324 		cputs(" file not found"); 

 push OSOpenFile_0
 call cputs
 add  sp, 2
;-1325 		return 0; 

 mov eax, 0
 jmp .retnOSOpenFile
;-1326 		}

;-1327 	BufferPtr = &Buffer;

.OSOpenFile161:
 mov ax, Buffer
 mov word [BufferPtr], ax
;-1328 	FilePointerL = 0;

 mov eax, 0
 mov dword [FilePointerL], eax
;-1329 	

;-1330 	BufSzL = (long) BUFFERSIZE;

 xor eax, eax
 mov eax, 35000
 mov [bp-4], eax
;-1331 	if (FileSizeL >=  BufSzL) {

 mov eax, [FileSizeL]
 cmp eax, [bp-4]
 jb  .OSOpenFile162
;-1332 		error2(" file longer than BufferSize"); 

 push OSOpenFile_1
 call error2
 add  sp, 2
;-1333 		return 0;

 mov eax, 0
 jmp .retnOSOpenFile
;-1334 	}

;-1335 		

;-1336 	if (fatClusterAnalyse(CurrentCluster)) return 0;// 4. OUT: StartSectorL

.OSOpenFile162:
 push word [CurrentCluster]
 call fatClusterAnalyse
 add  sp, 2
 or  al, al
 je .OSOpenFile163
 mov eax, 0
 jmp .retnOSOpenFile
;-1337 //	CurrentCluster is set in 2.fatDirSectorSearch

;-1338 //	if (debug) {									//		DOS.COM FDCONFIG

;-1339 //	putch(10);

;-1340 //	cputs(" --10 OSOpenFile B:");

;-1341 //	cputs(" CurrentCluster="); 	printunsign(CurrentCluster);//4177	4164

;-1342 //	cputs(",StartSectorL=");	printlong(StartSectorL);	//17051	16999

;-1343 //	cputs(",ClusterSizeL=");	printlong(clust_sizeL);		// 4	 4

;-1344 //	cputs(",FileSizeL="); 		printlong(FileSizeL);		//8802	762

;-1345 //	cputs(",NextCluster="); 	printunsign(NextCluster);	//4178	65.535

;-1346 //	cputs(",lastSectors=");		printunsign(lastSectors);	// 1	 1

;-1347 //	cputs(",lastBytes="); 		printunsign(lastBytes);		// 98	250

;-1348 //	getkey();

;-1349 //	}

;-1350 	return 1;

.OSOpenFile163:
 mov eax, 1
 jmp .retnOSOpenFile
;-1351 }

;-1352 

;-1353 // 11.

;-1354 int OSReadFile() {

 .retnOSOpenFile:
 LEAVE
 ret
OSOpenFile_0 db " file not found",0
OSOpenFile_1 db " file longer than BufferSize",0
ENDP

OSReadFile: PROC
;-1355 	unsigned int BytesToReadInt;

;-1356 	BytesToReadInt = FileSizeL;//long2int	

;Function : OSReadFile, Number local Var: 1
; # type sign width local variables
;101 var unsg word BytesToReadInt = bp-2;
 ENTER  2,0
 mov eax, [FileSizeL]
 mov [bp-2], ax
;-1357 	BytesAreRead=ReadFile(BytesToReadInt);//9.

 push word [bp-2]
 call ReadFile
 add  sp, 2
 mov word [BytesAreRead], ax
;-1358 	if (BytesToReadInt != BytesAreRead) {

 mov ax, [bp-2]
 cmp ax, [BytesAreRead]
 je  .OSReadFile164
;-1359 		FileError();

 call FileError
;-1360 		cputs(" --11 OSReadFile BytesAreRead="); 

 push OSReadFile_0
 call cputs
 add  sp, 2
;-1361 		printunsign(BytesAreRead);  

 push word [BytesAreRead]
 call printunsign
 add  sp, 2
;-1362 	}

;-1363 	if (debug) getkey();	

.OSReadFile164:
 mov eax, 1
 or  al, al
 je .OSReadFile165
 call getkey
;-1364 }

.OSReadFile165:
;-1365 

;-1366 

;-1367 // 12.

;-1368 int OSShowFile() {

 LEAVE
 ret
OSReadFile_0 db " --11 OSReadFile BytesAreRead=",0
ENDP

OSShowFile: PROC
;-1369 //	mdump(DiskBuf, 512);

;-1370 	dumpASCII(Buffer, BytesAreRead);

 push word [BytesAreRead]
 lea  ax, [Buffer]
 push ax
 call dumpASCII
 add  sp, 4
;-1371 }

;-1372 

;-1373 

;-1374 //------------------------------- Init,  main ---------------

;-1375 int Init() {

 ret
ENDP

Init: PROC
;-1376 	DOS_ERR = 0;

 mov eax, 0
 mov byte [DOS_ERR], al
;-1377 	Drive=0x80;

 mov eax, 128
 mov byte [Drive], al
;-1378 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-1379 	if (debug) cputs(" Init");

 mov eax, 1
 or  al, al
 je .Init166
 push Init_0
 call cputs
 add  sp, 2
;-1380 	if (Params()) cputs(" ** NO DRIVE PARAMS FOUND **");//no hard disk

.Init166:
 call Params
 or  al, al
 je .Init167
 push Init_1
 call cputs
 add  sp, 2
;-1381 	if (readMBR() == 0) {//0=error,1=FAT12,6=FAT16,11=FAT32	

.Init167:
 call readMBR
 cmp al, 0
 jne .Init168
;-1382 		cputs(" ** no active FAT partition found **");

 push Init_2
 call cputs
 add  sp, 2
;-1383 		return 1;

 mov eax, 1
 jmp .retnInit
;-1384 		}

;-1385 	if(getBootSector()==0) 	return 1;

.Init168:
 call getBootSector
 cmp al, 0
 jne .Init169
 mov eax, 1
 jmp .retnInit
;-1386 	if (FATInit())			return 1;

.Init169:
 call FATInit
 or  al, al
 je .Init170
 mov eax, 1
 jmp .retnInit
;-1387 	if(trueFATtype != 16) 	return 1;

.Init170:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init171
 mov eax, 1
 jmp .retnInit
;-1388 	Int13hExt();

.Init171:
 call Int13hExt
;-1389 	return 0;

 mov eax, 0
 jmp .retnInit
;-1390 }

;-1391 

;-1392 int main() {

 .retnInit:
 ret
Init_0 db " Init",0
Init_1 db " ** NO DRIVE PARAMS FOUND **",0
Init_2 db " ** no active FAT partition found **",0
ENDP

main: PROC
;-1393 	if (Init() ) return 1;

 call Init
 or  al, al
 je .main172
 mov eax, 1
 jmp .retnmain
;-1394 //	if (debug) PrintDriveParameter();

;-1395 	

;-1396 	if (OSOpenFile("fat.h"       ) > 0) { OSReadFile(); OSShowFile(); }

.main172:
 push main_0
 call OSOpenFile
 add  sp, 2
 cmp al, 0
 jle .main173
 call OSReadFile
 call OSShowFile
;-1397 	else FileError();

 jmp .main174
.main173:
 call FileError
;-1398 	if (OSOpenFile("r.bat"       ) > 0) { OSReadFile(); OSShowFile(); }

.main174:
 push main_1
 call OSOpenFile
 add  sp, 2
 cmp al, 0
 jle .main175
 call OSReadFile
 call OSShowFile
;-1399 	else FileError();

 jmp .main176
.main175:
 call FileError
;-1400 	if (OSOpenFile("int13.asm"   ) > 0) { OSReadFile(); OSShowFile(); }

.main176:
 push main_2
 call OSOpenFile
 add  sp, 2
 cmp al, 0
 jle .main177
 call OSReadFile
 call OSShowFile
;-1401 	else FileError();

 jmp .main178
.main177:
 call FileError
;-1402 	if (debug) cputs(".End.");

.main178:
 mov eax, 1
 or  al, al
 je .main179
 push main_3
 call cputs
 add  sp, 2
;-1403 }

.main179:
;-1404 /*

;-1405 11	OSReadFile

;-1406 	9 fatReadFile

;-1407 	

;-1408 10	OSOpenFile drive,slash,upper,to filename

;-1409 	8 fatOpenFile

;-1410 9. fatReadFile

;-1411 	1 readLogical

;-1412 	4 fatClusterAnalyse

;-1413 8. fatOpenFile set handle, init root or subdir

;-1414 	s7 fatGetStartCluster

;-1415 	s4 fatClusterAnalyse

;-1416 7. fatGestStartCluster

;-1417 	6 fatNextSearch

;-1418 	3 fatRootSearch

;-1419 	s5 fatDirSearch

;-1420 6. fatNextSearch Upto,search,isFilename =>7

;-1421 5. fatDirSearch a directory chain for search

;-1422 	4 fatClusterAnalyse

;-1423 	2 fatDieSectorSearch

;-1424 4. fatClusterAnalyse determines sector by cluster number, next cluster

;-1425 	1 ReadLogical

;-1426 3. fatRootSearch search the root for an entry

;-1427 	2 fatDirSectorSearch

;-1428 2. fatDirSectorSearch search a block of sectors for entries,

;-1429 		get starting cluster, file size, notfound

;-1430 	1 readLogical

;-1431 2.a printDirEntry

;-1432 2.b fatDirSectorList

;-1433 	1 readLogical					

;-1434 1. readLogical

;-1435 	DiskSectorReadWrite	

;-1436 */

;-1437 /*

;-1438 bin_file=fopen("name", "rb") //binary

;-1439 int = fgetc(in_file)	     //EOF(-1)

;-1440 fputc(character, file)

;-1441 printf() = fprintf(stdout, format, parameter1) //buffered I/O

;-1442 DOS: add CR13 to LF10

;-1443 read_size=fread(data_ptr, 1, size, file) //binary read

;-1444 file_descriptor=open(name, flags, mode=0666) //unbuffered I/O

;-1445 read_size=read(file_descriptor, buffer, size) //unbufferes I/O 

;-1446 */

 .retnmain:
 ret
main_0 db "fat.h",0
main_1 db "r.bat",0
main_2 db "int13.asm",0
main_3 db ".End.",0
ENDP
;Glob. variables:100 (400):1210 (4000), Functions:56 (300):577 (3000)
;Lines:1447, Constant: 2166 (4000), stacksize: 13560