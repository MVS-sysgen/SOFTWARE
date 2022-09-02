***********************************************************************
*                                                                     *
* Name: SYS1.PARMLIB(SCRIPT00)                                        *
*                                                                     *
* Desc: Sample Script member                                          *
*                                                                     *
***********************************************************************
PARM ECHO
PARM REPLYU
IF MF1
   CONTINUE
ELSE
   COM S MF1
ENDIF
PARM NOECHO
WAIT 5
IF MF1
   CONTINUE
ELSE
   MSG MF/1 could not be started, check system log for errors
ENDIF
