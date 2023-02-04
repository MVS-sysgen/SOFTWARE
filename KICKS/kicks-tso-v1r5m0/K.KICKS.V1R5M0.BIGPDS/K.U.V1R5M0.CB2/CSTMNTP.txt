       IDENTIFICATION DIVISION.
      *
       PROGRAM-ID.  CSTMNTP.
      *
       ENVIRONMENT DIVISION.
      *
       DATA DIVISION.
      *
       WORKING-STORAGE SECTION.
      *
       01  SWITCHES.
      *
           05  VALID-DATA-SW                   PIC X(01) VALUE 'Y'.
               88  VALID-DATA                            VALUE 'Y'.
      *
       01  FLAGS.
      *
           05  SEND-FLAG                       PIC X(01).
               88  SEND-ERASE                            VALUE '1'.
               88  SEND-ERASE-ALARM                      VALUE '2'.
               88  SEND-DATAONLY                         VALUE '3'.
               88  SEND-DATAONLY-ALARM                   VALUE '4'.
      *
       01  USER-INSTRUCTIONS.
           05  ADD-INSTRUCTION                 PIC X(79) VALUE
               'Type information for new customer.  Then Press Enter.'.
           05  CHANGE-INSTRUCTION              PIC X(79) VALUE
               'Type changes.  Then press Enter.'.
           05  DELETE-INSTRUCTION              PIC X(79) VALUE
               'Press Enter to delete this customer or press F12 to canc
      -        'el.'.
      *
       01  COMMUNICATION-AREA.
      *
           05  CA-CONTEXT-FLAG                 PIC X(01).
               88  PROCESS-KEY-MAP                       VALUE '1'.
               88  PROCESS-ADD-CUSTOMER                  VALUE '2'.
               88  PROCESS-CHANGE-CUSTOMER               VALUE '3'.
               88  PROCESS-DELETE-CUSTOMER               VALUE '4'.
           05  CA-ACTION-FLAG                  PIC X(01).
               88  ADD-REQUEST                           VALUE '1'.
               88  CHANGE-REQUEST                        VALUE '2'.
               88  DELETE-REQUEST                        VALUE '3'.
           05  CA-CUSTOMER-RECORD.
               10  CA-CUSTOMER-NUMBER          PIC X(06).
               10  CA-FIRST-NAME               PIC X(20).
               10  CA-LAST-NAME                PIC X(30).
               10  CA-ADDRESS                  PIC X(30).
               10  CA-CITY                     PIC X(20).
               10  CA-STATE                    PIC X(02).
               10  CA-ZIP-CODE                 PIC X(10).
           05  CA-SAVE-CUSTOMER-MASTER         PIC X(118).
           05  CA-RETURN-CONDITION             PIC X(01).
               88  PROCESS-OK                            VALUE '1'.
               88  PROCESS-ERROR                         VALUE '2'.
               88  PROCESS-SEVERE-ERROR                  VALUE '3'.
           05  CA-RETURN-MESSAGE               PIC X(79).
           05  CA-ERROR-PARAMETERS.
               10  CA-ERR-RESP                 PIC S9(08)   COMP.
               10  CA-ERR-RESP2                PIC S9(08)   COMP.
               10  CA-ERR-RSRCE                PIC X(08).

      *
       COPY CMNTSET.
      *
       COPY DFHAID.
      *
       COPY ATTR.
      *
       COPY ERRPARM.
      *
       LINKAGE SECTION.
      *
       01  DFHCOMMAREA                         PIC X(334).
      *
       PROCEDURE DIVISION.
      *
       0000-PROCESS-CUSTOMER-MAINT.
      *
           IF EIBCALEN > ZERO
               MOVE DFHCOMMAREA TO COMMUNICATION-AREA
           END-IF.
      *
           EVALUATE TRUE
      *
               WHEN EIBCALEN = ZERO
                   MOVE LOW-VALUE TO CMNTMP1O
                   MOVE -1 TO CUSTNO1L
                   SET SEND-ERASE TO TRUE
                   PERFORM 1600-SEND-KEY-MAP
                   SET PROCESS-KEY-MAP TO TRUE
      *
               WHEN EIBAID = DFHPF3
                   EXEC CICS
                       XCTL PROGRAM('INVMENU')
                   END-EXEC
      *
               WHEN EIBAID = DFHPF12
                   IF PROCESS-KEY-MAP
                       EXEC CICS
                           XCTL PROGRAM('INVMENU')
                       END-EXEC
                   ELSE
                       MOVE LOW-VALUE TO CMNTMP1O
                       MOVE -1 TO CUSTNO1L
                       SET SEND-ERASE TO TRUE
                       PERFORM 1600-SEND-KEY-MAP
                       SET PROCESS-KEY-MAP TO TRUE
                   END-IF
      *
               WHEN EIBAID = DFHCLEAR
                   IF PROCESS-KEY-MAP
                       MOVE LOW-VALUE TO CMNTMP1O
                       MOVE -1 TO CUSTNO1L
                       SET SEND-ERASE TO TRUE
                       PERFORM 1600-SEND-KEY-MAP
                   ELSE
                       MOVE LOW-VALUE TO CMNTMP2O
                       MOVE CA-CUSTOMER-NUMBER TO CUSTNO2O
                       EVALUATE TRUE
                           WHEN PROCESS-ADD-CUSTOMER
                               MOVE ADD-INSTRUCTION    TO INSTR2O
                           WHEN PROCESS-CHANGE-CUSTOMER
                               MOVE CHANGE-INSTRUCTION TO INSTR2O
                           WHEN PROCESS-DELETE-CUSTOMER
                               MOVE DELETE-INSTRUCTION TO INSTR2O
                       END-EVALUATE
                       MOVE -1 TO LNAMEL
                       SET SEND-ERASE TO TRUE
                       PERFORM 1500-SEND-DATA-MAP
                   END-IF
      *
               WHEN EIBAID = DFHPA1 OR DFHPA2 OR DFHPA3
                   CONTINUE
      *
               WHEN EIBAID = DFHENTER
                   EVALUATE TRUE
                       WHEN PROCESS-KEY-MAP
                           PERFORM 1000-PROCESS-KEY-MAP
                       WHEN PROCESS-ADD-CUSTOMER
                           PERFORM 2000-PROCESS-ADD-CUSTOMER
                       WHEN PROCESS-CHANGE-CUSTOMER
                           PERFORM 3000-PROCESS-CHANGE-CUSTOMER
                       WHEN PROCESS-DELETE-CUSTOMER
                           PERFORM 4000-PROCESS-DELETE-CUSTOMER
                   END-EVALUATE
      *
               WHEN OTHER
                   IF PROCESS-KEY-MAP
                       MOVE LOW-VALUE TO CMNTMP1O
                       MOVE 'That key is unassigned.' TO MSG1O
                       MOVE -1 TO CUSTNO1L
                       SET SEND-DATAONLY-ALARM TO TRUE
                       PERFORM 1600-SEND-KEY-MAP
                   ELSE
                       MOVE LOW-VALUE TO CMNTMP2O
                       MOVE 'That key is unassigned.' TO MSG2O
                       MOVE -1 TO LNAMEL
                       SET SEND-DATAONLY-ALARM TO TRUE
                       PERFORM 1500-SEND-DATA-MAP
                   END-IF
      *
           END-EVALUATE.
      *
           EXEC CICS
               RETURN TRANSID('CMNT')
                      COMMAREA(COMMUNICATION-AREA)
           END-EXEC.
      *
       1000-PROCESS-KEY-MAP.
      *
           MOVE LOW-VALUE TO CA-CUSTOMER-RECORD.
           PERFORM 1100-RECEIVE-KEY-MAP.
           PERFORM 1200-EDIT-KEY-DATA.
           IF VALID-DATA
               PERFORM 1300-GET-CUSTOMER-RECORD
           ELSE
               MOVE LOW-VALUE TO CUSTNO1O
                                 ACTIONO
               SET SEND-DATAONLY-ALARM TO TRUE
               PERFORM 1600-SEND-KEY-MAP
           END-IF.
      *
       1100-RECEIVE-KEY-MAP.
      *
           EXEC CICS
               RECEIVE MAP('CMNTMP1')
                       MAPSET('CMNTSET')
                       INTO(CMNTMP1I)
           END-EXEC.
           INSPECT CMNTMP1I
               REPLACING ALL '_' BY SPACE.
      *
       1200-EDIT-KEY-DATA.
      *
           MOVE ATTR-NO-HIGHLIGHT TO ACTIONH
                                     CUSTNO1H.

           IF ACTIONI NOT = '1' AND '2' AND '3'
               MOVE ATTR-REVERSE TO ACTIONH
               MOVE -1 TO ACTIONL
               MOVE 'Action must be 1, 2, or 3.' TO MSG1O
               MOVE 'N' TO VALID-DATA-SW
           END-IF.
      *
           IF    CUSTNO1L = ZERO
              OR CUSTNO1I = SPACE
               MOVE ATTR-REVERSE TO CUSTNO1H
               MOVE -1 TO CUSTNO1L
               MOVE 'You must enter a customer number.' TO MSG1O
               MOVE 'N' TO VALID-DATA-SW
           END-IF.
      *
       1300-GET-CUSTOMER-RECORD.
      *
           MOVE CUSTNO1I TO CA-CUSTOMER-NUMBER.
           MOVE ACTIONI  TO CA-ACTION-FLAG.
           PERFORM 1400-PROCESS-CUSTOMER-RECORD.
           IF PROCESS-OK
               EVALUATE ACTIONI
                   WHEN '1'
                       MOVE ADD-INSTRUCTION TO INSTR2O
                       SET PROCESS-ADD-CUSTOMER TO TRUE
                   WHEN '2'
                       MOVE CHANGE-INSTRUCTION TO INSTR2O
                       SET PROCESS-CHANGE-CUSTOMER TO TRUE
                   WHEN '3'
                       MOVE DELETE-INSTRUCTION TO INSTR2O
                       SET PROCESS-DELETE-CUSTOMER TO TRUE
                       MOVE ATTR-PROT TO LNAMEA
                                         FNAMEA
                                         ADDRA
                                         CITYA
                                         STATEA
                                         ZIPCODEA
               END-EVALUATE
               IF NOT PROCESS-DELETE-CUSTOMER
                   INSPECT CA-CUSTOMER-RECORD
                       REPLACING ALL SPACE BY '_'
               END-IF
               MOVE CUSTNO1I       TO CUSTNO2O
               MOVE CA-LAST-NAME   TO LNAMEO
               MOVE CA-FIRST-NAME  TO FNAMEO
               MOVE CA-ADDRESS     TO ADDRO
               MOVE CA-CITY        TO CITYO
               MOVE CA-STATE       TO STATEO
               MOVE CA-ZIP-CODE    TO ZIPCODEO
               MOVE -1             TO LNAMEL
               SET SEND-ERASE TO TRUE
               PERFORM 1500-SEND-DATA-MAP
           ELSE
               MOVE LOW-VALUE TO CUSTNO1O
                                 ACTIONO
               SET SEND-DATAONLY-ALARM TO TRUE
               MOVE -1 TO CUSTNO1L
               PERFORM 1600-SEND-KEY-MAP
           END-IF.
      *
       1400-PROCESS-CUSTOMER-RECORD.
      *
           EXEC CICS
               LINK PROGRAM('CSTMNTB')
               COMMAREA(COMMUNICATION-AREA)
           END-EXEC.
      *
           IF PROCESS-SEVERE-ERROR
               PERFORM 9999-TERMINATE-PROGRAM
           ELSE
               MOVE CA-RETURN-MESSAGE TO MSG1O
           END-IF.
      *
       1500-SEND-DATA-MAP.
      *
           MOVE 'CMNT' TO TRANID2O.
      *
           EVALUATE TRUE
               WHEN SEND-ERASE
                   EXEC CICS
                       SEND MAP('CMNTMP2')
                            MAPSET('CMNTSET')
                            FROM(CMNTMP2O)
                            ERASE
                            CURSOR
                   END-EXEC
               WHEN SEND-DATAONLY-ALARM
                   EXEC CICS
                       SEND MAP('CMNTMP2')
                            MAPSET('CMNTSET')
                            FROM(CMNTMP2O)
                            DATAONLY
                            ALARM
                            CURSOR
               END-EXEC
           END-EVALUATE.
      *
       1600-SEND-KEY-MAP.
      *
           MOVE 'CMNT' TO TRANID1O.
      *
           EVALUATE TRUE
               WHEN SEND-ERASE
                   EXEC CICS
                       SEND MAP('CMNTMP1')
                            MAPSET('CMNTSET')
                            FROM(CMNTMP1O)
                            ERASE
                            CURSOR
                   END-EXEC
               WHEN SEND-ERASE-ALARM
                   EXEC CICS
                       SEND MAP('CMNTMP1')
                            MAPSET('CMNTSET')
                            FROM(CMNTMP1O)
                            ERASE
                            ALARM
                            CURSOR
                   END-EXEC
               WHEN SEND-DATAONLY-ALARM
                   EXEC CICS
                       SEND MAP('CMNTMP1')
                            MAPSET('CMNTSET')
                            FROM(CMNTMP1O)
                            DATAONLY
                            ALARM
                            CURSOR
               END-EXEC
           END-EVALUATE.
      *
       2000-PROCESS-ADD-CUSTOMER.
      *
           PERFORM 2100-RECEIVE-DATA-MAP.
           PERFORM 2200-EDIT-CUSTOMER-DATA.
           IF VALID-DATA
               PERFORM 2300-SET-CUSTOMER-DATA
               PERFORM 1400-PROCESS-CUSTOMER-RECORD
               IF PROCESS-OK
                   SET SEND-ERASE TO TRUE
               ELSE
                   SET SEND-ERASE-ALARM TO TRUE
               END-IF
               MOVE -1 TO CUSTNO1L
               PERFORM 1600-SEND-KEY-MAP
               SET PROCESS-KEY-MAP TO TRUE
           ELSE
               MOVE LOW-VALUE TO LNAMEO
                                 FNAMEO
                                 ADDRO
                                 CITYO
                                 STATEO
                                 ZIPCODEO
               SET SEND-DATAONLY-ALARM TO TRUE
               PERFORM 1500-SEND-DATA-MAP
           END-IF.
      *
       2100-RECEIVE-DATA-MAP.
      *
           EXEC CICS
               RECEIVE MAP('CMNTMP2')
                       MAPSET('CMNTSET')
                       INTO(CMNTMP2I)
           END-EXEC.
           INSPECT CMNTMP2I
               REPLACING ALL '_' BY SPACE.
      *
       2200-EDIT-CUSTOMER-DATA.
      *
           MOVE ATTR-NO-HIGHLIGHT TO ZIPCODEH
                                     STATEH
                                     CITYH
                                     ADDRH
                                     FNAMEH
                                     LNAMEH.
      *
           IF    ZIPCODEI = SPACE
              OR ZIPCODEL = ZERO
               MOVE ATTR-REVERSE TO ZIPCODEH
               MOVE -1 TO ZIPCODEL
               MOVE 'You must enter a zip code.' TO MSG2O
               MOVE 'N' TO VALID-DATA-SW
           END-IF.
      *
           IF    STATEI = SPACE
              OR STATEL = ZERO
               MOVE ATTR-REVERSE TO STATEH
               MOVE -1 TO STATEL
               MOVE 'You must enter a state.' TO MSG2O
               MOVE 'N' TO VALID-DATA-SW
           END-IF.
      *
           IF    CITYI = SPACE
              OR CITYL = ZERO
               MOVE ATTR-REVERSE TO CITYH
               MOVE -1 TO CITYL
               MOVE 'You must enter a city.' TO MSG2O
               MOVE 'N' TO VALID-DATA-SW
           END-IF.
      *
           IF    ADDRI = SPACE
              OR ADDRL = ZERO
               MOVE ATTR-REVERSE TO ADDRH
               MOVE -1 TO ADDRL
               MOVE 'You must enter an address.' TO MSG2O
               MOVE 'N' TO VALID-DATA-SW
           END-IF.
      *
           IF    FNAMEI = SPACE
              OR FNAMEL = ZERO
               MOVE ATTR-REVERSE TO FNAMEH
               MOVE -1 TO FNAMEL
               MOVE 'You must enter a first name.' TO MSG2O
               MOVE 'N' TO VALID-DATA-SW
           END-IF.
      *
           IF    LNAMEI = SPACE
              OR LNAMEL = ZERO
               MOVE ATTR-REVERSE TO LNAMEH
               MOVE -1 TO LNAMEL
               MOVE 'You must enter a last name.' TO MSG2O
               MOVE 'N' TO VALID-DATA-SW
           END-IF.
      *
       2300-SET-CUSTOMER-DATA.
      *
           MOVE CUSTNO2I TO CA-CUSTOMER-NUMBER.
           MOVE LNAMEI   TO CA-LAST-NAME.
           MOVE FNAMEI   TO CA-FIRST-NAME.
           MOVE ADDRI    TO CA-ADDRESS.
           MOVE CITYI    TO CA-CITY.
           MOVE STATEI   TO CA-STATE.
           MOVE ZIPCODEI TO CA-ZIP-CODE.
      *
       3000-PROCESS-CHANGE-CUSTOMER.
      *
           PERFORM 2100-RECEIVE-DATA-MAP.
           PERFORM 2200-EDIT-CUSTOMER-DATA.
           IF VALID-DATA
               PERFORM 2300-SET-CUSTOMER-DATA
               PERFORM 1400-PROCESS-CUSTOMER-RECORD
               IF PROCESS-OK
                   SET SEND-ERASE TO TRUE
               ELSE
                   SET SEND-ERASE-ALARM TO TRUE
               END-IF
               MOVE -1 TO CUSTNO1L
               PERFORM 1600-SEND-KEY-MAP
               SET PROCESS-KEY-MAP TO TRUE
           ELSE
               MOVE LOW-VALUE TO LNAMEO
                                 FNAMEO
                                 ADDRO
                                 CITYO
                                 STATEO
                                 ZIPCODEO
               SET SEND-DATAONLY-ALARM TO TRUE
               PERFORM 1500-SEND-DATA-MAP
           END-IF.
      *
       4000-PROCESS-DELETE-CUSTOMER.
      *
           PERFORM 1400-PROCESS-CUSTOMER-RECORD.
           IF PROCESS-OK
               SET SEND-ERASE TO TRUE
           ELSE
               SET SEND-ERASE-ALARM TO TRUE
           END-IF.
           MOVE -1 TO CUSTNO1L.
           PERFORM 1600-SEND-KEY-MAP.
           SET PROCESS-KEY-MAP TO TRUE.
      *
       9999-TERMINATE-PROGRAM.
      *
           MOVE CA-ERR-RESP  TO ERR-RESP.
           MOVE CA-ERR-RESP2 TO ERR-RESP2.
           MOVE EIBTRNID     TO ERR-TRNID.
           MOVE CA-ERR-RSRCE TO ERR-RSRCE.
      *
           EXEC CICS
               XCTL PROGRAM('SYSERR')
                    COMMAREA(ERROR-PARAMETERS)
           END-EXEC.

