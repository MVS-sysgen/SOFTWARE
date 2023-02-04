//SRMAP   JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=2000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//TESTMSD EXEC KIKMAPS,MAPNAME=TESTMSD
//COPY.SYSUT1 DD *
TESTMSD  KIKMSD MODE=INOUT,CTRL=(FREEKB,FRSET),STORAGE=AUTO
*
TESTM24  KIKMDI SIZE=(24,80)
         KIKMDF POS=(10,25),LENGTH=32,                                 *
               INITIAL='Test map (24) for SRMAP API demo'
         KIKMDF POS=(13,30),LENGTH=14,                                 *
               INITIAL='Numeric field '
NUM24    KIKMDF POS=(13,45),LENGTH=6,ATTRB=(NUM,IC,FSET)
         KIKMDF POS=(15,30),LENGTH=14,                                 *
               INITIAL='  Alpha field '
ALPHA24  KIKMDF POS=(15,45),LENGTH=6,ATTRB=(FSET)
ERR24    KIKMDF POS=(23,30),LENGTH=20,INITIAL=''
*
TESTM43  KIKMDI SIZE=(43,80)
         KIKMDF POS=(22,25),LENGTH=32,                                 *
               INITIAL='Test map (43) for SRMAP API demo'
         KIKMDF POS=(25,30),LENGTH=14,                                 *
               INITIAL='Numeric field '
NUM43    KIKMDF POS=(25,45),LENGTH=6,ATTRB=(NUM,IC,FSET)
         KIKMDF POS=(27,30),LENGTH=14,                                 *
               INITIAL='  Alpha field '
ALPHA43  KIKMDF POS=(27,45),LENGTH=6,ATTRB=(FSET)
ERR43    KIKMDF POS=(42,30),LENGTH=20,INITIAL=''
*
         KIKMSD TYPE=FINAL
         END
/*
//LINKMAP.SYSLMOD DD DSN=&&GOSET(&MAPNAME),DISP=(,PASS),UNIT=SYSDA,
// SPACE=(1024,(50,20,5))
//COBMAP.SYSPRINT DD DSN=&&COBLIB(&MAPNAME),DISP=(,PASS),UNIT=SYSDA,
// SPACE=(CYL,(1,1,10)),DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120)
//GCCMAP.SYSPRINT DD DUMMY,DCB=BLKSIZE=160
//*
//*NOTE deliberate use of KIKCOBCL instead of K2KCOBCL below.
//*     This is so the JCL will also work when it's 'converted'
//*     to z/OS by changing the procname to KIKCB2CL, which
//*     does not have PP1 & COB1 steps.
//*     Of course this also means the following program can't
//*     use implied (or explicit) 'LENGTH OF'...
//*
//TESTCOB EXEC PROC=KIKCOBCL,
//             COND=(5,LE,TESTMSD.LINKMAP)
//COPY.SYSUT1 DD *
       ID DIVISION.
       PROGRAM-ID. TESTCOB.

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

      * EXEC KICKS SEND MAP(NAME) MAPSET(NAME)
      *       [FROM(DATA-AREA)]
      *       [ERASEAUP] [ERASE] [ALARM] [FREEKB] [FRSET]
      *       [MAPONLY] [DATAONLY]
      *       [ALTERNATE] [DEFAULT]
      *       [CURSOR(DATA-VALUE)]
      * END-EXEC.
      *
      * EXEC KICKS RECEIVE MAP(NAME) MAPSET(NAME)
      *       [INTO(DATA-AREA)]
      *       [ASIS]
      * END-EXEC.

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN    PIC X(24) VALUE 'TESTCOB  WORKING STORAGE'.
       77  WS-ERRCNT   PIC S9(4) COMP VALUE +0.

       COPY TESTMSD.

       COPY KIKAID.

       PROCEDURE DIVISION.

      * initialize map storage
           MOVE LOW-VALUES TO TESTM24O.

       RESTART-IT.

      * Note that even thou the mapset defines two maps - one
      * with 24 lines, the other with 43 - this program is run
      * in batch under the sequential terminal (CRLP) so only
      * the 24 line version is applicable...

      * Put another way, the CRLP's primary and alternate
      * screen sizes are the same, both 24x80...

      * send initial map, then clear err msg (whole map really)
           EXEC KICKS SEND
                 MAP('TESTM24') MAPSET('TESTMSD')
                 ERASE
           END-EXEC.
           MOVE LOW-VALUES TO TESTM24O.

      * get a response
      *  - don't need to clear input area as it overlays
      *  -       the output area cleared just above...
           EXEC KICKS RECEIVE
                 MAP('TESTM24') MAPSET('TESTMSD')
                 ASIS NOHANDLE
           END-EXEC.

      * if bad response
      *    - sound alarm using send control
      *    - loop back to send err msg & re-read (up to 5 times)
           IF EIBRESP NOT EQUAL DFHRESP(NORMAL) THEN
               EXEC KICKS SEND CONTROL ALARM END-EXEC
               MOVE 'BAD RESPONSE' TO ERR24O
               ADD +1 TO WS-ERRCNT
               IF WS-ERRCNT < 5 GO TO RESTART-IT.

      * if good response
      *    - send screen with input back so visible on crlp...
           EXEC KICKS SEND
                 MAP('TESTM24') MAPSET('TESTMSD')
                 ERASE
           END-EXEC.

           EXEC KICKS RETURN END-EXEC.
/*
//PP2.SYSLIB  DD
//            DD
//            DD DSN=&&COBLIB,DISP=(OLD,PASS)
//COB2.SYSLIB DD
//            DD
//            DD DSN=&&COBLIB,DISP=(OLD,PASS)
//LKED.SYSLMOD DD DSN=&&GOSET(TESTCOB),UNIT=SYSDA,
//     DISP=(MOD,PASS)
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKCOBGL)
 ENTRY TESTCOB
 NAME  TESTCOB(R)
/*
//GO EXEC PGM=KIKSIP1$,COND=(4,LT,TESTCOB.LKED),
//   REGION=2000K,TIME=1,
//   PARM='SIT=B$ ICVR=0 '
//* kiksip1$ comes from steplib...
//STEPLIB  DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//* tables come from skikload...
//SKIKLOAD DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//* programs & maps come from kikrpl...
//KIKRPL   DD DSN=&&GOSET,DISP=(OLD,DELETE),
//         DCB=BLKSIZE=32000
//         DD DSN=K.S.V1R5M0.KIKRPL,DISP=SHR
//*
//SYSPRINT DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=80)
//SYSTERM  DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=80)
//SYSOUT   DD SYSOUT=*,DCB=BLKSIZE=132
//CRLPOUT  DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=132)
//TRANDUMP DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=132)
//SYSUDUMP DD SYSOUT=*
//*
//AUXTRC   DD SYSOUT=*,DCB=(RECFM=V,BLKSIZE=2000)
//*
//SYSIN    DD DUMMY,DCB=(RECFM=F,BLKSIZE=80)
//*
//CRLPIN   DD *,DCB=BLKSIZE=80
TCOB<ENTER>
999<TAB>
AAA<ENTER>
/*
//
