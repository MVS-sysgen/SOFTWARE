//IVP1     JOB (SYS),'CUTIL00 IPV1',         <-- Review and Modify
//             CLASS=A,                      <-- Review and Modify
//             MSGCLASS=A,                   <-- Review and Modify
//             MSGLEVEL=(1,1)                <-- Review and Modify
//* -------------------------------------------------------*
//* *  CUTIL00 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $IVP1                                          *
//* *       Run CUTIL00 Validation                         *
//* *                                                      *
//* *  CUTIL00 validation via CCLIST0V using BATCH TSO     *
//* *  of documented function in program documentation.    *
//* *                                                      *
//* *  Note: CLIST are resolved from SYS2.CMDPROC          *
//* *        and tagged with <--TARGET for search          *
//* *        purposes.                                     *
//* -------------------------------------------------------*
//BATCHTSO PROC
//STEP01   EXEC PGM=IKJEFT01
//SYSPROC  DD  DISP=SHR,DSN=SYS2.CMDPROC           <--TARGET
//SYSPRINT DD  SYSOUT=*
//SYSTSPRT DD  SYSOUT=*
//SYSTSIN  DD  DUMMY       Command Line Input
//         PEND
//*
//TESTIT0  EXEC BATCHTSO
//STEP01.SYSTSIN DD *
CCUTIL0V
/*
//
