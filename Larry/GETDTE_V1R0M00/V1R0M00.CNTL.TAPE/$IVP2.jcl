//IVP2     JOB (SYS),'GETDTE IPV2',          <-- Review and Modify
//             CLASS=A,MSGCLASS=X,           <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID <-- Review and Modify
//* -------------------------------------------------------*
//* *  GETDTE for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $IVP2                                          *
//* *       Run GETDTE Validation from BATCH job           *
//* *                                                      *
//* *  Expected Result:                                    *
//* *  S0C4 for IVP2A   (invalid scenerio)                 *
//* *                                                      *
//* -------------------------------------------------------*
//IVP2A    EXEC PGM=GETDTE
//SYSPRINT DD  SYSOUT=*
//SYSUDUMP DD  SYSOUT=*
//
