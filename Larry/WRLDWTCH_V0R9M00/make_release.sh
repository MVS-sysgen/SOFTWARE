#!/bin/bash

# builds the JCL needed to install WRLDWTCH

cat << 'END'
//WRLDWTCH JOB (JOB),
//             'INSTALL WRLDWTCH',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
END


cat << 'END'
//* -------------------------------------------------------*
//* *  WRLDWTCH for MVS3.8J TSO / Hercules                 *
//* *                                                      *
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
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSPUNCH DD  DSN=NULLFILE
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSIN    DD  DUMMY
//*
//LKED     EXEC PGM=IEWL,PARM='MAP,LIST,LET,RENT,XREF,RENT,REFR',
//             COND=(0,NE,ASM)
//SYSLIN   DD  DSN=&&LOADSET,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSIN
//SYSLMOD  DD  DSN=SYSGEN.ISPF.LLIB(&MBR),DISP=SHR     <--TARGET
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(5,2))
//SYSIN    DD  DUMMY
//         PEND
END

cat << 'END'
//WRLDWTCH EXEC  ASML,MBR=WRLDWTCH
//ASM.SYSIN DD DATA,DLM=@@
END

cat WRLDWTCH.V0R9M00.XMIPDS/WRLDWTCH.V0R9M00.ASM/WRLDWTCH.txt

echo "@@"

cat << 'END'
//CLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.CLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=CWW
END

cat WRLDWTCH.V0R9M00.XMIPDS/WRLDWTCH.V0R9M00.ISPF/CWW.txt

echo "@@"
cat << 'END'
//PLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.PLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=PWW
END
cat WRLDWTCH.V0R9M00.XMIPDS/WRLDWTCH.V0R9M00.ISPF/PWW.txt
echo "./ ADD NAME=HWW"
cat WRLDWTCH.V0R9M00.XMIPDS/WRLDWTCH.V0R9M00.ISPF/HWW.txt
echo "@@"