//K999PGM JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=7000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//K999PGM EXEC  PROC=K2KCOBCL
//COPY.SYSUT1 DD *
       ID DIVISION.
       PROGRAM-ID. K999PGM.

      *///////////////////////////////////////////////////////////////
      * KICKS is an enhancement for TSO that lets you run your CICS
      * applications directly in TSO instead of having to 'install'
      * those apps in CICS.
      * You don't even need CICS itself installed on your machine!
      *
      * KICKS for TSO
      * © Copyright 2008-2014, Michael Noel, All Rights Reserved.
      *
      * Usage of 'KICKS for TSO' is in all cases subject to license.
      * See http://www.kicksfortso.com
      * for most current information regarding licensing options.
      *//1/////////2/////////3/////////4/////////5/////////6/////////7

      *///////////////////////////////////////////////////////////////
      * K999PGM is the shutdown PLT program.
      *///////////////////////////////////////////////////////////////

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN  PIC X(24) VALUE 'K999PGM  WORKING STORAGE'.

       PROCEDURE DIVISION.

      * --- just a sample for user modification ---

      * --- 'final' shutdown happens after transaction ends ---
           EXEC KICKS RETURN END-EXEC.

/*
//LKED.SYSLMOD DD DSN=K.S.V1R5M0.KIKRPL,DISP=SHR
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKCOBGX)
 ENTRY K999PGM
 NAME  K999PGM(R)
/*
//
