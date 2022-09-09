//DALCDS40 JOB (SYS),'LOAD MACLIB',          <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  SHRABIT.MACLIB for ShareABitOfIT Utilities          *
//* *   in MVS 3.8J / Hercules                             *
//* *  JOB: $INST40  Load SHRABIT.MACLIB from              *
//* *                DALCDS.V1R0M00.MACLIB                 *
//* -------------------------------------------------------*
//DALCDS40 PROC VRM=V1R0M00,
//             DVOLSER=MVSDLB,DUNIT=3350     <-- Review and Modify
//LOAD40   EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//INMACLIB DD  DSN=DALCDS.&VRM..MACLIB,DISP=SHR
//OUTMACLB DD  DSN=SHRABIT.MACLIB,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(20,10,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//         PEND
//*
//STEP001  EXEC DALCDS40
//SYSIN    DD  *
    COPY INDD=INMACLIB,OUTDD=OUTMACLB
/*
//
