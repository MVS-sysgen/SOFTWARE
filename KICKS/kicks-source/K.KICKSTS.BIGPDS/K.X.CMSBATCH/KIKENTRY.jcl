//KIKENTRY JOB  CLASS=C,MSGCLASS=Z
// EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN DD DUMMY,DCB=BLKSIZE=80
//SYSUT2 DD UNIT=10D,DISP=OLD,DCB=BLKSIZE=80
//SYSUT1 DD DATA,DLM=$$,DCB=BLKSIZE=3120
ID CMSBATCH
/JOB CMSUSER 123456 KIKENTRY
$$
// DD DSN=K.X.CMSBATCH(MAPN),DISP=SHR
// DD DSN=K.X.CMSBATCH(KASM),DISP=SHR
// DD DATA,DLM=$$
MAPN
KBLOCK KIKENTRY
KASM KIKENTRY
*////////1/////////2/////////3/////////4/////////5/////////6/////////7
* This will be the first block of any object that will be processed
* by 'KUNLKED', which will fill in A(ENTRY) with the address of the
* 'real' entry point.
*
*      ** In case the dumb VM loader defaults to starting at zero **
*////////1/////////2/////////3/////////4/////////5/////////6/////////7
KIKENTRY START 0
         USING *,15
         L     15,ENTRY            0
         BR    15                  4
         DC    H'0'                6
ENTRY    DC    A(ENTRY)            8   entry point
         DC    CL8'KIKENTRY'       12  eyecatcher
         DC    X'00'
V        DC    CL6'v1r5m0'         21  version
         DC    X'0'
DC       DC    CL8'mm/dd/yy'       28  compile date
         DC    C' '
TC       DC    CL8'hh:mm:ss'       37  compile time
         DC    X'00'
CR       DC    C'KICKS for CMS '   46  copyright notice
 DC C'© Copyright 2008-2014, Michael Noel, All Rights Reserved.'
         DC    X'00'
         END
/*
*ype KIKENTRY listing
/*
$$
//
