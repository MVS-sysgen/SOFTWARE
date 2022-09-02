***********************************************************************
*                                                                     *
* Name: SYS1.PARMLIB(SHUTFAST)                                        *
*                                                                     *
* Desc: Sample Shutdown member                                        *
*                                                                     *
***********************************************************************
PARM NOREPLYU
PARM NOECHO
MSG Sending first warning message
COM SE ',,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,'
COM SE '; Please logoff, the system will terminate in 2 minutes ;'
COM SE '"""""""""""""""""""""""""""""""""""""""""""""""""""""""""'
WAIT 60
MSG Sending second warning message
COM SE '***************************************************************'
COM SE '* You better finish now, the system will shutdown in 1 minute *'
COM SE '***************************************************************'
WAIT 60
MSG Shutdown beginning
COM P TSO
WAIT 10
COM z net,quick
COM P MF1
COM P CMD1
COM I SMF
COM $P PRT1
COM $P PRT2
COM $P PRT3
COM $P PUNCH1
COM $P RDR1
WAIT 5
COM $P
