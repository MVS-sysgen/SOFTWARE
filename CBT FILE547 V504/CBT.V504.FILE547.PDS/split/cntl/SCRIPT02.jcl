***********************************************************************
*                                                                     *
* Name: SYS1.PARMLIB(SCRIPT02)                                        *
*                                                                     *
* Desc: Sample Script member                                          *
*                                                                     *
***********************************************************************
PARM ECHO
PARM REPLYU
CMD S CLEARDMP,DD=00
WAIT 5
CMD S CLEARDMP,DD=01
WAIT 5
CMD S CLEARDMP,DD=02
WAIT 5
