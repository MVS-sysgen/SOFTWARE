#!/bin/bash

cat << 'END'
//ULXL01 JOB (JOB),
//             'INSTALL ULXL01',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
END

cat << 'END'
//*
//*  Installs MLIB
//*
//CLISTS   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.MLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
END

for i in MLIB/*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done

echo "@@"

cat << 'END'
//*
//*  Installs PLIB
//*
//CLISTS   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.PLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
END

for i in PLIB/*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done

echo "@@"

cat << 'END'
//ASMFCL EXEC ASMFCL,PARM.ASM='NODECK,OBJECT,NOXREF,NORLD',
//             PARM.LKED='LIST,MAP,NCAL,RENT,REUS,REFR',
//             COND.LKED=(0,NE,ASM)
//ASM.SYSIN DD DATA,DLM=@@
END

cat ULXL01M.ASM

cat << 'END'
@@
//LKED.SYSLMOD DD DSN=SYS2.CMDLIB(ULXL01),UNIT=,SPACE=,DISP=SHR
//LKED.SYSIN   DD DUMMY
END


