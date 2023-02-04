//$KIKALI JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1)
//*
//* BE SURE TO DO GLOBAL CHANGE KXTCSF TO YOUR OWN TSOID !!!
//*
//ASM      EXEC PGM=IFOX00,
//            PARM='DECK,LIST'
//SYSLIB   DD DSN=SYS1.MACLIB,DISP=SHR
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSUT2   DD UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSUT3   DD UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSPRINT DD SYSOUT=*
//SYSLIN   DD DUMMY
//SYSPUNCH DD DSN=&&OBJSET,
//         UNIT=SYSDA,SPACE=(80,(200,200)),
//         DISP=(,PASS)
//SYSIN    DD *
*/////////////////////////////////////////////////////////////////////
*//   KICKS is an enhancement for TSO that lets you run your CICS
*//   applications directly in TSO instead of having to 'install'
*//   those apps in CICS.
*//   You don't even need CICS itself installed on your machine!
*//
*//   KICKS for TSO
*//   © Copyright 2008-2014, Michael Noel, All Rights Reserved.
*//
*//   Usage of 'KICKS for TSO' is in all cases subject to license.
*//   See http://www.kicksfortso.com
*//   for most current information regarding licensing options..
*////////1/////////2/////////3/////////4/////////5/////////6/////////7
*
*  ///////////////////////////////////////////////////////////////////
* Glue 24 bit DSNALI calls to 31 bit reality...
* loosely based on code listed in
* http://publib.boulder.ibm.com/infocenter/dzichelp/v2r2/topic/
*             com.ibm.db2.doc.apsg/qdumbhi.htm#qdumbhi
*  ///////////////////////////////////////////////////////////////////
* Seems a bit strange that the entry point 'DSNHLI' is calling
* 'DSNHLI2' - but that's cause we want a cobol that's preprocessed
* with 'CAF', which gens calls to ep DSNHLI in load module DSNALI.
* but the alias for the load module DSNALI is DSNHLI2...
*  ///////////////////////////////////////////////////////////////////
*
*            1840  DSNALI
*     18     1858     DSNASP
*     1E     185E     DSNHLI2
*     24     1864     DSNHLI
*     2A     186A     DSNWLI2
*     30     1870     DSNWLI
*
KIKALI   CSECT
*
KIKALI   AMODE     24
KIKALI   RMODE     24
*
         ENTRY     DSNHLI
DSNHLI   B     80(,15)            Skip save area and local var(s)
*                                 B 4; SA 72; vars 4; total 80
*
SA       DC    18F'0'             standard save area
LISQL    DC    F'0'               local vars
*
         STM   14,12,12(13)       save regs
         LA    15,4(,15)          Get new save area address
         ST    13,4(,15)          Chain the save areas
         ST    15,8(,13)
         LR    13,15              Put new save area address in R13
*
         USING SA,13              address local vars, code labels...
*
         L     15,LISQL           Get the address of real DSNHLI
         LTR   15,15
         BNE   BASSM1
         STM   0,1,SA+20          save 0,1 - LOAD will destroy
         LOAD  EP=DSNHLI2
         LR    15,0               know it worked 'cause we're here...
         ST    15,LISQL
         LM    0,1,SA+20          recover 0,1 - LOAD destroyed
*
BASSM1   BASSM 14,15
         L     13,4(,13)          restore regs (except 0 & 15)
         L     14,12(,13)
         RETURN (1,12)            goback
*
         LTORG
*
         END
/*
//LKED     EXEC PGM=IEWL,PARM='XREF,MAP,LET,NCAL',
//         COND=(0,NE,ASM)
//SYSLMOD  DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSPRINT DD SYSOUT=*
//SYSLIN   DD DSN=&&OBJSET,DISP=(OLD,DELETE)
//         DD *
 NAME DSNALI(R)
/*
//
