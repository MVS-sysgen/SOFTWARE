//CCOMPR03 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CCOMPR for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//INCLIST  DD  DSN=CCOMPR.V0R9M01.CLIST,DISP=SHR
//INHELP   DD  DSN=CCOMPR.V0R9M01.HELP,DISP=SHR
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR
//OUTHELP  DD  DSN=SYS2.HELP,DISP=SHR
//SYSIN    DD  *
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
    SELECT MEMBER=NO#MBR#                    /*dummy entry no mbrs! */
    COPY INDD=((INHELP,R)),OUTDD=OUTHELP
    SELECT MEMBER=CHKDSN
/*
//
