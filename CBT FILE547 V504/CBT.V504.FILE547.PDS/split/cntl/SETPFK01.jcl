***********************************************************************
*                                                                     *
* Name: SYS1.PARMLIB(SETPFK01)                                        *
*                                                                     *
* Desc: Set console function keys on request                          *
*                                                                     *
***********************************************************************
01N K E,1
02N K E,D
03Y D U,,,_140,32
04Y F BSPPILOT,RUN=_
05Y V _xxx,offline;s dealloc
06Y M _xxx,vol=(SL,vvvvvv),use=uuuuuuuu;v _xxx,online
07Y V NET,INACT,ID=CUU0C_0,I;V NET,ACT,ID=CUU0C_0
08N K D,F
09N D TS,L
10N D A,L
11N K S,DEL=RD,SEG=19,RTME=001,RNUM=19,CON=N;K A,10
12N K A,NONE
