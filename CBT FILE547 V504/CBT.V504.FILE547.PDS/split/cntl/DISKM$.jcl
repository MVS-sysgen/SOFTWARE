//HERC01   JOB (CBT),
//             'Build DISKMAPx',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*                                                                  *
//*  Name: CBT.MVS38J.CNTL(DISKM$)                                   *
//*                                                                  *
//*  Type: Assembly of DISKMAPx modules                              *
//*                                                                  *
//*  Note: This job requires that the following files are available: *
//*                                                                  *
//*        CBT129.FILE260 - File 260 from CBT tape 129               *
//*        CBT249.FILE017 - File  17 from CBT tape 249               *
//*                                                                  *
//*  See CBT.MVS38J.CNTL(CBT090) on how to drop a file from          *
//*  CBT tape to DASD                                                *
//*                                                                  *
//********************************************************************
//CBTASM  PROC CBT='CBT249.FILE017',MEMBER=DISKMAP
//ASM     EXEC PGM=IFOX00,REGION=1024K,
//             PARM='NOXREF,NOLIST,TERM,DECK,NOOBJECT'
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSLIB   DD  DISP=SHR,DSN=&CBT,DCB=BLKSIZE=32720
//         DD  DISP=SHR,DSN=SYS1.AMACLIB
//         DD  DISP=SHR,DSN=SYS1.AMODGEN
//         DD  DISP=SHR,DSN=SYS1.MACLIB
//SYSPUNCH DD  DISP=(,PASS),UNIT=VIO,SPACE=(CYL,(1,1))
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DISP=SHR,DSN=&CBT(&MEMBER)
//        PEND
//CBTASML PROC CBT='CBT249.FILE017',MEMBER=DISKMAP,
//             SYSLMOD='SYS2.LINKLIB'
//ASM     EXEC PGM=IFOX00,REGION=1024K,
//             PARM='NOXREF,NOLIST,TERM,DECK,NOOBJECT'
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSLIB   DD  DISP=SHR,DSN=&CBT,DCB=BLKSIZE=32720
//         DD  DISP=SHR,DSN=CBT.MVS38J.MACLIB
//         DD  DISP=SHR,DSN=CBT.MVS38J.ASM
//         DD  DISP=SHR,DSN=SYS1.AMACLIB
//         DD  DISP=SHR,DSN=SYS1.AMODGEN
//         DD  DISP=SHR,DSN=SYS1.MACLIB
//SYSPUNCH DD  DISP=(,PASS),UNIT=VIO,SPACE=(CYL,(1,1))
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DISP=SHR,DSN=&CBT(&MEMBER)
//LINK    EXEC PGM=IEWL,PARM='XREF,LIST,MAP',COND=(0,NE,ASM)
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSPRINT DD  SYSOUT=*
//SYSLMOD  DD  DISP=SHR,DSN=&SYSLMOD(&MEMBER)
//SYSLIN   DD  DISP=(OLD,DELETE),DSN=*.ASM.SYSPUNCH
//         DD  DDNAME=SYSIN
//        PEND
//DISKMAP EXEC CBTASML,MEMBER=DISKMAP,
//             PARM.LINK='MAP,XREF,LIST,AC=1',
//             SYSLMOD='SYS2.LINKLIB'        <<==== CHANGE?|
//ASM.SYSIN DD DISP=SHR,DSN=CBT129.FILE260
//DYNAM   EXEC CBTASM,MEMBER=DYNAM
//DISKMPA EXEC CBTASML,MEMBER=DISKMAPA,
//             SYSLMOD='SYS2.LINKLIB'        <<==== CHANGE?|
//LINK.SYSLIN  DD DISP=(OLD,DELETE,DELETE),
//             DSN=*.DISKMPA.ASM.SYSPUNCH
//         DD  DISP=(OLD,DELETE,DELETE),DSN=*.DYNAM.ASM.SYSPUNCH
//         DD  *
 SETCODE AC(1)
 NAME DISKMAPA(R)
//SYSPRINT DD  SYSOUT=*