#!/bin/bash

# builds the JCL needed to install CCOMPR

cat << 'END'
//CCOMPR JOB (JOB),
//             'INSTALL CCOMPR',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
END

# add maclibs


cat << 'END'
//MACLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=&&MACLIBS,UNIT=SYSDA,
//             DISP=(,PASS,DELETE),
//             SPACE=(TRK,(04,02,02)),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=800,DSORG=PS)
//SYSUT1   DD  DATA,DLM=@@
END

for i in V0R9M01.MACLIB.TAPE/*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done

echo "@@"

cat << 'END'
//* -------------------------------------------------------*
//* *  CCOMPR for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST04                                        *
//* *       Install CCOMPR Program                         *
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
//ASML     PROC
//*
//ASM      EXEC PGM=IFOX00,
//             PARM='NODECK,LOAD,RENT,TERM,XREF'
//SYSGO    DD  DSN=&&LOADSET,DISP=(MOD,PASS),SPACE=(CYL,(1,1)),
//             UNIT=VIO,DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=800)
//SYSLIB   DD  DSN=SYS1.MACLIB,DISP=SHR
//         DD  DSN=SYS1.AMODGEN,DISP=SHR
//         DD  DSN=SYS2.MACLIB,DISP=SHR          ** YREG  **
//         DD  DSN=&&MACLIBS,DISP=OLD   * myMACLIB **
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
//SYSLMOD  DD  DUMMY
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(5,2))
//SYSIN    DD  DUMMY
//*
//         PEND
//*
END

# DFSPC

cat << 'END'

//* -------------------------------------------------------*
//* *  Assemble Link-Edit CCOMPR to ISPLLIB                *
//* -------------------------------------------------------*
//CCOMPR   EXEC  ASML
//ASM.SYSIN DD DATA,DLM=@@
END

cat V0R9M01.ASM.TAPE/CCOMPR.txt

echo "@@"
cat << END
//LKED.SYSLMOD DD  DISP=SHR,DSN=SYSGEN.ISPF.LLIB(CCOMPR)
END

cat << 'END'
//PLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.PLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=HCOMPR
END
cat V0R9M01.ISPF.TAPE/HCOMPR.txt 
echo "./ ADD NAME=PCOMPR"

cat V0R9M01.ISPF.TAPE/PCOMPR.txt 
echo "@@"

cat << 'END'
//CLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.CLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=C$CCOMPR
END

cat V0R9M01.ISPF.TAPE/C\$CCOMPR.txt

echo "@@"
cat << 'END'
//MLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.MLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=CMPR00
END

cat V0R9M01.ISPF.TAPE/CMPR00.txt
echo "./ ADD NAME=CMPR01"

cat V0R9M01.ISPF.TAPE/CMPR01.txt 

echo "@@"
