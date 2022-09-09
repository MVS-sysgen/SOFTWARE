//DFSPC5   JOB (SYS),'Install ISPF Parts',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DFSPC for MVS3.8J TSO / Hercules                    *
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
//ADDCLIB  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//MLIBIN   DD  DSN=DFSPC.V1R0M00.ISPF,DISP=SHR
//MLIBOUT  DD  DSN=XXXXXXXX.ISPMLIB,DISP=SHR    <--TARGET
//SYSIN    DD  *
   COPY INDD=MLIBIN,OUTDD=MLIBOUT
   SELECT MEMBER=ISRZ00
/*
//* -------------------------------------------------------*
//* *                                                      *
//* *  Panel PDS Member Installation                       *
//* *  - PDFSPC0  Panel    installs to ISPPLIB             *
//* *  - HDFSPC0  Panel    installs to ISPPLIB             *
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
//PLIBIN   DD  DSN=DFSPC.V1R0M00.ISPF,DISP=SHR
//PLIBOUT  DD  DSN=XXXXXXXX.ISPPLIB,DISP=SHR    <--TARGET
//SYSIN    DD  *
   COPY INDD=((PLIBIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=PDFSPC0
   SELECT MEMBER=HDFSPC0
/*
//
