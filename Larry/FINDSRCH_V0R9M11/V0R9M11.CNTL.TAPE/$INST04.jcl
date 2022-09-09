//FINDSRC4 JOB (SYS),'Install FINDSRCH',     <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  FINDSRCH for MVS3.8J TSO / Hercules                 *
//* *                                                      *
//* *  JOB: $INST04                                        *
//* *       Install FINDSRCH Programs                      *
//* *                                                      *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* *                                                      *
//* -------------------------------------------------------*
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  PROC: ASMLKED                                       *
//* *       Assembler Link-Edit                            *
//* *                                                      *
//* -------------------------------------------------------*
//ASML     PROC HLQ=WHATHLQ,VRM=VXRXMXX,
//             MBR=WHOWHAT
//*
//ASM      EXEC PGM=IFOX00,
//             PARM='NODECK,LOAD,RENT,TERM,XREF'
//SYSGO    DD  DSN=&&LOADSET,DISP=(MOD,PASS),SPACE=(CYL,(1,1)),
//             UNIT=VIO,DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=800)
//SYSLIB   DD  DSN=SYS1.MACLIB,DISP=SHR
//         DD  DSN=SYS1.AMODGEN,DISP=SHR
//         DD  DSN=SYS2.MACLIB,DISP=SHR          ** YREG  **
//         DD  DSN=&HLQ..&VRM..MACLIB,DISP=SHR   * myMACLIB **
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSPUNCH DD  DSN=NULLFILE
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSIN    DD  DSN=&HLQ..&VRM..ASM(&MBR),DISP=SHR <--INPUT
//*
//LKED     EXEC PGM=IEWL,PARM='MAP,LIST,LET,RENT,XREF',
//             COND=(0,NE,ASM)
//SYSLIN   DD  DSN=&&LOADSET,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSIN
//SYSLMOD  DD  DUMMY
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(5,2))
//SYSIN    DD  DUMMY
//*
//         PEND
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit FINDSRCH to ISPLLIB              *
//* -------------------------------------------------------*
//FINDSRCH EXEC  ASML,HLQ=FINDSRCH,VRM=V0R9M11,MBR=FINDSRCH,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=XXXXXXXX.ISPLLIB(&MBR)             <--TARGET
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit DSNTAB  to SYS2.LINKLIB          *
//* -------------------------------------------------------*
//DSNTAB   EXEC  ASML,HLQ=FINDSRCH,VRM=V0R9M11,MBR=DSNTAB,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.LINKLIB(&MBR)                 <--TARGET
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LOCATE  to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LOCATE   EXEC  ASML,HLQ=FINDSRCH,VRM=V0R9M11,MBR=LOCATE,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET
//LKED.SYSLIB  DD  DSN=SYS2.LINKLIB,DISP=SHR
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit FINDMEM to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//FINDMEM  EXEC  ASML,HLQ=FINDSRCH,VRM=V0R9M11,MBR=FINDMEM,
//         PARM.ASM='NODECK,LOAD,TERM,XREF',
//         PARM.LKED='MAP,LIST,LET,XREF'
//***      PARM.LKED=(XREF,LET,LIST,NCAL)
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  If SYSn.LINKLIB or SYSn.CMDLIB is updated           *
//* *                                                      *
//* -------------------------------------------------------*
//DBSTOP   EXEC DBSTOP,
//             COND=(0,NE)
//DBSTART  EXEC DBSTART,
//             COND=(0,NE)
//
