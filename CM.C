/*  CM.C für NASM  */
#define BSS
#define ARCHIVE   "AR.C"
int DOS_ERR=0; unsigned int DOS_NoBytes=0; char DOS_ByteRead=0; char ext;
//                        at - pipe  \   '   "   ;   ,   [   {
unsigned char KeybGer1[]={64,45,124,92, 39, 34, 59, 58, 91,123};
unsigned char Keybtmp1[]="yYzZ#^&*()_\]}/?><";
//                         "  \   >  <   ä   Ä   ö   Ö   ü   Ü
unsigned char KeybGer2[]={34,92, 62,60,132,142,148,153,129,154};
unsigned char Keybtmp2[]="zZyY$&/()=?<+*-_:;";
char direcord[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};//do not change
char dirattr=0;   int  dirzeit=0;  int  dirdatum=0;
int  dirbytlo=0;  int  dirbythi=0; 
char dirdatnam[]={0,0,0,0,0,0,0,0,0,0,0,0,0};
char Pfad[]="*.*";
//unsigned char buf[40501]; unsigned int BUFLEN=40500;
unsigned char buf[4097]; unsigned int BUFLEN=4096;
char FNBuf[128]; char inp_len=0;   char inp_buf[81]; unsigned char *pt;
//int pos;
char Info1[]="CMD commands: cls,dir,dos,exit,type,mem,dump,help";
char Info2[]="exec,fn,down,co,unreal,un,test,  *.COM ";
char Ls[]="12345678901";    char strL[11];   char z[]="0123456789ABCDEF";

long L1; char *p1;
int test() {  char *pos;
  _ L1 = 512345;
  prLr(L1);
  L1=L1 << 1;
  cputs(" Bytes: "); prLL(L1);
  L1=L1 << 1;
  cputs(", long: "); prLL(L1);
//  fillscreen();
  ex1("Dies ist ein Test");
 }
int ex1(char *p) {
  eax=0xB800; eax << 4; edi=eax;  eax=0;
  edi=0xB8000;
  while(*p) { al= *p;  ah=0x1f;
    asm mov [fs:edi], ax
    p++;  }
  _ L1=500000; L1=L1 << 3; prLL(L1);
  ebx=L1;
  asm mov dword [fs:ebx], 0x12345678
  asm cmp dword [fs:ebx], 0x12345678
  ifzero cputs(" Kein Fehler ");
/*  cx=160;  ah=0x1e;
  asm myloop: mov al, [fs:esi]
  asm         mov [fs:edi], ax
  esi++; edi++; edi++;
  asm loop myloop */
}

int fillscreen() {
  eax=0xF005; eax << 4; esi=eax;
  eax=0xB800; eax << 4; edi=eax;
  cx=160;  ah=0x1e;
  asm myloop: mov al, [fs:esi]
  asm         mov [fs:edi], ax
  esi++; edi++; edi++;
  asm loop myloop
}

void prLr(unsigned long L) {           ultoar(L, Ls); cputs(Ls);  }
void prLL(unsigned long L) {char *p; p=ultoaL(L, Ls); cputs(p );  }

void ultoar(unsigned long L, char *s) { int i;//edx:eax DIV ebx = eax Modulo edx
  i=0;  while(i<10) { *s = '0'; s++; i++; }   *s = 0;   s--;  eax=L;
  do { edx=0;  ebx=10; ebx /= ;
       dl+=48; bx=s;   *bx=dl;  s--; } while (eax != 0);
}
int ultoaL(unsigned long L, char *s) { // edx:eax DIV ebx = eax Modulo edx
  s=s+10;  *s = 0;   s--;  eax=L;
  do { edx=0;  ebx=10; ebx /= ;
       dl+=48; bx=s;   *bx=dl;  s--; } while (eax != 0);
  s++; ax=s;
}
// int dxax2l(char *p) { *p=ax; p+=2; *p=dx; } //wrong

int head3  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0;}//wrong

int head2  (char *s) {char c; char d;  //wrong
  lab1:
    c= *s;
    d=letter(c);
    s++;
    if( d != 0) goto lab1;
    *s=0;
// do{c=*s; c=letter(c); s++; }while(c) *s=0;
 }
int head1  (char *s) {while(*s >= 'A') s++;     *s=0; }

int main() {dohelp();
  do { putch(10);get_cmd(inp_buf); intrinsic(inp_buf); } while(1);}
int get_cmd(char *s){inp_buf=0;_ DOS_ERR=0;putch(':');Prompt1(inp_buf);putch(10);}
int intrinsic(char *t) {  char s[50];  char c; int i;
  _ DOS_ERR=0;    while (*t == ' ') t++;
  strcpy(s, t); toupper(s);   head1(s);
  if(eqstr(s,"CLS" )){clrscr5080();return;}if(eqstr(s,"DIR" )){dir1();return;}
  if(eqstr(s,"DOS" )){dodos(); return;}if(eqstr(s,"EXIT"))exitR(0);
  if(eqstr(s,"TYPE")){dotype();return;}if(eqstr(s,"MEM" )){domem(); return;}
  if(eqstr(s,"DUMP")){dodump();return;}if(eqstr(s,"HELP")){dohelp();return;}
  if(eqstr(s,"EXEC")){exec1 ();return;}if(eqstr(s,"FN"  )){doFN();  return;}
  if(eqstr(s,"DOWN")){dodown();return;}if(eqstr(s,"CO"  )){doco();  return;}
  if(eqstr(s,"UNREAL")){dounreal();  return;}
  if(eqstr(s,"UN")){doun();  return;}  if(eqstr(s,"TEST")){test();  return;}
  extrinsic(inp_buf);
}

unsigned char GDT1[]={15,0,0,0,0,0,0,0, 0xFF,0xFF,0x00,0x00,0x00,0x92,0xCF,0};
int doun() { cputs("\n;un:");
  if (isvirtual861()) cputs(" V86 ON. ");else cputs(" V86 OFF. ");
  if (is32bit()) cputs(" 32bit: ON. "); else cputs("  32bit: OFF. ");
  INITCPU321();
  if (isvirtual861()) cputs(" after INIT V86 ON. ");
    else cputs(" after INIT V86 OFF. ");
  if (is32bit1()) cputs(" 32bit: ON. "); else cputs("  32bit: OFF. ");
}
int isvirtual861() { eax=cr0;  ax &= 1; }
int is32bit1() { ecx=0xFFFF;
  asm jmp $ + 2;
  ecx++; ifzero return 0;  return 1;  }
int INITCPU321() {
	eax=0;
	ax=ds;
	eax << 4;
	asm add eax, GDT1       ;//Offset GDT
	asm mov [GDT1+2], eax
	asm lgdt [GDT1]
	bx=8;
	asm push ds
	asm cli
	eax=cr0;
	al++;
	cr0=eax;
//	asm jmp dword PROTECTION_ENABLED
	asm jmp PROTECTION_ENABLED
//  asm jmp [CS:PROTECTION_ENABLED]
	asm PROTECTION_ENABLED:
	fs=bx;
	al--;
	cr0=eax;
	asm jmp word PROTECTION_DISABLED
//  asm jmp PROTECTION_DISABLED
//	asm jmp [CS:PROTECTION_DISABLED]
	asm PROTECTION_DISABLED:
	asm sti
	asm pop ds
}

unsigned char MEM48[]={16,0, 0,0, 0,0};
unsigned char GDT[]={0,0,0,0,0,0,0,0,  0xFF,0xFF,0x00,0x00,0x00,0x92,0xCF,0};
int dounreal() {
  if (isvirtual86()) cputs(" V86 ON. ");
    else cputs(" V86 OFF. ");
  if (is32bit()) cputs(" 32bit: ON. "); else cputs("  32bit: OFF. ");
  INITCPU32();
  if (isvirtual86()) cputs(" after INIT V86 ON. ");
    else cputs(" after INIT V86 OFF. ");
  if (is32bit()) cputs(" 32bit: ON. "); else cputs("  32bit: OFF. ");
}
int isvirtual86() { eax=cr0;  ax &= 1; }
int is32bit() {
  ecx=0xFFFF;
  asm jmp $ + 2;
  ecx += 1;
  asm inc ecx
  ifzero return 0;
  return 1;
}
int INITCPU32() {
	/*asm mov byte [MEM48],16
	/*asm mov eax,seg GDT  */
	asm xor eax,eax
	asm mov ax, ds
	asm shl eax,4
	/*asm add ax, GDT
	asm mov [MEM48+2], eax*/
	asm mov bx, GDT
	asm movzx ebx,bx
	asm add eax,ebx
	asm mov dword [MEM48+2],eax
	asm lgdt [MEM48]
	asm mov bx,08h                  ;//Load bx to point to GDT entry 1
	asm push ds
	asm cli                         ;//Disable interrupts
	asm mov eax,cr0                 ;//Switch to protected mode
	asm or eax,1
	asm mov cr0,eax
	asm jmp PROT_ENABLED      ;//Clear executionpipe
//	asm jmp [CS:PROTECTION_ENABLED] ;//Clear executionpipe
	asm PROT_ENABLED:
	asm mov gs,bx                   ;//Load segment shadow-registers
	asm mov fs,bx                   ;//with GDT entry 1 (4GB segment limit)
	asm mov es,bx
	asm mov ds,bx
	asm and al,0FEh                 ;//Switch back to real-mode without
	asm mov cr0,eax                 ;//resetting the CPU
	asm jmp PROT_DISABLED     ;//Clear executionpipe
//	asm jmp [CS:PROTECTION_DISABLED];//Clear executionpipe
	asm PROT_DISABLED:
//asm jmp $ + 2
	asm sti                         ;//Enable interrupts
	asm pop ds
}

char memSignature; unsigned int memOwner; unsigned int memSize;
char memName[]="12345678";  unsigned int total_ext_mem;

int domem() { unsigned int vES; unsigned int vBX; unsigned int i;
asm mov al,17h
asm out 70h,al
asm nop
asm in al,71h
asm mov [total_ext_mem],al
asm mov al,18h
asm out 70h,al
asm nop
asm in al,71h
asm mov [total_ext_mem+1],al
cputs("CMOS extended memory KByte: "); prunsign(total_ext_mem);

asm mov ah,88h
asm int 15h
  _ total_ext_mem=ax;
  cputs(", Int 15h ext. mem KByte: "); prunsign(total_ext_mem);   putch(10);
  if (isvirtual86()) cputs("V86 ON.");
    else cputs("V86 OFF.");
  if (is32bit()) cputs(", 32bit: ON."); else cputs(", 32bit: OFF.");

   ah=0x52; inth 0x21; /* out= ES:BX ptr to invars*/
   _ vBX=bx; _ vES=es;
  asm mov es, [es:bx-2]
  _ vES=es;
 do {
   putch(10); cputs("ES="); printhex16(vES);
   putch('='); printint5(vES);
   if (vES >= 0xA000) cputs(" MCB in UMB");
   asm mov al, [es:0]
   _ memSignature= al; cputs("d, ");putch(memSignature);
   asm mov ax, [es:1]
   _  memOwner= ax;  cputs(", Owner="); printhex16(memOwner);
   asm mov ax, [es:3]
   _ memSize= ax;  cputs(", Size="); printhex16(memSize);
   putch('='); printint5(memSize); putch('d');
   putch('='); i=memSize >> 6; printint5(i);  cputs(" KByte");
   if (memOwner == 0) cputs(" free");
   if (memOwner == 8) cputs(" DOS ");
   i=memOwner-vES; if (i == 1){
       cputs(" PSP  ");  i=8;  do {bx=i;
       asm mov al, byte [es:bx]
       asm cmp al, 0
       ifzero _ i = 16;
       writetty(); i++; } while (i < 16);  }
    vES = vES + memSize;  vES++; __asm{mov es, [bp-2] };// _ es=vES;
    } while (memSignature == 'M');
}
char TodayStr[7];     unsigned long SumByteL; unsigned long DosL;
int doco() {int fdin; int fdout; unsigned int i;  char *p;
  char fin[60]; char fout[65]; char fext[30];
//  p=head1(inp_buf); strcpy(inp_buf, p);   Fehler!!!
  i=strlen(inp_buf);  // bei a.c >> A.110421.C
  if (_ i < 4) {cputs("Check Out filename[.C] short to 2 char"); return;}
  i=&inp_buf + 3; strcpy(inp_buf, i); // skip co_
  i=strlen(inp_buf);
  if (_ i == 0) {cputs("Check Out filename[.C] short to 2 char: "); return; }
  toupper(inp_buf);
  strcpy(fin, inp_buf);
  p=basename(inp_buf);
  if (p==0) { strcat1(fin, ".C"); strcpy(fext, ".C"); }
  else      { strcpy(fext, p); }
  if (_ i >  2) inp_buf[2]=0;
  if (_ i == 1) inp_buf[1]=0;
//  if (inp_buf[1] == '.') inp_buf[1]=0;  Error
  _ i=1; if (inp_buf[i] == '.') inp_buf[1]=0;
  strcpy (fout, ".\BAK" );
  strcat1(fout, inp_buf);
  GetDate(TodayStr);
  strcat1(fout, TodayStr);strcat1(fout, fext);

  cputs(" Check Out: "); cputs(fin);
  fdin=openR(fin);
  if (DOS_ERR) {putch(10); cputs(" file missing "); return;}
  cputs(", fout="); cputs(fout);
  fdout=creatR(fout);
  if (DOS_ERR) {putch(10); cputs(" file not creatable "); return;}

  _ SumByteL=0;
  do {
    DOS_NoBytes=readRL(&buf, fdin, BUFLEN);
    if (DOS_ERR) {putch(10); cputs(" ***Error*** reading: ");
      prunsign(DOS_NoBytes);return;}
    i = writeRL(&buf, fdout, DOS_NoBytes);
    if (DOS_ERR) {putch(10); cputs(" ***Error*** writing: ");
      cputs(fout);return;}
    if (i != DOS_NoBytes)  {putch(10); cputs(" Writing aborted. Bytes: ");
      prunsign(i);return;}
    eax=DOS_NoBytes;
    _ DosL=eax;
    SumByteL=SumByteL + DosL;
    } while (DOS_NoBytes == BUFLEN);
  fcloseR(fdin); fcloseR(fdout);
  cputs(" Bytes: ");  prLL(SumByteL);
}

int dir1() { int j;
  &FNBuf;  si=ax;  dx=0;  ax=0x4700; DosInt();
  cputs("Current directory: "); cputs(FNBuf); putch(10);
  setdta(direcord);  ffirst(Pfad);
  if (DOS_ERR) {cputs("Empty directory "); return;}
  cputs("Name     Ext CreatDat   Time Attr Size");
  do {
    if (dirdatnam != '.') {
    putch(10);  cputs(dirdatnam);  j=strlen(dirdatnam);
    do {putch(' '); j++; } while (j<13);
    j=dirdatum & 31;         if (j<10) putch(' '); prunsign(j); putch('.');
    j=dirdatum >> 5; j&=  15;if (j<10) putch('0'); prunsign(j); putch('.');
    j=dirdatum >> 9; j+=  80;if (j>=100) j-=100;
      if (j<10) putch('0'); prunsign(j); putch(' ');putch(' ');
    j=dirzeit  >>11;         if (j<10) putch(' '); prunsign(j); putch(':');
    j=dirzeit  >> 5; j&=  63;if (j<10) putch('0'); prunsign(j); putch(' ');
    if (dirbythi) { dirbytlo=dirbytlo >>10; dirbythi=dirbythi << 6;
      dirbythi=dirbythi+dirbytlo;
      cputs("     ");prunsign(dirbythi); cputs(" KB"); }
    else {if (dirattr==16) cputs("<DIR>");
      else {cputs("     ");prunsign(dirbytlo);} }   }
  j=fnext(Pfad);  } while (j!=18);
}
int dotype() {int fdin; int i;
  i=strlen(inp_buf);
  if (i == 4) {cputs("TYPE filename: "); Prompt1(inp_buf);}
  else  { i=&inp_buf + 5; strcpy(inp_buf, i); cputs(inp_buf); }
  fdin=openR(inp_buf);
  if (DOS_ERR) {putch(10); cputs("file missing: "); cputs(inp_buf); return;}
  do {DOS_NoBytes=readR(&DOS_ByteRead, fdin);
      putch(DOS_ByteRead); } while (DOS_NoBytes);
  fcloseR(fdin);
}
int dohelp() { unsigned int i;   cputs("CMD.COM V0.4 Codelength:");
  __asm{call LastFunctionByt}  _ i=ax;
  prunsign(i); putch('('); printhex16(i); putch('h'); putch(')');rdump();
  putch(10); cputs(Info1); putch(10); cputs(Info2);
}
int dodown() {
  cputs("Computer OFF with APM"); waitkey();
  ax=0x5301; bx=0; inth 0x15;
  ax=0x5307; bx=1; cx=3; inth 0x15;
}
int Env_seg=0; /*Take over Master Environment*/
int Cmd_ofs=0;     int Cmd_seg=0;
int FCB_ofs1=0x5C; int FCB_seg1=0;
int FCB_ofs2=0x6C; int FCB_seg2=0;
char FCB1=0; char FCB1A[]="           ";
char FCB1B[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
char FCB2=0; char FCB2A[]="           ";
char FCB2B[]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

int extrinsic(char *s) {char *p; 
  inp_len=strlen(inp_buf);
  if (inp_len == 0) return;
  p=&inp_buf+inp_len; *p=0;
  doFN();
  waitkey();
  exec1(inp_buf, &Env_seg, &inp_len);
}
int dodos() { char *p; int h;
  strcpy(inp_buf, "");
  h=strlen(inp_buf); inp_len=h & 255; p=&inp_buf+h; *p=0;
  cputs("Before DOS: "); cputs(inp_buf);
  exec1("COMMAND.COM", &Env_seg, &inp_len);
}

int doFN() {  unsigned int vAX; unsigned int vBX;
  __asm{mov si, FNBuf}; // _ si=&FNBuf;
  dx=0;  ax=0x4700; DosInt();  _ vAX=ax; _ vBX=bx;
  if (DOS_ERR) cputs(" ***Error GetCurrentDir***, AX=");//1=OK, 2=LW ungültig
  __asm{mov si, inp_buf};// _ si=&inp_buf;
  __asm{mov di, FNBuf};  // _ di=&FNBuf;
  ax=0x6000; DosInt(); _ vAX=ax; _ vBX=bx;//2=LW ungültig,3=falsch aufgebaut
  if (DOS_ERR) cputs(" ***Error Expand Filename***, AX=");
  cputs("Expanded filename: "); cputs(&FNBuf);
}
int setblock(unsigned int i) { unsigned int vAX; unsigned int vBX;
  DOS_ERR=0; bx=i; _ ax=cs; _ es=ax; ax=0x4A00; DosInt();
//modify memory Allocation. IN: ES=Block Seg, BX=size in para
  _ vAX=ax;    _ vBX=bx;
  if (DOS_ERR) cputs(" ***Error SetBlock***, AX=");
//    7=MCB destroyed, 8=Insufficient memory, 90=Invalid block address
//    BX=Max mem available, if CF & AX=8
}
int exec1(char *Datei1, char *ParmBlk, char *CmdLine1) 
  { int stkseg; int stkptr; unsigned int vAX;
  setblock(4096); putch(10);
  asm mov ax, [es:2ch]
  _ Env_seg=ax;
  Cmd_ofs = CmdLine1;
  _ ax      =es;   _ Cmd_seg =ds;
  _ FCB_seg1=ax;   _ FCB_seg2=ax;
  _ stkseg  =ss;   _ stkptr  =sp;
  dx=Datei1; bx=ParmBlk; ax=0x4B00; DosInt();
  _ vAX=ax;  _ ss=stkseg;  _ sp=stkptr;
  if (DOS_ERR) cputs(" ***Error EXEC*** ");
}
