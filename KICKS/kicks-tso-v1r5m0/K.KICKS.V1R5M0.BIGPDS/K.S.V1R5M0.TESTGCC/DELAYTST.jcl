//DELAYTST  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=5000K
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

 //* EXEC KICKS DELAY
 //*      [INTERVAL(hhmmss) |
 //*       TIME(hhmmss) |
 //*       FOR [HOURS(hh)] [MINUTES(mm)] [SECONDS(ss)] |
 //*       UNTIL [HOURS(hh)] [MINUTES(mm)] [SECONDS(ss)]]
 //* ;

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

 // routine to convert packed to binary
 // -- needed because gcc does not support
 // -- mainframe packed (aka comp-3) data.
 int CVB(char *packed, int size) {
  int p1=0, p2=0, b; char *pc=(char*)&p1;
  /* validate size passed */
  if (size < 1) return 0;
  if (size > 8) return 0;
  /* copy packed to double word for cvb */
  for (b=size, pc +=7, packed +=size-1; b>0; b--, pc--, packed--)
      *pc = *packed;
  /* inline asm to cvb, move result to b */
    __asm__ (
   "CVB 0,%1\n\t"
   "ST 0,%0"
   : "=m"(b)
   : "m"(p1)
   : "0"
   );
 return b;
 }

 int main(KIKEIB *eib) {

 int WS_BIN_DELAY, WS_EIBTIME, WS_HH, WS_MM, WS_SS;
 short RC;

     //
     // first a set of absolute delays
     //

     //    10 second delay
           EXEC KICKS DELAY INTERVAL(10) RESP(RC) ;

     //    10 second delay
           WS_BIN_DELAY = 10;
           EXEC KICKS DELAY INTERVAL(WS_BIN_DELAY) RESP(RC) ;

     //    1 minute (not 100 second) delay (hhmmss)
     //    in COBOL hhmmss for 100 secs is 000100, but
     //    it can't be expressed that way in C because
     //    the leading 0(s) would cause it to be octal.
           EXEC KICKS DELAY INTERVAL(100) RESP(RC) ;

     //    5 minute delay - should fail as KICKS rejects > 3 minutes
           EXEC KICKS DELAY INTERVAL(500) RESP(RC) ;

     //    10 second delay
           EXEC KICKS DELAY FOR SECONDS(10) RESP(RC) ;

     //    1 minute 10 second delay
           EXEC KICKS DELAY
             FOR MINUTES(1) SECONDS(10) RESP(RC)
           ;

     //    1 hour 1 minute 10 second delay - should fail
           EXEC KICKS DELAY
             FOR HOURS(1) MINUTES(1) SECONDS(10) RESP(RC)
           ;

     //
     // now a set of relative delays -- wait until a certain
     // time, meaning how long you wait depends on what time
     // it is when you do the EXEX KICKS...
     //

     //    wait until 12:01 am - probably fails 'expired'
           EXEC KICKS DELAY TIME(000001) RESP(RC) ;

     //    wait until 11:59 pm - probably fails 'invreq'
           EXEC KICKS DELAY
             UNTIL HOURS(23) MINUTES(59) SECONDS(0) RESP(RC)
           ;

     //    get current time (ASKTIME wo/ABSTIME just updates EIB)
           EXEC KICKS ASKTIME ;

     //    compute a time 30 seconds from now and wait for it
        /* WS_BIN_DELAY = EIBTIME + 30; won't work - no packed... */
           WS_EIBTIME = CVB((char*)&eib->eibtime, 4);
           WS_BIN_DELAY = WS_EIBTIME + 30;
           EXEC KICKS DELAY TIME(WS_BIN_DELAY) RESP(RC) ;

     //    compute a time 30 seconds from now and wait for it
           EXEC KICKS ASKTIME ;
           WS_EIBTIME = CVB((char*)&eib->eibtime, 4);
           WS_BIN_DELAY = WS_EIBTIME + 30;
           WS_HH = WS_BIN_DELAY / 10000;
           WS_BIN_DELAY -= 10000 * WS_HH;
           WS_MM = WS_BIN_DELAY / 100;
           WS_SS = WS_BIN_DELAY - (100 * WS_MM);
           EXEC KICKS DELAY
             UNTIL HOURS(WS_HH) MINUTES(WS_MM) SECONDS(WS_SS)
             RESP(RC)
           ;

     //    done now...
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
