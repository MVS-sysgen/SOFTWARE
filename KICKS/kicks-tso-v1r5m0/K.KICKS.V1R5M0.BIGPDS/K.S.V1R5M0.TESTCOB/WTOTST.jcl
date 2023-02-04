//WTOTST  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=2000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//TESTCOB EXEC PROC=K2KCOBCL       KIKCB2CL for z/os
//COPY.SYSUT1 DD *
       ID DIVISION.
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

      * EXEC KICKS WRITE OPERATOR
      *       TEXT(data-area) [TEXTLENGTH(data-value)]
      *       [ROUTECODES(data-area) [NUMROUTES)data-value)]]
      *       [ACTION(data-value) | EVENTUAL | IMMEDIATE | CRITICAL]
      *       [REPLY(data-area) MAXLENGTH(data-value)
      *        REPLYLENGTH(data-area) [TIMEOUT(data-value)]]
      * END-EXEC.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN  PIC X(24) VALUE 'TESTCOB  WORKING STORAGE'.
       77  WS-MSG1   PIC X(32) VALUE 'KICKS WRITE OPERATOR TEST'.
       77  WS-MSG2   PIC X(32) VALUE 'Please do NOT reply to this msg'.
       77  WS-MSG3   PIC X(32) VALUE 'Please DO reply to this msg ASAP'.
       77  WS-REPLY      PIC X(32) VALUE SPACES.
       77  WS-REPLY-LEN  PIC S9(8) COMP VALUE +0.
       77  RC            PIC S9(4) COMP VALUE +0.

       PROCEDURE DIVISION.

           EXEC KICKS WRITE OPERATOR
             TEXT(WS-MSG1) TEXTLENGTH(25)
           END-EXEC.

      * I guess it's obvious, but remember that asking for a reply
      * makes your program conversational, so any files you've been
      * using are unavailable to others while you're waiting for
      * the operator to reply.
      *
      * If possible (ie, your code really is between logical units
      * of work) declare a SYNCPOINT before waiting for a reply.
      * This will release files you've used so others can access
      * them while you wait for the reply.

           EXEC KICKS SYNCPOINT END-EXEC.

           EXEC KICKS WRITE OPERATOR
             TEXT(WS-MSG2) TEXTLENGTH(31)
             REPLY(WS-REPLY) MAXLENGTH(32)
             REPLYLENGTH(WS-REPLY-LEN)
             RESP(RC)
           END-EXEC.
      * should return RC=31=KIKRESP(EXPIRED) after 30 seconds
           DISPLAY WS-REPLY.
           DISPLAY WS-REPLY-LEN.
           DISPLAY RC.
           DISPLAY ' '.

           EXEC KICKS WRITE OPERATOR
             TEXT(WS-MSG3) TEXTLENGTH(32)
             REPLY(WS-REPLY) MAXLENGTH(32)
             REPLYLENGTH(WS-REPLY-LEN)
             TIMEOUT(120)
             RESP(RC)
           END-EXEC.
           DISPLAY WS-REPLY.
           DISPLAY WS-REPLY-LEN.
           DISPLAY RC.

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
//   PARM='SIT=B$ ICVR=0 '
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
TCOB<ENTER>
/*
//
