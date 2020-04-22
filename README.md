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
* [ ] 1A SETDTA
* [ ] 1F get default Disk Parameter Block (DPB)-> 32
* [x] 25 setIntVec in AL from DS:DX
* [x] 2A GetDate
* [x] 2C GetTime
* [x] 30 getDosVer
* [ ] 31 TSR
* [ ] 32 get disk parameter block (DPB)
* [x] 33 Control C Check (break)
* [x] 35 getIntVec in AL to ES:BX
* [ ] 39 MKDIR create directory in FAT
* [ ] 3A RMDIR remove directory in FAT
* [ ] 3B CHDIR change current directory
* [ ] 3C create handle
* [ ] 3D open handle
* [ ] 3E close handle
* [x] 3F read file or device, **todo** block IO
* [x] 40 read file or device, **todo** block IO
* [ ] 41 UNLINK delete directory entry
* [ ] 42 LSEEK move file pointer
* [ ] 43 CHMOD get/set file attributes
* [x] 44 IOCTL Data, only al=0,1
* [ ] 47 get current directory
* [ ] 48 Allocate Memory
* [ ] 49 Free Allocates Memory
* [ ] 4A Setblock, modify memory
* [ ] 4B EXEC, Load or Execute a Program
* [x] 4C EXIT Terminate, mapped to int 21h **todo**
* [ ] 4E FFIRST find first matching file
* [ ] 4F FNEXT find next file
* [ ] 52 get DOS List of Lists (MCB,DPB,SFT)
* [x] 54 GetVerifyState
* [ ] 56 rename file
* [ ] 57 get/set file date and time

