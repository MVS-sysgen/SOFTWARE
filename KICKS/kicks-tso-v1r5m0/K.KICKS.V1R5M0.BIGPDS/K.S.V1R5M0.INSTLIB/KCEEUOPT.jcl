//KCEEUOPT JOB CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1)
//*
//* BE SURE TO DO GLOBAL CHANGE BXTCMFN TO YOUR OWN TSOID !!!
//*
//ASM      EXEC PGM=ASMA90,
//            PARM='DECK,LIST'
//SYSLIB   DD DSN=SYS1.MACLIB,DISP=SHR
//         DD DSN=CEE.SCEEMAC,DISP=SHR
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
* CEEUOPT FOR KICKS
*   MODS FROM DEFAULT
*     - AMODE/RMODE 24 INSTEAD OF 31
*     - ABTERMENC = ABEND INSTEAD OF RETCODE
*     - ANYHEAP BELOW INSTEAD OF ANYWHERE
*     -    HEAP BELOW INSTEAD OF ANYWHERE
*     - MSGFILE CEEMSG INSTEAD OF SYSOUT
*
CEEUOPT  CSECT
*
CEEUOPT  AMODE     24
CEEUOPT  RMODE     24
         CEEXOPT ABPERC=(NONE),                                        X
               ABTERMENC=(ABEND),                                      X
               AIXBLD=(OFF),                                           X
               ALL31=(OFF),                                            X
               ANYHEAP=(16K,8K,BELOW,FREE),                            X
               BELOWHEAP=(8K,4K,FREE),                                 X
               CBLOPTS=(ON),                                           X
               CBLPSHPOP=(ON),                                         X
               CBLQDA=(OFF),                                           X
               CHECK=(ON),                                             X
               COUNTRY=(US),                                           X
               DEBUG=(OFF),                                            X
               DEPTHCONDLMT=(10),                                      X
               ENVAR=(''),                                             X
               ERRCOUNT=(0),                                           X
               ERRUNIT=(6),                                            X
               FILEHIST=(ON),                                          X
               HEAP=(32K,32K,BELOW,KEEP,8K,4K),                        X
               HEAPCHK=(OFF,1,0),                                      X
               HEAPPOOLS=(OFF,8,10,32,10,128,10,256,10,1024,10,2048,   X
               10),                                                    X
               INFOMSGFILTER=(OFF,,,,),                                X
               INQPCOPN=(ON),                                          X
               INTERRUPT=(OFF),                                        X
               LIBSTACK=(8K,4K,FREE),                                  X
               MSGFILE=(CEEMSG,FBA,121,0),                             X
               MSGQ=(15),                                              X
               NATLANG=(ENU),                                          X
               NOTEST=(ALL,*,PROMPT,INSPPREF),                         X
               NOUSRHDLR=(''),                                         X
               OCSTATUS=(ON),                                          X
               PC=(OFF),                                               X
               PLITASKCOUNT=(20),                                      X
               POSIX=(OFF),                                            X
               PROFILE=(OFF,''),                                       X
               PRTUNIT=(6),                                            X
               PUNUNIT=(7),                                            X
               RDRUNIT=(5),                                            X
               RECPAD=(OFF),                                           X
               RPTOPTS=(OFF),                                          X
               RPTSTG=(OFF),                                           X
               RTEREUS=(OFF),                                          X
               SIMVRD=(OFF),                                           X
               STACK=(128K,128K,BELOW,KEEP),                           X
               STORAGE=(NONE,NONE,NONE,8K),                            X
               TERMTHDACT=(TRACE),                                     X
               THREADHEAP=(4K,4K,BELOW,KEEP),                          X
               TRACE=(OFF,4K,DUMP,LE=0),                               X
               TRAP=(ON,SPIE),                                         X
               UPSI=(00000000),                                        X
               VCTRSAVE=(OFF),                                         X
               XUFLOW=(AUTO)
         END
/*
//LKED     EXEC PGM=IEWL,PARM='XREF,MAP,LET,NCAL',
//         COND=(0,NE,ASM)
//SYSLIN   DD DSN=&&OBJSET,DISP=(OLD,DELETE)
//SYSIN    DD DUMMY
//SYSLMOD  DD DSN=K.S.V1R5M0.SKIKLOAD(KCEEUOPT),DISP=SHR
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSPRINT DD SYSOUT=*
/*
//
