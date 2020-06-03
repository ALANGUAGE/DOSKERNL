;PLA compiler A.COM V1.0.1, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.1.2";//test bed

Version1 db "DOS.COM V0.1.2",0
;-2 //todo: resize and take own stack

<<<<<<< HEAD
;-3 #define ORGDATA		4000//start of arrays

;-4 unsigned int vAX;

vAX dw 0
;-5 unsigned int vBX;

vBX dw 0
;-6 unsigned int vCX;

vCX dw 0
;-7 unsigned int vDX;

vDX dw 0
;-8 unsigned int vSP;

vSP dw 0
;-9 unsigned int vBP;

vBP dw 0
;-10 unsigned int vCS;

vCS dw 0
;-11 unsigned int vDS;

vDS dw 0
;-12 unsigned int vSS;

vSS dw 0
;-13 unsigned int vES;

vES dw 0
;-14 

<<<<<<< HEAD
<<<<<<< HEAD
;-14 int writetty()     {


writetty: PROC
;-15     ah=0x0E;

 mov  ah, 14
;-16     bx=0;

 mov  bx, 0
;-17     asm int 16

 int 16
;-18 }

;-19 int putch(char c)  {
=======
;-16 char DOS_ERR=0;
=======
;-15 char DOS_ERR=0;
>>>>>>> parent of 8294ac5... Start Int13

DOS_ERR db 0
;-16 unsigned int count21h=0;

count21h dw 0
;-17 

;-18 int writetty()     {


writetty: PROC
;-19     ah=0x0E;

 mov  ah, 14
;-20     bx=0;

 mov  bx, 0
;-21     asm int 16

 int 16
;-22 }

<<<<<<< HEAD
pop bx;
;-25 }

;-26 int putch(char c)  {
>>>>>>> parent of aeed850... working
=======
;-23 int putch(char c)  {
>>>>>>> parent of 8294ac5... Start Int13
=======
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
>>>>>>> parent of aeed850... working

 ret
ENDP

putch: PROC
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-20     if (c==10)  {

;Function : putch, Number local Var: 1
; # type sign width local variables
;12 var sign byte c = bp+4;
=======
;-27     if (c==10)  {
=======
;-24     if (c==10)  {
>>>>>>> parent of 8294ac5... Start Int13
=======
;-27     if (c==10)  {
>>>>>>> parent of aeed850... working

;Function : putch, Number local Var: 1
; # type sign width local variables
;14 var sign byte c = bp+4;
<<<<<<< HEAD
>>>>>>> parent of aeed850... working
=======
>>>>>>> parent of aeed850... working
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-21         al=13;

 mov  al, 13
;-22         writetty();

 call writetty
;-23     }

;-24     al=c;

.putch1:
 mov  al, [bp+4]
;-25     writetty();

 call writetty
;-26 }

;-27 int cputs(char *s) {
=======
;-28         al=13;
=======
;-25         al=13;
>>>>>>> parent of 8294ac5... Start Int13

 mov  al, 13
;-26         writetty();

 call writetty
;-27     }

;-28     al=c;

.putch1:
 mov  al, [bp+4]
;-29     writetty();

 call writetty
;-30 }

<<<<<<< HEAD
;-34 int cputs(char *s) {
>>>>>>> parent of aeed850... working
=======
;-31 int cputs(char *s) {
>>>>>>> parent of 8294ac5... Start Int13
=======
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
>>>>>>> parent of aeed850... working

 LEAVE
 ret
ENDP

cputs: PROC
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-28     char c;

;-29     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;12 ptr sign byte s = bp+4
;13 var sign byte c = bp-2;
=======
;-35     char c;
=======
;-32     char c;
>>>>>>> parent of 8294ac5... Start Int13

;-33     while(*s) {
=======
;-35     char c;

;-36     while(*s) {
>>>>>>> parent of aeed850... working

;Function : cputs, Number local Var: 2
; # type sign width local variables
;14 ptr sign byte s = bp+4
;15 var sign byte c = bp-2;
<<<<<<< HEAD
>>>>>>> parent of aeed850... working
=======
>>>>>>> parent of aeed850... working
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-30         c=*s;
=======
;-37         c=*s;
>>>>>>> parent of aeed850... working
=======
;-34         c=*s;
>>>>>>> parent of 8294ac5... Start Int13
=======
;-37         c=*s;
>>>>>>> parent of aeed850... working

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-31         putch(c);
=======
;-38         putch(c);
>>>>>>> parent of aeed850... working
=======
;-35         putch(c);
>>>>>>> parent of 8294ac5... Start Int13
=======
;-38         putch(c);
>>>>>>> parent of aeed850... working

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-32         s++;

 inc  word[bp+4]
;-33     }

;-34 }

 jmp .cputs2
.cputs3:
;-35 

;-36 int printhex4(unsigned char c) {
=======
;-39         s++;
=======
;-36         s++;
>>>>>>> parent of 8294ac5... Start Int13

 inc  word[bp+4]
;-37     }

;-38 }

 jmp .cputs2
.cputs3:
;-39 

<<<<<<< HEAD
;-43 int printhex4(unsigned char c) {
>>>>>>> parent of aeed850... working
=======
;-40 int printhex4(unsigned char c) {
>>>>>>> parent of 8294ac5... Start Int13
=======
;-39         s++;

 inc  word[bp+4]
;-40     }

;-41 }

 jmp .cputs2
.cputs3:
;-42 

;-43 int printhex4(unsigned char c) {
>>>>>>> parent of aeed850... working

 LEAVE
 ret
ENDP

printhex4: PROC
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-37     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;12 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-38     if (c > 57) c += 7;
=======
;-44     c += 48;
=======
;-41     c += 48;
>>>>>>> parent of 8294ac5... Start Int13
=======
;-44     c += 48;
>>>>>>> parent of aeed850... working

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;14 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
<<<<<<< HEAD
<<<<<<< HEAD
;-45     if (c > 57) c += 7;
>>>>>>> parent of aeed850... working
=======
;-42     if (c > 57) c += 7;
>>>>>>> parent of 8294ac5... Start Int13
=======
;-45     if (c > 57) c += 7;
>>>>>>> parent of aeed850... working

 mov al, [bp+4]
 cmp al, 57
 jle .printhex44
 add  byte[bp+4], 7
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-39     putch(c);
=======
;-46     putch(c);
>>>>>>> parent of aeed850... working
=======
;-43     putch(c);
>>>>>>> parent of 8294ac5... Start Int13
=======
;-46     putch(c);
>>>>>>> parent of aeed850... working

.printhex44:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-40 }

;-41 int printhex8(unsigned char c) {
=======
;-47 }

;-48 int printhex8(unsigned char c) {
>>>>>>> parent of aeed850... working
=======
;-44 }

;-45 int printhex8(unsigned char c) {
>>>>>>> parent of 8294ac5... Start Int13
=======
;-47 }

;-48 int printhex8(unsigned char c) {
>>>>>>> parent of aeed850... working

 LEAVE
 ret
ENDP

printhex8: PROC
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-42     unsigned char nib;

;-43     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;12 var unsg byte c = bp+4
;13 var unsg byte nib = bp-2;
=======
;-49     unsigned char nib;
=======
;-46     unsigned char nib;
>>>>>>> parent of 8294ac5... Start Int13

;-47     nib = c >> 4; printhex4(nib);
=======
;-49     unsigned char nib;

;-50     nib = c >> 4; printhex4(nib);
>>>>>>> parent of aeed850... working

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;14 var unsg byte c = bp+4
;15 var unsg byte nib = bp-2;
<<<<<<< HEAD
>>>>>>> parent of aeed850... working
=======
>>>>>>> parent of aeed850... working
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-44     nib = c & 15; printhex4(nib);
=======
;-51     nib = c & 15; printhex4(nib);
>>>>>>> parent of aeed850... working
=======
;-48     nib = c & 15; printhex4(nib);
>>>>>>> parent of 8294ac5... Start Int13
=======
;-51     nib = c & 15; printhex4(nib);
>>>>>>> parent of aeed850... working

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-45 }

;-46 int printhex16(unsigned int i) {
=======
;-52 }

;-53 int printhex16(unsigned int i) {
>>>>>>> parent of aeed850... working
=======
;-49 }

;-50 int printhex16(unsigned int i) {
>>>>>>> parent of 8294ac5... Start Int13
=======
;-52 }

;-53 int printhex16(unsigned int i) {
>>>>>>> parent of aeed850... working

 LEAVE
 ret
ENDP

printhex16: PROC
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-47     unsigned int half;

;-48     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;12 var unsg word i = bp+4
;13 var unsg word half = bp-2;
=======
;-54     unsigned int half;
=======
;-51     unsigned int half;
>>>>>>> parent of 8294ac5... Start Int13

;-52     half = i >>  8; printhex8(half);
=======
;-54     unsigned int half;

;-55     half = i >>  8; printhex8(half);
>>>>>>> parent of aeed850... working

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;14 var unsg word i = bp+4
;15 var unsg word half = bp-2;
<<<<<<< HEAD
>>>>>>> parent of aeed850... working
=======
>>>>>>> parent of aeed850... working
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-49     half = i & 255; printhex8(half);
=======
;-56     half = i & 255; printhex8(half);
>>>>>>> parent of aeed850... working
=======
;-53     half = i & 255; printhex8(half);
>>>>>>> parent of 8294ac5... Start Int13
=======
;-56     half = i & 255; printhex8(half);
>>>>>>> parent of aeed850... working

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-50 }

;-51 

;-52 int printunsign(unsigned int n) {
=======
;-57 }
=======
;-54 }
>>>>>>> parent of 8294ac5... Start Int13

;-55 

<<<<<<< HEAD
;-59 int printunsign(unsigned int n) {
>>>>>>> parent of aeed850... working
=======
;-56 int printunsign(unsigned int n) {
>>>>>>> parent of 8294ac5... Start Int13
=======
;-57 }

;-58 

;-59 int printunsign(unsigned int n) {
>>>>>>> parent of aeed850... working

 LEAVE
 ret
ENDP

printunsign: PROC
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-53     unsigned int e;

;-54     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;12 var unsg word n = bp+4
;13 var unsg word e = bp-2;
=======
;-60     unsigned int e;
=======
;-57     unsigned int e;
>>>>>>> parent of 8294ac5... Start Int13

;-58     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;14 var unsg word n = bp+4
;15 var unsg word e = bp-2;
>>>>>>> parent of aeed850... working
=======
;-60     unsigned int e;

;-61     if (n >= 10) {

;Function : printunsign, Number local Var: 2
; # type sign width local variables
;14 var unsg word n = bp+4
;15 var unsg word e = bp-2;
>>>>>>> parent of aeed850... working
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsign5
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-55         e=n/10;
=======
;-62         e=n/10;
>>>>>>> parent of aeed850... working
=======
;-59         e=n/10;
>>>>>>> parent of 8294ac5... Start Int13
=======
;-62         e=n/10;
>>>>>>> parent of aeed850... working

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-56         printunsign(e);
=======
;-63         printunsign(e);
>>>>>>> parent of aeed850... working
=======
;-60         printunsign(e);
>>>>>>> parent of 8294ac5... Start Int13
=======
;-63         printunsign(e);
>>>>>>> parent of aeed850... working

 push word [bp-2]
 call printunsign
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-57         }

;-58     n=n%10;
=======
;-64         }

;-65     n=n%10;
>>>>>>> parent of aeed850... working
=======
;-61         }

;-62     n=n%10;
>>>>>>> parent of 8294ac5... Start Int13
=======
;-64         }

;-65     n=n%10;
>>>>>>> parent of aeed850... working

.printunsign5:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-59     n+='0';

 add  word[bp+4], 48
;-60     putch(n);
=======
=======
>>>>>>> parent of aeed850... working
;-66     n+='0';

 add  word[bp+4], 48
;-67     putch(n);
<<<<<<< HEAD
>>>>>>> parent of aeed850... working
=======
;-63     n+='0';

 add  word[bp+4], 48
;-64     putch(n);
>>>>>>> parent of 8294ac5... Start Int13
=======
>>>>>>> parent of aeed850... working

 push word [bp+4]
 call putch
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-61 }

;-62 

;-63 int ShowRegister() {
=======
;-68 }

;-69 int ShowRegister() {
>>>>>>> parent of aeed850... working
=======
;-65 }

;-66 

;-67 int ShowRegister() {
>>>>>>> parent of 8294ac5... Start Int13
=======
;-68 }

;-69 int ShowRegister() {
>>>>>>> parent of aeed850... working

 LEAVE
 ret
ENDP

ShowRegister: PROC
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-64     asm mov [vAX], ax

 mov [vAX], ax
;-65     asm mov [vBX], bx

 mov [vBX], bx
;-66     asm mov [vCX], cx

 mov [vCX], cx
;-67     asm mov [vDX], dx

 mov [vDX], dx
;-68     asm mov [vSP], sp

 mov [vSP], sp
;-69     asm mov [vBP], bp

 mov [vBP], bp
;-70     asm mov ax, cs

 mov ax, cs
;-71     asm mov [vCS], ax

 mov [vCS], ax
;-72     asm mov ax, ds

 mov ax, ds
;-73     asm mov [vDS], ax

 mov [vDS], ax
;-74     asm mov ax, ss

 mov ax, ss
;-75     asm mov [vSS], ax

 mov [vSS], ax
;-76     asm mov ax, es

 mov ax, es
;-77     asm mov [vES], ax

 mov [vES], ax
;-78     putch(10);
=======
;-70     asm mov [vAX], ax
=======
;-68     asm mov [vAX], ax
>>>>>>> parent of 8294ac5... Start Int13

 mov [vAX], ax
;-69     asm mov [vBX], bx

 mov [vBX], bx
;-70     asm mov [vCX], cx

 mov [vCX], cx
;-71     asm mov [vDX], dx

 mov [vDX], dx
;-72     asm mov [vSP], sp

 mov [vSP], sp
;-73     asm mov [vBP], bp

 mov [vBP], bp
;-74     asm mov ax, cs

 mov ax, cs
;-75     asm mov [vCS], ax

 mov [vCS], ax
;-76     asm mov ax, ds

 mov ax, ds
;-77     asm mov [vDS], ax

 mov [vDS], ax
;-78     asm mov ax, ss

 mov ax, ss
;-79     asm mov [vSS], ax

 mov [vSS], ax
;-80     asm mov ax, es

 mov ax, es
;-81     asm mov [vES], ax

 mov [vES], ax
<<<<<<< HEAD
;-84     putch(10);
>>>>>>> parent of aeed850... working
=======
;-82     putch(10);
>>>>>>> parent of 8294ac5... Start Int13
=======
;-70     asm mov [vAX], ax

 mov [vAX], ax
;-71     asm mov [vBX], bx

 mov [vBX], bx
;-72     asm mov [vCX], cx

 mov [vCX], cx
;-73     asm mov [vDX], dx

 mov [vDX], dx
;-74     asm mov [vSP], sp

 mov [vSP], sp
;-75     asm mov [vBP], bp

 mov [vBP], bp
;-76     asm mov ax, cs

 mov ax, cs
;-77     asm mov [vCS], ax

 mov [vCS], ax
;-78     asm mov ax, ds

 mov ax, ds
;-79     asm mov [vDS], ax

 mov [vDS], ax
;-80     asm mov ax, ss

 mov ax, ss
;-81     asm mov [vSS], ax

 mov [vSS], ax
;-82     asm mov ax, es

 mov ax, es
;-83     asm mov [vES], ax

 mov [vES], ax
;-84     putch(10);
>>>>>>> parent of aeed850... working

 push 10
 call putch
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-79     cputs( "AX="); printhex16(vAX);
=======
;-85     cputs( "AX="); printhex16(vAX);
>>>>>>> parent of aeed850... working
=======
;-83     cputs( "AX="); printhex16(vAX);
>>>>>>> parent of 8294ac5... Start Int13
=======
;-85     cputs( "AX="); printhex16(vAX);
>>>>>>> parent of aeed850... working

 push ShowRegister_0
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-80     cputs(",BX="); printhex16(vBX);
=======
;-86     cputs(",BX="); printhex16(vBX);
>>>>>>> parent of aeed850... working
=======
;-84     cputs(",BX="); printhex16(vBX);
>>>>>>> parent of 8294ac5... Start Int13
=======
;-86     cputs(",BX="); printhex16(vBX);
>>>>>>> parent of aeed850... working

 push ShowRegister_1
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-81     cputs(",CX="); printhex16(vCX);
=======
;-87     cputs(",CX="); printhex16(vCX);
>>>>>>> parent of aeed850... working
=======
;-85     cputs(",CX="); printhex16(vCX);
>>>>>>> parent of 8294ac5... Start Int13
=======
;-87     cputs(",CX="); printhex16(vCX);
>>>>>>> parent of aeed850... working

 push ShowRegister_2
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-82     cputs(",DX="); printhex16(vDX);
=======
;-88     cputs(",DX="); printhex16(vDX);
>>>>>>> parent of aeed850... working
=======
;-86     cputs(",DX="); printhex16(vDX);
>>>>>>> parent of 8294ac5... Start Int13
=======
;-88     cputs(",DX="); printhex16(vDX);
>>>>>>> parent of aeed850... working

 push ShowRegister_3
 call cputs
 add  sp, 2
 push word [vDX]
 call printhex16
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-83     cputs(",SP="); printhex16(vSP);
=======
;-89     cputs(",SP="); printhex16(vSP);
>>>>>>> parent of aeed850... working
=======
;-87     cputs(",SP="); printhex16(vSP);
>>>>>>> parent of 8294ac5... Start Int13
=======
;-89     cputs(",SP="); printhex16(vSP);
>>>>>>> parent of aeed850... working

 push ShowRegister_4
 call cputs
 add  sp, 2
 push word [vSP]
 call printhex16
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-84     cputs(",BP="); printhex16(vBP);
=======
;-90     cputs(",BP="); printhex16(vBP);
>>>>>>> parent of aeed850... working
=======
;-88     cputs(",BP="); printhex16(vBP);
>>>>>>> parent of 8294ac5... Start Int13
=======
;-90     cputs(",BP="); printhex16(vBP);
>>>>>>> parent of aeed850... working

 push ShowRegister_5
 call cputs
 add  sp, 2
 push word [vBP]
 call printhex16
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-85     cputs(",CS="); printhex16(vCS);
=======
;-91     cputs(",CS="); printhex16(vCS);
>>>>>>> parent of aeed850... working
=======
;-89     cputs(",CS="); printhex16(vCS);
>>>>>>> parent of 8294ac5... Start Int13
=======
;-91     cputs(",CS="); printhex16(vCS);
>>>>>>> parent of aeed850... working

 push ShowRegister_6
 call cputs
 add  sp, 2
 push word [vCS]
 call printhex16
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-86     cputs(",DS="); printhex16(vDS);
=======
;-92     cputs(",DS="); printhex16(vDS);
>>>>>>> parent of aeed850... working
=======
;-90     cputs(",DS="); printhex16(vDS);
>>>>>>> parent of 8294ac5... Start Int13
=======
;-92     cputs(",DS="); printhex16(vDS);
>>>>>>> parent of aeed850... working

 push ShowRegister_7
 call cputs
 add  sp, 2
 push word [vDS]
 call printhex16
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-87     cputs(",SS="); printhex16(vSS);
=======
;-93     cputs(",SS="); printhex16(vSS);
>>>>>>> parent of aeed850... working
=======
;-91     cputs(",SS="); printhex16(vSS);
>>>>>>> parent of 8294ac5... Start Int13
=======
;-93     cputs(",SS="); printhex16(vSS);
>>>>>>> parent of aeed850... working

 push ShowRegister_8
 call cputs
 add  sp, 2
 push word [vSS]
 call printhex16
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-88     cputs(",ES="); printhex16(vES);
=======
;-94     cputs(",ES="); printhex16(vES);
>>>>>>> parent of aeed850... working
=======
;-92     cputs(",ES="); printhex16(vES);
>>>>>>> parent of 8294ac5... Start Int13
=======
;-94     cputs(",ES="); printhex16(vES);
>>>>>>> parent of aeed850... working

 push ShowRegister_9
 call cputs
 add  sp, 2
 push word [vES]
 call printhex16
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-89 }

;-90 

;-91 

;-92 //--------------------------------  disk IO  -------------------

;-93 char BIOS_ERR=0;
=======
;-95 }
=======
;-93 }
>>>>>>> parent of 8294ac5... Start Int13

;-94 

;-95 //Int = pushf + call far

<<<<<<< HEAD
;-98 char BIOS_ERR=0;
>>>>>>> parent of aeed850... working
=======
;-96 //Int = pushf + push cs + push offset DOS_START + jmp far cs:VecOldOfs

;-97 int DosInt() {
>>>>>>> parent of 8294ac5... Start Int13
=======
;-95 }

;-96 

;-97 //--------------------------------  disk IO  -------------------

;-98 char BIOS_ERR=0;
>>>>>>> parent of aeed850... working

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
<<<<<<< HEAD
BIOS_ERR db 0
<<<<<<< HEAD
<<<<<<< HEAD
;-94 int  BIOS_Status=0;

BIOS_Status dw 0
;-95 char DiskBuf [512];

section .bss
absolute 4096
DiskBuf resb 512
section .text
;-96 char Drive;

Drive db 0
;-97 int  Cylinders;

Cylinders dw 0
;-98 char Sectors;

Sectors db 0
;-99 char Heads;

Heads db 0
;-100 char Attached;

Attached db 0
;-101 int  ParmTableSeg;

ParmTableSeg dw 0
;-102 int  ParmTableOfs;

ParmTableOfs dw 0
;-103 char DriveType;

DriveType db 0
;-104 //hard disk partition structure

;-105 unsigned char ptBootable;	//80h = active partition, else 00

ptBootable db 0
;-106 unsigned char ptStartHead;	//

ptStartHead db 0
;-107 unsigned char ptStartSector;	//bits 0-5

ptStartSector db 0
;-108 unsigned int  ptStartCylinder;//bits 8,9 in bits 6,7 of sector

ptStartCylinder dw 0
;-109 unsigned char ptFileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=hugePart

ptFileSystem db 0
;-110 unsigned char ptEndHead;		//

ptEndHead db 0
;-111 unsigned char ptEndSector;	//bits 0-5

ptEndSector db 0
;-112 unsigned int  ptEndCylinder;	//bits 8,9 in bits 6,7 of sector

ptEndCylinder dw 0
;-113 unsigned int ptStartSectorlo;//sectors preceding partition

ptStartSectorlo dw 0
;-114 unsigned int ptStartSectorhi;

ptStartSectorhi dw 0
;-115 unsigned int ptPartLenlo;    //length of partition in sectors

ptPartLenlo dw 0
;-116 unsigned int ptPartLenhi;

ptPartLenhi dw 0
;-117 

;-118 

;-119 int Int13hRW(char rw, char drive, char head, int cyl, int sector,


Int13hRW: PROC
;-120 	int count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-121 	BIOS_ERR=0;	

;Function : Int13hRW, Number local Var: 8
; # type sign width local variables
;35 var sign byte rw = bp+4
;36 var sign byte drive = bp+6
;37 var sign byte head = bp+8
;38 var sign word cyl = bp+10
;39 var sign word sector = bp+12
;40 var sign word count = bp+14
;41 var sign word BufSeg = bp+16
;42 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-122 	dl=drive;

 mov  dl, [bp+6]
;-123 	dh=head;

 mov  dh, [bp+8]
;-124 	es=BufSeg;

 mov  es, [bp+16]
;-125 	bx=BufOfs;

 mov  bx, [bp+18]
;-126 	cx=cyl;	

 mov  cx, [bp+10]
;-127 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-128 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-129 	sector &= 0x3F;//only 6 bits for sector

 and  word[bp+12], 63
;-130 	cl += sector;

 add  cl, [bp+12]
;-131 	ch=cyl;//low byte of cyl in ch

 mov  ch, [bp+10]
;-132 	

;-133 	al=count;

 mov  al, [bp+14]
;-134 	ah=rw;

 mov  ah, [bp+4]
;-135 	inth 0x13;

 int  19
;-136     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-137 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-138 }

;-139 int Int13hRawIO(char drive, char function) {
=======
;-99 unsigned int  BIOS_Status=0;
=======
>>>>>>> parent of 8294ac5... Start Int13

DosInt: PROC
;-98     inth 0x21;

 int  33
;-99     __emit__(0x73, 04); //jnc over DOS_ERR++

 db 115,4
;-100     DOS_ERR++;

 inc  byte[DOS_ERR]
;-101 }

;-102 

;-103 unsigned char JmpFarHook=0xEA;//start struct

 ret
ENDP
JmpFarHook db 234
;-104 unsigned int VecOldOfs;

VecOldOfs dw 0
;-105 unsigned int VecOldSeg;//end struct

VecOldSeg dw 0
;-106 

;-107 int GetIntVec(char c) {


GetIntVec: PROC
;-108     asm push es

;Function : GetIntVec, Number local Var: 1
; # type sign width local variables
;17 var sign byte c = bp+4;
 ENTER  0,0
 push es
;-109     al=c;

 mov  al, [bp+4]
;-110     ah=0x35;

 mov  ah, 53
;-111     DosInt();

 call DosInt
;-112     asm mov [VecOldOfs], bx

 mov [VecOldOfs], bx
;-113     asm mov [VecOldSeg], es

 mov [VecOldSeg], es
;-114     asm pop es

 pop es
;-115 }

;-116 

;-117 unsigned int VecNewOfs;

 LEAVE
 ret
ENDP
VecNewOfs dw 0
;-118 unsigned int VecNewSeg;

VecNewSeg dw 0
;-119 

;-120 int GetIntVecNew(char c) {


GetIntVecNew: PROC
;-121     asm push es

;Function : GetIntVecNew, Number local Var: 1
; # type sign width local variables
;19 var sign byte c = bp+4;
 ENTER  0,0
 push es
;-122     al=c;

 mov  al, [bp+4]
;-123     ah=0x35;

 mov  ah, 53
;-124     DosInt();

 call DosInt
;-125     asm mov [VecNewOfs], bx

 mov [VecNewOfs], bx
;-126     asm mov [VecNewSeg], es

 mov [VecNewSeg], es
;-127     asm pop es

 pop es
;-128 }

;-129 /*

;-130 int SetIntVecDos(char *adr) {

;-131     asm push ds

;-132     ax=cs;

;-133     ds=ax;

;-134 //    dx= &adr; is mov instead of lea

;-135     asm lea dx, [bp+4]; *adr

;-136     ax=0x2521;//new addr in ds:dx

;-137     DosInt();

;-138     asm pop ds

;-139 }

<<<<<<< HEAD
;-144 int Int13hRaw(char drive, char function) {
>>>>>>> parent of aeed850... working
=======
;-140 */

;-141 unsigned int DS_old;
>>>>>>> parent of 8294ac5... Start Int13
=======
;-99 unsigned int  BIOS_Status=0;

BIOS_Status dw 0
;-100 char DiskBuf [512];

section .bss
absolute 8192
DiskBuf resb 512
section .text
;-101 char Drive;

Drive db 0
;-102 unsigned int  Cylinders;

Cylinders dw 0
;-103 char Sectors;

Sectors db 0
;-104 char Heads;

Heads db 0
;-105 char Attached;

Attached db 0
;-106 int  ParmTableSeg;

ParmTableSeg dw 0
;-107 int  ParmTableOfs;

ParmTableOfs dw 0
;-108 char DriveType;

DriveType db 0
;-109 int  PartNo;

PartNo dw 0
;-110 //hard disk partition structure

;-111 unsigned char ptBootable;	//80h = active partition, else 00

ptBootable db 0
;-112 unsigned char ptStartHead;	//

ptStartHead db 0
;-113 unsigned char ptStartSector;	//bits 0-5

ptStartSector db 0
;-114 unsigned int  ptStartCylinder;//bits 8,9 in bits 6,7 of sector

ptStartCylinder dw 0
;-115 unsigned char ptFileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=hugePart

ptFileSystem db 0
;-116 unsigned char ptEndHead;		//

ptEndHead db 0
;-117 unsigned char ptEndSector;	//bits 0-5

ptEndSector db 0
;-118 unsigned int  ptEndCylinder;	//bits 8,9 in bits 6,7 of sector

ptEndCylinder dw 0
;-119 unsigned int ptStartSectorlo;//sectors preceding partition

ptStartSectorlo dw 0
;-120 unsigned int ptStartSectorhi;

ptStartSectorhi dw 0
;-121 unsigned int ptPartLenlo;    //length of partition in sectors

ptPartLenlo dw 0
;-122 unsigned int ptPartLenhi;

ptPartLenhi dw 0
;-123 

;-124 int Int13hRW(char rw, char drive, char head, int cyl, char sector,


Int13hRW: PROC
;-125 	char count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-126 	BIOS_ERR=0;	

;Function : Int13hRW, Number local Var: 8
; # type sign width local variables
;38 var sign byte rw = bp+4
;39 var sign byte drive = bp+6
;40 var sign byte head = bp+8
;41 var sign word cyl = bp+10
;42 var sign byte sector = bp+12
;43 var sign byte count = bp+14
;44 var sign word BufSeg = bp+16
;45 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-127 	dl=drive;

 mov  dl, [bp+6]
;-128 	dh=head;//may include 2 more cylinder bits

 mov  dh, [bp+8]
;-129 	es=BufSeg;

 mov  es, [bp+16]
;-130 	bx=BufOfs;

 mov  bx, [bp+18]
;-131 	cx=cyl;	

 mov  cx, [bp+10]
;-132 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-133 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-134 	sector &= 0x3F;//only 6 bits for sector

 and  byte[bp+12], 63
;-135 	cl += sector;

 add  cl, [bp+12]
;-136 	ch=cyl;//low byte of cyl in ch, word 2 byte

 mov  ch, [bp+10]
;-137 	

;-138 	al=count;

 mov  al, [bp+14]
;-139 	ah=rw;

 mov  ah, [bp+4]
;-140 	inth 0x13;

 int  19
;-141     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-142 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-143 }

;-144 int Int13hRaw(char drive, char function) {
>>>>>>> parent of aeed850... working

 LEAVE
 ret
ENDP
DS_old dw 0
;-142 

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
Int13hRawIO: PROC
;-140 	BIOS_ERR=0;	
=======
Int13hRaw: PROC
;-145 	BIOS_ERR=0;	
>>>>>>> parent of aeed850... working

;Function : Int13hRaw, Number local Var: 2
; # type sign width local variables
<<<<<<< HEAD
;35 var sign byte drive = bp+4
;36 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-141 	dl=drive;

 mov  dl, [bp+4]
;-142 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-143 	inth 0x13;

 int  19
;-144     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-145 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-146 }

;-147 int Int13hError() {
=======
;38 var sign byte drive = bp+4
;39 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-146 	dl=drive;
=======
;-143 int DOS_START() {

>>>>>>> parent of 8294ac5... Start Int13
=======
Int13hRaw: PROC
;-145 	BIOS_ERR=0;	

;Function : Int13hRaw, Number local Var: 2
; # type sign width local variables
;38 var sign byte drive = bp+4
;39 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-146 	dl=drive;

 mov  dl, [bp+4]
;-147 	ah=function;//0=reset, 1=status, 8=parms

 mov  ah, [bp+6]
;-148 	inth 0x13;

 int  19
;-149     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-150 	BIOS_ERR++;//Status or error code in AX

 inc  byte[BIOS_ERR]
;-151 }

;-152 int Int13hError() {
>>>>>>> parent of aeed850... working

DOS_START: PROC
;-144     count21h++;

 inc  word[count21h]
;-145     if (ah != 0x80) {

 cmp  ah, 128
 je  .DOS_START6
;-146         asm jmp JmpFarHook; goto old kernel

 jmp JmpFarHook; goto old kernel
;-147     }

;-148         ax=ds;

<<<<<<< HEAD
;-152 int Int13hError() {
>>>>>>> parent of aeed850... working
=======
.DOS_START6:
 mov  ax, ds
;-149         __emit__(0x2E);//cs seg for next instruction
>>>>>>> parent of 8294ac5... Start Int13

 db 46
;-150         asm mov [DS_old], ax

<<<<<<< HEAD
Int13hError: PROC
<<<<<<< HEAD
<<<<<<< HEAD
;-148 	cputs(" ** disk error AX=");
=======
;-153 	cputs("** DISK ERROR AX=");
>>>>>>> parent of aeed850... working
=======
;-153 	cputs("** DISK ERROR AX=");
>>>>>>> parent of aeed850... working

 push Int13hError_0
 call cputs
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-149 	printhex16(BIOS_Status);
=======
;-154 	printhex16(BIOS_Status);
>>>>>>> parent of aeed850... working
=======
;-154 	printhex16(BIOS_Status);
>>>>>>> parent of aeed850... working

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-150 //	cputs(" BIOS_ERR=");

;-151 //	printunsign(BIOS_ERR);

;-152 	cputs(".  ");
=======
;-155 	cputs(".  ");
>>>>>>> parent of aeed850... working
=======
;-155 	cputs(".  ");
>>>>>>> parent of aeed850... working

 push Int13hError_1
 call cputs
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-153 //	putch(10);

;-154 	BIOS_Status=Int13hRawIO(Drive, 0);//Reset
=======
;-156 	BIOS_Status=Int13hRaw(Drive, 0);//Reset
>>>>>>> parent of aeed850... working
=======
;-156 	BIOS_Status=Int13hRaw(Drive, 0);//Reset
>>>>>>> parent of aeed850... working

 push 0
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
<<<<<<< HEAD
<<<<<<< HEAD
;-155 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-156 }	

;-157 

;-158 int PrintDriveParms() {
=======
;-157 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-158 }	

;-159 

;-160 int Params(char drive) {
>>>>>>> parent of aeed850... working
=======
 mov [DS_old], ax
;-151         ax=cs;// cs seg is the only seg we know the value

 mov  ax, cs
;-152         ds=ax;

 mov  ds, ax
;-153 

;-154         asm sti; enable interrupts

 sti; enable interrupts
;-155         cputs("Inside DOS_START:");

 push DOS_START_0
 call cputs
 add  sp, 2
;-156         ShowRegister();
>>>>>>> parent of 8294ac5... Start Int13

 call ShowRegister
;-157 

<<<<<<< HEAD
<<<<<<< HEAD
PrintDriveParms: PROC
;-159 	asm mov [Heads],        dh

 mov [Heads],        dh
;-160 	Heads++;//1 to 256

 inc  byte[Heads]
;-161 	asm mov [Attached],     dl

 mov [Attached],     dl
;-162 	asm mov [ParmTableSeg], es

 mov [ParmTableSeg], es
;-163 	asm mov [ParmTableOfs], di

 mov [ParmTableOfs], di
;-164 	asm mov [DriveType],    bl;BiosType(biosval)

 mov [DriveType],    bl;BiosType(biosval)
;-165 	// CX =       ---CH--- ---CL---

;-166 	// cylinder : 76543210 98

;-167 	// sector   :            543210	

;-168 	asm mov [Sectors],      cl

 mov [Sectors],      cl
;-169 	Sectors &= 0x3F;// 63

 and  byte[Sectors], 63
;-170 	Sectors++;//1 to 64

 inc  byte[Sectors]
;-171 

;-172 	asm mov [Cylinders],    cl	

 mov [Cylinders],    cl	
;-173 	Cylinders &= 0xC0;//;bit 9 and 10

 and  word[Cylinders], 192
;-174 	Cylinders = Cylinders << 2;//compiler flaw:
=======
Params: PROC
;-161 	cputs("(AH=08)Drive Params:");
=======
;-158         cputs(" count21h=");
>>>>>>> parent of 8294ac5... Start Int13

 push DOS_START_1
 call cputs
 add  sp, 2
;-159         printunsign(count21h);

 push word [count21h]
 call printunsign
 add  sp, 2
;-160         cputs(" DS: old=");

 push DOS_START_2
 call cputs
 add  sp, 2
;-161         printunsign(DS_old);

 push word [DS_old]
 call printunsign
 add  sp, 2
;-162 

;-163         ax=DS_old;//restore ds Seg

 mov  ax, [DS_old]
;-164         ds=ax;

 mov  ds, ax
;-165         asm iret

 iret
;-166 }

;-167 

;-168 int setblock(unsigned int i) {

 ret
DOS_START_0 db "Inside DOS_START:",0
DOS_START_1 db " count21h=",0
DOS_START_2 db " DS: old=",0
ENDP

setblock: PROC
;-169     DOS_ERR=0;
=======
;-157 	BIOS_ERR=0;

 mov ax, 0
 mov byte [BIOS_ERR], al
;-158 }	

;-159 

;-160 int Params(char drive) {

 ret
Int13hError_0 db "** DISK ERROR AX=",0
Int13hError_1 db ".  ",0
ENDP

Params: PROC
;-161 	cputs("(AH=08)Drive Params:");

;Function : Params, Number local Var: 1
; # type sign width local variables
;38 var sign byte drive = bp+4;
 ENTER  0,0
 push Params_0
 call cputs
 add  sp, 2
;-162 	BIOS_Status=Int13hRaw(drive, 8);

 push 8
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
;-163 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Params6
 call Int13hError
;-164 	else {

 jmp .Params7
.Params6:
;-165 		cputs("AH Return Code:");

 push Params_1
 call cputs
 add  sp, 2
;-166 		printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-167 		asm mov [Heads],        dh

 mov [Heads],        dh
;-168 		Heads++;

 inc  byte[Heads]
;-169 		asm mov [Attached],     dl

 mov [Attached],     dl
;-170 		// CX =       ---CH--- ---CL---

;-171 		// cylinder : 76543210 98

;-172 		// sector   :            543210	

;-173 		asm mov [Sectors],      cl

 mov [Sectors],      cl
;-174 		Sectors &= 0x3F;// 63

 and  byte[Sectors], 63
;-175 //		Sectors++;//1 to 64

;-176 	

;-177 		asm mov [Cylinders],    cx	

 mov [Cylinders],    cx	
;-178 		Cylinders &= 0xC0;//;bit 9 and 10 only
>>>>>>> parent of aeed850... working

;Function : setblock, Number local Var: 1
; # type sign width local variables
;20 var unsg word i = bp+4;
 ENTER  0,0
 mov ax, 0
 mov byte [DOS_ERR], al
;-170     bx=i;

 mov  bx, [bp+4]
;-171     ax=cs;

 mov  ax, cs
;-172     es=ax;

<<<<<<< HEAD
 and  word[Cylinders], 192
;-179 		Cylinders = Cylinders << 2;//compiler flaw:
<<<<<<< HEAD
>>>>>>> parent of aeed850... working
=======
>>>>>>> parent of aeed850... working

 mov ax, [Cylinders]
 shl ax, 2
 mov word [Cylinders], ax
<<<<<<< HEAD
<<<<<<< HEAD
;-175 	asm add [Cylinders],    ch;//byte add, low byte is empty	

 add [Cylinders],    ch;//byte add, low byte is empty	
;-176 //	Cylinders++;//1 to 1024	

;-177 

;-178 	putch(10);
=======
;-180 		asm add [Cylinders],    ch;//byte add, low byte is empty	
=======
 mov  es, ax
;-173     ax=0x4A00;

 mov  ax, 18944
;-174     //modify mem Alloc. IN: ES=Block Seg, BX=size in para
>>>>>>> parent of 8294ac5... Start Int13

;-175     DosInt();

<<<<<<< HEAD
;-182 		putch(10);
>>>>>>> parent of aeed850... working
=======
;-180 		asm add [Cylinders],    ch;//byte add, low byte is empty	

 add [Cylinders],    ch;//byte add, low byte is empty	
;-181 	

;-182 		putch(10);
>>>>>>> parent of aeed850... working

 push 10
 call putch
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-179 	cputs("HD Params:");		 	//printhex8(Drive);

 push PrintDriveParms_0
 call cputs
 add  sp, 2
;-180 	cputs(" Cyl=");						printunsign(Cylinders);
=======
;-183 		cputs("CHS=");				printunsign(Cylinders);
>>>>>>> parent of aeed850... working
=======
;-183 		cputs("CHS=");				printunsign(Cylinders);
>>>>>>> parent of aeed850... working

 push Params_2
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-181 	cputs(", Sec=");					printunsign(Sectors);
=======
;-184 		putch('/');					printunsign(Heads);
>>>>>>> parent of aeed850... working
=======
 call DosInt
;-176     asm mov [vAX], ax

 mov [vAX], ax
;-177     asm mov [vBX], bx

 mov [vBX], bx
;-178     if (DOS_ERR) cputs(" ***Error SetBlock***");
>>>>>>> parent of 8294ac5... Start Int13

 mov al, [DOS_ERR]
 or  al, al
 je .setblock7
 push setblock_0
 call cputs
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-182 	cputs(", Hd=");						printunsign(Heads);
=======
;-185 		putch('/');					printunsign(Sectors);
>>>>>>> parent of aeed850... working
=======
;-179     cputs("SetBlock AX:"); printhex16(vAX);
>>>>>>> parent of 8294ac5... Start Int13

.setblock7:
 push setblock_1
 call cputs
 add  sp, 2
 push word [vAX]
 call printhex16
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-183 	cputs(", Attached=");				printhex8(Attached);
=======
;-186 		cputs(", NoDrives=");		printhex8(Attached);
>>>>>>> parent of aeed850... working
=======
;-180     cputs(",BX:"); printhex16(vBX);
>>>>>>> parent of 8294ac5... Start Int13

 push setblock_2
=======
;-184 		putch('/');					printunsign(Heads);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Heads]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-185 		putch('/');					printunsign(Sectors);

 push 47
 call putch
 add  sp, 2
 mov al, byte [Sectors]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-186 		cputs(", NoDrives=");		printhex8(Attached);

 push Params_3
>>>>>>> parent of aeed850... working
 call cputs
 add  sp, 2
<<<<<<< HEAD
 mov al, byte [Attached]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-184 	putch(10);	

 push 10
 call putch
 add  sp, 2
;-185 	cputs("DriveType (FL)=");			printhex8(DriveType);

 push PrintDriveParms_5
 call cputs
 add  sp, 2
 mov al, byte [DriveType]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-186 	cputs(", ParmTable=");				printhex16(ParmTableSeg);

 push PrintDriveParms_6
 call cputs
 add  sp, 2
 push word [ParmTableSeg]
 call printhex16
 add  sp, 2
;-187 	putch(':');							printhex16(ParmTableOfs);

 push 58
 call putch
 add  sp, 2
 push word [ParmTableOfs]
 call printhex16
 add  sp, 2
;-188 	putch('.');
=======
;-187 		putch('.');
>>>>>>> parent of aeed850... working
=======
;-187 		putch('.');
>>>>>>> parent of aeed850... working

 push 46
 call putch
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-189 }

;-190 

;-191 int Params(drive) {

 ret
PrintDriveParms_0 db "HD Params:",0
PrintDriveParms_1 db " Cyl=",0
PrintDriveParms_2 db ", Sec=",0
PrintDriveParms_3 db ", Hd=",0
PrintDriveParms_4 db ", Attached=",0
PrintDriveParms_5 db "DriveType (FL)=",0
PrintDriveParms_6 db ", ParmTable=",0
ENDP

Params: PROC
;-192 	putch(10);	

;Function : Params, Number local Var: 1
; # type sign width local variables
;35 var sign word drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
;-193 	cputs("(8)Drive Params :");

 push Params_0
 call cputs
 add  sp, 2
;-194 	BIOS_Status=Int13hRawIO(drive, 8);//error

 push 8
 push word [bp+4]
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-195 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .Params6
 call Int13hError
;-196 	printhex16(BIOS_Status);	

.Params6:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-197     PrintDriveParms();

 call PrintDriveParms
;-198 

;-199 	putch(10);

 push 10
 call putch
 add  sp, 2
;-200 	cputs("(10h)Status :");

 push Params_1
 call cputs
 add  sp, 2
;-201 	BIOS_Status=Int13hRawIO(drive, 0x10);	

 push 16
 push word [bp+4]
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-202 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Params7
 call Int13hError
;-203 	printhex16(BIOS_Status);	

.Params7:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-204 }

;-205 

;-206 int Status(drive) {
=======
;-188 	}

;-189 }
=======
;-188 	}

;-189 }

.Params7:
;-190 

;-191 int Status(drive) {

 LEAVE
 ret
Params_0 db "(AH=08)Drive Params:",0
Params_1 db "AH Return Code:",0
Params_2 db "CHS=",0
Params_3 db ", NoDrives=",0
ENDP
>>>>>>> parent of aeed850... working

.Params7:
;-190 

;-191 int Status(drive) {
>>>>>>> parent of aeed850... working

 LEAVE
 ret
Params_0 db "(AH=08)Drive Params:",0
Params_1 db "AH Return Code:",0
Params_2 db "CHS=",0
Params_3 db ", NoDrives=",0
=======
 push word [vBX]
 call printhex16
 add  sp, 2
;-181 }

;-182 

;-183 //-------------------  disk IO  -----------------

;-184 char BIOS_ERR=0;

 LEAVE
 ret
setblock_0 db " ***Error SetBlock***",0
setblock_1 db "SetBlock AX:",0
setblock_2 db ",BX:",0
>>>>>>> parent of 8294ac5... Start Int13
ENDP
BIOS_ERR db 0
;-185 int  BIOS_Status=0;

<<<<<<< HEAD
Status: PROC
<<<<<<< HEAD
<<<<<<< HEAD
;-207 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;35 var sign word drive = bp+4;
=======
=======
>>>>>>> parent of aeed850... working
;-192 	putch(10);

;Function : Status, Number local Var: 1
; # type sign width local variables
;38 var sign word drive = bp+4;
<<<<<<< HEAD
>>>>>>> parent of aeed850... working
=======
>>>>>>> parent of aeed850... working
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-208 	cputs("(1)Status last Op: AH=FL, AL=HD :");
=======
;-193 	cputs("(1)Status last Op=");
>>>>>>> parent of aeed850... working
=======
;-193 	cputs("(1)Status last Op=");
>>>>>>> parent of aeed850... working

 push Status_0
 call cputs
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-209 	BIOS_Status=Int13hRawIO(drive, 1);	
=======
;-194 	BIOS_Status=Int13hRaw(drive, 1);	
>>>>>>> parent of aeed850... working
=======
;-194 	BIOS_Status=Int13hRaw(drive, 1);	
>>>>>>> parent of aeed850... working

 push 1
 push word [bp+4]
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
<<<<<<< HEAD
<<<<<<< HEAD
;-210 	if (BIOS_ERR) Int13hError();	
=======
;-195 	if (BIOS_ERR) Int13hError();	
>>>>>>> parent of aeed850... working
=======
;-195 	if (BIOS_ERR) Int13hError();	
>>>>>>> parent of aeed850... working

 mov al, [BIOS_ERR]
 or  al, al
 je .Status8
 call Int13hError
<<<<<<< HEAD
<<<<<<< HEAD
;-211 	printhex16(BIOS_Status);	
=======
;-196 	printhex16(BIOS_Status);	
>>>>>>> parent of aeed850... working
=======
;-196 	printhex16(BIOS_Status);	
>>>>>>> parent of aeed850... working

.Status8:
 push word [BIOS_Status]
 call printhex16
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-212 }	

;-213 

;-214 int testDisk(drive) {
=======
;-197 }	
=======
BIOS_Status dw 0
;-186 char DiskBuf[512];

section .bss
absolute 4000
DiskBuf resb 512
section .text
;-187 char Drive;

Drive db 0
;-188 int  Cylinders;

Cylinders dw 0
;-189 int  Sectors;
>>>>>>> parent of 8294ac5... Start Int13

Sectors dw 0
;-190 int  Heads;

<<<<<<< HEAD
;-199 int getPartitionData() {
>>>>>>> parent of aeed850... working
=======
Heads dw 0
;-191 char Attached;
>>>>>>> parent of 8294ac5... Start Int13

Attached db 0
;-192 int  ParmTableSeg;

<<<<<<< HEAD
<<<<<<< HEAD
testDisk: PROC
;-215 	int i; int j; char c;

;-216 	putch(10);
=======
getPartitionData: PROC
;-200 	unsigned int j; char c; 

;-201 	j = PartNo << 4;
>>>>>>> parent of aeed850... working

;Function : getPartitionData, Number local Var: 2
; # type sign width local variables
<<<<<<< HEAD
;35 var sign word drive = bp+4
;36 var sign word i = bp-2
;37 var sign word j = bp-4
;38 var sign byte c = bp-6;
 ENTER  6,0
 push 10
 call putch
 add  sp, 2
;-217 	cputs("ReadStat=");	

 push testDisk_0
 call cputs
 add  sp, 2
;-218 	asm mov [ParmTableSeg], ds

 mov [ParmTableSeg], ds
;-219 	//Offset is in DiskBuf

;-220 	BIOS_Status=Int13hRW(2,drive,0,0,1,1,ParmTableSeg,DiskBuf);

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
;-221 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .testDisk9
 call Int13hError
;-222 //	printhex16(BIOS_Status);	

;-223 	cputs(", Part.Info: Magic=");

.testDisk9:
 push testDisk_1
 call cputs
 add  sp, 2
;-224 	i=510;

 mov ax, 510
 mov [bp-2], ax
;-225 	c = DiskBuf[i];

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov [bp-6], al
;-226 	printhex8(c);

 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-227 	i++;

 inc  word[bp-2]
;-228 	c = DiskBuf[i];
=======
;38 var unsg word j = bp-2
;39 var sign byte c = bp-4;
 ENTER  4,0
 mov ax, [PartNo]
 shl ax, 4
 mov [bp-2], ax
;-202 	j = j + 0x1be;			ptBootable=DiskBuf[j];
=======
ParmTableSeg dw 0
;-193 int  ParmTableOfs;

ParmTableOfs dw 0
;-194 char DriveType;

DriveType db 0
;-195 
>>>>>>> parent of 8294ac5... Start Int13

;-196 int Int13hError() {


Int13hError: PROC
;-197 	cputs("*** disk error #(hex) :");

 push Int13hError_0
 call cputs
 add  sp, 2
;-198 	printhex16(BIOS_Status);	

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-199 }	

;-200 int Int13hRawIO(char drive, char function) {

 ret
Int13hError_0 db "*** disk error #(hex) :",0
ENDP

Int13hRawIO: PROC
;-201 	BIOS_ERR=0;	

;Function : Int13hRawIO, Number local Var: 2
; # type sign width local variables
;31 var sign byte drive = bp+4
;32 var sign byte function = bp+6;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-202 	dl=drive;

 mov  dl, [bp+4]
;-203 	ah=function;//0=reset, 1=status, 8=parms, 10h=hd status

 mov  ah, [bp+6]
;-204 	inth 0x13;

 int  19
;-205     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-206 	BIOS_ERR++;//Status or error code in AH

 inc  byte[BIOS_ERR]
;-207 }

;-208 

<<<<<<< HEAD
 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptFileSystem], al
;-218 	j++;					ptEndHead=DiskBuf[j];
>>>>>>> parent of aeed850... working

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
<<<<<<< HEAD
 mov [bp-6], al
;-229 	printhex8(c);

 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-230 	

;-231 	cputs(",DiskBuf=");

 push testDisk_2
 call cputs
 add  sp, 2
;-232 	printhex16(ParmTableSeg);

 push word [ParmTableSeg]
 call printhex16
 add  sp, 2
;-233 	putch(':');							

 push 58
 call putch
 add  sp, 2
;-234 	printhex16(DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 call printhex16
 add  sp, 2
;-235 	putch('.');

 push 46
 call putch
 add  sp, 2
;-236 

;-237     putch(10);		

 push 10
 call putch
 add  sp, 2
;-238 	i=0;

 mov ax, 0
 mov [bp-2], ax
;-239 	cputs("Part=");

 push testDisk_3
 call cputs
 add  sp, 2
;-240 	printhex8(i);

 push word [bp-2]
 call printhex8
 add  sp, 2
;-241 	j=0x1be;

 mov ax, 446
 mov [bp-4], ax
;-242 	ptBootable=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptBootable], al
;-243 	cputs(",BootId=");
=======
 mov byte [ptEndHead], al
;-219 	j++;					ptEndSector=DiskBuf[j];
=======
;-209 int Int13hRW(char rw, char drive, int head, int cyl, int sector,

 LEAVE
 ret
ENDP
>>>>>>> parent of 8294ac5... Start Int13

Int13hRW: PROC
;-210 	int count, int BufSeg, int BufOfs) {//CHS max. 8GB

;-211 	BIOS_ERR=0;	

;Function : Int13hRW, Number local Var: 8
; # type sign width local variables
;31 var sign byte rw = bp+4
;32 var sign byte drive = bp+6
;33 var sign word head = bp+8
;34 var sign word cyl = bp+10
;35 var sign word sector = bp+12
;36 var sign word count = bp+14
;37 var sign word BufSeg = bp+16
;38 var sign word BufOfs = bp+18;
 ENTER  0,0
 mov ax, 0
 mov byte [BIOS_ERR], al
;-212 	dl=drive;

 mov  dl, [bp+6]
;-213 	dh=head;

 mov  dh, [bp+8]
;-214 	es=BufSeg;

 mov  es, [bp+16]
;-215 	bx=BufOfs;

 mov  bx, [bp+18]
;-216 	cx=cyl;	

 mov  cx, [bp+10]
;-217 	cx &= 0x300;//2 high bits of cyl

 and  cx, 768
;-218 	cx >> 2;//in 2 high bits of cl	

 shr  cx, 2
;-219 	sector &= 0x3F;//only 6 bits for sector

 and  word[bp+12], 63
;-220 	cl += sector;

 add  cl, [bp+12]
;-221 	ch=cyl;//low byte of cyl in ch

 mov  ch, [bp+10]
;-222 	

;-223 	al=count;

 mov  al, [bp+14]
;-224 	ah=rw;

 mov  ah, [bp+4]
;-225 	inth 0x13;

 int  19
;-226     __emit__(0x73, 04); //jnc over BIOS_ERR++

 db 115,4
;-227 	BIOS_ERR++;

 inc  byte[BIOS_ERR]
;-228 }

;-229 int Int13hReset() {

 LEAVE
 ret
ENDP

<<<<<<< HEAD
printPartitionData: PROC
;-240 	putch(10);		
>>>>>>> parent of aeed850... working

=======
;-197 }	

;-198 

;-199 int getPartitionData() {

 LEAVE
 ret
Status_0 db "(1)Status last Op=",0
ENDP

getPartitionData: PROC
;-200 	unsigned int j; char c; 

;-201 	j = PartNo << 4;

;Function : getPartitionData, Number local Var: 2
; # type sign width local variables
;38 var unsg word j = bp-2
;39 var sign byte c = bp-4;
 ENTER  4,0
 mov ax, [PartNo]
 shl ax, 4
 mov [bp-2], ax
;-202 	j = j + 0x1be;			ptBootable=DiskBuf[j];

 mov ax, [bp-2]
 add ax, 446
 mov [bp-2], ax
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptBootable], al
;-203 	j++;					ptStartHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartHead], al
;-204 	j++;					ptStartSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptStartSector], al
;-205 	ah=0;//next line convert byte to word

 mov  ah, 0
;-206 	ptStartCylinder=ptStartSector;	

 mov al, [ptStartSector]
 mov word [ptStartCylinder], ax
;-207 	ptStartSector &= 0x3F;

 and  byte[ptStartSector], 63
;-208 	ptStartSector++;//Sector start with 1

 inc  byte[ptStartSector]
;-209 	ptStartCylinder &= 0xC0;

 and  word[ptStartCylinder], 192
;-210 	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	

 mov ax, [ptStartCylinder]
 shl ax, 2
 mov word [ptStartCylinder], ax
;-211 	j++;

 inc  word[bp-2]
;-212 	ah=0;//byte 2 word

 mov  ah, 0
;-213 	ptStartCylinder=DiskBuf[j] + ptStartCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptStartCylinder]
 mov word [ptStartCylinder], ax
;-214 //	byte add, ok because low byte is empty

;-215 //	ptStartCylinder=ptStartCylinder + DiskBuf[j];//OK

;-216 

;-217 	j++;					ptFileSystem=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptFileSystem], al
;-218 	j++;					ptEndHead=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndHead], al
;-219 	j++;					ptEndSector=DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov byte [ptEndSector], al
;-220 	ah=0;//next line convert byte to word

 mov  ah, 0
;-221 	ptEndCylinder=ptEndSector;//see next 5 line		

 mov al, [ptEndSector]
 mov word [ptEndCylinder], ax
;-222 	ptEndSector &= 0x3F;

 and  byte[ptEndSector], 63
;-223 	ptEndSector++;//Sector start with 1

 inc  byte[ptEndSector]
;-224 	ptEndCylinder &= 0xC0;

 and  word[ptEndCylinder], 192
;-225 	ptEndCylinder = ptEndCylinder << 2;//OK no short cut!	

 mov ax, [ptEndCylinder]
 shl ax, 2
 mov word [ptEndCylinder], ax
;-226 	j++;

 inc  word[bp-2]
;-227 	ah=0;//byte 2 word

 mov  ah, 0
;-228 	ptEndCylinder=DiskBuf[j] + ptEndCylinder;

 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 add ax, [ptEndCylinder]
 mov word [ptEndCylinder], ax
;-229 //	byte add, ok because low byte is empty

;-230 //	ptStartCylinder=ptStartCylinder + DiskBuf[j];//OK

;-231 

;-232 	j++;					ptStartSectorlo = DiskBuf[j];

 inc  word[bp-2]
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov word [ptStartSectorlo], ax
;-233 	j += 2;					ptStartSectorhi = DiskBuf[j];

 add  word[bp-2], 2
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov word [ptStartSectorhi], ax
;-234 	j += 2;					ptPartLenhi = DiskBuf[j];

 add  word[bp-2], 2
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov word [ptPartLenhi], ax
;-235 	j += 2;					ptPartLenlo = DiskBuf[j];

 add  word[bp-2], 2
 mov bx, [bp-2]
 mov al, [DiskBuf + bx]
 mov word [ptPartLenlo], ax
;-236 	j += 2;//next partition entry

 add  word[bp-2], 2
;-237 }

;-238 	

;-239 int printPartitionData() {

 LEAVE
 ret
ENDP

printPartitionData: PROC
;-240 	putch(10);		

>>>>>>> parent of aeed850... working
 push 10
 call putch
 add  sp, 2
;-241 	cputs("No=");			printunsign(PartNo);

 push printPartitionData_0
 call cputs
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-244 	printhex8(ptBootable);
=======
=======
>>>>>>> parent of aeed850... working
 push word [PartNo]
 call printunsign
 add  sp, 2
;-242 	cputs(",Boot=");		printhex8(ptBootable);
<<<<<<< HEAD
>>>>>>> parent of aeed850... working
=======
>>>>>>> parent of aeed850... working

 push printPartitionData_1
 call cputs
 add  sp, 2
 mov al, byte [ptBootable]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-245 	j++;

 inc  word[bp-4]
;-246 	ptStartHead=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptStartHead], al
;-247 	cputs(",StartHd=");
=======
;-243 	cputs(" ID=");			printunsign(ptFileSystem);

 push printPartitionData_2
 call cputs
 add  sp, 2
 mov al, byte [ptFileSystem]
=======
;-243 	cputs(" ID=");			printunsign(ptFileSystem);

 push printPartitionData_2
 call cputs
 add  sp, 2
 mov al, byte [ptFileSystem]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-244 	cputs(",Start HSC=");	printunsign(ptStartHead);

 push printPartitionData_3
 call cputs
 add  sp, 2
 mov al, byte [ptStartHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-245 	cputs("/");				printunsign(ptStartSector);	

 push printPartitionData_4
 call cputs
 add  sp, 2
 mov al, byte [ptStartSector]
>>>>>>> parent of aeed850... working
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
<<<<<<< HEAD
;-244 	cputs(",Start HSC=");	printunsign(ptStartHead);

 push printPartitionData_3
 call cputs
 add  sp, 2
 mov al, byte [ptStartHead]
=======
;-246 	cputs("/");				printunsign(ptStartCylinder);

 push printPartitionData_5
 call cputs
 add  sp, 2
 push word [ptStartCylinder]
 call printunsign
 add  sp, 2
;-247 	cputs("-");				printunsign(ptEndHead);

 push printPartitionData_6
 call cputs
 add  sp, 2
 mov al, byte [ptEndHead]
>>>>>>> parent of aeed850... working
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
<<<<<<< HEAD
;-245 	cputs("/");				printunsign(ptStartSector);	
>>>>>>> parent of aeed850... working

 push printPartitionData_4
 call cputs
 add  sp, 2
<<<<<<< HEAD
;-248 	printhex8(ptStartHead);
=======
 mov al, byte [ptStartSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-246 	cputs("/");				printunsign(ptStartCylinder);
>>>>>>> parent of aeed850... working

 push printPartitionData_5
 call cputs
 add  sp, 2
 push word [ptStartCylinder]
 call printunsign
 add  sp, 2
;-247 	cputs("-");				printunsign(ptEndHead);

 push printPartitionData_6
 call cputs
 add  sp, 2
 mov al, byte [ptEndHead]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
<<<<<<< HEAD
;-249 	j++;

 inc  word[bp-4]
;-250 	ptStartSector=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptStartSector], al
;-251 	ah=0;//next line convert byte to word

 mov  ah, 0
;-252 	ptStartCylinder=ptStartSector;//see next 5 line		

 mov al, [ptStartSector]
 mov word [ptStartCylinder], ax
;-253 	ptStartSector &= 0x3F;

 and  byte[ptStartSector], 63
;-254 	ptStartSector++;//Sector start with 1

 inc  byte[ptStartSector]
;-255 	cputs(",StartSec=");
=======
;-248 	cputs("/");				printunsign(ptEndSector);	

 push printPartitionData_7
 call cputs
 add  sp, 2
 mov al, byte [ptEndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-249 	cputs("/");				printunsign(ptEndCylinder);

 push printPartitionData_8
 call cputs
 add  sp, 2
 push word [ptEndCylinder]
 call printunsign
 add  sp, 2
;-250 //	putch(10);		

;-251 	cputs(",Start=");

 push printPartitionData_9
 call cputs
 add  sp, 2
;-252 	printhex16(ptStartSectorhi);

 push word [ptStartSectorhi]
 call printhex16
 add  sp, 2
;-253 	printhex16(ptStartSectorlo);

 push word [ptStartSectorlo]
 call printhex16
 add  sp, 2
;-254 	cputs(",Len=");
>>>>>>> parent of aeed850... working

 push printPartitionData_10
 call cputs
 add  sp, 2
<<<<<<< HEAD
;-256 	printhex8(ptStartSector);	
=======
;-255 	printhex16(ptPartLenhi);
>>>>>>> parent of aeed850... working

 push word [ptPartLenhi]
 call printhex16
 add  sp, 2
<<<<<<< HEAD
;-257 	ptStartCylinder &= 0xC0;

 and  word[ptStartCylinder], 192
;-258 	ptStartCylinder = ptStartCylinder << 2;//OK no short cut!	

 mov ax, [ptStartCylinder]
 shl ax, 2
 mov word [ptStartCylinder], ax
;-259 	j++;

 inc  word[bp-4]
;-260 	ah=0;//byte 2 word

 mov  ah, 0
;-261 	ptStartCylinder=DiskBuf[j] + ptStartCylinder;

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 add ax, [ptStartCylinder]
 mov word [ptStartCylinder], ax
;-262 //	byte add, ok because low byte is empty

;-263 //	ptStartCylinder=ptStartCylinder + DiskBuf[j];//OK

;-264 	cputs(",StartCyl=");
=======
;-256 	printhex16(ptPartLenlo);

 push word [ptPartLenlo]
 call printhex16
 add  sp, 2
;-257 }
=======
Int13hReset: PROC
;-230 	BIOS_Status=Int13hRawIO(0x80, 0);

 push 0
 push 128
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-231 	if (BIOS_ERR) Int13hError();	
>>>>>>> parent of 8294ac5... Start Int13

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hReset8
 call Int13hError
;-232 }

.Int13hReset8:
;-233 int Int13hStatusRead() {

 ret
ENDP

Int13hStatusRead: PROC
;-234 	BIOS_Status=Int13hRawIO(0x80, 1);

 push 1
 push 128
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-235 	//AH=Status Floppy, AL=Status fixed disk	

;-236 	if (BIOS_ERR) Int13hError();	

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hStatusRead9
 call Int13hError
;-237 	// AL is destroyed but we have AX in BIOS_Status 

<<<<<<< HEAD
 jmp .testDisk10
.testDisk9:
;-266 		putch(10);
>>>>>>> parent of aeed850... working
=======
;-238 }				 
>>>>>>> parent of 8294ac5... Start Int13

.Int13hStatusRead9:
;-239 int Int13hDriveParams() {

<<<<<<< HEAD
 push testDisk_0
 call cputs
 add  sp, 2
<<<<<<< HEAD
;-265 	printhex16(ptStartCylinder);
=======
;-268 		printhex16(BIOS_Status);	
>>>>>>> parent of aeed850... working
=======
;-248 	cputs("/");				printunsign(ptEndSector);	

 push printPartitionData_7
 call cputs
 add  sp, 2
 mov al, byte [ptEndSector]
 mov ah, 0
 push ax
 call printunsign
 add  sp, 2
;-249 	cputs("/");				printunsign(ptEndCylinder);

 push printPartitionData_8
 call cputs
 add  sp, 2
 push word [ptEndCylinder]
 call printunsign
 add  sp, 2
;-250 //	putch(10);		

;-251 	cputs(",Start=");

 push printPartitionData_9
 call cputs
 add  sp, 2
;-252 	printhex16(ptStartSectorhi);

 push word [ptStartSectorhi]
 call printhex16
 add  sp, 2
;-253 	printhex16(ptStartSectorlo);

 push word [ptStartSectorlo]
 call printhex16
 add  sp, 2
;-254 	cputs(",Len=");

 push printPartitionData_10
 call cputs
 add  sp, 2
;-255 	printhex16(ptPartLenhi);

 push word [ptPartLenhi]
 call printhex16
 add  sp, 2
;-256 	printhex16(ptPartLenlo);

 push word [ptPartLenlo]
 call printhex16
 add  sp, 2
;-257 }

;-258 	

;-259 int testDisk(drive) {

 ret
printPartitionData_0 db "No=",0
printPartitionData_1 db ",Boot=",0
printPartitionData_2 db " ID=",0
printPartitionData_3 db ",Start HSC=",0
printPartitionData_4 db "/",0
printPartitionData_5 db "/",0
printPartitionData_6 db "-",0
printPartitionData_7 db "/",0
printPartitionData_8 db "/",0
printPartitionData_9 db ",Start=",0
printPartitionData_10 db ",Len=",0
ENDP

testDisk: PROC
;-260 	char c; int i;

;-261 	asm mov [ParmTableSeg], ds

;Function : testDisk, Number local Var: 3
; # type sign width local variables
;38 var sign word drive = bp+4
;39 var sign byte c = bp-2
;40 var sign word i = bp-4;
 ENTER  4,0
 mov [ParmTableSeg], ds
;-262 	//Offset is in DiskBuf

;-263 	BIOS_Status=Int13hRW(2,drive,0,0,1,1,ParmTableSeg,DiskBuf);

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
;-264 	if (BIOS_ERR) Int13hError();

 mov al, [BIOS_ERR]
 or  al, al
 je .testDisk9
 call Int13hError
;-265 	else {	

 jmp .testDisk10
.testDisk9:
;-266 		putch(10);

 push 10
 call putch
 add  sp, 2
;-267 		cputs("Read Partition Status:");

 push testDisk_0
 call cputs
 add  sp, 2
;-268 		printhex16(BIOS_Status);	
>>>>>>> parent of aeed850... working

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-266 	j++;

 inc  word[bp-4]
;-267 	ptFileSystem=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptFileSystem], al
;-268 	cputs(",FileID=");

 push testDisk_8
 call cputs
 add  sp, 2
;-269 	printhex8(ptFileSystem);
=======
;-269 		cputs(",MBR Magic=");	

 push testDisk_1
 call cputs
 add  sp, 2
;-270 		i=510;		c = DiskBuf[i];		printhex8(c);
>>>>>>> parent of aeed850... working

=======
;-269 		cputs(",MBR Magic=");	

 push testDisk_1
 call cputs
 add  sp, 2
;-270 		i=510;		c = DiskBuf[i];		printhex8(c);

>>>>>>> parent of aeed850... working
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
<<<<<<< HEAD
<<<<<<< HEAD
;-270 	j++;

 inc  word[bp-4]
;-271 	ptEndHead=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptEndHead], al
;-272 	cputs(",EndHd=");

 push testDisk_9
 call cputs
 add  sp, 2
;-273 	printhex8(ptEndHead);

 mov al, byte [ptEndHead]
=======
;-271 		i++;		c = DiskBuf[i];		printhex8(c);

 inc  word[bp-4]
 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov [bp-2], al
 mov al, byte [bp-2]
>>>>>>> parent of aeed850... working
=======
;-271 		i++;		c = DiskBuf[i];		printhex8(c);

 inc  word[bp-4]
 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov [bp-2], al
 mov al, byte [bp-2]
>>>>>>> parent of aeed850... working
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-274 	j++;

 inc  word[bp-4]
;-275 	ptEndSector=DiskBuf[j];

 mov bx, [bp-4]
 mov al, [DiskBuf + bx]
 mov byte [ptEndSector], al
;-276 	

;-277 		

;-278 	

;-279 }	

;-280 

;-281 //------------------------------------ main ---------------

;-282 int main() {
=======
;-272 		
=======
 ret
ENDP

Int13hDriveParams: PROC
;-240 	BIOS_Status=Int13hRawIO(0x80, 8);

 push 8
 push 128
 call Int13hRawIO
 add  sp, 4
 mov word [BIOS_Status], ax
;-241 	asm mov [Sectors],      cl

 mov [Sectors],      cl
;-242 	Sectors &= 0x3F;

 and  word[Sectors], 63
;-243 	Sectors++;//1 to 64
>>>>>>> parent of 8294ac5... Start Int13

 inc  word[Sectors]
;-244 

;-245 	asm mov [Cylinders],    cl	

 mov [Cylinders],    cl	
;-246 	Cylinders &= 0xC0;//;bit 9 and 10

 and  word[Cylinders], 192
;-247 	Cylinders << 2;//compiler flaw: forget to store in Cylinders

 mov ax, [Cylinders]
 shl ax, 2
;-248 	asm mov [Cylinders],    ax

 mov [Cylinders],    ax
;-249 	asm add [Cylinders],    ch;low byte	

<<<<<<< HEAD
;-279 		PartNo=0;
>>>>>>> parent of aeed850... working
=======
 add [Cylinders],    ch;low byte	
;-250 	Cylinders++;//1 to 1024
>>>>>>> parent of 8294ac5... Start Int13

 inc  word[Cylinders]
;-251 

<<<<<<< HEAD
<<<<<<< HEAD
main: PROC
;-283 //	unsigned int i;

;-284 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-285 

;-286 	Params(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Params
 add  sp, 2
;-287 	testDisk(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call testDisk
 add  sp, 2
;-288 

;-289 //	mdump(DiskBuf, 256);

;-290 	

;-291 

;-292 	putch(10);
=======
.testDisk11:
;-281 			getPartitionData();
=======
;-252 	asm mov [Heads],        dh
>>>>>>> parent of 8294ac5... Start Int13

 mov [Heads],        dh
;-253 	Heads++;//1 to 256

 inc  word[Heads]
;-254 	asm mov [Attached],     dl

 mov [Attached],     dl
;-255 	asm mov [ParmTableSeg], es

 mov [ParmTableSeg], es
;-256 	asm mov [ParmTableOfs], di

 mov [ParmTableOfs], di
;-257 	asm mov [DriveType],    bl

 mov [DriveType],    bl
;-258 	if (BIOS_ERR) Int13hError();//the above params are invalid	

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hDriveParams10
 call Int13hError
;-259 }	

.Int13hDriveParams10:
;-260 int Int13hHardDriveStatus() {

 ret
ENDP

<<<<<<< HEAD
Int13hExt: PROC
;-289 	putch(10);
>>>>>>> parent of aeed850... working

=======
;-272 		

;-273 		cputs(",DiskBuf=");

 push testDisk_2
 call cputs
 add  sp, 2
;-274 		printhex16(ParmTableSeg);

 push word [ParmTableSeg]
 call printhex16
 add  sp, 2
;-275 		putch(':');							

 push 58
 call putch
 add  sp, 2
;-276 		printhex16(DiskBuf);

 lea  ax, [DiskBuf]
 push ax
 call printhex16
 add  sp, 2
;-277 		putch('.');

 push 46
 call putch
 add  sp, 2
;-278 	

;-279 		PartNo=0;

 mov ax, 0
 mov word [PartNo], ax
;-280 		do {

.testDisk11:
;-281 			getPartitionData();

 call getPartitionData
;-282 			printPartitionData();

 call printPartitionData
;-283 			PartNo ++;

 inc  word[PartNo]
;-284 		} while (PartNo <4);

 mov ax, [PartNo]
 cmp ax, 4
 jge .testDisk12
 jmp .testDisk11
.testDisk12:
;-285 	}	

;-286 }

.testDisk10:
;-287 

;-288 int Int13hExt(char drive) {

 LEAVE
 ret
testDisk_0 db "Read Partition Status:",0
testDisk_1 db ",MBR Magic=",0
testDisk_2 db ",DiskBuf=",0
ENDP

Int13hExt: PROC
;-289 	putch(10);

>>>>>>> parent of aeed850... working
;Function : Int13hExt, Number local Var: 1
; # type sign width local variables
;38 var sign byte drive = bp+4;
 ENTER  0,0
 push 10
 call putch
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-293 	cputs("(41)Ext present :");
=======
;-290 	cputs("Int13h 41hExt AX=");
>>>>>>> parent of aeed850... working
=======
;-290 	cputs("Int13h 41hExt AX=");
>>>>>>> parent of aeed850... working

 push Int13hExt_0
 call cputs
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-294 	bx=0x55AA;

 mov  bx, 21930
;-295 	BIOS_Status=Int13hRawIO(0x80, 0x41);	
=======
=======
>>>>>>> parent of aeed850... working
;-291 	bx=0x55AA;

 mov  bx, 21930
;-292 	BIOS_Status=Int13hRaw(0x80, 0x41);	
<<<<<<< HEAD
>>>>>>> parent of aeed850... working
=======
>>>>>>> parent of aeed850... working

 push 65
=======
Int13hHardDriveStatus: PROC
;-261 	BIOS_Status=Int13hRawIO(0x80, 0x10);

 push 16
>>>>>>> parent of 8294ac5... Start Int13
 push 128
 call Int13hRaw
 add  sp, 4
 mov word [BIOS_Status], ax
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
;-296 	if (BIOS_ERR) Int13hError();
=======
=======
>>>>>>> parent of aeed850... working
;-293 	printhex16(BIOS_Status);

 push word [BIOS_Status]
 call printhex16
 add  sp, 2
;-294 	if (BIOS_ERR) {
<<<<<<< HEAD
>>>>>>> parent of aeed850... working
=======
;-262 	

;-263 	if (BIOS_ERR) Int13hError();//the above params are invalid			
>>>>>>> parent of 8294ac5... Start Int13

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hHardDriveStatus11
 call Int13hError
;-264 }	

.Int13hHardDriveStatus11:
;-265 

<<<<<<< HEAD
 call Int13hError
<<<<<<< HEAD
;-297 	//BIOS_Status=ax;01: Extension supported

;-298 	asm mov [vBX], bx;0xAA55 Extension installed
=======
;-297 		}
=======
;-266 int PrintDriveParms() {
>>>>>>> parent of 8294ac5... Start Int13

 ret
ENDP

PrintDriveParms: PROC
;-267 	cputs(" HD Params: Drive :"); 		printhex8(Drive);

 push PrintDriveParms_0
 call cputs
 add  sp, 2
<<<<<<< HEAD
;-300 		asm mov [vBX], bx;0xAA55 Extension installed
>>>>>>> parent of aeed850... working

 mov [vBX], bx;0xAA55 Extension installed
<<<<<<< HEAD
;-299 	asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			
;-300 	printhex16(BIOS_Status);		
=======
;-301 		asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			
;-302 		cputs(" BX=");		printhex16(vBX);
>>>>>>> parent of aeed850... working
=======
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-268 	cputs(", Cyl :");					printunsign(Cylinders);
>>>>>>> parent of 8294ac5... Start Int13

 push PrintDriveParms_1
 call cputs
 add  sp, 2
 push word [Cylinders]
 call printunsign
 add  sp, 2
<<<<<<< HEAD
<<<<<<< HEAD
;-301 

;-302 /*	DosBox Disk Services Int13h:

;-303 	00	Reset Disk System

;-304 	01	Get Status of Last Drive Operation

;-305 	02	Read Sectors

;-306 	03	Write Sectors

;-307 	08	Get Drive Parameters

;-308 	only DosBox_X:

;-309 	41	EXT Extension Available

;-310 	42	EXT Read Sectors

;-311 	43	EXT Write Sectors

;-312 	48	EXT Read Drive Parameter

;-313 */

;-314 

;-315 }
=======
;-303 		cputs(" CX=");		printhex16(vCX);
=======
;-269 	cputs(", Sec :");					printunsign(Sectors);
>>>>>>> parent of 8294ac5... Start Int13

 push PrintDriveParms_2
 call cputs
 add  sp, 2
 push word [Sectors]
 call printunsign
 add  sp, 2
;-270 	cputs(", Hd :");

 push PrintDriveParms_3
 call cputs
 add  sp, 2
;-271 }

;-272 	

;-273 int main() {

 ret
PrintDriveParms_0 db " HD Params: Drive :",0
PrintDriveParms_1 db ", Cyl :",0
PrintDriveParms_2 db ", Sec :",0
PrintDriveParms_3 db ", Hd :",0
ENDP

main: PROC
;-274     DOS_ERR = 0;

 mov ax, 0
 mov byte [DOS_ERR], al
;-275     Int13hDriveParams();

 call Int13hDriveParams
;-276     PrintDriveParms();

 call PrintDriveParms
;-277 /*

;-278     setblock(4096);// 64KB

;-279 

;-280     GetIntVec(0x21);

;-281     cputs(" Main Int21h old=");

;-282     printhex16(VecOldSeg);

;-283     putch(':');

;-284     printhex16(VecOldOfs);

;-285 

;-286     asm mov dx, DOS_START

;-287 //    asm lea dx, [DOS_START]

;-288     ax=0x2521;

;-289     DosInt();

;-290 //    ShowRegister();

;-291 

;-292     GetIntVecNew(0x21);

;-293     cputs(" Int21h new=");

;-294     printhex16(VecNewSeg);

;-295     putch(':');

;-296     printhex16(VecNewOfs);

;-297 

;-298     cputs(" count21h=");

;-299     printunsign(count21h);

;-300     cputs(" end main.");

;-301 

;-302 //    asm int 32;20h exit

;-303 

;-304     asm mov dx, main;get adr of main in dx//Terminate stay resident

;-305     asm shr dx, 4   ;make para

;-306     asm add dx, 17  ;PSP in para + align to next para

;-307     ax=0x3100;

;-308     DosInt();

;-309 */

<<<<<<< HEAD
=======

 mov al, [BIOS_ERR]
 or  al, al
 je .Int13hExt13
;-295 		cputs(" not present");	

 push Int13hExt_1
 call cputs
 add  sp, 2
;-296 		Int13hError();	

 call Int13hError
;-297 		}

;-298 	else {

 jmp .Int13hExt14
.Int13hExt13:
;-299 		cputs(" status=1:supported");

 push Int13hExt_2
 call cputs
 add  sp, 2
;-300 		asm mov [vBX], bx;0xAA55 Extension installed

 mov [vBX], bx;0xAA55 Extension installed
;-301 		asm mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			

 mov [vCX], cx;=1: AH042h-44h,47h,48h supported 			
;-302 		cputs(" BX=");		printhex16(vBX);

 push Int13hExt_3
 call cputs
 add  sp, 2
 push word [vBX]
 call printhex16
 add  sp, 2
;-303 		cputs(" CX=");		printhex16(vCX);

 push Int13hExt_4
 call cputs
 add  sp, 2
 push word [vCX]
 call printhex16
 add  sp, 2
;-304 		}		

;-305 }	

.Int13hExt14:
;-306 

;-307 int mdump(unsigned char *adr, unsigned int len ) {

 LEAVE
 ret
Int13hExt_0 db "Int13h 41hExt AX=",0
Int13hExt_1 db " not present",0
Int13hExt_2 db " status=1:supported",0
Int13hExt_3 db " BX=",0
Int13hExt_4 db " CX=",0
ENDP

mdump: PROC
;-308     unsigned char c;

;-309     int i;

;-310     int j;

;-311     j=0;

;Function : mdump, Number local Var: 5
; # type sign width local variables
;38 ptr unsg byte adr = bp+4
;39 var unsg word len = bp+6
;40 var unsg byte c = bp-2
;41 var sign word i = bp-4
;42 var sign word j = bp-6;
 ENTER  6,0
 mov ax, 0
 mov [bp-6], ax
;-312     while (j < len ) {

.mdump15:
 mov ax, [bp-6]
 cmp ax, [bp+6]
 jge .mdump16
;-313         putch(10);

 push 10
 call putch
 add  sp, 2
;-314         printhex16(adr);

 push word [bp+4]
 call printhex16
 add  sp, 2
;-315         putch(':');

 push 58
 call putch
 add  sp, 2
;-316         i=0;

 mov ax, 0
 mov [bp-4], ax
;-317         while (i < 16) {

.mdump17:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump18
;-318             putch(' ');

 push 32
 call putch
 add  sp, 2
;-319             c = *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-320             printhex8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-321             adr++;

 inc  word[bp+4]
;-322             i++;

 inc  word[bp-4]
;-323             j++;

 inc  word[bp-6]
;-324             }

;-325         putch(' ');

 jmp .mdump17
.mdump18:
 push 32
 call putch
 add  sp, 2
;-326         adr -=16;

 sub  word[bp+4], 16
;-327         i=0;

 mov ax, 0
 mov [bp-4], ax
;-328         while(i < 16) {

.mdump19:
 mov ax, [bp-4]
 cmp ax, 16
 jge .mdump20
;-329             c= *adr;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-330             if (c < 32) putch('.');

 mov al, [bp-2]
 cmp al, 32
 jge .mdump21
 push 46
 call putch
 add  sp, 2
;-331                 else putch(c);

 jmp .mdump22
.mdump21:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-332             adr++;

.mdump22:
 inc  word[bp+4]
;-333             i++;

 inc  word[bp-4]
;-334         }

;-335     }

 jmp .mdump19
.mdump20:
;-336 }

 jmp .mdump15
.mdump16:
;-337 

;-338 //------------------------------------ main ---------------

;-339 int main() {

 LEAVE
 ret
ENDP

main: PROC
;-340 	Drive=0x80;

 mov ax, 128
 mov byte [Drive], al
;-341 

;-342 	Params(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Params
 add  sp, 2
;-343 	testDisk(Drive);

 mov al, byte [Drive]
 mov ah, 0
 push ax
 call testDisk
 add  sp, 2
;-344 //	mdump(DiskBuf, 512);

;-345 	Int13hExt(Drive);

>>>>>>> parent of aeed850... working
 mov al, byte [Drive]
 mov ah, 0
 push ax
 call Int13hExt
 add  sp, 2
;-346 }
<<<<<<< HEAD
>>>>>>> parent of aeed850... working

 ret
ENDP
<<<<<<< HEAD
;Glob. variables:34 (400):311 (4000), Functions:16 (300):154 (3000)
;Lines:316, Constant: 294 (3000), stacksize: 60927
=======
;Glob. variables:37 (400):335 (4000), Functions:19 (300):188 (3000)
;Lines:347, Constant: 372 (3000), stacksize: 56831
>>>>>>> parent of aeed850... working
=======
;-310 

;-311 }

 ret
ENDP
;Glob. variables:30 (400):228 (4000), Functions:22 (300):249 (3000)
;Lines:312, Constant: 279 (3000), stacksize: 61023
>>>>>>> parent of 8294ac5... Start Int13
=======

 ret
ENDP
;Glob. variables:37 (400):335 (4000), Functions:19 (300):188 (3000)
;Lines:347, Constant: 372 (3000), stacksize: 56831
>>>>>>> parent of aeed850... working
