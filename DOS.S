;PLA compiler A.COM V1.1.3, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.1.9";//test bed

Version1 db "DOS.COM V0.1.9",0
;-2 //Finder /hg/VirtualBox VMs/DOS1/DOS1.vhd (.vmdk)

;-3 //rigth click / open / Parallels Mounter

;-4 // (E)DX:(E)AX DIV r/m16(32) = (E)AX, remainder (E)DX

;-5 // AL*r/m8=AX; AX*r/m16=DX:AX; EAX*r/m32=EDX:EAX

;-6 

;-7 // > 16.777.216 sectors (8GB) only LBA

;-8 //Ranish Part, int8h: CHS 1014/15/63, Start=63,Len=1.023.057

;-9 //Boot Sec=63, head=16, hidden=63, Sec=983.121

;-10 #define ORGDATA		16384//start of arrays

;-11 unsigned int vAX ;unsigned int vBX ;unsigned int vCX; unsigned int vDX;

vAX dw 0
vBX dw 0
vCX dw 0
vDX dw 0
;-12 unsigned int vSP; unsigned int vBP; unsigned int vCS; unsigned int vDS;

vSP dw 0
vBP dw 0
vCS dw 0
vDS dw 0
;-13 unsigned int vSS; unsigned int vES; //debugging

vSS dw 0
vES dw 0
;-14 

;-15 unsigned char DOS_ERR;

DOS_ERR db 0
;-16 unsigned char BIOS_ERR;

BIOS_ERR db 0
;-17 unsigned int  BIOS_Status;

BIOS_Status dw 0
;-18 

;-19 unsigned char DiskBuf [512];

section .bss
absolute 16384
DiskBuf resb 512
section .text
;-20 unsigned int  DiskBufSeg;

DiskBufSeg dw 0
;-21 unsigned char Drive=0x80;

Drive db 128
;-22 unsigned long Sectors_to_read;//for readLogical

Sectors_to_read dd 0
;-23 

;-24 //Params from int13h, Function 8

;-25 unsigned int  pa_Cylinders;

pa_Cylinders dw 0
;-26 unsigned char pa_Sectors;

pa_Sectors db 0
;-27 unsigned char pa_Heads;

pa_Heads db 0
;-28 unsigned char pa_Attached;

pa_Attached db 0
;-29 

;-30 unsigned int  pt_PartNo;

pt_PartNo dw 0
;-31 //start hard disk partition structure 16 bytes in MBR. do not change

;-32 unsigned char pt_Bootable;		//80h = active partition, else 00

pt_Bootable db 0
;-33 unsigned char pt_StartHead;

pt_StartHead db 0
;-34 unsigned char pt_StartSector;	//bits 0-5

pt_StartSector db 0
;-35 unsigned int  pt_StartCylinder;	//bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-36 unsigned char pt_FileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=largeFAT16

pt_FileSystem db 0
;-37 unsigned char pt_EndHead;

pt_EndHead db 0
;-38 unsigned char pt_EndSector;		//bits 0-5

pt_EndSector db 0
;-39 unsigned int  pt_EndCylinder;	//bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-40 unsigned long pt_HiddenSector;	//sectors preceding partition

pt_HiddenSector dd 0
;-41 unsigned long pt_PartLen;    	//length of partition in sectors

pt_PartLen dd 0
;-42 //end hard disk partition structure

;-43 

;-44 //start boot BIOS Parameter Block structure. do not change

;-45 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-46 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-47 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-48 unsigned char bs_clust_size;// 13 sectors per cluster (1,2,4,..,128)

bs_clust_size db 0
;-49 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-50 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-51 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-52 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-53 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-54 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-55 unsigned int  bs_sectors_per_track; // 24 (DOS 3+)sectors per track

bs_sectors_per_track dw 0
;-56 unsigned int  bs_num_heads;	// 26 (DOS 3+)number of heads

bs_num_heads dw 0
;-57 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors

bs_hid_sects dd 0
;-58 unsigned long bs_tot_sect32;// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-59 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-60 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-61 unsigned char bs_ext_signat;// 38 (DOS 4+) Extended signature,get next 3(29h)

bs_ext_signat db 0
;-62 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-63 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-64 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-65 // 62 end boot BIOS Parameter Block

;-66 

;-67 //start directory entry structure, do not change

;-68 unsigned char dir_Filename[]="1234567";	//00 +lengthbyte=11

dir_Filename db "1234567",0
;-69 unsigned char dir_Ext[]="12";	//07 +lengthbyte=3

dir_Ext db "12",0
;-70 unsigned char dir_Attrib;		//11 directory=10h, Label=08h, read only=1

dir_Attrib db 0
;-71 unsigned char dir_NTReserved;	//12 low case in body=8h, in ext=10h

dir_NTReserved db 0
;-72 unsigned char dir_TimeCreatedMS;//13 in 10 milliseconda or zero

dir_TimeCreatedMS db 0
;-73 unsigned int  dir_TimeCreated;	//14 creation time, resolution 2 seconds or 0

dir_TimeCreated dw 0
;-74 unsigned int  dir_DateCreated;	//16 creation date or zero

dir_DateCreated dw 0
;-75 unsigned int  dir_DateLastAccessd;		//18 no time info available or zero

dir_DateLastAccessd dw 0
;-76 unsigned int  dir_FirstClusterHiBytes;	//20 FAT12/16 always zero

dir_FirstClusterHiBytes dw 0
;-77 unsigned int  dir_LastModTime;	//22 modification time on closing

dir_LastModTime dw 0
;-78 unsigned int  dir_LastModDate;	//24 modification date on closing

dir_LastModDate dw 0
;-79 unsigned int  dir_FirstCluster;	//26 1.clu. of file data, if filesize=0 then 0

dir_FirstCluster dw 0
;-80 unsigned long dir_FileSize;		//28 size in bytes, if directory then zero

dir_FileSize dd 0
;-81 //end direcctory entry structure

;-82 

;-83 //FATInit

;-84 unsigned int fat_FatStartSector;

fat_FatStartSector dw 0
;-85 unsigned int fat_FatSectors;

fat_FatSectors dw 0
;-86 unsigned int fat_RootDirStartSector;

fat_RootDirStartSector dw 0
;-87 unsigned int fat_RootDirSectors;

fat_RootDirSectors dw 0
;-88 unsigned int fat_DataStartSector;

fat_DataStartSector dw 0
;-89 unsigned long fat_num_tracks;

fat_num_tracks dd 0
;-90 unsigned int  fat_num_cylinders;

fat_num_cylinders dw 0
;-91 unsigned long Sectors_per_cylinder;

Sectors_per_cylinder dd 0
;-92 unsigned long DataSectors32;

DataSectors32 dd 0
;-93 unsigned long CountofClusters;

CountofClusters dd 0
;-94 unsigned char trueFATtype;	//12, 16, 32 from FATInit

trueFATtype db 0
;-95 unsigned int  FATtype;		//0=error,1=FAT12,6=FAT16,11=FAT32 from ReadMBR

FATtype dw 0
;-96 

;-97 //fatfile

;-98 //unsigned char fat_currentdrive;

;-99 //unsigned char fat_currentpath[55];

;-100 //unsigned char fat_drive;//physical

;-101 unsigned char filename[67];

section .bss
absolute 16896
filename resb 67
section .text
;-102 //unsigned char fat_path     [55];

;-103 unsigned char fat_filename [8];

section .bss
absolute 16963
fat_filename resb 8
section .text
;-104 unsigned char fat_fileext  [3];// must follow fat_filename

section .bss
absolute 16971
fat_fileext resb 3
section .text
;-105 unsigned int  fat_notfound;

fat_notfound dw 0
;-106 		 int  fatfile_root;

fatfile_root dw 0
;-107 unsigned int  fatfile_nextCluster;

fatfile_nextCluster dw 0
;-108 unsigned int  fatfile_sectorCount;

fatfile_sectorCount dw 0
;-109 unsigned long fatfile_sectorStart;

fatfile_sectorStart dd 0
;-110 unsigned int  fatfile_lastBytes;

fatfile_lastBytes dw 0
;-111 unsigned int  fatfile_lastSectors;

fatfile_lastSectors dw 0
;-112 unsigned int  fatfile_cluster;

fatfile_cluster dw 0
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
;-120 __asm{


;-121 


;-122 }	}


;-123 

;-124 //------------------------------------   IO  -------------------

;-125 

;-126 int writetty()     {//char in AL

 ret
ENDP

writetty: PROC
;-127     ah=0x0E;

 mov  ah, 14
;-128     push bx;

push bx;
;-129     bx=0;			//page in BH

 mov  bx, 0
;-130     inth 0x10;		//16

 int  16
;-131     pop bx;

pop bx;
;-132 }

;-133 int putch(char c)  {

 ret
ENDP

putch: PROC
;-134     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;95 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-135         al=13;

 mov  al, 13
;-136         writetty();

 call writetty
;-137     }

;-138     al=c;

.putch1:
 mov  al, [bp+4]
;-139     writetty();

 call writetty
;-140 }

;-141 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-142     char c;

;-143     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;95 ptr sign byte s = bp+4
;96 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-144         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-145         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-146         s++;

 inc  word[bp+4]
;-147     }

;-148 }

 jmp .cputs2
.cputs3:
;-149 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-150 	char c;

;-151 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;95 ptr sign byte s = bp+4
;96 var sign word len = bp+6
;97 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-152 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-153 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-154 		s++;

 inc  word[bp+4]
;-155 		len--;

 dec  word[bp+6]
;-156 	} while (len > 0);

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-157 }

;-158 

;-159 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-160     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-161     inth 0x16;//AH=Scan code, AL=char

 int  22
;-162 }

;-163 int waitkey() {

 ret
ENDP

waitkey: PROC
;-164     ah=0x11;//get kbd status

 mov  ah, 17
;-165     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-166     //zero flag: 0=IS char, 1=NO char

;-167     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-168 }

;-169 int getkey() {

 ret
ENDP

getkey: PROC
;-170     waitkey();

 call waitkey
;-171     getch();

 call getch
;-172     ah=0;//clear scan code

 mov  ah, 0
;-173     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-174     //put ext code in AX

;-175 }

.getkey6:
;-176 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-177     getkey();

 call getkey
;-178     writetty();//destroys AH

 call writetty
;-179 }

;-180 

;-181 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-182     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;95 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-183     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-184     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-185 }

;-186 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-187     unsigned char nib;

;-188     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;95 var unsg byte c = bp+4
;96 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-189     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-190 }

;-191 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-192     unsigned int half;

;-193     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;95 var unsg word i = bp+4
;96 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-194     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-195 }

;-196 

;-197 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-198     unsigned int e;

;-199     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;95 var unsg word n = bp+4
;96 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-200         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-201         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-202         }

;-203     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-204     n+='0';

 add  word[bp+4], 48
;-205     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-206 }

;-207 

;-208 int printlong(unsigned long L) {

 LEAVE
 ret
ENDP

printlong: PROC
;-209     ax = L;     // get low in ax

;Function : printlong, Number local Var: 1
; # type sign width local variables
;95 var unsg long L = bp+4;
 ENTER  0,0
 mov  ax, [bp+4]
;-210     edx=L;

 mov  edx, [bp+4]
;-211     edx >> 16;  // get high in dx

 shr  edx, 16
;-212 __asm{


;-213   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-214     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-215 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-216     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-217     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-218 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-219     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-220     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-221     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-222     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-223     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-224     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-225     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-226     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-227 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-228 }	writetty();		__asm{


 call writetty

;-229     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-230     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-231     jb      .b             ;Not yet

    jb      .b             ;Not yet
;-232 }


;-233 }

;-234 //--------------------------------  string  ---------------------

;-235 int strlen(char *s) { int c;

 LEAVE
 ret
ENDP

strlen: PROC
;-236     c=0;

;Function : strlen, Number local Var: 2
; # type sign width local variables
;95 ptr sign byte s = bp+4
;96 var sign word c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-237     while (*s!=0) {s++; c++;}

.strlen9:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen10
 inc  word[bp+4]
 inc  word[bp-2]
;-238     return c;

 jmp .strlen9
.strlen10:
 mov ax, [bp-2]
 jmp .retnstrlen
;-239 }

;-240 int strcpy(char *s, char *t) {

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-241     do { *s=*t; s++; t++; }

;Function : strcpy, Number local Var: 2
; # type sign width local variables
;95 ptr sign byte s = bp+4
;96 ptr sign byte t = bp+6;
 ENTER  0,0
.strcpy11:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-242     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy12
 jmp .strcpy11
.strcpy12:
;-243     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-244     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-245 }

;-246 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-247     while(*p) {

;Function : eqstr, Number local Var: 2
; # type sign width local variables
;95 ptr sign byte p = bp+4
;96 ptr sign byte q = bp+6;
 ENTER  0,0
.eqstr13:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr14
;-248         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr15
 mov ax, 0
 jmp .retneqstr
;-249         p++;

.eqstr15:
 inc  word[bp+4]
;-250         q++;

 inc  word[bp+6]
;-251     }

;-252     if(*q) return 0;

 jmp .eqstr13
.eqstr14:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr16
 mov ax, 0
 jmp .retneqstr
;-253     return 1;

.eqstr16:
 mov ax, 1
 jmp .retneqstr
;-254 }

;-255 

;-256 int memcmp(char *s, char *t, unsigned int i) {

 .retneqstr:
 LEAVE
 ret
ENDP

memcmp: PROC
;-257     do {

;Function : memcmp, Number local Var: 3
; # type sign width local variables
;95 ptr sign byte s = bp+4
;96 ptr sign byte t = bp+6
;97 var unsg word i = bp+8;
 ENTER  0,0
.memcmp17:
;-258         if (*s < *t) return 0xFFFF;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 jge .memcmp18
 mov ax, 65535
 jmp .retnmemcmp
;-259         if (*s > *t) return 1;

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
;-260         s++; t++; i--;

.memcmp19:
 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-261     } while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcmp20
 jmp .memcmp17
.memcmp20:
;-262     return 0;

 mov ax, 0
 jmp .retnmemcmp
;-263 }

;-264 

;-265 int strcat(char *s, char *t) {

 .retnmemcmp:
 LEAVE
 ret
ENDP

strcat: PROC
;-266     while (*s != 0) s++;

;Function : strcat, Number local Var: 2
; # type sign width local variables
;95 ptr sign byte s = bp+4
;96 ptr sign byte t = bp+6;
 ENTER  0,0
.strcat21:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat22
 inc  word[bp+4]
;-267     strcpy(s, t);

 jmp .strcat21
.strcat22:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4
;-268 }

;-269 int toupper(char *s) {

 LEAVE
 ret
ENDP

toupper: PROC
;-270     while(*s) {

;Function : toupper, Number local Var: 1
; # type sign width local variables
;95 ptr sign byte s = bp+4;
 ENTER  0,0
.toupper23:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper24
;-271         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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
;-272         s++;

.toupper26:
.toupper25:
 inc  word[bp+4]
;-273     }

;-274 }

 jmp .toupper23
.toupper24:
;-275 int strchr(char *s, char c) {

 LEAVE
 ret
ENDP

strchr: PROC
;-276     while(*s) {

;Function : strchr, Number local Var: 2
; # type sign width local variables
;95 ptr sign byte s = bp+4
;96 var sign byte c = bp+6;
 ENTER  0,0
.strchr27:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .strchr28
;-277         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .strchr29
 mov ax, [bp+4]
 jmp .retnstrchr
;-278         s++;

.strchr29:
 inc  word[bp+4]
;-279     }

;-280     return 0;

 jmp .strchr27
.strchr28:
 mov ax, 0
 jmp .retnstrchr
;-281 }

;-282 int instr1(char *s, char c) {

 .retnstrchr:
 LEAVE
 ret
ENDP

instr1: PROC
;-283     while(*s) {

;Function : instr1, Number local Var: 2
; # type sign width local variables
;95 ptr sign byte s = bp+4
;96 var sign byte c = bp+6;
 ENTER  0,0
.instr130:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .instr131
;-284         if (*s==c) return 1;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .instr132
 mov ax, 1
 jmp .retninstr1
;-285         s++;

.instr132:
 inc  word[bp+4]
;-286     }

;-287     return 0;

 jmp .instr130
.instr131:
 mov ax, 0
 jmp .retninstr1
;-288 }

;-289 

;-290 int memcpy(char *s, char *t, unsigned int i) {

 .retninstr1:
 LEAVE
 ret
ENDP

memcpy: PROC
;-291 	unsigned int r;

;-292 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;95 ptr sign byte s = bp+4
;96 ptr sign byte t = bp+6
;97 var unsg word i = bp+8
;98 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-293 	do {

.memcpy33:
;-294 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-295 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-296 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy34
 jmp .memcpy33
.memcpy34:
;-297 	ax=r;//	return r;

 mov  ax, [bp-2]
;-298 }

;-299 

;-300 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-301     unsigned char c; int i; int j; int k;

;-302     j=0;

;Function : mdump, Number local Var: 6
; # type sign width local variables
;95 ptr unsg byte adr = bp+4
;96 var unsg word len = bp+6
;97 var unsg byte c = bp-2
;98 var sign word i = bp-4
;99 var sign word j = bp-6
;100 var sign word k = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-6], ax
;-303     k=0;

 mov ax, 0
 mov [bp-8], ax
;-304     while (j < len ) {

.mdump35:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump36
;-305 	    k++;;

 inc  word[bp-8]
;-306 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump37
;-307 		    getkey();

 call getkey
;-308 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-309 		    }

;-310         putch(10);

.mdump37:
 push 10
 call putch
 add  sp, 2
;-311         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-312         putch(':');

 push 58
 call putch
 add  sp, 2
;-313         i=0;

 mov ax, 0
 mov [bp-4], ax
;-314         while (i < 16) {

.mdump38:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump39
;-315             putch(' ');

 push 32
 call putch
 add  sp, 2
;-316             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-317             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-318             adr++;

 inc  word[bp+4]
;-319             i++;

 inc  word[bp-4]
;-320             j++;

 inc  word[bp-6]
;-321             }

;-322         putch(' ');

 jmp .mdump38
.mdump39:
 push 32
 call putch
 add  sp, 2
;-323         adr -=16;

 sub  word[bp+4], 16
;-324         i=0;

 mov ax, 0
 mov [bp-4], ax
;-325         while(i < 16) {

.mdump40:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump41
;-326             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-327             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump42
 push 46
 call putch
 add  sp, 2
;-328                 else putch(c);

 jmp .mdump43
.mdump42:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-329             adr++;

.mdump43:
 inc  word[bp+4]
;-330             i++;

 inc  word[bp-4]
;-331         }

;-332     }

 jmp .mdump40
.mdump41:
;-333 }

 jmp .mdump35
.mdump36:
;-334 

;-335 //--------------------------------  disk IO  -------------------

;-336 

;-337 int DiskSectorReadWrite(char rw, char drive, char head, int cyl,

 LEAVE
 ret
ENDP

DiskSectorReadWrite: PROC
;-338 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-339 	BIOS_ERR=0;

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;95 var sign byte rw = bp+4
;96 var sign byte drive = bp+6
;97 var sign byte head = bp+8
;98 var sign word cyl = bp+10
;99 var sign byte sector = bp+12
;100 var sign byte count = bp+14
;101 var sign word BufSeg = bp+16
;102 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-340 	dl=drive;

 mov  dl, [bp+6]
;-341 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-342 	es=BufSeg;

 mov  es, [bp+16]
;-343 	bx=BufOfs;

 mov  bx, [bp+18]
;-344 	cx=cyl;

 mov  cx, [bp+10]
;-345 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-346 	cx >> 2;//in 2 high bits of cl

 shr  cx, 2
;-347 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-348 	cl += sector;

 add  cl, [bp+12]
;-349 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-350 	al=count;

 mov  al, [bp+14]
;-351 	ah=rw;

 mov  ah, [bp+4]
;-352 	inth 0x13;

 int  19
;-353     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-354 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-355 }

;-356 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-357 	BIOS_ERR=0;

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;95 var sign byte drive = bp+4
;96 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-358 	dl=drive;

 mov  dl, [bp+4]
;-359 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-360 	inth 0x13;

 int  19
;-361     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-362 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-363 }

;-364 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-365 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-366 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-367 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-368 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-369 }

;-370 int Status(drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Status: PROC
;-371 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;95 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-372 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-373 	BIOS_Status=Int13hfunction(drive, 1);

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-374 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Status44
 call Int13hError
;-375 	printhex16(BIOS_Status);

.Status44:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-376 }

;-377 

;-378 int Params() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

Params: PROC
;-379 	cputs("Get Drive Params ");

 push Params_0
 call cputs
 add  sp, 2
;-380 	BIOS_Status=Int13hfunction(Drive, 8);

 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-381 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params45
;-382 		Int13hError();

 call Int13hError
;-383 		return 1;

 mov ax, 1
 jmp .retnParams
;-384 		}

;-385 	else {

 jmp .Params46
.Params45:
;-386 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-387 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-388 		// CX =       ---CH--- ---CL---

;-389 		// cylinder : 76543210 98

;-390 		// sector   :            543210

;-391 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-392 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-393 //		pa_Sectors++;//1 to 64

;-394 

;-395 		asm mov [pa_Cylinders],    cx

 mov [pa_Cylinders],    cx
;-396 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-397 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-398 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty

 add [pa_Cylinders],    ch;//byte add, low byte is empty
;-399 

;-400 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params47
;-401 			cputs(" no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-402 			return 1;

 mov ax, 1
 jmp .retnParams
;-403 			}

;-404 	}

.Params47:
;-405 	return 0;

.Params46:
 mov ax, 0
 jmp .retnParams
;-406 }

;-407 

;-408 

;-409 int getPartitionData() {

 .retnParams:
 ret
Params_0 db "Get Drive Params ",0
Params_1 db " no hard disk found",0
ENDP

getPartitionData: PROC
;-410 	unsigned int j; char c; char *p;

;-411 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;95 var unsg word j = bp-2
;96 var sign byte c = bp-4
;97 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [pt_PartNo]
 shl ax, 4
 mov [bp-2], ax
;-412 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-413 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-414 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-415 	pt_StartCylinder=(int)pt_StartSector;

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-416 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-417 //	pt_StartSector++;//Sector start with 1 todo

;-418 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-419 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-420 	j++;

 inc  word[bp-2]
;-421 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-422 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-423 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB

;-424 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-425 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-426 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-427 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-428 //	pt_EndSector++;//Sector start with 1 todo

;-429 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-430 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-431 	j++;

 inc  word[bp-2]
;-432 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-433 	j++;

 inc  word[bp-2]
;-434 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-435 	memcpy(&pt_HiddenSector, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-436 }

;-437 

;-438 int checkBootSign() {

 LEAVE
 ret
ENDP

checkBootSign: PROC
;-439 	int i;

;-440 	i=510;

;Function : checkBootSign, Number local Var: 1
; # type sign width local variables
;95 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-441 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign48
;-442 		i++;

 inc  word[bp-2]
;-443 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign49
 mov ax, 1
 jmp .retncheckBootSign
;-444 	}

.checkBootSign49:
;-445 	cputs(" Magic number NOT found.");

.checkBootSign48:
 push checkBootSign_0
 call cputs
 add  sp, 2
;-446 	return 0;

 mov ax, 0
 jmp .retncheckBootSign
;-447 }

;-448 

;-449 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db " Magic number NOT found.",0
ENDP

readMBR: PROC
;-450 	int isFAT;

;-451 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;95 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-452 	pt_PartNo=0;

 mov ax, 0
 mov word [pt_PartNo], ax
;-453 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-454 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR50
;-455 		Int13hError();

 call Int13hError
;-456 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-457 		}

;-458 	else {

 jmp .readMBR51
.readMBR50:
;-459 		putch(10);

 push 10
 call putch
 add  sp, 2
;-460 		cputs("Read partition.");

 push readMBR_0
 call cputs
 add  sp, 2
;-461 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .readMBR52
 mov ax, 0
 jmp .retnreadMBR
;-462 		do {

.readMBR52:
.readMBR53:
;-463 			getPartitionData();

 call getPartitionData
;-464 

;-465 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR54
;-466 				cputs("Boot partition found");

 push readMBR_1
 call cputs
 add  sp, 2
;-467 				if (pt_FileSystem == 1) {

 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR55
;-468 					cputs(", FAT12 partition < 32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-469 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-470 					}

;-471 				if (pt_FileSystem == 4) {

.readMBR55:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR56
;-472 					cputs(", small FAT16 partition < 32MB");

 push readMBR_3
 call cputs
 add  sp, 2
;-473 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-474 					}

;-475 				if (pt_FileSystem == 6) {

.readMBR56:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR57
;-476 					cputs(", large FAT16 partition < 2GB");

 push readMBR_4
 call cputs
 add  sp, 2
;-477 					isFAT=6;

 mov ax, 6
 mov [bp-2], ax
;-478 					}

;-479 				pt_PartNo=99;//end of loop

.readMBR57:
 mov ax, 99
 mov word [pt_PartNo], ax
;-480 			}

;-481 			pt_PartNo ++;

.readMBR54:
 inc  word[pt_PartNo]
;-482 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR58
 jmp .readMBR53
.readMBR58:
;-483 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-484 	}

;-485 }

.readMBR51:
;-486 

;-487 int getBootSector() {

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
;-488 	int i;

;-489 	putch(10);

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;95 var sign word i = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-490 	cputs(" Read boot sector");

 push getBootSector_0
 call cputs
 add  sp, 2
;-491   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

;-492   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-493 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector59
;-494 		Int13hError();

 call Int13hError
;-495 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-496 		}

;-497 	else {

 jmp .getBootSector60
.getBootSector59:
;-498 //		printhex16(BIOS_Status);

;-499 		if(checkBootSign()==0) return 0;

 call checkBootSign
 cmp al, 0
 jne .getBootSector61
 mov ax, 0
 jmp .retngetBootSector
;-500 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector61:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-501 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector62
 push getBootSector_1
 call cputs
 add  sp, 2
;-502 		i=2;

.getBootSector62:
 mov ax, 2
 mov [bp-2], ax
;-503 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector63
 push getBootSector_2
 call cputs
 add  sp, 2
;-504 	}

.getBootSector63:
;-505 	return 1;

.getBootSector60:
 mov ax, 1
 jmp .retngetBootSector
;-506 }

;-507 

;-508 int FATInit() {

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Read boot sector",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-509 	unsigned long templong;//converting word to dword

;-510 //	fat_currentdrive = bs_drive_num;

;-511 //	fat_currentpath = 0;

;-512 

;-513 	fat_FatStartSector = bs_res_sects;

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;95 var unsg long templong = bp-4;
 ENTER  4,0
 mov ax, [bs_res_sects]
 mov word [fat_FatStartSector], ax
;-514 	fat_FatSectors = bs_fat_size;

 mov ax, [bs_fat_size]
 mov word [fat_FatSectors], ax
;-515 	if (bs_num_fats == 2) fat_FatSectors=fat_FatSectors+fat_FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .FATInit64
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-516 

;-517 	fat_RootDirStartSector = fat_FatStartSector + fat_FatSectors;

.FATInit64:
 mov ax, [fat_FatStartSector]
 add ax, [fat_FatSectors]
 mov word [fat_RootDirStartSector], ax
;-518 	fat_RootDirSectors = bs_root_entr << 5;// *32

 mov ax, [bs_root_entr]
 shl ax, 5
 mov word [fat_RootDirSectors], ax
;-519 	fat_RootDirSectors = fat_RootDirSectors / bs_sect_size;

 mov ax, [fat_RootDirSectors]
 xor dx, dx
 div word [bs_sect_size]
 mov word [fat_RootDirSectors], ax
;-520 

;-521 	fat_DataStartSector = fat_RootDirStartSector + fat_RootDirSectors;

 mov ax, [fat_RootDirStartSector]
 add ax, [fat_RootDirSectors]
 mov word [fat_DataStartSector], ax
;-522 	templong=(long) fat_DataStartSector;

 xor eax, eax
 mov ax, [fat_DataStartSector]
 mov [bp-4], eax
;-523 

;-524 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .FATInit65
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-525 	DataSectors32=bs_tot_sect32 - templong;

.FATInit65:
 mov eax, [bs_tot_sect32]
 sub eax, [bp-4]
 mov dword [DataSectors32], eax
;-526 

;-527 	templong = (long) bs_clust_size;

 xor eax, eax
 mov al, [bs_clust_size]
 mov [bp-4], eax
;-528 	CountofClusters=DataSectors32 / templong;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [bp-4]
 mov dword [CountofClusters], eax
;-529 

;-530 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-531 	fat_num_tracks = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [fat_num_tracks], eax
;-532 

;-533 	templong = (long) bs_num_heads;

 xor eax, eax
 mov ax, [bs_num_heads]
 mov [bp-4], eax
;-534 	fat_num_cylinders = fat_num_tracks / templong;//w=d/w

 mov eax, [fat_num_tracks]
 xor edx, edx
 div dword [bp-4]
 mov word [fat_num_cylinders], ax
;-535 

;-536 	Sectors_per_cylinder = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinder], eax
;-537 	asm mov [Sectors_per_cylinder + 2], dx;store high word

 mov [Sectors_per_cylinder + 2], dx;store high word
;-538 

;-539 	cputs(", trueFATtype=FAT");

 push FATInit_0
 call cputs
 add  sp, 2
;-540 

;-541 	templong = (long) 65525;

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-542 	if (CountofClusters > templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jle .FATInit66
;-543 		trueFATtype=32;

 mov ax, 32
 mov byte [trueFATtype], al
;-544 		cputs("32 NOT supported");

 push FATInit_1
 call cputs
 add  sp, 2
;-545 		return 1;

 mov ax, 1
 jmp .retnFATInit
;-546 		}

;-547 	templong= (long) 4086;

.FATInit66:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-548 	if (CountofClusters < templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jge .FATInit67
;-549 		trueFATtype=12;

 mov ax, 12
 mov byte [trueFATtype], al
;-550 		cputs("12");

 push FATInit_2
 call cputs
 add  sp, 2
;-551 		return 0;

 mov ax, 0
 jmp .retnFATInit
;-552 		}

;-553 	trueFATtype=16;

.FATInit67:
 mov ax, 16
 mov byte [trueFATtype], al
;-554 	cputs("16");

 push FATInit_3
 call cputs
 add  sp, 2
;-555 	return 0;

 mov ax, 0
 jmp .retnFATInit
;-556 }

;-557 

;-558 int Int13hExt() {

 .retnFATInit:
 LEAVE
 ret
FATInit_0 db ", trueFATtype=FAT",0
FATInit_1 db "32 NOT supported",0
FATInit_2 db "12",0
FATInit_3 db "16",0
ENDP

Int13hExt: PROC
;-559 	bx=0x55AA;

 mov  bx, 21930
;-560 	BIOS_Status=Int13hfunction(Drive, 0x41);

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-561 	asm mov [vAX], ax;

 mov [vAX], ax;
;-562 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-563 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported
;-564 //	putch(10);

;-565 //	cputs("Int13h 41h Ext=");	printhex16(vAX);

;-566 //	cputs(", BIOS_Status=");	printhex16(BIOS_Status);

;-567 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt68
;-568 		cputs(" Ext NOT present");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-569 		Int13hError();

 call Int13hError
;-570 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-571 		}

;-572 	else {

 jmp .Int13hExt69
.Int13hExt68:
;-573 		cputs(",Extension found BX(AA55)=");printhex16(vBX);

 push Int13hExt_1
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-574 //		cputs(" CX=");						printhex16(vCX);

;-575 		}

;-576 	return 0;

.Int13hExt69:
 mov ax, 0
 jmp .retnInt13hExt
;-577 }

;-578 

;-579 int readLogical() {//IN:Sectors_to_read, OUT:1 sector in DiskBuf

 .retnInt13hExt:
 ret
Int13hExt_0 db " Ext NOT present",0
Int13hExt_1 db ",Extension found BX(AA55)=",0
ENDP

readLogical: PROC
;-580 	unsigned int track; unsigned int head; unsigned int sect;

;-581 	Sectors_to_read = Sectors_to_read + bs_hid_sects;//d=d+d

;Function : readLogical, Number local Var: 3
; # type sign width local variables
;95 var unsg word track = bp-2
;96 var unsg word head = bp-4
;97 var unsg word sect = bp-6;
 ENTER  6,0
 mov eax, [Sectors_to_read]
 add eax, [bs_hid_sects]
 mov dword [Sectors_to_read], eax
;-582 	track = Sectors_to_read / Sectors_per_cylinder;  //w=d/d

 mov eax, [Sectors_to_read]
 xor edx, edx
 div dword [Sectors_per_cylinder]
 mov [bp-2], ax
;-583 	head  = Sectors_to_read % Sectors_per_cylinder;  //w=d%d

 mov eax, [Sectors_to_read]
 xor edx, edx
 div dword [Sectors_per_cylinder]
 mov eax, edx
 mov [bp-4], ax
;-584 	sect  = head            % bs_sectors_per_track;  //w=w%w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov ax, dx
 mov [bp-6], ax
;-585 	sect++;

 inc  word[bp-6]
;-586 	head  = head            / bs_sectors_per_track;	 //w=w/w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov [bp-4], ax
;-587 

;-588 	DiskSectorReadWrite(2, bs_drive_num, head, track/* =cyl */,

;-589 		sect, 1, DiskBufSeg , DiskBuf);

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
;-590 }

;-591 

;-592 int PrintDriveParameter() {

 LEAVE
 ret
ENDP

PrintDriveParameter: PROC
;-593 	unsigned long Lo;

;-594 // from Params

;-595 	putch(10);

;Function : PrintDriveParameter, Number local Var: 1
; # type sign width local variables
;95 var unsg long Lo = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-596 	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);

 push PrintDriveParameter_0
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-597 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-598 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-599 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-600 	putch('.');

 push 46
 call putch
 add  sp, 2
;-601 //from getPartitionData

;-602 	putch(10);

 push 10
 call putch
 add  sp, 2
;-603 	cputs("getPartitionData:No=");printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-604 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-605 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-606 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-607 	cputs("/");				printunsign(pt_StartSector);

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-608 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-609 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-610 	cputs("/");				printunsign(pt_EndSector);

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-611 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-612 	cputs(",Start=");		printlong(pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 push dword [pt_HiddenSector]
 call printlong
 add  sp, 2
;-613 	cputs(",Len=");			printlong(pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 push dword [pt_PartLen]
 call printlong
 add  sp, 2
;-614 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-615 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-616 	printlong(Lo);

 push dword [bp-4]
 call printlong
 add  sp, 2
;-617 	cputs(" MByte.");

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-618 //from getBootSector

;-619 	putch(10);

 push 10
 call putch
 add  sp, 2
;-620 	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-621 	putch(10);

 push 10
 call putch
 add  sp, 2
;-622 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-623 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-624 	putch(10);

 push 10
 call putch
 add  sp, 2
;-625 	cputs("Reserved sectors=");printunsign(bs_res_sects);

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-626 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-627 	putch(10);

 push 10
 call putch
 add  sp, 2
;-628 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-629 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-630 	putch(10);

 push 10
 call putch
 add  sp, 2
;-631 	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-632 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-633 	putch(10);

 push 10
 call putch
 add  sp, 2
;-634 	cputs("sectors per track=");printunsign(bs_sectors_per_track);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_sectors_per_track]
 call printunsign
 add  sp, 2
;-635 	cputs(".number of heads=");printunsign(bs_num_heads);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_heads]
 call printunsign
 add  sp, 2
;-636 	putch(10);

 push 10
 call putch
 add  sp, 2
;-637 	cputs("hidden sectors(long)=");printlong(bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 push dword [bs_hid_sects]
 call printlong
 add  sp, 2
;-638 	cputs(".sectors(long)=");printlong(bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 push dword [bs_tot_sect32]
 call printlong
 add  sp, 2
;-639 	putch(10);

 push 10
 call putch
 add  sp, 2
;-640 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-641 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-642 	putch(10);

 push 10
 call putch
 add  sp, 2
;-643 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-644 	cputs(".Volume serial(long)=");printlong(bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 push dword [bs_serial_num]
 call printlong
 add  sp, 2
;-645 	putch(10);

 push 10
 call putch
 add  sp, 2
;-646 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-647 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-648 //from FATInit

;-649 	putch(10);

 push 10
 call putch
 add  sp, 2
;-650 	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [fat_FatStartSector]
 call printunsign
 add  sp, 2
;-651 	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [fat_FatSectors]
 call printunsign
 add  sp, 2
;-652 	putch(10);

 push 10
 call putch
 add  sp, 2
;-653 	cputs("fat_RootDirStartSector="); printunsign(fat_RootDirStartSector);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push word [fat_RootDirStartSector]
 call printunsign
 add  sp, 2
;-654 	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectors);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push word [fat_RootDirSectors]
 call printunsign
 add  sp, 2
;-655 	putch(10);

 push 10
 call putch
 add  sp, 2
;-656 	cputs("fat_DataStartSector=");	printunsign(fat_DataStartSector);

 push PrintDriveParameter_38
 call cputs
 add  sp, 2
 push word [fat_DataStartSector]
 call printunsign
 add  sp, 2
;-657 	cputs(", DataSectors32=");	printlong(DataSectors32);

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 push dword [DataSectors32]
 call printlong
 add  sp, 2
;-658 	putch(10);

 push 10
 call putch
 add  sp, 2
;-659 	cputs("CountofClusters=");	printlong(CountofClusters);

 push PrintDriveParameter_40
 call cputs
 add  sp, 2
 push dword [CountofClusters]
 call printlong
 add  sp, 2
;-660 	cputs(", Sectors_per_cylinder="); printlong(Sectors_per_cylinder);

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 push dword [Sectors_per_cylinder]
 call printlong
 add  sp, 2
;-661 	putch(10);

 push 10
 call putch
 add  sp, 2
;-662 	cputs("fat_num_tracks=");	printlong(fat_num_tracks);

 push PrintDriveParameter_42
 call cputs
 add  sp, 2
 push dword [fat_num_tracks]
 call printlong
 add  sp, 2
;-663 	cputs(", fat_num_cylinders="); printunsign(fat_num_cylinders);

 push PrintDriveParameter_43
 call cputs
 add  sp, 2
 push word [fat_num_cylinders]
 call printunsign
 add  sp, 2
;-664 	putch(10);

 push 10
 call putch
 add  sp, 2
;-665 	cputs("Sectors_per_cylinder=");	printlong(Sectors_per_cylinder);

 push PrintDriveParameter_44
 call cputs
 add  sp, 2
 push dword [Sectors_per_cylinder]
 call printlong
 add  sp, 2
;-666 }

;-667 

;-668 //--------------------------------  file IO  -------------------

;-669 int error2(char *s) {

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
PrintDriveParameter_36 db "fat_RootDirStartSector=",0
PrintDriveParameter_37 db ", fat_RootDirSectors=",0
PrintDriveParameter_38 db "fat_DataStartSector=",0
PrintDriveParameter_39 db ", DataSectors32=",0
PrintDriveParameter_40 db "CountofClusters=",0
PrintDriveParameter_41 db ", Sectors_per_cylinder=",0
PrintDriveParameter_42 db "fat_num_tracks=",0
PrintDriveParameter_43 db ", fat_num_cylinders=",0
PrintDriveParameter_44 db "Sectors_per_cylinder=",0
ENDP

error2: PROC
;-670 	putch(10);

;Function : error2, Number local Var: 1
; # type sign width local variables
;95 ptr sign byte s = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-671 	cputs("*** ERROR *** ");

 push error2_0
 call cputs
 add  sp, 2
;-672 	cputs(s);

 push word [bp+4]
 call cputs
 add  sp, 2
;-673 	DOS_ERR++;

 inc  byte[DOS_ERR]
;-674 }

;-675 int fatDirSectorSearch(unsigned long startSector, unsigned int numsectors) {

 LEAVE
 ret
error2_0 db "*** ERROR *** ",0
ENDP

fatDirSectorSearch: PROC
;-676     //search in fat_filename+ext

;-677     unsigned int i;

;-678     i=0;

;Function : fatDirSectorSearch, Number local Var: 3
; # type sign width local variables
;95 var unsg long startSector = bp+4
;96 var unsg word numsectors = bp+8
;97 var unsg word i = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-679 

;-680 

;-681 

;-682 }

;-683 

;-684 int fatRootSearch(char *search) {

 LEAVE
 ret
ENDP

fatRootSearch: PROC
;-685     // only for test

;-686     memcpy(&fat_filename, "DOS     COM", 11);

;Function : fatRootSearch, Number local Var: 1
; # type sign width local variables
;95 ptr sign byte search = bp+4;
 ENTER  0,0
 push 11
 push fatRootSearch_0
 lea  ax, [fat_filename]
 push ax
 call memcpy
 add  sp, 6
;-687     fatDirSectorSearch(fat_RootDirStartSector, fat_RootDirSectors);

 push word [fat_RootDirSectors]
 push word [fat_RootDirStartSector]
 call fatDirSectorSearch
 add  sp, 4
;-688 

;-689 

;-690 }

;-691 

;-692 int fatNextSearch(char *search, char *upto, int *last) {

 LEAVE
 ret
fatRootSearch_0 db "DOS     COM",0
ENDP

fatNextSearch: PROC
;-693 //todo parameter must be:    char **upto

;-694 

;-695 

;-696 

;-697 }

;Function : fatNextSearch, Number local Var: 3
; # type sign width local variables
;95 ptr sign byte search = bp+4
;96 ptr sign byte upto = bp+6
;97 ptr sign word last = bp+8;
 ENTER  0,0
;-698 

;-699 int fatGetStartCluster() {

 LEAVE
 ret
ENDP

fatGetStartCluster: PROC
;-700 	char search[11];

;-701 	char *upto;

;-702 	int last;

;-703 

;-704 	if (fat_notfound) return;

;Function : fatGetStartCluster, Number local Var: 3
; # type sign width local variables
;95 arr sign byte search[65525] = bp-11
;96 ptr sign byte upto = bp-13
;97 var sign word last = bp-15;
 ENTER  15,0
 mov ax, [fat_notfound]
 or  al, al
 je .fatGetStartCluster70
 jmp .retnfatGetStartCluster
;-705 	*upto = filename;

.fatGetStartCluster70:
 mov al, [filename]
 mov  bx, [bp-13]
 mov  [bx], al
;-706 	fatfile_cluster = 0;

 mov ax, 0
 mov word [fatfile_cluster], ax
;-707 

;-708 	fatNextSearch(search, &upto, &last);

 lea  ax, [bp-15]
 push ax
 lea  ax, [bp-13]
 push ax
 lea  ax, [bp-11]
 push ax
 call fatNextSearch
 add  sp, 6
;-709 

;-710 }

;-711 

;-712 int fatOpenFile() {//remove backslash, set handle for root or subdir

 .retnfatGetStartCluster:
 LEAVE
 ret
ENDP

fatOpenFile: PROC
;-713 	unsigned long bytes_per_cluster;

;-714 	fat_notfound=0;

;Function : fatOpenFile, Number local Var: 1
; # type sign width local variables
;95 var unsg long bytes_per_cluster = bp-4;
 ENTER  4,0
 mov ax, 0
 mov word [fat_notfound], ax
;-715 	if (filename[0] == 0) {//empty filename

 mov al, [filename]
 cmp al, 0
 jne .fatOpenFile71
;-716 		fatfile_root = 1;

 mov ax, 1
 mov word [fatfile_root], ax
;-717 		fatfile_nextCluster = 0xFFFF;

 mov ax, 65535
 mov word [fatfile_nextCluster], ax
;-718 		fatfile_sectorCount = fat_RootDirSectors;

 mov ax, [fat_RootDirSectors]
 mov word [fatfile_sectorCount], ax
;-719 		fatfile_sectorStart = (long) fat_RootDirStartSector;

 xor eax, eax
 mov ax, [fat_RootDirStartSector]
 mov dword [fatfile_sectorStart], eax
;-720 		fatfile_lastBytes   = 0;

 mov ax, 0
 mov word [fatfile_lastBytes], ax
;-721 		fatfile_lastSectors = fat_RootDirSectors;

 mov ax, [fat_RootDirSectors]
 mov word [fatfile_lastSectors], ax
;-722 		fatfile_cluster     = 0;

 mov ax, 0
 mov word [fatfile_cluster], ax
;-723 		fatfile_dir         = 1;

 mov ax, 1
 mov word [fatfile_dir], ax
;-724 

;-725 	} else {//search in subdir

 jmp .fatOpenFile72
.fatOpenFile71:
;-726 		fatfile_root = 0;

 mov ax, 0
 mov word [fatfile_root], ax
;-727 		fatGetStartCluster();

 call fatGetStartCluster
;-728 		if (fat_notfound) return 1;

 mov ax, [fat_notfound]
 or  al, al
 je .fatOpenFile73
 mov ax, 1
 jmp .retnfatOpenFile
;-729 		bytes_per_cluster   = (long) bs_clust_size * bs_sect_size;

.fatOpenFile73:
 xor eax, eax
 mov al, [bs_clust_size]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_sect_size]
 mov [bp-4], eax
;-730 		fatfile_lastBytes   = fatfile_fileSize % bytes_per_cluster;

 mov eax, [fatfile_fileSize]
 xor edx, edx
 div dword [bp-4]
 mov eax, edx
 mov word [fatfile_lastBytes], ax
;-731 		fatfile_lastSectors = fatfile_lastBytes / bs_sect_size;

 mov ax, [fatfile_lastBytes]
 xor dx, dx
 div word [bs_sect_size]
 mov word [fatfile_lastSectors], ax
;-732 		fatfile_lastBytes   = fatfile_lastBytes % bs_sect_size;

 mov ax, [fatfile_lastBytes]
 xor dx, dx
 div word [bs_sect_size]
 mov ax, dx
 mov word [fatfile_lastBytes], ax
;-733 		if (fatfile_fileSize == 0) fatfile_dir = 1;

 mov eax, [fatfile_fileSize]
 cmp eax, 0
 jne .fatOpenFile74
 mov ax, 1
 mov word [fatfile_dir], ax
;-734 		else                       fatfile_dir = 0;

 jmp .fatOpenFile75
.fatOpenFile74:
 mov ax, 0
 mov word [fatfile_dir], ax
;-735 

;-736 //		fatClusterAnalyse();

;-737 		fatfile_sectorCount = (int) bs_clust_size;

.fatOpenFile75:
 xor ax, ax
 mov al, [bs_clust_size]
 mov word [fatfile_sectorCount], ax
;-738 

;-739 	}

;-740 	fatfile_currentCluster = fatfile_cluster;

.fatOpenFile72:
 mov ax, [fatfile_cluster]
 mov word [fatfile_currentCluster], ax
;-741 	fatfile_sectorUpto = 0;

 mov ax, 0
 mov word [fatfile_sectorUpto], ax
;-742 	fatfile_byteUpto   = 0;

 mov ax, 0
 mov word [fatfile_byteUpto], ax
;-743 	if (fat_notfound) return 1;

 mov ax, [fat_notfound]
 or  al, al
 je .fatOpenFile76
 mov ax, 1
 jmp .retnfatOpenFile
;-744 	return 0;

.fatOpenFile76:
 mov ax, 0
 jmp .retnfatOpenFile
;-745 }

;-746 

;-747 int make_filename() {

 .retnfatOpenFile:
 LEAVE
 ret
ENDP

make_filename: PROC
;-748 	char *p;

;-749 	toupper(&filename);

;Function : make_filename, Number local Var: 1
; # type sign width local variables
;95 ptr sign byte p = bp-2;
 ENTER  2,0
 lea  ax, [filename]
 push ax
 call toupper
 add  sp, 2
;-750 	p = strchr(filename, ':' );

 push 58
 lea  ax, [filename]
 push ax
 call strchr
 add  sp, 4
 mov [bp-2], ax
;-751 //	if (p == 0) fat_drive = fat_currentdrive;

;-752 //	else error2("drive, patth not impl. yet");

;-753 

;-754 }

;-755 

;-756 int fileOpen() {//remove drive letter and insert in drive

 LEAVE
 ret
ENDP

fileOpen: PROC
;-757 	int rc;

;-758 	strcpy(filename, "dos.com");

;Function : fileOpen, Number local Var: 1
; # type sign width local variables
;95 var sign word rc = bp-2;
 ENTER  2,0
 push fileOpen_0
 lea  ax, [filename]
 push ax
 call strcpy
 add  sp, 4
;-759 

;-760 	make_filename();

 call make_filename
;-761 	rc=fatOpenFile();

 call fatOpenFile
 mov [bp-2], ax
;-762 	if (rc) return 0;//error

 mov ax, [bp-2]
 or  al, al
 je .fileOpen77
 mov ax, 0
 jmp .retnfileOpen
;-763 //	else return fhandle;

;-764 }

.fileOpen77:
;-765 

;-766 //------------------------------- Init,  main ---------------

;-767 int Init() {

 .retnfileOpen:
 LEAVE
 ret
fileOpen_0 db "dos.com",0
ENDP

Init: PROC
;-768 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-769 

;-770 	if (Params()) cputs("** NO DRIVE PARAMS FOUND **");//no hard disk

 call Params
 or  al, al
 je .Init78
 push Init_0
 call cputs
 add  sp, 2
;-771 	FATtype=readMBR();//0=error,1=FAT12,6=FAT16,11=FAT32

.Init78:
 call readMBR
 mov word [FATtype], ax
;-772 	if (FATtype == 0) {

 mov ax, [FATtype]
 cmp ax, 0
 jne .Init79
;-773 		cputs(" no active FAT partition found. ");

 push Init_1
 call cputs
 add  sp, 2
;-774 //		return 1;

;-775 		}

;-776 	if(getBootSector()==0) 	return 1;

.Init79:
 call getBootSector
 cmp ax, 0
 jne .Init80
 mov ax, 1
 jmp .retnInit
;-777 	if (FATInit())			return 1;

.Init80:
 call FATInit
 or  al, al
 je .Init81
 mov ax, 1
 jmp .retnInit
;-778 	if(trueFATtype != 16) 	return 1;

.Init81:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init82
 mov ax, 1
 jmp .retnInit
;-779 	Int13hExt();

.Init82:
 call Int13hExt
;-780 	return 0;

 mov ax, 0
 jmp .retnInit
;-781 }

;-782 

;-783 int main() {

 .retnInit:
 ret
Init_0 db "** NO DRIVE PARAMS FOUND **",0
Init_1 db " no active FAT partition found. ",0
ENDP

main: PROC
;-784 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-785 	if (Init() != 0) return 1;

 call Init
 cmp al, 0
 je  .main83
 mov ax, 1
 jmp .retnmain
;-786 	PrintDriveParameter();

.main83:
 call PrintDriveParameter
;-787 /*

;-788 	Sectors_to_read = (long) 0;

;-789 	readLogical();

;-790 	getkey();

;-791 	mdump(DiskBuf, 512);

;-792 */

;-793 }

 .retnmain:
 ret
ENDP
;Glob. variables:94 (400):1230 (4000), Functions:47 (300):468 (3000)
;Lines:794, Constant: 2171 (4000), stacksize: 48561