//WTOTST  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=5000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//TESTCOB EXEC  PROC=KIKGCCCL,LBOUTC='*' (default is 'Z')
//COPY.SYSUT1 DD *
 /////////////////////////////////////////////////////////////////////
 //   KICKS is an enhancement for TSO that lets you run your CICS
 //   applications directly in TSO instead of having to 'install'
 //   those apps in CICS.
 //   You don't even need CICS itself installed on your machine!
 //
 //   KICKS for TSO
 //   © Copyright 2008-2014, Michael Noel, All Rights Reserved.
 //
 //   Usage of 'KICKS for TSO' is in all cases subject to license.
 //   See http://www.kicksfortso.com
 //   for most current information regarding licensing options..
 ////////1/////////2/////////3/////////4/////////5/////////6/////////7

 //* EXEC KICKS WRITE OPERATOR
 //*       TEXT(data-area) [TEXTLENGTH(data-value)]
 //*       [ROUTECODES(data-area) [NUMROUTES)data-value)]]
 //*       [ACTION(data-value) | EVENTUAL | IMMEDIATE | CRITICAL]
 //*       [REPLY(data-area) MAXLENGTH(data-value)
 //*        REPLYLENGTH(data-area) [TIMEOUT(data-value)]]
 //* ;

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

 int main(KIKEIB *eib) {

 char WS_MSG1[32] ="KICKS WRITE OPERATOR TEST       ";
 char WS_MSG2[32] ="Please do NOT reply to this msg ";
 char WS_MSG3[32] ="Please DO reply to this msg ASAP";
 char WS_REPLY[32];
 int  WS_REPLY_LEN=0;
 short RC=0;

           EXEC KICKS WRITE OPERATOR
             TEXT(WS_MSG1) TEXTLENGTH(25)
           ;

     // I guess it's obvious, but remember that asking for a reply
     // makes your program conversational, so any files you've been
     // using are unavailable to others while you're waiting for
     // the operator to reply.
     //
     // If possible (ie, your code really is between logical units
     // of work) declare a SYNCPOINT before waiting for a reply.
     // This will release files you've used so others can access
     // them while you wait for the reply.

           EXEC KICKS SYNCPOINT ;

     // should return RC=31=KIKRESP(EXPIRED) after 30 seconds
     // when the operator does not reply (as instructed)
           memset(WS_REPLY, ' ', 32);
           EXEC KICKS WRITE OPERATOR
             TEXT(WS_MSG2) TEXTLENGTH(31)
             REPLY(WS_REPLY) MAXLENGTH(32)
             REPLYLENGTH(WS_REPLY_LEN)
             RESP(RC)
           ;

           printf("%32.32s\n", WS_REPLY);
           printf("%d\n", WS_REPLY_LEN);
           printf("%d\n\n", RC);

     // should return RC=0 when operator does reply
           memset(WS_REPLY, ' ', 32);
           EXEC KICKS WRITE OPERATOR
             TEXT(WS_MSG3) TEXTLENGTH(32)
             REPLY(WS_REPLY) MAXLENGTH(32)
             REPLYLENGTH(WS_REPLY_LEN)
             TIMEOUT(120)
             RESP(RC)
           ;

           printf("%32.32s\n", WS_REPLY);
           printf("%d\n", WS_REPLY_LEN);
           printf("%d\n\n", RC);

           EXEC KICKS RETURN ;
 }
/*
//LKED.SYSLMOD DD DSN=&&GOSET(TESTCOB),UNIT=SYSDA,
//     SPACE=(1024,(50,20,1)),DISP=(MOD,PASS)
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKGCCGL)
 ENTRY @@KSTRT
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
