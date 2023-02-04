//KIKMACLB  JOB  CLASS=C,MSGCLASS=Z
// EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN DD DUMMY,DCB=BLKSIZE=80
//SYSUT2 DD UNIT=10D,DISP=OLD,DCB=BLKSIZE=80
//SYSUT1 DD DATA,DLM=$$,DCB=BLKSIZE=3120
ID CMSBATCH
/JOB CMSUSER 123456 KIKMACLB
$$
// DD DSN=K.X.CMSBATCH(MAPN),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCGET),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCE),DISP=SHR
// DD DATA,DLM=$$
MAPN
KBLOCK KIKMACLB
KGCCE KIKMACLB
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

#include <stdlib.h>
#include <stdio.h>


 // very simple routines to read
 // only up to 10 fb80 CMS file at once
 // use for MACLIB to allow skipping 61FFFF61 records...

typedef struct {
 char  fscbcomm[8]; // +0    file system command (rdbuf, wrbuf, etc)
 char  fscbfn[8];   // +8    file name
 char  fscbft[8];   // +16   file type
 char  fscbfm[2];   // +24   file mode
 unsigned short fscbitno; // +26   relative record number to be rd/wr
 char *fscbbuff;    // +28   address of r/w buffer or of statefst
 int   fscbsize;    // +32   lenght of buffer
 char  fscbfv;      // +36   recfm - c'F' or c'V'
 char  fscbflg;     // +37   flag byte
 short fscbnoit;    // +38   number of records to be read/written
 int   fscbnord;    // +40   number of bytes actually read
 // extra for my routine's use...
 int   filler;      // +44   paranoia...
 int   CMSitno;     // +48   last record number read
 int   CMSr15;      // +52   last retcode
 } fscb;

char  CMSeofmk[4]={0,0,0,0}; // EOF value after first open
#define NUMFSCBS 10
fscb  CMSfscb[NUMFSCBS];

fscb *CMSopen (char *name) { // NULL open failed, else OK
 int i, r15=0; fscb *ModelFSCB;
      // first time setup eofmark & clear fscb table
      if (CMSeofmk[0] == 0) {
        CMSeofmk[0]=CMSeofmk[3]=0x61;  // keep actual 61ffff61
        CMSeofmk[1]=CMSeofmk[2]=0xff;  // out of the code...
        for (i=00; i<NUMFSCBS; i++) {
         memset(CMSfscb[i], 0, sizeof(fscb));
         }
        }
      // find free slot
      for (i=0; i<NUMFSCBS; i++) {
       if (CMSfscb[i].fscbfn[0] == 0) break;
       }
      // fail call if no free slot
      if(i == NUMFSCBS) return 0;
      // get adress of model fscb
      __asm__ (
        "B P%=\n"
        "F%= FSCB 'ANY LOADLIB ',BUFFER=*,BSIZE=80\n"
        "P%= LA 15,F%=\n\t"
        "ST 15,%0"
       : "=m"(ModelFSCB)
       : /* no inputs */
       : "15"
      );
      // copy model fscb to slot
      memcpy(CMSfscb[i], ModelFSCB, 44);
      // copy file name to slot name
      memcpy(&CMSfscb[i].fscbfn, name, 18);
      // now use ModelFSCB var as pointer to slot
      ModelFSCB = &CMSfscb[i];
      // do the open
      __asm__ (
        "L 2,%1\n\t"
        "FSOPEN FSCB=(2)\n\t"
        "ST 15,%0"
       : "=m"(r15)
       : "m"(ModelFSCB)
       : "1","2","15"
      );
      // save last return
      CMSfscb[i].CMSr15 = r15;
      // if open good return fscb pointer
      if (r15 == 0) return &CMSfscb[i];
      // if open failed return 0
      return 0;
 }

int   CMSread (char *buffer, fscb *fscb) {
 int i, r15=0;
      // verify fscb points to an in-use slot
      for (i=0; i<NUMFSCBS; i++) {
       if (&CMSfscb[i] == fscb) break;
       }
      // fail call if no match
      if(i == NUMFSCBS) return -1;
      // fail call if slot not open
      if (CMSfscb[i].fscbfn[0] == 0) return -2;
      // pre-clear buffer
      memset(buffer, 0, 82);
      // set to read 1 record
      fscb->fscbnoit = 1;
      // set record to read
      fscb->fscbitno = fscb->CMSitno;
      // read it
      __asm__ (
        "L 2,%1\n\t"
        "L 3,%2\n\t"
        "ST 3,28(,2)\n\t"
        "FSREAD FSCB=(2)\n\t"
        "ST 15,%0"
       : "=m"(r15)
       : "m"(fscb),"m"(buffer)
       : "1","2","3","15"
      );
      // advance for sequential read
      fscb->CMSitno++;
      // save last return
      fscb->CMSr15 = r15;
      // check for EOF
      if(!memcmp(buffer, CMSeofmk, 4)) {
       r15 = 12;
       fscb->CMSr15 = r15;
       fscb->fscbnord = 0;
       fscb->CMSitno--;
       }
      // return number of bytes read
      return fscb->fscbnord;
 }

int   CMSeof  (fscb *fscb) {  // 0 ok, 12 eof, else othr error...
 int i;
      // verify fscb points to an in-use slot
      for (i=0; i<NUMFSCBS; i++) {
       if (&CMSfscb[i] == fscb) break;
       }
      // fail call if no match
      if(i == NUMFSCBS) return -1;
      // fail call if slot not open
      if (CMSfscb[i].fscbfn[0] == 0) return -1;
      // return eof flag
      return fscb->CMSr15;
 }

int   CMSseek (fscb *fscb, unsigned short recno) {
 int i;
      // verify fscb points to an in-use slot
      for (i=0; i<NUMFSCBS; i++) {
       if (&CMSfscb[i] == fscb) break;
       }
      // fail call if no match
      if(i == NUMFSCBS) return -1;
      // fail call if slot not open
      if (CMSfscb[i].fscbfn[0] == 0) return -1;
      // verify recno OK
      if (recno <= 0) return -1;
      // set recno for next read
      fscb->CMSitno = recno;
      return 0;
 }

void  CMSclose(fscb *fscb) {  // close (if open)
 int i, r15=0;
      // verify fscb points to an in-use slot
      for (i=0; i<NUMFSCBS; i++) {
       if (&CMSfscb[i] == fscb) break;
       }
      // fail call if no match
      if(i == NUMFSCBS) return;
      // fail call if slot not open
      if (CMSfscb[i].fscbfn[0] == 0) return;
      // close file
      __asm__ (
        "L 2,%1\n\t"
        "FSCLOSE FSCB=(2)\n\t"
        "ST 15,%0"
       : "=m"(r15)
       : "m"(fscb)
       : "1","2","15"
      );
      // make slot free
      memset(fscb, 0, sizeof(CMSfscb[0]));
 }


 // very simple routines to read console stack
 // used for compatibly obtaining list of
 // GLOBAL'd MACLIB's via 'Q MACLIB (STACK'

int chkstk() {
 // returns number of lines in console stack
 // NUMFINRD same vm370 thru zvm 5.4 (at least)
 short *NUMFINRD = (short *)0x55C;
 int rc = *NUMFINRD;
 return rc;
 }

int rdstk(char *buffer, int maxbufl) {
 // returns length of line retrieved from console stack
 short bufl;char buf[132];
   __asm__ (
    "L   1,%1\n\t"
    "ST  1,S%=+8\n\t"
    "LA  1,1\n\t"
    "STC 1,S%=+8\n\t"
    "LA  1,S%=\n\t"
    "SVC 202\n\t"
    "DC AL4(*+4)\n\t"
    "B X%=\n"
   "S%= DS 0D\n\t"
    "DC CL8'CONREAD'\n\t"
    "DC AL1(1)\n\t"
    "DC AL3(0) buffer address\n\t"
    "DC CL1'U'\n\t"
    "DC AL3(0) returned count\n\t"
    "DC 8X'FF'\n"
   "X%= EQU *\n\t"
    "L 1,S%=+12\n\t"
    "STH 1,%0"
   : "=m"(bufl)
   : "m"(&buf[0])
   : "0", "1", "15"
   );
 memcpy(buffer, buf, maxbufl);
 return bufl;
 }


 // maclib directory pointer record
typedef struct {
 char   magic[6];  // s.b. 'DMSLIB'
 unsigned short  dirrec;
 int    dirnext  ; // dirnext/12 = num active entries + 1
 } dirptr;

 // maclib directory entry
typedef struct {
  char  member[8];
  unsigned short firstblock;
  short unknown;
 } dirent;

 // maclib directory  record
typedef struct {
 dirent mems[6];
 } dir;

 // in-mem module entry
typedef struct {
  char  member[8];
  short lib;
  unsigned short recnum;
 } modent;


int kikmaclb (int whycalled,
             char *memname, char *memline, int *ment) {

 // returns 0 for success, -1 for failure, +12 for eof

 static char maclibs[72];
 static char *MACLIBS=&maclibs[0];
 static int numlibs=0;         // number of libs

 static int nummods=0;         // num entries in dynamic table
 static modent *modtab=0;      // addr of gotten stor for table

 dirptr *dp; dir *drec;
 fscb *inc;
 char incname[22], *maclibname, newline[90];
 int  i, j, k;


 if (modtab == NULL) { // 1st time initialization

  // turn COMPSWT off  -- don't think this is needed here...
  // __asm__ (
  //  "COMPSWT OFF"
  // : /* no output */
  // : /* no input  */
  // : "0", "1", "15"
  // );

  // pass 0 - obtain list of global'd maclibs
  { char conbuf[132]; int i;
   // purge remaining lines in console stack
   while (chkstk() > 0) rdstk(conbuf, 130);
   // stack the global'd maclib names
   __asm__ (
    "LA 1,S%=\n\t"
    "SVC 202\n\t"
    "DC AL4(*+4)\n\t"
    "B X%=\n"
   "S%= DS 0D\n"
   "* DC CL8'CP' use CMS query (for stack) \n\t"
    "DC CL8'Q'\n\t"
    "DC CL8'MACLIB'\n\t"
    "DC CL8'('\n\t"
    "DC CL8'STACK'\n\t"
    "DC 8X'FF'\n"
   "X%= EQU *"
   : /* no output */
   : /* no input  */
   : "0", "1", "15"
   );
   // read 1st line
   rdstk(conbuf, 130);
   // copy to global and punctuate
   memcpy(MACLIBS, &conbuf[11], 72);
   for (i=8; i< 73; i+=9) MACLIBS[i] = 0;
   if(!strncmp(MACLIBS, "NONE ", 5)) *MACLIBS = ' ';
   // purge remaining lines in console stack
   while (chkstk() > 0) rdstk(conbuf, 130);
  }

  // pass 1 - read all the libs, count member names
  maclibname = MACLIBS;
  nummods = 0; numlibs = 0;
  for (i=0; i<8; i++, maclibname += 9) {
   if (*maclibname != ' ') {
    memset (incname, ' ', 22);
    memcpy (incname,    maclibname, 8);
    memcpy (incname+8,  "MACLIB  ", 8);
    memcpy (incname+16, "  ", 2);
    inc = CMSopen(incname);
    if(inc == 0) continue;
    CMSread(newline, inc); // get dir pointer rec
    if(CMSeof(inc)) break; // out of the FOR - problem!!
    dp = (dirptr*)&newline;
    if(CMSseek(inc, dp->dirrec) < 0) break; // FOR...
    j = dp->dirnext / 12;
    while (1) {
     CMSread(newline, inc);
     if(CMSeof(inc)) break;
     // do stuff...
     drec = (dir*)&newline;
     for (k=0; k<6; k++) {
      if (drec->mems[k].member[0] != 0) {
       // active entry
       j--; // reduce count of active entries
       nummods++; // increase count of mods
       }
      if(j < 1) break; // for
      }
     if(j < 1) break;  // while
     } // end while
    CMSclose(inc);
    numlibs++;
    }  // end if *maclib ...
   }   // end for

  modtab = (modent*)malloc(12*nummods);
  if (modtab == NULL) {
   printf("malloc for member list failed\n");
   return -1;
   }

  // pass 2 - read all the member names into storage
  maclibname = MACLIBS;
  nummods = 0; numlibs = 0;
  for (i=0; i<8; i++, maclibname += 9) {
   if (*maclibname != ' ') {
    memset (incname, ' ', 22);
    memcpy (incname,    maclibname, 8);
    memcpy (incname+8,  "MACLIB  ", 8);
    memcpy (incname+16, "  ", 2);
    inc = CMSopen(incname);
    if(inc == 0) continue;
    CMSread(newline, inc); // get dir pointer rec
    if(CMSeof(inc)) break; // out of the FOR - problem!!
    dp = (dirptr*)&newline;
    if(CMSseek(inc, dp->dirrec) < 0) break; // FOR...
    j = dp->dirnext / 12;
    while (1) {
     CMSread(newline, inc);
     if(CMSeof(inc)) break;
     // do stuff...
     drec = (dir*)&newline;
     for (k=0; k<6; k++) {
      if (drec->mems[k].member[0] != 0) {
       // active entry
       j--; // reduce count of active entries
       memcpy(modtab[nummods].member, drec->mems[k].member, 8);
       modtab[nummods].lib = i;
       modtab[nummods].recnum = drec->mems[k].firstblock;
       nummods++; // increase count of mods
       }
      if(j < 1) break; // for
      }
     if(j < 1) break;  // while
     } // end while
    CMSclose(inc);
    numlibs++;
    }  // end if *maclib ...
   }   // end for

  // printf("numlibs=%d, nummods=%d\n", numlibs, nummods);

  }    // end if (modtab == NULL)


 switch (whycalled) {

  case 0:  // open library

     // fell in here so it's already done!
     return 0;

  case 1:  // close library

     // not implemented
     return -1;

  case 2:  // open member

     for (i=0; i<nummods; i++) {
      if(!strncmp(memname, modtab[i].member, 8)) break;
      }
     if (i == nummods) return -1; // can't find it
     j = modtab[i].lib;
     k = modtab[i].recnum;

     maclibname = MACLIBS + (j * 9);
     memset (incname, ' ', 22);
     memcpy (incname,    maclibname, 8);
     memcpy (incname+8,  "MACLIB  ", 8);
     memcpy (incname+16, "  ", 2);
     inc = CMSopen(incname);
     if(inc == 0) return -1;
     *ment = (int)inc; // say channel for read/close
     if(CMSseek(inc, k) < 0) return -1;
     return 0;

  case 3:  // read line of member

     inc = (fscb*)*ment;
     CMSread(memline, inc);
     return CMSeof(inc);

  case 4:  // close member

     inc = (fscb*)*ment;
     CMSclose(inc);
     return 0;

  default: //  bad call
     return;
  }
 }

/*
/*
$$
//
