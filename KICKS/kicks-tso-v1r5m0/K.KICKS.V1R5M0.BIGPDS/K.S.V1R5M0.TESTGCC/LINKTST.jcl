//XFRAPI JOB CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=5000K
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

 //* EXEC KICKS LINK PROGRAM(name)
 //*       [COMMAREA(data-area) LENGTH(data-value)]
 //* ;
 //*
 //* EXEC CICS XCTL PROGRAM(name)
 //*       [COMMAREA(data-area) LENGTH(data-value)]
 //* ;
 //*
 //* EXEC KICKS RETURN
 //*       [TRANSID(name) [COMMAREA(data-area) LENGTH(data-value)]]
 //* ;
 //*
 //* EXEC KICKS HANDLE ABEND                         ** PRO only **
 //*       [ LABEL(label) | CANCEL ]
 //* ;

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

 int main (int argc, char *argv[]) {

      short WS_RESP=0;
      char  WS_COMM[16] ="                ";

           memset(WS_COMM, '1', 16);

     // FIRST TIME SHOULD LINK COB2, THEN XCTL COB3, THEN RETURN
     //    AND IT SHOULD SUCCEEED
           EXEC KICKS LINK PROGRAM("TESTCOB2")
             COMMAREA(WS_COMM) LENGTH(16)
             RESP(WS_RESP)
           ;

     // 2ND TIME SHOULD LINK COB3, WHICH DOES 'NOFILE' READ,
     //    WHICH FAILS CAUSING AEIL ABEND, WHICH IS 'CAUGHT'
     //    BY HANDLE ABEND.

<PRO>
     // SETUP ABEND CATCHER...
          EXEC KICKS HANDLE ABEND LABEL(CATCH_ABEND) ;
</PRO>

     // CALL THE GUY THAT WILL CRASH
           EXEC KICKS LINK PROGRAM("TESTCOB3")
             COMMAREA(WS_COMM) LENGTH(16)
             RESP(WS_RESP)
           ;

     // SHOULD NEVER GET HERE (abend in TESTCOB3 didn't happen?)
           printf("DIDNT CATCH AN ABEND...\n");
           EXEC KICKS RETURN ;

     // KICKS PRO should get here (abend caught)
       CATCH_ABEND:
           printf("CAUGHT ABEND...\n");
           EXEC KICKS RETURN ;

     // 'Golden' KICKS doesn't produce any message for an abend
     // because there is no HANDLE ABEND, so the task died
     // after TESTCOB3 abended
 }

/*
//LKED.SYSLMOD DD DSN=&&GOSET(TESTCOB),UNIT=SYSDA,
//     SPACE=(1024,(50,20,1)),DISP=(MOD,PASS)
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKGCCGL)
 ENTRY @@KSTRT
 NAME  TESTCOB(R)
/*
//TESTCOB2 EXEC PROC=KIKGCCCL,LBOUTC='*' (default is 'Z')
//COPY.SYSUT1 DD *

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

 typedef struct __mycomm__ {
     char something[16];
 } mycomm;

 int main(KIKEIB *eib, mycomm *KIKCOMM) {

        short WS_RESP=0;
        char  WS_COMM[16] ="                ";

           memcpy(WS_COMM, KIKCOMM, 16);
           memset(WS_COMM, '2', 16);

           EXEC KICKS XCTL PROGRAM("TESTCOB3")
             COMMAREA(WS_COMM) LENGTH(16)
             RESP(WS_RESP)
           ;

           EXEC KICKS RETURN ;
 }
/*
//LKED.SYSLMOD DD DSN=&&GOSET(TESTCOB),UNIT=SYSDA,
//     SPACE=(1024,(50,20,1)),DISP=(MOD,PASS)
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKGCCGL)
 ENTRY @@KSTRT
 NAME  TESTCOB2(R)
/*
//TESTCOB3 EXEC PROC=KIKGCCCL,LBOUTC='*' (default is 'Z')
//COPY.SYSUT1 DD *

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

 typedef struct __mycomm__ {
     char something[16];
 } mycomm;

 int main(KIKEIB *eib, mycomm *KIKCOMM) {

        short WS_RESP=0;
        char  WS_COMM[16] ="                ";
        char  WS_IOAREA[100];
        int   WS_IOAL=0;
        char  WS_KEY[10]="          ";

           memcpy(WS_COMM, KIKCOMM, 16);

           if (!memcmp(WS_COMM, "2222222222222222", 16))
               EXEC KICKS RETURN ;

           memset(WS_COMM, '3', 16);

           EXEC KICKS READ
               DATASET("NOFILE")
               INTO(WS_IOAREA)
               LENGTH(WS_IOAL)
               RIDFLD(WS_KEY)
               KEYLENGTH(10)
           ;

           EXEC KICKS RETURN ;
 }
/*
//LKED.SYSLMOD DD DSN=&&GOSET(TESTCOB),UNIT=SYSDA,
//     SPACE=(1024,(50,20,1)),DISP=(MOD,PASS)
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKGCCGL)
 ENTRY @@KSTRT
 NAME  TESTCOB3(R)
/*
//GO EXEC PGM=KIKSIP1$,COND=(4,LT),
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
