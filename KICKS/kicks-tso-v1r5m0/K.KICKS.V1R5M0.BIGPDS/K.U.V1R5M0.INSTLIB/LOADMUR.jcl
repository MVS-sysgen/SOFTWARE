//MURACH JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=1024K
//*
//* LOAD TEST DATA FOR 'MURACH' KICKS SAMPLE APPS
//*
//* MODIFIED TO USE 'DISPLAY' NUMERICS INSTEAD OF 'COMP-3'
//* -- THIS TO FACILITATE FILES THAT CAN BE READILY SHIPPED
//*    (IE, NO PACKED DATA TO GET FOULED UP)
//*
//* STKCARDS USED BELOW IS A 'C' PROGRAM TO COPY MULTIPLE
//* SHORT (CARD IMAGE) RECORDS TO A LONGER RECORD. IT'S ALSO
//* USED TO SET LRECL AS NEEDED FOR REPRO.
//*
//* FIRST DELETE/DEFINE CUSTMAS, PRODUCT, INVOICE & INVCTL
//*
//DELDEF EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
 DELETE K.U.MURACH.CUSTMAS
 DELETE K.U.MURACH.PRODUCT
 DELETE K.U.MURACH.INVOICE
 DELETE K.U.MURACH.INVCTL
 SET MAXCC = 0
 DEFINE CLUSTER                                       -
      (NAME(K.U.MURACH.CUSTMAS) VOLUMES(PUB002) -
       TRACKS(15 15)  INDEXED                         -
       SHAREOPTIONS(1 3) UNIQUE                       -
       RECORDSIZE(118 118)                            -
       KEYS(6 0)                                      -
      )                                               -
     DATA ( NAME(K.U.MURACH.CUSTMAS.DATA))            -
    INDEX ( NAME(K.U.MURACH.CUSTMAS.INDEX))
 DEFINE CLUSTER                                       -
      (NAME(K.U.MURACH.PRODUCT) VOLUMES(PUB002) -
       TRACKS(15 15)  INDEXED                         -
       SHAREOPTIONS(1 3) UNIQUE                       -
    /* RECORDSIZE(39 39)     REC W/COMP-3  */         -
       RECORDSIZE(46 46)                              -
       KEYS(10 0)                                     -
      )                                               -
     DATA ( NAME(K.U.MURACH.PRODUCT.DATA))            -
    INDEX ( NAME(K.U.MURACH.PRODUCT.INDEX))
 DEFINE CLUSTER                                       -
      (NAME(K.U.MURACH.INVOICE) VOLUMES(PUB002) -
       TRACKS(15 15)  INDEXED                         -
       SHAREOPTIONS(1 3) UNIQUE                       -
    /* RECORDSIZE(275 275)   REC W/COMP-3  */         -
       RECORDSIZE(389 389)                            -
       KEYS(6 0)                                      -
      )                                               -
     DATA ( NAME(K.U.MURACH.INVOICE.DATA))            -
    INDEX ( NAME(K.U.MURACH.INVOICE.INDEX))
 DEFINE CLUSTER                                       -
      (NAME(K.U.MURACH.INVCTL) VOLUMES(PUB002) -
       TRACKS(15 15)  INDEXED                         -
       SHAREOPTIONS(1 3) UNIQUE                       -
       RECORDSIZE(7 7)                                -
       KEYS(1 0)                                      -
      )                                               -
     DATA ( NAME(K.U.MURACH.INVCTL.DATA))             -
    INDEX ( NAME(K.U.MURACH.INVCTL.INDEX))
/*
//*
//* LOAD 118 BYTE RECORDS (2 CARDS PER) INTO CUSTMAS
//*
//LOAD1A EXEC PGM=STKCARDS,PARM='2'
//* DATA FROM P78, LOWE, CICS FOR THE COBOL PGMR, PART 2
//STEPLIB  DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//SYSTERM  DD SYSOUT=*,DCB=BLKSIZE=120
//SYSPRINT DD DSN=&REPROIN,DISP=(,PASS),UNIT=SYSDA,
//         SPACE=(CYL,(1,1)),DCB=(RECFM=FB,LRECL=118,BLKSIZE=1180)
//SYSIN    DD *,DCB=BLKSIZE=80
400001KIETH               MCDONALD                      4501 W MOCKINGBIRD
      DALLAS              TX75209
400002ARREN               ANELLI                        40 FORD RD
      DENVILLE            NJ07834
400003SUSAN               HOWARD                        1107 SECOND AVE #312
      REDWOOD CITY        CA94063
400004CAROLANN            EVENS                         74 SUTTON CT
      GREAT LAKES         IL60088
400005ELAINE              ROBERTS                       12914 BRACKNELL
      CERRITOS            CA90701
400006PAT                 HONG                          73 HIGH ST
      SAN FRANCISCO       CA94114
400007PHIL                ROACH                         25680 ORCHARD
      DEARBORN HTS        MI48125
400008TIM                 JOHNSON                       145 W 27TH ST
      SO CHICAGO HTS      IL60411
400009MARIANNE            BUSBEE                        3920 BERWYN DR #199
      MOBILE              AL36608
400010ENRIQUE             OTHON                         BOX 26729
      RICHMOND            VA23261
400011WILLIAM C           FERGUSON                      BOX 1283
      MIAMI               FL34002-1283
400012S D                 HEOHN                         PO BOX 27
      RIDDLE              OR97469
400013DAVID R             KEITH                         BOX 1266
      MAGNOLIA            AR71757-1266
400014R                   BINDER                        3425 WALDEN AVE
      DEPEW               NY14043
400015VIVIAN              GEORGE                        229 S 18TH ST
      PHILADELPHIA        PA19103
400016J                   NOETHLICH                     11 KINGSTON CT
      MERRIMACK           NH03054
/*
//LOAD1B EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//CUSTMAS   DD DSN=&REPROIN,DISP=(OLD,DELETE)
//SYSIN DD *
 REPRO INFILE(CUSTMAS) OUTDATASET(K.U.MURACH.CUSTMAS)
/*
//*
//* LOAD 46 BYTE RECORDS (1 CARD PER) INTO PRODUCT
//*
//LOAD2A EXEC PGM=STKCARDS,PARM='1'
//STEPLIB  DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//SYSTERM  DD SYSOUT=*,DCB=BLKSIZE=120
//SYSPRINT DD DSN=&REPROIN,DISP=(,PASS),UNIT=SYSDA,
//         SPACE=(CYL,(1,1)),DCB=(RECFM=FB,LRECL=46,BLKSIZE=460)
//SYSIN    DD *,DCB=BLKSIZE=80
0000000001PENNY               0000000010010000
0000000005NICKEL              0000000050002000
0000000010DIME                0000000100001000
0000000025QUARTER             0000000250000250
0000000100DOLLAR              0000001000000050
0000000500FIVE                0000005000000020
0000001000TEN                 0000010000000020
0000002000TWENTY              0000020000000020
0000010000CNOTE               0000100000000010
/*
//LOAD2B EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//PRODUCT   DD DSN=&REPROIN,DISP=(OLD,DELETE)
//SYSIN DD *
 REPRO INFILE(PRODUCT) OUTDATASET(K.U.MURACH.PRODUCT)
/*
//*
//* LOAD 389 BYTE RECORDS (5 CARDS PER) INTO INVOICE
//*
//LOAD3A EXEC PGM=STKCARDS,PARM='5'
//* (SOME) DATA FROM P78, LOWE, CICS FOR THE COBOL PGMR, PART 2
//STEPLIB  DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//SYSTERM  DD SYSOUT=*,DCB=BLKSIZE=120
//SYSPRINT DD DSN=&REPROIN,DISP=(,PASS),UNIT=SYSDA,
//         SPACE=(CYL,(1,1)),DCB=(RECFM=FB,LRECL=389,BLKSIZE=3890)
//SYSIN    DD *,DCB=BLKSIZE=80
00358491-07-23400015PROM1     000000100000000050000010000000050000000000
0100000010000000010000000000250000003000000025000000075          0000000
0000000000          0000000000000000000000000          00000000000000000
          0000000000000000000000000          0000000000000000000000000
0000000000000000000000000          0000000000000000000000000000005175
00358591-07-23400003PROM1               0000000000000000000000000          00000
00000000000000000000          0000000000000000000000000          0000000
0000000000          0000000000000000000000000          00000000000000000
          0000000000000000000000000          0000000000000000000000000
0000000000000000000000000          0000000000000000000000000000029283
00358691-07-23400007PROM1               0000000000000000000000000          00000
00000000000000000000          0000000000000000000000000          0000000
0000000000          0000000000000000000000000          00000000000000000
          0000000000000000000000000          0000000000000000000000000
0000000000000000000000000          0000000000000000000000000000006887
00358791-07-23400005PROM1               0000000000000000000000000          00000
00000000000000000000          0000000000000000000000000          0000000
0000000000          0000000000000000000000000          00000000000000000
          0000000000000000000000000          0000000000000000000000000
0000000000000000000000000          0000000000000000000000000000002209
00358891-07-23400004PROM1               0000000000000000000000000          00000
00000000000000000000          0000000000000000000000000          0000000
0000000000          0000000000000000000000000          00000000000000000
          0000000000000000000000000          0000000000000000000000000
0000000000000000000000000          0000000000000000000000000000005763
00358991-07-23400016PROM1               0000000000000000000000000          00000
00000000000000000000          0000000000000000000000000          0000000
0000000000          0000000000000000000000000          00000000000000000
          0000000000000000000000000          0000000000000000000000000
0000000000000000000000000          0000000000000000000000000000071105
00359091-07-23400003PROM1               0000000000000000000000000          00000
00000000000000000000          0000000000000000000000000          0000000
0000000000          0000000000000000000000000          00000000000000000
          0000000000000000000000000          0000000000000000000000000
0000000000000000000000000          0000000000000000000000000000011049
/*
//LOAD3B EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//INVOICE   DD DSN=&REPROIN,DISP=(OLD,DELETE)
//SYSIN DD *
 REPRO INFILE(INVOICE) OUTDATASET(K.U.MURACH.INVOICE)
/*
//*
//* LOAD 7 BYTE RECORDS (1 CARD PER) INTO INVCTL
//*
//LOAD4A EXEC PGM=STKCARDS,PARM='1'
//STEPLIB  DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//SYSTERM  DD SYSOUT=*,DCB=BLKSIZE=120
//SYSPRINT DD DSN=&REPROIN,DISP=(,PASS),UNIT=SYSDA,
//         SPACE=(CYL,(1,1)),DCB=(RECFM=FB,LRECL=7,BLKSIZE=70)
//SYSIN    DD *,DCB=BLKSIZE=80
0003591
/*
//LOAD4B EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//INVCTL   DD DSN=&REPROIN,DISP=(OLD,DELETE)
//SYSIN DD *
 REPRO INFILE(INVCTL) OUTDATASET(K.U.MURACH.INVCTL)
/*
//*
//* DEFINE & BUILD THE INVOICE ALTERNATE INDEX
//*
//BLDIDX   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
 DEFINE ALTERNATEINDEX                                -
      (NAME(K.U.MURACH.INVOICE.AIX)                   -
       RELATE(K.U.MURACH.INVOICE)                     -
       VOLUMES(PUB002)                                -
       TRACKS(15 15)  NONUNIQUEKEY UPGRADE            -
       KEYS(6 14)                                     -
       SHAREOPTIONS(1 3) UNIQUE                       -
       RECORDSIZE(17 411) /* MAX 100 DUPS */          -
      )                                               -
     DATA ( NAME(K.U.MURACH.INVOICE.AIX.DATA)) -
    INDEX ( NAME(K.U.MURACH.INVOICE.AIX.INDEX))
 DEFINE PATH                                          -
      (NAME(K.U.MURACH.INVOICE.PATH)                  -
       PATHENTRY(K.U.MURACH.INVOICE.AIX)              -
      )
 BLDINDEX INDATASET(K.U.MURACH.INVOICE)               -
           OUTDATASET(K.U.MURACH.INVOICE.AIX)
//
