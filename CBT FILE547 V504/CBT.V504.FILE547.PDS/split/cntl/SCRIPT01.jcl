***********************************************************************
*                                                                     *
* Name: SYS1.PARMLIB(SCRIPT01)                                        *
*                                                                     *
* Desc: Sample Script member                                          *
*                                                                     *
***********************************************************************
PARM ECHO
PARM REPLYU
IF MF1
   COM P MF1
ENDIF
WAIT 5
CMD I SMF
WAIT 60
CMD I SMF
