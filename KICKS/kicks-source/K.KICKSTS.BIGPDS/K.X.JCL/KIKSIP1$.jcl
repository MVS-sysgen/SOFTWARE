//KIKSIP  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=7000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//KIKSIP EXEC  PROC=KGCC,LOPTS='XREF,MAP',NAME=KIKSIP1$
//COPY.SYSUT1 DD DSN=K.X.ROOT.C(KIKSIP1$),DISP=SHR
//LKED.SYSLIN DD DSN=&&OBJSET,DISP=(OLD,DELETE)
// DD *
 INCLUDE SKIKLOAD(KIKASRB)
 INCLUDE SKIKLOAD(KIKLOAD)
 INCLUDE SKIKLOAD(VCONSTB5)
 ENTRY @@CRT0
/*
//
