;PLA compiler A.COM V1.1.2, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.1.8";//test bed

Version1 db "DOS.COM V0.1.8",0
;-2 //Finder /hg/VirtualBox VMs/DOS1/DOS1.vhd (.vmdk) 

;-3 //rigth click / open / Parallels Mounter

;-4 // > 16.777.216 sectors (8GB) only LBA

;-5 //Ranish Part, int8h: CHS 1014/15/63, Start=63,Len=1.023.057

;-6 //Boot Sec=63, head=16, hidden=63, Sec=983.121

;-7 #define ORGDATA		8192//start of arrays

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

;-16 unsigned char DiskBuf [512];

section .bss
absolute 8192
DiskBuf resb 512
section .text
;-17 unsigned int  DiskBufSeg;

DiskBufSeg dw 0
;-18 unsigned char Drive=0x80;

Drive db 128
;-19 unsigned long Sectors_to_read;//for readLogical

Sectors_to_read dd 0
;-20 

;-21 //Params from int13h, Function 8

;-22 unsigned int  pa_Cylinders;

pa_Cylinders dw 0
;-23 unsigned char pa_Sectors;

pa_Sectors db 0
;-24 unsigned char pa_Heads;

pa_Heads db 0
;-25 unsigned char pa_Attached;

pa_Attached db 0
;-26 

;-27 unsigned int  pt_PartNo;

pt_PartNo dw 0
;-28 //start hard disk partition structure 16 bytes in MBR. do not change

;-29 unsigned char pt_Bootable;		//80h = active partition, else 00

pt_Bootable db 0
;-30 unsigned char pt_StartHead;

pt_StartHead db 0
;-31 unsigned char pt_StartSector;	//bits 0-5

pt_StartSector db 0
;-32 unsigned int  pt_StartCylinder;	//bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-33 unsigned char pt_FileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=largeFAT16

pt_FileSystem db 0
;-34 unsigned char pt_EndHead;

pt_EndHead db 0
;-35 unsigned char pt_EndSector;		//bits 0-5

pt_EndSector db 0
;-36 unsigned int  pt_EndCylinder;	//bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-37 unsigned long pt_HiddenSector;	//sectors preceding partition

pt_HiddenSector dd 0
;-38 unsigned long pt_PartLen;    	//length of partition in sectors

pt_PartLen dd 0
;-39 //end hard disk partition structure

;-40 

;-41 //start boot BIOS Parameter Block structure. do not change

;-42 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-43 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-44 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-45 unsigned char bs_clust_size;// 13 sectors per cluster (1,2,4,..,128)

bs_clust_size db 0
;-46 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-47 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-48 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-49 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-50 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-51 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-52 unsigned int  bs_sectors_per_track; // 24 (DOS 3+)sectors per track 

bs_sectors_per_track dw 0
;-53 unsigned int  bs_num_heads;	// 26 (DOS 3+)number of heads   

bs_num_heads dw 0
;-54 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors 

bs_hid_sects dd 0
;-55 unsigned long bs_tot_sect32;// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-56 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-57 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-58 unsigned char bs_ext_signat;// 38 (DOS 4+) Extended signature,get next 3(29h)

bs_ext_signat db 0
;-59 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-60 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-61 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-62 // 62 end boot BIOS Parameter Block

;-63 

;-64 //FATInit     

;-65 unsigned int fat_FatStartSector;

fat_FatStartSector dw 0
;-66 unsigned int fat_FatSectors;

fat_FatSectors dw 0
;-67 unsigned int fat_RootDirStartSector;

fat_RootDirStartSector dw 0
;-68 unsigned int fat_RootDirSectors;

fat_RootDirSectors dw 0
;-69 unsigned int fat_DataStartSector;

fat_DataStartSector dw 0
;-70 unsigned long fat_num_tracks;

fat_num_tracks dd 0
;-71 unsigned int  fat_num_cylinders;

fat_num_cylinders dw 0
;-72 unsigned long Sectors_per_cylinder;

Sectors_per_cylinder dd 0
;-73 unsigned long DataSectors32;

DataSectors32 dd 0
;-74 unsigned long CountofClusters;

CountofClusters dd 0
;-75 char          trueFATtype;

trueFATtype db 0
;-76 

;-77 //FAT file

;-78 unsigned char fat_currentdrive;

fat_currentdrive db 0
;-79 unsigned char fat_currentpath[55];

section .bss
absolute 8704
fat_currentpath resb 55
section .text
;-80 unsigned char fat_drive;//physical

fat_drive db 0
;-81 unsigned char full_filename[67];

section .bss
absolute 8759
full_filename resb 67
section .text
;-82 unsigned char fat_path     [55];

section .bss
absolute 8826
fat_path resb 55
section .text
;-83 unsigned char fat_filename [8];

section .bss
absolute 8881
fat_filename resb 8
section .text
;-84 unsigned char fat_fileext  [3];

section .bss
absolute 8889
fat_fileext resb 3
section .text
;-85 

;-86 int test() {


test: PROC
;-87 __asm{	

	
;-88 


;-89 }	}


;-90 

;-91 //------------------------------------   IO  -------------------

;-92 

;-93 int writetty()     {//char in AL

 ret
ENDP

writetty: PROC
;-94     ah=0x0E;

 mov  ah, 14
;-95     push bx;

push bx;
;-96     bx=0;			//page in BH

 mov  bx, 0
;-97     inth 0x10;		//16

 int  16
;-98     pop bx;

pop bx;
;-99 }

;-100 int putch(char c)  {

 ret
ENDP

putch: PROC
;-101     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;72 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-102         al=13;

 mov  al, 13
;-103         writetty();

 call writetty
;-104     }

;-105     al=c;

.putch1:
 mov  al, [bp+4]
;-106     writetty();

 call writetty
;-107 }

;-108 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-109     char c;

;-110     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;72 ptr sign byte s = bp+4
;73 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-111         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-112         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-113         s++;

 inc  word[bp+4]
;-114     }

;-115 }

 jmp .cputs2
.cputs3:
;-116 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-117 	char c;

;-118 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;72 ptr sign byte s = bp+4
;73 var sign word len = bp+6
;74 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-119 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-120 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-121 		s++;

 inc  word[bp+4]
;-122 		len--;

 dec  word[bp+6]
;-123 	} while (len > 0);	

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-124 }

;-125 

;-126 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-127     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-128     inth 0x16;//AH=Scan code, AL=char

 int  22
;-129 }

;-130 int waitkey() {

 ret
ENDP

waitkey: PROC
;-131     ah=0x11;//get kbd status

 mov  ah, 17
;-132     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-133     //zero flag: 0=IS char, 1=NO char

;-134     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-135 }

;-136 int getkey() {

 ret
ENDP

getkey: PROC
;-137     waitkey();

 call waitkey
;-138     getch();

 call getch
;-139     ah=0;//clear scan code

 mov  ah, 0
;-140     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-141     //put ext code in AX

;-142 }

.getkey6:
;-143 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-144     getkey();

 call getkey
;-145     writetty();//destroys AH

 call writetty
;-146 }

;-147 

;-148 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-149     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;72 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-150     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-151     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-152 }

;-153 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-154     unsigned char nib;

;-155     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;72 var unsg byte c = bp+4
;73 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-156     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-157 }

;-158 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-159     unsigned int half;

;-160     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;72 var unsg word i = bp+4
;73 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-161     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-162 }

;-163 

;-164 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-165     unsigned int e;

;-166     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;72 var unsg word n = bp+4
;73 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-167         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-168         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-169         }

;-170     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-171     n+='0';

 add  word[bp+4], 48
;-172     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-173 }

;-174 

;-175 int printlong(unsigned int *p) {

 LEAVE
 ret
ENDP

printlong: PROC
;-176 	unsigned int lo; unsigned int hi;

;-177 	lo = *p;

;Function : printlong, Number local Var: 3
; # type sign width local variables
;72 ptr unsg word p = bp+4
;73 var unsg word lo = bp-2
;74 var unsg word hi = bp-4;
 ENTER  4,0
 mov bx, [bp+4]
 mov ax, [bx]
 mov [bp-2], ax
;-178 	p +=2;

 add  word[bp+4], 2
;-179 	hi = *p;

 mov bx, [bp+4]
 mov ax, [bx]
 mov [bp-4], ax
;-180 	dx=hi;

 mov  dx, [bp-4]
;-181 	ax=lo;

 mov  ax, [bp-2]
;-182 __asm{	

	
;-183   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-184     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-185 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-186     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-187     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-188 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-189     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-190     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-191     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-192     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-193     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-194     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-195     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-196     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-197 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-198 }	writetty();		__asm{


 call writetty

;-199     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-200     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-201     jb      .b             ;Not yet	

    jb      .b             ;Not yet	
;-202 } 


;-203 }

;-204 

;-205 //--------------------------------  string  ---------------------

;-206 int strlen(char *s) { int c;

 LEAVE
 ret
ENDP

strlen: PROC
;-207     c=0;

;Function : strlen, Number local Var: 2
; # type sign width local variables
;72 ptr sign byte s = bp+4
;73 var sign word c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-208     while (*s!=0) {s++; c++;}

.strlen9:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen10
 inc  word[bp+4]
 inc  word[bp-2]
;-209     return c;

 jmp .strlen9
.strlen10:
 mov ax, [bp-2]
 jmp .retnstrlen
;-210 }

;-211 int strcpy(char *s, char *t) {

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-212     do { *s=*t; s++; t++; }

;Function : strcpy, Number local Var: 2
; # type sign width local variables
;72 ptr sign byte s = bp+4
;73 ptr sign byte t = bp+6;
 ENTER  0,0
.strcpy11:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-213     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy12
 jmp .strcpy11
.strcpy12:
;-214     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-215     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-216 }

;-217 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-218     while(*p) {

;Function : eqstr, Number local Var: 2
; # type sign width local variables
;72 ptr sign byte p = bp+4
;73 ptr sign byte q = bp+6;
 ENTER  0,0
.eqstr13:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr14
;-219         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr15
 mov ax, 0
 jmp .retneqstr
;-220         p++;

.eqstr15:
 inc  word[bp+4]
;-221         q++;

 inc  word[bp+6]
;-222     }

;-223     if(*q) return 0;

 jmp .eqstr13
.eqstr14:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr16
 mov ax, 0
 jmp .retneqstr
;-224     return 1;

.eqstr16:
 mov ax, 1
 jmp .retneqstr
;-225 }

;-226 int strcat(char *s, char *t) {

 .retneqstr:
 LEAVE
 ret
ENDP

strcat: PROC
;-227     while (*s != 0) s++;

;Function : strcat, Number local Var: 2
; # type sign width local variables
;72 ptr sign byte s = bp+4
;73 ptr sign byte t = bp+6;
 ENTER  0,0
.strcat17:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat18
 inc  word[bp+4]
;-228     strcpy(s, t);

 jmp .strcat17
.strcat18:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4
;-229 }

;-230 int toupper(char *s) {

 LEAVE
 ret
ENDP

toupper: PROC
;-231     while(*s) {

;Function : toupper, Number local Var: 1
; # type sign width local variables
;72 ptr sign byte s = bp+4;
 ENTER  0,0
.toupper19:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper20
;-232         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  .toupper21
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  .toupper22
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
;-233         s++;

.toupper22:
.toupper21:
 inc  word[bp+4]
;-234     }

;-235 }

 jmp .toupper19
.toupper20:
;-236 int strchr(char *s, char c) {

 LEAVE
 ret
ENDP

strchr: PROC
;-237     while(*s) {

;Function : strchr, Number local Var: 2
; # type sign width local variables
;72 ptr sign byte s = bp+4
;73 var sign byte c = bp+6;
 ENTER  0,0
.strchr23:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .strchr24
;-238         if (*s==c) return s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .strchr25
 mov ax, [bp+4]
 jmp .retnstrchr
;-239         s++;

.strchr25:
 inc  word[bp+4]
;-240     }

;-241     return 0;

 jmp .strchr23
.strchr24:
 mov ax, 0
 jmp .retnstrchr
;-242 }

;-243 int instr1(char *s, char c) {

 .retnstrchr:
 LEAVE
 ret
ENDP

instr1: PROC
;-244     while(*s) {

;Function : instr1, Number local Var: 2
; # type sign width local variables
;72 ptr sign byte s = bp+4
;73 var sign byte c = bp+6;
 ENTER  0,0
.instr126:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .instr127
;-245         if (*s==c) return 1;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+6]
 jne .instr128
 mov ax, 1
 jmp .retninstr1
;-246         s++;

.instr128:
 inc  word[bp+4]
;-247     }

;-248     return 0;

 jmp .instr126
.instr127:
 mov ax, 0
 jmp .retninstr1
;-249 }

;-250 

;-251 int memcpy(char *s, char *t, unsigned int i) {

 .retninstr1:
 LEAVE
 ret
ENDP

memcpy: PROC
;-252 	unsigned int r;

;-253 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;72 ptr sign byte s = bp+4
;73 ptr sign byte t = bp+6
;74 var unsg word i = bp+8
;75 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-254 	do {

.memcpy29:
;-255 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-256 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-257 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy30
 jmp .memcpy29
.memcpy30:
;-258 	ax=r;//	return r;

 mov  ax, [bp-2]
;-259 }

;-260 	

;-261 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-262     unsigned char c; int i; int j; int k;

;-263     j=0;

;Function : mdump, Number local Var: 6
; # type sign width local variables
;72 ptr unsg byte adr = bp+4
;73 var unsg word len = bp+6
;74 var unsg byte c = bp-2
;75 var sign word i = bp-4
;76 var sign word j = bp-6
;77 var sign word k = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-6], ax
;-264     k=0;

 mov ax, 0
 mov [bp-8], ax
;-265     while (j < len ) {

.mdump31:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump32
;-266 	    k++;; 

 inc  word[bp-8]
;-267 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump33
;-268 		    getkey();

 call getkey
;-269 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-270 		    }

;-271         putch(10);

.mdump33:
 push 10
 call putch
 add  sp, 2
;-272         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-273         putch(':');

 push 58
 call putch
 add  sp, 2
;-274         i=0;

 mov ax, 0
 mov [bp-4], ax
;-275         while (i < 16) {

.mdump34:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump35
;-276             putch(' ');

 push 32
 call putch
 add  sp, 2
;-277             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-278             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-279             adr++;

 inc  word[bp+4]
;-280             i++;

 inc  word[bp-4]
;-281             j++;

 inc  word[bp-6]
;-282             }

;-283         putch(' ');

 jmp .mdump34
.mdump35:
 push 32
 call putch
 add  sp, 2
;-284         adr -=16;

 sub  word[bp+4], 16
;-285         i=0;

 mov ax, 0
 mov [bp-4], ax
;-286         while(i < 16) {

.mdump36:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump37
;-287             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-288             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump38
 push 46
 call putch
 add  sp, 2
;-289                 else putch(c);

 jmp .mdump39
.mdump38:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-290             adr++;

.mdump39:
 inc  word[bp+4]
;-291             i++;

 inc  word[bp-4]
;-292         }

;-293     }

 jmp .mdump36
.mdump37:
;-294 }

 jmp .mdump31
.mdump32:
;-295 

;-296 //--------------------------------  disk IO  -------------------

;-297 

;-298 int DiskSectorReadWrite(char rw, char drive, char head, int cyl, 

 LEAVE
 ret
ENDP

DiskSectorReadWrite: PROC
;-299 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-300 	BIOS_ERR=0;	

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;72 var sign byte rw = bp+4
;73 var sign byte drive = bp+6
;74 var sign byte head = bp+8
;75 var sign word cyl = bp+10
;76 var sign byte sector = bp+12
;77 var sign byte count = bp+14
;78 var sign word BufSeg = bp+16
;79 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-301 	dl=drive;

 mov  dl, [bp+6]
;-302 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-303 	es=BufSeg;

 mov  es, [bp+16]
;-304 	bx=BufOfs;

 mov  bx, [bp+18]
;-305 	cx=cyl;	

 mov  cx, [bp+10]
;-306 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-307 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-308 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-309 	cl += sector;

 add  cl, [bp+12]
;-310 	ch=cyl;//low byte of cyl in ch, word 2 byte	

 mov  ch, [bp+10]
;-311 	al=count;

 mov  al, [bp+14]
;-312 	ah=rw;

 mov  ah, [bp+4]
;-313 	inth 0x13;

 int  19
;-314     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-315 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-316 }

;-317 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-318 	BIOS_ERR=0;	

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;72 var sign byte drive = bp+4
;73 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-319 	dl=drive;

 mov  dl, [bp+4]
;-320 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-321 	inth 0x13;

 int  19
;-322     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-323 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-324 }

;-325 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-326 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-327 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-328 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-329 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-330 }	

;-331 int Status(drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Status: PROC
;-332 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;72 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-333 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-334 	BIOS_Status=Int13hfunction(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-335 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status40
 call Int13hError
;-336 	printhex16(BIOS_Status);	

.Status40:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-337 }	

;-338 

;-339 int Params() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

Params: PROC
;-340 	cputs("Get Drive Params ");

 push Params_0
 call cputs
 add  sp, 2
;-341 	BIOS_Status=Int13hfunction(Drive, 8);

 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-342 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params41
;-343 		Int13hError();

 call Int13hError
;-344 		return 1;

 mov ax, 1
 jmp .retnParams
;-345 		}

;-346 	else {

 jmp .Params42
.Params41:
;-347 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-348 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-349 		// CX =       ---CH--- ---CL---

;-350 		// cylinder : 76543210 98

;-351 		// sector   :            543210	

;-352 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-353 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-354 //		pa_Sectors++;//1 to 64

;-355 	

;-356 		asm mov [pa_Cylinders],    cx	

 mov [pa_Cylinders],    cx	
;-357 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-358 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-359 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty	

 add [pa_Cylinders],    ch;//byte add, low byte is empty	
;-360 		

;-361 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params43
;-362 			cputs(" no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-363 			return 1;

 mov ax, 1
 jmp .retnParams
;-364 			}

;-365 	}

.Params43:
;-366 	return 0;

.Params42:
 mov ax, 0
 jmp .retnParams
;-367 }

;-368 

;-369 

;-370 int getPartitionData() {

 .retnParams:
 ret
Params_0 db "Get Drive Params ",0
Params_1 db " no hard disk found",0
ENDP

getPartitionData: PROC
;-371 	unsigned int j; char c; char *p;

;-372 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;72 var unsg word j = bp-2
;73 var sign byte c = bp-4
;74 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [pt_PartNo]
 shl ax, 4
 mov [bp-2], ax
;-373 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-374 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-375 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-376 	pt_StartCylinder=(int)pt_StartSector;		

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-377 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-378 //	pt_StartSector++;//Sector start with 1 todo

;-379 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-380 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-381 	j++;

 inc  word[bp-2]
;-382 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-383 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-384 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB	

;-385 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-386 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-387 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line		

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-388 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-389 //	pt_EndSector++;//Sector start with 1 todo

;-390 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-391 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!	

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-392 	j++;

 inc  word[bp-2]
;-393 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-394 	j++;

 inc  word[bp-2]
;-395 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-396 	memcpy(&pt_HiddenSector, p, 8);	

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-397 }

;-398 	

;-399 int checkBootSign() {

 LEAVE
 ret
ENDP

checkBootSign: PROC
;-400 	int i;

;-401 	i=510;	

;Function : checkBootSign, Number local Var: 1
; # type sign width local variables
;72 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-402 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign44
;-403 		i++;		

 inc  word[bp-2]
;-404 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign45
 mov ax, 1
 jmp .retncheckBootSign
;-405 	}	

.checkBootSign45:
;-406 	cputs(" Magic number NOT found.");

.checkBootSign44:
 push checkBootSign_0
 call cputs
 add  sp, 2
;-407 	return 0;	

 mov ax, 0
 jmp .retncheckBootSign
;-408 }	

;-409 	

;-410 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db " Magic number NOT found.",0
ENDP

readMBR: PROC
;-411 	int isFAT;

;-412 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;72 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-413 	pt_PartNo=0;

 mov ax, 0
 mov word [pt_PartNo], ax
;-414 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-415 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR46
;-416 		Int13hError();

 call Int13hError
;-417 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-418 		}

;-419 	else {	

 jmp .readMBR47
.readMBR46:
;-420 		putch(10);

 push 10
 call putch
 add  sp, 2
;-421 		cputs("Read partition.");

 push readMBR_0
 call cputs
 add  sp, 2
;-422 		if(checkBootSign()==0) return 0;	

 call checkBootSign
 cmp al, 0
 jne .readMBR48
 mov ax, 0
 jmp .retnreadMBR
;-423 		do {

.readMBR48:
.readMBR49:
;-424 			getPartitionData();

 call getPartitionData
;-425 			

;-426 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR50
;-427 				cputs("Boot partition found");

 push readMBR_1
 call cputs
 add  sp, 2
;-428 				if (pt_FileSystem == 1) {

 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR51
;-429 					cputs(", FAT12 partition < 32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-430 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-431 					}

;-432 				if (pt_FileSystem == 4) {

.readMBR51:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR52
;-433 					cputs(", small FAT16 partition < 32MB");

 push readMBR_3
 call cputs
 add  sp, 2
;-434 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-435 					}

;-436 				if (pt_FileSystem == 6) {

.readMBR52:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR53
;-437 					cputs(", large FAT16 partition < 2GB");

 push readMBR_4
 call cputs
 add  sp, 2
;-438 					isFAT=6;

 mov ax, 6
 mov [bp-2], ax
;-439 					}

;-440 				pt_PartNo=99;//end of loop	

.readMBR53:
 mov ax, 99
 mov word [pt_PartNo], ax
;-441 			}

;-442 			pt_PartNo ++;

.readMBR50:
 inc  word[pt_PartNo]
;-443 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR54
 jmp .readMBR49
.readMBR54:
;-444 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-445 	}	

;-446 }

.readMBR47:
;-447 

;-448 int getBootSector() {

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
;-449 	int i;

;-450 	putch(10);

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;72 var sign word i = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-451 	cputs(" Read boot sector");

 push getBootSector_0
 call cputs
 add  sp, 2
;-452   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

;-453   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-454 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector55
;-455 		Int13hError();

 call Int13hError
;-456 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-457 		}

;-458 	else {	

 jmp .getBootSector56
.getBootSector55:
;-459 //		printhex16(BIOS_Status);	

;-460 		if(checkBootSign()==0) return 0;		

 call checkBootSign
 cmp al, 0
 jne .getBootSector57
 mov ax, 0
 jmp .retngetBootSector
;-461 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector57:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-462 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector58
 push getBootSector_1
 call cputs
 add  sp, 2
;-463 		i=2;

.getBootSector58:
 mov ax, 2
 mov [bp-2], ax
;-464 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector59
 push getBootSector_2
 call cputs
 add  sp, 2
;-465 	}

.getBootSector59:
;-466 	return 1;

.getBootSector56:
 mov ax, 1
 jmp .retngetBootSector
;-467 }

;-468 

;-469 int FATInit() {	

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Read boot sector",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-470 	unsigned long templong;//converting word to dword

;-471 // (e)dx:(e)ax DIV r/m16(32) = (e)ax, remainder (e)dx

;-472 	fat_currentdrive = bs_drive_num;

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;72 var unsg long templong = bp-4;
 ENTER  4,0
 mov al, [bs_drive_num]
 mov byte [fat_currentdrive], al
;-473 	fat_currentpath = 0;

 mov ax, 0
 mov byte [fat_currentpath], al
;-474 	

;-475 	fat_FatStartSector = bs_res_sects;	

 mov ax, [bs_res_sects]
 mov word [fat_FatStartSector], ax
;-476 	fat_FatSectors = bs_fat_size;	

 mov ax, [bs_fat_size]
 mov word [fat_FatSectors], ax
;-477 	if (bs_num_fats == 2) fat_FatSectors=fat_FatSectors+fat_FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .FATInit60
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-478 

;-479 	fat_RootDirStartSector = fat_FatStartSector + fat_FatSectors;

.FATInit60:
 mov ax, [fat_FatStartSector]
 add ax, [fat_FatSectors]
 mov word [fat_RootDirStartSector], ax
;-480 	fat_RootDirSectors = bs_root_entr << 5;// *32	

 mov ax, [bs_root_entr]
 shl ax, 5
 mov word [fat_RootDirSectors], ax
;-481 	fat_RootDirSectors = fat_RootDirSectors / bs_sect_size;

 mov ax, [fat_RootDirSectors]
 xor dx, dx
 div word [bs_sect_size]
 mov word [fat_RootDirSectors], ax
;-482 

;-483 	fat_DataStartSector = fat_RootDirStartSector + fat_RootDirSectors;

 mov ax, [fat_RootDirStartSector]
 add ax, [fat_RootDirSectors]
 mov word [fat_DataStartSector], ax
;-484 	templong=(long) fat_DataStartSector;		

 xor eax, eax
 mov ax, [fat_DataStartSector]
 mov [bp-4], eax
;-485 	

;-486 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;		

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .FATInit61
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-487 	DataSectors32=bs_tot_sect32 - templong;		

.FATInit61:
 mov eax, [bs_tot_sect32]
 sub eax, [bp-4]
 mov dword [DataSectors32], eax
;-488 

;-489 	templong = (long) bs_clust_size;		

 xor eax, eax
 mov al, [bs_clust_size]
 mov [bp-4], eax
;-490 	CountofClusters=DataSectors32 / templong;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [bp-4]
 mov dword [CountofClusters], eax
;-491 	

;-492 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-493 	fat_num_tracks = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [fat_num_tracks], eax
;-494 	

;-495 	templong = (long) bs_num_heads;	

 xor eax, eax
 mov ax, [bs_num_heads]
 mov [bp-4], eax
;-496 	fat_num_cylinders = fat_num_tracks / templong;//w=d/w

 mov eax, [fat_num_tracks]
 xor edx, edx
 div dword [bp-4]
 mov word [fat_num_cylinders], ax
;-497 			

;-498 	Sectors_per_cylinder = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinder], eax
;-499 	asm mov [Sectors_per_cylinder + 2], dx;store high word

 mov [Sectors_per_cylinder + 2], dx;store high word
;-500 

;-501 	cputs(", trueFATtype=FAT"); 

 push FATInit_0
 call cputs
 add  sp, 2
;-502 	

;-503 	templong = (long) 65525;			

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-504 	if (CountofClusters > templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jle .FATInit62
;-505 		trueFATtype=32; 

 mov ax, 32
 mov byte [trueFATtype], al
;-506 		cputs("32 NOT supported"); 

 push FATInit_1
 call cputs
 add  sp, 2
;-507 		return 1;

 mov ax, 1
 jmp .retnFATInit
;-508 		}

;-509 	templong= (long) 4086;

.FATInit62:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-510 	if (CountofClusters < templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jge .FATInit63
;-511 		trueFATtype=12; 

 mov ax, 12
 mov byte [trueFATtype], al
;-512 		cputs("12"); 

 push FATInit_2
 call cputs
 add  sp, 2
;-513 		return 0;

 mov ax, 0
 jmp .retnFATInit
;-514 		}

;-515 	trueFATtype=16;

.FATInit63:
 mov ax, 16
 mov byte [trueFATtype], al
;-516 	cputs("16");

 push FATInit_3
 call cputs
 add  sp, 2
;-517 	return 0;

 mov ax, 0
 jmp .retnFATInit
;-518 }

;-519 

;-520 int Int13hExt() {

 .retnFATInit:
 LEAVE
 ret
FATInit_0 db ", trueFATtype=FAT",0
FATInit_1 db "32 NOT supported",0
FATInit_2 db "12",0
FATInit_3 db "16",0
ENDP

Int13hExt: PROC
;-521 	bx=0x55AA;

 mov  bx, 21930
;-522 	BIOS_Status=Int13hfunction(Drive, 0x41);	

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-523 	asm mov [vAX], ax;

 mov [vAX], ax;
;-524 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-525 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported 			
;-526 //	putch(10);

;-527 //	cputs("Int13h 41h Ext=");	printhex16(vAX);

;-528 //	cputs(", BIOS_Status=");	printhex16(BIOS_Status);

;-529 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt64
;-530 		cputs(" Ext NOT present");	

 push Int13hExt_0
 call cputs
 add  sp, 2
;-531 		Int13hError();	

 call Int13hError
;-532 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-533 		}

;-534 	else {

 jmp .Int13hExt65
.Int13hExt64:
;-535 		cputs(",Extension found BX(AA55)=");printhex16(vBX);

 push Int13hExt_1
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-536 //		cputs(" CX=");						printhex16(vCX);

;-537 		}

;-538 	return 0;			

.Int13hExt65:
 mov ax, 0
 jmp .retnInt13hExt
;-539 }	

;-540 

;-541 int readLogical() {//IN:Sectors_to_read

 .retnInt13hExt:
 ret
Int13hExt_0 db " Ext NOT present",0
Int13hExt_1 db ",Extension found BX(AA55)=",0
ENDP

readLogical: PROC
;-542 	unsigned int track; unsigned int head; unsigned int sect;

;-543 	Sectors_to_read = Sectors_to_read + bs_hid_sects;//d=d+d

;Function : readLogical, Number local Var: 3
; # type sign width local variables
;72 var unsg word track = bp-2
;73 var unsg word head = bp-4
;74 var unsg word sect = bp-6;
 ENTER  6,0
 mov eax, [Sectors_to_read]
 add eax, [bs_hid_sects]
 mov dword [Sectors_to_read], eax
;-544 	track = Sectors_to_read / Sectors_per_cylinder;  //w=d/d

 mov eax, [Sectors_to_read]
 xor edx, edx
 div dword [Sectors_per_cylinder]
 mov [bp-2], ax
;-545 	head  = Sectors_to_read % Sectors_per_cylinder;  //w=d%d

 mov eax, [Sectors_to_read]
 xor edx, edx
 div dword [Sectors_per_cylinder]
 mov eax, edx
 mov [bp-4], ax
;-546 	sect  = head            % bs_sectors_per_track;  //w=w%w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov ax, dx
 mov [bp-6], ax
;-547 	sect++;

 inc  word[bp-6]
;-548 	head  = head            / bs_sectors_per_track;	 //w=w/w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov [bp-4], ax
;-549 

;-550 	DiskSectorReadWrite(2, bs_drive_num, head, track/* =cyl */,

;-551 		sect, 1, DiskBufSeg , DiskBuf);

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
;-552 }

;-553 

;-554 int PrintDriveParameter() {

 LEAVE
 ret
ENDP

PrintDriveParameter: PROC
;-555 	unsigned long Lo;

;-556 // from Params

;-557 	putch(10);

;Function : PrintDriveParameter, Number local Var: 1
; # type sign width local variables
;72 var unsg long Lo = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-558 	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);

 push PrintDriveParameter_0
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-559 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-560 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-561 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-562 	putch('.');

 push 46
 call putch
 add  sp, 2
;-563 //from getPartitionData

;-564 	putch(10);		

 push 10
 call putch
 add  sp, 2
;-565 	cputs("getPartitionData:No=");printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-566 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-567 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-568 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-569 	cputs("/");				printunsign(pt_StartSector);	

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-570 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-571 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-572 	cputs("/");				printunsign(pt_EndSector);	

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-573 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-574 	cputs(",Start=");		printlong(&pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 lea  ax, [pt_HiddenSector]
 push ax
 call printlong
 add  sp, 2
;-575 	cputs(",Len=");			printlong(&pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 lea  ax, [pt_PartLen]
 push ax
 call printlong
 add  sp, 2
;-576 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-577 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-578 	printlong(&Lo);

 lea  ax, [bp-4]
 push ax
 call printlong
 add  sp, 2
;-579 	cputs(" MByte.");	

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-580 //from getBootSector

;-581 	putch(10);

 push 10
 call putch
 add  sp, 2
;-582 	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-583 	putch(10);

 push 10
 call putch
 add  sp, 2
;-584 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);	

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-585 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);	

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-586 	putch(10);

 push 10
 call putch
 add  sp, 2
;-587 	cputs("Reserved sectors=");printunsign(bs_res_sects);	

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-588 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);	

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-589 	putch(10);

 push 10
 call putch
 add  sp, 2
;-590 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-591 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-592 	putch(10);

 push 10
 call putch
 add  sp, 2
;-593 	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-594 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-595 	putch(10);

 push 10
 call putch
 add  sp, 2
;-596 	cputs("sectors per track=");printunsign(bs_sectors_per_track);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_sectors_per_track]
 call printunsign
 add  sp, 2
;-597 	cputs(".number of heads=");printunsign(bs_num_heads);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_heads]
 call printunsign
 add  sp, 2
;-598 	putch(10);

 push 10
 call putch
 add  sp, 2
;-599 	cputs("hidden sectors(long)=");printlong(&bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 lea  ax, [bs_hid_sects]
 push ax
 call printlong
 add  sp, 2
;-600 	cputs(".sectors(long)=");printlong(&bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 lea  ax, [bs_tot_sect32]
 push ax
 call printlong
 add  sp, 2
;-601 	putch(10);

 push 10
 call putch
 add  sp, 2
;-602 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-603 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-604 	putch(10);

 push 10
 call putch
 add  sp, 2
;-605 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-606 	cputs(".Volume serial(long)=");printlong(&bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 lea  ax, [bs_serial_num]
 push ax
 call printlong
 add  sp, 2
;-607 	putch(10);

 push 10
 call putch
 add  sp, 2
;-608 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-609 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);		

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-610 //from FATInit

;-611 	putch(10);

 push 10
 call putch
 add  sp, 2
;-612 	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [fat_FatStartSector]
 call printunsign
 add  sp, 2
;-613 	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [fat_FatSectors]
 call printunsign
 add  sp, 2
;-614 	putch(10);

 push 10
 call putch
 add  sp, 2
;-615 	cputs("fat_RootDirStartSector="); printunsign(fat_RootDirStartSector);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push word [fat_RootDirStartSector]
 call printunsign
 add  sp, 2
;-616 	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectors);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push word [fat_RootDirSectors]
 call printunsign
 add  sp, 2
;-617 	putch(10);

 push 10
 call putch
 add  sp, 2
;-618 	cputs("fat_DataStartSector=");	printunsign(fat_DataStartSector);

 push PrintDriveParameter_38
 call cputs
 add  sp, 2
 push word [fat_DataStartSector]
 call printunsign
 add  sp, 2
;-619 	cputs(", DataSectors32=");	printlong(&DataSectors32);			

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 lea  ax, [DataSectors32]
 push ax
 call printlong
 add  sp, 2
;-620 	putch(10);

 push 10
 call putch
 add  sp, 2
;-621 	cputs("CountofClusters=");	printlong(&CountofClusters);

 push PrintDriveParameter_40
 call cputs
 add  sp, 2
 lea  ax, [CountofClusters]
 push ax
 call printlong
 add  sp, 2
;-622 	cputs(", Sectors_per_cylinder="); printlong(&Sectors_per_cylinder);	

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 lea  ax, [Sectors_per_cylinder]
 push ax
 call printlong
 add  sp, 2
;-623 	putch(10);

 push 10
 call putch
 add  sp, 2
;-624 	cputs("fat_num_tracks=");	printlong(&fat_num_tracks);

 push PrintDriveParameter_42
 call cputs
 add  sp, 2
 lea  ax, [fat_num_tracks]
 push ax
 call printlong
 add  sp, 2
;-625 	cputs(", fat_num_cylinders="); printunsign(fat_num_cylinders);	

 push PrintDriveParameter_43
 call cputs
 add  sp, 2
 push word [fat_num_cylinders]
 call printunsign
 add  sp, 2
;-626 	putch(10);

 push 10
 call putch
 add  sp, 2
;-627 	cputs("Sectors_per_cylinder=");	printlong(&Sectors_per_cylinder);

 push PrintDriveParameter_44
 call cputs
 add  sp, 2
 lea  ax, [Sectors_per_cylinder]
 push ax
 call printlong
 add  sp, 2
;-628 }	

;-629 

;-630 //--------------------------------  file IO  -------------------

;-631 int error2(char *s) {

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
;-632 	putch(10);

;Function : error2, Number local Var: 1
; # type sign width local variables
;72 ptr sign byte s = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-633 	cputs("*** ERROR *** ");

 push error2_0
 call cputs
 add  sp, 2
;-634 	cputs(s);		

 push word [bp+4]
 call cputs
 add  sp, 2
;-635 	DOS_ERR++;

 inc  byte[DOS_ERR]
;-636 }

;-637 

;-638 int fatOpenFile() {

 LEAVE
 ret
error2_0 db "*** ERROR *** ",0
ENDP

fatOpenFile: PROC
;-639 	

;-640 }	

;-641 

;-642 int make_filename() {

 ret
ENDP

make_filename: PROC
;-643 	char *p;

;-644 	toupper(&full_filename);

;Function : make_filename, Number local Var: 1
; # type sign width local variables
;72 ptr sign byte p = bp-2;
 ENTER  2,0
 lea  ax, [full_filename]
 push ax
 call toupper
 add  sp, 2
;-645 	p = strchr(full_filename);

 lea  ax, [full_filename]
 push ax
 call strchr
 add  sp, 2
 mov [bp-2], ax
;-646 	if (p == 0) fat_drive = fat_currentdrive;

 mov ax, [bp-2]
 cmp ax, 0
 jne .make_filename66
 mov al, [fat_currentdrive]
 mov byte [fat_drive], al
;-647 	else error2("drive, patth not impl. yet"); 

 jmp .make_filename67
.make_filename66:
 push make_filename_0
 call error2
 add  sp, 2
;-648 		

;-649 }

.make_filename67:
;-650 

;-651 int fileOpen() {

 LEAVE
 ret
make_filename_0 db "drive, patth not impl. yet",0
ENDP

fileOpen: PROC
;-652 	make_filename();

 call make_filename
;-653 	fatOpenFile();

 call fatOpenFile
;-654 	

;-655 }	

;-656 

;-657 //------------------------------------ main ---------------

;-658 int Init() {

 ret
ENDP

Init: PROC
;-659 	int FATtype; 

;-660 	Drive=0x80;

;Function : Init, Number local Var: 1
; # type sign width local variables
;72 var sign word FATtype = bp-2;
 ENTER  2,0
 mov ax, 128
 mov byte [Drive], al
;-661 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-662 

;-663 	if (Params()) cputs("** NO DRIVE PARAMS FOUND **");//no hard disk

 call Params
 or  al, al
 je .Init68
 push Init_0
 call cputs
 add  sp, 2
;-664 	FATtype=readMBR();//0=error,1=FAT12,6=FAT16,11=FAT32

.Init68:
 call readMBR
 mov [bp-2], ax
;-665 	if (FATtype == 0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .Init69
;-666 		cputs(" no active FAT partition found. ");

 push Init_1
 call cputs
 add  sp, 2
;-667 //		return 1;	

;-668 		}

;-669 	if(getBootSector()==0) 	return 1;

.Init69:
 call getBootSector
 cmp ax, 0
 jne .Init70
 mov ax, 1
 jmp .retnInit
;-670 	if (FATInit())			return 1;

.Init70:
 call FATInit
 or  al, al
 je .Init71
 mov ax, 1
 jmp .retnInit
;-671 	if(trueFATtype != 16) 	return 1;

.Init71:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init72
 mov ax, 1
 jmp .retnInit
;-672 	Int13hExt();

.Init72:
 call Int13hExt
;-673 	return 0;

 mov ax, 0
 jmp .retnInit
;-674 }	

;-675 

;-676 int main() {

 .retnInit:
 LEAVE
 ret
Init_0 db "** NO DRIVE PARAMS FOUND **",0
Init_1 db " no active FAT partition found. ",0
ENDP

main: PROC
;-677 	Init();

 call Init
;-678 	PrintDriveParameter(); 

 call PrintDriveParameter
;-679 /*	

;-680 	Sectors_to_read = (long) 0;

;-681 	readLogical();

;-682 	getkey();

;-683 	mdump(DiskBuf, 512);

;-684 */	

;-685 }

 ret
ENDP
;Glob. variables:71 (400):848 (4000), Functions:42 (300):395 (3000)
;Lines:686, Constant: 2171 (4000), stacksize: 56643