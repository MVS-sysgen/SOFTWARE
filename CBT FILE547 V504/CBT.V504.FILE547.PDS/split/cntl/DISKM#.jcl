//HERC01  JOB  (MVS),
//             'RUN DISKMAP',
//             CLASS=A,
//             MSGCLASS=X,
//             MSGLEVEL=(1,1),
//             NOTIFY=HERC01
//********************************************************************
//*
//* Name: CBT.MVS38J.CNTL(DISKM#)
//*
//* Desc: Run the DISKMAP programs
//*
//********************************************************************
//*   This step will only map the volume MVSRES
//DISKMAP EXEC PGM=DISKMAP,PARM=(MAP,EXT)
//SYSPRINT DD SYSOUT=*
//MVSRES   DD DISP=OLD,UNIT=3350,VOL=SER=MVSRES
//*   This step will map all online volumes
//DISKMPA EXEC PGM=DISKMAPA,PARM=(MAP)
//SYSPRINT DD SYSOUT=*
