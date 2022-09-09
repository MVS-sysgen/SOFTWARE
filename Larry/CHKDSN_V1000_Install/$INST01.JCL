//$INST01  JOB (SYS),'Load HET CHKDSN',          <-- Review and Modify
//             CLASS=A,MSGCLASS=A,               <-- Review and Modify
//             MSGLEVEL=(1,1)                    <-- Review and Modify
//* -------------------------------------------------------*
//* *  CHKDSN in MVS38J / Hercules                         *
//* *                                                      *
//* *  JOB: $INST01                                        *
//* *       Load CNTL data set from distribution tape      *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY                                           
//SYSPRINT DD  SYSOUT=*                                              
//SYSUT1   DD  DSN=CHKDSN.V1R0M00.TAPE,DISP=OLD,
//             VOL=SER=VS1000,LABEL=(1,SL),                  
//             UNIT=480                          <-- Review and Modify   
//SYSUT2   DD  DSN=HERC01.CHKDSN.CNTL,
//             DISP=(,CATLG),DCB=(RECFM=FB,LRECL=80,BLKSIZE=19040),
//             SPACE=(TRK,(100,10,10)), 
//             UNIT=3350,VOL=SER=PUB000          <-- Review and Modify   
//SYSIN    DD  DUMMY                                                    
/*                                                                  
//
