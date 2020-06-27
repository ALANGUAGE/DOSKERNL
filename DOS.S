;PLA compiler A.COM V1.1.2, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.1.7";//test bed

Version1 db "DOS.COM V0.1.7",0
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

;-27 //FATInit     

;-28 unsigned int fat_FatStartSector;

fat_FatStartSector dw 0
;-29 unsigned int fat_FatSectors;

fat_FatSectors dw 0
;-30 unsigned int fat_RootDirStartSector;

fat_RootDirStartSector dw 0
;-31 unsigned int fat_RootDirSectors;

fat_RootDirSectors dw 0
;-32 unsigned int fat_DataStartSector;

fat_DataStartSector dw 0
;-33 unsigned long fat_num_tracks;

fat_num_tracks dd 0
;-34 unsigned int  fat_num_cylinders;

fat_num_cylinders dw 0
;-35 unsigned long Sectors_per_cylinder;

Sectors_per_cylinder dd 0
;-36 unsigned long DataSectors32;

DataSectors32 dd 0
;-37 unsigned long CountofClusters;

CountofClusters dd 0
;-38 char          trueFATtype;

trueFATtype db 0
;-39 

;-40 unsigned int  pt_PartNo;

pt_PartNo dw 0
;-41 //start hard disk partition structure 16 bytes in MBR. do not change

;-42 unsigned char pt_Bootable;		//80h = active partition, else 00

pt_Bootable db 0
;-43 unsigned char pt_StartHead;

pt_StartHead db 0
;-44 unsigned char pt_StartSector;	//bits 0-5

pt_StartSector db 0
;-45 unsigned int  pt_StartCylinder;	//bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-46 unsigned char pt_FileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=largeFAT16

pt_FileSystem db 0
;-47 unsigned char pt_EndHead;

pt_EndHead db 0
;-48 unsigned char pt_EndSector;		//bits 0-5

pt_EndSector db 0
;-49 unsigned int  pt_EndCylinder;	//bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-50 unsigned long pt_HiddenSector;	//sectors preceding partition

pt_HiddenSector dd 0
;-51 unsigned long pt_PartLen;    	//length of partition in sectors

pt_PartLen dd 0
;-52 //end hard disk partition structure

;-53 

;-54 //start boot BIOS Parameter Block structure. do not change

;-55 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-56 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-57 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-58 unsigned char bs_clust_size;// 13 sectors per cluster (1,2,4,..,128)

bs_clust_size db 0
;-59 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-60 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-61 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-62 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-63 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-64 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-65 unsigned int  bs_sectors_per_track; // 24 (DOS 3+)sectors per track 

bs_sectors_per_track dw 0
;-66 unsigned int  bs_num_heads;	// 26 (DOS 3+)number of heads   

bs_num_heads dw 0
;-67 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors 

bs_hid_sects dd 0
;-68 unsigned long bs_tot_sect32;// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-69 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-70 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-71 unsigned char bs_ext_signat;// 38 (DOS 4+) Extended signature,get next 3(29h)

bs_ext_signat db 0
;-72 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-73 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-74 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-75 // 62 end boot BIOS Parameter Block

;-76 

;-77 int test() {


test: PROC
;-78 

;-79 __asm{	

	
;-80 


;-81 }	}


;-82 

;-83 int writetty()     {//char in AL

 ret
ENDP

writetty: PROC
;-84     ah=0x0E;

 mov  ah, 14
;-85     push bx;

push bx;
;-86     bx=0;			//page in BH

 mov  bx, 0
;-87     inth 0x10;		//16

 int  16
;-88     pop bx;

pop bx;
;-89 }

;-90 int putch(char c)  {

 ret
ENDP

putch: PROC
;-91     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;65 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-92         al=13;

 mov  al, 13
;-93         writetty();

 call writetty
;-94     }

;-95     al=c;

.putch1:
 mov  al, [bp+4]
;-96     writetty();

 call writetty
;-97 }

;-98 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-99     char c;

;-100     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;65 ptr sign byte s = bp+4
;66 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-101         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-102         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-103         s++;

 inc  word[bp+4]
;-104     }

;-105 }

 jmp .cputs2
.cputs3:
;-106 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-107 	char c;

;-108 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;65 ptr sign byte s = bp+4
;66 var sign word len = bp+6
;67 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-109 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-110 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-111 		s++;

 inc  word[bp+4]
;-112 		len--;

 dec  word[bp+6]
;-113 	} while (len > 0);	

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-114 }

;-115 

;-116 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-117     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-118     inth 0x16;//AH=Scan code, AL=char

 int  22
;-119 }

;-120 int waitkey() {

 ret
ENDP

waitkey: PROC
;-121     ah=0x11;//get kbd status

 mov  ah, 17
;-122     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-123     //zero flag: 0=IS char, 1=NO char

;-124     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-125 }

;-126 int getkey() {

 ret
ENDP

getkey: PROC
;-127     waitkey();

 call waitkey
;-128     getch();

 call getch
;-129     ah=0;//clear scan code

 mov  ah, 0
;-130     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-131     //put ext code in AX

;-132 }

.getkey6:
;-133 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-134     getkey();

 call getkey
;-135     writetty();//destroys AH

 call writetty
;-136 }

;-137 

;-138 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-139     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;65 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-140     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-141     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-142 }

;-143 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-144     unsigned char nib;

;-145     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;65 var unsg byte c = bp+4
;66 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-146     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-147 }

;-148 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-149     unsigned int half;

;-150     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;65 var unsg word i = bp+4
;66 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-151     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-152 }

;-153 

;-154 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-155     unsigned int e;

;-156     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;65 var unsg word n = bp+4
;66 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-157         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-158         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-159         }

;-160     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-161     n+='0';

 add  word[bp+4], 48
;-162     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-163 }

;-164 

;-165 int printlong(unsigned int *p) {

 LEAVE
 ret
ENDP

printlong: PROC
;-166 	unsigned int lo; unsigned int hi;

;-167 	lo = *p;

;Function : printlong, Number local Var: 3
; # type sign width local variables
;65 ptr unsg word p = bp+4
;66 var unsg word lo = bp-2
;67 var unsg word hi = bp-4;
 ENTER  4,0
 mov bx, [bp+4]
 mov ax, [bx]
 mov [bp-2], ax
;-168 	p +=2;

 add  word[bp+4], 2
;-169 	hi = *p;

 mov bx, [bp+4]
 mov ax, [bx]
 mov [bp-4], ax
;-170 	dx=hi;

 mov  dx, [bp-4]
;-171 	ax=lo;

 mov  ax, [bp-2]
;-172 __asm{	

	
;-173   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-174     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-175 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-176     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-177     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-178 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-179     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-180     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-181     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-182     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-183     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-184     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-185     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-186     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-187 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-188 }	writetty();		__asm{


 call writetty

;-189     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-190     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-191     jb      .b             ;Not yet	

    jb      .b             ;Not yet	
;-192 } 


;-193 }

;-194 

;-195 int memcpy(char *s, char *t, unsigned int i) {

 LEAVE
 ret
ENDP

memcpy: PROC
;-196 	unsigned int r;

;-197 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;65 ptr sign byte s = bp+4
;66 ptr sign byte t = bp+6
;67 var unsg word i = bp+8
;68 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-198 	do {

.memcpy9:
;-199 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-200 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-201 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy10
 jmp .memcpy9
.memcpy10:
;-202 	ax=r;//	return r;

 mov  ax, [bp-2]
;-203 }

;-204 	

;-205 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-206     unsigned char c; int i; int j; int k;

;-207     j=0;

;Function : mdump, Number local Var: 6
; # type sign width local variables
;65 ptr unsg byte adr = bp+4
;66 var unsg word len = bp+6
;67 var unsg byte c = bp-2
;68 var sign word i = bp-4
;69 var sign word j = bp-6
;70 var sign word k = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-6], ax
;-208     k=0;

 mov ax, 0
 mov [bp-8], ax
;-209     while (j < len ) {

.mdump11:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump12
;-210 	    k++;; 

 inc  word[bp-8]
;-211 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump13
;-212 		    getkey();

 call getkey
;-213 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-214 		    }

;-215         putch(10);

.mdump13:
 push 10
 call putch
 add  sp, 2
;-216         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-217         putch(':');

 push 58
 call putch
 add  sp, 2
;-218         i=0;

 mov ax, 0
 mov [bp-4], ax
;-219         while (i < 16) {

.mdump14:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump15
;-220             putch(' ');

 push 32
 call putch
 add  sp, 2
;-221             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-222             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-223             adr++;

 inc  word[bp+4]
;-224             i++;

 inc  word[bp-4]
;-225             j++;

 inc  word[bp-6]
;-226             }

;-227         putch(' ');

 jmp .mdump14
.mdump15:
 push 32
 call putch
 add  sp, 2
;-228         adr -=16;

 sub  word[bp+4], 16
;-229         i=0;

 mov ax, 0
 mov [bp-4], ax
;-230         while(i < 16) {

.mdump16:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump17
;-231             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-232             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump18
 push 46
 call putch
 add  sp, 2
;-233                 else putch(c);

 jmp .mdump19
.mdump18:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-234             adr++;

.mdump19:
 inc  word[bp+4]
;-235             i++;

 inc  word[bp-4]
;-236         }

;-237     }

 jmp .mdump16
.mdump17:
;-238 }

 jmp .mdump11
.mdump12:
;-239 

;-240 //--------------------------------  disk IO  -------------------

;-241 

;-242 int DiskSectorReadWrite(char rw, char drive, char head, int cyl, 

 LEAVE
 ret
ENDP

DiskSectorReadWrite: PROC
;-243 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-244 	BIOS_ERR=0;	

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;65 var sign byte rw = bp+4
;66 var sign byte drive = bp+6
;67 var sign byte head = bp+8
;68 var sign word cyl = bp+10
;69 var sign byte sector = bp+12
;70 var sign byte count = bp+14
;71 var sign word BufSeg = bp+16
;72 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-245 	dl=drive;

 mov  dl, [bp+6]
;-246 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-247 	es=BufSeg;

 mov  es, [bp+16]
;-248 	bx=BufOfs;

 mov  bx, [bp+18]
;-249 	cx=cyl;	

 mov  cx, [bp+10]
;-250 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-251 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-252 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-253 	cl += sector;

 add  cl, [bp+12]
;-254 	ch=cyl;//low byte of cyl in ch, word 2 byte	

 mov  ch, [bp+10]
;-255 	al=count;

 mov  al, [bp+14]
;-256 	ah=rw;

 mov  ah, [bp+4]
;-257 	inth 0x13;

 int  19
;-258     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-259 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-260 }

;-261 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-262 	BIOS_ERR=0;	

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;65 var sign byte drive = bp+4
;66 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-263 	dl=drive;

 mov  dl, [bp+4]
;-264 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-265 	inth 0x13;

 int  19
;-266     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-267 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-268 }

;-269 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-270 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-271 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-272 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-273 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-274 }	

;-275 int Status(drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Status: PROC
;-276 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;65 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-277 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-278 	BIOS_Status=Int13hfunction(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-279 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status20
 call Int13hError
;-280 	printhex16(BIOS_Status);	

.Status20:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-281 }	

;-282 

;-283 int Params() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

Params: PROC
;-284 	cputs("Get Drive Params ");

 push Params_0
 call cputs
 add  sp, 2
;-285 	BIOS_Status=Int13hfunction(Drive, 8);

 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-286 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params21
;-287 		Int13hError();

 call Int13hError
;-288 		return 1;

 mov ax, 1
 jmp .retnParams
;-289 		}

;-290 	else {

 jmp .Params22
.Params21:
;-291 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-292 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-293 		// CX =       ---CH--- ---CL---

;-294 		// cylinder : 76543210 98

;-295 		// sector   :            543210	

;-296 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-297 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-298 //		pa_Sectors++;//1 to 64

;-299 	

;-300 		asm mov [pa_Cylinders],    cx	

 mov [pa_Cylinders],    cx	
;-301 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-302 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-303 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty	

 add [pa_Cylinders],    ch;//byte add, low byte is empty	
;-304 		

;-305 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params23
;-306 			cputs(" no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-307 			return 1;

 mov ax, 1
 jmp .retnParams
;-308 			}

;-309 	}

.Params23:
;-310 	return 0;

.Params22:
 mov ax, 0
 jmp .retnParams
;-311 }

;-312 

;-313 

;-314 int getPartitionData() {

 .retnParams:
 ret
Params_0 db "Get Drive Params ",0
Params_1 db " no hard disk found",0
ENDP

getPartitionData: PROC
;-315 	unsigned int j; char c; char *p;

;-316 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;65 var unsg word j = bp-2
;66 var sign byte c = bp-4
;67 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [pt_PartNo]
 shl ax, 4
 mov [bp-2], ax
;-317 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-318 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-319 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-320 	pt_StartCylinder=(int)pt_StartSector;		

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-321 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-322 //	pt_StartSector++;//Sector start with 1 todo

;-323 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-324 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-325 	j++;

 inc  word[bp-2]
;-326 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-327 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-328 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB	

;-329 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-330 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-331 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line		

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-332 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-333 //	pt_EndSector++;//Sector start with 1 todo

;-334 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-335 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!	

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-336 	j++;

 inc  word[bp-2]
;-337 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-338 	j++;

 inc  word[bp-2]
;-339 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-340 	memcpy(&pt_HiddenSector, p, 8);	

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-341 }

;-342 	

;-343 int checkBootSign() {

 LEAVE
 ret
ENDP

checkBootSign: PROC
;-344 	int i;

;-345 	i=510;	

;Function : checkBootSign, Number local Var: 1
; # type sign width local variables
;65 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-346 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign24
;-347 		i++;		

 inc  word[bp-2]
;-348 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign25
 mov ax, 1
 jmp .retncheckBootSign
;-349 	}	

.checkBootSign25:
;-350 	cputs(" Magic number NOT found.");

.checkBootSign24:
 push checkBootSign_0
 call cputs
 add  sp, 2
;-351 	return 0;	

 mov ax, 0
 jmp .retncheckBootSign
;-352 }	

;-353 	

;-354 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db " Magic number NOT found.",0
ENDP

readMBR: PROC
;-355 	int isFAT;

;-356 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;65 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-357 	pt_PartNo=0;

 mov ax, 0
 mov word [pt_PartNo], ax
;-358 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-359 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR26
;-360 		Int13hError();

 call Int13hError
;-361 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-362 		}

;-363 	else {	

 jmp .readMBR27
.readMBR26:
;-364 		putch(10);

 push 10
 call putch
 add  sp, 2
;-365 		cputs("Read partition.");

 push readMBR_0
 call cputs
 add  sp, 2
;-366 		if(checkBootSign()==0) return 0;	

 call checkBootSign
 cmp al, 0
 jne .readMBR28
 mov ax, 0
 jmp .retnreadMBR
;-367 		do {

.readMBR28:
.readMBR29:
;-368 			getPartitionData();

 call getPartitionData
;-369 			

;-370 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR30
;-371 				cputs("Boot partition found");

 push readMBR_1
 call cputs
 add  sp, 2
;-372 				if (pt_FileSystem == 1) {

 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR31
;-373 					cputs(", FAT12 partition < 32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-374 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-375 					}

;-376 				if (pt_FileSystem == 4) {

.readMBR31:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR32
;-377 					cputs(", small FAT16 partition < 32MB");

 push readMBR_3
 call cputs
 add  sp, 2
;-378 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-379 					}

;-380 				if (pt_FileSystem == 6) {

.readMBR32:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR33
;-381 					cputs(", large FAT16 partition < 2GB");

 push readMBR_4
 call cputs
 add  sp, 2
;-382 					isFAT=6;

 mov ax, 6
 mov [bp-2], ax
;-383 					}

;-384 				pt_PartNo=99;//end of loop	

.readMBR33:
 mov ax, 99
 mov word [pt_PartNo], ax
;-385 			}

;-386 			pt_PartNo ++;

.readMBR30:
 inc  word[pt_PartNo]
;-387 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR34
 jmp .readMBR29
.readMBR34:
;-388 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-389 	}	

;-390 }

.readMBR27:
;-391 

;-392 int getBootSector() {int i;

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
;-393 		putch(10);

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;65 var sign word i = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-394 		cputs(" Read boot sector");

 push getBootSector_0
 call cputs
 add  sp, 2
;-395   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

;-396   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-397 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector35
;-398 		Int13hError();

 call Int13hError
;-399 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-400 		}

;-401 	else {	

 jmp .getBootSector36
.getBootSector35:
;-402 //		printhex16(BIOS_Status);	

;-403 		if(checkBootSign()==0) return 0;		

 call checkBootSign
 cmp al, 0
 jne .getBootSector37
 mov ax, 0
 jmp .retngetBootSector
;-404 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector37:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-405 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector38
 push getBootSector_1
 call cputs
 add  sp, 2
;-406 		i=2;

.getBootSector38:
 mov ax, 2
 mov [bp-2], ax
;-407 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector39
 push getBootSector_2
 call cputs
 add  sp, 2
;-408 	}

.getBootSector39:
;-409 	return 1;

.getBootSector36:
 mov ax, 1
 jmp .retngetBootSector
;-410 }

;-411 

;-412 int FATInit() {	

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Read boot sector",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

FATInit: PROC
;-413 	unsigned long templong;//converting word to dword

;-414 

;-415 	fat_FatStartSector = bs_res_sects;	

;Function : FATInit, Number local Var: 1
; # type sign width local variables
;65 var unsg long templong = bp-4;
 ENTER  4,0
 mov ax, [bs_res_sects]
 mov word [fat_FatStartSector], ax
;-416 	fat_FatSectors = bs_fat_size;	

 mov ax, [bs_fat_size]
 mov word [fat_FatSectors], ax
;-417 	if (bs_num_fats == 2) fat_FatSectors=fat_FatSectors+fat_FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .FATInit40
 mov ax, [fat_FatSectors]
 add ax, [fat_FatSectors]
 mov word [fat_FatSectors], ax
;-418 

;-419 	fat_RootDirStartSector = fat_FatStartSector + fat_FatSectors;

.FATInit40:
 mov ax, [fat_FatStartSector]
 add ax, [fat_FatSectors]
 mov word [fat_RootDirStartSector], ax
;-420 	fat_RootDirSectors = bs_root_entr << 5;// *32	

 mov ax, [bs_root_entr]
 shl ax, 5
 mov word [fat_RootDirSectors], ax
;-421 	fat_RootDirSectors = fat_RootDirSectors / bs_sect_size;

 mov ax, [fat_RootDirSectors]
 xor dx, dx
 div word [bs_sect_size]
 mov word [fat_RootDirSectors], ax
;-422 

;-423 	fat_DataStartSector = fat_RootDirStartSector + fat_RootDirSectors;

 mov ax, [fat_RootDirStartSector]
 add ax, [fat_RootDirSectors]
 mov word [fat_DataStartSector], ax
;-424 	templong=(long) fat_DataStartSector;		

 xor eax, eax
 mov ax, [fat_DataStartSector]
 mov [bp-4], eax
;-425 	

;-426 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;		

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .FATInit41
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-427 	DataSectors32=bs_tot_sect32 - templong;		

.FATInit41:
 mov eax, [bs_tot_sect32]
 sub eax, [bp-4]
 mov dword [DataSectors32], eax
;-428 

;-429 	templong = (long) bs_clust_size;		

 xor eax, eax
 mov al, [bs_clust_size]
 mov [bp-4], eax
;-430 	CountofClusters=DataSectors32 / templong;//d=d/b

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [bp-4]
 mov dword [CountofClusters], eax
;-431 	

;-432 	templong = (long) bs_sectors_per_track;

 xor eax, eax
 mov ax, [bs_sectors_per_track]
 mov [bp-4], eax
;-433 	fat_num_tracks = bs_tot_sect32 / templong;//d=d/w

 mov eax, [bs_tot_sect32]
 xor edx, edx
 div dword [bp-4]
 mov dword [fat_num_tracks], eax
;-434 	

;-435 	templong = (long) bs_num_heads;	

 xor eax, eax
 mov ax, [bs_num_heads]
 mov [bp-4], eax
;-436 	fat_num_cylinders = fat_num_tracks / templong;//w=d/w

 mov eax, [fat_num_tracks]
 xor edx, edx
 div dword [bp-4]
 mov word [fat_num_cylinders], ax
;-437 			

;-438 	Sectors_per_cylinder = bs_sectors_per_track *  bs_num_heads;//d=w*w

 mov ax, [bs_sectors_per_track]
;todo:save high part:mov [Longvar+2(+4)],(e)dx
 mul word [bs_num_heads]
 mov dword [Sectors_per_cylinder], eax
;-439 	asm mov [Sectors_per_cylinder + 2], dx;store high word

 mov [Sectors_per_cylinder + 2], dx;store high word
;-440 

;-441 	cputs(", trueFATtype=FAT"); 

 push FATInit_0
 call cputs
 add  sp, 2
;-442 	

;-443 	templong = (long) 65525;			

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-444 	if (CountofClusters > templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jle .FATInit42
;-445 		trueFATtype=32; 

 mov ax, 32
 mov byte [trueFATtype], al
;-446 		cputs("32 NOT supported"); 

 push FATInit_1
 call cputs
 add  sp, 2
;-447 		return 1;

 mov ax, 1
 jmp .retnFATInit
;-448 		}

;-449 	templong= (long) 4086;

.FATInit42:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-450 	if (CountofClusters < templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jge .FATInit43
;-451 		trueFATtype=12; 

 mov ax, 12
 mov byte [trueFATtype], al
;-452 		cputs("12"); 

 push FATInit_2
 call cputs
 add  sp, 2
;-453 		return 0;

 mov ax, 0
 jmp .retnFATInit
;-454 		}

;-455 	trueFATtype=16;

.FATInit43:
 mov ax, 16
 mov byte [trueFATtype], al
;-456 	cputs("16");

 push FATInit_3
 call cputs
 add  sp, 2
;-457 	return 0;

 mov ax, 0
 jmp .retnFATInit
;-458 }

;-459 

;-460 int Int13hExt() {

 .retnFATInit:
 LEAVE
 ret
FATInit_0 db ", trueFATtype=FAT",0
FATInit_1 db "32 NOT supported",0
FATInit_2 db "12",0
FATInit_3 db "16",0
ENDP

Int13hExt: PROC
;-461 	bx=0x55AA;

 mov  bx, 21930
;-462 	BIOS_Status=Int13hfunction(Drive, 0x41);	

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-463 	asm mov [vAX], ax;

 mov [vAX], ax;
;-464 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-465 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported 			
;-466 //	putch(10);

;-467 //	cputs("Int13h 41h Ext=");	printhex16(vAX);

;-468 //	cputs(", BIOS_Status=");	printhex16(BIOS_Status);

;-469 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt44
;-470 		cputs(" Ext NOT present");	

 push Int13hExt_0
 call cputs
 add  sp, 2
;-471 		Int13hError();	

 call Int13hError
;-472 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-473 		}

;-474 	else {

 jmp .Int13hExt45
.Int13hExt44:
;-475 		cputs(",Extension found BX(AA55)=");printhex16(vBX);

 push Int13hExt_1
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-476 //		cputs(" CX=");						printhex16(vCX);

;-477 		}

;-478 	return 0;			

.Int13hExt45:
 mov ax, 0
 jmp .retnInt13hExt
;-479 }	

;-480 

;-481 int readLogical() {//IN:Sectors_to_read

 .retnInt13hExt:
 ret
Int13hExt_0 db " Ext NOT present",0
Int13hExt_1 db ",Extension found BX(AA55)=",0
ENDP

readLogical: PROC
;-482 	unsigned int track; unsigned int head; unsigned int sect;

;-483 	Sectors_to_read = Sectors_to_read + bs_hid_sects;//d=d+d

;Function : readLogical, Number local Var: 3
; # type sign width local variables
;65 var unsg word track = bp-2
;66 var unsg word head = bp-4
;67 var unsg word sect = bp-6;
 ENTER  6,0
 mov eax, [Sectors_to_read]
 add eax, [bs_hid_sects]
 mov dword [Sectors_to_read], eax
;-484 	track = Sectors_to_read / Sectors_per_cylinder;  //w=d/d

 mov eax, [Sectors_to_read]
 xor edx, edx
 div dword [Sectors_per_cylinder]
 mov [bp-2], ax
;-485 	head  = Sectors_to_read % Sectors_per_cylinder;  //w=d%d

 mov eax, [Sectors_to_read]
 xor edx, edx
 div dword [Sectors_per_cylinder]
 mov eax, edx
 mov [bp-4], ax
;-486 	sect  = head            % bs_sectors_per_track;  //w=w%w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov ax, dx
 mov [bp-6], ax
;-487 	sect++;

 inc  word[bp-6]
;-488 	head  = head            / bs_sectors_per_track;	 //w=w/w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_sectors_per_track]
 mov [bp-4], ax
;-489 

;-490 	DiskSectorReadWrite(2, bs_drive_num, head, track/* =cyl */,

;-491 		sect, 1, DiskBufSeg , DiskBuf);

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
;-492 }

;-493 

;-494 int PrintDriveParameter() {

 LEAVE
 ret
ENDP

PrintDriveParameter: PROC
;-495 	unsigned long Lo;

;-496 // from Params

;-497 	putch(10);

;Function : PrintDriveParameter, Number local Var: 1
; # type sign width local variables
;65 var unsg long Lo = bp-4;
 ENTER  4,0
 push 10
 call putch
 add  sp, 2
;-498 	cputs("Params:CylHeadSec=");printunsign(pa_Cylinders);

 push PrintDriveParameter_0
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-499 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-500 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-501 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-502 	putch('.');

 push 46
 call putch
 add  sp, 2
;-503 //from getPartitionData

;-504 	putch(10);		

 push 10
 call putch
 add  sp, 2
;-505 	cputs("getPartitionData:No=");printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-506 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-507 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-508 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-509 	cputs("/");				printunsign(pt_StartSector);	

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-510 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-511 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-512 	cputs("/");				printunsign(pt_EndSector);	

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-513 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-514 	cputs(",Start=");		printlong(&pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 lea  ax, [pt_HiddenSector]
 push ax
 call printlong
 add  sp, 2
;-515 	cputs(",Len=");			printlong(&pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 lea  ax, [pt_PartLen]
 push ax
 call printlong
 add  sp, 2
;-516 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-517 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-518 	printlong(&Lo);

 lea  ax, [bp-4]
 push ax
 call printlong
 add  sp, 2
;-519 	cputs(" MByte.");	

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-520 //from getBootSector

;-521 	putch(10);

 push 10
 call putch
 add  sp, 2
;-522 	cputs("getBootSector:OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-523 	putch(10);

 push 10
 call putch
 add  sp, 2
;-524 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);	

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-525 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);	

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-526 	putch(10);

 push 10
 call putch
 add  sp, 2
;-527 	cputs("Reserved sectors=");printunsign(bs_res_sects);	

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-528 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);	

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-529 	putch(10);

 push 10
 call putch
 add  sp, 2
;-530 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-531 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-532 	putch(10);

 push 10
 call putch
 add  sp, 2
;-533 	cputs("Media desc.(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-534 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-535 	putch(10);

 push 10
 call putch
 add  sp, 2
;-536 	cputs("sectors per track=");printunsign(bs_sectors_per_track);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_sectors_per_track]
 call printunsign
 add  sp, 2
;-537 	cputs(".number of heads=");printunsign(bs_num_heads);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_heads]
 call printunsign
 add  sp, 2
;-538 	putch(10);

 push 10
 call putch
 add  sp, 2
;-539 	cputs("hidden sectors(long)=");printlong(&bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 lea  ax, [bs_hid_sects]
 push ax
 call printlong
 add  sp, 2
;-540 	cputs(".sectors(long)=");printlong(&bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 lea  ax, [bs_tot_sect32]
 push ax
 call printlong
 add  sp, 2
;-541 	putch(10);

 push 10
 call putch
 add  sp, 2
;-542 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-543 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-544 	putch(10);

 push 10
 call putch
 add  sp, 2
;-545 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-546 	cputs(".Volume serial(long)=");printlong(&bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 lea  ax, [bs_serial_num]
 push ax
 call printlong
 add  sp, 2
;-547 	putch(10);

 push 10
 call putch
 add  sp, 2
;-548 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-549 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);		

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-550 //from FATInit

;-551 	putch(10);

 push 10
 call putch
 add  sp, 2
;-552 	cputs("FATInit:fat_FatStartSector:");	printunsign(fat_FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [fat_FatStartSector]
 call printunsign
 add  sp, 2
;-553 	cputs(", fat_FatSectors=");		printunsign(fat_FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [fat_FatSectors]
 call printunsign
 add  sp, 2
;-554 	putch(10);

 push 10
 call putch
 add  sp, 2
;-555 	cputs("fat_RootDirStartSector="); printunsign(fat_RootDirStartSector);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push word [fat_RootDirStartSector]
 call printunsign
 add  sp, 2
;-556 	cputs(", fat_RootDirSectors=");	printunsign(fat_RootDirSectors);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push word [fat_RootDirSectors]
 call printunsign
 add  sp, 2
;-557 	putch(10);

 push 10
 call putch
 add  sp, 2
;-558 	cputs("fat_DataStartSector=");	printunsign(fat_DataStartSector);

 push PrintDriveParameter_38
 call cputs
 add  sp, 2
 push word [fat_DataStartSector]
 call printunsign
 add  sp, 2
;-559 	cputs(", DataSectors32=");	printlong(&DataSectors32);			

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 lea  ax, [DataSectors32]
 push ax
 call printlong
 add  sp, 2
;-560 	putch(10);

 push 10
 call putch
 add  sp, 2
;-561 	cputs("CountofClusters=");	printlong(&CountofClusters);

 push PrintDriveParameter_40
 call cputs
 add  sp, 2
 lea  ax, [CountofClusters]
 push ax
 call printlong
 add  sp, 2
;-562 	cputs(", Sectors_per_cylinder="); printlong(&Sectors_per_cylinder);	

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 lea  ax, [Sectors_per_cylinder]
 push ax
 call printlong
 add  sp, 2
;-563 	putch(10);

 push 10
 call putch
 add  sp, 2
;-564 	cputs("fat_num_tracks=");	printlong(&fat_num_tracks);

 push PrintDriveParameter_42
 call cputs
 add  sp, 2
 lea  ax, [fat_num_tracks]
 push ax
 call printlong
 add  sp, 2
;-565 	cputs(", fat_num_cylinders="); printunsign(fat_num_cylinders);	

 push PrintDriveParameter_43
 call cputs
 add  sp, 2
 push word [fat_num_cylinders]
 call printunsign
 add  sp, 2
;-566 	putch(10);

 push 10
 call putch
 add  sp, 2
;-567 	cputs("Sectors_per_cylinder=");	printlong(&Sectors_per_cylinder);

 push PrintDriveParameter_44
 call cputs
 add  sp, 2
 lea  ax, [Sectors_per_cylinder]
 push ax
 call printlong
 add  sp, 2
;-568 }	

;-569 

;-570 int Init() {

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

Init: PROC
;-571 	int FATtype; 

;-572 	Drive=0x80;

;Function : Init, Number local Var: 1
; # type sign width local variables
;65 var sign word FATtype = bp-2;
 ENTER  2,0
 mov ax, 128
 mov byte [Drive], al
;-573 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-574 

;-575 	if (Params()) cputs("** NO DRIVE PARAMS FOUND **");//no hard disk

 call Params
 or  al, al
 je .Init46
 push Init_0
 call cputs
 add  sp, 2
;-576 	FATtype=readMBR();//0=error,1=FAT12,6=FAT16,11=FAT32

.Init46:
 call readMBR
 mov [bp-2], ax
;-577 	if (FATtype == 0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .Init47
;-578 		cputs(" no active FAT partition found. ");

 push Init_1
 call cputs
 add  sp, 2
;-579 //		return 1;	

;-580 		}

;-581 	if(getBootSector()==0) 	return 1;

.Init47:
 call getBootSector
 cmp ax, 0
 jne .Init48
 mov ax, 1
 jmp .retnInit
;-582 	if (FATInit())			return 1;

.Init48:
 call FATInit
 or  al, al
 je .Init49
 mov ax, 1
 jmp .retnInit
;-583 	if(trueFATtype != 16) 	return 1;

.Init49:
 mov al, [trueFATtype]
 cmp al, 16
 je  .Init50
 mov ax, 1
 jmp .retnInit
;-584 	Int13hExt();

.Init50:
 call Int13hExt
;-585 	return 0;

 mov ax, 0
 jmp .retnInit
;-586 }	

;-587 //------------------------------------ main ---------------

;-588 int main() {

 .retnInit:
 LEAVE
 ret
Init_0 db "** NO DRIVE PARAMS FOUND **",0
Init_1 db " no active FAT partition found. ",0
ENDP

main: PROC
;-589 	Init();

 call Init
;-590 	PrintDriveParameter(); 

 call PrintDriveParameter
;-591 /*	

;-592 	Sectors_to_read = (long) 0;

;-593 	readLogical();

;-594 	getkey();

;-595 	mdump(DiskBuf, 512);

;-596 */	

;-597 }

 ret
ENDP
;Glob. variables:64 (400):757 (4000), Functions:31 (300):304 (3000)
;Lines:598, Constant: 2171 (4000), stacksize: 56831