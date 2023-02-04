//KSMTPGM JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=7000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//KSMTPGM EXEC  PROC=K2KCOBCL
//COPY.SYSUT1 DD *
       ID DIVISION.
       PROGRAM-ID. KSMTPGM.

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
      * KSMTPGM is the master terminal program.
      *//1/////////2/////////3/////////4/////////5/////////6/////////7

      *///////////////////////////////////////////////////////////////
      * Changes for 1.4.0
      *   added maxcc display to top line
      *   check for wide screens before using alt screen size
      *//1/////////2/////////3/////////4/////////5/////////6/////////7

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN  PIC X(24) VALUE 'KSMTPGM  WORKING STORAGE'.
       77  WS-DEFSCRNHT        PIC S9(4) COMP.
       77  WS-ALTSCRNWD        PIC S9(4) COMP.
       77  WS-SCRNHT           PIC S9(4) COMP.
       77  WS-MAXCC            PIC S9(4) COMP.

       01  SUBS-COMMAREA.
           05  RC      PIC S9(4) COMP.
           05  LASTMAX PIC S9(4) COMP.
           05  ICVR    PIC S9(8) COMP.

       01  RC-BITS.
           05  RC-BITS-BITS PIC S9(8) COMP.
           05  RC-BIT-1     PIC S9(4) COMP.
           05  RC-BIT-2     PIC S9(4) COMP.
           05  RC-BIT-4     PIC S9(4) COMP.
           05  RC-BIT-8     PIC S9(4) COMP.

       01  THE-SCREEN.
           05  LINE-1  PIC X(45)
               VALUE ' KICKS Master Terminal Program      (maxcc = '.
           05  LINE-1B PIC ZZZZ9.
           05  LINE-1C PIC X(29) VALUE ')'.
           05  LINE-2  PIC X(79) VALUE SPACE.
           05  LINE-3  PIC X(79) VALUE SPACE.
           05  LINE-4  PIC X(79) VALUE
               'Press a PF key to obtain indicated action:'.
           05  LINE-5  PIC X(79) VALUE SPACE.
           05  LINE-6  PIC X(79) VALUE 'PF1  =  SHOW TRACE STATUS'.
           05  LINE-7  PIC X(79)
               VALUE 'PF2  =  TOGGLE INTERNAL TRACE ON/OFF'.
           05  LINE-8  PIC X(79)
               VALUE 'PF3  =  TOGGLE AUX TRACE ON/OFF'.
           05  LINE-9  PIC X(79)
               VALUE 'PF4  =  TOGGLE INTENSE TRACE ON/OFF'.
           05  LINE-10 PIC X(79) VALUE SPACE.
           05  LINE-11 PIC X(79)
               VALUE 'PF5  =  SHOW ICVR VALUE'.
           05  LINE-12 PIC X(79)
               VALUE 'PF6  =  DECREASE ICVR'.
           05  LINE-13 PIC X(79)
               VALUE 'PF7  =  INCREASE ICVR'.
           05  LINE-14 PIC X(79) VALUE 'PF8  =  '.
           05  LINE-15 PIC X(79) VALUE 'PF9  =  '.
           05  LINE-16 PIC X(79) VALUE 'PF10 =  '.
           05  LINE-17 PIC X(79) VALUE 'PF11 =  '.
           05  LINE-18 PIC X(79) VALUE 'PF12 =  QUIT'.
           05  LINE-19 PIC X(79) VALUE SPACE.
           05  LINE-20.
               10  FILLER     PIC X.
               10  ICVR-MSG1  PIC X(8).
               10  ICVR-VAL   PIC ZZZZZZ9.
               10  ICVR-MSG2  PIC X(23).
               10  ICVR-VAL2  PIC ZZZ9.
               10  ICVR-MSG3  PIC X(9).
               10  FILLER     PIC X(27).
           05  LINE-21.
               10  FILLER     PIC XX.
               10  AUX-MSG1   PIC X(19).
               10  AUX-MSG2   PIC X(17).
               10  FILLER     PIC X(41).
           05  LINE-22 PIC X(79) VALUE SPACE.
           05  LINE-23.
               10  FILLER     PIC X.
               10  TS-MESSAGE PIC X(77).
               10  FILLER     PIC X.

       COPY DFHAID.

       PROCEDURE DIVISION.
           MOVE SPACES TO
               LINE-19, LINE-20, LINE-21, LINE-22, LINE-23.
           EXEC KICKS
               LINK PROGRAM('KMAXCCG')
               COMMAREA(SUBS-COMMAREA)
           END-EXEC.
           MOVE LASTMAX TO WS-MAXCC, LINE-1B.

       DO-IT-AGAIN.
      *    SEND SCREEN, CLEAR MSG LINES FOR NEXT TIME, GET NEW AID
           PERFORM SEND-SCREEN.
           MOVE SPACES TO
               LINE-19, LINE-20, LINE-21, LINE-22, LINE-23.
           EXEC CICS RECEIVE END-EXEC.

       PF1.
      *    PF1  =  SHOW TRACE STATUS
           IF EIBAID NOT EQUAL DFHPF1 GO TO PF2.
           PERFORM SHOW-TRACE-STUFF.
           GO TO DO-IT-AGAIN.

       PF2.
      *    PF2  =  TOGGLE INTERNAL TRACE ON/OFF
           IF EIBAID NOT EQUAL DFHPF2 GO TO PF3.
           PERFORM SHOW-TRACE-STUFF.
           IF RC-BIT-1 = 0
               EXEC KICKS
                   LINK PROGRAM('KTRCON')
                   COMMAREA(SUBS-COMMAREA)
               END-EXEC
           ELSE
               EXEC KICKS
                   LINK PROGRAM('KTRCOFF')
                   COMMAREA(SUBS-COMMAREA)
               END-EXEC.
           IF RC NOT = 0
               MOVE 'ERROR TURNING INTERNAL TRACE ON' TO TS-MESSAGE
           ELSE
           PERFORM SHOW-TRACE-STUFF.
           GO TO DO-IT-AGAIN.

       PF3.
      *    PF3  =  TOGGLE AUX TRACE ON/OFF
           IF EIBAID NOT EQUAL DFHPF3 GO TO PF4.
           PERFORM SHOW-TRACE-STUFF.
           IF RC-BIT-2 = 0
               EXEC KICKS
                   LINK PROGRAM('KTRCAON')
                   COMMAREA(SUBS-COMMAREA)
               END-EXEC
           ELSE
               EXEC KICKS
                   LINK PROGRAM('KTRCAOF')
                   COMMAREA(SUBS-COMMAREA)
               END-EXEC.
           PERFORM SHOW-TRACE-STUFF.
           GO TO DO-IT-AGAIN.

       PF4.
      *    PF6  =  TOGGLE INTENSE TRACE ON/OFF
           IF EIBAID NOT EQUAL DFHPF4 GO TO PF5.
           PERFORM SHOW-TRACE-STUFF.
           IF RC-BIT-8 = 0
               EXEC KICKS
                   LINK PROGRAM('KTRCINON')
                   COMMAREA(SUBS-COMMAREA)
               END-EXEC
           ELSE
               EXEC KICKS
                   LINK PROGRAM('KTRCINOF')
                   COMMAREA(SUBS-COMMAREA)
               END-EXEC.
           PERFORM SHOW-TRACE-STUFF.
           GO TO DO-IT-AGAIN.

       PF5.
      *    PF5  =  SHOW ICVR VALUE
           IF EIBAID NOT EQUAL DFHPF5 GO TO PF6.
           PERFORM SHOW-ICVR-STUFF.
           GO TO DO-IT-AGAIN.

       PF6.
      *    PF6  =  DECREASE ICVR
           IF EIBAID NOT EQUAL DFHPF6 GO TO PF7.
           PERFORM SHOW-ICVR-STUFF.
           ADD -100 TO ICVR.
           IF ICVR < 0 MOVE 0 TO ICVR.
           EXEC KICKS
               LINK PROGRAM('KICVRPUT')
               COMMAREA(SUBS-COMMAREA)
           END-EXEC.
           PERFORM SHOW-ICVR-STUFF.
           GO TO DO-IT-AGAIN.

       PF7.
      *    PF7  =  INCREASE ICVR
           IF EIBAID NOT EQUAL DFHPF7 GO TO PF8.
           PERFORM SHOW-ICVR-STUFF.
           ADD +100 TO ICVR.
           EXEC KICKS
               LINK PROGRAM('KICVRPUT')
               COMMAREA(SUBS-COMMAREA)
           END-EXEC.
           PERFORM SHOW-ICVR-STUFF.
           GO TO DO-IT-AGAIN.

       PF8.
      *    PF8  =
           IF EIBAID NOT EQUAL DFHPF8 GO TO PF9.
           GO TO DO-IT-AGAIN.

       PF9.
      *    PF9  =
           IF EIBAID NOT EQUAL DFHPF9 GO TO PF10.
           GO TO DO-IT-AGAIN.

       PF10.
      *    PF10 =
           IF EIBAID NOT EQUAL DFHPF10 GO TO PF11.
           GO TO DO-IT-AGAIN.

       PF11.
      *    PF11 =
           IF EIBAID NOT EQUAL DFHPF11 GO TO PF12.
           GO TO DO-IT-AGAIN.

       PF12.
      *    PF12 =  QUIT
           IF EIBAID = DFHPF12 OR DFHCLEAR
               MOVE SPACES TO THE-SCREEN
               MOVE 'KSMT FINISHED. ' TO LINE-1
               PERFORM SEND-SCREEN
               EXEC CICS RETURN END-EXEC.
      *        GO TO DO-IT-AGAIN.

       UNKNOW-AID.
           MOVE 'UNKNOWN COMMAND' TO TS-MESSAGE.
           GO TO DO-IT-AGAIN.

       SHOW-TRACE-STUFF.
           EXEC KICKS
               LINK PROGRAM('KTRCSTA')
               COMMAREA(SUBS-COMMAREA)
           END-EXEC.
           PERFORM GET-BITS.
           IF RC-BIT-1 NOT = 0
               MOVE '  INTERNAL TRACE ON' TO LINE-20
           ELSE
               MOVE '  INTERNAL TRACE OFF' TO LINE-20.
           IF RC-BIT-2 NOT = 0
               MOVE 'AUXILARY TRACE ON' TO AUX-MSG1
           ELSE
               MOVE 'AUXILARY TRACE OFF' TO AUX-MSG1.
           IF RC-BIT-4 NOT = 0
               MOVE '(FILE IS OPEN)' TO AUX-MSG2
           ELSE
               MOVE '(FILE IS CLOSED)' TO AUX-MSG2.
           IF RC-BIT-8 NOT = 0
               MOVE '  INTENSE TRACING ACTIVE' TO LINE-22
           ELSE
               MOVE '  INTENSE TRACING INACTIVE' TO LINE-22.

       SHOW-ICVR-STUFF.
           EXEC KICKS
               LINK PROGRAM('KICVRGET')
               COMMAREA(SUBS-COMMAREA)
           END-EXEC.
           MOVE 'ICVR IS ' TO ICVR-MSG1.
           MOVE ICVR TO ICVR-VAL.
           MOVE ' MILLISECONDS, OR ABOUT ' TO ICVR-MSG2.
           DIVIDE ICVR BY 1000 GIVING RC-BITS-BITS
               REMAINDER RC-BIT-1.
      *    IF RC-BIT-1 > 499 ADD 1 TO RC-BITS-BITS.
           MOVE RC-BITS-BITS TO ICVR-VAL2.
           MOVE ' SECONDS.' TO ICVR-MSG3.

       GET-BITS.
           MOVE LOW-VALUES TO RC-BITS.
           MOVE RC TO RC-BITS-BITS.
           DIVIDE RC-BITS-BITS BY 2 GIVING RC-BITS-BITS
             REMAINDER RC-BIT-1.
           DIVIDE RC-BITS-BITS BY 2 GIVING RC-BITS-BITS
             REMAINDER RC-BIT-2.
           DIVIDE RC-BITS-BITS BY 2 GIVING RC-BITS-BITS
             REMAINDER RC-BIT-4.
           DIVIDE RC-BITS-BITS BY 2 GIVING RC-BITS-BITS
             REMAINDER RC-BIT-8.

       SEND-SCREEN.
           EXEC KICKS ASSIGN SCRNHT(WS-SCRNHT) END-EXEC.
           EXEC KICKS ASSIGN DEFSCRNHT(WS-DEFSCRNHT) END-EXEC.
           EXEC KICKS ASSIGN ALTSCRNWD(WS-ALTSCRNWD) END-EXEC.
           IF WS-ALTSCRNWD NOT EQUAL 80 OR
              WS-SCRNHT = WS-DEFSCRNHT
               EXEC CICS
                   SEND TEXT FROM(THE-SCREEN)
                        ERASE FREEKB
               END-EXEC
           ELSE
               EXEC CICS
                   SEND TEXT FROM(THE-SCREEN)
                        ERASE FREEKB ALTERNATE
               END-EXEC.
           IF TS-MESSAGE NOT= SPACES
               EXEC CICS
                   SEND CONTROL ALARM FREEKB
               END-EXEC.

/*
//LKED.SYSLMOD DD DSN=K.S.V1R5M0.KIKRPL,DISP=SHR
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKCOBGX)
 ENTRY KSMTPGM
 NAME  KSMTPGM(R)
/*
//
