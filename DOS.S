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

;-27 //calcFATtype     

;-28 unsigned int FatStartSector;

FatStartSector dw 0
;-29 unsigned int FatSectors;

FatSectors dw 0
;-30 unsigned int RootDirStartSector;

RootDirStartSector dw 0
;-31 unsigned int RootDirSectors;

RootDirSectors dw 0
;-32 unsigned int DataStartSector;

DataStartSector dw 0
;-33 unsigned long DataSectors32;

DataSectors32 dd 0
;-34 unsigned long CountofClusters;

CountofClusters dd 0
;-35 char          trueFATtype;

trueFATtype db 0
;-36 unsigned long Sectors_per_cylinder;

Sectors_per_cylinder dd 0
;-37 

;-38 unsigned int  pt_PartNo;

pt_PartNo dw 0
;-39 //start hard disk partition structure 16 bytes in MBR. do not change

;-40 unsigned char pt_Bootable;		//80h = active partition, else 00

pt_Bootable db 0
;-41 unsigned char pt_StartHead;

pt_StartHead db 0
;-42 unsigned char pt_StartSector;	//bits 0-5

pt_StartSector db 0
;-43 unsigned int  pt_StartCylinder;	//bits 8,9 in bits 6,7 of sector

pt_StartCylinder dw 0
;-44 unsigned char pt_FileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=largeFAT16

pt_FileSystem db 0
;-45 unsigned char pt_EndHead;

pt_EndHead db 0
;-46 unsigned char pt_EndSector;		//bits 0-5

pt_EndSector db 0
;-47 unsigned int  pt_EndCylinder;	//bits 8,9 in bits 6,7 of sector

pt_EndCylinder dw 0
;-48 unsigned long pt_HiddenSector;	//sectors preceding partition

pt_HiddenSector dd 0
;-49 unsigned long pt_PartLen;    	//length of partition in sectors

pt_PartLen dd 0
;-50 //end hard disk partition structure

;-51 

;-52 //start boot BIOS Parameter Block structure. do not change

;-53 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90

bs_jmp db "12",0
;-54 unsigned char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0"

bs_sys_id db "1234567",0
;-55 unsigned int  bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-56 unsigned char bs_clust_size;// 13 sectors per cluster (1,2,4,..,128)

bs_clust_size db 0
;-57 unsigned int  bs_res_sects;	// 14 reserved sectors starting at 0

bs_res_sects dw 0
;-58 unsigned char bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats db 0
;-59 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-60 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-61 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD)

bs_media_desc db 0
;-62 unsigned int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-63 unsigned int  bs_num_sects;	// 24 (DOS 3+)sectors per track 

bs_num_sects dw 0
;-64 unsigned int  bs_num_sides;	// 26 (DOS 3+)number of heads   

bs_num_sides dw 0
;-65 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors 

bs_hid_sects dd 0
;-66 unsigned long bs_tot_sect32;	// 32 (DOS 4+) number of sectors if ofs 19 = 0

bs_tot_sect32 dd 0
;-67 unsigned char bs_drive_num;	// 36 (DOS 4+) physical drive number

bs_drive_num db 0
;-68 unsigned char bs_reserved;  // 37 (DOS 4+) for Windows NT check disk

bs_reserved db 0
;-69 unsigned char bs_ext_signat;// 38 (DOS 4+) Extended signature,get next 3(29h)

bs_ext_signat db 0
;-70 unsigned long bs_serial_num;// 39 (DOS 4+) Volume serial number random

bs_serial_num dd 0
;-71 unsigned char bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME"

bs_label db "1234567890",0
;-72 unsigned char bs_fs_id[]="1234567";  // 54 (DOS 4+) File system type "FAT16"

bs_fs_id db "1234567",0
;-73 // 62 end boot BIOS Parameter Block

;-74 

;-75 int test() {


test: PROC
;-76 

;-77 __asm{	

	
;-78 


;-79 }	}


;-80 

;-81 int writetty()     {//char in AL

 ret
ENDP

writetty: PROC
;-82     ah=0x0E;

 mov  ah, 14
;-83     push bx;

push bx;
;-84     bx=0;			//page in BH

 mov  bx, 0
;-85     inth 0x10;		//16

 int  16
;-86     pop bx;

pop bx;
;-87 }

;-88 int putch(char c)  {

 ret
ENDP

putch: PROC
;-89     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;63 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-90         al=13;

 mov  al, 13
;-91         writetty();

 call writetty
;-92     }

;-93     al=c;

.putch1:
 mov  al, [bp+4]
;-94     writetty();

 call writetty
;-95 }

;-96 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-97     char c;

;-98     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;63 ptr sign byte s = bp+4
;64 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-99         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-100         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-101         s++;

 inc  word[bp+4]
;-102     }

;-103 }

 jmp .cputs2
.cputs3:
;-104 int cputsLen(char *s, int len) {

 LEAVE
 ret
ENDP

cputsLen: PROC
;-105 	char c;

;-106 	do {

;Function : cputsLen, Number local Var: 3
; # type sign width local variables
;63 ptr sign byte s = bp+4
;64 var sign word len = bp+6
;65 var sign byte c = bp-2;
 ENTER  2,0
.cputsLen4:
;-107 		c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-108 		putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-109 		s++;

 inc  word[bp+4]
;-110 		len--;

 dec  word[bp+6]
;-111 	} while (len > 0);	

 mov ax, [bp+6]
 cmp ax, 0
 jle .cputsLen5
 jmp .cputsLen4
.cputsLen5:
;-112 }

;-113 

;-114 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-115     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-116     inth 0x16;//AH=Scan code, AL=char

 int  22
;-117 }

;-118 int waitkey() {

 ret
ENDP

waitkey: PROC
;-119     ah=0x11;//get kbd status

 mov  ah, 17
;-120     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-121     //zero flag: 0=IS char, 1=NO char

;-122     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-123 }

;-124 int getkey() {

 ret
ENDP

getkey: PROC
;-125     waitkey();

 call waitkey
;-126     getch();

 call getch
;-127     ah=0;//clear scan code

 mov  ah, 0
;-128     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-129     //put ext code in AX

;-130 }

.getkey6:
;-131 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-132     getkey();

 call getkey
;-133     writetty();//destroys AH

 call writetty
;-134 }

;-135 

;-136 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-137     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;63 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-138     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex47
 add  byte[bp+4], 7
;-139     putch(c);

.printhex47:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-140 }

;-141 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-142     unsigned char nib;

;-143     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;63 var unsg byte c = bp+4
;64 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-144     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-145 }

;-146 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-147     unsigned int half;

;-148     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;63 var unsg word i = bp+4
;64 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-149     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-150 }

;-151 

;-152 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-153     unsigned int e;

;-154     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;63 var unsg word n = bp+4
;64 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign8
;-155         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-156         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-157         }

;-158     n=n%10;

.printunsign8:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-159     n+='0';

 add  word[bp+4], 48
;-160     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-161 }

;-162 

;-163 int printlong(unsigned int *p) {

 LEAVE
 ret
ENDP

printlong: PROC
;-164 	unsigned int lo; unsigned int hi;

;-165 	lo = *p;

;Function : printlong, Number local Var: 3
; # type sign width local variables
;63 ptr unsg word p = bp+4
;64 var unsg word lo = bp-2
;65 var unsg word hi = bp-4;
 ENTER  4,0
 mov bx, [bp+4]
 mov ax, [bx]
 mov [bp-2], ax
;-166 	p +=2;

 add  word[bp+4], 2
;-167 	hi = *p;

 mov bx, [bp+4]
 mov ax, [bx]
 mov [bp-4], ax
;-168 	dx=hi;

 mov  dx, [bp-4]
;-169 	ax=lo;

 mov  ax, [bp-2]
;-170 __asm{	

	
;-171   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-172     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-173 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-174     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-175     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-176 ;// DX:AX DIV BX = AX remainder dx

;// DX:AX DIV BX = AX remainder dx
;-177     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-178     db		145;=91h xchg ax,cx; move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx; move it to CX restoring LowDividend
;-179     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-180     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-181     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-182     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-183     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-184     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-185 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-186 }	writetty();		__asm{


 call writetty

;-187     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-188     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-189     jb      .b             ;Not yet	

    jb      .b             ;Not yet	
;-190 } 


;-191 }

;-192 

;-193 int memcpy(char *s, char *t, unsigned int i) {

 LEAVE
 ret
ENDP

memcpy: PROC
;-194 	unsigned int r;

;-195 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;63 ptr sign byte s = bp+4
;64 ptr sign byte t = bp+6
;65 var unsg word i = bp+8
;66 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-196 	do {

.memcpy9:
;-197 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-198 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-199 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy10
 jmp .memcpy9
.memcpy10:
;-200 	ax=r;//	return r;

 mov  ax, [bp-2]
;-201 }

;-202 	

;-203 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
ENDP

mdump: PROC
;-204     unsigned char c; int i; int j; int k;

;-205     j=0;

;Function : mdump, Number local Var: 6
; # type sign width local variables
;63 ptr unsg byte adr = bp+4
;64 var unsg word len = bp+6
;65 var unsg byte c = bp-2
;66 var sign word i = bp-4
;67 var sign word j = bp-6
;68 var sign word k = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-6], ax
;-206     k=0;

 mov ax, 0
 mov [bp-8], ax
;-207     while (j < len ) {

.mdump11:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump12
;-208 	    k++;; 

 inc  word[bp-8]
;-209 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump13
;-210 		    getkey();

 call getkey
;-211 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-212 		    }

;-213         putch(10);

.mdump13:
 push 10
 call putch
 add  sp, 2
;-214         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-215         putch(':');

 push 58
 call putch
 add  sp, 2
;-216         i=0;

 mov ax, 0
 mov [bp-4], ax
;-217         while (i < 16) {

.mdump14:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump15
;-218             putch(' ');

 push 32
 call putch
 add  sp, 2
;-219             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-220             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-221             adr++;

 inc  word[bp+4]
;-222             i++;

 inc  word[bp-4]
;-223             j++;

 inc  word[bp-6]
;-224             }

;-225         putch(' ');

 jmp .mdump14
.mdump15:
 push 32
 call putch
 add  sp, 2
;-226         adr -=16;

 sub  word[bp+4], 16
;-227         i=0;

 mov ax, 0
 mov [bp-4], ax
;-228         while(i < 16) {

.mdump16:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump17
;-229             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-230             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump18
 push 46
 call putch
 add  sp, 2
;-231                 else putch(c);

 jmp .mdump19
.mdump18:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-232             adr++;

.mdump19:
 inc  word[bp+4]
;-233             i++;

 inc  word[bp-4]
;-234         }

;-235     }

 jmp .mdump16
.mdump17:
;-236 }

 jmp .mdump11
.mdump12:
;-237 

;-238 //--------------------------------  disk IO  -------------------

;-239 

;-240 int DiskSectorReadWrite(char rw, char drive, char head, int cyl, 

 LEAVE
 ret
ENDP

DiskSectorReadWrite: PROC
;-241 char sector, char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-242 	BIOS_ERR=0;	

;Function : DiskSectorReadWrite, Number local Var: 8
; # type sign width local variables
;63 var sign byte rw = bp+4
;64 var sign byte drive = bp+6
;65 var sign byte head = bp+8
;66 var sign word cyl = bp+10
;67 var sign byte sector = bp+12
;68 var sign byte count = bp+14
;69 var sign word BufSeg = bp+16
;70 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-243 	dl=drive;

 mov  dl, [bp+6]
;-244 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-245 	es=BufSeg;

 mov  es, [bp+16]
;-246 	bx=BufOfs;

 mov  bx, [bp+18]
;-247 	cx=cyl;	

 mov  cx, [bp+10]
;-248 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-249 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-250 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-251 	cl += sector;

 add  cl, [bp+12]
;-252 	ch=cyl;//low byte of cyl in ch, word 2 byte	

 mov  ch, [bp+10]
;-253 	al=count;

 mov  al, [bp+14]
;-254 	ah=rw;

 mov  ah, [bp+4]
;-255 	inth 0x13;

 int  19
;-256     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-257 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-258 }

;-259 int Int13hfunction(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hfunction: PROC
;-260 	BIOS_ERR=0;	

;Function : Int13hfunction, Number local Var: 2
; # type sign width local variables
;63 var sign byte drive = bp+4
;64 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-261 	dl=drive;

 mov  dl, [bp+4]
;-262 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-263 	inth 0x13;

 int  19
;-264     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-265 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-266 }

;-267 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-268 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-269 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-270 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-271 	//Int13hfunction(Drive, 0);//Reset, loose BIOS_ERR

;-272 }	

;-273 int Status(drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Status: PROC
;-274 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;63 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-275 	cputs("Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-276 	BIOS_Status=Int13hfunction(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-277 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status20
 call Int13hError
;-278 	printhex16(BIOS_Status);	

.Status20:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-279 }	

;-280 

;-281 int Params() {

 LEAVE
 ret
Status_0 db "Status last Op=",0
ENDP

Params: PROC
;-282 	cputs("Get Drive Params ");

 push Params_0
 call cputs
 add  sp, 2
;-283 	BIOS_Status=Int13hfunction(Drive, 8);

 push 8
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-284 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Params21
;-285 		Int13hError();

 call Int13hError
;-286 		return 1;

 mov ax, 1
 jmp .retnParams
;-287 		}

;-288 	else {

 jmp .Params22
.Params21:
;-289 		asm mov [pa_Heads],        dh

 mov [pa_Heads],        dh
;-290 		asm mov [pa_Attached],     dl

 mov [pa_Attached],     dl
;-291 		// CX =       ---CH--- ---CL---

;-292 		// cylinder : 76543210 98

;-293 		// sector   :            543210	

;-294 		asm mov [pa_Sectors],      cl

 mov [pa_Sectors],      cl
;-295 		pa_Sectors &= 0x3F;// 63

 and  byte[pa_Sectors], 63
;-296 //		pa_Sectors++;//1 to 64

;-297 	

;-298 		asm mov [pa_Cylinders],    cx	

 mov [pa_Cylinders],    cx	
;-299 		pa_Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[pa_Cylinders], 192
;-300 		pa_Cylinders = pa_Cylinders << 2;//compiler flaw:

 mov ax, [pa_Cylinders]
 shl ax, 2
 mov word [pa_Cylinders], ax
;-301 		asm add [pa_Cylinders],    ch;//byte add, low byte is empty	

 add [pa_Cylinders],    ch;//byte add, low byte is empty	
;-302 		

;-303 		if (pa_Attached == 0) {

 mov al, [pa_Attached]
 cmp al, 0
 jne .Params23
;-304 			cputs(" no hard disk found");

 push Params_1
 call cputs
 add  sp, 2
;-305 			return 1;

 mov ax, 1
 jmp .retnParams
;-306 			}

;-307 	}

.Params23:
;-308 	return 0;

.Params22:
 mov ax, 0
 jmp .retnParams
;-309 }

;-310 

;-311 

;-312 int getPartitionData() {

 .retnParams:
 ret
Params_0 db "Get Drive Params ",0
Params_1 db " no hard disk found",0
ENDP

getPartitionData: PROC
;-313 	unsigned int j; char c; char *p;

;-314 	j = pt_PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;63 var unsg word j = bp-2
;64 var sign byte c = bp-4
;65 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [pt_PartNo]
 shl ax, 4
 mov [bp-2], ax
;-315 	j = j + 0x1be;			pt_Bootable=DiskBuf[j];//80H=boot

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_Bootable], al
;-316 	j++;					pt_StartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartHead], al
;-317 	j++;					pt_StartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_StartSector], al
;-318 	pt_StartCylinder=(int)pt_StartSector;		

 xor ax, ax
 mov al, [pt_StartSector]
 mov word [pt_StartCylinder], ax
;-319 	pt_StartSector &= 0x3F;

 and  byte[pt_StartSector], 63
;-320 //	pt_StartSector++;//Sector start with 1 todo

;-321 	pt_StartCylinder &= 0xC0;

 and  word[pt_StartCylinder], 192
;-322 	pt_StartCylinder = pt_StartCylinder << 2;

 mov ax, [pt_StartCylinder]
 shl ax, 2
 mov word [pt_StartCylinder], ax
;-323 	j++;

 inc  word[bp-2]
;-324 	pt_StartCylinder=(int)DiskBuf[j] + pt_StartCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_StartCylinder]
 mov word [pt_StartCylinder], ax
;-325 	j++;					pt_FileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_FileSystem], al
;-326 //	0=not used, 1=FAT12, 4=FAT16, 5=extended, 6=large<2GB	

;-327 	j++;					pt_EndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndHead], al
;-328 	j++;					pt_EndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [pt_EndSector], al
;-329 	pt_EndCylinder=    (int)pt_EndSector;//see next 5 line		

 xor ax, ax
 mov al, [pt_EndSector]
 mov word [pt_EndCylinder], ax
;-330 	pt_EndSector &= 0x3F;

 and  byte[pt_EndSector], 63
;-331 //	pt_EndSector++;//Sector start with 1 todo

;-332 	pt_EndCylinder &= 0xC0;

 and  word[pt_EndCylinder], 192
;-333 	pt_EndCylinder = pt_EndCylinder << 2;//OK no short cut!	

 mov ax, [pt_EndCylinder]
 shl ax, 2
 mov word [pt_EndCylinder], ax
;-334 	j++;

 inc  word[bp-2]
;-335 	pt_EndCylinder=(int)DiskBuf[j] + pt_EndCylinder;

 xor ax, ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [pt_EndCylinder]
 mov word [pt_EndCylinder], ax
;-336 	j++;

 inc  word[bp-2]
;-337 	p = j + &DiskBuf;//copy pt_HiddenSector, pt_PartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-338 	memcpy(&pt_HiddenSector, p, 8);	

 push 8
 push word [bp-6]
 lea  ax, [pt_HiddenSector]
 push ax
 call memcpy
 add  sp, 6
;-339 }

;-340 	

;-341 int checkBootSign() {

 LEAVE
 ret
ENDP

checkBootSign: PROC
;-342 	int i;

;-343 	i=510;	

;Function : checkBootSign, Number local Var: 1
; # type sign width local variables
;63 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 510
 mov [bp-2], ax
;-344 	if (DiskBuf[i] == 0x55) {

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 85
 jne .checkBootSign24
;-345 		i++;		

 inc  word[bp-2]
;-346 		if (DiskBuf[i] == 0xAA) return 1;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 cmp al, 170
 jne .checkBootSign25
 mov ax, 1
 jmp .retncheckBootSign
;-347 	}	

.checkBootSign25:
;-348 	cputs(" Magic number NOT found.");

.checkBootSign24:
 push checkBootSign_0
 call cputs
 add  sp, 2
;-349 	return 0;	

 mov ax, 0
 jmp .retncheckBootSign
;-350 }	

;-351 	

;-352 int readMBR() {

 .retncheckBootSign:
 LEAVE
 ret
checkBootSign_0 db " Magic number NOT found.",0
ENDP

readMBR: PROC
;-353 	int isFAT;

;-354 	isFAT=0;

;Function : readMBR, Number local Var: 1
; # type sign width local variables
;63 var sign word isFAT = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-355 	pt_PartNo=0;

 mov ax, 0
 mov word [pt_PartNo], ax
;-356 	BIOS_Status=DiskSectorReadWrite(2,Drive,0,0,1,1,DiskBufSeg,DiskBuf);

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
;-357 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .readMBR26
;-358 		Int13hError();

 call Int13hError
;-359 		return 0;

 mov ax, 0
 jmp .retnreadMBR
;-360 		}

;-361 	else {	

 jmp .readMBR27
.readMBR26:
;-362 		putch(10);

 push 10
 call putch
 add  sp, 2
;-363 		cputs("Read partition.");

 push readMBR_0
 call cputs
 add  sp, 2
;-364 		if(checkBootSign()==0) return 0;	

 call checkBootSign
 cmp al, 0
 jne .readMBR28
 mov ax, 0
 jmp .retnreadMBR
;-365 		do {

.readMBR28:
.readMBR29:
;-366 			getPartitionData();

 call getPartitionData
;-367 			

;-368 			if (pt_Bootable == 0x80) {

 mov al, [pt_Bootable]
 cmp al, 128
 jne .readMBR30
;-369 				cputs("Boot partition found");

 push readMBR_1
 call cputs
 add  sp, 2
;-370 				if (pt_FileSystem == 1) {

 mov al, [pt_FileSystem]
 cmp al, 1
 jne .readMBR31
;-371 					cputs(", FAT12 partition < 32MB");

 push readMBR_2
 call cputs
 add  sp, 2
;-372 					isFAT=1;

 mov ax, 1
 mov [bp-2], ax
;-373 					}

;-374 				if (pt_FileSystem == 4) {

.readMBR31:
 mov al, [pt_FileSystem]
 cmp al, 4
 jne .readMBR32
;-375 					cputs(", small FAT16 partition < 32MB");

 push readMBR_3
 call cputs
 add  sp, 2
;-376 					isFAT=4;

 mov ax, 4
 mov [bp-2], ax
;-377 					}

;-378 				if (pt_FileSystem == 6) {

.readMBR32:
 mov al, [pt_FileSystem]
 cmp al, 6
 jne .readMBR33
;-379 					cputs(", large FAT16 partition < 2GB");

 push readMBR_4
 call cputs
 add  sp, 2
;-380 					isFAT=6;

 mov ax, 6
 mov [bp-2], ax
;-381 					}

;-382 				pt_PartNo=99;//end of loop	

.readMBR33:
 mov ax, 99
 mov word [pt_PartNo], ax
;-383 			}

;-384 			pt_PartNo ++;

.readMBR30:
 inc  word[pt_PartNo]
;-385 		} while (pt_PartNo <4);

 mov ax, [pt_PartNo]
 cmp ax, 4
 jge .readMBR34
 jmp .readMBR29
.readMBR34:
;-386 		return isFAT;

 mov ax, [bp-2]
 jmp .retnreadMBR
;-387 	}	

;-388 }

.readMBR27:
;-389 

;-390 int getBootSector() {int i;

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
;-391 		putch(10);

;Function : getBootSector, Number local Var: 1
; # type sign width local variables
;63 var sign word i = bp-2;
 ENTER  2,0
 push 10
 call putch
 add  sp, 2
;-392 		cputs(" Read boot sector");

 push getBootSector_0
 call cputs
 add  sp, 2
;-393   	BIOS_Status=DiskSectorReadWrite(2, Drive, pt_StartHead, pt_StartCylinder,

;-394   		pt_StartSector, 1, DiskBufSeg, DiskBuf);

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
;-395 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .getBootSector35
;-396 		Int13hError();

 call Int13hError
;-397 		return 0;

 mov ax, 0
 jmp .retngetBootSector
;-398 		}

;-399 	else {	

 jmp .getBootSector36
.getBootSector35:
;-400 //		printhex16(BIOS_Status);	

;-401 		if(checkBootSign()==0) return 0;		

 call checkBootSign
 cmp al, 0
 jne .getBootSector37
 mov ax, 0
 jmp .retngetBootSector
;-402 		memcpy(&bs_jmp, &DiskBuf, 62);

.getBootSector37:
 push 62
 lea  ax, [DiskBuf]
 push ax
 lea  ax, [bs_jmp]
 push ax
 call memcpy
 add  sp, 6
;-403 		if (bs_jmp[0] != 0xEB) cputs(".ATTN boot byte NOT EBh");

 mov al, [bs_jmp]
 cmp al, 235
 je  .getBootSector38
 push getBootSector_1
 call cputs
 add  sp, 2
;-404 		i=2;

.getBootSector38:
 mov ax, 2
 mov [bp-2], ax
;-405 		if (bs_jmp[i] != 0x90) cputs(".ATTN[2] boot byte NOT 90h");

 mov bx, [bp-2]
 mov al, [bs_jmp + bx]
 cmp al, 144
 je  .getBootSector39
 push getBootSector_2
 call cputs
 add  sp, 2
;-406 	}

.getBootSector39:
;-407 	return 1;

.getBootSector36:
 mov ax, 1
 jmp .retngetBootSector
;-408 }

;-409 

;-410 int calcFATtype() {	

 .retngetBootSector:
 LEAVE
 ret
getBootSector_0 db " Read boot sector",0
getBootSector_1 db ".ATTN boot byte NOT EBh",0
getBootSector_2 db ".ATTN[2] boot byte NOT 90h",0
ENDP

calcFATtype: PROC
;-411 	unsigned long templong;//converting word to dword

;-412 

;-413 	FatStartSector=bs_res_sects;	

;Function : calcFATtype, Number local Var: 1
; # type sign width local variables
;63 var unsg long templong = bp-4;
 ENTER  4,0
 mov ax, [bs_res_sects]
 mov word [FatStartSector], ax
;-414 	FatSectors=bs_fat_size;	

 mov ax, [bs_fat_size]
 mov word [FatSectors], ax
;-415 	if (bs_num_fats == 2) FatSectors=FatSectors+FatSectors;

 mov al, [bs_num_fats]
 cmp al, 2
 jne .calcFATtype40
 mov ax, [FatSectors]
 add ax, [FatSectors]
 mov word [FatSectors], ax
;-416 

;-417 	RootDirStartSector=FatStartSector + FatSectors;

.calcFATtype40:
 mov ax, [FatStartSector]
 add ax, [FatSectors]
 mov word [RootDirStartSector], ax
;-418 	RootDirSectors= bs_root_entr << 5;// *32	

 mov ax, [bs_root_entr]
 shl ax, 5
 mov word [RootDirSectors], ax
;-419 	RootDirSectors= RootDirSectors / bs_sect_size;

 mov ax, [RootDirSectors]
 xor dx, dx
 div word [bs_sect_size]
 mov word [RootDirSectors], ax
;-420 

;-421 	DataStartSector=RootDirStartSector + RootDirSectors;

 mov ax, [RootDirStartSector]
 add ax, [RootDirSectors]
 mov word [DataStartSector], ax
;-422 	templong=(long) DataStartSector;		

 xor eax, eax
 mov ax, [DataStartSector]
 mov [bp-4], eax
;-423 	

;-424 	if (bs_tot_sect16 !=0) bs_tot_sect32 = (long) bs_tot_sect16;		

 mov ax, [bs_tot_sect16]
 cmp ax, 0
 je  .calcFATtype41
 xor eax, eax
 mov ax, [bs_tot_sect16]
 mov dword [bs_tot_sect32], eax
;-425 	DataSectors32=bs_tot_sect32 - templong;		

.calcFATtype41:
 mov eax, [bs_tot_sect32]
 sub eax, [bp-4]
 mov dword [DataSectors32], eax
;-426 

;-427 	templong =(long) bs_clust_size;		

 xor eax, eax
 mov al, [bs_clust_size]
 mov [bp-4], eax
;-428 	CountofClusters=DataSectors32 / templong;

 mov eax, [DataSectors32]
 xor edx, edx
 div dword [bp-4]
 mov dword [CountofClusters], eax
;-429 		

;-430 	Sectors_per_cylinder = bs_num_sects *  bs_num_sides;//d=w*w

 mov ax, [bs_num_sects]
;do not forget to save the high word:mov [Longvar+2],dx
 mul word [bs_num_sides]
 mov dword [Sectors_per_cylinder], eax
;-431 	asm mov [Sectors_per_cylinder + 2], dx;store high word

 mov [Sectors_per_cylinder + 2], dx;store high word
;-432 

;-433 	cputs(", trueFATtype=FAT"); 

 push calcFATtype_0
 call cputs
 add  sp, 2
;-434 	

;-435 	templong = (long) 65525;			

 xor eax, eax
 mov ax, 65525
 mov [bp-4], eax
;-436 	if (CountofClusters > templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jle .calcFATtype42
;-437 		trueFATtype=32; 

 mov ax, 32
 mov byte [trueFATtype], al
;-438 		cputs("32 NOT supported"); 

 push calcFATtype_1
 call cputs
 add  sp, 2
;-439 		return 1;

 mov ax, 1
 jmp .retncalcFATtype
;-440 		}

;-441 	templong= (long) 4086;

.calcFATtype42:
 xor eax, eax
 mov ax, 4086
 mov [bp-4], eax
;-442 	if (CountofClusters < templong) {

 mov eax, [CountofClusters]
 cmp eax, [bp-4]
 jge .calcFATtype43
;-443 		trueFATtype=12; 

 mov ax, 12
 mov byte [trueFATtype], al
;-444 		cputs("12"); 

 push calcFATtype_2
 call cputs
 add  sp, 2
;-445 		return 0;

 mov ax, 0
 jmp .retncalcFATtype
;-446 		}

;-447 	trueFATtype=16;

.calcFATtype43:
 mov ax, 16
 mov byte [trueFATtype], al
;-448 	cputs("16");

 push calcFATtype_3
 call cputs
 add  sp, 2
;-449 	return 0;

 mov ax, 0
 jmp .retncalcFATtype
;-450 }

;-451 

;-452 int Int13hExt() {

 .retncalcFATtype:
 LEAVE
 ret
calcFATtype_0 db ", trueFATtype=FAT",0
calcFATtype_1 db "32 NOT supported",0
calcFATtype_2 db "12",0
calcFATtype_3 db "16",0
ENDP

Int13hExt: PROC
;-453 	bx=0x55AA;

 mov  bx, 21930
;-454 	BIOS_Status=Int13hfunction(Drive, 0x41);	

 push 65
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hfunction
 add  sp, 4
 mov word [BIOS_Status], ax
;-455 	asm mov [vAX], ax;

 mov [vAX], ax;
;-456 	asm mov [vBX], bx; 0xAA55 Extension installed

 mov [vBX], bx; 0xAA55 Extension installed
;-457 	asm mov [vCX], cx; =1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx; =1: AH042h-44h,47h,48h supported 			
;-458 //	putch(10);

;-459 //	cputs("Int13h 41h Ext=");	printhex16(vAX);

;-460 //	cputs(", BIOS_Status=");	printhex16(BIOS_Status);

;-461 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt44
;-462 		cputs(" Ext NOT present");	

 push Int13hExt_0
 call cputs
 add  sp, 2
;-463 		Int13hError();	

 call Int13hError
;-464 		return 1;

 mov ax, 1
 jmp .retnInt13hExt
;-465 		}

;-466 	else {

 jmp .Int13hExt45
.Int13hExt44:
;-467 		cputs(",Extension found BX(AA55)=");printhex16(vBX);

 push Int13hExt_1
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-468 //		cputs(" CX=");						printhex16(vCX);

;-469 		}

;-470 	return 0;			

.Int13hExt45:
 mov ax, 0
 jmp .retnInt13hExt
;-471 }	

;-472 

;-473 int readLogical() {//IN:Sectors_to_read

 .retnInt13hExt:
 ret
Int13hExt_0 db " Ext NOT present",0
Int13hExt_1 db ",Extension found BX(AA55)=",0
ENDP

readLogical: PROC
;-474 	unsigned int track; unsigned int head; unsigned int sect;

;-475 	Sectors_to_read = Sectors_to_read + bs_hid_sects;//d=d+d

;Function : readLogical, Number local Var: 3
; # type sign width local variables
;63 var unsg word track = bp-2
;64 var unsg word head = bp-4
;65 var unsg word sect = bp-6;
 ENTER  6,0
 mov eax, [Sectors_to_read]
 add eax, [bs_hid_sects]
 mov dword [Sectors_to_read], eax
;-476 	track = Sectors_to_read / Sectors_per_cylinder;  //w=d/d

 mov eax, [Sectors_to_read]
 xor edx, edx
 div dword [Sectors_per_cylinder]
 mov [bp-2], ax
;-477 	head  = Sectors_to_read % Sectors_per_cylinder;  //w=d%d

 mov eax, [Sectors_to_read]
 xor edx, edx
 div dword [Sectors_per_cylinder]
 mov eax, edx
 mov [bp-4], ax
;-478 	sect  = head            % bs_num_sects; 	     //w=w%w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_num_sects]
 mov ax, dx
 mov [bp-6], ax
;-479 	sect++;

 inc  word[bp-6]
;-480 	head  = head            / bs_num_sects;			 //w=w/w

 mov ax, [bp-4]
 xor dx, dx
 div word [bs_num_sects]
 mov [bp-4], ax
;-481 

;-482 	DiskSectorReadWrite(2, bs_drive_num, head, track/* =cyl */,

;-483 		sect, 1, DiskBufSeg , DiskBuf);

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
;-484 	

;-485 //int DiskSectorReadWrite(char rw, char drive, char head, int cyl, 

;-486 //char sector, char count, int BufSeg, int BufOfs)

;-487 	

;-488 }

;-489 

;-490 int PrintDriveParameter() {

 LEAVE
 ret
ENDP

PrintDriveParameter: PROC
;-491 	unsigned long Lo;

;-492 // from Params

;-493 	cputs("CylHeadSec=");		printunsign(pa_Cylinders);

;Function : PrintDriveParameter, Number local Var: 1
; # type sign width local variables
;63 var unsg long Lo = bp-4;
 ENTER  4,0
 push PrintDriveParameter_0
 call cputs
 add  sp, 2
 push word [pa_Cylinders]
 call printunsign
 add  sp, 2
;-494 	putch('/');					printunsign(pa_Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-495 	putch('/');					printunsign(pa_Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [pa_Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-496 	cputs(", NoDrives=");		printhex8  (pa_Attached);

 push PrintDriveParameter_1
 call cputs
 add  sp, 2
 mov al, byte [pa_Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-497 	putch('.');

 push 46
 call putch
 add  sp, 2
;-498 //from getPartitionData

;-499 	putch(10);		

 push 10
 call putch
 add  sp, 2
;-500 	cputs("No=");			printunsign(pt_PartNo);

 push PrintDriveParameter_2
 call cputs
 add  sp, 2
 push word [pt_PartNo]
 call printunsign
 add  sp, 2
;-501 	cputs(",Boot=");		printhex8(pt_Bootable);

 push PrintDriveParameter_3
 call cputs
 add  sp, 2
 mov al, byte [pt_Bootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-502 	cputs(" ID=");			printunsign(pt_FileSystem);

 push PrintDriveParameter_4
 call cputs
 add  sp, 2
 mov al, byte [pt_FileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-503 	cputs(",HdSeCy=");		printunsign(pt_StartHead);

 push PrintDriveParameter_5
 call cputs
 add  sp, 2
 mov al, byte [pt_StartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-504 	cputs("/");				printunsign(pt_StartSector);	

 push PrintDriveParameter_6
 call cputs
 add  sp, 2
 mov al, byte [pt_StartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-505 	cputs("/");				printunsign(pt_StartCylinder);

 push PrintDriveParameter_7
 call cputs
 add  sp, 2
 push word [pt_StartCylinder]
 call printunsign
 add  sp, 2
;-506 	cputs("-");				printunsign(pt_EndHead);

 push PrintDriveParameter_8
 call cputs
 add  sp, 2
 mov al, byte [pt_EndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-507 	cputs("/");				printunsign(pt_EndSector);	

 push PrintDriveParameter_9
 call cputs
 add  sp, 2
 mov al, byte [pt_EndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-508 	cputs("/");				printunsign(pt_EndCylinder);

 push PrintDriveParameter_10
 call cputs
 add  sp, 2
 push word [pt_EndCylinder]
 call printunsign
 add  sp, 2
;-509 	cputs(",Start=");		printlong(&pt_HiddenSector);

 push PrintDriveParameter_11
 call cputs
 add  sp, 2
 lea  ax, [pt_HiddenSector]
 push ax
 call printlong
 add  sp, 2
;-510 	cputs(",Len=");			printlong(&pt_PartLen);

 push PrintDriveParameter_12
 call cputs
 add  sp, 2
 lea  ax, [pt_PartLen]
 push ax
 call printlong
 add  sp, 2
;-511 	cputs(" Sec=");

 push PrintDriveParameter_13
 call cputs
 add  sp, 2
;-512 	Lo = pt_PartLen >> 11;//sectors to MByte

 mov eax, [pt_PartLen]
 shr eax, 11
 mov [bp-4], eax
;-513 	printlong(&Lo);

 lea  ax, [bp-4]
 push ax
 call printlong
 add  sp, 2
;-514 	cputs(" MByte.");	

 push PrintDriveParameter_14
 call cputs
 add  sp, 2
;-515 	putch(10);

 push 10
 call putch
 add  sp, 2
;-516 //from getBootSector

;-517 	putch(10);

 push 10
 call putch
 add  sp, 2
;-518 	cputs("OEM name (MSDOS5.0)=");cputsLen(bs_sys_id,8);

 push PrintDriveParameter_15
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_sys_id]
 push ax
 call cputsLen
 add  sp, 4
;-519 	putch(10);

 push 10
 call putch
 add  sp, 2
;-520 	cputs("Bytes per sector(512)=");printunsign(bs_sect_size);	

 push PrintDriveParameter_16
 call cputs
 add  sp, 2
 push word [bs_sect_size]
 call printunsign
 add  sp, 2
;-521 	cputs(".Sectors per cluster(1,,128)=");printunsign(bs_clust_size);	

 push PrintDriveParameter_17
 call cputs
 add  sp, 2
 mov al, byte [bs_clust_size]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-522 	putch(10);

 push 10
 call putch
 add  sp, 2
;-523 	cputs("Reserved sectors=");printunsign(bs_res_sects);	

 push PrintDriveParameter_18
 call cputs
 add  sp, 2
 push word [bs_res_sects]
 call printunsign
 add  sp, 2
;-524 	cputs(".Number of FAT(1,2)=");printunsign(bs_num_fats);	

 push PrintDriveParameter_19
 call cputs
 add  sp, 2
 mov al, byte [bs_num_fats]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-525 	putch(10);

 push 10
 call putch
 add  sp, 2
;-526 	cputs("Root directory entries(512)=");printunsign(bs_root_entr);

 push PrintDriveParameter_20
 call cputs
 add  sp, 2
 push word [bs_root_entr]
 call printunsign
 add  sp, 2
;-527 	cputs(".Total sectors(0 if > 32MB=");printunsign(bs_tot_sect16);

 push PrintDriveParameter_21
 call cputs
 add  sp, 2
 push word [bs_tot_sect16]
 call printunsign
 add  sp, 2
;-528 	putch(10);

 push 10
 call putch
 add  sp, 2
;-529 	cputs("Media descriptor(F8h for HD)=");printhex8(bs_media_desc);

 push PrintDriveParameter_22
 call cputs
 add  sp, 2
 mov al, byte [bs_media_desc]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-530 	cputs(".Sectors per FAT=");printunsign(bs_fat_size);

 push PrintDriveParameter_23
 call cputs
 add  sp, 2
 push word [bs_fat_size]
 call printunsign
 add  sp, 2
;-531 	putch(10);

 push 10
 call putch
 add  sp, 2
;-532 	cputs("sectors per track=");printunsign(bs_num_sects);

 push PrintDriveParameter_24
 call cputs
 add  sp, 2
 push word [bs_num_sects]
 call printunsign
 add  sp, 2
;-533 	cputs(".number of heads=");printunsign(bs_num_sides);

 push PrintDriveParameter_25
 call cputs
 add  sp, 2
 push word [bs_num_sides]
 call printunsign
 add  sp, 2
;-534 	putch(10);

 push 10
 call putch
 add  sp, 2
;-535 	cputs("hidden sectors(long)=");printlong(&bs_hid_sects);

 push PrintDriveParameter_26
 call cputs
 add  sp, 2
 lea  ax, [bs_hid_sects]
 push ax
 call printlong
 add  sp, 2
;-536 	cputs(".sectors(long)=");printlong(&bs_tot_sect32);

 push PrintDriveParameter_27
 call cputs
 add  sp, 2
 lea  ax, [bs_tot_sect32]
 push ax
 call printlong
 add  sp, 2
;-537 	putch(10);

 push 10
 call putch
 add  sp, 2
;-538 	cputs("physical drive number=");printunsign(bs_drive_num);

 push PrintDriveParameter_28
 call cputs
 add  sp, 2
 mov al, byte [bs_drive_num]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-539 	cputs(".Windows NT check disk=");printunsign(bs_reserved);

 push PrintDriveParameter_29
 call cputs
 add  sp, 2
 mov al, byte [bs_reserved]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-540 	putch(10);

 push 10
 call putch
 add  sp, 2
;-541 	cputs("Extended signature(29h)=");printhex8(bs_ext_signat);

 push PrintDriveParameter_30
 call cputs
 add  sp, 2
 mov al, byte [bs_ext_signat]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-542 	cputs(".Volume serial(long)=");printlong(&bs_serial_num);

 push PrintDriveParameter_31
 call cputs
 add  sp, 2
 lea  ax, [bs_serial_num]
 push ax
 call printlong
 add  sp, 2
;-543 	putch(10);

 push 10
 call putch
 add  sp, 2
;-544 	cputs("Volume label(NO NAME)=");cputsLen(bs_label,11);

 push PrintDriveParameter_32
 call cputs
 add  sp, 2
 push 11
 lea  ax, [bs_label]
 push ax
 call cputsLen
 add  sp, 4
;-545 	cputs(".File system type(FAT16)=");cputsLen(bs_fs_id,8);		

 push PrintDriveParameter_33
 call cputs
 add  sp, 2
 push 8
 lea  ax, [bs_fs_id]
 push ax
 call cputsLen
 add  sp, 4
;-546 //from calcFATtype

;-547 	putch(10);

 push 10
 call putch
 add  sp, 2
;-548 	cputs("FatStartSector:");	printunsign(FatStartSector);

 push PrintDriveParameter_34
 call cputs
 add  sp, 2
 push word [FatStartSector]
 call printunsign
 add  sp, 2
;-549 	cputs(", FatSectors=");		printunsign(FatSectors);

 push PrintDriveParameter_35
 call cputs
 add  sp, 2
 push word [FatSectors]
 call printunsign
 add  sp, 2
;-550 	putch(10);

 push 10
 call putch
 add  sp, 2
;-551 	cputs("RootDirStartSector="); printunsign(RootDirStartSector);

 push PrintDriveParameter_36
 call cputs
 add  sp, 2
 push word [RootDirStartSector]
 call printunsign
 add  sp, 2
;-552 	cputs(", RootDirSectors=");	printunsign(RootDirSectors);

 push PrintDriveParameter_37
 call cputs
 add  sp, 2
 push word [RootDirSectors]
 call printunsign
 add  sp, 2
;-553 	putch(10);

 push 10
 call putch
 add  sp, 2
;-554 	cputs("DataStartSector=");	printunsign(DataStartSector);

 push PrintDriveParameter_38
 call cputs
 add  sp, 2
 push word [DataStartSector]
 call printunsign
 add  sp, 2
;-555 	cputs(", DataSectors32=");	printlong(&DataSectors32);			

 push PrintDriveParameter_39
 call cputs
 add  sp, 2
 lea  ax, [DataSectors32]
 push ax
 call printlong
 add  sp, 2
;-556 	putch(10);

 push 10
 call putch
 add  sp, 2
;-557 	cputs("CountofClusters=");	printlong(&CountofClusters);

 push PrintDriveParameter_40
 call cputs
 add  sp, 2
 lea  ax, [CountofClusters]
 push ax
 call printlong
 add  sp, 2
;-558 	cputs(", Sectors_per_cylinder="); printlong(&Sectors_per_cylinder);

 push PrintDriveParameter_41
 call cputs
 add  sp, 2
 lea  ax, [Sectors_per_cylinder]
 push ax
 call printlong
 add  sp, 2
;-559 	

;-560 }	

;-561 //------------------------------------ main ---------------

;-562 int main() {

 LEAVE
 ret
PrintDriveParameter_0 db "CylHeadSec=",0
PrintDriveParameter_1 db ", NoDrives=",0
PrintDriveParameter_2 db "No=",0
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
PrintDriveParameter_15 db "OEM name (MSDOS5.0)=",0
PrintDriveParameter_16 db "Bytes per sector(512)=",0
PrintDriveParameter_17 db ".Sectors per cluster(1,,128)=",0
PrintDriveParameter_18 db "Reserved sectors=",0
PrintDriveParameter_19 db ".Number of FAT(1,2)=",0
PrintDriveParameter_20 db "Root directory entries(512)=",0
PrintDriveParameter_21 db ".Total sectors(0 if > 32MB=",0
PrintDriveParameter_22 db "Media descriptor(F8h for HD)=",0
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
PrintDriveParameter_34 db "FatStartSector:",0
PrintDriveParameter_35 db ", FatSectors=",0
PrintDriveParameter_36 db "RootDirStartSector=",0
PrintDriveParameter_37 db ", RootDirSectors=",0
PrintDriveParameter_38 db "DataStartSector=",0
PrintDriveParameter_39 db ", DataSectors32=",0
PrintDriveParameter_40 db "CountofClusters=",0
PrintDriveParameter_41 db ", Sectors_per_cylinder=",0
ENDP

main: PROC
;-563 	int FATtype; char Errordrive;

;-564 	Errordrive=0;

;Function : main, Number local Var: 2
; # type sign width local variables
;63 var sign word FATtype = bp-2
;64 var sign byte Errordrive = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], al
;-565 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-566 	asm mov [DiskBufSeg], ds; 		//Offset is in DiskBuf

 mov [DiskBufSeg], ds; 		//Offset is in DiskBuf
;-567 

;-568 	if (Params()) Errordrive++;		//no hard disk

 call Params
 or  al, al
 je .main46
 inc  byte[bp-4]
;-569 	FATtype=readMBR();//0=error,1=FAT12,6=FAT16,11=FAT32

.main46:
 call readMBR
 mov [bp-2], ax
;-570 	if (FATtype == 0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .main47
;-571 		cputs(" no active FAT partition found");

 push main_0
 call cputs
 add  sp, 2
;-572 		Errordrive++;	

 inc  byte[bp-4]
;-573 		}

;-574 	if(getBootSector()==0) 	Errordrive++;

.main47:
 call getBootSector
 cmp al, 0
 jne .main48
 inc  byte[bp-4]
;-575 	if (calcFATtype())		Errordrive++;

.main48:
 call calcFATtype
 or  al, al
 je .main49
 inc  byte[bp-4]
;-576 	if(trueFATtype != 16) 	Errordrive++;

.main49:
 mov al, [trueFATtype]
 cmp al, 16
 je  .main50
 inc  byte[bp-4]
;-577 	Int13hExt();

.main50:
 call Int13hExt
;-578 //	if(Errordrive > 0) 

;-579 	PrintDriveParameter(); 

 call PrintDriveParameter
;-580 /*	

;-581 	Sectors_to_read = (long) 0;

;-582 	readLogical();

;-583 	getkey();

;-584 	mdump(DiskBuf, 512);

;-585 */	

;-586 }

 LEAVE
 ret
main_0 db " no active FAT partition found",0
ENDP
;Glob. variables:62 (400):696 (4000), Functions:30 (300):303 (3000)
;Lines:587, Constant: 1958 (3000), stacksize: 56831