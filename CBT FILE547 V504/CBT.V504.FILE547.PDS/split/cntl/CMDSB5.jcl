//HERC01  JOB  (MVS),
//             'INSTALL # SUBSYS',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*                                                                  *
//* NAME: SYS1.SETUP.CNTL(CMDSB5)                                    *
//*                                                                  *
//* TYPE: JCL to assemble some CMDSBSYS modules for use in non-SE    *
//*       systems only                                               *
//*                                                                  *
//********************************************************************
//DMASM   PROC MEMBER=,
//             LNCT=55,
//             LINKMEM=,
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
//SYSLMOD  DD  DISP=SHR,DSN=&LINKLIB.(&LINKMEM)
//SYSUT1   DD  UNIT=VIO,SPACE=(TRK,(50,20))
//SYSPRINT DD  SYSOUT=*
//        PEND
//DMLINK  PROC LINKLIB='CBT.CMDSBSYS.LINKLIB'
//DMLINK  EXEC PGM=IEWL,
//             PARM='XREF,LET,LIST,RENT,REUS'
//SYSLIN   DD  DDNAME=SYSIN
//SYSLIB   DD  DISP=SHR,DSN=SYS1.LINKLIB
//SYSLMOD  DD  DISP=SHR,DSN=&LINKLIB
//SYSUT1   DD  UNIT=VIO,SPACE=(TRK,(50,20))
//SYSPRINT DD  SYSOUT=*
//        PEND
//LNK00   EXEC DMLINK
//DMLINK.SYSIN DD *
 INCLUDE SYSLIB(IEFBR14)
 NAME CSCGQ03D(R)
//ASM01   EXEC DMASM,MEMBER=NSESE03D,LINKMEM=CSCSE03D
//ASM02   EXEC DMASM,MEMBER=NSESJ03D,LINKMEM=CSCSJ03D
//ASM03   EXEC DMASM,MEMBER=NSESL03D,LINKMEM=CSCSL03D
//ASM04   EXEC DMASM,MEMBER=NSEZJ03D,LINKMEM=CSCZJ03D
//ASM05   EXEC DMASM,MEMBER=NSEZS03D,LINKMEM=CSCZS03D
//ASM06   EXEC DMASM,MEMBER=NSEGF03D,LINKMEM=CSCGF03D
//ASM07   EXEC DMASM,MEMBER=NSEGJ03D,LINKMEM=CSCGJ03D
//ASM08   EXEC DMASM,MEMBER=NSEGS03D,LINKMEM=CSCGS03D