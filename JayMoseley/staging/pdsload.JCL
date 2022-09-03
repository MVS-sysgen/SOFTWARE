//PDSLOAD$ JOB (001),'INSTALL PDSLOAD'
//* ********************************************************            00030000
//* *  INSTALL THE 'PDSLOAD' PROGRAM                       *            00040000
//* ********************************************************            00050000
//PDSLOAD  EXEC ASMFCL,                                                 00060000
//         PARM.ASM='LIST,OBJECT,NODECK,TERM,RENT,ALIGN',               00070000
//         PARM.LKED='LIST,MAP,RENT'                                    00080000
//SYSTERM  DD SYSOUT=*                                                  00090000
//SYSIN    DD *                                                         00100000
PDSLOAD  TITLE '   P D S L O A D    '                                   00110000
*$DOC@***************************************************************** 00120000
*                                                                     * 00130000
*          PDSLOAD - LOAD SEQUENTIAL DATA SET INTO PDS MEMBERS        * 00140000
*                                                                     * 00150000
*********************************************************************** 00160000
*                                                                       00170000
*         WRITTEN BY: BILL GODFREY, PLANNING RESEARCH CORPORATION.      00180000
*         INSTALLATION: PRC COMPUTER CENTER INC, MCLEAN VA.             00190000
*         DATE WRITTEN: NOVEMBER 25 1980.                               00200000
*         DATE UPDATED: FEBRUARY 13, 2000                               00210000
*         ATTRIBUTES: RE-ENTRANT. (AMODE AND RMODE MUST BE 24.)         00220000
*                                                                       00230000
*         THIS PROGRAM CONVERTS A SEQUENTIAL DATA SET OF PDS            00240000
*         MEMBERS IN 'IEBUPDTE' FORMAT TO A PARTITIONED DATA SET.       00250000
*                                                                       00260000
*         THE IEBUPDTE UTILITY PROGRAM CAN DO THE SAME THING,           00270000
*         BUT THIS PROGRAM HAS THE FOLLOWING ADDED CAPABILITIES:        00280000
*         .  STORES SPF STATISTICS IN A MEMBER'S DIRECTORY ENTRY        00290000
*            IF THEY ARE PRESENT ON THE './ ADD' STATEMENT,             00300000
*         .  CAN GENERATE SPF STATISTICS IF NONE ARE PRESENT,           00310000
*         .  CAN SELECT ONE MEMBER FROM INPUT FILE,                     00320000
*         .  RESTORES MODIFIED IEBUPDTE STATEMENTS WITHIN A MEMBER      00330000
*            (CHANGES '/.' BACK TO './').                               00340000
*         .  DOES NOT LIST THE DATA IN THE MEMBER,                      00350000
*         .  PRINTS NUMBER OF RECORDS FOR EACH MEMBER WRITTEN.          00360000
*                                                                       00370000
*         IF PARM='UPDTE(XX)' IS SPECIFIED, THEN ALL OCCURRENCES        00380000
*         OF THE 2 CHARACTERS IN PARENTHESES WILL BE CHANGED TO         00390000
*         './' BEFORE BEING WRITTEN TO THE PDS, IF THEY OCCUR           00400000
*         IN COLUMNS 1-2 OF THE DATA.  THIS IS USED IN CONJUNCTION      00410000
*         WITH ANOTHER PROGRAM WHICH CREATES IEBUPDTE-FORMAT            00420000
*         DATA SETS FROM A PDS, AND IN SO DOING CHANGES ALL             00430000
*         OCCURRENCES OF './' IN COLUMNS 1-2 OF THE DATA WITHIN         00440000
*         THE MEMBERS TO ANOTHER CONSTANT, SO IEBUPDTE AND THIS         00450000
*         PROGRAM WILL NOT TREAT THE DATA RECORDS AS CONTROL CARDS.     00460000
*         IEBUPDTE DOESNT CHANGE THE DATA BACK. THIS PROGRAM DOES.      00470000
*                                                                       00480000
*         LOG OF CHANGES:                                               00490000
*          28MAY81 - SUPPORT NAME= AS SECOND OPERAND (FOLLOWING SSI).   00500000
*          28MAY81 - SINGLE MEMBER MAY BE SPECIFIED IN PARM.            00510000
*                    PARM='S(ABC)' WILL SELECT MEMBER 'ABC' ONLY.       00520000
*          28MAY81 - PARM=SPF WILL FORCE SPF STATS TO BE GENERATED.     00530000
*                    IF SPF IS SPECIFIED IN PARM, IT MUST BE FIRST.     00540000
*                    IF UPDTE(XX) IS SPECIFIED, IT MUST BE LAST.        00550000
*---------------------------------------------------------------------- 00560000
*          ??JUL87 - THIS VERSION OF THE PDSLOAD PROGRAM HAS BEEN       00570000
*                    MODIFIED WITH A GLOBAL VARIABLE SO THE LRECL OF    00580000
*                    THE INPUT AND OUTPUT DATASETS CAN BE CHANGED       00590000
*                    MERELY BY MODIFYING THE GLOBAL AND REASSEMBLING    00600000
*                    THE PROGRAM.  AN EYECATCHER HAS BEEN ADDED SO      00610000
*                    THAT YOU CAN SEE THE ASSEMBLED LRECL BY BROWSING   00620000
*                    THE LOAD MODULE.  SEE LABEL "&LRECL".              00630000
*                    YOU NEED TO REASSEMBLE THE PROGRAM EVERY TIME YOU  00640000
*                    WANT TO CHANGE THE LRECL THAT THE PROGRAM TAKES.   00650000
*                    (ADMITTEDLY IT'S BETTER TO DO THIS WITH A PARM AT  00660000
*                    EXECUTION TIME.)  BUT THIS WORKS.  (IT HAS NOT     00670000
*                    BEEN TESTED WITH LRECL MUCH LESS THAN 80.)         00680000
*                                                                       00690000
* S. GOLOB - NEWSWEEK - MOUNTAIN LAKES, N.J.                        NWK 00700000
*---------------------------------------------------------------------- 00710000
*          01SEP92 - AVOID ABEND S0C4 AFTER ERROR RETURN CODE FROM      00720000
*                    STOW.  (EG. DIRECTORY FULL, OR, I/O ERROR.)        00730000
*                  - CEASE PROCESSING INPUT RECORDS AFTER A './ ENDUP ' 00740000
*                    RECORD IS ENCOUNTERED.                             00750000
*                  - DELETE RUN-TIME CODE TO LOAD EXIT ENTRY POINTS     00760000
*                    INTO DCB AREAS BY SPECIFYING APPROPRIATE OPERANDS  00770000
*                    ON THE DCB MACROS.                                 00780000
*                  - DELETE THE &LRECL SYMBOLIC VARIABLE AND ALTER      00790000
*                    CODE TO HANDLE ANY RECORD SIZE UP TO 256.          00800000
*                    RECORD FORMAT MUST STILL BE FIXED LENGTH RECORDS.  00810000
*                    INPUT AND OUTPUT RECORD LENGTHS NEED NOT BE THE    00820000
*                    SAME.  HENCE, OFFLOAD/PDSLOAD CAN BE USED TO       00830000
*                    TRUNCATE OR EXTEND THE RECORD LENGTH OF A PDS.     00840000
*                  - ENSURE BLANKS ARE USED FOR RECORD EXTENSION.       00850000
*                  - IF THE OPEN OF SYSUT1 FAILS THEN THE OPEN IS       00860000
*                    RETRIED WITH DDNAME=SYSIN IN CASE THE JOB IS       00870000
*                    A HASTILY RE-EDITED IEBUPDTE JOB STREAM.           00880000
*                  - REDO LOGIC OF PDS OPEN EXIT TO COPY INPUT LRECL    00890000
*                    TO OUTPUT LRECL (IF NOT SUPPLIED), AND TO USE      00900000
*                    SYSTEM-DETERMINED BLOCKSIZE (IF NOT SUPPLIED)      00910000
*                    IF DFP IS 2.4.0 OR HIGHER.  OTHERWISE, 39 TIMES    00920000
*                    THE LRECL IS USED IF IT IS LESS THAN 32K (WHICH    00930000
*                    IT SHOULD BE SINCE MAX LRECL IS 256), OR IF IT     00940000
*                    IS NOT UNDER 32K THEN THE PDS IS NOT BLOCKED.      00950000
*                                                                       00960000
* GREG PRICE - FERNTREE COMPUTER SERVICES - MELBOURNE, AUSTRALIA  GP@FT 00970000
*---------------------------------------------------------------------- 00980000
*          26JUN98 - ADD Y2K DATE WINDOWING CODE FOR SPFCREDT AND       00990000
*                    SPFCHGDT.                                          01000000
*                                                                       01010000
* JOHN KALINICH - USA LSSC, ST. LOUIS, MISSOURI               DRK JUN98 01020000
*---------------------------------------------------------------------- 01030000
*          20APR99 - SUPPORT ANY LRECL FOR FIXED-LENGTH AND             01040000
*                    VARIABLE LENGTH RECORDS.                           01050000
*                  - FIXED-LENGTH OUTPUT RECORDS ARE WRITTEN FROM       01060000
*                    EITHER FIXED-LENGTH OR VARIABLE-LENGTH INPUT.      01070000
*                    (OFTEN PC TEXT FILE TRANSFERS GO TO A RECFM=VB     01080000
*                    DATA SET ON MVS.)                                  01090000
*                  - VARIABLE-LENGTH OUTPUT DATA REQUIRES VARIABLE-     01100000
*                    LENGTH INPUT RECORDS.                              01110000
*                  - MINIMUM INPUT LRECL (F AND V) REMAINS AT 80, BUT   01120000
*                    MINIMUM OUTPUT LRECL IS 1 (PLUS 4 FOR RDW IF V).   01130000
*                  - RECORDS ARE TRUNCATED TO FIT INTO THE OUTPUT       01140000
*                    LRECL AS NECESSARY.                                01150000
*                  - BLANKS ARE USED TO EXTEND FIXED-LENGTH RECORDS     01160000
*                    WHERE OUTPUT LRECL IS BIGGER THAN INPUT LRECL.     01170000
*                  - SUPPORT DDNAME OVERRIDES AS PER IEBUPDTE AND       01180000
*                    OTHER OS UTILITIES FOR INTERFACING WITH REVIEW.    01190000
*                  - PARM=NEW IS USED TO REQUEST IEBUPDTE BEHAVIOUR.    01200000
*                    SPECIFICALLY, OPENING SYSUT1 IS NOT ATTEMPTED,     01210000
*                    AND SYSIN IS ASSUMED TO SPECIFY THE INPUT FILE.    01220000
*                    'NEW' MUST BE THE FIRST OR ONLY OPTION IN THE      01230000
*                    PARAMETER STRING, BEFORE 'SPF' EVEN.               01240000
*                  - THE RECORD COUNT STORED IN SPF STATISTICS WILL     01250000
*                    BE THE NUMBER OF RECORDS LOADED BY PDSLOAD, AND    01260000
*                    NOT NECESSARILY THE VALUE ON THE ./ ADD CARD.      01270000
*                  - SUPPORT MEMBER NAME SELECTION BY MASK.             01280000
*                    EG. S(ABC)      - MEMBER ABC ONLY.                 01290000
*                        S(ABC*****) - ALL MEMBERS STARTING WITH ABC.   01300000
*                        S(*BC*)     - ABC, ABCD, EBC3 BUT NOT ABCDE.   01310000
*                    ASTERISK (*), QUESTION MARK (?), AND PERCENT       01320000
*                    SIGN (%) CAN BE USED INTERCHANGABLY AS SINGLE-     01330000
*                    CHARACTER PLACEHOLDERS.                            01340000
*                  - ENSURE SPF STATS DATA FROM ./ ADD ARE NUMERIC.     01350000
* GREG PRICE                                                      GP@P6 01360000
*---------------------------------------------------------------------- 01370000
*          13FEB00 - STARTOOL'S "COMBINE" SUBCOMMAND PUTS     SBG 02/00 01380000
*                    ISPF STATISTICS RECORDS INTO THE ./ ADD  SBG 02/00 01390000
*                    CARDS DIFFERENTLY THAN LISTPDS AND       SBG 02/00 01400000
*                    REVIEW.  PDSLOAD IS BEING MODIFIED TO    SBG 02/00 01410000
*                    RECOGNIZE EITHER FORMAT, AND TO BE ABLE  SBG 02/00 01420000
*                    TO RE-CONSTITUTE THE ISPF STATS NO       SBG 02/00 01430000
*                    MATTER WHICH UTILITY WAS USED TO CREATE  SBG 02/00 01440000
*                    THEM, INSIDE THE ./ ADD NAME=XXXX CARDS. SBG 02/00 01450000
*                                                             SBG 02/00 01460000
*      WHAT "STARTOOL COMBINE" WAS DOING, THE DIFFERENCE      SBG 02/00 01470000
*      IS AS FOLLOWS:   "CREATE DATE" AND "MODIFY DATE"       SBG 02/00 01480000
*      ARE GIVEN SEVEN CHARACTERS INSTEAD OF FIVE, THAT IS:   SBG 02/00 01490000
*                                                             SBG 02/00 01500000
*        CCYYDDD , INSTEAD OF YYDDD .                         SBG 02/00 01510000
*                                                             SBG 02/00 01520000
*      THIS INTRODUCES FOUR EXTRA CHARACTERS.  IF YOU HAVE    SBG 02/00 01530000
*      A 7-CHARACTER USERID, A NON-BLANK WILL BE SHOVED INTO  SBG 02/00 01540000
*      COLUMN 72, RENDERING THE MEMBER UN-STOWABLE BY IBM'S   SBG 02/00 01550000
*      IEBUPDTE.  IEBUPDTE TREATS THE NON-BLANK IN COLUMN 72  SBG 02/00 01560000
*      AS A CONTINUATION CHARACTER, AND EXPECTS ANOTHER       SBG 02/00 01570000
*      CONTROL CARD ON THE NEXT LINE.  AT LEAST PDSLOAD WILL  SBG 02/00 01580000
*      NOW BE ABLE TO DEAL WITH THIS SITUATION PROPERLY.      SBG 02/00 01590000
*                                                             SBG 02/00 01600000
*      I'VE ENTERED AN APAR WITH BRUCE LELAND OF STARTOOL     SBG 02/00 01610000
*      SUPPORT.  BUT THE OLD SEQUENTIAL DATASETS THAT HAVE    SBG 02/00 01620000
*      BEEN CREATED WITH EXISTING RELEASES OF STARTOOL, IN    SBG 02/00 01630000
*      ITS FORMAT, STILL HAVE TO BE DEALT WITH.               SBG 02/00 01640000
*                                                             SBG 02/00 01650000
* SAM GOLOB                                                   SBG 02/00 01660000
*---------------------------------------------------------------------- 01670000
*********************************************************************** 01680000
         EJECT                                                          01690000
*********************************************************************** 01700000
*                                                                       01710000
*     PDSLOAD NOW ACCEPTS DDNAME OVERRIDES IN THE SECOND PROGRAM        01720000
*     PARAMETER.  THE IBM OS/360-TO-OS/390 UTILITY PROGRAM DDNAME       01730000
*     PARAMETER FORMAT IS USED.  THE THIRD PARAMETER (INITIAL PAGE      01740000
*     NUMBER FOR REPORT) IS NOT USED.  THE SYSIN SLOT IS USED FOR       01750000
*     THE INPUT SEQUENTIAL FILE DDNAME, THE SYSPRINT SLOT IS USED       01760000
*     FOR THE OUTPUT REPORT DDNAME, AND THE SYSUT2 SLOT IS USED         01770000
*     FOR THE OUTPUT PARTITIONED FILE DDNAME.  THE PARAMETER            01780000
*     CONSISTS OF A HALFWORD LENGTH COUNT FOLLOWED BY A NUMBER OF       01790000
*     CONTIGUOUS 8-BYTE SLOTS.  PDSLOAD REQUIRES THAT THE LENGTH        01800000
*     COUNT IS A MULTIPLE OF 8.  A NULL SLOT MEANS NO OVERRIDE FOR      01810000
*     THE CORRESPONDING DDNAME.  THERE IS NO MINIMUM SLOT COUNT         01820000
*     REQUIREMENT.  DDNAMES MUST BE PADDED WITH BLANKS TO 8-BYTES       01830000
*     IF NECESSARY.                                                     01840000
*                                                                       01850000
*     THE ABILITY TO OVERRIDE DDNAMES WAS IMPLEMENTED TO FACILITATE     01860000
*     THE DYNAMIC INVOCATION OF PDSLOAD FROM THE REVIEW TSO COMMAND.    01870000
*                                                                       01880000
*     THE IBM UTILITY DDNAME SLOT CONVENTION GOES SOMETHING LIKE THIS:  01890000
*         01  SYSLIN                                                    01900000
*         02  OUTPUT MEMBER NAME                                        01910000
*         03  SYSLMOD                                                   01920000
*         04  SYSLIB                                                    01930000
*         05  SYSIN                                                     01940000
*         06  SYSPRINT      (SYSLOUT)                                   01950000
*         07  SYSPUNCH                                                  01960000
*         08  SYSUT1                                                    01970000
*         09  SYSUT2                                                    01980000
*         10  SYSUT3                                                    01990000
*         11  SYSUT4                                                    02000000
*         12  SYSTERM                                                   02010000
*         13  SYSUT5                                                    02020000
*         14  SYSUT6        (SYSCIN FOR PL/I COMPILER)                  02030000
*         15  SYSUT7                                                    02040000
*         16  SYSADATA                                                  02050000
*         17  SYSIDL                                                    02060000
*                                                                       02070000
*********************************************************************** 02080000
         EJECT                                                          02090000
*********************************************************************** 02100000
*                                                                       02110000
*         THE ONLY IEBUPDTE CONTROL STATEMENTS THAT ARE ACCEPTABLE      02120000
*         ARE THE ./ ADD STATEMENT AND THE ./ ALIAS STATEMENT.          02130000
*         THE 'NAME=' OPERAND MUST BE SPECIFIED AS THE FIRST OR         02140000
*         SECOND OPERAND (SOMETIMES SSI= IS SPECIFIED FIRST).           02150000
*         ANY OTHER IEBUPDTE OPERAND (EXCEPT SSI=) IS INVALID AND       02160000
*         WILL PREVENT SUBSEQUENT OPERANDS FROM BEING PROCESSED.        02170000
*         ./ ENDUP STATEMENTS WILL NOW TERMINATE PROCESSING.            02180000
*                                                                       02190000
*         THESE ADD STATEMENTS WILL BE PROCESSED CORRECTLY -            02200000
*         ./ ADD NAME=XYZ                                               02210000
*         ./ ADD NAME=XYZ,SSI=0012C06A                                  02220000
*         ./ ADD SSI=1234ABCD,NAME=XYZ                                  02230000
*                                                                       02240000
*         IN ORDER FOR SPF STATISTICS TO BE STORED, THE './ ADD'        02250000
*         STATEMENT MUST LOOK LIKE THIS:                                02260000
*                                                                       02270000
*            COL     DESCRIPTION                                        02280000
*            1-20    ./ ADD NAME=XXXXXXXX                               02290000
*            21      BLANK                                              02300000
*            22-71   VVMM-YYDDD-YYDDD-HHMM-NNNNN-NNNNN-NNNNN-UUUUUUUUUU 02310000
*                    VER CREATE LASTMODIFY  SIZE  INIT   MOD   ID       02320000
*                                                                       02330000
*         THE 'LISTPDS' UTILITY PROGRAM (FROM NASA GODDARD) HAS         02340000
*         BEEN LOCALLY MODIFIED TO PUNCH AN IEBUPDTE DECK WITH          02350000
*         SPF STATISTICS IN THE ABOVE FORMAT. IT DOES NOT PUNCH         02360000
*         ./ ALIAS STATEMENTS, HOWEVER.                                 02370000
*                                                                       02380000
*         THE 'REVIEW' UTILITY TSO COMMAND IN CBT FILE 134 HAS          02390000
*         BEEN LOCALLY MODIFIED TO PUNCH AN IEBUPDTE DECK WITH          02400000
*         SPF STATISTICS IN THE ABOVE FORMAT. IT CAN ALSO PUNCH         02410000
*         ./ ALIAS STATEMENTS WHEN THE MEMBER LIST HAS BEEN SORTED      02420000
*         INTO TTR ORDER.                                               02430000
*                                                                       02440000
*         THE SPF DATA IS IN THE 'COMMENTS' AREA OF THE STATEMENT       02450000
*         SO THE INPUT COULD BE RUN THRU 'IEBUPDTE' SUCCESSFULLY.       02460000
*         IT WOULD JUST IGNORE THE SPF DATA.                            02470000
*                                                                       02480000
*         THE FORMAT OF THE 50-BYTE SPF FIELD IS FIXED. EACH VALUE      02490000
*         MUST HAVE THE CORRECT NUMBER OF DIGITS (USE LEADING ZEROES    02500000
*         IF NECESSARY). ONLY THE 10-BYTE 'ID' FIELD AT THE END         02510000
*         MAY HAVE A VARIABLE LENGTH. NO IMBEDDED BLANKS ALLOWED.       02520000
*         VALUES MUST BE SEPARATED BY A HYPEN AS ABOVE. IF THE          02530000
*         DATA DOES NOT CONFORM TO THESE RULES, THE MEMBER WILL         02540000
*         STILL BE WRITTEN BUT WITHOUT SPF STATISTICS.  NOTE THAT       02550000
*         ISPF INSISTS THAT THE NINTH AND TENTH BYTES OF THE USERID     02560000
*         ARE BLANKS OR ISPF WILL NOT SHOW THE STATISTICS.              02570000
*                                                                       02580000
*         INPUT (SYSUT1) DCB ATTRIBUTES NEED NOT BE SPECIFIED IF        02590000
*         THE FILE HAS STANDARD LABELS. IF IT IS AN UNLABELED TAPE,     02600000
*         ONLY THE BLKSIZE NEED BE SPECIFIED (IF IT IS NOT &LRECL).     02610000
*                                                                       02620000
*         IF THE OUTPUT FILE DOES NOT HAVE ATTRIBUTES IN ITS LABEL      02630000
*         AND NONE ARE SPECIFIED IN THE SYSUT2 DD STATEMENT, THE        02640000
*         PROGRAM WILL SET THEM TO LRECL=&LRECL, BLKSIZE=39*&LRECL. NWK 02650000
*                                                                       02660000
*         RECOMMENDATION: SUPPLY COMPLETE INPUT DCB EITHER VIA DATA     02670000
*         SET LABELS (TAPE OR DISK) OR VIA JCL.                         02680000
*                                                                       02690000
*         NOTES ON OUTPUT DCB:  IF SUPPLIED COMPLETELY FROM DATA SET    02700000
*         LABELS, JCL, OR BOTH COMBINED, THEN THAT IS FINE.  SOME       02710000
*         PEOPLE CODE 'RECFM=F,BLKSIZE=80' SO DCBLRECL IS ZERO.         02720000
*         HENCE, IF OUTPUT BLKSIZE IS SUPPLIED AND OUTPUT LRECL IS      02730000
*         NOT, THEN IT IS COPIED FROM THE OUTPUT BLKSIZE AND AN         02740000
*         UNBLOCKED PDS IS ASSUMED.  IF BOTH LRECL AND BLKSIZE ARE      02750000
*         SUPPLIED THEN THE SUPPLIED VALUES ARE USED.  IF NEITHER ARE   02760000
*         SUPPLIED THEN THE OUTPUT LRECL IS COPIED FROM THE INPUT       02770000
*         SEQUENTIAL FILE LRECL.  IF YOU HAVE DFP 2.4.0 OR LATER        02780000
*         THEN CODE OR LEAVE OUTPUT BLKSIZE=0 FOR SYSTEM-DETERMINED     02790000
*         BLOCKSIZE.  OLD DFP OR NON-DFP DEFAULT IS 39 TIMES LRECL.     02800000
*                                                                       02810000
*$DOC$***************************************************************** 02820000
         SPACE                                                          02830000
PDSLOAD  START                                                          02840000
         USING PDSLOAD,R15                                              02850000
         B     @PROLOG                                                  02860000
         DROP  R15                                                      02870000
*         DC    AL1(17),CL17'PDSLOAD &SYSDATC '                  *JLM*  02880000
         DC    AL1(23),CL23'PDSLOAD &SYSDATE &SYSTIME '          *JLM*  02890000
         DC    CL10' ANY LRECL'                                         02900000
         DC    CL48' OUT:  1:F,V->F (TRUNC,EXTEND)  2:V->V (TRUNC)  '   02910000
@SIZE    DC    0F'0',AL1(1),AL3(@DATAL)                                 02920000
         USING PDSLOAD,R10,R11                                          02930000
@PROLOG  STM   R14,R12,12(R13)                                          02940000
         LR    R10,R15             BASE REGISTER                        02950000
         LA    R15,4095                                                 02960000
         LA    R11,1(R15,R10)      BASE REGISTER                        02970000
         LR    R2,R1                                                    02980000
         L     R0,@SIZE                                                 02990000
         GETMAIN R,LV=(0)                                               03000000
         L     R15,@SIZE           TARGET SIZE                          03010000
         LR    R14,R1              TARGET ADDRESS                       03020000
         SLR   R5,R5               SOURCE SIZE AND PAD                  03030000
         MVCL  R14,R4              ZERO DYNAMIC AREA                    03040000
         ST    R13,4(,R1)          CHAIN SAVE AREAS                     03050000
         ST    R1,8(,R13)                                               03060000
         LR    R13,R1                                                   03070000
         USING @DATA,R13                                                03080000
         SPACE                                                          03090000
         ZAP   REPORTPG,=P'0'      INITIAL PAGE COUNTER                 03100000
         ZAP   REPORTLN,=P'0'      INITIAL LINE COUNTER                 03110000
         ZAP   REPORTMX,=P'50'     INITIAL LINES PER PAGE               03120000
         MVI   REPORTO-1,C' '      BLANK PROPOGATOR                     03130000
         MVI   LINE-1,C' '         BLANK PROPOGATOR                     03140000
         MVC   MEMSEL,=CL8' '                                           03150000
         MVC   UPDTE,=C'./'                                             03160000
         SPACE                                                          03170000
         L     R1,0(,R2)           POINT TO PARM                        03180000
         LH    R0,0(,R1)           GET LENGTH OF PARM                   03190000
         LTR   R0,R0                                                    03200000
         BZ    PARMX                                                    03210000
         LA    R1,2(,R1)           POINT TO PARM DATA                   03220000
         CH    R0,=H'3'            IS PARM LONG ENOUGH FOR SPF?         03230000
         BL    PARMSX              NO, BYPASS COMPARE                   03240000
         CLC   0(3,R1),=C'NEW'     IS IT NEW, AS PER IEBUPDTE?          03250000
         BNE   TRYSPF              NO                                   03260000
         OI    FLAG1,NEWPRM        YES, TOLERATE AS PDSLOAD DOES THIS   03270000
         LA    R1,3(,R1)                                                03280000
         SH    R0,=H'3'                                                 03290000
         BZ    PARMX                                                    03300000
         CLI   0(R1),C','                                               03310000
         BNE   PARMERR                                                  03320000
         LA    R1,1(,R1)           POINT PAST COMMA                     03330000
         SH    R0,=H'1'                                                 03340000
         BZ    PARMX                                                    03350000
TRYSPF   CLC   0(3,R1),=C'SPF'     IS IT SPF?                           03360000
         BNE   PARMSX              NO                                   03370000
         OI    FLAG1,GENSPF        YES, GENERATE SPF STATISTICS         03380000
         LA    R1,3(,R1)                                                03390000
         SH    R0,=H'3'                                                 03400000
         BZ    PARMX                                                    03410000
         CLI   0(R1),C','                                               03420000
         BNE   PARMERR                                                  03430000
         LA    R1,1(,R1)           POINT PAST COMMA                     03440000
         SH    R0,=H'1'                                                 03450000
         BZ    PARMX                                                    03460000
PARMSX   DS    0H                                                       03470000
PARMM    CH    R0,=H'3'            LONG ENOUGH FOR S(X ?                03480000
         BL    PARMERR             NO                                   03490000
         CLC   0(2,R1),=C'S('      IS IT S( ?                           03500000
         BNE   PARMMX              NO, BRANCH                           03510000
         LA    R1,2(,R1)           YES, POINT PAST PAREN                03520000
         SH    R0,=H'2'                                                 03530000
         LA    R15,MEMSEL                                               03540000
         LA    R14,MEMSEL+8                                             03550000
PARMML   CLI   0(R1),C')'                                               03560000
         BE    PARMME                                                   03570000
         CR    R15,R14             IS MEMBER NAME TOO LONG?             03580000
         BNL   PARMMIG             YES, IGNORE EXTRA CHARACTERS         03590000
         MVC   0(1,R15),0(R1)      COPY ONE BYTE OF MEMBER NAME         03600000
         LA    R15,1(,R15)                                              03610000
         LA    R1,1(,R1)                                                03620000
PARMMIG  BCT   R0,PARMML                                                03630000
         B     PARMX                                                    03640000
PARMME   LA    R1,1(,R1)           POINT PAST PAREN                     03650000
         SH    R0,=H'1'                                                 03660000
         BZ    PARMX                                                    03670000
         CLI   0(R1),C','                                               03680000
         BNE   PARMERR                                                  03690000
         LA    R1,1(,R1)           POINT PAST COMMA                     03700000
         SH    R0,=H'1'                                                 03710000
         BZ    PARMERR                                                  03720000
PARMMX   DS    0H                                                       03730000
         CH    R0,=H'9'            IS PARM LONG ENOUGH FOR UPDTE(XX)?   03740000
         BNE   PARMERR                                                  03750000
         CLC   0(6,R1),=C'UPDTE('                                       03760000
         BNE   PARMERR                                                  03770000
         CLI   08(R1),C')'                                              03780000
         BNE   PARMERR                                                  03790000
         MVC   UPDTE,6(R1)         LOOK FOR XX INSTEAD OF ./            03800000
         B     PARMX                                                    03810000
PARMERR  WTO   'PDSLOAD WILL ABEND - INVALID PARAMETER',ROUTCDE=(11)    03820000
         ABEND 100                                                      03830000
PARMX    DS    0H                                                       03840000
         EJECT                                                          03850000
************************************************************            03860000
*                                                          *            03870000
*        INITIALIZE THE DCBS                               *            03880000
*                                                          *            03890000
************************************************************            03900000
         SPACE                                                          03910000
         MVC   PRTDCBW(PRTDCBL),PRTDCB                                  03920000
         MVC   UT1DCBW(UT1DCBL),UT1DCB                                  03930000
         MVC   PDSDCBW(PDSDCBL),PDSDCB                                  03940000
         LA    R3,PRTDCBW                                               03950000
         LA    R4,UT1DCBW                                               03960000
         LA    R5,PDSDCBW                                               03970000
         TM    FLAG1,NEWPRM        WAS PARM=NEW SPECIFIED?              03980000
         BZ    NEWPRMOK            NO                                   03990000
         MVC   DDNAM(8,R4),=CL8'SYSIN'   YES, BEHAVE LIKE IEBUPDTE      04000000
NEWPRMOK TM    0(R2),X'80'         ANY DDNAME OVERRIDES?                04010000
         BO    PARM2X              NO, ONLY ONE PARAMETER               04020000
         L     R1,4(,R2)           POINT TO SECOND PARAMETER            04030000
         LA    R1,0(,R1)           ENSURE ADDRESS FORMAT                04040000
         LTR   R1,R1               ZERO POINTER?                        04050000
         BZ    PARM2BAD            YES, NO OVERRIDES SUPPLIED           04060000
         CLI   0(R1),0             LENGTH LESS THAN 256?                04070000
         BNE   PARM2BAD            NO                                   04080000
         TM    1(R1),7             MULTIPLE OF EIGHT?                   04090000
         BNZ   PARM2BAD            NO                                   04100000
         CLI   1(R1),8*5           SYSIN SLOT PRESENT?                  04110000
         BL    PARM2X              NO                                   04120000
         CLI   34(R1),0   (8*4+2)  SYSIN OVERRIDE SPECIFIED?            04130000
         BE    PARM2I              NO                                   04140000
         MVC   DDNAM(8,R4),34(R1)  YES, COPY IT INTO DCB                04150000
PARM2I   CLI   1(R1),8*6           SYSPRINT SLOT PRESENT?               04160000
         BL    PARM2X              NO                                   04170000
         CLI   42(R1),0   (8*5+2)  SYSPRINT OVERRIDE SPECIFIED?         04180000
         BE    PARM2P              NO                                   04190000
         MVC   DDNAM(8,R3),42(R1)  YES, COPY IT INTO DCB                04200000
PARM2P   CLI   1(R1),8*9           SYSUT2 SLOT PRESENT?                 04210000
         BL    PARM2X              NO                                   04220000
         CLI   66(R1),0   (8*8+2)  SYSUT2 OVERRIDE SPECIFIED?           04230000
         BE    PARM2X              NO                                   04240000
         MVC   DDNAM(8,R5),66(R1)  YES, COPY IT INTO DCB                04250000
         B     PARM2X              DDNAME OVERRIDE PROCESSING COMPLETE  04260000
PARM2BAD WTO   'PDSLOAD - INVALID DDNAME OVERRIDE PARAMETER IGNORED',  +04270000
               ROUTCDE=(11)                                             04280000
PARM2X   DS    0H                                                       04290000
         EJECT                                                          04300000
************************************************************            04310000
*                                                          *            04320000
*        OPEN THE DCBS                                     *            04330000
*                                                          *            04340000
************************************************************            04350000
         SPACE                                                          04360000
         SPACE                                                          04370000
         LA    R6,OPEN                                                  04380000
         MVI   0(R6),X'80'                                              04390000
         SPACE                                                          04400000
         OPEN  ((R3),OUTPUT),MF=(E,(R6))                                04410000
         SPACE                                                          04420000
         TM    OFLGS(R3),X'10'                                          04430000
         BO    OKPRT                                                    04440000
         LA    R15,16                                                   04450000
         B     EXIT                                                     04460000
PRTEXO   CLC   BLKSI(2,R1),=H'0'                                        04470000
         BNER  R14                                                      04480000
         MVC   BLKSI(2,R1),LRECL(R1)                                    04490000
         NI    RECFM(R1),255-X'10' CHANGE RECFM FROM FBA TO FA          04500000
         BR    R14                                                      04510000
OKPRT    OI    STATUS,PRT          SYSPRINT IS OPEN                     04520000
         SPACE                                                          04530000
         OPEN  ((R4),INPUT),MF=(E,(R6))                                 04540000
         SPACE                                                          04550000
         TM    OFLGS(R4),X'10'                                          04560000
         BO    OKUT1                                                    04570000
         LA    R15,16                                                   04580000
         CLC   DDNAM(8,R4),=CL8'SYSUT1'  AFTER TRYING SYSUT1?           04590000
         BNE   EXIT                      NO, OPEN FAILED                04600000
         MVC   DDNAM(8,R4),=CL8'SYSIN'   YES, NO OVERRIDE SO RETRY      04610000
         WTO   'PDSLOAD WILL RETRY WITH DDNAME=SYSIN',                 +04620000
               ROUTCDE=(11)        USE SAME ROUTING AS IEC130I          04630000
         B     OKPRT               RETRY OPEN WITH SYSIN                04640000
UT1EXO   TM    RECFM(R1),X'C0'     UNDEFINED RECORD FORMAT?             04650000
         BOR   R14                 YES, TAKE NO ACTION HERE             04660000
         MVI   DWLIN+1,4           PREPARE FOR INPUT RDWS               04670000
         TM    RECFM(R1),X'40'     FIXED LENGTH RECORD INPUT?           04680000
         BOR   R14                 NO, TAKE NO ACTION HERE              04690000
         MVI   DWLIN+1,0           NO INPUT RDWS                        04700000
         OI    RECFM(R1),X'80'     FORCE SOME RECORD FORMAT             04710000
         CLC   BLKSI(2,R1),=H'0'   IS BLKSIZE SPECIFIED?                04720000
         BNE   UT1EX1              YES, CHECK LRECL                     04730000
         MVC   BLKSI(2,R1),LRECL(R1)  NO, DEFAULT IS UNBLOCKED          04740000
         NI    RECFM(R1),255-X'10' CHANGE RECFM FROM FB TO F            04750000
         BR    R14                 RETURN                               04760000
UT1EX1   CLC   LRECL(2,R1),=H'0'   IS LRECL SPECIFIED?                  04770000
         BNER  R14                 YES, RETURN                          04780000
         MVC   LRECL(2,R1),BLKSI(R1)  NO, DEFAULT IS UNBLOCKED          04790000
         NI    RECFM(R1),255-X'10' CHANGE RECFM FROM FB TO F            04800000
         BR    R14                 RETURN                               04810000
OKUT1    OI    STATUS,UT1          SYSUT1 IS OPEN                       04820000
         TM    RECFM(R4),X'C0'     INPUT RECFM=U?                       04830000
         BO    UNDEFBAD            YES, INVALID                         04840000
         MVC   LINE,LINE-1                                              04850000
         MVC   LINE+1(SHOMSGLN),SHORTMSG                                04860000
         CLC   =H'80',LRECL(R4)    INPUT LRECL<80?                      04870000
         BH    FAILEXIT            YES, INVALID                         04880000
         SPACE                                                          04890000
         OPEN  ((R5),OUTPUT),MF=(E,(R6))                                04900000
         SPACE                                                          04910000
         TM    OFLGS(R5),X'10'                                          04920000
         BO    OKUT2                                                    04930000
         LA    R15,16                                                   04940000
         B     EXIT                                                     04950000
UT2EXO   TM    RECFM(R1),X'C0'     NULL RECORD FORMAT?                  04960000
         BM    UT2EX3              NO, FIXED OR VARIABLE LENGTH         04970000
         BZ    UT2EX2              YES, COPY INPUT RECORD FORMAT        04980000
         XC    LRECL(2,R1),LRECL(R1)   RECFM=U SO FORCE LRECL=0         04990000
         BR    R14                 RETURN                               05000000
UT2EX2   MVC   RECFM(1,R1),RECFM(R4)  YES, COPY INPUT RECFM             05010000
UT2EX3   CLC   LRECL(2,R1),=H'0'   IS LRECL SPECIFIED?                  05020000
         BNE   UT2EX4              YES, TAKE NO ACTION HERE             05030000
         MVC   LRECL(2,R1),LRECL(R4)    COPY INPUT LRECL                05040000
UT2EX4   TM    RECFM(R1),X'80'     FIXED LENGTH RECORDS?                05050000
         BOR   R14                 YES, USE SDB OR GOOD USER SPEC       05060000
         MVI   DWLOT+1,4           USE OUTPUT BDWS AND RDWS             05070000
         BR    R14                 USE SDB OR GOOD USER SPEC            05080000
*                                                                       05090000
*  TEST FOR BACK LEVEL MVS AND DFP DROPPED.  COMPLETE DCB DETAILS       05100000
*  OF TARGET PDS SHOULD BE IN VTOC BEFORE THIS PROGRAM GETS CONTROL.    05110000
*  EVEN SO, THE ABOVE CODE SHOULD ALLOW A PDSLOAD TO A NEW PDS THAT     05120000
*  HAS HAD NO DCB ATTRIBUTES PREVIOUSLY SUPPLIED ON A "MODERN" MVS.     05130000
*                                                                       05140000
*  IN ANY CASE, DCB CONFLICTS ARE HEREBY DECREED TO BE USER ERROR(S).   05150000
*                                                                       05160000
OKUT2    OI    STATUS,UT2          SYSUT2 IS OPEN                       05170000
         TM    RECFM(R5),X'C0'     OUTPUT RECFM=U?                      05180000
         BO    UNDEFBAD            YES, INVALID                         05190000
         TM    RECFM(R5),X'40'     FIXED-LENGTH OUTPUT RECORDS?         05200000
         BZ    GETBUF              YES                                  05210000
         TM    RECFM(R4),X'80'     VARIABLE-LENGTH INPUT RECORDS?       05220000
         BZ    GETBUF              YES                                  05230000
         MVC   LINE,LINE-1         NO, F(B)-IN NO GOOD FOR V(B)-OUT     05240000
         MVC   LINE+1(FIXMSGLN),FIXINMSG                                05250000
         B     FAILEXIT                                                 05260000
         SPACE                                                          05270000
GETBUF   LA    R0,7                                                     05280000
         AH    R0,BLKSI(,R5)                                            05290000
         SRL   R0,3                                                     05300000
         SLL   R0,4                DOUBLE ROUNDED-UP BLKSIZE            05310000
         ST    R0,FREEM                                                 05320000
         GETMAIN R,LV=(0)                                               05330000
         ST    R1,FREEM+4                                               05340000
         ST    R1,PUTPDSX          BUFFER 1 ADDRESS                     05350000
         XC    0(4,R1),0(R1)       RESET BDW 1                          05360000
         LR    R0,R1                                                    05370000
         AH    R0,DWLOT            ALLOW FOR OUTPUT BDW                 05380000
         ST    R0,PUTPDSX+4        BUFFER 1 ADDRESS TO USE NEXT         05390000
         AH    R1,BLKSI(,R5)                                            05400000
         ST    R1,PUTPDSX+8        PAST END OF BUFFER 1                 05410000
         LA    R1,7(,R1)                                                05420000
         SRL   R1,3                                                     05430000
         SLL   R1,3                ALIGN BUFFER 2                       05440000
         ST    R1,PUTPDSY          BUFFER 2 ADDRESS                     05450000
         XC    0(4,R1),0(R1)       RESET BDW 2                          05460000
         LR    R0,R1                                                    05470000
         AH    R0,DWLOT            ALLOW FOR OUTPUT BDW                 05480000
         ST    R0,PUTPDSY+4        BUFFER 2 ADDRESS TO USE NEXT         05490000
         AH    R1,BLKSI(,R5)                                            05500000
         ST    R1,PUTPDSY+8        PAST END OF BUFFER 2                 05510000
         LA    R1,PDSDECB1                                              05520000
         MVC   0(PDSDECBL,R1),PDSDECB                                   05530000
         ST    R1,PUTPDSX+12                                            05540000
         LA    R1,PDSDECB2                                              05550000
         MVC   0(PDSDECBL,R1),PDSDECB                                   05560000
         ST    R1,PUTPDSY+12                                            05570000
         SPACE                                                          05580000
         MVC   LINE,LINE-1                                              05590000
         MVC   MEMBER,=CL8' '      BLANK OUT MEMBER NAME                05600000
         SR    R1,R1                                                    05610000
         ST    R1,SEQ                                                   05620000
         ST    R1,UPR                                                   05630000
         BAL   R14,REPORT          FORCE A HEADER                       05640000
         EJECT                                                          05650000
************************************************************            05660000
*                                                          *            05670000
*        READ AN INPUT RECORD                              *            05680000
*                                                          *            05690000
************************************************************            05700000
         SPACE                                                          05710000
READ     DS    0H                                                       05720000
         GET   (R4)                                                     05730000
         SPACE                                                          05740000
         ST    R1,RECAD            SAVE INPUT RECORD ADDRESS            05750000
         LA    R0,1                                                     05760000
         A     R0,COUNTIN                                               05770000
         ST    R0,COUNTIN                                               05780000
         MVC   LINE,LINE-1                                              05790000
         LR    R15,R1              POINT TO INPUT RECORD                05800000
         AH    R15,DWLIN           POINT TO INPUT DATA                  05810000
         CLC   =C'./',0(R15)       CONTROL STATEMENT?                   05820000
         BNE   COPY                NO                                   05830000
         SPACE                                                          05840000
************************************************************            05850000
*                                                          *            05860000
*         PARSE THE CONTROL STATEMENT                      *            05870000
*                                                          *            05880000
************************************************************            05890000
         SPACE                                                          05900000
         MVI   INREC,C' '          CLEAR CONTROL RECORD HOLD AREA       05910000
         MVC   INREC+1(79),INREC                                        05920000
         LA    R14,72-1            GET LENGTH CODE IF FIXED LENGTH      05930000
         CR    R1,R15              FIXED LENGTH RECORDS?                05940000
         BE    COPYCNTL            YES, AND MINIMUM LRECL IS 80         05950000
         SLR   R3,R3               NO                                   05960000
         ICM   R3,3,0(R1)          GET RECORD LENGTH                    05970000
         SH    R3,=H'5'            GET DATA LENGTH CODE                 05980000
         CR    R3,R14              IS RECORD TOO LONG FOR INREC?        05990000
         BH    COPYCNTL            YES                                  06000000
         LR    R14,R3              NO, USE ACTUAL DATA LENGTH           06010000
COPYCNTL EX    R14,LOADECHO        COPY CONTROL STATEMENT IMAGE         06020000
         LA    R15,INREC           POINT TO COLUMN 1                    06030000
         LA    R3,72-1             LENGTH CODE OF CONTROL STATEMENT     06040000
         LA    R6,ODL              POINT TO OPERAND DESCRIPTOR LIST     06050000
         XC    0(ODLL,R6),0(R6)    ZERO THE ODL                         06060000
         SR    R1,R1               INSURE HI ORDER BYTE ZERO            06070000
         LA    R0,ODLL/8-1         NUMBER OF ENTRIES IN O.D.L.          06080000
*                                  MINUS 1 (LAST ODE WILL REMAIN ZERO)  06090000
LOOP     XC    0(8,R6),0(R6)       ZERO THE OPERAND DESCRIPTOR ENTRY    06100000
         EX    R3,TRTNONBL         FIND A NONBLANK                      06110000
         BZ    DONE                BRANCH IF ALL BLANKS                 06120000
         LR    R14,R1              GET ADDRESS OF STRING                06130000
         SR    R14,R15             GET LENGTH OF PRECEDING BLANKS       06140000
         SR    R3,R14              GET LENGTH OF REMAINING TEXT         06150000
         LR    R15,R1              GET ADDRESS OF NONBLANK              06160000
         EX    R3,TRTBLANK         FIND A BLANK                         06170000
         BZ    LAST                BRANCH IF NOT FOUND                  06180000
         LR    R14,R1              GET ADDRESS OF BLANK                 06190000
         SR    R14,R15             GET LENGTH OF FIELD                  06200000
         OI    6(R6),X'80'         OPERAND PRESENT                      06210000
         ST    R15,0(,R6)          ADDRESS OF OPERAND                   06220000
         STH   R14,4(,R6)          LENGTH OF OPERAND                    06230000
         SR    R3,R14              GET LENGTH CODE OF REMAINING TEXT    06240000
         BZ    DONE                BRANCH IF ONE TRAILING BLANK         06250000
         LA    R6,8(,R6)           POINT TO NEXT O.D.E.                 06260000
         LR    R15,R1              POINT TO BLANK                       06270000
         BCT   R0,LOOP                                                  06280000
         B     DONE                                                     06290000
LOADECHO MVC   INREC(0),0(R15)     <<< EXECUTED >>>                     06300000
TRTNONBL TRT   0(0,R15),TABNONBL   <<< EXECUTED >>>                     06310000
TRTBLANK TRT   0(0,R15),TABBLANK   <<< EXECUTED >>>                     06320000
LAST     LA    R14,1(,R3)          GET LENGTH                           06330000
         OI    6(R6),X'80'         OPERAND PRESENT                      06340000
         ST    R15,0(,R6)          ADDRESS OF OPERAND                   06350000
         STH   R14,4(,R6)          LENGTH OF OPERAND                    06360000
DONE     DS    0H                                                       06370000
         SPACE                                                          06380000
************************************************************            06390000
*                                                          *            06400000
*         DETERMINE TYPE OF CONTROL STATEMENT              *            06410000
*                                                          *            06420000
************************************************************            06430000
         SPACE                                                          06440000
         LA    R6,ODE1             POINT TO FIRST O.D.E.                06450000
         TM    6(R6),X'80'         ANYTHING PRESENT?                    06460000
         BZ    COPY                BRANCH IF WHOLE STATEMENT BLANK      06470000
         L     R1,0(,R6)           POINT TO FIRST STRING                06480000
         LH    R15,4(,R6)          GET LENGTH OF STRING                 06490000
         LA    R0,3                MAX VALID LENGTH                     06500000
         CR    R15,R0              IS STRING TOO LONG ?                 06510000
         BH    COPY                BRANCH IF TOO LONG                   06520000
         SLL   R15,2               MULTIPLY LENGTH BY 4                 06530000
         B     *(R15)              BRANCH TO ONE OF NEXT 7              06540000
         B     COPY                1 CHAR                               06550000
         B     CONTROL             2 CHAR                               06560000
         B     COPY                3 CHAR                               06570000
         SPACE                                                          06580000
COPY     DS    0H                                                       06590000
         CLI   MEMBER,C' '         HAS A ./ADD RECORD BEEN READ?        06600000
         BE    COPYERR             NO, PRINT A MESSAGE                  06610000
         LA    R1,1                                                     06620000
         A     R1,SEQ              COUNT THE RECORDS IN THIS MEMBER     06630000
         ST    R1,SEQ                                                   06640000
         SPACE                                                          06650000
         TM    FLAG1,SELECT        ARE WE SELECTING THIS MEMBER?        06660000
         BZ    READ                NO, BRANCH                           06670000
         SPACE                                                          06680000
*        MVC   INREC+72(8),=C'00000000'                                 06690000
*        CVD   R1,DOUBLE                                                06700000
*        OI    DOUBLE+7,X'0F'                                           06710000
*        UNPK  INREC+72(5),DOUBLE+5(3)                                  06720000
         SPACE                                                          06730000
         LH    R1,LRECL(,R4)       GET INPUT LRECL                      06740000
         L     R14,RECAD           POINT TO THE INPUT RECORD            06750000
         CLI   DWLIN+1,0           FIXED-LENGTH INPUT?                  06760000
         BE    *+8                 YES                                  06770000
         ICM   R1,3,0(R14)         NO, GET RECORD LENGTH                06780000
         SH    R1,DWLIN            GET DATA LENGTH                      06790000
         CH    R1,=H'1'            LONG ENOUGH?                         06800000
         BNH   NOTUPDTE            NO                                   06810000
         AH    R14,DWLIN           POINT TO DATA OF INPUT RECORD        06820000
         CLC   0(2,R14),UPDTE      IS THIS XX OF UPDTE(XX)?             06830000
         BNE   NOTUPDTE            NO, SKIP MVC                         06840000
         MVC   0(2,R14),=C'./'     YES, CHANGE TO ./                    06850000
         LA    R1,1                                                     06860000
         A     R1,UPR              COUNT THE MODIFIED RECORDS           06870000
         ST    R1,UPR                                                   06880000
NOTUPDTE DS    0H                                                       06890000
         SPACE                                                          06900000
         BAL   R14,PUTPDS                                               06910000
         B     READ                                                     06920000
         SPACE                                                          06930000
COPYERR  TM    STATUS,COPYM        HAS MESSAGE BEEN ISSUED?             06940000
         BO    READ                YES, BRANCH                          06950000
         OI    STATUS,COPYM                                             06960000
         MVC   LINE,LINE-1                                              06970000
         MVC   LINE+1(24),=C'SKIPPING FOR ./ ADD CARD'                  06980000
         BAL   R14,REPORT                                               06990000
         B     READ                                                     07000000
         EJECT                                                          07010000
************************************************************            07020000
*                                                          *            07030000
*         WRITE A LOGICAL RECORD TO THE PDS                *            07040000
*                                                          *            07050000
************************************************************            07060000
         SPACE                                                          07070000
PUTPDS   ST    R14,PUTPDSR         SAVE RETURN ADDRESS                  07080000
PUTREDO  LM    R6,R9,PUTPDSX       FIRST, CURRENT, END, DECB            07090000
         L     R14,RECAD           POINT TO THE INPUT RECORD            07100000
         LH    R1,LRECL(,R5)       GET LRECL OF OUTPUT PDS              07110000
         CLI   DWLOT+1,0           FIXED-LENGTH OUTPUT RECORDS?         07120000
         BE    PUTLEN              YES                                  07130000
         CLM   R1,3,0(R14)         NO, TRUNCATE INPUT RECORD?           07140000
         BL    PUTLEN              YES                                  07150000
         ICM   R1,3,0(R14)         NO, USE INPUT RECORD LENGTH          07160000
PUTLEN   LR    R0,R7               COPY TARGET FOR THIS RECORD          07170000
         AR    R7,R1               POINT TO NEXT "CURRENT" RECORD       07180000
         CR    R7,R8               WILL THIS RECORD FIT IN THIS BLOCK?  07190000
         BH    PUTPDS1             NO, ISSUE WRITE AND PROCURE BUFFER   07200000
         ST    R7,PUTPDSX+4        YES, SAVE TARGET FOR NEXT RECORD     07210000
         LH    R15,LRECL(,R4)      GET LRECL OF INPUT                   07220000
         CLI   DWLIN+1,0           FIXED-LENGTH INPUT RECORDS?          07230000
         BE    PUTPAD              YES, PROCEED WITH F(B) TO F(B)       07240000
         ICM   R15,3,0(R14)        NO, GET INPUT RECORD LENGTH FROM RDW 07250000
         CLI   DWLOT+1,0           FIXED-LENGTH OUTPUT RECORDS?         07260000
         BNE   PUTVTOV             NO, VARIABLE-LENGTH IN AND OUT       07270000
         AH    R14,DWLIN           YES, POINT PAST INPUT RDW            07280000
         SH    R15,DWLIN           REDUCE LENGTH OF DATA TO COPY        07290000
         B     PUTPAD              PROCEED WITH V(B) TO F(B)            07300000
PUTVTOV  SR    R7,R6               GET NEW SIZE OF BLOCK                07310000
         STH   R7,0(,R6)           UPDATE LENGTH IN BDW                 07320000
         LR    R7,R0               COPY TARGET FOR THIS RECORD          07330000
         STCM  R1,3,0(R7)          SET OUTPUT LENGTH IN RDW             07340000
         AH    R14,=H'2'           DO NOT COPY RDW LENGTH, BUT DO       07350000
         SH    R15,=H'2'                  COPY RDW SECOND HALF          07360000
         AH    R0,=H'2'                                                 07370000
         SH    R1,=H'2'                                                 07380000
PUTPAD   ICM   R15,8,LINE-1        LOAD BLANK PAD CHARACTER             07390000
         MVCL  R0,R14              MOVE RECORD INTO BLOCK               07400000
         L     R14,PUTPDSR         RESTORE RETURN ADDRESS               07410000
         BR    R14                 RETURN                               07420000
PUTPDS1  TM    STATUS,DECB         ANY WRITES OUTSTANDING?              07430000
         BZ    PUTPDS2             NO, BRANCH                           07440000
         L     R1,PUTPDSY+12       GET LAST DECB                        07450000
         CHECK (1)                                                      07460000
PUTPDS2  DS    0H                                                       07470000
         WRITE (R9),SF,(R5),(R6),MF=E                                   07480000
         MVC   PUTPDSX(16),PUTPDSY SWAP                                 07490000
         STM   R6,R9,PUTPDSY       SWAP                                 07500000
         AH    R6,DWLOT            ALLOW FOR OUTPUT BDW                 07510000
         ST    R6,PUTPDSY+4                                             07520000
         OI    STATUS,DECB                                              07530000
         B     PUTREDO             REDRIVE WITH BUFFER NOW AVAILABLE    07540000
         EJECT                                                          07550000
************************************************************            07560000
*                                                          *            07570000
*         PROCESS EACH ./ STATEMENT                        *            07580000
*                                                          *            07590000
************************************************************            07600000
         SPACE                                                          07610000
CONTROL  BAL   R14,STOW            FINISH PREVIOUS MEMBER               07620000
         MVC   MEMBER,=CL8' '      RESET                                07630000
         NI    STATUS,255-COPYM     RESET                               07640000
         NI    STATUS,255-SPF        RESET                              07650000
         NI    STATUS,255-SSI         RESET                             07660000
         SR    R1,R1                   RESET                            07670000
         ST    R1,SEQ                   RESET                           07680000
         ST    R1,UPR                    RESET                          07690000
         NI    FLAG1,255-SELECT           RESET                         07700000
         SPACE                                                          07710000
         MVC   LINE,LINE-1         PRINT                                07720000
         MVC   LINE+1(72),INREC     THE                                 07730000
         BAL   R14,REPORT            ./ADD STATEMENT                    07740000
         CLC   0(12,R1),=C'./ ADD NAME='                                07750000
         BE    SIMPLE                                                   07760000
         LA    R6,ODE2             POINT TO SECOND O.D.E.               07770000
         TM    6(R6),X'80'         ANYTHING PRESENT?                    07780000
         BZ    COPY                BRANCH IF NO OPERAND                 07790000
         CLC   4(2,R6),=H'3'       LENGTH OF 'ADD'?                     07800000
         BNE   NOTADD                                                   07810000
         L     R1,0(,R6)           POINT TO OPERAND                     07820000
         CLC   0(3,R1),=C'ADD'                                          07830000
         BNE   COPY                                                     07840000
         SPACE                                                          07850000
************************************************************            07860000
*                                                          *            07870000
*         PROCESS THE ./ ADD STATEMENT                     *            07880000
*                                                          *            07890000
************************************************************            07900000
         SPACE                                                          07910000
SIMPLE   MVC   MEMBER,=CL8' '                                           07920000
         LA    R6,ODE3             POINT TO FIRST OPERAND DESCRIPTOR    07930000
         TM    6(R6),X'80'         ANYTHING PRESENT?                    07940000
         BZ    COPY                BRANCH IF NO OPERAND                 07950000
         LH    R15,4(,R6)          GET LENGTH OF STRING                 07960000
         SH    R15,=H'5'           LENGTH OF 'NAME='                    07970000
         BNP   OP2NAME             BRANCH IF TOO SHORT FOR NAME=        07980000
         L     R1,0(,R6)           POINT TO OPERAND                     07990000
         CLC   0(5,R1),=C'NAME='   IS IT NAME= ?                        08000000
         BNE   OP2NAME             NO, ITS PROBABLY SSI=                08010000
         LA    R1,5(,R1)                                                08020000
         LA    R0,8                MAX VALID LENGTH                     08030000
         CR    R15,R0              IS STRING TOO LONG ?                 08040000
         BH    COPY                BRANCH IF TOO LONG                   08050000
         MVC   MEMBER,=CL8' '                                           08060000
         BCTR  R15,0               GET LENGTH MINUS 1 FOR EX            08070000
         B     *+10                                                     08080000
         MVC   MEMBER(0),0(R1)     <<< EXECUTED >>>                     08090000
         EX    R15,*-6             MOVE NAME TO MEMBER NAME             08100000
         TRT   MEMBER,ALPHANUM     IS MEMBER NAME VALID                 08110000
         BNZ   ILLMEM              NO, BRANCH                           08120000
         CLI   MEMBER,C'0'         IS FIRST CHAR NUMERIC?               08130000
         BNL   ILLMEM              YES, BRANCH                          08140000
         CLI   MEMBER,C'-'         IS FIRST CHAR HYPHEN?                08150000
         BE    ILLMEM                                                   08160000
         CLI   MEMSEL,C' '         ARE WE SELECTING ALL MEMBERS?        08170000
         BE    SELMEM1             YES, BRANCH                          08180000
         BAL   R14,MEMMATCH        NO, IS THIS A SELECTED MEMBER?       08190000
         BNE   *+8                 NO                                   08200000
SELMEM1  OI    FLAG1,SELECT        INDICATE THIS MEMBER SELECTED        08210000
         B     OP2SSI                                                   08220000
*                                                                       08230000
*              SSI= WAS PROBABLY SPECIFIED FIRST,                       08240000
*              SEE IF NAME= IS SECOND                                   08250000
*                                                                       08260000
OP2NAME  LA    R6,ODE4             POINT TO SECOND OPERAND              08270000
         TM    6(R6),X'80'         ANYTHING PRESENT?                    08280000
         BZ    COPY                BRANCH IF NO OPERAND                 08290000
         LH    R15,4(,R6)          GET LENGTH OF STRING                 08300000
         SH    R15,=H'5'           LENGTH OF 'NAME='                    08310000
         BNP   COPY                BRANCH IF TOO SHORT FOR NAME=        08320000
         L     R1,0(,R6)           POINT TO OPERAND                     08330000
         CLC   0(5,R1),=C'NAME='                                        08340000
         BNE   COPY                                                     08350000
         LA    R1,5(,R1)                                                08360000
         LA    R0,8                MAX VALID LENGTH                     08370000
         CR    R15,R0              IS STRING TOO LONG ?                 08380000
         BH    COPY                BRANCH IF TOO LONG                   08390000
         MVC   MEMBER,=CL8' '                                           08400000
         BCTR  R15,0               GET LENGTH MINUS 1 FOR EX            08410000
         B     *+10                                                     08420000
         MVC   MEMBER(0),0(R1)     <<< EXECUTED >>>                     08430000
         EX    R15,*-6             MOVE NAME TO MEMBER NAME             08440000
         TRT   MEMBER,ALPHANUM     IS MEMBER NAME VALID                 08450000
         BNZ   ILLMEM              NO, BRANCH                           08460000
         CLI   MEMBER,C'0'         IS FIRST CHAR NUMERIC?               08470000
         BNL   ILLMEM              YES, BRANCH                          08480000
         CLI   MEMBER,C'-'         IS FIRST CHAR HYPHEN?                08490000
         BE    ILLMEM                                                   08500000
         CLI   MEMSEL,C' '         ARE WE SELECTING ALL MEMBERS?        08510000
         BE    SELMEM2             YES, BRANCH                          08520000
         BAL   R14,MEMMATCH        NO, IS THIS A SELECTED MEMBER?       08530000
         BNE   *+8                 NO                                   08540000
SELMEM2  OI    FLAG1,SELECT        INDICATE THIS MEMBER SELECTED        08550000
         SPACE                                                          08560000
         LA    R6,ODE3             POINT TO FIRST OPERAND               08570000
         LH    R15,4(,R6)          LENGTH                               08580000
         L     R6,0(,R6)           POINT TO OPERAND                     08590000
         CH    R15,=H'12'          IS LENGTH RIGHT FOR SSI=XXXXXXXX?    08600000
         BNE   NOUSER              NO, IGNORE FIRST OPND, NO USER DATA  08610000
         CLC   0(4,R6),=C'SSI='    IS IT SSI= ?                         08620000
         BE    SSICVT              YES, GO PROCESS SSI                  08630000
         B     NOUSER              NO, IGNORE FIRST OPND, NO USER DATA  08640000
*                                                                       08650000
*              NAME= WAS SPECIFIED FIRST                                08660000
*              CHECK FOR SSI= OR SPF STATS                              08670000
*                                                                       08680000
OP2SSI   LA    R6,ODE4             POINT TO 2ND OPERAND DESCRIPTOR      08690000
         TM    6(R6),X'80'         ANYTHING PRESENT?                    08700000
         BZ    NOUSER              NO USER DATA TO BE STOWED            08710000
         LH    R15,4(,R6)          LENGTH                               08720000
         L     R6,0(,R6)           POINT TO OPERAND                     08730000
         CH    R15,=H'12'          IS LENGTH RIGHT FOR SSI=XXXXXXXX?    08740000
         BNE   NOSSI               NO, BRANCH                           08750000
         CLC   0(4,R6),=C'SSI='    IS IT SSI= ?                         08760000
         BNE   NOSSI               NO, BRANCH                           08770000
SSICVT   MVC   MEMUSER(8),4(R6)    MOVE 8 HEX CHARACTERS                08780000
         LA    R1,MEMUSER          POINT TO DATA TO BE CONVERTED        08790000
         LA    R0,4                LENGTH/2 OF DATA TO BE CONVERTED     08800000
         BAL   R14,PACK            CONVERT HEX TO BINARY                08810000
         OI    STATUS,SSI          SET FLAG FOR STOW                    08820000
         B     READ                                                     08830000
NOSSI    DS    0H                                                       08840000
         MVI   SKIPFLG,X'00'       RESET SKIP FLAG            SBG 02/00 08850000
         CLI   12(R6),C'-'         EXTRA 2 NUMBERS IN CRDATE? SBG 02/00 08860000
         BNE   TESTOLD             NOT STARTOOL COMBINE       SBG 02/00 08870000
         MVI   SKIPFLG,X'01'       SET SKIP FLAG              SBG 02/00 08880000
         B     TESTNEW             TEST NEW FORMAT            SBG 02/00 08890000
TESTOLD  DS    0H                  SAME CODE AS BEFORE        SBG 02/00 08900000
         SH    R15,=H'41'          MINIMUM LENGTH 41                    08910000
         BM    NOSPF                                                    08920000
         CH    R15,=H'9'           ID LENGTH CODE MAY BE 0 TO 9         08930000
         BH    NOSPF               TOTAL LENGTH EXCEEDS 50              08940000
         CLI   4(R6),C'-'                                               08950000
         BNE   NOSPF                                                    08960000
         CLI   10(R6),C'-'                                              08970000
         BNE   NOSPF                                                    08980000
         CLI   16(R6),C'-'                                              08990000
         BNE   NOSPF                                                    09000000
         CLI   21(R6),C'-'                                              09010000
         BNE   NOSPF                                                    09020000
         CLI   27(R6),C'-'                                              09030000
         BNE   NOSPF                                                    09040000
         CLI   33(R6),C'-'                                              09050000
         BNE   NOSPF                                                    09060000
         CLI   39(R6),C'-'                                              09070000
         BNE   NOSPF                                                    09080000
         B     TESTNUM             TEST NUMERICS OLD WAY      SBG 02/00 09090000
TESTNEW  DS    0H                  TEST FOR NEW FORMAT        SBG 02/00 09100000
         SH    R15,=H'45'          MINIMUM LENGTH 45          SBG 02/00 09110000
         BM    NOSPF                                          SBG 02/00 09120000
         CH    R15,=H'9'        ID LENGTH CODE MAY BE 0 TO 9  SBG 02/00 09130000
         BH    NOSPF               TOTAL LENGTH EXCEEDS 54    SBG 02/00 09140000
         CLI   4(R6),C'-'                                     SBG 02/00 09150000
         BNE   NOSPF                                          SBG 02/00 09160000
         CLI   12(R6),C'-'                                    SBG 02/00 09170000
         BNE   NOSPF                                          SBG 02/00 09180000
         CLI   20(R6),C'-'                                    SBG 02/00 09190000
         BNE   NOSPF                                          SBG 02/00 09200000
         CLI   25(R6),C'-'                                    SBG 02/00 09210000
         BNE   NOSPF                                          SBG 02/00 09220000
         CLI   31(R6),C'-'                                    SBG 02/00 09230000
         BNE   NOSPF                                          SBG 02/00 09240000
         CLI   37(R6),C'-'                                    SBG 02/00 09250000
         BNE   NOSPF                                          SBG 02/00 09260000
         CLI   43(R6),C'-'                                    SBG 02/00 09270000
         BNE   NOSPF                                          SBG 02/00 09280000
         B     TESTNUMN            TEST NUMERICS NEW WAY      SBG 02/00 09290000
TESTNUM  DS    0H                                             SBG 02/00 09300000
         USING XPF,R6                                         SBG 02/00 09310000
         TRT   XPFVM,NUMERIC                                  SBG 02/00 09320000
         BNZ   NOSPF                                                    09330000
         TRT   XPFCREDT,NUMERIC                                         09340000
         BNZ   NOSPF                                                    09350000
         TRT   XPFCHGDT,NUMERIC                                         09360000
         BNZ   NOSPF                                                    09370000
         TRT   XPFHHMM,NUMERIC                                          09380000
         BNZ   NOSPF                                                    09390000
         TRT   XPFCCNT,NUMERIC                                          09400000
         BNZ   NOSPF                                                    09410000
         TRT   XPFICNT,NUMERIC                                          09420000
         BNZ   NOSPF                                                    09430000
         TRT   XPFMOD,NUMERIC                                           09440000
         BNZ   NOSPF                                                    09450000
         PACK  DOUBLE,XPFVM+0(2)   GET V OF V.M                         09460000
         CVB   R0,DOUBLE                                                09470000
         STC   R0,SPFVM                                                 09480000
         PACK  DOUBLE,XPFVM+2(2)   GET M OF V.M                         09490000
         CVB   R0,DOUBLE                                                09500000
         STC   R0,SPFVM+1                                               09510000
         PACK  DOUBLE,XPFCREDT     GET YYDDD                            09520000
         OI    DOUBLE+7,X'0F'                                           09530000
         CLC   XPFCREDT(2),=C'66'  BELOW 19XX WINDOW?         DRK JUN98 09540000
         BNL   *+8                 NO,  THEN 19XX             DRK JUN98 09550000
         OI    DOUBLE+4,X'01'      YES, THEN 20XX             DRK JUN98 09560000
         MVC   SPFCREDT,DOUBLE+4                                        09570000
         PACK  DOUBLE,XPFCHGDT     GET YYDDD                            09580000
         OI    DOUBLE+7,X'0F'                                           09590000
         CLC   XPFCHGDT(2),=C'66'  BELOW 19XX WINDOW?         DRK JUN98 09600000
         BNL   *+8                 NO,  THEN 19XX             DRK JUN98 09610000
         OI    DOUBLE+4,X'01'      YES, THEN 20XX             DRK JUN98 09620000
         MVC   SPFCHGDT,DOUBLE+4   DATE LAST MODIFIED                   09630000
         PACK  DOUBLE,XPFHHMM                                           09640000
         L     R0,DOUBLE+4         GET 000HHMMC                         09650000
         SRL   R0,4                GET 0000HHMM                         09660000
         STH   R0,SPFHHMM          TIME LAST MODIFIED                   09670000
         PACK  DOUBLE,XPFCCNT      SIZE                                 09680000
         CVB   R0,DOUBLE                                                09690000
         STH   R0,SPFCCNT          CURRENT SIZE                         09700000
         PACK  DOUBLE,XPFICNT      SIZE                                 09710000
         CVB   R0,DOUBLE                                                09720000
         STH   R0,SPFICNT          INITIAL SIZE                         09730000
         PACK  DOUBLE,XPFMOD       MOD                                  09740000
         CVB   R0,DOUBLE                                                09750000
         STH   R0,SPFMOD           LINES MODIFIED                       09760000
         MVC   SPFUSER,=CL10' '    PAD WITH BLANKS                      09770000
         B     *+10                                                     09780000
         MVC   SPFUSER(0),XPFUSER                                       09790000
         EX    R15,*-6                                                  09800000
         OI    STATUS,SPF          SET FLAG FOR STOW                    09810000
         DROP  R6                                             SBG 02/00 09820000
         B     NOSPF               GO PROCESS FURTHER         SBG 02/00 09830000
TESTNUMN DS    0H                                             SBG 02/00 09840000
         USING XP2,R6                                         SBG 02/00 09850000
         TRT   XP2VM,NUMERIC                                  SBG 02/00 09860000
         BNZ   NOSPF                                          SBG 02/00 09870000
         TRT   XP2CREDT,NUMERIC                               SBG 02/00 09880000
         BNZ   NOSPF                                          SBG 02/00 09890000
         TRT   XP2CHGDT,NUMERIC                               SBG 02/00 09900000
         BNZ   NOSPF                                          SBG 02/00 09910000
         TRT   XP2HHMM,NUMERIC                                SBG 02/00 09920000
         BNZ   NOSPF                                          SBG 02/00 09930000
         TRT   XP2CCNT,NUMERIC                                SBG 02/00 09940000
         BNZ   NOSPF                                          SBG 02/00 09950000
         TRT   XP2ICNT,NUMERIC                                SBG 02/00 09960000
         BNZ   NOSPF                                          SBG 02/00 09970000
         TRT   XP2MOD,NUMERIC                                 SBG 02/00 09980000
         BNZ   NOSPF                                          SBG 02/00 09990000
         PACK  DOUBLE,XP2VM+0(2)   GET V OF V.M               SBG 02/00 10000000
         CVB   R0,DOUBLE                                      SBG 02/00 10010000
         STC   R0,SPFVM                                       SBG 02/00 10020000
         PACK  DOUBLE,XP2VM+2(2)   GET M OF V.M               SBG 02/00 10030000
         CVB   R0,DOUBLE                                      SBG 02/00 10040000
         STC   R0,SPFVM+1                                     SBG 02/00 10050000
         PACK  DOUBLE,XP2CREDT     GET YYDDD                  SBG 02/00 10060000
         OI    DOUBLE+7,X'0F'                                 SBG 02/00 10070000
         CLC   XP2CREDT(2),=C'66'  BELOW 19XX WINDOW?         DRK JUN98 10080000
         BNL   *+8                 NO,  THEN 19XX             DRK JUN98 10090000
         OI    DOUBLE+4,X'01'      YES, THEN 20XX             DRK JUN98 10100000
         MVC   SPFCREDT,DOUBLE+4                              SBG 02/00 10110000
         PACK  DOUBLE,XP2CHGDT     GET YYDDD                  SBG 02/00 10120000
         OI    DOUBLE+7,X'0F'                                 SBG 02/00 10130000
         CLC   XP2CHGDT(2),=C'66'  BELOW 19XX WINDOW?         DRK JUN98 10140000
         BNL   *+8                 NO,  THEN 19XX             DRK JUN98 10150000
         OI    DOUBLE+4,X'01'      YES, THEN 20XX             DRK JUN98 10160000
         MVC   SPFCHGDT,DOUBLE+4   DATE LAST MODIFIED         SBG 02/00 10170000
         PACK  DOUBLE,XP2HHMM                                 SBG 02/00 10180000
         L     R0,DOUBLE+4         GET 000HHMMC               SBG 02/00 10190000
         SRL   R0,4                GET 0000HHMM               SBG 02/00 10200000
         STH   R0,SPFHHMM          TIME LAST MODIFIED         SBG 02/00 10210000
         PACK  DOUBLE,XP2CCNT      SIZE                       SBG 02/00 10220000
         CVB   R0,DOUBLE                                      SBG 02/00 10230000
         STH   R0,SPFCCNT          CURRENT SIZE               SBG 02/00 10240000
         PACK  DOUBLE,XP2ICNT      SIZE                       SBG 02/00 10250000
         CVB   R0,DOUBLE                                      SBG 02/00 10260000
         STH   R0,SPFICNT          INITIAL SIZE               SBG 02/00 10270000
         PACK  DOUBLE,XP2MOD       MOD                        SBG 02/00 10280000
         CVB   R0,DOUBLE                                      SBG 02/00 10290000
         STH   R0,SPFMOD           LINES MODIFIED             SBG 02/00 10300000
         MVC   SPFUSER,=CL10' '    PAD WITH BLANKS            SBG 02/00 10310000
         B     *+10                                           SBG 02/00 10320000
         MVC   SPFUSER(0),XP2USER                             SBG 02/00 10330000
         EX    R15,*-6                                        SBG 02/00 10340000
         OI    STATUS,SPF          SET FLAG FOR STOW          SBG 02/00 10350000
         DROP  R6                                             SBG 02/00 10360000
NOSPF    DS    0H                                                       10370000
NOUSER   DS    0H                                                       10380000
         B     READ                                                     10390000
         SPACE                                                          10400000
ILLMEM   MVC   MEMBER,=CL8' '      SUPPRESS COPY                        10410000
         B     COPY                                                     10420000
         SPACE                                                          10430000
PACK     ST    R14,PACKR                                                10440000
         LR    R15,R1              REG 15 --> SENDING/RECEIVING FIELD   10450000
         SR    R14,R14                                                  10460000
         IC    R14,0(,R1)          REG 14  =  1ST CHAR                  10470000
         CLI   0(R1),C'0'          NUMBER OR LETTER?                    10480000
         BNL   *+8                 NUMBER - BRANCH                      10490000
         LA    R14,57(,R14)        LETTER - CONVERT TO FA-FF            10500000
         SLL   R14,4               SHIFT LEFT 4 BITS                    10510000
         STC   R14,0(,R15)         STORE THE LEFT HALF                  10520000
         IC    R14,1(,R1)          REG 14  =  2ND CHAR                  10530000
         CLI   1(R1),C'0'          NUMBER OR LETTER?                    10540000
         BNL   *+8                 NUMBER - BRANCH                      10550000
         LA    R14,57(,R14)        LETTER - CONVERT                     10560000
         SLL   R14,28              SHIFT LEFT HALF TO OBLIVION          10570000
         SRL   R14,28              SHIFT BACK AGAIN                     10580000
         STC   R14,1(,R15)         STORE RIGHT HALF                     10590000
         OC    0(1,R15),1(R15)     'OR' RIGHT HALF OVER LEFT HALF       10600000
         LA    R1,2(,R1)           INCREMENT SENDING FIELD              10610000
         LA    R15,1(,R15)         INCREMENT RECEIVING FLD              10620000
         BCT   R0,PACK+6           LOOP USING LENGTH IN REG 0           10630000
         L     R14,PACKR                                                10640000
         BR    R14                 EXIT                                 10650000
         SPACE                                                          10660000
MEMMATCH STM   R14,R12,12(R13)     SAVE REGISTERS                       10670000
         LA    R3,MEMBER           POINT TO MEMBER NAME                 10680000
         LA    R4,MEMSEL           POINT TO SELECTION MASK              10690000
         LA    R0,8                GET MEMBER NAME LENGTH               10700000
MASKLOOP CLI   0(R4),C'*'          GENERIC CHARACTER MATCH?             10710000
         BE    MASKNEXT            YES, THIS CHARACTER MATCHES          10720000
         CLI   0(R4),C'?'          GENERIC CHARACTER MATCH?             10730000
         BE    MASKNEXT            YES, THIS CHARACTER MATCHES          10740000
         CLI   0(R4),C'%'          GENERIC CHARACTER MATCH?             10750000
         BE    MASKNEXT            YES, THIS CHARACTER MATCHES          10760000
         CLC   0(1,R4),0(R3)       SPECIFIC CHARACTER MATCH?            10770000
         BNE   MASKEXIT            NO, UNSUCCESSFUL MATCH               10780000
MASKNEXT LA    R3,1(,R3)           POINT TO NEXT BYTE OF ITEM           10790000
         LA    R4,1(,R4)           POINT TO NEXT BYTE OF MASK           10800000
         BCT   R0,MASKLOOP         TEST NEXT BYTE                       10810000
MASKEXIT LM    R14,R12,12(R13)     RESTORE REGISTERS                    10820000
         BR    R14                 RETURN TO CALLER                     10830000
         EJECT                                                          10840000
************************************************************            10850000
*                                                          *            10860000
*         PROCESS THE ./ ALIAS STATEMENT                   *            10870000
*                                                          *            10880000
************************************************************            10890000
         SPACE                                                          10900000
NOTADD   CLC   4(2,R6),=H'5'       LENGTH OF 'ALIAS'?                   10910000
         BNE   COPY                                                     10920000
         L     R1,0(,R6)           POINT TO OPERAND                     10930000
         CLC   0(5,R1),=C'ENDUP'   END OF IEBUPDTE-LIKE INPUT?          10940000
         BE    EODUT1              YES, SIMULATE END-OF-FILE            10950000
         CLC   0(5,R1),=C'ALIAS'                                        10960000
         BNE   COPY                                                     10970000
         LA    R6,ODE3             POINT TO THIRD O.D.E.                10980000
         TM    6(R6),X'80'         ANYTHING PRESENT?                    10990000
         BZ    COPY                BRANCH IF NO OPERAND                 11000000
         LH    R15,4(,R6)          GET LENGTH OF STRING                 11010000
         SH    R15,=H'5'           LENGTH OF 'NAME='                    11020000
         BNP   COPY                                                     11030000
         L     R1,0(,R6)           POINT TO OPERAND                     11040000
         CLC   0(5,R1),=C'NAME='                                        11050000
         BNE   COPY                                                     11060000
         LA    R1,5(,R1)                                                11070000
         LA    R0,8                MAX VALID LENGTH                     11080000
         CR    R15,R0              IS STRING TOO LONG ?                 11090000
         BH    COPY                BRANCH IF TOO LONG                   11100000
         MVC   MEMBER,=CL8' '                                           11110000
         BCTR  R15,0               GET LENGTH MINUS 1 FOR EX            11120000
         B     *+10                                                     11130000
         MVC   MEMBER(0),0(R1)     <<< EXECUTED >>>                     11140000
         EX    R15,*-6             MOVE NAME TO MEMBER NAME             11150000
         TRT   MEMBER,ALPHANUM     IS MEMBER NAME VALID                 11160000
         BNZ   ILLMEM              NO, BRANCH                           11170000
         CLI   MEMBER,C'0'         IS FIRST CHAR NUMERIC?               11180000
         BNL   ILLMEM              YES, BRANCH                          11190000
         CLI   MEMBER,C'-'         IS FIRST CHAR HYPHEN?                11200000
         BE    ILLMEM                                                   11210000
         MVC   LINE,LINE-1                                              11220000
         MVC   LINE+32(05),=C'ALIAS'                                    11230000
         MVC   LINE+39(08),MEMBER                                       11240000
         LA    R6,MEMBER                                                11250000
         OI    11(R6),X'80'        SET ALIAS BIT ON                     11260000
         STOW  (R5),(R6),R                                              11270000
         LA    R14,ALIASR          RETURN ADDRESS FROM STOWAR           11280000
         ST    R14,STOWR           RETURN ADDRESS FROM STOWAR           11290000
         B     STOWAR(R15)                                              11300000
ALIASR   MVC   MEMBER,=CL8' '                                           11310000
         B     READ                                                     11320000
         EJECT                                                          11330000
************************************************************            11340000
*                                                          *            11350000
*        ADD OR REPLACE A MEMBER                           *            11360000
*                                                          *            11370000
************************************************************            11380000
         SPACE                                                          11390000
STOW     DS    0H                                                       11400000
         ST    R14,STOWR                                                11410000
         TM    STATUS,DECB         ANY WRITES OUTSTANDING?              11420000
         BZ    STOWW               NO, BRANCH                           11430000
         L     R1,PUTPDSY+12       GET LAST DECB                        11440000
         CHECK (1)                                                      11450000
         NI    STATUS,255-DECB     NO OUTSTANDING WRITES                11460000
STOWW    LM    R6,R9,PUTPDSX       GET WRITE REGISTERS                  11470000
         SR    R7,R6               GET LENGTH OF FINAL BLOCK            11480000
         SH    R7,DWLOT            ACCOUNT FOR ANY BDW                  11490000
         BNP   STOWSET             BRANCH IF NOTHING IN BUFFER          11500000
         LH    R8,BLKSI(,R5)       SAVE ORIGINAL BLKSIZE                11510000
         CLI   DWLOT+1,4           VARIABLE-LENGTH OUTPUT RECORDS?      11520000
         BE    *+8                 YES, LENGTH IN DATA, NOT DCB         11530000
         STH   R7,BLKSI(,R5)       NO, STORE FINAL BLOCK LENGTH IN DCB  11540000
         WRITE (R9),SF,(R5),(R6),MF=E                                   11550000
         CHECK (R9)                                                     11560000
         STH   R8,BLKSI(,R5)       RESTORE DCB BLKSIZE FOR NEXT MEMBER  11570000
STOWSET  L     R1,PUTPDSX                                               11580000
         AH    R1,DWLOT            ALLOW FOR OUTPUT BDW                 11590000
         ST    R1,PUTPDSX+4                                             11600000
         L     R1,PUTPDSY                                               11610000
         AH    R1,DWLOT            ALLOW FOR OUTPUT BDW                 11620000
         ST    R1,PUTPDSY+4                                             11630000
         MVC   LINE,LINE-1                                              11640000
         CLI   MEMBER,C' '         IS THERE A MEMBER NAME?              11650000
         BE    STOWX               NO, BRANCH                           11660000
         TM    FLAG1,SELECT        WAS THIS MEMBER SELECTED?            11670000
         BZ    STOWX               NO, BRANCH                           11680000
         MVI   MEMC,0                                                   11690000
         TM    STATUS,SPF          IS THERE SPF USERDATA?               11700000
         BZ    STOWNSPF            NO, BRANCH                           11710000
         MVI   MEMC,15             LENGTH OF USER DATA IN HALFWORDS     11720000
         CLC   SPFCCNT,SEQ+2       IS THE RECORD COUNT CORRECT?         11730000
         BE    STOWNSSI            YES                                  11740000
         MVC   SPFCCNT,SEQ+2       NO, CORRECT IT                       11750000
         OI    FLAG1,FIXSZ         FLAG CORRECTION                      11760000
         B     STOWNSSI                                                 11770000
STOWNSPF DS    0H                                                       11780000
         TM    FLAG1,GENSPF        SPF STATS TO BE GENERATED?           11790000
         BZ    STOWNGEN            NO, BRANCH                           11800000
         MVI   MEMC,15             LENGTH OF USER DATA IN HALFWORDS     11810000
         XC    MEMUSER(30),MEMUSER                                      11820000
         MVI   SPFVM,1             1.0                                  11830000
         XC    SPFRESV,SPFRESV     ZERO RESERVED BYTES                  11840000
         TIME  DEC                                                      11850000
         ST    R1,SPFCREDT         DATE CREATED                         11860000
         ST    R1,SPFCHGDT         DATE OF LAST CHANGE                  11870000
         SRL   R0,16                                                    11880000
         STH   R0,SPFHHMM          TIME OF LAST CHANGE                  11890000
         L     R1,SEQ              SIZE                                 11900000
         STH   R1,SPFICNT                                               11910000
         STH   R1,SPFCCNT                                               11920000
         MVC   SPFUSER,=CL10'PDSLOAD'                                   11930000
         B     STOWNSSI                                                 11940000
STOWNGEN DS    0H                                                       11950000
         TM    STATUS,SSI          IS THERE SSI USERDATA?               11960000
         BZ    STOWNSSI            NO, BRANCH                           11970000
         MVI   MEMC,2              LENGTH OF USERDATA SSI IN HALFWORDS  11980000
STOWNSSI DS    0H                                                       11990000
         MVC   LINE+32(06),=C'MEMBER'                                   12000000
         MVC   LINE+39(08),MEMBER                                       12010000
         LA    R6,MEMBER                                                12020000
         XC    8(03,R6),8(R6)      TTR                                  12030000
         SPACE                                                          12040000
         STOW  (R5),(R6),R                                              12050000
         SPACE                                                          12060000
         CLM   R15,2,=X'0018'      UNEXPECTED RETURN CODE?              12070000
         BH    STOWPDSE            YES, PROBABLY SOME PDSE WORRY        12080000
         B     STOWAR(R15)          R             A                     12090000
STOWAR   B     STOWAR00             REPLACED      ADDED                 12100000
         B     STOWAR04             N/A           NOT ADDED, EXISTS     12110000
         B     STOWAR08             ADDED         N/A                   12120000
         B     STOWAR0C                                                 12130000
         B     STOWAR10                                                 12140000
         B     STOWAR14                                                 12150000
         B     STOWAR18                                                 12160000
*         SPACE                                                  *JLM*  12170000
*RESULT   EQU   LINE+48                                          *JLM*  12180000
*         SPACE                                                  *JLM*  12190000
STOWAR00 TRT   LINE+39(9),TABBLANK                                      12200000
         MVC   1(8,R1),=CL8'REPLACED'                                   12210000
         LA    R1,9(,R1)                                                12220000
         B     STOWCOMW                                                 12230000
STOWAR04 MVC   RESULT(23),=CL32'NOT ADDED *** ALREADY EXISTS ***'       12240000
         B     STOWCOM                                                  12250000
STOWAR08 TRT   LINE+39(9),TABBLANK                                      12260000
         MVC   1(5,R1),=CL5'ADDED'                                      12270000
         LA    R1,6(,R1)                                                12280000
         B     STOWCOMW                                                 12290000
STOWAR0C MVC   RESULT(33),=CL33'NOT STOWED *** DIRECTORY FULL ***'      12300000
         B     STOWCOM                                                  12310000
STOWAR10 MVC   RESULT(28),=CL28'NOT STOWED *** I/O ERROR ***'           12320000
         B     STOWCOM                                                  12330000
STOWAR14 MVC   RESULT(28),=CL28'NOT STOWED *** DCB ERROR ***'           12340000
         B     STOWCOM                                                  12350000
STOWAR18 MVC   RESULT(32),=CL32'NOT STOWED *** STORAGE ERROR ***'       12360000
         B     STOWCOM                                                  12370000
STOWPDSE MVC   RESULT(29),=CL29'NOT STOWED *** PDSE ERROR ***'          12380000
         SPACE                                                          12390000
STOWCOM  DS    0H                                                       12400000
         MVI   RC+1,4                                                   12410000
         BAL   R14,REPORT          OUTPUT PRINT LINE                    12420000
         B     STOWX               THAT IS ALL FOR THIS MEMBER          12430000
STOWCOMW DS    0H                                                       12440000
         TM    MEMC,X'80'          WAS THAT AN ALIAS?                   12450000
         BO    STOWXA              YES, BRANCH                          12460000
         ST    R1,STOWSVR1                                              12470000
         L     R15,SEQ                                                  12480000
         CVD   R15,DOUBLE                                               12490000
         MVC   1(7,R1),=X'4020206B202120'                               12500000
         ED    1(7,R1),DOUBLE+5                                         12510000
         MVI   1(R1),C'('                                               12520000
         LA    R1,2(,R1)                                                12530000
STOWCOMJ CLI   0(R1),C' '                                               12540000
         BNE   STOWCOMK                                                 12550000
         MVC   0(7,R1),1(R1)                                            12560000
         B     STOWCOMJ                                                 12570000
STOWCOMK LA    R1,1(,R1)                                                12580000
         CLI   0(R1),C' '                                               12590000
         BNE   STOWCOMK                                                 12600000
         MVC   1(08,R1),=C'RECORDS)'                                    12610000
         CH    R15,=H'1'           ONE RECORD?                          12620000
         BNE   STOWCHEK            NO, TEXT IS GOOD                     12630000
         MVC   7(2,R1),8(R1)       CHANGE RECORDS TO RECORD             12640000
         BCTR  R1,0                ADJUST FOR TEXT LENGTH CHANGE        12650000
STOWCHEK TM    FLAG1,FIXSZ         WAS THE SPF STATISTICS SIZE FIXED?   12660000
         BZ    STOWREPT            NO                                   12670000
         NI    FLAG1,255-FIXSZ     YES, RESET FLAG                      12680000
         MVC   8(15,R1),=C' - STATS FIXED)'                             12690000
STOWREPT BAL   R14,REPORT                                               12700000
         L     R15,UPR                                                  12710000
         LTR   R15,R15                                                  12720000
         BZ    STOWX                                                    12730000
         MVC   LINE,LINE-1                                              12740000
         L     R1,STOWSVR1                                              12750000
         CVD   R15,DOUBLE                                               12760000
         MVC   1(7,R1),=X'4020206B202120'                               12770000
         ED    1(7,R1),DOUBLE+5                                         12780000
         MVI   1(R1),C'('                                               12790000
         LA    R1,2(,R1)                                                12800000
STOWUPRJ CLI   0(R1),C' '                                               12810000
         BNE   STOWUPRK                                                 12820000
         MVC   0(7,R1),1(R1)                                            12830000
         B     STOWUPRJ                                                 12840000
STOWUPRK LA    R1,1(,R1)                                                12850000
         CLI   0(R1),C' '                                               12860000
         BNE   STOWUPRK                                                 12870000
         MVC   1(09,R1),=C'MODIFIED)'                                   12880000
STOWXA   BAL   R14,REPORT                                               12890000
STOWX    L     R14,STOWR                                                12900000
         BR    R14                                                      12910000
         SPACE                                                          12920000
UNDEFBAD MVC   LINE,LINE-1                                              12930000
         MVC   LINE+1(UNDMSGLN),UNDEFMSG                                12940000
FAILEXIT BAL   R14,REPORT          REPORT REASON FOR TERMINATION        12950000
         LA    R15,16                                                   12960000
         B     EXIT                                                     12970000
         EJECT                                                          12980000
************************************************************            12990000
*                                                          *            13000000
*         REPORT WRITER                                    *            13010000
*                                                          *            13020000
************************************************************            13030000
         SPACE                                                          13040000
REPORT   LA    R1,LINE                                                  13050000
         LA    R0,121                                                   13060000
REPORTW  STM   R14,R2,REPORTS                                           13070000
         LA    R3,PRTDCBW          POINT R3 TO DCB                      13080000
         CP    REPORTLN,REPORTMX   IS LINECOUNT LIMIT REACHED?          13090000
         BNH   *+10                NO                                   13100000
         ZAP   REPORTLN,=P'0'      YES, FORCE NEW PAGE                  13110000
         CP    REPORTLN,=P'0'      IS NEW PAGE REQUESTED?               13120000
         BE    REPORTH             YES, GO PRINT HEADING                13130000
REPORTD  CH    R0,=H'121'          IS OUTPUT LINE LENGTH OK?            13140000
         BNL   REPORTP             YES, BRANCH                          13150000
         MVC   REPORTO,REPORTO-1   BLANK THE WORK AREA                  13160000
         BCTR  R14,0               LENGTH MINUS 1                       13170000
         B     *+10                                                     13180000
         MVC   REPORTO(0),0(R1)    COPY OUTPUT LINE                     13190000
         EX    R14,*-6             EXECUTE MVC                          13200000
REPORTB  LA    R1,REPORTO          POINT TO NEW OUTPUT LINE             13210000
REPORTP  LR    R2,R1               POINT R2 TO OUTPUT LINE              13220000
         PUT   (R3),(R2)           WRITE OUTPUT LINE                    13230000
         AP    REPORTLN,=P'1'      INCREMENT LINE COUNTER               13240000
REPORTX  LM    R14,R2,REPORTS      RESTORE REGS                         13250000
         BR    R14                 RETURN                               13260000
REPORTH  AP    REPORTPG,=P'1'      INCREMENT PAGE COUNTER               13270000
         MVC   REPORTO,REPORTO-1   BLANK HEADING                        13280000
         MVI   REPORTO,C'1'        CC = NEW PAGE                        13290000
         MVC   REPORTO+1(L'HEAD1),HEAD1                                 13300000
         LA    R1,REPORTO+075-9    RIGHT EDGE PAGE NO                   13310000
         MVC   3(6,R1),=X'402020202020' EDIT MASK                       13320000
         ED    3(6,R1),REPORTPG    UNPACK PAGE NO                       13330000
         MVC   0(4,R1),=C'PAGE'    INSERT 'PAGE'                        13340000
         PUT   (R3),REPORTO        PUT HEADING LINE 1                   13350000
         MVC   REPORTO,REPORTO-1   BLANK LINE                           13360000
         PUT   (R3),REPORTO        PUT HEADING LINE 2                   13370000
         LM    R0,R1,REPORTS+8     RESTORE R0 AND R1                    13380000
         B     REPORTD             GO PRINT DETAIL LINE                 13390000
         EJECT                                                          13400000
************************************************************            13410000
*                                                          *            13420000
*         END OF FILE                                      *            13430000
*                                                          *            13440000
************************************************************            13450000
         SPACE                                                          13460000
EODUT1   DS    0H                                                       13470000
         BAL   R14,STOW                                                 13480000
EXITRC   LH    R15,RC                                                   13490000
EXIT     LR    R2,R15              SAVE RETURN CODE                     13500000
         LA    R6,CLOSE                                                 13510000
         MVI   0(R6),X'80'                                              13520000
         TM    STATUS,UT2          IS SYSUT2 OPEN?                      13530000
         BZ    EXITC5X             NO, SKIP CLOSE                       13540000
         CLOSE ((R5)),MF=(E,(R6))                                       13550000
         FREEPOOL (R5)                                                  13560000
         TM    STATUS,PDS                                               13570000
         BZ    EXITC5X                                                  13580000
         LM    R0,R1,FREEM         GET LENGTH AND LOCATION OF BUFFERS   13590000
         FREEMAIN R,LV=(0),A=(1)                                        13600000
EXITC5X  DS    0H                                                       13610000
         TM    STATUS,UT1          IS SYSUT1 OPEN?                      13620000
         BZ    EXITC4X             NO, SKIP CLOSE                       13630000
         CLOSE ((R4)),MF=(E,(R6))                                       13640000
         FREEPOOL (R4)                                                  13650000
EXITC4X  DS    0H                                                       13660000
         TM    STATUS,PRT          IS SYSPRINT OPEN?                    13670000
         BZ    EXITC3X             NO, SKIP CLOSE                       13680000
         LA    R3,PRTDCBW          POINT R3 TO DCB                      13690000
         CLOSE ((R3)),MF=(E,(R6))                                       13700000
         FREEPOOL (R3)                                                  13710000
EXITC3X  DS    0H                                                       13720000
         SPACE 1                                                        13730000
         LR    R1,R13                                                   13740000
         L     R0,@SIZE                                                 13750000
         L     R13,4(,R13)                                              13760000
         FREEMAIN R,A=(1),LV=(0)                                        13770000
         LR    R15,R2              RESTORE RETURN CODE                  13780000
         LM    R0,R12,20(R13)                                           13790000
         L     R14,R12(,R13)                                            13800000
         BR    R14                                                      13810000
         EJECT                                                          13820000
************************************************************            13830000
*                                                          *            13840000
*        CONSTANTS                                         *            13850000
*                                                          *            13860000
************************************************************            13870000
         SPACE                                                          13880000
         DS    0F                                                       13890000
UT1EXLST DC    AL1(X'85'),AL3(UT1EXO)  DCB EXIT LIST FOR SYSUT1         13900000
PDSEXLST DC    AL1(X'85'),AL3(UT2EXO)  DCB EXIT LIST FOR SYSUT2         13910000
PRTEXLST DC    AL1(X'85'),AL3(PRTEXO)  DCB EXIT LIST FOR SYSPRINT       13920000
         LTORG                                                          13930000
         SPACE                                                          13940000
HEAD1    DC    C'--- PDSLOAD --- PDS MEMBER RELOAD UTILITY ---'         13950000
         SPACE                                                          13960000
FIXINMSG DC    C'    PDSLOAD TERMINATED - '                             13970000
         DC    C'VARIABLE-LENGTH OUTPUT REQUIRES VARIABLE-LENGTH INPUT' 13980000
FIXMSGLN EQU   *-FIXINMSG                                               13990000
         SPACE                                                          14000000
UNDEFMSG DC    C'    PDSLOAD TERMINATED - '                             14010000
         DC    C'UNDEFINED RECORD FORMAT NOT SUPPORTED'                 14020000
UNDMSGLN EQU   *-UNDEFMSG                                               14030000
         SPACE                                                          14040000
SHORTMSG DC    C'    PDSLOAD TERMINATED - '                             14050000
         DC    C'INPUT FILE LOGICAL RECORD LENGTH LESS THAN 80'         14060000
SHOMSGLN EQU   *-SHORTMSG                                               14070000
         SPACE                                                          14080000
         PRINT NOGEN                                                    14090000
         SPACE                                                          14100000
PRTDCB   DCB   DDNAME=SYSPRINT,MACRF=(PM),DSORG=PS,EXLST=PRTEXLST,     +14110000
               RECFM=FBA,LRECL=121                                      14120000
PRTDCBL  EQU   *-PRTDCB                                                 14130000
         SPACE                                                          14140000
UT1DCB   DCB   DDNAME=SYSUT1,MACRF=(GL),DSORG=PS,                      +14150000
               EODAD=EODUT1,EXLST=UT1EXLST                              14160000
UT1DCBL  EQU   *-UT1DCB                                                 14170000
         SPACE                                                          14180000
PDSDCB   DCB   DDNAME=SYSUT2,MACRF=(W),DSORG=PO,                       +14190000
               EXLST=PDSEXLST,BUFNO=2                                   14200000
PDSDCBL  EQU   *-PDSDCB                                                 14210000
         SPACE                                                          14220000
         PRINT GEN                                                      14230000
         SPACE                                                          14240000
         WRITE PDSDECB,SF,MF=L                                          14250000
PDSDECBL EQU   *-PDSDECB                                                14260000
         SPACE                                                          14270000
TABNONBL DC    64X'FF'                                                  14280000
         DC    X'00'               BLANK                                14290000
         DC    42X'FF'                                                  14300000
         DC    X'00'               COMMA                                14310000
         DC    148X'FF'                                                 14320000
TABBLANK DC    64X'00'                                                  14330000
         DC    X'40'               BLANK                                14340000
         DC    42X'00'                                                  14350000
         DC    X'6B'               COMMA                                14360000
         DC    148X'00'                                                 14370000
         SPACE                                                          14380000
ALPHANUM DC    0D'0',64X'FF',X'00',26X'FF'                              14390000
*                            SPACE                                      14400000
         DC    X'00',4X'FF',X'00',26X'FF',2X'00',68X'FF',09X'00'        14410000
*                $            -              #@           A-I           14420000
         DC    7X'FF',9X'00',8X'FF',8X'00',6X'FF',10X'00',6X'FF'        14430000
*                       J-R            S-Z            0-9               14440000
         SPACE                                                          14450000
*              THE ABOVE TABLE CAN BE USED TO TEST FOR ALPHANUMERIC     14460000
*              (PLUS NATIONALS, HYPHEN, AND BLANK)                      14470000
*              WITH A 'TRT' INSTRUCTION.                                14480000
*              IF THE FIELD IS VALID, CONDITION CODE IS 0.              14490000
*              WARNING: 'TRT' CAN CHANGE THE LOW ORDER 8 BITS           14500000
*              OF REGISTER 2 AND LOW ORDER 24 BITS OF REG 1.            14510000
         SPACE                                                          14520000
NUMERIC  DC    240X'FF',10X'00',6X'FF'                                  14530000
         SPACE                                                          14540000
EODAD    EQU   32                  OFFSET INTO DCB                      14550000
RECFM    EQU   36                  OFFSET INTO DCB                      14560000
EXLST    EQU   36                  OFFSET INTO DCB                      14570000
OFLGS    EQU   48                  OFFSET INTO DCB                      14580000
DDNAM    EQU   40                  OFFSET INTO DCB                      14590000
BLKSI    EQU   62                  OFFSET INTO DCB                      14600000
LRECL    EQU   82                  OFFSET INTO DCB                      14610000
         EJECT                                                          14620000
************************************************************            14630000
*                                                          *            14640000
*        DSECTS                                            *            14650000
*                                                          *            14660000
************************************************************            14670000
         SPACE                                                          14680000
@DATA    DSECT                                                          14690000
         DS    18F                 REGISTER SAVEAREA                    14700000
DOUBLE   DS    D                                                        14710000
OPEN     DS    F                                                        14720000
CLOSE    EQU   OPEN                                                     14730000
COUNTIN  DS    F                                                        14740000
SEQ      DS    F                                                        14750000
UPR      DS    F                                                        14760000
STOWSVR1 DS    F                                                        14770000
OPTIONS  DS    H                                                        14780000
RC       DS    H                                                        14790000
UPDTE    DS    CL2                                                      14800000
PRTDCBW  DS    0F,(PRTDCBL)X                                            14810000
UT1DCBW  DS    0F,(UT1DCBL)X                                            14820000
PDSDCBW  DS    0F,(PDSDCBL)X                                            14830000
FREEM    DS    2F                                                       14840000
PUTPDSR  DS    F                                                        14850000
PUTPDSX  DS    4F                                                       14860000
PUTPDSY  DS    4F                                                       14870000
RECAD    DS    F                                                        14880000
DWLIN    DS    H                                                        14890000
DWLOT    DS    H                                                        14900000
SKIPFLG  DS    X                                              SBG 02/00 14910000
PDSDECB1 DS    0F,(PDSDECBL)X                                           14920000
PDSDECB2 DS    0F,(PDSDECBL)X                                           14930000
STOWR    DS    F                                                        14940000
PACKR    DS    F                                                        14950000
INREC    DS    0D,CL80                                                  14960000
ADD      DS    CL256                                                    14970000
ODL      DS    0F                  OPERAND DESCRIPTOR LIST              14980000
ODE1     DS    2F                  OPERAND DESCRIPTOR ENTRY 1           14990000
ODE2     DS    2F                  OPERAND DESCRIPTOR ENTRY 2           15000000
ODE3     DS    2F                  OPERAND DESCRIPTOR ENTRY 3           15010000
ODE4     DS    2F                  OPERAND DESCRIPTOR ENTRY 4           15020000
ODE5     DS    2F                  OPERAND DESCRIPTOR ENTRY 5           15030000
ODLL     EQU   *-ODL                                                    15040000
STATUS   DS    C                                                        15050000
PRT      EQU   X'80'                                                    15060000
UT1      EQU   X'40'                                                    15070000
UT2      EQU   X'20'                                                    15080000
PDS      EQU   X'10'                                                    15090000
DECB     EQU   X'08'                                                    15100000
COPYM    EQU   X'04'                                                    15110000
SPF      EQU   X'02'                                                    15120000
SSI      EQU   X'01'                                                    15130000
FLAG1    DS    C                                                        15140000
SELECT   EQU   X'80'                                                    15150000
GENSPF   EQU   X'40'               GENERATE SPF STATS                   15160000
NEWPRM   EQU   X'20'               PARM=NEW WAS SPECIFIED               15170000
FIXSZ    EQU   X'10'               SPF STATS SIZE WAS CORRECTED         15180000
         DS    C                   LINE-1                               15190000
LINE     DS    CL133                                                    15200000
         SPACE ,                                                 *JLM*  15210000
RESULT   EQU   LINE+48                                           *JLM*  15220000
         SPACE ,                                                 *JLM*  15230000
LINEH1   DS    CL133                                                    15240000
*                                                                       15250000
MEMSEL   DS    D                                                        15260000
MEMBER   DS    D                                                        15270000
MEMTTR   DS    XL3                                                      15280000
MEMC     DS    XL1                 LENGTH/2 OF MEMUSER                  15290000
MEMUSER  DS    CL30                SPF STATISTICS OR SSI                15300000
         ORG   *-30                                                     15310000
SPFVM    DS    XL2                 VERSION, LEVEL                       15320000
SPFRESV  DS    XL2                 RESERVED                             15330000
SPFCREDT DS    PL4                 DATE CREATED                         15340000
SPFCHGDT DS    PL4                 DATE LAST UPDATED                    15350000
SPFHHMM  DS    XL2                 TIME LAST UPDATED                    15360000
SPFCCNT  DS    H                   CURRENT SIZE                         15370000
SPFICNT  DS    H                   INITIAL SIZE                         15380000
SPFMOD   DS    H                   MODS                                 15390000
SPFUSER  DS    CL10                USERID                               15400000
*                                                                       15410000
REPORTS  DS    6F                  REGISTER SAVE AREA                   15420000
REPORTPG DS    PL3                 PAGE COUNT, INIT P'0'                15430000
REPORTLN DS    PL2                 LINE COUNT, INIT P'0'                15440000
REPORTMX DS    PL2                 LINES/PAGE, INIT P'50'               15450000
REPORTOB DS    CL1                 REPORTO-1 (INIT BLANK)               15460000
REPORTO  DS    CL133               OUTPUT AREA                          15470000
         DS    0D                                                       15480000
@DATAL   EQU   *-@DATA                                                  15490000
         SPACE                                                          15500000
XPF      DSECT                                                          15510000
XPFVM    DS    CL4,C               VERSION, LEVEL                       15520000
XPFCREDT DS    CL5,C               DATE CREATED                         15530000
XPFCHGDT DS    CL5,C               DATE LAST UPDATED                    15540000
XPFHHMM  DS    CL4,C               TIME LAST UPDATED                    15550000
XPFCCNT  DS    CL5,C               CURRENT SIZE                         15560000
XPFICNT  DS    CL5,C               INITIAL SIZE                         15570000
XPFMOD   DS    CL5,C               MODS                                 15580000
XPFUSER  DS    CL10                USERID                               15590000
XP2      DSECT                                                          15600000
XP2VM    DS    CL4,C               VERSION, LEVEL                       15610000
         DS    CL2                 EXTRA LETTERS FOR YEAR               15620000
XP2CREDT DS    CL5,C               DATE CREATED                         15630000
         DS    CL2                 EXTRA LETTERS FOR YEAR               15640000
XP2CHGDT DS    CL5,C               DATE LAST UPDATED                    15650000
XP2HHMM  DS    CL4,C               TIME LAST UPDATED                    15660000
XP2CCNT  DS    CL5,C               CURRENT SIZE                         15670000
XP2ICNT  DS    CL5,C               INITIAL SIZE                         15680000
XP2MOD   DS    CL5,C               MODS                                 15690000
XP2USER  DS    CL10                USERID                               15700000
R0       EQU   0                                                        15710000
R1       EQU   1                                                        15720000
R2       EQU   2                                                        15730000
R3       EQU   3                                                        15740000
R4       EQU   4                                                        15750000
R5       EQU   5                                                        15760000
R6       EQU   6                                                        15770000
R7       EQU   7                                                        15780000
R8       EQU   8                                                        15790000
R9       EQU   9                                                        15800000
R10      EQU   10                                                       15810000
R11      EQU   11                                                       15820000
R12      EQU   12                                                       15830000
R13      EQU   13                                                       15840000
R14      EQU   14                                                       15850000
R15      EQU   15                                                       15860000
         END                                                            15870000
/*                                                                      15880000
//LKED.SYSLMOD DD DSN=SYS2.LINKLIB,DISP=SHR                             15890000
//LKED.SYSIN DD *                                                       15900000
 NAME PDSLOAD(R)                                                        15910000
/*                                                                      15920000
//                                                                      15930000
