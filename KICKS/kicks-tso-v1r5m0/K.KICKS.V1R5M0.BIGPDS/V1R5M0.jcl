//RCVKICK2 JOB CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=4096K
//*
//* UPDATE THE HLQ IN THE FOLLOWING CARD BEFORE RUNNING <<<<<<<<<<
//RECV    PROC UID=HERC01,MEM=DUMMY,MEM2=DUMMY,TRK=30,MLQ=KICKS
//RECV370 EXEC PGM=RECV370
//RECVLOG  DD  SYSOUT=*
//XMITIN   DD  DSN=&UID..KICKS.V1R5M0.BIGPDS(&MEM),DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  DSN=&&SYSUT1,
//             UNIT=SYSALLDA,
//             SPACE=(TRK,(300,60)),
//             DISP=(NEW,DELETE,DELETE)
//* ADD SPECIFIC VOLUME BELOW IF YOU CARE               <<<<<<<<<<
//SYSUT2   DD  DSN=&UID..&MLQ..V1R5M0.&MEM2,
//             UNIT=SYSALLDA,
//             SPACE=(TRK,(&TRK,&TRK,100)),
//             DISP=(NEW,CATLG,DELETE)
//SYSIN    DD  DUMMY
// PEND
//*
//HCB2     EXEC RECV,MEM=HCB2,MEM2=CB2,TRK=150
//HCOB     EXEC RECV,MEM=HCOB,MEM2=COB,TRK=150
//HCOBCOPY EXEC RECV,MEM=HCOBCOPY,MEM2=COBCOPY,TRK=150
//HGCC     EXEC RECV,MEM=HGCC,MEM2=GCC,TRK=150
//HGCCCOPY EXEC RECV,MEM=HGCCCOPY,MEM2=GCCCOPY,TRK=150
//HINSTLIB EXEC RECV,MEM=HINSTLIB,MEM2=INSTLIB,TRK=30
//HKIKRPL  EXEC RECV,MEM=HKIKRPL,MEM2=KIKRPL,TRK=150
//HMAPSRC  EXEC RECV,MEM=HMAPSRC,MEM2=MAPSRC,TRK=45
//HOPIDS   EXEC RECV,MEM=HOPIDS,MEM2=OPIDS,TRK=15
//HSPUFI   EXEC RECV,MEM=HSPUFI,MEM2='SPUFI.IN',TRK=15
//*
//SCMDPROC EXEC RECV,MLQ=KICKSSYS,MEM=SCMDPROC,MEM2=CLIST,TRK=15
//SCOB     EXEC RECV,MLQ=KICKSSYS,MEM=SCOB,MEM2=COB,TRK=45
//SCOBCOPY EXEC RECV,MLQ=KICKSSYS,MEM=SCOBCOPY,MEM2=COBCOPY,TRK=60
//SDOC     EXEC RECV,MLQ=KICKSSYS,MEM=SDOC,MEM2=DOC,TRK=15
//SGCC     EXEC RECV,MLQ=KICKSSYS,MEM=SGCC,MEM2=GCC,TRK=15
//SGCCCOPY EXEC RECV,MLQ=KICKSSYS,MEM=SGCCCOPY,MEM2=GCCCOPY,TRK=60
//SINSTLIB EXEC RECV,MLQ=KICKSSYS,MEM=SINSTLIB,MEM2=INSTLIB,TRK=30
//SKIKRPL  EXEC RECV,MLQ=KICKSSYS,MEM=SKIKRPL,MEM2=KIKRPL,TRK=150
//SMACLIB  EXEC RECV,MLQ=KICKSSYS,MEM=SMACLIB,MEM2=MACLIB,TRK=15
//SMAPSRC  EXEC RECV,MLQ=KICKSSYS,MEM=SMAPSRC,MEM2=MAPSRC,TRK=45
//SPROCLIB EXEC RECV,MLQ=KICKSSYS,MEM=SPROCLIB,MEM2=PROCLIB
//SPROCLIZ EXEC RECV,MLQ=KICKSSYS,MEM=SPROCLIZ,MEM2=PROCLIBZ
//SSKIKLOD EXEC RECV,MLQ=KICKSSYS,MEM=SSKIKLOD,MEM2=SKIKLOAD,TRK=150
//STESTCOB EXEC RECV,MLQ=KICKSSYS,MEM=STESTCOB,MEM2=TESTCOB,TRK=30
//STESTGCC EXEC RECV,MLQ=KICKSSYS,MEM=STESTGCC,MEM2=TESTGCC,TRK=30
//STESTFIL EXEC RECV,MLQ=KICKSSYS,MEM=STESTFIL,MEM2=TESTFILE,TRK=45
//