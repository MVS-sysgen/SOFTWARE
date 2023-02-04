//DCPTST  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=5000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//TESTCOB EXEC  PROC=KIKGCCCL,LBOUTC='*' (default is 'Z')
//COPY.SYSUT1 DD *
 /////////////////////////////////////////////////////////////////////
 //   KICKS is an enhancement for TSO that lets you run your CICS
 //   applications directly in TSO instead of having to 'install'
 //   those apps in CICS.
 //   You don't even need CICS itself installed on your machine!
 //
 //   KICKS for TSO
 //   © Copyright 2008-2014, Michael Noel, All Rights Reserved.
 //
 //   Usage of 'KICKS for TSO' is in all cases subject to license.
 //   See http://www.kicksfortso.com
 //   for most current information regarding licensing options..
 ////////1/////////2/////////3/////////4/////////5/////////6/////////7

 //* EXEC KICKS DELETEQ TD
 //*       QUEUE(name)
 //* ;
 //*
 //* EXEC KICKS READQ TD
 //*       QUEUE(name) INTO(data-area)
 //*      [LENGTH(data-area)] NOSUSPEND
 //* ;
 //*
 //* EXEC KICKS WRITEQ TD
 //*       QUEUE(name)
 //*       FROM(data-area) [LENGTH(data-area)]
 //* ;
 //*
 //* EXEC KICKS SPOOLOPEN OUTPUT
 //*       TOKEN(data-area) { USERID(data-value) | WRITER(data-value) }
 //*       NODE(data-value) [ CLASS(data-value) ] [ PRINT | PUNCH ]
 //* ;
 //*
 //* EXEC KICKS SPOOLOPEN INPUT                   ** NOT IMPLEMENTED **
 //*       TOKEN(data-area) USERID(data-value)  [ CLASS(data-value) ]
 //* ;
 //*
 //* EXEC KICKS SPOOLREAD                         ** NOT IMPLEMENTED **
 //*       TOKEN(data-area)  INTO(data-area)
 //*       MAXFLENGTH(data-value) TOFLENGTH(data-area)
 //* ;
 //*
 //* EXEC KICKS SPOOLWRITE
 //*       TOKEN(data-area)  FROM(data-area)  FLENGTH(data-value)
 //*      [ LINE | PAGE ]
 //* ;
 //*
 //* EXEC KICKS SPOOLCLOSE
 //*       TOKEN(data-area)  [ KEEP ]
 //* ;

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

 int main(KIKEIB *eib) {

      short rc=0;
      char  intrdr_token[10], sysout_token[10];
      char  c, card[80], log_msg[24];
      short card_length=80, i, num_cards=0;

      memset(card, ' ', 80);
      memset(log_msg, ' ', 24);
      memset(intrdr_token, ' ', 10);
      memset(sysout_token, ' ', 10);

<PRO>

     // these are tests of INTRApartition queues.

     // DELETEQ
     // WRITEQ 5 records
     // READQ the 5 records
     // DELETEQ again

           EXEC KICKS DELETEQ TD
                 QUEUE("TEST") NOHANDLE
           ;
           num_cards = 0;

           while (num_cards < 5) {
            c = '1' + num_cards;
            memset(card, c, 80);
            printf("%80s\n",card);
            EXEC KICKS WRITEQ TD
                  QUEUE("TEST") FROM(card) LENGTH(card_length)
                  RESP(rc)
            ;
            if (rc != 0) {
             printf ("BAD RETURN FROM WRITEQ, %d\n", rc);
             EXEC KICKS RETURN ;
             }
            num_cards++;
            }
           num_cards = 0;
           printf("\n");
           while (num_cards < 5) {
            EXEC KICKS READQ TD
                  QUEUE("TEST") INTO(card) LENGTH(card_length)
                  RESP(rc)
            ;
            if (rc != 0) {
             printf ("BAD RETURN FROM READQ, %d\n", rc);
             EXEC KICKS RETURN ;
             }
            printf("%80s\n",card);
            num_cards++;
            }

           EXEC KICKS DELETEQ TD
                 QUEUE("TEST") RESP(rc)
           ;
           if (rc != 0) {
            printf ("BAD RETURN FROM DELETEQ (2ND) %d\n", rc);
            EXEC KICKS RETURN ;
            }
           num_cards = 0;
           printf("\n");
</PRO>

     // these are tests of EXTRApartition queues.

     // SPOOLOPEN iD rdr, then read cards with READQ and send
     // to intrdr with SPOOLWRITE, and on eof do SPOOLCLOSE
     // to submit job (if num cards read > 0). write message
     // with num cards submitted with WRITEQ.

           while (rc == 0) {
            EXEC KICKS READQ TD
                  QUEUE("SYSI") INTO(card) LENGTH(card_length)
                  NOSUSPEND
                  RESP(rc)
            ;
            if (rc == 0) {
             num_cards++;
             if (num_cards == 1) {
              EXEC KICKS SPOOLOPEN OUTPUT
                    TOKEN(intrdr_token) WRITER("INTRDR")
                    NODE("*")
                    RESP(rc)
              ;
              if (rc != 0) {
               printf ("BAD RETURN FROM SPOOLOPEN (1st), %d\n", rc);
               EXEC KICKS RETURN ;
               }
              }
             EXEC KICKS SPOOLWRITE
                   TOKEN(intrdr_token) FROM(card) FLENGTH(80)
                   RESP(rc)
             ;
             if (rc != 0) {
              printf ("BAD RETURN FROM SPOOLWRITE (1ST), %d\n", rc);
              EXEC KICKS RETURN ;
              }
             }
            } // end of while (rc == 0) reading TD queue

           if (rc != KIKRESP(QZERO)) {
            printf ("BAD RETURN FROM READQ, %d\n", rc);
            EXEC KICKS RETURN ;
            }
           if (num_cards > 0) {
            EXEC KICKS SPOOLCLOSE
                  TOKEN(intrdr_token)
                  RESP(rc)
            ;
            if (rc != 0) {
             printf ("BAD RETURN FROM SPOOLCLOSE (1st), %d\n", rc);
             EXEC KICKS RETURN ;
             }
            }
           sprintf(log_msg, "%d JCL CARDS SUBMITED.", num_cards);
           EXEC KICKS WRITEQ TD
                 QUEUE("LOG") FROM(log_msg) LENGTH(strlen(log_msg))
                 RESP(rc)
           ;
            if (rc != 0) {
             printf ("BAD RETURN FROM WRITEQ, %d\n", rc);
             EXEC KICKS RETURN ;
             }

     // SPOOLOPEN sysout, then write ten lines of all 'KICKS '
     // using SPOOLWRITE, then SPOOLCLOSE to print the lines
     // then write message the sysout sent with WRITEQ.

           EXEC KICKS SPOOLOPEN OUTPUT
                 TOKEN(sysout_token) CLASS("A")
                 USERID("*") NODE("*")
                 RESP(rc)
           ;
           if (rc != 0) {
            printf ("BAD RETURN FROM SPOOLOPEN (2ND), %d\n", rc);
            EXEC KICKS RETURN ;
            }

           memcpy(log_msg, "KICKS KICKS KICKS KICKS ", 24);
           for (i=0; i<10; i++) {
            EXEC KICKS SPOOLWRITE
                  TOKEN(sysout_token) FROM(log_msg) FLENGTH(24)
                  RESP(rc)
            ;
            if (rc != 0) {
             printf ("BAD RETURN FROM SPOOLWRITE (2ND), %d\n", rc);
             EXEC KICKS RETURN ;
             }
            }

           EXEC KICKS SPOOLCLOSE
                 TOKEN(sysout_token)
                 RESP(rc)
           ;
           if (rc != 0) {
            printf ("BAD RETURN FROM SPOOLCLOSE (2ND), %d\n", rc);
            EXEC KICKS RETURN ;
            }

     //    done now...

           EXEC KICKS RETURN ;
 }
/*
//LKED.SYSLMOD DD DSN=&&GOSET(TESTCOB),UNIT=SYSDA,
//     SPACE=(1024,(50,20,1)),DISP=(MOD,PASS)
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKGCCGL)
 ENTRY @@KSTRT
 NAME  TESTCOB(R)
/*
//GO EXEC PGM=KIKSIP1$,COND=(4,LT,TESTCOB.LKED),
//   REGION=2000K,TIME=1,
//   PARM='SIT=B$ ICVR=0 '
//* kiksip1$ comes from steplib...
//STEPLIB  DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//* tables come from skikload...
//SKIKLOAD DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//* programs & maps come from kikrpl...
//KIKRPL   DD DSN=&&GOSET,DISP=(OLD,DELETE),
//         DCB=BLKSIZE=32000
//         DD DSN=K.S.V1R5M0.KIKRPL,DISP=SHR
//*
//SYSPRINT DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=80)
//SYSTERM  DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=80)
//SYSOUT   DD SYSOUT=*,DCB=BLKSIZE=132
//CRLPOUT  DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=132)
//TRANDUMP DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=132)
//SYSUDUMP DD SYSOUT=*
//*
//SYSO     DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=132)
//SYSI     DD DATA,DLM=XX
//DCPTST2  JOB  MSGCLASS=A,MSGLEVEL=(1,1),USER=HERC01,TYPRUN=SCAN
//  EXEC PGM=IEFBR14
//
XX
//*
//AUXTRC   DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=120)
//*
//KIKTEMP  DD DSN=K.S.V1R5M0.KIKTEMP,DISP=SHR
//KIKINTRA DD DSN=K.S.V1R5M0.KIKINTRA,DISP=SHR
//*
//SYSIN    DD DUMMY,DCB=(RECFM=F,BLKSIZE=80)
//*
//CRLPIN   DD *,DCB=BLKSIZE=80
KEDF ON<ENTER>
TCOB<ENTER>
/*
//
