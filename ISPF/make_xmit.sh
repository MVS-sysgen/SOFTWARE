#
# Reads and appends RFE ISPF Panels and #001JCL to UNLOAD_AND_XMIT.jcl
# How to use: 
# 1) Mount the ISPF tape with the following command in herculse: devinit 100 /path/to/ISPF.V2R2M0.aws
# 2) Start the punchcard writer on the hercules console: /$s punch1
# 3) submit the output from this script
# 4) Wait for "$HASP190 ISPFXMIT SETUP -- PUNCH1"
# 5) Start the punchcard writer on the hercules console (yes, again): /$s punch1
# 6) Wait for "HASP250 ISPFXMIT IS PURGED"
# 7) Trim the punchcard output with these lines of python (or run fix_xmi.py)
# ```python
# with open("punchcards/pch00d.txt", 'rb') as punchfile:
#   punchfile.seek(160)
#   no_headers = punchfile.read()
#   no_footers = no_headers[:-80]
# with open("ISPF.XMIT", 'wb') as review_out:
#   review_out.write(no_footers)
# ```

cat UNLOAD_AND_XMIT.jcl
echo ''
cat << 'EOF'
//*
//* ADD RFE PANELS TO MVP.STAGING.RFEPLIB
//* AND XMIT TO MVP.STAGING(RFEPLIB)
//*
//RFEPLIB   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=MVP.STAGING.RFEPLIB,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
EOF

for i in RFEPLIB/*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done

echo '@@'
cat << 'EOF'
//RFEPLIBX EXEC XMIT,DSN=RFEPLIB
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

