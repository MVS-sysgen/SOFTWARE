//KIKGCCGL JOB CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=7000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//* This is an ALMOST exact copy of KIKCOBGL.JCL.  Difference is
//* (1) no BLL cell stuff
//* (2) names modules KIKGCCGL/KIKGCCGX instead of KIKCOBGL/KIKCOBGX
//* (3) generates @@ksr1, @@kstrt for (argv, argc) fixup
//*
//* Note it includes the cobol glue code. No differences for GCC
//* at this time, although GCC preprocessor does not do Handle
//* Condition or Handle Aid so that code is effectively dead.
//*
//* Why not just use the COBOL glue routine? I want to have a
//* separate module so jcl won't have to change if I later decide
//* some special activity is needed for GCC...
//*
//KIKCGLU EXEC  PROC=KGCC,NAME=KIKGCCGL
//COPY.SYSUT1 DD *,DCB=BLKSIZE=3120
#define FORGCC
#define DOEDF
/*
// DD DISP=SHR,DSN=K.X.ROOT.C(KIKCOBGL)
//ASM.SYSIN DD DISP=SHR,DSN=K.X.ROOT.ASM(KIKGLUMA)
// DD *
         ENTRY @@KSTRT
@@KSTRT  START 0
         USING *,15
         ST    1,@@KSR1
         L     1,0(,1)
         ST    1,@@KIKEIB
         LA    1,@@KSR1X
         L     15,=V(@@CRT0)
         BR    15
         LTORG
*
         ENTRY @@KSR1
@@KSR1   DC    F'0'           r1 passed by KICKS at entry
*
         ENTRY @@KIKEIB
@@KIKEIB DC    F'0'           global eib address
*
*        arg list passed to gcc...
@@KSR1X  DC    XL1'80'
         DC    AL3(@@KSR1Y)
@@KSR1Y  DC    CL8'KICKS'
         DROP  15
/*
// DD DSN=&&TEMP2,DISP=(OLD,DELETE)
//LKED.SYSLIN DD DSN=&&OBJSET,DISP=(OLD,DELETE)
// DD *
/*
//KIKCGLUX EXEC  PROC=KGCC,NAME=KIKGCCGX
//COPY.SYSUT1 DD *,DCB=BLKSIZE=3120
#define FORGCC
#define DOEDF
/*
// DD DISP=SHR,DSN=K.X.ROOT.C(KIKCOBGL)
//ASM.SYSIN DD DISP=SHR,DSN=K.X.ROOT.ASM(KIKGLUMA)
// DD *
         ENTRY @@KSTRT
@@KSTRT  START 0
         USING *,15
         ST    1,@@KSR1
         L     1,0(,1)
         ST    1,@@KIKEIB
         LA    1,@@KSR1X
         L     15,=V(@@CRT0)
         BR    15
         LTORG
*
         ENTRY @@KSR1
@@KSR1   DC    F'0'           r1 passed by KICKS at entry
*
         ENTRY @@KIKEIB
@@KIKEIB DC    F'0'           global eib address
*
*        arg list passed to gcc...
@@KSR1X  DC    XL1'80'
         DC    AL3(@@KSR1Y)
@@KSR1Y  DC    CL8'KICKS'
         DROP  15
/*
// DD DSN=&&TEMP2,DISP=(OLD,DELETE)
//LKED.SYSLIN DD DSN=&&OBJSET,DISP=(OLD,DELETE)
// DD *
/*
//
