//DFSPC1   JOB (SYS),'Install Other PDSs',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DFSPC for MVS3.8J TSO / Hercules                    *
//* *  JOB: $INST02  Load other PDS from distribution tape *
//* *  Note: Uses tape drive 480                           *
//* -------------------------------------------------------*
//DFSPC2 PROC VRM=V1R0M00,
//             TVOLSER=VS1000,TUNIT=480,
//             DVOLSER=MVSDLB,DUNIT=3350     <-- Review and Modify
//LOAD02   EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//INCLIST  DD  DSN=DFSPC.&VRM..CLIST.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(2,SL)
//INHELP   DD  DSN=DFSPC.&VRM..HELP.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(3,SL)
//INISPF   DD  DSN=DFSPC.&VRM..ISPF.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(4,SL)
//INASM    DD  DSN=DFSPC.&VRM..ASM.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(5,SL)
//INMAC    DD  DSN=DFSPC.&VRM..MACLIB.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(6,SL)
//OUTCLIST DD  DSN=DFSPC.&VRM..CLIST,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(20,10,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//OUTHELP  DD  DSN=DFSPC.&VRM..HELP,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(05,05,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//OUTISPF  DD  DSN=DFSPC.&VRM..ISPF,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(05,05,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//OUTASM   DD  DSN=DFSPC.&VRM..ASM,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(60,30,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//OUTMAC   DD  DSN=DFSPC.&VRM..MACLIB,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(05,05,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//         PEND
//*
//STEP001  EXEC DFSPC2
//SYSIN    DD  *
    COPY INDD=INCLIST,OUTDD=OUTCLIST
    COPY INDD=INHELP,OUTDD=OUTHELP
    COPY INDD=INISPF,OUTDD=OUTISPF
    COPY INDD=INASM,OUTDD=OUTASM
    COPY INDD=INMAC,OUTDD=OUTMAC
/*
//
