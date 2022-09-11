#!/bin/bash

# builds the JCL needed to install DALCDS/ISRDDN

cat << 'END'
//ISPOPT5 JOB (JOB),
//             'INSTALL ISPOPT5',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
END


cat << 'END'
//SAMPLIB  EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS2.SAMPLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=HELLOFOR
END

cat V0R9M00.CNTL.TAPE/HELLOFOR.txt

echo "@@"

cat << 'END'
//CMDPROC  EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS1.CMDPROC,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=C$ISPOP5
END

cat V0R9M00.CLIST.TAPE/C\$ISPOP5.txt
echo "./ ADD NAME=CLDSI"
cat V0R9M00.CLIST.TAPE/CLDSI.txt

echo "@@"

cat << 'END'
//PROCLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS2.PROCLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=GCCISP5
END

cat V0R9M00.CLIST.TAPE/GCCISP5.txt

echo "@@"


# CLIB
cat << 'END'
//CLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DISP=SHR,DSN=SYSGEN.ISPF.CLIB
//SYSUT1   DD  DATA,DLM=@@
END

for i in V0R9M00.ISPF.TAPE/CB*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done

echo "@@"

# MLIB
cat << 'END'
//MLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DISP=SHR,DSN=SYSGEN.ISPF.MLIB
//SYSUT1   DD  DATA,DLM=@@
END

for i in V0R9M00.ISPF.TAPE/BG*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done

echo "@@"

# PLIB
cat << 'END'
//PLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DISP=SHR,DSN=SYSGEN.ISPF.PLIB
//SYSUT1   DD  DATA,DLM=@@
END

for i in V0R9M00.ISPF.TAPE/HS*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done

for i in V0R9M00.ISPF.TAPE/IS*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done

echo "@@"

cat << 'END'
//* -------------------------------------------------------*
//* *  ISPOPT5 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST99  Install Other Files                   *
//* *                                                      *
//* *       Install OBJ Validation File                    *
//* *                                                      *
//* -------------------------------------------------------*
//*
//OBJFILE  EXEC PGM=IEFBR14
//OBJ      DD DISP=(MOD,CATLG),
//         DSN=ISPOPT5.V0R9M00.OBJ,
//         UNIT=SYSDA,                       <-- Review and Modify
//         SPACE=(CYL,(1,1,10),),
//         DCB=(DSORG=PO,RECFM=FB,LRECL=80,BLKSIZE=3120)
//
END