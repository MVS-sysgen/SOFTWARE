//#001JCL JOB (TSO),
//             'Recieve XMI',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1)
//* Before adding this to a zip you need to convert it to EBCDIC
//* with dd if=\#001JCL.jcl of=\#001JCL conv=ebcdic,block cbs=80
//STEP01 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
 DELETE 'HTTPD.LINKLIB' PURGE
 DELETE 'HTTPD.HTML' PURGE
 DELETE 'HTTPD.ICON' PURGE
 DELETE 'HTTPD.LUA' PURGE
 DELETE 'HTTPD.BREXX' PURGE
 DELETE 'HTTPD.UFSDISK0' PURGE
 DELETE 'MVP.HTTPD' PURGE
 SET LASTCC=0
 SET MAXCC=0
/*
//* Receive the main HTTPD dataset
//UNPKHTTP EXEC PGM=RECV370,REGION=4096K
//STEPLIB  DD  DISP=SHR,DSN=SYSC.LINKLIB
//RECVLOG  DD SYSOUT=*
//XMITIN   DD DSN=MVP.WORK(HTTPD330),DISP=SHR
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DSN=&&SYSUT1,
//         UNIT=SYSDA,VOL=SER=PUB001,
//         SPACE=(TRK,(250,250)),
//         DISP=(NEW,DELETE,DELETE)
//SYSUT2   DD DSN=MVP.HTTPD,
//         UNIT=SYSDA,VOL=SER=PUB001,
//         SPACE=(TRK,(250,250,25),RLSE),
//         DISP=(NEW,CATLG,DELETE)
//SYSIN    DD DUMMY
//*
//* JCL to RECEIVE all the datasets
//* 
//STEP02 EXEC PGM=IKJEFT01,DYNAMNBR=64                
//SYSPRINT DD SYSOUT=*                                
//SYSTSPRT DD SYSOUT=*                                
//SYSTSIN  DD *                                       
 RECEIVE INDATASET('YOUR UPLOAD DATASET') -           
         DATASET('MVP.HTTPD') -                
         VOL(PUB001) NOPROMPT                         
 RECEIVE INDATASET('MVP.HTTPD(LINKLIB)') -     
         DATASET('HTTPD.LINKLIB') -                   
         VOL(PUB001) NOPROMPT                         
 RECEIVE INDATASET('MVP.HTTPD(HTML)') -        
         DATASET('HTTPD.HTML') -                      
         VOL(PUB001) NOPROMPT                         
 RECEIVE INDATASET('MVP.HTTPD(ICON)') -        
         DATASET('HTTPD.ICON') -                      
         VOL(PUB001) NOPROMPT                         
 RECEIVE INDATASET('MVP.HTTPD(LUA)') -         
         DATASET('HTTPD.LUA') -                       
         VOL(PUB001) NOPROMPT                         
 RECEIVE INDATASET('MVP.HTTPD(BREXX)') -       
         DATASET('HTTPD.BREXX') -                     
         VOL(PUB001) NOPROMPT                         
 RECEIVE INDATASET('MVP.HTTPD(UFSDISK0)') -    
         DATASET('HTTPD.UFSDISK0') -                  
         VOL(PUB001) NOPROMPT                         
 DELETE 'MVP.HTTPD' PURGE     
//* Install the proc
//*
//STEP1   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS2.PROCLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=HTTPD
//HTTPD    PROC                                                         00000100
//HTTPD    EXEC PGM=HTTPD,REGION=6144K,TIME=1440,                       00000206
//  PARM='CONFIG=HTTPD.LUA(HTTPD)'              
//* Replace your.lua.dataset(xxxxxxxx) with the 
//* dataset name of your configuration settings 
//* for HTTPD 3.1.0
//* You don't need a configuration dataset if the   
//* default values are acceptable for your site.    
//* See CONFIG30.html member for defaults.                 
//*                                                                     00003900
//STEPLIB  DD DISP=SHR,DSN=HTTPD.LINKLIB                                00004003
//HTTPDERR DD SYSOUT=*              STDERR                              00004100
//HTTPDOUT DD SYSOUT=*              STDOUT                              00004200
//HTTPDIN  DD DUMMY                 STDIN                               00004300
//SNAP     DD SYSOUT=*                                                  00004400
//HTTPDBG  DD SYSOUT=*                                                  00004500
//HTML     DD DISP=SHR,DSN=HTTPD.HTML                                   00004603
//ICO      DD DISP=SHR,DSN=HTTPD.ICON                                   00004703
//ICON     DD DISP=SHR,DSN=HTTPD.ICON                                   00004803
//*                                                                     00004900
//HTTPSTAT DD SYSOUT=*                                                  00005000
//*           DCB=(LRECL=132,BLKSIZE=136,RECFM=VB)                      00005100
//* THE FOLLOWING ARE THE JES2 CHECKPOINT AND SPOOL                     00005200
//HASPCKPT DD DISP=SHR,DSN=SYS1.HASPCKPT,UNIT=3350,VOL=SER=MVS000       00005302
//HASPACE1 DD DISP=SHR,DSN=SYS1.HASPACE,UNIT=3350,VOL=SER=SPOOL1        00005402
//*                                                                     00005500
//* THE FOLLOWING ARE THE UNIX "LIKE" FILE SYSTEM DISK                  00005600
//* NOTE: USE DISP=OLD FOR READ/WRITE ACCESS.                           00005700
//*       USE DISP=SHR FOR READONLY ACCESS.                             00005800
//UFSDISK0 DD DISP=OLD,DSN=HTTPD.UFSDISK0                               00005903
//*
//* BREXX CGI Datasets (new for HTTPD 3.1.0)
//* ===> You need to allocate your BREXX scripts PDS <===
//SYSEXEC  DD DSN=HTTPD.BREXX,DISP=SHR
//         DD DSN=BREXX.V2R5M3.SAMPLES,DISP=SHR
//RXLIB    DD DSN=BREXX.V2R5M3.RXLIB,DISP=SHR
//*                                           
@@