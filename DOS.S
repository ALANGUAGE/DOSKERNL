;PLA compiler A.COM V1.0.1, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.1.4";//test bed

Version1 db "DOS.COM V0.1.4",0
;-2 //todo: resize and take own stack

;-3 //Finder / DOS1.vmdk / Rechtsclick / Öffnen / Parallels Mounter

;-4 #define ORGDATA		8192//start of arrays

;-5 unsigned int vAX;

vAX dw 0
;-6 unsigned int vBX;

vBX dw 0
;-7 unsigned int vCX;

vCX dw 0
;-8 unsigned int vDX;

vDX dw 0
;-9 unsigned int vSP;

vSP dw 0
;-10 unsigned int vBP;

vBP dw 0
;-11 unsigned int vCS;

vCS dw 0
;-12 unsigned int vDS;

vDS dw 0
;-13 unsigned int vSS;

vSS dw 0
;-14 unsigned int vES;

vES dw 0
;-15 

;-16 char DOS_ERR=0;

DOS_ERR db 0
;-17 unsigned int count21h=0;

count21h dw 0
;-18 

;-19 int writetty()     {//char in AL


writetty: PROC
;-20     ah=0x0E;

 mov  ah, 14
;-21     push bx;

push bx;
;-22     bx=0;			//page in BH

 mov  bx, 0
;-23     inth 0x10;		//16

 int  16
;-24     pop bx;

pop bx;
;-25 }

;-26 int putch(char c)  {

 ret
ENDP

putch: PROC
;-27     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;14 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-28         al=13;

 mov  al, 13
;-29         writetty();

 call writetty
;-30     }

;-31     al=c;

.putch1:
 mov  al, [bp+4]
;-32     writetty();

 call writetty
;-33 }

;-34 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-35     char c;

;-36     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;14 ptr sign byte s = bp+4
;15 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-37         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-38         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-39         s++;

 inc  word[bp+4]
;-40     }

;-41 }

 jmp .cputs2
.cputs3:
;-42 

;-43 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-44     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-45     inth 0x16;//AH=Scan code, AL=char

 int  22
;-46 }

;-47 int waitkey() {

 ret
ENDP

waitkey: PROC
;-48     ah=0x11;//get kbd status

 mov  ah, 17
;-49     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-50     //zero flag: 0=IS char, 1=NO char

;-51     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-52 }

;-53 int getkey() {

 ret
ENDP

getkey: PROC
;-54     waitkey();

 call waitkey
;-55     getch();

 call getch
;-56     ah=0;//clear scan code

 mov  ah, 0
;-57     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey4
 call getch
 add ax, 256
;-58     //put ext code in AX

;-59 }

.getkey4:
;-60 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-61     getkey();

 call getkey
;-62     writetty();//destroys AH

 call writetty
;-63 }

;-64 

;-65 int printhex4(unsigned char c) {

 ret
ENDP

printhex4: PROC
;-66     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;14 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-67     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex45
 add  byte[bp+4], 7
;-68     putch(c);

.printhex45:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-69 }

;-70 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-71     unsigned char nib;

;-72     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;14 var unsg byte c = bp+4
;15 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-73     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-74 }

;-75 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-76     unsigned int half;

;-77     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;14 var unsg word i = bp+4
;15 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-78     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-79 }

;-80 

;-81 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-82     unsigned int e;

;-83     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;14 var unsg word n = bp+4
;15 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign6
;-84         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-85         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-86         }

;-87     n=n%10;

.printunsign6:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-88     n+='0';

 add  word[bp+4], 48
;-89     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-90 }

;-91 

;-92 int memcpy(char *s, char *t, int i) {

 LEAVE
 ret
ENDP

memcpy: PROC
;-93 	unsigned int r;

;-94 	r = s;

;Function : memcpy, Number local Var: 4
; # type sign width local variables
;14 ptr sign byte s = bp+4
;15 ptr sign byte t = bp+6
;16 var sign word i = bp+8
;17 var unsg word r = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 mov [bp-2], ax
;-95 	do {

.memcpy7:
;-96 		*s = *t;

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-97 		s++; t++; i--;

 inc  word[bp+4]
 inc  word[bp+6]
 dec  word[bp+8]
;-98 	} while (i != 0);

 mov ax, [bp+8]
 cmp ax, 0
 je  .memcpy8
 jmp .memcpy7
.memcpy8:
;-99 	ax=r;//	return r;

 mov  ax, [bp-2]
;-100 }

;-101 

;-102 int printlong(unsigned int lo, unsigned int hi) {

 LEAVE
 ret
ENDP

printlong: PROC
;-103 // DX:AX DIV BX = AX remainder dx

;-104 	dx=hi;

;Function : printlong, Number local Var: 2
; # type sign width local variables
;14 var unsg word lo = bp+4
;15 var unsg word hi = bp+6;
 ENTER  0,0
 mov  dx, [bp+6]
;-105 	ax=lo;

 mov  ax, [bp+4]
;-106 __asm{	

	
;-107   	mov     bx,10          ;CONST

  	mov     bx,10          ;CONST
;-108     push    bx             ;Sentinel

    push    bx             ;Sentinel
;-109 .a: mov     cx,ax          ;Temporarily store LowDividend in CX

.a: mov     cx,ax          ;Temporarily store LowDividend in CX
;-110     mov     ax,dx          ;First divide the HighDividend

    mov     ax,dx          ;First divide the HighDividend
;-111     xor     dx,dx          ;Setup for division DX:AX / BX

    xor     dx,dx          ;Setup for division DX:AX / BX
;-112     div     bx             ; -> AX is HighQuotient, Remainder is re-used

    div     bx             ; -> AX is HighQuotient, Remainder is re-used
;-113     db		145;=91h xchg ax,cx;Temporarily move it to CX restoring LowDividend

    db		145;=91h xchg ax,cx;Temporarily move it to CX restoring LowDividend
;-114     div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]

    div     bx             ; -> AX is LowQuotient, Remainder DX=[0,9]
;-115     push    dx             ;(1) Save remainder for now

    push    dx             ;(1) Save remainder for now
;-116     mov     dx,cx          ;Build true 32-bit quotient in DX:AX

    mov     dx,cx          ;Build true 32-bit quotient in DX:AX
;-117     or      cx,ax          ;Is the true 32-bit quotient zero?

    or      cx,ax          ;Is the true 32-bit quotient zero?
;-118     jnz     .a             ;No, use as next dividend

    jnz     .a             ;No, use as next dividend
;-119     pop     ax             ;(1a) First pop (Is digit for sure)

    pop     ax             ;(1a) First pop (Is digit for sure)
;-120 .b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]

.b: add     al, 48;"0"     ;Turn into character [0,9] -> ["0","9"]
;-121 }


;-122     writetty();

 call writetty
;-123 __asm{


;-124     pop     ax             ;(1b) All remaining pops

    pop     ax             ;(1b) All remaining pops
;-125     cmp     ax,bx          ;Was it the sentinel?

    cmp     ax,bx          ;Was it the sentinel?
;-126     jb      .b             ;Not yet	

    jb      .b             ;Not yet	
;-127 }		


;-128 }

;-129 

;-130 char out10[10];

 LEAVE
 ret
ENDP
section .bss
absolute 8192
out10 resb 10
section .text
;-131 

;-132 int ultoa2(unsigned int l, unsigned int h, char *s) { int i;


ultoa2: PROC
;-133   i=0;  while(i<10) { *s = '0'; s++; i++; }   *s = 0;   s--;

;Function : ultoa2, Number local Var: 4
; # type sign width local variables
;15 var unsg word l = bp+4
;16 var unsg word h = bp+6
;17 ptr sign byte s = bp+8
;18 var sign word i = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
.ultoa29:
 mov ax, [bp-2]
 cmp ax, 10
 jge .ultoa210
 mov ax, 48
 mov  bx, [bp+8]
 mov  [bx], al
 inc  word[bp+8]
 inc  word[bp-2]
 jmp .ultoa29
.ultoa210:
 mov ax, 0
 mov  bx, [bp+8]
 mov  [bx], al
 dec  word[bp+8]
;-134 /*  

;-135 ;Function : ultoa2, Number local Var: 4

;-136 ; # type sign width local variables

;-137 ;15 var unsg word l = bp+4

;-138 ;16 var unsg word h = bp+6

;-139 ;17 ptr sign byte s = bp+8

;-140 ;18 var sign word i = bp-2;  */

;-141 __asm{


;-142   	mov eax, dword [bp+4]  ; l   edx:eax DIV ebx = eax Rest edx

  	mov eax, dword [bp+4]  ; l   edx:eax DIV ebx = eax Rest edx
;-143  .ul:xor edx, edx

 .ul:xor edx, edx
;-144  

 
;-145  	db 102	;66h for 32bit next instruction

 	db 102	;66h for 32bit next instruction
;-146   	mov bx, 10	; BB 0A 00

  	mov bx, 10	; BB 0A 00
;-147  	db 0		; imm is 4 bytes

 	db 0		; imm is 4 bytes
;-148  	db 0

 	db 0
;-149 ;  	mov ebx, 10	;not working, compiler error

;  	mov ebx, 10	;not working, compiler error
;-150   	

  	
;-151   	

  	
;-152  	div ebx

 	div ebx
;-153   	add dl, 48

  	add dl, 48
;-154   	mov [bp+8], dl  ; s

  	mov [bp+8], dl  ; s
;-155   	mov bx, [bp+8]

  	mov bx, [bp+8]
;-156   	mov [bx], dl

  	mov [bx], dl
;-157   	dec  word	[bp+8]  ; s--;

  	dec  word	[bp+8]  ; s--;
;-158   	cmp eax, 0	;66 83 F8 00 todo???

  	cmp eax, 0	;66 83 F8 00 todo???
;-159   	jnz .ul

  	jnz .ul
;-160   	mov ax, [bp+8]    

  	mov ax, [bp+8]    
;-161 }


;-162 }

;-163 

;-164 	

;-165 int ShowRegister() {

 LEAVE
 ret
ENDP

ShowRegister: PROC
;-166     asm mov [vAX], ax

 mov [vAX], ax
;-167     asm mov [vBX], bx

 mov [vBX], bx
;-168     asm mov [vCX], cx

 mov [vCX], cx
;-169     asm mov [vDX], dx

 mov [vDX], dx
;-170     asm mov [vSP], sp

 mov [vSP], sp
;-171     asm mov [vBP], bp

 mov [vBP], bp
;-172     asm mov ax, cs

 mov ax, cs
;-173     asm mov [vCS], ax

 mov [vCS], ax
;-174     asm mov ax, ds

 mov ax, ds
;-175     asm mov [vDS], ax

 mov [vDS], ax
;-176     asm mov ax, ss

 mov ax, ss
;-177     asm mov [vSS], ax

 mov [vSS], ax
;-178     asm mov ax, es

 mov ax, es
;-179     asm mov [vES], ax

 mov [vES], ax
;-180     putch(10);

 push 10
 call putch
 add  sp, 2
;-181     cputs( "AX="); printhex16(vAX);

 push ShowRegister_0
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-182     cputs(",BX="); printhex16(vBX);

 push ShowRegister_1
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-183     cputs(",CX="); printhex16(vCX);

 push ShowRegister_2
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-184     cputs(",DX="); printhex16(vDX);

 push ShowRegister_3
 call cputs
 add  sp, 2
 push word [vDX]
 call printhex16
 add  sp, 2
;-185     cputs(",SP="); printhex16(vSP);

 push ShowRegister_4
 call cputs
 add  sp, 2
 push word [vSP]
 call printhex16
 add  sp, 2
;-186     cputs(",BP="); printhex16(vBP);

 push ShowRegister_5
 call cputs
 add  sp, 2
 push word [vBP]
 call printhex16
 add  sp, 2
;-187     cputs(",CS="); printhex16(vCS);

 push ShowRegister_6
 call cputs
 add  sp, 2
 push word [vCS]
 call printhex16
 add  sp, 2
;-188     cputs(",DS="); printhex16(vDS);

 push ShowRegister_7
 call cputs
 add  sp, 2
 push word [vDS]
 call printhex16
 add  sp, 2
;-189     cputs(",SS="); printhex16(vSS);

 push ShowRegister_8
 call cputs
 add  sp, 2
 push word [vSS]
 call printhex16
 add  sp, 2
;-190     cputs(",ES="); printhex16(vES);

 push ShowRegister_9
 call cputs
 add  sp, 2
 push word [vES]
 call printhex16
 add  sp, 2
;-191 }

;-192 

;-193 //--------------------------------  disk IO  -------------------

;-194 char BIOS_ERR=0;

 ret
ShowRegister_0 db "AX=",0
ShowRegister_1 db ",BX=",0
ShowRegister_2 db ",CX=",0
ShowRegister_3 db ",DX=",0
ShowRegister_4 db ",SP=",0
ShowRegister_5 db ",BP=",0
ShowRegister_6 db ",CS=",0
ShowRegister_7 db ",DS=",0
ShowRegister_8 db ",SS=",0
ShowRegister_9 db ",ES=",0
ENDP
BIOS_ERR db 0
;-195 unsigned int  BIOS_Status=0;

BIOS_Status dw 0
;-196 char DiskBuf [512];

section .bss
absolute 8202
DiskBuf resb 512
section .text
;-197 char Drive;

Drive db 0
;-198 unsigned int  Cylinders;

Cylinders dw 0
;-199 char Sectors;

Sectors db 0
;-200 char Heads;

Heads db 0
;-201 char Attached;

Attached db 0
;-202 int  ParmTableSeg;

ParmTableSeg dw 0
;-203 int  ParmTableOfs;

ParmTableOfs dw 0
;-204 char DriveType;

DriveType db 0
;-205 int  PartNo;

PartNo dw 0
;-206 //hard disk partition structure

;-207 unsigned char ptBootable;	//80h = active partition, else 00

ptBootable db 0
;-208 unsigned char ptStartHead;	//

ptStartHead db 0
;-209 unsigned char ptStartSector;	//bits 0-5

ptStartSector db 0
;-210 unsigned int  ptStartCylinder;//bits 8,9 in bits 6,7 of sector

ptStartCylinder dw 0
;-211 unsigned char ptFileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=hugePart

ptFileSystem db 0
;-212 unsigned char ptEndHead;		//

ptEndHead db 0
;-213 unsigned char ptEndSector;	//bits 0-5

ptEndSector db 0
;-214 unsigned int  ptEndCylinder;	//bits 8,9 in bits 6,7 of sector

ptEndCylinder dw 0
;-215 unsigned int ptStartSectorlo;//sectors preceding partition

ptStartSectorlo dw 0
;-216 unsigned int ptStartSectorhi;

ptStartSectorhi dw 0
;-217 unsigned int ptPartLenlo;    //length of partition in sectors

ptPartLenlo dw 0
;-218 unsigned int ptPartLenhi;

ptPartLenhi dw 0
;-219 

;-220 int Int13hRW(char rw, char drive, char head, int cyl, char sector,


Int13hRW: PROC
;-221 	char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-222 	BIOS_ERR=0;	

;Function : Int13hRW, Number local Var: 8
; # type sign width local variables
;39 var sign byte rw = bp+4
;40 var sign byte drive = bp+6
;41 var sign byte head = bp+8
;42 var sign word cyl = bp+10
;43 var sign byte sector = bp+12
;44 var sign byte count = bp+14
;45 var sign word BufSeg = bp+16
;46 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-223 	dl=drive;

 mov  dl, [bp+6]
;-224 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-225 	es=BufSeg;

 mov  es, [bp+16]
;-226 	bx=BufOfs;

 mov  bx, [bp+18]
;-227 	cx=cyl;	

 mov  cx, [bp+10]
;-228 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-229 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-230 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-231 	cl += sector;

 add  cl, [bp+12]
;-232 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-233 	

;-234 	al=count;

 mov  al, [bp+14]
;-235 	ah=rw;

 mov  ah, [bp+4]
;-236 	inth 0x13;

 int  19
;-237     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-238 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-239 }

;-240 int Int13hRaw(char drive, char function) {

 LEAVE
 ret
ENDP

Int13hRaw: PROC
;-241 	BIOS_ERR=0;	

;Function : Int13hRaw, Number local Var: 2
; # type sign width local variables
;39 var sign byte drive = bp+4
;40 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-242 	dl=drive;

 mov  dl, [bp+4]
;-243 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-244 	inth 0x13;

 int  19
;-245     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-246 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-247 }

;-248 int Int13hError() {

 LEAVE
 ret
ENDP

Int13hError: PROC
;-249 	cputs("** DISK ERROR AX=");

 push Int13hError_0
 call cputs
 add  sp, 2
;-250 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-251 	cputs(".  ");

 push Int13hError_1
 call cputs
 add  sp, 2
;-252 	BIOS_Status=Int13hRaw(Drive, 0);//Reset

 push 0
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-253 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-254 }	

;-255 

;-256 int Params(char drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Params: PROC
;-257 	cputs("(AH=08)Drive Params:");

;Function : Params, Number local Var: 1
; # type sign width local variables
;39 var sign byte drive = bp+4;
 ENTER  0,0
 push Params_0
 call cputs
 add  sp, 2
;-258 	BIOS_Status=Int13hRaw(drive, 8);

 push 8
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-259 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Params11
 call Int13hError
;-260 	else {

 jmp .Params12
.Params11:
;-261 //		cputs("AH Return Code:");

;-262 //		printhex16(BIOS_Status);	

;-263 		asm mov [Heads],        dh

 mov [Heads],        dh
;-264 //		Heads++;

;-265 		asm mov [Attached],     dl

 mov [Attached],     dl
;-266 		// CX =       ---CH--- ---CL---

;-267 		// cylinder : 76543210 98

;-268 		// sector   :            543210	

;-269 		asm mov [Sectors],      cl

 mov [Sectors],      cl
;-270 		Sectors &= 0x3F;// 63

 and  byte[Sectors], 63
;-271 //		Sectors++;//1 to 64

;-272 	

;-273 		asm mov [Cylinders],    cx	

 mov [Cylinders],    cx	
;-274 		Cylinders &= 0xC0;//;bit 9 and 10 only

 and  word[Cylinders], 192
;-275 		Cylinders = Cylinders << 2;//compiler flaw:

 mov ax, [Cylinders]
 shl ax, 2
 mov word [Cylinders], ax
;-276 		asm add [Cylinders],    ch;//byte add, low byte is empty	

 add [Cylinders],    ch;//byte add, low byte is empty	
;-277 	

;-278 //		putch(10);

;-279 		cputs("CyHdSc=");			printunsign(Cylinders);

 push Params_1
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
;-280 		putch('/');					printunsign(Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-281 		putch('/');					printunsign(Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-282 		cputs(", NoDrives=");		printhex8(Attached);

 push Params_2
 call cputs
 add  sp, 2
 mov al, byte [Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-283 		putch('.');

 push 46
 call putch
 add  sp, 2
;-284 	}

;-285 }

.Params12:
;-286 

;-287 int Status(drive) {

 LEAVE
 ret
Params_0 db "(AH=08)Drive Params:",0
Params_1 db "CyHdSc=",0
Params_2 db ", NoDrives=",0
ENDP

Status: PROC
;-288 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;39 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-289 	cputs("(1)Status last Op=");

 push Status_0
 call cputs
 add  sp, 2
;-290 	BIOS_Status=Int13hRaw(drive, 1);	

 push 1
 push word [bp+4]
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-291 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Status13
 call Int13hError
;-292 	printhex16(BIOS_Status);	

.Status13:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-293 }	

;-294 

;-295 int getPartitionData() {

 LEAVE
 ret
Status_0 db "(1)Status last Op=",0
ENDP

getPartitionData: PROC
;-296 	unsigned int j; char c; char *p;

;-297 	j = PartNo << 4;

;Function : getPartitionData, Number local Var: 3
; # type sign width local variables
;39 var unsg word j = bp-2
;40 var sign byte c = bp-4
;41 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, [PartNo]
 shl ax, 4
 mov [bp-2], ax
;-298 	j = j + 0x1be;			ptBootable=DiskBuf[j];

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptBootable], al
;-299 	j++;					ptStartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartHead], al
;-300 	j++;					ptStartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartSector], al
;-301 	ah=0;//next line convert byte to word

 mov  ah, 0
;-302 	ptStartCylinder=ptStartSector;	

 mov al, [ptStartSector]
 mov word [ptStartCylinder], ax
;-303 	ptStartSector &= 0x3F;

 and  byte[ptStartSector], 63
;-304 //	ptStartSector++;//Sector start with 1 todo

;-305 	ptStartCylinder &= 0xC0;

 and  word[ptStartCylinder], 192
;-306 	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	

 mov ax, [ptStartCylinder]
 shl ax, 2
 mov word [ptStartCylinder], ax
;-307 	j++;

 inc  word[bp-2]
;-308 	ah=0;//byte 2 word

 mov  ah, 0
;-309 	ptStartCylinder=DiskBuf[j] + ptStartCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptStartCylinder]
 mov word [ptStartCylinder], ax
;-310 //	byte add, ok because low byte is empty

;-311 //	ptStartCylinder=ptStartCylinder + DiskBuf[j];//OK

;-312 

;-313 	j++;					ptFileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptFileSystem], al
;-314 	j++;					ptEndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndHead], al
;-315 	j++;					ptEndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndSector], al
;-316 	ah=0;//next line convert byte to word

 mov  ah, 0
;-317 	ptEndCylinder=ptEndSector;//see next 5 line		

 mov al, [ptEndSector]
 mov word [ptEndCylinder], ax
;-318 	ptEndSector &= 0x3F;

 and  byte[ptEndSector], 63
;-319 //	ptEndSector++;//Sector start with 1 todo

;-320 	ptEndCylinder &= 0xC0;

 and  word[ptEndCylinder], 192
;-321 	ptEndCylinder = ptEndCylinder << 2;//OK no short cut!	

 mov ax, [ptEndCylinder]
 shl ax, 2
 mov word [ptEndCylinder], ax
;-322 	j++;

 inc  word[bp-2]
;-323 	ah=0;//byte 2 word

 mov  ah, 0
;-324 	ptEndCylinder=DiskBuf[j] + ptEndCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptEndCylinder]
 mov word [ptEndCylinder], ax
;-325 //	byte add, ok because low byte is empty

;-326 //	ptStartCylinder=ptStartCylinder + DiskBuf[j];//OK

;-327 	

;-328 	j++;

 inc  word[bp-2]
;-329 	p = j + &DiskBuf;//copy ptStartSector, ptPartLen

 mov ax, [bp-2]
 add ax, DiskBuf
 mov [bp-6], ax
;-330 	memcpy(&ptStartSectorlo, p, 8);

 push 8
 push word [bp-6]
 lea  ax, [ptStartSectorlo]
 push ax
 call memcpy
 add  sp, 6
;-331 	

;-332 	j += 8;//next partition entry

 add  word[bp-2], 8
;-333 }

;-334 	

;-335 int printPartitionData() {

 LEAVE
 ret
ENDP

printPartitionData: PROC
;-336 	putch(10);		

 push 10
 call putch
 add  sp, 2
;-337 	cputs("No=");			printunsign(PartNo);

 push printPartitionData_0
 call cputs
 add  sp, 2
 push word [PartNo]
 call printunsign
 add  sp, 2
;-338 	cputs(",Boot=");		printhex8(ptBootable);

 push printPartitionData_1
 call cputs
 add  sp, 2
 mov al, byte [ptBootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-339 	cputs(" ID=");			printunsign(ptFileSystem);

 push printPartitionData_2
 call cputs
 add  sp, 2
 mov al, byte [ptFileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-340 	cputs(",HdSeCy=");		printunsign(ptStartHead);

 push printPartitionData_3
 call cputs
 add  sp, 2
 mov al, byte [ptStartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-341 	cputs("/");				printunsign(ptStartSector);	

 push printPartitionData_4
 call cputs
 add  sp, 2
 mov al, byte [ptStartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-342 	cputs("/");				printunsign(ptStartCylinder);

 push printPartitionData_5
 call cputs
 add  sp, 2
 push word [ptStartCylinder]
 call printunsign
 add  sp, 2
;-343 	cputs("-");				printunsign(ptEndHead);

 push printPartitionData_6
 call cputs
 add  sp, 2
 mov al, byte [ptEndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-344 	cputs("/");				printunsign(ptEndSector);	

 push printPartitionData_7
 call cputs
 add  sp, 2
 mov al, byte [ptEndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-345 	cputs("/");				printunsign(ptEndCylinder);

 push printPartitionData_8
 call cputs
 add  sp, 2
 push word [ptEndCylinder]
 call printunsign
 add  sp, 2
;-346 //	putch(10);		

;-347 	cputs(",St=");

 push printPartitionData_9
 call cputs
 add  sp, 2
;-348 	printunsign(ptStartSectorhi);

 push word [ptStartSectorhi]
 call printunsign
 add  sp, 2
;-349 	putch(':');

 push 58
 call putch
 add  sp, 2
;-350 	printunsign(ptStartSectorlo);

 push word [ptStartSectorlo]
 call printunsign
 add  sp, 2
;-351 	putch('.');

 push 46
 call putch
 add  sp, 2
;-352 	printlong(ptStartSectorlo, ptStartSectorhi);

 push word [ptStartSectorhi]
 push word [ptStartSectorlo]
 call printlong
 add  sp, 4
;-353 	cputs(",Len=");

 push printPartitionData_10
 call cputs
 add  sp, 2
;-354 	printunsign(ptPartLenhi);

 push word [ptPartLenhi]
 call printunsign
 add  sp, 2
;-355 	putch(':');

 push 58
 call putch
 add  sp, 2
;-356 	printunsign(ptPartLenlo);

 push word [ptPartLenlo]
 call printunsign
 add  sp, 2
;-357 	

;-358 	putch('.');

 push 46
 call putch
 add  sp, 2
;-359 	printlong(ptPartLenlo, ptPartLenhi);

 push word [ptPartLenhi]
 push word [ptPartLenlo]
 call printlong
 add  sp, 4
;-360 }

;-361 	

;-362 int testDisk(drive) {

 ret
printPartitionData_0 db "No=",0
printPartitionData_1 db ",Boot=",0
printPartitionData_2 db " ID=",0
printPartitionData_3 db ",HdSeCy=",0
printPartitionData_4 db "/",0
printPartitionData_5 db "/",0
printPartitionData_6 db "-",0
printPartitionData_7 db "/",0
printPartitionData_8 db "/",0
printPartitionData_9 db ",St=",0
printPartitionData_10 db ",Len=",0
ENDP

testDisk: PROC
;-363 	char c; int i;

;-364 	asm mov [ParmTableSeg], ds

;Function : testDisk, Number local Var: 3
; # type sign width local variables
;39 var sign word drive = bp+4
;40 var sign byte c = bp-2
;41 var sign word i = bp-4;
 ENTER  4,0
 mov [ParmTableSeg], ds
;-365 	//Offset is in DiskBuf

;-366 	BIOS_Status=Int13hRW(2,drive,0,0,1,1,ParmTableSeg,DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 push word [ParmTableSeg]
 push 1
 push 1
 push 0
 push 0
 push word [bp+4]
 push 2
 call Int13hRW
 add  sp, 16
 mov word [BIOS_Status], ax
;-367 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .testDisk14
 call Int13hError
;-368 	else {	

 jmp .testDisk15
.testDisk14:
;-369 		putch(10);

 push 10
 call putch
 add  sp, 2
;-370 		cputs("Read Partition Status:");

 push testDisk_0
 call cputs
 add  sp, 2
;-371 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-372 		cputs(",MBR Magic=");	

 push testDisk_1
 call cputs
 add  sp, 2
;-373 		i=510;		c = DiskBuf[i];		printhex8(c);

 mov ax, 510
 mov [bp-4], ax
 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-374 		i++;		c = DiskBuf[i];		printhex8(c);

 inc  word[bp-4]
 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-375 		

;-376 		cputs(",DiskBuf=");

 push testDisk_2
 call cputs
 add  sp, 2
;-377 		printhex16(ParmTableSeg);

 push word [ParmTableSeg]
 call printhex16
 add  sp, 2
;-378 		putch(':');							

 push 58
 call putch
 add  sp, 2
;-379 		printhex16(DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 call printhex16
 add  sp, 2
;-380 		putch('.');

 push 46
 call putch
 add  sp, 2
;-381 	

;-382 		PartNo=0;

 mov ax, 0
 mov word [PartNo], ax
;-383 		do {

.testDisk16:
;-384 			getPartitionData();

 call getPartitionData
;-385 			printPartitionData();

 call printPartitionData
;-386 			PartNo ++;

 inc  word[PartNo]
;-387 		} while (PartNo <4);

 mov ax, [PartNo]
 cmp ax, 4
 jge .testDisk17
 jmp .testDisk16
.testDisk17:
;-388 	}	

;-389 }

.testDisk15:
;-390 

;-391 int Int13hExt(char drive) {

 LEAVE
 ret
testDisk_0 db "Read Partition Status:",0
testDisk_1 db ",MBR Magic=",0
testDisk_2 db ",DiskBuf=",0
ENDP

Int13hExt: PROC
;-392 	putch(10);

;Function : Int13hExt, Number local Var: 1
; # type sign width local variables
;39 var sign byte drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-393 	cputs("Int13h 41hExt AX=");

 push Int13hExt_0
 call cputs
 add  sp, 2
;-394 	bx=0x55AA;

 mov  bx, 21930
;-395 	BIOS_Status=Int13hRaw(0x80, 0x41);	

 push 65
 push 128
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-396 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-397 	if (BIOS_ERR) {

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt18
;-398 		cputs(" not present");	

 push Int13hExt_1
 call cputs
 add  sp, 2
;-399 		Int13hError();	

 call Int13hError
;-400 		}

;-401 	else {

 jmp .Int13hExt19
.Int13hExt18:
;-402 		cputs(" status=1:supported");

 push Int13hExt_2
 call cputs
 add  sp, 2
;-403 		asm mov [vBX], bx;0xAA55 Extension installed

 mov [vBX], bx;0xAA55 Extension installed
;-404 		asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			
;-405 		cputs(" BX=");		printhex16(vBX);

 push Int13hExt_3
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-406 		cputs(" CX=");		printhex16(vCX);

 push Int13hExt_4
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-407 		}		

;-408 }	

.Int13hExt19:
;-409 

;-410 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
Int13hExt_0 db "Int13h 41hExt AX=",0
Int13hExt_1 db " not present",0
Int13hExt_2 db " status=1:supported",0
Int13hExt_3 db " BX=",0
Int13hExt_4 db " CX=",0
ENDP

mdump: PROC
;-411     unsigned char c;

;-412     int i;

;-413     int j;

;-414     int k;

;-415     j=0;

;Function : mdump, Number local Var: 6
; # type sign width local variables
;39 ptr unsg byte adr = bp+4
;40 var unsg word len = bp+6
;41 var unsg byte c = bp-2
;42 var sign word i = bp-4
;43 var sign word j = bp-6
;44 var sign word k = bp-8;
 ENTER  8,0
 mov ax, 0
 mov [bp-6], ax
;-416     k=0;

 mov ax, 0
 mov [bp-8], ax
;-417     while (j < len ) {

.mdump20:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump21
;-418 	    k++;; 

 inc  word[bp-8]
;-419 	    if (k > 8) {

 mov ax, [bp-8]
 cmp ax, 8
 jle .mdump22
;-420 		    getkey();

 call getkey
;-421 		    k=1;

 mov ax, 1
 mov [bp-8], ax
;-422 		    }

;-423         putch(10);

.mdump22:
 push 10
 call putch
 add  sp, 2
;-424         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-425         putch(':');

 push 58
 call putch
 add  sp, 2
;-426         i=0;

 mov ax, 0
 mov [bp-4], ax
;-427         while (i < 16) {

.mdump23:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump24
;-428             putch(' ');

 push 32
 call putch
 add  sp, 2
;-429             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-430             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-431             adr++;

 inc  word[bp+4]
;-432             i++;

 inc  word[bp-4]
;-433             j++;

 inc  word[bp-6]
;-434             }

;-435         putch(' ');

 jmp .mdump23
.mdump24:
 push 32
 call putch
 add  sp, 2
;-436         adr -=16;

 sub  word[bp+4], 16
;-437         i=0;

 mov ax, 0
 mov [bp-4], ax
;-438         while(i < 16) {

.mdump25:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump26
;-439             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-440             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump27
 push 46
 call putch
 add  sp, 2
;-441                 else putch(c);

 jmp .mdump28
.mdump27:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-442             adr++;

.mdump28:
 inc  word[bp+4]
;-443             i++;

 inc  word[bp-4]
;-444         }

;-445     }

 jmp .mdump25
.mdump26:
;-446 }

 jmp .mdump20
.mdump21:
;-447 

;-448 //------------------------------------ main ---------------

;-449 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-450 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-451 	

;-452 	Params(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Params
 add  sp, 2
;-453 	testDisk(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call testDisk
 add  sp, 2
;-454 //	getkey();

;-455 //	mdump(DiskBuf, 512);

;-456 	Int13hExt(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hExt
 add  sp, 2
;-457 }

 ret
ENDP
;Glob. variables:38 (400):341 (4000), Functions:26 (300):241 (3000)
;Lines:458, Constant: 366 (3000), stacksize: 56821