//ASSADRTS JOB CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=5000K
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

 //*  EXEC KICKS ADDRESS COMMAREA(DATA-AREA) ;
 //*  EXEC KICKS ADDRESS CWA(DATA-AREA) ;
 //*  EXEC KICKS ADDRESS EIB(DATA-AREA) ;
 //*  EXEC KICKS ADDRESS TCTUA(DATA-AREA) ;
 //*  EXEC KICKS ADDRESS TWA(DATA-AREA) ;
 //*
 //*  EXEC KICKS ASSIGN ALTSCRNHT(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN ALTSCRNWD(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN COLOR(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN CWALENG(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN DEFSCRNHT(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN DEFSCRNWD(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN EWASUPP(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN EXTDS(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN FACILITY(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN FCI(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN HILIGHT(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN LANGINUSE(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN NATLANGINUSE(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN NETNAME(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN OPID(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN PARTNS(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN PROGRAM(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN PS(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN SCRNHT(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN SCRNWD(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN SYSID(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN TCTUALENG(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN TERMCODE(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN TWALENG(DATA-AREA) ;
 //*  EXEC KICKS ASSIGN USERID(DATA-AREA) ;

#include <stdio.h>

 int main(KIKEIB *eib) {

     char *WS_COMMAREA = NULL;
     char *WS_CWA      = NULL;
     char *WS_EIB      = NULL;
     char *WS_TCTUA    = NULL;
     char *WS_TWA      = NULL;
    short  WS_ALTSCRNHT= 0;
    short  WS_ALTSCRNWD= 0;
     char  WS_COLOR    = 0;
    short  WS_CWALENG  = 0;
    short  WS_DEFSCRNHT= 0;
    short  WS_DEFSCRNWD= 0;
     char  WS_EWASUPP  = 0;
     char  WS_EXTDS    = 0;
     char  WS_FACILITY[4] = {0,0,0,0};
     char  WS_FCI      = 0;
     char  WS_HILIGHT  = 0;
     char  WS_LANGINUSE[3] = {0,0,0};
     char  WS_NATLANGINUSE = 0;
     char  WS_NETNAME[8] = {0,0,0,0,0,0,0,0};
     char  WS_OPID[3]  = {0,0,0};
     char  WS_PARTNS   =0;
     char  WS_PROGRAM[8] = {0,0,0,0,0,0,0,0};
     char  WS_PS       =0;
    short  WS_SCRNHT   = 0;
    short  WS_SCRNWD   = 0;
     char  WS_SYSID[8]   = {0,0,0,0,0,0,0,0};
    short  WS_TCTUALENG= 0;
    short  WS_TERMCODE = 0;
    short  WS_TWALENG  = 0;
     char  WS_USERID[8]  = {0,0,0,0,0,0,0,0};
    short  WS_TIOASIZE = 0;

           EXEC KICKS ADDRESS COMMAREA(WS_COMMAREA) ;
           EXEC KICKS ADDRESS CWA(WS_CWA) ;
     // NOTE - CICS supports address eib, but use makes
     //        little sense since the EIB is **usually**
     //        available in a command level program...
     // ALSO - the size of these data areas (expect EIB)
     //        is variable, so you should use only the
     //        the storage within what assign(xxxLENG)
     //        says is allocated to the area of interest.
           EXEC KICKS ADDRESS EIB(WS_EIB) ;
           EXEC KICKS ADDRESS TCTUA(WS_TCTUA) ;
           EXEC KICKS ADDRESS TWA(WS_TWA) ;

           EXEC KICKS ASSIGN ALTSCRNHT(WS_ALTSCRNHT) ;
           EXEC KICKS ASSIGN ALTSCRNWD(WS_ALTSCRNWD) ;
           EXEC KICKS ASSIGN COLOR(WS_COLOR) ;
           EXEC KICKS ASSIGN CWALENG(WS_CWALENG) ;
           EXEC KICKS ASSIGN DEFSCRNHT(WS_DEFSCRNHT) ;
           EXEC KICKS ASSIGN DEFSCRNWD(WS_DEFSCRNWD) ;
           EXEC KICKS ASSIGN EWASUPP(WS_EWASUPP) ;
           EXEC KICKS ASSIGN EXTDS(WS_EXTDS) ;
           EXEC KICKS ASSIGN FACILITY(WS_FACILITY) ;
           EXEC KICKS ASSIGN FCI(WS_FCI) ;
           EXEC KICKS ASSIGN HILIGHT(WS_HILIGHT) ;
           EXEC KICKS ASSIGN LANGINUSE(WS_LANGINUSE) ;
           EXEC KICKS ASSIGN NATLANGINUSE(WS_NATLANGINUSE) ;
           EXEC KICKS ASSIGN NETNAME(WS_NETNAME) ;
           EXEC KICKS ASSIGN OPID(WS_OPID) ;
           EXEC KICKS ASSIGN PARTNS(WS_PARTNS) ;
           EXEC KICKS ASSIGN PROGRAM(WS_PROGRAM) ;
           EXEC KICKS ASSIGN PS(WS_PS) ;
           EXEC KICKS ASSIGN SCRNHT(WS_SCRNHT) ;
           EXEC KICKS ASSIGN SCRNWD(WS_SCRNWD) ;
           EXEC KICKS ASSIGN SYSID(WS_SYSID) ;
           EXEC KICKS ASSIGN TCTUALENG(WS_TCTUALENG) ;
           EXEC KICKS ASSIGN TERMCODE(WS_TERMCODE) ;
           EXEC KICKS ASSIGN TWALENG(WS_TWALENG) ;
           EXEC KICKS ASSIGN USERID(WS_USERID) ;

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
//SYSO     DD DUMMY,DCB=(RECFM=F,BLKSIZE=132)
//SYSI     DD DUMMY,DCB=(RECFM=F,BLKSIZE=132)
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
