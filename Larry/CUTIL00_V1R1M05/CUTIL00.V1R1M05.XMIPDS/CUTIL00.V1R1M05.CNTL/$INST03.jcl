//CUTIL003 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CUTIL00 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//INCLIST  DD  DSN=CUTIL00.V1R1M05.CLIST,DISP=SHR
//INHELP   DD  DSN=CUTIL00.V1R1M05.HELP,DISP=SHR
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR
//OUTHELP  DD  DSN=SYS2.HELP,DISP=SHR
//SYSIN    DD  *
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
    SELECT MEMBER=CCUTIL00
    SELECT MEMBER=CCUTIL0V
    COPY INDD=((INHELP,R)),OUTDD=OUTHELP
    SELECT MEMBER=CUTIL00
    SELECT MEMBER=CCUTIL00
/*
//
