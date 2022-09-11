//ISPOPT5U JOB (SYS),'Upgrade ISPOPT5',      <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  ISPOPT5 in MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $UP0902                                        *
//* *       Upgrade ISPOPT5 Software from release V0R9M00  *
//* *                                                      *
//* *       - No upgrade! INITIAL distribution             *
//* *                                                      *
//* -------------------------------------------------------*
//*
//UP00000  EXEC PGM=IEFBR14
//SYSPRINT DD  SYSOUT=*
//
