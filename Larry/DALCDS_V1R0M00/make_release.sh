#!/bin/bash

# builds the JCL needed to install DALCDS/ISRDDN

cat << 'END'
//DALCDS JOB (JOB),
//             'INSTALL DALCDS',
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

for i in V1R0M00.MACLIB.TAPE/*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done

echo "@@"

cat << 'END'
//* -------------------------------------------------------*
//* *  DALCDS for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST04                                        *
//* *       Install DALCDS Program                         *
//* *                                                      *
//* *  - Programs install          to xxxxxxxx.ISPLLIB     *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* *                                                      *
//* -------------------------------------------------------*
//ASML     PROC MBR=WHOWHAT
//ASM      EXEC PGM=IFOX00,
//             PARM='NODECK,LOAD,RENT,TERM,XREF'
//SYSGO    DD  DSN=&&LOADSET,DISP=(MOD,PASS),SPACE=(CYL,(1,1)),
//             UNIT=VIO,DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=800)
//SYSLIB   DD  DSN=SYS1.MACLIB,DISP=SHR
//         DD  DSN=SYS1.AMODGEN,DISP=SHR
//         DD  DSN=SYS2.MACLIB,DISP=SHR          ** YREG  **
//         DD  DSN=&&MACLIBS,DISP=OLD       ** ShareABitofIT **
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
//SYSLMOD  DD  DSN=SYSGEN.ISPF.LLIB(&MBR),DISP=SHR 
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(5,2))
//SYSIN    DD  DUMMY
//         PEND
END

# DALCDS

cat << 'END'
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  Assemble Link-edit DALCDS                           *
//* *                                                      *
//* -------------------------------------------------------*
//DALCDS   EXEC  ASML,MBR=DALCDS
//ASM.SYSIN DD DATA,DLM=@@
END

cat V1R0M00.ASM.TAPE/DALCDS.txt

cat << 'END'
@@
//LKED.SYSLMOD DD  DISP=SHR,DSN=SYSGEN.ISPF.LLIB
//*
//LKED.SYSIN DD *
 ALIAS ISRDDN
 NAME DALCDS(R)
/*
END


cat << 'END'
//PLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.PLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=PDALCDS0
END
cat V1R0M00.ISPF.TAPE/PDALCDS0.txt
echo "./ ADD NAME=HDALCDS0"
cat V1R0M00.ISPF.TAPE/HDALCDS0.txt
echo "@@"
