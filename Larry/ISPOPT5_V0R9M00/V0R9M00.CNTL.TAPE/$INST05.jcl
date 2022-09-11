//ISPOPT55 JOB (SYS),'Install ISPF Parts',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  ISPOPT5 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST05  Install ISPF parts                    *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
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
//ISPF     EXEC PARTSI,HLQ=ISPOPT5,VRM=V0R9M00,
//         CLIB='XXXXXXXX.ISPCLIB',                <--TARGET
//         MLIB='XXXXXXXX.ISPMLIB',                <--TARGET
//         PLIB='XXXXXXXX.ISPPLIB',                <--TARGET
//         SLIB='XXXXXXXX.ISPSLIB',                <--TARGET
//         TLIB='XXXXXXXX.ISPTLIB'                 <--TARGET
//ADDCLIB.SYSIN    DD  *                  CLIB
   COPY INDD=((CLIBIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=CBGIJCL0
   SELECT MEMBER=CBGIQGO
   SELECT MEMBER=CBGLLIBS
   SELECT MEMBER=CBGVALIN
   SELECT MEMBER=CBGP5
   SELECT MEMBER=CBGP51
   SELECT MEMBER=CBGP52
   SELECT MEMBER=CBGP53
   SELECT MEMBER=CBGP54
   SELECT MEMBER=CBGP55
   SELECT MEMBER=CBGP56
   SELECT MEMBER=CBGP57
   SELECT MEMBER=CBGP58
   SELECT MEMBER=CBGP59
   SELECT MEMBER=CBGP5A
   SELECT MEMBER=CBGP5B
   SELECT MEMBER=CBGP5C
   SELECT MEMBER=CBGP5D
   SELECT MEMBER=CBGP5E
   SELECT MEMBER=CBGP5F
   SELECT MEMBER=CBGP5G
   SELECT MEMBER=CBGP5H
   SELECT MEMBER=CBGP5I
//ADDMLIB.SYSIN    DD  *                  MLIB
   COPY INDD=((MLIBIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=BGOPT0
   SELECT MEMBER=BGOPT1
   SELECT MEMBER=BGOPT5
   SELECT MEMBER=BGOPT55
//ADDPLIB.SYSIN    DD  *                  PLIB
   COPY INDD=((PLIBIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=HSPOPT5
   SELECT MEMBER=HSPOPT51
   SELECT MEMBER=HSPOPT52
   SELECT MEMBER=HSPOPT53
   SELECT MEMBER=HSPOPT54
   SELECT MEMBER=HSPOPT55
   SELECT MEMBER=HSPOPT56
   SELECT MEMBER=HSPOPT57
   SELECT MEMBER=HSPOPT58
   SELECT MEMBER=HSPOPT59
   SELECT MEMBER=HSPOPT5A
   SELECT MEMBER=HSPOPT5B
   SELECT MEMBER=HSPOPT5C
   SELECT MEMBER=HSPOPT5D
   SELECT MEMBER=HSPOPT5E
   SELECT MEMBER=HSPOPT5F
   SELECT MEMBER=HSPOPT5G
   SELECT MEMBER=HSPOPT5H
   SELECT MEMBER=HSPOPT5I
   SELECT MEMBER=ISPOPT5
   SELECT MEMBER=ISPOPT51
   SELECT MEMBER=ISPOPT52
   SELECT MEMBER=ISPOPT53
   SELECT MEMBER=ISPOPT54
   SELECT MEMBER=ISPOPT55
   SELECT MEMBER=ISPOPT56
   SELECT MEMBER=ISPOPT57
   SELECT MEMBER=ISPOPT58
   SELECT MEMBER=ISPOPT59
   SELECT MEMBER=ISPOPT5A
   SELECT MEMBER=ISPOPT5B
   SELECT MEMBER=ISPOPT5C
   SELECT MEMBER=ISPOPT5D
   SELECT MEMBER=ISPOPT5E
   SELECT MEMBER=ISPOPT5F
   SELECT MEMBER=ISPOPT5G
   SELECT MEMBER=ISPOPT5H
   SELECT MEMBER=ISPOPT5I
   SELECT MEMBER=ISPOPT5X
//ADDSLIB.SYSIN    DD  *                  SLIB
   COPY INDD=((SLIBIN,R)),OUTDD=SLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
//ADDTLIB.SYSIN    DD  *                  TLIB
   COPY INDD=((TLIBIN,R)),OUTDD=TLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
//
