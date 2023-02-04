$README  this file, describing members in the ROOT.C pds
CMSTCP1$ CMS terminal control for 'modern' VM's with CONSOLE macro
CMSTCP2$ CMS terminal control for vm370 with mecaff
CMSTCP3$ CMS terminal control for vm370 x'58' wo/mecaff
CRLPPGM  KICKS application to control CRLP terminal
KIKACP   ACP is abnormal condition program; does trans dumps
         and abend code remapping
KIKBMS1$ BMS is terminal basic mapping support
KIKCOBGL 'glue' routine(s) for Cobol HANDLE AID, HANDLE
         CONDITION processing. link to KEDF as necessary
KIKCRLP  routine used by terminal control programs to handle
         input and output for the CRLP terminal
KIKDCP0$ DCP is destination control program, does TD reads
         and writes, also SPOOLxxx api  0$ is dummy...
KIKDCP1$ DCP is destination control program, does TD reads
         and writes, also SPOOLxxx api  1$ is normal.
KIKKCP1$ DCP is task control program, primary use is creating
         and terminating tasks. also enq/deq, assign, address,
         asktime, formattime, syncpoint, signoff, delay, ...
KIKLOAD  KICKS loader, called by SIP & PCP to load programs
         and tables into storage, delete them, etc.
KIKPCP1$ PCP is program control program. does load, release, link,
         xctl, return, abend, dump
KIKSCP1$ SCP is storage control program, does getmain, freemain
KIKSIP1$ SIP is system initialization program, does startup,
         then runs the 'main loop' reading the terminal and calling
         KCP to attach tasks, tracking maxcc, and finally
         cleaning up and shutting down
KIKTCP0$ dummy terminal control used by both TSO and CMS
KIKTCP1$ TSO terminal control for 'modern' TSO with TPUT NOEDIT
KIKTCP2$ TSO terminal control for older TSO with just TPUT FULSCR
KIKTSP0$ TSP is temporary storage program, does TS reads and writes,
         0$ is dummy
KIKTSP1$ TSP is temporary storage program, does TS reads and writes,
         1$ is normal
SVC99    SAS svc 99 routines for dynamic allocation
SVC99C   test program for SAS svc 99 dynamic allocation
