//XFRAPI JOB CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=2000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//TESTCOB EXEC PROC=K2KCOBCL       KIKCB2CL for z/os
//COPY.SYSUT1 DD *
       ID DIVISION.
       PROGRAM-ID. TESTCOB.

      *///////////////////////////////////////////////////////////////
      * KICKS is an enhancement for TSO that lets you run your CICS
      * applications directly in TSO instead of having to 'install'
      * those apps in CICS.
      * You don't even need CICS itself installed on your machine!
      *
      * KICKS for TSO
      * © Copyright 2008-2014, Michael Noel, All Rights Reserved.
      *
      * Usage of 'KICKS for TSO' is in all cases subject to license.
      * See http://www.kicksfortso.com
      * for most current information regarding licensing options.
      *//1/////////2/////////3/////////4/////////5/////////6/////////7

      * EXEC KICKS LINK PROGRAM(name)
      *       [COMMAREA(data-area) LENGTH(data-value)]
      * END-EXEC.
      *
      * EXEC CICS XCTL PROGRAM(name)
      *       [COMMAREA(data-area) LENGTH(data-value)]
      * END-EXEC.
      *
      * EXEC KICKS RETURN
      *       [TRANSID(name) [COMMAREA(data-area) LENGTH(data-value)]]
      * END-EXEC.
      *
      * EXEC KICKS HANDLE ABEND                       ** PRO only **
      *       [ LABEL(label) | CANCEL ]
      * END-EXEC.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN  PIC X(24)  VALUE 'TESTCOB  WORKING STORAGE'.
       77  WS-RESP   PIC S9(4)  VALUE +0.
       77  WS-COMM   PIC X(16)  VALUE SPACES.

       PROCEDURE DIVISION.

           MOVE ALL '1' TO WS-COMM.

      * FIRST TIME SHOULD LINK COB2, THEN XCTL COB3, THEN RETURN
      *    AND IT SHOULD SUCCEEED
           EXEC KICKS LINK PROGRAM('TESTCOB2')
             COMMAREA(WS-COMM) LENGTH(16)
             RESP(WS-RESP)
           END-EXEC.

      * 2ND TIME SHOULD LINK COB3, WHICH DOES 'NOFILE' READ,
      *    WHICH FAILS CAUSING AEIL ABEND, WHICH IS 'CAUGHT'
      *    BY HANDLE ABEND.

<PRO>
      * SETUP ABEND CATCHER...
          EXEC KICKS HANDLE ABEND LABEL(CATCH-ABEND) END-EXEC.
</PRO>

      * CALL THE GUY THAT WILL CRASH
           EXEC KICKS LINK PROGRAM('TESTCOB3')
             COMMAREA(WS-COMM) LENGTH(16)
             RESP(WS-RESP)
           END-EXEC.

      * SHOULD NEVER GET HERE  (abend in TESTCOB3 didn't happen?)
           DISPLAY 'DIDNT CATCH ABEND...'.
           EXEC KICKS RETURN END-EXEC.

      * KICKS PRO should get here (abend caught)
       CATCH-ABEND.
           DISPLAY 'CAUGHT ABEND...'.
           EXEC KICKS RETURN END-EXEC.

      * 'Golden' KICKS doesn't produce any message for an abend
      * because there is no  HANDLE ABEND, so the task died
      * after TESTCOB3 abended

/*
//LKED.SYSLMOD DD DSN=&&GOSET(TESTCOB),UNIT=SYSDA,
//     SPACE=(1024,(50,20,1)),DISP=(MOD,PASS)
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKCOBGL)
 ENTRY TESTCOB
 NAME  TESTCOB(R)
/*
//TESTCOB2 EXEC PROC=K2KCOBCL       KIKCB2CL for z/os
//COPY.SYSUT1 DD *
       ID DIVISION.
       PROGRAM-ID. TESTCOB2.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN  PIC X(24)  VALUE 'TESTCOB2 WORKING STORAGE'.
       77  WS-RESP   PIC S9(4)  VALUE +0.
       77  WS-COMM   PIC X(16)  VALUE SPACES.

       LINKAGE SECTION.
       01  KIKCOMMAREA          PIC X(16).

       PROCEDURE DIVISION.

           MOVE KIKCOMMAREA TO WS-COMM.
           MOVE ALL '2' TO WS-COMM.

           EXEC KICKS XCTL PROGRAM('TESTCOB3')
             COMMAREA(WS-COMM) LENGTH(16)
             RESP(WS-RESP)
           END-EXEC.

           EXEC KICKS RETURN END-EXEC.
/*
//LKED.SYSLMOD DD DSN=&&GOSET(TESTCOB),UNIT=SYSDA,
//     SPACE=(1024,(50,20,1)),DISP=(MOD,PASS)
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKCOBGL)
 ENTRY TESTCOB2
 NAME  TESTCOB2(R)
/*
//TESTCOB3 EXEC PROC=K2KCOBCL       KIKCB2CL for z/os
//COPY.SYSUT1 DD *
       ID DIVISION.
       PROGRAM-ID. TESTCOB3.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN  PIC X(24)  VALUE 'TESTCOB3 WORKING STORAGE'.
       77  WS-RESP   PIC S9(4)  VALUE +0.
       77  WS-COMM   PIC X(16)  VALUE SPACES.
       77  WS-IOAREA PIC X(100) VALUE SPACES.
       77  WS-IOAL   PIC S9(8)  VALUE +0 COMP.
       77  WS-KEY    PIC X(10)  VALUE SPACES.

       LINKAGE SECTION.
       01  KIKCOMMAREA          PIC X(16).

       PROCEDURE DIVISION.

           MOVE KIKCOMMAREA TO WS-COMM.

           IF WS-COMM = ALL '2'
               EXEC KICKS RETURN END-EXEC.

           MOVE ALL '3' TO WS-COMM.

           EXEC KICKS READ
               DATASET('NOFILE')
               INTO(WS-IOAREA)
               LENGTH(WS-IOAL)
               RIDFLD(WS-KEY)
               KEYLENGTH(10)
           END-EXEC.

           EXEC KICKS RETURN END-EXEC.
/*
//LKED.SYSLMOD DD DSN=&&GOSET(TESTCOB),UNIT=SYSDA,
//     SPACE=(1024,(50,20,1)),DISP=(MOD,PASS)
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKCOBGL)
 ENTRY TESTCOB3
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
KSMT<ENTER>
<PF4>
<PF4>
<PF12>
<CLEAR>
TCOB<ENTER>
/*
//
