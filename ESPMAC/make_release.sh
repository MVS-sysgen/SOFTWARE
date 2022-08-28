#!/bin/bash

cat << END
//ESPMAC  JOB (TSO),
//             'Install ESP MACLIB',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
//*
//*  Installs SYS2.MACLIB
//*
//STEP1   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS2.ESPMAC,DISP=(NEW,CATLG),
//             VOL=SER=PUB000,
//             UNIT=SYSDA,SPACE=(TRK,(44,14,17)),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=19040)
//SYSUT1   DD  DATA,DLM=@@
END

for i in CBT.V500.FILE861.PDS/*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done
echo '@@'
echo "//*"
