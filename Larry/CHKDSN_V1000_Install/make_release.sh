#!/bin/bash

# builds the JCL needed to install CHKDSN

cat << 'END'
//CHKDSN JOB (JOB),
//             'INSTALL CHKDSN',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
END


cat << 'END'
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
//SYSIN    DD  DUMMY
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
END

cat << 'END'
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  Assemble CHKDSN programs                            *
//* *                                                      *
//* -------------------------------------------------------*
//CHKDSN   EXEC  ASML,MBR=CHKDSN
//ASM.SYSIN DD DATA,DLM=@@
END

cat CHKDSN.V1R0M00.TAPE/CHKDSN.txt

cat << 'END'
@@
//CHKDSNSM EXEC  ASML,MBR=CHKDSNMS
//ASM.SYSIN DD DATA,DLM=@@
END

cat CHKDSN.V1R0M00.TAPE/CHKDSNMS.txt

echo "@@"

cat << 'END'
//CLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS2.HELP,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=CHKDSN
END

cat CHKDSN.V1R0M00.TAPE/HCHKDSN.txt
