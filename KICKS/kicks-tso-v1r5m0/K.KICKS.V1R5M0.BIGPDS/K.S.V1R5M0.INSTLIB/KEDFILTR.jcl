//KEDFILTR JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1)
//*
//ASM      EXEC PGM=IFOX00,PARM='DECK,NOLIST'
//*                 ASMA90             FOR Z/OS
//SYSLIB   DD DSN=SYS1.MACLIB,DISP=SHR
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSUT2   DD UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSUT3   DD UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSPRINT DD SYSOUT=*
//SYSLIN   DD DUMMY
//SYSPUNCH DD DSN=&&OBJSET,
//         UNIT=SYSDA,SPACE=(80,(200,200)),
//         DISP=(,PASS)
//SYSGO    DD DDNAME=SYSLIN
//SYSIN    DD *
*/////////////////////////////////////////////////////////////////////
*//   KICKS is an enhancement for TSO that lets you run your CICS
*//   applications directly in TSO instead of having to 'install'
*//   those apps in CICS.
*//   You don't even need CICS itself installed on your machine!
*//
*//   KICKS for TSO
*//   © Copyright 2008-2014, Michael Noel, All Rights Reserved.
*//
*//   Usage of 'KICKS for TSO' is in all cases subject to license.
*//   See http://www.kicksfortso.com
*//   for most current information regarding licensing options..
*////////1/////////2/////////3/////////4/////////5/////////6/////////7
*
* This is a filter for KEDF. For each pair of half words, the first is
* the eibfn, the 2nd a flag the says if KEDF should break for this
* condition (0=break, 1=skip it). The table ends with eibfn=0.
*
* The table is loaded once (on first use of KEDF) and may hereafter
* be modified in memory by KEDFPGM, but such changes are never saved
* so it will always be back to this when KICKS is restarted.
*
* KEDFPGM cares about the order, so don't change it!!
*
KEDFILTR START 0
 DC X'01050000' v1r5m0(0)            not table entry, VRM for table!
*
 DC H'514,0'    ADDRESS           1
 DC H'516,1'    HANDLE CONDITION  2  off 'cause they're a pain in the
 DC H'518,1'    HANDLE AID        3  TAC example, and to demo on/off
 DC H'520,0'    ASSIGN            4
 DC H'522,0'    IGNORE CONDITION  5
 DC H'1026,0'   RECEIVE           6
 DC H'1538,0'   READ              7
 DC H'1540,0'   WRITE             8
 DC H'1542,0'   REWRITE           9
 DC H'1544,0'   DELETE           10
 DC H'1546,0'   UNLOCK           11
 DC H'1548,0'   STARTBR          12
 DC H'1550,0'   READNEXT         13
 DC H'1552,0'   READPREV         14
 DC H'1554,0'   ENDBR            15
 DC H'1556,0'   RESETBR          16
 DC H'2050,0'   WRITEQ TD        17
 DC H'2052,0'   READQ TD         18
 DC H'2054,0'   DELETEQ TD       19
 DC H'3586,0'   LINK             20
 DC H'3588,0'   XCTL             21
 DC H'3590,0'   LOAD             22
 DC H'3592,0'   RETURN           23
 DC H'3594,0'   RELEASE          24
 DC H'3596,0'   ABEND            25
 DC H'4098,0'   ASKTIME          26
 DC H'4100,0'   DELAY            27
 DC H'4616,0'   SUSPEND          28
 DC H'22018,0'  SPOOLOPEN        29  old was 5602
 DC H'22022,0'  SPOOLWRITE       30  old was 5606
 DC H'22032,0'  SPOOLCLOSE       31  old was 5610
 DC H'5634,0'   SYNCPOINT        32
 DC H'6146,0'   RECEIVE MAP      33
 DC H'6148,0'   SEND MAP         34
 DC H'6150,0'   SEND TEXT        35
 DC H'6162,0'   SEND CONTROL     36
 DC H'18434,0'  ENTER            37  old was 6660
 DC H'7170,0'   DUMP             38
 DC H'18946,0'  ASKTIME ABSTIME  39
 DC H'18948,0'  FORMATTIME       40
 DC H'27650,0'  WRITE OPERATOR   41
 DC H'29700,0'  SIGNOFF          42
 DC H'4212,0'   ENQ              43
 DC H'4214,0'   DEQ              44
 DC H'3076,0'   FREEMAIN         45
 DC H'3074,0'   GETMAIN          46
 DC H'3598,0'   HANDLE ABEND     47
 DC H'2566,0'   DELETEQ TS       48
 DC H'2564,0'   READQ TS         49
 DC H'2562,0'   WRITEQ TS        50
*
 DC H'9999,0'   SOURCE TRACE     51  not eibfn, just id for trace
*
 DC H'0,0'      end of list      52  end of table flag
*
 END
/*
//LKED     EXEC PGM=IEWL,PARM='XREF,MAP,LET,NCAL',
//         COND=(0,NE,ASM)
//SYSLIN   DD DSN=&&OBJSET,DISP=(OLD,DELETE)
//SYSIN    DD DUMMY
//SYSLMOD  DD DSN=K.S.V1R5M0.KIKRPL(KEDFILTR),DISP=SHR
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSPRINT DD SYSOUT=*
//
