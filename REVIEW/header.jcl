//HEADER JOB (TSO),
//             'Install Review',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,PASSWORD=SYS1
//* Upload files
//* This file is used by make_release.py to create the package
//* for MVP
//* CLEAN UP
//CLEANUP EXEC PGM=IDCAMS
//SYSIN    DD *
  DELETE MVP.STAGING SCRATCH PURGE
  DELETE MVP.XMIT SCRATCH PURGE
  SET MAXCC=0
  SET LASTCC=0
//SYSPRINT DD SYSOUT=*
//SOURCE   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=MVP.STAGING,DISP=(,CATLG,DELETE),
//             UNIT=SYSDA,VOL=SER=PUB001,SPACE=(TRK,(50,50,10)),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=800)

//SYSUT1   DD  DATA,DLM='??'
./ ADD NAME=#001JCL
//#001JCL JOB (TSO),
//             'Install Review',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1)
//* ----- CLEAN UP -----
//CLEANUP EXEC PGM=IDCAMS
//SYSIN    DD *
  DELETE SYSGEN.REVIEW.LOAD SCRATCH PURGE
  DELETE SYSGEN.REVIEW.HELP SCRATCH PURGE
  DELETE SYSGEN.REVIEW.CLIST SCRATCH PURGE
  SET MAXCC=0
  SET LASTCC=0
//SYSPRINT DD SYSOUT=*
//* Receive XMIT files
//* -------------------
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
//XMITIN   DD  DSN=MVP.WORK(CLIST),DISP=SHR
//RECVLOG  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//* Work temp dataset
//SYSUT1   DD  DSN=&&SYSUT1,
//             UNIT=VIO,
//             SPACE=(CYL,(5,1)),
//             DISP=(NEW,DELETE,DELETE)
//* Output dataset
//SYSUT2   DD  DSN=SYSGEN.REVIEW.CLIST,
//             UNIT=SYSALLDA,VOL=SER=PUB001,
//             SPACE=(CYL,(15,2,20),RLSE),
//             DISP=(NEW,CATLG,DELETE)
//* ----- HELP -----
//RECV370 EXEC PGM=RECV370
//STEPLIB  DD  DISP=SHR,DSN=SYSC.LINKLIB
//XMITIN   DD  DSN=MVP.WORK(HELP),DISP=SHR
//RECVLOG  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//* Work temp dataset
//SYSUT1   DD  DSN=&&SYSUT1,
//             UNIT=VIO,
//             SPACE=(CYL,(5,1)),
//             DISP=(NEW,DELETE,DELETE)
//* Output dataset
//SYSUT2   DD  DSN=SYSGEN.REVIEW.HELP,
//             UNIT=SYSALLDA,VOL=SER=PUB001,
//             SPACE=(CYL,(15,2,20),RLSE),
//             DISP=(NEW,CATLG,DELETE)
//* ----- LOAD -----
//RECV370 EXEC PGM=RECV370
//STEPLIB  DD  DISP=SHR,DSN=SYSC.LINKLIB
//XMITIN   DD  DSN=MVP.WORK(LOAD),DISP=SHR
//RECVLOG  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//* Work temp dataset
//SYSUT1   DD  DSN=&&SYSUT1,
//             UNIT=VIO,
//             SPACE=(CYL,(5,1)),
//             DISP=(NEW,DELETE,DELETE)
//* Output dataset
//SYSUT2   DD  DSN=SYSGEN.REVIEW.LOAD,
//             UNIT=SYSALLDA,VOL=SER=PUB001,
//             SPACE=(CYL,(15,2,20),RLSE),
//             DISP=(NEW,CATLG,DELETE)
//*
//*  THIS STEP COPIES THE REVIEW/RFE CLIST MEMBERS INTO SYS1.CMDPROC
//*
//STEP1CLS EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  DSN=SYSGEN.REVIEW.CLIST,DISP=SHR
//SYSUT2   DD  DSN=SYS1.CMDPROC,DISP=SHR
//SYSIN    DD  *
  COPY INDD=((SYSUT1,R)),OUTDD=SYSUT2
  COPY INDD=((SYSUT2,R)),OUTDD=SYSUT2
//*
//*  THIS STEP COPIES THE REVIEW/RFE TSO HELP MEMBERS INTO SYS2.HELP
//*
//STEP2HLP EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  DSN=SYSGEN.REVIEW.HELP,DISP=SHR
//SYSUT2   DD  DSN=SYS2.HELP,DISP=SHR
//SYSIN    DD  *
  COPY INDD=((SYSUT1,R)),OUTDD=SYSUT2
  COPY INDD=((SYSUT2,R)),OUTDD=SYSUT2
//*
//*  THIS JOB COPIES THE REVIEW/RFE TSO PROGRAMS INTO SYS2.CMDLIB
//*
//STEP3LD  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  DSN=SYSGEN.REVIEW.LOAD,DISP=SHR
//SYSUT2   DD  DSN=SYS2.CMDLIB,DISP=SHR
//SYSIN    DD  *
  COPY INDD=((SYSUT1,R)),OUTDD=SYSUT2
  COPY INDD=((SYSUT2,R)),OUTDD=SYSUT2
/*
??