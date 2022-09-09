#!/bin/bash

# builds the JCL needed to install DALCDS/ISRDDN

cat << 'END'
//FINDSRCH JOB (JOB),
//             'INSTALL FINDSRCH',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
END


cat << 'END'
//* -------------------------------------------------------*
//* *  FINDSRCH for MVS3.8J TSO / Hercules                 *
//* *                                                      *
//* *  JOB: $INST04                                        *
//* *       Install FINDSRCH Programs                      *
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
END


cat << 'END'
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit FINDSRCH to ISPLLIB              *
//* -------------------------------------------------------*
//FINDSRCH EXEC  ASML,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//ASM.SYSIN DD DATA,DLM=@@
END

cat V0R9M11.ASM.TAPE/FINDSRCH.txt

cat << 'END'
@@
//LKED.SYSLMOD DD  DISP=SHR,DSN=SYSGEN.ISPF.LLIB(FINDSRCH)
END

cat << 'END'
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit DSNTAB  to SYS2.LINKLIB          *
//* -------------------------------------------------------*
//DSNTAB   EXEC  ASML,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//ASM.SYSIN DD DATA,DLM=@@
END

cat V0R9M11.ASM.TAPE/DSNTAB.txt

cat << 'END'
@@
//LKED.SYSLMOD DD  DISP=SHR,DSN=SYS2.LINKLIB(DSNTAB)
END

cat << 'END'
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LOCATE  to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LOCATE   EXEC  ASML,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//ASM.SYSIN DD DATA,DLM=@@
END

cat V0R9M11.ASM.TAPE/LOCATE.txt

cat << 'END'
@@
//LKED.SYSLMOD DD  DISP=SHR,DSN=SYS2.CMDLIB(LOCATE)
//LKED.SYSLIB  DD  DSN=SYS2.LINKLIB,DISP=SHR
END

cat << 'END'
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit FINDMEM to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//FINDMEM  EXEC  ASML,
//         PARM.ASM='NODECK,LOAD,TERM,XREF',
//         PARM.LKED='MAP,LIST,LET,XREF'
//***      PARM.LKED=(XREF,LET,LIST,NCAL)
//ASM.SYSIN DD DATA,DLM=@@
END

cat V0R9M11.ASM.TAPE/FINDMEM.txt

cat << 'END'
@@
//LKED.SYSLMOD DD  DISP=SHR,DSN=SYS2.CMDLIB(FINDMEM)
END



cat << 'END'
//PLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.PLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=PFINDM
END
cat V0R9M11.ISPF.TAPE/PFINDM.txt
echo "./ ADD NAME=HFINDM"
cat V0R9M11.ISPF.TAPE/HFINDM.txt
echo "./ ADD NAME=PMEMFIND"
cat V0R9M11.ISPF.TAPE/PMEMFIND.txt
echo "./ ADD NAME=HMEMFIND"
cat V0R9M11.ISPF.TAPE/HMEMFIND.txt
echo "./ ADD NAME=PSRCH"
cat V0R9M11.ISPF.TAPE/PSRCH.txt
echo "./ ADD NAME=HSRCH"
cat V0R9M11.ISPF.TAPE/HSRCH.txt
echo "./ ADD NAME=PVOL"
cat V0R9M11.ISPF.TAPE/PVOL.txt
echo "./ ADD NAME=HVOL"
cat V0R9M11.ISPF.TAPE/HVOL.txt
echo "@@"

cat << 'END'
//MLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.MLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=FIND00
END
cat V0R9M11.ISPF.TAPE/FIND00.txt
echo "./ ADD NAME=FIND01"
cat V0R9M11.ISPF.TAPE/FIND01.txt
echo "@@"

cat << 'END'
//CLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.ISPF.CLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=C$FNDSRH
END
cat V0R9M11.ISPF.TAPE/C\$FNDSRH.txt
echo "./ ADD NAME=CMEMFIND"
cat V0R9M11.ISPF.TAPE/CMEMFIND.txt
echo "./ ADD NAME=CSRCH"
cat V0R9M11.ISPF.TAPE/CSRCH.txt
echo "./ ADD NAME=CVOL"
cat V0R9M11.ISPF.TAPE/CVOL.txt
echo "./ ADD NAME=CLOC8"
cat V0R9M11.ISPF.TAPE/CLOC8.txt
echo "./ ADD NAME=CMEMINDD"
cat V0R9M11.ISPF.TAPE/CMEMINDD.txt
echo "@@"

cat << 'END'
//CLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS1.CMDPROC,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=CLDSI
END
cat V0R9M11.CLIST.TAPE/CLDSI.txt
echo "@@"


cat << 'END'
//CLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS2.HELP,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=CLDSI
END
cat V0R9M11.HELP.TAPE/CLDSI.txt
echo "./ ADD NAME=FINDMEM"
cat V0R9M11.HELP.TAPE/FINDMEM.txt
echo "./ ADD NAME=FINDSRCH"
cat V0R9M11.HELP.TAPE/FINDSRCH.txt
echo "./ ADD NAME=LOCATE"
cat V0R9M11.HELP.TAPE/LOCATE.txt
echo "@@"