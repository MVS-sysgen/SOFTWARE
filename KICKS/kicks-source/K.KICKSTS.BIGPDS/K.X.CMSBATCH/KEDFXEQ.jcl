//KEDFXEQ  JOB  CLASS=C,MSGCLASS=Z
// EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSIN DD DUMMY,DCB=BLKSIZE=80
//SYSUT2 DD UNIT=10D,DISP=OLD,DCB=BLKSIZE=80
//SYSUT1 DD DATA,DLM=$$,DCB=BLKSIZE=3120
ID CMSBATCH
/JOB CMSUSER 123456 KEDFXEQ
$$
// DD DSN=K.X.CMSBATCH(MAPN),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCE),DISP=SHR
// DD DSN=K.X.CMSBATCH(KGCCGET),DISP=SHR
// DD DSN=K.X.CMSBATCH(KEDFLINK),DISP=SHR
// DD DATA,DLM=$$
MAPN
KBLOCK KEDFXEQ
KGCCGET
VMARC UNPACK ASYSH VMARC N = = A
KGCCE doapi
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOAPI),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE dobms
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOBMS),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE dobottom
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOBOTTOM),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE docomm
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOCOMM),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE docwa
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOCWA),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE dodcp
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DODCP),DISP=SHR
// DD DATA,DLM=$$
/*
erase * listing
erase * assemble
KGCCE dodump
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DODUMP),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE doeib
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOEIB),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE dofcp
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOFCP),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE dofilter
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOFILTER),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE dokcp
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOKCP),DISP=SHR
// DD DATA,DLM=$$
/*
erase * listing
erase * assemble
KGCCE domain
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOMAIN),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE dopcp
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOPCP),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE doscp
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOSCP),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE dotcp
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOTCP),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE dotctteua
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOTCTTEU),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE dotioa
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOTIOA),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE dotop
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOTOP),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE dotrace
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOTRACE),DISP=SHR
// DD DATA,DLM=$$
/*
erase * listing
erase * assemble
KGCCE dotsp
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOTSP),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE dotwa
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOTWA),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE dousr
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOUSR),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE dows
$$
// DD DSN=K.X.KEDFXEQ.PARTS(DOWS),DISP=SHR
// DD DATA,DLM=$$
/*
KGCCE getmapdsectsize
$$
// DD DSN=K.X.KEDFXEQ.PARTS(GETMAPDS),DISP=SHR
// DD DATA,DLM=$$
/*
erase * listing
erase * assemble
KGCCE kedfxeq
#define KEDFXEQFLAG
#include "kedfxeq.h"
$$
// DD DSN=K.X.ROOT.CPART(KIKACPTR),DISP=SHR
// DD DSN=K.X.ROOT.CPART(ENCODE32),DISP=SHR
// DD DSN=K.X.KEDFXEQ(KEDFXEQ),DISP=SHR
// DD DATA,DLM=$$
/*
KEDFLINK
ERASE DOAPI    TEXT *
ERASE DOBMS    TEXT *
ERASE DOBOTTOM TEXT *
ERASE DOCOMM   TEXT *
ERASE DOCWA    TEXT *
ERASE DODCP    TEXT *
ERASE DODUMP   TEXT *
ERASE DOEIB    TEXT *
ERASE DOFCP    TEXT *
ERASE DOFILTER TEXT *
ERASE DOKCP    TEXT *
ERASE DOMAIN   TEXT *
ERASE DOPCP    TEXT *
ERASE DOSCP    TEXT *
ERASE DOTIOA   TEXT *
ERASE DOTCP    TEXT *
ERASE DOTCTTEU TEXT *
ERASE DOTOP    TEXT *
ERASE DOTRACE  TEXT *
ERASE DOTSP    TEXT *
ERASE DOTWA    TEXT *
ERASE DOUSR    TEXT *
ERASE DOWS     TEXT *
ERASE GETMAPDS TEXT *
/*
$$
//