//ENQDEQ  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=5000K
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

 //* EXEC KICKS ENQ
 //*       RESOURCE(data-area)
 //*       [LENGTH(data-value)]
 //*       [LUW | UOW | TASK | MAXLIFETIME(data-area)]
 //*       [NOSUSPEND]
 //* ;
 //*
 //* EXEC KICKS DEQ
 //*       RESOURCE(data-area)
 //*       [LENGTH(data-value)]
 //*       [LUW | UOW | TASK | MAXLIFETIME(data-area)]
 //* ;

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

 int main(KIKEIB *eib) {

  char *ws_begin="TESTGCC  WORKING STORAGE";
  short ws_maxl=0;

      // enqueue then deque on above working storage text...

           EXEC KICKS ENQ RESOURCE(ws_begin) LENGTH(24) ;

           EXEC KICKS DEQ RESOURCE(ws_begin) LENGTH(24) ;

      // it's not an error to enqueue the same resource more than once
      // - but you must dequeue as many times as you enqueue...

           EXEC KICKS ENQ RESOURCE(ws_begin) ;

           EXEC KICKS ENQ RESOURCE(ws_begin) ;

           EXEC KICKS DEQ RESOURCE(ws_begin) ;

           EXEC KICKS DEQ RESOURCE(ws_begin) ;

      // it's not an error to dequeue something that is not enqueued

           EXEC KICKS DEQ RESOURCE(ws_begin) ;

      // Note that if, as above, resources are specified without length
      // then what is actually enqueued is the ADDRESS, and different
      // KICKS's won't have the same things at those addresses hence
      // enqueues across different KICKS's make no sense, so no MVS
      // enqueues (or dequeues) are done for such.
      //
      // However, as below, when length IS specified the enqueue is
      // based on the string value contents of the resource specified,
      // in this case 'TESTCOB  WORKING STORAGE', and MVS enqueues
      // (and dequeues) ARE done.

           EXEC KICKS ENQ RESOURCE(ws_begin) LENGTH(24) ;

           EXEC KICKS ENQ RESOURCE(ws_begin) LENGTH(24) ;

           EXEC KICKS DEQ RESOURCE(ws_begin) LENGTH(24) ;

           EXEC KICKS DEQ RESOURCE(ws_begin) LENGTH(24) ;

           EXEC KICKS DEQ RESOURCE(ws_begin) LENGTH(24) ;

      // An MVS enqueue may block (ie, another KICKS user might already
      // have the resource enqueued). When this happens KICKS will keep
      // trying to get the enqueue for up to the value set in the SIT
      // MAXDELY parameter (default 3 minutes). If it still can't get
      // the enqueue you'll get an abend resp=55, resp2=999. This is
      // probably different from what happens in your real CICS, which
      // by default will wait forever, but probably has a local exit
      // to do ??something?? else.

           EXEC KICKS ENQ RESOURCE(ws_begin) LENGTH(24)
                NOHANDLE ;
           if (eib->eibresp == 55)
                printf("Enqueue failed\n");
           else {
                printf("30 second wait to block someone...\n");
                EXEC KICKS DELAY INTERVAL(30) ;
                printf("Done blocking\n");
                EXEC KICKS DEQ RESOURCE(ws_begin) LENGTH(24) ;
            }

      // It's also possible to get control back immediately, whether
      // the enqueue was successful or not. Code NOSUSPEND to do this
      // and check EIBRESP for success...

           EXEC KICKS ENQ RESOURCE(ws_begin) LENGTH(24)
                NOSUSPEND ;
           if (eib->eibresp == 0) {
                printf("Nosuspend enq worked...\n");
                EXEC KICKS DEQ RESOURCE(ws_begin) LENGTH(24) ;
            }

      // A syncpoint releases enqueues with default LUW (aka UOW)
      // maxlifetime.

           EXEC KICKS ENQ RESOURCE(ws_begin) LENGTH(24) ;

           EXEC KICKS ENQ RESOURCE(ws_begin) LENGTH(24) ;

           EXEC KICKS SYNCPOINT ;

           EXEC KICKS DEQ RESOURCE(ws_begin) LENGTH(24) ;

      // Enqueues with maxlifetime TASK last beyond SYNCPOINT

           EXEC KICKS ENQ TASK RESOURCE(ws_begin) LENGTH(24) ;

           EXEC KICKS ENQ TASK RESOURCE(ws_begin) LENGTH(24) ;

           EXEC KICKS SYNCPOINT ;

           EXEC KICKS DEQ RESOURCE(ws_begin) LENGTH(24) ;

           EXEC KICKS DEQ RESOURCE(ws_begin) LENGTH(24) ;

      // maxlifetime can also be specified with a variable
      //   246 for LUW/UOW, 233 for TASK, or, better, use KIKVALUE

           ws_maxl = KIKVALUE(TASK);
           EXEC KICKS ENQ MAXLIFETIME(ws_maxl)
                RESOURCE(ws_begin) LENGTH(24) ;

      // No way to make an enqueue last past end of task. Run this
      // again and note first ENQ again starts at 0...

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
//AUXTRC   DD SYSOUT=*,DCB=(RECFM=V,BLKSIZE=2000)
//*
//SYSIN    DD DUMMY,DCB=(RECFM=F,BLKSIZE=80)
//*
//CRLPIN   DD *,DCB=BLKSIZE=80
KEDF ON<ENTER>
TCOB<ENTER>
TCOB<ENTER>
/*
//
