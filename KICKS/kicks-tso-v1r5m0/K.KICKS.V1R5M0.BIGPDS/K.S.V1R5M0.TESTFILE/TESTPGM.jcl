//TESTPGM JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=7000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//TESTPGM EXEC  PROC=K2KCOBCL
//COPY.SYSUT1 DD *
       ID DIVISION.
       PROGRAM-ID. TESTPGM.

      *///////////////////////////////////////////////////////////////
      * 'KICKS for TSO' is a product to deliver 'CICS like'
      * functionality in MVS/TSO. CICS functionality is delivered
      * at the source code level, not at the object code level.
      * Applications must be recompiled and the recompiled programs
      * are not compatible with any known version of 'real' CICS.
      *
      * 'KICKS for TSO'
      * © Copyright 2008-2014, Michael Noel, All Rights Reserved.
      *
      * Usage of 'KICKS for TSO' is in all cases subject to license.
      * See http://www.kicksfortso.com
      * for most current information regarding licensing options.
      *//1/////////2/////////3/////////4/////////5/////////6/////////7

      * test harness for use with cedf
      * vsam test suite menu

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN   PIC X(23) VALUE 'TESTPGM WORKING STORAGE'.
       77  AID77      PIC X VALUE SPACE.
       77  HOME       PIC S9(8) COMP VALUE +0.

       01  BAD-PF-MSG PIC X(8)  VALUE 'BAD PF  '.
       01  DONE-MSG   PIC X(8)  VALUE 'DONE    '.
       01  DONE-LOG.
           05  DONE-LOG-PGM PIC X(8).
           05  FILLER       PIC X(4) VALUE 'DONE'.
       01  PF-MSG.
         02  PF-MSG0  PIC X(79) VALUE 'VSAM test suite (use w/KEDF)'.
         02  PF-MSG1.
           05  FILLER PIC X(19) VALUE 'PF1 - browse KSDS  '.
           05  FILLER PIC X(20) VALUE 'PF2 - browse KSDS/P'.
           05  FILLER PIC X(20) VALUE 'PF3 - browse ESDS  '.
           05  FILLER PIC X(19) VALUE 'PF4 - browse ESDS/P'.
           05  FILLER PIC X(1)  VALUE ' '.
         02  PF-MSG2.
           05  FILLER PIC X(19) VALUE 'PF5 - direct KSDS  '.
           05  FILLER PIC X(20) VALUE 'PF6 - direct KSDS/P'.
           05  FILLER PIC X(20) VALUE 'PF7 - direct ESDS  '.
           05  FILLER PIC X(19) VALUE 'PF8 - direct ESDS/P'.
           05  FILLER PIC X(1)  VALUE ' '.
         02  PF-MSG3.
           05  FILLER PIC X(23) VALUE 'PF9 - browse RRDS  '.
           05  FILLER PIC X(23) VALUE 'PF10 - direct RRDS '.
           05  FILLER PIC X(15) VALUE 'PF11 - '.
           05  FILLER PIC X(15) VALUE 'PF12 - quit'.

       COPY DFHAID.
      *01  DFHAID COPY DFHAID.

       PROCEDURE DIVISION.

       DO-IT-AGAIN.
           EXEC CICS
            SEND TEXT FROM(PF-MSG) LENGTH(313) ERASE CURSOR(HOME)
           END-EXEC.
           EXEC CICS RECEIVE END-EXEC.
           MOVE EIBAID TO AID77.

       PF1.
      *    PF1  =
           IF EIBAID NOT EQUAL DFHPF1 GO TO PF2.
           EXEC CICS XCTL PROGRAM('TESTBKS') END-EXEC.
           GO TO DO-IT-AGAIN.

       PF2.
      *    PF2  =
           IF EIBAID NOT EQUAL DFHPF2 GO TO PF3.
           EXEC CICS XCTL PROGRAM('TESTBKP') END-EXEC.
           GO TO DO-IT-AGAIN.

       PF3.
      *    PF3  =
           IF EIBAID NOT EQUAL DFHPF3 GO TO PF4.
           EXEC CICS XCTL PROGRAM('TESTBES') END-EXEC.
           GO TO DO-IT-AGAIN.

       PF4.
      *    PF4  =
           IF EIBAID NOT EQUAL DFHPF4 GO TO PF5.
           EXEC CICS XCTL PROGRAM('TESTBEP') END-EXEC.
           GO TO UNKNOW-AID.

       PF5.
      *    PF5  =
           IF EIBAID NOT EQUAL DFHPF5 GO TO PF6.
           EXEC CICS XCTL PROGRAM('TESTDKS') END-EXEC.
           GO TO DO-IT-AGAIN.

       PF6.
      *    PF6  =
           IF EIBAID NOT EQUAL DFHPF6 GO TO PF7.
           EXEC CICS XCTL PROGRAM('TESTDKP') END-EXEC.
           GO TO DO-IT-AGAIN.

       PF7.
      *    PF7  =
           IF EIBAID NOT EQUAL DFHPF7 GO TO PF8.
           EXEC CICS XCTL PROGRAM('TESTDES') END-EXEC.
           GO TO UNKNOW-AID.

       PF8.
      *    PF8  = READ for update
           IF EIBAID NOT EQUAL DFHPF8 GO TO PF9.
           EXEC CICS XCTL PROGRAM('TESTDEP') END-EXEC.
           GO TO UNKNOW-AID.

       PF9.
      *    PF9  =
           IF EIBAID NOT EQUAL DFHPF9 GO TO PF10.
           EXEC CICS XCTL PROGRAM('TESTBRR') END-EXEC.
           GO TO UNKNOW-AID.

       PF10.
      *    PF10 =
           IF EIBAID NOT EQUAL DFHPF10 GO TO PF11.
           EXEC CICS XCTL PROGRAM('TESTDRR') END-EXEC.
           GO TO UNKNOW-AID.

       PF11.
      *    PF11 =
           IF EIBAID NOT EQUAL DFHPF11 GO TO PF12.
           GO TO UNKNOW-AID.

       PF12.
      *    PF12 =  QUIT
           IF EIBAID NOT EQUAL DFHPF12 GO TO UNKNOW-AID.
           EXEC CICS
            SEND TEXT FROM(DONE-MSG) LENGTH(8) ERASE CURSOR(HOME)
           END-EXEC.
           MOVE WS-BEGIN TO DONE-LOG-PGM.
           EXEC CICS LINK PROGRAM('KLOGIT')
            COMMAREA(DONE-LOG) LENGTH(12)
           END-EXEC.
           EXEC CICS RETURN END-EXEC.
      *    GO TO DO-IT-AGAIN.

       UNKNOW-AID.
           IF EIBTRMID NOT EQUAL 'CRLP'
            EXEC CICS
             SEND TEXT FROM(BAD-PF-MSG) LENGTH(8) ERASE CURSOR(HOME)
            END-EXEC
            EXEC CICS DELAY INTERVAL(1) END-EXEC
           ELSE
            EXEC CICS ABEND ABCODE('BARF') NODUMP END-EXEC.
           GO TO DO-IT-AGAIN.

/*
//LKED.SYSLMOD DD DSN=K.U.V1R5M0.KIKRPL,DISP=SHR
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKCOBGL)
 ENTRY TESTPGM
 NAME  TESTPGM(R)
/*
//


 REMOVE GROUP(TESTPGM) LIST(HERC01)
 ADD    GROUP(TESTPGM) LIST(HERC01)

 DEFINE FILE(TSTKSDS)     GROUP(TESTPGM) DSNAME(K.U.TSTKSDS)
 AL FI(TSTKSDS) GR(TESTPGM) ADD(Y) BROWSE(Y) DEL(Y) UPDATE(Y) READ(Y)
 DEFINE FILE(TSTKSDP)     GROUP(TESTPGM) DSNAME(K.U.TSTKSDS.P          ATH)
 AL FI(TSTKSDP) GR(TESTPGM) ADD(Y) BROWSE(Y) DEL(Y) UPDATE(Y) READ(Y)
 DEFINE FILE(TSTESDS)     GROUP(TESTPGM) DSNAME(K.U.TSTESDS)
 AL FI(TSTESDS) GR(TESTPGM) ADD(Y) BROWSE(Y) DEL(N) UPDATE(Y) READ(Y)
 DEFINE FILE(TSTESDP)     GROUP(TESTPGM) DSNAME(K.U.TSTESDS.P          ATH)
 AL FI(TSTESDP) GR(TESTPGM) ADD(Y) BROWSE(Y) DEL(Y) UPDATE(Y) READ(Y)
 DEFINE FILE(TSTRRDS)     GROUP(TESTPGM) DSNAME(K.U.TSTRRDS)
 AL FI(TSTRRDS) GR(TESTPGM) ADD(Y) BROWSE(Y) DEL(Y) UPDATE(Y) READ(Y)

 DEFINE TRANSACTION(TEST) GROUP(TESTPGM)    PROGRAM(TESTPGM)
 DEFINE PROGRAM(TESTPGM)  GROUP(TESTPGM)    LANGUAGE(COBOL)
 DEFINE PROGRAM(TESTBKS)  GROUP(TESTPGM)    LANGUAGE(COBOL)
 DEFINE PROGRAM(TESTBKP)  GROUP(TESTPGM)    LANGUAGE(COBOL)
 DEFINE PROGRAM(TESTBES)  GROUP(TESTPGM)    LANGUAGE(COBOL)
 DEFINE PROGRAM(TESTBEP)  GROUP(TESTPGM)    LANGUAGE(COBOL)
 DEFINE PROGRAM(TESTBRR)  GROUP(TESTPGM)    LANGUAGE(COBOL)
 DEFINE PROGRAM(TESTDKS)  GROUP(TESTPGM)    LANGUAGE(COBOL)
 DEFINE PROGRAM(TESTDKP)  GROUP(TESTPGM)    LANGUAGE(COBOL)
 DEFINE PROGRAM(TESTDES)  GROUP(TESTPGM)    LANGUAGE(COBOL)
 DEFINE PROGRAM(TESTDEP)  GROUP(TESTPGM)    LANGUAGE(COBOL)
 DEFINE PROGRAM(TESTDRR)  GROUP(TESTPGM)    LANGUAGE(COBOL)

