//SRTEXT  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=5000K
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

 //* EXEC KICKS SEND TEXT
 //*       FROM(data-area)
 //*       [LENGTH(data-area) | FLENGTH(data-area)]
 //*       [ERASE] [ALARM] [FREEKB] [ALTERNATE]
 //*       [CURSOR(data-value)]
 //* ;
 //*
 //* EXEC KICKS SEND CONTROL
 //*       [ERASE] [ALARM] [FREEKB] [ALTERNATE]
 //*       [ERASEAUP] [FRSET]
 //*       [CURSOR(data-value)]
 //* ;
 //*
 //* EXEC KICKS RECEIVE
 //*       [INTO(data-area)]
 //*       [LENGTH(data-area) | FLENGTH(data-area)]
 //*       [MAXLENGTH(data-value) | MAXFLENGTH(data-value)]
 //*       [ASIS] [BUFFER]
 //* ;
 //*
 //* -> RECEIVE does not support use of LENGTH or MAXLENGTH,
 //*    use FLENGTH and MAXFLENGTH instead...
 //*
 //* -> If a RECEIVE is issued purely to detect an AID, you can
 //*    omit the INTO (and the FLENGTH, and the MAXFLENGTH)...

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "kikaid.h"

 int main(KIKEIB *eib) {

 char WS_MSG1[42] ="PLEASE PRESS PF1 TO FINISH THIS PROGRAM...";
 char WS_MSG2[55] =
      "DONE. THANKS FOR PRESSING PF1. PRESS CLEAR TO CONTINUE.";
 short WS_MSG1_S=42;
 int   WS_MSG2_L=55;

        while (1) {

     // clear the screen using send control
           EXEC KICKS SEND CONTROL ERASE ;

     // write a message using send text
           EXEC KICKS SEND TEXT
                 FROM(WS_MSG1) LENGTH(WS_MSG1_S)
           ;

     // get a response (just the aid really) using receive
           EXEC KICKS RECEIVE NOHANDLE ;

     // if bad response
     //    - sound alarm using send control
     //    - loop back to 'clear screen' above
           if (eib->eibaid == KIKPF1) break;
           EXEC KICKS SEND CONTROL ALARM ;

        }

     // if good response
     //    - clear screen w/message & quit
           EXEC KICKS SEND TEXT
                 FROM(WS_MSG2) FLENGTH(WS_MSG2_L)
                 ERASE
           ;

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
TCOB<ENTER>
<PF2>
<PF1>
<CLEAR>
/*
//
