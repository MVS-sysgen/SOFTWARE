//FINDSRC3 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  FINDSRCH for MVS3.8J TSO / Hercules                 *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//INCLIST  DD  DSN=FINDSRCH.V0R9M11.CLIST,DISP=SHR
//INHELP   DD  DSN=FINDSRCH.V0R9M11.HELP,DISP=SHR
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR
//OUTHELP  DD  DSN=SYS2.HELP,DISP=SHR
//SYSIN    DD  *
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
    SELECT MEMBER=NO#MBR#                    /*dummy entry no mbrs! */
    COPY INDD=((INHELP,R)),OUTDD=OUTHELP
    SELECT MEMBER=CHKDSN
    SELECT MEMBER=CUTIL00
    SELECT MEMBER=FINDSRCH
    SELECT MEMBER=LOCATE
    SELECT MEMBER=FINDMEM
    SELECT MEMBER=CFLDSI
    SELECT MEMBER=CLDSI
    SELECT MEMBER=LISTDSJ
/*
//
