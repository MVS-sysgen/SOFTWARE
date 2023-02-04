//KIKSIT   JOB CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1)
//*
//ASM      EXEC PGM=IFOX00,
//           PARM='DECK,NOLIST'
//SYSLIB   DD DSN=SYS1.MACLIB,DISP=SHR
//         DD DSN=K.S.V1R5M0.MACLIB,DISP=SHR
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSUT2   DD UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSUT3   DD UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSPRINT DD SYSOUT=*
//SYSLIN   DD DUMMY
//SYSPUNCH DD DSN=&&OBJSET,
//         UNIT=SYSDA,SPACE=(80,(200,200)),
//         DISP=(,PASS)
//SYSIN    DD *
         PRINT GEN
         KIKSIT SUFFIX=1$,                                             *
               PCP=1$,PPT=1$,                                          *
               KCP=1$,PCT=1$,                                          *
               FCP=1$,FCT=1$,                                          *
               DCP=1$,DCT=1$,                                          *
               TCP=1$,BMS=1$,                                          *
               SCP=1$,FFREEKB=NO,                                      *
               TSP=1$
         LTORG
         END
/*
//LKED     EXEC PGM=IEWL,PARM='XREF,MAP,LET,NCAL',
//         COND=(0,NE,ASM)
//SYSLIN   DD DSN=&&OBJSET,DISP=(OLD,DELETE)
//SKIKLOAD DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//SYSIN    DD DUMMY
//SYSLMOD  DD DSN=K.S.V1R5M0.SKIKLOAD(KIKSIT1$),DISP=SHR
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSPRINT DD SYSOUT=*
