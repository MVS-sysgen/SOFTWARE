      *PARAMETER PASSING EXAMPLE
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PARM.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  FILLER-LINE PIC X(133) VALUE ALL '='.
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
           DISPLAY '<< JOB INFORMATION >>'.
           DISPLAY 'JOB NUMBER     : ' WS-GETJOBI-JOB-NBR.
           DISPLAY 'JOB NAME       : ' WS-GETJOBI-JOB-NAME.
           DISPLAY 'JOB STEP NAME  : ' WS-GETJOBI-STEP-NAME.
           DISPLAY 'PROC STEP NAME : ' WS-GETJOBI-PROCSTEP-NAME.
           

           IF PARM-LENGTH > 0 THEN 
             DISPLAY 'PARAMETER LEN  : ' PARM-LENGTH
             DISPLAY 'PARAMETER      : ' PARM-DATA.
           
           
           DISPLAY '<< END INFORMATION >>'.

       MAINLINE-EXIT.
                GOBACK.
