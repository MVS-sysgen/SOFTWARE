#!/bin/bash

cat << END
//COLEMAC  JOB (TSO),
//             'Install ESP MACLIB',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
//*
//*  Installs SYS2.COLEMAC
//*
//STEP1   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS2.COLEMAC,DISP=(NEW,CATLG),
//             VOL=SER=PUB000,
//             UNIT=SYSDA,SPACE=(CYL,(2,3,14)),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=19040)
//SYSUT1   DD  DATA,DLM=@@
END

for i in macros/*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done
echo '@@'
echo "//*"
