//KSSFPGM JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=7000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//KSSFPGM EXEC  PROC=K2KCOBCL
//COPY.SYSUT1 DD *
       ID DIVISION.
       PROGRAM-ID. KSSFPGM.

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

      *///////////////////////////////////////////////////////////////
      * KSSFPGM (tranid KSSF) is the signoff/shutdown program.
      *///////////////////////////////////////////////////////////////

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN   PIC X(24) VALUE 'KSSFPGM  WORKING STORAGE'.
       77  WS-SM-ALT  PIC X     VALUE X'7E'.
       77  WS-SM-NORM PIC X     VALUE X'F5'.
       77  WS-ALTHT   PIC S9(4)  COMP.
       77  WS-SCRNHT  PIC S9(4)  COMP.

      * Note use of 3270 'set attribute' (SA) orders in the
      * following STRFIELD buffer - unusual in CICS/KICKS apps...

       01  SHUTDOWN-MSG.
           10  SM-CMD PIC X     VALUE X'7E'.
           10  SM-WCC PIC X     VALUE X'C3'.
           10  FILLER PIC X(2)  VALUE X'1DF0'.
           10  FILLER PIC X(3)  VALUE X'284100'.
           10  FILLER PIC X(3)  VALUE X'2842F2'.
           10  FILLER PIC X VALUE 'K'.
           10  FILLER PIC X(3)  VALUE X'284100'.
           10  FILLER PIC X(3)  VALUE X'2842F6'.
           10  FILLER PIC X VALUE 'I'.
           10  FILLER PIC X(3)  VALUE X'284100'.
           10  FILLER PIC X(3)  VALUE X'2842F5'.
           10  FILLER PIC X VALUE 'C'.
           10  FILLER PIC X(3)  VALUE X'284100'.
           10  FILLER PIC X(3)  VALUE X'2842F1'.
           10  FILLER PIC X VALUE 'K'.
           10  FILLER PIC X(3)  VALUE X'284100'.
           10  FILLER PIC X(3)  VALUE X'2842F4'.
           10  FILLER PIC X VALUE 'S'.
           10  FILLER PIC X(2)  VALUE X'1DF0'.
           10  FILLER PIC X(3)  VALUE X'284100'.
           10  FILLER PIC X(3)  VALUE X'284200'.
           10  FILLER PIC X(19) VALUE 'is shutting down...'.
           10  FILLER PIC X     VALUE X'13'.

       PROCEDURE DIVISION.

      * --- obtain screen size ---
           EXEC KICKS ASSIGN SCRNHT(WS-SCRNHT) END-EXEC.
           EXEC KICKS ASSIGN ALTSCRNHT(WS-ALTHT) END-EXEC.

      * --- send shutdown message in current size screen ---
           IF WS-SCRNHT = WS-ALTHT
               MOVE WS-SM-ALT  TO SM-CMD
           ELSE
               MOVE WS-SM-NORM TO SM-CMD.
           EXEC KICKS
             SEND TEXT FROM(SHUTDOWN-MSG) STRFIELD
           END-EXEC.
      * --- do receive to make sure msg gets to screen ---
           EXEC KICKS RECEIVE CHECK END-EXEC.

      * --- signoff (signoff is same as shutdown to KICKS!) ---
           EXEC KICKS SIGNOFF END-EXEC.
           EXEC KICKS DELAY INTERVAL(2) END-EXEC.

      * --- exit with alt screen size, cleared, unlocked
           EXEC KICKS SEND CONTROL ERASE ALTERNATE FREEKB END-EXEC.

      * --- shutdown happens after transaction ends ---
           EXEC KICKS RETURN END-EXEC.

/*
//LKED.SYSLMOD DD DSN=K.S.V1R5M0.KIKRPL,DISP=SHR
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKCOBGX)
 ENTRY KSSFPGM
 NAME  KSSFPGM(R)
/*
//

