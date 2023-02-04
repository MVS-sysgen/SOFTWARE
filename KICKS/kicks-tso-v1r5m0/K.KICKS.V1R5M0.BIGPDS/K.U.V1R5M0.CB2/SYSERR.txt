       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.  SYSERR.
      *
       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
      *
       01  ERROR-MESSAGE.
      *
           05  ERROR-LINE-1.
               10  FILLER      PIC X(20)  VALUE 'A serious error has '.
               10  FILLER      PIC X(20)  VALUE 'occurred.  Please co'.
               10  FILLER      PIC X(20)  VALUE 'ntact technical supp'.
               10  FILLER      PIC X(19)  VALUE 'ort.               '.
           05  ERROR-LINE-2    PIC X(79)  VALUE SPACE.
           05  ERROR-LINE-3.
               10  FILLER      PIC X(11)  VALUE 'EIBRESP  = '.
               10  EM-RESP     PIC Z(08)9.
               10  FILLER      PIC X(59)  VALUE SPACE.
           05  ERROR-LINE-4.
               10  FILLER      PIC X(11)  VALUE 'EIBRESP2 = '.
               10  EM-RESP2    PIC Z(08)9.
               10  FILLER      PIC X(59)  VALUE SPACE.
           05  ERROR-LINE-5.
               10  FILLER      PIC X(11)  VALUE 'EIBTRNID = '.
               10  EM-TRNID    PIC X(04).
               10  FILLER      PIC X(64)  VALUE SPACE.
           05  ERROR-LINE-6.
               10  FILLER      PIC X(11)  VALUE 'EIBRSRCE = '.
               10  EM-RSRCE    PIC X(08).
               10  FILLER      PIC X(60)  VALUE SPACE.
           05  ERROR-LINE-7    PIC X(79)  VALUE SPACE.
      *
       COPY ERRPARM.
      *
       LINKAGE SECTION.
      *
       01  DFHCOMMAREA         PIC X(20).
      *
       PROCEDURE DIVISION.
      *
       0000-DISPLAY-ERROR-MESSAGE.
      *
           MOVE DFHCOMMAREA TO ERROR-PARAMETERS.
           MOVE ERR-RESP  TO EM-RESP.
           MOVE ERR-RESP2 TO EM-RESP2.
           MOVE ERR-TRNID TO EM-TRNID.
           MOVE ERR-RSRCE TO EM-RSRCE.
           EXEC CICS
               SEND TEXT FROM(ERROR-MESSAGE)
                         ERASE
                         ALARM
                         FREEKB
           END-EXEC.
           EXEC CICS
               RETURN
           END-EXEC.
