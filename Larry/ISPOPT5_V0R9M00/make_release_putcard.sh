#!/bin/bash

# builds the JCL needed to install DALCDS/ISRDDN

cat << 'END'
//PUTCARD JOB (JOB),
//             'INSTALL PUTCARD',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
END


cat << 'END'
//* -------------------------------------------------------*
//* *  ISPOPT5 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST40  Install Other Components              *
//* *                                                      *
//* *       Install PUTCARD  Programs                      *
//* *                                                      *
//* *  - PUTCARD  programs installs to ISPLLIB             *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* *                                                      *
//* -------------------------------------------------------*
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  PROC: ASMLKED                                       *
//* *       Assembler Link-Edit                            *
//* *                                                      *
//* -------------------------------------------------------*
//ASML     PROC
//*
//ASM      EXEC PGM=IFOX00,
//             PARM='NODECK,LOAD,RENT,TERM,XREF'
//SYSGO    DD  DSN=&&LOADSET,DISP=(MOD,PASS),SPACE=(CYL,(1,1)),
//             UNIT=VIO,DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=800)
//SYSLIB   DD  DSN=SYS1.MACLIB,DISP=SHR
//         DD  DSN=SYS1.AMODGEN,DISP=SHR
//         DD  DSN=SYS2.MACLIB,DISP=SHR          ** YREG  **
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSPUNCH DD  DSN=NULLFILE
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSIN    DD  DUMMY
//*
//LKED     EXEC PGM=IEWL,PARM='MAP,LIST,LET,RENT,XREF',
//             COND=(0,NE,ASM)
//SYSLIN   DD  DSN=&&LOADSET,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSIN
//SYSLMOD  DD  DUMMY
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(5,2))
//SYSIN    DD  DUMMY
//*
//         PEND
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit PUTCARD to ISPLLIB               *
//* -------------------------------------------------------*
//PUTCARD  EXEC  ASML,
//         PARM.ASM='OBJECT,NODECK,XREF,TERM',
//         PARM.LKED='LET,LIST,MAP,XREF,SIZE=(900K,124K)'
END

cat V0R9M00.ASM.TAPE/PUTCARD.txt

cat << 'END'
@@
//LKED.SYSLMOD DD  DISP=SHR,DSN=SYSGEN.ISPF.LLIB
//*
//********************************************************************/
//* 04/10/2020 1.0.20   Larry Belmontes Jr.                          */
//*                     - Added ALIAS LISTDSI to LKED step           */
//********************************************************************/
//LKED.SYSIN DD *
 ALIAS CNTLCARD
 NAME PUTCARD(R)
/*
END


cat << 'END'
//CLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS2.HELP,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=PUTCARD
)F FUNCTION -
  CONTROL CARD IMAGE QUICK BUILDER - 
  Frequently within CLISTS and REXX EXECs, utilities are invoked
  that require input via control cards. While the control cards can be
  built within CLISTS and EXECs, it is not a user friendly process.
  For that reason, I came up with the CNTLCARD program, which makes
  it much easier to build the control card input required by such
  utilities.
 
  The CNTLCARD program assumes (and requires) that a pre-allocated
  virtual I/O (VIO) dataset be used to hold the control card that is
  to be generated. This was done as a security feature, since sensitive
  information could be put into the control card (like passwords) and
  only the job or user allocating the VIO dataset could access it.
  
  It is also the reason that only one control card can be written to
  the VIO dataset using the CNTLCARD program (you cannot specify a
  a disposition of MOD for a VIO dataset). If you do not require the
  security, or if you desire to be able to create multiple control
  cards, you can modify the source code at label DDOK to skip the VIO
  checking. If you do not perform this modification, CNTLCARD will
  set a return code of 4 if the SYSIN DD does not refer to a VIO
  dataset.

  CNTLCARD will return two other return codes. A code of 8 will be
  set if the SYSIN DD is not allocated, and a return code of 12 will be
  set if no parameter is passed to it. If you attempt to pass a control
  card whose length is greater than 80 bytes for CNTLCARD to write, it
  will truncate the length to 80 bytes without issuing any
  notification.

  In order to handle special character situations, such as leading
  blanks, the string of data to be used as a control card can be
  enclosed in single quotes, which will be stripped off if found by the
  CNTLCARD program. Otherwise the string can be coded without the
  quotes even if it has embedded blanks or special characters.
  As an example of its use, to generate a SORT control card, you would
  code:

    SYSLOAD ' SORT FIELDS=(3,9,CH,A),FILSZ=E100'
    
  Below is an example CLIST which uses an unmodified CNTLCARD
  program to write a single control card to a VIO dataset:

    FREE DD(SYSIN) DELETE
    ALLOC DD(SYSIN) UNIT(VIO) SP(1) NEW REUSE +
    RECFM(F) LRECL(80) BLKSIZE(80) DSORG(PS)
    SYSLOAD ' SORT FIELDS=(3,9,CH,A),FILSZ=E100'

  Below is an example CLIST which to use a modified version of the
  CNTLCARD program (as described earlier) to write multiple control
  cards to a non-VIO dataset:

    FREE DD(SYSIN) DELETE
    ALLOC DD(SYSIN) UNIT(SYSDA) SP(1) MOD REUSE DA(TEMP) +
    RECFM(F) LRECL(80) BLKSIZE(80) DSORG(PS)
    SYSLOAD ' SORT FIELDS=(3,9,CH,A),FILSZ=E100'
    SYSLOAD ' RECORD TYPE=F'
                                                    c Xephon 1998
END
