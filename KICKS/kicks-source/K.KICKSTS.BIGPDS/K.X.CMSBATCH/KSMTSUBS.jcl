//KSMTSUBS  JOB  CLASS=C,MSGCLASS=Z
// EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN DD DUMMY,DCB=BLKSIZE=80
//SYSUT2 DD UNIT=10D,DISP=OLD,DCB=BLKSIZE=80
//SYSUT1 DD DATA,DLM=$$,DCB=BLKSIZE=3120
ID CMSBATCH
/JOB CMSUSER 123456 KSMTSUBS
$$
// DD DSN=K.X.CMSBATCH(MAPN),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCGET),DISP=SHR
// DD DATA,DLM=$$
MAPN
KBLOCK KSMTSUBS
KGCCGET
VMARC UNPACK ASYSH VMARC N = = A
KIKGCCCL KTRCON * * KIKSRPL * NONE
 // © Copyright 2008-2014, Michael Noel, All Rights Reserved.
 #include <stdio.h>

#include "kicks.h"

 KIKCSA *csa;

 typedef struct _DFHCOMMAREA {
  short rc;           // return code
 } DFHCOMMAREA;

 void ktrcon (KIKEIB *eib, DFHCOMMAREA *comm) {
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

 // turn on internal trace, err if no trace table...
 if (csa->trc.trcnum > 0) csa->trc.trcflags |= 1;
 else myrc = -1;

 // return to caller
 comm->rc = myrc; /* set return code */
 KIKPCP(csa, kikpcpRETN, NULL, NULL, &zero); /* goback */
 }
/*
KIKGCCCL KTRCOFF * * KIKSRPL * NONE
 // © Copyright 2008-2014, Michael Noel, All Rights Reserved.
 #include <stdio.h>

#include "kicks.h"

 KIKCSA *csa;

 typedef struct _DFHCOMMAREA {
  short rc;           // return code
 } DFHCOMMAREA;

 void ktrcoff (KIKEIB *eib, DFHCOMMAREA *comm) {
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

 // turn off internal trace, NO ERR if no trace table...
 csa->trc.trcflags ¬= 1;

 // return to caller
 comm->rc = myrc; /* set return code */
 KIKPCP(csa, kikpcpRETN, NULL, NULL, &zero); /* goback */
 }
/*
KIKGCCCL KTRCSTA * * KIKSRPL * NONE
 // © Copyright 2008-2014, Michael Noel, All Rights Reserved.
 #include <stdio.h>

#include "kicks.h"

 KIKCSA *csa;

 typedef struct _DFHCOMMAREA {
  short rc;           // return code
 } DFHCOMMAREA;

 void ktrcsta (KIKEIB *eib, DFHCOMMAREA *comm) {
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

 // puts trcflags into return code
 myrc = csa->trc.trcflags;

 // return to caller
 comm->rc = myrc; /* set return code */
 KIKPCP(csa, kikpcpRETN, NULL, NULL, &zero); /* goback */
 }
/*
KIKGCCCL KTRCAON * * KIKSRPL * NONE
 // © Copyright 2008-2014, Michael Noel, All Rights Reserved.
 #include <stdio.h>

#include "kicks.h"

 KIKCSA *csa;

 typedef struct _DFHCOMMAREA {
  short rc;           // return code
 } DFHCOMMAREA;

 void ktrcaon (KIKEIB *eib, DFHCOMMAREA *comm) {
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

 // turn on aux trace
 csa->trc.trcflags |= 2;

 // return to caller
 comm->rc = myrc; /* set return code */
 KIKPCP(csa, kikpcpRETN, NULL, NULL, &zero); /* goback */
 }
/*
KIKGCCCL KTRCAOF * * KIKSRPL * NONE
 // © Copyright 2008-2014, Michael Noel, All Rights Reserved.
 #include <stdio.h>

#include "kicks.h"

 KIKCSA *csa;

 typedef struct _DFHCOMMAREA {
  short rc;           // return code
 } DFHCOMMAREA;

 void ktrcaof (KIKEIB *eib, DFHCOMMAREA *comm) {
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

 // turn off aux trace
 csa->trc.trcflags ¬= 2;

 // return to caller
 comm->rc = myrc; /* set return code */
 KIKPCP(csa, kikpcpRETN, NULL, NULL, &zero); /* goback */
 }
/*
KIKGCCCL KTRCINON * * KIKSRPL * NONE
 // © Copyright 2008-2014, Michael Noel, All Rights Reserved.
 #include <stdio.h>

#include "kicks.h"

 KIKCSA *csa;

 typedef struct _DFHCOMMAREA {
  short rc;           // return code
 } DFHCOMMAREA;

 void ktrcinon (KIKEIB *eib, DFHCOMMAREA *comm) {
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

 // turn on intense trace, NO ERR if no trace table...
 csa->trc.trcflags |= 8;

 // return to caller
 comm->rc = myrc; /* set return code */
 KIKPCP(csa, kikpcpRETN, NULL, NULL, &zero); /* goback */
 }
/*
KIKGCCCL KTRCINOF * * KIKSRPL * NONE
 // © Copyright 2008-2014, Michael Noel, All Rights Reserved.
 #include <stdio.h>

#include "kicks.h"

 KIKCSA *csa;

 typedef struct _DFHCOMMAREA {
  short rc;           // return code
 } DFHCOMMAREA;

 void ktrcinof (KIKEIB *eib, DFHCOMMAREA *comm) {
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

 // turn off intense trace, NO ERR if no trace table...
 csa->trc.trcflags ¬= 8;

 // return to caller
 comm->rc = myrc; /* set return code */
 KIKPCP(csa, kikpcpRETN, NULL, NULL, &zero); /* goback */
 }
/*
KIKGCCCL KICVRGET * * KIKSRPL * NONE
 // © Copyright 2008-2014, Michael Noel, All Rights Reserved.
 #include <stdio.h>

#include "kicks.h"

 KIKCSA *csa;

 typedef struct _DFHCOMMAREA {
  short rc;           // return code
  short junk;         // ** make alignment explicit **
  int icvr;           // the value
 } DFHCOMMAREA;

 void kicvrget (KIKEIB *eib, DFHCOMMAREA *comm) {
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

 // return value of AICAmax
 comm->icvr = csa->AICAmax;

 // return to caller
 comm->rc = myrc; /* set return code */
 KIKPCP(csa, kikpcpRETN, NULL, NULL, &zero); /* goback */
 }
/*
KIKGCCCL KICVRPUT * * KIKSRPL * NONE
 // © Copyright 2008-2014, Michael Noel, All Rights Reserved.
 #include <stdio.h>

#include "kicks.h"

 KIKCSA *csa;

 typedef struct _DFHCOMMAREA {
  short rc;           // return code
  short junk;         // ** make alignment explicit **
  int icvr;           // the value
 } DFHCOMMAREA;

 void kicvrput (KIKEIB *eib, DFHCOMMAREA *comm) {
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

 // store value of AICAmax
 csa->AICAmax = comm->icvr;

 // return to caller
 comm->rc = myrc; /* set return code */
 KIKPCP(csa, kikpcpRETN, NULL, NULL, &zero); /* goback */
 }
/*
COPY * LKEDIT A = = N (REPLACE
/*
$$
//
