//KIKPPT   JOB CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1)
//*
//ASM      EXEC PGM=IFOX00,
//            PARM='DECK,NOLIST'
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
         KIKPPT TYPE=INITIAL,SUFFIX=S$
*
* ****** ************************************************************
*
*        KICKS SUPPLIED PROGRAMS
*
*        -- LOGON/LOGOFF - AKA STARTUP/SHUTDOWN
*
         KIKPPT TYPE=ENTRY,PROGRAM=KSGMPGM,PGMLANG=CMDLVL
         KIKPPT TYPE=ENTRY,PROGRAM=KSGMAP,USAGE=MAP
         KIKPPT TYPE=ENTRY,PROGRAM=KSGMHLP,PGMLANG=CMDLVL
         KIKPPT TYPE=ENTRY,PROGRAM=KSGMLIC,PGMLANG=CMDLVL
         KIKPPT TYPE=ENTRY,PROGRAM=KSGMAPL,USAGE=MAP
         KIKPPT TYPE=ENTRY,PROGRAM=KSSFPGM,PGMLANG=CMDLVL
         KIKPPT TYPE=ENTRY,PROGRAM=K999PGM,PGMLANG=CMDLVL
*
*        -- CRLP CONTROL
*
         KIKPPT TYPE=ENTRY,PROGRAM=CRLPPGM,PGMLANG=MACC
*
*        -- LOGGER
*
         KIKPPT TYPE=ENTRY,PROGRAM=KLOGIT,PGMLANG=CMDLVL
*
*        -- COMMAND LEVEL DEBUGGER
*
         KIKPPT TYPE=ENTRY,PROGRAM=KEDFPGM,PGMLANG=CMDLVL
         KIKPPT TYPE=ENTRY,PROGRAM=KEDFON,PGMLANG=MACC     KEDF ON
         KIKPPT TYPE=ENTRY,PROGRAM=KEDFOFF,PGMLANG=MACC    KEDF OFF
         KIKPPT TYPE=ENTRY,PROGRAM=KEDFSTA,PGMLANG=MACC    KEDF STATUS
         KIKPPT TYPE=ENTRY,PROGRAM=KEDFILTR,PGMLANG=ASSEMBLER
         KIKPPT TYPE=ENTRY,PROGRAM=KEDMAP,USAGE=MAP
         KIKPPT TYPE=ENTRY,PROGRAM=KEDFXEQ,PGMLANG=MACC
         KIKPPT TYPE=ENTRY,PROGRAM=KSDBLOAD,PGMLANG=CMDLVL
*
*        -- KEBR - QUEUE BROWSER
*
         KIKPPT TYPE=ENTRY,PROGRAM=KEBRPGM,PGMLANG=CMDLVL
         KIKPPT TYPE=ENTRY,PROGRAM=KEBRM,USAGE=MAP
         KIKPPT TYPE=ENTRY,PROGRAM=KEBRHELP,PGMLANG=ASSEMBLER
*
*        -- KSMT - 'MASTER TERMINAL' TRACSACTION
*
         KIKPPT TYPE=ENTRY,PROGRAM=KSMTPGM,PGMLANG=CMDLVL
*
*        -- LINKED-TO C PGMS TO MANIPULATE CSA (CALLED BY KSMT)
*
*        ---- TRACE TABLE CONTROL ROUTINES
*
         KIKPPT TYPE=ENTRY,PROGRAM=KTRCSTA,PGMLANG=MACC    GET TRACE
         KIKPPT TYPE=ENTRY,PROGRAM=KTRCON,PGMLANG=MACC     TRACE ON
         KIKPPT TYPE=ENTRY,PROGRAM=KTRCOFF,PGMLANG=MACC    TRACE OFF
         KIKPPT TYPE=ENTRY,PROGRAM=KTRCAON,PGMLANG=MACC    AUX TR ON
         KIKPPT TYPE=ENTRY,PROGRAM=KTRCAOF,PGMLANG=MACC    AUX TR OFF
         KIKPPT TYPE=ENTRY,PROGRAM=KTRCINON,PGMLANG=MACC   INTENSE ON
         KIKPPT TYPE=ENTRY,PROGRAM=KTRCINOF,PGMLANG=MACC   INTENSE OFF
*
*        ---- ICVR CONTROL ROUTINES
*
         KIKPPT TYPE=ENTRY,PROGRAM=KICVRGET,PGMLANG=MACC   GET ICVR
         KIKPPT TYPE=ENTRY,PROGRAM=KICVRPUT,PGMLANG=MACC   PUT ICVR
*
*        ---- LASTCC/MAXCC ROUTINES
*
         KIKPPT TYPE=ENTRY,PROGRAM=KLASTCCG,PGMLANG=MACC   GET LASTCC
         KIKPPT TYPE=ENTRY,PROGRAM=KLASTCCP,PGMLANG=MACC   PUT LASTCC
         KIKPPT TYPE=ENTRY,PROGRAM=KMAXCCG,PGMLANG=MACC    GET MAXCC
         KIKPPT TYPE=ENTRY,PROGRAM=KMAXCCP,PGMLANG=MACC    PUT MAXCC
*
* ****** ************************************************************
*
         KIKPPT TYPE=FINAL
         END
/*
//LKED     EXEC PGM=IEWL,PARM='XREF,MAP,LET,NCAL',
//         COND=(0,NE,ASM)
//SYSLIN   DD DSN=&&OBJSET,DISP=(OLD,DELETE)
//SYSIN    DD DUMMY
//SYSLMOD  DD DSN=K.S.V1R5M0.SKIKLOAD(KIKPPTS$),DISP=SHR
//SYSUT1   DD UNIT=SYSDA,SPACE=(CYL,(2,1))
//SYSPRINT DD SYSOUT=*