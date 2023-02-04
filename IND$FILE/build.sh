#
# Reads and appends #001JCL to UNLOAD_AND_XMIT.jcl
# How to use: 
# 1) Mount the IND$FILE tape with the following command in hercules: devinit 100 /path/to/IND$FILE.HET
# 2) Start the punchcard writer on the hercules console: /$s punch1
# 3) submit the output from this script
# 4) Wait for "$HASP190 IND$XMIT SETUP -- PUNCH1"
# 5) Start the punchcard writer on the hercules console (yes, again): /$s punch1
# 6) Wait for "HASP250 IND$XMIT IS PURGED"
# 7) Trim the punchcard output with these lines of python (or run fix_xmi.py)
# ```python
# with open("punchcards/pch00d.txt", 'rb') as punchfile:
#   punchfile.seek(160)
#   no_headers = punchfile.read()
#   no_footers = no_headers[:-80]
# with open("ISPF.XMIT", 'wb') as review_out:
#   review_out.write(no_footers)
# ```

cat << 'EOF'
//IND$XMIT JOB (TSO),
//             'Unload/XMIT',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,PASSWORD=SYS1
//*
//* This JCL deletes the staging dataset
//* Then creates MVP.STAGING and MVP.STAGING.IND$FILE
//* Then creates those datasets
//* Then unloads the tape to MVP.STAGING.IND$FILE
//* Then uses XMIT to put MVP.STAGING.IND$FILE to MVP.STAGING(IND$FILE)
//* Then places #001JCL.jcl in MVP.STAGING(#001JCL)
//* Then uses XMIT to place MVP.STAGING to syspunch
//*
//CLEANUP EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE MVP.STAGING SCRATCH PURGE
  DELETE MVP.STAGING.IND$FILE SCRATCH PURGE
  SET MAXCC=0
  SET LASTCC=0
//*
//* Add MVP.STAGING
//*     MVP.STAGING.IND$FILE
//*
//SYS2EXEC EXEC PGM=IEFBR14
//STAGING  DD DSN=MVP.STAGING,DISP=(,CATLG,DELETE),
//            UNIT=SYSDA,VOL=SER=PUB001,SPACE=(TRK,(50,50,10)),
//            DCB=(RECFM=FB,LRECL=80,BLKSIZE=800)
//LLIB     DD DSN=MVP.STAGING.IND$FILE,DISP=(,CATLG),
//         VOL=SER=PUB001,UNIT=SYSDA,SPACE=(CYL,(2,0,20),RLSE)
//*
//* Unload the IND$FILE tape file to MVP.STAGING.IND$FILE
//*
//IND$COPY EXEC PGM=IEBCOPY
//SYSPRINT DD  SYSOUT=*
//SYSUT3   DD  UNIT=SYSDA,SPACE=(TRK,(1,1))
//SYSUT4   DD  UNIT=SYSDA,SPACE=(TRK,(1,1))
//TAPE     DD  DSN=IND$FILE.LOAD,
//             UNIT=TAPE,
//             LABEL=(1,SL,,,EXPDT=98000),
//             VOL=(,RETAIN,,,SER=INDFIL),
//             DISP=(OLD,PASS)
//DISK     DD  DSN=MVP.STAGING.IND$FILE,DISP=SHR
//SYSIN    DD  *
 COPY INDD=((TAPE,R)),OUTDD=DISK
//*
//* Now we create IND$FILE XMIT in MVP.STAGING(IND$FILE)
//*
//XMITLLIB EXEC PGM=XMIT370
//STEPLIB  DD DSN=SYSC.LINKLIB,DISP=SHR
//XMITLOG  DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//SYSUT1   DD DSN=MVP.STAGING.IND$FILE,DISP=SHR
//SYSUT2   DD DSN=&&SYSUT2,UNIT=SYSDA,
//         SPACE=(TRK,(255,255)),
//         DISP=(NEW,DELETE,DELETE)
//XMITOUT  DD DSN=MVP.STAGING(IND$FILE),DISP=SHR
EOF

cat << 'EOF'
//*
//* Add #001JCL to MVP.STAGING
//*
//ADD01JCL EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=MVP.STAGING,DISP=SHR
//SYSUT1   DD  DATA,DLM='><'
./ ADD NAME=#001JCL
EOF

cat '#001JCL.jcl'

echo ''

echo '><'

cat << 'EOF'
//*
//* Outputs the resulting XMI file to SYSPUNCH
//*
//XMITLLIB EXEC PGM=XMIT370
//STEPLIB  DD DSN=SYSC.LINKLIB,DISP=SHR
//XMITLOG  DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSIN    DD DUMMY
//SYSUT1   DD DSN=MVP.STAGING,DISP=SHR
//SYSUT2   DD DSN=&&SYSUT2,UNIT=SYSDA,
//         SPACE=(TRK,(255,255)),
//         DISP=(NEW,DELETE,DELETE)
//XMITOUT  DD SYSOUT=B