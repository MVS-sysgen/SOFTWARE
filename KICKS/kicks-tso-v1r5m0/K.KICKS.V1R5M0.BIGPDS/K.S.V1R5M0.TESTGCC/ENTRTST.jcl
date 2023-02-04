//ENTRTST JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=5000K
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

 //* EXEC KICKS ENTER
 //*       TRACENUM(data-value) | TRACEID(data-value)
 //*       [FROM(data-area) [FROMLENGTH(data-area)]]
 //*       [RESOURE(data-area)] [EXCEPTION]
 //* ;
 //* EXEC KICKS DUMP
 //*       DUMPCODE(data-value) | FROM(data-area)
 //*       [FLENGTH(data-value) | LENGTH(data-value)]
 //* ;

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

 typedef struct __mycomm__ {
     char something[80];
 } mycomm;

 int main(KIKEIB *eib, mycomm *KIKCOMM) {

     char  VARX[10] = "         ";
     char  DFHX[10] = "         ";

     // all(most) all args specified
            EXEC KICKS ENTER TRACEID(1)
             FROM(KIKCOMM)
             FROMLENGTH(80)
             EXCEPTION
            ;

     // tracenum instead
            EXEC KICKS ENTER TRACENUM(2)
             FROM(KIKCOMM)
             FROMLENGTH(80)
             EXCEPTION
            ;

     // fromlength with 'size of ..'
            EXEC KICKS ENTER TRACEID(5)
             FROM(KIKCOMM)
             FROMLENGTH(sizeof(VARX))
             EXCEPTION
            ;

     // fromlength omitted
            EXEC KICKS ENTER TRACEID(6)
             FROM(KIKCOMM)
             EXCEPTION
            ;

     // from as literal, no length
            EXEC KICKS ENTER TRACEID(7)
             FROM("hello world")
             EXCEPTION
            ;

     // dump to show results
            EXEC KICKS DUMP DUMPCODE("ASDF") ;

     // dump to show just var4
            EXEC KICKS DUMP FROM(VARX) ;

     // dump to show first 100 bytes of ws
            EXEC KICKS DUMP FROM(VARX) LENGTH(100) ;

     // return to KICKS

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
