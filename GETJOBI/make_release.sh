#!/bin/bash
cd $(dirname $0)
cat << END
//GETJOBI JOB (TSO),
//             'Install GETJOBI',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,PASSWORD=SYS1
//* From:
//* https://ibmmainframes.com/viewtopic.php?p=167434&highlight=#167434
//*
//* Requires MACLIB and SXMACLIB
//*
//* STEP 1: Compile/Link LISTCDS to SYS2.LINKLIB(GETJOBI)
//*
//ASSEM        EXEC ASMFCL,MAC='SYS1.MACLIB',MAC1='SYS2.MACLIB',
//             MAC2='SYS2.SXMACLIB',PARM.LKED='(XREF,LET,LIST,CAL)'
//ASM.SYSIN    DD DATA,DLM='@@'
END

cat GETJOBI.hlasm

cat << 'END'
@@
//LKED.SYSLMOD DD DISP=SHR,DSN=SYS2.LINKLIB(GETJOBI)
//LKED.SYSLIB   DD  DSN=SYS2.LINKLIB,DISP=SHR
//*
//* STEP 2: Install Help
//*
//STEP1   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS2.HELP,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
./ ADD NAME=GETJOBI
)F FUNCTION -
    < G E T J O B I >  (GET JOB INFORMATION)

    THIS SUB-PROGRAM IS CALLED TO OBTAIN THE JOB-NAME, PROCSTEP
    NAME, STEP-NAME AND JOB-NUMBER (IN THIS ORDER). NOTE THE   
    REQUIRED 128-BYTE WORKAREA (FOR REENTRANCY PURPOSES).      
                                                        
    EXAMPLE SYNTAX:                                            
                                                        
        03  WS-GETJOBI-PARM-REC.                                   
            05  WS-GETJOBI-JOB-NAME                                
                                  PIC  X(08).                      
            05  WS-GETJOBI-PROCSTEP-NAME                           
                                  PIC  X(08).                      
            05  WS-GETJOBI-STEP-NAME                               
                                  PIC  X(08).                      
            05  WS-GETJOBI-JOB-NBR                                 
                                  PIC  X(08).                      
            05  WS-GETJOBI-WORKAREA                                
                                  PIC  X(128).                     

        CALL WS-GETJOBI               USING WS-GETJOBI-PARM-REC    
        END-CALL                                                   
                                                        
)X SYNTAX   - NONE
)O OPERANDS - NONE                             
@@
//*
//* TEST GETJOBI
//*
//*
//TEST     EXEC COBUCLG,                                                    
//         PARM.COB='FLAGW,LOAD,SUPMAP,SIZE=2048K,BUF=1024K,LIST',
//         PARM.GO='TEST123456789TEST'
//COB.SYSPUNCH DD DUMMY                                                     
//COB.SYSIN    DD *                                                         
END

cat TEST.cbl

cat << 'END'
/*                                                                          
//COB.SYSLIB DD DSNAME=SYSC.COBLIB,DISP=SHR
//LKED.SYSLIB DD DSNAME=SYSC.COBLIB,DISP=SHR
//            DD DSNAME=SYS2.LINKLIB,DISP=SHR
//GO.SYSOUT  DD SYSOUT=*,DCB=(RECFM=FBA,LRECL=161,BLKSIZE=16100)           
//
END


