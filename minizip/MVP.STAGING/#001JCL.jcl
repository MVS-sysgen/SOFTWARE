//INSTALL JOB (FTPD),
//            'MINIZIP INSTALL',
//            CLASS=A,
//            MSGCLASS=A,
//            REGION=8M,
//            MSGLEVEL=(1,1)
//*
//* Installs FTPD/FTPDXCTL to SYS2.LINKLIB
//* Adds FTPDPM00 to SYS1.PARMLIB
//* Adds FTPD procedure to SYS2.PROCLIB
//* Adds the FTP user and updates RAKF profiles
//*
//ZIPDELTE EXEC PGM=IDCAMS,REGION=1024K
//SYSPRINT DD  SYSOUT=A
//SYSIN    DD  *
 DELETE SYS2.PROCLIB(ZIP)
 DELETE SYS2.PROCLIB(UNZIP)
 DELETE SYS2.LINKLIB(MINIZIP)
 DELETE SYS2.LINKLIB(MINIUNZ)
 /* IF THERE WAS NO DATASET TO DELETE, RESET CC           */
 IF LASTCC = 8 THEN
   DO
       SET LASTCC = 0
       SET MAXCC = 0
   END
/*
//* RECV370 DDNAMEs:
//* ----------------
//*
//*     RECVLOG    RECV370 output messages (required)
//*
//*     RECVDBUG   Optional, specifies debugging options.
//*
//*     XMITIN     input XMIT file to be received (required)
//*
//*     SYSPRINT   IEBCOPY output messages (required for DSORG=PO
//*                input datasets on SYSUT1)
//*
//*     SYSUT1     Work dataset for IEBCOPY (not needed for sequential
//*                XMITs; required for partitioned XMITs)
//*
//*     SYSUT2     Output dataset - sequential or partitioned
//*
//*     SYSIN      IEBCOPY input dataset (required for DSORG=PO XMITs)
//*                A DUMMY dataset.
//*
//RECV370 EXEC PGM=RECV370
//STEPLIB  DD  DISP=SHR,DSN=SYSC.LINKLIB
//XMITIN   DD  DSN=MVP.WORK(MINIZIP),DISP=SHR
//RECVLOG  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//* Work temp dataset
//SYSUT1   DD  DSN=&&SYSUT1,
//             UNIT=VIO,
//             SPACE=(CYL,(5,1)),
//             DISP=(NEW,DELETE,DELETE)
//* Output dataset
//SYSUT2   DD  DSN=SYS2.LINKLIB,DISP=SHR
//*
//* Add ZIP to SYS2.PROCLIB
//*
//FTPDPROC EXEC PGM=IEBGENER
//SYSUT1   DD DATA,DLM=@@
//ZIP    PROC OUTZIP=,INFILE=,P=
//*
//* JCL procedure for MINIZIP
//*
//* to use it pass the provided the location of the zip file
//* to be creted to OUTZIP
//* INFILE is the DSN to be compressed
//* P is for flags or other parms
//*
//* e.g. //ZIP EXEC ZIP,P='-o',OUTZIP='IBMUSER.ZIP',INFILE='TEST.TEST'
//*
//ZIP      EXEC PGM=MINIZIP,REGION=0M,
//  PARM='&P DD:ZIPFILE &INFILE'
//ZIPFILE DD DISP=(NEW,CATLG,DELETE),
//        DSN=&OUTZIP,UNIT=SYSDA,
//        VOL=SER=PUB001,SPACE=(TRK,(15,15),RLSE),
//        DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=27920)
//STDOUT   DD   SYSOUT=*
//SYSPRINT DD   SYSOUT=*
//SYSTERM  DD   SYSOUT=*
//SYSIN    DD   DUMMY
//SYSUT1   DD   UNIT=SYSDA,SPACE=(CYL,300),
//  DCB=(DSORG=PS,RECFM=FB,LRECL=128,BLKSIZE=6144)
@@
//SYSUT2   DD DISP=SHR,DSN=SYS2.PROCLIB(ZIP)
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//*
//* Add UNZIP to SYS2.PROCLIB
//*
//FTPDPROC EXEC PGM=IEBGENER
//SYSUT1   DD DATA,DLM=@@
//UNZIP    PROC OUTDSN=,INZIP=,P=
//*
//* JCL procedure for miniunz
//*
//* to use it pass the input zip file (must be a seq dataset)
//* and the output PDS
//*
//UNZIP    EXEC PGM=MINIUNZ,REGION=0M,
//  PARM='&P &INZIP DD:OUTDSN'
//OUTDSN    DD  DSN=&OUTDSN,DISP=(,CATLG),
//             UNIT=SYSDA,VOL=SER=PUB001,
//             SPACE=(CYL,(10,5,50)),
//             DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=27920)
//STDOUT   DD   SYSOUT=*
//SYSPRINT DD   SYSOUT=*
//SYSTERM  DD   SYSOUT=*
//SYSIN    DD   DUMMY
//SYSUT1   DD   UNIT=SYSDA,SPACE=(CYL,300),
//  DCB=(DSORG=PS,RECFM=FB,LRECL=128,BLKSIZE=6144)
@@
//SYSUT2   DD DISP=SHR,DSN=SYS2.PROCLIB(ZIP)
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
