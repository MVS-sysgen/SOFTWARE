//SVC99  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=7000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//SVC99   EXEC KGCC,NAME=SVC99
//COPY.SYSUT1 DD DSN=K.X.ROOT.C(SVC99),DISP=SHR
//