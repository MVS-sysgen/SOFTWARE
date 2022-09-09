//$INST02  JOB (SYS),'Install CHKDSN',       <-- Review and Modify
//             CLASS=A,                      <-- Review and Modify
//             MSGCLASS=A,                   <-- Review and Modify
//             MSGLEVEL=(1,1)                <-- Review and Modify
//* -------------------------------------------------------*
//* *  CHKDSN for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST02                                        *
//* *       Install CHKDSN Programs                        *
//* *       Install CHKDSN HELP file                       *
//* *                                                      *
//* *  - CHKDSN programs  installs to SYS2.CMDLIB          *
//* *  - CHKDSN HELP file installs to SYS2.HELP            *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* *                                                      *
//* -------------------------------------------------------*
//ASML     PROC MBR=WHOWHAT
//ASM      EXEC PGM=IFOX00,
//             PARM='NODECK,LOAD,RENT,TERM'
//SYSGO    DD  DSN=&&LOADSET,DISP=(MOD,PASS),SPACE=(CYL,(1,1)),
//             UNIT=VIO,DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=800)
//SYSLIB   DD  DSN=SYS1.MACLIB,DISP=SHR
//         DD  DSN=SYS1.AMODGEN,DISP=SHR
//         DD  DSN=SYS2.MACLIB,DISP=SHR          ** YREG  **
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSPUNCH DD  DSN=NULLFILE
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSIN    DD  DSN=HERC01.CHKDSN.CNTL(&MBR),DISP=SHR <--INPUT
//*
//LKED     EXEC PGM=IEWL,PARM='MAP,LIST,LET,RENT,XREF',
//             COND=(0,NE,ASM)
//SYSLIN   DD  DSN=&&LOADSET,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSIN
//SYSLMOD  DD  DSN=SYS2.CMDLIB(&MBR),DISP=SHR      <--TARGET
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(5,2))
//SYSIN    DD  DUMMY
//         PEND
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  Assemble CHKDSN programs                            *
//* *                                                      *
//* -------------------------------------------------------*
//CHKDSN   EXEC  ASML,MBR=CHKDSN
//CHKDSNSM EXEC  ASML,MBR=CHKDSNMS
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  CHKDSN Help file                                    *
//* *  Copy HCHKDSN as CHKDSN to SYS2.HELP                 *
//* *                                                      *
//* -------------------------------------------------------*
//HELP    EXEC PGM=IEBCOPY,COND=(0,NE)
//SYSPRINT DD  SYSOUT=*
//INHELP   DD  DISP=SHR,DSN=HERC01.CHKDSN.CNTL          <--INPUT
//OUTHELP  DD  DISP=SHR,DSN=SYS2.HELP              <= TARGET LIBRARY
//SYSIN    DD  *
    COPY INDD=INHELP,OUTDD=OUTHELP
    SELECT MEMBER=((HCHKDSN,CHKDSN,R))
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
