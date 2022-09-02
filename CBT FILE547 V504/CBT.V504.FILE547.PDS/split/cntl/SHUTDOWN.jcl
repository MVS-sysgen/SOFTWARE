***********************************************************************
*                                                                     *
* Name: SYS1.PARMLIB(SHUTDOWN)                                        *
*                                                                     *
* Desc: Sample Shutdown member                                        *
*                                                                     *
***********************************************************************
PARM EXEC
PARM ECHO
COM SE 'Please logoff, the system will terminate in 5 minutes'
WAIT 180
COM SE 'You better finish now, the system will shutdown in 2 minutes'
WAIT 60
COM SE 'We mean it.  The system will terminate in 1 minute||'
WAIT 60
COM P TSO
WAIT 30
COM z net,quick
COM P MF1
COM P CMD1
COM $P PRT1
COM $P PRT2
COM $P PRT3
COM $P PUNCH1
COM $P RDR1
COM $P
