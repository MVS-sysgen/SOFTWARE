//MURMAPS JOB  CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1)
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//CMNTSET EXEC KIKMAPS,MAPNAME=CMNTSET
//COPY.SYSUT1 DD DISP=SHR,DSN=K.U.V1R5M0.MAPSRC(CMNTSET)
//*
//DB2SET1 EXEC KIKMAPS,MAPNAME=DB2SET1
//COPY.SYSUT1 DD DISP=SHR,DSN=K.U.V1R5M0.MAPSRC(DB2SET1)
//*
//INQSET1 EXEC KIKMAPS,MAPNAME=INQSET1
//COPY.SYSUT1 DD DISP=SHR,DSN=K.U.V1R5M0.MAPSRC(INQSET1)
//*
//INQSET2 EXEC KIKMAPS,MAPNAME=INQSET2
//COPY.SYSUT1 DD DISP=SHR,DSN=K.U.V1R5M0.MAPSRC(INQSET2)
//*
//INQSET3 EXEC KIKMAPS,MAPNAME=INQSET3
//COPY.SYSUT1 DD DISP=SHR,DSN=K.U.V1R5M0.MAPSRC(INQSET3)
//*
//MENSET1 EXEC KIKMAPS,MAPNAME=MENSET1
//COPY.SYSUT1 DD DISP=SHR,DSN=K.U.V1R5M0.MAPSRC(MENSET1)
//*
//MNTSET1 EXEC KIKMAPS,MAPNAME=MNTSET1
//COPY.SYSUT1 DD DISP=SHR,DSN=K.U.V1R5M0.MAPSRC(MNTSET1)
//*
//MNTSET2 EXEC KIKMAPS,MAPNAME=MNTSET2
//COPY.SYSUT1 DD DISP=SHR,DSN=K.U.V1R5M0.MAPSRC(MNTSET2)
//*
//ORDSET1 EXEC KIKMAPS,MAPNAME=ORDSET1
//COPY.SYSUT1 DD DISP=SHR,DSN=K.U.V1R5M0.MAPSRC(ORDSET1)
//*
//SUMSET1 EXEC KIKMAPS,MAPNAME=SUMSET1
//COPY.SYSUT1 DD DISP=SHR,DSN=K.U.V1R5M0.MAPSRC(SUMSET1)
//