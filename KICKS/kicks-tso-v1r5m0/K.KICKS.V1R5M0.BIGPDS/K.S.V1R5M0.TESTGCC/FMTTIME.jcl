//FMTTIME  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=5000K
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

 //* EXEC KICKS FORMATTIME ABSTIME(data-value)
 //*       [YYDDD(data-area)]  [YYYYDDD(data-area)]
 //*       [YYMMDD(data-area)] [YYYYMMDD(data-area)]
 //*       [YYDDMM(data-area)] [YYYYDDMM(data-area)]
 //*       [DDMMYY(data-area)] [DDMMYYYY(data-area)]
 //*       [MMDDYY(data-area)] [MMDDYYYY(data-area)]
 //*       [DAYCOUNT(data-area)]
 //*       [DAYOFWEEK(data-area)]
 //*       [DAYOFMONTH(data-area)]
 //*       [MONTHOFYEAR(data-area)]
 //*       [YEAR(data-area)]
 //*       [DATESEP(data-value)]
 //*       [TIME(data-area)
 //*       [TIMESEP(data-value)]
 //* END-EXEC.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

 int main(KIKEIB *eib) {

 char WS_ABSTIME[8];
 char WS_FMTTIME[8];
 char WS_FMTDATE[20], WS_BLANK=' ';
 int  WS_BIN;
 short RC;

           EXEC KICKS ASKTIME ABSTIME(WS_ABSTIME) ;

           memset(WS_FMTTIME, ' ', 8);
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             TIME(WS_FMTTIME)
           ;
           printf("%8.8s\n", WS_FMTTIME);

           memset(WS_FMTTIME, ' ', 8);
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             TIME(WS_FMTTIME) TIMESEP(":")
           ;
           printf("%8.8s\n", WS_FMTTIME);

           memset(WS_FMTDATE, ' ', 20);
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             YYDDD(WS_FMTDATE)
           ;
           printf("%20.20s\n", WS_FMTDATE);

           memset(WS_FMTDATE, ' ', 20);
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             YYDDD(WS_FMTDATE) DATESEP("-")
           ;
           printf("%20.20s\n", WS_FMTDATE);

           memset(WS_FMTDATE, ' ', 20);
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             YYYYDDD(WS_FMTDATE) DATESEP("-")
           ;
           printf("%20.20s\n", WS_FMTDATE);

           memset(WS_FMTDATE, ' ', 20);
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             YYMMDD(WS_FMTDATE) DATESEP("/")
           ;
           printf("%20.20s\n", WS_FMTDATE);

           memset(WS_FMTDATE, ' ', 20);
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             YYYYMMDD(WS_FMTDATE) DATESEP("/")
           ;
           printf("%20.20s\n", WS_FMTDATE);

           memset(WS_FMTDATE, ' ', 20);
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             YYDDMM(WS_FMTDATE) DATESEP("/")
           ;
           printf("%20.20s\n", WS_FMTDATE);

           memset(WS_FMTDATE, ' ', 20);
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             YYYYDDMM(WS_FMTDATE) DATESEP("/")
           ;
           printf("%20.20s\n", WS_FMTDATE);

           memset(WS_FMTDATE, ' ', 20);
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             DDMMYY(WS_FMTDATE) DATESEP("/")
           ;
           printf("%20.20s\n", WS_FMTDATE);

           memset(WS_FMTDATE, ' ', 20);
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             DDMMYYYY(WS_FMTDATE) DATESEP("/")
           ;
           printf("%20.20s\n", WS_FMTDATE);

           memset(WS_FMTDATE, ' ', 20);
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             MMDDYY(WS_FMTDATE) DATESEP(&WS_BLANK)
           ;
           printf("%20.20s\n", WS_FMTDATE);

           memset(WS_FMTDATE, ' ', 20);
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             MMDDYYYY(WS_FMTDATE) DATESEP(&WS_BLANK)
           ;
           printf("%20.20s\n", WS_FMTDATE);

           WS_BIN = 0;
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             DAYCOUNT(WS_BIN)
           ;
           printf("%d\n", WS_BIN);

           WS_BIN = 0;
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             DAYOFWEEK(WS_BIN)
           ;
           printf("%d\n", WS_BIN);

           WS_BIN = 0;
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             DAYOFMONTH(WS_BIN)
           ;
           printf("%d\n", WS_BIN);

           WS_BIN = 0;
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             MONTHOFYEAR(WS_BIN)
           ;
           printf("%d\n", WS_BIN);

           WS_BIN = 0;
           EXEC KICKS FORMATTIME ABSTIME(WS_ABSTIME)
             YEAR(WS_BIN)
           ;
           printf("%d\n", WS_BIN);

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

