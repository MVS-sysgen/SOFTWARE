//KFDEFLT   JOB  CLASS=C,MSGCLASS=Z
// EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN DD DUMMY,DCB=BLKSIZE=80
//SYSUT2 DD UNIT=10D,DISP=OLD,DCB=BLKSIZE=80
//SYSUT1 DD DATA,DLM=$$,DCB=BLKSIZE=3120
ID CMSBATCH
/JOB CMSUSER 123456 KFDEFLT
$$
// DD DSN=K.X.CMSBATCH(MAPN),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCGET),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCE),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCEL),DISP=SHR
// DD DATA,DLM=$$
MAPN
KBLOCK KFDEFLT
KGCCGET
VMARC UNPACK ASYSH VMARC N = = A
KGCCE KFDEFLT
 /////////////////////////////////////////////////////////////////////
 // 'KICKS for TSO' is a product to deliver 'CICS like' functionality
 // in MVS/TSO. Its CICS functionality is delivered at the source code
 // level, not at the object code level. Applications must be
 // recompiled and the recompiled programs are not compatible with any
 // known version of 'real' CICS (the IBM program product),
 //
 // © Copyright 2008-2014, Michael Noel, All Rights Reserved.
 //
 // Usage of 'KICKS for TSO' is in all cases subject to license. See
 // http://www.kicksfortso.com
 // for most current information regarding licensing options..
 ////////1/////////2/////////3/////////4/////////5/////////6/////////7


 // This program, a CMS only utility, is little more than a gutted SIP
 // that selects the 'appropriate' FCT (via the usual SIT process),
 // loads it, and returns vsam file sharing parms.


 // following define tells kicks.h not to extern the globals
#define KIKSIP

#include <stdio.h>

#include "kicks.h"

#include "extid.h"

#include "fcthdr.h"

 // for globals that are NOT effected by SIT processing
void gbl_i1(KIKCSA *csa) {
  extid *extbuf;

 // CSA itself
 // clear csa
 memset(csa, 0, sizeof(*csa));

 // set version
 csa->version = MKVER(V, R, M, E);

 // preset csa table default suffixes
 memcpy(&csa->sit_table_suffix, "00",2);
 memcpy(&csa->fcp_table_suffix, "00",2);

 // TCTTE
 // set the tctte pointer and clear it
 memset((char*)&kiktctte, 0, sizeof(kiktctte));
 csa->tctte = &kiktctte;

 // use DIAG 0 to obtain version flag
 __asm__ (
  "LA 2,B%=\n\t"
  "ST 2,%0\n\t"
  "LA 3,40\n\t"
  "DC X'83',X'23',XL1'0000'\n\t"
  "B P%=\n"
 "B%= DS 5D inline storage to ensure dw alignment\n"
 "P%= EQU *"
  : "=m"(extbuf)
  : /* no input */
  : "2", "3"
 );

 if (!strncmp(extbuf->vm370.system, "VM/370", 6)) {
  // vm/370 24 bit system
  csa->systype = csasystype$vm6pk;
  }
 else
 if (!strncmp(extbuf->vm370.system, "VM/SP", 5)) {
  // vm/sp 24 bit system
  csa->systype = csasystype$vmsp;
  }
 else {
  // 31 bit capable...
  csa->systype = csasystype$zvm;
  }

 // also capture userid from extbuf
 // user id in same place for either system...
 memcpy(csa->tctte->usrid, extbuf->vm370.userid, 8);

 // TIOA
 // set tioa pointer & clear it
 csa->tctte->tioa = (char*)&tioabuf;
 csa->tctte->tioasize = sizeof(tioabuf);
 memset((char*)csa->tctte->tioa, 0, csa->tctte->tioasize);

 // LOADCB
 // set loadcb pointer, clear it, point to loader pgm
 csa->loadcb = &loadcb;
 memset(csa->loadcb, 0, sizeof(loadcb));
 csa->loadcb->loader = (char*)&kikload;

 // preset SKIKLOAD for system pgm & table loads
 memcpy(&csa->loadcb->loadlib, "SKIKLOAD", 8);
 kikload(csa, 0); // might as well open too
}

// sub used by merge_parms sub
int merge_tst(KIKCSA *csa, char *str) {
 int strl = strlen(str);
 if (!memcmp(csa->tctte->tioa, str, strl))
  if ((*(csa->tctte->tioa+strl) != 0) &&
      (*(csa->tctte->tioa+strl) != ' ')) return(true);
 return(false);
 }

// sub used by main to merge SIT parms from parms and sysin
void merge_parms(KIKCSA *csa) {
char *ip; long L;
 if (merge_tst(csa, "FCT="))
  memcpy(&csa->fcp_table_suffix, (csa->tctte->tioa)+4, 2);
}


void stackit(char *catuserid,
     unsigned short catlnk1, unsigned short  catlnk2,
     char *catpasswd, char *catfm, char *catvol, char * me) {
 char line[80], *aline=&line[0]; int alinel;
 // clear stack
 while (chkstk() > 0) rdstk(line, 80);
 // catuser catlnk1 catlnk2 catpass catfm catvol me
 sprintf(aline, "%8.8s %X %X %8.8s %1.1s %6.6s %8.8s",
   catuserid,
   catlnk1,
   catlnk2,
   catpasswd,
   catfm,
   catvol,
   me);
 alinel = strlen(aline);
 //printf("%s\n", aline);
  __asm__ (
   "LA  1,S%=\n\t"
   "L   0,%0\n\t"
   "ST  0,12(,1)\n\t"
   "L   0,%1\n\t"
   "STC 0,12(,1)\n\t"
   "SVC 202\n\t"
   "DC AL4(*+4)\n\t"
   "B X%=\n"
  "S%= DS 0D\n\t"
   "DC CL8'ATTN'\n\t"
   "DC CL4'FIFO'\n\t"
   "DC AL1(0)\n\t"
   "DC AL3(0)\n\t"
   "DC 8X'FF'\n"
  "X%= EQU *"
  : /* no output */
  : "m"(aline), "m"(alinel)
  : "0", "1", "15"
  );
 }


int main (int argc, char *argv[]) { // kiksip is main...
KIKCSA *csa;
int i; char *ip, firstnl[8]; long L;
fcth *fcthdr;

 // setup globals
 csa = &kikcsa; gbl_i1(csa);

 // pass 1 over cmd line arguments for possible 'SIT='
 for (i = 1; i < argc; i++)
  if (!memcmp(argv[i], "SIT=", 4))
   if ((*(argv[i]+4) != 0) && (*(argv[i]+4) != ' ')) {
   memcpy(&csa->sit_table_suffix, (argv[i])+4, 2);
   // load the SIT specified
   memcpy(&csa->loadcb->loadbase, "KIKSIT", 6);
   memcpy(&csa->loadcb->loadsuffix, &csa->sit_table_suffix, 2);
   kikload(csa, 2);
   if (csa->loadcb->loaderr1 != 0) {
    fprintf (stderr, "SIT table %8.8s failed to load %x(%x)\n",
      &csa->loadcb->loadbase, csa->loadcb->loaderr1,
      csa->loadcb->loaderr15);
    stackit("",0,0,"","","","");
    exit(999);
    }
   else {
    csa->sit_table_addr = (KIKSIT *)csa->loadcb->loadedwhere;
    if (memcmp((char *)&csa->version, &csa->sit_table_addr->ver, 4)) {
     fprintf (stderr, "SIT version does not match CSA!\n");
     stackit("",0,0,"","","","");
     exit (999);
     }
    // merge in SIT suffixes/parms
    memcpy(&csa->fcp_table_suffix,
           &csa->sit_table_addr->fcp_table_suffix, 2);
    }
   }

 // pass 2 over cmd line arguments for other suffixes/parms
 for (i = 1; i < argc; i++) {
  strcpy(csa->tctte->tioa, argv[i]);
  merge_parms(csa);
  }

 // load the system programs and tables
 memcpy(&csa->loadcb->loadbase, "KIKFCT", 6);
 memcpy(&csa->loadcb->loadsuffix, &csa->fcp_table_suffix, 2);
 kikload(csa, 2);
 if (csa->loadcb->loaderr1 != 0) {
  fprintf (stderr, "FCT table %8.8s failed to load %x(%x)\n",
    &csa->loadcb->loadbase, csa->loadcb->loaderr1,
    csa->loadcb->loaderr15);
  stackit("",0,0,"","","","");
  exit(999);
  }
 csa->fcp_table_addr = csa->loadcb->loadedwhere;
 fcthdr = (fcth *)csa->fcp_table_addr;

 if (memcmp((char *)&csa->version, &fcthdr->ver[0], 4)) {
  fprintf (stderr, "FCT version does not match CSA!\n");
  stackit("",0,0,"","","","");
  exit (999);
  }

 // done loading system programs, close loader dcb
 kikload(csa, 1); // close prev open

 // now stack FCT info (and userid)
 stackit(
   fcthdr->catuserid,
   fcthdr->catlnk1,
   fcthdr->catlnk2,
   fcthdr->catpasswd,
   fcthdr->catfm,
   fcthdr->catvol,
   csa->tctte->usrid);

 // that's all folks!
 exit (0);
}

/*
KGCCEL KFDEFLT @@main
 INCLUDE KIKENTRY
 INCLUDE KFDEFLT
 INCLUDE KIKLOAD
/*
GLOBAL TXTLIB KIKULOD KIKSLOD KIKURPL KIKSRPL KIKSAMPL
LOAD KFDEFLT
START * SIT=1$
/*
$$
//
