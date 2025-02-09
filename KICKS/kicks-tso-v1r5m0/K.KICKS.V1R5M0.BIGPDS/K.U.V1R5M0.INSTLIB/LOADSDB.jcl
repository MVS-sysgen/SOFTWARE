//LOADSDB JOB CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=1024K
//*
//* INITIALIZE THE SOURCE TRACE PROGRAMS FILE
//*
//* THE FILE NAMES CONTAIN VRM BECAUSE
//* THE FORMAT IS SUBJECT TO CHANGE...
//*
//* FIRST DELETE/DEFINE IT
//*
//DELDEF EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
 DELETE K.U.V1R5M0.SDB
 SET MAXCC = 0
 DEFINE CLUSTER                                      -
     (NAME(K.U.V1R5M0.SDB) VOLUMES(PUB002)           -
      CYLINDERS(10 10)  INDEXED                      -
      SHAREOPTIONS(1 3) UNIQUE                       -
      RECORDSIZE(92 92)                              -
      KEYS(14 0)                                     -
     )                                               -
    DATA ( NAME(K.U.V1R5M0.SDBDATA))                 -
   INDEX ( NAME(K.U.V1R5M0.SDB.INDEX))
/*
//*
//* LOAD A DUMMY RECORD
//*
//LOAD   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 REPRO INFILE(DUMYDATA) OUTDATASET(K.U.V1R5M0.SDB)
/*
//DUMYDATA DD *
99999999999999999999999999999999999
/*
//
//PRINT  EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 PRINT INDATASET(K.U.V1R5M0.SDB)
/*
//
