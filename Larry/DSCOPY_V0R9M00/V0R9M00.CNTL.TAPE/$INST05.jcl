//DSCOPY05 JOB (SYS),'Install ISPF Parts',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DSCOPY in MVS3.8J TSO / Hercules                    *
//* *                                                      *
//* *  JOB: $INST05  Install ISPF parts                    *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* *                                                      *
//* *                                                      *
//* *  - Uses ISPF 2.1 product from Wally Mclaughlin       *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* *                                                      *
//* -------------------------------------------------------*
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  PROC: PARTSISPF                                     *
//* *       Copy ISPF Parts                                *
//* *                                                      *
//* -------------------------------------------------------*
//PARTSI   PROC HLQ=MYHLQ,VRM=VXRXMXX,
//             CLIB='XXXXXXXX.ISPCLIB',
//             MLIB='XXXXXXXX.ISPMLIB',
//             PLIB='XXXXXXXX.ISPPLIB',
//             SLIB='XXXXXXXX.ISPSLIB',
//             TLIB='XXXXXXXX.ISPTLIB'
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  CLIB Member Installation                            *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPCLIB DD       *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPCLIB allocation step.       *
//* *                                                      *
//* -------------------------------------------------------*
//ADDCLIB  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//CLIBIN   DD  DSN=&HLQ..&VRM..ISPF,DISP=SHR
//CLIBOUT  DD  DSN=&CLIB,DISP=SHR
//SYSIN    DD  DUMMY
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  MLIB Member Installation                            *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPMLIB DD       *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPMLIB allocation step.       *
//* *                                                      *
//* -------------------------------------------------------*
//ADDMLIB  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//MLIBIN   DD  DSN=&HLQ..&VRM..ISPF,DISP=SHR
//MLIBOUT  DD  DSN=&MLIB,DISP=SHR
//SYSIN    DD  DUMMY
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  PLIB Member Installation                            *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPPLIB DD       *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPPLIB allocation step.       *
//* *                                                      *
//* -------------------------------------------------------*
//ADDPLIB  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//PLIBIN   DD  DSN=&HLQ..&VRM..ISPF,DISP=SHR
//PLIBOUT  DD  DSN=&PLIB,DISP=SHR
//SYSIN    DD  DUMMY
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  SLIB Member Installation                            *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPSLIB DD       *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPSLIB allocation step.       *
//* *                                                      *
//* -------------------------------------------------------*
//ADDSLIB  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//SLIBIN   DD  DSN=&HLQ..&VRM..ISPF,DISP=SHR
//SLIBOUT  DD  DSN=&SLIB,DISP=SHR
//SYSIN    DD  DUMMY
//*
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  TLIB Member Installation                            *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPTLIB DD       *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPTLIB allocation step.       *
//* *                                                      *
//* -------------------------------------------------------*
//ADDTLIB  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//TLIBIN   DD  DSN=&HLQ..&VRM..ISPF,DISP=SHR
//TLIBOUT  DD  DSN=&TLIB,DISP=SHR
//SYSIN    DD  DUMMY
//*
//         PEND
//*
//ISPF     EXEC PARTSI,HLQ=DSCOPY,VRM=V0R9M00,
//         CLIB='XXXXXXXX.ISPCLIB',                <--TARGET
//         MLIB='XXXXXXXX.ISPMLIB',                <--TARGET
//         PLIB='XXXXXXXX.ISPPLIB',                <--TARGET
//         SLIB='XXXXXXXX.ISPSLIB',                <--TARGET
//         TLIB='XXXXXXXX.ISPTLIB'                 <--TARGET
//ADDCLIB.SYSIN    DD  *                  CLIB
   COPY INDD=((CLIBIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
//ADDMLIB.SYSIN    DD  *                  MLIB
   COPY INDD=((MLIBIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=DCPY00
   SELECT MEMBER=DCPY01
   SELECT MEMBER=DCPY02
//ADDPLIB.SYSIN    DD  *                  PLIB
   COPY INDD=((PLIBIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=HDCPY0
   SELECT MEMBER=HDCPY0R
   SELECT MEMBER=PDCPY0
   SELECT MEMBER=PDCPY0R
   SELECT MEMBER=PDCPY1
//ADDSLIB.SYSIN    DD  *                  SLIB
   COPY INDD=((SLIBIN,R)),OUTDD=SLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
//ADDTLIB.SYSIN    DD  *                  TLIB
   COPY INDD=((TLIBIN,R)),OUTDD=TLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
//