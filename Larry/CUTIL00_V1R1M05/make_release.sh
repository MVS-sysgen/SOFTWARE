#!/bin/bash

# builds the JCL needed to install LISTDSJ/LISTDSI

cat << 'END'
//CUTIL00 JOB (JOB),
//             'INSTALL CUTIL00',
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

for i in CUTIL00.V1R1M05.XMIPDS/CUTIL00.V1R1M05.CLIST/*; do
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

for i in CUTIL00.V1R1M05.XMIPDS/CUTIL00.V1R1M05.HELP/*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done

echo "@@"

# add maclibs


# cat << 'END'
# //MACLIB   EXEC PGM=PDSLOAD
# //STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
# //SYSPRINT DD  SYSOUT=*
# //SYSUT2   DD  DSN=&&MACLIBS,UNIT=SYSDA,
# //             DISP=(,PASS,DELETE),
# //             SPACE=(TRK,(04,02,02)),
# //             DCB=(RECFM=FB,LRECL=80,BLKSIZE=800,DSORG=PS)
# //SYSUT1   DD  DATA,DLM=@@
# END

# for i in LISTDSJ.V2R0M00/LISTDSJ.V2R0M00.MACLIB/*; do
#     m=${i%.*}
#     member=${m##*/}
#     echo "./ ADD NAME=$member"
#     cat "$i"
# done

# echo "@@"

cat << 'END'
//* -------------------------------------------------------*
//* *  CUTIL00 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST04  Install CUTIL00 Software              *
//* *                                                      *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* *                                                      *
//* *  NOTE:                                               *
//* *  -----                                               *
//* *  Two user-mods, ZP60014 and ZP60038, are REQUIRED.   *
//* *                                                      *
//* *  For more information, refer to program CUTIL00.     *
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

# CUTIL00

cat << 'END'
//* -------------------------------------------------------*
//* *  Assemble Link-Edit CUTIL00 to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//CUTIL00  EXEC  ASML,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//ASM.SYSIN DD DATA,DLM=@@
END

cat CUTIL00.V1R1M05.XMIPDS/CUTIL00.V1R1M05.ASM/CUTIL00.txt

cat << 'END'
@@
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(CUTIL00)                       <--TARGET
END

# CUTILTBL

cat << 'END'
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit CUTILTBL to SYS2.CMDLIB          *
//* -------------------------------------------------------*
//CUTILTBL EXEC  ASML,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//ASM.SYSIN DD DATA,DLM=@@
END

cat CUTIL00.V1R1M05.XMIPDS/CUTIL00.V1R1M05.ASM/CUTILTBL.txt

cat << 'END'
@@
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(CUTILTBL) 
END

cat << 'END'
//CLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.CLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=CCUTIL0I
END
cat CUTIL00.V1R1M05.XMIPDS/CUTIL00.V1R1M05.ISPF/CCUTIL0I.txt
echo "@@"

cat << 'END'
//MLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.MLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=CUTIL0
END

cat CUTIL00.V1R1M05.XMIPDS/CUTIL00.V1R1M05.ISPF/CUTIL0.txt
echo "@@"

cat << 'END'
//PLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.PLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=HCUTIL00
END
cat CUTIL00.V1R1M05.XMIPDS/CUTIL00.V1R1M05.ISPF/HCUTIL00.txt
echo "./ ADD NAME=PCUTIL00"
cat CUTIL00.V1R1M05.XMIPDS/CUTIL00.V1R1M05.ISPF/PCUTIL00.txt
echo "@@"
