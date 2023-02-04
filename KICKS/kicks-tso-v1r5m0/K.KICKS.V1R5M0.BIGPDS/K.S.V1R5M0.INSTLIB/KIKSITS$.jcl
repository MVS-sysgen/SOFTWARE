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
         KIKSIT SUFFIX=S$,PLTPI=KSDB,                                  *
               PCP=1$,PPT=S$,                                          *
               KCP=1$,PCT=S$,                                          *
               FCP=1$,FCT=S$,                                          *
               DCP=1$,DCT=S$,                                          *
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
//SYSLMOD  DD DSN=K.S.V1R5M0.SKIKLOAD(KIKSITS$),DISP=SHR
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSPRINT DD SYSOUT=*
