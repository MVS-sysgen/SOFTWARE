//BATCH1  JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=2000K
//*
//GO     EXEC PGM=KIKSIP1$,TIME=1,PARM='SIT=1$'
//* kiksip1$ comes from steplib...
//STEPLIB  DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//* tables come from skikload...
//SKIKLOAD DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//* programs & maps come from kikrpl...
//KIKRPL   DD DSN=K.U.V1R5M0.KIKRPL,DISP=SHR,
//         DCB=BLKSIZE=32000
//         DD DSN=K.S.V1R5M0.KIKRPL,DISP=SHR
//*
//SYSPRINT DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=80)
//SYSTERM  DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=80)
//SYSOUT   DD SYSOUT=*,DCB=BLKSIZE=132
//CRLPOUT  DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=132)
//TRANDUMP DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=132)
//SYSUDUMP DD SYSOUT=*
//*
//AUXTRC   DD SYSOUT=*,DCB=(RECFM=F,BLKSIZE=120)
//*
//SYSIN    DD DUMMY,DCB=(RECFM=F,BLKSIZE=80)
//*
//TACDATA  DD DSN=K.U.TACDATA,DISP=SHR
//*
//CRLPIN   DD *,DCB=BLKSIZE=80
<clear>            get blank screen to enter next transaction
crlp<REMARK>       the CRLP transaction can be used to set
    <REMARK>       or change the sequential terminal name or options
    <REMARK>       TERMID=xxxx - change name from default CRLP to ?
    <REMARK>       TRIM/NOTRIM - trailing spaces trimmed off (or not)
    <REMARK>       BORDER/NOBORDER - box around screen (or not)
    <REMARK>       ** note that TRIM & BORDER are mutually exclusive
    <REMARK>       ECHO/NOECHO - crlpin echoed to crlpout (or not)
    <REMARK>       TIOA/NOTIOA - generated TIOA displayed (or not)
    <REMARK>       SHOWI/NOSHOWI - input screen displayed (or not)
border<enter>      show current options
<clear>            get blank screen to enter next transaction
BTC0<ENTER>        show the main menu
<PF1>              show the auto refund menu
<PF1>              show the add request screen
10<REM>            YEAR, NO <TAB> 'CAUSE AUTOSKIPPED ALREADY
memyself<erase>    NAME, NO SPACES, AUTOSKIP (except last!)
<TAB>              <tab> can't go on same line <erase> above...
14725 INNER WAY<ERASE>
<TAB>
SITKA<ERASE>
<TAB>
AK<REM>            ST,  NO <ERASE> OR <TAB> 'CAUSE FIELD FILLED
99835<REM>         ZIP, NO <ERASE> OR <TAB> 'CAUSE FIELD FILLED
516384991<REM>     SSN, NO <ERASE> OR <TAB> 'CAUSE FIELD FILLED
43210<ERASE>       GROSS
<TAB>
1NOT<ERASE>        CONTRIB - not numeric, force error
<ENTER>            try to do the add, get error msg
<CLEAR>            back up to auto refund menu
<CLEAR>            back up to main menu
<CLEAR>            back up to 'data entry concluded'
<clear>            get blank screen to enter next transaction
KSSF<ENTER>        LOGOFF - would happen anyway at following /*
/*
//
