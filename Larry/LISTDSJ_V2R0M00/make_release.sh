#!/bin/bash

# builds the JCL needed to install LISTDSJ/LISTDSI

cat << 'END'
//LISTDSJ JOB (JOB),
//             'INSTALL LISTDSJ',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
END


# add CLISTs/HELP
cat << 'END'
//*
//*  Installs CLISTs
//*
//CLISTS   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS1.CMDPROC,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
END

for i in LISTDSJ.V2R0M00/LISTDSJ.V2R0M00.CLIST/*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done


cat << 'END'
@@
//*
//*  Installs HELP
//*
//HELP     EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS2.HELP,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
END

for i in LISTDSJ.V2R0M00/LISTDSJ.V2R0M00.HELP/*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done

echo "@@"

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

for i in LISTDSJ.V2R0M00/LISTDSJ.V2R0M00.MACLIB/*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done

echo "@@"

cat << 'END'
//* -------------------------------------------------------*
//* *  LISTDSJ for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST04                                        *
//* *       Install LISTDSJ Programs                       *
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
//         DD  DSN=&&MACLIBS,DISP=OLD 
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

# LISTDSJ

cat << 'END'
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LISTDSJ to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LISTDSJ EXEC   ASML,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//ASM.SYSIN DD DATA,DLM=@@
END

cat LISTDSJ.V2R0M00/LISTDSJ.V2R0M00.ASM/LISTDSJ.txt

cat << 'END'
@@
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
END

# LSDJMSG

cat << 'END'
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LDSJMSG to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LDSJMSG EXEC   ASML,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//ASM.SYSIN DD DATA,DLM=@@
END

cat LISTDSJ.V2R0M00/LISTDSJ.V2R0M00.ASM/LDSJMSG.txt

cat << 'END'
@@
//LKED.SYSLMOD DD  DISP=SHR,DSN=SYS2.CMDLIB(LDSJMSG)
END

# LDSJISP

cat << 'END'
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LDSJISP to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LDSJISP EXEC   ASML,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//ASM.SYSIN DD DATA,DLM=@@
END

cat LISTDSJ.V2R0M00/LISTDSJ.V2R0M00.ASM/LDSJISP.txt

cat << 'END'
@@
//LKED.SYSLMOD DD  DISP=SHR,DSN=SYS2.CMDLIB(LDSJISP)
END

cat << 'END'
//CLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.CLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=CLISTDIJ
END

cat LISTDSJ.V2R0M00/LISTDSJ.V2R0M00.ISPF/CLISTDIJ.txt
echo "@@"

cat << 'END'
//MLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.MLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=LDSJ00
END

cat LISTDSJ.V2R0M00/LISTDSJ.V2R0M00.ISPF/LDSJ00.txt
echo "@@"

cat << 'END'
//PLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.PLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=PLISTDSJ
END

cat LISTDSJ.V2R0M00/LISTDSJ.V2R0M00.ISPF/PLISTDSJ.txt
echo "./ ADD NAME=HLISTDSJ"
cat LISTDSJ.V2R0M00/LISTDSJ.V2R0M00.ISPF/HLISTDSJ.txt
echo "@@"