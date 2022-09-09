//IVP1     JOB (SYS),'GETDTE IPV1',          <-- Review and Modify
//             CLASS=A,MSGCLASS=X,           <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID <-- Review and Modify
//* -------------------------------------------------------*
//* *  GETDTE for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $IVP1                                          *
//* *       Run GETDTE Validation from TSO Batch           *
//* *       to execulte clist CGETDTE                      *
//* *                                                      *
//* *  Expected Result:                                    *
//* *  RC=0                                                *
//* *                                                      *
//* -------------------------------------------------------*
//BATCHTSO PROC
//STEP01   EXEC PGM=IKJEFT01
//SYSPROC  DD  DISP=SHR,DSN=SYS1.CMDPROC           <--TARGET
//SYSPRINT DD  SYSOUT=*
//SYSTSPRT DD  SYSOUT=*
//SYSTSIN  DD  DUMMY       Command Line Input
//         PEND
//*
//IVP1     EXEC BATCHTSO
//STEP01.SYSTSIN DD *
CGETDTE
/*
//
