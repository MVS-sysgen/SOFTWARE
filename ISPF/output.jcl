//ISPFXMIT JOB (TSO),
//             'Unload/XMIT ISPF',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,PASSWORD=SYS1
//* ----- CLEAN UP -----
//CLEANUP EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE MVP.STAGING SCRATCH PURGE
  DELETE MVP.STAGING.DOC SCRATCH PURGE
  DELETE MVP.STAGING.LLIB SCRATCH PURGE
  DELETE MVP.STAGING.PLIB SCRATCH PURGE
  DELETE MVP.STAGING.RFEPLIB SCRATCH PURGE
  DELETE MVP.STAGING.MLIB SCRATCH PURGE
  SET MAXCC=0
  SET LASTCC=0
//*
//* Add MVP.STAGING
//*
//SYS2EXEC EXEC PGM=IEFBR14
//STAGING  DD DSN=MVP.STAGING,DISP=(,CATLG,DELETE),
//            UNIT=SYSDA,VOL=SER=PUB001,SPACE=(TRK,(50,50,10)),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=800)
//LLIB     DD DSN=MVP.STAGING.LLIB,DISP=(,CATLG),
//         VOL=SER=PUB001,UNIT=SYSDA,SPACE=(CYL,(2,0,20),RLSE)
//DOC      DD DSN=MVP.STAGING.DOC,DISP=(,CATLG),
//         VOL=SER=PUB001,UNIT=SYSDA,SPACE=(CYL,(2,0,20),RLSE)
//MLIB     DD DSN=MVP.STAGING.MLIB,DISP=(,CATLG),
//         VOL=SER=PUB001,UNIT=SYSDA,SPACE=(CYL,(2,0,20),RLSE)
//PLIB     DD DSN=MVP.STAGING.PLIB,DISP=(,CATLG),
//         VOL=SER=PUB001,UNIT=SYSDA,SPACE=(CYL,(2,0,20),RLSE)
//RFEPLIB  DD DSN=MVP.STAGING.RFEPLIB,DISP=(,CATLG),
//         VOL=SER=PUB001,UNIT=SYSDA,SPACE=(CYL,(2,0,20),RLSE)
//*
//* Create temp dataset for IEBCOPY control statements
//*
//TEMPFILE EXEC PGM=IEBGENER
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//* :....1....:....2....:....3....:....4....:....5....:....6....:....7.
//SYSUT1   DD  *
DOIT  	   COPY OUTDD=SYSUT2
                INDD=((SYSUT1,R))
/*
//SYSUT2   DD  DSN=&&CONTROL,UNIT=SYSDA,SPACE=(CYL,1),
//             DISP=(NEW,CATLG,DELETE)
//*
//* Unload neccesary files
//*
//LOAD     PROC INDSN=LLIB,OUTDSN=LLIB,LABEL=1
//STEP1    EXEC PGM=IEBCOPY
//SYSPRINT DD   SYSOUT=*
//SYSUT1   DD   DSN=ISP.V2R2M0.&INDSN..UNLOAD,DISP=(OLD,KEEP),
//         VOL=(PRIVATE,RETAIN,SER=ISP220),UNIT=TAPE,
//         LABEL=(&LABEL,SL,,IN)
//SYSUT2   DD   DSN=MVP.STAGING.&OUTDSN,DISP=SHR
//SYSIN    DD   DSN=&&CONTROL,DISP=SHR
//         PEND
//* *******************************************************
//DOC      EXEC LOAD,INDSN=DOC,OUTDSN=DOC,LABEL=2
//LLIB     EXEC LOAD,INDSN=LLIB,OUTDSN=LLIB,LABEL=4
//MLIB     EXEC LOAD,INDSN=MLIB,OUTDSN=MLIB,LABEL=5
//PLIB     EXEC LOAD,INDSN=PLIB,OUTDSN=PLIB,LABEL=6
//OPTMLIB  EXEC LOAD,INDSN=OPTMLIB,OUTDSN=MLIB,LABEL=12
//OPTPLIB  EXEC LOAD,INDSN=OPTPLIB,OUTDSN=PLIB,LABEL=13
//*INSTALL  EXEC LOAD,DSN=INSTALL,LABEL=1
//*CLIB     EXEC LOAD,DSN=CLIB,LABEL=3
//*SLIB     EXEC LOAD,DSN=SLIB,LABEL=7
//*TLIB     EXEC LOAD,DSN=TLIB,LABEL=8
//*OPTDOC   EXEC LOAD,INDSN=OPTDOC,LABEL=9
//*OPTCLIB  EXEC LOAD,INDSN=OPTCLIB,LABEL=10
//*OPTLLIB  EXEC LOAD,INDSN=OPTLLIB,LABEL=11
//*OPTSLIB  EXEC LOAD,INDSN=OPTSLIB,LABEL=14
//* *******************************************************
//*
//* Move the files to MVP.STAGING(MEMBER) USING XMIT
//*
//XMIT     PROC DSN=LLIB
//XMITLLIB EXEC PGM=XMIT370
//STEPLIB  DD DSN=SYSC.LINKLIB,DISP=SHR
//XMITLOG  DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//SYSUT1   DD DSN=MVP.STAGING.&DSN,DISP=SHR
//SYSUT2   DD DSN=&&SYSUT2,UNIT=SYSDA,
//         SPACE=(TRK,(255,255)),
//         DISP=(NEW,DELETE,DELETE)
//XMITOUT  DD DSN=MVP.STAGING(&DSN),DISP=SHR
//         PEND
//* *******************************************************
//DOC      EXEC XMIT,DSN=DOC
//LLIB     EXEC XMIT,DSN=LLIB
//MLIB     EXEC XMIT,DSN=MLIB
//PLIB     EXEC XMIT,DSN=PLIB
//* *******************************************************
//*
//* The following loads the RFE PLIBS run the script
//* rfeplib.sh which will append those files here
//*
//* EVERTHING BELOW THIS NEXT LINE IS AUTOMATED DO NOT TOUCH
//*
//* ADD RFE PANELS TO MVP.STAGING.RFEPLIB
//* AND XMIT TO MVP.STAGING(RFEPLIB)
//*
//RFEPLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=MVP.STAGING.RFEPLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=REV@PRIM
)ATTR DEFAULT(%+_)
    # TYPE(AB)    FORMAT(MIX)
    % TYPE(TEXT)  INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT)  INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT)  INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    | TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    " TYPE(ABSL) GE(ON)
)ABC DESC('RefList') MNEM(1)
PDC DESC('Current Data Set List &ZDSCURT.') MNEM(1) ACC(CTRL+ALT+P)
 ACTION RUN(ISRRLIST) PARM('PL1')
PDC DESC('Current Library List &ZDSCURLT.') MNEM(2) ACC(CTRL+SHIFT+P)
 ACTION RUN(ISRRLIST) PARM('LL1')
PDC DESC('List of Personal Data Set Lists') MNEM(1) PDSEP(ON) ACC(CTRL+ALT+O)
 ACTION RUN(ISRRLIST) PARM('PL2')
PDC DESC('List of Personal Library Lists') MNEM(2) ACC(CTRL+SHIFT+O)
 ACTION RUN(ISRRLIST) PARM('LL2')
)ABCINIT
.ZVARS=REFLIST
      VGET (ZCURTB ZCURLTB) PROFILE
      IF (&ZCURTB = &Z) &ZDSCURT = &Z
      ELSE &ZDSCURT= '(&ZCURTB)'
      IF (&ZCURLTB = &Z) &ZDSCURLT = &Z
      ELSE &ZDSCURLT= '(&ZCURLTB)'
)ABC DESC('RefMode') MNEM(2)
PDC DESC('List Execute') UNAVAIL(ZRM1) MNEM(1) ACTION RUN(ISRRLIST) PARM('BEX')
PDC DESC('List Retrieve') UNAVAIL(ZRM2) MNEM(2) ACTION RUN(ISRRLIST) PARM('BRT')
)ABCINIT
.ZVARS=REFMODE
  VGET (ZBLIST) PROFILE
  IF (&ZBLIST = 'EXECUTE')
    &zrm1 = 1
    &zrm2 = 0
    &refmode = 2
  ELSE
    &zrm1 = 0
    &zrm2 = 1
    &refmode = 1
)ABC DESC('Help') MNEM(1)
PDC PDCTEXT('REVIEW command tutorial')
 ACTION RUN(TUTOR) PARM('REVHB00')
PDC PDCTEXT('REVIEW TSO full-screen help')
 ACTION RUN(TSO) PARM('HEL REVIEW')
PDC PDCTEXT('About...')
 ACTION RUN(TUTOR) PARM('REVLOGO')
PDC PDCTEXT('REVIEW FAQ')
 ACTION RUN(TUTOR) PARM('REVFAQ')
)ABCINIT
.ZVARS=HELP
)BODY EXPAND(\\)
%# RefList# RefMode# Help+
"-------------------------------------------------------------------------------
+\ \¢REVIEW Command Processor\ \
%Command ===>_ZCMD                                                             +
+
%ISPF Library:
+   Project%===>_PRJ1    %
+   Library%===>_LIB1    %
+   Type   %===>_TYP1    %
+   Member %===>_MEM1    %
+
%Other Partitioned, Sequential, VSAM, Unix HFS File, or ddname FILE:
+   Data Set Name  %===>|DSN1                                                  %
+   Volume Serial  %===>_VOL1  +  (If not cataloged)
+   Options        %===>_OPT1                                                  %
+  ¢REVIEW+CP Name %===>_CMD1    +
)INIT
  .CURSOR = DSN1
  .NRET = ON
  IF (&REVPDSN = &Z)
    .CURSOR = MEM1
  IF (&REVPDSN ¬= &Z)
    .CURSOR = DSN1
  .HELP   = REVHB00
  &ZHTOP  = REVHB00
  &MEM1 = &Z
  &DSN1 = &REVPDSN
  &VOL1 = &REVPVOL
  &CMD1 = &REVPCMD
  IF (&CMD1 = &Z)  &CMD1 = 'REVIEW'
)REINIT
  .CURSOR = DSN1
  .NRET = ON
  IF (&DSN1 ¬= &Z)
    &DSN1 = &REVPDSN
    &VOL1 = &REVPVOL
    &MEM1 = &Z
  REFRESH (*)
)PROC
  /* Start NRETRIEV code */
  .NRET = OFF
  IF (&ZVERB = NRETRIEV)
    VGET (ZCURTB,ZCURLTB) PROFILE
    IF (.CURSOR NE DSN1 AND .CURSOR NE VOL1)
      .NRET = LIB
      IF (&ZNRLIB = YES)
        .CURSOR = MEM1
        &PRJ1 = &ZNRPROJ
        &LIB1 = &ZNRGRP1
        &TYP1 = &ZNRTYPE
        &MEM1 = &ZNRMEM
        &DSN1 = &Z
        &VOL1 = &Z
        .MSG = ISRDS013
      ELSE .MSG = ISRDS011
    ELSE
      .NRET = DSN
      IF (&ZNRDS = YES)
        .CURSOR = DSN1
        &DSN1 = &ZNRODSN
        &VOL1 = &ZNRVOL
        .MSG = ISRDS014
      ELSE .MSG = ISRDS012
  /* End NRETRIEV code */

  /* Start RefList code */
  VGET (ZRDSN ZRVOL) SHARED
  IF (&ZRDSN ¬= ' ')
    &DSN1 = &ZRDSN
    VGET (ZREFVOLM) PROFILE
    IF (&ZREFVOLM = 'ON')
      &VOL1 = &ZRVOL
    ELSE                                                  /* OW15849*/
      &VOL1 = &Z                                          /* OW15849*/
    &ZDSVOL = &VOL1
    .CURSOR = DSN1
    &ZRDSN = ' '
    &ZRVOL = ' '
    VPUT (ZRDSN ZRVOL) SHARED
    VPUT (ZDSVOL) SHARED
    VGET (ZBLIST) PROFILE
    IF (&ZBLIST ¬= 'EXECUTE') .MSG = ISRDS003
  VGET (DSALSEL) SHARED
  IF (&DSALSEL ¬= ' ')
    VGET (DSA1,DSA2,DSA6,DSA7) SHARED
    &PRJ1 = &DSA1
    &LIB1 = &DSA2
    &TYP1 = &DSA6
    &MEM1  = &DSA7
    &DSN1 = ' '
    &VOL1 = ' '
    &DSALSEL = ' '
    VPUT (DSALSEL) SHARED
    .CURSOR = MEM1
    VGET (ZBLIST) PROFILE
    IF (&ZBLIST ¬= 'EXECUTE') .MSG = ISRDS003
  /* End RefList code */

  &REVPDSN = &DSN1
  &REVPVOL = &VOL1
  &REVPCMD = &CMD1
  VPUT (PRJ1 LIB1 TYP1) PROFILE
  VPUT (REVPDSN REVPVOL REVPCMD) SHARED

  IF (&DSN1 = &Z)
    VER (&PRJ1,NB,DSNAME)
    VER (&LIB1,NB,DSNAME)
    VER (&TYP1,NB,DSNAME)
    IF (&MEM1 = &Z)
      &OPT2 = 0
    ELSE
      VER (&MEM1,DSNAME,MSG=ISRE090)
      &OPT2 = 1
    IF (&VOL1 ¬= &Z) .MSG=ISRE094

  IF (&DSN1 ¬= &Z)
     &RFC = TRUNC(&DSN1,1)          /* If first character    */
     IF (&RFC = '''')               /*   of DSN is "'" check */
        &RREM = .TRAIL              /*   to see if last "'"  */
        &RREM2 = TRUNC(&RREM,'''')  /*   is missing.         */
        IF (&RREM2 = &RREM)         /* If last "'" missing   */
           &DSN1 = '&DSN1&RFC'      /*   add it to the end.  */
     IF (&VOL1 = &Z)
        &OPT2 = 2
     IF (&VOL1 ¬= &Z)
        &OPT2 = 3
  &ZSEL = TRANS(&OPT2,
                0,'CMD(&CMD1 ''&PRJ1..&LIB1..&TYP1'' &OPT1)'
                1,'CMD(&CMD1 ''&PRJ1..&LIB1..&TYP1(&MEM1)'' &OPT1)'
                2,'CMD(&CMD1 &DSN1 &OPT1)'
                3,'CMD(&CMD1 &DSN1 VOL(&VOL1) &OPT1)'
               ' ',' '
                *,'?' )
)END
./ ADD NAME=REVFAQ
)ATTR
  ! TYPE(TEXT) COLOR(WHITE) HILITE(USCORE)
  { TYPE(NT)
  @ TYPE(ET)
  # TYPE(DT)
)BODY CMD( ) WINDOW(60,3)
{     @The REVIEW FAQ is located at:                      {
{                                                         {
{     !http://www.prycroft6.com.au/REVIEW/revfaq.html+    {
)INIT
  &ZUP = REVFAQ
  &ZWINTTL = 'REVIEW FAQ'
  &ZCMD = ' '
  &CMD = ' '
)END
./ ADD NAME=REVHB00
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    # TYPE(AB)    FORMAT(MIX)
    " TYPE(ABSL) GE(ON)
)ABC DESC('Help') MNEM(1)
PDC PDCTEXT('REVIEW TSO full-screen help')
 ACTION RUN(TSO) PARM('HEL REVIEW')
PDC PDCTEXT('About...')
 ACTION RUN(TUTOR) PARM('REVLOGO')
PDC PDCTEXT('REVIEW FAQ')
 ACTION RUN(TUTOR) PARM('REVFAQ')
)ABCINIT
.ZVARS=HELP
)BODY EXPAND(\\)
\ \# Help
%TUTORIAL+-\-\-¢REVIEW Command Processor+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +
%               ---------------------------------------------
%               |                  REVIEW                   |
%               ---------------------------------------------
+
  ¢REVIEW+allows you to display MVS and Unix files.

   Members of partitioned data sets, sequential data sets, VSAM data sets,
   and Unix files can be displayed, and can be scrolled forward, backward,
   left, or right.

 The following topics are presented in sequence, or may be selected by number:
  %1+- Types of data sets               %7+- Display modes (HEX/ASCII/SMF/EREP)
  %2+- Invoking¢REVIEW+                 %8+- Global subcommands
  %3+- Directory display list           %9+- Browse subcommands
  %4+- Display screen format           %10+- ISPF services (Browse/Edit/View)
  %5+- Scrolling data                  %11+- TSO commands
  %6+-¢REVIEW+profile                  %12+- Ending a¢REVIEW+session

 The following topics will be presented only if selected by number:
 %13+- General¢REVIEW+information      %14+- Detailed¢REVIEW+information
)INIT
&ZHTOP = REVHB00
)PROC
  &ZSEL = TRANS(&ZCMD  1,REVHB01   2,REVHB02   3,REVHB03   4,REVHB04
                       5,REVHB05   6,REVHB06   7,REVHB07   8,REVHB08
                       9,REVHB09  10,REVHB10  11,REVHB11  12,REVHB12
                      13,*REVHBGN 14,*REVHBDT
                         *,'?')
)END
./ ADD NAME=REVHB01
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Types of Datasets+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 ¢REVIEW+can display sequential, partitioned, partitioned-extended,
  VSAM, and Unix HFS (Hierarchical File System) files that have the
  the following characteristics.

      %Record Formats+- fixed, variable, or undefined
                      - blocked or unblocked
                      - standard or spanned
                      - with or without printer control characters

      %Data Lengths+  - 1 to 65535 bytes of data, inclusive

)INIT
)PROC
)END
./ ADD NAME=REVHB02
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    # AREA(SCRL) EXTEND(ON)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Invoking The Command Processor+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +
#SCRLAREA -----------------------------------------------------------------#
)AREA SCRLAREA
+
+       ¢REVIEW+ 'dsname'  UNIT('unit')  VOLUME('volume')  QUICK  DATA
+                       TOP('rel-addr')  SUBSYS('subsys')  XISPMODE
+    or
+       ¢REVIEW+ 'filename'  FILE  DATA  TOP('rel-addr')  XISPMODE
+    or
+       ¢REVIEW+ 'pathname'
+
+%Required+- 'dsname'
+    or      'filename'  FILE
+    or      'pathname'  which must begin with a slash
+    or      no operands for "point and shoot".
+
+%Defaults+- TOP(0)
+            UNIT(SYSALLDA) when VOLUME is specified.
+
+%Aliases +- REV, REVED, REVVSAM
+
+
+
+ %Operands+-
+
+ %'dsname'+or%'dsname(member)'+- The data set to be examined.
+ %'filename'+- The DDNAME allocated to the data set to be examined.
+ %'pathname'+- The path name of an UNIX directory.
+
+  If the first operand begins with a slash ('/') then it is deemed to
+  specify an UNIX directory path, and no other operands are allowed.
+  A specific UNIX file may be specified to directly access the data
+  contained in the file.
+
+  If the first operand does not begin with a slash then it is assumed
+  to be a DSNAME unless it is followed by the keyword 'FILE'.
+
+  Specifying the quoted dsname of 'FORMAT4.DSCB' and a VOLUME
+  requests that the VTOC of that volume be REVIEWed.
+
+  Specifying the file name of PARMLIB when there is no PARMLIB
+  allocated on a OS/390 1.2 or later system requests that the
+  logical PARMLIB service be used to¢REVIEW+the system PARMLIB
+  concatenation.
+
+  If no operands are supplied then¢REVIEW+reads the screen image
+  and extracts the data set name from the part of the screen
+  containing the cursor.  This works in both fullscreen and line
+  modes, but not under Session Manager which updates the screen
+  before¢REVIEW+receives control.  If a data set name is not found
+  then normal TSO prompting is commenced except for a recursive
+ ¢REVIEW+session where a message is displayed.
+
+  A member name is NOT considered part of the data set name for
+  "point and shoot" purposes.
+
+  A UNIX path name cannot be processed by "point and shoot".
+
%FILE     +- This keyword indicates that the first operand is
+            a FILENAME, not a DSNAME.  This is useful for looking
+            at a temporary data set or at concatenated libraries.
+            A member name may be specified in the first operand
+            after the DDNAME if the DDNAME is allocated to a
+            PDS.  This allows you to enter 'REVIEW SYSPROC(X) F'
+            to look at member 'X' in whatever PDS is allocated to
+            DDNAME 'SYSPROC'.
+
+            Note that REVIEWing a concatenated sequential file may
+            cause unexpected behaviour.
+
+            The 'FILE' operand may be abbreviated to 'F'.
+
%VOLUME('volume')+- For uncataloged data sets, the volume serial.
+
+            'VOLUME' may be abbreviated to 'V'.
+
%UNIT('unit')+- For uncataloged data sets, the unit type.
+            This operand is ignored if 'VOLUME' is not specified.
+            If 'VOLUME' is specified the default unit is 'SYSALLDA'.
+            For data sets accessed via the catalog, the unit is
+            determined from the catalog entry.
+
+            'UNIT' may be abbreviated to 'U'.
+
%TOP('rel-addr')+- This specifies a relative address within the
+            data set to be considered as the logical top-of-data.
+            'TOP' performs the same function as the 'NEWTOP'
+            subcommand before the initial display of data.  As with
+            'NEWTOP', 'rel-addr' is a 1 to 6 hexadecimal digit
+            number interpreted as a TTR for disk data sets, or as
+            a BLOCK IDENTIFIER for tape data sets.  When 0 is
+            specified or defaulted to, no special action is taken.
+            This operand is ignored for VSAM and subsystem data sets.
+
+            'TOP' may be abbreviated to 'T'.
+
%TTR('rel-addr')+- Same as TOP('rel-addr').
+
%SUBSYS('subsys')+- For subsystem data sets, this specifies the 1-4
+            character subsystem name.  The subsystem must be active
+            and allow data set allocation for this to be successful.
+            The subsystem data set name specified may include a
+            member name in parentheses if appropriate.
+            This operand is ignored if 'VOLUME' is specified.
+
+            'SUBSYS' may be abbreviated to 'S'.
+
%QUICK    +- This indicates that if an unquoted data set name was
+            specified then the name was fully qualified apart from
+            the prefix (ie. no trailing qualifier has to be added).
+            This saves a search of the catalog to look for trailing
+            qualifiers which is otherwise performed unconditionally
+            unless the 'VOLUME' operand was specified.  This operand
+            is ignored if 'VOLUME' is specified.
+
+            The 'QUICK' operand may be abbreviated to 'Q'.
+
%DATA     +- This operand has several uses which, in general, mean
+            that control data is displayed rather than interpreted.
+            Specifically, this operand has seven (7) different
+            functions depending upon the type of data set being
+            REVIEWed.
+
+            1) For a VSAM component -
+               'DATA' indicates that control interval information
+               and DB2 tablespace structure is not to be interpreted
+               and that physical blocks are to be shown as-is without
+               extracting logical records or rows.
+
+            2) For a VSAM KSDS (Key-Sequenced Data Set) cluster -
+               'DATA' indicates that records are to be presented in
+               RBA (Relative Byte Address) or physical order rather
+               than in key-sequence order.
+
+            3) For a partitioned data set -
+               'DATA' indicates that the PDS directory is to be
+               REVIEWed as a sequential file, thereby precluding
+               access to the contents of members.
+
+            4) For other disk files with fixed length records -
+               'DATA' indicates that direct access logic which can
+               speed up access to different parts of the file will
+               not be used.  This logic is employed by default when
+               RECFM=F, RECFM=FS, or RECFM=FBS unless 'DATA' is
+               specified.  It is also used when RECFM=FB and the
+               VTOC indicates more than 256 tracks of data unless
+               'DATA' is specified.
+               (If this direct access logic is used and the file
+               does not use standard blocking, incorrect line
+               numbers and/or I/O errors could possibly occur.
+               The 'NEWTOP' subcommand (without any operand)
+               can be used from within¢REVIEW+to make¢REVIEW+
+               start behaving as if 'DATA' had been specified.)
+
+            5) For a SUBSYSTEM data set with a member included -
+               'DATA' indicates that a sequential file will be
+               allocated to the specified member only and data from
+               other members will not be accessible.  Use the 'DATA'
+               operand if the subsystem data set has members but the
+               subsystem does not support partitioned access.
+               (Normally, if 'DATA' was not specified then data from
+               the nominated member would initially be displayed,
+               but data from other members could subsequently
+               be displayed by using the 'MEMBER' subcommand.)
+
+            6) For a ZIP file 'DATA' indicates that the ZIP directory
+               will not be formatted, but that normal sequential read
+               and display processing will take place.  Only DASD
+               sequential data sets and UNIX files are checked for
+               ZIP format by REVIEW.
+
+            7) For a PCX (Paintbrush) file 'DATA' indicates that
+               picture data is not to be interpreted, but that normal
+               data display processing will take place.  Without the
+               'DATA' operand¢REVIEW+would attempt to display the
+               picture image contained in 1-bit, 4-bit or 8-bit color
+               single-plane PCX file.  (The 'FORMAT OFF' subcommand
+               can be used from within¢REVIEW+to instruct¢REVIEW+to
+               discard the picture data and therefore no longer show
+               the picture image.  A subsequent 'NEWTOP' subcommand
+               could be used to reactivate the image display.)  PCX
+               files are recognised by data content when the first
+               record is at least 80 bytes long.  The rendering of
+               pictures is never attempted when¢REVIEW+is running as
+               an ISPF application.
+
+            The 'DATA' operand may be abbreviated to 'D'.
+
%XISPMODE+- This specifies that¢REVIEW+
+            1) is not to act as an ISPF application and is therefore
+               to perform terminal I/O and subcommand processing
+               natively; and
+            2) is not to determine terminal capabilities from ISPF
+               variables but is to issue a Read Partition (Query)
+               itself if appropriate.
+
+            This operand will only affect processing in an ISPF
+            environment.
+
+            The second function listed above relates to detecting
+            the graphics capabilities of the TSO terminal.  If you
+            want¢REVIEW+to render graphic images (pictures) in an
+            ISPF environment then the XISPMODE operand is required
+            so that¢REVIEW+will detect that the terminal can handle
+            graphics.  Without this operand,¢REVIEW+determines
+            color, highlighting and graphics escape support from
+            ISPF, does not perform terminal I/O for a Query, and
+            can therefore present non-graphic file data more rapidly.
+
+            The 'XISPMODE' operand may be abbreviated to 'X'.
+
)INIT
)PROC
)END
./ ADD NAME=REVHB03
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Directory Displays+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


  ¢REVIEW+has three (3) different directory displays.

   The following can be selected by name:

    %DATA    +- for a PDS, a data PDSE, and concatenated
                files of any sort of PDS and/or PDSE.
    %OBJECT  +- for an unconcatenated program object PDSE.
    %UNIX    +- for UNIX directories and files in
                hierarchical file structures.

)INIT
)PROC
  &ZSEL = TRANS(&ZCMD  DATA,*REVHP00  OBJECT,*REVHO00  UNIX,*REVHU00
                       *,'?')
)END
./ ADD NAME=REVHB04
)ATTR DEFAULT(%#_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    $ TYPE(TEXT) INTENS(HIGH) COLOR(GREEN)
    @ TYPE(TEXT) INTENS(HIGH) COLOR(RED) HILITE(USCORE)
    # TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL#-\-\-¢REVIEW Display Screen Format#-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             #


   The six areas of the¢REVIEW#display screen are shown below.
   They are:%(1)#Title,%(2)#Line/Column numbers,%(3)#Command,
  %(4)#Scroll amount,%(5)#Ruler,%(6)#Data fields.

        .--------------------------------------------------------------.#
        |                                                              |
%(1)#=> | %AD.HELP(REVIEW) - 37.05 ------------------- Line 1 Col 1 80#| <=%(2)#
%(3)#=> | %Command ==>@                               %Scroll ==>@CSR #| <=%(4)#
%(5)#=> |¢1       10        20        30        40        50        60#|
        |¢+---+----+----+----+----+----+----+----+----+----+----+----+#|
        |$*                    TSO HELP FOR 'REVIEW' RELEASE 37.5   NO#| <=%(6)#
        |$)F Function -                                               #|
        |$  The REVIEW command allows a data set or UNIX entity to be #|
        |$  a 3270 TSO terminal in full screen mode.  Both disk and ta#|
        |$  may be REVIEWed.  If a PDS without a member is specified t#|
        |$  member selection list is displayed.  Load module members w#|
        |$  residence mode of ANY are shown in high intensity or green#|

                               (continued)
)INIT
)PROC
&ZCONT = REVHB04A
)END
./ ADD NAME=REVHB04A
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Display Screen Format+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   The six display screen areas shown on the previous page are:

   (1) -%Title+- identifies the name of the data set (and member).  If
         ISPF statistics are present, the version/mod level is displayed.

   (2) -%Line/Column numbers+- shows the data line and column numbers
         that are being displayed.

   (3) -%Command+- where subcommands are entered.

   (4) -%Scroll amount+- where the scrolling amount is displayed.  You can
         change the amount by overtyping the amount field.

   (5) -%Ruler+- where the ruler header lines are displayed.

   (6) -%Data fields+- where the data is displayed.  Each field extends to
         the full width of the display.
)INIT
)PROC
)END
./ ADD NAME=REVHB05
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Scrolling+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


  ¢REVIEW+allows you to scroll up and down through the data.  If the data is
   too wide to fit on the screen, you can also scroll left and right.

   To scroll, enter one of the six scroll commands (UP, DOWN, LEFT, RIGHT,
   TOP or BOTTOM).  Minus, plus, less than, and greater than signs are aliases
   for UP, DOWN, LEFT, and RIGHT.

   To change the number of lines or columns being scrolled, change the
   scroll amount field.

 The following topics will be presented only if selected by number:
    %1+- Scroll commands
    %2+- Scroll amount
)INIT
)PROC
  &ZSEL = TRANS(&ZCMD  1,*REVHB05A  2,*REVHB05B
                       *,'?')
)END
./ ADD NAME=REVHB05A
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Scroll Commands+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   Use the scroll commands (or the default PF keys) to scroll:

    %UP    +(PF7)  - toward the top of the data
    %DOWN  +(PF8)  - toward the bottom of the data
    %LEFT  +(PF10) - toward the first column of the data
    %RIGHT +(PF11) - toward the last column of the data

   Usually, you can combine scrolling with other actions by entering a
   command and then pressing a scroll PF key (instead of the ENTER key).
   Both the action and the scroll will process.

   If the amount in the scroll amount field is not valid when a scroll command
   is entered, an error message is displayed.  Either correct the scroll
   amount, or take an action other than scrolling.

)INIT
)PROC
)END
./ ADD NAME=REVHB05B
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Scroll Amount+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   The scroll amount is displayed on the terminal screen, following the
   command field.  You can change the scroll amount by typing over the
   scroll amount with a new amount.

   Valid scroll amounts are:

    %PAGE+to scroll by one page.

    %HALF+to scroll by half a page.

    %nnnn+(any number from 1 to 9999) to scroll by the specified
          number of lines or columns.

    %CSR+ to scroll to the position of the cursor within the data (or by
          a page if the cursor is outside the data or is already
          positioned in the top, bottom, left, or right margin).

    %DATA+to scroll by a page minus one line when scrolling up or down
          or by a page minus one column when scrolling left or right.
)INIT
)PROC
)END
./ ADD NAME=REVHB06
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Profile+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   The¢REVIEW+profile is stored as member%REVPROF+in the library
   allocated to ddname ISPPROF.  The DISPLAY and COLOR commands
   update the profile.  The¢REVIEW+user profile contains the data display
   colors, scrolling amount, and the 24 PF Key values (XISPMODE).

)INIT
)PROC
)END
./ ADD NAME=REVHB07
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Display Modes+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   The subcommands listed below are used to control the settings of the
   various modes and controls for the display.

   The following topics are presented in sequence, or may be selected by name:

    %HEX    +- to set HEX mode on/off and to specify a hex display.
    %ASCII  +- to set ASCII mode on/off and to specify an ASCII display.
    %SMF    +- to set SMF mode on/off and to specify a formatted SMF display.
    %EREP   +- to set EREP mode on/off and to specify an formatted EREP display.
    %FORMAT +- to format data based on the data type in the DS or DC statement.

)INIT
)PROC
  &ZSEL = TRANS(&ZCMD  HEX,REVHB07A   ASCII,REVHB07B     SMF,REVHB07C
                      EREP,REVHB07D  FORMAT,REVHB07E
                       *,'?')
)END
./ ADD NAME=REVHB07A
)ATTR DEFAULT(%#_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    $ TYPE(TEXT) INTENS(HIGH) COLOR(GREEN)
    @ TYPE(TEXT) INTENS(HIGH) COLOR(RED) HILITE(USCORE)
    # TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(++)
%TUTORIAL#-+-+-¢REVIEW Hex Display Screen Format#-+-+-%TUTORIAL
%OPTION  ===>_ZCMD                                                             #


   The six areas of the¢REVIEW%Hex#display screen are shown below.
   They are:%(1)#Title,%(2)#Line/Column numbers,%(3)#Command,
  %(4)#Scroll amount,%(5)#Ruler,%(6)#Hex data fields.

        .--------------------------------------------------------------.#
        |                                                              |
%(1)#=> | %AD.HELP(REVIEW) - 37.05 ------------------- Line 1 Col 1 80#| <=%(2)#
%(3)#=> | %Command ==>@                               %Scroll ==>@CSR #| <=%(4)#
%(5)#=> |¢ 1       5        10        15        20        25        30#|
        |¢/\------/\--------/\--------/\--------/\--------/\--------/\#|
        |$5C4040404040404040404040404040404040404040E3E2D640C8C5D3D740#| <=%(6)#
        |$5DC640C6A49583A389969540604040404040404040404040404040404040#|
        |$4040E3888540D9C5E5C9C5E640839694948195844081939396A6A2408140#|
        |$40408140F3F2F7F040E3E2D640A3859994899581934089954086A4939340#|
        |$40409481A840828540D9C5E5C9C5E685844B4040C986408140D7C4E240A6#|
        |$404094859482859940A285938583A3899695409389A2A34089A2408489A2#|
        |$40409985A2898485958385409496848540968640C1D5E84081998540A288#|


)INIT
)PROC
)END
./ ADD NAME=REVHB07B
)ATTR DEFAULT(%#_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    $ TYPE(TEXT) INTENS(HIGH) COLOR(GREEN)
    @ TYPE(TEXT) INTENS(HIGH) COLOR(RED) HILITE(USCORE)
    # TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL#-\-\-¢REVIEW ASCII Display Screen Format#-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             #


   The six areas of the¢REVIEW%ASCII#display screen are shown below.
   They are:%(1)#Title,%(2)#Line/Column numbers,%(3)#Command,
  %(4)#Scroll amount,%(5)#Ruler,%(6)#ASCII data fields.

        .--------------------------------------------------------------.#
        |                                                              |
%(1)#=> | %TRIDJK.README.TXT on WORK15 --------------- Line 1 Col 1 80#| <=%(2)#
%(3)#=> | %Command ==>@                               %Scroll ==>@CSR #| <=%(4)#
%(5)#=> |¢1       10        20        30        40        50        60#|
        |¢+---+----+----+----+----+----+----+----+----+----+----+----+#|
        |$Vista TN3270 For Windows..------------------------....Vista #| <=%(6)#
        |$s a program designed to emulate IBM..standard 3270 series te#|
        |$(TCP) environment..provided by a standard WINSOCK interface.#|
        |$ by:....    Tom Brennan..    523 N. Nora Ave...    West Covi#|
        |$f you need support, enhancements, registration information,.#|
        |$ress your opinion of the product, please..send a note to:...#|
        |$oftware.com....or visit..   ..    www.tombrennansoftware.com#|

)INIT
)PROC
)END
./ ADD NAME=REVHB07C
)ATTR DEFAULT(%#_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    $ TYPE(TEXT) INTENS(HIGH) COLOR(GREEN)
    @ TYPE(TEXT) INTENS(HIGH) COLOR(RED) HILITE(USCORE)
    # TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL#-\-\-¢REVIEW SMF Display Screen Format#-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             #


   The six areas of the¢REVIEW%SMF#display screen are shown below.
   They are:%(1)#Title,%(2)#Line/Column numbers,%(3)#Command,
  %(4)#Scroll amount,%(5)#Ruler,%(6)#SMF formatted data fields.

        .--------------------------------------------------------------.#
        |                                                              |
%(1)#=> | %SYS1.MAN1 on MPSYSF ----------------------- Line 1 Col 1 80#| <=%(2)#
%(3)#=> | %Command ==>@                               %Scroll ==>@CSR #| <=%(4)#
%(5)#=> |¢1       10        20        30        40        50        60#|
        |¢+---+----+----+----+----+----+----+----+----+----+----+----+#|
        |$ 64©08:56:40 04.022 A1VS RMFGAT   SYS1.RMFMON.DS2.DATA    B=#| <=%(6)#
        |$ 64^08:56:40 04.022 A1VS IEESYSAS SYS1.MAN2.DATA     VSAM B=#|
        |$ 60 08:56:40 04.022 A1VS IEESYSAS SYS1.MAN2                 #|
        |$ 42¶08:56:40 04.022 A1VS IEESYSAS CLOSE Scroll right for mor#|
        |$ 90 08:56:40 04.022 A1VS SMF      subtype   6 SWITCH SMF    #|
        |$230 08:56:40 04.022 A1VS RDRH                               #|
        |$ 30£08:56:40 04.022 A1VS RDRH     STC26082             RDRH #|

)INIT
)PROC
)END
./ ADD NAME=REVHB07D
)ATTR DEFAULT(}+_)
    } TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    $ TYPE(TEXT) INTENS(HIGH) COLOR(GREEN)
    @ TYPE(TEXT) INTENS(HIGH) COLOR(RED) HILITE(USCORE)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
}TUTORIAL+-\-\-¢REVIEW EREP Display Screen Format+-\-\-}TUTORIAL
}OPTION  ===>_ZCMD                                                             +


   The six areas of the¢REVIEW}EREP+display screen are shown below.
   They are:}(1)+Title,}(2)+Line/Column numbers,}(3)+Command,
  }(4)+Scroll amount,}(5)+Ruler,}(6)+EREP formatted data fields.

        .--------------------------------------------------------------.+
        |                                                              |
}(1)+=> | }SYS1.A1.LOGREC on WLMDW1 ------------------ Line 1 Col 1 80+| <=}(2)+
}(3)+=> | }Command ==>@                               }Scroll ==>@CSR +| <=}(4)+
}(5)+=> |¢1       10        20        30        40        50        60+|
        |¢*DATE* TIME-OF-DAY RECTYP CPU-SERIAL# JOB-NAME IDNO VOLUME/L+|
        |$XTNT:0380.00-03CF.0E  LAST-REC:0380.01.03  90%:03C7.0E  DEVT+| <=}(6)+
        |$04.022 10:18:57.58 LOGREC 0205F1-9672 3-MINUTE CURRENCY RECO+|
        |$04.022 00:05:46.19 MDR    0205F1-9672           345 LM2548  +|
        |$04.022 00:18:00.97 MDR    0205F1-9672           343 LM6668  +|
        |$04.022 00:18:01.08 MDR    0205F1-9672           344 LM6530  +|
        |$04.022 00:18:45.93 MDR    0205F1-9672           350 LM6458  +|
        |$04.022 00:22:16.85 MDR    0205F1-9672           341 LM2268  +|

)INIT
)PROC
)END
./ ADD NAME=REVHB07E
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    # AREA(SCRL) EXTEND(ON)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW FORMAT Subcommand+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +
+
#SCRLAREA -----------------------------------------------------------------#
)AREA SCRLAREA


+  The%FORMAT+subcommand causes¢REVIEW+to format file data on the
+  screen according to the data structure and types specified in
+  Assembler DS and/or DC statements.  The "ruler" heading line above
+  the data is used to show the names of the visible data items, and
+  where room permits the starting column number of the item is shown
+  directly above the data item name.
+
+  The format of the actual file data remains unchanged when HEX ON
+  is active.  When HEX OFF is current, each data item is formatted
+  according to the data type in the DS or DC statement.  The main data
+  types are character, hexadecimal, decimal, and binary integer.
+
+  The Assembler statements are read from the partitioned data set(s)
+  allocated to the REVFMTS file.  REVFMTS must be allocated before it
+  can be used by this subcommand.  The TSO subcommand may be useful in
+  helping to perform this allocation from within¢REVIEW.+ The FMTVAR
+  subcommand can be used to override the data type of a specific data
+  item or variable in a dynamic fashion.
+
+  Note that for variable-length records, the record descriptor word
+  (RDW) is assumed to be present in the data structure source, even
+  though the contents of the RDW are not shown by¢REVIEW.+
+
+  When using this subcommand (as opposed to the SMF subcommand) to
+  format SMF records, the following members of SYS1.MACLIB may be
+  useful, especially after a FINDSMF ALL subcommand has been issued:
+     IFASMFR  - type 0                   IAZSMF49 - type 49
+     IFASMFR1 - type 7                   IFASMFR5 - type 50
+     IFGSMF14 - type 14 and type 15      IAZSMF45 - type 52
+     IGGSMF17 - type 17                  IAZSMF45 - type 53
+     IFASMFR2 - type 20                  IAZSMF45 - type 54
+     IGESMF21 - type 21                  IAZSMF45 - type 55
+     IOSDSMFR - type 22                  IAZSMF45 - type 56
+     IAZSMF24 - type 24                  IAZSMF45 - type 57
+     IAZSMF25 - type 25                  IAZSMF45 - type 58
+     IAZSMF26 - type 26                  IDASMF62 - type 62
+     IFASMFI6 - type 36                  IGGSMF63 - type 63
+     IFASMFR4 - type 40                  IDASMF64 - type 64
+     IAZSMF43 - type 43                  IGGSMF67 - type 67
+     IAZSMF45 - type 45                  IGGSMF68 - type 68
+     IAZSMF47 - type 47                  IGGSMF69 - type 69
+     IAZSMF48 - type 48                  IFASMFR9 - type 80
+
+  When¢REVIEWing+a VTOC, the VTOC entries can be formatted by
+  'FORMAT ON' even when no REVFMTS file allocation is present.
+
+  %Syntax+-
+     FORMAT  'fmtname' / ON / OFF
+
+  %Alias+-
+     FMT
+
)INIT
)PROC
&ZCONT = REVHB07F
)END
./ ADD NAME=REVHB07F
)ATTR DEFAULT(%#_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    $ TYPE(TEXT) INTENS(HIGH) COLOR(GREEN)
    @ TYPE(TEXT) INTENS(HIGH) COLOR(RED) HILITE(USCORE)
    # TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL#-\-\-¢REVIEW VTOC Formatted Display Screen Format#-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             #


   The six areas of the¢REVIEW%VTOC#formatted display screen are shown below.
   They are:%(1)#Title,%(2)#Line/Column numbers,%(3)#Command,
  %(4)#Scroll amount,%(5)#Ruler,%(6)#VTOC data fields.

        .--------------------------------------------------------------.#
        |                                                              |
%(1)#=> | %FORMAT4.DSCB on MPIPLF -------------------- Line 1 Col 1 80#| <=%(2)#
%(3)#=> | %Command ==>@                               %Scroll ==>@CSR #| <=%(4)#
%(5)#=> |¢1                                            45       46    #|
        |¢DS1DSNAM                                     DS1FMTID DS1DSS#|
        |$............................................ F4       ......#| <=%(6)#
        |$............................................ F5       ......#|
        |$SYS1.VTOCIX.MPIPLF                           F1       MPIPLF#|
        |$NETVIEW.CNMLINK                              F1       MPIPLF#|
        |$SYS1.PARMLIB                                 F1       MPIPLF#|
        |$TCPIP.SEZADES                                F1       MPIPLF#|
        |$TCPIP.SEZAXLD1                               F1       MPIPLF#|

)INIT
)PROC
)END
./ ADD NAME=REVHB08
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    ! AREA(SCRL) EXTEND(ON)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Global Subcommands+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +
+
!SCRLAREA -----------------------------------------------------------------!
)AREA SCRLAREA
+
+  These subcommands are available in all display modes of¢REVIEW:+
+
%  HELP    +- Request HELP about¢REVIEW+and/or its subcommands.
%  KEYS    +- Display current Program Function Key values.
%  ?       +- Display the release of¢REVIEW+that is in use.
%  TSO     +- Issue a TSO command.
%  RECALL  +- Recall previously typed-in commands for optional
+             editing and reissuing.
%  RETRIEVE+- Same as 'RECALL'.
%  SWAP    +- List or transfer control between parallel sessions.
%  UP      +- Scroll backwards a specified number of lines or records.
+             If no operand is specified, the 'scroll' value is used.
+             This is displayed in the upper right corner.
+             Note that scrolling up to a previous volume or data
+             set cannot be performed.
%  DOWN    +- Scroll forwards a specified number of lines or records.
+             If no operand is specified, the 'scroll' value is used.
+             This is displayed in the upper right corner.
%  TOP     +- Scroll up to the first line or record (on this volume).
%  BOTTOM  +- Scroll down to the last line or record.
%  BOT     +- Same as 'BOTTOM'.
%  END     +- END the command.
%  CANCEL  +- Same as 'END' but user profile changes are not saved.
%  CAN     +- Same as 'CANCEL'.
%  EXIT    +- Terminate the whole¢REVIEW+session.
%  RETURN  +- Same as 'EXIT'.
+
)INIT
)PROC
)END
./ ADD NAME=REVHB09
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    ! AREA(SCRL) EXTEND(ON)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Browse Subcommands+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +
+
!SCRLAREA -----------------------------------------------------------------!
)AREA SCRLAREA
+
   These subcommands are available while¢REVIEWing+file data.

%  LEFT     +- Scroll to the left a specified number of columns.
            +  If no operand is specified, the 'scroll' value is used.
%  RIGHT    +- Scroll to the RIGHT a specified number of columns.
            +  If no operand is specified, the 'scroll' value is used.
%  LOCATE   +- Display the specified record number.
            +  (Relative record number only, not sequence numbers.)
%  HEX ON   +- Display the screen in hexadecimal.
%  HEX OFF  +- Display the screen in character mode.
%  HEX      +- If HEX currently on, turn it off.  If off, turn it on.
%  FIND     +- Search until the specified data or pattern is found.
%  FINDSMF  +- Search for an SMF record type and optionally sub-type.
%  FINDNOT  +- Search until the specified data or pattern is not found.
%  IFIND    +- Repeat the previous FIND or FINDNOT operation.
%  RESET    +- Deactivate line exclusion caused by the ALL or REST
            +  operand of a FIND or FINDNOT subcommand.
%  FULL ON  +- Use full EBCDIC translation for display with using any
            +  APL characters.
%  FULL OFF +- Use the standard 3270 keyboard character set for display.
%  FULL     +- If FULL is on, turn it off.  If off, turn it on.
%  ASCII ON +- Specifies that ASCII data is being¢REVIEWed+and that
            +  characters are to be translated to EBCDIC before being
            +  displayed.  Note that search arguments to the 'FIND' and
            +  'FINDNOT' commands typed in while in ASCII mode are
            +  translated to ASCII.
%  ASCII OFF+ - Leave the characters to be displayed in EBCDIC.
%  ASCII    +- If ASCII is on, turn it off.  If off, turn it on.
%  DISP T   +- Display TN/T11-like EBCDIC text characters where possible.
            +  This is similar to 3278T in ISPF.
%  DISP A   +- Display APL/EBCDIC characters where possible.
            +  This is similar to 3278A in ISPF.
%  DISP     +- Toggle between DISP T and DISP A.
%  DIR      +- Display the directory of the partitioned data set or file
            +  currently being¢REVIEWed.+
%  MEMBER   +- Switch to a specified member within the same
            +  partitioned data set (or concatenation thereof)
            +  as the current member.
%  NEWTOP   +- Specify a relative physical address to be considered
            +  as the top-of-data.  This is useful for looking past
            +  I/O errors, end-of-file markers, and at deleted members.
            +  It is also useful for directly viewing data a long way
            +  from the start without reading all the preceding records.
%  SUBMIT   +- Submit the file or MEMBER being¢REVIEWed.+
            +  TSO SUBMIT is invoked.
            +  The data set must be sequential or partitioned,
            +  and have fixed length 80-byte records.
%  SMF ON   +- If SMF data is being examined, convert the record
            +  to eye-readable format.
%  SMF OFF  +- Undo 'SMF ON'.
%  SMF      +- If SMF is currently on, turn it off.  If off, turn it on.
%  EREP ON  +- If LOGREC data is being examined, convert the record
            +  to eye-readable format.
%  EREP OFF +- Undo 'EREP ON'.
%  EREP     +- If EREP is currently on, turn it off. If off, turn it on.
%  FORMAT   +- Format file data according to Assembler data definition
            +  source code in the nominated member of the REVFMTS file.
            +  VTOC entries can be formatted without the REVFMTS file.
%  FMT OFF  +- Suspend record formatting.  Disable picture rendering.
%  FMT ON   +- Resume record formatting.
%  FMTVAR   +- Manually specify the data type of a data item.
%  APPEND   +- Copy¢REVIEWed+data starting from the first record shown
            +  on the screen to an output file.  Data is to be appended
            +  to any existing data in the output file.
%  COPYOUT  +- Copy¢REVIEWed+data starting from the first record shown
            +  on the screen to an output file.  Any data in the output
            +  file will be overwritten and lost.
%  PICDATA  +- Cause Assembler source statements containing picture
            +  image data to be written to a file.
%  EDIT     +- Process the current data set with ISPF EDIT.
%  BROWSE   +- Process the current data set with ISPF BROWSE.
%  VIEW     +- Process the current data set with ISPF VIEW.
%  UPDATE   +- Process the current data set with REVEDIT, the fullscreen
            +  editor component of¢REVIEW.+
%  RTF      +- COPYOUT print files with message and ASM text coloring.
)INIT
)PROC
)END
./ ADD NAME=REVHB10
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW ISPF Services+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   The%EDIT, BROWSE,+and%VIEW+subcommands request ISPF services for the
   data set or member currently being¢REVIEWed.+ These subcommands are only
   valid when the current data set is an MVS DASD data set.  The ISPF
   request will only succeed in an ISPF environment.

)INIT
)PROC
)END
./ ADD NAME=REVHB11
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW TSO Commands+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   The%SUBMIT+subcommand will submit the data set or member currently
   being¢REVIEWed.+ TSO SUBMIT is invoked.  The data set must be
   sequential or partitioned, and have fixed length 80-byte records.


   The%TSO+subcommand specifies a TSO command processor to be invoked
   from the¢REVIEW+processor.  Commands generating an implicit EXEC such
   as SYSPROC member names and commands immediately prefixed by a percent
   sign are supported.

)INIT
)PROC
)END
./ ADD NAME=REVHB12
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Termination+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   The%END+subcommand terminates the¢REVIEW+command, or, if in member
   selection mode, returns to the member selection list.  The member
   selection list may be bypassed with the EXIT subcommand.

   The%EXIT+subcommand terminates the¢REVIEW+command, bypassing the
   member selection list.

   The%CANCEL+subcommand performs the same processing as the END subcommand
   without saving the¢REVIEW+user profile to disk.  The¢REVIEW+user
   profile (which contains data display colors, scrolling amount and 24 PF
   Key values) is normally only rewritten to disk at the END of a¢REVIEW+
   session if it has been changed during that session.  If a member list has
   not been displayed in a session then the¢REVIEW+session is terminated
   without saving the user profile.  If a member list has been shown it is
   reshown but the user profile is no longer considered to have been
   altered, even though the profile "in-core" still has the changes applied
   to it.  Changing the profile at this stage and exiting will cause all
   accumulated profile changes for the¢REVIEW+session to be saved to disk
   unless another CANCEL is issued.
)INIT
)PROC
)END
./ ADD NAME=REVHBDT
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Detailed Information+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   Detailed information for the¢REVIEW+command processor is contained
   in the TSO HELP member for¢REVIEW.+ This member resides in the SYSHELP
   concatenation.   Enter one of the following commands to view the HELP
   member in 3270 full screen mode.

     %TSO FSHELP REVIEW+
     %TSO HEL REVIEW+

)INIT
)PROC
)END
./ ADD NAME=REVHBGN
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    # AREA(SCRL) EXTEND(ON)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW General Information+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +
+
#SCRLAREA -----------------------------------------------------------------#
)AREA SCRLAREA
+
+The¢REVIEW+command allows a data set or UNIX entity to be examined at a
+3270 TSO terminal in full screen mode.  Both disk and tape files may be
+REVIEWed.  Load module members with a residence mode of ANY are shown
+in high intensity or green in the member list.  SCLM-managed members
+are flagged with an equals ('=') sign in the member list.  When looking
+at file data, a 'K' may be shown in the "ruler" heading line to denote
+the first and last, or only, column(s) of VSAM record keys.  On color
+terminals the portion of the "ruler" line corresponding to record keys
+is shown in red.  If the record format indicates printer carriage
+control characters then an 'A' or an 'M' as appropriate may be shown in
+column 1 of the "ruler" heading line.
+
¢REVIEW+can format records according to Assembler data structure
+source code supplied by the user. ¢REVIEW+can also format system
+related data such as SMF records, EREP data, VTOC entries, tape
+labels and load module structure and identification data. ¢REVIEW+
+can format the directories of ZIP files created by PKZIP, Info-ZIP,
+WinZIP, etc.
+
¢REVIEW+can display the history of program objects residing in PDSE
+data sets or UNIX files, including compilation and program bind
+timestamps.
+
¢REVIEW+can display pictures in 1-bit (black-and-white), 4-bit
+(16 colors) and 8-bit (256 colors) single-plane ".PCX" (ZSoft
+Paintbrush) files on a terminal with 3270 graphics capabilities.
+
¢REVIEW+can display pictures in 1-bit (black-and-white), 4-bit
+(16 colors), 8-bit (256 colors), 16-bit (high color), 24-bit or
+32-bit (true color) uncompressed single-plane ".BMP" (Windows or
+OS/2 Bitmap) files on a terminal with 3270 graphics capabilities.
+
+(Colors in color pictures will be coarsely rendered in 3270 colors.)
+
¢REVIEW+can process a single data set or a pre-allocated file
+concatenation.  Partitioned files can be sequentialized,
+offloaded in PDSLOAD (IEBUPDTE-like) format, or searched for
+specific or picture-masked data.  Load modules can be offloaded
+into a sequential format, and can be delinked into object decks.
+Sequential offload files can be processed to restore members
+into partitioned data sets.
+
¢REVIEW+can process the system PARMLIB concatenation.
+
¢REVIEW+has three (3) different directory displays.  They are:
+    1)%PDS+type - for a PDS, a data PDSE, and concatenated
+       files of any sort of PDS and/or PDSE.
+    2)%PDSE+type - for an unconcatenated program object PDSE.
+    3)%UNIX+type - for UNIX directories and files in
+       hierarchical file structures.
+
¢REVIEW+can process UNIX files such as HFS (Hierarchical File System)
+files.
+
¢REVIEW+allows access to, and the saving of, data by data content,
+data beyond I/O errors and end-of-file markers, and data from
+deleted members of a PDS.
+
¢REVIEW+can convert ASCII data to EBCDIC.
+
¢REVIEW+can be invoked recursively by using the TSO subcommand.
+Swapping between parallel sessions allows access to any nested
+REVIEW session without requiring the termination of any other
+REVIEW session.
+
+The 'REVED' command is a way of invoking¢REVIEW+and setting the
+default action for non-VSAM data sets to edit with REVEDIT instead
+of browse with REVIEW.  Using REVED with a sequential data set
+name immediately starts a REVEDIT session.  Using REVED with a
+partitioned data set name alters the meaning of the 'S' selection
+code to mean edit (with REVEDIT) rather than browse (with REVIEW).
+
)INIT
)PROC
)END
./ ADD NAME=REVHE00
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    # TYPE(AB)    FORMAT(MIX)
    " TYPE(ABSL) GE(ON)
)ABC DESC('Help') MNEM(1)
PDC PDCTEXT('REVEDIT TSO full-screen help')
 ACTION RUN(TSO) PARM('HEL REVEDIT')
PDC PDCTEXT('About...')
 ACTION RUN(TUTOR) PARM('REVLOGO')
PDC PDCTEXT('REVIEW FAQ')
 ACTION RUN(TUTOR) PARM('REVFAQ')
)ABCINIT
.ZVARS=HELP
)BODY EXPAND(\\)
\ \# Help
%TUTORIAL+-\-\-¢REVEDIT Component of REVIEW+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +
%               ---------------------------------------------
%               |                  REVEDIT                  |
%               ---------------------------------------------
+
   The¢REVEDIT+component of¢REVIEW+allows you to create and change
   MVS files.

   Members of partitioned data sets and sequential data sets can be
   edited, and can be scrolled forward, backward, left, or right.

 The following topics are presented in sequence, or may be selected by number:
  %1+- Types of data sets               %6+- Global subcommands
  %2+- Invoking¢REVEDIT+                %7+- Edit primary subcommands
  %3+- Directory display list           %8+- Edit line subcommands
  %4+- Display screen format            %9+- TSO commands
  %5+- Scrolling data                  %10+- Ending a¢REVEDIT+session


 The following topics will be presented only if selected by number:
 %11+- Detailed¢REVEDIT+information
)INIT
&ZHTOP = REVHE00
)PROC
  &ZSEL = TRANS(&ZCMD  1,REVHE01   2,REVHE02   3,REVHE03   4,REVHE04
                       5,REVHE05   6,REVHE06   7,REVHE07   8,REVHE08
                       9,REVHE09  10,REVHE10
                      11,*REVHEDT
                         *,'?')
)END
./ ADD NAME=REVHE01
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVEDIT Types of Datasets+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 ¢REVEDIT+can edit sequential, partitioned, and partitioned-extended
  files that have the following characteristics.


      %Record Formats+- fixed or variable
                      - blocked or unblocked
                      - with or without printer control characters

      %Data Lengths+  - 1 to 32760 bytes of data, inclusive

)INIT
)PROC
)END
./ ADD NAME=REVHE02
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVEDIT Invocation+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 ¢REVEDIT+is a fullscreen editor and a component of¢REVIEW.+
 ¢REVEDIT+is not a TSO command, but the¢REVEDIT+HELP member will be
  accessed when HELP is requested in a non-ISPF environment.

 ¢REVEDIT+allows the editing of MVS data sets residing on direct
  access storage devices (DASD) which may contain records which have
  a fixed-length or variable-length format.  Currently only non-VSAM
  is supported.

  Under MVS/ESA and later (including OS/390 and z/OS) data being
  edited is held in a data space which can grow with the data up to
  two (2) gigabytes in size subject to installation limits implemented
  either by design (eg. system exits) or circumstance (eg. insufficient
  auxiliary storage to allow processing to continue).

   Syntax -
        %UPDATE+
     or, if not in an ISPF environment
        %EDIT+
)INIT
)PROC
)END
./ ADD NAME=REVHE03
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Directory Display Information+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +
+
%               ---------------------------------------------
%               |               PDS/PDSE                    |
%               |       Directory Display Information       |
%               ---------------------------------------------
+
   The following topics are presented in sequence or may be requested
   by number:
     %1+- Accessing and updating members
     %2+- Reading or writing member contents to or from a file
     %3+-¢REVIEW+directory display control
     %4+- Sorting directory entries
     %5+- Searching members
     %6+-¢REVIEW+session control
     %7+-¢REVIEW+member selection action codes

   The following topics will be presented only if selected by number:
     %8+- General¢REVIEW+information
)INIT
)PROC
  &ZSEL = TRANS(&ZCMD  1,REVHP01   2,REVHP02   3,REVHP03   4,REVHP04
                       5,REVHP05   6,REVHP06   7,REVHP07   8,*REVHBGN
                       *,'?')
)END
./ ADD NAME=REVHE04
)ATTR DEFAULT(%#_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    $ TYPE(TEXT) INTENS(HIGH) COLOR(GREEN)
    Ý TYPE(TEXT) INTENS(HIGH) COLOR(RED)
    ¨ TYPE(TEXT) INTENS(HIGH) COLOR(BLUE)
    @ TYPE(TEXT) INTENS(HIGH) COLOR(RED) HILITE(USCORE)
    # TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL#-\-\-¢REVEDIT Display Screen Format#-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             #


   The six areas of the¢REVEDIT#display screen are shown below.
   They are:%(1)#Title,%(2)#Line/Column numbers,%(3)#Command,
  %(4)#Scroll amount,%(5)#Line command fields,%(6)#Data fields.

        .--------------------------------------------------------------.#
        |                                                              |
% (1)#=>|%REVEDIT  AD.HELP(REVEDIT) - 01.01        Columns 00001 00072#| <=%(2)#
% (3)#=>|%Command ===>@                              %Scroll ==>@CSR  #| <=%(4)#
        |Ý******¨***************************** Top of Data ***********#|
        |$000001 *                    TSO HELP FOR 'REVEDIT' RELEASE 3#|
        |$000002 )F Function -                                        #|
        |$000003   REVEDIT is a component of REVIEW which is a fullscr#|
% (5)#=>|$000004   REVEDIT is not a TSO command, but this HELP member #| <=%(6)#
        |$000005   when HELP is requested in a non-ISPF environment.  #|
        |$000006                                                      #|
        |$000007   REVEDIT allows the editing of MVS data sets residin#|
        |$000008   access storage devices (DASD) which may contain rec#|

                               (continued)
)INIT
)PROC
&ZCONT = REVHE04A
)END
./ ADD NAME=REVHE04A
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVEDIT Display Screen Format+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   The six display screen areas shown on the previous page are:

   (1) -%Title+- identifies the name of the data set (and member).  If
         ISPF statistics are present, the version/mod level is displayed.

   (2) -%Line/Column numbers+- shows the data line and column numbers
         that are being displayed.

   (3) -%Command+- where subcommands are entered.

   (4) -%Scroll amount+- where the scrolling amount is displayed.  You can
         change the amount by overtyping the amount field.

   (5) -%Line command fields+- where line commands are entered.

   (6) -%Data fields+- where the data is displayed.  Each field extends to
         the full width of the display.
)INIT
)PROC
)END
./ ADD NAME=REVHE05
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVEDIT Scrolling+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


  ¢REVEDIT+allows you to scroll up and down through the data. If the data is
   too wide to fit on the screen, you can also scroll left and right.

   To scroll, enter one of the six scroll commands (UP, DOWN, LEFT, RIGHT,
   TOP or BOTTOM).  Minus, plus, less than, and greater than signs are aliases
   for UP, DOWN, LEFT, and RIGHT.

   To change the number of lines or columns being scrolled, change the
   scroll amount field.

 The following topics will be presented only if selected by number:
    %1+- Scroll commands
    %2+- Scroll amount
)INIT
)PROC
  &ZSEL = TRANS(&ZCMD  1,*REVHE05A  2,*REVHE05B
                       *,'?')
)END
./ ADD NAME=REVHE05A
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVEDIT Scroll Commands+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   Use the scroll commands (or the default PF keys) to scroll:

    %UP    +(PF7)  - toward the top of the data
    %DOWN  +(PF8)  - toward the bottom of the data
    %LEFT  +(PF10) - toward the first column of the data
    %RIGHT +(PF11) - toward the last column of the data

   Usually, you can combine scrolling with other actions by entering a
   command and then pressing a scroll PF key (instead of the ENTER key).
   Both the action and the scroll will process.

   If the amount in the scroll amount field is not valid when a scroll command
   is entered, an error message is displayed.  Either correct the scroll
   amount, or take an action other than scrolling.

)INIT
)PROC
)END
./ ADD NAME=REVHE05B
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVEDIT Scroll Amount+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   The scroll amount is displayed on the terminal screen, following the
   command field.  You can change the scroll amount by typing over the
   scroll amount with a new amount.

   Valid scroll amounts are:

    %PAGE+to scroll by one page.

    %HALF+to scroll by half a page.

    %nnnn+(any number from 1 to 9999) to scroll by the specified
          number of lines or columns.

    %CSR+ to scroll to the position of the cursor within the data (or by
          a page if the cursor is outside the data or is already
          positioned in the top, bottom, left, or right margin).

    %DATA+to scroll by a page minus one line when scrolling up or down
          or by a page minus one column when scrolling left or right.
)INIT
)PROC
)END
./ ADD NAME=REVHE06
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    ! AREA(SCRL) EXTEND(ON)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Global Subcommands+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +
+
!SCRLAREA -----------------------------------------------------------------!
)AREA SCRLAREA
+
+  These subcommands are available in all display modes of¢REVIEW:+
+
%  HELP    +- Request HELP about¢REVEDIT.+
%  KEYS    +- Display current Program Function Key values.
%  ?       +- Display the release of¢REVIEW+that is in use.
%  TSO     +- Issue a TSO command.
%  RECALL  +- Recall previously typed-in commands for optional
+             editing and reissuing.
%  RETRIEVE+- Same as 'RECALL'.
%  SWAP    +- List or transfer control between parallel sessions.
%  UP      +- Scroll backwards a specified number of lines or records.
+             If no operand is specified, the 'scroll' value is used.
+             This is displayed in the upper right corner.
+             Note that scrolling up to a previous volume or data
+             set cannot be performed.
%  DOWN    +- Scroll forwards a specified number of lines or records.
+             If no operand is specified, the 'scroll' value is used.
+             This is displayed in the upper right corner.
%  TOP     +- Scroll up to the first line or record (on this volume).
%  BOTTOM  +- Scroll down to the last line or record.
%  BOT     +- Same as 'BOTTOM'.
%  END     +- END the command.
%  CANCEL  +- Same as 'END' but user profile changes are not saved.
%  CAN     +- Same as 'CANCEL'.
%  EXIT    +- Terminate the whole¢REVIEW+session.
%  RETURN  +- Same as 'EXIT'.
+
)INIT
)PROC
)END
./ ADD NAME=REVHE07
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    ! AREA(SCRL) EXTEND(ON)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVEDIT Edit Primary Subcommands+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +
+
!SCRLAREA -----------------------------------------------------------------!
)AREA SCRLAREA
+
   These primary subcommands are available while editing file data:

%  LEFT     +- Scroll to the left a specified number of columns.
            +  If no operand is specified, the 'scroll' value is used.
%  RIGHT    +- Scroll to the RIGHT a specified number of columns.
            +  If no operand is specified, the 'scroll' value is used.
%  LOCATE   +- Display the specified record number.
            +  (Relative record number only, not sequence numbers.)
%  CAPS ON  +- Ensure all data entered is translated to upper case.
%  CAPS OFF +- Ensure the case of entered data is not changed.
%  CAPS     +- Toggle the CAPS setting.
%  COLS ON  +- Activate the column marker.
%  COLS OFF +- Deactivate the column marker.
%  COLS     +- Toggle the display of the column marker.
%  COPY     +- Import the contents of a data set into the edited data.
%  CREATE   +- Create a new data set or member with edit session data.
%  PROF ON  +- Activate the profile settings display.
%  PROF OFF +- Deactivate the profile settings display.
%  PROF     +- Toggle the display of the profile settings.
%  HEX ON   +- Display the data in hexadecimal and character formats.
%  HEX OFF  +- Display the data in character format.
%  HEX      +- If HEX currently on, turn it off.  If off, turn it on.
%  HI OFF   +- Turns off syntax highlighting.
%  HI ASM   +- Activates Assembler source code syntax highlighting.
%  HI JCL   +- Activates JCL source code syntax highlighting.
%  HI AUTO  +- Activates syntax highlighting for JCL and Assembler
            +  source whenever they are detected.
%  FIND     +- Search until the specified data or pattern is found.
%  FINDNOT  +- Search until the specified data or pattern is not found.
%  IFIND    +- Repeat the previous FIND or FINDNOT or EXCLUDE or EXNOT.
%  CHANGE   +- Find and then change a specified character string.
%  ICHANGE  +- Repeat the previous CHANGE.
%  DELETE   +- Delete excluded or nonexcluded lines.
%  EXCLUDE  +- Exclude lines from display.
%  EXNOT    +- Exclude lines from display that do not contain the string.
%  FLIP     +- Toggle the exclusion status of every data record.
%  STATS    +- Set whether member statistics are to be stored or not.
%  LEVEL    +- Set the modification level of the member statistics.
%  VERSION  +- Set the version level of the member statistics.
%  NUMBER   +- Set sequence numbering on or off.
%  UNNUM    +- Clear sequence numbers from the data.
%  REDO     +- Undo an 'UNDO'.
%  RENUM    +- Resequence the data records.
%  NULLS ON +- Replace trailing blanks with 3270 null characters.
%  NULLS OFF+- Preserve trailing blanks.
%  REPLACE  +- Replace a data set or member with edit session data.
%  RESET    +- Clear all line commands and cancel all exclusions.
%  SORT     +- Sort records into a different order based on data content.
%  SUBMIT   +- Submit the data set or MEMBER being edited.
            +  TSO SUBMIT is invoked.
%  UNDO     +- Undo a change to the data being edited or viewed.
%  UNDO ON  +- Enable UNDO.
%  UNDO OFF +- Disable UNDOa nd release UNDO resources.
%  ZAP      +- Control whether PDS members with fixed-length records
            +  that have an unchanged record count at save time are
            +  to be stored in the same location (using update-in-place)
            +  to save disk space, or not.
)INIT
)PROC
)END
./ ADD NAME=REVHE08
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    ! AREA(SCRL) EXTEND(ON)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVEDIT Edit Line Subcommands+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +

   These line subcommands are available while editing file data:

%  I +- Insert line (to insert 1 or more lines of new data).
%  D +- Delete line (to delete 1 line, several lines, or a block of lines).
%  R +- Repeat line (to repeat a single line 1 or more times,
%    +               or to repeat a block of lines 1 or more times).
%  C +- To identify the source of a copy operation.
%  M +- To identify the source of a move operation.
%  A +- To identify the destination of a move/copy operation.
%  B +- To identify the destination of a move/copy operation.
%  O +- To identify the destination of a move/copy overlay operation.
%  ) +- Shift right one or more columns.
%  ( +- Shift left one or more columns.
%  X +- Exclude one line, several lines, or a block of lines.
%  F +- Show the first line(s) from a block of excluded lines.
%  L +- Show the last line(s) from a block of excluded lines.
%  S +- Show the lines from a block of excluded lines.
%  W +- Lowercase, to change text from uppercase to lowercase.
%  U +- Uppercase, to change text from lowercase to uppercase.
% TF +- Text flow, to flow text to the end of a paragraph.
% TS +- Text split, to split a text line at the cursor to allow insertion.
)INIT
)PROC
)END
./ ADD NAME=REVHE09
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW TSO Commands+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   The%SUBMIT+subcommand will submit the data set or member currently
   being edited.  TSO SUBMIT is invoked.  The data set must be
   sequential or partitioned, and have fixed length 80-byte records.


   The%TSO+subcommand specifies a TSO command processor to be invoked
   from the¢REVIEW+processor.  Commands generating an implicit EXEC such
   as SYSPROC member names and commands immediately prefixed by a percent
   sign are supported.

)INIT
)PROC
)END
./ ADD NAME=REVHE10
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVEDIT Termination+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   The%END+subcommand instructs¢REVEDIT+to terminate after saving
   any changed data.  If the data cannot be saved then¢REVEDIT+will
   not terminate.

   The%EXIT+subcommand performs the same processing as END, except
   that if¢REVEDIT+was invoked from a member selection list then the
   member selection list will not be displayed but instead the entire
  ¢REVIEW+session will end.

   The%CANCEL+subcommand instructs¢REVEDIT+to discard all data
   being edited and terminate.

)INIT
)PROC
)END
./ ADD NAME=REVHEDT
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVEDIT Detailed Information+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   Detailed information for the¢REVEDIT+option of¢REVIEW+is contained
   in the TSO HELP member¢REVEDIT.+ This member resides in the SYSHELP
   concatenation.   Enter one of the following commands to view the HELP
   member in 3270 full screen mode.

     %TSO FSHELP REVEDIT+
     %TSO HEL REVEDIT+

)INIT
)PROC
)END
./ ADD NAME=REVHJ00
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    # TYPE(AB)    FORMAT(MIX)
    " TYPE(ABSL) GE(ON)
)ABC DESC('Help') MNEM(1)
PDC PDCTEXT('REVOUT TSO full-screen help')
 ACTION RUN(TSO) PARM('HEL REVOUT')
PDC PDCTEXT('About...')
 ACTION RUN(TUTOR) PARM('REVLOGO')
PDC PDCTEXT('REVIEW FAQ')
 ACTION RUN(TUTOR) PARM('REVFAQ')
)ABCINIT
.ZVARS=HELP
)BODY EXPAND(\\)
\ \# Help
%TUTORIAL+-\-\-¢REVIEW Job Output Listings+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +
+
%               ---------------------------------------------
%               |                 REVIEW                    |
%               |            Job Output Listings            |
%               ---------------------------------------------
+
   The following topics are presented in sequence or may be requested
   by number:
     %1+- Job output list display format
     %2+- Job output list subcommands
     %3+- Job processing selection codes

   The following topics will be presented only if selected by number:
     %4+- Detailed Job Output Listing information
)INIT
)PROC
  &ZSEL = TRANS(&ZCMD  1,REVHJ01   2,REVHJ02   3,REVHJ03   4,*REVHJDT
                       *,'?')
)END
./ ADD NAME=REVHJ01
)ATTR DEFAULT(%#_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    $ TYPE(TEXT) INTENS(HIGH) COLOR(GREEN)
    @ TYPE(TEXT) INTENS(HIGH) COLOR(RED) HILITE(USCORE)
    # TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL#-\-\-¢REVOUT Job List Display#-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             #


    .----------------------------------------------------------------------.#
    | %REVOUT   TRIDJK                                        LINE 1 OF 2# |
    | %COMMAND ===>@                                     %SCROLL ===>@CS # |
    | $S Q JOBNAME  JOBIDENT STATUS          STEPNAME PROCSTEP   CPU-TIME# |
    | $' ' TRIDJK   TSU32280 ON OUTPUT QUEUE                             # |
    | $' ' TRIDJK   TSU00194 EXECUTING       LOGDED                 48.74# |
    .----------------------------------------------------------------------.#
       | |
       | |
       | |
       | +------%SYSOUT class (for release)#
       +--------%Job selection code (S, P, O, C)#
)INIT
)PROC
)END
./ ADD NAME=REVHJ02
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    ! AREA(SCRL) EXTEND(ON)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVOUT Primary Subcommands+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +
+
!SCRLAREA -----------------------------------------------------------------!
)AREA SCRLAREA
+
   These primary subcommands are available from the job list display:

%  STATUS   +- Issue a search for a different job name.
)INIT
)PROC
)END
./ ADD NAME=REVHJ03
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    ! AREA(SCRL) EXTEND(ON)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVOUT Line Subcommands+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +

   These line subcommands are available from the job list display:

%  S +- Look at available job output. ¢REVIEW+will be used.
%  P +- Purge job output.  A batch job will also be cancelled.
%  O +- Release job output for printing.
%    +  A new SYSOUT class can be specified in the Q column.
%  C +- Cancel a job before or during execution.
%    +  The job will not be purged.
)INIT
)PROC
)END
./ ADD NAME=REVHJDT
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Job Output Listings+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   Detailed information for REVIEWing job output on JES spool is contained
   in the TSO HELP member¢REVOUT.+ This member resides in the SYSHELP
   concatenation.   Enter one of the following commands to view the HELP
   member in 3270 full screen mode.

     %TSO FSHELP REVOUT+
     %TSO HEL REVOUT+

)INIT
)PROC
)END
./ ADD NAME=REVHO00
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    # TYPE(AB)    FORMAT(MIX)
    " TYPE(ABSL) GE(ON)
)ABC DESC('Help') MNEM(1)
PDC PDCTEXT('REVPDSE TSO full-screen help')
 ACTION RUN(TSO) PARM('HEL REVPDSE')
PDC PDCTEXT('About...')
 ACTION RUN(TUTOR) PARM('REVLOGO')
PDC PDCTEXT('REVIEW FAQ')
 ACTION RUN(TUTOR) PARM('REVFAQ')
)ABCINIT
.ZVARS=HELP
)BODY EXPAND(\\)
\ \# Help
%TUTORIAL+-\-\-¢REVIEW Directory Display Information+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +
+
%               ---------------------------------------------
%               |          PDSE Program Object              |
%               |       Directory Display Information       |
%               ---------------------------------------------
+
   The following topics are presented in sequence or may be requested
   by number:
     %1+- Accessing members
     %2+-¢REVIEW+directory display control
     %3+- Sorting directory entries
     %4+- Searching members
     %5+-¢REVIEW+session control
     %6+- Program object attributes - Part 1
     %7+- Program object attributes - Part 2
     %8+-¢REVIEW+member selection action codes

   The following topics will be presented only if selected by number:
     %9+- Detailed PDSE program object directory display information
)INIT
)PROC
  &ZSEL = TRANS(&ZCMD  1,REVHO01   2,REVHO02   3,REVHO03   4,REVHO04
                       5,REVHO05   6,REVHO06   7,REVHO07   8,REVHO08
                       9,*REVHODT  *,'?')
)END
./ ADD NAME=REVHO01
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Accessing Members+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Subcmd   Aliases  Function

%SELECT   S  SEL  +Choose a member for¢REVIEW+and review it.
                   eg.%s aProgram+starts a¢REVIEW+Browse of member%aProgram.+
                   eg.%s POSTING+ starts a¢REVIEW+Browse of member%POSTING.+

%BROWSE   B       +Choose a member for ISPF Browse and browse it.
                   An ISPF environment is required for this subcommand.
                   eg.%bRoWsE mIxIt+starts an ISPF Browse of member%mIxIt.+


                   Note that the operand specifying the member name
                   is not automatically folded to upper case, and
                   has a maximum length of eight (8) characters.

)INIT
)PROC
)END
./ ADD NAME=REVHO02
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Controlling the Display+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Subcmd   Aliases  Function

%DOWN             +Scroll down towards the bottom of the list.
%UP               +Scroll up towards the top of the list.
%BOTTOM           +Same as%DOWN MAX.+
%TOP              +Same as%UP MAX.+

%LOCATE LOC LIST L+Scroll the display to position the first entry name
                   (or ID name if SORT ID is in effect) starting with
                   the string matching the subcommand operand.

%IFIND    RFIND   +Scroll the display to position the next (or first)
                   tagged entry at the top of the display.

%TAGFLIP  TF      +Untag all tagged entries and tag all untagged entries.

%RESET    RES     +Untag all entries.

%REFRESH  REF     +Refresh the entry list from DASD.  Tags are discarded.
)INIT
)PROC
)END
./ ADD NAME=REVHO03
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Sorting the Entries+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Subcommand        Function

%SORT NAME        +Sort the list into ascending name order.

%SORT CHA         +Sort the list into descending change timestamp order.
%SORT DATE        +Sort the list into descending change timestamp order.

%SORT SIZE        +Sort the list into descending size order.

%SORT TTR         +Sort the list into ascending MLT or TTR order.  This is
                   the order that the members were saved into the PDSE.

%SORT ID          +Sort the list into ascending user/job order.
%SORT JOB         +Sort the list into ascending user/job order.
%SORT USER        +Sort the list into ascending user/job order.

%SORT SSI         +Sort the list into ascending SSI order.
%SORT VER         +Sort the list into ascending SSI order.
)INIT
)PROC
)END
./ ADD NAME=REVHO04
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Searching Members+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Subcmd   Aliases  Function

%SEARCH   FIND  F +Causes the presentation of a data entry panel where the
                   search parameters are to be entered.

                   If any members are tagged only tagged members are searched.

                   After the search, members with matching data will be
                   tagged, and will be the only members tagged.
)INIT
)PROC
)END
./ ADD NAME=REVHO05
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Session Control+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Subcmd   Aliases  Function

%EXIT     END  =X +Terminate the¢REVIEW+session.
%CANCEL   CAN     +Terminate the¢REVIEW+session without updating your profile.

%SWAP LIST        +Display a list of parallel¢REVIEW+sessions.
%SWAP             +Swap to the second most recent¢REVIEW+session.
%SWAP #           +Swap to the¢REVIEW+session number%#+where%#+is a
                   decimal number which can be obtained from%SWAP LIST.+

%TSO      TSS     +Invoke the Command Processor named by the operand.
                   If the named command is¢REVIEW+a parallel session
                   is started.

)INIT
)PROC
)END
./ ADD NAME=REVHO06
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Program Object Attributes (1)+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


      %AMd+- Addressing mode of program.

%A24+- 24-bit addressing mode.
%A31+- 31-bit addressing mode.
%ANY+- either addressing mode.
%OV +- Segment Overlay program which must have 24-bit addressing mode.

      %At+ - Additional program attribute - display precedence order as listed.

%NX +- Program is Not eXecutable.  It cannot be fetched into storage.
%NE +- Program is Not Editable.  It cannot be reprocessed by the Binder.
%SC +- Program is in Scatter format - unlikely for a program object.
%OL +- Program is Only Loadable.  It can only be fetched by a LOAD macro.
%PG +- Program requires Page alignment.  It is loaded on a 4K page boundary.
%TS +- Program object contains Test Symbol information to assist debugging.
%NM +- Program is Not Migratable.  It cannot be converted to a load module.

)INIT
)PROC
)END
./ ADD NAME=REVHO07
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Program Object Attributes (2)+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


      %RU+ - Program reusability level.

%RU+ - Program is serially reusable.
%RN+ - Program is serially reusable, and reenterable.
%RF+ - Program is serially reusable, reenterable, and refreshable.


      %V+  - Program Management Version of the program object.

%d + - Program object is DLL-enabled.


 The names of aliases which can be hidden are shown in parentheses.

%*+after the real name indicates that the 8-byte real or primary name was
 generated by the Binder, and that the long alias name is the alternative
 primary name, that is, the primary name specified on the bind.


)INIT
)PROC
)END
./ ADD NAME=REVHO08
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Member Selection Codes+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Code  Function

%   S +Browse the member with¢REVIEW.+ This is the default
       selection code when the cursor is placed on the leader dot.

%   /+¢REVIEW+the member with the%DATA+operand.

%   B +Browse the member with ISPF Browse.

%   R +Reset or untag the member.
%   T +Tag the member for display control purposes, or for
       later processing by SEARCH, OFFLOAD, SEQLOAD or DELINK.

%   H +Display program history.
%   M +Display program map.
)INIT
)PROC
)END
./ ADD NAME=REVHODT
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Directory Display Information+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   Detailed information for the PDSE program object directory display is
   contained in the TSO HELP member¢REVPDSE.+ This member resides in
   the SYSHELP concatenation.   Enter one of the following commands to
   view the HELP member in 3270 full screen mode.

     %TSO FSHELP REVPDSE+
     %TSO HEL REVPDSE+

)INIT
)PROC
)END
./ ADD NAME=REVHP00
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    # TYPE(AB)    FORMAT(MIX)
    " TYPE(ABSL) GE(ON)
)ABC DESC('Help') MNEM(1)
PDC PDCTEXT('REVPDS TSO full-screen help')
 ACTION RUN(TSO) PARM('HEL REVPDS')
PDC PDCTEXT('About...')
 ACTION RUN(TUTOR) PARM('REVLOGO')
PDC PDCTEXT('REVIEW FAQ')
 ACTION RUN(TUTOR) PARM('REVFAQ')
)ABCINIT
.ZVARS=HELP
)BODY EXPAND(\\)
\ \# Help
%TUTORIAL+-\-\-¢REVIEW Directory Display Information+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +
+
%               ---------------------------------------------
%               |               PDS/PDSE                    |
%               |       Directory Display Information       |
%               ---------------------------------------------
+
   The following topics are presented in sequence or may be requested
   by number:
     %1+- Accessing and updating members
     %2+- Reading or writing member contents to or from a file
     %3+-¢REVIEW+directory display control
     %4+- Sorting directory entries
     %5+- Searching members
     %6+-¢REVIEW+session control
     %7+-¢REVIEW+member selection action codes

   The following topics will be presented only if selected by number:
     %8+- Detailed PDS/PDSE directory display information
     %9+- PDS/PDSE source directory display format
    %10+- PDS load directory display format
    %11+- PDSE load directory display format
)INIT
)PROC
  &ZSEL = TRANS(&ZCMD  1,REVHP01   2,REVHP02   3,REVHP03   4,REVHP04
                       5,REVHP05   6,REVHP06   7,REVHP07   8,*REVHPDT
                       9,*REVHP08 10,*REVHP09 11,*REVHP10
                       *,'?')
)END
./ ADD NAME=REVHP01
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Accessing and Updating Members+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Subcmd   Aliases  Function

%SELECT   S  SEL  +Choose a member for¢REVIEW+and review it.
                   eg.%s member01+starts a¢REVIEW+Browse of member%MEMBER01.+

%UPDATE   U       +Choose a member for¢REVEDIT+and edit it.
                   eg.%u member01+starts a¢REVIEW+Edit of member%MEMBER01.+

%BROWSE   B       +Choose a member for ISPF Browse and browse it.
                   eg.%b member01+starts an ISPF Browse of member%MEMBER01.+

%EDIT     E       +Choose a member for ISPF Edit and edit it.
                   eg.%e member01+starts an ISPF Edit of member%MEMBER01.+

%VIEW     V       +Choose a member for ISPF View and view it.
                   eg.%v member01+starts an ISPF View of member%MEMBER01.+
)INIT
)PROC
)END
./ ADD NAME=REVHP02
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Transferring Member Contents+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Subcmd   Aliases  Function

%PDSLOAD  PDS     +Write new member contents from sequential input.
                   PDSLOAD (or REVLMOD for load modules) will be invoked.

%OFFLOAD  OFF     +Copy members to a sequential file with%./+control records.
                   Sort into TTR order first to preserve aliases.

%SEQLOAD  SEQ     +Copy member contents to a sequential file.
                   This is not available when the record format is undefined.

%DELINK   DL      +Delink load modules and produce object decks.
                   The DELINKI program will be invoked.  Segment overlay
                   programs and program objects cannot be processed.
)INIT
)PROC
)END
./ ADD NAME=REVHP03
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Controlling the Display+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Subcmd   Aliases  Function

%DOWN             +Scroll down towards the bottom of the list.
%UP               +Scroll up towards the top of the list.
%BOTTOM           +Same as%DOWN MAX.+
%TOP              +Same as%UP MAX.+

%LOCATE LOC LIST L+Scroll the display to position the first entry name
                   (or ID name if SORT ID is in effect) starting with
                   the string matching the subcommand operand.

%IFIND    RFIND   +Scroll the display to position the next (or first)
                   tagged entry at the top of the display.

%TAGFLIP  TF      +Untag all tagged entries and tag all untagged entries.

%RESET    RES     +Untag all entries.

%REFRESH  REF     +Refresh the entry list from DASD.  Tags are discarded.
)INIT
)PROC
)END
./ ADD NAME=REVHP04
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Sorting the Entries+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Subcommand        Function

%SORT NAME        +Sort the list into ascending name order.

%SORT CHA         +Sort the list into descending change timestamp order.
%SORT DATE        +Sort the list into descending change timestamp order.

%SORT SIZE        +Sort the list into descending size order.

%SORT TTR         +Sort the list into ascending TTR order.  This is
                   the order that the members were saved into the PDS.

%SORT ID          +Sort the list into ascending UserId order.
%SORT USER        +Sort the list into ascending UserId order.

%SORT SSI         +Sort the list into ascending SSI or VV.MM order.
%SORT VER         +Sort the list into ascending SSI or VV.MM order.
)INIT
)PROC
)END
./ ADD NAME=REVHP05
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Searching Members+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Subcmd   Aliases  Function

%SEARCH   FIND  F +Causes the presentation of a data entry panel where the
                   search parameters are to be entered.

                   If any members are tagged only tagged members are searched.

                   After the search, members with matching data will be
                   tagged, and will be the only members tagged.
)INIT
)PROC
)END
./ ADD NAME=REVHP06
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Session Control+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Subcmd   Aliases  Function

%EXIT     END  =X +Terminate the¢REVIEW+session.
%CANCEL   CAN     +Terminate the¢REVIEW+session without updating your profile.

%SWAP LIST        +Display a list of parallel¢REVIEW+sessions.
%SWAP             +Swap to the second most recent¢REVIEW+session.
%SWAP #           +Swap to the¢REVIEW+session number%#+where%#+is a
                   decimal number which can be obtained from%SWAP LIST.+

%TSO      TSS     +Invoke the Command Processor named by the operand.
                   If the named command is¢REVIEW+a parallel session
                   is started.

)INIT
)PROC
)END
./ ADD NAME=REVHP07
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Member Selection Codes+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Code  Function

%   S +Browse the member with¢REVIEW.+ This is the default
       selection code when the cursor is placed on the leader dot.

%   /+¢REVIEW+the member with the%DATA+operand.

%   U +Edit the member with¢REVEDIT.+

%   B +Browse the member with ISPF Browse.
%   E +Edit the member with ISPF Edit.
%   V +View the member with ISPF View.

%   D +Delete a member from an unconcatenated PDS (not PDSE).
%   R +Restore a deleted member, or reset (untag) a tagged member.
%   T +Tag the member for display control purposes, or for
       later processing by SEARCH, OFFLOAD, SEQLOAD or DELINK.

%   H +Display program history.
)INIT
)PROC
)END
./ ADD NAME=REVHP08
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    ! TYPE(TEXT) INTENS(LOW)  COLOR(BLUE) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Source Directory Display+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +

%AD.FILE182.PDS477 -----------------------------------------------------------
 Command ===>
¢   NAME       TTR   VV.MM  CREATED      CHANGED       INIT  SIZE   MOD   ID
!.+#PDSTBL   !009803+01.57!89-12-27+08-06-25!09:32:15+  134!  154+   22!TRIDJK
!.+#SPWRKA   !003304+01.00!04-12-01+04-12-01!11:32:29+   65!   65+    0!TRIDJK
!.+@ALIAS    !004B03+01.22!99-07-16+08-01-28!07:28:03+  158!  169+   24!TRIDJK
!.+@ATTRIB   !008603+01.86!98-01-15+08-05-21!07:24:07+ 1413! 1583+  238!TRIDJK
!.+@BROWSE   !00C703+01.13!99-07-16+08-12-22!08:17:23+  515!  522+   13!TRIDJK
!.+@CHANGE   !004B05+01.02!99-07-16+06-08-22!13:39:19+   35!   35+    1!TRIDJK
!.+@CLEAR    !008F04+01.03!99-07-16+08-05-21!08:36:15+   45!   45+    2!TRIDJK
!.+@COBANAL  !008503+01.99!01-02-01+08-01-28!07:28:53+ 1499!  637+  560!TRIDJK
!.+@COMPARE  !004B07+01.02!99-07-16+06-08-22!13:39:27+  207!  207+    1!TRIDJK
!.+@COMPRES  !005001+01.09!99-07-16+08-01-28!07:28:57+  406!  406+   11!TRIDJK
!.+@CONTROL  !00DD01+01.99!06-07-17+09-01-15!14:08:27+ 1117! 1199+  154!TRIDJK
!.+@COPY     !009301+01.27!01-02-01+08-05-21!10:52:50+ 1499! 1519+   48!TRIDJK
!.+@CPKMAP   !007E03+01.93!01-02-01+08-01-28!07:28:21+ 1499!  336+  224!TRIDJK
!.+@DELETE   !008A03+01.07!99-07-16+08-05-07!11:29:49+  375!  378+   27!TRIDJK
!.+@DELINK   !008301+01.99!01-02-01+08-01-28!07:28:07+ 1499!  465+  353!TRIDJK
!.+@DIACAX   !009001+01.39!98-08-11+08-05-21!08:37:27+  159!  251+  103!TRIDJK
!.+@DIACLN   !005104+01.01!99-07-16+06-09-01!09:14:58+   72!   89+   88!TRIDJK
!.+@DIAFIND  !00C101+01.43!97-08-29+08-11-25!15:12:26+ 1258! 1370+  236!TRIDJK
)INIT
)PROC
)END
./ ADD NAME=REVHP09
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    ! TYPE(TEXT) INTENS(LOW)  COLOR(GREEN) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Load Directory Display+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +

%AD.CMDLIB ----------------------------------------------------------------
 Command ===>
¢   NAME      SSI       SIZE   TTR   ALIAS-OF AC -- -- -- -ATTRIBUTES -- --
+. PDS4            21K 0050D8 001E0D          00 FO EP0      RF RN RU
 . PDS52           25K 006090 00270F          00 FO EP0      RF RN RU
 . PDS53           38K 009610 002809          00 FO EP0      RF RN RU
!. PDS60           52K 00CF28 002906          00 FO EP0      RF RN RU
!. PDS61           59K 00E948 002A0A          00 FO EP0      RF RN RU
+. PDS62           72K 011F88 002C06          00 FO EP0      RF RN RU
 . PDS63           76K 012DC0 002D08          00 FO EP0      RF RN RU
 . PDS70           92K 016CD8 002F06          00 FO EP0      RF RN RU
 . PDS71          110K 01B760 001F0C          00 FO EP0      RF RN RU
 . PDS72          132K 020DF8 003106          00 FO EP0   PG RF RN RU
 . PDS73          146K 0247C0 000A0E          00 FO EP0      RF RN RU
 . PDS80          168K 029E28 003408          00 FO EP0   PG RF RN RU
 . PDS81          180K 02CFD8 003809          00 FO EP0   PG RF RN RU
 . PDS82          181K 02D3A8 003C0C          00 FO EP0   PG RF RN RU
 . PDS83          216K 035E78 000306          00 FO EP0   PG RF RN RU
 . PDS84     CB319182  0367C8 004D04          00 FO EP0   PG RF RN RU
 . PDS85          241K 03C080 00F804          00 FO EP0   PG RF RN RU
 . PDS86          298K 04A418 029305          00 FO EP0   PG RF RN RU    TS
)INIT
)PROC
)END
./ ADD NAME=REVHP10
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    ! TYPE(TEXT) INTENS(LOW)  COLOR(GREEN) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW PDSE Load Directory Display+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +

%TRIDJK.PDSEU -------------------------------
 Command ===>
¢  RealName Alias-Name      Size AC AMd At RU V Non-0-EP Save-Timestamp User/Job
+. BLKDISK  SSI=CB346296    1B88              1
 . CDAEQED         501K    7D340    A64 NE RN 42d        07-12-17 13:25 TSC3901
 . COBANAL          40K     9D28 00 A31    RN 2          08-01-31 08:37 TRIDJK
 . DEX               6K     15E0              1
 . MFCTFSN  SSI=71900820     990           RN 2          07-07-09 14:20 TRIDJKA
 . MFCTMMD  SSI=71800820     4B8           RN 2          07-06-29 08:06 TRIDJK
!. PDS86    PDS            49E10 00     PG RF 2          08-08-27 07:59 TRIDJK
!. PDS86    PDSE           49E10 00     PG RF 2          08-08-27 07:59 TRIDJK
 . PDS86           296K    49E10 00     PG RF 2          08-08-27 07:59 TRIDJK
 . TEST2            26K     6600    A31       2          07-08-09 10:21 TRIDJK
 . TRSMAIN          82K    14558 00 ANY    RN 2          98-12-30 11:27 TRIDJK

¢  **END**        959K      393K:R=24                 2007-12-11 PERM69
)INIT
)PROC
)END
./ ADD NAME=REVHPDT
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Directory Display Information+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   Detailed information for the PDS/PDSE directory display is contained
   in the TSO HELP member¢REVPDS.+ This member resides in the SYSHELP
   concatenation.   Enter one of the following commands to view the HELP
   member in 3270 full screen mode.

     %TSO FSHELP REVPDS+
     %TSO HEL REVPDS+

)INIT
)PROC
)END
./ ADD NAME=REVHU00
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
    # TYPE(AB)    FORMAT(MIX)
    " TYPE(ABSL) GE(ON)
)ABC DESC('Help') MNEM(1)
PDC PDCTEXT('REVUNIX TSO full-screen help')
 ACTION RUN(TSO) PARM('HEL REVUNIX')
PDC PDCTEXT('About...')
 ACTION RUN(TUTOR) PARM('REVLOGO')
PDC PDCTEXT('REVIEW FAQ')
 ACTION RUN(TUTOR) PARM('REVFAQ')
)ABCINIT
.ZVARS=HELP
)BODY EXPAND(\\)
\ \# Help
%TUTORIAL+-\-\-¢REVIEW Directory Display Information+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +
+
%               ---------------------------------------------
%               |                   Unix                    |
%               |       Directory Display Information       |
%               ---------------------------------------------
+
   The following topics are presented in sequence or may be requested
   by number:
     %1+- Accessing entries
     %2+-¢REVIEW+directory display control
     %3+- Sorting directory entries
     %4+- Searching files
     %5+-¢REVIEW+session control
     %6+- Entry attribute flags
     %7+-¢REVIEW+entry selection action codes

   The following topics will be presented only if selected by number:
     %8+- Detailed Unix directory display information
)INIT
)PROC
  &ZSEL = TRANS(&ZCMD  1,REVHU01   2,REVHU02   3,REVHU03   4,REVHU04
                       5,REVHU05   6,REVHU06   7,REVHU07   8,*REVHUDT
                       *,'?')
)END
./ ADD NAME=REVHU01
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Accessing and Updating Entries+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Subcmd   Aliases  Function

%SELECT   S  SEL  +Choose an entry for¢REVIEW+and review it.

%BROWSE   B       +Choose a file for ISPF Browse and browse it.
                   An ISPF environment is required for this subcommand.

%EDIT     E       +Choose a file for ISPF Edit and edit it.
                   An ISPF environment is required for this subcommand.

%/pathname        +Jump directly to a path and¢REVIEW+it.



                   Note that the operand specifying the entry or file
                   is not automatically folded to upper case.

)INIT
)PROC
)END
./ ADD NAME=REVHU02
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Controlling the Display+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Subcmd   Aliases  Function

%DOWN             +Scroll down towards the bottom of the list.
%UP               +Scroll up towards the top of the list.
%BOTTOM           +Same as%DOWN MAX.+
%TOP              +Same as%UP MAX.+

%LOCATE LOC LIST L+Scroll the display to position the first entry name
                   (or ID name if SORT ID is in effect) starting with
                   the string matching the subcommand operand.

%IFIND    RFIND   +Scroll the display to position the next (or first)
                   tagged entry at the top of the display.

%TAGFLIP  TF      +Untag all tagged entries and tag all untagged entries.

%RESET    RES     +Untag all entries.

%REFRESH  REF     +Refresh the entry list from DASD.  Tags are discarded.
)INIT
)PROC
)END
./ ADD NAME=REVHU03
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Sorting the Entries+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Subcommand        Function

%SORT NAME        +Sort the list into ascending name order.

%SORT CHA         +Sort the list into descending change timestamp order.
%SORT MOD         +Sort the list into descending change timestamp order.

%SORT CRE         +Sort the list into descending create timestamp order.

%SORT ACC         +Sort the list into descending access timestamp order.

%SORT SIZE        +Sort the list into descending size order.

%SORT ID          +Sort the list into ascending owner name order.
%SORT OWNER       +Sort the list into ascending owner name order.
%SORT USER        +Sort the list into ascending owner name order.

)INIT
)PROC
)END
./ ADD NAME=REVHU04
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Searching Members+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Subcmd   Aliases  Function

%SEARCH   FIND  F +Causes the presentation of a data entry panel where the
                   search parameters are to be entered.

                   If any entries are tagged only tagged files are searched.

                   After the search, files with matching data will be
                   tagged, and will be the only entries tagged.
)INIT
)PROC
)END
./ ADD NAME=REVHU05
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Session Control+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Subcmd   Aliases  Function

%EXIT     END  =X +Terminate the¢REVIEW+session.
%CANCEL   CAN     +Terminate the¢REVIEW+session without updating your profile.

%SWAP LIST        +Display a list of parallel¢REVIEW+sessions.
%SWAP             +Swap to the second most recent¢REVIEW+session.
%SWAP #           +Swap to the¢REVIEW+session number%#+where%#+is a
                   decimal number which can be obtained from%SWAP LIST.+

%TSO      TSS     +Invoke the Command Processor named by the operand.
                   If the named command is¢REVIEW+a parallel session
                   is started.

)INIT
)PROC
)END
./ ADD NAME=REVHU06
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW UNIX Entry Attributes+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


            The first flag of the Mode Flags is the File Type.


             Flag  Indicated Attribute

               %d+ Directory
               %c+ Character Special file
               %-+ Regular file
               %p+ Named Pipe (FIFO) Special file
               %l+ Symbolic Link
               %b+ Block Special file
               %s+ Socket file
               %e+ External Link
               %n+ Non-Share Address Space program
               %A+ APF Authorised program
               %N+ APF Authorised and Non-Share AS
               %t+ Sticky bit on (shown as last flag of Mode Flags)

)INIT
)PROC
)END
./ ADD NAME=REVHU07
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Entry Selection Codes+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


 Code  Function

%   S +Browse the entry contents with¢REVIEW.+ This is the default
       selection code when the cursor is placed on the leader dot.

%   /+¢REVIEW+the entry contents with the%DATA+operand.

%   A+¢REVIEW+the entry contents - if a file treat as an
      %ASCII text+file.

%   B +Browse the regular file with ISPF Browse.
%   E +Edit the regular file with ISPF Edit.

%   R +Reset or untag the member.
%   T +Tag the member for display control purposes, or for
       later processing by SEARCH.

%   H +Display program history.
%   M +Display program map.
)INIT
)PROC
)END
./ ADD NAME=REVHUDT
)ATTR DEFAULT(%+_)
    % TYPE(TEXT) INTENS(HIGH) COLOR(WHITE) SKIP(ON)
    ¢ TYPE(TEXT) INTENS(HIGH) COLOR(YELLOW)
    + TYPE(TEXT) INTENS(LOW)  COLOR(TURQ) SKIP(ON)
    _ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED)
    ¬ TYPE(INPUT) INTENS(HIGH) CAPS(ON) JUST(LEFT) COLOR(RED) PAD(_)
    ¦ TYPE(INPUT) INTENS(HIGH) CAPS(OFF)
)BODY EXPAND(\\)
%TUTORIAL+-\-\-¢REVIEW Directory Display Information+-\-\-%TUTORIAL
%OPTION  ===>_ZCMD                                                             +


   Detailed information for the Unix directory display is contained
   in the TSO HELP member¢REVUNIX.+ This member resides in the SYSHELP
   concatenation.   Enter one of the following commands to view the HELP
   member in 3270 full screen mode.

     %TSO FSHELP REVUNIX+
     %TSO HEL REVUNIX+

)INIT
)PROC
)END
./ ADD NAME=REVLOGO
)ATTR
  ! TYPE(TEXT) COLOR(WHITE) HILITE(USCORE)
  { TYPE(NT)
  @ TYPE(ET)
  # TYPE(DT)
  | AREA(SCRL) EXTEND(ON)
)BODY CMD( ) WINDOW(60,10)
{     @Unlicensed Materials - Property of the Free World  {
{                                                         {
{     !http://www.cbttape.org/ftp/cbt/CBT134.zip+         {
{                                                         {
@      Weapon Masters present and past...
|S1                                                       |
)AREA S1
#        Greg Price
#        John Kalinich
#        Bruce Leland
#        Tony Watson
#        Bill Godfrey
)INIT
  &ZUP = REVLOGO
  &ZWINTTL = 'REVIEW Command'
  &ZCMD = ' '
  &CMD = ' '
)END
./ ADD NAME=REVPANEL
)PANEL KEYLIST(REVKEYL,REV)
)ATTR
   01  TYPE(CHAR)    INTENS(LOW)  COLOR(BLUE)
   02  TYPE(CHAR)    INTENS(LOW)  COLOR(RED)
   03  TYPE(CHAR)    INTENS(LOW)  COLOR(PINK)
   04  TYPE(CHAR)    INTENS(LOW)  COLOR(GREEN)
   05  TYPE(CHAR)    INTENS(LOW)  COLOR(TURQ)
   06  TYPE(CHAR)    INTENS(LOW)  COLOR(YELLOW)
   07  TYPE(CHAR)    INTENS(LOW)  COLOR(WHITE)
   11  TYPE(CHAR)    INTENS(LOW)  COLOR(BLUE)    HILITE(BLINK)
   12  TYPE(CHAR)    INTENS(LOW)  COLOR(RED)     HILITE(BLINK)
   13  TYPE(CHAR)    INTENS(LOW)  COLOR(PINK)    HILITE(BLINK)
   14  TYPE(CHAR)    INTENS(LOW)  COLOR(GREEN)   HILITE(BLINK)
   15  TYPE(CHAR)    INTENS(LOW)  COLOR(TURQ)    HILITE(BLINK)
   16  TYPE(CHAR)    INTENS(LOW)  COLOR(YELLOW)  HILITE(BLINK)
   17  TYPE(CHAR)    INTENS(LOW)  COLOR(WHITE)   HILITE(BLINK)
   21  TYPE(CHAR)    INTENS(LOW)  COLOR(BLUE)    HILITE(REVERSE)
   22  TYPE(CHAR)    INTENS(LOW)  COLOR(RED)     HILITE(REVERSE)
   23  TYPE(CHAR)    INTENS(LOW)  COLOR(PINK)    HILITE(REVERSE)
   24  TYPE(CHAR)    INTENS(LOW)  COLOR(GREEN)   HILITE(REVERSE)
   25  TYPE(CHAR)    INTENS(LOW)  COLOR(TURQ)    HILITE(REVERSE)
   26  TYPE(CHAR)    INTENS(LOW)  COLOR(YELLOW)  HILITE(REVERSE)
   27  TYPE(CHAR)    INTENS(LOW)  COLOR(WHITE)   HILITE(REVERSE)
   31  TYPE(CHAR)    INTENS(LOW)  COLOR(BLUE)    HILITE(USCORE)
   32  TYPE(CHAR)    INTENS(LOW)  COLOR(RED)     HILITE(USCORE)
   33  TYPE(CHAR)    INTENS(LOW)  COLOR(PINK)    HILITE(USCORE)
   34  TYPE(CHAR)    INTENS(LOW)  COLOR(GREEN)   HILITE(USCORE)
   35  TYPE(CHAR)    INTENS(LOW)  COLOR(TURQ)    HILITE(USCORE)
   36  TYPE(CHAR)    INTENS(LOW)  COLOR(YELLOW)  HILITE(USCORE)
   37  TYPE(CHAR)    INTENS(LOW)  COLOR(WHITE)   HILITE(USCORE)
   41  TYPE(CHAR)    INTENS(LOW)  COLOR(BLUE)    GE(ON)
   42  TYPE(CHAR)    INTENS(LOW)  COLOR(RED)     GE(ON)
   43  TYPE(CHAR)    INTENS(LOW)  COLOR(PINK)    GE(ON)
   44  TYPE(CHAR)    INTENS(LOW)  COLOR(GREEN)   GE(ON)
   45  TYPE(CHAR)    INTENS(LOW)  COLOR(TURQ)    GE(ON)
   46  TYPE(CHAR)    INTENS(LOW)  COLOR(YELLOW)  GE(ON)
   47  TYPE(CHAR)    INTENS(LOW)  COLOR(WHITE)   GE(ON)
   51  TYPE(CHAR)    INTENS(LOW)  COLOR(BLUE)    GE(ON) HILITE(BLINK)
   52  TYPE(CHAR)    INTENS(LOW)  COLOR(RED)     GE(ON) HILITE(BLINK)
   53  TYPE(CHAR)    INTENS(LOW)  COLOR(PINK)    GE(ON) HILITE(BLINK)
   54  TYPE(CHAR)    INTENS(LOW)  COLOR(GREEN)   GE(ON) HILITE(BLINK)
   55  TYPE(CHAR)    INTENS(LOW)  COLOR(TURQ)    GE(ON) HILITE(BLINK)
   56  TYPE(CHAR)    INTENS(LOW)  COLOR(YELLOW)  GE(ON) HILITE(BLINK)
   57  TYPE(CHAR)    INTENS(LOW)  COLOR(WHITE)   GE(ON) HILITE(BLINK)
   61  TYPE(CHAR)    INTENS(LOW)  COLOR(BLUE)    GE(ON) HILITE(REVERSE)
   62  TYPE(CHAR)    INTENS(LOW)  COLOR(RED)     GE(ON) HILITE(REVERSE)
   63  TYPE(CHAR)    INTENS(LOW)  COLOR(PINK)    GE(ON) HILITE(REVERSE)
   64  TYPE(CHAR)    INTENS(LOW)  COLOR(GREEN)   GE(ON) HILITE(REVERSE)
   65  TYPE(CHAR)    INTENS(LOW)  COLOR(TURQ)    GE(ON) HILITE(REVERSE)
   66  TYPE(CHAR)    INTENS(LOW)  COLOR(YELLOW)  GE(ON) HILITE(REVERSE)
   67  TYPE(CHAR)    INTENS(LOW)  COLOR(WHITE)   GE(ON) HILITE(REVERSE)
   71  TYPE(CHAR)    INTENS(LOW)  COLOR(BLUE)    GE(ON) HILITE(USCORE)
   72  TYPE(CHAR)    INTENS(LOW)  COLOR(RED)     GE(ON) HILITE(USCORE)
   73  TYPE(CHAR)    INTENS(LOW)  COLOR(PINK)    GE(ON) HILITE(USCORE)
   74  TYPE(CHAR)    INTENS(LOW)  COLOR(GREEN)   GE(ON) HILITE(USCORE)
   75  TYPE(CHAR)    INTENS(LOW)  COLOR(TURQ)    GE(ON) HILITE(USCORE)
   76  TYPE(CHAR)    INTENS(LOW)  COLOR(YELLOW)  GE(ON) HILITE(USCORE)
   77  TYPE(CHAR)    INTENS(LOW)  COLOR(WHITE)   GE(ON) HILITE(USCORE)
   0A  TYPE(DATAIN)  INTENS(LOW)  COLOR(GREEN)
   0B  TYPE(DATAIN)  INTENS(HIGH) COLOR(RED)
   0C  TYPE(DATAOUT) INTENS(LOW)  COLOR(BLUE)
   0D  TYPE(DATAOUT) INTENS(HIGH) COLOR(WHITE)
   $   TYPE(OUTPUT)  INTENS(HIGH) COLOR(WHITE) JUST(ASIS) CAPS(OFF)
   %   TYPE(TEXT)    INTENS(HIGH) COLOR(WHITE)
   +   TYPE(TEXT)    INTENS(LOW)
   _   TYPE(INPUT)   INTENS(HIGH) COLOR(RED) CAPS(OFF) JUST(LEFT) HILITE(USCORE)
   #   AREA(DYNAMIC) EXTEND(ON) SCROLL(ON)
)BODY WIDTH(&ZSCREENW) EXPAND(\\)
$REVLN1                        \ \
%Command ===>_ZCMD             \ \                            %Scroll ===>_REVS+
#REVBUF,REVSHDW  --------------\-\---------------------------------------------#
)INIT
 .HELP   = &REVHELP
 &ZHTOP  = &REVHELP
 .CURSOR = &REVCSR
 .CSRPOS = &REVPOS
 .ALARM = &REVALRM
)PROC
 &REVLVL = LVLINE(REVBUF)
 &REVCSR = .CURSOR
 &REVPOS = .CSRPOS
 &REVPFK = .PFKEY
)END
./ ADD NAME=REVPANL2
)PANEL KEYLIST(REVKEYL,REV)
)ATTR
   01  TYPE(CHAR)    INTENS(LOW)  COLOR(BLUE)
   02  TYPE(CHAR)    INTENS(LOW)  COLOR(RED)
   03  TYPE(CHAR)    INTENS(LOW)  COLOR(PINK)
   04  TYPE(CHAR)    INTENS(LOW)  COLOR(GREEN)
   05  TYPE(CHAR)    INTENS(LOW)  COLOR(TURQ)
   06  TYPE(CHAR)    INTENS(LOW)  COLOR(YELLOW)
   07  TYPE(CHAR)    INTENS(LOW)  COLOR(WHITE)
   11  TYPE(CHAR)    INTENS(LOW)  COLOR(BLUE)    HILITE(BLINK)
   12  TYPE(CHAR)    INTENS(LOW)  COLOR(RED)     HILITE(BLINK)
   13  TYPE(CHAR)    INTENS(LOW)  COLOR(PINK)    HILITE(BLINK)
   14  TYPE(CHAR)    INTENS(LOW)  COLOR(GREEN)   HILITE(BLINK)
   15  TYPE(CHAR)    INTENS(LOW)  COLOR(TURQ)    HILITE(BLINK)
   16  TYPE(CHAR)    INTENS(LOW)  COLOR(YELLOW)  HILITE(BLINK)
   17  TYPE(CHAR)    INTENS(LOW)  COLOR(WHITE)   HILITE(BLINK)
   21  TYPE(CHAR)    INTENS(LOW)  COLOR(BLUE)    HILITE(REVERSE)
   22  TYPE(CHAR)    INTENS(LOW)  COLOR(RED)     HILITE(REVERSE)
   23  TYPE(CHAR)    INTENS(LOW)  COLOR(PINK)    HILITE(REVERSE)
   24  TYPE(CHAR)    INTENS(LOW)  COLOR(GREEN)   HILITE(REVERSE)
   25  TYPE(CHAR)    INTENS(LOW)  COLOR(TURQ)    HILITE(REVERSE)
   26  TYPE(CHAR)    INTENS(LOW)  COLOR(YELLOW)  HILITE(REVERSE)
   27  TYPE(CHAR)    INTENS(LOW)  COLOR(WHITE)   HILITE(REVERSE)
   31  TYPE(CHAR)    INTENS(LOW)  COLOR(BLUE)    HILITE(USCORE)
   32  TYPE(CHAR)    INTENS(LOW)  COLOR(RED)     HILITE(USCORE)
   33  TYPE(CHAR)    INTENS(LOW)  COLOR(PINK)    HILITE(USCORE)
   34  TYPE(CHAR)    INTENS(LOW)  COLOR(GREEN)   HILITE(USCORE)
   35  TYPE(CHAR)    INTENS(LOW)  COLOR(TURQ)    HILITE(USCORE)
   36  TYPE(CHAR)    INTENS(LOW)  COLOR(YELLOW)  HILITE(USCORE)
   37  TYPE(CHAR)    INTENS(LOW)  COLOR(WHITE)   HILITE(USCORE)
   41  TYPE(CHAR)    INTENS(LOW)  COLOR(BLUE)    GE(ON)
   42  TYPE(CHAR)    INTENS(LOW)  COLOR(RED)     GE(ON)
   43  TYPE(CHAR)    INTENS(LOW)  COLOR(PINK)    GE(ON)
   44  TYPE(CHAR)    INTENS(LOW)  COLOR(GREEN)   GE(ON)
   45  TYPE(CHAR)    INTENS(LOW)  COLOR(TURQ)    GE(ON)
   46  TYPE(CHAR)    INTENS(LOW)  COLOR(YELLOW)  GE(ON)
   47  TYPE(CHAR)    INTENS(LOW)  COLOR(WHITE)   GE(ON)
   51  TYPE(CHAR)    INTENS(LOW)  COLOR(BLUE)    GE(ON) HILITE(BLINK)
   52  TYPE(CHAR)    INTENS(LOW)  COLOR(RED)     GE(ON) HILITE(BLINK)
   53  TYPE(CHAR)    INTENS(LOW)  COLOR(PINK)    GE(ON) HILITE(BLINK)
   54  TYPE(CHAR)    INTENS(LOW)  COLOR(GREEN)   GE(ON) HILITE(BLINK)
   55  TYPE(CHAR)    INTENS(LOW)  COLOR(TURQ)    GE(ON) HILITE(BLINK)
   56  TYPE(CHAR)    INTENS(LOW)  COLOR(YELLOW)  GE(ON) HILITE(BLINK)
   57  TYPE(CHAR)    INTENS(LOW)  COLOR(WHITE)   GE(ON) HILITE(BLINK)
   61  TYPE(CHAR)    INTENS(LOW)  COLOR(BLUE)    GE(ON) HILITE(REVERSE)
   62  TYPE(CHAR)    INTENS(LOW)  COLOR(RED)     GE(ON) HILITE(REVERSE)
   63  TYPE(CHAR)    INTENS(LOW)  COLOR(PINK)    GE(ON) HILITE(REVERSE)
   64  TYPE(CHAR)    INTENS(LOW)  COLOR(GREEN)   GE(ON) HILITE(REVERSE)
   65  TYPE(CHAR)    INTENS(LOW)  COLOR(TURQ)    GE(ON) HILITE(REVERSE)
   66  TYPE(CHAR)    INTENS(LOW)  COLOR(YELLOW)  GE(ON) HILITE(REVERSE)
   67  TYPE(CHAR)    INTENS(LOW)  COLOR(WHITE)   GE(ON) HILITE(REVERSE)
   71  TYPE(CHAR)    INTENS(LOW)  COLOR(BLUE)    GE(ON) HILITE(USCORE)
   72  TYPE(CHAR)    INTENS(LOW)  COLOR(RED)     GE(ON) HILITE(USCORE)
   73  TYPE(CHAR)    INTENS(LOW)  COLOR(PINK)    GE(ON) HILITE(USCORE)
   74  TYPE(CHAR)    INTENS(LOW)  COLOR(GREEN)   GE(ON) HILITE(USCORE)
   75  TYPE(CHAR)    INTENS(LOW)  COLOR(TURQ)    GE(ON) HILITE(USCORE)
   76  TYPE(CHAR)    INTENS(LOW)  COLOR(YELLOW)  GE(ON) HILITE(USCORE)
   77  TYPE(CHAR)    INTENS(LOW)  COLOR(WHITE)   GE(ON) HILITE(USCORE)
   0A  TYPE(DATAIN)  INTENS(LOW)  COLOR(GREEN)
   0B  TYPE(DATAIN)  INTENS(HIGH) COLOR(RED)
   0C  TYPE(DATAOUT) INTENS(LOW)  COLOR(BLUE)
   0D  TYPE(DATAOUT) INTENS(HIGH) COLOR(WHITE)
   $   TYPE(OUTPUT)  INTENS(HIGH) COLOR(WHITE) JUST(ASIS) CAPS(OFF)
   %   TYPE(TEXT)    INTENS(HIGH) COLOR(WHITE)
   +   TYPE(TEXT)    INTENS(LOW)
   _   TYPE(INPUT)   INTENS(HIGH) COLOR(RED) CAPS(OFF) JUST(LEFT) HILITE(USCORE)
   #   AREA(DYNAMIC) EXTEND(ON) SCROLL(ON)
)BODY WIDTH(&ZSCREENW) EXPAND(\\)
$REVLN1                        \ \
%Command ===>_ZCMD             \ \                            +
#REVBUF,REVSHDW  --------------\-\---------------------------------------------#
)INIT
 .HELP   = &REVHELP
 &ZHTOP  = &REVHELP
 .CURSOR = &REVCSR
 .CSRPOS = &REVPOS
 .ALARM = &REVALRM
)PROC
 &REVLVL = LVLINE(REVBUF)
 &REVCSR = .CURSOR
 &REVPOS = .CSRPOS
 &REVPFK = .PFKEY
)END
@@
//RFEPLIBX EXEC XMIT,DSN=RFEPLIB
//*
//* Add #001JCL to MVP.STAGING
//*
//ADD01JCL EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=MVP.STAGING,DISP=SHR
//SYSUT1   DD  DATA,DLM='><'
./ ADD NAME=#001JCL
//#001JCL JOB (TSO),
//             'Install ISPF',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1)
//* ----- CLEAN UP -----
//CLEANUP EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE SYSGEN.ISPF.DOC SCRATCH PURGE
  DELETE SYSGEN.ISPF.LLIB SCRATCH PURGE
  DELETE SYSGEN.ISPF.PLIB SCRATCH PURGE
  DELETE SYSGEN.ISPF.RFEPLIB SCRATCH PURGE
  DELETE SYSGEN.ISPF.MLIB SCRATCH PURGE
  DELETE SYSGEN.ISPF.SLIB SCRATCH PURGE
  DELETE SYSGEN.ISPF.TLIB SCRATCH PURGE
  DELETE SYSGEN.ISPF.CLIB SCRATCH PURGE
  SET MAXCC=0
  SET LASTCC=0
//*
//* RECV370 Proc 
//*
//RECV    PROC DSN=LLIB
//* ---- RECEIVE ----
//RECVJCL EXEC PGM=RECV370
//STEPLIB  DD  DISP=SHR,DSN=SYSC.LINKLIB
//XMITIN   DD  DSN=MVP.WORK(&DSN),DISP=SHR
//RECVLOG  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//* Work temp dataset
//SYSUT1   DD  DSN=&&SYSUT1,
//             VOL=SER=PUB001,
//             UNIT=3390,
//             SPACE=(CYL,(8,4),RLSE),
//             DISP=(,DELETE)
//* Output dataset
//SYSUT2   DD  DISP=(NEW,CATLG),
//             DSN=SYSGEN.ISPF.&DSN,
//             DCB=SYS1.MACLIB,
//             SPACE=(CYL,(2,0,20),RLSE),
//             UNIT=SYSDA,
//             VOL=SER=PUB001
//         PEND
//* ***************************
//DOC      EXEC RECV,DSN=DOC
//MLIB     EXEC RECV,DSN=MLIB
//PLIB     EXEC RECV,DSN=PLIB
//RFEPLIB  EXEC RECV,DSN=RFEPLIB
//* ---- RECEIVE LOADLIB ----
//RECVLOAD EXEC PGM=RECV370
//STEPLIB  DD  DISP=SHR,DSN=SYSC.LINKLIB
//XMITIN   DD  DSN=MVP.WORK(LLIB),DISP=SHR
//RECVLOG  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//* Work temp dataset
//SYSUT1   DD  DSN=&&SYSUT1,
//             VOL=SER=PUB001,
//             UNIT=3390,
//             SPACE=(CYL,(8,4),RLSE),
//             DISP=(,DELETE)
//* Output dataset
//SYSUT2   DD  DISP=(NEW,CATLG),
//             DSN=SYSGEN.ISPF.LLIB,
//             SPACE=(CYL,(2,0,20),RLSE),
//             UNIT=SYSDA,
//             VOL=SER=PUB001,
//             DCB=(RECFM=U,BLKSIZE=19069)
//* ***************************
//* Create empty DSNs
//* I'm not sure we need these
//* But they're in the original Wally ISPF
//* And they get allocated in the CLIST provided by Wally
//*
//SYS2EXEC EXEC PGM=IEFBR14
//SLIB     DD DSN=SYSGEN.ISPF.SLIB,DISP=(,CATLG),
//         VOL=SER=PUB001,UNIT=SYSDA,SPACE=(CYL,(2,0,20),RLSE)
//SLIB     DD DSN=SYSGEN.ISPF.TLIB,DISP=(,CATLG),
//         VOL=SER=PUB001,UNIT=SYSDA,SPACE=(CYL,(2,0,20),RLSE)
//CLIB     DD DSN=SYSGEN.ISPF.CLIB,DISP=(,CATLG),
//         VOL=SER=PUB001,UNIT=SYSDA,SPACE=(CYL,(2,0,20),RLSE)
//*
//* Add ISPF CLIST to SYS1.CMDPROC
//*
//CLIST    EXEC PGM=IEBGENER
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD DUMMY
//SYSUT2   DD  DSN=SYS1.CMDPROC(ISPF),DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
PROC  0
/*     ALLOCATE REQUIRED ISPF DD NAMES     */
ALLOC F(ISPCLIB) DA('SYSGEN.ISPF.CLIB','SYSGEN.REVIEW.CLIST') SHR
ALLOC F(ISPLLIB) DA('SYSGEN.ISPF.LLIB','SYSGEN.REVIEW.LOAD') SHR
ALLOC F(ISPMLIB) DA('SYSGEN.ISPF.MLIB') SHR
ALLOC F(ISPPLIB) DA('SYSGEN.ISPF.PLIB','SYSGEN.ISPF.RFEPLIB') SHR
ALLOC F(ISPSLIB) DA('SYSGEN.ISPF.SLIB') SHR
ALLOC F(ISPTABL) DA('SYSGEN.ISPF.TLIB') SHR
ALLOC F(ISPTLIB) DA('SYSGEN.ISPF.TLIB') SHR
/* CREATE USERID.ISP.PROF IF IT DOES NOT EXIST  */   
IF &SYSDSN('&SYSUID..ISP.PROF') NE &STR(OK) THEN DO
    /* Create the DCB info */
    ATTRIB PROFS BLKSIZE(3120) LRECL(80) DSORG(PO) RECFM(F,B)
    /* Allocate the dataset */
    ALLOC DSNAME('&SYSUID..ISP.PROF') CYLINDERS SPACE(1,0) DIR(10) +
    VOLUME(PUB001) UNIT(3390) USING(PROFS) NEW
    /* Free the dcb info */
    FREE ATTRLIST(PROFS)
END
/* Allocate user profiles */
ALLOC F(ISPPROF) DA('&SYSUID..ISP.PROF') SHR
ALLOC F(REVPROF) DA('&SYSUID..ISP.PROF') SHR
/* Launch ISPF */
CALL 'SYSGEN.ISPF.LLIB(ISPF)'
FREE  F(ISPCLIB,ISPLLIB,ISPMLIB,ISPPLIB,ISPSLIB,ISPTABL,ISPTLIB)
FREE  F(ISPPROF,REVPROF)
@@
//*
//* Apply ISPMAINT
//*
//IMASPZAP EXEC PGM=IMASPZAP,PARM=IGNIDRFULL
//SYSLIB   DD   DSN=SYSGEN.ISPF.LLIB,DISP=SHR
//SYSPRINT DD   SYSOUT=*
//SYSIN    DD   *
*
*--------------------*
* UPGRADE VERSION ID *
*--------------------*
*
 NAME ISPF     ISPVERSN
 REP 05  F0F0F0
//*
//* Install ACETEST
//*
//ACEINST    EXEC PGM=IEBCOPY
//SYSPRINT DD   SYSOUT=*
//ISPLLIB  DD   DSN=SYSGEN.ISPF.LLIB,DISP=SHR
//ACEAPF   DD   DSN=SYS2.LINKLIB,DISP=SHR
//SYSIN    DD   *
 C I=ISPLLIB,O=ACEAPF
 S M=ACEABEND
 S M=ACEBREAK
 S M=ACELMAN
 S M=ACETEST
//*
//* Add ACEAUTH to SYS2.PROCLIB and SYS2.PARMLIB
//*
//ACEAUTH  EXEC PGM=IEBGENER
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//SYSUT2   DD  DSN=SYS2.PROCLIB(ACEAUTH),DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
//*
//* This proc must be run once after every IPL to activate the APF-
//* Authorized features of ACETEST. If this job is not run, ACETEST
//* will still operate, but in a limited manner.
//*
//* Either use /S ACEAUTH from MVS console or submit a job
//* with //ACEAUTH EXEC ACEAUTH as the only step
//*
//ACETEST  EXEC PGM=ACETEST,PARM='ACEAUTH'
//STEPLIB  DD   DSN=SYS2.LINKLIB,DISP=SHR
//SYSUDUMP DD   SYSOUT=*
//ACEAUTH  DD   DSN=SYS2.PARMLIB(ACEAUTH),DISP=SHR
@@
//ACEAUTH  EXEC PGM=IEBGENER
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//SYSUT2   DD  DSN=SYS2.PARMLIB(ACEAUTH),DISP=SHR
//SYSUT1   DD  *
END
><
//*
//* Outputs the resulting XMI file to SYSPUNCH
//*
//XMITLLIB EXEC PGM=XMIT370
//STEPLIB  DD DSN=SYSC.LINKLIB,DISP=SHR
//XMITLOG  DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//SYSUT1   DD DSN=MVP.STAGING,DISP=SHR
//SYSUT2   DD DSN=&&SYSUT2,UNIT=SYSDA,
//         SPACE=(TRK,(255,255)),
//         DISP=(NEW,DELETE,DELETE)
//XMITOUT  DD SYSOUT=B

