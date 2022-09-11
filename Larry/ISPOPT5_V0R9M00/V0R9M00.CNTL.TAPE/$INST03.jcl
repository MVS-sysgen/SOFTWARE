//ISPOPT53 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  ISPOPT5 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *  - C$IPSOP5 clist   installs to SYS2.CMDPROC         *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//INCLIST  DD  DSN=ISPOPT5.V0R9M00.CLIST,DISP=SHR
//INHELP   DD  DSN=ISPOPT5.V0R9M00.HELP,DISP=SHR
//INPROC   DD  DSN=ISPOPT5.V0R9M00.CLIST,DISP=SHR
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR
//OUTHELP  DD  DSN=SYS2.HELP,DISP=SHR
//OUTPROC  DD  DSN=SYS2.PROCLIB,DISP=SHR
//SYSIN    DD  *
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
    SELECT MEMBER=C$ISPOP5
    SELECT MEMBER=CFLDSI
    SELECT MEMBER=CLDSI
    COPY INDD=((INHELP,R)),OUTDD=OUTHELP
    SELECT MEMBER=CFLDSI
    SELECT MEMBER=CLDSI
    SELECT MEMBER=CUTIL00
    SELECT MEMBER=LISTDSJ
    COPY INDD=((INPROC,R)),OUTDD=OUTPROC
    SELECT MEMBER=GCCISP5
/*
//
