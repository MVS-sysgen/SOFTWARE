//#001JCL JOB (TSO),
//             'Recieve XMI',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1)
//RECV370 EXEC PGM=RECV370
//STEPLIB  DD  DISP=SHR,DSN=SYSC.LINKLIB
//XMITIN   DD  DSN=MVP.WORK(IND$FILE),DISP=SHR
//RECVLOG  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  DUMMY
//* Work temp dataset
//SYSUT1   DD  DSN=&&SYSUT1,
//             UNIT=VIO,
//             SPACE=(CYL,(5,1)),
//             DISP=(NEW,DELETE,DELETE)
//* Output dataset
//SYSUT2   DD  DSN=SYS2.CMDLIB,
//             DISP=SHR