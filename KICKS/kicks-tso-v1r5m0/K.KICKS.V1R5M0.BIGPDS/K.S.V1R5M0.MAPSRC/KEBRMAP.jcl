//KEBRMAP JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1)
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
// EXEC KIKMAPS,MAPNAME=KEBRM PARM.ASM='DECK,LIST'
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
* maps KEBRMp - 24x80, KEBRMq - 32x80,      KEBRMr - 43x80
*      KEBRMs - 32x87, KEBRMt - 27x132      KEBRMu - 62x160
*      32x87 is ibm dynamic size used by mecaff (in cms)
*      62x160 is 3290 max size, also supposedly ispf max size
*
KEBRM    DFHMSD MODE=INOUT,CTRL=FREEKB,                                *
               DSATTS=(COLOR,HILIGHT),                                 *
               MAPATTS=(COLOR,HILIGHT),                                *
               TYPE=&SYSPARM,LANG=COBOL,TIOAPFX=YES
*
KEBRMP   DFHMDI SIZE=(24,80),COLOR=TURQUOISE
*
MAPA01   DFHMDF POS=(01,01),LENGTH=04,INITIAL='KEBR'
         DFHMDF POS=(01,06),LENGTH=08,INITIAL='TS Queue'
MAPB01   DFHMDF POS=(01,15),LENGTH=36,ATTRB=(NORM,UNPROT,FSET)
         DFHMDF POS=(01,52),LENGTH=01,ATTRB=ASKIP
         DFHMDF POS=(01,54),LENGTH=09,INITIAL='Line/Item'
MAPC01   DFHMDF POS=(01,64),LENGTH=05,ATTRB=(NORM,NUM,UNPROT,FSET),    *
               PICIN='99999',PICOUT='ZZZZ9'
         DFHMDF POS=(01,70),LENGTH=03,INITIAL='of'
MAPD01   DFHMDF POS=(01,74),LENGTH=05,ATTRB=(NORM,PROT),               *
               PICOUT='ZZZZ9'
*
         DFHMDF POS=(02,01),LENGTH=12,INITIAL='Command ===>'
MAPB02   DFHMDF POS=(02,14),LENGTH=42,ATTRB=(IC,NORM,UNPROT)
         DFHMDF POS=(02,57),LENGTH=06,ATTRB=ASKIP,INITIAL='Column'
MAPC02   DFHMDF POS=(02,64),LENGTH=05,ATTRB=(NORM,NUM,UNPROT,FSET),    *
               PICIN='99999',PICOUT='ZZZZ9'
         DFHMDF POS=(02,70),LENGTH=02,INITIAL='of'
MAPD02   DFHMDF POS=(02,74),LENGTH=05,ATTRB=(NORM,PROT),               *
               PICOUT='ZZZZ9'
*
MAPA03   DFHMDF POS=(03,01),LENGTH=79,OCCURS=19
*
         DFHMDF POS=(22,01),LENGTH=40,                                 *
               INITIAL='PF1 : Help          PF2 : HEX/Char      '
         DFHMDF POS=(22,40),LENGTH=40,                                 *
               INITIAL='PF3 : Quit          PF4 :               '
         DFHMDF POS=(23,01),LENGTH=40,                                 *
               INITIAL='PF5 : RFind         PF6 :               '
         DFHMDF POS=(23,40),LENGTH=40,                                 *
               INITIAL='PF7 : Back          PF8 : Forward       '
         DFHMDF POS=(24,01),LENGTH=40,                                 *
               INITIAL='PF9 :               PF10: Left          '
         DFHMDF POS=(24,40),LENGTH=40,                                 *
               INITIAL='PF11: Right         PF12: Quit          '
*
KEBRMQ   DFHMDI SIZE=(32,80),COLOR=TURQUOISE
*
MAQA01   DFHMDF POS=(01,01),LENGTH=04,INITIAL='KEBR'
         DFHMDF POS=(01,06),LENGTH=08,INITIAL='TS Queue'
MAQB01   DFHMDF POS=(01,15),LENGTH=36,ATTRB=(NORM,UNPROT,FSET)
         DFHMDF POS=(01,52),LENGTH=01,ATTRB=ASKIP
         DFHMDF POS=(01,54),LENGTH=09,INITIAL='Line/Item'
MAQC01   DFHMDF POS=(01,64),LENGTH=05,ATTRB=(NORM,NUM,UNPROT,FSET),    *
               PICIN='99999',PICOUT='ZZZZ9'
         DFHMDF POS=(01,70),LENGTH=03,INITIAL='of'
MAQD01   DFHMDF POS=(01,74),LENGTH=05,ATTRB=(NORM,PROT),               *
               PICOUT='ZZZZ9'
*
         DFHMDF POS=(02,01),LENGTH=12,INITIAL='Command ===>'
MAQB02   DFHMDF POS=(02,14),LENGTH=42,ATTRB=(IC,NORM,UNPROT)
         DFHMDF POS=(02,57),LENGTH=06,ATTRB=ASKIP,INITIAL='Column'
MAQC02   DFHMDF POS=(02,64),LENGTH=05,ATTRB=(NORM,NUM,UNPROT,FSET),    *
               PICIN='99999',PICOUT='ZZZZ9'
         DFHMDF POS=(02,70),LENGTH=02,INITIAL='of'
MAQD02   DFHMDF POS=(02,74),LENGTH=05,ATTRB=(NORM,PROT),               *
               PICOUT='ZZZZ9'
*
MAQA03   DFHMDF POS=(03,01),LENGTH=79,OCCURS=27
*
         DFHMDF POS=(30,01),LENGTH=40,                                 *
               INITIAL='PF1 : Help          PF2 : HEX/Char      '
         DFHMDF POS=(30,40),LENGTH=40,                                 *
               INITIAL='PF3 : Quit          PF4 :               '
         DFHMDF POS=(31,01),LENGTH=40,                                 *
               INITIAL='PF5 : RFind         PF6 :               '
         DFHMDF POS=(31,40),LENGTH=40,                                 *
               INITIAL='PF7 : Back          PF8 : Forward       '
         DFHMDF POS=(32,01),LENGTH=40,                                 *
               INITIAL='PF9 :               PF10: Left          '
         DFHMDF POS=(32,40),LENGTH=40,                                 *
               INITIAL='PF11: Right         PF12: Quit          '
*
KEBRMR   DFHMDI SIZE=(43,80),COLOR=TURQUOISE
*
MARA01   DFHMDF POS=(01,01),LENGTH=04,INITIAL='KEBR'
         DFHMDF POS=(01,06),LENGTH=08,INITIAL='TS Queue'
MARB01   DFHMDF POS=(01,15),LENGTH=36,ATTRB=(NORM,UNPROT,FSET)
         DFHMDF POS=(01,52),LENGTH=01,ATTRB=ASKIP
         DFHMDF POS=(01,54),LENGTH=09,INITIAL='Line/Item'
MARC01   DFHMDF POS=(01,64),LENGTH=05,ATTRB=(NORM,NUM,UNPROT,FSET),    *
               PICIN='99999',PICOUT='ZZZZ9'
         DFHMDF POS=(01,70),LENGTH=03,INITIAL='of'
MARD01   DFHMDF POS=(01,74),LENGTH=05,ATTRB=(NORM,PROT),               *
               PICOUT='ZZZZ9'
*
         DFHMDF POS=(02,01),LENGTH=12,INITIAL='Command ===>'
MARB02   DFHMDF POS=(02,14),LENGTH=42,ATTRB=(IC,NORM,UNPROT)
         DFHMDF POS=(02,57),LENGTH=06,ATTRB=ASKIP,INITIAL='Column'
MARC02   DFHMDF POS=(02,64),LENGTH=05,ATTRB=(NORM,NUM,UNPROT,FSET),    *
               PICIN='99999',PICOUT='ZZZZ9'
         DFHMDF POS=(02,70),LENGTH=02,INITIAL='of'
MARD02   DFHMDF POS=(02,74),LENGTH=05,ATTRB=(NORM,PROT),               *
               PICOUT='ZZZZ9'
*
MARA03   DFHMDF POS=(03,01),LENGTH=79,OCCURS=38
*
         DFHMDF POS=(41,01),LENGTH=40,                                 *
               INITIAL='PF1 : Help          PF2 : HEX/Char      '
         DFHMDF POS=(41,40),LENGTH=40,                                 *
               INITIAL='PF3 : Quit          PF4 :               '
         DFHMDF POS=(42,01),LENGTH=40,                                 *
               INITIAL='PF5 : RFind         PF6 :               '
         DFHMDF POS=(42,40),LENGTH=40,                                 *
               INITIAL='PF7 : Back          PF8 : Forward       '
         DFHMDF POS=(43,01),LENGTH=40,                                 *
               INITIAL='PF9 :               PF10: Left          '
         DFHMDF POS=(43,40),LENGTH=40,                                 *
               INITIAL='PF11: Right         PF12: Quit          '
*
KEBRMS   DFHMDI SIZE=(32,87),COLOR=TURQUOISE
*
MASA01   DFHMDF POS=(01,01),LENGTH=04,INITIAL='KEBR'
         DFHMDF POS=(01,06),LENGTH=08,INITIAL='TS Queue'
MASB01   DFHMDF POS=(01,15),LENGTH=36,ATTRB=(NORM,UNPROT,FSET)
         DFHMDF POS=(01,52),LENGTH=01,ATTRB=ASKIP
         DFHMDF POS=(01,54),LENGTH=09,INITIAL='Line/Item'
MASC01   DFHMDF POS=(01,64),LENGTH=05,ATTRB=(NORM,NUM,UNPROT,FSET),    *
               PICIN='99999',PICOUT='ZZZZ9'
         DFHMDF POS=(01,70),LENGTH=03,INITIAL='of'
MASD01   DFHMDF POS=(01,74),LENGTH=05,ATTRB=(NORM,PROT),               *
               PICOUT='ZZZZ9'
*
         DFHMDF POS=(02,01),LENGTH=12,INITIAL='Command ===>'
MASB02   DFHMDF POS=(02,14),LENGTH=42,ATTRB=(IC,NORM,UNPROT)
         DFHMDF POS=(02,57),LENGTH=06,ATTRB=ASKIP,INITIAL='Column'
MASC02   DFHMDF POS=(02,64),LENGTH=05,ATTRB=(NORM,NUM,UNPROT,FSET),    *
               PICIN='99999',PICOUT='ZZZZ9'
         DFHMDF POS=(02,70),LENGTH=02,INITIAL='of'
MASD02   DFHMDF POS=(02,74),LENGTH=05,ATTRB=(NORM,PROT),               *
               PICOUT='ZZZZ9'
*
MASA03   DFHMDF POS=(03,01),LENGTH=86,OCCURS=27
*
         DFHMDF POS=(30,01),LENGTH=40,                                 *
               INITIAL='PF1 : Help          PF2 : HEX/Char      '
         DFHMDF POS=(30,40),LENGTH=40,                                 *
               INITIAL='PF3 : Quit          PF4 :               '
         DFHMDF POS=(31,01),LENGTH=40,                                 *
               INITIAL='PF5 : RFind         PF6 :               '
         DFHMDF POS=(31,40),LENGTH=40,                                 *
               INITIAL='PF7 : Back          PF8 : Forward       '
         DFHMDF POS=(32,01),LENGTH=40,                                 *
               INITIAL='PF9 :               PF10: Left          '
         DFHMDF POS=(32,40),LENGTH=40,                                 *
               INITIAL='PF11: Right         PF12: Quit          '
*
KEBRMT   DFHMDI SIZE=(27,132),COLOR=TURQUOISE
*
MATA01   DFHMDF POS=(01,01),LENGTH=04,INITIAL='KEBR'
         DFHMDF POS=(01,06),LENGTH=08,INITIAL='TS Queue'
MATB01   DFHMDF POS=(01,15),LENGTH=36,ATTRB=(NORM,UNPROT,FSET)
         DFHMDF POS=(01,52),LENGTH=01,ATTRB=ASKIP
         DFHMDF POS=(01,54),LENGTH=09,INITIAL='Line/Item'
MATC01   DFHMDF POS=(01,64),LENGTH=05,ATTRB=(NORM,NUM,UNPROT,FSET),    *
               PICIN='99999',PICOUT='ZZZZ9'
         DFHMDF POS=(01,70),LENGTH=03,INITIAL='of'
MATD01   DFHMDF POS=(01,74),LENGTH=05,ATTRB=(NORM,PROT),               *
               PICOUT='ZZZZ9'
*
         DFHMDF POS=(02,01),LENGTH=12,INITIAL='Command ===>'
MATB02   DFHMDF POS=(02,14),LENGTH=42,ATTRB=(IC,NORM,UNPROT)
         DFHMDF POS=(02,57),LENGTH=06,ATTRB=ASKIP,INITIAL='Column'
MATC02   DFHMDF POS=(02,64),LENGTH=05,ATTRB=(NORM,NUM,UNPROT,FSET),    *
               PICIN='99999',PICOUT='ZZZZ9'
         DFHMDF POS=(02,70),LENGTH=02,INITIAL='of'
MATD02   DFHMDF POS=(02,74),LENGTH=05,ATTRB=(NORM,PROT),               *
               PICOUT='ZZZZ9'
*
MATA03   DFHMDF POS=(03,01),LENGTH=131,OCCURS=23
*
         DFHMDF POS=(26,01),LENGTH=40,                                 *
               INITIAL='PF1 : Help          PF2 : HEX/Char      '
         DFHMDF POS=(26,40),LENGTH=40,                                 *
               INITIAL='PF3 : Quit          PF4 :               '
         DFHMDF POS=(26,81),LENGTH=40,                                 *
               INITIAL='PF5 : RFind         PF6 :               '
         DFHMDF POS=(27,01),LENGTH=40,                                 *
               INITIAL='PF7 : Back          PF8 : Forward       '
         DFHMDF POS=(27,40),LENGTH=40,                                 *
               INITIAL='PF9 :               PF10: Left          '
         DFHMDF POS=(27,81),LENGTH=40,                                 *
               INITIAL='PF11: Right         PF12: Quit          '
*
KEBRMU   DFHMDI SIZE=(62,160),COLOR=TURQUOISE
*
MAUA01   DFHMDF POS=(01,01),LENGTH=04,INITIAL='KEBR'
         DFHMDF POS=(01,06),LENGTH=08,INITIAL='TS Queue'
MAUB01   DFHMDF POS=(01,15),LENGTH=36,ATTRB=(NORM,UNPROT,FSET)
         DFHMDF POS=(01,52),LENGTH=01,ATTRB=ASKIP
         DFHMDF POS=(01,54),LENGTH=09,INITIAL='Line/Item'
MAUC01   DFHMDF POS=(01,64),LENGTH=05,ATTRB=(NORM,NUM,UNPROT,FSET),    *
               PICIN='99999',PICOUT='ZZZZ9'
         DFHMDF POS=(01,70),LENGTH=03,INITIAL='of'
MAUD01   DFHMDF POS=(01,74),LENGTH=05,ATTRB=(NORM,PROT),               *
               PICOUT='ZZZZ9'
*
         DFHMDF POS=(02,01),LENGTH=12,INITIAL='Command ===>'
MAUB02   DFHMDF POS=(02,14),LENGTH=42,ATTRB=(IC,NORM,UNPROT)
         DFHMDF POS=(02,57),LENGTH=06,ATTRB=ASKIP,INITIAL='Column'
MAUC02   DFHMDF POS=(02,64),LENGTH=05,ATTRB=(NORM,NUM,UNPROT,FSET),    *
               PICIN='99999',PICOUT='ZZZZ9'
         DFHMDF POS=(02,70),LENGTH=02,INITIAL='of'
MAUD02   DFHMDF POS=(02,74),LENGTH=05,ATTRB=(NORM,PROT),               *
               PICOUT='ZZZZ9'
*
MAUA03   DFHMDF POS=(03,01),LENGTH=159,OCCURS=58
*
         DFHMDF POS=(61,01),LENGTH=40,                                 *
               INITIAL='PF1 : Help          PF2 : HEX/Char      '
         DFHMDF POS=(61,40),LENGTH=40,                                 *
               INITIAL='PF3 : Quit          PF4 :               '
         DFHMDF POS=(61,81),LENGTH=40,                                 *
               INITIAL='PF5 : RFind         PF6 :               '
         DFHMDF POS=(62,01),LENGTH=40,                                 *
               INITIAL='PF7 : Back          PF8 : Forward       '
         DFHMDF POS=(62,40),LENGTH=40,                                 *
               INITIAL='PF9 :               PF10: Left          '
         DFHMDF POS=(62,81),LENGTH=40,                                 *
               INITIAL='PF11: Right         PF12: Quit          '
*
         DFHMSD TYPE=FINAL
         END
/*
//LINKMAP.SYSLMOD DD DSN=K.S.V1R5M0.KIKRPL(KEBRM),
//       DISP=SHR
//COBMAP.SYSPRINT DD DSN=K.S.V1R5M0.COBCOPY(KEBRM),
//       DISP=SHR
//GCCMAP.SYSPRINT DD DSN=K.S.V1R5M0.GCCCOPY(KEBRM),
//       DISP=SHR
//
