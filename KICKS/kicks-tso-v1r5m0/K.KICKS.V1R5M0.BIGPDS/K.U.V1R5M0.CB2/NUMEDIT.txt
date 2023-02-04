       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.  NUMEDIT.
      *
       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
      *
       01  WORK-FIELDS.
      *
           05  INTEGER-PART        PIC 9(10).
           05  INTEGER-PART-X      REDEFINES   INTEGER-PART.
               10  INTEGER-CHAR    PIC X(01)   OCCURS 10.
           05  DECIMAL-PART        PIC V9(10).
           05  DECIMAL-PART-X      REDEFINES   DECIMAL-PART.
               10  DECIMAL-CHAR    PIC X(01)   OCCURS 10.
           05  DECIMAL-POS         PIC S9(03)  COMP-3.
           05  INTEGER-LENGTH      PIC S9(03)  COMP-3.
           05  INTEGER-SUB         PIC S9(03)  COMP-3.
           05  DECIMAL-SUB         PIC S9(03)  COMP-3.
           05  UNEDIT-SUB          PIC S9(03)  COMP-3.
      *
       LINKAGE SECTION.
      *
       01  UNEDITED-NUMBER.
           05  UNEDITED-CHAR       OCCURS 10   PIC X.
      *
       01  EDITED-NUMBER           PIC 9(07)V99.
      *
       01  VALID-NUMBER-SW         PIC X(01).
           88  VALID-NUMBER        VALUE 'Y'.
      *
       PROCEDURE DIVISION USING UNEDITED-NUMBER
                                EDITED-NUMBER
                                VALID-NUMBER-SW.
      *
       0000-EDIT-NUMBER.
      *
           MOVE 'Y' TO VALID-NUMBER-SW.
           MOVE ZERO TO INTEGER-PART
                        DECIMAL-PART
                        DECIMAL-POS.
           INSPECT UNEDITED-NUMBER
               TALLYING DECIMAL-POS FOR CHARACTERS
                   BEFORE INITIAL '.'.
           IF DECIMAL-POS < 10
               PERFORM 1000-EDIT-DECIMAL-NUMBER
           ELSE
               PERFORM 2000-EDIT-INTEGER
           END-IF.
           IF VALID-NUMBER
               COMPUTE EDITED-NUMBER = INTEGER-PART + DECIMAL-PART
           END-IF.
      *
       0000-EXIT.
      *
           EXIT PROGRAM.
      *
       1000-EDIT-DECIMAL-NUMBER.
      *
           MOVE 10 TO INTEGER-SUB.
           PERFORM 1100-EDIT-INTEGER-PART
               VARYING UNEDIT-SUB FROM DECIMAL-POS BY -1
                 UNTIL UNEDIT-SUB < 1.
           MOVE 1 TO DECIMAL-SUB.
           ADD 2 TO DECIMAL-POS.
           PERFORM 1200-EDIT-DECIMAL-PART
               VARYING UNEDIT-SUB FROM DECIMAL-POS BY 1
                 UNTIL UNEDIT-SUB > 10.
      *
       1100-EDIT-INTEGER-PART.
      *
           IF UNEDITED-CHAR(UNEDIT-SUB) NUMERIC
               MOVE UNEDITED-CHAR(UNEDIT-SUB)
                   TO INTEGER-CHAR(INTEGER-SUB)
               SUBTRACT 1 FROM INTEGER-SUB
           ELSE IF UNEDITED-CHAR(UNEDIT-SUB) NOT = SPACE
               MOVE 'N' TO VALID-NUMBER-SW
           END-IF.
      *
       1200-EDIT-DECIMAL-PART.
      *
           IF UNEDITED-CHAR(UNEDIT-SUB) NUMERIC
               MOVE UNEDITED-CHAR(UNEDIT-SUB)
                   TO DECIMAL-CHAR(DECIMAL-SUB)
               ADD 1 TO DECIMAL-SUB
           ELSE IF UNEDITED-CHAR(UNEDIT-SUB) NOT = SPACE
               MOVE 'N' TO VALID-NUMBER-SW
           END-IF.
      *
       2000-EDIT-INTEGER.
      *
           INSPECT UNEDITED-NUMBER
               REPLACING LEADING SPACE BY ZERO.
           MOVE ZERO TO INTEGER-LENGTH.
           INSPECT UNEDITED-NUMBER
               TALLYING INTEGER-LENGTH FOR CHARACTERS
                   BEFORE INITIAL SPACE.
           MOVE 10 TO INTEGER-SUB.
           PERFORM 1100-EDIT-INTEGER-PART
               VARYING UNEDIT-SUB FROM INTEGER-LENGTH BY -1
                 UNTIL UNEDIT-SUB < 1.
           MOVE ZERO TO DECIMAL-PART.
