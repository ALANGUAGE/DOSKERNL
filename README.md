# DOSKERNL a very simple rewrite of MS-DOS 2.0 with FAT16
It consists of the folllowing repositories:
* [PLA](https://github.com/ALANGUAGE/A2017) Programming Language A, a very simple C-Compiler in 17 KByte.
* [AS](https://github.com/ALANGUAGE/ASM86) a very simple subset of a X86 assembler with the syntax of NASM. It is written in PLA and a DOS COM-program with only 12 KBytes.
* CMD a very simple Command.com interpreter.
* DOS is the new kernel and command interpreter.

### KRNL
uses the DOS-API with the old ROM Basic int 18h instead of int 21h with the same function numbers. KRNL uses only BIOS calls for better virtualisation and no direct hardware access.

### DOS
calls OS subroutines. The following functions are or will be implemented:
16/29 ready
* [ ] 00 Program terminate
* [x] 01 read keyboard and echo
* [x] 02 display character
* [x] 06 direct console I/O
* [x] 07 direct console Input noecho
* [x] 09 display string in DS:DX
* [x] 25 setIntVec set interrupt vector in AL from DS:DX
* [x] 2A get date
* [x] 2C get time
* [x] 30 get DOS version
* [x] 33 control C check (break)
* [x] 35 getIntVec get interrupt vector in AL to ES:BX
* [ ] 39 create directory
* [ ] 3A remove directory
* [ ] 3B change current directory
* [ ] 3C create handle
* [x] 3D open file with handle
* [ ] 3E close file handle
* [x] 3F read file or device
* [x] 40 write file or device, **todo** block IO
* [ ] 41 delete file
* [ ] 42 move file pointer
* [x] 44 IOCTL IO control data, only al=0,1
* [ ] 47 get current directory
* [ ] 4B EXEC, load or execute a program
* [ ] 4C EXIT terminate process
* [ ] 4E FFIRST find first matching file
* [ ] 4F FNEXT find next file
* [x] 54 get verify state
