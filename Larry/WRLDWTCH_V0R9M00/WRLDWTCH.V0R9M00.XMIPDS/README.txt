WRLDWTCH for MVS3.8J / Hercules
===============================


Date: 09/22/2018  Release V0R9M00

*  Author:  Larry Belmontes Jr.
*           https://ShareABitofIT.net/WRLDWTCH-in-MVS38J
*           Copyright (C) 2018  Larry Belmontes, Jr.


----------------------------------------------------------------------
|    WRLDWTCH     I n s t a l l a t i o n   R e f e r e n c e        |
----------------------------------------------------------------------

   The approach for this installation procedure is to transfer the
distribution tape content from your personal computing device to
MVS with minimal JCL (less than 24 lines for easy copy-paste) and to
continue the installation procedure using supplied JCL from the MVS
CNTL data set under TSO.

   Below are descriptions of ZIP file content, pre-installation
requirements (notes, credits) and installation steps.

Good luck and enjoy using WRLDWTCH as added value to MVS 3.8J!
-Larry Belmontes



======================================================================
* I. C o n t e n t   o f   Z I P   F i l e                           |
======================================================================

o  $INST00.JCL          Define Alias for HLQ WRLDWTCH in Master Catalog

o  $INST01.JCL          Load CNTL data set from distribution tape

o  $RECVXMI.JCL         Receive XMI SEQ to MVS PDSs

o  WRLDWTCH.V0R9M00.HET Hercules Emulated Tape (HET) multi-file volume
                        with VOLSER of V0900 containing software
                        distribution.

o  WRLDWTCH.V0R9M00.XMI XMIT file containing software distribution.

o  DSCLAIMR.TXT         Disclaimer

o  PREREQS.TXT          Required user-mods

o  README.TXT           This File


Note:   ISPF v2.0 or higher must be installed under MVS3.8J TSO
-----   including associated user-mods per ISPF Installation Pre-reqs.


Credit: CBT File 366 contains the original World Clock program as a
------- REXX / ISPF application contributed by Marvin Shaw in 1999.
        Thanks to Marvin for this community contribution.
        More information at:
        https://www.cbttape.org/cbtdowns.htm


======================================================================
* II. P r e - i n s t a l l a t i o n   R e q u i r e m e n t s      |
======================================================================

o  The Master Catalog password may be required for some installation
   steps.

o  Tape files use device 480.

o  As default, DASD files will be loaded to VOLSER=MVSDLB, type 3350 device.

   Below is a DATASET List after tape distribution load for reference purposes:

   DATA-SET-NAME------------------------------- VOLUME ALTRK USTRK ORG FRMT % XT
   WRLDWTCH.V0R9M00.ASM                         MVSDLB    20     5 PO  FB  25  1
   WRLDWTCH.V0R9M00.CLIST                       MVSDLB     2     1 PO  FB  50  1
   WRLDWTCH.V0R9M00.CNTL                        MVSDLB    20     5 PO  FB  25  1
   WRLDWTCH.V0R9M00.HELP                        MVSDLB     2     1 PO  FB  50  1
   WRLDWTCH.V0R9M00.ISPF                        MVSDLB     5     2 PO  FB  40  1
   WRLDWTCH.V0R9M00.MACLIB                      MVSDLB     2     1 PO  FB  50  1
   **END**    TOTALS:      51 TRKS ALLOC        15 TRKS USED       6 EXTENTS


   Confirm the TOTAL track allocation is available on MVSDLB.

   Note: A different DASD device type may be used to yield
         different usage results.

o  TSO user-id with sufficient access rights to update SYS2.CMDPROC,
   SYS2.CMDLIB, SYS2.HELP, SYS2.LINKLIB and/or ISPF libraries.

o  For installations with a security system (e.g. RAKF), you MAY need to
   insert additional JOB statement information.

   //         USER=???????,PASSWORD=????????

o  Names of ISPCLIB (Clist), ISPMLIB (Message), ISPLLIB (Load) and/or
   ISPPLIB (Panel) libraries.

o  Download ZIP file to your PC local drive.

o  Unzip the downloaded file into a temp directory on your PC device.



======================================================================
* III. I n s t a l l a t i o n   S t e p s                           |
======================================================================

+--------------------------------------------------------------------+
| Step 1. Define Alias for HLQ WRLDWTCH in MVS User Catalog          |
+--------------------------------------------------------------------+
|         JCL Member: WRLDWTCH.V0R9M00.CNTL($INST00)                 |
+--------------------------------------------------------------------+


______________________________________________________________________
//WRLDWTCH JOB (SYS),'Def WRLDWTCH Alias',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  WRLDWTCH in MVS3.8J TSO / Hercules                  *
//* *  JOB: $INST00  Define Alias for HLQ WRLDWTCH         *
//* *  Note: The master catalog password will be required  *
//* -------------------------------------------------------*
//DEFALIAS EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 PARM GRAPHICS(CHAIN(SN))
 LISTCAT ALIAS  ENT(WRLDWTCH)

 IF LASTCC NE 0 THEN -
    DEFINE ALIAS(NAME(WRLDWTCH) RELATE(SYS1.UCAT.MVS))
/*
//
______________________________________________________________________
Figure 1: $INST00 JCL


    a) Copy and paste the above JCL to a PDS member, update JOB
       statement to conform to your installation standard.

    b) Submit the job.

    c) Review job output for successful DEFINE ALIAS.

    Note: Job step DEFALIAS returns RC=0004 due to LISTCAT function
          completing with condition code of 4 and DEFINE ALIAS
          function completing with condition code of 0.


+--------------------------------------------------------------------+
| Step 2. Determine software installation source                     |
+--------------------------------------------------------------------+
|         HET or XMI ?                                               |
+--------------------------------------------------------------------+


    a) Software can be installed from two sources, HET or XMI.

       - For tape installation (HET), proceed to STEP 4. ****

         or

       - For XMIT installation (XMI), proceed to next STEP.


+--------------------------------------------------------------------+
| Step 3. Load XMIPDS data set from XMI SEQ file                     |
+--------------------------------------------------------------------+
|         JCL Member: WRLDWTCH.V0R9M00.CNTL($RECVXMI)                |
+--------------------------------------------------------------------+


______________________________________________________________________
//RECV000A JOB (SYS),'Receive WRLDWTCH XMI',     <-- Review and Modify
//             CLASS=A,MSGCLASS=X,REGION=0M,     <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  JOB: $RECVXMI  Receive Application XMI Files        *
//* -------------------------------------------------------*
//RECV     PROC HLQ=WRLDWTCH,VRM=V0R9M00,TYP=XXXXXXXX,
//             DSPACE='(TRK,(10,05,40))',DDISP='(,CATLG,DELETE)',
//             DUNIT=3350,DVOLSER=MVSDLB         <-- Review and Modify
//*
//RECV370  EXEC PGM=RECV370
//STEPLIB  DD  DSN=SYS2.LINKLIB,DISP=SHR         <-- Review and Modify
//RECVLOG  DD  SYSOUT=*
//XMITIN   DD  DISP=SHR,DSN=&&XMIPDS(&TYP)
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  DSN=&&SYSUT1,
//   UNIT=SYSALLDA,SPACE=(CYL,(10,05)),DISP=(,DELETE,DELETE)
//SYSUT2   DD  DSN=&HLQ..&VRM..&TYP,DISP=&DDISP,
//   UNIT=&DUNIT,SPACE=&DSPACE,VOL=SER=&DVOLSER
//SYSIN    DD  DUMMY
//SYSUDUMP DD  SYSOUT=*
//         PEND
//* RECEIVE XMIPDS TEMP
//XMIPDS   EXEC RECV,TYP=XMIPDS,DSPACE='(CYL,(10,05,10),RLSE)'
//RECV370.XMITIN DD  DISP=SHR,DSN=your.transfer.xmi    <-- XMI File
//RECV370.SYSUT2   DD  DSN=&&XMIPDS,DISP=(,PASS),
//   UNIT=SYSDA,SPACE=&DSPACE
//* RECEIVE CNTL, HELP, CLIST, ISPF, ASM, MACLIB
//CNTL     EXEC RECV,TYP=CNTL,DSPACE='(TRK,(20,10,10))'
//HELP     EXEC RECV,TYP=HELP,DSPACE='(TRK,(02,02,02))'
//CLIST    EXEC RECV,TYP=CLIST,DSPACE='(TRK,(02,02,02))'
//ISPF     EXEC RECV,TYP=ISPF,DSPACE='(TRK,(05,05,10))'
//ASM      EXEC RECV,TYP=ASM,DSPACE='(TRK,(20,10,10))'
//MACLIB   EXEC RECV,TYP=MACLIB,DSPACE='(TRK,(02,02,02))'
//
______________________________________________________________________
Figure 2: $RECVXMI.JCL


    a) Transfer WRLDWTCH.V0R9M00.XMI to MVS using your 3270 emulator.

       Make note of the DSN assigned on MVS transfer.

       Use transfer IND$FILE options:

          NEW BLKSIZE=3200 LRECL=80 RECFM=FB

       Ensure the DSN on MVS exists with the correct DCB information:

          ORG=PS BLKSIZE=3200 LRECL=80 RECFM=FB


    b) Copy and paste the above JCL to a PDS member, update JOB
       statement to conform to your installation standard.

       Review JCL and apply any modifications per your installation
       including the DSN assigned during the transfer above for
       the XMI file.

    d) Submit the job.

    e) Review job output for successful load of the following PDSs:

       WRLDWTCH.V0R9M00.ASM
       WRLDWTCH.V0R9M00.CLIST
       WRLDWTCH.V0R9M00.CNTL
       WRLDWTCH.V0R9M00.HELP
       WRLDWTCH.V0R9M00.ISPF
       WRLDWTCH.V0R9M00.MACLIB

    f) Subsequent installation steps will be submitted from members
       contained in the CNTL data set.

    g) Proceed to STEP 6.   ****

+--------------------------------------------------------------------+
| Step 4. Load CNTL data set from distribution tape                  |
+--------------------------------------------------------------------+
|         JCL Member: WRLDWTCH.V0R9M00.CNTL($INST01)                 |
+--------------------------------------------------------------------+


______________________________________________________________________
//WRLDWTC1 JOB (SYS),'Install CNTL PDS',     <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  WRLDWTCH in MVS3.8J TSO / Hercules                  *
//* *  JOB: $INST01  Load CNTL PDS from distribution tape  *
//* *  Note: Default TAPE=480, DASD=3350 on MVSDLB         *
//* -------------------------------------------------------*
//LOADCNTL PROC HLQ=WRLDWTCH,VRM=V0R9M00,TVOLSER=VS0900,
//   TUNIT=480,DVOLSER=MVSDLB,DUNIT=3350     <-- Review and Modify
//LOAD001  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//INCNTL   DD  DSN=&HLQ..&VRM..CNTL.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(1,SL)
//CNTL     DD  DSN=&HLQ..&VRM..CNTL,
//             UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(20,10,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//         PEND
//STEP001  EXEC LOADCNTL                     Load CNTL PDS
//SYSIN    DD  *
    COPY INDD=INCNTL,OUTDD=CNTL
//
______________________________________________________________________
Figure 3: $INST01 JCL


    a) Before submitting the above job, the distribution tape
       must be made available to MVS by issuing the following
       command from the Hercules console:

       DEVINIT 480 X:\dirname\WRLDWTCH.V0R9M00.HET READONLY=1

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
| Step 5. Load Other data sets from distribution tape                |
+--------------------------------------------------------------------+
|         JCL Member: WRLDWTCH.V0R9M00.CNTL($INST02)                 |
+--------------------------------------------------------------------+


______________________________________________________________________
//WRLDWTC2 JOB (SYS),'Install Other PDSs',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  WRLDWTCH in MVS3.8J TSO / Hercules                  *
//* *  JOB: $INST02  Load other PDS from distribution tape *
//* *  Tape Volume:  File 1 - CNTL                         *
//* *                File 2 - CLIST                        *
//* *                File 3 - HELP                         *
//* *                File 4 - ISPF                         *
//* *                File 5 - ASM                          *
//* *                File 6 - MACLIB                       *
//* *  Note: Default TAPE=480, DASD=3350 on MVSDLB         *
//* -------------------------------------------------------*
//LOADOTHR PROC HLQ=WRLDWTCH,VRM=V0R9M00,TVOLSER=VS0900,
//   TUNIT=480,DVOLSER=MVSDLB,DUNIT=3350     <-- Review and Modify
//LOAD02   EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//INCLIST  DD  DSN=&HLQ..&VRM..CLIST.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(2,SL)
//INHELP   DD  DSN=&HLQ..&VRM..HELP.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(3,SL)
//INISPF   DD  DSN=&HLQ..&VRM..ISPF.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(4,SL)
//INASM    DD  DSN=&HLQ..&VRM..ASM.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(5,SL)
//INMACLIB DD  DSN=&HLQ..&VRM..MACLIB.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(6,SL)
//CLIST    DD  DSN=&HLQ..&VRM..CLIST,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(02,02,02)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//HELP     DD  DSN=&HLQ..&VRM..HELP,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(02,02,02)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//ISPF     DD  DSN=&HLQ..&VRM..ISPF,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(05,05,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//ASM      DD  DSN=&HLQ..&VRM..ASM,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(20,10,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//MACLIB   DD  DSN=&HLQ..&VRM..MACLIB,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(02,02,02)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//         PEND
//*
//STEP001  EXEC LOADOTHR                     Load ALL other PDSs
//SYSIN    DD  *
    COPY INDD=INCLIST,OUTDD=CLIST
    COPY INDD=INHELP,OUTDD=HELP
    COPY INDD=INISPF,OUTDD=ISPF
    COPY INDD=INASM,OUTDD=ASM
    COPY INDD=INMACLIB,OUTDD=MACLIB
//
______________________________________________________________________
Figure 4: $INST02 JCL


    a) Member $INST02 installs remaining data sets from distribution
       tape.

    b) Review and update JOB statement and other JCL to conform to your
       installation standard.

    c) Before submitting the above job, the distribution tape
       must be made available to MVS by issuing the following
       command from the Hercules console:

       DEVINIT 480 X:\dirname\WRLDWTCH.V0R9M00.HET READONLY=1

       where X:\dirname is the complete path to the location
       of the Hercules Emulated Tape file.

    d) Issue the following command from the MVS console to vary
       device 480 online:

       V 480,ONLINE

    e) Submit the job.

    f) Review job output for successful loads.


+--------------------------------------------------------------------+
| Step 6. Install TSO parts                                          |
+--------------------------------------------------------------------+
|         JCL Member: WRLDWTCH.V0R9M00.CNTL($INST03)                 |
+--------------------------------------------------------------------+


______________________________________________________________________
//WRLDWTC3 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  WRLDWTCH in MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//INCLIST  DD  DSN=WRLDWTCH.V0R9M00.CLIST,DISP=SHR
//INHELP   DD  DSN=WRLDWTCH.V0R9M00.HELP,DISP=SHR
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR
//OUTHELP  DD  DSN=SYS2.HELP,DISP=SHR
//SYSIN    DD  *
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
    SELECT MEMBER=NO#MBR#                    /*dummy entry no mbrs! */
    COPY INDD=((INHELP,R)),OUTDD=OUTHELP
    SELECT MEMBER=NO#MBR#                    /*dummy entry no mbrs! */
/*
//
______________________________________________________________________
Figure 5: $INST03 JCL


    a) Member $INST03 installs TSO component(s).

       Note:  If no TSO components are included for this distribution,
       -----  RC = 4 is returned by the corresponding IEBCOPY step.

    b) Review and update JOB statement and other JCL to conform to your
       installation standard.

    c) Submit the job.

    d) Review job output for successful load(s).


+--------------------------------------------------------------------+
| Step 7. Install Programs - WRLDWTCH                                |
+--------------------------------------------------------------------+
|         JCL Member: WRLDWTCH.V0R9M00.CNTL($INST04)                 |
+--------------------------------------------------------------------+


______________________________________________________________________
//WRLDWTCD JOB (SYS),'Install WRLDWTCH',     <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  WRLDWTCH for MVS3.8J TSO / Hercules                 *
//* *                                                      *
//* *  JOB: $INST04                                        *
//* *       Install WRLDWTCH Program                       *
//* *                                                      *
//* -------------------------------------------------------*
//ASML     PROC MBR=WHOWHAT
//ASM      EXEC PGM=IFOX00,
//             PARM='NODECK,LOAD,RENT,TERM,XREF'
//SYSGO    DD  DSN=&&LOADSET,DISP=(MOD,PASS),SPACE=(CYL,(1,1)),
//             UNIT=VIO,DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=800)
//SYSLIB   DD  DSN=SYS1.MACLIB,DISP=SHR
//         DD  DSN=SYS2.MACLIB,DISP=SHR          ** YREG  **
//         DD  DSN=WRLDWTCH.V0R9M00.MACLIB,DISP=SHR  * myMACLIB   **
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSPUNCH DD  DSN=NULLFILE
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSIN    DD  DSN=WRLDWTCH.V0R9M00.ASM(&MBR),DISP=SHR <--INPUT
//*
//LKED     EXEC PGM=IEWL,PARM='MAP,LIST,LET,RENT,XREF,RENT,REFR',
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
//* *  Assemble Link-edit WRLDWTCH                         *
//* *                                                      *
//* -------------------------------------------------------*
//WRLDWTCH EXEC  ASML,MBR=WRLDWTCH
//
______________________________________________________________________
Figure 6: $INST04 JCL


    a) Member $INST04 installs program WRLDWTCH.

    b) Review and update JOB statement and other JCL to conform to your
       installation standard.

    c) Submit the job.

    d) Review job output for successful completion.


+--------------------------------------------------------------------+
| Step 8. Install ISPF parts                                         |
+--------------------------------------------------------------------+
|         JCL Member: WRLDWTCH.V0R9M00.CNTL($INST05)                 |
+--------------------------------------------------------------------+


______________________________________________________________________
//WRLDWTC5 JOB (SYS),'Install ISPF Parts',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  WRLDWTCH in MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST05  Install ISPF parts                    *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* *                                                      *
//* *                                                      *
//* *  - Uses ISPF 2.0 product from Wally Mclaughlin       *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* *                                                      *
//* -------------------------------------------------------*
/*
//* -------------------------------------------------------*
//* *                                                      *
//* *  Panel PDS Member Installation                       *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPPLIB DD       *
//* *      for ISPF 2.x                                    *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPPLIB allocation step.       *
//* *                                                      *
//* -------------------------------------------------------*
//ADDPLIB  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//PLIBIN   DD  DSN=WRLDWTCH.V0R9M00.ISPF,DISP=SHR
//PLIBOUT  DD  DSN=XXXXXXXX.ISPPLIB,DISP=SHR       <--TARGET
//SYSIN    DD  *
   COPY INDD=((PLIBIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=PWW
   SELECT MEMBER=HWW
/*
//* -------------------------------------------------------*
//* *                                                      *
//* *  Message PDS Member Installation                     *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPMLIB DD       *
//* *      for ISPF 2.x                                    *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPMLIB allocation step.       *
//* *                                                      *
//* -------------------------------------------------------*
//ADDMLIB  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//MLIBIN   DD  DSN=WRLDWTCH.V0R9M00.ISPF,DISP=SHR
//MLIBOUT  DD  DSN=XXXXXXXX.ISPMLIB,DISP=SHR       <--TARGET
//SYSIN    DD  *
   COPY INDD=((MLIBIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
/*
//* -------------------------------------------------------*
//* *                                                      *
//* *  CLIST PDS Member Installation                       *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPCLIB DD       *
//* *      for ISPF 2.x                                    *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPCLIB allocation step.       *
//* *                                                      *
//* -------------------------------------------------------*
//ADDCLIB  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//CLIBIN   DD  DSN=WRLDWTCH.V0R9M00.ISPF,DISP=SHR
//CLIBOUT  DD  DSN=XXXXXXXX.ISPCLIB,DISP=SHR       <--TARGET
//SYSIN    DD  *
   COPY INDD=((CLIBIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=CWW
/*
//
______________________________________________________________________
Figure 7: $INST05 JCL


    a) Member $INST05 installs ISPF component(s).

       Note:  If no ISPF components are included for this distribution,
       -----  RC = 4 is returned by the corresponding IEBCOPY step.

    b) Review and update JOB statement and other JCL to conform to your
       installation standard.

    c) Review and update DD statements for ISPCLIB (clist),
       ISPMLIB (messages), and/or ISPPLIB (panel) library names.
       The DD statements are tagged with '<--TARGET'.

    d) Submit the job.

    e) Review job output for successful load(s).


+--------------------------------------------------------------------+
| Step 9. Validate WRLDWTCH                                          |
+--------------------------------------------------------------------+


    a) From the ISPF Main Menu, enter the following command:
       TSO WRLDWTCH

    b) The World WATCH map should display with current date, time,
       and world map with colored time zones with current HH (hours)
       for each time zone.

    c) Press PF3 to exit and return to previous ISPF screen.

    d) Validation for WRLDWTCH is complete.



________________________________________________________________________________
                              World WATCH      03.10.18  16:29:47
 ===>

 ...   ...   ...   ... HH###HHH#..   ...   ...   ...   ...   ...   ...
 ...   ...   ...H H#..  H###HHH#..   ...   ...   ... HH##.   ...   ...
 ...   ... HH### HH###   ###HHH...   ...HH ...   ###HHH###HHH###H  ...
 ..#HHH###HHH###HHH#.#H  ###H  .#.   .##HHH###HHH###HHH###HHH###HHH###HH
 ...HHH.##HHH###HH .##   .#.   ...   ##.HHH###HHH###HHH###HHH###HH ##.
 ...   ...HHH###HHH###HH ...   ...HH ###HHH###HHH###HHH###HHH##.  H...
 ...   ... HH###HHH###H H...   ... HH###HHH###HHH###HHH###HHH##.   ...
 ...   ...  H###HHH##.   ...   ...HH .##HHH##.HHH###HHH###HHH..#   ...
 ..Dallas--------*H#..   ...   ...HHH#..  H###HHH###HHH###H  .#.   ...
 ...   ...   .##H  ...   ...   ..#HHH###HHH###H H###HHH###H  ...   ...
 ...   ...   ...HHH...   ...   .##HHH###HHH###   .##  H##.   ...   ...
 ...   ...   ...   .##HH ...   ..#HHH###HHH##.   .#.   ...   ...   ...
 ...   ...   ...   .##HHH#..   ...   ###HHH#..   ...   #.#  H.##   ...
 ...   ...   ...   .##HHH####  ...   .##HHH...   ...   ...   ...   ...
 ...   ...   ...   ...HHH###   ...   .##HHH.#.   ...   ... HH###   ...
 ...   ...   ...   ...HHH#..   ...   .##HH ...   ...   ...HHH###H  ...
 ...   ...   ...   ..#HHH...   ...   ..#H  ...   ...   ...HH .##H  ...
 ...   ...   ...   ..#H  ...   ...   ...   ...   ...   ...   ..#   ..#
 ...   ...   ...   ..#H  ...   ...   ...   ...   ...   ...   ...   ...
 ...   ...   ...   ...H  ...   ...   ...   ...   ...   ...   ...   ...
 11 12 13 14 15 16 17 18 19 20 21 22 23 00 01 02 03 04 05 06 07 08 09 10
________________________________________________________________________________
Figure 8: Sample World CLOCK Panel


+--------------------------------------------------------------------+
| Step 10. Done                                                      |
+--------------------------------------------------------------------+


    a) Congratulations!  You completed the installation for WRLDWTCH.


+--------------------------------------------------------------------+
| Step 11. Incorporate WRLDWTCH into ISPF Menu                       |
+--------------------------------------------------------------------+


    a) See program WRLDWTCH for information on incorporating WRLDWTCH
       into a ISPF Selection Menu.




Enjoy WRLDWTCH for ISPF 2.x on MVS 3.8J!


======================================================================
* IV. S o f t w a r e   I n v e n t o r y   L i s t                  |
======================================================================

  - WRLDWTCH.V0R9M00.ASM
   . WRLDWTCH    TSO CP to build World Map and display via ISPF

  - WRLDWTCH.V0R9M00.CLIST
   . None**      No CLIST members in this version

  - WRLDWTCH.V1R1M00.CNTL
   . $INST00     Define Alias for HLQ WRLDWTCH
   . $INST01     Load CNTL data set from distribution tape (HET)
   . $INST02     Load other data sets from distribution tape (HET)
   . $INST03     Install TSO Parts
   . $INST04     Install WRLDWTCH CP
   . $INST05     Install ISPF Parts
   . $RECVXMI    Receive XMI SEQ to MVS PDSs via RECV370
   . DSCLAIMR    Disclaimer
   . PREREQS     Required User-mods
   . README      Documentation and Installation instructions

  - WRLDWTCH.V0R9M00.HELP
   . None**      No HELP members in this version

  - WRLDWTCH.V0R9M00.ISPF
   . CWW         World WATCH CLIST for WRLDWTCH
   . HWW         World WATCH Help Panel
   . PWW         World WATCH Panel
   . None**      No Message MLIB members in this version

  - WRLDWTCH.V0R9M00.MACLIB
   . None**      No MACRO members in this version







