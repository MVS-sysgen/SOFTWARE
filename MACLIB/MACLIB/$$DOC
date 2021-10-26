SYS2.MACLIB
===========

ORIGINAL MACLIB PART OF TK4- UPDATE 9
TK4- UPDATE BY JUERGEN WINKELMANN WINKELMANN@ID.ETHZ.CH
OFFLOADED BY PHILIP YOUNG

LICENSE:
========

FROM MVS_TK4-_V1.00_USERS_MANUAL.PDF

THE MVS 3.8J TUR(N)KEY 4- DISTRIBUTION ITSELF IS PUT INTO THE PUBLIC
DOMAIN WITHOUT CLAIMING ANY COPYRIGHT BY THE AUTHOR AS FAR AS NO THIRD
PARTY COPYRIGHTS ARE AFFECTED.

JCL USED TO OFFLOAD:
====================

```JCL
//OFFLOAD2 JOB (001),'OFFLOAD PDS',CLASS=A,MSGCLASS=H
//OFFLOAD EXEC PGM=OFFLOAD,REGION=256K
//SYSPRINT DD SYSOUT=*
//PDS      DD DSN=SYS2.MACLIB,DISP=SHR
//SEQ      DD  DSN=SYS2.MACLIB.UNLOAD,
//             UNIT=SYSALLDA,VOL=SER=DEV01,
//             SPACE=(TRK,(44,14),RLSE),
//             DISP=(NEW,CATLG,DELETE)
//SYSIN    DD *
  O I=PDS,O=SEQ,T=IEBUPDTE
//
```

MACROS
======


$ATTR
-----

Generates 3270 attribute bytes

$EPILOG
======

Typical HLASM return routine

$ESC
===

3270 ESCape sequence

$GLOBALS
=======

Sets 3270 globals

$IC
==

Generates 3270 code for INSERT CURSOR order

$IO
==

Generate IO command for 3270 device

$MODEL
=====

Set model number for 3270 macros

$PROLOG
======

This macro will provide entry linkage and optionally multiple base
registers. Also via the `LV=` keyword provide additional user storage
(appended to the save area) addressable from register 13. If no
operands are coded register 12 is assumed from the base. Example:

```hlasm
SECTNAME $PROLOG          = STANDARD REG 12 BASE
SECTNAME $PROLOG 5        = STANDARD, REG 5 BASE
SECTNAME $PROLOG 10,LV=20 = ADD 20 BYTES TO SAVE AREA
                                      REG 10 IS BASE
SECTNAME $PROLOG R10,R11  = REGS 10 AND 11 ARE BASES
```

$RA
==

Generates 3270 Repeat Until Address order

$REGS
====

Equates R0-R15 and REG0-REG15


$SBA
===

Generates 3270 Set Buffer Address Order

$SF
==

Generates 3270 Start Field order (with attribute)

$STCK
====

this macro will provide the day, date, and time from  the time-of-day
clock in gregorian (english) format. if invoked without the optional
'nogen' keyword, the  constants named below will be generated.  if the
'nogen' keyword is used, the user must provide this   routine with
addressability to them as pre-defined constants.

```
DAY    DS   X      A BINARY NUMBER (HEX) RELATIVE TO
                   THE DAY OF THE WEEK AS FOLLOWS
                   0=MONDAY, 1=TUESDAY, 2=WEDNESDAY,
                   3=THURSDAY, 4=FRIDAY,
                   5=SATURDAY, 6=SUNDAY

DATE   DS   CL8    AN EIGHT CHARACTER FIELD CONTAINING
                   THE DATE IN MM/DD/YY FORMAT

TIME   DS   CL8    AN EIGHT CHARACTER FIELD CONTAINING
                   THE TIME IN HH:MM:SS FORMAT
```

note that the caller must provide a register save area that begins on a
doubleword boundary to be used as a work area by this routine
(r-13 based).

$TITLE
=====

Sets title?

$WCC
===

Generates 3270 write control character

@
=

MACRO to create block letters in assembly listing

BLANK
====

Fills an area with chars

BOX
==

Makes a box

BSPAUTH
======

Authorizes a program using SVC244

BSPBEG
=====

BSP header macro

BSPEND
=====

Typical HLASM return routine but BSP


BSPENTER
=======

Provide entry coding and house keeping for assembler modules

BSPGLBLS
=======

Declares globals &BSPAUTH, &BSPCSCT, &BSPMOD ,&BSPPRFX, &BSPPRGM,
&BSPVER, &BSPASVC

BSPPATCH
=======

To reserve 5% or 25 half words in a module for maintenance

BSPRET
=====

???????

BSPSGLBL
=======

Sets the globals listed in BSPGLBLS


DA
=

Data set allocation macro

DBGMSG
=====

Generate debug messages

DDTBRK
=====

?????

DIAG
===

??????

DO
=

Macro for structured programming

ELSE
===

Else: macro for structured programming

ELSEIF
=====

Elseif macro for structured programming

ENDDO
====

Enddo: close a do group in structured programming

ENDIF
====

Endif: macro  close current if level

ENTER
====

?????????

EXIT
===

Exit macro for structured programming

FC
=

Fortune Coookie macro

FILL
===

Fills an area with ' ' (space)

FINISH
=====

????????

ICATCHER
=======

May be used to generate CSECT Cards and standard format module
eye-catchers.  Both the CSECT and module eye-catchers are
optional.  See operand descriptions and examples below.

IEECODES
=======

????????

IEZBITS
======

Sets `BIT0`-`BIT7` with numerical value

IEZREGS
======

Equates R0-R15

IF
=

Starts a new if level for structured programming

IFERR
====

Error messages for structured programming-macros

IFGLO
====

GLOBALS FOR MACROS FOR STRUCTURED PROGRAMMING

IFPRO
====

PROCESSES CONDITION STATEMENTS IN STUCTURED PROGRAMMING

IHAIQE
=====

????????

IHAPIE
=====

A PIE IS CREATED AFTER A PROGRAM CHECK HAS OCCURRED IF THERE
IS A USER-SPECIFIED EXIT ROUTINE TO HANDLE PROGRAM CHECK
INTERRUPTIONS.  A PIE IS USED TO PASS THE NECESSARY DATA TO
THE USER-SPECIFIED EXIT ROUTINE.

MODULEID
=======

May be used to generate CSECT Cards and standard format module
eye-catchers.  Both the CSECT and module eye-catchers are
optional.

MSGPUT
=====

Puts message somewhere?

QTPUT
====

QUICK FORM OF TPUT TERMINAL INTERFACE ROUTINE

REGEQU
=====

Equates R0-R15

REGISTER
=======

Equates R0-R15

RRTEND
=====

????????

RRTENT
=====

????????

RRTTAB
=====

????????

SETMAXCC
=======

Sets max return code

STR$CLN
======

STRING Macro Instruction for Assembler XF with all the JCL from
STR$GSF removed

STR$GSF
======

STRING Macro Instruction for Assembler XF but with JCL and documenation


STRING
======

Alias of STR$CLN

SVC34
====

Use SVC34 to issue a command

SYSGET
=====

????????

SYSPRINT
=======

????????

SYSPUT
=====

????????

TESTENV
======

This program will try to determine the current runtime environment
by scanning MVS control blocks

X2CHRTAB
=======

????????

X2CHRTRN
=======

????????

YREGS
====

Equates R0-R15

