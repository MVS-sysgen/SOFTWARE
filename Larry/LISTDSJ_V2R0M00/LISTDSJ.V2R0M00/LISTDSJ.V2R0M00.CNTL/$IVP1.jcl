//IVP1     JOB (SYS),'LISTDSJ IPV1',         <-- Review and Modify
//         CLASS=A,MSGCLASS=A,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  LISTDSJ for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $IVP1                                          *
//* *       Run LISTDSJ Validation                         *
//* *                                                      *
//* *  LISTDSJ validation via CLISTDSJ using BATCH TSO     *
//* *  of documented function in program documentation.    *
//* *                                                      *
//* *  Note: CLIST are resolved from SYS2.CMDPROC          *
//* *        and tagged with <--TARGET for search          *
//* *        purposes.                                     *
//* *                                                      *
//* *                                                      *
//* * Change History: <CHGHIST>                            *
//* * ==================================================== *
//* * MM/DD/CCYY Version  Name / Description               *
//* * ---------- -------  -------------------------------- *
//* * 02/27/2021 1.0.40   Larry Belmontes Jr.              *
//* *                     - Add BTSO keyword parameter to  *
//* *                       CLISTDSJ n PRMS(...)           *
//* *                                                      *
//* * 04/29/2019 1.0.00   Larry Belmontes Jr.              *
//* *                     - Initial version released to    *
//* *                       MVS 3.8J hobbyist public       *
//* *                       domain                         *
//* *                                                      *
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
CLISTDSJ X PRMS('Validate List type 1')
CLISTDSJ 1 PRMS('''HERC01.TEST.CNTL'' BTSO')
/*
//VALDAT2  EXEC BATCHTSO
//STEP01.SYSTSIN DD *
CLISTDSJ X PRMS('Validate List type 2')
CLISTDSJ 2 PRMS('''HERC01.TEST.CNTL'' BTSO')
/*
//VALDAT3  EXEC BATCHTSO
//STEP01.SYSTSIN DD *
CLISTDSJ X PRMS('Validate List type 3')
CLISTDSJ 3 PRMS('''HERC01.TEST.CNTL'' BTSO')
/*
//VALDAT4  EXEC BATCHTSO
//STEP01.SYSTSIN DD *
CLISTDSJ X PRMS('Validate List type 3 with DIR option')
CLISTDSJ 3 PRMS('''HERC01.TEST.CNTL'' DIR BTSO')
/*
//VALDAT5  EXEC BATCHTSO
//STEP01.SYSTSIN DD *
CLISTDSJ X PRMS('Validate with ABOUT option')
CLISTDSJ 1 PRMS('''HERC01.TEST.CNTL'' ABOUT BTSO')
/*
//VALDAT6  EXEC BATCHTSO
//STEP01.SYSTSIN DD *
CLISTDSJ X PRMS('Validate as to why NOT to use PNL w CLISTDSJ')
CLISTDSJ 3 PRMS('''HERC01.TEST.CNTL'' PNL BTSO')
/*
//VALDAT7  EXEC BATCHTSO
//STEP01.SYSTSIN DD *
CLISTDSJ X PRMS('Validate List type 1 with FILE option')
CLISTDSJ 1 PRMS('SYSPROC FILE BTSO')
/*
//
