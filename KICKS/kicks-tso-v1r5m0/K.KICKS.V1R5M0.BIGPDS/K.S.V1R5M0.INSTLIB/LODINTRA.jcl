//LODINTRA JOB CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1)
//*
//DELDEF EXEC PGM=IDCAMS,REGION=1024K
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
 DELETE K.S.V1R5M0.KIKINTRA
 SET MAXCC = 0
 DEFINE CLUSTER                                       -
      (NAME(K.S.V1R5M0.KIKINTRA) INDEXED              -
       VOLUMES(PUB002)                                -
       TRACKS(15 15)                                  -
       SHAREOPTIONS(1 3) UNIQUE                       -
       RECORDSIZE(19 32767) SPANNED                   -
       KEYS(6 0)                                      -
      )                                               -
     DATA ( NAME(K.S.V1R5M0.KIKINTRA.DATA)) -
    INDEX ( NAME(K.S.V1R5M0.KIKINTRA.INDEX))
/*
//*
//* LOAD A DUMMY RECORD
//*
//LOAD   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 REPRO INFILE(DUMYDATA) OUTDATASET(K.S.V1R5M0.KIKINTRA)
/*
//DUMYDATA DD *
99999999999999999999999999999999999
/*
//
