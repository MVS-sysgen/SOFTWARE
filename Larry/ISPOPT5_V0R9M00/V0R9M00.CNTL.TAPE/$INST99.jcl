//ISPOP599 JOB (SYS),'Install OBJ Val File', <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  ISPOPT5 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST99  Install Other Files                   *
//* *                                                      *
//* *       Install OBJ Validation File                    *
//* *                                                      *
//* -------------------------------------------------------*
//*
//OBJFILE  EXEC PGM=IEFBR14
//OBJ      DD DISP=(MOD,CATLG),
//         DSN=ISPOPT5.V0R9M00.OBJ,
//         UNIT=SYSDA,                       <-- Review and Modify
//         SPACE=(CYL,(1,1,10),),
//         DCB=(DSORG=PO,RECFM=FB,LRECL=80,BLKSIZE=3120)
//
