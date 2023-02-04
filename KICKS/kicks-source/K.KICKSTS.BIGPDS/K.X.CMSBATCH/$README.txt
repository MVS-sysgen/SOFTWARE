$README  this file, describing members in the CMSBATCH pds
ADOALL   jcl to submit most all the following to CMSBATCH
ASYS     jcl to submit CMSBATCH job to build vmarc of H files
ATABALL  jcl to submit CMSBATCH job to assemble tables (FCT, PCT, ...)
BOOL     jcl to submit CMSBATCH job to add mecaff bool.h to ASYS vmarc
CLEANUP  jcl to submit CMSBATCH job to delete 'unnecesary file' after
         build is complete. Not usually run.
COMPRESS jcl to submit CMSBATCH job to compress maclibs and txtlibs
CRLP     jcl to submit CMSBATCH job to compile CRLPPGM
FB2VB    jcl to submit CMSBATCH job to compile FB2VB
KASM     CMSBATCH fragment to make KASM EXEC on CMSBATCH A disk
KEBR     jcl to submit CMSBATCH job to compile KEBR, meaning
         KEBRM mapset, KEBRPGM program, and KEBRHELP help text
KEDF     jcl to submit CMSBATCH job to compile KEDF, meaning
         KEDMAP mapset, KEDFPGM program, and KEDFILTR table
KEDFLINK CMSBATCH fragment to make KEDFLINK EXEC on CMSBATCH A disk
KEDFSUBS jcl to submit CMSBATCH job to compile subroutines
         used by KEDFPGM
KEDFXEQ  jcl to submit CMSBATCH job to compile KFDFXEQ
KFDEFLT  jcl to submit CMSBATCH job to compile KFDEFLT
KGCCCSL  CMSBATCH fragment to make KGCCCSL EXEC on CMSBATCH A disk
KGCCE    CMSBATCH fragment to make KGCCE EXEC on CMSBATCH A disk
KGCCEG   CMSBATCH fragment to make KGCCEG EXEC on CMSBATCH A disk
KGCCEL   CMSBATCH fragment to make KGCCEL EXEC on CMSBATCH A disk
KGCCGET  CMSBATCH fragment to make KGCCGET EXEC on CMSBATCH A disk
KIKACP   jcl to submit CMSBATCH job to compile KIKACP
KIKASRB  jcl to submit CMSBATCH job to compile KIKASRB
KIKBMS1$ jcl to submit CMSBATCH job to compile KIKBMS1$
KIKCOBGL jcl to submit CMSBATCH job to compile KIKCOBGL
KIKCRLP  jcl to submit CMSBATCH job to compile KIKCRLP
KIKDCP0$ jcl to submit CMSBATCH job to compile KIKDCP0$
KIKDCP1$ jcl to submit CMSBATCH job to compile KIKDCP1$
KIKENTRY jcl to submit CMSBATCH job to compile KIKENTRY
KIKFCP0$ jcl to submit CMSBATCH job to compile KIKFCP0$
KIKFCP1$ jcl to submit CMSBATCH job to compile KIKFCP1$
KIKFCP2$ jcl to submit CMSBATCH job to compile KIKFCP2$
KIKGCCGL jcl to submit CMSBATCH job to compile KIKGCCGL
KIKKCP1$ jcl to submit CMSBATCH job to compile KIKKCP1$
KIKLOAD  jcl to submit CMSBATCH job to compile KIKLOAD
KIKMACLB jcl to submit CMSBATCH job to compile KIKMACLB, which is
         the 'copy' support for the COBOL & GCC preprocessors
KIKMG    jcl to submit CMSBATCH job to compile KIKMG
KIKPCP1$ jcl to submit CMSBATCH job to compile KIKPCP1$
KIKPPCOB jcl to submit CMSBATCH job to compile KIKPPCOB
KIKPPGCC jcl to submit CMSBATCH job to compile KIKPPGCC
KIKSAMPL jcl to submit CMSBATCH job to compile all the sample
         maps & programs (MUR & TAC)
KIKSCP1$ jcl to submit CMSBATCH job to compile KIKSCP1$
KIKSIP1$ jcl to submit CMSBATCH job to compile KIKSIP1$
KIKTCP0$ jcl to submit CMSBATCH job to compile KIKTCP0$
         (source KIKTCP0$)
KIKTCP1$ jcl to submit CMSBATCH job to compile KIKTCP1$
         (source CMSTCP1$)
KIKTCP2$ jcl to submit CMSBATCH job to compile KIKTCP2$
         (source CMSTCP2$)
KIKTCP3$ jcl to submit CMSBATCH job to compile KIKTCP3$
         (source CMSTCP3$)
KIKTESTS jcl to submit CMSBATCH job to run KICKS tests
         (cobol tests, gcc tests, vsam file tests)
KIKTSP0$ jcl to submit CMSBATCH job to compile KIKTSP0$
KIKTSP1$ jcl to submit CMSBATCH job to compile KIKTSP1$
KLOGIT   jcl to submit CMSBATCH job to compile KLOGIT
KSDBLOAD jcl to submit CMSBATCH job to compile KSDBLOAD
KSGM     jcl to submit CMSBATCH job to compile KSGMAP,
         KSGMPGM, KSGMAPL, KSGMLIC, and KSGMHLP
KSMT     jcl to submit CMSBATCH job to compile KSMTPGM
KSMTSUBS jcl to submit CMSBATCH job to compile subroutines
         used by KSMT (and by LASTCC)
KSSF     jcl to submit CMSBATCH job to compile KSSFPGM
         (and K999PGM)
KUNLKED  jcl to submit CMSBATCH job to compile KUNLKED
LASTCC   jcl to submit CMSBATCH job to compile LASTCC
LOADMUR  jcl to submit CMSBATCH job to del/define MUR example
         vsam files
LOADSYS  jcl to submit CMSBATCH job to del/define systems
         vsam files (KIKINTRA, KIKTEMP, KSDB)
LOADTAC  jcl to submit CMSBATCH job to del/define TAC example
         vsam files
LSTLINES jcl to submit CMSBATCH job to compile LSTLINES
MAPN     CMSBATCH fragment to make MAPN EXEC on CMSBATCH A disk
         ** important **
         this defines the CMS userid and minidisk address
         to be used for all the CMSBATCH submissions
         ** important **
NEWLIBS  jcl to submit CMSBATCH job to create new MACLIBS
         and TXTLIBS. The new maclibs are primed with appropriate
         members copied from TSO
SHOWLIBS jcl to submit CMSBATCH job to print MACLIBs and TXTLIBs
STKCARDS jcl to submit CMSBATCH job to compile STKCARDS
SVC99    jcl to submit CMSBATCH job to compile SAS svc 99 routine
SYNCXIT  jcl to submit CMSBATCH job to compile SYNCXIT
VCONSTB5 jcl to submit CMSBATCH job to compile VCONSTB5
