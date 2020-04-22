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

;Function : putch, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
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

;Function : cputs, Number local Var: 2
; # type sign width local variables
;300 ptr sign byte s = bp+4
;301 var sign byte c = bp-2;
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

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;300 var unsg byte c = bp+4;
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

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;300 var unsg byte c = bp+4
;301 var unsg byte nib = bp-2;
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

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;300 var unsg word i = bp+4
;301 var unsg word half = bp-2;
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

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;300 var unsg word n = bp+4
;301 var unsg word e = bp-2;
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

;Function : BCDtoChar, Number local Var: 2
; # type sign width local variables
;300 var sign byte BCD = bp+4
;301 var sign byte LowNibble = bp-2;
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
;-89 unsigned int count18h=0;// counts all interrups calls in CS:

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

;-102 unsigned int VecOldOfs;// in CS:

 ret
ENDP
VecOldOfs dw 0
;-103 unsigned int VecOldSeg;// in CS:

VecOldSeg dw 0
;-104 unsigned int count=0;  // in CS:

count dw 0
;-105 

;-106 int GetIntVec(char c) {


GetIntVec: PROC
;-107     asm push es

;Function : GetIntVec, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 push es
;-108     al=c;

 mov  al, [bp+4]
;-109     ah=0x35;

 mov  ah, 53
;-110     KernelInt();

 call KernelInt
;-111     asm mov [cs:VecOldOfs], bx

 mov [cs:VecOldOfs], bx
;-112     asm mov [cs:VecOldSeg], es

 mov [cs:VecOldSeg], es
;-113     asm pop es

 pop es
;-114 }

;-115 

;-116 //--------------------------- Start of new Interrupt 18h ------------

;-117 int KERNEL_START() {

 LEAVE
 ret
ENDP

KERNEL_START: PROC
;-118     asm inc  word[cs:count18h]; count18h++;

 inc  word[cs:count18h]; count18h++;
;-119     asm sti; set interrupt enable

 sti; set interrupt enable
;-120 

;-121     if (ah==0x01) {//Read Keyboard and Echo

 cmp  ah, 1
 jne .KERNEL_START7
;-122         kbdEcho();

 call kbdEcho
;-123         asm iret

 iret
;-124     }

;-125     if (ah==0x02) {//Display Character

.KERNEL_START7:
 cmp  ah, 2
 jne .KERNEL_START8
;-126         al=dl;

 mov  al, dl
;-127         writetty();

 call writetty
;-128         asm iret

 iret
;-129     }

;-130     if (ah==0x06) {//Direct Console I/O

.KERNEL_START8:
 cmp  ah, 6
 jne .KERNEL_START9
;-131         if (dl == 0xFF) {// then read character

 cmp  dl, 255
 jne .KERNEL_START10
;-132             getch();

 call getch
;-133             asm iret

 iret
;-134         }

;-135         al=dl;           // else display character

.KERNEL_START10:
 mov  al, dl
;-136         writetty();

 call writetty
;-137         asm iret

 iret
;-138     }

;-139     if (ah==0x07) {//Direct Console Input

.KERNEL_START9:
 cmp  ah, 7
 jne .KERNEL_START11
;-140         getch();

 call getch
;-141         asm iret

 iret
;-142     }

;-143     if (ah==0x09) {//display string in DS:DX

.KERNEL_START11:
 cmp  ah, 9
 jne .KERNEL_START12
;-144         asm push si

 push si
;-145         si=dx;

 mov  si, dx
;-146         asm cld; clear direction, string up

 cld; clear direction, string up
;-147         asm lodsb; from DS:SI to AL

 lodsb; from DS:SI to AL
;-148         while (al != '$') {

.KERNEL_START13:
 cmp  al, 36
 je  .KERNEL_START14
;-149             writetty();

 call writetty
;-150             asm lodsb

 lodsb
;-151         }

;-152         asm pop si

 jmp .KERNEL_START13
.KERNEL_START14:
 pop si
;-153         asm iret

 iret
;-154     }

;-155 

;-156     if (ah==0x25) {//setIntVec in AL from DS:DX

.KERNEL_START12:
 cmp  ah, 37
 jne .KERNEL_START15
;-157         asm cli; clear int enable, turn OFF int

 cli; clear int enable, turn OFF int
;-158         asm push ax

 push ax
;-159         asm push es

 push es
;-160         asm push di

 push di
;-161         asm push ds; later pop ax

 push ds; later pop ax
;-162         ax << 2;

 shl  ax, 2
;-163         ah=0;

 mov  ah, 0
;-164         di=ax;

 mov  di, ax
;-165         ax=0;

 mov  ax, 0
;-166         es=ax;//segment 0

 mov  es, ax
;-167         ax=dx;

 mov  ax, dx
;-168         asm cld; clear direction, string up

 cld; clear direction, string up
;-169         asm stosw; ofs in DX to ES:DI

 stosw; ofs in DX to ES:DI
;-170         asm pop ax; get DS

 pop ax; get DS
;-171         asm stosw; seg (DS) to ES:DI+2

 stosw; seg (DS) to ES:DI+2
;-172         asm pop di

 pop di
;-173         asm pop es

 pop es
;-174         asm pop ax

 pop ax
;-175         asm sti;set int enable, turn ON int

 sti;set int enable, turn ON int
;-176         asm iret

 iret
;-177     }

;-178     if (ah==0x2A) {//GetDate

.KERNEL_START15:
 cmp  ah, 42
 jne .KERNEL_START16
;-179         ah=4;

 mov  ah, 4
;-180         inth 0x1A;

 int  26
;-181         __emit__(0x73, 04); //jnc over KERNEL_ERR++

 db 115,4
;-182         KERNEL_ERR++;

 inc  byte[KERNEL_ERR]
;-183         asm mov [cent], ch; cent ... are used by GetDate

 mov [cent], ch; cent ... are used by GetDate
;-184         asm mov [year], cl

 mov [year], cl
;-185         asm mov [month],dh

 mov [month],dh
;-186         asm mov [day],  dl

 mov [day],  dl
;-187         if (KERNEL_ERR > 0) cputs("ERROR no RTC");

 mov al, [KERNEL_ERR]
 cmp al, 0
 jle .KERNEL_START17
 push KERNEL_START_0
 call cputs
 add  sp, 2
;-188         cent=BCDtoChar(cent);

.KERNEL_START17:
 mov al, byte [cent]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [cent], al
;-189         year=BCDtoChar(year);

 mov al, byte [year]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [year], al
;-190         month=BCDtoChar(month);

 mov al, byte [month]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [month], al
;-191         day=BCDtoChar(day);

 mov al, byte [day]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [day], al
;-192         ch=0;

 mov  ch, 0
;-193         cl=year;

 mov  cl, [year]
;-194         asm add cx, 2000; add century

 add cx, 2000; add century
;-195         dh=month;

 mov  dh, [month]
;-196         dl=day;

 mov  dl, [day]
;-197         asm iret

 iret
;-198     }

;-199     if (ah==0x2C) {//GetTime, NO 1/100 sec

.KERNEL_START16:
 cmp  ah, 44
 jne .KERNEL_START18
;-200         ah=2;

 mov  ah, 2
;-201         inth 0x1A;

 int  26
;-202         __emit__(0x73, 04); //jnc over KERNEL_ERR++

 db 115,4
;-203         KERNEL_ERR++;

 inc  byte[KERNEL_ERR]
;-204         asm mov [hour], ch

 mov [hour], ch
;-205         asm mov [min],  cl

 mov [min],  cl
;-206         asm mov [sec],  dh

 mov [sec],  dh
;-207         if (KERNEL_ERR > 0) cputs("ERROR no RTC");

 mov al, [KERNEL_ERR]
 cmp al, 0
 jle .KERNEL_START19
 push KERNEL_START_1
 call cputs
 add  sp, 2
;-208         hour=BCDtoChar(hour);

.KERNEL_START19:
 mov al, byte [hour]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [hour], al
;-209         min=BCDtoChar(min);

 mov al, byte [min]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [min], al
;-210         sec=BCDtoChar(sec);

 mov al, byte [sec]
 mov ah, 0
 push ax
 call BCDtoChar
 add  sp, 2
 mov byte [sec], al
;-211         ch=hour;

 mov  ch, [hour]
;-212         cl=min;

 mov  cl, [min]
;-213         dh=sec;

 mov  dh, [sec]
;-214         dl=0;// NO 1/100 sec

 mov  dl, 0
;-215         asm iret

 iret
;-216     }

;-217     if (ah==0x30) {//getDosVer

.KERNEL_START18:
 cmp  ah, 48
 jne .KERNEL_START20
;-218         ax=0x1E03; //Ver 3.30

 mov  ax, 7683
;-219         asm iret

 iret
;-220     }

;-221     if (ah==0x33) {//Control C Check (break)

.KERNEL_START20:
 cmp  ah, 51
 jne .KERNEL_START21
;-222         al=0xFF;// error for all subcodes

 mov  al, 255
;-223         dl=0;// always off

 mov  dl, 0
;-224         asm iret

 iret
;-225     }

;-226     if (ah==0x35) {//getIntVec in AL to ES:BX

.KERNEL_START21:
 cmp  ah, 53
 jne .KERNEL_START22
;-227         asm cli; clear int enable, turn OFF int

 cli; clear int enable, turn OFF int
;-228         asm push ds

 push ds
;-229         bx=0;

 mov  bx, 0
;-230         ds=bx;  //Int table starts at 0000

 mov  ds, bx
;-231         bl=al;

 mov  bl, al
;-232         bx << 2;//int is 4 bytes long

 shl  bx, 2
;-233         asm les bx, [bx]; ofs in bx, seg in es

 les bx, [bx]; ofs in bx, seg in es
;-234         asm pop ds

 pop ds
;-235         asm sti; set int enable, turn ON int

 sti; set int enable, turn ON int
;-236         asm iret

 iret
;-237     }

;-238 

;-239 //todo backspace not counting correct

;-240     if (ah==0x3F) {   //read file or device

.KERNEL_START22:
 cmp  ah, 63
 jne .KERNEL_START23
;-241         if (bx == 0) {//BX = handle = stdin only

 cmp  bx, 0
 jne .KERNEL_START24
;-242                       //CX = bytes to Read

;-243                       //DS:DX buffer

;-244             asm push bx;buffer in DS:DX

 push bx;buffer in DS:DX
;-245             count=0;

 mov ax, 0
 mov word [count], ax
;-246             bx=dx;//set offset to index register, loose handle

 mov  bx, dx
;-247             while (cx > 0) {//number to read

.KERNEL_START25:
 cmp  cx, 0
 jle .KERNEL_START26
;-248                 getkey();

 call getkey
;-249                 //check for extended code AH=1

;-250                 asm mov [bx], al;//DS:BX is buffer

 mov [bx], al;//DS:BX is buffer
;-251                 writetty();

 call writetty
;-252                 asm inc bx

 inc bx
;-253                 asm dec cx;count down of bytes to read

 dec cx;count down of bytes to read
;-254                 count++;

 inc  word[count]
;-255                 // use as a cooked input stream

;-256                 if (al ==  8) {//Backspace, delete 1 character

 cmp  al, 8
 jne .KERNEL_START27
;-257                     if (count > 0) {// at least 1 character

 mov ax, [count]
 cmp ax, 0
 jle .KERNEL_START28
;-258                         //putch(8); already written 7 lines up

;-259                         putch(' ');

 push 32
 call putch
 add  sp, 2
;-260                         putch(8);

 push 8
 call putch
 add  sp, 2
;-261                         asm inc cx; remove the dec cx above

 inc cx; remove the dec cx above
;-262                         asm inc cx; 1 more char to read

 inc cx; 1 more char to read
;-263                         asm dec bx; remove the inc bx above

 dec bx; remove the inc bx above
;-264                         asm dec bx;remove 1 char from input string

 dec bx;remove 1 char from input string
;-265                         count-=2;

 sub  word[count], 2
;-266                     }

;-267                 }

.KERNEL_START28:
;-268                 if (al == 13) {//send LF=10 after CR=13

.KERNEL_START27:
 cmp  al, 13
 jne .KERNEL_START29
;-269                     al=10;

 mov  al, 10
;-270                     asm mov [bx], al;//DS:BX is buffer

 mov [bx], al;//DS:BX is buffer
;-271                     writetty();

 call writetty
;-272                     asm inc bx

 inc bx
;-273                     cx=0;// leave the while loop

 mov  cx, 0
;-274                     count++;

 inc  word[count]
;-275                 }

;-276             }

.KERNEL_START29:
;-277             asm pop bx

 jmp .KERNEL_START25
.KERNEL_START26:
 pop bx
;-278             ax=count;//bytes read

 mov  ax, [count]
;-279             asm iret;   carry=error

 iret;   carry=error
;-280         }

;-281         ax=6;//error handle invalid, not 0

.KERNEL_START24:
 mov  ax, 6
;-282         asm stc

 stc
;-283         asm iret

 iret
;-284     }

;-285     if (ah==0x40) {//write to file or device

.KERNEL_START23:
 cmp  ah, 64
 jne .KERNEL_START30
;-286         if (bx <= 2) {//handle = stdin,stdout,error device

 cmp  bx, 2
 ja  .KERNEL_START31
;-287             asm push cx;later pop ax, byte written

 push cx;later pop ax, byte written
;-288             asm push bx;save bx, because we use it

 push bx;save bx, because we use it
;-289             bx=dx;//set offset to index register, loose handle

 mov  bx, dx
;-290             while (cx > 0) {//number to write

.KERNEL_START32:
 cmp  cx, 0
 jle .KERNEL_START33
;-291                 asm mov al, [bx];//DS:BX is buffer

 mov al, [bx];//DS:BX is buffer
;-292                 writetty();//write raw stream

 call writetty
;-293                 asm dec cx

 dec cx
;-294                 asm inc bx

 inc bx
;-295             }

;-296             asm pop bx

 jmp .KERNEL_START32
.KERNEL_START33:
 pop bx
;-297             asm pop ax; from CX, byte written

 pop ax; from CX, byte written
;-298             asm iret

 iret
;-299         }

;-300         ax=6;//error handle invalid

.KERNEL_START31:
 mov  ax, 6
;-301         asm stc

 stc
;-302         asm iret

 iret
;-303     }

;-304 

;-305     if (ah==0x44) {//IOCTL Data

.KERNEL_START30:
 cmp  ah, 68
 jne .KERNEL_START34
;-306         if (al == 0) {// 0=get data

 cmp  al, 0
 jne .KERNEL_START35
;-307             if (bx == 0) {//handle:sdtin

 cmp  bx, 0
 jne .KERNEL_START36
;-308                 dx=mode_IOData;//8080=cooked, 8280=raw

 mov  dx, [mode_IOData]
;-309                 asm iret

 iret
;-310             }

;-311         }

.KERNEL_START36:
;-312         if (al == 1) {//set data

.KERNEL_START35:
 cmp  al, 1
 jne .KERNEL_START37
;-313             if (bx == 0) {//handle:sdtin

 cmp  bx, 0
 jne .KERNEL_START38
;-314                 asm mov [mode_IOData], dx;//8080=cooked, 8280=raw

 mov [mode_IOData], dx;//8080=cooked, 8280=raw
;-315                 asm iret

 iret
;-316             }

;-317         }

.KERNEL_START38:
;-318             ax=15;//error unvalid Data

.KERNEL_START37:
 mov  ax, 15
;-319             asm stc; set carry flag

 stc; set carry flag
;-320             asm iret

 iret
;-321         // IOCTL function not supported,fall through to error

;-322     }

;-323     if (ah==0x4C) {//Terminate

.KERNEL_START34:
 cmp  ah, 76
 jne .KERNEL_START39
;-324         al=0;//returncode

 mov  al, 0
;-325         inth 0x21;

 int  33
;-326         // asm iret

;-327     }

;-328     if (ah==0x54) {//GetVerifyState

.KERNEL_START39:
 cmp  ah, 84
 jne .KERNEL_START40
;-329         al=0;// always off

 mov  al, 0
;-330         asm iret

 iret
;-331     }

;-332 

;-333     // function not implemented

;-334     asm push ax

.KERNEL_START40:
 push ax
;-335     cputs(" FUNC ");

 push KERNEL_START_2
 call cputs
 add  sp, 2
;-336     asm pop ax

 pop ax
;-337     ax >> 8;

 shr  ax, 8
;-338     printhex8(ax);

 push ax
 call printhex8
 add  sp, 2
;-339     cputs("h not supported");

 push KERNEL_START_3
 call cputs
 add  sp, 2
;-340 //    inth 3;// break, call debug

;-341     asm iret

 iret
;-342 }// END OF TSR

;-343 

;-344 //--------------------------- Kernel Programs for separate use ------

;-345 int GetTickerBios() {

 ret
KERNEL_START_0 db "ERROR no RTC",0
KERNEL_START_1 db "ERROR no RTC",0
KERNEL_START_2 db " FUNC ",0
KERNEL_START_3 db "h not supported",0
ENDP

GetTickerBios: PROC
;-346     cputs(" BiosTicker LO/HI:");

 push GetTickerBios_0
 call cputs
 add  sp, 2
;-347     ah=0;

 mov  ah, 0
;-348     inth 0x1A;

 int  26
;-349     printunsign(dx);

 push dx
 call printunsign
 add  sp, 2
;-350     putch(':');

 push 58
 call putch
 add  sp, 2
;-351     printunsign(cx);

 push cx
 call printunsign
 add  sp, 2
;-352 }

;-353 

;-354 int RAM046CTicks() {

 ret
GetTickerBios_0 db " BiosTicker LO/HI:",0
ENDP

RAM046CTicks: PROC
;-355     cputs(" Ticks @40:6C LO/HI:");

 push RAM046CTicks_0
 call cputs
 add  sp, 2
;-356     asm push es

 push es
;-357     ax=0x40;

 mov  ax, 64
;-358     es=ax;

 mov  es, ax
;-359     __emit__(0x26);// ES:

 db 38
;-360     asm mov ax, [108]; 6Ch

 mov ax, [108]; 6Ch
;-361     printunsign(ax);

 push ax
 call printunsign
 add  sp, 2
;-362     putch(':');

 push 58
 call putch
 add  sp, 2
;-363     __emit__(0x26);// ES:

 db 38
;-364     asm mov ax, [110]; 6Eh

 mov ax, [110]; 6Eh
;-365     printunsign(ax);

 push ax
 call printunsign
 add  sp, 2
;-366     asm pop es

 pop es
;-367 }

;-368 

;-369 int printDateTime() {

 ret
RAM046CTicks_0 db " Ticks @40:6C LO/HI:",0
ENDP

printDateTime: PROC
;-370     ah=0x2A;

 mov  ah, 42
;-371     KernelInt();

 call KernelInt
;-372     printunsign(day);

 mov al, byte [day]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-373     putch('.');

 push 46
 call putch
 add  sp, 2
;-374     printunsign(month);

 mov al, byte [month]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-375     putch('.');

 push 46
 call putch
 add  sp, 2
;-376     printunsign(cent);

 mov al, byte [cent]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-377     printunsign(year);

 mov al, byte [year]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-378     putch(' ');

 push 32
 call putch
 add  sp, 2
;-379     ah=0x2C;

 mov  ah, 44
;-380     KernelInt();

 call KernelInt
;-381     printunsign(hour);

 mov al, byte [hour]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-382     putch(':');

 push 58
 call putch
 add  sp, 2
;-383     printunsign(min);

 mov al, byte [min]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-384     putch(':');

 push 58
 call putch
 add  sp, 2
;-385     printunsign(sec);

 mov al, byte [sec]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-386 }

;-387 int printVersion() {

 ret
ENDP

printVersion: PROC
;-388     int vAX;

;-389     ah=0x30;

;Function : printVersion, Number local Var: 1
; # type sign width local variables
;300 var sign word vAX = bp-2;
 ENTER  2,0
 mov  ah, 48
;-390     KernelInt();

 call KernelInt
;-391     asm mov [bp-2], ax;

 mov [bp-2], ax;
;-392     cputs(" KernelVer:");

 push printVersion_0
 call cputs
 add  sp, 2
;-393     printhex4(vAX);

 push word [bp-2]
 call printhex4
 add  sp, 2
;-394     putch('.');

 push 46
 call putch
 add  sp, 2
;-395     vAX=vAX >> 8;

 mov ax, [bp-2]
 shr ax, 8
 mov [bp-2], ax
;-396     printunsign(vAX);

 push word [bp-2]
 call printunsign
 add  sp, 2
;-397 }

;-398 int readDevice() {

 LEAVE
 ret
printVersion_0 db " KernelVer:",0
ENDP

readDevice: PROC
;-399     bx=0;

 mov  bx, 0
;-400     cx=8;//max character

 mov  cx, 8
;-401     asm lea dx, [Buf]

 lea dx, [Buf]
;-402     ah=0x3F;

 mov  ah, 63
;-403     KernelInt();//return: AX bytes read

 call KernelInt
;-404     dx=Buf;//asm mov dx, [Buf]

 mov  dx, [Buf]
;-405     printunsign(ax);

 push ax
 call printunsign
 add  sp, 2
;-406 }

;-407 int writeDevice() {

 ret
ENDP

writeDevice: PROC
;-408     bx=1;//handle

 mov  bx, 1
;-409     cx=16;//length

 mov  cx, 16
;-410     asm lea dx, [Buf]; dx=Buf;

 lea dx, [Buf]; dx=Buf;
;-411     ah=0x40;

 mov  ah, 64
;-412     KernelInt();//return: AX bytes written

 call KernelInt
;-413 }

;-414 

;-415 int getFirstMCB() {

 ret
ENDP

getFirstMCB: PROC
;-416     ah=0x52;//DOS list of lists

 mov  ah, 82
;-417     inth 0x21;// out= ES:BX ptr to list of lists

 int  33
;-418     __emit__(0x26);// ES: Praefix

 db 38
;-419     asm mov es, [bx-2]; mov es, [es:bx-2]

 mov es, [bx-2]; mov es, [es:bx-2]
;-420     asm mov es, [es:bx-2]

 mov es, [es:bx-2]
;-421     //first memory control block in ES:

;-422 }

;-423 char memSignature;

 ret
ENDP
memSignature db 0
;-424 unsigned int memOwner;

memOwner dw 0
;-425 unsigned int memSize;

memSize dw 0
;-426 

;-427 int domem() {


domem: PROC
;-428     getFirstMCB();//with Int21h

 call getFirstMCB
;-429     do {

.domem41:
;-430         putch(10);

 push 10
 call putch
 add  sp, 2
;-431         cputs("Start:");

 push domem_0
 call cputs
 add  sp, 2
;-432         printhex16(es);

 push es
 call printhex16
 add  sp, 2
;-433         if (es >= 0xA000) cputs(" MCB in UMB");

 cmp  es, 40960 ;unsigned : 0
 jb  .domem42
 push domem_1
 call cputs
 add  sp, 2
;-434         //asm mov al, [es:0]; M or Z ERROR***********

;-435         __emit__(0x26,0xA0,0,0);

.domem42:
 db 38,160,0,0
;-436         asm mov [memSignature], al

 mov [memSignature], al
;-437         cputs(", ");

 push domem_2
 call cputs
 add  sp, 2
;-438         putch(memSignature);

 mov al, byte [memSignature]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-439 //        asm mov ax, [es:1];psp ERROR*****

;-440         __emit__(0x26,0xA1,1,0);

 db 38,161,1,0
;-441         asm mov [memOwner], ax

 mov [memOwner], ax
;-442         cputs(", PSP:");

 push domem_3
 call cputs
 add  sp, 2
;-443         printhex16(memOwner);

 push word [memOwner]
 call printhex16
 add  sp, 2
;-444 //        asm mov ax, [es:3]//size in para ERROR*******

;-445         __emit__(0x26,0xA1,3,0);

 db 38,161,3,0
;-446         asm mov [memSize], ax

 mov [memSize], ax
;-447         cputs(", Size:");

 push domem_4
 call cputs
 add  sp, 2
;-448         printhex16(memSize);

 push word [memSize]
 call printhex16
 add  sp, 2
;-449         if (memOwner == 8) cputs(" DOS");

 mov ax, [memOwner]
 cmp ax, 8
 jne .domem43
 push domem_5
 call cputs
 add  sp, 2
;-450         if (memOwner == 0) cputs(" free");

.domem43:
 mov ax, [memOwner]
 cmp ax, 0
 jne .domem44
 push domem_6
 call cputs
 add  sp, 2
;-451         else {

 jmp .domem45
.domem44:
;-452             putch(' ');

 push 32
 call putch
 add  sp, 2
;-453             __emit__(0x26,0xA1,8,0);//

 db 38,161,8,0
;-454             writetty();

 call writetty
;-455             __emit__(0x26,0xA1,9,0);//

 db 38,161,9,0
;-456             writetty();

 call writetty
;-457             __emit__(0x26,0xA1,10,0);//

 db 38,161,10,0
;-458             writetty();

 call writetty
;-459             __emit__(0x26,0xA1,11,0);//

 db 38,161,11,0
;-460             writetty();

 call writetty
;-461             __emit__(0x26,0xA1,12,0);//

 db 38,161,12,0
;-462             writetty();

 call writetty
;-463             __emit__(0x26,0xA1,13,0);//

 db 38,161,13,0
;-464             writetty();

 call writetty
;-465             __emit__(0x26,0xA1,14,0);//

 db 38,161,14,0
;-466             writetty();

 call writetty
;-467             __emit__(0x26,0xA1,15,0);//

 db 38,161,15,0
;-468             writetty();

 call writetty
;-469         }

;-470     ax=es;

.domem45:
 mov  ax, es
;-471     ax += memSize;

 add  ax, [memSize]
;-472     asm inc ax; ax+=1;

 inc ax; ax+=1;
;-473     es=ax;

 mov  es, ax
;-474     }

;-475     while (memSignature == 'M');

 mov al, [memSignature]
 cmp al, 77
 jne .domem46
 jmp .domem41
.domem46:
;-476 }

;-477 char DOS_ERR=0;

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
;-478 unsigned int vAX;

vAX dw 0
;-479 unsigned int vBX;

vBX dw 0
;-480 

;-481 int DosInt() {


DosInt: PROC
;-482     inth 0x21;

 int  33
;-483     __emit__(0x73, 04); //jnc over DOS_ERR++

 db 115,4
;-484     DOS_ERR++;

 inc  byte[DOS_ERR]
;-485 }

;-486 

;-487 int setBlockDos(unsigned int i) {

 ret
ENDP

setBlockDos: PROC
;-488     bx=i;//number para wanted

;Function : setBlockDos, Number local Var: 1
; # type sign width local variables
;300 var unsg word i = bp+4;
 ENTER  0,0
 mov  bx, [bp+4]
;-489     ax=cs;

 mov  ax, cs
;-490     es=ax;//seg addr

 mov  es, ax
;-491     ax=0x4A00;

 mov  ax, 18944
;-492     DosInt();

 call DosInt
;-493 //modify memory Allocation. IN: ES=Block Seg, BX=size in para

;-494     asm mov [vAX], ax; error code or segment addr

 mov [vAX], ax; error code or segment addr
;-495     asm mov [vBX], bx; free para

 mov [vBX], bx; free para
;-496     if (DOS_ERR) cputs(" ***Error Alloc Mem***");

 mov al, [DOS_ERR]
 or  al, al
 je .setBlockDos47
 push setBlockDos_0
 call cputs
 add  sp, 2
;-497 //    7=MCB destroyed, 8=Insufficient memory, 9=ES is wrong

;-498 //    BX=Max mem available, if CF & AX=8

;-499     cputs(" setBlock AX:"); printhex16(vAX);

.setBlockDos47:
 push setBlockDos_1
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-500     cputs(",BX:"); printhex16(vBX);

 push setBlockDos_2
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-501 }

;-502 int AllocMemDos(unsigned int i) {// in para

 LEAVE
 ret
setBlockDos_0 db " ***Error Alloc Mem***",0
setBlockDos_1 db " setBlock AX:",0
setBlockDos_2 db ",BX:",0
ENDP

AllocMemDos: PROC
;-503     bx=i;

;Function : AllocMemDos, Number local Var: 1
; # type sign width local variables
;300 var unsg word i = bp+4;
 ENTER  0,0
 mov  bx, [bp+4]
;-504     ah=0x48;

 mov  ah, 72
;-505     DosInt();

 call DosInt
;-506     asm mov [vAX], ax; seg addr or error code

 mov [vAX], ax; seg addr or error code
;-507     asm mov [vBX], bx; free para

 mov [vBX], bx; free para
;-508     if (DOS_ERR) cputs(" ***Error Set Block***");

 mov al, [DOS_ERR]
 or  al, al
 je .AllocMemDos48
 push AllocMemDos_0
 call cputs
 add  sp, 2
;-509 //    7=MCB destroyed, 8=Insufficient memory

;-510 //    BX=Max mem available, if CF & AX=8

;-511     cputs(" AllocMem AX:"); printhex16(vAX);

.AllocMemDos48:
 push AllocMemDos_1
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
;-512     cputs(",BX:"); printhex16(vBX);

 push AllocMemDos_2
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-513 }

;-514 int FreeMemDos(unsigned int i) {// segment addr

 LEAVE
 ret
AllocMemDos_0 db " ***Error Set Block***",0
AllocMemDos_1 db " AllocMem AX:",0
AllocMemDos_2 db ",BX:",0
ENDP

FreeMemDos: PROC
;-515     es=i;

;Function : FreeMemDos, Number local Var: 1
; # type sign width local variables
;300 var unsg word i = bp+4;
 ENTER  0,0
 mov  es, [bp+4]
;-516 //    ax=i;

;-517 //    es=ax;

;-518     ah=0x49;

 mov  ah, 73
;-519     DosInt();

 call DosInt
;-520     asm mov [vAX], ax; error code

 mov [vAX], ax; error code
;-521     if (DOS_ERR) {

 mov al, [DOS_ERR]
 or  al, al
 je .FreeMemDos49
;-522         cputs(" ***Error Free Mem***");

 push FreeMemDos_0
 call cputs
 add  sp, 2
;-523 //    7=MCB destroyed, 9=ES is wromg

;-524         cputs(" FreeMem AX:");

 push FreeMemDos_1
 call cputs
 add  sp, 2
;-525         printhex16(vAX);

 push word [vAX]
 call printhex16
 add  sp, 2
;-526     }

;-527 }

.FreeMemDos49:
;-528 

;-529 int main() {

 LEAVE
 ret
FreeMemDos_0 db " ***Error Free Mem***",0
FreeMemDos_1 db " FreeMem AX:",0
ENDP

main: PROC
;-530     asm mov word [cs:count18h], 0

 mov word [cs:count18h], 0
;-531     asm mov dx, KERNEL_START;set Int Vec

 mov dx, KERNEL_START;set Int Vec
;-532     ax=0x2518;

 mov  ax, 9496
;-533     inth 0x21;//new In18h is not yet connected

 int  33
;-534     setBlockDos(4096);//reduce COM-Prg to 64 KByte

 push 4096
 call setBlockDos
 add  sp, 2
;-535 domem();

 call domem
;-536 printVersion();

 call printVersion
;-537 printDateTime();

 call printDateTime
;-538 

;-539     cputs(" c18h=");

 push main_0
 call cputs
 add  sp, 2
;-540     __emit__(0x2E);// CS: prefix for next count18h

 db 46
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