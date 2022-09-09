GETDTE Utility for MVS 3.8J / Hercules


Date: 7/30/2020  Release V1R0M00

*  Author:  Larry Belmontes Jr.
*           https://ShareABitofIT.net/GETDTE-in-MVS38J
*           Copyright (C) 2013-2020  Larry Belmontes, Jr.


----------------------------------------------------------------------
|    GETDTE       I n s t a l l a t i o n   R e f e r e n c e        |
----------------------------------------------------------------------

   The approach for this installation procedure is to transfer the
distribution tape content from the your personal computing device to
MVS with minimal JCL (less than 24 lines for easy copy-paste) and to
continue the installation procedure using supplied JCL from the MVS
CNTL data set under TSO.

   Below are description of ZIP file content, pre-installation
requirements and installation steps.

Thanks!
-Larry Belmontes



======================================================================
* I. C o n t e n t   o f   Z I P   F i l e                           |
======================================================================

o  $INST00.JCL          Define Alias for HLQ GETDTE in Master Catalog

o  $INST01.JCL          Load CNTL data set from distribution tape

o  GETDTE_V1R0M00.HET   Hercules Emulated Tape (HET) multi-file volume
                        with VOLSER of V1000 contains software
                        distribution.

o  DSCLAIMR.TXT         Disclaimer

o  PREREQS.TXT          Required user-mods

o  README.TXT           This File





======================================================================
* II. P r e - i n s t a l l a t i o n   R e q u i r e m e n t s      |
======================================================================

o  The Master Catalog password will be required for some installation
   steps.

o  Tape files use device 480.

o  DASD files will be loaded to VOLSER=MVSDLB, type 3350 device.
   Confirm that 110 tracks are available.

o  TSO user-id with sufficient access rights to update SYS2.CMDPROC
   libraries.

o  Download ZIP file to your PC local drive.

o  Unzip the downloaded file into a temp directory on your PC device.



======================================================================
* III. I n s t a l l a t i o n   S t e p s                           |
======================================================================

+--------------------------------------------------------------------+
| Step 1. Define Alias for HLQ GETDTE in MVS User Catalog            |
+--------------------------------------------------------------------+
|         JCL Member: GETDTE.V1R0M00.CNTL($INST00)                   |
+--------------------------------------------------------------------+


______________________________________________________________________
//GETDTE00 JOB (SYS),'Define GETDTE Alias',  <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  GETDTE for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST00  Define Alias for HLQ GETDTE           *
//* *  Note: The master catalog password will be required  *
//* -------------------------------------------------------*
//DEFALIAS EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 PARM GRAPHICS(CHAIN(SN))
 LISTCAT ALIAS  ENT(GETDTE)
 IF LASTCC NE 0 THEN -
    DEFINE ALIAS(NAME(GETDTE) RELATE(SYS1.UCAT.MVS))
/*
//
______________________________________________________________________
Figure 1: $INST00 JCL


    a) Copy and paste the above JCL to a PDS member, update JOB
       statement to conform to your installation standard.

    b) Submit the job.

    c) Review job output for successful DEFINE ALIAS.

    Note: Job step DEFALIAS returns RC=0004 due to LISTCAT function
          LISTCAT function completing with condition code of 4 and
          DEFINE ALIAS function completing with condition code of 0.


+--------------------------------------------------------------------+
| Step 2. Load CNTL data set from distribution tape                  |
+--------------------------------------------------------------------+
|         JCL Member: GETDTE.V1R0M00.CNTL($INST01)                   |
+--------------------------------------------------------------------+


______________________________________________________________________
//GETDTE01 JOB (SYS),'Install CNTL PDS',     <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  GETDTE for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST01  Load CNTL PDS from distribution tape  *
//* *  Note: Uses tape drive 480                           *
//* -------------------------------------------------------*
//GETDTE01 PROC VRM=V1R0M00,
//             TVOLSER=VS1000,TUNIT=480,
//             DVOLSER=MVSDLB,DUNIT=3350     <-- Review and Modify
//LOAD001  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  DSN=GETDTE.&VRM..CNTL.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(1,SL)
//SYSUT2   DD  DSN=GETDTE.&VRM..CNTL,
//             UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(20,10,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//SYSIN    DD  DUMMY
//         PEND
//*
//STEP001  EXEC GETDTE01
______________________________________________________________________
Figure 2: $INST01 JCL


    a) Before submitting the above job, the distribution tape
       must be made available to MVS by issuing the following
       command from the Hercules console:

       DEVINIT 480 X:\dirname\GETDTE_V1R0M00.HET READONLY=1

       where X:\dirname is the complete path to the location
       of the Hercules Emulated Tape file.

    b) Issue the following command from the MVS console to vary
       device 480 online:

       V 480,ONLINE

    c) Copy and paste the above JCL to a PDS member, update JOB
       statement to conform to your installation standard.

       Review JCL and apply any modifications per your installation.

    d) Submit the job.

    e) Review job output for successful load of the CNTL data set.

    f) Subsequent installation steps will be submitted from members
       contained in the CNTL data set.


+--------------------------------------------------------------------+
| Step 3. Load Other data sets from distribution tape                |
+--------------------------------------------------------------------+
|         JCL Member: GETDTE.V1R0M00.CNTL($INST02)                   |
+--------------------------------------------------------------------+


______________________________________________________________________
//GETDTE02 JOB (SYS),'Install Other PDSs',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  GETDTE for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST02  Load other PDS from distribution tape *
//* *  Note: Uses tape drive 480                           *
//* -------------------------------------------------------*
//GETDTE02 PROC VRM=V1R0M00,
//             TVOLSER=VS1000,TUNIT=480,
//             DVOLSER=MVSDLB,DUNIT=3350     <-- Review and Modify
//LOAD02   EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//INCLIST  DD  DSN=GETDTE.&VRM..CLIST.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(2,SL)
//INASM    DD  DSN=GETDTE.&VRM..ASM.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(5,SL)
//OUTCLIST DD  DSN=GETDTE.&VRM..CLIST,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(20,10,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//OUTASM   DD  DSN=GETDTE.&VRM..ASM,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(60,30,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//         PEND
//*
//STEP001  EXEC GETDTE02
//SYSIN    DD  *
    COPY INDD=INCLIST,OUTDD=OUTCLIST
    COPY INDD=INASM,OUTDD=OUTASM
/*
//
______________________________________________________________________
Figure 3: $INST02 JCL


    a) Member $INST02 in the GETDTE.V1R0M00.CNTL data set contains
       the job to load other GETDTE data sets from distribution
       tape.

    b) Review and update JOB statement and other JCL to conform to your
       installation standard.

    c) Before submitting the above job, the distribution tape
       must be made available to MVS by issuing the following
       command from the Hercules console:

       DEVINIT 480 X:\dirname\GETDTE_V1R0M00.HET READONLY=1

       where X:\dirname is the complete path to the location
       of the Hercules Emulated Tape file.

    d) Issue the following command from the MVS console to vary
       device 480 online:

       V 480,ONLINE

    e) Submit the job.

    f) Review job output for successful load of other data sets.


+--------------------------------------------------------------------+
| Step 4. Install TSO parts for GETDTE                               |
+--------------------------------------------------------------------+
|         JCL Member: GETDTE.V1R0M00.CNTL($INST03)                   |
+--------------------------------------------------------------------+


______________________________________________________________________
//GETDTE03 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  GETDTE for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *  - CGETDTE  clist   installs to SYS2.CMDPROC         *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//INCLIST  DD  DSN=GETDTE.V1R0M00.CLIST,DISP=SHR
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR
//SYSIN    DD  *
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
/*
//
______________________________________________________________________
Figure 4: $INST03 JCL


    a) Member $INST03 in the GETDTE.V1R0M00.CNTL data set contains
       the job to install TSO CLIST to SYS2.CMDPROC.

    b) Review and update JOB statement and other JCL to conform to your
       installation standard.

    c) Submit the job.

    d) Review job output for successful load of the TSO CLIST and
       HELP members.


+--------------------------------------------------------------------+
| Step 5. Install GETDTE Program                                     |
+--------------------------------------------------------------------+
|         JCL Member: GETDTE.V1R0M00.CNTL($INST04)                   |
+--------------------------------------------------------------------+


______________________________________________________________________
//GETDTE04 JOB (SYS),'Install GETDTE',       <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  GETDTE for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST04                                        *
//* *       Install GETDTE Program                         *
//* *                                                      *
//* *  - Programs install          to SYS2.LINKLIB         *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* *                                                      *
//* -------------------------------------------------------*
//ASML     PROC MBR=WHOWHAT
//ASM      EXEC PGM=IFOX00,
//             PARM='NODECK,LOAD,RENT,TERM,XREF'
//SYSGO    DD  DSN=&&LOADSET,DISP=(MOD,PASS),SPACE=(CYL,(1,1)),
//             UNIT=VIO,DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=800)
//SYSLIB   DD  DSN=SYS1.MACLIB,DISP=SHR
//         DD  DSN=SYS1.AMODGEN,DISP=SHR
//         DD  DSN=SYS2.MACLIB,DISP=SHR          ** YREG  **
//         DD  DSN=GETDTE.V1R0M00.ASM,DISP=SHR   ** RDTECOMA **
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSPUNCH DD  DSN=NULLFILE
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSIN    DD  DSN=GETDTE.V1R0M00.ASM(&MBR),DISP=SHR <--INPUT
//*
//LKED     EXEC PGM=IEWL,PARM='MAP,LIST,LET,RENT,XREF',
//             COND=(0,NE,ASM)
//SYSLIN   DD  DSN=&&LOADSET,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSIN
//SYSLMOD  DD  DSN=SYS2.LINKLIB(&MBR),DISP=SHR     <--TARGET
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(5,2))
//SYSIN    DD  DUMMY
//         PEND
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  Assemble GETDTE                                     *
//* *                                                      *
//* -------------------------------------------------------*
//GETDTE   EXEC  ASML,MBR=GETDTE
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  If SYSn.LINKLIB or SYSn.CMDLIB is updated           *
//* *                                                      *
//* -------------------------------------------------------*
//DBSTOP   EXEC DBSTOP,
//             COND.IEFPROC=(0,NE)
//DBSTART  EXEC DBSTART,
//             COND.IEFPROC=(0,NE)
//
______________________________________________________________________
Figure 5: $INST04 JCL


    a) Member $INST04 in the GETDTE.V1R0M00.CNTL data set contains
       the job to install program GETDTE and CHKDSN to SYS2.CMDLIB.

    b) Review and update JOB statement and other JCL to conform to your
       installation standard.

    c) Submit the job.

    d) Review job output for successful completion of assembly and
       link edit steps.


+--------------------------------------------------------------------+
| Step 6. Run GETDTE TSO Validation                                  |
|         JCL Member: GETDTE.V1R0M00.CNTL($IVP1)                     |
+--------------------------------------------------------------------+


______________________________________________________________________
//IVP1     JOB (SYS),'GETDTE IPV1',          <-- Review and Modify
//             CLASS=A,MSGCLASS=X,           <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID <-- Review and Modify
//* -------------------------------------------------------*
//* *  GETDTE for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $IVP1                                          *
//* *       Run GETDTE Validation from TSO Batch           *
//* *       to execulte clist CGETDTE                      *
//* *                                                      *
//* *  Expected Result:                                    *
//* *  RC=0                                                *
//* *                                                      *
//* -------------------------------------------------------*
//BATCHTSO PROC
//STEP01   EXEC PGM=IKJEFT01
//SYSPROC  DD  DISP=SHR,DSN=SYS2.CMDPROC           <--TARGET
//SYSPRINT DD  SYSOUT=*
//SYSTSPRT DD  SYSOUT=*
//SYSTSIN  DD  DUMMY       Command Line Input
//         PEND
//*
//IVP1     EXEC BATCHTSO
//STEP01.SYSTSIN DD *
CGETDTE
/*
//
______________________________________________________________________
Figure 6: $IVP1 JCL


    a) Member $IVP1 in the GETDTE.V1R0M00.CNTL data set contains
       the job to validate GETDTE.

    b) Review and update JOB statement and other JCL to conform to your
       installation standard.

    c) Submit the job.

    d) Review job output for successful execution.  All return codes
       should be zero.

    e) Validation for GETDTE TSO is complete.


+--------------------------------------------------------------------+
| Step 7. Run GETDTE BATCH Validation                                |
|         JCL Member: GETDTE.V1R0M00.CNTL($IVP2)                     |
+--------------------------------------------------------------------+


______________________________________________________________________
//IVP2     JOB (SYS),'GETDTE IPV2',          <-- Review and Modify
//             CLASS=A,MSGCLASS=X,           <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID <-- Review and Modify
//* -------------------------------------------------------*
//* *  GETDTE for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $IVP2                                          *
//* *       Run GETDTE Validation from BATCH job           *
//* *                                                      *
//* *  Expected Result:                                    *
//* *  S0C4 for IVP2A   (invalid scenerio)                 *
//* *                                                      *
//* -------------------------------------------------------*
//IVP2A    EXEC PGM=GETDTE
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//
______________________________________________________________________
Figure 7: $IVP2 JCL


    a) Member $IVP2 in the GETDTE.V1R0M00.CNTL data set contains
       the job to validate GETDTE.

    b) Review and update JOB statement and other JCL to conform to your
       installation standard.

    c) Submit the job.

    d) Review job output.  Step IVP2A return code should be S0C4.
       This is normal as it is unsupported for GETDTE usage in a MVS job step.

    e) Validation for GETDTE BATCH is complete.


+--------------------------------------------------------------------+
| Step 8. Done                                                       |
+--------------------------------------------------------------------+


    a) Congratulations!  You completed the installation for GETDTE.

    b) Two sample programs that invoke GETDTE are included for
       reference purposes in GETDTE.V1R0M00.CNTL, members COB2DTE and
       PL12DTE.




Enjoy using GETDTE!


