//LISTDSJU JOB (SYS),'Upgrade LISTDSJ',      <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  LISTDSJ for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $UP2000                                        *
//* *       Upgrade LISTDSJ Software from release V1R0M40  *
//* *                                                      *
//* *  Review JCL before submitting!!                      *
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
//* *  ISPF Library Member Installation                    *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPF Libraries   *
//* *      - ISPCLIB, ISPMLIB, ISPPLIB, ISPSLIB, ISPTLIB   *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPxLIB allocation step.       *
//* *                                                      *
//* -------------------------------------------------------*
//ISPFLIBS EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//ISPFIN   DD  DSN=&HLQ..&VRM..ISPF,DISP=SHR
//CLIBOUT  DD  DSN=&CLIB,DISP=SHR
//MLIBOUT  DD  DSN=&MLIB,DISP=SHR
//PLIBOUT  DD  DSN=&PLIB,DISP=SHR
//SLIBOUT  DD  DSN=&SLIB,DISP=SHR
//TLIBOUT  DD  DSN=&TLIB,DISP=SHR
//SYSIN    DD  DUMMY
//*
//         PEND
//*
//* -------------------------------------------------------*
//* *  Update TSO parts for this release distribution      *
//* -------------------------------------------------------*
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//TSOPARTS EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//INCLIST  DD  DSN=LISTDSJ.V2R0M00.CLIST,DISP=SHR
//INHELP   DD  DSN=LISTDSJ.V2R0M00.HELP,DISP=SHR
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR          <--TARGET
//OUTHELP  DD  DSN=SYS2.HELP,DISP=SHR             <--TARGET
//SYSIN    DD  *
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
    SELECT MEMBER=CFLDSI
    SELECT MEMBER=CLDSI
    SELECT MEMBER=CLDSI2
    COPY INDD=((INHELP,R)),OUTDD=OUTHELP
    SELECT MEMBER=CFLDSI
    SELECT MEMBER=CLDSI
    SELECT MEMBER=CLDSI2
/*
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LISTDSJ to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LISTDSJ EXEC   ASML,HLQ=LISTDSJ,VRM=V2R0M00,MBR=LISTDSJ,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB                        <--TARGET
//*
//********************************************************************/
//* 04/10/2020 1.0.20   Larry Belmontes Jr.                          */
//*                     - Added ALIAS LISTDSI to LKED step           */
//********************************************************************/
//LKED.SYSIN DD *
 ALIAS LISTDSI
 NAME LISTDSJ(R)
/*
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LDSJMSG to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LDSJMSG EXEC   ASML,HLQ=LISTDSJ,VRM=V2R0M00,MBR=LDSJMSG,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LDSJISP to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LDSJISP EXEC   ASML,HLQ=LISTDSJ,VRM=V2R0M00,MBR=LDSJISP,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET
//*
//* -------------------------------------------------------*
//* *  If SYSn.LINKLIB or SYSn.CMDLIB is updated           *
//* -------------------------------------------------------*
//DBSTOP   EXEC DBSTOP,
//             COND=(0,NE)
//DBSTART  EXEC DBSTART,
//             COND=(0,NE)
//*
//* -------------------------------------------------------*
//* *  Update ISPF parts for this release distribution     *
//* -------------------------------------------------------*
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//*
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//*
//* -------------------------------------------------------*
//ISPFPRTS EXEC PARTSI,HLQ=LISTDSJ,VRM=V2R0M00,
//         CLIB='XXXXXXXX.ISPCLIB',                <--TARGET
//         MLIB='XXXXXXXX.ISPMLIB',                <--TARGET
//         PLIB='XXXXXXXX.ISPPLIB',                <--TARGET
//         SLIB='XXXXXXXX.ISPSLIB',                <--TARGET
//         TLIB='XXXXXXXX.ISPTLIB'                 <--TARGET
//SYSIN    DD  *
   COPY INDD=((ISPFIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
   COPY INDD=((ISPFIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
   COPY INDD=((ISPFIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=PLISTDSJ
   SELECT MEMBER=HLISTDSJ
   COPY INDD=((ISPFIN,R)),OUTDD=SLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
   COPY INDD=((ISPFIN,R)),OUTDD=TLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
//
