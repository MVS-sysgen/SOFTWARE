#!/bin/bash

cat << END
//ISPTHEME  JOB (TSO),
//             'New ISPF Theme',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
//*
//* Backup ISPF PLIB
//BACKUP   EXEC PGM=IEBCOPY
//SYSPRINT DD   SYSOUT=*
//SYSUT1   DD   DSN=SYSGEN.ISPF.PLIB,DISP=SHR
//SYSIN    DD  DUMMY
//SYSUT2   DD  DISP=(NEW,CATLG),
//             DSN=SYSGEN.ISPF.PLIB.BACKUP,
//             DCB=SYS1.MACLIB,
//             SPACE=(CYL,(2,0,20),RLSE),
//             UNIT=SYSDA,
//             VOL=SER=PUB001
//*
//*  Installs Wally ISPF Theme
//*
//STEP1   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.PLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
END

for i in Theme/*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done
echo '@@'
echo "//*"
