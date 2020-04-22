# DOSKERNL a very simple rewrite of MS-DOS 2.0 with FAT16 XBPB
It consists of the folllowing repositories:
* [PLA](https://github.com/ALANGUAGE/A2017) Programming Language A, a very simple C-Compiler in 17 KByte.
* [AS](https://github.com/ALANGUAGE/ASM86) a very simple subset of a X86 assembler with the syntax of NASM. It is written in PLA and a DOS COM-program with only 12 KBytes.
* CMD a very simple Command.com interpreter.
* DOS debugging routines and test bed.

### KRNL
uses the DOS-API with the old ROM Basic int 18h instead of int 21h with the same function numbers. KRNL uses only BIOS calls for better virtualisation and no direct hardware access. The following functions are implemented:

* [x] 01 Read Keyboard and Echo
* [x] 02 Display Character
* [x] 06 Direct Console I/O
* [x] 07 Direct Console Input
* [x] 09 display string in DS:DX
* [x] 25 setIntVec in AL from DS:DX
* [x] 2A GetDate
* [x] 2C GetTime
* [x] 30 getDosVer
* [x] 33 Control C Check (break)
* [x] 35 getIntVec in AL to ES:BX
* [x] 3F read file or device, todo block IO
* [x] 40 read file or device, todo block IO
* [x] 44 IOCTL Data, only al=0,1
* [x] 4C Terminate, mapped to int 21h todo
* [x] 54 GetVerifyState

