//PLI2DTEC JOB (001),'TEST GETDTE',              <-- Review and Modify
//             CLASS=A,MSGCLASS=A,REGION=0M,     <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  Test Driver to sample PL/I call to GETDTE           *
//* -------------------------------------------------------*
//STEP01   EXEC PL1LFCLG,
//        REGION.PL1L=256K,
//        PARM.PL1L='L,E,A,X,M,S2,NT,SORMGIN=(2,72,1),LINECNT=55',
//        PARM.LKED='XREF,LIST',
//        COND.LKED=(0,NE,PL1L),
//        COND.GO=(0,NE,LKED)
//PL1L.SYSIN DD *
1  PL12DTE: PROC OPTIONS (MAIN);
   /*************************************************************/
   /*                                                           */
   /* Program: PLI2DTE                                          */
   /*                                                           */
   /* Author:  Larry Belmontes                                  */
   /* https://www.shareabitofit.net/GETDTE-in-MVS38J            */
   /*                                                           */
   /* Purpose: This program calls GETDTE and displays results   */
   /*          via DISPLAY and SYSOUT DD.                       */
   /*                                                           */
   /*          This program call GETDTE with and with no parms  */
   /*          for testing purposes.                            */
   /*                                                           */
   /*          This program serves as a sample of PL/I calling  */
   /*          GETDTE.                                          */
   /*                                                           */
   /* Disclaimer:                                               */
   /* -----------                                               */
   /* No guarantee; No warranty; Install / Use at your own risk.*/
   /*                                                           */
   /* This software is provided ôAS ISö and without any         */
   /* expressed or implied warranties, including, without       */
   /* limitation, the implied warranties of merchantability     */
   /* and fitness for a particular purpose.                     */
   /*                                                           */
   /* The author requests keeping authors name intact in any    */
   /* modified versions.                                        */
   /*                                                           */
   /* In addition, the author requests submissions regarding    */
   /* any code modifications / enhancements and/or associated   */
   /* comments for consideration into a subsequent release      */
   /* (giving credit to contributor(s)) thus, improving overall */
   /* functionality benefiting the MVS 3.8J hobbyist public     */
   /* domain community.                                         */
   /*                                                           */
   /*************************************************************/


   /*************************************************************/
   /* Declare GETDTE  Entry Point                               */
   /*************************************************************/
      DCL GETDTE  ENTRY  ;
   /*************************************************************/
   /* Declare GETDTE  Parm List per PLI                         */
   /*************************************************************/
   /* IBM MANUAL: GC28-6594-7 PLI/F Programmers Guide Jan 1971  */
   /* Refer to the above manual for explanation related to      */
   /* declaring the GETDTE parm list as described in section    */
   /* Communications with Other Languages, Chapter 15, p.212    */
   /*************************************************************/
      DCL DTECOM  CHAR(80),
          DTPARML FIXED DEC(1,0) BASED(DTPARM1);
   /*************************************************************/
   /* Declare GETDTE  Detailed Parm List                        */
   /*************************************************************/
      DCL 1 DTECOM_A BASED(DTPARM1),
           2 RDATE,
            3 RDATEMM         CHAR(02),
            3 RDATES1         CHAR(01),
            3 RDATEDD         CHAR(02),
            3 RDATES2         CHAR(01),
            3 RDATECC         CHAR(02),
            3 RDATEYY         CHAR(02),
            3 RDATES3         CHAR(01),
            3 RDATEJJJ        CHAR(03),
           2 RDATES4          CHAR(01),
           2 RTIME,
            3 RTIMEHH         CHAR(02),
            3 RTIMES1         CHAR(01),
            3 RTIMEMM         CHAR(02),
            3 RTIMES2         CHAR(01),
            3 RTIMESS         CHAR(02),
            3 RTIMES3         CHAR(01),
            3 RTIMETT         CHAR(02),
           2 RMONTH_NAME      CHAR(09),
           2 RDAY_NUM         CHAR(01),
           2 RDAY_NAME        CHAR(09),
           2 RJOB_NAME        CHAR(08),
           2 RSTEP_NAME       CHAR(08),
           2 RPROC_STEP_NAME  CHAR(08),
           2 RENV             CHAR(05),
           2 RPARMTY          CHAR(06);
1  /*************************************************************/
   /* Declare Others...                                         */
   /*************************************************************/
      DCL PRTOUT FILE RECORD OUTPUT
          ENV(CTLASA F(101));
      DCL   PRT_REC_AREA   CHAR(101);
      DCL 1 PRT_REC DEFINED PRT_REC_AREA,
            2 PRT_CC       CHAR(1),
            2 PRT_REC_DATA,
              3 FILLER       CHAR(80);

1  /*************************************************************/
   /* Open DD PRTOUT for printing                               */
   /*************************************************************/
      DISPLAY ('Start PL1 to DTE');
      PUT FILE(SYSPRINT)
          SKIP EDIT ('Start PL1 to GETDTE')(A);
      OPEN FILE(PRTOUT);
   /*************************************************************/
   /* Setup Parm and invoke GETDTE                              */
   /*************************************************************/
      DTPARM1 = ADDR (DTECOM);
      CALL GETDTE (DTPARML);
   /* DISPLAY (DTECOM);    */
   /*************************************************************/
   /* Print DTECOM string on PRTOUT                             */
   /*************************************************************/
      PRT_CC       = ' ';
      PRT_REC_DATA = DTECOM;
      WRITE FILE(PRTOUT) FROM(PRT_REC_AREA);
   /*************************************************************/
   /* Close DD PRTOUT                                           */
   /*************************************************************/
      CLOSE FILE(PRTOUT);

   /*************************************************************/
   /* Done: Return to OS                                        */
   /*************************************************************/
      END PL12DTE;
/*
//LKED.SYSLIB DD
//            DD DSN=SYS2.LINKLIB,DISP=SHR        -- GETDTE
//LKED.SYSLMOD DD DSNAME=&&GOSET(GO),DISP=(MOD,PASS),
//        UNIT=SYSALLDA,SPACE=(1024,(70,30,5),RLSE)
//GO.SYSPRINT DD SYSOUT=*                         -- PUT     output
//GO.SYSOUT   DD SYSOUT=*
//GO.PRTOUT   DD SYSOUT=*                         -- REPORT  output
//GO.SYSDUMP  DD SYSOUT=*
//GO.SYSABEND DD SYSOUT=*
//
