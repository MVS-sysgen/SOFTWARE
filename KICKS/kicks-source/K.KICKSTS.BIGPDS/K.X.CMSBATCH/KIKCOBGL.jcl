//KIKCOBGL  JOB  CLASS=C,MSGCLASS=Z
// EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN DD DUMMY,DCB=BLKSIZE=80
//SYSUT2 DD UNIT=10D,DISP=OLD,DCB=BLKSIZE=80
//SYSUT1 DD DATA,DLM=$$,DCB=BLKSIZE=3120
ID CMSBATCH
/JOB CMSUSER 123456 KIKCOBGL
$$
// DD DSN=K.X.CMSBATCH(MAPN),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCGET),DISP=SHR
// DD DSN=K.X.CMSBATCH(KASM),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCE),DISP=SHR
// DD DATA,DLM=$$
MAPN
KBLOCK KIKCOBGL
KGCCGET
VMARC UNPACK ASYSH VMARC N = = A
KASM kikbllin
*  //////1/////////2/////////3/////////4/////////5/////////6/////////7
* A CALL TO THIS ROUTINE SHOULD BE THE FIRST STATEMENT OF AN MVT
* ANSI COBOL PROGRAM THAT USES THE 'BLL-CELLS' APPROACH TO ACCESSING
* EXTERNAL DATA. THIS ROUTINE INITIALIZES THE BLL FOR THE BLL-CELLS
* RECORD (BY WHATEVER NAME) TO POINT TO ITSELF.
*
* IE - CALL 'KIKBLLIN' USING BLL-CELLS.
*  //////1/////////2/////////3/////////4/////////5/////////6/////////7
KIKBLLIN START 0
         USING *,15
         STM   14,12,12(13)
         LR    3,14             GET CALLING CODE ADDR
         S     3,=F'26'         BKUP TO BLL LOAD
         CLC   0(2,3),=XL2'58E0'  IS THIS A 'L 14,??'
         BE    BLL2                 YES
*
         LA    1,1              PROBABLY SHOULD USE KICKS ABEND
         LA    15,0             BUT IT'S GONNA DIE ANYWAY...
         ABEND (1),DUMP
*
BLL2     MVC   BLL3+2(2),2(3)   MOVE BLL ADDR TO MY LA
         EX    0,BLL3           EX TO DO LA OF BLL
         ST    2,0(,2)          SAVE ITS OWN ADDR IN BLL
         LM    14,12,12(13)
         BR    14
BLL3     LA    2,0
         LTORG
         END
/*
*
* copy custom PDPPRLG macro to disk
*
FILEDEF  INMOVE  TERM ( RECFM F BLOCK 80 LRECL 80
FILEDEF  OUTMOVE DISK PDPPRLG MACRO A ( RECFM F BLOCK 80 LRECL 80
MOVEFILE
$$
// DD DSN=K.X.ROOT.ASM(KIKGLUMA),DISP=SHR
// DD DATA,DLM=$$
/*
MACLIB DEL PDPCLIB PDPPRLG
MACLIB DEL PDPCLIB PDPPRLG
MACLIB ADD PDPCLIB PDPPRLG
*
* compile edf version
*
KGCCE kikcobgl
#define DOEDF
$$
// DD DSN=K.X.ROOT.C(KIKCOBGL),DISP=SHR
// DD DATA,DLM=$$
/*
*
* compile non-edf version
*
KGCCE kikcobgx
#undef DOEDF
$$
// DD DSN=K.X.ROOT.C(KIKCOBGL),DISP=SHR
// DD DATA,DLM=$$
/*
/*
$$
//