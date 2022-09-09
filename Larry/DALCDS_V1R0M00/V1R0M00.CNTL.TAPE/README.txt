DALCDS for MVS 3.8J / Hercules


Date: 8/10/2020  Release V1R0M00

*  Author:  Larry Belmontes Jr.
*           https://ShareABitofIT.net/DALCDS-in-MVS38J
*           Copyright (C) 2020  Larry Belmontes, Jr.


----------------------------------------------------------------------
|    DALCDS       I n s t a l l a t i o n   R e f e r e n c e        |
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

o  $INST00.JCL          Define Alias for HLQ DALCDS in Master Catalog

o  $INST01.JCL          Load CNTL data set from distribution tape

o  DALCDS_V1R0M00.HET   Hercules Emulated Tape (HET) multi-file volume
                        with VOLSER of VS1000 contains software
                        distribution.

o  DSCLAIMR.TXT         Disclaimer

o  PREREQS.TXT          Required user-mods

o  README.TXT           This File


Note: Two installation prerequisites are ISPF message set ISRZ00
----- and SHRABIT.MACLIB macro PDS.  For convenience purposes, a
      current version of both, are included for installation.  The
      below steps will address each at the appropriate points.


======================================================================
* II. P r e - i n s t a l l a t i o n   R e q u i r e m e n t s      |
======================================================================

o  The Master Catalog password will be required for some installation
   steps.

o  Tape files use device 480.

o  DASD files will be loaded to VOLSER=MVSDLB, type 3350 device.
   Confirm that 110 tracks are available.

o  TSO user-id with sufficient access rights to update ISPF libraries.

o  Names of ISPLLIB (Load), ISPMLIB (Message) and
   ISPPLIB (Panel) libraries.

o  Download ZIP file to your PC local drive.

o  Unzip the downloaded file into a temp directory on your PC device.



======================================================================
* III. I n s t a l l a t i o n   S t e p s                           |
======================================================================

+--------------------------------------------------------------------+
| Step 1. Define Alias for HLQ DALCDS in MVS User Catalog            |
+--------------------------------------------------------------------+
|         JCL Member: DALCDS.V1R0M00.CNTL($INST00)                   |
+--------------------------------------------------------------------+


______________________________________________________________________
//DALCDS0 JOB (SYS),'Define DALCDS Alias',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=LARRY01     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DALCDS for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST00  Define Alias for HLQ DALCDS           *
//* *  Note: The master catalog password will be required  *
//* -------------------------------------------------------*
//DEFALIAS EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 PARM GRAPHICS(CHAIN(SN))
 LISTCAT ALIAS  ENT(DALCDS)
 IF LASTCC NE 0 THEN -
    DEFINE ALIAS(NAME(DALCDS) RELATE(SYS1.UCAT.MVS))
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
|         JCL Member: DALCDS.V1R0M00.CNTL($INST01)                   |
+--------------------------------------------------------------------+


______________________________________________________________________
//DALCDS1  JOB (SYS),'Install CNTL PDS',     <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=LARRY01     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DALCDS for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST01  Load CNTL PDS from distribution tape  *
//* *  Note: Uses tape drive 480                           *
//* -------------------------------------------------------*
//DALCDS1 PROC VRM=V1R0M00,
//             TVOLSER=VS1000,TUNIT=480,
//             DVOLSER=MVSDLB,DUNIT=3350     <-- Review and Modify
//LOAD001  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  DSN=DALCDS.&VRM..CNTL.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(1,SL)
//SYSUT2   DD  DSN=DALCDS.&VRM..CNTL,
//             UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(20,10,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//SYSIN    DD  DUMMY
//         PEND
//*
//STEP001  EXEC DALCDS1
______________________________________________________________________
Figure 2: $INST01 JCL


    a) Before submitting the above job, the distribution tape
       must be made available to MVS by issuing the following
       command from the Hercules console:

       DEVINIT 480 X:\dirname\DALCDS_V1R0M00.HET READONLY=1

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
|         JCL Member: DALCDS.V1R0M00.CNTL($INST02)                   |
+--------------------------------------------------------------------+


______________________________________________________________________
//DALCDS1  JOB (SYS),'Install Other PDSs',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=LARRY01     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DALCDS for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST02  Load other PDS from distribution tape *
//* *  Note: Uses tape drive 480                           *
//* -------------------------------------------------------*
//DALCDS2 PROC VRM=V1R0M00,
//             TVOLSER=VS1000,TUNIT=480,
//             DVOLSER=MVSDLB,DUNIT=3350     <-- Review and Modify
//LOAD02   EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//INCLIST  DD  DSN=DALCDS.&VRM..CLIST.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(2,SL)
//INHELP   DD  DSN=DALCDS.&VRM..HELP.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(3,SL)
//INISPF   DD  DSN=DALCDS.&VRM..ISPF.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(4,SL)
//INASM    DD  DSN=DALCDS.&VRM..ASM.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(5,SL)
//INMAC    DD  DSN=DALCDS.&VRM..MACLIB.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(6,SL)
//OUTCLIST DD  DSN=DALCDS.&VRM..CLIST,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(20,10,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//OUTHELP  DD  DSN=DALCDS.&VRM..HELP,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(05,05,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//OUTISPF  DD  DSN=DALCDS.&VRM..ISPF,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(05,05,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//OUTASM   DD  DSN=DALCDS.&VRM..ASM,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(60,30,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//OUTMAC   DD  DSN=DALCDS.&VRM..MACLIB,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(05,05,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//         PEND
//*
//STEP001  EXEC DALCDS2
//SYSIN    DD  *
    COPY INDD=INCLIST,OUTDD=OUTCLIST
    COPY INDD=INHELP,OUTDD=OUTHELP
    COPY INDD=INISPF,OUTDD=OUTISPF
    COPY INDD=INASM,OUTDD=OUTASM
    COPY INDD=INMAC,OUTDD=OUTMAC
/*
//
______________________________________________________________________
Figure 3: $INST02 JCL


    a) Member $INST02 in the DALCDS.V1R0M00.CNTL data set contains
       the job to load other DALCDS data sets from distribution
       tape.

    b) Review and update JOB statement and other JCL to conform to your
       installation standard.

    c) Before submitting the above job, the distribution tape
       must be made available to MVS by issuing the following
       command from the Hercules console:

       DEVINIT 480 X:\dirname\DALCDS_V1R0M00.HET READONLY=1

       where X:\dirname is the complete path to the location
       of the Hercules Emulated Tape file.

    d) Issue the following command from the MVS console to vary
       device 480 online:

       V 480,ONLINE

    e) Submit the job.

    f) Review job output for successful load of other data sets.
       Return Code = 8 is due to empty datasets detected by IEBCOPY.


+--------------------------------------------------------------------+
| Step 4. Create SHRABIT.MACLIB                                      |
+--------------------------------------------------------------------+
|         JCL Member: DALCDS.V1R0M00.CNTL($INST40)                   |
+--------------------------------------------------------------------+


______________________________________________________________________
//DALCDS40 JOB (SYS),'LOAD MACLIB',          <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=LARRY01     <-- Review and Modify
//* -------------------------------------------------------*
//* *  SHRABIT.MACLIB for ShareABitOfIT Utilities          *
//* *   in MVS 3.8J / Hercules                             *
//* *  JOB: $INST40  Load SHRABIT.MACLIB from              *
//* *                DALCDS.V1R0M00.MACLIB                 *
//* -------------------------------------------------------*
//DALCDS40 PROC VRM=V1R0M00,
//             DVOLSER=MVSDLB,DUNIT=3350     <-- Review and Modify
//LOAD40   EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//INMACLIB DD  DSN=DALCDS.&VRM..MACLIB,DISP=SHR
//OUTMACLB DD  DSN=SHRABIT.MACLIB,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(20,10,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//         PEND
//*
//STEP001  EXEC DALCDS40
//SYSIN    DD  *
    COPY INDD=INMACLIB,OUTDD=OUTMACLB
/*
//
______________________________________________________________________
Figure 4: $INST40 JCL


    a) Member $INST40 in the DALCDS.V1R0M00.CNTL data set contains
       the job to load SHRABIT.MACLIB.

       Note:  If SHRABIT.MACLIB is already installed on your system,
       -----  proceed to step 5.

    b) Review and update JOB statement and other JCL to conform to your
       installation standard.

    c) Submit the job.

    f) Review job output for successful load of SHRABIT.MACLIB.


+--------------------------------------------------------------------+
| Step 5. Install DALCDS Program                                     |
+--------------------------------------------------------------------+
|         JCL Member: DALCDS.V1R0M00.CNTL($INST04)                   |
+--------------------------------------------------------------------+


______________________________________________________________________
//DALCDSD  JOB (SYS),'Install DALCDS',       <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=LARRY01     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DALCDS for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST04                                        *
//* *       Install DALCDS Program                         *
//* *                                                      *
//* *  - Programs install          to xxxxxxxx.ISPLLIB     *
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
//         DD  DSN=SHRABIT.MACLIB,DISP=SHR       ** ShareABitofIT **
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSPUNCH DD  DSN=NULLFILE
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSIN    DD  DSN=DALCDS.V1R0M00.ASM(&MBR),DISP=SHR   <--INPUT
//*
//LKED     EXEC PGM=IEWL,PARM='MAP,LIST,LET,RENT,XREF',
//             COND=(0,NE,ASM)
//SYSLIN   DD  DSN=&&LOADSET,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSIN
//SYSLMOD  DD  DSN=XXXXXXXX.ISPLLIB(&MBR),DISP=SHR     <--TARGET
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(5,2))
//SYSIN    DD  DUMMY
//         PEND
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  Assemble Link-edit DALCDS                           *
//* *                                                      *
//* -------------------------------------------------------*
//DALCDS   EXEC  ASML,MBR=DALCDS
//
______________________________________________________________________
Figure 5: $INST04 JCL


    a) Member $INST04 in the DALCDS.V1R0M00.CNTL data set contains
       the job to install program DALCDS into ISPLLIB (load).

    b) Review and update JOB statement and other JCL to conform to your
       installation standard.

    c) Review and update DD statement for ISPLLIB (load)
       ISPF library names.  The DD statements are tagged
       with '<--TARGET'.

    d) Submit the job.

    e) Review job output for successful completion of assembly and
       link edit steps.


+--------------------------------------------------------------------+
| Step 6. Install ISPF parts for DALCDS                              |
+--------------------------------------------------------------------+
|         JCL Member: DALCDS.V1R0M00.CNTL($INST05)                   |
+--------------------------------------------------------------------+


______________________________________________________________________
//DALCDS5  JOB (SYS),'Install ISPF Parts',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=LARRY01     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DALCDS for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST05  Install ISPF parts                    *
//* *                                                      *
//* -------------------------------------------------------*
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  Message PDS Member Installation                     *
//* *  - ISRZ00   Message  installs to ISPMLIB             *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPMLIB DD       *
//* *      for ISPF 2.0                                    *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPMLIB allocation step.       *
//* *                                                      *
//* *  Note: Duplicate members NOT allowed.                *
//* *                                                      *
//* *  Note: ISRZ00 will NOT be overlaid to preserve       *
//* *        existing version.  Overlaying ISRZ00          *
//* *        must be facilitated manually by modifying     *
//* *        the COPY statement below.                     *
//* *                                                      *
//* -------------------------------------------------------*
//ADDMLIB  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//MLIBIN   DD  DSN=DALCDS.V1R0M00.ISPF,DISP=SHR
//MLIBOUT  DD  DSN=XXXXXXXX.ISPMLIB,DISP=SHR    <--TARGET
//SYSIN    DD  *
   COPY INDD=MLIBIN,OUTDD=MLIBOUT
   SELECT MEMBER=ISRZ00
/*
//* -------------------------------------------------------*
//* *                                                      *
//* *  Panel PDS Member Installation                       *
//* *  - PDALCDS0 Panel    installs to ISPPLIB             *
//* *  - HDALCDS0 Panel    installs to ISPPLIB             *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPPLIB DD       *
//* *      for ISPF 2.0                                    *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPPLIB allocation step.       *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* *                                                      *
//* -------------------------------------------------------*
//ADDPLIB  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//PLIBIN   DD  DSN=DALCDS.V1R0M00.ISPF,DISP=SHR
//PLIBOUT  DD  DSN=XXXXXXXX.ISPPLIB,DISP=SHR    <--TARGET
//SYSIN    DD  *
   COPY INDD=((PLIBIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=PDALCDS0
   SELECT MEMBER=HDALCDS0
/*
//
______________________________________________________________________
Figure 6: $INST05 JCL


    a) Member $INST05 in the DALCDS.V1R0M00.CNTL data set contains
       the job to install ISPF components to CLIB, PLIB and MLIB
       ISPF libraries.

    b) Review and update JOB statement and other JCL to conform to your
       installation standard.

    c) Review and update DD statements for ISPMLIB (message) and
       ISPPLIB (panel) ISPF library names.
       The DD statements are tagged with '<--TARGET'.

    d) Submit the job.

    e) Review job output for successful load of ISPF members
       across ISPF libraries.

    f) Step ADDMLIB may contain return code other than zero due
       ISRZ00 already in existence.


+--------------------------------------------------------------------+
| Step 7. Validate DALCDS                                            |
+--------------------------------------------------------------------+


    a) From the ISPF Main Menu, enter the following command:
       TSO ISPEXEC SELECT CMD(DALCDS) NEWAPPL(DALC)

    b) The panel PDALCDS0 is displayed.

       If the panel does not display, recheck $inst04 and $inst05
       for return codes and more importantly, the PDS names that hold
       program and panels.

________________________________________________________________________________
 07/30/2020.212 09:51:33 -----  TSO Allocations   ----               ROW 1 OF 53
 COMMAND ===>                                                   SCROLL ===> CSR
                                                                        LARRY03
 UserID- LARRY03  Step- IKJACCNT Proc- ISPLGN02                         PDALCDS0

 DD# DDNAME   ORG DISP VOLSER DSNAME
 001 STEPLIB  PO  Shr  PUB005 ISP.V2R2M0.LLIB
                  Shr  PUB005 LARRY01.REVIEW.R50M0.LOAD
 002 SYS00004 VS  Shr  PUB000 SYS1.UCAT.TSO
 003 SYS00002 VS  Shr  MVSCAT SYS1.UCAT.MVS
 004 ISPPROF  PO  Shr  TSO00B LARRY03.ISP.PROF
 005 SYSOUT   PS  New         Terminal
 006 SYSUDUMP ??? Mod         JES2.TSU00308.SO0101
 007 SYSABEND ??? Mod         JES2.TSU00308.SO0102
 008 SYSDBOUT ??? Mod         JES2.TSU00308.SO0103
 009 DISPLAY  PS  New         Terminal
 010 STDOUT   PS  New         Terminal
 011 IMLOG    PS  Mod         JES2.TSU00308.SO0104
 012 SYSHELP  ??? Shr  MVSRES SYS1.HELP
                  Shr  PUB000 SYS2.HELP
                  Shr  PUB005 LARRY01.REVIEW.R50M0.HELP
 013 SYSPROC  PO  Shr  PUB000 SYS1.CMDPROC
                  Shr  PUB005 SYS2.CMDPROC
                  Shr  PUB005 LARRY01.REVIEW.R50M0.CLIST
________________________________________________________________________________
Figure 7: DALCDS TSO Allocations Panel


    c) Scroll display using PF7 and PF8.

    d) Use PF1 to display HELP panel.

    e) Validation is complete.


+--------------------------------------------------------------------+
| Step 8. Done                                                       |
+--------------------------------------------------------------------+


    a) Congratulations!  You completed the installation for DALCDS.


+--------------------------------------------------------------------+
| Step 9. Incorporate DALCDS into ISPF menu panel                    |
+--------------------------------------------------------------------+


    a) To integrate DALCDS into your ISPF system, refer to member in
       DALCDS.V1R0M00.ASM(DALCDS) for suggested steps in the Overview
       section as a menu item or ISPF command.







Enjoy DALCDS!


