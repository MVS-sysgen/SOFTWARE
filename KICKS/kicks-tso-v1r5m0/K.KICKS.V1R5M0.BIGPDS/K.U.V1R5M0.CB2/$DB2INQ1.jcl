//$DB2INQ1 JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=2048K
//*
//* Following inline proc is basically just the first (PP) step
//* of the normal KIKCB2PP proc. The expectation is it will be
//* used as shown to create a PDS (and member) that will be
//* used as input to DB2I program preparation.
//*
//* BE SURE TO DO GLOBAL CHANGE HERC01 TO YOUR OWN TSOID !!!
//*
//KIKDB2CL PROC OUTC='*',
//            UNT='SYSDA',
//            KICKSYS='K.KICKSSYS',
//            KIKSUSR='K.KICKS',
//            VER='V1R4M1'
//*           CBLPARM='OFFSET,MAP,XREF'
//*
//PP     EXEC PGM=KIKPPCOB,
//            PARM='-v -? -zos -t'
//STEPLIB  DD DSN=&KICKSYS..&VER..SKIKLOAD,DISP=SHR
//SYSPRINT DD DISP=(,PASS),UNIT=&UNT,SPACE=(800,(500,100)),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=800)
//SYSTERM  DD SYSOUT=&OUTC,DCB=(BLKSIZE=120,RECFM=F)
//SYSUDUMP DD SYSOUT=&OUTC
//SYSLIB   DD DISP=SHR,DSN=&KIKSUSR..&VER..COBCOPY
//         DD DISP=SHR,DSN=&KICKSYS..&VER..COBCOPY
// PEND
//*
//SCR    EXEC PGM=IEFBR14
//PPOUT    DD DSN=K.TMP.KIKPPOUT,DISP=(MOD,DELETE),
//         UNIT=SYSDA,SPACE=(TRK,(1))
//*
//DB2INQ1 EXEC KIKDB2CL
//PP.SYSPRINT DD DCB=(RECFM=FB,LRECL=80,BLKSIZE=3120),
//          UNIT=SYSDA,SPACE=(TRK,(15,15,5),RLSE),DISP=(,CATLG),
//          DSN=K.TMP.KIKPPOUT(DB2INQ1)
//PP.SYSIN  DD DISP=SHR,DSN=K.U.V1R5M0.CB2(DB2INQ1)
//
