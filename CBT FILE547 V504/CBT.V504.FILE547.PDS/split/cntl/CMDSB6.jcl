//HERC01  JOB  (MVS),
//             'INSTALL # SUBSYS',
//             CLASS=A,
//*            RESTART=UPD1,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*                                                                  *
//* NAME: SYS1.SETUP.CNTL(CMDSB6)                                    *
//*                                                                  *
//* DESC: This job prints the CMDSBSYS documentation and creates     *
//*       the needed procedures in SYS1.PROCLIB                      *
//*                                                                  *
//*       Finally, it adds one line to SYS1.PARMLIB(COMMND00)        *
//*         COM='S CMD1'                                             *
//*                                                                  *
//********************************************************************
//DMASM   PROC MEMBER=,
//             LNCT=55,
//             ASMLIB='CBT249.FILE266',
//             LINKLIB='CBT.CMDSBSYS.LINKLIB'
//ASM     EXEC PGM=IEUASM,PARM=(LOAD,NODECK,'LINECNT=&LNCT.')
//SYSLIB   DD  DISP=SHR,DSN=&ASMLIB,DCB=BLKSIZE=32720
//         DD  DISP=SHR,DSN=SYS1.HASPSRC
//         DD  DISP=SHR,DSN=SYS1.MACLIB
//         DD  DISP=SHR,DSN=SYS1.AMODGEN
//SYSUT1   DD  UNIT=SYSDA,SPACE=(TRK,(90,50))
//SYSUT2   DD  UNIT=SYSDA,SPACE=(TRK,(90,50))
//SYSUT3   DD  UNIT=SYSDA,SPACE=(TRK,(90,50))
//SYSPRINT DD  SYSOUT=*
//SYSGO    DD  UNIT=VIO,SPACE=(TRK,(90,50)),
//             DISP=(,PASS)
//SYSIN    DD  DSN=&ASMLIB.(&MEMBER.),DISP=SHR
//LKED    EXEC PGM=IEWL,
//             PARM='XREF,LET,LIST,AC=1,SIZE=(140K,6400)'
//SYSLIN   DD  DSN=*.ASM.SYSGO,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSIN
//SYSLIB   DD  DISP=SHR,DSN=&LINKLIB.
//SYSLMOD  DD  DISP=SHR,DSN=&LINKLIB.(&MEMBER.)
//SYSUT1   DD  UNIT=VIO,SPACE=(TRK,(50,20))
//SYSPRINT DD  SYSOUT=*
//        PEND
//ASMPR   EXEC DMASM,MEMBER=CMDPRINT
//DOCCMD1 EXEC PGM=CMDPRINT,PARM='01072'
//STEPLIB  DD  DISP=SHR,DSN=CBT.CMDSBSYS.LINKLIB
//SYSPRINT DD  SYSOUT=A
//SYSUDUMP DD  SYSOUT=A
#$#
                    VERSION
             $DOC         .COMMAND SUB-SYSTEM -   (ADDIT DOCUMENTATION)
             $HELP        .COMMAND SUB-SYSTEM -   (TSO HELP MEMBER)
             $HINTS       .COMMAND SUB-SYSTEM -   (ADDIT INSTALL HINTS)
             $JCL         .COMMAND SUB-SYSTEM -   (JCL TO RUN CMD1)
             $MODS        .COMMAND SUB-SYSTEM -   (MVSMODS IEBCOPY)
             CMDDOCTN     .COMMAND SUB-SYSTEM -   (DOCUMENTATION)
             CMDDUMMY     .COMMAND SUB-SYSTEM -   (CMDDUMMY MODULE)
             CMDINSTL     .COMMAND SUB-SYSTEM -   (INSTALLATION JCL)
             CMDPRINT     .COMMAND SUB-SYSTEM -   (DOCUMENTATION PRINT)
             CMDSBCSC     .COMMAND SUB-SYSTEM -   (CROSS-SYSTEM CNTRL)
             CMDSBINT     .COMMAND SUB-SYSTEM -   (INIT AND MONITOR)
             CMDSBMON     .COMMAND SUB-SYSTEM -   (STANDALONE MONITOR)
             CMDSBSYS     .COMMAND SUB-SYSTEM -   (PROCESSOR)
             CMDSBTSO     .COMMAND SUB-SYSTEM -   (TSO FULL SCREEN MON)
             CMDTSO       .COMMAND SUB-SYSTEM -   (TSO DIRECTOR)
             CSCGA03D     .COMMAND SUB-SYSTEM -   (A - ACTIVITY MON.)
             CSCGE03D     .COMMAND SUB-SYSTEM -   (E - EXCEPTION MON.)
             CSCGF03D     .COMMAND SUB-SYSTEM -   (F - FRAME USE GRAPH)
             CSCGH03D     .COMMAND SUB-SYSTEM -   (H - HELP FOR GRAPH)
             CSCGI03D     .COMMAND SUB-SYSTEM -   (I - JES2 INIT DISP)
             CSCGJ03D     .COMMAND SUB-SYSTEM -   (J - JOB CPU GRAPH)
             CSCGO03D     .COMMAND SUB-SYSTEM -   (O - I/O ACTIVITY)
             CSCGQ03D     .COMMAND SUB-SYSTEM -   (Q - QUE)
             CSCGS03D     .COMMAND SUB-SYSTEM -   (S - SYS. IND. GRAPH)
             CSCGU03D     .COMMAND SUB-SYSTEM -   (U -DASD SPACE DISPL)
CSCSA03D     IEESA03D     .COMMAND SUB-SYSTEM -   (#N -  D ENQ P1)
CSCSB03D     IEESB03D     .COMMAND SUB-SYSTEM -   (#N -  D ENQ P2)
CSCSC03D     IEESC03D     .COMMAND SUB-SYSTEM -   (#L -  D LINES)
CSCSD03D     IEESD03D     .COMMAND SUB-SYSTEM -   (#D -  COREZAP)
CSCSE03D     IEESE03D     .COMMAND SUB-SYSTEM -   (#A -  ASCB INFO)
CSCSF03D     IEESF03D     .COMMAND SUB-SYSTEM -   (#F -  D FRAMES)
CSCSG03D     IEESG03D     .COMMAND SUB-SYSTEM -   (#R -  D ALLOC)
CSCSH03D     IEESH03D     .COMMAND SUB-SYSTEM -   (#S -  D LPA)
CSCSI03D     IEESI03D     .COMMAND SUB-SYSTEM -   (#V -  D DEVICE)
CSCSJ03D     IEESJ03D     .COMMAND SUB-SYSTEM -   (#I -  D PAGES)
CSCSK03D     IEESK03D     .COMMAND SUB-SYSTEM -   (#C -  CALCULATOR)
CSCSL03D     IEESL03D     .COMMAND SUB-SYSTEM -   (#J -  D A)
CSCSZ03D     IEESZ03D     .COMMAND SUB-SYSTEM -   (#Z -  D A)
CSCSM03D     IEESM03D     .COMMAND SUB-SYSTEM -   (#H -  HELP)
CSCSN03D     IEESN03D     .COMMAND SUB-SYSTEM -   (#T -  D TIOT)
CSCSO03D     IEESO03D     .COMMAND SUB-SYSTEM -   (#M -  TSO SEND)
CSCSP0ED     IEESP03D     .COMMAND SUB-SYSTEM -   (#P -  D SU)
CSCSQ03D     IEESQ03D     .COMMAND SUB-SYSTEM -   (#Q -  ANALYZE ENQ)
CSCSR03D     IEESR03D     .COMMAND SUB-SYSTEM -   (#O -  I/O PENDING)
CSCSS03D     IEESS03D     .COMMAND SUB-SYSTEM -   (#E -  EXECUTE)
CSCZA03D     IEEZA03D     .COMMAND SUB-SYSTEM -   (##A -  ACTIVITY MON.)
CSCZB03D     IEEZB03D     .COMMAND SUB-SYSTEM -   (##B -  DEVICE MON.)
CSCZC03D     IEEZC03D     .COMMAND SUB-SYSTEM -   (##C -  CHANNEL MON.)
CSCZJ03D     IEEZJ03D     .COMMAND SUB-SYSTEM -   (##J -  JOB MON.)
CSCZP03D     IEEZP03D     .COMMAND SUB-SYSTEM -   (##P -  PAGING MON.)
CSCZS03D     IEEZS03D     .COMMAND SUB-SYSTEM -   (##S -  SYSIND MON.)
             NSEGF03D     .CMD SUB-SYS (NONSE) -  (F - FRAME USE GRAPH)
             NSEGJ03D     .CMD SUB-SYS (NONSE) -  (J - JOB CPU GRAPH)
             NSEGS03D     .CMD SUB-SYS (NONSE) -  (S - SYS. IND. GRAPH)
             NSESE03D     .CMD SUB-SYS (NONSE) -  (#A -  ASCB INFO)
             NSESJ03D     .CMD SUB-SYS (NONSE) -  (#I -  D PAGES)
             NSESL03D     .CMD SUB-SYS (NONSE) -  (#J -  D A)
             NSEZJ03D     .CMD SUB-SYS (NONSE) -  (##J -  JOB MON.)
             NSEZS03D     .CMD SUB-SYS (NONSE) -  (##S -  SYSIND MON.)
#$#
             MACROS VERSION  FOR CMDSBMON
             ALLOC    1.0 .MACRO NEEDED FOR CMDSBMON
             DYNSPACE 1.0 .MACRO NEEDED FOR CMDSBMON
             FREE     1.0 .MACRO NEEDED FOR CMDSBMON
             RCPBFRGS 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPBTU   1.0 .MACRO NEEDED FOR CMDSBMON
             RCPBTU2  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPCKID  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPDDN   1.0 .MACRO NEEDED FOR CMDSBMON
             RCPDDNRT 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPDEBUG 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPDFPL  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPDINC  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPDISP  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPDS    1.0 .MACRO NEEDED FOR CMDSBMON
             RCPDSECT 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPDSN   1.0 .MACRO NEEDED FOR CMDSBMON
             RCPDSNPD 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPDSNRT 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPDSRGR 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPDUMMY 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPENDD  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPFDDN  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPFDISP 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPFDSN  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPFHOLD 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPFORUS 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPFREE  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPIOPL  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPLINK  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPLOAD  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPLOCSW 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPLOCS1 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPLOCS2 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPMCA   1.0 .MACRO NEEDED FOR CMDSBMON
             RCPNTU   1.0 .MACRO NEEDED FOR CMDSBMON
             RCPPERM  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPPPL   1.0 .MACRO NEEDED FOR CMDSBMON
             RCPPROC  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPPSWD  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPQNAME 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPRNGE  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPSPACE 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPSPEC  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPSR2   1.0 .MACRO NEEDED FOR CMDSBMON
             RCPSSREQ 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPSUBL  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPSYSOU 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPTU    1.0 .MACRO NEEDED FOR CMDSBMON
             RCPTUBFR 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPTXTL  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPTYPE  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPUNALC 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPUNIT  1.0 .MACRO NEEDED FOR CMDSBMON
             RCPVCHAR 1.0 .MACRO NEEDED FOR CMDSBMON
             RCPVOLRT 1.0 .MACRO NEEDED FOR CMDSBMON
             S99FAIL  1.0 .MACRO NEEDED FOR CMDSBMON
#$#
                   VERSION
             CSCGQQ00 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - QUEUECMN)
             CSCGQQ01 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - QUEUE)
             CSCGQQ02 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - ALLOCATE)
             CSCGQQ03 1.1 .CMD SUB-SYSTEM -       (Q - QCMD - CKPT)
             CSCGQQ04 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - DDNAME)
             CSCGQQ05 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - DISPLAY)
             CSCGQQ05 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - DISPLAY)
             CSCGQQ06 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - FINDJOB)
             CSCGQQ07 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - FORMAT)
             CSCGQQ08 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - HELP)
             CSCGQQ09 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - HEXBLK)
             CSCGQQ10 1.1 .CMD SUB-SYSTEM -       (Q - QCMD - INIT)
             CSCGQQ11 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - JCL)
             CSCGQQ12 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - JLOG)
             CSCGQQ13 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - JMSG)
             CSCGQQ14 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - LIST)
             CSCGQQ15 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - LISTDS)
             CSCGQQ16 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - PARSE)
             CSCGQQ17 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - READSPC)
             CSCGQQ18 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - REPOS)
             CSCGQQ19 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - SAVE)
             CSCGQQ20 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - SEARCH)
             CSCGQQ21 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - SYSLOG)
             CSCGQQ22 1.0 .CMD SUB-SYSTEM -       (Q - QCMD - XDS)
#$#
                   VERSION
             MACROS VERSION  FOR THE QUE COMMAND
             $JQT     1.0 .MACRO NEEDED FOR QUEUE
             QCLNK    1.0 .MACRO NEEDED FOR QUEUE
             QCOMMON  1.1 .MACRO NEEDED FOR QUEUE
             QSTART   1.1 .MACRO NEEDED FOR QUEUE
             QSTOP    1.0 .MACRO NEEDED FOR QUEUE
             QTILT    1.0 .MACRO NEEDED FOR QUEUE
/*
//DOCCMD2 EXEC PGM=CMDPRINT,PARM='01072'
//STEPLIB  DD  DISP=SHR,DSN=CBT.CMDSBSYS.LINKLIB
//SYSPRINT DD  SYSOUT=A
//SYSUDUMP DD  SYSOUT=*
//SYSIN    DD  DISP=SHR,DSN=CBT249.FILE266(CMDDOCTN)
//UPD1    EXEC PGM=IEBUPDTE,PARM=NEW
//SYSPRINT DD SYSOUT=*
//SYSUT2   DD DSN=SYS2.PROCLIB,DISP=SHR
//SYSIN  DD  DATA
