***********************************************************************
*                                                                     *
* Name: SYS1.PARMLIB(SETPFK02)                                        *
*                                                                     *
* Desc: Set console function keys on request                          *
*                                                                     *
***********************************************************************
01N K E,1
02N K E,D
03N $DJ1-999,l=A
04Y $LJ_xxx,HOLD,L=A
05Y $T_PRT1,Q=AX
06Y M _xxx,vol=(SL,vvvvvv),use=uuuuuuuu;v _xxx,online
07Y V NET,INACT,ID=CUU0C_0,I;V NET,ACT,ID=CUU0C_0
08N K D,F
09N D TS,L
10N D A,L
11N K S,DEL=RD,SEG=19,RTME=001,RNUM=19,CON=N;K A,10
12N K A,NONE
