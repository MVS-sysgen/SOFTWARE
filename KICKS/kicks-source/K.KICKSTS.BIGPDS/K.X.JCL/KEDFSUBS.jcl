//KEDFSUBS JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=7000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//KEDFON EXEC  PROC=KGCC,NAME=KEDFON,
//       LLIB='K.S.V1R5M0.KIKRPL'
//COPY.SYSUT1 DD DATA,DLM=XX

 // © Copyright 2008-2014, Michael Noel, All Rights Reserved.
 #include <stdio.h>

 #include "kicks.h"

 KIKCSA *csa;

 typedef struct _DFHCOMMAREA {
  short rc;           // return code
 } DFHCOMMAREA;

 void kedfon (KIKEIB *eib, DFHCOMMAREA *comm) {
 char *p; short myrc=0; int zero=0;
 int i, dodump=0, suppress=1;

 // get CSA addressibility
 p = ((char*)eib) - 8;         // backup into eib preface
 csa = (KIKCSA *) *((int*)p);  // pull out the csa pointer

 // do version checking
 if (csa->version != MKVER(V, R, M, E))
   KIKPCP(csa, kikpcpABND2, "VER4", &suppress);

 // post fini-abend
 static FiniAbend FA;
 for (i=0; i<16; i++) FA.fini_rtntos.regs[i] = 0;
 FA.fini_rtntos.val=0;
 FA.fini_gotovars=NULL;
 for (i=0; i<16; i++) FA.abend_rtntos.regs[i] = 0;
 FA.abend_rtntos.val=0;
 FA.abend_gotovars = NULL;
 FA.next = csa->tca->next_FA;
 csa->tca->next_FA = &FA;

 // turn on kedf
 csa->tctte->flags |= tctteflag$kedfon;

 // return to caller
 comm->rc = myrc; /* set return code */
 KIKPCP(csa, kikpcpRETN, NULL, NULL, &zero); /* goback */
 }
XX
//LKED.SYSLIN DD DSN=&&OBJSET,DISP=(OLD,DELETE)
// DD *
 ENTRY KEDFON
/*
//KEDFOFF EXEC  PROC=KGCC,NAME=KEDFOFF,
//        LLIB='K.S.V1R5M0.KIKRPL'
//COPY.SYSUT1 DD DATA,DLM=XX

 // © Copyright 2008-2014, Michael Noel, All Rights Reserved.
 #include <stdio.h>

 #include "kicks.h"

 KIKCSA *csa;

 typedef struct _DFHCOMMAREA {
  short rc;           // return code
 } DFHCOMMAREA;

 void kedfoff (KIKEIB *eib, DFHCOMMAREA *comm) {
 char *p; short myrc=0; int zero=0;
 int i, dodump=0, suppress=1;

 // get CSA addressibility
 p = ((char*)eib) - 8;         // backup into eib preface
 csa = (KIKCSA *) *((int*)p);  // pull out the csa pointer

 // do version checking
 if (csa->version != MKVER(V, R, M, E))
   KIKPCP(csa, kikpcpABND2, "VER4", &suppress);

 // post fini-abend
 static FiniAbend FA;
 for (i=0; i<16; i++) FA.fini_rtntos.regs[i] = 0;
 FA.fini_rtntos.val=0;
 FA.fini_gotovars=NULL;
 for (i=0; i<16; i++) FA.abend_rtntos.regs[i] = 0;
 FA.abend_rtntos.val=0;
 FA.abend_gotovars = NULL;
 FA.next = csa->tca->next_FA;
 csa->tca->next_FA = &FA;

 // turn off kedf
 csa->tctte->flags &= ~tctteflag$kedfon;

 // return to caller
 comm->rc = myrc; /* set return code */
 KIKPCP(csa, kikpcpRETN, NULL, NULL, &zero); /* goback */
 }
XX
//LKED.SYSLIN DD DSN=&&OBJSET,DISP=(OLD,DELETE)
// DD *
 ENTRY KEDFOFF
/*
//KEDFSTA EXEC  PROC=KGCC,NAME=KEDFSTA,
//        LLIB='K.S.V1R5M0.KIKRPL'
//COPY.SYSUT1 DD DATA,DLM=XX

 // © Copyright 2008-2014, Michael Noel, All Rights Reserved.
 #include <stdio.h>

 #include "kicks.h"

 KIKCSA *csa;

 typedef struct _DFHCOMMAREA {
  short rc;           // return code
 } DFHCOMMAREA;

 void kedfsta (KIKEIB *eib, DFHCOMMAREA *comm) {
 char *p; short myrc=0; int zero=0;
 int i, dodump=0, suppress=1;

 // get CSA addressibility
 p = ((char*)eib) - 8;         // backup into eib preface
 csa = (KIKCSA *) *((int*)p);  // pull out the csa pointer

 // do version checking
 if (csa->version != MKVER(V, R, M, E))
   KIKPCP(csa, kikpcpABND2, "VER4", &suppress);

 // post fini-abend
 static FiniAbend FA;
 for (i=0; i<16; i++) FA.fini_rtntos.regs[i] = 0;
 FA.fini_rtntos.val=0;
 FA.fini_gotovars=NULL;
 for (i=0; i<16; i++) FA.abend_rtntos.regs[i] = 0;
 FA.abend_rtntos.val=0;
 FA.abend_gotovars = NULL;
 FA.next = csa->tca->next_FA;
 csa->tca->next_FA = &FA;

 // puts kedf status into return code
 myrc =  csa->tctte->flags & tctteflag$kedfon;

 // return to caller
 comm->rc = myrc; /* set return code */
 KIKPCP(csa, kikpcpRETN, NULL, NULL, &zero); /* goback */
 }
XX
//LKED.SYSLIN DD DSN=&&OBJSET,DISP=(OLD,DELETE)
// DD *
 ENTRY KEDFSTA
/*
//
