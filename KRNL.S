;PLA compiler A.COM V0.9.6, Input: KRNL.C, Output: KRNL.S
org  256 
jmp main
;-1 char Version1[]="KERNEL.COM V0.1b";

Version1 db "KERNEL.COM V0.1b",0
;-2 //--------------------------- Bios Routines I/O ---------------------

;-3 int writetty()     {//char in AL


writetty: PROC
;-4     ah=0x0E;

 mov  ah, 14
;-5     asm push bx

 push bx
;-6     bx=0;     //page in BH

 mov  bx, 0
;-7     inth 0x10;

 int  16
;-8     asm pop bx

 pop bx
;-9 }

;-10 int putch(char c)  {

 ret
ENDP

putch: PROC
;-11     if (c==10)  {// LF
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-12         al=13;   // CR, write CR first and then LF

 mov  al, 13
;-13         writetty();

 call writetty
;-14     }

;-15     al=c;

.putch1:
 mov  al, [bp+4]
;-16     writetty();

 call writetty
;-17 }

;-18 int cputs(char *s) {//only with correct DS !!!

 LEAVE
 ret
ENDP

cputs: PROC
;-19     char c;

;-20     while(*s) {
;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-21         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-22         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-23         s++;

 inc  word[bp+4]
;-24     }

;-25 }

 jmp .cputs2
.cputs3:
;-26 

;-27 int printhex4(unsigned char c) {

 LEAVE
 ret
ENDP

printhex4: PROC
;-28     c += 48;
;
 ENTER  0,0
 add  byte[bp+4], 48
;-29     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex44
 add  byte[bp+4], 7
;-30     putch(c);

.printhex44:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-31 }

;-32 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-33     unsigned char nib;

;-34     nib = c >> 4; printhex4(nib);
;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-35     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-36 }

;-37 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-38     unsigned int half;

;-39     half = i >>  8; printhex8(half);
;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-40     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-41 }

;-42 

;-43 int printunsign(unsigned int n) {

 LEAVE
 ret
ENDP

printunsign: PROC
;-44     unsigned int e;

;-45     if (n >= 10) {
;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign5
;-46         e=n/10;

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-47         printunsign(e);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-48         }

;-49     n=n%10;

.printunsign5:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-50     n+='0';

 add  word[bp+4], 48
;-51     putch(n);

 push word [bp+4]
 call putch
 add  sp, 2
;-52 }

;-53 

;-54 int getch() {

 LEAVE
 ret
ENDP

getch: PROC
;-55     ah=0x10;//MF2-KBD read char

 mov  ah, 16
;-56     inth 0x16;//AH=Scan code, AL=char

 int  22
;-57 }

;-58 int waitkey() {

 ret
ENDP

waitkey: PROC
;-59     ah=0x11;//get kbd status

 mov  ah, 17
;-60     inth 0x16;//AH:Scan code, AL:char read, resting in buffer

 int  22
;-61     //zero flag: 0=IS char, 1=NO char

;-62     __emit__(0x74,0xFA);// jz back 2 bytes until char read

 db 116,250
;-63 }

;-64 int getkey() {

 ret
ENDP

getkey: PROC
;-65     waitkey();

 call waitkey
;-66     getch();

 call getch
;-67     ah=0;//clear scan code

 mov  ah, 0
;-68     if (al == 0) getch() + 0x100;

 cmp  al, 0
 jne .getkey6
 call getch
 add ax, 256
;-69     //put ext code in AX

;-70 }

.getkey6:
;-71 int kbdEcho() {

 ret
ENDP

kbdEcho: PROC
;-72     getkey();

 call getkey
;-73     writetty();//destroys AH

 call writetty
;-74 }

;-75 // ------------------------- Bios Functions -------------------------

;-76 int BCDtoChar(char BCD) { // converts 2 digit packed BCD

 ret
ENDP

BCDtoChar: PROC
;-77     char LowNibble;       // to Integer

;-78     LowNibble = BCD & 0xF;// save ones digit
;
 ENTER  2,0
 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
;-79     BCD >> 4;// extract tens digit, result in AX

 mov al, [bp+4]
 shr al, 4
;-80     asm push dx

 push dx
;-81     dl = 10;

 mov  dl, 10
;-82     asm mul dl; result in AX

 mul dl; result in AX
;-83     asm pop dx

 pop dx
;-84     al += LowNibble;

 add  al, [bp-2]
;-85     ah=0;//result is byte

 mov  ah, 0
;-86 }

;-87 //---------------------------- Kernel Data Area ---------------------

;-88 char KERNEL_ERR=0;

 LEAVE
 ret
ENDP
KERNEL_ERR db 0
;-89 unsigned int count18h=0;// counts all interrups calls

count18h dw 0
;-90 char cent;char year;char month;char day;

cent db 0
year db 0
month db 0
day db 0
;-91 char hour; char min; char sec;

hour db 0
min db 0
sec db 0
;-92 unsigned int mode_IOData=0x8280;

mode_IOData dw 33408
;-93 char Buf[]="123456789012345678";

Buf db "123456789012345678",0
;-94 

;-95 

;-96 //--------------------------- Kernel Routines -----------------------

;-97 int KernelInt() {


KernelInt: PROC
;-98     inth 0x18;

 int  24
;-99     __emit__(0x73, 04); //jnc over KERNEL_ERR++

 db 115,4
;-100     KERNEL_ERR++;

 inc  byte[KERNEL_ERR]
;-101 }

;-102 unsigned int VecOldOfs;

 ret
ENDP
VecOldOfs dw 0
;-103 unsigned int VecOldSeg;

VecOldSeg dw 0
;-104 unsigned int count=0;

count dw 0
;-105 

;-106 int GetIntVec(char c) {


GetIntVec: PROC
;-107     asm push es
;
 ENTER  0,0
 push es
;-108     al=c;

 mov  al, [bp+4]
;-109     ah=0x35;

 mov  ah, 53
;-110     KernelInt();

 call KernelInt
;-111     __emit__(0x2E);//CS override

 db 46
;-112     asm mov [VecOldOfs], bx

 mov [VecOldOfs], bx
;-113     __emit__(0x2E);//CS override

 db 46
;-114     asm mov [VecOldSeg], es

 mov [VecOldSeg], es
;-115     asm pop es

 pop es
;-116 }

;-117 

;-118 //--------------------------- Start of new Interrupt 18h ------------

;-119 int KERNEL_START() {

 LEAVE
 ret
ENDP

KERNEL_START: PROC
;-120     count18h++;

 inc  word[count18h]
;-121     asm sti; set interrupt enable

 sti; set interrupt enable
;-122 

;-123     if (ah==0x01) {//Read Keyboard and Echo

 cmp  ah, 1
 jne .KERNEL_START7
;-124         kbdEcho();

 call kbdEcho
;-125         asm iret

 iret
;-126     }

;-127     if (ah==0x02) {//Display Character

.KERNEL_START7:
 cmp  ah, 2
 jne .KERNEL_START8
;-128         al=dl;

 mov  al, dl
;-129         writetty();

 call writetty
;-130         asm iret

 iret
;-131     }

;-132     if (ah==0x06) {//Direct Console I/O

.KERNEL_START8:
 cmp  ah, 6
 jne .KERNEL_START9
;-133         if (dl == 0xFF) {// then read character

 cmp  dl, 255
 jne .KERNEL_START10
;-134             getch();

 call getch
;-135             asm iret

 iret
;-136         }

;-137         al=dl;           // else display character

.KERNEL_START10:
 mov  al, dl
;-138         writetty();

 call writetty
;-139         asm iret

 iret
;-140     }

;-141     if (ah==0x07) {//Direct Console Input

.KERNEL_START9:
 cmp  ah, 7
 jne .KERNEL_START11
;-142         getch();

 call getch
;-143         asm iret

 iret
;-144     }

;-145     if (ah==0x09) {//display string in DS:DX

.KERNEL_START11:
 cmp  ah, 9
 jne .KERNEL_START12
;-146         asm push si

 push si
;-147         si=dx;

 mov  si, dx
;-148         asm cld; clear direction, string up

 cld; clear direction, string up
;-149         asm lodsb; from DS:SI to AL

 lodsb; from DS:SI to AL
;-150         while (al != '$') {

.KERNEL_START13:
 cmp  al, 36
 je  .KERNEL_START14
;-151             writetty();

 call writetty
;-152             asm lodsb

 lodsb
;-153         }

;-154         asm pop si

 jmp .KERNEL_START13
.KERNEL_START14:
 pop si
;-155         asm iret

 iret
;-156     }

;-157 

;-158     if (ah==0x25) {//setIntVec in AL from DS:DX

.KERNEL_START12:
 cmp  ah, 37
 jne .KERNEL_START15
;-159         asm cli; clear int enable, turn OFF int

 cli; clear int enable, turn OFF int
;-160         asm push ax

 push ax
;-161         asm push es

 push es
;-162         asm push di

 push di
;-163         asm push ds; later pop ax

 push ds; later pop ax
;-164         ax << 2;

 shl  ax, 2
;-165         ah=0;

 mov  ah, 0
;-166         di=ax;

 mov  di, ax
;-167         ax=0;

 mov  ax, 0
;-168         es=ax;//segment 0

 mov  es, ax
;-169         ax=dx;

 mov  ax, dx
;-170         asm cld; clear direction, string up

 cld; clear direction, string up
;-171         asm stosw; ofs in DX to ES:DI

 stosw; ofs in DX to ES:DI
;-172         asm pop ax; get DS

 pop ax; get DS
;-173         asm stosw; seg (DS) to ES:DI+2

 stosw; seg (DS) to ES:DI+2
;-174         asm pop di

 pop di
;-175         asm pop es

 pop es
;-176         asm pop ax

 pop ax
;-177         asm sti;set int enable, turn ON int

 sti;set int enable, turn ON int
;-178         asm iret

 iret
;-179     }

;-180     if (ah==0x2A) {//GetDate

.KERNEL_START15:
 cmp  ah, 42
 jne .KERNEL_START16
;-181         ah=4;

 mov  ah, 4
;-182         inth 0x1A;

 int  26
;-183         __emit__(0x73, 04); //jnc over KERNEL_ERR++

 db 115,4
;-184         KERNEL_ERR++;

 inc  byte[KERNEL_ERR]
;-185         asm mov [cent], ch; cent ... are used by GetDate

 mov [cent], ch; cent ... are used by GetDate
;-186         asm mov [year], cl

 mov [year], cl
;-187         asm mov [month],dh

 mov [month],dh
;-188         asm mov [day],  dl

 mov [day],  dl
;-189         if (KERNEL_ERR > 0) cputs("ERROR no RTC");

 mov al, [KERNEL_ERR]
 cmp al, 0
 jle .KERNEL_START17
 push KERNEL_START_0
 call cputs
 add  sp, 2
;-190         cent=BCDtoChar(cent);

.KERNEL_START17:
 mov al, byte [cent]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [cent], al
;-191         year=BCDtoChar(year);

 mov al, byte [year]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [year], al
;-192         month=BCDtoChar(month);

 mov al, byte [month]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [month], al
;-193         day=BCDtoChar(day);

 mov al, byte [day]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [day], al
;-194         ch=0;

 mov  ch, 0
;-195         cl=year;

 mov  cl, [year]
;-196         asm add cx, 2000; add century

 add cx, 2000; add century
;-197         dh=month;

 mov  dh, [month]
;-198         dl=day;

 mov  dl, [day]
;-199         asm iret

 iret
;-200     }

;-201     if (ah==0x2C) {//GetTime, NO 1/100 sec

.KERNEL_START16:
 cmp  ah, 44
 jne .KERNEL_START18
;-202         ah=2;

 mov  ah, 2
;-203         inth 0x1A;

 int  26
;-204         __emit__(0x73, 04); //jnc over KERNEL_ERR++

 db 115,4
;-205         KERNEL_ERR++;

 inc  byte[KERNEL_ERR]
;-206         asm mov [hour], ch

 mov [hour], ch
;-207         asm mov [min],  cl

 mov [min],  cl
;-208         asm mov [sec],  dh

 mov [sec],  dh
;-209         if (KERNEL_ERR > 0) cputs("ERROR no RTC");

 mov al, [KERNEL_ERR]
 cmp al, 0
 jle .KERNEL_START19
 push KERNEL_START_1
 call cputs
 add  sp, 2
;-210         hour=BCDtoChar(hour);

.KERNEL_START19:
 mov al, byte [hour]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [hour], al
;-211         min=BCDtoChar(min);

 mov al, byte [min]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [min], al
;-212         sec=BCDtoChar(sec);

 mov al, byte [sec]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [sec], al
;-213         ch=hour;

 mov  ch, [hour]
;-214         cl=min;

 mov  cl, [min]
;-215         dh=sec;

 mov  dh, [sec]
;-216         dl=0;// NO 1/100 sec

 mov  dl, 0
;-217         asm iret

 iret
;-218     }

;-219     if (ah==0x30) {//getDosVer

.KERNEL_START18:
 cmp  ah, 48
 jne .KERNEL_START20
;-220         ax=0x1E03; //Ver 3.30

 mov  ax, 7683
;-221         asm iret

 iret
;-222     }

;-223     if (ah==0x33) {//Control C Check (break)

.KERNEL_START20:
 cmp  ah, 51
 jne .KERNEL_START21
;-224         al=0xFF;// error for all subcodes

 mov  al, 255
;-225         dl=0;// always off

 mov  dl, 0
;-226         asm iret

 iret
;-227     }

;-228     if (ah==0x35) {//getIntVec in AL to ES:BX

.KERNEL_START21:
 cmp  ah, 53
 jne .KERNEL_START22
;-229         asm cli; clear int enable, turn OFF int

 cli; clear int enable, turn OFF int
;-230         asm push ds

 push ds
;-231         bx=0;

 mov  bx, 0
;-232         ds=bx;  //Int table starts at 0000

 mov  ds, bx
;-233         bl=al;

 mov  bl, al
;-234         bx << 2;//int is 4 bytes long

 shl  bx, 2
;-235         asm les bx, [bx]; ofs in bx, seg in es

 les bx, [bx]; ofs in bx, seg in es
;-236         asm pop ds

 pop ds
;-237         asm sti; set int enable, turn ON int

 sti; set int enable, turn ON int
;-238         asm iret

 iret
;-239     }

;-240 

;-241 //todo backspace not counting correct

;-242     if (ah==0x3F) {   //read file or device

.KERNEL_START22:
 cmp  ah, 63
 jne .KERNEL_START23
;-243         if (bx == 0) {//BX = handle = stdin only

 cmp  bx, 0
 jne .KERNEL_START24
;-244                       //CX = bytes to Read

;-245                       //DS:DX buffer

;-246             asm push bx;buffer in DS:DX

 push bx;buffer in DS:DX
;-247             count=0;

 mov ax, 0
 mov word [count], ax
;-248             bx=dx;//set offset to index register, loose handle

 mov  bx, dx
;-249             while (cx > 0) {//number to read

.KERNEL_START25:
 cmp  cx, 0
 jle .KERNEL_START26
;-250                 getkey();

 call getkey
;-251                 //check for extended code AH=1

;-252                 asm mov [bx], al;//DS:BX is buffer

 mov [bx], al;//DS:BX is buffer
;-253                 writetty();

 call writetty
;-254                 asm inc bx

 inc bx
;-255                 asm dec cx;count down of bytes to read

 dec cx;count down of bytes to read
;-256                 count++;

 inc  word[count]
;-257                 // use as a cooked input stream

;-258                 if (al ==  8) {//Backspace, delete 1 character

 cmp  al, 8
 jne .KERNEL_START27
;-259                     if (count > 0) {// at least 1 character

 mov ax, [count]
 cmp ax, 0
 jle .KERNEL_START28
;-260                         //putch(8); already written 7 lines up

;-261                         putch(' ');

 push 32
 call putch
 add  sp, 2
;-262                         putch(8);

 push 8
 call putch
 add  sp, 2
;-263                         asm inc cx; remove the dec cx above

 inc cx; remove the dec cx above
;-264                         asm inc cx; 1 more char to read

 inc cx; 1 more char to read
;-265                         asm dec bx; remove the inc bx above

 dec bx; remove the inc bx above
;-266                         asm dec bx;remove 1 char from input string

 dec bx;remove 1 char from input string
;-267                         count-=2;

 sub  word[count], 2
;-268                     }

;-269                 }

.KERNEL_START28:
;-270                 if (al == 13) {//send LF=10 after CR=13

.KERNEL_START27:
 cmp  al, 13
 jne .KERNEL_START29
;-271                     al=10;

 mov  al, 10
;-272                     asm mov [bx], al;//DS:BX is buffer

 mov [bx], al;//DS:BX is buffer
;-273                     writetty();

 call writetty
;-274                     asm inc bx

 inc bx
;-275                     cx=0;// leave the while loop

 mov  cx, 0
;-276                     count++;

 inc  word[count]
;-277                 }

;-278             }

.KERNEL_START29:
;-279             asm pop bx

 jmp .KERNEL_START25
.KERNEL_START26:
 pop bx
;-280             ax=count;//bytes read

 mov  ax, [count]
;-281             asm iret;   carry=error

 iret;   carry=error
;-282         }

;-283         ax=6;//error handle invalid, not 0

.KERNEL_START24:
 mov  ax, 6
;-284         asm stc

 stc
;-285         asm iret

 iret
;-286     }

;-287     if (ah==0x40) {//write to file or device

.KERNEL_START23:
 cmp  ah, 64
 jne .KERNEL_START30
;-288         if (bx <= 2) {//handle = stdin,stdout,error device

 cmp  bx, 2
 ja  .KERNEL_START31
;-289             asm push cx;later pop ax, byte written

 push cx;later pop ax, byte written
;-290             asm push bx;save bx, because we use it

 push bx;save bx, because we use it
;-291             bx=dx;//set offset to index register, loose handle

 mov  bx, dx
;-292             while (cx > 0) {//number to write

.KERNEL_START32:
 cmp  cx, 0
 jle .KERNEL_START33
;-293                 asm mov al, [bx];//DS:BX is buffer

 mov al, [bx];//DS:BX is buffer
;-294                 writetty();//write raw stream

 call writetty
;-295                 asm dec cx

 dec cx
;-296                 asm inc bx

 inc bx
;-297             }

;-298             asm pop bx

 jmp .KERNEL_START32
.KERNEL_START33:
 pop bx
;-299             asm pop ax; from CX, byte written

 pop ax; from CX, byte written
;-300             asm iret

 iret
;-301         }

;-302         ax=6;//error handle invalid

.KERNEL_START31:
 mov  ax, 6
;-303         asm stc

 stc
;-304         asm iret

 iret
;-305     }

;-306 

;-307     if (ah==0x44) {//IOCTL Data

.KERNEL_START30:
 cmp  ah, 68
 jne .KERNEL_START34
;-308         if (al == 0) {// 0=get data

 cmp  al, 0
 jne .KERNEL_START35
;-309             if (bx == 0) {//handle:sdtin

 cmp  bx, 0
 jne .KERNEL_START36
;-310                 dx=mode_IOData;//8080=cooked, 8280=raw

 mov  dx, [mode_IOData]
;-311                 asm iret

 iret
;-312             }

;-313         }

.KERNEL_START36:
;-314         if (al == 1) {//set data

.KERNEL_START35:
 cmp  al, 1
 jne .KERNEL_START37
;-315             if (bx == 0) {//handle:sdtin

 cmp  bx, 0
 jne .KERNEL_START38
;-316                 asm mov [mode_IOData], dx;//8080=cooked, 8280=raw

 mov [mode_IOData], dx;//8080=cooked, 8280=raw
;-317                 asm iret

 iret
;-318             }

;-319         }

.KERNEL_START38:
;-320             ax=15;//error unvalid Data

.KERNEL_START37:
 mov  ax, 15
;-321             asm stc; set carry flag

 stc; set carry flag
;-322             asm iret

 iret
;-323         // IOCTL function not supported,fall through to error

;-324     }

;-325     if (ah==0x4C) {//Terminate

.KERNEL_START34:
 cmp  ah, 76
 jne .KERNEL_START39
;-326         al=0;//returncode

 mov  al, 0
;-327         inth 0x21;

 int  33
;-328         // asm iret

;-329     }

;-330     if (ah==0x54) {//GetVerifyState

.KERNEL_START39:
 cmp  ah, 84
 jne .KERNEL_START40
;-331         al=0;// always off

 mov  al, 0
;-332         asm iret

 iret
;-333     }

;-334 

;-335     // function not implemented

;-336     asm push ax

.KERNEL_START40:
 push ax
;-337     cputs(" FUNC ");

 push KERNEL_START_2
 call cputs
 add  sp, 2
;-338     asm pop ax

 pop ax
;-339     ax >> 8;

 shr  ax, 8
;-340     printhex8(ax);

 push ax
 call printhex8
 add  sp, 2
;-341     cputs("h not supported");

 push KERNEL_START_3
 call cputs
 add  sp, 2
;-342 //    inth 3;// break, call debug

;-343     asm iret

 iret
;-344 }// END OF TSR

;-345 

;-346 //--------------------------- Kernel Programs for separate use ------

;-347 int GetTickerBios() {

 ret
KERNEL_START_0 db "ERROR no RTC",0
KERNEL_START_1 db "ERROR no RTC",0
KERNEL_START_2 db " FUNC ",0
KERNEL_START_3 db "h not supported",0
ENDP

GetTickerBios: PROC
;-348     cputs(" BiosTicker LO/HI:");

 push GetTickerBios_0
 call cputs
 add  sp, 2
;-349     ah=0;

 mov  ah, 0
;-350     inth 0x1A;

 int  26
;-351     printunsign(dx);

 push dx
 call printunsign
 add  sp, 2
;-352     putch(':');

 push 58
 call putch
 add  sp, 2
;-353     printunsign(cx);

 push cx
 call printunsign
 add  sp, 2
;-354 }

;-355 

;-356 int RAM046CTicks() {

 ret
GetTickerBios_0 db " BiosTicker LO/HI:",0
ENDP

RAM046CTicks: PROC
;-357     cputs(" Ticks @40:6C LO/HI:");

 push RAM046CTicks_0
 call cputs
 add  sp, 2
;-358     asm push es

 push es
;-359     ax=0x40;

 mov  ax, 64
;-360     es=ax;

 mov  es, ax
;-361     __emit__(0x26);// ES:

 db 38
;-362     asm mov ax, [108]; 6Ch

 mov ax, [108]; 6Ch
;-363     printunsign(ax);

 push ax
 call printunsign
 add  sp, 2
;-364     putch(':');

 push 58
 call putch
 add  sp, 2
;-365     __emit__(0x26);// ES:

 db 38
;-366     asm mov ax, [110]; 6Eh

 mov ax, [110]; 6Eh
;-367     printunsign(ax);

 push ax
 call printunsign
 add  sp, 2
;-368     asm pop es

 pop es
;-369 }

;-370 

;-371 int printDateTime() {

 ret
RAM046CTicks_0 db " Ticks @40:6C LO/HI:",0
ENDP

printDateTime: PROC
;-372     ah=0x2A;

 mov  ah, 42
;-373     KernelInt();

 call KernelInt
;-374     printunsign(day);

 mov al, byte [day]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-375     putch('.');

 push 46
 call putch
 add  sp, 2
;-376     printunsign(month);

 mov al, byte [month]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-377     putch('.');

 push 46
 call putch
 add  sp, 2
;-378     printunsign(cent);

 mov al, byte [cent]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-379     printunsign(year);

 mov al, byte [year]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-380     putch(' ');

 push 32
 call putch
 add  sp, 2
;-381     ah=0x2C;

 mov  ah, 44
;-382     KernelInt();

 call KernelInt
;-383     printunsign(hour);

 mov al, byte [hour]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-384     putch(':');

 push 58
 call putch
 add  sp, 2
;-385     printunsign(min);

 mov al, byte [min]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-386     putch(':');

 push 58
 call putch
 add  sp, 2
;-387     printunsign(sec);

 mov al, byte [sec]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-388 }

;-389 int printVersion() {

 ret
ENDP

printVersion: PROC
;-390     int vAX;

;-391     ah=0x30;
;
 ENTER  2,0
 mov  ah, 48
;-392     KernelInt();

 call KernelInt
;-393     asm mov [bp-2], ax;

 mov [bp-2], ax;
;-394     cputs(" KernelVer:");

 push printVersion_0
 call cputs
 add  sp, 2
;-395     printhex4(vAX);

 push word [bp-2]
 call printhex4
 add  sp, 2
;-396     putch('.');

 push 46
 call putch
 add  sp, 2
;-397     vAX=vAX >> 8;

 mov ax, [bp-2]
 shr ax, 8
 mov [bp-2], ax
;-398     printunsign(vAX);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-399 }

;-400 int readDevice() {

 LEAVE
 ret
printVersion_0 db " KernelVer:",0
ENDP

readDevice: PROC
;-401     bx=0;

 mov  bx, 0
;-402     cx=8;//max character

 mov  cx, 8
;-403     asm lea dx, [Buf]

 lea dx, [Buf]
;-404     ah=0x3F;

 mov  ah, 63
;-405     KernelInt();//return: AX bytes read

 call KernelInt
;-406     dx=Buf;//asm mov dx, [Buf]

 mov  dx, [Buf]
;-407     printunsign(ax);

 push ax
 call printunsign
 add  sp, 2
;-408 }

;-409 int writeDevice() {

 ret
ENDP

writeDevice: PROC
;-410     bx=1;//handle

 mov  bx, 1
;-411     cx=16;//length

 mov  cx, 16
;-412     asm lea dx, [Buf]; dx=Buf;

 lea dx, [Buf]; dx=Buf;
;-413     ah=0x40;

 mov  ah, 64
;-414     KernelInt();//return: AX bytes written

 call KernelInt
;-415 }

;-416 

;-417 int getFirstMCB() {

 ret
ENDP

getFirstMCB: PROC
;-418     ah=0x52;//DOS list of lists

 mov  ah, 82
;-419     inth 0x21;// out= ES:BX ptr to list of lists

 int  33
;-420     __emit__(0x26);// ES: Praefix

 db 38
;-421     asm mov es, [bx-2];mov es, [es:bx-2]

 mov es, [bx-2];mov es, [es:bx-2]
;-422     //first memory control block in ES:

;-423 }

;-424 char memSignature;

 ret
ENDP
memSignature db 0
;-425 unsigned int memOwner;

memOwner dw 0
;-426 unsigned int memSize;

memSize dw 0
;-427 

;-428 int domem() {


domem: PROC
;-429     getFirstMCB();//with Int21h

 call getFirstMCB
;-430     do {

.domem41:
;-431         putch(10);

 push 10
 call putch
 add  sp, 2
;-432         cputs("Start:");

 push domem_0
 call cputs
 add  sp, 2
;-433         printhex16(es);

 push es
 call printhex16
 add  sp, 2
;-434         if (es >= 0xA000) cputs(" MCB in UMB");

 cmp  es, 40960 ;unsigned : 0
 jb  .domem42
 push domem_1
 call cputs
 add  sp, 2
;-435 //        asm mov al, [es:0]// M or Z

;-436         __emit__(0x26,0xA0,0,0);

.domem42:
 db 38,160,0,0
;-437         asm mov [memSignature], al

 mov [memSignature], al
;-438         cputs(", ");

 push domem_2
 call cputs
 add  sp, 2
;-439         putch(memSignature);

 mov al, byte [memSignature]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-440 //        asm mov ax, [es:1]//program segment prefix

;-441         __emit__(0x26,0xA1,1,0);

 db 38,161,1,0
;-442         asm mov [memOwner], ax

 mov [memOwner], ax
;-443         cputs(", PSP:");

 push domem_3
 call cputs
 add  sp, 2
;-444         printhex16(memOwner);

 push word [memOwner]
 call printhex16
 add  sp, 2
;-445 //        asm mov ax, [es:3]//size in para

;-446         __emit__(0x26,0xA1,3,0);

 db 38,161,3,0
;-447         asm mov [memSize], ax

 mov [memSize], ax
;-448         cputs(", Size:");

 push domem_4
 call cputs
 add  sp, 2
;-449         printhex16(memSize);

 push word [memSize]
 call printhex16
 add  sp, 2
;-450         if (memOwner == 8) cputs(" DOS");

 mov ax, [memOwner]
 cmp ax, 8
 jne .domem43
 push domem_5
 call cputs
 add  sp, 2
;-451         if (memOwner == 0) cputs(" free");

.domem43:
 mov ax, [memOwner]
 cmp ax, 0
 jne .domem44
 push domem_6
 call cputs
 add  sp, 2
;-452         else {

 jmp .domem45
.domem44:
;-453             putch(' ');

 push 32
 call putch
 add  sp, 2
;-454             __emit__(0x26,0xA1,8,0);//

 db 38,161,8,0
;-455             writetty();

 call writetty
;-456             __emit__(0x26,0xA1,9,0);//

 db 38,161,9,0
;-457             writetty();

 call writetty
;-458             __emit__(0x26,0xA1,10,0);//

 db 38,161,10,0
;-459             writetty();

 call writetty
;-460             __emit__(0x26,0xA1,11,0);//

 db 38,161,11,0
;-461             writetty();

 call writetty
;-462             __emit__(0x26,0xA1,12,0);//

 db 38,161,12,0
;-463             writetty();

 call writetty
;-464             __emit__(0x26,0xA1,13,0);//

 db 38,161,13,0
;-465             writetty();

 call writetty
;-466             __emit__(0x26,0xA1,14,0);//

 db 38,161,14,0
;-467             writetty();

 call writetty
;-468             __emit__(0x26,0xA1,15,0);//

 db 38,161,15,0
;-469             writetty();

 call writetty
;-470         }

;-471     ax=es;

.domem45:
 mov  ax, es
;-472     ax += memSize;

 add  ax, [memSize]
;-473     asm inc ax; ax+=1;

 inc ax; ax+=1;
;-474     es=ax;

 mov  es, ax
;-475     }

;-476     while (memSignature == 'M');

 mov al, [memSignature]
 cmp al, 77
 jne .domem46
 jmp .domem41
.domem46:
;-477 }

;-478 char DOS_ERR=0;

 ret
domem_0 db "Start:",0
domem_1 db " MCB in UMB",0
domem_2 db ", ",0
domem_3 db ", PSP:",0
domem_4 db ", Size:",0
domem_5 db " DOS",0
domem_6 db " free",0
ENDP
DOS_ERR db 0
;-479 unsigned int vAX;

vAX dw 0
;-480 unsigned int vBX;

vBX dw 0
;-481 

;-482 int DosInt() {


DosInt: PROC
;-483     inth 0x21;

 int  33
;-484     __emit__(0x73, 04); //jnc over DOS_ERR++

 db 115,4
;-485     DOS_ERR++;

 inc  byte[DOS_ERR]
;-486 }

;-487 

;-488 int setBlockDos(unsigned int i) {

 ret
ENDP

setBlockDos: PROC
;-489     bx=i;
;
 ENTER  0,0
 mov  bx, [bp+4]
;-490     ax=cs;

 mov  ax, cs
;-491     es=ax;

 mov  es, ax
;-492     ax=0x4A00;

 mov  ax, 18944
;-493     DosInt();

 call DosInt
;-494 //modify memory Allocation. IN: ES=Block Seg, BX=size in para

;-495     asm mov [vAX], ax; error code or segment addr

 mov [vAX], ax; error code or segment addr
;-496     asm mov [vBX], bx; free para

 mov [vBX], bx; free para
;-497     if (DOS_ERR) cputs(" ***Error Alloc Mem***");

 mov al, [DOS_ERR]
 or  al, al
 je .setBlockDos47
 push setBlockDos_0
 call cputs
 add  sp, 2
;-498 //    7=MCB destroyed, 8=Insufficient memory, 9=ES is wrong

;-499 //    BX=Max mem available, if CF & AX=8

;-500     cputs(" setBlock AX:"); printhex16(vAX);

.setBlockDos47:
 push setBlockDos_1
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-501     cputs(",BX:"); printhex16(vBX);

 push setBlockDos_2
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-502 }

;-503 int AllocMemDos(unsigned int i) {// in para

 LEAVE
 ret
setBlockDos_0 db " ***Error Alloc Mem***",0
setBlockDos_1 db " setBlock AX:",0
setBlockDos_2 db ",BX:",0
ENDP

AllocMemDos: PROC
;-504     bx=i;
;
 ENTER  0,0
 mov  bx, [bp+4]
;-505     ah=0x48;

 mov  ah, 72
;-506     DosInt();

 call DosInt
;-507     asm mov [vAX], ax; error code

 mov [vAX], ax; error code
;-508     asm mov [vBX], bx; free para

 mov [vBX], bx; free para
;-509     if (DOS_ERR) cputs(" ***Error Set Block***");

 mov al, [DOS_ERR]
 or  al, al
 je .AllocMemDos48
 push AllocMemDos_0
 call cputs
 add  sp, 2
;-510 //    7=MCB destroyed, 8=Insufficient memory

;-511 //    BX=Max mem available, if CF & AX=8

;-512     cputs(" AllocMem AX:"); printhex16(vAX);

.AllocMemDos48:
 push AllocMemDos_1
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-513     cputs(",BX:"); printhex16(vBX);

 push AllocMemDos_2
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-514 }

;-515 int FreeMemDos(unsigned int i) {// segment addr

 LEAVE
 ret
AllocMemDos_0 db " ***Error Set Block***",0
AllocMemDos_1 db " AllocMem AX:",0
AllocMemDos_2 db ",BX:",0
ENDP

FreeMemDos: PROC
;-516     dx=i;
;
 ENTER  0,0
 mov  dx, [bp+4]
;-517     bx=i;

 mov  bx, [bp+4]
;-518     es=i;//todo

 mov  es, [bp+4]
;-519     ax=i;

 mov  ax, [bp+4]
;-520     es=ax;

 mov  es, ax
;-521     ah=0x49;

 mov  ah, 73
;-522     DosInt();

 call DosInt
;-523     asm mov [vAX], ax; error code

 mov [vAX], ax; error code
;-524     if (DOS_ERR) {

 mov al, [DOS_ERR]
 or  al, al
 je .FreeMemDos49
;-525         cputs(" ***Error Free Mem***");

 push FreeMemDos_0
 call cputs
 add  sp, 2
;-526 //    7=MCB destroyed, 9=ES is wromg

;-527         cputs(" FreeMem AX:");

 push FreeMemDos_1
 call cputs
 add  sp, 2
;-528         printhex16(vAX);

 push word [vAX]
 call printhex16
 add  sp, 2
;-529     }

;-530 }

.FreeMemDos49:
;-531 

;-532 int main() {

 LEAVE
 ret
FreeMemDos_0 db " ***Error Free Mem***",0
FreeMemDos_1 db " FreeMem AX:",0
ENDP

main: PROC
;-533     count18h=0;

 mov ax, 0
 mov word [count18h], ax
;-534     asm mov dx, KERNEL_START;set Int Vec

 mov dx, KERNEL_START;set Int Vec
;-535     ax=0x2518;

 mov  ax, 9496
;-536     inth 0x21;//new In18h is not yet connected

 int  33
;-537     setBlockDos(4096);//reduce COM-Prg to 64 KByte

 push 4096
 call setBlockDos
 add  sp, 2
;-538 domem();

 call domem
;-539 

;-540     cputs(" c18h=");

 push main_0
 call cputs
 add  sp, 2
;-541     printunsign(count18h);

 push word [count18h]
 call printunsign
 add  sp, 2
;-542     ah=0x4C;//Terminate

 mov  ah, 76
;-543     KernelInt();

 call KernelInt
;-544 }

 ret
main_0 db " c18h=",0
ENDP
;Glob. variables:21 (300), Functions:28 (300), Lines:545
;Constant: 160 (3000), stacksize: 40536