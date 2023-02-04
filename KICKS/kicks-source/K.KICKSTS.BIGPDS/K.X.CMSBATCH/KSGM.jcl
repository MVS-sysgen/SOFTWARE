//KSGM      JOB  CLASS=C,MSGCLASS=Z
// EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN DD DUMMY,DCB=BLKSIZE=80
//SYSUT2 DD UNIT=10D,DISP=OLD,DCB=BLKSIZE=80
//SYSUT1 DD DATA,DLM=$$,DCB=BLKSIZE=3120
ID CMSBATCH
/JOB CMSUSER 123456 KSGM
$$
// DD DSN=K.X.CMSBATCH(MAPN),DISP=SHR
// DD DATA,DLM=$$
MAPN
KBLOCK KSGM
GETCOB
KIKMG    ksgmap  mapsrc n kiksrpl kikcosys kikgcsys
KIKMG    ksgmapl mapsrc n kiksrpl kikcosys kikgcsys
K2KCOBCL ksgmpgm cobol  n kiksrpl * kikcobgx
K2KCOBCL ksgmlic cobol  n kiksrpl * kikcobgx
GETGCC
SET LDRTBLS 64
COPY GCC PARM N = = A (REPLACE
COPY PDPCLIB TXTLIB N = = A (REPLACE
KIKGCCCL ksgmhlp c      n kiksrpl * kikgccgx
/*
$$
//
