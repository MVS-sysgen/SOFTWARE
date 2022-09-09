CHKDSN in MVS38J / Hercules
===========================

Date: 07/30/2020  Release V1R0M00

Author: Larry Belmontes Jr.
        https://ShareABitofIT.net/CHKDSN-in-MVS38J
        Copyright (C) 2020  Larry Belmontes, Jr.



   Sometimes it is necessary to determine if a dataset (DSN) exists on
the system catalog and VTOC.  Under TSO, the SYSDSN function can be
used for this purpose.  However, SYSDSN can be used only be used for
cataloged DSNs.

   Other shareware / freeware utilities provide a similar functionality
to SYSDSN on the CBT website (www.cbttape.org). However, I could not
locate one for my specific needs.  Thus, the creation of CHKDSN!

   CHKDSN checks for existence of a DSN using the system catalog and
cataloged volume.  Additionally, CHKDSN will search the DSN for
existence of a PDS member, if a member name is provided as DSN(member).
Fully-qualified and non-qualified DSNs are supported under TSO.

    Optionally, CHKDSN can be 'forced' to verify that volume serial
numbers match between the system catalog and requested volume.

    CHKDSN can also be used in MVS Batch JOBs.  CHKDSN supports only
fully-qualified DSNs in MVS JOBs.

    CHKDSN is a simple to use utility that will enhance your MVS38J
development toolset.


----------------------------------------------------------------------
| I n s t a l l a t i o n   R e f e r e n c e                        |
----------------------------------------------------------------------

   The approach for this installation procedure is to transfer the
distribution tape content from your personal computing device to MVS
with minimal JCL (less than 24 lines for easy copy-paste) and to
continue the installation procedure using supplied JCL from the MVS
CNTL data set under TSO.

   Below are description of ZIP file content, pre-installation
requirements and installation steps.

Good luck and enjoy!
-Larry Belmontes



======================================================================
* I. C o n t e n t   o f   Z I P   F i l e                           |
======================================================================

o  $INST01.JCL          Load CNTL data set from distrubtion tape

o  CHKDSN_V1R0M00.HET   Hercules Emulated Tape (HET) with VOLSER VS1000
                        containing software distribution.

o  DSCLAMR.TXT          Disclaimer

o  README.TXT           This File




======================================================================
* II. P r e - i n s t a l l a t i o n   R e q u i r e m e n t s      |
======================================================================

o  The Master Catalog password may be required for some installation
   steps.

o  Tape files use device 480.

o  HERC01.CHKDSN.CNTL (PDS) will be created.

o  DASD file(s) are loaded to VOLSER=PUB000, type 3350 device, by
   default. Confirm that 100 tracks are available.

o  Download ZIP file to your PC local drive.

o  Unzip the downloaded file into a temp directory on your PC device.

o  If dataset name, HERC01.CHKDSN.CNTL is changed, some JCL changes
   may be necessary in the supplied JCL.



======================================================================
* III. I n s t a l l a t i o n   S t e p s                           |
======================================================================

+--------------------------------------------------------------------+
| Step 1. Load CNTL data set from distribution tape                  |
|         JCL Member: $INST01                                        |
+--------------------------------------------------------------------+


//$INST01  JOB (SYS),'Load HET CHKDSN',          <-- Review and Modify
//             CLASS=A,MSGCLASS=A,               <-- Review and Modify
//             MSGLEVEL=(1,1)                    <-- Review and Modify
//* -------------------------------------------------------*
//* *  CHKDSN in MVS38J / Hercules                         *
//* *                                                      *
//* *  JOB: $INST01                                        *
//* *       Load CNTL data set from distribution tape      *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  DSN=CHKDSN.V1R0M00.TAPE,DISP=OLD,
//             VOL=SER=VS1000,LABEL=(1,SL),
//             UNIT=480                          <-- Review and Modify
//SYSUT2   DD  DSN=HERC01.CHKDSN.CNTL,
//             DISP=(,CATLG),DCB=(RECFM=FB,LRECL=80,BLKSIZE=19040),
//             SPACE=(TRK,(100,10,10)),
//             UNIT=3350,VOL=SER=PUB000          <-- Review and Modify
//SYSIN    DD  DUMMY
/*
//
Figure 1: $INST01 JCL


    a) Before submitting the above job, the distribution tape
       must be made available to MVS by issuing the following
       command from the Hercules console:

       DEVINIT 480 X:\DIRNAME\CHKDSN_V1R0M00.HET READONLY=1

       where X:\DIRNAME is the complete path to the location
       of the Hercules Emulated Tape file.

    b) Issue the following command from the MVS console to vary
       device 480 online:

       V 480,ONLINE

    c) Copy and paste the above JCL to a PDS member, update JOB
       statement to conform to your installation standard.

    d) Review, modify (if needed) and submit the job.

    e) Review job output for successful load of the CNTL data set.



+--------------------------------------------------------------------+
| Step 2. Install CHKDSN                                             |
|         JCL Member: $INST02                                        |
+--------------------------------------------------------------------+


  o    See file $INST02.JCL which represents PDS member $INST02


    a) Review JCL and make modifications per your installation
       practices.

    b) Submit JOB.

    c) Review job output for successful execution (RC=0) for
       all steps.



+--------------------------------------------------------------------+
| Step 3. Validate CHKDSN from TSO                                   |
+--------------------------------------------------------------------+

    a) From the TSO READY prompt, type the following command:

       READY

         TSO CHKDSN 'SYS1.MACLIB'

    b) The expected response:

         CHKDSN   0000 -SYS1.MACLIB on MVSRES
         ***

       Note: MVSRES may be a different volume on your system.


    c) Installation complete.  Congratulations!






Enjoy!


