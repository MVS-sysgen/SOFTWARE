# This script packages generates the JCL necessary to deploy RECEIVE
# and TRANSMIT *only* 
#

cat << 'END'
//NJE38  JOB (TSO),
//             'Install NJE38',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
/*JOBPARM   LINES=1000
//*
//* This JCL does 4 things:
//* 1) Creates SYSGEN.NJE38.MACLIB and adds the NJE38 maclibs to it
//* 2) Creates SYSGEN.NJE38.ASMSRC and adds the needed source files
//* 3) Assembles the required and adds them to SYS2.CMDLIB
//* 4) Updates and adds TRANSMIT/RECEIVE to SYS1.UMODSRC(IKJEFTE2)
//*
//* *******************************************************************
//*
//*  Installs SYSGEN.NJE38.MACLIB
//*
//NJE38MAC EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.NJE38.MACLIB,DISP=(NEW,CATLG),
//             VOL=SER=PUB001,
//             UNIT=3390,SPACE=(CYL,(1,1,5)),
//             DCB=(BLKSIZE=3120,RECFM=FB,LRECL=80)
//SYSUT1   DD  DATA,DLM=@@
END

for i in ../N38.MACLIB/*;do
    filename=$(basename -- "$i")
    echo "./ ADD NAME=${filename%.*}"
    cat $i
done
echo "@@"

cat << 'END'
//*
//*  Installs SYSGEN.NJE38.ASMSRC
//*
//ASMSRC   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.NJE38.ASMSRC,DISP=(NEW,CATLG),
//             VOL=SER=PUB001,
//             UNIT=3390,SPACE=(CYL,(2,1,10)),
//             DCB=(BLKSIZE=6160,LRECL=80,RECFM=FB)
//SYSUT1   DD  DATA,DLM=@@
END

for i in NJESYS NJESPOOL NJEINIT NJEFMT NJESCN NJESYS NJETRN NJERCV;do
    filename=$i
    echo "./ ADD NAME=${filename%.*}"
    cat ../N38.ASMSRC/$i.txt
done
echo "@@"

cat << 'ENDJCL'
//*
//* These steps will assemble all components of NJE38 and link it
//* into SYSGEN.NJE38.AUTHLIB
//*
//* All steps should receive COND CODE 0
//*
//ASSEM    PROC R=RENT,M=
//ASSEMBLE EXEC  PGM=IFOX00,REGION=4096K,
// PARM=('XREF(FULL),OBJ,SYSPARM((ON,GEN,NODATA,YES,YES))',
//       'NODECK,&R')
//SYSLIB   DD    DSN=SYSGEN.NJE38.MACLIB,DISP=SHR,DCB=BLKSIZE=32720
//         DD    DSN=SYS1.SMPMTS,DISP=SHR
//         DD    DSN=SYS1.SMPSTS,DISP=SHR
//         DD    DSN=SYS1.MACLIB,DISP=SHR
//         DD    DSN=SYS1.AMODGEN,DISP=SHR
//SYSUT1   DD    DSN=&&SYSUT1,UNIT=SYSDA,SPACE=(1700,(5600,500))
//SYSUT2   DD    DSN=&&SYSUT2,UNIT=SYSDA,SPACE=(1700,(1300,500))
//SYSUT3   DD    DSN=&&SYSUT3,UNIT=SYSDA,SPACE=(1700,(1300,500))
//SYSPRINT DD SYSOUT=*
//SYSPUNCH DD SYSOUT=B
//SYSGO    DD DSN=&&NJE38OBJ(&M),DISP=(MOD,PASS),
//            SPACE=(800,(2000,1000,10)),UNIT=SYSDA
//SYSIN    DD DSN=SYSGEN.NJE38.ASMSRC(&M),DISP=SHR
// PEND
//* ***********************************
//*        EXEC ASSEM,M=NJEINIT,R=RENT
//*        EXEC ASSEM,M=NJECMX,R=RENT
//*        EXEC ASSEM,M=NJEDRV,R=RENT
//*        EXEC ASSEM,M=NJEFMT,R=RENT
//         EXEC ASSEM,M=NJERCV,R=RENT
//*        EXEC ASSEM,M=NJERLY,R=RENT
//*        EXEC ASSEM,M=NJESCN,R=RENT
//         EXEC ASSEM,M=NJESPOOL,R=RENT
//         EXEC ASSEM,M=NJESYS,R=RENT
//         EXEC ASSEM,M=NJETRN,R=RENT
//*        EXEC ASSEM,M=NJE38,R=RENT
//*        EXEC ASSEM,M=NJ38RECV,R=RENT
//*        EXEC ASSEM,M=NJ38XMIT,R=RENT
//*        EXEC ASSEM,M=DMTXJE,R=NORENT
//*        EXEC ASSEM,M=DMTMSG,R=RENT
//* ***********************************
//*
//LKCMDLIB EXEC PGM=IEWL,PARM='XREF,LET,LIST,NCAL,RENT',COND=(4,LT)
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  DSN=&&SYSUT1,UNIT=SYSDA,SPACE=(1024,(50,20))
//SYSLMOD  DD  DSN=SYS2.CMDLIB,DISP=SHR
//NJEOBJ   DD  DSN=&&NJE38OBJ,DISP=(OLD,PASS)
//SYSLIN   DD *
        ORDER NJERCV(P)
        INCLUDE NJEOBJ(NJERCV)
        INCLUDE NJEOBJ(NJESYS)
        INCLUDE NJEOBJ(NJESPOOL)
        ENTRY NJERCV
        SETCODE AC(1)
        ALIAS RECV
   NAME RECEIVE(R)
        ORDER NJETRN(P)
        INCLUDE NJEOBJ(NJETRN)
        INCLUDE NJEOBJ(NJESYS)
        INCLUDE NJEOBJ(NJESPOOL)
        ENTRY NJETRN
        SETCODE AC(1)
        ALIAS XMIT
   NAME TRANSMIT(R)
//*
//* Edit SYS1.UMODSRC(IKJEFTE2) Adding NJE38 programs
//* that need auth
//*
//EDITUMOD EXEC PGM=IKJEFT01,REGION=1024K,DYNAMNBR=50
//SYSPRINT DD  SYSOUT=*
//SYSTSPRT DD  SYSOUT=*
//SYSTERM  DD  SYSOUT=*
//SYSTSIN  DD  *
 EDIT 'SYS1.UMODSRC(IKJEFTE2)' DATA 
 LIST
 TOP
 FIND /TERMINATOR/
 UP
 INSERT          DC    C'RECEIVE '             NJE38 RECEIVE
 INSERT          DC    C'RECV    '             NJE38 RECEIVE Alias
 INSERT          DC    C'TRANSMIT'             NJE38 TRANSMIT
 INSERT          DC    C'XMIT    '             NJE38 TRANSMIT Alias
 LIST
 END SAVE
/*
//*
//* Add Help files
//* 
//HELP     EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS2.HELP,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=TRANSMIT
NJE38 - TSO TRANSMIT

   Command line format:

   TRANSMIT node.userid
            DATASET( )
            OUTDATASET( )
            VOLSER( )
            UNIT( )
            PDS | SEQUENTIAL
            QUIET

   where:

    node.userid    - optional. specifies the destination of the 
                     transmission

    DATASET( )     - specifies the dsname of the dataset to be
                     transmitted.  May optionally specify a member.

    OUTDATASET( )  - required. Specifies the encoded file is to be
                     written to this dataset instead of being
                     transmitted.  'node.userid' may be omitted if
                     OUTDATASET is specified, but if it is present
                     then the specified node and userid will be part
                     of the encoded data instead of meaningless
                     defaults. If OUTDATASET is specified, the
                     named dataset will be used if it exists, other-
                     wise it will be created.
                     The contents of OUTDATASET can be input to a
                     RECEIVE command by the use of RECEIVE INDATASET.

    VOLSER( )      - optional. Specifies a volume where OUTDATASET
                     should be created.  If not specified, a PUBLIC
                     volume will be selected.

    UNIT( )        - optional. Specifies a unit name where OUTDATASET
                     should be created.  If not specified, SYSDA is
                     the default unit name.

    PDS            - If specified, indicates that the member name
                     specified with DATASET is to be transmitted
                     with IEBCOPY unload, thereby preserving the
                     user directory data in the source PDS.

    SEQUENTIAL     - DEFAULT. Indicates that any member name specified
                     with DATASET is to be transmitted as a sequential
                     file; no directory information is part of the
                     transmission. SEQL must be specified or defaulted
                     if the destination host is a VM system.

    QUIET          - If specified, indicates that all informational
                     messages from TRANSMIT are suppressed.  Error
                     messages will always be displayed.


    Examples (a user is logged on to TSO with userid FRED:

    1. Send member COBSRC from FRED.MY.PDS to user HERC01 at
       node MVSA.  The directory information associated with COBSRC
       is to be part of the transmission:

       TRANSMIT mvsa.herc01 da(my.pds(cobsrc)) pds

    2. Encode dataset HERC02.COBOL.LISTING into FRED.NETLIB:

       TRANSMIT da('herc02.cobol.listing') out(netlib)

    3. Send macro GETQ from FRED.MACLIB to CMSUSER at VMSYS1.

       TRANSMIT vmsys1.cmsuser da(maclib(getq))
./ ADD NAME=RECEIVE
NJE38 - TSO RECEIVE

   Command line format (all parameters are optional):

   RECEIVE  DATASET( )
            VOLSER( )
            UNIT( )
            DIR( )
            INDATASET( )
            PURGE  | NOPURGE
            PROMPT | NOPROMPT
            QUIET

   where:

    DATASET( )     - specifies the dsname of the dataset to be
                     created; the received data will be placed within.
                     If not specified, the dataset name will be
                     derived from the incoming dataset name, with
                     the first qualifer being replaced by the
                     receiver's TSO userid.

    VOLSER( )      - specifies a volume where DATASET should be
                     created.  If not specified, a PUBLIC volume will
                     be chosen based on the receiving dataset's
                     attributes.

    UNIT( )        - specifies a unit name where DATASET should be
                     created.  If not specified, SYSDA is the default
                     unit name.

    DIR( )         - specifies a number of directory blocks if
                     incoming file was a PDSE.

    INDATASET( )  -  optional. Specifies that the encoded named
                     dataset is to be received.  The encoded dataset
                     was previously created by TRANSMIT using
                     OUTDATASET.  May optionally specify a membername.

    PURGE          - DEFAULT.  Indicates that RECEIVE is to purge
                     the spool file after successful retrieval. Has
                     no meaning if INDATASET is specified.

    NOPURGE        - Indicates that RECEIVE is to retain the spool
                     file.  The file can be received again or must be
                     removed from the spool by other means.  Has
                     no meaning if INDATASET is specified.

    PROMPT         - DEFAULT.  Indicates that RECEIVE is to prompt
                     the TSO user to respecify DATASET or VOLSER
                     after learning the incoming dataset name. The
                     user can then choose to change the name or
                     volume.

    NOPROMPT       - Indicates that no prompts are to be issued.  If
                     errors are encountered, such as the incoming
                     dataset name already existing, then RECEIVE is
                     terminated without any opportunity to change
                     the parameters.

    QUIET          - If specified, indicates that all informational
                     messages from  RECEIVE are suppressed.  Error
                     messages will always be displayed. QUIET also
                     forces on NOPROMPT.
@@
/*
//
ENDJCL
