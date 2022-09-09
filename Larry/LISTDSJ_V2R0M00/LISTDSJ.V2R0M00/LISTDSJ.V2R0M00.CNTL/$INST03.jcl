//LISTDSJ3 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  LISTDSJ for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//INCLIST  DD  DSN=LISTDSJ.V2R0M00.CLIST,DISP=SHR
//INHELP   DD  DSN=LISTDSJ.V2R0M00.HELP,DISP=SHR
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR
//OUTHELP  DD  DSN=SYS2.HELP,DISP=SHR
//SYSIN    DD  *
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
    SELECT MEMBER=CLISTDSJ
    SELECT MEMBER=CFLDSI
    SELECT MEMBER=CLDSI
    SELECT MEMBER=CLDSI2
    COPY INDD=((INHELP,R)),OUTDD=OUTHELP
    SELECT MEMBER=LISTDSJ
    SELECT MEMBER=CFLDSI
    SELECT MEMBER=CLDSI
    SELECT MEMBER=CLDSI2
/*
//
