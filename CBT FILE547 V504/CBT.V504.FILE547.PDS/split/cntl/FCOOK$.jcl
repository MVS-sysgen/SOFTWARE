//HERC01   JOB (CBT),
//             'Build BSPFCOOK',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*                                                                  *
//*  Name: CBT.MVS38J.CNTL(FCOOK$)                                   *
//*                                                                  *
//*  Type: Assembly of BSPFCOOK Module                               *
//*                                                                  *
//*  Desc: Builds the fortune cookie jar                             *
//*                                                                  *
//*  Note: Assembling with SYSPARM(TEST) is considerably faster,     *
//*        but it will give you only 10 fortune cookies              *
//*                                                                  *
//********************************************************************
//CLEANUP EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 DELETE SYS2.LINKLIB(BSPFCOOK)      NONVSAM
 DELETE SYS2.LINKLIB(FCOOKIE)       NONVSAM
 DELETE SYS2.LINKLIB(COOKIE)        NONVSAM
 DELETE SYS2.LINKLIB(FORTUNE)       NONVSAM
 DELETE SYS2.LINKLIB(MURPHY)        NONVSAM
 DELETE CBT.MVS38J.OBJ(BSPFCOOK)   NONVSAM
 SET MAXCC=0
 SET LASTCC=0
//ASM     EXEC PGM=IFOX00,
//*            PARM='DECK,NOOBJECT,NOXREF,NOESD,NORLD,SYSPARM(TEST)'
//             PARM='DECK,NOOBJECT,NOXREF,NOESD,NORLD,TERM'
//********************************************************************
//* You might have to change the DSNAMES in the next 2 DD statements *
//********************************************************************
//SYSIN    DD  DISP=SHR,DSN=CBT.MVS38J.ASM(BSPFCOOK)
//SYSLIB   DD  DISP=SHR,DSN=CBT.MVS38J.MACLIB,DCB=BLKSIZE=32720
//         DD  DISP=SHR,DSN=CBT.MVS38J.ASM
//         DD  DISP=SHR,DSN=SYS1.MACLIB
//         DD  DISP=SHR,DSN=SYS1.AMACLIB
//         DD  DISP=SHR,DSN=SYS1.AMODGEN
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSPUNCH DD  DISP=(,PASS),UNIT=VIO,SPACE=(CYL,(10,10))
//COMP1   EXEC COMPRESS,LIB='SYS2.LINKLIB'
//LINK    EXEC PGM=IEWL,
//             COND=(0,NE),
//             PARM='RENT,REUS,REFR,LIST,LET,MAP'
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=VIO,SPACE=(TRK,(50,20))
//SYSLMOD  DD  DISP=SHR,DSN=SYS2.LINKLIB
//SYSLIN   DD  DISP=(OLD,DELETE),DSN=*.ASM.SYSPUNCH
//         DD  *
 ALIAS COOKIE
 ALIAS MURPHY
 ALIAS FCOOKIE
 ALIAS FORTUNE
 NAME BSPFCOOK(R)
