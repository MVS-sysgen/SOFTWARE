//COB2DTEC JOB (001),'TEST GETDTE',              <-- Review and Modify
//             CLASS=A,MSGCLASS=X,               <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  Test Driver to sample COBOL call to GETDTE          *
//* -------------------------------------------------------*
//STEP01  EXEC COBUCLG,CPARM1='LIST,LOAD,NODECK,PMAP,DMAP,LIB',
//        COND.LKED=(0,NE,COB),
//        COND.GO=(0,NE,LKED)
//COB.SYSIN DD *
       IDENTIFICATION DIVISION.
       PROGRAM-ID.             COB2DTE.
       AUTHOR.                 Larry Belmontes.
       REMARKS.
                               This program calls GETDTE and
                               displays results via DISPLAY and
                               PRTOUT DD.

                               This program calls GETDTE with and
                               with no parms for testing purposes.

                               This program serves as a sample of
                               COBOL calling GETDTE.

           https://www.shareabitofit.net/GETDTE-in-MVS38J            */
                                                                     */
                                                                     */
           Disclaimer:                                               */
           -----------                                               */
           No guarantee; No warranty; Install / Use at your own risk.*/
                                                                     */
           This software is provided ôAS ISö and without any         */
           expressed or implied warranties, including, without       */
           limitation, the implied warranties of merchantability     */
           and fitness for a particular purpose.                     */
                                                                     */
           The author requests keeping authors name intact in any    */
           modified versions.                                        */
                                                                     */
           In addition, the author requests submissions regarding    */
           any code modifications / enhancements and/or associated   */
           comments for consideration into a subsequent release      */
           (giving credit to contributor(s)) thus, improving overall */
           functionality benefiting the MVS 3.8J hobbyist public     */
           domain community.                                         */
                                                                     */
       EJECT
       ENVIRONMENT DIVISION.

       CONFIGURATION SECTION.
       SOURCE-COMPUTER.        IBM-4341.
       OBJECT-COMPUTER.        IBM-4341.
       SPECIAL-NAMES.          C01 IS TO-TOP-OF-PAGE.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *
           SELECT REPORT-FILE ASSIGN TO UR-1403-S-PRTOUT.
      *
       EJECT
       DATA DIVISION.

       FILE SECTION.

       FD  REPORT-FILE
           RECORDING MODE IS F
           RECORD CONTAINS 133 CHARACTERS
           LABEL RECORDS ARE OMITTED
           DATA RECORD IS REPORT-LINE.
       01  REPORT-LINE.
           05  CC                  PIC X(01).
           05  REPORT-L132         PIC X(132).

       EJECT
       WORKING-STORAGE SECTION.

       01  RDTECOM  COPY RDTECOMC.

       EJECT
       01  RC-X     PIC 9999.

       EJECT
       PROCEDURE DIVISION.

       0000-MAINLINE SECTION.

      ******************************************************
      * Open Files                                         *
      ******************************************************
           OPEN OUTPUT REPORT-FILE.
           MOVE SPACES   TO CC.
           MOVE 'OPEN REPORT FILE' TO REPORT-L132.
           WRITE REPORT-LINE
                     AFTER 1.

      ******************************************************
      * Call GETDTE with NO commarea and disply results    *
      ******************************************************
           MOVE ALL '*'          TO RDTECOM.
           MOVE SPACES           TO CC.
           MOVE '1. DATA:'       TO REPORT-L132.
           WRITE REPORT-LINE
                     AFTER 1.
           DISPLAY '1. B4 CALL USING DISPLAY OUTPUT'.
           CALL 'GETDTE'.
           MOVE RETURN-CODE      TO RC-X.
           DISPLAY '1. BACK FROM CALL  RC=' RC-X.
           DISPLAY 'DATA=' RDTECOM.
           MOVE SPACES           TO CC.
           MOVE RDTECOM          TO REPORT-L132.
           WRITE REPORT-LINE
                       AFTER 1.

      ******************************************************
      * Call GETDTE with commarea and disply results       *
      ******************************************************
           MOVE SPACES           TO REPORT-L132.
           WRITE REPORT-LINE
                     AFTER 1.
           MOVE ALL '*'          TO RDTECOM.
           MOVE SPACES           TO CC.
           MOVE '2. DATA:'       TO REPORT-L132.
           WRITE REPORT-LINE
                     AFTER 1.
           DISPLAY ' '.
           DISPLAY '2. B4 CALL USING DISPLAY OUTPUT'.
           CALL 'GETDTE' USING RDTECOM.
           MOVE RETURN-CODE      TO RC-X.
           DISPLAY '2. BACK FROM CALL  RC=' RC-X.
           DISPLAY 'DATA=' RDTECOM.
           MOVE SPACES           TO CC.
           MOVE RDTECOM          TO REPORT-L132.
           WRITE REPORT-LINE
                       AFTER 1.

      ******************************************************
      * Close files                                        *
      ******************************************************
           MOVE SPACES   TO CC.
           MOVE 'CLOSE REPORT FILE' TO REPORT-L132.
           WRITE REPORT-LINE
                     AFTER 1.
           CLOSE REPORT-FILE.

      ******************************************************
      * Return to OS                                       *
      ******************************************************
           GOBACK.

/*
//COB.SYSLIB  DD
//            DD DSN=GETDTE.V1R0M00.ASM,DISP=SHR  -- RDTECOMC
//LKED.SYSLIB DD
//            DD DSN=SYS2.LINKLIB,DISP=SHR        -- GETDTE
//GO.SYSPRINT DD SYSOUT=*
//GO.SYSOUT   DD SYSOUT=*                         -- DISPLAY output
//GO.PRTOUT   DD SYSOUT=*                         -- REPORT  output
//GO.SYSDUMP  DD SYSOUT=*
//GO.SYSABEND DD SYSOUT=*
//
