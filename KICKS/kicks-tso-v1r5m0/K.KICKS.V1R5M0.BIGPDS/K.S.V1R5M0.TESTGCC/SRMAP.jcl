//SRMAP   JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=5000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//TESTMSD EXEC KIKMAPS,MAPNAME=TESTMSD
//COPY.SYSUT1 DD *
TESTMSD  KIKMSD MODE=INOUT,CTRL=(FREEKB,FRSET),STORAGE=AUTO
*
TESTM24  KIKMDI SIZE=(24,80)
         KIKMDF POS=(10,25),LENGTH=32,                                 *
               INITIAL='Test map (24) for SRMAP API demo'
         KIKMDF POS=(13,30),LENGTH=14,                                 *
               INITIAL='Numeric field '
NUM24    KIKMDF POS=(13,45),LENGTH=6,ATTRB=(NUM,IC,FSET)
         KIKMDF POS=(15,30),LENGTH=14,                                 *
               INITIAL='  Alpha field '
ALPHA24  KIKMDF POS=(15,45),LENGTH=6,ATTRB=(FSET)
ERR24    KIKMDF POS=(23,30),LENGTH=20,INITIAL=''
*
TESTM43  KIKMDI SIZE=(43,80)
         KIKMDF POS=(22,25),LENGTH=32,                                 *
               INITIAL='Test map (43) for SRMAP API demo'
         KIKMDF POS=(25,30),LENGTH=14,                                 *
               INITIAL='Numeric field '
NUM43    KIKMDF POS=(25,45),LENGTH=6,ATTRB=(NUM,IC,FSET)
         KIKMDF POS=(27,30),LENGTH=14,                                 *
               INITIAL='  Alpha field '
ALPHA43  KIKMDF POS=(27,45),LENGTH=6,ATTRB=(FSET)
ERR43    KIKMDF POS=(42,30),LENGTH=20,INITIAL=''
*
         KIKMSD TYPE=FINAL
         END
/*
//LINKMAP.SYSLMOD DD DSN=&&GOSET(&MAPNAME),DISP=(,PASS),UNIT=SYSDA,
// SPACE=(1024,(50,20,5))
//COBMAP.SYSPRINT DD DUMMY,DCB=BLKSIZE=80
//GCCMAP.SYSPRINT DD DSN=&&GCCLIB(&MAPNAME),DISP=(,PASS),UNIT=SYSDA,
// SPACE=(CYL,(1,1,10)),DCB=(RECFM=VB,LRECL=160,BLKSIZE=3120)
//*
//TESTCOB EXEC  PROC=KIKGCCCL,LBOUTC='*',  (default is 'Z')
//        COND=(5,LE,TESTMSD.LINKMAP)
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

 //* EXEC KICKS SEND MAP(name) MAPSET(name)
 //*       [FROM(data-area)]
 //*       [ERASEAUP] [ERASE] [ALARM] [FREEKB] [FRSET]
 //*       [MAPONLY] [DATAONLY]
 //*       [ALTERNATE] [DEFAULT]
 //*       [CURSOR(data-value)]
 //* ;
 //*
 //* EXEC KICKS RECEIVE MAP(name) MAPSET(name)
 //*       [INTO(data-area)]
 //*       [ASIS]
 //* ;

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "testmsd.h"
#include "kikaid.h"

 int main(KIKEIB *eib) {

     int  WS_ERRCNT=0;

     // initialize map storage
       memset(&testm24.testm24o, 0, sizeof(testm24.testm24o));

       while (1) {

     // Note that even thou the mapset defines two maps - one
     // with 24 lines, the other with 43 - this program is run
     // in batch under the sequential terminal (CRLP) so only
     // the 24 line version is applicable...

     // Put another way, the CRLP's primary and alternate
     // screen sizes are the same, both 24x80...

     // send initial map, then clear err msg (whole map really)
           EXEC KICKS SEND
                 MAP("TESTM24") MAPSET("TESTMSD")
                 FROM(testm24.testm24o)
                 ERASE
           ;
           memset(&testm24.testm24o, 0, sizeof(testm24.testm24o));

     // get a response
     //  - don't need to clear input area as it overlays
     //  -       the output area cleared just above...
           EXEC KICKS RECEIVE
                 MAP("TESTM24") MAPSET("TESTMSD")
                 INTO(testm24.testm24i)
                 ASIS NOHANDLE
           ;

     // if bad response
     //    - sound alarm using send control
     //    - loop back to send err msg & re-read (up to 5 times)
           if (eib->eibresp != DFHRESP(NORMAL)) {
               EXEC KICKS SEND CONTROL ALARM ;
               memcpy(testm24.testm24o.err24o,
                      "BAD RESPONSE        ", 20);
               WS_ERRCNT++;
               if (WS_ERRCNT < 5) continue;
               }
           break;

           }

     // if good response
     //    - send screen with input back so visible on crlp...
           EXEC KICKS SEND
                 MAP("TESTM24") MAPSET("TESTMSD")
                 FROM(testm24.testm24o)
                 ERASE
           ;

           EXEC KICKS RETURN ;
    }
/*
//COMP.INCLUDE DD
//             DD
//             DD DSN=&&GCCLIB,DISP=(OLD,PASS)
//LKED.SYSLMOD DD DSN=&&GOSET(TESTCOB),UNIT=SYSDA,
//     DISP=(MOD,PASS)
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
TCOB<ENTER>
999<TAB>
AAA<ENTER>
/*
//
