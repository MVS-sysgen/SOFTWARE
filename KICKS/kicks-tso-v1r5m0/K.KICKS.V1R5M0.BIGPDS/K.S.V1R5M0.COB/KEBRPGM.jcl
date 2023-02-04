//KEBRPGM JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=3000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//KEBRPGM EXEC  PROC=K2KCOBCL      K2KCOBCS or K2KCOBCL for MVS38
//COPY.SYSUT1 DD *                 KIKCB2CS or KIKCB2CL for Z/OS
       ID DIVISION.
       PROGRAM-ID. KEBRPGM.

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

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN  PIC X(24) VALUE 'KEBRPGM  WORKING STORAGE'.
       77  WS-MSG              PIC X(72) VALUE SPACES.
       77  WS-LOWVALUES        PIC X VALUE LOW-VALUES.
       77  WS-SUB              PIC S9(4) COMP SYNC VALUE +0.
       77  WS-SUB2             PIC S9(4) COMP VALUE +0.
       77  WS-SUB3             PIC S9(4) COMP VALUE +0.
       77  WS-TWALENG          PIC S9(4) COMP VALUE +0.
       77  WS-SCRNWD           PIC S9(4) COMP VALUE +0.
       77  WS-SCRNHT           PIC S9(4) COMP VALUE +0.
       77  WS-DEFSCRNHT        PIC S9(4) COMP VALUE +0.
       77  WS-DEFSCRNWD        PIC S9(4) COMP VALUE +0.
       77  WS-ALTSCRNHT        PIC S9(4) COMP VALUE +0.
       77  WS-ALTSCRNWD        PIC S9(4) COMP VALUE +0.
       77  WS-WHICHMAP         PIC S9(4) COMP VALUE +0.
       77  WS-NUMITEMS         PIC S9(4) COMP VALUE +0.
       77  WS-NUM-LINES        PIC S9(4) COMP VALUE +19.
       77  WS-NUM-COLS         PIC S9(4) COMP VALUE +72.
       77  WS-LINE-SUB         PIC S9(4) COMP.
      * following actual queue name used in API calls
      * it may contain unprintables
      * derived as needed from WS-COMM-QUEUE by GET-HEX
       77  WS-Q                PIC X(16).
      * following are item number and size of each line as it's read
       77  WS-ITEM             PIC S9(4) COMP SYNC.
       77  WS-ITEMSIZE         PIC S9(4) COMP.
      * following are for processing TD queues
       77  WS-SAVE-ITEM        PIC S9(4) COMP.
       77  WS-SAVE-NUM-COLS    PIC S9(4) COMP.
       77  WS-SAVE-COMM-ITEM   PIC S9(4) COMP.
       77  WS-SAVE-COMM-COLUMN PIC S9(4) COMP.
       77  WS-TD-QUEUE         PIC X(4)  VALUE SPACES.
      * following are for processing vsam files
       77  WS-FILE             PIC X(8).
       77  WS-FILE-TYPE        PIC S9(4) COMP SYNC.
       77  WS-FILELOAD-FIRST   PIC S9(4) COMP VALUE +1.
       77  WS-FILELOAD-NUM     PIC S9(4) COMP VALUE +100.
       77  WS-RECSIZE          PIC S9(4) COMP.
      * following needs to be 'S9(8) COMP' for rba's & rrn's...
       77  WS-RID              PIC S9(8) COMP SYNC.
      * following for unknown size of RID that may return...
       77  WS-RID-MORE         PIC X(256).
      * following for use in checksumming queue
       77  WS-CHKSUM-NEW       PIC S9(15) COMP-3.

      * working storage for pointer to TS/TD/file record
<NCB2>
       77  WS-SET              PIC S9(8) COMP VALUE +0.
</NCB2>
<CB2>
       77  WS-SET              USAGE POINTER.
</CB2>

      * working storage copy of comm-area
       01  WS-COMM.
      * displayed and stored q (either QUEUE or QNAME)
      *  - unless it starts with X' it is assumed to be character
      *    data, so QUEUE is the first 8 and QNAME the first 16.
      *  - if it does start with a X' an attempt will be made to
      *    interpret it as HEX. If that succeeds the converted
      *    HEX will be used as a QUEUE/QNAME, otherwise it will be
      *    taken, leading X' and all, as a character name.
      *  - if a HEX string has an odd number of digits it will be
      *    taken as having a leading zero...
      *  - a HEX string is assumed right padded with spaces (ie,
      *    X'40' characters)...
           05  WS-COMM-QUEUE   PIC X(36) VALUE SPACES.
      * whether the above name opened OK, 0=closed, 1=opened
           05  WS-COMM-VALID-Q PIC S9(4) COMP SYNC VALUE +0.
      * HEX and RULER toggles. +1 on, -1 off
           05  WS-COMM-HEX     PIC S9(4) COMP VALUE -1.
           05  WS-COMM-RULER   PIC S9(4) COMP VALUE +1.
      * HELP top line number
           05  WS-COMM-HELP    PIC S9(4) COMP VALUE +0.
      * beginning column of item(s) to show
           05  WS-COMM-COLUMN  PIC S9(4) COMP VALUE +0.
      * number of items in a valid open queue
           05  WS-COMM-NUMITEMS PIC S9(4) COMP VALUE +0.
      * following is the item number for the item on top line
           05  WS-COMM-ITEM    PIC S9(4) COMP VALUE +0.
      * following is maximum itemsize in the queue
           05  WS-COMM-ITEMSIZE PIC S9(4) COMP VALUE +0.
      * following is checksum for the queue
           05  WS-COMM-CHKSUM  PIC S9(15) COMP-3 VALUE +0.
      * ** FIND stuff **
      * find direction (-1 bwd, +1 fwd)
           05  WS-COMM-RFINDD  PIC S9(4) COMP SYNC VALUE +1.
      * which item last found
           05  WS-COMM-FITEM   PIC S9(4) COMP SYNC VALUE +0.
      * where in item was last find
           05  WS-COMM-FOFFS   PIC S9(4) COMP SYNC VALUE +0.
      * how long is find compare
           05  WS-COMM-FINDL   PIC S9(4) COMP SYNC VALUE +0.
      * number direction switches last good find
           05  WS-COMM-FINDSWC PIC S9(4) COMP SYNC VALUE +0.
      * what to find
      * - like queue, this potentially hex value is stored 'displayable'
           05  WS-COMM-FIND    PIC X(36) VALUE SPACES.

      * area to process unformatted input (QUEUE) on initial entry
       01  IM-FLENGTH          PIC S9(8)  COMP VALUE +41.
       01  INPUT-MSG.
           05  FILLER          PIC X(4).
           05  FILLER          PIC X.
           05  IM-QUEUE.
               10  IMQ-TRN     PIC X(4).
               10  IMQ-TRM     PIC X(4).
               10  FILLER      PIC X(28).

      * work areas for dealing with hex/char arguments.
       01  WS-HEX-WORK.
      * input/output areas
           05  WS-HW-HEX-IN    PIC X(36) VALUE SPACES.
           05  WS-HW-CHAR-OUT.
               10  FILLER       PIC X.
               10  WS-HW-CHAR-OUT-REST.
                   15  FILLER   PIC X(14).
                   15  WS-HW-CHAR-OUT-16 PIC X.
      * status values: -1 means not hex, else ok
           05  WS-HW-STATUS    PIC S9(4) COMP.
      * these vars used in determining FIND type and length
           05  WS-HW-FIND-FNS  PIC X.
           05  WS-HW-FIND-LNS  PIC X.
           05  WS-HW-FIND-FNSP PIC S9(4) COMP SYNC VALUE +1.
           05  WS-HW-FIND-LNSP PIC S9(4) COMP.
      * multi-defined work space...
           05  WS-HW.
      * this used to check for leading X'
               10  WS-HW1      PIC X.
               10  WS-HW2      PIC X.
               10  WS-HW3R     PIC X(34).
           05  FILLER REDEFINES WS-HW.
      * this used to 'shift' WS-HW
               10  FILLER      PIC X.
               10  WS-HW2R     PIC X(35).
           05  FILLER REDEFINES WS-HW.
      * this used to punch in ending spaces (actual spaces)
               10  FILLER      PIC X(32).
               10  WS-HW33     PIC X(4).
           05  FILLER REDEFINES WS-HW.
      * this used to add leading zero, trailing spaces (x'40's)
      * also used to find find/last non space for FIND args
               10  WS-HWCHAR   PIC X OCCURS 36.
           05  FILLER REDEFINES WS-HW.
      * this used to punch in char or hex termid
               10  FILLER      PIC X(4).
               10  WS-HW-Q-T   PIC X(4).
               10  FILLER      PIC X(2).
               10  WS-HW-Q-THEX PIC X OCCURS 9.
               10  FILLER      PIC X(17).
      * following holds converted digits as processed
           05  WS-HW-LOW       PIC S9(4) COMP.
      * following if used to convert chars to numbers
           05  WS-HW-DIG.
               10  WS-HW-DIGIT PIC S9(4) COMP.
           05  FILLER REDEFINES WS-HW-DIG.
               10  FILLER      PIC X.
               10  WS-HW-DIGITX PIC X.

      * following for formatting FIND (etal) messages
       01  WS-FIND-MSGS.
           05  WS-FM-CMD       PIC X(4)  VALUE SPACES.
           05  FILLER          PIC X     VALUE SPACES.
           05  WS-FM-DIR       PIC X(3)  VALUE SPACES.
           05  FILLER          PIC X     VALUE SPACES.
           05  WS-FM-ARG       PIC X(36) VALUE SPACES.

      * following are for processing PUT SYSOUT reports
       01  WS-PRINT-VARS.
           05  WS-PRINT-CLASS  PIC X VALUE 'A'.
           05  WS-PRINT-USERID PIC X(8) VALUE '*       '.
           05  WS-PRINT-NODE   PIC X(8) VALUE '*       '.
           05  WS-PRINT-TOKEN  PIC X(8) VALUE SPACES.
           05  WS-PRINT-COLS   PIC 9(3) VALUE 120.
           05  WS-PRINT-PAGENUM PIC S9(4) COMP SYNC.
           05  WS-PRINT-LPP    PIC S9(4) COMP VALUE +60.
           05  WS-PRINT-LPP2   PIC S9(4) COMP.
           05  WS-PRINT-FIRST  PIC S9(4) COMP VALUE +1.
           05  WS-PRINT-ITEMS  PIC S9(4) COMP VALUE +50.
           05  WS-PRINT-ABSTIME PIC S9(15) COMP-3.

      * print header
       01  WS-PRINT-HEADER.
           05  FILLER          PIC X VALUE '1'.
           05  FILLER          PIC X(26) VALUE
           'KEDF listing for TS queue '.
           05  WS-PRTHDR-QUEUE PIC X(16) VALUE SPACES.
           05  FILLER          PIC X(6) VALUE ' user '.
           05  WS-PRTHDR-USER  PIC X(8) VALUE SPACES.
           05  FILLER          PIC X(13) VALUE ' at terminal '.
           05  WS-PRTHDR-TERM  PIC X(4) VALUE SPACES.
           05  FILLER          PIC X(4) VALUE ' at '.
           05  WS-PRTHDR-DATE  PIC X(8) VALUE SPACES.
           05  FILLER          PIC X VALUE SPACE.
           05  WS-PRTHDR-TIME  PIC X(8) VALUE SPACES.
           05  FILLER          PIC X(17) VALUE SPACES.
           05  FILLER          PIC X(5) VALUE 'PAGE '.
           05  WS-PRTHDR-PAGE  PIC ZZZ9 VALUE '  1'.

      * print footer
       01  WS-PRINT-FOOTER.
           05  FILLER          PIC X VALUE SPACE.
           05  FILLER          PIC X(25) VALUE
           'KICKS version 1.5.0, '.
           05  FILLER          PIC X(57) VALUE
           '@ Copyright 2008-2014, Michael Noel, All Rights Reserved.'.

      * print data line
       01  WS-PRINT-LINE.
           05  FILLER          PIC X VALUE SPACE.
           05  WS-PRT-LINE     PIC X(120) VALUE SPACES.

      * some (sub)strings for command processing
       01  WS-MAYBE.
           05  MAYBE-SUB       PIC S9(4) COMP VALUE +0.
           05  MAYBE-NUM       PIC S9(4) COMP VALUE +0.
           05  MAYBE-SAVE      PIC X(50).
           05  MAYBE           PIC X(50).
           05  FILLER REDEFINES MAYBE.
               10  WS-MAYBE1   PIC X.
               10  WS-MAYBE1N REDEFINES WS-MAYBE1 PIC 9.
               10  WS-MAYBER   PIC X(49).
           05  FILLER REDEFINES MAYBE.
               10  WS-MAYBE2   PIC X(2).
               10  FILLER      PIC X(48).
           05  FILLER REDEFINES MAYBE.
               10  WS-MAYBE3   PIC X(3).
               10  FILLER      PIC X(47).
           05  FILLER REDEFINES MAYBE.
               10  WS-MAYBE4   PIC X(4).
               10  FILLER      PIC X(46).
           05  FILLER REDEFINES MAYBE.
               10  WS-MAYBE5   PIC X(5).
               10  FILLER      PIC X(45).
           05  FILLER REDEFINES MAYBE.
               10  WS-MAYBE6   PIC X(6).
               10  FILLER      PIC X(44).
           05  FILLER REDEFINES MAYBE.
               10  WS-MAYBE7   PIC X(7).
               10  FILLER      PIC X(43).
           05  FILLER REDEFINES MAYBE.
               10  WS-MAYBE8   PIC X(8).
               10  FILLER      PIC X(42).
           05  FILLER REDEFINES MAYBE.
               10  WS-MAYBEX   PIC X OCCURS 50.

      * define colors/highlites for parts of the screen
      * Values shown represent the map defaults, and should not be
      * changed here. rather do it at the top of 'FILL-IN-MAP'.
       01  WS-COLORS.
           05  WS-COLORS-SAVE  PIC X.
           05  WS-COLORS-INPUT PIC X VALUE '5'.
           05  WS-COLORS-MSG   PIC X VALUE '2'.
           05  WS-COLORS-RULER PIC X VALUE '5'.
           05  WS-COLORS-TOP   PIC X VALUE '5'.
      * ws-colors-inum not currently used...
           05  WS-COLORS-INUM  PIC X VALUE HIGH-VALUES.
           05  WS-COLORS-ASCII PIC X VALUE '5'.
           05  WS-COLORS-HEX1  PIC X VALUE '5'.
           05  WS-COLORS-HEX2  PIC X VALUE '5'.
           05  WS-COLORS-BOT   PIC X VALUE '5'.
           05  WS-COLORS-HELP  PIC X VALUE HIGH-VALUES.
       01  WS-HILITE.
           05  WS-HILITE-SAVE  PIC X.
           05  WS-HILITE-INPUT PIC X VALUE HIGH-VALUES.
           05  WS-HILITE-MSG   PIC X VALUE HIGH-VALUES.
           05  WS-HILITE-RULER PIC X VALUE HIGH-VALUES.
           05  WS-HILITE-TOP   PIC X VALUE HIGH-VALUES.
      * ws-hilite-inum not currently used...
           05  WS-HILITE-INUM  PIC X VALUE HIGH-VALUES.
           05  WS-HILITE-ASCII PIC X VALUE HIGH-VALUES.
           05  WS-HILITE-HEX1  PIC X VALUE HIGH-VALUES.
           05  WS-HILITE-HEX2  PIC X VALUE HIGH-VALUES.
           05  WS-HILITE-BOT   PIC X VALUE HIGH-VALUES.
           05  WS-HILITE-HELP  PIC X VALUE HIGH-VALUES.

      * variables used to generate character and vertical hex lines
       01  WS-VHEX-VARS.
           05  WS-VHEX-ONCE    PIC S9(4) COMP VALUE +0.
           05  WS-PER          PIC S9(4) COMP VALUE +0.
           05  WS-TEMP-REC-CHAR PIC X.
           05  WS-TEMP-REC-INT PIC S9(4) COMP.
           05  FILLER REDEFINES WS-TEMP-REC-INT.
               10  FILLER      PIC X.
               10  WS-TEMP-REC-INT0 PIC X.
           05  PRINTABLE-TABLES.
               10 PRINTABLE-ALL.
<CB2>
                15 PIC X(16) VALUE X'000102030405060708090A0B0C0D0E0F'.
                15 PIC X(16) VALUE X'101112131415161718191A1B1C1D1E1F'.
                15 PIC X(16) VALUE X'202122232425262728292A2B2C2D2E2F'.
                15 PIC X(16) VALUE X'303132333435363738393A3B3C3D3E3F'.
                15 PIC X(16) VALUE X'404142434445464748494A4B4C4D4E4F'.
                15 PIC X(16) VALUE X'505152535455565758595A5B5C5D5E5F'.
                15 PIC X(16) VALUE X'606162636465666768696A6B6C6D6E6F'.
                15 PIC X(16) VALUE X'707172737475767778797A7B7C7D7E7F'.
                15 PIC X(16) VALUE X'808182838485868788898A8B8C8D8E8F'.
                15 PIC X(16) VALUE X'909192939495969798999A9B9C9D9E9F'.
                15 PIC X(16) VALUE X'A0A1A2A3A4A5A6A7A8A9AAABACADAEAF'.
                15 PIC X(16) VALUE X'B0B1B2B3B4B5B6B7B8B9BABBBCBDBEBF'.
                15 PIC X(16) VALUE X'C0C1C2C3C4C5C6C7C8C9CACBCCCDCECF'.
                15 PIC X(16) VALUE X'D0D1D2D3D4D5D6D7D8D9DADBDCDDDEDF'.
                15 PIC X(16) VALUE X'E0E1E2E3E4E5E6E7E8E9EAEBECEDEEEF'.
                15 PIC X(16) VALUE X'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'.
</CB2>
<NCB2>
      * ANSI COBOL can't init PRINTABLE-ALL with VALUE clauses...
                  15  PT-PA PIC X OCCURS 256.
</NCB2>
               10 PRINTABLE-ALL-VALUES
                  REDEFINES PRINTABLE-ALL PIC X(256).

      * careful with upload/downloads of this program, as the
      * following table MAY contain special characters that won't
      * survive the transfer transliterations...

      * 'X' means the character will be untranslated, SPACE (or
      * anything except 'X') will replace the character with that.

               10 PRINTABLE-ALLOWED.
                  15  FILLER   PIC X(16) VALUE SPACES.
                  15  FILLER   PIC X(16) VALUE SPACES.
                  15  FILLER   PIC X(16) VALUE SPACES.
                  15  FILLER   PIC X(16) VALUE SPACES.
                  15  FILLER   PIC X(16) VALUE '          XXXXXX'.
                  15  FILLER   PIC X(16) VALUE 'X         XXXXX '.
                  15  FILLER   PIC X(16) VALUE 'XX        XXXXXX'.
                  15  FILLER   PIC X(16) VALUE '          XXXXXX'.
                  15  FILLER   PIC X(16) VALUE ' XXXXXXXXX      '.
                  15  FILLER   PIC X(16) VALUE ' XXXXXXXXX      '.
                  15  FILLER   PIC X(16) VALUE ' XXXXXXXXX      '.
                  15  FILLER   PIC X(16) VALUE '          XX    '.
                  15  FILLER   PIC X(16) VALUE 'XXXXXXXXXX      '.
                  15  FILLER   PIC X(16) VALUE 'XXXXXXXXXX      '.
                  15  FILLER   PIC X(16) VALUE 'X XXXXXXXX      '.
                  15  FILLER   PIC X(16) VALUE 'XXXXXXXXXX      '.
               10 PRINTABLE-ALLOWED-VALUES
                  REDEFINES PRINTABLE-ALLOWED PIC X(256).
               10 PAV
                  REDEFINES PRINTABLE-ALLOWED PIC X OCCURS 256.

               10 PRINTABLE-TOPHEX.
                  15  FILLER   PIC X(16) VALUE '0000000000000000'.
                  15  FILLER   PIC X(16) VALUE '1111111111111111'.
                  15  FILLER   PIC X(16) VALUE '2222222222222222'.
                  15  FILLER   PIC X(16) VALUE '3333333333333333'.
                  15  FILLER   PIC X(16) VALUE '4444444444444444'.
                  15  FILLER   PIC X(16) VALUE '5555555555555555'.
                  15  FILLER   PIC X(16) VALUE '6666666666666666'.
                  15  FILLER   PIC X(16) VALUE '7777777777777777'.
                  15  FILLER   PIC X(16) VALUE '8888888888888888'.
                  15  FILLER   PIC X(16) VALUE '9999999999999999'.
                  15  FILLER   PIC X(16) VALUE 'AAAAAAAAAAAAAAAA'.
                  15  FILLER   PIC X(16) VALUE 'BBBBBBBBBBBBBBBB'.
                  15  FILLER   PIC X(16) VALUE 'CCCCCCCCCCCCCCCC'.
                  15  FILLER   PIC X(16) VALUE 'DDDDDDDDDDDDDDDD'.
                  15  FILLER   PIC X(16) VALUE 'EEEEEEEEEEEEEEEE'.
                  15  FILLER   PIC X(16) VALUE 'FFFFFFFFFFFFFFFF'.
               10 PRINTABLE-TOPHEX-VALUES
                  REDEFINES PRINTABLE-TOPHEX PIC X(256).
               10 PTH
                  REDEFINES PRINTABLE-TOPHEX PIC X OCCURS 256.

               10 PRINTABLE-BOTHEX.
                  15  FILLER   PIC X(16) VALUE '0123456789ABCDEF'.
                  15  FILLER   PIC X(16) VALUE '0123456789ABCDEF'.
                  15  FILLER   PIC X(16) VALUE '0123456789ABCDEF'.
                  15  FILLER   PIC X(16) VALUE '0123456789ABCDEF'.
                  15  FILLER   PIC X(16) VALUE '0123456789ABCDEF'.
                  15  FILLER   PIC X(16) VALUE '0123456789ABCDEF'.
                  15  FILLER   PIC X(16) VALUE '0123456789ABCDEF'.
                  15  FILLER   PIC X(16) VALUE '0123456789ABCDEF'.
                  15  FILLER   PIC X(16) VALUE '0123456789ABCDEF'.
                  15  FILLER   PIC X(16) VALUE '0123456789ABCDEF'.
                  15  FILLER   PIC X(16) VALUE '0123456789ABCDEF'.
                  15  FILLER   PIC X(16) VALUE '0123456789ABCDEF'.
                  15  FILLER   PIC X(16) VALUE '0123456789ABCDEF'.
                  15  FILLER   PIC X(16) VALUE '0123456789ABCDEF'.
                  15  FILLER   PIC X(16) VALUE '0123456789ABCDEF'.
                  15  FILLER   PIC X(16) VALUE '0123456789ABCDEF'.
               10 PRINTABLE-BOTHEX-VALUES
                  REDEFINES PRINTABLE-BOTHEX PIC X(256).
               10 PBH
                  REDEFINES PRINTABLE-BOTHEX PIC X OCCURS 256.

      * generated ruler, character, and vertical hex lines
       01  WS-VHEX1.
           05  WS-VHEX1-CNNN   PIC 9(5).
           05  FILLER          PIC X.
           05  WS-VHEX1-C      PIC X OCCURS 152.
       01  WS-VHEX2.
           05  WS-VHEX2-X      PIC X(6).
           05  WS-VHEX2-C      PIC X OCCURS 152.
       01  WS-VHEX3.
           05  WS-VHEX3-X      PIC X(6).
           05  WS-VHEX3-C      PIC X OCCURS 152.
       01  WS-VHEX-RULER.
           05  WS-RULER-CNNN   PIC Z(5).
           05  FILLER          PIC X.
           02  WS-VHEX-RULER-C9.
               05  WS-VHEX-RULER-C PIC X OCCURS 152.
           02  WS-VHEX-RULER-9C REDEFINES WS-VHEX-RULER-C9.
               05  WS-VHEX-RULER-9 PIC 9 OCCURS 152.

       COPY KEBRM.

       COPY DFHAID.
       COPY DFHBMSCA.

       LINKAGE SECTION.
      * since this is only used as a sending field for reloading
      * WS-COMM it just needs to be at least as big as WS-COMM.
      * hopefully WS-COMM will never get this big!
       01  DFHCOMMAREA         PIC X(300).

<NCB2>
       01  BLL-CELLS.
           05  FILLER          PIC S9(8) COMP.
           05  BLL-TEMPREC     PIC S9(8) COMP.
           05  BLL-HELP        PIC S9(8) COMP.
</NCB2>

      * space for a TS (or TD) queue item
      * 'chars' may occur up to 32k but only need to be defined
      * to occur at all (once is good) for subscripting to work.
      * Defining it larger unnecessarily complicates BLL setup.
       01  WS-TEMP-REC.
           05  WS-TEMP-REC-CHARS PIC X OCCURS 1.

      * map of loaded help text
      * 'line' may occur up to several hundred
       01  WS-HELP-TEXT.
           05  WS-HT-NUM  PIC S9(4) COMP.
           05  WS-HT-LINE PIC X(78) OCCURS 1.

       PROCEDURE DIVISION.

      * obtain storage for temp storage/td/file record.
           EXEC CICS GETMAIN SET(WS-SET) FLENGTH(32700)
                INITIMG(WS-LOWVALUES) BELOW NOSUSPEND
                NOHANDLE
           END-EXEC.
           IF EIBRESP NOT EQUAL DFHRESP(NORMAL) THEN
               EXEC CICS ABEND ABCODE('GETM') END-EXEC.
      * and setup addressing
<CB2>
           SET ADDRESS OF WS-TEMP-REC TO WS-SET.
</CB2>
<NCB2>
           MOVE WS-SET TO BLL-TEMPREC.
</NCB2>

      * need screen size early on...
           PERFORM ADJUST-SCREENSIZE.

           IF EIBCALEN = 0 THEN
      * obtain queue name from command line (if given)
               MOVE SPACES TO INPUT-MSG
               EXEC CICS RECEIVE
                 INTO(INPUT-MSG)
                 FLENGTH(IM-FLENGTH) MAXFLENGTH(IM-FLENGTH)
                 NOHANDLE
               END-EXEC
               IF IM-FLENGTH > 5 THEN
<CB2>
                   INSPECT
                    INPUT-MSG REPLACING ALL LOW-VALUES BY SPACES
</CB2>
<NCB2>
                   EXAMINE
                    INPUT-MSG REPLACING ALL LOW-VALUES BY SPACES
</NCB2>
                   MOVE IM-QUEUE TO WS-COMM-QUEUE, MAPB01I
                   MOVE 'Transaction Q ' TO MAYBE-SAVE
                   GO TO NEW-QUEUE
               ELSE
                   MOVE SPACES TO IM-QUEUE
                   MOVE EIBTRNID TO IMQ-TRN
                   MOVE EIBTRMID TO IMQ-TRM
                   MOVE IM-QUEUE TO WS-COMM-QUEUE, MAPB01I
                   MOVE 'Default Q ' TO MAYBE-SAVE
                   GO TO NEW-QUEUE
           ELSE
           IF EIBCALEN NOT = LENGTH OF WS-COMM THEN
                EXEC CICS ABEND ABCODE('COMM') END-EXEC
           ELSE
                MOVE DFHCOMMAREA TO WS-COMM
                PERFORM GET-QUEUE-HEX
                PERFORM ADJUST-SCREENITEMS
                IF WS-WHICHMAP = 1
                    EXEC CICS
                       RECEIVE MAP('KEBRMQ') MAPSET('KEBRM')
                       NOHANDLE
                    END-EXEC
                ELSE
                IF WS-WHICHMAP = 2
                    EXEC CICS
                      RECEIVE MAP('KEBRMR') MAPSET('KEBRM')
                      NOHANDLE
                    END-EXEC
                ELSE
                IF WS-WHICHMAP = 3
                    EXEC CICS
                      RECEIVE MAP('KEBRMS') MAPSET('KEBRM')
                      NOHANDLE
                    END-EXEC
                ELSE
                IF WS-WHICHMAP = 4
                    EXEC CICS
                      RECEIVE MAP('KEBRMT') MAPSET('KEBRM')
                      NOHANDLE
                    END-EXEC
                ELSE
                IF WS-WHICHMAP = 5
                    EXEC CICS
                      RECEIVE MAP('KEBRMU') MAPSET('KEBRM')
                      NOHANDLE
                    END-EXEC
                ELSE
                    EXEC CICS
                      RECEIVE MAP('KEBRMP') MAPSET('KEBRM')
                      NOHANDLE
                    END-EXEC.

      * allow 'finish-up' aids early
           IF EIBAID = DFHCLEAR OR
                       DFHPF3   OR DFHPF12  OR
                       DFHPF15  OR DFHPF24 THEN
               GO TO FINISH-IT.

      * make sure no strange 'mapfail' or 'invmpsz' issues
           IF EIBRESP NOT = DFHRESP(NORMAL) THEN
               EXEC CICS ABEND ABCODE('MAPF') END-EXEC.

      * go elsewhere to handle other not-ENTER aids
           IF EIBAID NOT = DFHENTER THEN GO TO NOT-ENTER.

      * figure out what user typed
           IF MAPB01I NOT = WS-COMM-QUEUE THEN
               MOVE 'Overtyped Queue ' TO MAYBE-SAVE
               GO TO NEW-QUEUE.
           IF MAPC01I NOT = WS-COMM-ITEM THEN
               MOVE 'Overtyped Line/Item ' TO MAYBE-SAVE
               GO TO NEW-ITEM.
           IF MAPC02I NOT = WS-COMM-COLUMN THEN
               MOVE 'Overtyped Column ' TO MAYBE-SAVE
               GO TO NEW-COL.

           MOVE MAPB02I TO MAYBE.
<CB2>
           INSPECT
              MAYBE REPLACING ALL LOW-VALUES BY SPACES.
</CB2>
<NCB2>
           EXAMINE
              MAYBE REPLACING ALL LOW-VALUES BY SPACES.
</NCB2>

      * keep command around for use with error messages...
           MOVE MAYBE TO MAYBE-SAVE.

           IF WS-MAYBE1 = ' ' THEN PERFORM SHIFT-MAYBE.

      * check for more ways of quitting
           IF WS-MAYBE3 = '=X '     THEN GO TO FINISH-IT.
           IF WS-MAYBE4 = 'END '    THEN GO TO FINISH-IT.
           IF WS-MAYBE5 = 'QUIT '   THEN GO TO FINISH-IT.
           IF WS-MAYBE7 = 'CANCEL ' THEN GO TO FINISH-IT.
      *
      * check for (and execute) 'commands'
      *   --  stuff typed after 'command' prompt (line 2)
      *
           IF WS-MAYBE1 = ' ' OR WS-MAYBE8 = 'REFRESH ' THEN
               MOVE +0 TO WS-COMM-HELP
               GO TO REDO-IT.
      *
           IF WS-MAYBE4 = 'TOP ' THEN
               IF WS-COMM-HELP > 0 THEN
               MOVE +1 TO WS-COMM-HELP
               GO TO REDO-IT
               ELSE
               MOVE 1 TO WS-COMM-ITEM
               PERFORM ADJUST-ITEM
               GO TO REDO-IT.
      *
           IF WS-MAYBE4 = 'BOT ' OR WS-MAYBE7 = 'BOTTOM ' THEN
               IF WS-COMM-HELP > 0 THEN
               MOVE +999 TO WS-COMM-HELP
               GO TO REDO-IT
               ELSE
               MOVE WS-COMM-NUMITEMS TO WS-COMM-ITEM
               PERFORM ADJUST-ITEM
               GO TO REDO-IT.

      * following commands not valid if showing help...
           IF WS-COMM-HELP > 0 THEN GO TO  BAD-COMMAND.
      *
           IF WS-MAYBE5 = 'HELP ' THEN
               MOVE +1 TO WS-COMM-HELP
               GO TO REDO-IT.
      *
           IF WS-MAYBE5 = 'LEFT ' THEN
               SUBTRACT WS-NUM-COLS FROM WS-COMM-COLUMN
               PERFORM ADJUST-COLUMN
               GO TO REDO-IT.
      *
           IF WS-MAYBE6 = 'RIGHT ' THEN
               ADD WS-NUM-COLS TO WS-COMM-COLUMN
               PERFORM ADJUST-COLUMN
               GO TO REDO-IT.
      *
           IF WS-MAYBE5 = 'LINE ' THEN
               PERFORM SHIFT-MAYBE
               PERFORM GET-MAYBE-NUM
               IF MAYBE-NUM > 0 THEN
                   MOVE MAYBE-NUM TO MAPC01I
                   GO TO NEW-ITEM
               ELSE
                   MOVE 'Bad line (item) number' TO WS-MSG
                   GO TO REDO-IT.
      *
           IF WS-MAYBE4 = 'COL ' OR WS-MAYBE7 = 'COLUMN ' THEN
               PERFORM SHIFT-MAYBE
               PERFORM GET-MAYBE-NUM
               IF MAYBE-NUM > 0 THEN
                   MOVE MAYBE-NUM TO MAPC02I
                   GO TO NEW-COL
               ELSE
                   MOVE 'Bad column number' TO WS-MSG
                   GO TO REDO-IT.
      *
           IF WS-MAYBE4 = 'HEX ' THEN
               MULTIPLY -1 BY WS-COMM-HEX
               PERFORM ADJUST-SCREENITEMS
               GO TO REDO-IT.
      *
           IF WS-MAYBE6 = 'RULER ' THEN
               MULTIPLY -1 BY WS-COMM-RULER
               PERFORM ADJUST-SCREENITEMS
               GO TO REDO-IT.
      *
           IF WS-MAYBE2 NOT = 'F ' AND
              WS-MAYBE5 NOT = 'FIND ' THEN GO TO NOT-FIND.
           IF WS-COMM-VALID-Q = 0 THEN
               MOVE 'TSQ not valid for FIND ' TO WS-MSG
               GO TO REDO-IT.
           PERFORM SHIFT-MAYBE.
           IF WS-MAYBE4 = SPACES THEN GO TO RFIND-FROM-FIND.
           MOVE +1 TO WS-COMM-RFINDD.
           MOVE WS-COMM-ITEM TO WS-COMM-FITEM.
           MOVE +0 TO WS-COMM-FINDL, WS-COMM-FOFFS, WS-COMM-FINDSWC.
           MOVE SPACES TO WS-COMM-FIND.
           IF WS-MAYBE4 = 'FWD ' THEN
               MOVE +1 TO WS-COMM-RFINDD
               PERFORM SHIFT-MAYBE
           ELSE
           IF WS-MAYBE4 = 'BWD ' THEN
               MOVE -1 TO WS-COMM-RFINDD
               PERFORM SHIFT-MAYBE.
           IF MAYBE = SPACES THEN
               MOVE 'Missing argument' TO WS-MSG
               GO TO REDO-IT.
           PERFORM FIND-IT.
           IF WS-COMM-FINDL NOT = +0 THEN
               PERFORM RFIND-IT
               IF WS-MSG = SPACES THEN
                   MOVE WS-COMM-FITEM TO WS-COMM-ITEM
                   MOVE WS-COMM-FOFFS TO WS-COMM-COLUMN.
           PERFORM ADJUST-SCREENITEMS.
           GO TO REDO-IT.
       NOT-FIND.
      *
           IF WS-MAYBE6 NOT = 'RFIND ' THEN GO TO NOT-RFIND.
           IF WS-COMM-VALID-Q = 0 THEN
               MOVE 'TSQ not valid for RFIND ' TO WS-MSG
               GO TO REDO-IT.
           PERFORM SHIFT-MAYBE.
       RFIND-FROM-FIND.
           IF WS-MAYBE4 = SPACES THEN
               MOVE TALLY TO TALLY
           ELSE
           IF WS-MAYBE4 = 'FWD ' THEN
               MOVE +1 TO WS-COMM-RFINDD
           ELSE
           IF WS-MAYBE4 = 'BWD ' THEN
               MOVE -1 TO WS-COMM-RFINDD
           ELSE
               MOVE 'Bad argument' TO WS-MSG
               GO TO REDO-IT.
           IF WS-COMM-FINDL = 0 THEN
               MOVE 'No previous FIND' TO WS-MSG
               GO TO REDO-IT.
           MOVE MAYBE-SAVE TO WS-FM-CMD.
           IF WS-COMM-RFINDD > 0 THEN
               MOVE '>>>' TO WS-FM-DIR
           ELSE
               MOVE '<<<' TO WS-FM-DIR.
           MOVE WS-COMM-FIND TO WS-FM-ARG.
           MOVE WS-FIND-MSGS TO MAYBE-SAVE.
           PERFORM RFIND-IT.
           IF WS-MSG = SPACES THEN
               MOVE WS-COMM-FITEM TO WS-COMM-ITEM
               MOVE WS-COMM-FOFFS TO WS-COMM-COLUMN.
           PERFORM ADJUST-SCREENITEMS.
           GO TO REDO-IT.
       NOT-RFIND.
     *
           IF WS-MAYBE5 = 'VGET ' THEN
               PERFORM SHIFT-MAYBE
               PERFORM MOVE-FILE
               PERFORM SHIFT-MAYBE
               PERFORM LOAD-FILE
               PERFORM PRE-READ-TSQ
               MOVE WS-CHKSUM-NEW TO WS-COMM-CHKSUM
               PERFORM ADJUST-SCREENITEMS
               GO TO REDO-IT.
      *
           IF WS-MAYBE4 = 'GET ' THEN
               PERFORM SHIFT-MAYBE
               PERFORM MOVE-TDQ
               PERFORM LOAD-TDQ
               PERFORM DELETE-TDQ
               PERFORM PRE-READ-TSQ
               MOVE WS-CHKSUM-NEW TO WS-COMM-CHKSUM
               PERFORM ADJUST-SCREENITEMS
               GO TO REDO-IT.
      *
           IF WS-MAYBE4 = 'PUT ' THEN
             IF WS-COMM-VALID-Q > 0 THEN
               PERFORM SHIFT-MAYBE
               IF WS-MAYBE7 = 'SYSOUT ' THEN
                   PERFORM SHIFT-MAYBE
                   PERFORM PRINT-INSTEAD
                   PERFORM ADJUST-SCREENITEMS
                   GO TO REDO-IT
               ELSE
                   PERFORM MOVE-TDQ
                   PERFORM SAVE-TDQ
                   PERFORM ADJUST-SCREENITEMS
                   GO TO REDO-IT
             ELSE
                MOVE 'TSQ not valid for PUT ' TO WS-MSG
                GO TO REDO-IT.

      *
      *    'PRINT' is just a synonym for 'PUT SYSOUT'
      *
           IF WS-MAYBE6 = 'PRINT ' THEN
             IF WS-COMM-VALID-Q > 0 THEN
               PERFORM SHIFT-MAYBE
               PERFORM PRINT-INSTEAD
               PERFORM ADJUST-SCREENITEMS
               GO TO REDO-IT
             ELSE
               MOVE 'TSQ not valid for PRINT ' TO WS-MSG
               GO TO REDO-IT.
      *
           IF WS-MAYBE6 = 'PURGE ' THEN
             IF WS-COMM-VALID-Q > 0 THEN
               PERFORM DELETE-TSQ
               MOVE 'QUEUE deleted' TO WS-MSG
               PERFORM ADJUST-SCREENITEMS
               GO TO REDO-IT
             ELSE
               MOVE 'TSQ not valid for PURGE ' TO WS-MSG
               GO TO REDO-IT.
      *
           IF WS-MAYBE2 = 'Q ' OR WS-MAYBE6 = 'QUEUE ' THEN
               PERFORM SHIFT-MAYBE
               MOVE MAYBE TO WS-COMM-QUEUE
               PERFORM GET-QUEUE-HEX
               PERFORM PRE-READ-TSQ
               MOVE WS-CHKSUM-NEW TO WS-COMM-CHKSUM
               PERFORM ADJUST-SCREENITEMS
               GO TO REDO-IT.
      *
           IF WS-MAYBE5 NOT = 'TERM ' THEN GO TO NOT-TERM.
           PERFORM SHIFT-MAYBE.
      * if no argument use current termid
           IF MAYBE = SPACES THEN MOVE EIBTRMID TO MAYBE.
           MOVE WS-COMM-QUEUE TO WS-HW.
      * if queue not in hex format just move in termid
           IF WS-HW1 NOT = 'X' OR
              WS-HW2 NOT = QUOTE THEN
               MOVE MAYBE TO WS-HW-Q-T
               GO TO TERM-4.
      * if queue is in hex format may need to fill in area
      * between hex digits currently present and where the
      * new ones go. also may need to account for implied
      * leading hex zero...
      * -- so start by counting the digits
<NCB2>
           EXAMINE WS-HW TALLYING UNTIL FIRST SPACE.
</NCB2>
<CB2>
           MOVE ZERO TO TALLY.
           INSPECT WS-HW TALLYING TALLY FOR CHARACTERS BEFORE SPACE.
</CB2>
      * capture digit count (less leading X' and trailing quote)
           MOVE TALLY TO WS-SUB3.
           ADD  -3    TO WS-SUB3.
      * if count less than 7 need to fill in some x'40's
           IF WS-SUB3 < 7 THEN
              MOVE WS-SUB3 TO WS-SUB2
              COMPUTE WS-SUB = WS-SUB3 + 3
              PERFORM TERM-2 UNTIL WS-SUB2 NOT < 7.
      * if count odd then logically add leading zero
           DIVIDE WS-SUB3 BY 2 GIVING WS-SUB REMAINDER WS-SUB2.
           MOVE +0 TO WS-HW-DIGIT, WS-SUB.
           IF WS-SUB2 > 0 THEN ADD -1 TO WS-SUB.
           PERFORM TERM-3 4 TIMES.
      * if we're are now past the end add a new quote
           ADD +1 TO WS-SUB.
           IF WS-HW-Q-THEX (WS-SUB) = SPACE THEN
               MOVE QUOTE TO WS-HW-Q-THEX (WS-SUB)
               ADD +1 TO WS-SUB
               MOVE SPACE TO WS-HW-Q-THEX (WS-SUB).
           GO TO TERM-4.
       TERM-2.
      * move x'40's to area between current and termid
           MOVE '4' TO WS-HWCHAR (WS-SUB).
           ADD +1 TO WS-SUB, WS-SUB2.
           MOVE '0' TO WS-HWCHAR (WS-SUB).
           ADD +1 TO WS-SUB, WS-SUB2.
       TERM-3.
      * move hex digits into the string
           MOVE WS-MAYBE1 TO WS-HW-DIGITX.
           ADD +1 TO WS-HW-DIGIT, WS-SUB.
           MOVE PTH (WS-HW-DIGIT) TO WS-HW-Q-THEX (WS-SUB).
           ADD +1 TO WS-SUB.
           MOVE PBH (WS-HW-DIGIT) TO WS-HW-Q-THEX (WS-SUB).
           MOVE WS-MAYBER TO MAYBE.
       TERM-4.
      * char or hex wrap up the change...
           MOVE WS-HW TO MAPB01I.
           GO TO NEW-QUEUE.
       NOT-TERM.
      *
       BAD-COMMAND.
           MOVE 'Undefined command ' TO WS-MSG.
           GO TO REDO-IT.
      *
      * check for (and execute) screen value overtypes
      *   --  stuff typed in line 1 fields
      *
       NEW-QUEUE.
           IF WS-COMM-HELP > 0 THEN GO TO BAD-COMMAND.
           MOVE MAPB01I TO WS-COMM-QUEUE.
           PERFORM GET-QUEUE-HEX.
           PERFORM PRE-READ-TSQ.
           IF WS-MSG = SPACES THEN MOVE 'Ok' TO WS-MSG.
           MOVE WS-CHKSUM-NEW TO WS-COMM-CHKSUM.
           PERFORM ADJUST-SCREENITEMS.
           GO TO REDO-IT.
      *
       NEW-ITEM.
           IF WS-COMM-HELP > 0 THEN GO TO BAD-COMMAND.
           MOVE MAPC01I TO WS-COMM-ITEM.
           PERFORM ADJUST-SCREENITEMS.
           PERFORM ADJUST-ITEM.
           GO TO REDO-IT.
      *
       NEW-COL.
           IF WS-COMM-HELP > 0 THEN GO TO BAD-COMMAND.
           MOVE MAPC02I TO WS-COMM-COLUMN.
           PERFORM ADJUST-COLUMN.
           GO TO REDO-IT.

      *
      * handle PF?? functions
      *
       NOT-ENTER.

       PF1.
      *    - help
           IF EIBAID NOT = DFHPF1 THEN GO TO PF2.
           MOVE 'PF1 ' TO MAYBE-SAVE.
           MOVE +1 TO WS-COMM-HELP.
           GO TO REDO-IT.

       PF2.
      *    - switch between simple character and vhex display
           IF EIBAID NOT = DFHPF2 THEN GO TO PF3.
           MOVE 'PF2 ' TO MAYBE-SAVE.
           IF WS-COMM-HELP > 0 THEN GO TO BAD-COMMAND.
           MULTIPLY -1 BY WS-COMM-HEX.
           PERFORM ADJUST-SCREENITEMS.
           GO TO REDO-IT.

       PF3.
      *    - QUIT - handled above...

       PF5.
      *    - find again
           IF EIBAID NOT = DFHPF5 THEN GO TO PF17.
           MOVE 'PF5 ' TO MAYBE-SAVE.
           IF WS-COMM-HELP > 0 THEN GO TO BAD-COMMAND.
           IF WS-COMM-FINDL = 0 THEN
               MOVE 'No previous FIND' TO WS-MSG
               GO TO REDO-IT.
           MOVE MAYBE-SAVE TO WS-FM-CMD.
           IF WS-COMM-RFINDD > 0 THEN
               MOVE '>>>' TO WS-FM-DIR
           ELSE
               MOVE '<<<' TO WS-FM-DIR.
           MOVE WS-COMM-FIND TO WS-FM-ARG.
           MOVE WS-FIND-MSGS TO MAYBE-SAVE.
           PERFORM RFIND-IT.
           IF WS-MSG = SPACES THEN
               MOVE WS-COMM-FITEM TO WS-COMM-ITEM
               MOVE WS-COMM-FOFFS TO WS-COMM-COLUMN.
           PERFORM ADJUST-SCREENITEMS.
           GO TO REDO-IT.

       PF17.
      *    - switch directions (then use PF5 to continue)
           IF EIBAID NOT = DFHPF17 THEN GO TO PF7.
           MOVE 'PF17 ' TO MAYBE-SAVE.
           IF WS-COMM-HELP > 0 THEN GO TO BAD-COMMAND.
           IF WS-COMM-FINDL = 0 THEN
               MOVE 'No previous FIND' TO WS-MSG
               GO TO REDO-IT.
           MULTIPLY WS-COMM-RFINDD  BY -1 GIVING WS-COMM-RFINDD.
           GO TO REDO-IT.

       PF7.
      *    - scroll back (toward TOP)
           IF EIBAID NOT = DFHPF7 THEN GO TO PF19.
           MOVE 'PF7 ' TO MAYBE-SAVE.
           IF WS-COMM-HELP > 0 THEN
               SUBTRACT WS-NUM-LINES FROM WS-COMM-HELP
               IF WS-COMM-HELP > 0 THEN GO TO REDO-IT
               ELSE
               MOVE +1 TO WS-COMM-HELP
               GO TO REDO-IT.
           PERFORM ANALYZE-CURSOR.
           IF WS-SUB = 0 THEN
               SUBTRACT WS-NUMITEMS FROM WS-COMM-ITEM
               PERFORM ADJUST-ITEM
           ELSE
               MOVE WS-SUB TO WS-COMM-ITEM
               SUBTRACT WS-NUMITEMS FROM WS-COMM-ITEM
               ADD 1 TO WS-COMM-ITEM
               IF WS-COMM-ITEM < 1 THEN MOVE 1 TO WS-COMM-ITEM.
           PERFORM ADJUST-SCREENITEMS.
           GO TO REDO-IT.

       PF19.
      *    - (shift PF7) - scroll TOP
           IF EIBAID NOT = DFHPF19 THEN GO TO PF8.
           MOVE 'PF19 ' TO MAYBE-SAVE.
           IF WS-COMM-HELP > 0 THEN
               MOVE +1 TO WS-COMM-HELP
               GO TO REDO-IT.
           MOVE 1 TO WS-COMM-ITEM.
           PERFORM ADJUST-ITEM.
           GO TO REDO-IT.

       PF8.
      *    - scroll forward (toward BOTTOM)
           IF EIBAID NOT = DFHPF8 THEN GO TO PF20.
           MOVE 'PF8 ' TO MAYBE-SAVE.
           IF WS-COMM-HELP > 0 THEN
               ADD WS-NUM-LINES TO WS-COMM-HELP
               GO TO REDO-IT.
           PERFORM ANALYZE-CURSOR.
           IF WS-SUB = 0 THEN
               ADD WS-NUMITEMS TO WS-COMM-ITEM
               PERFORM ADJUST-ITEM
           ELSE
               MOVE WS-SUB TO WS-COMM-ITEM.
           PERFORM ADJUST-SCREENITEMS.
           GO TO REDO-IT.

       PF20.
      *    - (shift PF8) - scroll BOTTOM
           IF EIBAID NOT = DFHPF20 THEN GO TO PF10.
           MOVE 'PF20 ' TO MAYBE-SAVE.
           IF WS-COMM-HELP > 0 THEN
               MOVE +999 TO WS-COMM-HELP
               GO TO REDO-IT.
           MOVE WS-COMM-NUMITEMS TO WS-COMM-ITEM.
           PERFORM ADJUST-ITEM.
           GO TO REDO-IT.

       PF10.
      *    - scroll left
           IF EIBAID NOT = DFHPF10 THEN GO TO PF11.
           MOVE 'PF10 ' TO MAYBE-SAVE.
           IF WS-COMM-HELP > 0 THEN GO TO BAD-COMMAND.
           PERFORM ANALYZE-CURSOR.
           IF WS-SUB = 0 THEN
               SUBTRACT WS-NUM-COLS FROM WS-COMM-COLUMN
               PERFORM ADJUST-COLUMN
           ELSE
               ADD WS-SUB2 TO WS-COMM-COLUMN
               SUBTRACT WS-NUM-COLS FROM WS-COMM-COLUMN
               IF WS-COMM-COLUMN < 1 THEN
                   MOVE 1 TO WS-COMM-COLUMN.
           GO TO REDO-IT.

       PF11.
      *    - scroll right
           IF EIBAID NOT = DFHPF11 THEN GO TO BAD-PF.
           MOVE 'PF11 ' TO MAYBE-SAVE.
           IF WS-COMM-HELP > 0 THEN GO TO BAD-COMMAND.
           PERFORM ANALYZE-CURSOR.
           IF WS-SUB = 0 THEN
               ADD WS-NUM-COLS TO WS-COMM-COLUMN
               PERFORM ADJUST-COLUMN
           ELSE
               ADD WS-SUB2 TO WS-COMM-COLUMN
               SUBTRACT 1 FROM WS-COMM-COLUMN.
           GO TO REDO-IT.

       BAD-PF.
           MOVE 'Unassigned PF key ' TO MAYBE-SAVE.
           MOVE 'Invalid ATTN key entered' TO WS-MSG.
     *     GO TO REDO-IT.

       REDO-IT.
           PERFORM FILL-IN-MAP.
           IF WS-WHICHMAP = 1
               EXEC CICS
                 SEND MAP('KEBRMQ') MAPSET('KEBRM') ERASE ALTERNATE
               END-EXEC
           ELSE
           IF WS-WHICHMAP = 2
               EXEC CICS
                 SEND MAP('KEBRMR') MAPSET('KEBRM') ERASE ALTERNATE
               END-EXEC
           ELSE
           IF WS-WHICHMAP = 3
               EXEC CICS
                 SEND MAP('KEBRMS') MAPSET('KEBRM') ERASE ALTERNATE
               END-EXEC
           ELSE
           IF WS-WHICHMAP = 4
               EXEC CICS
                 SEND MAP('KEBRMT') MAPSET('KEBRM') ERASE ALTERNATE
               END-EXEC
           ELSE
           IF WS-WHICHMAP = 5
               EXEC CICS
                 SEND MAP('KEBRMU') MAPSET('KEBRM') ERASE ALTERNATE
               END-EXEC
           ELSE
               EXEC CICS
                 SEND MAP('KEBRMP') MAPSET('KEBRM') ERASE
               END-EXEC.

       RETURN-IT.
           IF WS-MSG NOT = SPACES THEN
               EXEC CICS SEND CONTROL ALARM END-EXEC.
           EXEC CICS
             RETURN TRANSID(EIBTRNID) COMMAREA(WS-COMM)
           END-EXEC.

       FINISH-IT.
      * if in HELP, quit that, but continue with normal display
           IF WS-COMM-HELP > 0 THEN
               MOVE +0 TO WS-COMM-HELP
               GO TO REDO-IT.
      * otherwise it's bye bye...
           MOVE 'Browse ended normally. Ready for next transaction:'
               TO WS-VHEX1.
           IF WS-WHICHMAP = 0 THEN
               EXEC CICS SEND TEXT
                    FROM(WS-VHEX1) LENGTH(52)
                    ERASE FREEKB
               END-EXEC
           ELSE
               EXEC CICS SEND TEXT
                    FROM(WS-VHEX1) LENGTH(52)
                    ERASE ALTERNATE FREEKB
               END-EXEC.
           EXEC CICS RETURN END-EXEC.

       FILL-IN-MAP SECTION.
      *    override default colors/hilites here...
           MOVE DFHGREEN TO WS-COLORS-INPUT.
           MOVE DFHUNDLN TO WS-HILITE-INPUT.
           MOVE DFHRED   TO WS-COLORS-MSG.
      * ?? MOVE DFHBLINK TO WS-HILITE-MSG.
           MOVE DFHNEUTR TO WS-COLORS-TOP, WS-COLORS-BOT.
           MOVE DFHPINK  TO WS-COLORS-RULER.
           MOVE DFHNEUTR TO WS-COLORS-HELP.
           MOVE DFHREVRS TO WS-HILITE-HELP.
      *    fill biggest of overlaying maps with low values
           MOVE LOW-VALUES TO KEBRMUO.
      *    fill in items in same location on all maps
      *    fill in the tran id
           MOVE EIBTRNID  TO MAPA01O.
      *    fill in the QUEUE
           MOVE WS-COMM-QUEUE   TO MAPB01O.
           MOVE WS-COLORS-INPUT TO MAPB01C.
           MOVE WS-HILITE-INPUT TO MAPB01H.
      *    fill in the item number
           MOVE WS-COMM-ITEM    TO MAPC01O.
           MOVE WS-COLORS-INPUT TO MAPC01C.
           MOVE WS-HILITE-INPUT TO MAPC01H.
      *    fill in the number of items
           MOVE WS-COMM-NUMITEMS TO MAPD01O.
      *    fill in the offset
           MOVE WS-COMM-COLUMN  TO MAPC02O.
           MOVE WS-COLORS-INPUT TO MAPC02C.
           MOVE WS-HILITE-INPUT TO MAPC02H.
      *    fill in the item size
           MOVE WS-COMM-ITEMSIZE TO MAPD02O.
      *    add colors/hilites to command line
           MOVE SPACES          TO MAPB02O.
           MOVE WS-COLORS-INPUT TO MAPB02C.
           MOVE WS-HILITE-INPUT TO MAPB02H.

      *    get ready to use main line group
           MOVE 1 TO WS-LINE-SUB.

      *    show help if that's the plan
           IF WS-COMM-HELP > 0 THEN
               PERFORM FIM-HELP
               GO TO FIM-EXIT.

      *    if there is a message show it in the top line(S)
           IF WS-MSG NOT = SPACES THEN
               MOVE WS-COLORS-MSG TO WS-COLORS-HELP
               MOVE WS-HILITE-MSG TO WS-HILITE-HELP
               MOVE MAYBE-SAVE TO WS-VHEX1
               PERFORM FIM-HELP-LINE
               MOVE WS-MSG TO WS-VHEX1
               PERFORM FIM-HELP-LINE.

      *    if there is a queue show its lines
           IF WS-COMM-VALID-Q > 0 THEN
               PERFORM FIM-RULER THRU FIM-RULER-X
               PERFORM FIM-TOP
               PERFORM FIM-LINES
                   VARYING WS-ITEM FROM WS-COMM-ITEM BY 1
                   UNTIL WS-ITEM > (WS-NUMITEMS + WS-COMM-ITEM - 1)
                      OR WS-ITEM > WS-COMM-NUMITEMS
               PERFORM FIM-BOTTOM THRU FIM-BOTTOM-X
               MOVE WS-NUM-LINES TO WS-LINE-SUB
               PERFORM FIM-RULER THRU FIM-RULER-X.
           GO TO FIM-EXIT.

       FIM-HELP.
      * load help text
           EXEC CICS LOAD PROGRAM('KEBRHELP') SET(WS-SET)
               NOHANDLE
           END-EXEC.
           IF EIBRESP NOT = DFHRESP(NORMAL) THEN
               MOVE 'Help is not available ' TO WS-MSG
               GO TO FIM-EXIT.
<CB2>
           SET ADDRESS OF WS-HELP-TEXT TO WS-SET.
</CB2>
<NCB2>
           MOVE WS-SET TO BLL-HELP.
</NCB2>
      * make sure beginning line of help won't go to far
           COMPUTE WS-SUB = WS-COMM-HELP + WS-NUM-LINES - 1.
           IF WS-SUB > WS-HT-NUM THEN
               COMPUTE WS-COMM-HELP = WS-COMM-HELP -
                                     (WS-SUB - WS-HT-NUM).
           IF WS-COMM-HELP < 1 THEN MOVE +1 TO WS-COMM-HELP.
           MOVE WS-COMM-HELP TO WS-SUB.
           PERFORM FIM-HELP-2 WS-NUM-LINES TIMES.
       FIM-HELP-2.
           MOVE SPACES TO WS-VHEX1.
           IF WS-SUB NOT > WS-HT-NUM THEN
               MOVE WS-HT-LINE (WS-SUB) TO WS-VHEX1.
      * fixup for assembler not liking quotes in text...
<CB2>
           INSPECT WS-VHEX1 REPLACING ALL '`' BY QUOTE.
</CB2>
<NCB2>
           EXAMINE WS-VHEX1 REPLACING ALL '`' BY QUOTE.
</NCB2>
           PERFORM FIM-HELP-LINE.
           ADD +1 TO WS-SUB.
       FIM-HELP-LINE.
           IF WS-NUM-COLS = 72  THEN
               MOVE WS-VHEX1        TO MAPA03O (WS-LINE-SUB)
               MOVE WS-COLORS-HELP  TO MAPA03C (WS-LINE-SUB)
               MOVE WS-HILITE-HELP  TO MAPA03H (WS-LINE-SUB)
           ELSE
           IF WS-NUM-COLS = 79  THEN
               MOVE WS-VHEX1        TO MASA03O (WS-LINE-SUB)
               MOVE WS-COLORS-HELP  TO MASA03C (WS-LINE-SUB)
               MOVE WS-HILITE-HELP  TO MASA03H (WS-LINE-SUB)
           ELSE
           IF WS-NUM-COLS = 124 THEN
               MOVE WS-VHEX1        TO MATA03O (WS-LINE-SUB)
               MOVE WS-COLORS-HELP  TO MATA03C (WS-LINE-SUB)
               MOVE WS-HILITE-HELP  TO MATA03H (WS-LINE-SUB)
           ELSE
           IF WS-NUM-COLS = 152 THEN
               MOVE WS-VHEX1        TO MAUA03O (WS-LINE-SUB)
               MOVE WS-COLORS-HELP  TO MAUA03C (WS-LINE-SUB)
               MOVE WS-HILITE-HELP  TO MAUA03H (WS-LINE-SUB)
           ELSE
           EXEC CICS ABEND ABCODE('SSIZ') END-EXEC.
           ADD +1 TO WS-LINE-SUB.

       FIM-RULER.
           IF WS-COMM-RULER < 0 THEN GO TO FIM-RULER-X.
           PERFORM MAKE-RULER.
           IF WS-NUM-COLS = 72  THEN
               MOVE WS-VHEX-RULER   TO MAPA03O (WS-LINE-SUB)
               MOVE WS-COLORS-RULER TO MAPA03C (WS-LINE-SUB)
               MOVE WS-HILITE-RULER TO MAPA03H (WS-LINE-SUB)
           ELSE
           IF WS-NUM-COLS = 79  THEN
               MOVE WS-VHEX-RULER   TO MASA03O (WS-LINE-SUB)
               MOVE WS-COLORS-RULER TO MASA03C (WS-LINE-SUB)
               MOVE WS-HILITE-RULER TO MASA03H (WS-LINE-SUB)
           ELSE
           IF WS-NUM-COLS = 124 THEN
               MOVE WS-VHEX-RULER   TO MATA03O (WS-LINE-SUB)
               MOVE WS-COLORS-RULER TO MATA03C (WS-LINE-SUB)
               MOVE WS-HILITE-RULER TO MATA03H (WS-LINE-SUB)
           ELSE
           IF WS-NUM-COLS = 152 THEN
               MOVE WS-VHEX-RULER   TO MAUA03O (WS-LINE-SUB)
               MOVE WS-COLORS-RULER TO MAUA03C (WS-LINE-SUB)
               MOVE WS-HILITE-RULER TO MAUA03H (WS-LINE-SUB)
           ELSE
           EXEC CICS ABEND ABCODE('SSIZ') END-EXEC.
           ADD  1 TO WS-LINE-SUB.
       FIM-RULER-X.
           MOVE TALLY TO TALLY.

       FIM-TOP.
           IF WS-COMM-ITEM = 1 THEN
               IF WS-NUM-COLS = 72  THEN
                 MOVE '*** TOP OF QUEUE ******' TO MAPA03O (WS-LINE-SUB)
                 MOVE WS-COLORS-TOP TO MAPA03C (WS-LINE-SUB)
                 MOVE WS-HILITE-TOP TO MAPA03H (WS-LINE-SUB)
                 ADD  1 TO WS-LINE-SUB
               ELSE
               IF WS-NUM-COLS = 79  THEN
                 MOVE '*** TOP OF QUEUE ******' TO MASA03O (WS-LINE-SUB)
                 MOVE WS-COLORS-TOP TO MASA03C (WS-LINE-SUB)
                 MOVE WS-HILITE-TOP TO MASA03H (WS-LINE-SUB)
                 ADD  1 TO WS-LINE-SUB
               ELSE
               IF WS-NUM-COLS = 124 THEN
                 MOVE '*** TOP OF QUEUE ******' TO MATA03O (WS-LINE-SUB)
                 MOVE WS-COLORS-TOP TO MATA03C (WS-LINE-SUB)
                 MOVE WS-HILITE-TOP TO MATA03H (WS-LINE-SUB)
                 ADD  1 TO WS-LINE-SUB
               ELSE
               IF WS-NUM-COLS = 152 THEN
                 MOVE '*** TOP OF QUEUE ******' TO MAUA03O (WS-LINE-SUB)
                 MOVE WS-COLORS-TOP TO MAUA03C (WS-LINE-SUB)
                 MOVE WS-HILITE-TOP TO MAUA03H (WS-LINE-SUB)
                 ADD  1 TO WS-LINE-SUB
               ELSE
               EXEC CICS ABEND ABCODE('SSIZ') END-EXEC.

       FIM-BOTTOM.
           SUBTRACT 1 FROM WS-ITEM.
           IF WS-ITEM < WS-COMM-NUMITEMS THEN GO TO FIM-BOTTOM-X.
           IF WS-LINE-SUB > (WS-NUM-LINES - 1) THEN GO TO FIM-BOTTOM-X.
           IF WS-NUM-COLS = 72  THEN
             MOVE '*** BOTTOM OF QUEUE ******' TO MAPA03O (WS-LINE-SUB)
             MOVE WS-COLORS-TOP TO MAPA03C (WS-LINE-SUB)
             MOVE WS-HILITE-TOP TO MAPA03H (WS-LINE-SUB)
           ELSE
           IF WS-NUM-COLS = 79  THEN
             MOVE '*** BOTTOM OF QUEUE ******' TO MASA03O (WS-LINE-SUB)
             MOVE WS-COLORS-TOP TO MASA03C (WS-LINE-SUB)
             MOVE WS-HILITE-TOP TO MASA03H (WS-LINE-SUB)
           ELSE
           IF WS-NUM-COLS = 124 THEN
             MOVE '*** BOTTOM OF QUEUE ******' TO MATA03O (WS-LINE-SUB)
             MOVE WS-COLORS-TOP TO MATA03C (WS-LINE-SUB)
             MOVE WS-HILITE-TOP TO MATA03H (WS-LINE-SUB)
           ELSE
           IF WS-NUM-COLS = 152 THEN
             MOVE '*** BOTTOM OF QUEUE ******' TO MAUA03O (WS-LINE-SUB)
             MOVE WS-COLORS-TOP TO MAUA03C (WS-LINE-SUB)
             MOVE WS-HILITE-TOP TO MAUA03H (WS-LINE-SUB)
           ELSE
           EXEC CICS ABEND ABCODE('SSIZ') END-EXEC.
       FIM-BOTTOM-X.
           MOVE TALLY TO TALLY.

       FIM-LINES.
           PERFORM READ-TSQ.
           PERFORM VHEX.
           IF WS-NUM-COLS = 72  THEN PERFORM FIM-72
           ELSE
           IF WS-NUM-COLS = 79  THEN PERFORM FIM-79
           ELSE
           IF WS-NUM-COLS = 124 THEN PERFORM FIM-124
           ELSE
           IF WS-NUM-COLS = 152 THEN PERFORM FIM-152
           ELSE
           EXEC CICS ABEND ABCODE('SSIZ') END-EXEC.
       FIM-72.
      * 72 for mod2, mod3, mod4 'p' ('q', 'r')
           MOVE WS-ITEM  TO WS-VHEX1-CNNN.
           MOVE WS-VHEX1 TO MAPA03O (WS-LINE-SUB).
           MOVE WS-COLORS-ASCII TO MAPA03C (WS-LINE-SUB).
           MOVE WS-HILITE-ASCII TO MAPA03H (WS-LINE-SUB).
           ADD  1 TO WS-LINE-SUB.
           IF WS-COMM-HEX > 0 THEN
               MOVE WS-VHEX2 TO MAPA03O (WS-LINE-SUB)
               MOVE WS-COLORS-HEX1 TO MAPA03C (WS-LINE-SUB)
               MOVE WS-HILITE-HEX1 TO MAPA03H (WS-LINE-SUB)
               ADD  1 TO WS-LINE-SUB
               MOVE WS-VHEX3 TO MAPA03O (WS-LINE-SUB)
               MOVE WS-COLORS-HEX2 TO MAPA03C (WS-LINE-SUB)
               MOVE WS-HILITE-HEX2 TO MAPA03H (WS-LINE-SUB)
               ADD  1 TO WS-LINE-SUB.
       FIM-79.
      * 79 for mecaff custom 's'
           MOVE WS-ITEM  TO WS-VHEX1-CNNN.
           MOVE WS-VHEX1 TO MASA03O (WS-LINE-SUB).
           MOVE WS-COLORS-ASCII TO MASA03C (WS-LINE-SUB).
           MOVE WS-HILITE-ASCII TO MASA03H (WS-LINE-SUB).
           ADD  1 TO WS-LINE-SUB.
           IF WS-COMM-HEX > 0 THEN
               MOVE WS-VHEX2 TO MASA03O (WS-LINE-SUB)
               MOVE WS-COLORS-HEX1 TO MASA03C (WS-LINE-SUB)
               MOVE WS-HILITE-HEX1 TO MASA03H (WS-LINE-SUB)
               ADD  1 TO WS-LINE-SUB
               MOVE WS-VHEX3 TO MASA03O (WS-LINE-SUB)
               MOVE WS-COLORS-HEX2 TO MASA03C (WS-LINE-SUB)
               MOVE WS-HILITE-HEX2 TO MASA03H (WS-LINE-SUB)
               ADD  1 TO WS-LINE-SUB.
       FIM-124.
      * 124 for mod5 't'
           MOVE WS-ITEM  TO WS-VHEX1-CNNN.
           MOVE WS-VHEX1 TO MATA03O (WS-LINE-SUB).
           MOVE WS-COLORS-ASCII TO MATA03C (WS-LINE-SUB).
           MOVE WS-HILITE-ASCII TO MATA03H (WS-LINE-SUB).
           ADD  1 TO WS-LINE-SUB.
           IF WS-COMM-HEX > 0 THEN
               MOVE WS-VHEX2 TO MATA03O (WS-LINE-SUB)
               MOVE WS-COLORS-HEX1 TO MATA03C (WS-LINE-SUB)
               MOVE WS-HILITE-HEX1 TO MATA03H (WS-LINE-SUB)
               ADD  1 TO WS-LINE-SUB
               MOVE WS-VHEX3 TO MATA03O (WS-LINE-SUB)
               MOVE WS-COLORS-HEX2 TO MATA03C (WS-LINE-SUB)
               MOVE WS-HILITE-HEX2 TO MATA03H (WS-LINE-SUB)
               ADD  1 TO WS-LINE-SUB.
       FIM-152.
      * 152 for 3290 'u'
           MOVE WS-ITEM  TO WS-VHEX1-CNNN.
           MOVE WS-VHEX1 TO MATA03O (WS-LINE-SUB).
           MOVE WS-COLORS-ASCII TO MAUA03C (WS-LINE-SUB).
           MOVE WS-HILITE-ASCII TO MAUA03H (WS-LINE-SUB).
           ADD  1 TO WS-LINE-SUB.
           IF WS-COMM-HEX > 0 THEN
               MOVE WS-VHEX2 TO MAUA03O (WS-LINE-SUB)
               MOVE WS-COLORS-HEX1 TO MAUA03C (WS-LINE-SUB)
               MOVE WS-HILITE-HEX1 TO MAUA03H (WS-LINE-SUB)
               ADD  1 TO WS-LINE-SUB
               MOVE WS-VHEX3 TO MAUA03O (WS-LINE-SUB)
               MOVE WS-COLORS-HEX2 TO MAUA03C (WS-LINE-SUB)
               MOVE WS-HILITE-HEX2 TO MAUA03H (WS-LINE-SUB)
               ADD  1 TO WS-LINE-SUB.
       FIM-EXIT.
           EXIT.

       MAKE-RULER SECTION.
      * create ruler line
      * using WS-COMM-COLUMN, ws-comm-itemsize
           MOVE SPACES TO WS-VHEX-RULER.
           PERFORM MAKE-RULE
               VARYING WS-PER FROM +1 BY +1
               UNTIL   WS-PER > WS-NUM-COLS
                    OR WS-PER > WS-COMM-ITEMSIZE - (WS-COMM-COLUMN - 1).
           GO TO MAKE-RULER-EXIT.
       MAKE-RULE.
           COMPUTE WS-SUB2 = (WS-COMM-COLUMN - 1) + WS-PER.
           IF WS-SUB2 > 99 THEN SUBTRACT 100 FROM WS-SUB2.
           DIVIDE 10 INTO WS-SUB2 GIVING TALLY REMAINDER WS-SUB2.
           IF WS-SUB2 = 0 THEN
               MOVE TALLY TO WS-VHEX-RULER-9 (WS-PER)
           ELSE
           IF WS-SUB2 = 5 THEN
               MOVE '|' TO WS-VHEX-RULER-C (WS-PER)
           ELSE
               MOVE '.' TO WS-VHEX-RULER-C (WS-PER).
       MAKE-RULER-EXIT.
           EXIT.

       VHEX SECTION.
      * format ws-vhex1, ws-vhex2, ws-vhex3 as 'vertical hex'
      * from ws-temp-rec
      * using ws-comm-column, ws-itemsize
           MOVE SPACES TO WS-VHEX1, WS-VHEX2, WS-VHEX3.
           PERFORM VHEX-PERCHAR
               VARYING WS-PER FROM +1 BY +1
               UNTIL   WS-PER > WS-NUM-COLS
                    OR WS-PER > WS-ITEMSIZE - (WS-COMM-COLUMN - 1).
           GO TO VHEX-PERCHAR-2.
       VHEX-PERCHAR.
           COMPUTE WS-SUB = (WS-COMM-COLUMN - 1) + WS-PER.
           MOVE WS-TEMP-REC-CHARS (WS-SUB) TO WS-VHEX1-C (WS-PER),
                                              WS-VHEX2-C (WS-PER),
                                              WS-VHEX3-C (WS-PER).
       VHEX-PERCHAR-2.

</SD> don't trace this messing with printable tables...
<NCB2>
      * ANSI COBOL can't init PRINTABLE-ALL with VALUE clauses...
       VHEX-MAKE-PRINTABLE.
           IF WS-VHEX-ONCE > 0 THEN GO TO VHEX-ASCII.
           ADD +1 TO WS-VHEX-ONCE.
           PERFORM VHEX-MAKE-PRINTABLE-2
               VARYING WS-SUB FROM +1 BY +1 UNTIL WS-SUB = 256.
       VHEX-MAKE-PRINTABLE-2.
           SUBTRACT +1 FROM WS-SUB GIVING WS-TEMP-REC-INT.
           MOVE WS-TEMP-REC-INT0 TO PT-PA (WS-SUB).
</NCB2>
      * since PRINTABLE-ALLOW is fragile with respect to
      * file transfer mangling it's fixed up here...
       VHEX-MAKE-PRINTABLE-3.
           PERFORM VHEX-MAKE-PRINTABLE-4
               VARYING WS-SUB FROM +1 BY +1 UNTIL WS-SUB = 256.
       VHEX-MAKE-PRINTABLE-4.
           IF PAV (WS-SUB) = 'X' THEN
               SUBTRACT +1 FROM WS-SUB GIVING WS-TEMP-REC-INT
               MOVE WS-TEMP-REC-INT0 TO PAV (WS-SUB).
<SD> turn tracing back on

<NCB2>
       VHEX-ASCII.
           TRANSFORM WS-VHEX1
                FROM PRINTABLE-ALL-VALUES
                  TO PRINTABLE-ALLOWED-VALUES.
           IF WS-COMM-HEX < 0 THEN GO TO VHEX-EXIT.
       VHEX-TOPHEX.
           TRANSFORM WS-VHEX2
                FROM PRINTABLE-ALL-VALUES
                  TO PRINTABLE-TOPHEX-VALUES.
       VHEX-BOTHEX.
           TRANSFORM WS-VHEX3
                FROM PRINTABLE-ALL-VALUES
                  TO PRINTABLE-BOTHEX-VALUES.
</NCB2>
<CB2>
       VHEX-ASCII.
           INSPECT WS-VHEX1
                CONVERTING PRINTABLE-ALL-VALUES
                        TO PRINTABLE-ALLOWED-VALUES.
           IF WS-COMM-HEX < 0 THEN GO TO VHEX-EXIT.
       VHEX-TOPHEX.
           INSPECT WS-VHEX2
                CONVERTING PRINTABLE-ALL-VALUES
                        TO PRINTABLE-TOPHEX-VALUES.
       VHEX-BOTHEX.
           INSPECT WS-VHEX3
                CONVERTING PRINTABLE-ALL-VALUES
                        TO PRINTABLE-BOTHEX-VALUES.
</CB2>
       VHEX-FIXUP-SPACES.
           MOVE SPACES TO WS-VHEX2-X, WS-VHEX3-X.
           COMPUTE WS-PER = WS-ITEMSIZE - WS-COMM-COLUMN + 2.
           IF WS-PER > WS-NUM-COLS THEN
               ADD +1, WS-NUM-COLS GIVING WS-PER.
           PERFORM VHEX-FIXUP2
               VARYING WS-SUB FROM WS-PER BY +1
               UNTIL WS-SUB > 152.
           GO TO VHEX-EXIT.
       VHEX-FIXUP2.
      * this to blank the vhex on the 'line number' part
      *           and past the end of the logical record
           MOVE SPACE TO WS-VHEX2-C (WS-SUB), WS-VHEX3-C (WS-SUB).
       VHEX-EXIT.
           EXIT.


       PRE-READ-TSQ SECTION.
      * read entire q to determine checksum & max itemsize
      * exit with item 1 in storage
      * status in eibresp as usual
           MOVE +32700 TO WS-ITEMSIZE.
           MOVE +0     TO WS-CHKSUM-NEW.
           MOVE ALL SPACES TO WS-TEMP-REC.
           EXEC CICS READQ TS
             QNAME(WS-Q) ITEM(1)
             INTO(WS-TEMP-REC) LENGTH(WS-ITEMSIZE)
             NUMITEMS(WS-COMM-NUMITEMS)
             NOHANDLE
           END-EXEC.
           IF EIBRESP = DFHRESP(NORMAL) THEN
               MOVE 1 TO WS-COMM-VALID-Q
               MOVE WS-ITEMSIZE TO WS-COMM-ITEMSIZE
               PERFORM CHKSUM-TSQ
           ELSE
               MOVE 0 TO WS-COMM-VALID-Q,
                         WS-COMM-ITEMSIZE,
                         WS-COMM-ITEM,
                         WS-COMM-NUMITEMS,
                         WS-COMM-COLUMN
               IF WS-MSG = SPACES THEN
                   MOVE 'Can not read that QUEUE ' TO WS-MSG
                   GO TO PRE-READ-TSQ-EXIT
              ELSE
                   GO TO PRE-READ-TSQ-EXIT.
       PRE-READ-TSQ-NEXT.
           MOVE +32700 TO WS-ITEMSIZE.
           MOVE ALL SPACES TO WS-TEMP-REC.
           EXEC CICS READQ TS
             QNAME(WS-Q) NEXT
             INTO(WS-TEMP-REC) LENGTH(WS-ITEMSIZE)
             NOHANDLE
           END-EXEC.
           IF EIBRESP NOT = DFHRESP(NORMAL) THEN
               GO TO PRE-READ-TSQ-DONE.
           PERFORM CHKSUM-TSQ.
           IF WS-ITEMSIZE > WS-COMM-ITEMSIZE THEN
               MOVE WS-ITEMSIZE TO WS-COMM-ITEMSIZE.
           GO TO PRE-READ-TSQ-NEXT.
       PRE-READ-TSQ-DONE.
      * put 1st item back into memory
           MOVE 1 TO WS-ITEM,
                     WS-COMM-ITEM,
                     WS-COMM-COLUMN.
           PERFORM READ-TSQ.
       PRE-READ-TSQ-EXIT.
           EXIT.

       CHKSUM-TSQ SECTION.
      * add current record to new checksum
           MOVE +0 TO WS-TEMP-REC-INT.
           IF WS-ITEMSIZE < 1 THEN GO TO CHKSUM-TSQ-EXIT.
</SD> turn source trace off for this loopy stuff...
           PERFORM CHKS-1
               VARYING WS-SUB FROM +1 BY +1
               UNTIL WS-SUB = WS-ITEMSIZE.
        CHKS-1.
           MOVE WS-TEMP-REC-CHARS (WS-SUB) TO WS-TEMP-REC-INT0.
           ADD WS-TEMP-REC-INT TO WS-CHKSUM-NEW.
       CHKSUM-TSQ-EXIT.
<SD>  turn source trace back on
           EXIT.

       DELETE-TSQ SECTION.
      * delete tsq, reset valid-q
           EXEC CICS DELETEQ TS
             QNAME(WS-Q)
             NOHANDLE
           END-EXEC.
           MOVE 0 TO WS-COMM-VALID-Q.
       DELETE-TSQ-EXIT.
           EXIT.

       READ-TSQ SECTION.
      * read tsq item, status in eibresp as usual
           MOVE +32700 TO WS-ITEMSIZE.
           MOVE ALL SPACES TO WS-TEMP-REC.
           EXEC CICS READQ TS
             QNAME(WS-Q) ITEM(WS-ITEM)
             INTO(WS-TEMP-REC) LENGTH(WS-ITEMSIZE)
             NOHANDLE
           END-EXEC.
       READ-TSQ-EXIT.
           EXIT.

       WRITE-TSQ SECTION.
      * write NEXT tsq item, status in eibresp as usual
           EXEC CICS WRITEQ TS
             QNAME(WS-Q)
             FROM(WS-TEMP-REC) LENGTH(WS-ITEMSIZE)
             AUXILIARY
             NOSUSPEND NOHANDLE
           END-EXEC.
       WRITE-TSQ-EXIT.
           EXIT.

       FIND-IT SECTION.
      * get find argument and setup for subsequent RFINDS
      *   mostly get find length...
           MOVE MAYBE TO WS-COMM-FIND, WS-HW-HEX-IN, WS-HW.
           MOVE -1 TO WS-COMM-FOFFS.
      * set first non-space
           MOVE WS-HW1 TO WS-HW-FIND-FNS.
           MOVE SPACE  TO WS-HW-FIND-LNS.
           MOVE +1 TO WS-HW-FIND-FNSP.
      * find last non-space
           MOVE +36 TO WS-SUB.
           PERFORM FI-2 VARYING WS-HW-FIND-LNSP FROM +36 BY -1
               UNTIL WS-HW-FIND-LNSP = 1
                  OR WS-HW-FIND-LNS NOT = SPACE.
           ADD +1 TO WS-HW-FIND-LNSP.
           COMPUTE WS-COMM-FINDL = WS-HW-FIND-LNSP
                                 - WS-HW-FIND-FNSP + 1.
      * check for hex
           PERFORM GET-HEX.
           IF WS-HW-STATUS < 0 THEN GO TO FI-1.
      * it is hex
           IF WS-HW-FIND-LNS = QUOTE THEN
               SUBTRACT +1 FROM WS-HW-FIND-LNSP
               MOVE WS-HWCHAR (WS-HW-FIND-LNSP) TO WS-HW-FIND-LNS
               SUBTRACT +1 FROM WS-COMM-FINDL.
           SUBTRACT +2 FROM WS-COMM-FINDL.
           ADD +1 TO WS-COMM-FINDL.
           DIVIDE WS-COMM-FINDL BY 2 GIVING WS-COMM-FINDL.
           GO TO FIND-IT-EXIT.
       FI-1.
      * it's not hex so first make sure it's not to big
           IF WS-COMM-FINDL > 16 THEN
               MOVE 'Argument is to long ' TO WS-MSG
               MOVE +0 TO WS-COMM-FINDL
               GO TO FIND-IT-EXIT.
      *  so see if first and last char as the same (delimiters)
           IF WS-HW-FIND-FNS NOT = WS-HW-FIND-LNS THEN
               GO TO FIND-IT-EXIT.
      * need to remove delimiter and adjust length (negative length
      * indicates to RFIND that there is a leading delimiter)
           SUBTRACT +2 FROM WS-COMM-FINDL.
           IF WS-COMM-FINDL < 1 THEN
               MOVE 'Argument is to short ' TO WS-MSG
               MOVE +0 TO WS-COMM-FINDL
               GO TO FIND-IT-EXIT.
           MULTIPLY WS-COMM-FINDL BY -1 GIVING WS-COMM-FINDL.
           GO TO FIND-IT-EXIT.
       FI-2.
           MOVE WS-HWCHAR (WS-HW-FIND-LNSP) TO WS-HW-FIND-LNS.
       FIND-IT-EXIT.
           EXIT.

       RFIND-IT SECTION.
      * execute a find
           MOVE WS-COMM-FIND TO WS-HW-HEX-IN, WS-HW.
           PERFORM GET-HEX.
           IF WS-COMM-FINDL < 0 THEN MOVE WS-HW2R TO WS-HW
           ELSE
           IF WS-HW-STATUS  = 0 THEN MOVE WS-HW-CHAR-OUT TO WS-HW.
      * re read last item found
       RFI-1.
           MOVE WS-COMM-FITEM TO WS-ITEM.
           PERFORM READ-TSQ.
           IF EIBRESP = DFHRESP(ITEMERR) THEN GO TO RFI-SWITCH.
           IF EIBRESP NOT = DFHRESP(NORMAL) THEN
               MOVE 'Could not read TSQ' TO WS-MSG
               GO TO RFI-Z.
      * when foffs < 0 we recalc it based on direction, but when
      * we've already done at least one read in this find we use
      * the one from the last task.
           IF WS-COMM-FOFFS < 0 THEN
               MOVE +0 TO WS-COMM-FOFFS
               IF WS-COMM-RFINDD > 0 THEN GO TO RFI-2
               ELSE
               ADD WS-ITEMSIZE TO WS-COMM-FOFFS
               IF WS-COMM-FINDL > 0 THEN
                   SUBTRACT WS-COMM-FINDL FROM WS-COMM-FOFFS
               ELSE
                   ADD WS-COMM-FINDL TO WS-COMM-FOFFS.
      * begin scan 1 char past previous find
       RFI-2.
           ADD WS-COMM-RFINDD TO WS-COMM-FOFFS.
           IF WS-COMM-FOFFS < 1 THEN
               MOVE -1 TO WS-COMM-FOFFS
               ADD -1 TO WS-COMM-FITEM
               GO TO RFI-1.
           IF WS-COMM-FINDL > 0 THEN
               COMPUTE WS-SUB = WS-COMM-FOFFS + WS-COMM-FINDL
           ELSE
               COMPUTE WS-SUB = WS-COMM-FOFFS - WS-COMM-FINDL.
           IF WS-SUB > WS-ITEMSIZE THEN
               MOVE -1 TO WS-COMM-FOFFS
               ADD +1 TO WS-COMM-FITEM
               GO TO RFI-1.
           MOVE +1 TO WS-SUB.
           MOVE WS-COMM-FOFFS TO WS-SUB2.
           MOVE WS-COMM-FINDL TO WS-SUB3.
           IF WS-SUB3 < ZERO THEN
               MULTIPLY WS-SUB3 BY -1 GIVING WS-SUB3.
      * SUB  is start of find arg,
      * SUB2 is start of compare in item,
      * SUB3 is length of compare
           PERFORM RFI-3 VARYING WS-SUB FROM WS-SUB BY +1
               UNTIL WS-SUB > WS-SUB3.
      * if match we are done, else loop
           IF WS-SUB < 100 THEN
                MOVE +1 TO WS-COMM-FINDSWC
                GO TO RFIND-IT-EXIT.
           GO TO RFI-2.
       RFI-3.
           IF WS-TEMP-REC-CHARS (WS-SUB2) NOT EQUAL
              WS-HWCHAR (WS-SUB) THEN
              MOVE +100 TO WS-SUB
           ELSE
              ADD +1 TO WS-SUB2.
       RFI-SWITCH.
      * EOF, so either switch direction or announce not found
           IF WS-COMM-FINDSWC = +1 THEN
               MOVE 'EOF/BOF in FIND' TO WS-MSG
               MULTIPLY WS-COMM-RFINDD  BY -1 GIVING WS-COMM-RFINDD
               MOVE WS-COMM-ITEM TO WS-COMM-FITEM
               MOVE WS-COMM-COLUMN TO WS-COMM-FOFFS
               ADD WS-COMM-RFINDD TO WS-COMM-FOFFS
               MOVE +0 TO WS-COMM-FINDSWC
               GO TO RFIND-IT-EXIT.
           MOVE 'Not found ' TO WS-MSG.
       RFI-Z.
      * error, so reset find and exit
           MOVE +1 TO WS-COMM-RFINDD.
           MOVE +0 TO WS-COMM-FINDL, WS-COMM-FITEM, WS-COMM-FOFFS.
      *    MOVE SPACES TO WS-COMM-FIND.
       RFIND-IT-EXIT.
           EXIT.

       DELETE-TDQ SECTION.
      * delete tdq
           EXEC CICS DELETEQ TD
             QUEUE(WS-TD-QUEUE)
             NOHANDLE
           END-EXEC.
           IF WS-MSG = SPACES THEN MOVE 'Ok' TO WS-MSG.
       DELETE-TDQ-EXIT.
           EXIT.

       LOAD-TDQ SECTION.
      * load TDQ into TS, status in WS-MSG
           MOVE WS-ITEM TO WS-SAVE-ITEM.
       LOAD-TDQ1.
           PERFORM READ-TDQ.
           IF EIBRESP = DFHRESP(QIDERR) THEN
               MOVE 'TDQ not found' TO WS-MSG
               GO TO LOAD-TDQ2.
           IF EIBRESP = DFHRESP(QZERO) THEN
               GO TO LOAD-TDQ2.
           IF EIBRESP NOT = DFHRESP(NORMAL) THEN
               MOVE 'TDQ did not LOAD-1' TO WS-MSG
               GO TO LOAD-TDQ2.
           PERFORM WRITE-TSQ.
           IF EIBRESP = DFHRESP(NORMAL) THEN
               GO TO LOAD-TDQ1.
           MOVE 'TDQ did not LOAD-2' TO WS-MSG.
       LOAD-TDQ2.
           MOVE WS-SAVE-ITEM TO WS-ITEM.
           IF WS-MSG = SPACES THEN MOVE 'Ok' TO WS-MSG.
       LOAD-TDQ-EXIT.
           EXIT.

       READ-TDQ SECTION.
      * read NEXT tdq item, status in eibresp as usual
           MOVE +32700 TO WS-ITEMSIZE.
           MOVE ALL SPACES TO WS-TEMP-REC.
           EXEC CICS READQ TD
             QUEUE(WS-TD-QUEUE)
             INTO(WS-TEMP-REC) LENGTH(WS-ITEMSIZE)
             NOSUSPEND NOHANDLE
           END-EXEC.
       READ-TDQ-EXIT.
           EXIT.

       SAVE-TDQ SECTION.
      * save TDQ from TS, status in WS-MSG
           MOVE WS-ITEM TO WS-SAVE-ITEM.
           MOVE 1 TO WS-ITEM.
       SAVE-TDQ1.
           PERFORM READ-TSQ.
           IF EIBRESP = DFHRESP(ITEMERR) THEN
               GO TO SAVE-TDQ2.
           IF EIBRESP NOT = DFHRESP(NORMAL) THEN
               MOVE 'TDQ did not SAVE-1' TO WS-MSG
               GO TO SAVE-TDQ2.
           PERFORM WRITE-TDQ.
           IF EIBRESP NOT = DFHRESP(NORMAL) THEN
               MOVE 'TDQ did not SAVE-2' TO WS-MSG
               GO TO SAVE-TDQ2.
           ADD 1 TO WS-ITEM.
           GO TO SAVE-TDQ1.
       SAVE-TDQ2.
           MOVE WS-SAVE-ITEM TO WS-ITEM.
           IF WS-MSG = SPACES THEN MOVE 'Ok' TO WS-MSG.
       SAVE-TDQ-EXIT.
           EXIT.

       WRITE-TDQ SECTION.
      * write NEXT tdq item, status in eibresp as usual
           EXEC CICS WRITEQ TD
             QUEUE(WS-TD-QUEUE)
             FROM(WS-TEMP-REC) LENGTH(WS-ITEMSIZE)
             NOHANDLE
           END-EXEC.
       WRITE-TDQ-EXIT.
           EXIT.

       LOAD-FILE SECTION.
      * load vsam file into TSQ, status in WS-MSG

      * VGET filename [ FIRST NNNN RECS NNNN ]

      * get optional arguments in any order
       LF-GETARGS.
           IF WS-MAYBE1 = SPACE THEN GO TO LF-STARTBR.

       LF-GA-1.
           IF WS-MAYBE6 NOT = 'FIRST ' THEN GO TO LF-GA-2.
           PERFORM SHIFT-MAYBE.
           PERFORM GET-MAYBE-NUM
           IF MAYBE-NUM > 0 THEN
               MOVE MAYBE-NUM TO WS-FILELOAD-FIRST
           ELSE
               MOVE 'FIRST wrong' TO WS-MSG
               GO TO LOAD-FILE-EXIT.
           PERFORM SHIFT-MAYBE.
           GO TO LF-GETARGS.

       LF-GA-2.
           IF WS-MAYBE5 NOT = 'RECS ' THEN GO TO LF-GA-X.
           PERFORM SHIFT-MAYBE.
           PERFORM GET-MAYBE-NUM
           IF MAYBE-NUM > 0 THEN
               MOVE MAYBE-NUM TO WS-FILELOAD-NUM
           ELSE
               MOVE 'RECS wrong' TO WS-MSG
               GO TO LOAD-FILE-EXIT.
           PERFORM SHIFT-MAYBE.
           GO TO LF-GETARGS.

       LF-GA-X.
           MOVE 'unknown VGET argument' TO WS-MSG
           GO TO LOAD-FILE-EXIT.

       LF-STARTBR.
           MOVE WS-ITEM TO WS-SAVE-ITEM.
           MOVE +0 TO WS-SUB, WS-SUB2.
      * presume ksds
           MOVE +0 TO WS-FILE-TYPE. MOVE +0 TO WS-RID.
           EXEC CICS STARTBR FILE(WS-FILE)
             RIDFLD(WS-RID) KEYLENGTH(1) GENERIC GTEQ
             NOHANDLE
           END-EXEC.
           IF EIBRESP = DFHRESP(NORMAL)  THEN GO TO LOAD-FILE1.
           IF EIBRESP = DFHRESP(DSIDERR) THEN
              MOVE 'FILE not found' TO WS-MSG
              GO TO LOAD-FILE2.
           IF EIBRESP NOT = DFHRESP(INVREQ) AND
              EIBRESP NOT = DFHRESP(ILLOGIC) THEN
              MOVE 'FILE did not LOAD-1' TO WS-MSG
              GO TO LOAD-FILE2.
      * maybe it's an esds
           EXEC CICS ENDBR FILE(WS-FILE) NOHANDLE END-EXEC.
           MOVE +1 TO WS-FILE-TYPE. MOVE +0 TO WS-RID.
           EXEC CICS STARTBR FILE(WS-FILE) RBA
             RIDFLD(WS-RID)
             NOHANDLE
           END-EXEC.
           IF EIBRESP  = DFHRESP(NORMAL)  THEN GO TO LOAD-FILE1.
      * maybe it's an rrds
           EXEC CICS ENDBR FILE(WS-FILE) NOHANDLE END-EXEC.
           MOVE +2 TO WS-FILE-TYPE. MOVE +1 TO WS-RID.
           EXEC CICS STARTBR FILE(WS-FILE) RRN
             RIDFLD(WS-RID)
             NOHANDLE
           END-EXEC.
           IF EIBRESP  = DFHRESP(NORMAL)  THEN GO TO LOAD-FILE1.
      * some less likely issue apparently...
           MOVE 'FILE did not LOAD-2' TO WS-MSG
           GO TO LOAD-FILE2.
       LOAD-FILE1.
           PERFORM READ-FILE.
           IF EIBRESP = DFHRESP(ENDFILE) THEN
               GO TO LOAD-FILE2.
           IF EIBRESP NOT = DFHRESP(NORMAL)  AND
              EIBRESP NOT = DFHRESP(LENGERR) AND
              EIBRESP NOT = DFHRESP(DUPKEY) THEN
               MOVE 'FILE did not LOAD-3' TO WS-MSG
               GO TO LOAD-FILE2.
           ADD +1 TO WS-SUB.
           IF WS-SUB < WS-FILELOAD-FIRST THEN GO TO LOAD-FILE1.
           PERFORM WRITE-TSQ.
           IF EIBRESP = DFHRESP(NORMAL) THEN
               ADD +1 TO WS-SUB2
               IF WS-SUB2 < WS-FILELOAD-NUM THEN GO TO LOAD-FILE1
               ELSE                              GO TO LOAD-FILE2.
           MOVE 'FILE did not LOAD-4' TO WS-MSG.
       LOAD-FILE2.
           EXEC CICS ENDBR FILE(WS-FILE) NOHANDLE END-EXEC.
           MOVE WS-SAVE-ITEM TO WS-ITEM.
           IF WS-MSG = SPACES THEN MOVE 'Ok' TO WS-MSG.
       LOAD-FILE-EXIT.
           EXIT.

       READ-FILE SECTION.
      * read NEXT file rec, status in eibresp as usual
           MOVE +32700 TO WS-RECSIZE.
           MOVE ALL SPACES TO WS-TEMP-REC.
           IF WS-FILE-TYPE = +0 THEN
             EXEC CICS READNEXT FILE(WS-FILE)
               INTO(WS-TEMP-REC) LENGTH(WS-RECSIZE)
               RIDFLD(WS-RID)
               NOHANDLE
             END-EXEC.
           IF WS-FILE-TYPE = +1 THEN
             EXEC CICS READNEXT FILE(WS-FILE) RBA
               INTO(WS-TEMP-REC) LENGTH(WS-RECSIZE)
               RIDFLD(WS-RID)
               NOHANDLE
             END-EXEC.
           IF WS-FILE-TYPE = +2 THEN
             EXEC CICS READNEXT FILE(WS-FILE) RRN
               INTO(WS-TEMP-REC) LENGTH(WS-RECSIZE)
               RIDFLD(WS-RID)
               NOHANDLE
             END-EXEC.
           MOVE WS-RECSIZE TO WS-ITEMSIZE.
       READ-FILE-EXIT.
           EXIT.

       PRINT-INSTEAD SECTION.
      * print TSQ instead of writing it to TDQ, status in WS-MSG

      * PRINT [ CLASS X LPP NN FIRST NNNN ITEMS NNNN ]      or
      * PUT SYSOUT [ CLASS X LPP NN FIRST NNNN ITEMS NNNN ]

      * save some stuff I might need later...
           MOVE WS-ITEM TO WS-SAVE-ITEM.
           MOVE WS-NUM-COLS TO WS-SAVE-NUM-COLS.
           MOVE WS-COMM-ITEM TO WS-SAVE-COMM-ITEM.
           MOVE WS-COMM-COLUMN TO WS-SAVE-COMM-COLUMN.

      * get optional arguments in any order
       PI-GETARGS.
           IF WS-MAYBE1 = SPACE THEN GO TO PI-ADJUST-LPP.

       PI-GA-1.
           IF WS-MAYBE6 NOT = 'CLASS ' THEN GO TO PI-GA-2.
           PERFORM SHIFT-MAYBE.
           IF WS-MAYBE1 = SPACE THEN
               MOVE 'CLASS wrong' TO WS-MSG
               GO TO PI-DONE.
           MOVE WS-MAYBE1 TO WS-PRINT-CLASS.
           PERFORM SHIFT-MAYBE.
           GO TO PI-GETARGS.

       PI-GA-2.
           IF WS-MAYBE4 NOT = 'LPP ' THEN GO TO PI-GA-3.
           PERFORM SHIFT-MAYBE.
           IF WS-MAYBE1 = '0' THEN
               MOVE MAYBE-NUM TO WS-PRINT-LPP
           ELSE
           PERFORM GET-MAYBE-NUM
           IF MAYBE-NUM > 0 THEN
               MOVE MAYBE-NUM TO WS-PRINT-LPP
           ELSE
               MOVE 'LPP wrong' TO WS-MSG
               GO TO PI-DONE.
           PERFORM SHIFT-MAYBE.
           GO TO PI-GETARGS.

       PI-GA-3.
           IF WS-MAYBE6 NOT = 'FIRST ' THEN GO TO PI-GA-4.
           PERFORM SHIFT-MAYBE.
           PERFORM GET-MAYBE-NUM
           IF MAYBE-NUM > 0 THEN
               MOVE MAYBE-NUM TO WS-PRINT-FIRST
           ELSE
               MOVE 'FIRST wrong' TO WS-MSG
               GO TO PI-DONE.
           PERFORM SHIFT-MAYBE.
           GO TO PI-GETARGS.

        PI-GA-4.
           IF WS-MAYBE6 NOT = 'ITEMS ' THEN GO TO PI-GA-X.
           PERFORM SHIFT-MAYBE.
           PERFORM GET-MAYBE-NUM
           IF MAYBE-NUM > 0 THEN
               MOVE MAYBE-NUM TO WS-PRINT-ITEMS
           ELSE
               MOVE 'ITEMS wrong' TO WS-MSG
               GO TO PI-DONE.
           PERFORM SHIFT-MAYBE.
           GO TO PI-GETARGS.

      * possibly add NODE, USERID, COLS overrides here...

       PI-GA-X.
           MOVE 'unknown PRINT argument' TO WS-MSG
           GO TO PI-DONE.

      * adjust LPP to reflect header, trailers, and one line group
      * LPP is lines per page, LPP2 is max line to start new group
       PI-ADJUST-LPP.
           MOVE WS-PRINT-LPP TO WS-PRINT-LPP2.
      *    SUBTRACT +2 FROM WS-PRINT-LPP2. already accounted for...
           SUBTRACT +1 FROM WS-PRINT-LPP2.
           SUBTRACT +2 FROM WS-PRINT-LPP2.
           IF WS-COMM-RULER NOT < 0 THEN
               SUBTRACT +1 FROM WS-PRINT-LPP2.
           IF WS-COMM-HEX NOT < 0 THEN
               SUBTRACT +2 FROM WS-PRINT-LPP2.
           IF WS-PRINT-LPP2 < 1 THEN
               MOVE 'LPP is to small' TO WS-MSG
               GO TO PI-DONE.

      * set first item number, listing offset
           COMPUTE WS-NUM-COLS = WS-PRINT-COLS - 6.
           MOVE WS-PRINT-FIRST TO WS-COMM-ITEM.

      * setup the header
       PI-SETHDR.
           MOVE WS-COMM-QUEUE TO WS-PRTHDR-QUEUE.
           EXEC CICS ASSIGN USERID(WS-PRTHDR-USER) END-EXEC.
           MOVE EIBTRMID TO WS-PRTHDR-TERM.
           EXEC CICS ASKTIME ABSTIME(WS-PRINT-ABSTIME) END-EXEC.
           EXEC CICS FORMATTIME ABSTIME(WS-PRINT-ABSTIME)
             TIME(WS-PRTHDR-TIME) TIMESEP(':')
           END-EXEC.
           EXEC CICS FORMATTIME ABSTIME(WS-PRINT-ABSTIME)
             MMDDYY(WS-PRTHDR-DATE) DATESEP('/')
           END-EXEC.

      * open the report
           EXEC CICS SPOOLOPEN OUTPUT
                 TOKEN(WS-PRINT-TOKEN)
                 CLASS(WS-PRINT-CLASS)
                 USERID(WS-PRINT-USERID)
                 NODE(WS-PRINT-NODE)
                 NOHANDLE
           END-EXEC.
           IF EIBRESP NOT = DFHRESP(NORMAL) THEN
               MOVE 'SYSOUT did not open!' TO WS-MSG
               GO TO PI-DONE.
           MOVE 1 TO WS-ITEM, WS-LINE-SUB, WS-PRINT-PAGENUM.

      * read/print lines
       PI-1.
           MOVE +1 TO WS-COMM-COLUMN.
           PERFORM READ-TSQ.
           IF EIBRESP = DFHRESP(NORMAL)  THEN GO TO PI-1B.
           IF EIBRESP = DFHRESP(ITEMERR) AND WS-LINE-SUB > 1 THEN
               PERFORM PI-TRAILER
               GO TO PI-2.
           IF EIBRESP = DFHRESP(ITEMERR) THEN GO TO PI-2.
           MOVE 'Error reading TSQ' TO WS-MSG.
           GO TO PI-2.

      * check for skipping some items
       PI-1B.
           IF WS-ITEM < WS-PRINT-FIRST THEN GO TO PI-1D.

      * see if there is enough space on the page to start next group
       PI-1B2.
           IF WS-LINE-SUB NOT < WS-PRINT-LPP2 THEN
               PERFORM PI-TRAILER.

      * see if it's time to do another header
           IF WS-LINE-SUB = 1 THEN PERFORM PI-HEADER.

      * print detail line(s)
           PERFORM VHEX.

      * only first line group of item gets item number
           IF WS-COMM-COLUMN = +1 THEN
               MOVE WS-ITEM  TO WS-VHEX1-CNNN.

           MOVE WS-VHEX1 TO WS-PRT-LINE.
           PERFORM PI-LINE.

           IF WS-COMM-RULER > 0 THEN
               PERFORM MAKE-RULER
               MOVE WS-COMM-COLUMN TO WS-RULER-CNNN
               MOVE WS-VHEX-RULER TO WS-PRT-LINE
               PERFORM PI-LINE.

           IF WS-COMM-HEX < 0 THEN GO TO PI-1C.

           MOVE WS-VHEX2 TO WS-PRT-LINE.
           PERFORM PI-LINE.

           MOVE WS-VHEX3 TO WS-PRT-LINE.
           PERFORM PI-LINE.

       PI-1C.
           MOVE SPACES TO WS-PRT-LINE.
           PERFORM PI-LINE.

      * check to see if more line groups for this item
           ADD WS-NUM-COLS TO WS-COMM-COLUMN.
           IF WS-COMM-COLUMN NOT >  WS-ITEMSIZE THEN GO TO PI-1B2.

      * increment item and decide if time to quit
       PI-1D.
           ADD 1 TO WS-ITEM.
           SUBTRACT WS-PRINT-FIRST FROM WS-ITEM GIVING WS-SUB.
           IF WS-SUB NOT >  WS-PRINT-ITEMS THEN GO TO PI-1.
           IF WS-LINE-SUB > 1 THEN PERFORM PI-TRAILER.
           GO TO PI-2.

      * here to print a header
       PI-HEADER.
           MOVE WS-PRINT-PAGENUM TO WS-PRTHDR-PAGE.
           ADD 1 TO WS-PRINT-PAGENUM.
           MOVE WS-PRINT-HEADER TO WS-PRINT-LINE.
           PERFORM PI-LINE.
      * following also takes care of spacing ws-print-line CC...
           PERFORM PI-BLANK.
           MOVE 3 TO WS-LINE-SUB.

      * here to print a trailer at bottom of page
       PI-TRAILER.
           PERFORM PI-BLANK
               UNTIL WS-LINE-SUB NOT < WS-PRINT-LPP.
           MOVE WS-PRINT-FOOTER TO WS-PRINT-LINE.
           PERFORM PI-LINE.
           MOVE 1 TO WS-LINE-SUB.

      * here to send a blank line
       PI-BLANK.
           MOVE SPACES TO WS-PRINT-LINE.
           PERFORM PI-LINE.

      * here to send output to JES
       PI-LINE.
           EXEC CICS SPOOLWRITE
               TOKEN(WS-PRINT-TOKEN)
               FROM(WS-PRINT-LINE)
               NOHANDLE
           END-EXEC.
           IF EIBRESP NOT = DFHRESP(NORMAL) THEN
               GO TO PI-ERROR.
           ADD +1 TO WS-LINE-SUB.

      * here for all the SPOOLWRITE failures
       PI-ERROR.
           IF WS-MSG = SPACES THEN
               MOVE 'SPOOLWRITE failed!' TO WS-MSG.

      * here to close the report
       PI-2.
           EXEC CICS SPOOLCLOSE
                 TOKEN(WS-PRINT-TOKEN)
                 NOHANDLE
           END-EXEC.
           IF EIBRESP NOT = DFHRESP(NORMAL) THEN
               IF WS-MSG = SPACES THEN
                   MOVE 'SYSOUT did not close!' TO WS-MSG.

           IF WS-MSG = SPACES THEN MOVE 'Ok' TO WS-MSG.

      * restore saved stuff
       PI-DONE.
           MOVE WS-SAVE-ITEM TO WS-ITEM.
           MOVE WS-SAVE-NUM-COLS TO WS-NUM-COLS.
           MOVE WS-SAVE-COMM-ITEM TO WS-COMM-ITEM.
           MOVE WS-SAVE-COMM-COLUMN TO WS-COMM-COLUMN.

       PRINT-INSTEAD-EXIT.
           EXIT.

       ADJUST-ITEM SECTION.
           IF WS-COMM-VALID-Q = 0 THEN
               MOVE 0 TO WS-COMM-ITEM
               GO TO ADJUST-ITEM-EXIT.
           IF WS-COMM-ITEM < 1 THEN
               MOVE 1 TO WS-COMM-ITEM
               GO TO ADJUST-ITEM-EXIT.
           IF WS-COMM-ITEM > WS-COMM-NUMITEMS THEN
               MOVE WS-COMM-NUMITEMS TO WS-COMM-ITEM.
           COMPUTE WS-SUB = WS-COMM-NUMITEMS - WS-NUMITEMS.
           IF WS-SUB < 0 THEN MOVE 0 TO WS-SUB.
           IF WS-COMM-ITEM > WS-SUB THEN
               MOVE WS-SUB TO WS-COMM-ITEM
               ADD 1 TO WS-COMM-ITEM.
       ADJUST-ITEM-EXIT.
           EXIT.

       ADJUST-COLUMN SECTION.
           IF WS-COMM-VALID-Q = 0 THEN
               MOVE 0 TO WS-COMM-COLUMN
               GO TO ADJUST-COLUMN-EXIT.
           IF WS-COMM-COLUMN < 1 THEN
               MOVE 1 TO WS-COMM-COLUMN
               GO TO ADJUST-COLUMN-EXIT.
           COMPUTE WS-SUB = WS-COMM-ITEMSIZE - WS-NUM-COLS.
           IF WS-SUB < 0 THEN MOVE 0 TO WS-SUB.
           IF WS-COMM-COLUMN > WS-SUB THEN
               MOVE WS-SUB TO WS-COMM-COLUMN
               ADD 1 TO WS-COMM-COLUMN.
       ADJUST-COLUMN-EXIT.
           EXIT.

       ADJUST-SCREENSIZE SECTION.
           EXEC CICS ASSIGN DEFSCRNHT(WS-DEFSCRNHT) END-EXEC.
           EXEC CICS ASSIGN DEFSCRNWD(WS-DEFSCRNWD) END-EXEC.
           MOVE WS-DEFSCRNHT TO WS-SCRNHT.
           MOVE WS-DEFSCRNWD TO WS-SCRNWD.
           EXEC CICS ASSIGN ALTSCRNHT(WS-ALTSCRNHT) END-EXEC.
           EXEC CICS ASSIGN ALTSCRNWD(WS-ALTSCRNWD) END-EXEC.
      * standard (mod 2), 24x80
      * primary select by default, but ensure it's OK
           IF WS-DEFSCRNWD NOT = 80 OR WS-DEFSCRNHT NOT = 24 THEN
               EXEC CICS ABEND ABCODE('BADS') END-EXEC.
<NOKICKS>
      * if twaleng = 0 that means always use primary screen...
      * 'cause the profile doesn't have scrnsize(alternate) ??
           EXEC CICS ASSIGN TWALENG(WS-TWALENG) END-EXEC.
           IF WS-TWALENG = 0 THEN GO TO ADJUST-SCREENSIZE-EXIT.
      * otherwise
</NOKICKS>
      * select largest alternate that matches width (if any)
           IF WS-ALTSCRNWD = 80  AND WS-ALTSCRNHT NOT < 32 THEN
      * mod 3, 32x80
               MOVE 27  TO WS-NUM-LINES
               MOVE 72  TO WS-NUM-COLS
               MOVE WS-ALTSCRNHT TO WS-SCRNHT
               MOVE WS-ALTSCRNWD TO WS-SCRNWD
               MOVE +1 TO WS-WHICHMAP.
           IF WS-ALTSCRNWD = 80  AND WS-ALTSCRNHT NOT < 43 THEN
      * mod 4, 43x80
               MOVE 38  TO WS-NUM-LINES
               MOVE 72  TO WS-NUM-COLS
               MOVE WS-ALTSCRNHT TO WS-SCRNHT
               MOVE WS-ALTSCRNWD TO WS-SCRNWD
               MOVE +2 TO WS-WHICHMAP.
           IF WS-ALTSCRNWD = 87  AND WS-ALTSCRNHT NOT < 32 THEN
      * 'mecaff' custom, 32x87
               MOVE 27  TO WS-NUM-LINES
               MOVE 79  TO WS-NUM-COLS
               MOVE WS-ALTSCRNHT TO WS-SCRNHT
               MOVE WS-ALTSCRNWD TO WS-SCRNWD
               MOVE +3 TO WS-WHICHMAP.
           IF WS-ALTSCRNWD = 132 AND WS-ALTSCRNHT NOT < 27 THEN
      * mod 5, 27x132
               MOVE 22  TO WS-NUM-LINES
               MOVE 124 TO WS-NUM-COLS
               MOVE WS-ALTSCRNHT TO WS-SCRNHT
               MOVE WS-ALTSCRNWD TO WS-SCRNWD
               MOVE +4  TO WS-WHICHMAP.
           IF WS-ALTSCRNWD = 160 AND WS-ALTSCRNHT NOT < 62 THEN
      * 3290 (aka ISPF max), 62x160
               MOVE 57  TO WS-NUM-LINES
               MOVE 152 TO WS-NUM-COLS
               MOVE WS-ALTSCRNHT TO WS-SCRNHT
               MOVE WS-ALTSCRNWD TO WS-SCRNWD
               MOVE +5  TO WS-WHICHMAP.
       ADJUST-SCREENSIZE-EXIT.
           EXIT.

       ADJUST-SCREENITEMS SECTION.
      * called after comm area moved to working storage
      * = and when a new queue is opened
      * = and when item number is changed (might be at top)
      * = and when hex/char is toggled
           MOVE WS-NUM-LINES TO WS-NUMITEMS.
      * leave room for top/bottom rulers
           IF WS-COMM-RULER > 0 THEN SUBTRACT 2 FROM WS-NUMITEMS.
      * maybe leave room for 'top of queue' line
           IF WS-COMM-ITEM = 1 THEN SUBTRACT 1 FROM WS-NUMITEMS.
      * adjust for lines/item based on char or vhex display
           IF WS-COMM-HEX > 0 THEN DIVIDE 3 INTO WS-NUMITEMS.
      * final issue is whether a 'bottom of queue' line will fit,
      * and that is resolved as lines are moved to screen.
       ADJUST-SCREENITEMS-EXIT.
           EXIT.

       SHIFT-MAYBE SECTION.
      * shift 0-50 chars of MAYBE left to make 1st char not = space
            IF WS-MAYBE1 NOT = ' ' THEN PERFORM SPACE-MAYBE.
            MOVE 0 TO MAYBE-SUB.
       SM-1.
            IF WS-MAYBE1 = ' ' THEN
                ADD 1 TO MAYBE-SUB
                MOVE WS-MAYBER TO MAYBE
                IF MAYBE-SUB < 50 THEN GO TO SM-1.
       SHIFT-MAYBE-EXIT.
           EXIT.

       SPACE-MAYBE SECTION.
      * space fill up to 36 leading chars of MAYBE
            MOVE 0 TO MAYBE-SUB.
       SP-1.
            IF WS-MAYBE1 NOT = ' ' THEN
                MOVE ' ' TO WS-MAYBE1
                ADD 1 TO MAYBE-SUB
                MOVE WS-MAYBER TO MAYBE
                IF MAYBE-SUB < 36 THEN GO TO SP-1.
       SPACE-MAYBE-EXIT.
           EXIT.

       MOVE-FILE SECTION.
      * move up to first space from maybe to ws-file
            MOVE 1 TO MAYBE-SUB.
       MF-1.
            IF WS-MAYBEX (MAYBE-SUB) = ' ' THEN GO TO MF-2.
            ADD +1 TO MAYBE-SUB.
            IF MAYBE-SUB > 7 THEN GO TO MF-2.
            GO TO MF-1.
       MF-2.
            IF MAYBE-SUB = 1 THEN MOVE WS-MAYBE1 TO WS-FILE
            ELSE
            IF MAYBE-SUB = 2 THEN MOVE WS-MAYBE2 TO WS-FILE
            ELSE
            IF MAYBE-SUB = 3 THEN MOVE WS-MAYBE3 TO WS-FILE
            ELSE
            IF MAYBE-SUB = 4 THEN MOVE WS-MAYBE4 TO WS-FILE
            ELSE
            IF MAYBE-SUB = 5 THEN MOVE WS-MAYBE5 TO WS-FILE
            ELSE
            IF MAYBE-SUB = 6 THEN MOVE WS-MAYBE6 TO WS-FILE
            ELSE
            IF MAYBE-SUB = 7 THEN MOVE WS-MAYBE7 TO WS-FILE
            ELSE
            MOVE WS-MAYBE8 TO WS-FILE.
       MOVE-FILE-EXIT.
           EXIT.

       MOVE-TDQ SECTION.
      * move up to first space from maybe to ws-td-queue
            MOVE 1 TO MAYBE-SUB.
       MT-1.
            IF WS-MAYBEX (MAYBE-SUB) = ' ' THEN GO TO MT-2.
            ADD +1 TO MAYBE-SUB.
            IF MAYBE-SUB > 3 THEN GO TO MT-2.
            GO TO MT-1.
       MT-2.
            IF MAYBE-SUB = 1 THEN MOVE WS-MAYBE1 TO WS-TD-QUEUE
            ELSE
            IF MAYBE-SUB = 2 THEN MOVE WS-MAYBE2 TO WS-TD-QUEUE
            ELSE
            IF MAYBE-SUB = 3 THEN MOVE WS-MAYBE3 TO WS-TD-QUEUE
            ELSE
            MOVE WS-MAYBE4 TO WS-TD-QUEUE.
       MOVE-TDQ-EXIT.
           EXIT.

       GET-MAYBE-NUM SECTION.
      * obtain MAYBE-NUM from the first 1-5 chars of MAYBE
      * zero if bad...
            MOVE 0 TO MAYBE-SUB, MAYBE-NUM.
       GMN-1.
            IF WS-MAYBE1 = ' ' THEN GO TO GET-MAYBE-NUM-EXIT.
            IF WS-MAYBE1 NOT NUMERIC THEN
               MOVE +0 TO MAYBE-NUM
               GO TO GET-MAYBE-NUM-EXIT.
            COMPUTE MAYBE-NUM = 10 * MAYBE-NUM + WS-MAYBE1N.
            ADD 1 TO MAYBE-SUB
            MOVE WS-MAYBER TO MAYBE
            IF MAYBE-SUB < 6 THEN GO TO GMN-1.
            MOVE +0 TO MAYBE-NUM.
       GET-MAYBE-NUM-EXIT.
           EXIT.

       GET-QUEUE-HEX SECTION.
      * Turn possibly hex queue name in WS-COMM-QUEUE into chars
      * in WS-Q. Hex is considered right padded with all spaces.
      * NOTE that queue names all spaces and X'' both valid.
           MOVE WS-COMM-QUEUE TO WS-HW-HEX-IN.
           PERFORM GET-HEX.
           MOVE WS-HW-CHAR-OUT TO WS-Q.
       GET-QUEUE-HEX-EXIT.
           EXIT.

       GET-HEX SECTION.
      * Turn possible hex in WS-HW-HEX-IN into chars in WS-HW-CHAR-OUT.
      * Hex is considered right padded with all spaces
      * on exit status negative for not hex
           MOVE WS-HW-HEX-IN TO WS-HW-CHAR-OUT, WS-HW.
           MOVE -1 TO WS-HW-STATUS.
           IF WS-HW1 NOT = 'X'   THEN GO TO GET-HEX-EXIT.
           IF WS-HW2 NOT = QUOTE THEN GO TO GET-HEX-EXIT.
           MOVE LOW-VALUES TO WS-HW-CHAR-OUT.
           MOVE +0 TO WS-HW-STATUS.
           MOVE WS-HW3R TO WS-HW.
      * make trailing quote a blank and count hex digits
<NCB2>
           TRANSFORM WS-HW FROM QUOTE TO SPACE.
           EXAMINE WS-HW TALLYING UNTIL FIRST SPACE.
</NCB2>
<CB2>
           INSPECT WS-HW CONVERTING QUOTE TO SPACE.
           MOVE ZERO TO TALLY.
           INSPECT WS-HW TALLYING TALLY FOR CHARACTERS BEFORE SPACE.
</CB2>
      * if count odd add leading zero
           MOVE TALLY TO WS-SUB3.
           DIVIDE TALLY BY 2 GIVING WS-SUB REMAINDER WS-SUB2.
           IF WS-SUB2 > 0 THEN
               PERFORM GH-3
                   VARYING WS-SUB FROM  +32 BY -1
                   UNTIL   WS-SUB = +1
               MOVE '0' TO WS-HWCHAR (1)
               ADD +1 TO WS-SUB3.
      * recover count and use to space pad
           ADD +1 WS-SUB3 GIVING WS-SUB.
           PERFORM GH-4 UNTIL WS-SUB NOT < +32.
           MOVE SPACES TO WS-HW33.
           MOVE +0 TO WS-SUB, WS-SUB2, WS-HW-LOW, WS-HW-DIGIT.
       GH-1.
      * loop converting hex digits
           IF WS-HW1 = ' ' THEN GO TO GH-5.
           IF WS-HW1 < 'A' THEN GO TO GH-X.
           IF WS-HW1 > '9' THEN GO TO GH-X.
           IF WS-HW1 > 'F' AND WS-HW1 < '0' THEN GO TO GH-X.
           MOVE WS-HW1 TO WS-HW-DIGITX.
           ADD -240 TO WS-HW-DIGIT.
           IF WS-HW-DIGIT < 0 THEN ADD +57 TO WS-HW-DIGIT.
           IF WS-SUB2 = 0 THEN
               MOVE WS-HW-DIGIT TO WS-HW-LOW
               ADD +1 TO WS-SUB2
           ELSE
               COMPUTE WS-HW-LOW = 16 * WS-HW-LOW + WS-HW-DIGIT
               PERFORM GH-2
               MOVE +0 TO WS-SUB2.
           ADD +1 TO WS-SUB.
           MOVE WS-HW2R TO WS-HW.
           IF WS-SUB < 33 THEN GO TO GH-1.
       GH-X.
      * here when hex conversion fails
           MOVE WS-HW-HEX-IN TO WS-HW-CHAR-OUT.
           MOVE -1 TO WS-HW-STATUS.
           GO TO GET-HEX-EXIT.
       GH-2.
      * 'shift' ws-q LEFT and add new char
           MOVE WS-HW-CHAR-OUT-REST TO WS-HW-CHAR-OUT.
           MOVE WS-HW-LOW TO WS-HW-DIGIT.
           MOVE WS-HW-DIGITX TO WS-HW-CHAR-OUT-16.
       GH-3.
      * shift ws-hw right to prepend a leading zero
           ADD -1 WS-SUB GIVING WS-SUB2.
           MOVE WS-HWCHAR (WS-SUB2) TO WS-HWCHAR (WS-SUB).
       GH-4.
      * pad ws-hw with hex spaces
           MOVE '4' TO WS-HWCHAR (WS-SUB).
           ADD   +1 TO WS-SUB.
           MOVE '0' TO WS-HWCHAR (WS-SUB).
           ADD   +1 TO WS-SUB.
       GH-5.
      * 'shift' in last digit if there is one
           IF WS-SUB2 > 0 THEN PERFORM GH-2.
       GET-HEX-EXIT.
           EXIT.

       ANALYZE-CURSOR SECTION.
      * convert cursor into
      *   line (item) number in WS-SUB, column (offset) in WS-SUB2
      *
      * SOME KNOWN 'EDGE' CASES WHERE THIS DOESN'T WORK QUITE RIGHT,
      * SUCH AS CURSOR ON **BOTTOM** OR BOTTOM RULER LINE OF HEX
      * DISPLAY, BUT THOSE SEEM ONLY A VERY MINOR GUI ISSUE SO
      *         !! I'M NOT BOTHERING TO FIX THEM !!
      *
           MOVE EIBCPOSN TO WS-SUB.
           DIVIDE WS-SUB BY WS-SCRNWD
               GIVING WS-SUB
               REMAINDER WS-SUB2.
           ADD 1 TO WS-SUB, WS-SUB2.
           SUBTRACT 7 FROM WS-SUB2.
           IF WS-SUB2 < 1 THEN
               MOVE 0 TO WS-SUB, WS-SUB2
               GO TO ANALYZE-CURSOR-EXIT.
      * sub2 good at this point, need to adjust line to item
           SUBTRACT 2 FROM WS-SUB.
           IF WS-SUB > WS-NUM-LINES THEN
               MOVE 0 TO WS-SUB, WS-SUB2
               GO TO ANALYZE-CURSOR-EXIT.
           IF WS-COMM-RULER > 0 THEN SUBTRACT 1 FROM WS-SUB.
           IF WS-COMM-ITEM = 1  THEN SUBTRACT 1 FROM WS-SUB.
           IF WS-SUB < 1 THEN
               MOVE 0 TO WS-SUB, WS-SUB2
               GO TO ANALYZE-CURSOR-EXIT.
           IF WS-COMM-HEX > 0   THEN
               SUBTRACT 1 FROM WS-SUB
               DIVIDE 3 INTO WS-SUB
               ADD 1 TO WS-SUB.
           COMPUTE WS-SUB = WS-SUB + WS-COMM-ITEM - 1.
      * sub good at this point, need to ensure not to big!
           IF WS-SUB > WS-COMM-NUMITEMS THEN
               MOVE 0 TO WS-SUB, WS-SUB2.
       ANALYZE-CURSOR-EXIT.
           EXIT.
/*
//LKED.SYSLMOD DD DSN=K.S.V1R5M0.KIKRPL,DISP=SHR
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKCOBGL)
 ENTRY KEBRPGM
 NAME  KEBRPGM(R)
/*
//




//PRINT   EXEC PGM=IDCAMS,REGION=1024K
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 PRINT INDATASET(K.U.V1R5M0.SDB)
/*
//
