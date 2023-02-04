       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.  INTEDIT.
      *
       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
      *
       01  WORK-FIELDS.
      *
           05  INTEGER-PART        PIC 9(05).
           05  INTEGER-LENGTH      PIC S9(03)  COMP-3.
      *
       LINKAGE SECTION.
      *
       01  UNEDITED-NUMBER         PIC X(05).
      *
       01  EDITED-NUMBER           PIC 9(05).
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
           MOVE ZERO TO INTEGER-LENGTH.
           INSPECT UNEDITED-NUMBER
               REPLACING LEADING SPACE BY ZERO.
           INSPECT UNEDITED-NUMBER
               TALLYING INTEGER-LENGTH FOR CHARACTERS
                   BEFORE INITIAL SPACE.
           IF UNEDITED-NUMBER(1:INTEGER-LENGTH) NUMERIC
               MOVE UNEDITED-NUMBER(1:INTEGER-LENGTH)
                   TO EDITED-NUMBER
               MOVE 'Y' TO VALID-NUMBER-SW
           ELSE
               MOVE 'N' TO VALID-NUMBER-SW
           END-IF.
      *
       0000-EXIT.
      *
           EXIT PROGRAM.
