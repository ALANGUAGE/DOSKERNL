char Version1[]="ASM.C V1.2";//Assembler like NASM, 11801bytes. 8381 stack
//todo CS:with adr, not implemented: 14,15,16,41,51
//todo Seg override works for [mem|, not [es:2ch]
//todo getDigit hex 0x1234
#define IDLENMAX    31
char Symbol[IDLENMAX];  //next symbol to decode
char SymbolUpper[IDLENMAX];//set toupper in getName
char ProcName[IDLENMAX];//name of actual proc
char isPrint=1;         //print to screen on
char isInProc=0;        //is inside a procedure
unsigned int SymbolInt; //integer value set in getDigit
#define INPUTBUFMAX 255
char InputBuf[INPUTBUFMAX];//filled in getLine
unsigned char *InputPtr;//position in InputBuf
char namein [67];       //input file name  .S
char namelst[67];       //list file name   .LST
char namebin[67];       //output file name .COM
int  asm_fd;            //input file descriptor
int lst_fd;             //list file descriptor
int bin_fd;             //output file descriptor
int DOS_ERR=0;          //global var
int ErrorCount=0;       //number of errors
int DOS_NoBytes;        //number of bytes read (0 or 1)
char DOS_ByteRead;      //the byte just read by DOS

unsigned int PC=0;      //program counter
unsigned int Origin=0;  //ORG nn
unsigned int AbsoluteLab=0;//uninitialised data
unsigned int PCStart;   //PC at start of line by PrintLine()
char isLabel;           //by getName()
#define DIGIT    1      //0-9
#define LETTERE  2      //a-z A-Z @ . _
#define ALNUME   3      //a-z A-Z @ . _  0-9
#define NOALNUME 4      //other char
char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME
#define BYTE     1
#define WORD     2
#define DWORD    3
#define SEGREG   4
#define IMM      1      //const  ,123
#define REG      2      //       ,BX    mode=11
#define ADR      3      //DIRECT: VALUE  ,var1  mod=00, r/m=110
#define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16
char Op;                //1. operand: 0, IMM, REG, ADR, MEM
char Op2;               //2. operand
char CodeType;          //1-207 by searchSymbol(), must be byte size
char Code1;             //1. Opcode
char R2No;              //0 - 7 AL, CL, ...  set in testReg()
char R1No;              //temp for 1. register
char R2Type;            //0=no reg, BYTE, WORD, DWORD, SEGREG
char R1Type;            //temp for 1. register
char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
char wflag;             //wordflag: 0=byte, 1=word/dword
char dflag;             //directionflag: 1=to reg MOV,ALU
char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3
char rm;                //combination of index and base reg
char isDirect;          //set in process and getMeM, need in WriteEA
int disp;               //displacement      0-8 bytes
unsigned int imme;      //immediate         0-8 bytes

#define OPMAXLEN 5
char OpPos[OPMAXLEN];   //array for one opcode to list
int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
char *OpCodePtr;        //position in OpCodeTable by searchSymbol
char PrintRA;           //print * for forward relocative jmp

#define LABELNAMESMAX 6000
char LabelNames[LABELNAMESMAX];//space for names of all labels
char *LabelNamePtr;     //first free position
char *tmpLabelNamePtr;  //set after PROC to LabelNamePtr

#define LABELADRMAX 600
unsigned int LabelAddr[LABELADRMAX];//addr of each label
int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1
int tmpLabelMaxIx;      //set after PROC to LabelMaxIx
int LabelIx;            //actual # of just searched label

#define JMPNAMESMAX 4000
char JmpNames[JMPNAMESMAX];//space for names of jmp, call
char *JmpNamePtr;       //first free position
char *tmpJmpNamePtr;    //set after PROC to JmpNamePtr

#define JMPMAX 200      //max. jmp and call
unsigned int JmpAddr[JMPMAX];//addr to be fixed
int JmpMaxIx=0;         //actual # of jmp, call. 1 to JMPMAX-1
int tmpJmpMaxIx=0;      //set after PROC to JmpMaxIx

#define FILEBINMAX 25000
char FileBin  [FILEBINMAX];//output binary file
unsigned int BinLen=0;  //length of binary file

char *arglen=0x80;      // for main only
char *argv=0x82;        // for main only

int writetty()     {//char in AL
    ah=0x0E;
    asm push bx
    bx=0;     //page in BH
    inth 0x10;
    asm pop bx
}
int putch(char c)  {
    if (c==10)  {// LF
        al=13;   // CR, write CR first and then LF
        writetty();
    }
    al=c;
    writetty();
}
int cputs(char *s) {
    char c;
    while(*s) {
        c=*s;
        putch(c);
        s++;
    }
}
int mkneg(int n)   {
    n; // ax=n;
    asm neg ax
}

int DosInt() {
    inth 0x21;
    __emit__(0x73, 04); //jnc over DOS_ERR++
    DOS_ERR++;
}
int openR (char *s) {
    dx=s;
    ax=0x3D02;
    DosInt();
}
int creatR(char *s) {
    dx=s;
    cx=0;
    ax=0x3C00;
    DosInt();
}
int fcloseR(int fd) {
    bx=fd;
    ax=0x3E00;
    DosInt();
}
int exitR  (char c) {
    ah=0x4C;
    al=c;
    DosInt();
}
int readRL(char *s, int fd, int len){
    dx=s;
    cx=len;
    bx=fd;
    ax=0x3F00;
    DosInt();
}
int fputcR(char *n, int fd) {
    __asm{lea dx, [bp+4]}; /* = *n */
    cx=1;
    bx=fd;
    ax=0x4000;
    DosInt();
}

int letterE(char c) {
  if (c=='_') return 1;
  if (c=='.') return 1;
  if (c=='?') return 1;
  if (c=='$') return 1;
  if (c> 'z') return 0;
  if (c< '@') return 0; // at included
  if (c> 'Z') { if (c< 'a') return 0; }
  return 1;
}
int digit(char c){
    if(c<'0') return 0;
    if(c>'9') return 0;
    return 1;
}
int alnumE(char c) {
  if (digit(c)) return 1;
  if (letterE(c)) return 1;
  return 0;
}
int strlen(char *s) { int c;
    c=0;
    while (*s!=0) {s++; c++;}
    return c;
    }
int strcpy(char *s, char *t) {
    do { *s=*t; s++; t++; }
    while (*t!=0);
    *s=0;
    return s;
    }
int eqstr(char *p, char *q) {
    while(*p) {
        if (*p != *q) return 0;
            p++;
            q++;
            }
    if(*q) return 0;
    return 1;
    }
int strcat1(char *s, char *t) {
    while (*s != 0) s++;
    strcpy(s, t);
    }
int toupper(char *s) {
    while(*s) {
        if (*s >= 'a') if (*s <= 'z') *s=*s-32;
            s++;
              }
    }

int testReg() {
//ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  R2Type=0;
  if (strlen(Symbol) < 2) return 0;
  if (strlen(Symbol) > 3) return 0;
  R2Type=BYTE;
  if (eqstr(SymbolUpper, "AL")) return 0;
  if (eqstr(SymbolUpper, "CL")) return 1;
  if (eqstr(SymbolUpper, "DL")) return 2;
  if (eqstr(SymbolUpper, "BL")) return 3;
  if (eqstr(SymbolUpper, "AH")) return 4;
  if (eqstr(SymbolUpper, "CH")) return 5;
  if (eqstr(SymbolUpper, "DH")) return 6;
  if (eqstr(SymbolUpper, "BH")) return 7;
  R2Type=WORD;
  if (eqstr(SymbolUpper, "AX")) return 0;
  if (eqstr(SymbolUpper, "CX")) return 1;
  if (eqstr(SymbolUpper, "DX")) return 2;
  if (eqstr(SymbolUpper, "BX")) return 3;
  if (eqstr(SymbolUpper, "SP")) return 4;
  if (eqstr(SymbolUpper, "BP")) return 5;
  if (eqstr(SymbolUpper, "SI")) return 6;
  if (eqstr(SymbolUpper, "DI")) return 7;
  R2Type=SEGREG;
  if (eqstr(SymbolUpper, "ES")) return 0;
  if (eqstr(SymbolUpper, "CS")) return 1;
  if (eqstr(SymbolUpper, "SS")) return 2;
  if (eqstr(SymbolUpper, "DS")) return 3;
  if (eqstr(SymbolUpper, "FS")) return 4;
  if (eqstr(SymbolUpper, "GS")) return 5;
  R2Type=DWORD;
  if (eqstr(SymbolUpper, "EAX"))return 0;
  if (eqstr(SymbolUpper, "ECX"))return 1;
  if (eqstr(SymbolUpper, "EDX"))return 2;
  if (eqstr(SymbolUpper, "EBX"))return 3;
  if (eqstr(SymbolUpper, "ESP"))return 4;
  if (eqstr(SymbolUpper, "EBP"))return 5;
  if (eqstr(SymbolUpper, "ESI"))return 6;
  if (eqstr(SymbolUpper, "EDI"))return 7;
  R2Type=0; return 0;
}

int prc(unsigned char c) {
    if (isPrint) {
        if (c==10) {
            ax=13;
            writetty();
        }
        al=c;
        writetty();
    }
    fputcR(c, lst_fd);
}

int prscomment(unsigned char *s) {
    unsigned char c;
    while (*s){
        c=*s;
        prc(c);
        s++;
    }
}
int printstring(unsigned char *s) {
    unsigned char c;
    int com;
    com=0;
    while (*s) {
        c=*s;
        if (c==34) {
            if (com) com=0;
                else com=1;
        }
        if (c==92) {
            if (com==0) {
                s++;
                c=*s;
                if (c=='n') c=10;
                if (c=='t') c= 9;
            }
        }
        prc(c);
        s++;
    }
}
int printhex4(unsigned char c) {
    c += 48;
    if (c > 57) c += 7;
    prc(c);
}
int printhex8(unsigned char c) {
    unsigned char nib;
    nib = c >> 4; printhex4(nib);
    nib = c & 15; printhex4(nib);
}
int printhex16(unsigned int i) {
    unsigned int half;
    half = i >>  8; printhex8(half);
    half = i & 255; printhex8(half);
}
int printunsigned(unsigned int n) {
    unsigned int e;
    if (n >= 10) {
        e=n/10; //DIV
        printunsigned(e);
    }
    n = n % 10; //unsigned mod
    n += '0';
    prc(n);
}
int printLine() {
    unsigned int i; char c;
    printstring("\n");
    i=PCStart + Origin;
    printhex16(i);
    if (OpPrintIndex == 0) printstring("               ");
    else {
//        prc(' ');
        i=0;
        do {
            c=OpPos[i];
            prc(' ');
            printhex8(c);
            i++;
        } while (i < OpPrintIndex);
        while (i < OPMAXLEN) {// fill rest with blank
            printstring("   ");
            i++;
        }
    }
    prc(PrintRA);
    prscomment(InputBuf);
}

int epilog() {
    unsigned int i; int j; char c;
    isPrint=1;
    printstring(", Output: ");
    printstring(namelst);
    if (ErrorCount == 0) {
        printstring(", no errors, ");
        printstring(namebin);
        printstring("= ");
        printunsigned(BinLen);
        printstring(" bytes.");
        bin_fd=creatR(namebin);
        if(DOS_ERR){
            cputs("can not create COM file: ");
            cputs(namebin);
            exitR(2);
        }
        i=0;
        do {
            c = FileBin[i];
            fputcR(c, bin_fd);
            i++;
        } while (i < BinLen);
    fcloseR(bin_fd);
    }
    fcloseR(asm_fd);
    fcloseR(lst_fd);
    exitR(ErrorCount);
}

int error1(char *s) {
    isPrint=1;
    ErrorCount++;
    printLine();
    printstring("\n*** ERROR: ");
    printstring(s);
    printstring(", Symbol >>");
    printstring(Symbol);
    printstring("<< in proc ");
    printstring(ProcName);
    epilog();
}
int notfounderror(){error1("label not found: ");}
int dataexit()     {error1("DB,DW,DD or RESB,W,D expected");}
int addrerror()    {error1("address missing");}
int immeerror()    {error1("immediate not allowed here");}
int implerror()    {error1("not implemented");}
int indexerror()   {error1("invalid index register");}
int invaloperror() {error1("invalid or no operands");}
int numbererror()  {error1("number expected");}
int regmemerror()  {error1("only register or memory allowed");}
int reg16error()   {error1("only reg16, no segreg allowed");}
int segregerror()  {error1("segment register not allowed");}
int syntaxerror()  {error1("syntax");}

int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR
  if (c == 10) return 1;//LF
  if (c == 13) {//CR
    DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
    if (DOS_ByteRead != 10) error1("missing LF(10) after CR(13)");
    return 1;
  }
  return 0;
}
int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  unsigned int i;
  InputPtr= &InputBuf;
  *InputPtr=0;//if last line is empty
  do {
    DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
    if (DOS_ERR) error1("Reading Source");
    if (DOS_NoBytes == 0) return;
    *InputPtr = DOS_ByteRead;
    InputPtr++;
    i = InputPtr - &InputBuf;
    if (i >= INPUTBUFMAX) error1("input line too long");
  } while (ifEOL(DOS_ByteRead) == 0);
  InputPtr--;
  *InputPtr=0;
}
int skipBlank() {
  skipblank1:
    if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
    if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
}

int getDigit(unsigned char c) {//ret: SymbolInt
  unsigned int CastInt;
  SymbolInt=0;//todo input hex with 0x1234 as digit in A.C
  do {
    c-='0';
    SymbolInt=SymbolInt*10;
    ax=0;
    CastInt=c; //cast b2w
    SymbolInt=SymbolInt+CastInt;
    InputPtr++;
    c = *InputPtr;
  } while(digit(c));
}
int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  char *p; unsigned int i;
  p = &Symbol;
  *p = c;
  p++;
  while (alnumE(c)) {
    InputPtr++;
    c = *InputPtr;
    *p = c;
    p++;
    i = p - &Symbol;
    if (i >= IDLENMAX) error1("symbol too long");
  }
  if (c == ':') isLabel=1; else isLabel=0;
  p--;
  *p = 0;
  strcpy(SymbolUpper, Symbol);
  toupper(SymbolUpper);
}

//OpName, 0, CodeType, Code1
//  1:   1 byte opcod
char T00[]={'P','U','S','H','A',0,1,0x60, 'P','O','P','A',0,    1,0x61};
char T01[]={'N','O','P',0,        1,0x90, 'C','B','W',0,        1,0x98};
char T02[]={'C','W','D','E',0,    1,0x98, 'C','W','D',0,        1,0x99};
char T03[]={'C','D','Q',0,        1,0x99, 'W','A','I','T',0,    1,0x9B};
char T04[]={'P','U','S','H','F',0,1,0x9C, 'P','O','P','F',0,    1,0x9D};
char T05[]={'S','A','H','F',0,    1,0x9E, 'L','A','H','F',0,    1,0x9F};
char T06[]={'M','O','V','S','B',0,1,0xA4, 'M','O','V','S','W',0,1,0xA5};
char T07[]={'C','M','P','S','B',0,1,0xA6, 'C','M','P','S','W',0,1,0xA7};
char T08[]={'S','T','O','S','B',0,1,0xAA, 'S','T','O','S','W',0,1,0xAB};
char T09[]={'L','O','D','S','B',0,1,0xAC, 'L','O','D','S','W',0,1,0xAD};
char T10[]={'S','C','A','S','B',0,1,0xAE, 'S','C','A','S','W',0,1,0xAF};
char T11[]={'L','E','A','V','E',0,1,0xC9, 'I','N','T','3',0,    1,0xCC};
char T12[]={'I','N','T','O',0,    1,0xCE, 'I','R','E','T',0,    1,0xCF};
char T13[]={'X','L','A','T',0,    1,0xD7, 'L','O','C','K',0,    1,0xF0};
char T14[]={'R','E','P','N','E',0,1,0xF2, 'R','E','P','N','Z',0,1,0xF2};
char T15[]={'R','E','P','E',0,    1,0xF3, 'R','E','P','Z',0,    1,0xF3};
char T16[]={'H','L','T',0,        1,0xF4, 'C','L','C',0,        1,0xF8};
char T17[]={'S','T','C',0,        1,0xF9, 'C','L','I',0,        1,0xFA};
char T18[]={'S','T','I',0,        1,0xFB, 'C','L','D',0,        1,0xFC};
char T19[]={'S','T','D',0,        1,0xFD};
// 2: mem reg 16 bit
char T20[]={'I','N','C',0,        2, 0,   'D','E','C',0,        2, 1};
char T21[]={'N','O','T',0,        2, 2,   'N','E','G',0,        2, 3};
char T22[]={'M','U','L',0,        2, 4,   'I','M','U','L',0,    2, 5};
//IMUL acc only
char T23[]={'D','I','V',0,        2, 6,   'I','D','I','V',0,    2, 7};
//  3: les, lda, lea, lss, lfs, lgs
char T24[]={'L','E','S',0,        3,0xC4, 'L','D','S',0,        3,0xC5};
char T25[]={'L','E','A',0,        3,0x8D, 'L','S','S',0,        3,0xB2};
char T26[]={'L','F','S',0,        3,0xB4, 'L','G','S',0,        3,0xB5};
//  4: acc,imm  reg,imm  index,reg
char T27[]={'A','D','D',0,        4, 0,   'O','R',0,            4, 1};
char T28[]={'A','D','C',0,        4, 2,   'S','B','B',0,        4, 3};
char T29[]={'A','N','D',0,        4, 4,   'S','U','B',0,        4, 5};
char T30[]={'X','O','R',0,        4, 6,   'C','M','P',0,        4, 7};
//  5: mov
char T31[]={'M','O','V',0,        5, 0};
//  6: single byte relative jump
char T32[]={'J','O',0,            6, 0,    'J','N','O',0,       6, 1};
char T33[]={'J','B',0,            6, 2,    'J','C',0,           6, 2};
char T34[]={'J','N','B',0,        6, 3};
char T35[]={'J','A','E',0,        6, 3,    'J','N','C',0,       6, 3};
char T36[]={'J','E',0,            6, 4,    'J','Z',0,           6, 4};
char T37[]={'J','N','E',0,        6, 5,    'J','N','Z',0,       6, 5};
char T38[]={'J','B','E',0,        6, 6,    'J','N','A',0,       6, 6};
char T39[]={'J','A',0,            6, 7,    'J','S',0,           6, 8};
char T40[]={'J','N','S',0,        6, 9};
char T41[]={'J','P',0,            6,10,    'J','P','E',0,       6,10};
char T42[]={'J','N','P',0,        6,11,    'J','P','O',0,       6,11};
char T43[]={'J','L',0,            6,12};
char T44[]={'J','N','L',0,        6,13,    'J','G','E',0,       6,13};
char T45[]={'J','L','E',0,        6,14,    'J','N','G',0,       6,14};
char T46[]={'J','G',0,            6,15};
//  7: jmp, call
char T47[]={'J','M','P',0,        7,0xE9,  'C','A','L','L',0,   7,0xE8};
//  8: ret
char T48[]={'R','E','T',0,        8,0xC3,  'R','E','T','F',0,   8,0xCB};
//  9: seg, r/m
char T49[]={'P','U','S','H',0,    9,0x50,  'P','O','P',0,       9,0x58};
//  11: shift, rotates
char T50[]={'R','O','L',0,       11, 0,    'R','O','R',0,      11, 1};
char T51[]={'R','C','L',0,       11, 2,    'R','C','R',0,      11, 3};
char T52[]={'S','H','L',0,       11, 4,    'S','A','L',0,      11, 4};
char T53[]={'S','H','R',0,       11, 5,    'S','A','R',0,      11, 7};
//  12: int
char T54[]={'I','N','T',0,       12,0xCD};
//  14: in/out                   not implemented
char T55[]={'I','N',0,           14,0xE4,  'I','N','S','B',0,  14,0x6C};
char T56[]={'I','N','S','W',0,   14,0x6D,  'I','N','S','D',0,  14,0x6D};
char T57[]={'O','U','T',0,       14,0xE6,  'O','U','T','B',0,  14,0x6E};
char T58[]={'O','U','T','W',0,   14,0x6F,  'O','U','T','D',0,  14,0x6F};
//  15: xch                      not implemented
char T59[]={'X','C','H','G',0,   15,0x86};
//  16: loop, jcxz               not implemented
char T60 []={'L','O','O','P','N','Z',0,16,0xE0};
char T60a[]={'L','O','O','P','N','E',0,16,0xE0};
char T61[]={'L','O','O','P','Z',0,16,0xE1,'L','O','O','P','E',0,16,0xE1};
char T62[]={'L','O','O','P',0,    16,0xE2};
char T63[]={'J','C','X','Z',0,    16,0xE3,'J','E','C','X','Z',0,16,0xE3};
//  30: other
char T64[]={'E','N','T','E','R',0,30,0};
//                                not implemented
char T65[]={'T','E','S','T',0,    41,0xF6};
char T66[]={'M','O','V','S','X',0,51,0xBE,'M','O','V','Z','X',0,51,0xB6};
// 100: directives
char T67[]={'O','R','G',0,      101, 0};
// section, segment .TEXT .DATA .BSS
char T68[]={'S','E','C','T','I','O','N',0,      102, 0};
char T69[]={'S','E','G','M','E','N','T',0,      102, 0};
char T70[]={'A','B','S','O','L','U','T','E',0,  110, 0};
char T71[]={'P','R','O','C',0,    111, 0, 'E','N','D','P',0, 112, 0};
char T72[]={'D','B',0,            200, 0, 'D','W',0,         201, 0};
char T73[]={'D','D',0,            202, 0, 'R','E','S','B',0, 203, 0};
char T74[]={'R','E','S','W',0,    204, 0, 'R','E','S','D',0, 205, 0};
char TEND=0;// end of table char

int lookCode1() {//ret: CodeType, Code1
    OpCodePtr= &T00;
    do  {
        if (eqstr(SymbolUpper, OpCodePtr))  {
            while(*OpCodePtr!=0) OpCodePtr++;
            OpCodePtr++;
            CodeType = *OpCodePtr;
            OpCodePtr++;
            Code1    = *OpCodePtr;
            return;
        }
        while(*OpCodePtr!=0) OpCodePtr++;
        OpCodePtr += 3;

        } while(*OpCodePtr!=0);
    CodeType=0;
}


int genCode8(char c) {
//set: BinLen++, OpPrintIndex++
    FileBin[BinLen]=c;
    BinLen++;
    PC++;
    if (BinLen >= FILEBINMAX) error1("COM file too long");
    if (OpPrintIndex < OPMAXLEN) {
        OpPos[OpPrintIndex]=c;
        OpPrintIndex++;
    }
}
int gen66h() {genCode8(0x66);
}
int genCode2(char c, char d) {
    c = c + d;
    genCode8(c);
}
int genCodeW(char c) {
    c = c + wflag;
    genCode8(c);
}
int genCode16(unsigned int i) {
    genCode8(i); i=i >> 8;
    genCode8(i);
}
int genCode32(unsigned long L) {
    genCode16(L); L=L >>16;
    genCode16(L);
}
int writeEA(char xxx) {//value for reg/operand
//need: Op, Op2, disp, R1No, R2No, rm, isDirect
//mod-bits: mode76, reg/opcode543, r/m210
//Op: 0, IMM, REG, ADR, MEM
    int disploc;
    char len;
    len=0;
    xxx = xxx << 3;//in reg/opcode field
    if (Op == REG) {
        xxx |= 0xC0;
        if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM
            else {
                if (Op2 == REG) xxx = xxx + R1No;
                else            xxx = xxx + R2No;
            }
        }
    if (Op == MEM) {
        if (isDirect) {
            xxx |= 6;
            len = 2;
        }
        else {
            xxx = xxx + rm;
            if (rm == 6) {//make [BP+00]
                len=1;
                if (disp == 0) xxx |= 0x40;
            }

            if (disp) {
                disploc=disp;
                if (disploc  < 0) disploc=mkneg(disploc);
                if (disploc > 127) len=2;
                else len=1;
                if (len == 1) xxx |= 0x40;
                else xxx |= 0x80;
            }
        }
    }

    genCode8(xxx);// gen second byte
    if (len == 1) genCode8 (disp);
    if (len == 2) genCode16(disp);
}

int genImmediate() {
    if (wflag) if (OpSize == DWORD) genCode32(imme);
        //todo imme long
        else genCode16(imme);
    else       genCode8 (imme);
}

int setwflag() {//word size, bit 0
    wflag=0;
    if (OpSize == 0) {//do not override OpSize
        if (Op == REG) OpSize=R1Type;
        if (Op2== REG) OpSize=R2Type;
        if (R2Type== SEGREG) OpSize=WORD;
        if (R1Type == SEGREG) OpSize=WORD;
    }
    if (OpSize  == DWORD) {gen66h(); wflag=1;}
    if (OpSize  ==  WORD) wflag=1;
}
int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3
    unsigned int ui;
    sflag=2;
    ui = imme & 0xFF80;//is greater than signed 127?
    if(ui != 0) sflag = 0;
    if (OpSize == BYTE) {
        if (imme > 255) error1("too big for byte r/m");
        sflag=0;//byte reg does not need sign extended
    }
}
int checkConstSize(unsigned int ui) {
    if (ui > 127   ) return 0;//is near; return sflag
    if (ui < 0xFF80) return 0;//-128dez
    return 2;// is short
}


int ChangeDirection() {
    char c;
    c=Op;     Op    =Op2;    Op2   =c;
    c=R1Type; R1Type=R2Type; R2Type=c;
    c=R1No;   R1No  =R2No;   R2No  =c;
    dflag=2;
}

int getTokeType() {
    char c;
    skipBlank();
    c = *InputPtr;
    if (c == 0)   {TokeType=0; return; }//last line or empty line
    if (c == ';') {TokeType=0; return; }//comment
    if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
    if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
    TokeType=NOALNUME;
}

int isToken(char c) {
    skipBlank();
    if (*InputPtr == c) {
        InputPtr++;
        return 1;
        }
    return 0;
}


int need(char c) {
    if (isToken(c)) {
        getTokeType();
        return;
        }
        isPrint=1;
    printstring(" need: ");
    prc(c);
    error1("character misssing");
}
int skipRest() {
    getTokeType();
    if(TokeType)error1("extra char ignored");
}


int checkOpL() {
    if (Op == ADR) implerror();
    if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
    setwflag();
    if (OpSize == 0) error1("no op size declared");
    if (OpSize == R1Type) return;
    if (Op == REG) if (R1Type==0) error1("no register defined");
}

int searchLabel() {
    int LIx; char *p;
    p = &LabelNames;
    LIx = 1;
    while (LIx <= LabelMaxIx) {
        if (eqstr(p, Symbol)) return LIx;//pos of label
        p=strlen(p) + p;
        p++;
        LIx++;
    }
    return 0;
}

int getOp1() {//scan for a single operand
//return:0, IMM, REG, ADR (not MEM)
//set   :R2Type, R2No by testReg
//set   :LabelIx by searchLabel
    if (TokeType == 0)      return 0;
    if (TokeType == DIGIT)  return IMM;
    if (TokeType == ALNUME) {
        R2No=testReg();
        if (R2Type)        return REG;
        LabelIx=searchLabel();
        return ADR;
    }
    return 0;
}

int getIndReg1() {
    if (R2Type !=WORD) indexerror();
    if (R2No==3) rm=7;//BX
    if (R2No==5) rm=6;//BP, change to BP+0
    if (R2No==7) rm=5;//DI
    if (R2No==6) rm=4;//SI
    if (rm==0) indexerror();
}
int getIndReg2() {char m; m=4;//because m=0 is BX+DI
    if (R2Type !=WORD) indexerror();
    if (R2No==7) if (rm==6) m=3;//BP+DI
             else if (rm==7) m=1;//BX+DI
    if (R2No==6) if (rm==6) m=2;//BP+SI
             else if (rm==7) m=0;//BX+SI
    if (m > 3) indexerror();
    return m;
}
int getMEM() {// e.g. [CS: array + bp+si -4]
//set: disp, rm, R2Type
    char c;
    disp=0; rm=0;
    do {
        getTokeType();
        c=getOp1();
        if (R2Type == SEGREG) {//put segment prefix
            if (R2No == 0) genCode8(0x26);//ES:
            if (R2No == 1) genCode8(0x2E);//CS:
            if (R2No == 2) genCode8(0x36);//SS:
            if (R2No == 3) genCode8(0x3E);//DS:
            if (R2No == 4) genCode8(0x64);//FS:
            if (R2No == 5) genCode8(0x65);//GS:
            need(':');// includes getTokeType();
            c=getOp1();
        }
        if (c ==   0) syntaxerror();
        if (c == REG) {
            isDirect=0;
            if (rm) rm=getIndReg2();
            else getIndReg1();
        }
        if (c == ADR) {
            if (LabelIx)    disp=disp+LabelAddr[LabelIx];
            else notfounderror();
        }
        if (c == IMM) disp=disp+SymbolInt;
        if (isToken('-')) {
            getTokeType();
            if (TokeType != DIGIT) numbererror();
            disp = disp - SymbolInt;
        }
    } while (isToken('+'));
    if (isToken(']') == 0) error1("] expected");
}

int getOpR() {
    Op2=getOp1();
    if (isToken('[')) {Op2 = MEM; getMEM();    return;}
    if (Op2 == 0)     {invaloperror();         return;}
    if (Op2 == IMM)   {imme=SymbolInt;         return;}
    if (Op2 == REG)                            return;
    if (Op2 == ADR)   {
        if (LabelIx == 0) disp=0;
        else disp=LabelAddr[LabelIx];
        return;}
    error1("Name of operand expected");
}

int getOpL() {//set: op=0,IMM,REG,ADR,MEM
    getOpR();
    Op=Op2;         Op2=0;
    R1No=R2No;      R2No=0;
    R1Type=R2Type;  R2Type=0;
}

int get2Ops() {
    getOpL();
    need(',');
    getOpR();
}
int check2Ops() {
    get2Ops();
    if (Op ==   0) addrerror();
    if (Op == ADR) invaloperror();
    if (Op == IMM) immeerror();
    if (Op2==   0) addrerror();
    setwflag();
}

int storeJmp() {
    unsigned int i;
    JmpMaxIx++;
    if (JmpMaxIx >= JMPMAX) error1("too many Jmp");
    JmpNamePtr=strcpy(JmpNamePtr, Symbol);
    JmpNamePtr++;
    i = JmpNamePtr - &JmpNames;
    i += IDLENMAX;
    if ( i >= JMPNAMESMAX) error1("too many Jmp names");
    JmpAddr[JmpMaxIx] = PC;
}

int storeLabel() {
    unsigned int i;
    if(searchLabel()) error1("duplicate label");
    LabelMaxIx++;
    if (LabelMaxIx >= LABELADRMAX) error1("too many labels");
    LabelNamePtr=strcpy(LabelNamePtr, Symbol);
    LabelNamePtr++;
    i = LabelNamePtr - &LabelNames;
    i += IDLENMAX;
    if (i >= LABELNAMESMAX) error1("too many label names");
    LabelAddr[LabelMaxIx] = PC + Origin;
}


int genDB() {
    char c;  char isloop;
        isloop = 0;
            do {
                if (isloop) getTokeType();//omit ,
                if (TokeType == DIGIT) genCode8(SymbolInt);
                else {
                    skipBlank();
                    if (isToken('"')) {
                        do {
                            c= *InputPtr;
                            genCode8(c);
                            InputPtr++;
                        } while (*InputPtr != '"' );
                        InputPtr++;
                    }
                }
                isloop = 1;
            } while (isToken(','));
}

int getVariable() {
    char c;
    storeLabel();
    getTokeType();
    if(TokeType==ALNUME) {//getName
        lookCode1();
        if (CodeType < 200) dataexit();
        if (CodeType > 205) dataexit();
        if (CodeType== 200) {//DB
            do {
                getTokeType();
                if (TokeType == DIGIT) genCode8(SymbolInt);
                else {
                    skipBlank();
                    if (isToken('"')) {
                        do {
                            c= *InputPtr;
                            genCode8(c);
                            InputPtr++;
                        } while (*InputPtr != '"' );
                        InputPtr++;
                    }
                }
            } while (isToken(','));
        }
        if (CodeType == 201) {//DW
            do {
                getTokeType();
                if (TokeType ==DIGIT) genCode16(SymbolInt);
            } while (isToken(','));
        }
        if (CodeType == 202) {//DD
            do {
                getTokeType();
                if (TokeType ==DIGIT) { genCode16(SymbolInt);
                                    genCode16(0);}//todo genCode32(SymbolLong);
            } while (isToken(','));
        }
        if (CodeType >= 203) {//resb, resw, resd
            getTokeType();
            if (TokeType == DIGIT) {
                if (SymbolInt <= 0) syntaxerror();
                if (AbsoluteLab == 0) error1("Absolute is null");
                LabelAddr[LabelMaxIx] = AbsoluteLab;
                if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw
                if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd
                AbsoluteLab = AbsoluteLab + SymbolInt;
            } else numbererror();
        }
    }
    else dataexit();
}

int getCodeSize() {
    if (TokeType ==ALNUME) {
        if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
        if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
        if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
    }
    return 0;
}

int FixOneJmp(unsigned int hex) {
    int Ix; char c;
    Ix=searchLabel();
    if (Ix == 0) notfounderror();
    disp = LabelAddr[Ix];
    c = FileBin[hex];//look for 'A' push Absolute
    if (c != 0xAA) {
        disp = disp - hex;
        disp = disp -2;//PC points to next instruction
        disp = disp - Origin;
    }
    FileBin[hex] = disp;//fix low byte
    hex++;
    disp = disp >> 8;
    FileBin[hex] = disp;
}
int fixJmp() {
    unsigned int hex; int i;
    char *p;
    p = &JmpNames;
    i = 1;
    while (i <= JmpMaxIx) {
        strcpy(Symbol, p);
        p = strlen(Symbol) + p;
        p++;
        hex = JmpAddr[i];
        FixOneJmp(hex);
        i++;
    }
}
int fixJmpMain() {
    if (JmpMaxIx ) error1("resting global jmp");
    strcpy(Symbol, "main");
    FixOneJmp(1);//first instruction, PC=1
}


int process() {
    char c;
    int i;
    Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
    disp=imme=0;//int
    isDirect=1; //set in getMeM=0, need in WriteEA
    getTokeType();//0, DIGIT, ALNUME, NOALNUME
    OpSize=getCodeSize();//0, BYTE, WORD, DWORD

    if (CodeType ==  1) {//1 byte opcode
        genCode8(Code1);
        return;
    }

    if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
        getOpL();
        checkOpL();
        if (Code1 < 2) {//inc,dec
  	        if (Op == REG) {//short
                if (wflag) {
                    if (Code1) genCode2(0x48, R1No);//DEC
                        else   genCode2(0x40, R1No);//INC
                    return;
                    }
            }
        }
        if (Code1 == 5) {//imul extension?
            getTokeType();
            if (TokeType) implerror();
        }
        if (Code1 < 2) genCodeW(0xFE);
            else genCodeW(0xF6);
        writeEA(Code1);
        return;
    }

    if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
        check2Ops();    //setwflag not applicable
        if (R1Type != WORD) reg16error();//only r16
        if (Op2 != MEM) addrerror();//only m16

        if (Code1 >= 0xB2) {
            if (Code1 <= 0xB5) genCode8(0x0F);//lss,lfs,lgs
        }
        genCode8(Code1);
        Op=Op2;//set MEM for writeEA
        writeEA(R1No);
        return;
    }

    if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
        check2Ops();
        if (Op2 == ADR) {
            if (LabelIx == 0) notfounderror();
            imme=LabelAddr[LabelIx];
            Op2=IMM;//got the addr and fall through
        }
        if (Op2 == IMM) {//second operand is imm
            setsflag();
            if (Op == REG) {
                if (R1No == 0) {// acc,imm
                    if (sflag == 0) {
                        c = Code1 << 3;
                        c += 4;
                        genCodeW(c);
                        genImmediate();
                        return;
                    }
                }
            }
            //r/m, imm: 80 sign-extended,TTT,imm
            c = sflag + 0x80;
            genCodeW(c);
            writeEA(Code1);
            if (sflag) genCode8(imme);
            else genImmediate();
            return;
        }
        c = Code1 << 3;//r/m, r/r
        if (Op == REG) {
            if (Op2 == MEM) {//reg, mem
                c += 2;//add direction flag
                genCodeW(c);
                Op=Op2;//set MEM for writeEA
                writeEA(R1No);
                return;
            }
        }
        if (Op2 == REG) {//mem,reg    reg,reg
            genCodeW(c);
            writeEA(R2No);//2. Op in reg-field
            return;
        }
        syntaxerror();
        return;
    }

    if (CodeType == 5) {//mov (movsx, movzx=51)
        check2Ops();
        if (Op2 == ADR) {
            if (disp) imme=disp;
            else notfounderror();
            Op2=IMM;//continue with IMM
        }
        if (Op2 == IMM) {// r,i
            if (Op == REG) {
                c = wflag << 3;
                c += 0xB0;
                genCode2(c, R1No);
                genImmediate();
                return;
            }
            if (Op == MEM) {// m,i
                genCodeW(0xC6);
                writeEA( 0 );
                genImmediate();
                return;
            }
            regmemerror();
            return;
        }
        if (R1Type == SEGREG) ChangeDirection();//sreg,rm
        if (R2Type == SEGREG) {//rm,sreg
            if (OpSize != WORD) reg16error();
                genCode2(0x8C, dflag);
                writeEA(R2No);
                return;
        }
        if (Op2 == MEM) {//acc, moffs16
            if (Op == REG) {
                if (R1No == 0) {
                    if (isDirect) {
                        genCodeW(0xA0);
                        genCode16(disp);
                        return;
                    }
                }
            }
        }
        if (Op == MEM) {//moffs16, acc
            if (Op2 == REG) {
                if (R2No == 0) {
                    if (isDirect) {
                        genCodeW(0xA2);
                        genCode16(disp);
                        return;
                    }
                }
            }

        }
        if (Op2 == REG) {//rm, r
            genCodeW(0x88);
            writeEA(R2No);
            return;
        }
        if (Op2 == MEM) {//r, m
            if (Op == REG) {
                ChangeDirection();
                genCodeW(0x8A);
                writeEA(R2No);
                return;
            }
        }
        syntaxerror();
        return;
    }

    if (CodeType == 6) {//Jcc
        if (TokeType == ALNUME) {
            LabelIx=searchLabel();
            if (LabelIx > 0) {
                disp=LabelAddr[LabelIx];
                disp = disp - PC;
                disp = disp - Origin;
                if (checkConstSize(disp) ) {
                    genCode2(Code1, 0x70);//short
                    disp -= 2;
                    genCode8(disp);
                } else {
                    genCode8(0x0F);
                    genCode2(Code1, 0x80);//near
                    disp -= 4;
                    genCode16(disp);
                }
            }
            else {//jump forward, near only
                genCode8(0x0F);
                genCode2(Code1, 0x80);
                storeJmp();
                genCode16(0);
                PrintRA='r';
            }
        return;
        }
    }

    if (CodeType == 7) {//jmp, call
        if (TokeType == ALNUME) {
            LabelIx=searchLabel();
            if (LabelIx > 0) {
                disp=LabelAddr[LabelIx];
                disp = disp - PC;
                disp = disp - Origin;
                if (checkConstSize(disp) ) {
                    if (Code1 == 0xE9) {//jmp only
                        genCode8(0xEB);//short
                        disp -= 2;
                        genCode8(disp);
                    }
                    else {
                        genCode8(Code1);//near
                        disp -= 3;
                        genCode16(disp);
                    }
                }
                else {
                    genCode8(Code1);//near
                    disp -= 3;
                    genCode16(disp);
                }
            }
            else {//jump forward, near only
                genCode8(Code1);
                if (PC != 1) storeJmp();//omit jmp main
                genCode16(0);
                PrintRA='R';
            }
        return;
        }
    }

    if (CodeType ==  8) {//ret,retf
        if (TokeType == DIGIT) {
            if (Code1 == 0xC3) genCode8(0xC2);//ret n
                else genCode8(0xCA);//retf n
            genCode16(SymbolInt);
            return;
        }
        genCode8(Code1);
        return;
    }

    if (CodeType == 9) {//push, pop
        getOpL();
        if (Code1 == 0x50) {//push only
            if (Op == IMM) {//push imm8,16
                setsflag();
                genCode2(0x68, sflag);
                if (sflag) genCode8 (imme);
                else       genCode16(imme);
                return;
            }
            if (Op == ADR) {//push string ABSOLUTE i16
                if (disp) {
                    genCode8(0x68);
                    genCode16(disp);
                    return;
                }
                else {
                    genCode8(0x68);
                    storeJmp();
                    genCode16(0xAAAA);//magic for abs ADR
                    PrintRA='A';
                    return;
                }
            }
        }
        if (R1Type == SEGREG) {
            if (Code1 == 0x58) {//pop only
                if (R1No == 1) error1("pop cs not allowed");
            }
            c = R1No <<3;
            if (R1No > 3) {//FS, GS
                c += 122;  //0x7A
                genCode8(0x0F);
            }
            if (Code1 == 0x50) c +=6;//push
                else c += 7;//pop
            genCode8(c);
            return;
        }
        checkOpL();//sorts out:ADR,SEGREG  resting: REG, MEM

        if (Op == MEM) {
            if (Code1 == 0x50) {//push word [bp+6]
                genCode8(0xFF);
                writeEA(6);
            }else {
                genCode8(0x8F);
                writeEA(0);
            }
            return;
        }
        if (R1Type == BYTE) reg16error();
        if (R1Type == WORD) {//is REG, w/o SEGREG
            genCode2(Code1, R1No);
            return;
        }
        syntaxerror();
        return;
    }

    if (CodeType == 11) {//shift, rotate
        check2Ops();
        if (Op2 == IMM) {
            if (imme == 1) {
                genCodeW(0xD0);
                writeEA(Code1);
                return;
            }
            genCodeW(0xC0);//80186
            writeEA(Code1);
            genCode8(imme);
            return;
        }
        if (Op2 == REG) {
            if (R2Type == BYTE) {
                if (R2No == 1) {//CL-REG
                    if (R1Type == WORD) wflag=1;//hack
                    genCodeW(0xD2);
                    writeEA(Code1);
                    return;
                }
            }
        }
    }

    if (CodeType == 12) {//int
        if (TokeType == DIGIT) {
            genCode8(Code1);
            genCode8(SymbolInt);
            return;
        }
    }

    if (CodeType == 14) {//in, out
        implerror();
        return;
    }
    if (CodeType == 15) {//xchg
        implerror();
        return;
    }
    if (CodeType == 16) {//loop
        implerror();
        return;
    }

    if (CodeType == 30) {//enter i18,i8
        genCode8(0xC8);
        Op=getOp1();
        if (Op == IMM) genCode16(SymbolInt);
        else numbererror();
        need(',');
        Op=getOp1();
        if (Op == IMM) genCode8 (SymbolInt);
        else numbererror();
        return;
    }

    if (CodeType == 41) {//test
        implerror();
        return;
    }

    if (CodeType == 51) {//movsx, movzx=51
        implerror();
        return;
    }

    if (CodeType==101) {//ORG nn
        if (TokeType != DIGIT) numbererror();
        Origin=SymbolInt;
        return;
    }

    if (CodeType == 102) {//section, segment
        //getTokeType();//ignore .bss .text .data
        AbsoluteLab=0;//nasm resets erevy time
        return;
    }

    if (CodeType == 110) {//absolute
        if (TokeType != DIGIT) numbererror();
        AbsoluteLab=SymbolInt;
        return;
    }
    if (CodeType == 111) {//name: PROC
        if (isInProc == 0)  {
            printstring("\nentering: ");
            printstring(ProcName);
            isInProc=1;
            tmpLabelNamePtr = LabelNamePtr;
            tmpLabelMaxIx   = LabelMaxIx;
            tmpJmpNamePtr   = JmpNamePtr;
            tmpJmpMaxIx     = JmpMaxIx;
        } else error1("already in PROC");
        return;
    }
    if (CodeType == 112) {//ENDP
        if (isInProc == 0) error1("not in PROC");
        printstring("\nleaving: ");
        printstring(ProcName);
        printstring(", loc labels: ");
        i = LabelMaxIx - tmpLabelMaxIx;
        printunsigned(i);
        printstring(", loc jmp forward: ");
        i = JmpMaxIx - tmpJmpMaxIx;
        printunsigned(i);
        fixJmp();
        isInProc=0;
        LabelNamePtr = tmpLabelNamePtr;//delete local Labels
        LabelMaxIx   = tmpLabelMaxIx;
        JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp
        JmpMaxIx     = tmpJmpMaxIx;
        return;
    }
    if (CodeType == 200) {//db
        genDB();
        return;
    }

    error1("Command not implemented or syntax error");
}

int parse() {
    LabelNamePtr  = &LabelNames;
    JmpNamePtr= &JmpNames;
    LabelMaxIx=0;
    JmpMaxIx=0;
    BinLen=0;
    isInProc=0;
    isPrint=0;

    do {//process a new line
        PCStart=PC;
        OpSize=0;
        OpPrintIndex=0;
        PrintRA=' ';
        getLine();
        if (DOS_NoBytes) {
            InputPtr = &InputBuf;
            getTokeType();//getCode in SymbolUpper,
                          //set TokeType,isLabel by getName
            if (TokeType == ALNUME) {
                if (isLabel) {//set in getName
                  if (isInProc == 0)  strcpy(ProcName, Symbol);
                    storeLabel();
                    InputPtr++;//remove :
                    getTokeType();
                }
            }
            if (TokeType == ALNUME) {
                lookCode1();
                if(CodeType) process();
                else getVariable();
                skipRest();
            }
            else if(TokeType >ALNUME)error1(
                "Label or instruction expected");
            else if(TokeType==DIGIT )error1(
                "No digit allowed at start");
            printLine();
        }
    } while (DOS_NoBytes != 0 );
    isPrint=1;
}

int getarg() {
    int arglen1; int i; char *c;
    arglen1=*arglen;
    if (arglen1==0) {
        cputs(Version1);
        cputs(", Usage: AS.COM filename [w/o .S] : ");
        exitR(3);
    }
    i=arglen1+129;
    *i=0;
    arglen1--;
    toupper(argv);

    strcpy(namein, argv); strcat1(namein, ".S");
    strcpy(namelst,argv); strcat1(namelst,".LST");
    strcpy(namebin,argv); strcat1(namebin,".COM");

  DOS_ERR=0; PC=0; ErrorCount=0;

    asm_fd=openR (namein);
    if(DOS_ERR){
        cputs("Source file missing: ");
        cputs(namein);
        exitR(1);
    }
    lst_fd=creatR(namelst);
    if(DOS_ERR){
        cputs("can not create list file: ");
        cputs(namelst);
        exitR(2);
    }
    printstring(";");
    printstring(Version1);
    printstring(", Input: "); printstring(namein);
}

int main() {
    getarg();
    parse();
    fixJmpMain();
    epilog();
}
