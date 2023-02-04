//PDSUPDT$ JOB CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1)
//*
//* ***************************************************************** *
//* ASSEMBLE PDSUPDTE                                                 *
//* ***************************************************************** *
//ASM     EXEC ASMFCL PARM='LIST,OBJECT,NODECK'
//SYSIN    DD  DSN=K.X.UTIL(PDSUPDT$),DISP=SHR
//LKED.SYSLMOD DD DSN=K.S.V1R5M0.SKIKLOAD,DISP=SHR
//SYSIN    DD  *
  NAME PDSUPDTE(R)
//
