char Version1[]="PLA compiler A.COM V1.0";//16500 bytes. 32905 stack
//todo:op=reg not recognized
#define IDLENMAX       31//max length of names
#define COLUMNMAX     128//output, input is 100
#define T_NAME        256//the following defines for better clearity
#define T_CONST       257
#define T_STRING      258
#define T_DEFINE      511
#define T_RETURN      512
#define T_IF          513
#define T_ELSE        514
#define T_WHILE       515
#define T_DO          516
#define T_INT         517
#define T_ASM         518
#define T_ASMBLOCK    519
#define T_EMIT        520
#define T_GOTO        521
#define T_VOID        529
#define T_CHAR        530
#define T_SIGNED      531
#define T_UNSIGNED    532
#define T_LONG        533
#define T_INTH        600
#define T_EQ          806
#define T_NE          807
#define T_GE          811
#define T_LE          824
#define T_PLUSPLUS   1219
#define T_MINUSMINUS 1225
#define T_PLUSASS    1230
#define T_MINUSASS   1231
#define T_MULASS     1232
#define T_DIVASS     1233
#define T_ANDASS     1234
#define T_ORASS      1235
#define T_LESSLESS   1240
#define T_GREATGREAT 1241

char isPrint=1;//set screen listing
#define ORGDATA     20000//set it to end of text
unsigned int orgDataOriginal=20000;//must be ORGDATA
unsigned int orgDatai;//actual max of array, must be less than stack
#define COMAX        3000
char co[COMAX];//constant storage
int maxco=0;
int maxco1=0;
#define CMDLENMAX      67
char Symbol[COLUMNMAX];
char fname[CMDLENMAX];
char namein[CMDLENMAX];
char namelst[CMDLENMAX];
char *cloc=0;
int fdin=0;
int fdout=0;
int token=0;
int column=0;
char thechar=0;   //reads one char forward
int iscmp=0;
int nconst=0;
int nreturn=0;
int nlabel=0;‚
unsigned int lexval=0;
int typei;       char istype;
int signi;       char issign;
int widthi;      char iswidth;
int wi=0;
#define VARMAX        400//max global and local var
char GType [VARMAX]; // 0=V, 1=*, 2=&,#
char GSign [VARMAX]; // 0=U, 1=S
char GWidth[VARMAX]; // 0, 1, 2, 4
int  GData [VARMAX];
#define VARNAMESMAX 4000//VARMAX * 10 - IDLENMAX
char VarNames[VARNAMESMAX];//Space for global and local var names
char *VarNamePtr;   //first free position
int GTop=1;         //0 = empty
// int LStart=1  ;     //max global var
int LTop=1;

#define FUNCMAX       300//max functions
#define FUNCTIONNAMESMAX 3000//Space for preceeding functon names
char FunctionNames[FUNCTIONNAMESMAX];
char *FunctionNamePtr;  //first free position in FunctionNames
int  FunctionMaxIx=0;   //number of functions

char fgetsdest[COLUMNMAX];
unsigned char *fgetsp=0;
unsigned int lineno=1;
unsigned char *pt=0;
unsigned char *p1=0;
int DOS_ERR=0;
int DOS_NoBytes=0;
char DOS_ByteRead=0;
int ireg1;
int mod2;
int ireg2;

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
    asm lea dx, [bp+4]; *n  todo: why not mov
    asm mov cx, 1;      cx=1;
    asm mov bx, [bp+6]; bx=fd;
    asm mov ax, 16384;  ax=0x4000;
    DosInt();
}

int letter(char c) {
      if (c=='_') return 1;
      if (c=='.') return 1;
      if (c=='?') return 1;
      if (c=='$') return 1;
      if (c> 'z') return 0;
      if (c< '@') return 0;// at included
      if (c> 'Z') { if (c< 'a') return 0; }
      return 1;
}
int digit(char c){
      if(c<'0') return 0;
      if(c>'9') return 0;
      return 1;
}
int alnum(char c) {
    if (digit (c)) return 1;
    if (letter(c)) return 1;
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
int strcat(char *s, char *t) {
    while (*s != 0) s++;
    strcpy(s, t);
}
int toupper(char *s) {
    while(*s) {
        if (*s >= 'a') if (*s <= 'z') *s=*s-32;
        s++;
    }
}
int instr1(char *s, char c) {
    while(*s) {
        if (*s==c) return 1;
        s++;
    }
    return 0;
}

int eprc(char c)  {
    *cloc=c;
    cloc++;
}
int eprs(char *s) {
    char c;
    while(*s) {
        c=*s;
        eprc(c);
        s++;
    }
}

int prc(unsigned char c) {
    if (isPrint) {
        if (c==10) {
            asm mov ax, 13
            writetty();
        }
        asm mov al, [bp+4]; al=c;
        writetty();
    }
    fputcR(c, fdout);
}

int prscomment(unsigned char *s) {
    unsigned char c;
    while(*s){
        c=*s;
        prc(c);
        s++;
    }
}

int printstring(unsigned char *s) {
    unsigned char c; int com;
    com=0;
    while(*s) {
        c=*s;
        if (c==34) if (com) com=0;
                   else com=1;
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

int eprnum(int n){//for docall procedure
    int e;
    if(n<0) {
        eprc('-');
        n=mkneg(n);
    }
    if (n >= 10) {
        e=n/10;
        eprnum(e);
    }
    n=n%10;
    n=n+'0';
    eprc(n);
}

int printinteger (int n){
    int e;
    if(n<0) {  prc('-');  n=mkneg(n); }
    if (n >= 10) {
        e=n/10;
        printinteger(e);
    }
    n=n%10;
    n += '0';
    prc(n);
}

int printunsigned(unsigned int n) {
    unsigned int e;
    if (n >= 10) {
        e=n/10;
        printunsigned(e);
    }
    n = n % 10; /*unsigned mod*/
    n += '0';
    prc(n);
}

int end1(int n) {
    fcloseR(fdin);
    fcloseR(fdout);
    exitR(n);
}

int error1(char *s) {
    isPrint=1;
    lineno--;
    printstring("\n ");
    prscomment(&fgetsdest);
    printstring(";Line: ");
    printunsigned(lineno);
    printstring(" ************** ERROR: ");
    printstring(s);
    printstring("  in column: ");
    printunsigned(column);
    printstring("\nToken: ");
    printunsigned(token);
    printstring(", Symbol: ");
    printstring(Symbol);
    end1(1);
}

int printinputline() {
    int col;
    col=0;
    fgetsp=&fgetsdest;
    do {
        DOS_NoBytes=readRL(&DOS_ByteRead, fdin, 1);
        if (DOS_NoBytes == 0) return;
        *fgetsp=DOS_ByteRead;
        fgetsp++;
        col++;
        if (col >100) error1("input line longer than 100 char");
        }
        while (DOS_ByteRead != 10);
    *fgetsp=0;
        printstring("\n;-");
        printunsigned(lineno);
        prc(' ');
        lineno++;
        prscomment(&fgetsdest);
}

int fgets1() {
    char c;
    c=*fgetsp;
    if (c==0) {
        printinputline();
        if (DOS_NoBytes == 0) return 0;
        fgetsp=&fgetsdest;
        c=*fgetsp;
        column=0;
    }
    fgetsp++;
    column++;
    return c;
}

int next() {
    char r;
    r = thechar;
    thechar = fgets1();
    return r;
}

int storeVarName() {
    unsigned int i;
    VarNamePtr=strcpy(VarNamePtr, Symbol);
    VarNamePtr++;
    i = VarNamePtr - &VarNames;
    i += IDLENMAX;
    if (i > VARNAMESMAX) error1("too many variable names");
}
/*
int searchVarName() {
	char *p; int i;
	p = &VarNames;
	i=1;//start with 1
	while (i < VARMAX) {
		if (eqstr(p, Symbol)) return i;
		p=strlen(p) + p;
		p++;
		i++;
	}
	return 0;		
}
*/	
int getVarName(unsigned int i) {
	int j; char *p;
	j = 1;
	p = &VarNames;
	while (j < i) {
		while (*p) p++;
		p++;
		j++;	 		
	}
	return p;	
		
}
		
int printName(unsigned int i) {
    if (i < GTop) {
	    i=getVarName(i);	    
        printstring(i);
    }
    else {
        printstring("[bp");
        i = GData[i];
        if (i>0) prc('+');
        printinteger(i);
        prc(']');
    }
}

int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR
    if (c == 10) return 1;//LF
    if (c == 13) {//CR
        if (thechar == 10) c=next();
        return 1;
    }
    return 0;
}

char symboltemp[80];

int getlex() {
    char c; char *p;
    int i; int j;
g1: c=next();
    if (c == 0) return 0;
    if (c <= ' ') goto g1;
  if (c=='=') {if(thechar=='=') {next(); return T_EQ; }}
  if (c=='!') {if(thechar=='=') {next(); return T_NE; }}
  if (c=='<') {if(thechar=='=') {next(); return T_LE; }}
  if (c=='>') {if(thechar=='=') {next(); return T_GE; }}
  if (c=='<') {if(thechar=='<') {next(); return T_LESSLESS;  }}
  if (c=='>') {if(thechar=='>') {next(); return T_GREATGREAT;}}
  if (c=='+') {if(thechar=='+') {next(); return T_PLUSPLUS;  }}
  if (c=='-') {if(thechar=='-') {next(); return T_MINUSMINUS;}}
  if (c=='+') {if(thechar=='=') {next(); return T_PLUSASS;   }}
  if (c=='-') {if(thechar=='=') {next(); return T_MINUSASS;  }}
  if (c=='&') {if(thechar=='=') {next(); return T_ANDASS;    }}
  if (c=='|') {if(thechar=='=') {next(); return T_ORASS;     }}
  if (c=='*') {if(thechar=='=') {next(); return T_MULASS;    }}
  if (c=='/') {if(thechar=='=') {next(); return T_DIVASS;    }}
  if (instr1("()[]{},;*:%-><=+!&|#?", c)) return c ;
  if (c == '/') {
      if (thechar == '/') {
          do c=next();
          while(ifEOL(c)==0) return getlex();
      }
  }
  if (c == '/') {
      if (thechar == '*') {
          g2: c=next();
          if (c != '*') goto g2;
          if (thechar != '/') goto g2;
          c=next();
          return getlex();
      } else  return '/';
  }
  if (c == '"') {
      p=&Symbol;
      c=next();
      while (c != '"') {
          *p=c;
          p++;
          c=next();
          }
          *p=0;
      return T_STRING;
  }
  if (digit(c)) {
      lexval=0;
      lexval=c-'0'; // lexval=int hi=0, c=char
      if (thechar=='x') thechar='X';
      if (thechar=='X') {
          next();
          while(alnum(thechar)) {
              c=next();
              if(c>96) c=c-39;
      	       if (c>64) c=c-7;
               c=c-48;
               lexval=lexval << 4; // * 16
               i=0;
               i=c;
               lexval=lexval+i;
           }
       }else {
           while(digit(thechar)) {
               c=next();
               c=c-48;
               lexval=lexval*10;
               i=0;
               i=c;
               lexval=lexval+i;
           }
       }
      return T_CONST;
  }
  if (c==39) {
      lexval=next();
      if (lexval==92) {
          lexval=next();
          if (lexval=='n') lexval=10;
          if (lexval=='t') lexval= 9;
          if (lexval=='0') lexval= 0;
      }
      next();
      return T_CONST;
  }
  if (alnum(c)) {
    strcpy(symboltemp, Symbol);
    p=&Symbol;
    *p=c;
    p++;
    while(alnum(thechar)) {
        c=next();
        *p=c;
        p++;
    }
    *p=0;
    if (eqstr(Symbol,"signed"  )) return T_SIGNED;
    if (eqstr(Symbol,"unsigned")) return T_UNSIGNED;
    if (eqstr(Symbol,"void"    )) return T_VOID;
    if (eqstr(Symbol,"int"     )) return T_INT;
    if (eqstr(Symbol,"long"    )) return T_LONG;
    if (eqstr(Symbol,"inth"    )) return T_INTH;
    if (eqstr(Symbol,"char"    )) return T_CHAR;
    if (eqstr(Symbol,"asm"     )) return T_ASM;
    if (eqstr(Symbol,"__asm"   )) return T_ASMBLOCK;
    if (eqstr(Symbol,"__emit__")) return T_EMIT;
    if (eqstr(Symbol,"return"  )) return T_RETURN;
    if (eqstr(Symbol,"if"      )) return T_IF;
    if (eqstr(Symbol,"else"    )) return T_ELSE;
    if (eqstr(Symbol,"while"   )) return T_WHILE;
    if (eqstr(Symbol,"do"      )) return T_DO;
    if (eqstr(Symbol,"goto"    )) return T_GOTO;
    if (eqstr(Symbol,"define"  )) return T_DEFINE;

    i=0;//convert define to value
    while (i < GTop) {
        j=getVarName(i);
        if (eqstr(Symbol,j)) {
            if (GType[i]=='#') {
                lexval=GData[i];
                strcpy(Symbol, symboltemp);
                return T_CONST;
            }
        }
        i++;
    }
    return T_NAME; } 
    error1("Input item not recognized");
}

int istoken(int t) {
    if (token == t) {
        token=getlex();
        return 1;
    }
    return 0;
}

int expect(int t) {
    if (istoken(t)==0) {
        *cloc=0;
        printstring(co);
        printstring("\nExpected ASCII(dez): ");
        printinteger(t);
        error1(" not found");
    }
}

int v(unsigned int i) {//value
    if (i < GTop) prc('[');
    printName(i);
    if (i < GTop) prc(']');
}
int checknamelen() {
    int i;
    i=strlen(Symbol);
    if (i > IDLENMAX) error1("Item name is too long)");
}

int checkName() {
    unsigned int i; unsigned int j;
    i=GTop;
    while(i<LTop) {//todo look for local var first
        j=getVarName(i);
        if(eqstr(Symbol,j))return i;
        i++;
    }
    i=1;
    while(i<GTop) {
        j=getVarName(i);
        if(eqstr(Symbol,j))return i;
        i++;
    }
    return 0;
}

int searchname() {
    unsigned int i;
    i=checkName();
    if (i == 0) error1("Variable unknown");
    return i;
}

int name1() {
    if (token!=T_NAME) error1("Name expected");
    token=getlex();
}

int typeName() {
    int m; //0=V,1=*,2=&
    issign='S';
    if(istoken(T_SIGNED))   issign='S';
    if(istoken(T_UNSIGNED)) issign='U';
    iswidth=2;
    if(istoken(T_VOID))     iswidth=0;
    if(istoken(T_CHAR))     iswidth=1;
    if(istoken(T_INT))      iswidth=2;
    if(istoken(T_LONG))     iswidth=4;
    istype='V';
    m=0;
    if(istoken('*'))  {istype='*'; m=1;}
    if(istoken('&'))  {istype='&'; m=2;}
    name1();
    return m;
}

int gettypes(int i) {
    char c;
    c=GSign [i];
    if (c=='S') signi =1;  else signi =0;
    c=GWidth[i];
    widthi=0;
    wi=0;
    if (c==1) {widthi=1;wi=1;}
    if (c==2) {widthi=2;wi=2;}
    if (c==4) {widthi=4;wi=4;}
    c=GType [i];
    typei=0;
    if (c=='*') {typei=1;wi=2;}
    if (c=='&')  typei=2;
    return i;
}

int addlocal() {
    if(LTop >= VARMAX) error1("Local variable table full");
    if (checkName() != 0) error1("Variable already defined");
    GSign[LTop]=issign;
    GWidth[LTop]=iswidth;
    GType[LTop]=istype;
    pt=getVarName(LTop);
    strcpy(pt, Symbol);
    storeVarName();
}


int cmpneg(int ids) {
       if(iscmp==T_EQ) printstring("\n jne .");         //ZF=0
  else if(iscmp==T_NE) printstring("\n je  .");         //ZF=1
  else if(iscmp==T_LE) if (ids) printstring("\n jg  .");//ZF=0 SF=O
                       else     printstring("\n ja  .");//ZF=0 CF=0
  else if(iscmp==T_GE) if (ids){printstring(" ;unsigned : ");
                                printunsigned(ids);
                                printstring("\n jl  .");}//SF!=O
                       else    {printstring(" ;unsigned : ");
                                printunsigned(ids);
                                printstring("\n jb  .");}//jb=jc=CF=1
  else if(iscmp=='<' ) printstring("\n jge .");          //SF=O
  else if(iscmp=='>' ) printstring("\n jle .");          //ZF=1 | SF!=O
  else error1("internal error compare unknown in CMPNEG()");
}

int isrelational() {
    if (token==T_EQ) goto w;
    if (token==T_NE) goto w;
    if (token==T_LE) goto w;
    if (token==T_GE) goto w;
    if (token=='<' ) goto w;
    if (token=='>' ) goto w;
    return 0;
w:  iscmp=token;
    token=getlex();
    return 1;
}

int checkreg() { // >=17 = 16bit, >=47 = 32bit
  if (strlen(Symbol) <  2) return 0;
  if (eqstr(Symbol,"al")) return 1;   if (eqstr(Symbol,"cl")) return 3;
  if (eqstr(Symbol,"dl")) return 5;   if (eqstr(Symbol,"bl")) return 7;
  if (eqstr(Symbol,"ah")) return 9;   if (eqstr(Symbol,"ch")) return 11;
  if (eqstr(Symbol,"dh")) return 13;  if (eqstr(Symbol,"bh")) return 15;
  if (eqstr(Symbol,"ax")) return 17;  if (eqstr(Symbol,"cx")) return 19;
  if (eqstr(Symbol,"dx")) return 21;  if (eqstr(Symbol,"bx")) return 23;
  if (eqstr(Symbol,"sp")) return 25;  if (eqstr(Symbol,"bp")) return 27;
  if (eqstr(Symbol,"si")) return 29;  if (eqstr(Symbol,"di")) return 31;
  if (eqstr(Symbol,"es")) return 33;  if (eqstr(Symbol,"cs")) return 35;
  if (eqstr(Symbol,"ss")) return 37;  if (eqstr(Symbol,"ds")) return 39;
  if (eqstr(Symbol,"fs")) return 41;  if (eqstr(Symbol,"gs")) return 43;
  // (eqstr(Symbol,"ip")) return 45;
  if (strlen(Symbol) >   3) return 0;
  if (eqstr(Symbol,"eax")) return 47; if (eqstr(Symbol,"ecx")) return 50;
  if (eqstr(Symbol,"edx")) return 53; if (eqstr(Symbol,"ebx")) return 56;
  if (eqstr(Symbol,"esp")) return 59; if (eqstr(Symbol,"ebp")) return 62;
  if (eqstr(Symbol,"esi")) return 65; if (eqstr(Symbol,"edi")) return 68;
//  if (eqstr(Symbol,"cr0")) return 71;
  return 0;
}

char printregstr[]
="*alcldlblahchdhbhaxcxdxbxspbpsidiescsssdsfsgsipeaxecxedxebxespebpesiedi";

int printreg(int i) {
    unsigned int k; unsigned char c;
    k = &printregstr + i;
    c=*k;
    prc(c);
    i++;
    k = &printregstr + i;
    c=*k;
    prc(c);
    if (i > 47) {
        i++;
        k = &printregstr + i;
        c=*k;
        prc(c);
        }
}

char ops[5];
int doreg1(int iscmp1) {
    int i;
    if (istoken('='))          strcpy(ops, "mov");
    if (istoken(T_PLUSASS))    strcpy(ops, "add");
    if (istoken(T_MINUSASS))   strcpy(ops, "sub");
    if (istoken(T_ANDASS))     strcpy(ops, "and");
    if (istoken(T_ORASS))      strcpy(ops, "or" );
    if (istoken(T_LESSLESS))   strcpy(ops, "shl");
    if (istoken(T_GREATGREAT)) strcpy(ops, "shr");
    if (iscmp1 == 1) {
            token=getlex();
            if (isrelational() ==0) error1("Relational expected");
            strcpy(ops, "cmp");
        }
    printstring("\n ");
    printstring(ops);
    printstring("  ");
    printreg(ireg1);   //todo
    printstring(", ");

    if (istoken(T_CONST)) {
        printunsigned(lexval);
        goto reg1;
        }
    mod2=typeName();
    ireg2=checkreg();
    if (ireg2) {
        printreg(ireg2);
        goto reg1;
        }
    i=searchname();
    if (mod2 == 2) printName(i);
        else v(i);
reg1: if (iscmp1 == 1) {
    cmpneg(0);
    printstring(fname);
    expect(')');
    }
}

int compoundass(char *op, int mode, int id1) {
    if(mode) error1("only scalar variable allowed");
    printstring("\n ");
    printstring(op);
    printstring("  ");
    gettypes(id1);
    if (wi==2) printstring("word");
        else printstring("byte");
    v(id1);
    printstring(", ");
    expect(T_CONST);
    printunsigned(lexval);
}

int dovar1(int mode, int op, int ixarr, int id1) {
    gettypes(id1);
    if (mode==1) {// * = ptr
        printstring("\n mov bx, ");
        v(id1); printstring("\n ");
        printstring(op);
        if(widthi == 1) printstring(" al, [bx]\n mov ah, 0");
        if(widthi == 2) printstring(" ax, [bx]");
        return;
        }
    if (mode==2){// & = adr
        printstring("\n ");
        printstring(op);
        printstring(" ax, ");
        printName(id1);
        return;
        }
    if (ixarr) {//array
        printstring("\n mov bx, ");
        v(ixarr);
        if (wi==2) printstring("\n shl bx, 1");
        printstring("\n ");
        printstring(op);
        if (wi==2) printstring(" ax, ");
            else printstring(" al, ");
        prc('[');
        printName(id1);
        printstring(" + bx]");
        return;
        }
    printstring("\n ");
    printstring(op);
    if(wi==1) printstring(" al, ");
    if(wi==2) printstring(" ax, ");
    if(wi==4) printstring(" eax, ");
    v(id1);
}

int rterm(char *op) {
    int mode; int opint; int ixarr; int id1;
    if (istoken(T_CONST)) {
        printstring("\n ");
        printstring(op);
        if (wi==1) printstring(" al, ");
        if (wi==2) printstring(" ax, ");
        if (wi==4) printstring(" eax, ");
        printunsigned(lexval);
        return;
        }
    mode=typeName();
    id1=searchname();
    ixarr=0;
    if (istoken('[')) {
        ixarr=searchname();
        expect(T_NAME);
        expect(']');
        gettypes(ixarr);
        if (widthi != 2) error1("Array index must be int");
        }
    if (eqstr(Symbol,"ax")) return;
    opint=op;
    dovar1(mode, opint, ixarr, id1);
}

int doassign(int mode, int i, int ixarr, int ixconst) {
    gettypes(i);
    if (mode==1) {// * = ptr
        printstring("\n mov  bx, ");
        v(i);
        if (widthi == 2) printstring("\n mov  [bx], ax");
            else  printstring("\n mov  [bx], al");
        return;
        }
    if (mode==2) {// & = adr
        printstring("\n mov  ");
        printName(i);
        printstring(", ax");
        return;
        }
    if (ixarr) {
        printstring("\n mov bx, ");
        if(ixconst) printunsigned(ixarr);
            else v(ixarr);
        if (wi==2) printstring("\n shl bx, 1");
        printstring("\n mov [");
        printName(i);
        if (wi==2) printstring("+bx], ax");
            else printstring("+bx], al");
        return;
        }
    if (wi==1){
        printstring("\n mov ");
        if(i<GTop) printstring("byte ");
        v(i);
        printstring(", al");
        return;
        }
    if (wi==2){
        printstring("\n mov ");
        if(i<GTop) printstring("word ");
        v(i);
        printstring(", ax");
        return;
        }
    if (wi==4){
        printstring("\n mov ");
        if(i<GTop) printstring("dword ");
        v(i);
        printstring(", eax");
        return;
        }
}

int domul(int ids) {
    if (ids) rterm("imul");
        else {
        if (istoken(T_CONST)) {
            printstring("\n mov bx, ");
            printunsigned(lexval);
            printstring("\n mul bx");
            }
        else error1("with MUL only const number as multipl. allowed");
        }
}

int doidiv(int ids) {
    int mode; int id1;
    if (istoken(T_CONST)) {
        printstring("\n mov bx, ");
        printunsigned(lexval);
        if (ids) printstring("\n cwd\n idiv bx");
            else printstring("\n mov dx, 0\n div bx");
        }
    else {
        mode=typeName();
        id1=searchname();
        if (mode) error1("only const number or int as divisor allowed");
        gettypes(id1);
        if (typei) error1("only int as simple var divisor allowed");
        if (wi!=2) error1("only int, no byte as divisor allowed");
        printstring("\n mov bx, ");
        v(id1);
        if (ids) printstring("\n cwd\n idiv bx");
            else printstring("\n mov dx, 0\n div bx");
    }
}

int domod(int ids) {
    doidiv(ids);
    printstring("\n mov ax, dx");
}


int docalltype[10]; int docallvalue[10];
char procname[17]; // 1=CONST, 2=String, 3=&, 4=Name

int docall() {
    int i; int narg; int t0; int n0;  int sz32;
    narg=0;
    sz32=0;
    checknamelen();
    strcpy(&procname, Symbol);
    expect('(');
	if (istoken(')') ==0 ) {
	    do {
	        narg++;
	        if (narg >9 ) error1("Max. 9 parameters");
	        t0=0;
            if(istoken(T_CONST)) {
                t0=1;
                n0=lexval;
                }
            if(istoken(T_STRING)){
                t0=2;
                n0=nconst;
                eprs("\n");
                eprs(fname);
                eprc(95);
                eprnum(nconst);
                eprs(" db ");
                eprc(34);
                eprs(Symbol);
                eprc(34);
                eprs(",0");
                nconst++;
                }
            if(istoken('&'))     {
                t0=3;
                name1();
                n0=searchname();
                }
            if(istoken(T_NAME))  {



                    t0=4;
                    n0=searchname();
                    p1=&GType;
                    p1=p1+n0;
                    if (*p1=='&') t0=3;

                }
            if (t0==0) error1("parameter not recognized (no * allowed)");
            docalltype [narg] = t0;
            docallvalue[narg] = n0;
        } while (istoken(','));

  	expect(')');
  	i=narg;
    do {
        t0 = docalltype [i];
        n0 = docallvalue[i];
        if(t0==1){
            printstring("\n push ");
            printunsigned(n0);
            }
        if(t0==2){
            printstring("\n push ");
            printstring(fname);
            prc(95);
            printunsigned(n0);
            }
        if(t0==3){
            printstring("\n lea  ax, ");
            v(n0);
            printstring("\n push ax");
            }
        if(t0==4){
            gettypes(n0);
            if(wi==2) {
                printstring("\n push word ");
                v(n0);
                }
            else {
                printstring("\n mov al, byte ");
                v(n0);
                printstring("\n mov ah, 0\n push ax");
                }
            }
        if(t0==5){
            printstring("\n push ");
            printreg(n0);
            if (n0 >= 47) sz32+2;
            }
        i--;
        } while (i > 0);
    }
	printstring("\n call ");
	printstring(&procname);
	if (narg>0) {
	    printstring("\n add  sp, ");
        narg=narg+narg;
        narg=narg+sz32;
        printunsigned(narg);
        }
}


int expr() {
    int mode;   int id1;
    int ixarr;  int ixconst;
    int ids;    int isCONST;
    int i;      unsigned char *p;

    if (istoken(T_CONST)) {// constant ;
        printstring("\n mov ax, ");
        printunsigned(lexval);
        return 4;
        }
    mode=typeName(); /*0=variable, 1=* ptr, 2=& adr*/
    ireg1=checkreg();//todo
    if (ireg1) {
        doreg1(0);
        return;
        }

    if (token=='(')  {
        docall();
        goto e1;
        }

    id1=searchname();
    gettypes(id1);
    ids=signi;
    ixarr=0;
    ixconst=0;
    if (istoken('[')) {
        if (istoken(T_CONST)) {
            ixconst=1;
            ixarr=lexval;
            expect(']');
            }
        else {
            ixarr=searchname();
            expect(T_NAME);
            expect(']');
            gettypes(ixarr);
            if (widthi != 2) error1("Array index must be number or int");
            }
        }
    if (istoken(T_PLUSPLUS  )) {
        if(mode)error1("Only var allowed");
        printstring("\n inc  ");
        if (wi==2) printstring("word"); else printstring("byte");
        v(id1);
        goto e1;
        }
    if (istoken(T_MINUSMINUS)) {
        if(mode)error1("Only var allowed");
        printstring("\n dec  ");
        if (wi==2) printstring("word"); else printstring("byte");
        v(id1);
        goto e1;
        }

    if (istoken(T_PLUSASS )) {compoundass("add", mode, id1); goto e1; }
    if (istoken(T_MINUSASS)) {compoundass("sub", mode, id1); goto e1; }
    if (istoken(T_ANDASS  )) {compoundass("and", mode, id1); goto e1; }
    if (istoken(T_ORASS   )) {compoundass("or" , mode, id1); goto e1; }
    if (istoken(T_MULASS  )) error1("not implemented");
    if (istoken(T_DIVASS  )) error1("not implemented");

    if (istoken('=')) {
        expr();
        doassign(mode, id1, ixarr, ixconst);
        goto e1;
        }
    dovar1(mode, "mov", ixarr, id1);

e1:      if (istoken('+')) rterm("add");
    else if (istoken('-')) rterm("sub");
    else if (istoken('&')) rterm("and");
    else if (istoken('|')) rterm("or" );
    else if (istoken(T_LESSLESS)) rterm("shl");
    else if (istoken(T_GREATGREAT)) rterm("shr");
    else if (istoken('*')) domul (ids);
    else if (istoken('/')) doidiv(ids);
    else if (istoken('%')) domod (ids);
    if (isrelational()) {
        rterm("cmp");
        cmpneg(ids);
        }
    return 0;
}

int pexpr() {//called from if, do, while
    expect('(');
    iscmp=0;
    if (token==T_NAME) {
        ireg1=checkreg();
        if (ireg1) {
            doreg1(1);
            return;
            }
        }

    expr();
    if (iscmp==0) printstring("\n or  al, al\n je .");
    printstring(fname);
    expect(')');
}


int prlabel(int n) {
    printstring("\n.");
    printstring(fname);
    printunsigned(n);
    prc(':');
}
int prjump (int n) {
    printstring("\n jmp .");
    printstring(fname);
    printunsigned(n);
}

int stmt() {
    int c; char cha;
    int jdest; int tst; int jtemp;
    if(istoken('{')) {
        while(istoken('}')==0) stmt();
        }
    else if(istoken(T_IF)) {
        pexpr();
        nlabel++;
        jdest=nlabel;
        printinteger(jdest);
        stmt();
        if (istoken(T_ELSE)) {
            nlabel++;
            tst=nlabel;
            prjump(tst);
            prlabel(jdest);
            stmt();
            prlabel(tst);
        }
        else prlabel(jdest);
    }
    else if(istoken(T_DO)) {
        nlabel++;
        jdest=nlabel;
        prlabel(jdest);
        stmt();
        expect(T_WHILE);
        pexpr();
        nlabel++;
        jtemp=nlabel;
        printinteger(jtemp);
        prjump(jdest);
         prlabel(jtemp);
    }
    else if(istoken(T_WHILE)) {
        nlabel++;
        jdest=nlabel;
        prlabel(jdest);
        pexpr();
        nlabel++;
        tst=nlabel;
        printinteger(tst);
        stmt();
        prjump(jdest);
        prlabel(tst);
    }
    else if(istoken(T_GOTO))  {
        printstring("\n jmp .");
        name1();
        printstring(Symbol);
        expect(';');
    }
    else if(token==T_ASM)     {
      printstring("\n");
      c=next();
      while(c != '\n') {
        prc(c);
        c=next();
        };
        token=getlex();
    }
    else if(istoken(T_ASMBLOCK)) {
        if (token== '{' )  {
            printstring("\n"); cha=next();
            while(cha!= '}') {
                prc(cha);
                cha=next();
            }
            token=getlex();
        } else error1("Curly open expected");
    }
    else if(istoken(T_INTH))  {
        printstring("\n int  ");
        expect(T_CONST);
        printunsigned(lexval);
        expect(';');
    }
    else if(istoken(T_EMIT)) {
      printstring("\n db ");
    L1: token=getlex();
      printunsigned(lexval);
      token=getlex();
      if (token== ',') {
          prc(',');
          goto L1;
      }
      expect(')');
    }
    else if(istoken(';'))      { }
    else if(istoken(T_RETURN)) {
        if (token!=';') expr();
        printstring("\n jmp .retn");
        printstring(fname);
        nreturn++;
        expect(';');
    }
    else if(thechar==':')      {
        printstring("\n."); // Label
        printstring(Symbol); prc(':');
        expect(T_NAME);
        expect(':');
    }
    else  {expr();; expect(';'); }
}

int isvariable() {
    if(token==T_SIGNED)   goto v1;
    if(token==T_UNSIGNED) goto v1;
    if(token==T_CHAR)     goto v1;
    if(token==T_INT)      goto v1;
    if(token==T_LONG)     goto v1;
    return 0;
v1: return 1;
}

//***************************************************************
int listvar(unsigned int i) {
    unsigned int j;
    char c;
    printstring("\n;");
    printunsigned(i);
    prc(32);
    c=GType [i];
    if(c=='V')printstring("var ");
    if(c=='*')printstring("ptr ");
    if(c=='&')printstring("arr ");
    if(c=='#')printstring("def ");
    c=GSign [i];
    if(c=='S')printstring("sign ");
    if(c=='U')printstring("unsg ");
    c=GWidth[i];
    if(c== 0)printstring("NULL " );
    if(c== 1)printstring("byte " );
    if(c== 2)printstring("word " );
    if(c== 4)printstring("long " );
    pt=getVarName(i);
//    j=i*32;
//    pt=&GNameField + j;
    printstring(pt);
    if(GType[i]=='#') {
        prc('=');
        j=GData[i];
        printunsigned(j);
    }
    if(GType[i]=='&') {
        prc('[');
        j=GData[i];
        printunsigned(j);
        prc(']');
    }
    if (i >= GTop) {
        printstring(" = bp");
        j=GData[i];
        if (j > 0) prc('+');
        printinteger(j);
    }
}

int listproc() {
    int i;
    if (LTop > GTop) {
        printstring("\n;Function : ");
        printstring(fname);
        printstring(", Number local Var: ");
        i=LTop - GTop;
        printunsigned(i);
        printstring("\n; # type sign width local variables");
        i=GTop;
        while (i < LTop) {
            listvar(i);
            i++;
        }
    }
}

int searchFunction() {
    int FunctionIndex; char *p;
    p= &FunctionNames;
    FunctionIndex=1;          //0=function name not found
    while (FunctionIndex <= FunctionMaxIx ) {
        if (eqstr(p, Symbol)) return FunctionIndex;
        p = strlen(p) + p;
        p++;
        FunctionIndex++;
    }
    return 0;               //no function found
}

int storeFunction() {
    unsigned int i;
    FunctionMaxIx++;        //leave 0 empty for function not notfound
    if (FunctionMaxIx >= FUNCMAX) error1("Function table full");
    FunctionNamePtr=strcpy(FunctionNamePtr, Symbol);
    FunctionNamePtr++;      //function name is saved
    i = FunctionNamePtr - &FunctionNames;
    i += IDLENMAX;
    if (i >= FUNCTIONNAMESMAX) error1("too many function names");

}

int dofunc() {
    int nloc; unsigned int j;int narg;
    int VarNamePtrLocalStart;
    cloc=&co;
    checknamelen();
    strcpy(fname, Symbol);
    if(searchFunction()) error1("Function already defined");
    storeFunction();

    printstring("\n\n");
    printstring(Symbol);
    printstring(": PROC");
    expect('(');
//    LStart=GTop;
    LTop=GTop;
    VarNamePtrLocalStart=VarNamePtr;

    if (istoken(')')==0) {
        narg=2;
        do {
            typeName();
            addlocal();
            narg+=2;
            GData[LTop]=narg;
            if (iswidth == 4) narg+=2;
            LTop++;
            }
        while (istoken(','));
        expect(')');
        }

    expect('{'); /*body*/
    nloc=0;
    nreturn=0;
    nconst=0;
    while(isvariable()) {
        do {
            typeName();
            checknamelen();
            addlocal();
            nloc-=2;
            if (iswidth == 4) nloc-=2;
            GData[LTop]=nloc;
            if (istoken('[')){
                istype='&';
                GType[LTop]='&';
                expect(T_CONST);
                expect(']');
                nloc=nloc-lexval;
                nloc+=2;
                GData[LTop]=nloc;
            }
            LTop++;
        } while (istoken(','));
        expect(';');
    }
    listproc();
    if (LTop>GTop){
        printstring(";\n ENTER  ");
        nloc=mkneg(nloc);
        printunsigned (nloc);
        printstring(",0");
        }

    while(istoken('}')==0)  stmt();

    if (nreturn) {
            printstring("\n .retn");
            printstring(fname);
            prc(':');
        }
    if (LTop > GTop) printstring("\n LEAVE");
    printstring("\n ret");
    *cloc=0;
    printstring(co);
    maxco1=strlen(co);
    if (maxco1 > maxco) maxco=maxco1;
    printstring("\nENDP");
    VarNamePtr=VarNamePtrLocalStart;//delete local names
}

char doglobName[IDLENMAX];
int doglob() {
    int i; int j; int isstrarr;
    isstrarr=0;
    if (GTop >= VARMAX) error1("Global table full");
    if (iswidth == 0) error1("no VOID as var type");
    checknamelen();
    if (checkName() != 0) error1("Variable already defined");
    if (istoken('[')) {
        istype='&';
        if (istoken(T_CONST)) {
            printstring("\nsection .bss\nabsolute ");
            printunsigned(orgDatai);
            printstring("\n"); printstring(Symbol);
            if (iswidth==1) printstring(" resb ");
            if (iswidth==2) printstring(" resw ");
            if (iswidth==4) printstring(" resd ");
            printunsigned(lexval);
            printstring("\nsection .text");
            orgDatai=orgDatai+lexval;
            if (iswidth==2) orgDatai=orgDatai+lexval;
            if (iswidth==4) {i= lexval * 3; orgDatai=orgDatai + i;}
            GData[GTop]=lexval;
            expect(']');
        }else {
            expect(']');
            if (iswidth != 1) error1("Only ByteArray allowed");
            printstring("\n");
            printstring(Symbol);
            printstring(" db ");
            isstrarr=1;
            strcpy(doglobName, Symbol);//save Symbol name
            expect('=');
            if (istoken(T_STRING)) {
                prc(34);
                prscomment(Symbol);
                prc(34);
                printstring(",0");
                i=strlen(Symbol);
                GData[GTop]=i;
                }
            else if (istoken('{' )) {
                i=0;
                do {
                    if(i) prc(',');
                    expect(T_CONST);
                    printunsigned(lexval);
                    i=1;
                    }
                    while (istoken(','));
                expect('}');
            }
        else error1("String or number array expected");
        };
    }else { //expect('=');
        printstring("\n");
        printstring(Symbol);
        if (istype=='*') printstring(" dw ");
        else {
            if      (iswidth==1) printstring(" db ");
            else if (iswidth==2) printstring(" dw ");
            else                 printstring(" dd ");
        }
    if(istoken('-')) prc('-');
    if (istoken('=')) {
        expect(T_CONST);
        printunsigned(lexval);
        }else printunsigned(0);
    }
    GSign[GTop]=issign;
    GWidth[GTop]=iswidth;
    GType[GTop]=istype;
    pt=getVarName(GTop);
    if (isstrarr) strcpy(pt, doglobName);
        else strcpy(pt, Symbol);
	if (isstrarr) strcpy(Symbol, doglobName);
	storeVarName();
    GTop++;
    expect(';');
}

int dodefine() {
    expect(T_NAME);
    if (token==T_CONST) {
        if (GTop >= VARMAX) error1("global table (define) full");
        checknamelen();
        if (checkName() != 0) error1("#Define var already defined");
        if (eqstr(Symbol, "ORGDATA")) {
            orgDataOriginal=lexval;
            orgDatai=lexval;
            expect(T_CONST);
            return;
        }
        GSign [GTop]='U';
        GWidth[GTop]=1;
        GType [GTop]='#';
        pt=getVarName(GTop);
        strcpy(pt, Symbol);
        storeVarName();
        GData[GTop]=lexval;
        expect(T_CONST);
        GTop++;
    }
}

int parse() {
    token=getlex();
    do {
        if (token <= 0) return 1;
        if (istoken('#')) {
             if (istoken(T_DEFINE))  dodefine();
             else error1("define expected");
        }
    else{
        typeName();
        if (token=='(') dofunc();
        else doglob(); }
    } while(1);
}

char *arglen=0x80; char *argv=0x82;
int getarguments() {
    int arglen1; unsigned int i; char *c;
    isPrint=1;
    arglen1=*arglen;
    if (arglen1 == 0) {
        cputs(Version1);
        cputs(" Usage: A.COM in_file[.C]: ");
        exitR(3);
        }
    i=arglen1+129;
    *i=0;
    arglen1--;
    toupper(argv);
    strcpy(namein, argv);
    if (instr1(namein, '.') == 0) strcat(namein, ".C");
    strcpy(namelst, namein);
    i=strlen(namelst);
    i--;
    c=&namelst+i;
    *c='S';
}
int openfiles() {
    fdin=openR (namein);
    if(DOS_ERR){
        cputs("Source file missing (.C): ");
        cputs(namein);
        exitR(1);
        }
    fdout=creatR(namelst);
    if(DOS_ERR){
        cputs("list file not creatable: ");
        cputs(namelst);
        exitR(2);
        }
    printstring(";");
    printstring(Version1);
    printstring(", Input: "); printstring(namein);
    printstring(", Output: "); printstring(namelst);
}

int epilog() {
    unsigned int i;
    isPrint=1;
    GTop--;
    printstring("\n;Glob. variables:"); printunsigned(GTop);
    printstring(" (");                  printunsigned(VARMAX);
    i = VarNamePtr - &VarNames;
    printstring("):");                  printunsigned(i);
    printstring(" (");					printunsigned(VARNAMESMAX);
    printstring("), Functions:");       printunsigned(FunctionMaxIx);
    printstring(" (");                  printunsigned(FUNCMAX);
    i = FunctionNamePtr - &FunctionNames;
    printstring("):");                  printunsigned(i);
    printstring(" (");					printunsigned(FUNCTIONNAMESMAX);
    printstring(")\n;Lines:");          printunsigned(lineno);
    printstring(", Constant: ");        printunsigned(maxco);
    printstring(" (");                  printunsigned(COMAX);
    i = COMAX;
    i = i - maxco;
    if (i<=1000)printstring("\n ** Warning ** constant area too small");
    printstring("), stacksize: ");
    i=65535;
    i=i-orgDatai;
    printunsigned(i);
    if (i <= 1000) printstring("\n *** Warning *** Stack too small");

}

int main() {
    getarguments();
    openfiles();
    isPrint=0;
    printstring("\norg  256 \njmp main");

	GTop = 1;
    VarNamePtr= &VarNames;
    FunctionNamePtr= &FunctionNames;
    FunctionMaxIx=0;
    orgDatai=orgDataOriginal;
    fgetsp=&fgetsdest;
    *fgetsp=0;
    thechar=fgets1();

    parse();

    epilog();
    end1(0);
}
