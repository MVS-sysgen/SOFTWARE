//KUNLKED JOB CLASS=C,MSGCLASS=Z
// EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN DD DUMMY,DCB=BLKSIZE=80
//SYSUT2 DD UNIT=10D,DISP=OLD,DCB=BLKSIZE=80
//SYSUT1 DD DATA,DLM=$$,DCB=BLKSIZE=3120
ID CMSBATCH
/JOB CMSUSER 123456 KUNLKED
$$
// DD DSN=K.X.CMSBATCH(MAPN),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCEG),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCGET),DISP=SHR
// DD DATA,DLM=$$
MAPN
KBLOCK KUNLKED
VMARC UNPACK ASYSH VMARC N = = A
KGCCEG KUNLKED
$$
// DD DSN=K.X.UTIL(KUNLKED),DISP=SHR
// DD DATA,DLM=$$
/*
$$
//