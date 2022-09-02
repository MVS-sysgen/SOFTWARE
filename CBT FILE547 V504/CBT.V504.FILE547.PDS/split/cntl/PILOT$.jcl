//HERC01   JOB (CBT),
//             'Install Autopilot',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(0,0),
//             REGION=8192K,
//             NOTIFY=HERC01
//* +----------------------------------------------------------------+
//* |                                                                |
//* | Name: CBT.MVS38J.CNTL(PILOT$)                                  |
//* |                                                                |
//* | Type: JCL to install Autopilot (BSPPILOT, AKA C3PO)            |
//* |                                                                |
//* | Desc: Build the automatic operator main control task BSPPILOT  |
//* |                                                                |
//* +----------------------------------------------------------------+
//ASM     EXEC PGM=IFOX00,PARM='DECK,NOOBJECT,TERM,NOXREF'
//********************************************************************
//* You might have to change the DSNAMES in the next 2 DD statements *
//********************************************************************
//SYSIN    DD  DISP=SHR,DSN=CBT.MVS38J.ASM(BSPPILOT)
//SYSLIB   DD  DISP=SHR,DSN=CBT.MVS38J.MACLIB,DCB=BLKSIZE=32720
//         DD  DISP=SHR,DSN=SYS1.MACLIB
//         DD  DISP=SHR,DSN=SYS1.AMACLIB
//         DD  DISP=SHR,DSN=SYS1.AMODGEN
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSPUNCH DD  DISP=(NEW,PASS),UNIT=VIO,SPACE=(CYL,(1,1))
//LINK    EXEC PGM=IEWL,
//             COND=(0,NE),
//             PARM='XREF,LIST,MAP'
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSLIN   DD  DISP=(OLD,DELETE),DSN=*.ASM.SYSPUNCH
//SYSLMOD  DD  DISP=SHR,DSN=SYS2.LINKLIB(BSPPILOT)  <<==== change
//UPDATE  EXEC PGM=IEBUPDTE,
//             COND=(0,NE),
//             PARM=NEW
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DISP=SHR,DSN=SYS1.PARMLIB
//SYSIN    DD  *
