//BOOL      JOB  CLASS=C,MSGCLASS=Z
//*
//* Not usually needed, but run if you get a message complaining
//* about bool.h missing during compile of kiktcp2$
//*
// EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN DD DUMMY,DCB=BLKSIZE=80
//SYSUT2 DD UNIT=10D,DISP=OLD,DCB=BLKSIZE=80
//SYSUT1 DD DATA,DLM=$$,DCB=BLKSIZE=3120
ID CMSBATCH
/JOB CMSUSER 123456 BOOL
$$
// DD DSN=K.X.CMSBATCH(MAPN),DISP=SHR
// DD DATA,DLM=$$
MAPN
KBLOCK BOOL
FILEDEF  INMOVE  TERM ( RECFM F BLOCK 80 LRECL 80
FILEDEF  OUTMOVE DISK bool H A ( RECFM F BLOCK 80 LRECL 80
MOVEFILE
 /*
** BOOL.H      - MECAFF API header file
**
** This file is part of the MECAFF-API for VM/370 R6 "SixPack".
**
** This module defines the boolean data type used in the implementation
** modules of the MECAFF API and the MECAFF programs.
**
** This software is provided "as is" in the hope that it will be useful, with
** no promise, commitment or even warranty (explicit or implicit) to be
** suited or usable for any particular purpose.
** Using this software is at your own risk!
**
** Written by Dr. Hans-Walter Latz, Berlin (Germany), 2011,2012
** Released to the public domain.
 */

#if !defined(__BOOLimported)
#define __BOOLimported

#ifndef true

typedef unsigned char bool;
#define true ((bool)1)
#define false ((bool)0)
#endif

#endif

/*
VMARC PACK BOOL H A ASYSH VMARC N ( APPEND
/*
$$
//
