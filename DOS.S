;PLA compiler A.COM V1.1.2, Input: DOS.C, Output: DOS.S
org  256 
jmp main
;-1 char Version1[]="DOS.COM V0.1.7";//test bed

Version1 db "DOS.COM V0.1.7",0
;-2 //todo: resize and take own stack

;-3 //Finder /hg/VirtualBox VMs/DOS1/DOS1.vhd (.vmdk) 

;-4 // Rechtsclick / Öffnen / Parallels Mounter

;-5 //Ranish Part, int8h: CHS 1014/15/63, Start=63,Len=1.023.057

;-6 //Boot Sec=63, head=16, hidden=63, Sec=983.121

;-7 #define ORGDATA		8192//start of arrays

;-8 unsigned int vAX ;unsigned int vBX ;unsigned int vCX; unsigned int vDX;

vAX dw 0
vBX dw 0
vCX dw 0
vDX dw 0
;-9 unsigned int vSP; unsigned int vBP; unsigned int vCS; unsigned int vDS;

vSP dw 0
vBP dw 0
vCS dw 0
vDS dw 0
;-10 unsigned int vSS; unsigned int vES; //debugging

vSS dw 0
vES dw 0
;-11 

;-12 unsigned char DOS_ERR;

DOS_ERR db 0
;-13 unsigned char BIOS_ERR;

BIOS_ERR db 0
;-14 unsigned int  BIOS_Status;

BIOS_Status dw 0
;-15 

;-16 unsigned char DiskBuf [512];

section .bss
absolute 8192
DiskBuf resb 512
section .text
;-17 unsigned int  DiskBufSeg;

DiskBufSeg dw 0
;-18 unsigned char Drive=0x80;

Drive db 128
;-19 unsigned long Sectors_to_read;//for readLogical

Sectors_to_read dd 0
;-20 

;-21 //Params from int13h, Function 8

;-22 unsigned int  pa_Cylinders;

pa_Cylinders dw 0
;-23 unsigned char pa_Sectors;

pa_Sectors db 0
;-24 unsigned char pa_Heads;

pa_Heads db 0
;-25 unsigned char pa_Attached;

pa_Attached db 0
;-26 

;-27 //calcFATtype     

;-28 unsigned int FatStartSector;

FatStartSector dw 0
;-29 unsigned int FatSectors;

FatSectors dw 0
;-30 unsigned int RootDirStartSector;

RootDirStartSector dw 0
;-31 unsigned int RootDirSectors;

RootDirSectors dw 0
;-32 unsigned int DataStartSector;

DataStartSector dw 0
;-33 unsigned long DataSectors32;

DataSectors32 dd 0
;-34 unsigned long CountofClusters;

CountofClusters dd 0
;-35 char          trueFATtype;

trueFATtype db 0
;-36 unsigned long Sectors_per_cylinder;

Sectors_per_cylinder dd 0
;-37 

;-38 //start hard disk partition structure 16 bytes in MBR. do not change unsigned

;-39 char pt_Bootable;		//80h = active partition, else 00 unsigned char

pt_Bootable db 0
;-40 pt_StartHead;

pt_StartHead dw 0
;-41 unsigned char pt_StartSector;	//bits 0-5

pt_StartSector db 0
;-42 unsigned int  pt_StartCylinder;	//bits 8,9 in bits 6,7 of sector unsigned char

pt_StartCylinder dw 0
;-43 pt_FileSystem;	//0=nu,1=FAT12,4=FAT16,5=ExtPart,6=largeFAT16 unsigned char

pt_FileSystem dw 0
;-44 pt_EndHead;

pt_EndHead dw 0
;-45 unsigned char pt_EndSector;		//bits 0-5

pt_EndSector db 0
;-46 unsigned int  pt_EndCylinder;	//bits 8,9 in bits 6,7 of sector unsigned long

pt_EndCylinder dw 0
;-47 pt_HiddenSector;	//sectors preceding partition

pt_HiddenSector dw 0
;-48 unsigned long pt_PartLen;    	//length of partition in sectors 

pt_PartLen dd 0
;-49 //end hard disk partition structure

;-50 

;-51 //start boot BIOS Parameter Block structure. do not change

;-52 unsigned char bs_jmp[]="12";// 00 +LenByte:Must be 0xEB, 0x3C, 0x90 unsigned

bs_jmp db "12",0
;-53 char bs_sys_id[]="1234567";// 03 OEM name,version "MSDOS5.0" unsigned int 

bs_sys_id db "1234567",0
;-54 bs_sect_size;	// 11 bytes per sector (512)

bs_sect_size dw 0
;-55 unsigned char bs_clust_size;// 13 sectors per cluster (1,2,4,..,128) unsigned

bs_clust_size db 0
;-56 int  bs_res_sects;	// 14 reserved sectors starting at 0 unsigned char

bs_res_sects dw 0
;-57 bs_num_fats;	// 16 number of FAT (1 or 2)

bs_num_fats dw 0
;-58 unsigned int  bs_root_entr;	// 17 number of root directory entries (512)

bs_root_entr dw 0
;-59 unsigned int  bs_tot_sect16;// 19 number of total sectors (0 if > 32Mb)

bs_tot_sect16 dw 0
;-60 unsigned char bs_media_desc;// 21 media descriptor byte (F8h for HD) unsigned

bs_media_desc db 0
;-61 int  bs_fat_size;	// 22 sectors per fat

bs_fat_size dw 0
;-62 unsigned int  bs_num_sects;	// 24 (DOS 3+)sectors per track 

bs_num_sects dw 0
;-63 unsigned int  bs_num_sides;	// 26 (DOS 3+)number of heads   

bs_num_sides dw 0
;-64 unsigned long bs_hid_sects;	// 28 (DOS 3+)number of hidden sectors unsigned

bs_hid_sects dd 0
;-65 long bs_tot_sect32;	// 32 (DOS 4+) number of sectors if ofs 19 = 0 unsigned

bs_tot_sect32 dd 0
;-66 char bs_drive_num;	// 36 (DOS 4+) physical drive number unsigned char

bs_drive_num db 0
;-67 bs_reserved;  // 37 (DOS 4+) for Windows NT check disk unsigned char

bs_reserved dw 0
;-68 bs_ext_signat;// 38 (DOS 4+) Extended signature,get next 3(29h) unsigned long

bs_ext_signat dw 0
;-69 bs_serial_num;// 39 (DOS 4+) Volume serial number random unsigned char

bs_serial_num dw 0
;-70 bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME" unsigned char

 bs_label[]="1234567890";//43 (DOS 4+) Volume label "NO NAME" unsigned char
;Line: 70 ************** ERROR: Only ByteArray allowed  in column: 12
Token: 61, Symbol: bs_label