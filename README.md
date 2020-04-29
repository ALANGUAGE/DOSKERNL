# DOSKERNL a very simple rewrite of MS-DOS 2.0 with FAT16 XBPB
It consists of the folllowing repositories:
* [PLA](https://github.com/ALANGUAGE/A2017) Programming Language A, a very simple C-Compiler in 17 KByte.
* [AS](https://github.com/ALANGUAGE/ASM86) a very simple subset of a X86 assembler with the syntax of NASM. It is written in PLA and a DOS COM-program with only 12 KBytes.
* CMD a very simple Command.com interpreter.
* DOS debugging routines and test bed.

### KRNL
uses the DOS-API with the old ROM Basic int 18h instead of int 21h with the same function numbers. KRNL uses only BIOS calls for better virtualisation and no direct hardware access. The following functions are or will be implemented:

16/41 ready
* [ ] 00 Program terminate
* [x] 01 read keyboard and echo
* [x] 02 display character
* [x] 06 direct console I/O
* [x] 07 direct console Input noecho
* [x] 09 display string in DS:DX
* [ ] 1A SETDTA set disk transfer address
* [ ] 1F get default drive parameter block (DPB)-> 32
* [x] 25 setIntVec set interrupt vector in AL from DS:DX
* [x] 2A get date
* [x] 2C get time
* [x] 30 get DOS version
* [ ] 31 TSR Terminate stay resident
* [ ] 32 get drive parameter block (DPB)
* [x] 33 control C check (break)
* [x] 35 getIntVec get interrupt vector in AL to ES:BX
* [ ] 39 MKDIR create subdirectory in FAT
* [ ] 3A RMDIR remove subdirectory in FAT
* [ ] 3B CHDIR change current subdirectory
* [ ] 3C create file with handle
* [ ] 3D open file with handle
* [ ] 3E close file handle
* [x] 3F read file or device, **todo** block IO
* [x] 40 read file or device, **todo** block IO
* [ ] 41 UNLINK delete file by directory entry
* [ ] 42 LSEEK move file pointer
* [ ] 43 CHMOD get/set file attributes
* [x] 44 IOCTL IO control data, only al=0,1
* [ ] 47 get current directory
* [ ] 48 allocate memory
* [ ] 49 free allocated memory
* [ ] 4A setblock, modify allocated memory
* [ ] 4B EXEC, load or execute a program
* [x] 4C EXIT terminate process, mapped to int 21h **todo**
* [ ] 4E FFIRST find first matching file
* [ ] 4F FNEXT find next file
* [ ] 52 get DOS List of Lists (MCB,DPB,SFT), undocumented
* [x] 54 get verify state
* [ ] 56 rename file
* [ ] 57 get/set file date and time
