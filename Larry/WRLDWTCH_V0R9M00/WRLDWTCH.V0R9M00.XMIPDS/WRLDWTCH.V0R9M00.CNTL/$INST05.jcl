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
