A.COM DOS
if errorlevel 1 goto err
AS DOS
NASM.EXE -oDOSNASM.COM -fbin -O1 -dENDP -dPROC -lDOSNASM.LST DOS.S  
:err