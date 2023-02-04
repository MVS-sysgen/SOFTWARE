//KIKGCCGL  JOB  CLASS=C,MSGCLASS=Z
// EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN DD DUMMY,DCB=BLKSIZE=80
//SYSUT2 DD UNIT=10D,DISP=OLD,DCB=BLKSIZE=80
//SYSUT1 DD DATA,DLM=$$,DCB=BLKSIZE=3120
ID CMSBATCH
/JOB CMSUSER 123456 KIKGCCGL
$$
// DD DSN=K.X.CMSBATCH(MAPN),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCGET),DISP=SHR
// DD DSN=K.X.CMSBATCH(KASM),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCE),DISP=SHR
// DD DATA,DLM=$$
*
* This is an ALMOST exact copy of KIKCOBGL.CMSBATCH.  Differences
* (1) no BLL cell stuff
* (2) names modules KIKGCCGL/KIKGCCGX instead of KIKCOBGL/KIKCOBGX
* (3) generates @@ksr1, @@kstrt for (argv, argc) fixup
*
* Note it includes the cobol glue code. No differences for GCC
* at this time, although GCC preprocessor does not do Handle
* Condition or Handle Aid so that code is effectively dead.
*
* Why not just use the COBOL glue routine? I want to have a
* separate module so jcl won't have to change if I later decide
* some special activity is needed for GCC...
*
MAPN
KBLOCK KIKGCCGL
KGCCGET
VMARC UNPACK ASYSH VMARC N = = A
KASM @@kstrt
         ENTRY @@KSTRT
@@KSTRT  START 0
         USING *,15
         ST    1,@@KSR1
         L     1,0(,1)
         ST    1,@@KIKEIB
*        LA    1,@@KSR1X
         L     1,@@KSR1X      CMS wants r1 -> list, not a(list)...
         XR    0,0            ensure @@CRT0 sees no EPlist
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
*        CMS style arg list passed to gcc...
@@KSR1X  DC    AL4(@@KSR1Y)
         DS    0D
@@KSR1Y  DC    CL8'KICKS'
         DC    8X'FF'
         DC    8X'FF'
         DC    8X'FF'
         LTORG
         END
/*
*
* copy custom PDPPRLG macro to disk
*
FILEDEF  INMOVE  TERM ( RECFM F BLOCK 80 LRECL 80
FILEDEF  OUTMOVE DISK PDPPRLG MACRO A ( RECFM F BLOCK 80 LRECL 80
MOVEFILE
$$
// DD DSN=K.X.ROOT.ASM(KIKGLUMA),DISP=SHR
// DD DATA,DLM=$$
/*
MACLIB DEL PDPCLIB PDPPRLG
MACLIB DEL PDPCLIB PDPPRLG
MACLIB ADD PDPCLIB PDPPRLG
*
* compile edf version
*
KGCCE kikgccgl
#define FORGCC
#define DOEDF
$$
// DD DSN=K.X.ROOT.C(KIKCOBGL),DISP=SHR
// DD DATA,DLM=$$
/*
*
* compile non-edf version
*
KGCCE kikgccgx
#define FORGCC
#undef DOEDF
$$
// DD DSN=K.X.ROOT.C(KIKCOBGL),DISP=SHR
// DD DATA,DLM=$$
/*
/*
$$
//
