//KSGMMAP JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1)
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
// EXEC KIKMAPS,MAPNAME=KSGMAP
//COPY.SYSUT1 DD *
         PRINT NOGEN
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
* maps ksgmapp - 24x80, ksgmapq - 32x80,  ksgmapr - 43x80
*      ksgmaps - 32x87, ksgmapt - 27x132  ksgmapu - 62x160
*      32x87 is ibm dynamic size used by mecaff (in cms)
*      62x160 is 3290 max size, also supposedly ispf max size
*
KSGMAP   KIKMSD MODE=INOUT,CTRL=FREEKB,                                *
               DSATTS=(COLOR,HILIGHT),                                 *
               MAPATTS=(COLOR,HILIGHT),                                *
               TYPE=&SYSPARM,LANG=COBOL,TIOAPFX=YES
*
KSGMAPP  KIKMDI SIZE=(24,80),COLOR=TURQUOISE
*
MAPX01   KIKMDF POS=(01,01),LENGTH=17,INITIAL='KSGM for cms user'
MAPA01   KIKMDF POS=(01,19),LENGTH=08,ATTRB=ASKIP
         KIKMDF POS=(01,28),LENGTH=11,INITIAL='at terminal'
MAPB01   KIKMDF POS=(01,40),LENGTH=08,ATTRB=ASKIP
MAPC01   KIKMDF POS=(01,59),LENGTH=08,ATTRB=ASKIP
MAPD01   KIKMDF POS=(01,69),LENGTH=08,ATTRB=ASKIP
MAPE01   KIKMDF POS=(01,50),LENGTH=08,ATTRB=ASKIP
*
MAPA06   KIKMDF POS=(06,12),LENGTH=12,INITIAL='KK        KK'
MAPB06   KIKMDF POS=(06,27),LENGTH=10,INITIAL='IIIIIIIIII'
MAPC06   KIKMDF POS=(06,41),LENGTH=10,INITIAL='CCCCCCCCCC'
MAPD06   KIKMDF POS=(06,54),LENGTH=12,INITIAL='KK        KK'
MAPE06   KIKMDF POS=(06,69),LENGTH=10,INITIAL='SSSSSSSSSS'
*
MAPA07   KIKMDF POS=(07,11),LENGTH=11,INITIAL='KK       KK'
MAPB07   KIKMDF POS=(07,26),LENGTH=10,INITIAL='IIIIIIIIII'
MAPC07   KIKMDF POS=(07,39),LENGTH=12,INITIAL='CCCCCCCCCCCC'
MAPD07   KIKMDF POS=(07,53),LENGTH=11,INITIAL='KK       KK'
MAPE07   KIKMDF POS=(07,67),LENGTH=12,INITIAL='SSSSSSSSSSSS'
*
MAPA08   KIKMDF POS=(08,10),LENGTH=10,INITIAL='KK      KK'
MAPB08   KIKMDF POS=(08,29),LENGTH=02,INITIAL='II'
MAPC08   KIKMDF POS=(08,38),LENGTH=12,INITIAL='CC        CC'
MAPD08   KIKMDF POS=(08,52),LENGTH=10,INITIAL='KK      KK'
MAPE08   KIKMDF POS=(08,66),LENGTH=12,INITIAL='SS        SS'
*
MAPA09   KIKMDF POS=(09,09),LENGTH=09,INITIAL='KK     KK'
MAPB09   KIKMDF POS=(09,28),LENGTH=02,INITIAL='II'
MAPC09   KIKMDF POS=(09,37),LENGTH=02,INITIAL='CC'
MAPD09   KIKMDF POS=(09,51),LENGTH=09,INITIAL='KK     KK'
MAPE09   KIKMDF POS=(09,65),LENGTH=02,INITIAL='SS'
*
MAPA10   KIKMDF POS=(10,08),LENGTH=08,INITIAL='KK    KK'
MAPB10   KIKMDF POS=(10,27),LENGTH=02,INITIAL='II'
MAPC10   KIKMDF POS=(10,36),LENGTH=02,INITIAL='CC'
MAPD10   KIKMDF POS=(10,50),LENGTH=08,INITIAL='KK    KK'
MAPE10   KIKMDF POS=(10,64),LENGTH=03,INITIAL='SSS'
*
MAPA11   KIKMDF POS=(11,07),LENGTH=07,INITIAL='KKKKKKK'
MAPB11   KIKMDF POS=(11,26),LENGTH=02,INITIAL='II'
MAPC11   KIKMDF POS=(11,35),LENGTH=02,INITIAL='CC'
MAPD11   KIKMDF POS=(11,49),LENGTH=07,INITIAL='KKKKKKK'
MAPE11   KIKMDF POS=(11,64),LENGTH=09,INITIAL='SSSSSSSSS'
MAPF11   KIKMDF POS=(11,40),LENGTH=04,INITIAL='    '
*
MAPA12   KIKMDF POS=(12,06),LENGTH=07,INITIAL='KKKKKKK'
MAPB12   KIKMDF POS=(12,25),LENGTH=02,INITIAL='II'
MAPC12   KIKMDF POS=(12,34),LENGTH=02,INITIAL='CC'
MAPD12   KIKMDF POS=(12,48),LENGTH=07,INITIAL='KKKKKKK'
MAPE12   KIKMDF POS=(12,64),LENGTH=09,INITIAL='SSSSSSSSS'
*
MAPA13   KIKMDF POS=(13,05),LENGTH=08,INITIAL='KK    KK'
MAPB13   KIKMDF POS=(13,24),LENGTH=02,INITIAL='II'
MAPC13   KIKMDF POS=(13,33),LENGTH=02,INITIAL='CC'
MAPD13   KIKMDF POS=(13,47),LENGTH=08,INITIAL='KK    KK'
MAPE13   KIKMDF POS=(13,70),LENGTH=03,INITIAL='SSS'
*
MAPA14   KIKMDF POS=(14,04),LENGTH=09,INITIAL='KK     KK'
MAPB14   KIKMDF POS=(14,23),LENGTH=02,INITIAL='II'
MAPC14   KIKMDF POS=(14,32),LENGTH=02,INITIAL='CC'
MAPD14   KIKMDF POS=(14,46),LENGTH=09,INITIAL='KK     KK'
MAPE14   KIKMDF POS=(14,70),LENGTH=02,INITIAL='SS'
*
MAPA15   KIKMDF POS=(15,03),LENGTH=10,INITIAL='KK      KK'
MAPB15   KIKMDF POS=(15,22),LENGTH=02,INITIAL='II'
MAPC15   KIKMDF POS=(15,31),LENGTH=12,INITIAL='CC        CC'
MAPD15   KIKMDF POS=(15,45),LENGTH=10,INITIAL='KK      KK'
MAPE15   KIKMDF POS=(15,59),LENGTH=12,INITIAL='SS        SS'
*
MAPA16   KIKMDF POS=(16,02),LENGTH=11,INITIAL='KK       KK'
MAPB16   KIKMDF POS=(16,17),LENGTH=10,INITIAL='IIIIIIIIII'
MAPC16   KIKMDF POS=(16,30),LENGTH=12,INITIAL='CCCCCCCCCCCC'
MAPD16   KIKMDF POS=(16,44),LENGTH=11,INITIAL='KK       KK'
MAPE16   KIKMDF POS=(16,59),LENGTH=12,INITIAL='SSSSSSSSSSSS'
*
MAPA17   KIKMDF POS=(17,01),LENGTH=12,INITIAL='KK        KK'
MAPB17   KIKMDF POS=(17,16),LENGTH=10,INITIAL='IIIIIIIIII'
MAPC17   KIKMDF POS=(17,30),LENGTH=11,INITIAL='CCCCCCCCCCC'
MAPD17   KIKMDF POS=(17,43),LENGTH=12,INITIAL='KK        KK'
MAPE17   KIKMDF POS=(17,59),LENGTH=10,INITIAL='SSSSSSSSSS'
*
MAPA18   KIKMDF POS=(18,70),LENGTH=2,INITIAL='TM',COLOR=RED
*
MAPA20   KIKMDF POS=(20,60),LENGTH=18,INITIAL='For TSO          ',     *
               COLOR=NEUTRAL,HILIGHT=BLINK
MAPB20   KIKMDF POS=(22,60),LENGTH=06,INITIAL='V1R5M0'
MAPC20   KIKMDF POS=(23,60),LENGTH=16,INITIAL='September 2014  '
         KIKMDF POS=(24,01),LENGTH=40,                                 *
               INITIAL='Press PF1 for help, CLEAR to continue...'
         KIKMDF POS=(24,42),LENGTH=02,ATTRB=(IC)
         KIKMDF POS=(24,60),LENGTH=11,INITIAL='© Mike Noel'
*
KSGMAPQ  KIKMDI SIZE=(32,80),COLOR=TURQUOISE
*
MAQX01   KIKMDF POS=(01,01),LENGTH=17,INITIAL='KSGM for cms user'
MAQA01   KIKMDF POS=(01,19),LENGTH=08,ATTRB=ASKIP
         KIKMDF POS=(01,28),LENGTH=11,INITIAL='at terminal'
MAQB01   KIKMDF POS=(01,40),LENGTH=08,ATTRB=ASKIP
MAQC01   KIKMDF POS=(01,59),LENGTH=08,ATTRB=ASKIP
MAQD01   KIKMDF POS=(01,69),LENGTH=08,ATTRB=ASKIP
MAQE01   KIKMDF POS=(01,50),LENGTH=08,ATTRB=ASKIP
*
MAQA06   KIKMDF POS=(09,12),LENGTH=12,INITIAL='KK        KK'
MAQB06   KIKMDF POS=(09,27),LENGTH=10,INITIAL='IIIIIIIIII'
MAQC06   KIKMDF POS=(09,41),LENGTH=10,INITIAL='CCCCCCCCCC'
MAQD06   KIKMDF POS=(09,54),LENGTH=12,INITIAL='KK        KK'
MAQE06   KIKMDF POS=(09,69),LENGTH=10,INITIAL='SSSSSSSSSS'
*
MAQA07   KIKMDF POS=(10,11),LENGTH=11,INITIAL='KK       KK'
MAQB07   KIKMDF POS=(10,26),LENGTH=10,INITIAL='IIIIIIIIII'
MAQC07   KIKMDF POS=(10,39),LENGTH=12,INITIAL='CCCCCCCCCCCC'
MAQD07   KIKMDF POS=(10,53),LENGTH=11,INITIAL='KK       KK'
MAQE07   KIKMDF POS=(10,67),LENGTH=12,INITIAL='SSSSSSSSSSSS'
*
MAQA08   KIKMDF POS=(11,10),LENGTH=10,INITIAL='KK      KK'
MAQB08   KIKMDF POS=(11,29),LENGTH=02,INITIAL='II'
MAQC08   KIKMDF POS=(11,38),LENGTH=12,INITIAL='CC        CC'
MAQD08   KIKMDF POS=(11,52),LENGTH=10,INITIAL='KK      KK'
MAQE08   KIKMDF POS=(11,66),LENGTH=12,INITIAL='SS        SS'
*
MAQA09   KIKMDF POS=(12,09),LENGTH=09,INITIAL='KK     KK'
MAQB09   KIKMDF POS=(12,28),LENGTH=02,INITIAL='II'
MAQC09   KIKMDF POS=(12,37),LENGTH=02,INITIAL='CC'
MAQD09   KIKMDF POS=(12,51),LENGTH=09,INITIAL='KK     KK'
MAQE09   KIKMDF POS=(12,65),LENGTH=02,INITIAL='SS'
*
MAQA10   KIKMDF POS=(13,08),LENGTH=08,INITIAL='KK    KK'
MAQB10   KIKMDF POS=(13,27),LENGTH=02,INITIAL='II'
MAQC10   KIKMDF POS=(13,36),LENGTH=02,INITIAL='CC'
MAQD10   KIKMDF POS=(13,50),LENGTH=08,INITIAL='KK    KK'
MAQE10   KIKMDF POS=(13,64),LENGTH=03,INITIAL='SSS'
*
MAQA11   KIKMDF POS=(14,07),LENGTH=07,INITIAL='KKKKKKK'
MAQB11   KIKMDF POS=(14,26),LENGTH=02,INITIAL='II'
MAQC11   KIKMDF POS=(14,35),LENGTH=02,INITIAL='CC'
MAQD11   KIKMDF POS=(14,49),LENGTH=07,INITIAL='KKKKKKK'
MAQE11   KIKMDF POS=(14,64),LENGTH=09,INITIAL='SSSSSSSSS'
MAQF11   KIKMDF POS=(14,40),LENGTH=04,INITIAL='    '
*
MAQA12   KIKMDF POS=(15,06),LENGTH=07,INITIAL='KKKKKKK'
MAQB12   KIKMDF POS=(15,25),LENGTH=02,INITIAL='II'
MAQC12   KIKMDF POS=(15,34),LENGTH=02,INITIAL='CC'
MAQD12   KIKMDF POS=(15,48),LENGTH=07,INITIAL='KKKKKKK'
MAQE12   KIKMDF POS=(15,64),LENGTH=09,INITIAL='SSSSSSSSS'
*
MAQA13   KIKMDF POS=(16,05),LENGTH=08,INITIAL='KK    KK'
MAQB13   KIKMDF POS=(16,24),LENGTH=02,INITIAL='II'
MAQC13   KIKMDF POS=(16,33),LENGTH=02,INITIAL='CC'
MAQD13   KIKMDF POS=(16,47),LENGTH=08,INITIAL='KK    KK'
MAQE13   KIKMDF POS=(16,70),LENGTH=03,INITIAL='SSS'
*
MAQA14   KIKMDF POS=(17,04),LENGTH=09,INITIAL='KK     KK'
MAQB14   KIKMDF POS=(17,23),LENGTH=02,INITIAL='II'
MAQC14   KIKMDF POS=(17,32),LENGTH=02,INITIAL='CC'
MAQD14   KIKMDF POS=(17,46),LENGTH=09,INITIAL='KK     KK'
MAQE14   KIKMDF POS=(17,70),LENGTH=02,INITIAL='SS'
*
MAQA15   KIKMDF POS=(18,03),LENGTH=10,INITIAL='KK      KK'
MAQB15   KIKMDF POS=(18,22),LENGTH=02,INITIAL='II'
MAQC15   KIKMDF POS=(18,31),LENGTH=12,INITIAL='CC        CC'
MAQD15   KIKMDF POS=(18,45),LENGTH=10,INITIAL='KK      KK'
MAQE15   KIKMDF POS=(18,59),LENGTH=12,INITIAL='SS        SS'
*
MAQA16   KIKMDF POS=(19,02),LENGTH=11,INITIAL='KK       KK'
MAQB16   KIKMDF POS=(19,17),LENGTH=10,INITIAL='IIIIIIIIII'
MAQC16   KIKMDF POS=(19,30),LENGTH=12,INITIAL='CCCCCCCCCCCC'
MAQD16   KIKMDF POS=(19,44),LENGTH=11,INITIAL='KK       KK'
MAQE16   KIKMDF POS=(19,59),LENGTH=12,INITIAL='SSSSSSSSSSSS'
*
MAQA17   KIKMDF POS=(20,01),LENGTH=12,INITIAL='KK        KK'
MAQB17   KIKMDF POS=(20,16),LENGTH=10,INITIAL='IIIIIIIIII'
MAQC17   KIKMDF POS=(20,30),LENGTH=11,INITIAL='CCCCCCCCCCC'
MAQD17   KIKMDF POS=(20,43),LENGTH=12,INITIAL='KK        KK'
MAQE17   KIKMDF POS=(20,59),LENGTH=10,INITIAL='SSSSSSSSSS'
*
MAQA18   KIKMDF POS=(21,70),LENGTH=2,INITIAL='TM',COLOR=RED
*
MAQA20   KIKMDF POS=(28,60),LENGTH=18,INITIAL='For TSO          ',     *
               COLOR=NEUTRAL,HILIGHT=BLINK
MAQB20   KIKMDF POS=(30,60),LENGTH=06,INITIAL='V1R5M0'
MAQC20   KIKMDF POS=(31,60),LENGTH=16,INITIAL='September 2014  '
         KIKMDF POS=(32,01),LENGTH=40,                                 *
               INITIAL='Press PF1 for help, CLEAR to continue...'
         KIKMDF POS=(32,42),LENGTH=02,ATTRB=(IC)
         KIKMDF POS=(32,60),LENGTH=11,INITIAL='© Mike Noel'
*
KSGMAPR  KIKMDI SIZE=(43,80),COLOR=TURQUOISE
*
MARX01   KIKMDF POS=(01,01),LENGTH=17,INITIAL='KSGM for cms user'
MARA01   KIKMDF POS=(01,19),LENGTH=08,ATTRB=ASKIP
         KIKMDF POS=(01,28),LENGTH=11,INITIAL='at terminal'
MARB01   KIKMDF POS=(01,40),LENGTH=08,ATTRB=ASKIP
MARC01   KIKMDF POS=(01,59),LENGTH=08,ATTRB=ASKIP
MARD01   KIKMDF POS=(01,69),LENGTH=08,ATTRB=ASKIP
MARE01   KIKMDF POS=(01,50),LENGTH=08,ATTRB=ASKIP
*
MARA06   KIKMDF POS=(16,12),LENGTH=12,INITIAL='KK        KK'
MARB06   KIKMDF POS=(16,27),LENGTH=10,INITIAL='IIIIIIIIII'
MARC06   KIKMDF POS=(16,41),LENGTH=10,INITIAL='CCCCCCCCCC'
MARD06   KIKMDF POS=(16,54),LENGTH=12,INITIAL='KK        KK'
MARE06   KIKMDF POS=(16,69),LENGTH=10,INITIAL='SSSSSSSSSS'
*
MARA07   KIKMDF POS=(17,11),LENGTH=11,INITIAL='KK       KK'
MARB07   KIKMDF POS=(17,26),LENGTH=10,INITIAL='IIIIIIIIII'
MARC07   KIKMDF POS=(17,39),LENGTH=12,INITIAL='CCCCCCCCCCCC'
MARD07   KIKMDF POS=(17,53),LENGTH=11,INITIAL='KK       KK'
MARE07   KIKMDF POS=(17,67),LENGTH=12,INITIAL='SSSSSSSSSSSS'
*
MARA08   KIKMDF POS=(18,10),LENGTH=10,INITIAL='KK      KK'
MARB08   KIKMDF POS=(18,29),LENGTH=02,INITIAL='II'
MARC08   KIKMDF POS=(18,38),LENGTH=12,INITIAL='CC        CC'
MARD08   KIKMDF POS=(18,52),LENGTH=10,INITIAL='KK      KK'
MARE08   KIKMDF POS=(18,66),LENGTH=12,INITIAL='SS        SS'
*
MARA09   KIKMDF POS=(19,09),LENGTH=09,INITIAL='KK     KK'
MARB09   KIKMDF POS=(19,28),LENGTH=02,INITIAL='II'
MARC09   KIKMDF POS=(19,37),LENGTH=02,INITIAL='CC'
MARD09   KIKMDF POS=(19,51),LENGTH=09,INITIAL='KK     KK'
MARE09   KIKMDF POS=(19,65),LENGTH=02,INITIAL='SS'
*
MARA10   KIKMDF POS=(20,08),LENGTH=08,INITIAL='KK    KK'
MARB10   KIKMDF POS=(20,27),LENGTH=02,INITIAL='II'
MARC10   KIKMDF POS=(20,36),LENGTH=02,INITIAL='CC'
MARD10   KIKMDF POS=(20,50),LENGTH=08,INITIAL='KK    KK'
MARE10   KIKMDF POS=(20,64),LENGTH=03,INITIAL='SSS'
*
MARA11   KIKMDF POS=(21,07),LENGTH=07,INITIAL='KKKKKKK'
MARB11   KIKMDF POS=(21,26),LENGTH=02,INITIAL='II'
MARC11   KIKMDF POS=(21,35),LENGTH=02,INITIAL='CC'
MARD11   KIKMDF POS=(21,49),LENGTH=07,INITIAL='KKKKKKK'
MARE11   KIKMDF POS=(21,64),LENGTH=09,INITIAL='SSSSSSSSS'
MARF11   KIKMDF POS=(21,40),LENGTH=04,INITIAL='    '
*
MARA12   KIKMDF POS=(22,06),LENGTH=07,INITIAL='KKKKKKK'
MARB12   KIKMDF POS=(22,25),LENGTH=02,INITIAL='II'
MARC12   KIKMDF POS=(22,34),LENGTH=02,INITIAL='CC'
MARD12   KIKMDF POS=(22,48),LENGTH=07,INITIAL='KKKKKKK'
MARE12   KIKMDF POS=(22,64),LENGTH=09,INITIAL='SSSSSSSSS'
*
MARA13   KIKMDF POS=(23,05),LENGTH=08,INITIAL='KK    KK'
MARB13   KIKMDF POS=(23,24),LENGTH=02,INITIAL='II'
MARC13   KIKMDF POS=(23,33),LENGTH=02,INITIAL='CC'
MARD13   KIKMDF POS=(23,47),LENGTH=08,INITIAL='KK    KK'
MARE13   KIKMDF POS=(23,70),LENGTH=03,INITIAL='SSS'
*
MARA14   KIKMDF POS=(24,04),LENGTH=09,INITIAL='KK     KK'
MARB14   KIKMDF POS=(24,23),LENGTH=02,INITIAL='II'
MARC14   KIKMDF POS=(24,32),LENGTH=02,INITIAL='CC'
MARD14   KIKMDF POS=(24,46),LENGTH=09,INITIAL='KK     KK'
MARE14   KIKMDF POS=(24,70),LENGTH=02,INITIAL='SS'
*
MARA15   KIKMDF POS=(25,03),LENGTH=10,INITIAL='KK      KK'
MARB15   KIKMDF POS=(25,22),LENGTH=02,INITIAL='II'
MARC15   KIKMDF POS=(25,31),LENGTH=12,INITIAL='CC        CC'
MARD15   KIKMDF POS=(25,45),LENGTH=10,INITIAL='KK      KK'
MARE15   KIKMDF POS=(25,59),LENGTH=12,INITIAL='SS        SS'
*
MARA16   KIKMDF POS=(26,02),LENGTH=11,INITIAL='KK       KK'
MARB16   KIKMDF POS=(26,17),LENGTH=10,INITIAL='IIIIIIIIII'
MARC16   KIKMDF POS=(26,30),LENGTH=12,INITIAL='CCCCCCCCCCCC'
MARD16   KIKMDF POS=(26,44),LENGTH=11,INITIAL='KK       KK'
MARE16   KIKMDF POS=(26,59),LENGTH=12,INITIAL='SSSSSSSSSSSS'
*
MARA17   KIKMDF POS=(27,01),LENGTH=12,INITIAL='KK        KK'
MARB17   KIKMDF POS=(27,16),LENGTH=10,INITIAL='IIIIIIIIII'
MARC17   KIKMDF POS=(27,30),LENGTH=11,INITIAL='CCCCCCCCCCC'
MARD17   KIKMDF POS=(27,43),LENGTH=12,INITIAL='KK        KK'
MARE17   KIKMDF POS=(27,59),LENGTH=10,INITIAL='SSSSSSSSSS'
*
MARA18   KIKMDF POS=(28,70),LENGTH=2,INITIAL='TM',COLOR=RED
*
MARA20   KIKMDF POS=(39,60),LENGTH=18,INITIAL='For TSO          ',     *
               COLOR=NEUTRAL,HILIGHT=BLINK
MARB20   KIKMDF POS=(41,60),LENGTH=06,INITIAL='V1R5M0'
MARC20   KIKMDF POS=(42,60),LENGTH=16,INITIAL='September 2014  '
         KIKMDF POS=(43,01),LENGTH=40,                                 *
               INITIAL='Press PF1 for help, CLEAR to continue...'
         KIKMDF POS=(43,42),LENGTH=02,ATTRB=(IC)
         KIKMDF POS=(43,60),LENGTH=11,INITIAL='© Mike Noel'
*
KSGMAPS  KIKMDI SIZE=(32,87),COLOR=TURQUOISE
*
MASX01   KIKMDF POS=(01,01),LENGTH=17,INITIAL='KSGM for cms user'
MASA01   KIKMDF POS=(01,19),LENGTH=08,ATTRB=ASKIP
         KIKMDF POS=(01,28),LENGTH=11,INITIAL='at terminal'
MASB01   KIKMDF POS=(01,40),LENGTH=08,ATTRB=ASKIP
MASC01   KIKMDF POS=(01,62),LENGTH=08,ATTRB=ASKIP
MASD01   KIKMDF POS=(01,72),LENGTH=08,ATTRB=ASKIP
MASE01   KIKMDF POS=(01,50),LENGTH=08,ATTRB=ASKIP
*
MASA06   KIKMDF POS=(09,15),LENGTH=12,INITIAL='KK        KK'
MASB06   KIKMDF POS=(09,30),LENGTH=10,INITIAL='IIIIIIIIII'
MASC06   KIKMDF POS=(09,44),LENGTH=10,INITIAL='CCCCCCCCCC'
MASD06   KIKMDF POS=(09,57),LENGTH=12,INITIAL='KK        KK'
MASE06   KIKMDF POS=(09,72),LENGTH=10,INITIAL='SSSSSSSSSS'
*
MASA07   KIKMDF POS=(10,14),LENGTH=11,INITIAL='KK       KK'
MASB07   KIKMDF POS=(10,29),LENGTH=10,INITIAL='IIIIIIIIII'
MASC07   KIKMDF POS=(10,42),LENGTH=12,INITIAL='CCCCCCCCCCCC'
MASD07   KIKMDF POS=(10,56),LENGTH=11,INITIAL='KK       KK'
MASE07   KIKMDF POS=(10,70),LENGTH=12,INITIAL='SSSSSSSSSSSS'
*
MASA08   KIKMDF POS=(11,13),LENGTH=10,INITIAL='KK      KK'
MASB08   KIKMDF POS=(11,32),LENGTH=02,INITIAL='II'
MASC08   KIKMDF POS=(11,41),LENGTH=12,INITIAL='CC        CC'
MASD08   KIKMDF POS=(11,55),LENGTH=10,INITIAL='KK      KK'
MASE08   KIKMDF POS=(11,69),LENGTH=12,INITIAL='SS        SS'
*
MASA09   KIKMDF POS=(12,12),LENGTH=09,INITIAL='KK     KK'
MASB09   KIKMDF POS=(12,31),LENGTH=02,INITIAL='II'
MASC09   KIKMDF POS=(12,40),LENGTH=02,INITIAL='CC'
MASD09   KIKMDF POS=(12,54),LENGTH=09,INITIAL='KK     KK'
MASE09   KIKMDF POS=(12,68),LENGTH=02,INITIAL='SS'
*
MASA10   KIKMDF POS=(13,11),LENGTH=08,INITIAL='KK    KK'
MASB10   KIKMDF POS=(13,30),LENGTH=02,INITIAL='II'
MASC10   KIKMDF POS=(13,39),LENGTH=02,INITIAL='CC'
MASD10   KIKMDF POS=(13,53),LENGTH=08,INITIAL='KK    KK'
MASE10   KIKMDF POS=(13,67),LENGTH=03,INITIAL='SSS'
*
MASA11   KIKMDF POS=(14,10),LENGTH=07,INITIAL='KKKKKKK'
MASB11   KIKMDF POS=(14,29),LENGTH=02,INITIAL='II'
MASC11   KIKMDF POS=(14,38),LENGTH=02,INITIAL='CC'
MASD11   KIKMDF POS=(14,52),LENGTH=07,INITIAL='KKKKKKK'
MASE11   KIKMDF POS=(14,67),LENGTH=09,INITIAL='SSSSSSSSS'
MASF11   KIKMDF POS=(14,43),LENGTH=04,INITIAL='    '
*
MASA12   KIKMDF POS=(15,09),LENGTH=07,INITIAL='KKKKKKK'
MASB12   KIKMDF POS=(15,28),LENGTH=02,INITIAL='II'
MASC12   KIKMDF POS=(15,37),LENGTH=02,INITIAL='CC'
MASD12   KIKMDF POS=(15,51),LENGTH=07,INITIAL='KKKKKKK'
MASE12   KIKMDF POS=(15,67),LENGTH=09,INITIAL='SSSSSSSSS'
*
MASA13   KIKMDF POS=(16,08),LENGTH=08,INITIAL='KK    KK'
MASB13   KIKMDF POS=(16,27),LENGTH=02,INITIAL='II'
MASC13   KIKMDF POS=(16,36),LENGTH=02,INITIAL='CC'
MASD13   KIKMDF POS=(16,50),LENGTH=08,INITIAL='KK    KK'
MASE13   KIKMDF POS=(16,73),LENGTH=03,INITIAL='SSS'
*
MASA14   KIKMDF POS=(17,07),LENGTH=09,INITIAL='KK     KK'
MASB14   KIKMDF POS=(17,26),LENGTH=02,INITIAL='II'
MASC14   KIKMDF POS=(17,35),LENGTH=02,INITIAL='CC'
MASD14   KIKMDF POS=(17,49),LENGTH=09,INITIAL='KK     KK'
MASE14   KIKMDF POS=(17,73),LENGTH=02,INITIAL='SS'
*
MASA15   KIKMDF POS=(18,06),LENGTH=10,INITIAL='KK      KK'
MASB15   KIKMDF POS=(18,25),LENGTH=02,INITIAL='II'
MASC15   KIKMDF POS=(18,34),LENGTH=12,INITIAL='CC        CC'
MASD15   KIKMDF POS=(18,48),LENGTH=10,INITIAL='KK      KK'
MASE15   KIKMDF POS=(18,62),LENGTH=12,INITIAL='SS        SS'
*
MASA16   KIKMDF POS=(19,05),LENGTH=11,INITIAL='KK       KK'
MASB16   KIKMDF POS=(19,20),LENGTH=10,INITIAL='IIIIIIIIII'
MASC16   KIKMDF POS=(19,33),LENGTH=12,INITIAL='CCCCCCCCCCCC'
MASD16   KIKMDF POS=(19,47),LENGTH=11,INITIAL='KK       KK'
MASE16   KIKMDF POS=(19,62),LENGTH=12,INITIAL='SSSSSSSSSSSS'
*
MASA17   KIKMDF POS=(20,04),LENGTH=12,INITIAL='KK        KK'
MASB17   KIKMDF POS=(20,19),LENGTH=10,INITIAL='IIIIIIIIII'
MASC17   KIKMDF POS=(20,33),LENGTH=11,INITIAL='CCCCCCCCCCC'
MASD17   KIKMDF POS=(20,46),LENGTH=12,INITIAL='KK        KK'
MASE17   KIKMDF POS=(20,62),LENGTH=10,INITIAL='SSSSSSSSSS'
*
MASA18   KIKMDF POS=(21,73),LENGTH=2,INITIAL='TM',COLOR=RED
*
MASA20   KIKMDF POS=(28,66),LENGTH=18,INITIAL='for TSO          ',     *
               COLOR=NEUTRAL,HILIGHT=BLINK
MASB20   KIKMDF POS=(30,66),LENGTH=06,INITIAL='V1R5M0'
MASC20   KIKMDF POS=(31,66),LENGTH=16,INITIAL='September 2014  '
         KIKMDF POS=(32,01),LENGTH=40,                                 *
               INITIAL='Press PF1 for help, CLEAR to continue...'
         KIKMDF POS=(32,42),LENGTH=02,ATTRB=(IC)
         KIKMDF POS=(32,66),LENGTH=11,INITIAL='© Mike Noel'
*
KSGMAPT  KIKMDI SIZE=(27,132),COLOR=TURQUOISE
*
MATX01   KIKMDF POS=(01,01),LENGTH=17,INITIAL='KSGM for cms user'
MATA01   KIKMDF POS=(01,19),LENGTH=08,ATTRB=ASKIP
         KIKMDF POS=(01,28),LENGTH=11,INITIAL='at terminal'
MATB01   KIKMDF POS=(01,40),LENGTH=08,ATTRB=ASKIP
MATC01   KIKMDF POS=(01,111),LENGTH=08,ATTRB=ASKIP
MATD01   KIKMDF POS=(01,121),LENGTH=08,ATTRB=ASKIP
MATE01   KIKMDF POS=(01,50),LENGTH=08,ATTRB=ASKIP
*
MATA06   KIKMDF POS=(07,38),LENGTH=12,INITIAL='KK        KK'
MATB06   KIKMDF POS=(07,53),LENGTH=10,INITIAL='IIIIIIIIII'
MATC06   KIKMDF POS=(07,67),LENGTH=10,INITIAL='CCCCCCCCCC'
MATD06   KIKMDF POS=(07,80),LENGTH=12,INITIAL='KK        KK'
MATE06   KIKMDF POS=(07,95),LENGTH=10,INITIAL='SSSSSSSSSS'
*
MATA07   KIKMDF POS=(08,37),LENGTH=11,INITIAL='KK       KK'
MATB07   KIKMDF POS=(08,52),LENGTH=10,INITIAL='IIIIIIIIII'
MATC07   KIKMDF POS=(08,65),LENGTH=12,INITIAL='CCCCCCCCCCCC'
MATD07   KIKMDF POS=(08,79),LENGTH=11,INITIAL='KK       KK'
MATE07   KIKMDF POS=(08,93),LENGTH=12,INITIAL='SSSSSSSSSSSS'
*
MATA08   KIKMDF POS=(09,36),LENGTH=10,INITIAL='KK      KK'
MATB08   KIKMDF POS=(09,55),LENGTH=02,INITIAL='II'
MATC08   KIKMDF POS=(09,64),LENGTH=12,INITIAL='CC        CC'
MATD08   KIKMDF POS=(09,78),LENGTH=10,INITIAL='KK      KK'
MATE08   KIKMDF POS=(09,92),LENGTH=12,INITIAL='SS        SS'
*
MATA09   KIKMDF POS=(10,35),LENGTH=09,INITIAL='KK     KK'
MATB09   KIKMDF POS=(10,54),LENGTH=02,INITIAL='II'
MATC09   KIKMDF POS=(10,63),LENGTH=02,INITIAL='CC'
MATD09   KIKMDF POS=(10,77),LENGTH=09,INITIAL='KK     KK'
MATE09   KIKMDF POS=(10,91),LENGTH=02,INITIAL='SS'
*
MATA10   KIKMDF POS=(11,34),LENGTH=08,INITIAL='KK    KK'
MATB10   KIKMDF POS=(11,53),LENGTH=02,INITIAL='II'
MATC10   KIKMDF POS=(11,62),LENGTH=02,INITIAL='CC'
MATD10   KIKMDF POS=(11,76),LENGTH=08,INITIAL='KK    KK'
MATE10   KIKMDF POS=(11,90),LENGTH=03,INITIAL='SSS'
*
MATA11   KIKMDF POS=(12,33),LENGTH=07,INITIAL='KKKKKKK'
MATB11   KIKMDF POS=(12,52),LENGTH=02,INITIAL='II'
MATC11   KIKMDF POS=(12,61),LENGTH=02,INITIAL='CC'
MATD11   KIKMDF POS=(12,75),LENGTH=07,INITIAL='KKKKKKK'
MATE11   KIKMDF POS=(12,90),LENGTH=09,INITIAL='SSSSSSSSS'
MATF11   KIKMDF POS=(12,66),LENGTH=04,INITIAL='    '
*
MATA12   KIKMDF POS=(13,32),LENGTH=07,INITIAL='KKKKKKK'
MATB12   KIKMDF POS=(13,51),LENGTH=02,INITIAL='II'
MATC12   KIKMDF POS=(13,60),LENGTH=02,INITIAL='CC'
MATD12   KIKMDF POS=(13,74),LENGTH=07,INITIAL='KKKKKKK'
MATE12   KIKMDF POS=(13,90),LENGTH=09,INITIAL='SSSSSSSSS'
*
MATA13   KIKMDF POS=(14,31),LENGTH=08,INITIAL='KK    KK'
MATB13   KIKMDF POS=(14,50),LENGTH=02,INITIAL='II'
MATC13   KIKMDF POS=(14,59),LENGTH=02,INITIAL='CC'
MATD13   KIKMDF POS=(14,73),LENGTH=08,INITIAL='KK    KK'
MATE13   KIKMDF POS=(14,96),LENGTH=03,INITIAL='SSS'
*
MATA14   KIKMDF POS=(15,30),LENGTH=09,INITIAL='KK     KK'
MATB14   KIKMDF POS=(15,49),LENGTH=02,INITIAL='II'
MATC14   KIKMDF POS=(15,58),LENGTH=02,INITIAL='CC'
MATD14   KIKMDF POS=(15,72),LENGTH=09,INITIAL='KK     KK'
MATE14   KIKMDF POS=(15,96),LENGTH=02,INITIAL='SS'
*
MATA15   KIKMDF POS=(16,29),LENGTH=10,INITIAL='KK      KK'
MATB15   KIKMDF POS=(16,48),LENGTH=02,INITIAL='II'
MATC15   KIKMDF POS=(16,57),LENGTH=12,INITIAL='CC        CC'
MATD15   KIKMDF POS=(16,71),LENGTH=10,INITIAL='KK      KK'
MATE15   KIKMDF POS=(16,85),LENGTH=12,INITIAL='SS        SS'
*
MATA16   KIKMDF POS=(17,28),LENGTH=11,INITIAL='KK       KK'
MATB16   KIKMDF POS=(17,43),LENGTH=10,INITIAL='IIIIIIIIII'
MATC16   KIKMDF POS=(17,56),LENGTH=12,INITIAL='CCCCCCCCCCCC'
MATD16   KIKMDF POS=(17,70),LENGTH=11,INITIAL='KK       KK'
MATE16   KIKMDF POS=(17,85),LENGTH=12,INITIAL='SSSSSSSSSSSS'
*
MATA17   KIKMDF POS=(18,27),LENGTH=12,INITIAL='KK        KK'
MATB17   KIKMDF POS=(18,42),LENGTH=10,INITIAL='IIIIIIIIII'
MATC17   KIKMDF POS=(18,56),LENGTH=11,INITIAL='CCCCCCCCCCC'
MATD17   KIKMDF POS=(18,69),LENGTH=12,INITIAL='KK        KK'
MATE17   KIKMDF POS=(18,85),LENGTH=10,INITIAL='SSSSSSSSSS'
*
MATA18   KIKMDF POS=(19,96),LENGTH=2,INITIAL='TM',COLOR=RED
*
MATA20   KIKMDF POS=(23,112),LENGTH=18,INITIAL='For TSO          ',    *
               COLOR=NEUTRAL,HILIGHT=BLINK
MATB20   KIKMDF POS=(25,112),LENGTH=06,INITIAL='V1R5M0'
MATC20   KIKMDF POS=(26,112),LENGTH=16,INITIAL='September 2014  '
         KIKMDF POS=(27,01),LENGTH=40,                                 *
               INITIAL='Press PF1 for help, CLEAR to continue...'
         KIKMDF POS=(27,42),LENGTH=02,ATTRB=(IC)
         KIKMDF POS=(27,112),LENGTH=11,INITIAL='© Mike Noel'
*
KSGMAPU  KIKMDI SIZE=(62,160),COLOR=TURQUOISE
*
MAUX01   KIKMDF POS=(01,01),LENGTH=17,INITIAL='KSGM for cms user'
MAUA01   KIKMDF POS=(01,19),LENGTH=08,ATTRB=ASKIP
         KIKMDF POS=(01,28),LENGTH=11,INITIAL='at terminal'
MAUB01   KIKMDF POS=(01,40),LENGTH=08,ATTRB=ASKIP
MAUC01   KIKMDF POS=(01,139),LENGTH=08,ATTRB=ASKIP
MAUD01   KIKMDF POS=(01,149),LENGTH=08,ATTRB=ASKIP
MAUE01   KIKMDF POS=(01,50),LENGTH=08,ATTRB=ASKIP
*
MAUA06   KIKMDF POS=(24,52),LENGTH=12,INITIAL='KK        KK'
MAUB06   KIKMDF POS=(24,67),LENGTH=10,INITIAL='IIIIIIIIII'
MAU006   KIKMDF POS=(24,81),LENGTH=10,INITIAL='CCCCCCCCCC'
MAUD06   KIKMDF POS=(24,94),LENGTH=12,INITIAL='KK        KK'
MAUE06   KIKMDF POS=(24,109),LENGTH=10,INITIAL='SSSSSSSSSS'
*
MAUA07   KIKMDF POS=(25,51),LENGTH=11,INITIAL='KK       KK'
MAUB07   KIKMDF POS=(25,66),LENGTH=10,INITIAL='IIIIIIIIII'
MAUC07   KIKMDF POS=(25,79),LENGTH=12,INITIAL='CCCCCCCCCCCC'
MAUD07   KIKMDF POS=(25,93),LENGTH=11,INITIAL='KK       KK'
MAUE07   KIKMDF POS=(25,107),LENGTH=12,INITIAL='SSSSSSSSSSSS'
*
MAUA08   KIKMDF POS=(26,50),LENGTH=10,INITIAL='KK      KK'
MAUB08   KIKMDF POS=(26,69),LENGTH=02,INITIAL='II'
MAUC08   KIKMDF POS=(26,78),LENGTH=12,INITIAL='CC        CC'
MAUD08   KIKMDF POS=(26,92),LENGTH=10,INITIAL='KK      KK'
MAUE08   KIKMDF POS=(26,106),LENGTH=12,INITIAL='SS        SS'
*
MAUA09   KIKMDF POS=(27,49),LENGTH=09,INITIAL='KK     KK'
MAUB09   KIKMDF POS=(27,68),LENGTH=02,INITIAL='II'
MAUC09   KIKMDF POS=(27,77),LENGTH=02,INITIAL='CC'
MAUD09   KIKMDF POS=(27,91),LENGTH=09,INITIAL='KK     KK'
MAUE09   KIKMDF POS=(27,105),LENGTH=02,INITIAL='SS'
*
MAUA10   KIKMDF POS=(28,48),LENGTH=08,INITIAL='KK    KK'
MAUB10   KIKMDF POS=(28,67),LENGTH=02,INITIAL='II'
MAUC10   KIKMDF POS=(28,76),LENGTH=02,INITIAL='CC'
MAUD10   KIKMDF POS=(28,90),LENGTH=08,INITIAL='KK    KK'
MAUE10   KIKMDF POS=(28,104),LENGTH=03,INITIAL='SSS'
*
MAUA11   KIKMDF POS=(29,47),LENGTH=07,INITIAL='KKKKKKK'
MAUB11   KIKMDF POS=(29,66),LENGTH=02,INITIAL='II'
MAUC11   KIKMDF POS=(29,75),LENGTH=02,INITIAL='CC'
MAUD11   KIKMDF POS=(29,89),LENGTH=07,INITIAL='KKKKKKK'
MAUE11   KIKMDF POS=(29,104),LENGTH=09,INITIAL='SSSSSSSSS'
MAUF11   KIKMDF POS=(29,80),LENGTH=04,INITIAL='    '
*
MAUA12   KIKMDF POS=(30,46),LENGTH=07,INITIAL='KKKKKKK'
MAUB12   KIKMDF POS=(30,65),LENGTH=02,INITIAL='II'
MAUC12   KIKMDF POS=(30,74),LENGTH=02,INITIAL='CC'
MAUD12   KIKMDF POS=(30,88),LENGTH=07,INITIAL='KKKKKKK'
MAUE12   KIKMDF POS=(30,104),LENGTH=09,INITIAL='SSSSSSSSS'
*
MAUA13   KIKMDF POS=(31,45),LENGTH=08,INITIAL='KK    KK'
MAUB13   KIKMDF POS=(31,64),LENGTH=02,INITIAL='II'
MAUC13   KIKMDF POS=(31,73),LENGTH=02,INITIAL='CC'
MAUD13   KIKMDF POS=(31,87),LENGTH=08,INITIAL='KK    KK'
MAUE13   KIKMDF POS=(31,110),LENGTH=03,INITIAL='SSS'
*
MAUA14   KIKMDF POS=(32,44),LENGTH=09,INITIAL='KK     KK'
MAUB14   KIKMDF POS=(32,63),LENGTH=02,INITIAL='II'
MAUC14   KIKMDF POS=(32,72),LENGTH=02,INITIAL='CC'
MAUD14   KIKMDF POS=(32,86),LENGTH=09,INITIAL='KK     KK'
MAUE14   KIKMDF POS=(32,110),LENGTH=02,INITIAL='SS'
*
MAUA15   KIKMDF POS=(33,43),LENGTH=10,INITIAL='KK      KK'
MAUB15   KIKMDF POS=(33,62),LENGTH=02,INITIAL='II'
MAUC15   KIKMDF POS=(33,71),LENGTH=12,INITIAL='CC        CC'
MAUD15   KIKMDF POS=(33,85),LENGTH=10,INITIAL='KK      KK'
MAUE15   KIKMDF POS=(33,99),LENGTH=12,INITIAL='SS        SS'
*
MAUA16   KIKMDF POS=(34,42),LENGTH=11,INITIAL='KK       KK'
MAUB16   KIKMDF POS=(34,57),LENGTH=10,INITIAL='IIIIIIIIII'
MAUC16   KIKMDF POS=(34,70),LENGTH=12,INITIAL='CCCCCCCCCCCC'
MAUD16   KIKMDF POS=(34,84),LENGTH=11,INITIAL='KK       KK'
MAUE16   KIKMDF POS=(34,99),LENGTH=12,INITIAL='SSSSSSSSSSSS'
*
MAUA17   KIKMDF POS=(35,41),LENGTH=12,INITIAL='KK        KK'
MAUB17   KIKMDF POS=(35,56),LENGTH=10,INITIAL='IIIIIIIIII'
MAUC17   KIKMDF POS=(35,70),LENGTH=11,INITIAL='CCCCCCCCCCC'
MAUD17   KIKMDF POS=(35,83),LENGTH=12,INITIAL='KK        KK'
MAUE17   KIKMDF POS=(35,99),LENGTH=10,INITIAL='SSSSSSSSSS'
*
MAUA18   KIKMDF POS=(36,110),LENGTH=2,INITIAL='TM',COLOR=RED
*
MAUA20   KIKMDF POS=(58,140),LENGTH=18,INITIAL='For TSO          ',    *
               COLOR=NEUTRAL,HILIGHT=BLINK
MAUB20   KIKMDF POS=(60,140),LENGTH=06,INITIAL='V1R5M0'
MAUC20   KIKMDF POS=(61,140),LENGTH=16,INITIAL='September 2014  '
         KIKMDF POS=(62,01),LENGTH=40,                                 *
               INITIAL='Press PF1 for help, CLEAR to continue...'
         KIKMDF POS=(62,42),LENGTH=02,ATTRB=(IC)
         KIKMDF POS=(62,140),LENGTH=11,INITIAL='© Mike Noel'
*
         KIKMSD TYPE=FINAL
         END
/*
//LINKMAP.SYSLMOD DD DSN=K.S.V1R5M0.KIKRPL(KSGMAP),
//       DISP=SHR
//COBMAP.SYSPRINT DD DSN=K.S.V1R5M0.COBCOPY(KSGMAP),
//       DISP=SHR
//GCCMAP.SYSPRINT DD DSN=K.S.V1R5M0.GCCCOPY(KSGMAP),
//       DISP=SHR
//*
//* compile the map for the license display
//*
//KSGMAPL EXEC KIKMAPS,MAPNAME=KSGMAPL
//COPY.SYSUT1 DD *
         PRINT NOGEN
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
* maps ksgmapp - 24x80, ksgmapq - 32x80,  ksgmapr - 43x80
*
KSGMAPL  KIKMSD MODE=INOUT,CTRL=FREEKB,EXTATT=YES,                     *
               TYPE=&SYSPARM,LANG=COBOL,TIOAPFX=YES
*
*
*
KSGMAPP  KIKMDI SIZE=(24,80),COLOR=TURQUOISE

P02      KIKMDF POS=(02,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(02,80),LENGTH=1
P03      KIKMDF POS=(03,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(03,80),LENGTH=1
P04      KIKMDF POS=(04,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(04,80),LENGTH=1
P05      KIKMDF POS=(05,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(05,80),LENGTH=1
P06      KIKMDF POS=(06,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(06,80),LENGTH=1
P07      KIKMDF POS=(07,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(07,80),LENGTH=1
P08      KIKMDF POS=(08,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(08,80),LENGTH=1
P09      KIKMDF POS=(09,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(09,80),LENGTH=1
P10      KIKMDF POS=(10,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(10,80),LENGTH=1
P11      KIKMDF POS=(11,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(11,80),LENGTH=1
P12      KIKMDF POS=(12,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(12,80),LENGTH=1
P13      KIKMDF POS=(13,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(13,80),LENGTH=1
P14      KIKMDF POS=(14,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(14,80),LENGTH=1
P15      KIKMDF POS=(15,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(15,80),LENGTH=1
P16      KIKMDF POS=(16,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(16,80),LENGTH=1
P17      KIKMDF POS=(17,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(17,80),LENGTH=1
P18      KIKMDF POS=(18,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(18,80),LENGTH=1
P19      KIKMDF POS=(19,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(19,80),LENGTH=1
P20      KIKMDF POS=(20,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(20,80),LENGTH=1
P21      KIKMDF POS=(21,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(21,80),LENGTH=1
P22      KIKMDF POS=(22,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(22,80),LENGTH=1

         KIKMDF POS=(24,01),LENGTH=12,INITIAL='PF3 - return'
         KIKMDF POS=(24,23),LENGTH=15,INITIAL='PF7 - page back'
         KIKMDF POS=(24,41),LENGTH=18,INITIAL='PF8 - page forward'
         KIKMDF POS=(24,66),LENGTH=12,INITIAL='PF10 - print'
         KIKMDF POS=(24,16),LENGTH=02,ATTRB=(IC)
*
*
*
KSGMAPQ  KIKMDI SIZE=(32,80),COLOR=TURQUOISE

Q02      KIKMDF POS=(02,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(02,80),LENGTH=1
Q03      KIKMDF POS=(03,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(03,80),LENGTH=1
Q04      KIKMDF POS=(04,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(04,80),LENGTH=1
Q05      KIKMDF POS=(05,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(05,80),LENGTH=1
Q06      KIKMDF POS=(06,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(06,80),LENGTH=1
Q07      KIKMDF POS=(07,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(07,80),LENGTH=1
Q08      KIKMDF POS=(08,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(08,80),LENGTH=1
Q09      KIKMDF POS=(09,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(09,80),LENGTH=1
Q10      KIKMDF POS=(10,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(10,80),LENGTH=1
Q11      KIKMDF POS=(11,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(11,80),LENGTH=1
Q12      KIKMDF POS=(12,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(12,80),LENGTH=1
Q13      KIKMDF POS=(13,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(13,80),LENGTH=1
Q14      KIKMDF POS=(14,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(14,80),LENGTH=1
Q15      KIKMDF POS=(15,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(15,80),LENGTH=1
Q16      KIKMDF POS=(16,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(16,80),LENGTH=1
Q17      KIKMDF POS=(17,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(17,80),LENGTH=1
Q18      KIKMDF POS=(18,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(18,80),LENGTH=1
Q19      KIKMDF POS=(19,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(19,80),LENGTH=1
Q20      KIKMDF POS=(20,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(20,80),LENGTH=1
Q21      KIKMDF POS=(21,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(21,80),LENGTH=1
Q22      KIKMDF POS=(22,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(22,80),LENGTH=1
Q23      KIKMDF POS=(23,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(23,80),LENGTH=1
Q24      KIKMDF POS=(24,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(24,80),LENGTH=1
Q25      KIKMDF POS=(25,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(25,80),LENGTH=1
Q26      KIKMDF POS=(26,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(26,80),LENGTH=1
Q27      KIKMDF POS=(27,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(27,80),LENGTH=1
Q28      KIKMDF POS=(28,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(28,80),LENGTH=1

         KIKMDF POS=(32,01),LENGTH=12,INITIAL='PF3 - return'
         KIKMDF POS=(32,23),LENGTH=15,INITIAL='PF7 - page back'
         KIKMDF POS=(32,41),LENGTH=18,INITIAL='PF8 - page forward'
         KIKMDF POS=(32,66),LENGTH=12,INITIAL='PF10 - print'
         KIKMDF POS=(32,16),LENGTH=02,ATTRB=(IC)
*
*
*
KSGMAPR  KIKMDI SIZE=(43,80),COLOR=TURQUOISE

R02      KIKMDF POS=(02,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(02,80),LENGTH=1
R03      KIKMDF POS=(03,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(03,80),LENGTH=1
R04      KIKMDF POS=(04,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(04,80),LENGTH=1
R05      KIKMDF POS=(05,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(05,80),LENGTH=1
R06      KIKMDF POS=(06,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(06,80),LENGTH=1
R07      KIKMDF POS=(07,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(07,80),LENGTH=1
R08      KIKMDF POS=(08,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(08,80),LENGTH=1
R09      KIKMDF POS=(09,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(09,80),LENGTH=1
R10      KIKMDF POS=(10,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(10,80),LENGTH=1
R11      KIKMDF POS=(11,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(11,80),LENGTH=1
R12      KIKMDF POS=(12,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(12,80),LENGTH=1
R13      KIKMDF POS=(13,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(13,80),LENGTH=1
R14      KIKMDF POS=(14,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(14,80),LENGTH=1
R15      KIKMDF POS=(15,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(15,80),LENGTH=1
R16      KIKMDF POS=(16,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(16,80),LENGTH=1
R17      KIKMDF POS=(17,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(17,80),LENGTH=1
R18      KIKMDF POS=(18,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(18,80),LENGTH=1
R19      KIKMDF POS=(19,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(19,80),LENGTH=1
R20      KIKMDF POS=(20,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(20,80),LENGTH=1
R21      KIKMDF POS=(21,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(21,80),LENGTH=1
R22      KIKMDF POS=(22,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(22,80),LENGTH=1
R23      KIKMDF POS=(23,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(23,80),LENGTH=1
R24      KIKMDF POS=(24,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(24,80),LENGTH=1
R25      KIKMDF POS=(25,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(25,80),LENGTH=1
R26      KIKMDF POS=(26,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(26,80),LENGTH=1
R27      KIKMDF POS=(27,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(27,80),LENGTH=1
R28      KIKMDF POS=(28,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(28,80),LENGTH=1
R29      KIKMDF POS=(29,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(29,80),LENGTH=1
R30      KIKMDF POS=(30,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(30,80),LENGTH=1
R31      KIKMDF POS=(31,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(31,80),LENGTH=1
R32      KIKMDF POS=(32,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(32,80),LENGTH=1
R33      KIKMDF POS=(33,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(33,80),LENGTH=1
R34      KIKMDF POS=(34,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(34,80),LENGTH=1
R35      KIKMDF POS=(35,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(35,80),LENGTH=1
R36      KIKMDF POS=(36,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(36,80),LENGTH=1
R37      KIKMDF POS=(37,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(37,80),LENGTH=1
R38      KIKMDF POS=(38,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(38,80),LENGTH=1
R39      KIKMDF POS=(39,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(39,80),LENGTH=1
R40      KIKMDF POS=(40,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(40,80),LENGTH=1
R41      KIKMDF POS=(41,01),LENGTH=78,COLOR=WHITE,HILIGHT=REVERSE
         KIKMDF POS=(41,80),LENGTH=1

         KIKMDF POS=(43,01),LENGTH=12,INITIAL='PF3 - return'
         KIKMDF POS=(43,23),LENGTH=15,INITIAL='PF7 - page back'
         KIKMDF POS=(43,41),LENGTH=18,INITIAL='PF8 - page forward'
         KIKMDF POS=(43,66),LENGTH=12,INITIAL='PF10 - print'
         KIKMDF POS=(43,16),LENGTH=02,ATTRB=(IC)
*
*
*
         KIKMSD TYPE=FINAL
         END
/*
//LINKMAP.SYSLMOD DD DSN=K.S.V1R5M0.KIKRPL(KSGMAPL),
//       DISP=SHR
//COBMAP.SYSPRINT DD DSN=K.S.V1R5M0.COBCOPY(KSGMAPL),
//       DISP=SHR
//GCCMAP.SYSPRINT DD DSN=K.S.V1R5M0.GCCCOPY(KSGMAPL),
//       DISP=SHR
//