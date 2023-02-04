//TESTLOAD JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1)
//*
//DELDEF EXEC PGM=IDCAMS,REGION=1024K
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
 DELETE K.U.V1R5M0.TSTKSDS
 DELETE K.U.V1R5M0.TSTESDS
 DELETE K.U.V1R5M0.TSTRRDS
 SET MAXCC = 0
 DEFINE CLUSTER                                       -
      (NAME(K.U.V1R5M0.TSTKSDS)                       -
       VOLUMES(PUB002)                                -
       TRACKS(15 15)     INDEXED                      -
       SHAREOPTIONS(1 3) UNIQUE                       -
       RECORDSIZE(80 80)                              -
       KEYS(6 10)                                     -
      )                                               -
     DATA ( NAME(K.U.V1R5M0.TSTKSDS.DATA))            -
    INDEX ( NAME(K.U.V1R5M0.TSTKSDS.INDEX))
 DEFINE CLUSTER                                       -
      (NAME(K.U.V1R5M0.TSTESDS)                       -
       VOLUMES(PUB002)                                -
       TRACKS(15 15)  NONINDEXED                      -
       SHAREOPTIONS(1 3) UNIQUE                       -
       RECORDSIZE(80 80)                              -
      )                                               -
     DATA ( NAME(K.U.V1R5M0.TSTESDS.DATA))
 DEFINE CLUSTER                                       -
      (NAME(K.U.V1R5M0.TSTRRDS)                       -
       VOLUMES(PUB002)                                -
       TRACKS(15 15)  NUMBERED                        -
       SHAREOPTIONS(1 3) UNIQUE                       -
       RECORDSIZE(80 80)                              -
      )                                               -
     DATA ( NAME(K.U.V1R5M0.TSTRRDS.DATA))
/*
//LOAD   EXEC PGM=IDCAMS,REGION=1024K
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 REPRO INFILE(TSTDATA) OUTDATASET(K.U.V1R5M0.TSTKSDS)
 PRINT INDATASET(K.U.V1R5M0.TSTKSDS)
 REPRO INFILE(TSTDATA) OUTDATASET(K.U.V1R5M0.TSTESDS)
 PRINT INDATASET(K.U.V1R5M0.TSTESDS)
 REPRO INFILE(TSTDATA) OUTDATASET(K.U.V1R5M0.TSTRRDS)
 PRINT INDATASET(K.U.V1R5M0.TSTRRDS)
/*
//TSTDATA  DD *
ZERO      000005
ONE       111111
TWO       222222
THREE     333333
THREEA    333334
THREEB    333335
THREEC    333336
THREED    333337
FOUR      444444
FIVE      555555
SIX       666666
SEVEN     777777
EIGHT     888888
NINE      999995
/*
//BLDIDX   EXEC PGM=IDCAMS,REGION=1024K
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DEFINE ALTERNATEINDEX                                -
      (NAME(K.U.V1R5M0.TSTKSDS.AIX)                   -
       RELATE(K.U.V1R5M0.TSTKSDS)                     -
       VOLUMES(PUB002)                                -
       TRACKS(15 15)  UNIQUEKEY                       -
       UPGRADE                                        -
       KEYS(6 0)                                      -
       SHAREOPTIONS(1 3) UNIQUE                       -
       RECORDSIZE(80 80)                              -
      )                                               -
     DATA ( NAME(K.U.V1R5M0.TSTKSDS.AIX.DATA)) -
    INDEX ( NAME(K.U.V1R5M0.TSTKSDS.AIX.INDEX))
 DEFINE PATH                                          -
      (NAME(K.U.V1R5M0.TSTKSDS.PATH)                  -
       PATHENTRY(K.U.V1R5M0.TSTKSDS.AIX)              -
      )
 BLDINDEX INDATASET(K.U.V1R5M0.TSTKSDS)               -
           OUTDATASET(K.U.V1R5M0.TSTKSDS.AIX)
 PRINT INDATASET(K.U.V1R5M0.TSTKSDS.PATH)
/*
//BLDIDX2  EXEC PGM=IDCAMS,REGION=1024K
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DEFINE ALTERNATEINDEX                                -
      (NAME(K.U.V1R5M0.TSTESDS.AIX)                   -
       RELATE(K.U.V1R5M0.TSTESDS)                     -
       VOLUMES(PUB002)                                -
       TRACKS(15 15)  UNIQUEKEY                       -
       UPGRADE                                        -
       KEYS(6 0)                                      -
       SHAREOPTIONS(1 3) UNIQUE                       -
       RECORDSIZE(80 80)                              -
      )                                               -
     DATA ( NAME(K.U.V1R5M0.TSTESDS.AIX.DATA)) -
    INDEX ( NAME(K.U.V1R5M0.TSTESDS.AIX.INDEX))
 DEFINE PATH                                          -
      (NAME(K.U.V1R5M0.TSTESDS.PATH)                  -
       PATHENTRY(K.U.V1R5M0.TSTESDS.AIX)              -
      )
 BLDINDEX INDATASET(K.U.V1R5M0.TSTESDS)               -
           OUTDATASET(K.U.V1R5M0.TSTESDS.AIX)
 PRINT INDATASET(K.U.V1R5M0.TSTESDS.PATH)
/*
//
