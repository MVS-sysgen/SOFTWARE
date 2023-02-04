       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.  GETINV.
      *
       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
      *
       COPY INVCTL.
      *
       LINKAGE SECTION.
      *
       01  DFHCOMMAREA   PIC 9(06).
      *
       PROCEDURE DIVISION.
      *
       0000-GET-INVOICE-NUMBER.
      *
           MOVE ZERO TO INVCTL-RECORD-KEY.
           EXEC CICS
               READ FILE('INVCTL')
                    INTO(INVCTL-RECORD)
                    RIDFLD(INVCTL-RECORD-KEY)
                    UPDATE
           END-EXEC.
           MOVE INVCTL-NEXT-INVOICE-NUMBER TO DFHCOMMAREA.
           ADD 1 TO INVCTL-NEXT-INVOICE-NUMBER.
           EXEC CICS
               REWRITE FILE('INVCTL')
                       FROM(INVCTL-RECORD)
           END-EXEC.
           EXEC CICS
               RETURN
           END-EXEC.


