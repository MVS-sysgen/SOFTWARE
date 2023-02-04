//TSPTST  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=4000K
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

 //    EXEC KICKS DELETEQ TS
 //          QUEUE(name)
 //    ;
 //    EXEC KICKS READQ TS
 //          QUEUE(name)
 //          INTO(data-area) [LENGTH(data-area)]
 //         [NUMITEMS(data-area)] [ITEM(data-value) | NEXT}
 //    ;
 //    EXEC KICKS WRITEQ TS
 //          QUEUE(name)
 //          FROM(data-area) [LENGTH(data-area)]
 //         [ITEM(data-value) [REWRITE]]
 //         [NUMITEMS(data-area)] [MAIN | AUXILIARY]
 //          NOSUSPEND
 //    ;
 //  In KICKS, WRITEQ TS (and READQ TD) assume NOSUSPEND even if
 //  you don't specify it, in which case a 'remark' (return code 2)
 //  results at compile time to alert you to the issue.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


 short i, rc;
 char  card[82];
 short card_length, num_cards=0, card_num, direction=1;

 void Read_and_Print(void);


 int main(KIKEIB *eib) {


<NPRO>
      // Since this entire test is 'PRO only' it uses the 'KLASTCCP'
      // subroutine to set the KICKS return code when it's run in a
      // non-PRO system.

      struct {
       short last_ca_return;
       short last_ca_lastcc;
       } last_ca;

           last_ca.last_ca_return = 0;
           last_ca.last_ca_lastcc = 8;
           EXEC KICKS LINK PROGRAM("KLASTCCP") NOHANDLE
               COMMAREA(last_ca) ;
           EXEC KICKS RETURN ;

  }
</NPRO>


<PRO>

           // delete TS queue
           EXEC KICKS DELETEQ TS
             QUEUE("TSTST")
                 RESP(rc)           ;
           if((rc != 0 ) && (rc != KIKRESP(QIDERR))) {
            printf("BAD RETURN FROM DELETEQ TS %d\n", rc);
            EXEC KICKS RETURN ;
            }

           while (1) { // read card images into TS queue
            memset(card, ' ', 82);
            card_length=80;
            EXEC KICKS READQ TD
                  QUEUE("SYSI") INTO(card) LENGTH(card_length)
                  RESP(rc)
            ;
            if (rc != 0) break;
            num_cards++;

            EXEC KICKS WRITEQ TS QUEUE("TSTST")
                 FROM(card) LENGTH(card_length)
            ;

            printf("%s\n", card);
            }

           if (rc != KIKRESP(QZERO)) {
            printf("BAD RETURN FROM READQ TD %d\n", rc);
            EXEC KICKS RETURN ;
            }

           printf("\n");
           Read_and_Print();

           EXEC KICKS SYNCPOINT ;

           printf("\n");
           Read_and_Print();

           // do some READ NEXT's

           printf("\n");
           EXEC KICKS READQ TS
                 QUEUE("TSTST") INTO(card) ITEM(1)
           ;
           printf("%s\n", card);

           EXEC KICKS READQ TS
                 QUEUE("TSTST") INTO(card) NEXT
           ;
           printf("%s\n", card);

           EXEC KICKS READQ TS
                 QUEUE("TSTST") INTO(card) NEXT
           ;
           printf("%s\n", card);

           // do a REWRITE test
           for (i=0; i<80; i++) card[i] = '4';
           EXEC KICKS WRITEQ TS QUEUE("TSTST")
                 FROM(card) LENGTH(80)
                 REWRITE ITEM(2)
           ;

           printf("\n");
           Read_and_Print();

           // time to quit

           EXEC KICKS DELETEQ TS
             QUEUE("TSTST")
           ;

           EXEC KICKS RETURN ;
  }

 void Read_and_Print() {

            card_num = 0;
            if(direction < 0) card_num = num_cards + 1;

            while (1) {
             if (direction > 0) card_num++; else card_num--;
             EXEC KICKS READQ TS
                   QUEUE("TSTST") INTO(card)
                   ITEM(card_num)
                   RESP(rc)
             ;
             if(rc != 0) break;
             printf("%s\n", card);
             }

           if (rc != KIKRESP(ITEMERR)) {
            printf("BAD RETURN FROM READQ TS %d\n", rc);
            EXEC KICKS RETURN ;
            }

           direction *= -1; // go other way next time...
  }
</PRO>
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
//   PARM='SIT=B$ ICVR=0'
//*        use TRCFLAGS=3 for auxtrace
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
//AUXTRC   DD SYSOUT=*,DCB=(RECFM=V,BLKSIZE=2000)
//SYSUDUMP DD SYSOUT=*
//*
//SYSO     DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=132)
//SYSI     DD *
3333333333333333333333333333333
22222222222222222222222222222
11111111111111111111111111
/*
//KIKTEMP  DD DSN=K.S.V1R5M0.KIKTEMP,DISP=SHR
//*
//SYSIN    DD DUMMY,DCB=(RECFM=F,BLKSIZE=80)
//*
//CRLPIN   DD *,DCB=BLKSIZE=80
<CLEAR>            PREPARE TO ENTER NEXT TRANSACTION
CRLP BORDER<ENTER> SHOW CRLP OPTIONS
<CLEAR>            PREPARE TO ENTER NEXT TRANSACTION
KEDF ON<ENTER>     TURN ON KEDF
<CLEAR>            PREPARE TO ENTER NEXT TRANSACTION
TCOB<ENTER>        START THE TEST
/*
//
