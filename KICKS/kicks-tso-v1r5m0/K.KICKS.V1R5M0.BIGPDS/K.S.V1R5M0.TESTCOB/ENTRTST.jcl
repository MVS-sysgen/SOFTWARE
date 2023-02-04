//ENTRTST JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=2000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//TESTCOB EXEC  PROC=K2KCOBCL       KIKCB2CL for z/os
//COPY.SYSUT1 DD *
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TESTCOB.

      *///////////////////////////////////////////////////////////////
      * KICKS is an enhancement for TSO that lets you run your CICS
      * applications directly in TSO instead of having to 'install'
      * those apps in CICS.
      * You don't even need CICS itself installed on your machine!
      *
      * KICKS for TSO
      * © Copyright 2008-2014, Michael Noel, All Rights Reserved.
      *
      * Usage of 'KICKS for TSO' is in all cases subject to license.
      * See http://www.kicksfortso.com
      * for most current information regarding licensing options.
      *//1/////////2/////////3/////////4/////////5/////////6/////////7

      * EXEC KICKS ENTER
      *       TRACENUM(data-value) | TRACEID(data-value)
      *       [FROM(data-area) [FROMLENGTH(data-area)]]
      *       [RESOURE(data-area)] [EXCEPTION]
      * END-EXEC.
      *
      * EXEC KICKS DUMP
      *       DUMPCODE(data-value) | FROM(data-area)
      *       [FLENGTH(data-value) | LENGTH(data-value)]
      * END-EXEC.

       ENVIRONMENT DIVISION.

       DATA DIVISION.

       WORKING-STORAGE SECTION.
       77  WS   PIC X(10) VALUE 'TEST1'.
       77  VARX PIC X(10) VALUE 'TEST1'.

      *01  THING1.
      *    05  VAR1 PIC X(10).

       01  THING2.
           05  VAR2 PIC X(100).

       01  THING3.
           05  VAR3 PIC X(200).

       02  THING4.
           05  VAR4 PIC X(300).
           05  VAR1 PIC X(3000).


       LINKAGE SECTION.
       01  DFHCOMMAREA PIC X(80).

       PROCEDURE DIVISION.

       MAIN-PARA.

      * all(most) all args specified
            EXEC KICKS ENTER TRACEID(1)
             FROM(KIKCOMMAREA)
             FROMLENGTH(80)
             EXCEPTION
            END-EXEC.

      * tracenum instead
            EXEC KICKS ENTER TRACENUM(2)
             FROM(KIKCOMMAREA)
             FROMLENGTH(80)
             EXCEPTION
            END-EXEC.

      * from with 'of'
            EXEC KICKS ENTER TRACEID(3)
             FROM(VAR3 OF THING3)
             FROMLENGTH(80)
             EXCEPTION
            END-EXEC.

      * fromlength with 'length of'
      * and DFHCOMMAREA instead of KIKCOMMAREA
            EXEC KICKS ENTER TRACEID(4)
             FROM(DFHCOMMAREA)
             FROMLENGTH(LENGTH OF VAR4)
             EXCEPTION
            END-EXEC.

      * fromlength with 'length of .. of'
      * and DFHCOMMAREA instead of KIKCOMMAREA
            EXEC KICKS ENTER TRACEID(5)
             FROM(DFHCOMMAREA)
             FROMLENGTH(LENGTH OF VAR4 OF THING4)
             EXCEPTION
            END-EXEC.

      * fromlength omitted
            EXEC KICKS ENTER TRACEID(6)
             FROM(KIKCOMMAREA)
             EXCEPTION
            END-EXEC.

      * from as literal, no length
            EXEC KICKS ENTER TRACEID(7)
             FROM('hello world')
             EXCEPTION
            END-EXEC.

      * dump to show results (in trace table)
            EXEC KICKS DUMP DUMPCODE('ASDF') END-EXEC.

      * dump to show just var4
            EXEC KICKS DUMP FROM(VAR4) END-EXEC.

      * dump to show first 100 bytes of ws
            EXEC KICKS DUMP FROM(WS) LENGTH(100) END-EXEC.

      * return to KICKS
            EXEC KICKS RETURN END-EXEC.
/*
//LKED.SYSLMOD DD DSN=&&GOSET(TESTCOB),UNIT=SYSDA,
//     SPACE=(1024,(50,20,1)),DISP=(MOD,PASS)
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKCOBGL)
 ENTRY TESTCOB
 NAME  TESTCOB(R)
/*
//GO EXEC PGM=KIKSIP1$,COND=(4,LT,TESTCOB.LKED),
//   REGION=2000K,TIME=1,
//   PARM='SIT=B$ ICVR=0 TRCNUM=1000 '
//* kiksip1$ comes from steplib...
//STEPLIB  DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//* tables come from skikload...
//SKIKLOAD DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//* programs & maps come from kikrpl...
//KIKRPL   DD DSN=&&GOSET,DISP=(OLD,DELETE),
//         DCB=BLKSIZE=32000
//         DD DSN=K.S.V1R5M0.KIKRPL,DISP=SHR
//*
//SYSPRINT DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=80)
//SYSTERM  DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=80)
//SYSOUT   DD SYSOUT=*,DCB=BLKSIZE=132
//CRLPOUT  DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=132)
//TRANDUMP DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=132)
//SYSUDUMP DD SYSOUT=*
//*
//AUXTRC   DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=120)
//*
//SYSIN    DD DUMMY,DCB=(RECFM=F,BLKSIZE=80)
//*
//CRLPIN   DD *,DCB=BLKSIZE=80
KEDF ON<ENTER>
KSMT<ENTER>
<PF3>        turn on aux trace
<PF12>       quit ksmt
<CLEAR>
TCOB<ENTER>
/*
//
