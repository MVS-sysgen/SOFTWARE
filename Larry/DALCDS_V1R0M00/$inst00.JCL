//DALCDS0 JOB (SYS),'Define DALCDS Alias',   <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DALCDS for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST00  Define Alias for HLQ DALCDS           *
//* *  Note: The master catalog password will be required  *
//* -------------------------------------------------------*
//DEFALIAS EXEC PGM=IDCAMS 
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 PARM GRAPHICS(CHAIN(SN))
 LISTCAT ALIAS  ENT(DALCDS) 
 IF LASTCC NE 0 THEN -
    DEFINE ALIAS(NAME(DALCDS) RELATE(SYS1.UCAT.MVS))                          
/*                                                                      
//
