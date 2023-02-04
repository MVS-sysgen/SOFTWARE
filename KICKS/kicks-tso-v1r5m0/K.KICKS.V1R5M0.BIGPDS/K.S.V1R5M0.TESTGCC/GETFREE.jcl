//GETFREE  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=5000K
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

 //* EXEC KICKS GETMAIN
 //*      SET(pointer-ref)
 //*      { LENGTH(data-value) | FLENGTH(data-value) [BELOW] }
 //*      [INITIMG(data-value)]
 //*      [NOSUSPEND] [SHARED] {USERKEY | CICSKEY}]
 //* ;
 //*
 //* EXEC KICKS FREEMAIN
 //*      { DATA(data-area) | DATAPOINTER(pointer-ref) }
 //* ;

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

 int main(KIKEIB *eib) {

  char *ws_begin="TESTGCC  WORKING STORAGE";
  char *ws_set, ws_low=0x00, ws_high=0xff, ws_space=' ';
  int i;

  struct {
   char s1_1[1000];
   char filler[3000];
   char s1_lots[1000];
   char s1_more[1000];
   } *stor1;

      // plain old getmain...
           EXEC KICKS GETMAIN SET(ws_set) FLENGTH(2400) ;
      // NOSTG condition does not result in abend, must test...
           if (eib->eibresp != KIKRESP(NORMAL)) {
               printf("bad getmain 1\n");
               EXEC KICKS ABEND ABCODE("GETM") ;
               }

      // getmain initializing gotten storage to high values...
           EXEC KICKS GETMAIN SET(ws_set) FLENGTH(240)
                INITIMG(&ws_high) ;
           if (eib->eibresp != KIKRESP(NORMAL)) {
               printf("bad getmain 2\n");
               EXEC KICKS ABEND ABCODE("GETM") ;
               }

     // getmain obtaining storage that is 'shared' - meaning it
     // does not automatically go away at task end - must be
     // explicitly freed.
           EXEC KICKS GETMAIN SET(ws_set) LENGTH(240)
                INITIMG(&ws_low) SHARED ;
           if (eib->eibresp != KIKRESP(NORMAL)) {
               printf("bad getmain 3\n");
               EXEC KICKS ABEND ABCODE("GETM") ;
               }

     // freemain the above 'shared' storage
           EXEC KICKS FREEMAIN DATAPOINTER(ws_set) ;

     // getmain for STOR1 item
           EXEC KICKS GETMAIN SET(ws_set) FLENGTH(6000)
                INITIMG(&ws_space) ;
           if (eib->eibresp != KIKRESP(NORMAL)) {
               printf("bad getmain 4\n");
               EXEC KICKS ABEND ABCODE("GETM") ;
               }

           stor1 = ws_set;
           memset(stor1->s1_1, '1', 1000);
           memset(stor1->s1_lots, 'L', 1000);
           memset(stor1->s1_more, 'M', 1000);
           for (i=0; i<60; i++) {
            printf("%100.100s\n", stor1);
            (char*)stor1 += 100;
            }
           stor1 = ws_set;

     // freemain the 'STOR1' storage by data (instead of pointer)
     //    EXEC KICKS FREEMAIN DATAPOINTER(ws_set) ;
           EXEC KICKS FREEMAIN DATA(stor1->s1_1) ;

           EXEC KICKS RETURN ;

     // note we are stopping without ever freemain'ing the first
     // two pieces of storage we got. that's OK, since those were
     // not acquired 'SHARED', so KICKS will freemain them when
     // this task ends (the above RETURN).
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
/*
//
