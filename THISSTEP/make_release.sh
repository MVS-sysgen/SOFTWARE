#!/bin/bash
cd $(dirname $0)
cat << END
//THISSTEP JOB (TSO),
//             'Install THISSTEP',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,PASSWORD=SYS1
//*
//* Requires GETJOBI
//*
//* STEP 1: Compile/Link THISSTEP to SYS2.LINKLIB(THISSTEP)
//*
//* TEST GETJOBI
//*
//*
//TEST     EXEC COBUCL,                                                    
//         PARM.COB='FLAGW,LOAD,SUPMAP,SIZE=2048K,BUF=1024K,LIST'
//COB.SYSPUNCH DD DUMMY                                                     
//COB.SYSIN    DD *                                                         
END

cat THISSTEP.cbl

cat << 'END'
/*                                                                          
//COB.SYSLIB DD DSNAME=SYSC.COBLIB,DISP=SHR
//LKED.SYSLIB DD DSNAME=SYSC.COBLIB,DISP=SHR
//            DD DSNAME=SYS2.LINKLIB,DISP=SHR          
//LKED.SYSLMOD DD DSNAME=SYS2.LINKLIB(THISSTEP),DISP=SHR
//*
//* STEP 2: Install Help
//*
//STEP1   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS2.HELP,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=THISSTEP
END

cat THISSTEP.hlp

cat << 'END'
@@
//*
//* TEST THISSTEP
//*
//*
//STEP5 EXEC PGM=THISSTEP
//SYSOUT DD SYSOUT=*,DCB=(RECFM=FBA,LRECL=161,BLKSIZE=16100)
//STEP6 EXEC PGM=THISSTEP,PARM='TEST PARAMETER'
//SYSOUT DD SYSOUT=*,DCB=(RECFM=FBA,LRECL=161,BLKSIZE=16100)
END