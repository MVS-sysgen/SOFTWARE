//IVPS     JOB (SYS),'CUTIL00 IPVS',         <-- Review and Modify
//         CLASS=A,MSGCLASS=A,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CUTIL00 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $IVP1                                          *
//* *       Run CUTIL00 Samples                            *
//* *                                                      *
//* *  CUTIL00 validation via CCUTIL00 using BATCH TSO     *
//* *  of sample functions.                                *
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
//TESTITS  EXEC BATCHTSO
//STEP01.SYSTSIN DD *
CCUTIL00 ABOUT VERBOSE(N)
CCUTIL00 LTRIM    VAR01('   LEADING SPACES') VAR02('')  VERBOSE(N)
CCUTIL00 RTRIM    VAR01('TRAILING SPACES  ') VAR02('')  VERBOSE(N)
CCUTIL00 TRIM     VAR01(' TRIM   MY  DATA ') VAR02('')  VERBOSE(N)
CCUTIL00 TRIM$    VAR01(' TRIM   MY  DATA ') VAR02('')  VERBOSE(N)
CCUTIL00 INDEX    VAR01('MY, STRING, OK?   ') VAR02('","')  VERBOSE(N)
CCUTIL00 INDEXB   VAR01('MY, STRING, OK?   ') VAR02('","')  VERBOSE(N)
CCUTIL00 ISNUM    VAR01('0123456789') VERBOSE(N)
CCUTIL00 ISALPHA  VAR01('ABCDEFGHIJ') VERBOSE(N)
CCUTIL00 ISLOWER  VAR01('abcdefghij') VERBOSE(N)
CCUTIL00 ISUPPER  VAR01('ABCDEFGHIJ') VERBOSE(N)
CCUTIL00 ISBLANK  VAR01('         ') VERBOSE(N)
CCUTIL00 ISDSN    VAR01('A.A1234567') VERBOSE(N)
CCUTIL00 ECHO     VAR01('MY DATA TO DISPLAY') VERBOSE(N)
CCUTIL00 ECHOQ    VAR01('MY DATA TO DISPLAY') VERBOSE(N)
CCUTIL00 REVRS    VAR01('ABCDEFGHIJKLM96%QRS') VAR02('') VERBOSE(N)
CCUTIL00 UPPERC   VAR01('ABCDEFGHIJKLMNOPQRS') VERBOSE(N)
CCUTIL00 LOWERC   VAR01('ABCDEFGHIJKLMNOPQRS') VAR02('') VERBOSE(N)
CCUTIL00 COUNT    VAR01('MY NAME IS DINO, BIG DINO.') VAR02('"DINO"') -
 VERBOSE(N)
CCUTIL00 FIND     VAR01('MY NAME IS DINO, BIG DINO.') VAR02('"DINO"') -
 VERBOSE(N)
CCUTIL00 FINDL    VAR01('MY NAME IS DINO, BIG DINO.') VAR02('"DINO"') -
 VERBOSE(N)
CCUTIL00 CENTER   VAR01('CENTER THIS T E X T ...       ') VAR02('') -
 VERBOSE(N)
CCUTIL00 LJUST    VAR01(' JUSTIFY THIS TEXT    ') VAR02('') VERBOSE(N)
CCUTIL00 RJUST    VAR01(' JUSTIFY THIS TEXT    ') VAR02('') VERBOSE(N)
CCUTIL00 ZFILL    VAR01('12   ') VAR02('') VERBOSE(N)
CCUTIL00 WORDS    VAR01('  ONE TEWO THREE33 FOUR., FIVE ') VERBOSE(N)
CCUTIL00 GEN#     VAR01('') VERBOSE(N)
CCUTIL00 DD2DSN   VAR01('SYSPROC') VAR02('') VERBOSE(N)
CCUTIL00 JOBINFO  VAR01('') VERBOSE(N)
CCUTIL00 DAYSMM   VAR01('022016') VERBOSE(N)
CCUTIL00 DAYSYY   VAR01('2020') VERBOSE(N)
CCUTIL00 ISLEAP   VAR01('2020') VERBOSE(N)

CCUTIL00 CYJ-D8   VAR01('2020061') VAR02('') VERBOSE(N)
CCUTIL00 CYJ-DAY  VAR01('1981061') VAR02('') VERBOSE(N)
CCUTIL00 CYJ-DOW  VAR01('1981061') VAR02('') VERBOSE(N)
CCUTIL00 CYJ-MDCY VAR01('2020061') VAR02('') VERBOSE(N)

CCUTIL00 JCY-D8   VAR01('1612017') VAR02('') VERBOSE(N)
CCUTIL00 JCY-DAY  VAR01('0611981') VAR02('') VERBOSE(N)
CCUTIL00 JCY-DOW  VAR01('0611981') VAR02('') VERBOSE(N)
CCUTIL00 JCY-MDCY VAR01('1612017') VAR02('') VERBOSE(N)

CCUTIL00 MDCY-D8  VAR01('12101990') VAR02('') VERBOSE(N)
CCUTIL00 MDCY-DAY VAR01('12101990') VAR02('') VERBOSE(N)
CCUTIL00 MDCY-DOW VAR01('12101990') VAR02('') VERBOSE(N)
CCUTIL00 MDCY-CYJ VAR01('12101990') VAR02('') VERBOSE(N)

CCUTIL00 DMCY-D8  VAR01('15071987') VAR02('') VERBOSE(N)
CCUTIL00 DMCY-DAY VAR01('15071987') VAR02('') VERBOSE(N)
CCUTIL00 DMCY-DOW VAR01('15071987') VAR02('') VERBOSE(N)
CCUTIL00 DMCY-CYJ VAR01('15071987') VAR02('') VERBOSE(N)

CCUTIL00 CYMD-D8  VAR01('19951231') VAR02('') VERBOSE(N)
CCUTIL00 CYMD-DAY VAR01('19951231') VAR02('') VERBOSE(N)
CCUTIL00 CYMD-DOW VAR01('19951231') VAR02('') VERBOSE(N)
CCUTIL00 CYMD-CYJ VAR01('19951231') VAR02('') VERBOSE(N)

CCUTIL00 CYDM-D8  VAR01('19951605') VAR02('') VERBOSE(N)
CCUTIL00 CYDM-DAY VAR01('19951605') VAR02('') VERBOSE(N)
CCUTIL00 CYDM-DOW VAR01('19951605') VAR02('') VERBOSE(N)
CCUTIL00 CYDM-CYJ VAR01('19951605') VAR02('') VERBOSE(N)
CCUTIL00 FILL     VAR01('') VAR02('*20') VERBOSE(N)
CCUTIL00 LSTRIP   VAR01(',,28,BC,') VAR02(',') VERBOSE(N)
CCUTIL00 RSTRIP   VAR01(',,28,BC,') VAR02(',') VERBOSE(N)
CCUTIL00 STRIP    VAR01(',,28,BC,') VAR02(',') VERBOSE(N)
CCUTIL00 STRIP$   VAR01(',,28,BC,') VAR02(',') VERBOSE(N)
CCUTIL00 CONCAT   VAR01('STRING DATA 1.') -
 VAR02('A RESULT STRING 2.') VERBOSE(N)
CCUTIL00 UNSTR    VAR01('1234567 AND SO ON . I AM 78 LONG. ') -
 VAR02('7') VERBOSE(N)
CCUTIL00 REPLACE  VAR01('1234567 AND SO ON . I AM 7879.') -
 VAR02('"SO ON ","890123456--"') VERBOSE(N)
CCUTIL00 VEXIST   VAR01('VAR01') VERBOSE(N)
CCUTIL00 VEXIST   VAR01('DDD01') VERBOSE(N)
CCUTIL00 TDSN     VAR01('HERC01.CARDS.') VERBOSE(N)
CCUTIL00 NOW      VAR01('') VERBOSE(N)
CCUTIL00 PAD      VAR01('MAKE ME 30 LONG') VAR02(' 30') VERBOSE (N)
CCUTIL00 GET1V    VAR01('THE TABLE TOP IS CLEAR') VAR02('x11') -
 VERBOSE (N)
CCUTIL00 PUT1V    VAR01('THE TABLE TOP IS CLEAR') VAR02('N22') -
 VERBOSE (N)
CCUTIL00 MCAL     VAR01('') VAR02('') VERBOSE (N)
CCUTIL00 LEN      VAR01(' MY WORD IN THE STRING    ')          -
 VERBOSE (N)
CCUTIL00 SLEN     VAR01(' MY WORD IN THE STRING    ')          -
 VERBOSE (N)
CCUTIL00 OVERLAY  VAR01(' MY TEXT TO BE OVERLAYED OK!! ')      -
 VAR02('"----- ",7') VERBOSE(N)
CCUTIL00 UTDSN    VAR01('CARDS') VERBOSE (N)
CCUTIL00 TRUNC    VAR01('THE MAN WALKED HERE') -
 VAR02('x07') VERBOSE(N)
/*
//