//KB12    JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=5000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//KB12    EXEC KIKGCCCL GCCPREF='GCC.V76',PDPPREF='PDPCLIB.V76'
//COPY.SYSUT1  DD *

 // following version used when storage=auto IS specified
#include <stdlib.h>
#include "kikaid.h"

int main(KIKEIB *eib) {
short rc, which=0;
#include "kb12.h"

 EXEC CICS ASSIGN ALTSCRNHT(rc);
 if (rc == 43) which = 1;
 do {
   if (which == 0) {
    memset(&kb1224, 0, sizeof(kb1224));
    EXEC CICS SEND MAP("kb1224") MAPSET("kb12") ERASE;
    EXEC CICS RECEIVE MAP("kb1224") MAPSET("kb12") RESP(rc);
    } else {
    memset(&kb1243, 0, sizeof(kb1243));
    EXEC CICS SEND MAP("kb1243") MAPSET("kb12") ERASE ALTERNATE;
    EXEC CICS RECEIVE MAP("kb1243") MAPSET("kb12") RESP(rc);
    }
   if((eib->eibaid == KIKPF3) ||
      (!strncmp(&kb1224.kb1224i.kb1224bi,"QUIT",4)) ||
      (!strncmp(&kb1243.kb1243i.kb1243bi,"QUIT",4))) {
    EXEC CICS SEND CONTROL ERASE ;
    EXEC CICS RETURN ;
    }
   } while (1);
 }
/*
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKGCCGL)
 ENTRY @@KSTRT
 NAME KB12PGM(R)
/*
//
 // following version used when storage=auto IS specified
#include <stdlib.h>
#include "kikaid.h"

int main(KIKEIB *eib) {
short rc, which=0;
#include "kb12.h"

 EXEC CICS ASSIGN ALTSCRNHT(rc);
 if (rc == 43) which = 1;
 do {
   if (which == 0) {
    memset(&kb1224, 0, sizeof(kb1224));
    EXEC CICS SEND MAP("kb1224") MAPSET("kb12") ERASE;
    EXEC CICS RECEIVE MAP("kb1224") MAPSET("kb12") RESP(rc);
    } else {
    memset(&kb1243, 0, sizeof(kb1243));
    EXEC CICS SEND MAP("kb1243") MAPSET("kb12") ERASE ALTERNATE;
    EXEC CICS RECEIVE MAP("kb1243") MAPSET("kb12") RESP(rc);
    }
   if((eib->eibaid == KIKPF3) ||
      (!strncmp(&kb1224.kb1224i.kb1224bi,"QUIT",4)) ||
      (!strncmp(&kb1243.kb1243i.kb1243bi,"QUIT",4))) {
    EXEC CICS SEND CONTROL ERASE ;
    EXEC CICS RETURN ;
    }
   } while (1);
 }
 // following version used when storage=auto IS specified
 // -- cheats by using INTO to put 1243 map data into 1224 dsect...
#include <stdlib.h>
#include "kikaid.h"

int main(KIKEIB *eib) {
short rc, which=0;
#include "kb12.h"

 EXEC CICS ASSIGN ALTSCRNHT(rc);
 if (rc == 43) which = 1;
 do {
   memset(&kb1224, 0, sizeof(kb1224));
   if (which == 0) {
    EXEC CICS SEND MAP("kb1224") MAPSET("kb12") ERASE;
    EXEC CICS RECEIVE MAP("kb1224") MAPSET("kb12") RESP(rc);
    } else {
    EXEC CICS SEND MAP("kb1243") MAPSET("kb12") ERASE ALTERNATE
         FROM(kb1224.kb1224o);
    EXEC CICS RECEIVE MAP("kb1243") MAPSET("kb12") RESP(rc)
         INTO(kb1224.kb1224i);
    }
   if((eib->eibaid == KIKPF3) ||
      (!strncmp(&kb1224.kb1224i.kb1224bi,"QUIT",4))) {
    EXEC CICS SEND CONTROL ERASE ;
    EXEC CICS RETURN ;
    }
   } while (1);
 }
 // following version used when storage=auto is NOT specified
 // -- and if 'base=' is specified
 // --     just substitue base name for bmsmapbr
#include <stdlib.h>
#include "kikaid.h"

int main(KIKEIB *eib) {
short rc, which=0;
#include "kb12.h"

 bmsmapbr = malloc(sizeof(*bmsmapbr));

 EXEC CICS ASSIGN ALTSCRNHT(rc);
 if (rc == 43) which = 1;
 do {
   memset(bmsmapbr, 0, sizeof(*bmsmapbr));
   if (which == 0) {
    EXEC CICS SEND MAP("kb1224") MAPSET("kb12") ERASE
         FROM(bmsmapbr->kb1224o);
    EXEC CICS RECEIVE MAP("kb1224") MAPSET("kb12") RESP(rc)
         INTO(bmsmapbr->kb1224i);
    } else {
    EXEC CICS SEND MAP("kb1243") MAPSET("kb12") ERASE ALTERNATE
         FROM(bmsmapbr->kb1243o);
    //   or  (bmsmapbr->kb1224o) - same thing...
    EXEC CICS RECEIVE MAP("kb1243") MAPSET("kb12") RESP(rc)
         INTO(bmsmapbr->kb1243i);
    //   or  (bmsmapbr->kb1224i) - same thing...
    }
   if((eib->eibaid == KIKPF3) ||
      (!strncmp(bmsmapbr->kb1224i.kb1224bi,"QUIT",4))) {
    EXEC CICS SEND CONTROL ERASE ;
    EXEC CICS RETURN ;
    }
   } while (1);
 }
