//#001JCL JOB (TSO),
//             'Install LISTPDS',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,PASSWORD=SYS1
//CLEANUP EXEC PGM=IDCAMS
//REPROIN  DD  *
99999999    SEED RECORD FOR THE RPF Profile cluster
//SYSPRINT DD  SYSOUT=*
//SYSIN  DD *
 PARM GRAPHICS(CHAIN(SN))
   DEFINE ALIAS(NAME(RPF) RELATE(UCPUB000))
 /***********************************************************/
 /*                                                         */
 /* Note:  you do not need this define alias if you do not  */
 /*        want to use a private user catalog               */
 /*                                                         */
 /* Note:  you need to update the relate parameter to       */
 /*        point to the catalog that you want to use        */
 /*                                                         */
 /***********************************************************/
   DELETE RPF.PROFILE CLUSTER
   SET LASTCC = 0
   SET MAXCC  = 0
 /***********************************************************/
 /*                                                         */
 /* Note:  You will have to modify the volume names         */
 /*        and the dataset high level qualifiers            */
 /*        to reflect your system environment               */
 /*                                                         */
 /***********************************************************/
  DEFINE CLUSTER ( NAME(RPF.PROFILE) -
                   VOL(PUB000) -
                   FREESPACE(20 10) -
                   RECORDSIZE(1750 1750) -
                   INDEXED -
                   IMBED -
                   UNIQUE  -
                   KEYS(8 0) -
                   CYLINDERS(1 1) -
                 ) -
            DATA ( NAME(RPF.PROFILE.DATA) -
                   SHR(3 3) -
                 ) -
           INDEX ( NAME(RPF.PROFILE.INDEX) -
                   SHR(3 3) -
                 )
  IF LASTCC = 0 THEN -
     REPRO INFILE(REPROIN) -
           OUTDATASET(RPF.PROFILE)
  DELETE RPF.V1R9M0.SRPFJCL SCRATCH PURGE
  DELETE RPF.V1R9M0.SRPFHELP SCRATCH PURGE
  DELETE RPF.V1R9M0.SRPFLOAD SCRATCH PURGE
  SET MAXCC=0
  SET LASTCC=0
//* ---- RECEIVE JCL ----
//RECVJCL EXEC PGM=RECV370
//STEPLIB  DD  DISP=SHR,DSN=SYSC.LINKLIB
//XMITIN   DD  DSN=MVP.WORK(JCL),DISP=SHR
//RECVLOG  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//* Work temp dataset
//SYSUT1   DD  DSN=&&SYSUT1,
//             UNIT=SYSALLDA,
//             SPACE=(CYL,(8,4),RLSE),
//             DISP=(,DELETE)
//* Output dataset
//SYSUT2   DD  DISP=(NEW,CATLG),
//             DSN=RPF.V1R9M0.SRPFJCL,
//             DCB=SYS1.MACLIB,
//             SPACE=(CYL,(1,1,20)),
//             UNIT=SYSDA,
//             VOL=SER=PUB000
//* ---- RECEIVE HELP ----
//RECVHELP EXEC PGM=RECV370
//STEPLIB  DD  DISP=SHR,DSN=SYSC.LINKLIB
//XMITIN   DD  DSN=MVP.WORK(HELP),DISP=SHR
//RECVLOG  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//* Work temp dataset
//SYSUT1   DD  DSN=&&SYSUT1,
//             UNIT=SYSALLDA,
//             SPACE=(CYL,(8,4),RLSE),
//             DISP=(,DELETE)
//* Output dataset
//SYSUT2   DD  DISP=(NEW,CATLG),
//             DSN=RPF.V1R9M0.SRPFHELP,
//             DCB=SYS1.MACLIB,
//             SPACE=(CYL,(1,1,5)),
//             UNIT=SYSDA,
//             VOL=SER=PUB000
//* ---- RECEIVE LOAD ----
//RECVLOAD EXEC PGM=RECV370
//STEPLIB  DD  DISP=SHR,DSN=SYSC.LINKLIB
//XMITIN   DD  DSN=MVP.WORK(LOAD),DISP=SHR
//RECVLOG  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//* Work temp dataset
//SYSUT1   DD  DSN=&&SYSUT1,
//             UNIT=SYSALLDA,
//             SPACE=(CYL,(8,4),RLSE),
//             DISP=(,DELETE)
//* Output dataset
//SYSUT2   DD  DISP=(NEW,CATLG),
//             DSN=RPF.V1R9M0.SRPFLOAD,
//             DCB=(RECFM=U,BLKSIZE=6144),
//             SPACE=(CYL,(2,1,30)),
//             UNIT=SYSDA,
//             VOL=SER=PUB000
//COPYHELP  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//HELPIN   DD  DISP=SHR,DSN=RPF.V1R9M0.SRPFHELP
//HELPOUT  DD  DISP=SHR,DSN=SYS2.HELP
//SYSIN    DD  *
 COPY INDD=((HELPIN,R)),OUTDD=HELPOUT
 S M=RPF,RPFED
/*
//*
//* DESC: COPY THE RPF LOAD LIBARY TO A LIBRARY IN THE
//*       LINKLIST (SYS1.PARMLIB(LNKLSTXX))
//*
//ALLOC   EXEC PGM=IEBCOPY
//LOAD     DD  DISP=SHR,DSN=RPF.V1R9M0.SRPFLOAD
//CMDLIB   DD  DISP=SHR,DSN=SYS2.CMDLIB
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 COPY INDD=CMDLIB,OUTDD=CMDLIB
 COPY INDD=((LOAD,R)),OUTDD=CMDLIB
 COPY INDD=CMDLIB,OUTDD=CMDLIB
/*
//EDITSTEP EXEC PGM=IKJEFT01,REGION=1024K,DYNAMNBR=50
//SYSPRINT DD  SYSOUT=*
//SYSTSPRT DD  SYSOUT=*
//SYSTERM  DD  SYSOUT=*
//SYSTSIN  DD  *
 EDIT 'SYS1.PROCLIB(IKJACCNT)' CNTL OLD
 LIST
 TOP
 FIND /SYSPROC/
 INSERT //RPFPROF  DD  DISP=SHR,DSN=RPF.PROFILE
 LIST
 SAVE
 END
/*