//HERC01   JOB (CBT),
//             'Install WTO Exit',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(0,0),
//             REGION=8192K,
//             NOTIFY=HERC01
//* +----------------------------------------------------------------+
//* |                                                                |
//* | Name: CBT.MVS38J.CNTL(CVXIT$)                                  |
//* |                                                                |
//* | Type: JCL to install usermod ZUM0003                           |
//* |                                                                |
//* | Desc: Build the automatic operator made from the WTO           |
//* |       exit IEECVXIT and the R2D2 routine                       |
//* |                                                                |
//* |       The code in IEECVXIT will only be active when and if     |
//* |       the module BSPPILOT is running in a started task or a job|
//* |       with the name BSPPILOT.                                  |
//* |                                                                |
//* |       A Procedure called BSPPILOT will be automatically placed |
//* |       into SYS1.PROCLIB.  This usermod will also create a      |
//* |       member COMMND01 in SYS1.PARMLIB.  You should copy        |
//* |       this member to the beginning of your existing COMMND00   |
//* |       member. If you do not already have a COMMND00 member     |
//* |       then just rename COMMND01 to COMMND00                    |
//* |                                                                |
//* |                                                                |
//* +----------------------------------------------------------------+
/*MESSAGE *****************************
/*MESSAGE *                           *
/*MESSAGE * To activate this usermod  *
/*MESSAGE * an IPL with the CLPA      *
/*MESSAGE * option is required        *
/*MESSAGE *                           *
/*MESSAGE *****************************
//*
//*
//ASM     EXEC PGM=IFOX00,
//             PARM='DECK,NOOBJECT,NOXREF,TERM,SYSPARM(BSPPILOT)'
//*********************************************************************
//* You might need to change the following two DD statements to reflect
//* The correct dataset names for MACLIB and SYSIN
//*********************************************************************
//SYSIN    DD  DISP=SHR,DSN=CBT.MVS38J.ASM(IEECVXIT)
//SYSLIB   DD  DISP=SHR,DSN=CBT.MVS38J.MACLIB,DCB=BLKSIZE=32720
//         DD  DISP=SHR,DSN=SYS1.MACLIB
//         DD  DISP=SHR,DSN=SYS1.AMACLIB
//         DD  DISP=SHR,DSN=SYS1.AMODGEN
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(1,1))
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSPUNCH DD  DISP=SHR,DSN=SYS1.UMODOBJ(IEECVXIT)
//SMPREJ  EXEC SMPREC,COND=(0,NE)
//SMPCNTL  DD  *
 REJECT S(ZUM0003).
//SMPREC  EXEC SMPREC,COND=(0,NE,ASM)
//SMPPTFIN DD DATA,DLM=$$
++USERMOD(ZUM0003).
++VER(Z038) FMID(EBB1102).
++MOD(IEECVXIT) TXLIB(UMODOBJ).
++MAC(COMMND01) DISTLIB(APARMLIB) SYSLIB(PARMLIB).
COM='S BSPPILOT,PARM=NOWTO'
++MAC(BSPPILOT) DISTLIB(APROCLIB) SYSLIB(PROCLIB).
//IEFPROC EXEC PGM=BSPPILOT            <<<< added by ZUM0003/Autopilot
//SYSUDUMP DD  SYSOUT=A
$$
//SMPCNTL DD *
 RECEIVE SELECT(ZUM0003).
//SMPAPP  EXEC SMPAPP,
//       COND=((0,NE,ASM),
//             (0,NE,SMPREC.HMASMP))
//SMPCNTL DD  *
 APPLY G(ZUM0003) DIS(WRITE).
