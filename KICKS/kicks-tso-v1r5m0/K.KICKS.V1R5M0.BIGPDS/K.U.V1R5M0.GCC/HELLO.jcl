//HELLO   JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=5000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//HELLO   EXEC KIKGCCCL
//COPY.SYSUT1  DD *

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "helloms.h"

 int main()            {

  char save_ctimeo[8], my_abstime[8];

           EXEC KICKS ASKTIME ABSTIME(my_abstime) ;

           EXEC KICKS FORMATTIME ABSTIME(my_abstime)
             TIME(save_ctimeo) TIMESEP("")
           ;

           memset((char*)&hello.helloo, 0, sizeof(hello));
           memcpy(hello.helloo.ctimeo,
                  save_ctimeo, sizeof(hello.helloo.ctimeo));

           EXEC KICKS
             SEND MAP("hello") MAPSET("helloms") ERASE
           ;

           EXEC KICKS
             RECEIVE MAP("hello") MAPSET("helloms")
           ;

           if (!memcmp(hello.helloi.ctimei,
               save_ctimeo, sizeof(hello.helloi.ctimei)))
             memset(hello.helloo.ctimeo, '0',
                    sizeof(hello.helloo.ctimeo));
           else
             memset(hello.helloo.ctimeo, '9',
                    sizeof(hello.helloo.ctimeo));

           EXEC KICKS
             SEND MAP("hello") MAPSET("helloms") ERASE
           ;

           EXEC KICKS RETURN ;
 }
/*
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKGCCGL)
 ENTRY @@KSTRT
 NAME HELLO(R)
/*
//
