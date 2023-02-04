//KLOGIT  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=5000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//KLOGIT  EXEC KIKGCCCL
//COPY.SYSUT1  DD *
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
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
 typedef struct __mycomm__ {
     char msg[1];
 } mycomm;
 typedef struct __mymsg__ {
     char date[8];
     char fil1;
     char time[8];
     char fil2;
     char user[8];
     char fil3;
     char term[4];
     char fil4;
     char tran[4];
     char fil5;
     char msg[95];
 } mymsg;
 int main(KIKEIB *eib, mycomm *KIKCOMM) {
  char  ws_abstime[8];
  mymsg logmsg;
  int mylong;
           memset(&logmsg, ' ', sizeof(logmsg));
           EXEC KICKS ASKTIME ABSTIME(ws_abstime) ;
           EXEC KICKS FORMATTIME ABSTIME(ws_abstime)
             MMDDYY(logmsg.date) DATESEP("/") ;
           EXEC KICKS FORMATTIME ABSTIME(ws_abstime)
             TIME(logmsg.time) TIMESEP(":") ;
           memcpy(logmsg.user, eib->eibusrid, 8);
           memcpy(logmsg.term, eib->eibtrmid, 4);
           memcpy(logmsg.tran, eib->eibtrnid, 4);
           mylong = eib->eibcalen;
           if (mylong > sizeof(logmsg.msg))
               mylong = sizeof(logmsg.msg);
           memcpy(logmsg.msg, KIKCOMM->msg, mylong);
           mylong -= sizeof(logmsg.msg);
           mylong += sizeof(logmsg);
           EXEC KICKS WRITEQ TD QUEUE("LOG")
                 FROM(logmsg) LENGTH(mylong)
                 NOHANDLE ;
           EXEC KICKS RETURN ;
 }
/*
//LKED.SYSLMOD DD DSN=K.S.V1R5M0.KIKRPL,DISP=SHR
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKGCCGX)
 ENTRY @@KSTRT
 NAME KLOGIT(R)
/*
//
