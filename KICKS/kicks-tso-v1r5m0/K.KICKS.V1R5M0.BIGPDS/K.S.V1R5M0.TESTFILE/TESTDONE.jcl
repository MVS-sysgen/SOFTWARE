//TESTDEL JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1)
//*
//DELDEF EXEC PGM=IDCAMS,REGION=1024K
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
 DELETE K.U.V1R5M0.TSTKSDS
 DELETE K.U.V1R5M0.TSTESDS
 DELETE K.U.V1R5M0.TSTRRDS
 SET MAXCC = 0
/*
//