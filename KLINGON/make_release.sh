cd $(dirname $0)

cat << 'EOF'
//KLINGON JOB (JOB),'KL',CLASS=A,MSGCLASS=A,
//            REGION=1024K,USER=IBMUSER,PASSWORD=SYS1
//*
//* *******************************************************************
//*
//* CLEAN UP
//CLEANUP EXEC PGM=IDCAMS
//SYSIN    DD *
  DELETE SYSGEN.KLINGON.SOURCE SCRATCH PURGE
  DELETE SYSGEN.KLINGON.ASSETS SCRATCH PURGE
  SET MAXCC=0
  SET LASTCC=0
//SYSPRINT DD SYSOUT=*
//* Upload files
EOF

cat << 'EOF'
//SOURCE   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.KLINGON.SOURCE,DISP=(NEW,CATLG),
//             VOL=SER=PUB001,
//             UNIT=3390,SPACE=(CYL,(5,5,40))
//SYSUT1   DD  DATA,DLM=@@
EOF

for i in source/*; do
    m=${i%.*}
    member=${m##*/}
    echo "./ ADD NAME=$member"
    cat "$i"
done

echo '@@'

cat << 'EOF'
//ASSETS   EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYSGEN.KLINGON.ASSETS,DISP=(NEW,CATLG),
//             VOL=SER=PUB001,
//             UNIT=3390,SPACE=(CYL,(2,1,3))
//SYSUT1   DD  DATA,DLM=@@
EOF

echo "./ ADD NAME=#GRAFICS"
cat "#GRAFICS.txt"
echo "./ ADD NAME=#KLHELP"
cat "#KLHELP.txt"
echo "@@"


cat << 'EOF'
//CLIST    EXEC PGM=PDSLOAD
//STEPLIB  DD  DSN=SYSC.LINKLIB,DISP=SHR
//SYSPRINT DD  SYSOUT=*
//SYSUT2   DD  DSN=SYS1.CMDPROC,DISP=SHR
//SYSUT1   DD  DATA,DLM=@@
EOF

echo "./ ADD NAME=KLINGON"
cat KLINGON.clist
echo "@@"

cat klingon_compile.jcl

echo "//"