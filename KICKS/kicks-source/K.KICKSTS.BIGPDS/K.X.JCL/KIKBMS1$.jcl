//KIKBMS  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=7000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//KIKBMS EXEC PROC=KGCC,NAME=KIKBMS1$
//COPY.SYSUT1 DD DISP=SHR,DSN=K.X.ROOT.CPART(ENCODE32)
// DD DISP=SHR,DSN=K.X.ROOT.C(KIKBMS1$)
//LKED.SYSLIN DD DSN=&&OBJSET,DISP=(OLD,DELETE)
// DD *
 ENTRY KIKBMS
/*
//