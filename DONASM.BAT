A.COM DOS
if errorlevel 1 goto err
AS DOS
NASM -oDOSNASM.COM -fbin -O1 -dENDP -dPROC -lDOSNASM.LST DOS.S  
:err