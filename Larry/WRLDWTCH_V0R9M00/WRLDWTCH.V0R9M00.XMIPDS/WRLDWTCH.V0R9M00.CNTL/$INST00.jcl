//WRLDWTCH JOB (SYS),'Def WRLDWTCH Alias',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  WRLDWTCH in MVS3.8J TSO / Hercules                  *
//* *  JOB: $INST00  Define Alias for HLQ WRLDWTCH         *
//* *  Note: The master catalog password will be required  *
//* -------------------------------------------------------*
//DEFALIAS EXEC PGM=IDCAMS
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 PARM GRAPHICS(CHAIN(SN))
 LISTCAT ALIAS  ENT(WRLDWTCH)

 IF LASTCC NE 0 THEN -
    DEFINE ALIAS(NAME(WRLDWTCH) RELATE(SYS1.UCAT.MVS))
/*
//
