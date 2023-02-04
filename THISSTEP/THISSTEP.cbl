      *THISSTEP
      *
      * This program requires GETJOBI to run
      * When run it will return a seperate line showing the current
      * STEP and name (if applicable) the PROC STEP name
      *
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PARM.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  FILLER-LINE PIC X(133) VALUE ALL '='.
       01  SEPERATOR-LINE.
           05  STEP-NAME PIC  X(08).
           05  SL-STEP-SPACE PIC XXX VALUE ' =='.
           05  PROCSTEP-NAME PIC  X(08) VALUE ALL '='
           05  SL-PROC-SPACE PIC X VALUE '='.
           05  FILLER PIC X(113) VALUE ALL '='.
       01  COLUMNS.
           05 FILLER PIC X(9) VALUE 'STEP NAME'.
           05 FILLER PIC XX VALUE '  '.
           05 PROCSTEP PIC X(9) VALUE SPACES.
       LINKAGE SECTION.
       01   PARM-BUFFER.
            05 PARM-LENGTH   PIC S9(4) COMP.
            05 PARM-DATA.
               10 NUMB       PIC X(100).
       03  WS-GETJOBI-PARM-REC.
           05  WS-GETJOBI-JOB-NAME
                                 PIC  X(08).
           05  WS-GETJOBI-PROCSTEP-NAME
                                 PIC  X(08).
           05  WS-GETJOBI-STEP-NAME
                                 PIC  X(08).
           05  WS-GETJOBI-JOB-NBR
                                 PIC  X(08).
           05  WS-GETJOBI-WORKAREA
                                 PIC  X(128).
       PROCEDURE DIVISION USING PARM-BUFFER.
       MAINLINE SECTION.
           
           CALL 'GETJOBI' USING WS-GETJOBI-PARM-REC.

           MOVE WS-GETJOBI-PROCSTEP-NAME TO STEP-NAME.
           IF WS-GETJOBI-STEP-NAME NOT = SPACES 
               MOVE WS-GETJOBI-PROCSTEP-NAME TO PROCSTEP-NAME
               MOVE ' = ' TO SL-STEP-SPACE
               MOVE ' ' TO SL-PROC-SPACE
               MOVE WS-GETJOBI-STEP-NAME TO STEP-NAME
               MOVE 'PROC STEP' TO PROCSTEP.


           DISPLAY COLUMNS.
           DISPLAY SEPERATOR-LINE.

           IF PARM-LENGTH > 0 THEN 
             DISPLAY PARM-DATA.

       MAINLINE-EXIT.
                GOBACK.
