//SYNCXIT JOB CLASS=C,MSGCLASS=A,MSGLEVEL=(1,1),REGION=2000K
//*
//JOBPROC DD   DSN=K.S.V1R5M0.PROCLIB,DISP=SHR
//*
//SYNCXIT EXEC PROC=K2KCOBCL       KIKCB2CL for z/os
//COPY.SYSUT1 DD *
       ID DIVISION.
       PROGRAM-ID. SYNCXIT.

      *///////////////////////////////////////////////////////////////
      * KICKS is an enhancement for TSO that lets you run your CICS
      * applications directly in TSO instead of having to 'install'
      * those apps in CICS.
      * You don't even need CICS itself installed on your machine!
      *
      * KICKS for TSO
      * © Copyright 2008-2014, Michael Noel, All Rights Reserved.
      *
      * Usage of 'KICKS for TSO' is in all cases subject to license.
      * See http://www.kicksfortso.com
      * for most current information regarding licensing options.
      *//1/////////2/////////3/////////4/////////5/////////6/////////7

      * SYNCXIT is a sample SYNCPOINT exit, and is an ordinary command
      * level program,  *** BUT ***
      * Please don't use the syncpoint api within it, or link/xctl to
      * any other program that does! The result would not be pretty...

       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       77  WS-BEGIN  PIC X(24)  VALUE 'SYNCXIT  WORKING STORAGE'.
       77  WS-MSG    PIC X(16)  VALUE 'SPX-UNKNOWN ENTR'.

       LINKAGE SECTION.
       01  KIKCOMMAREA.
           05  FLAG  PIC S9(8) COMP.
               88  TASK-START  VALUE -1.
               88  SP-COMMIT   VALUE +0.
               88  SP-ROLLBACK VALUE +1.
               88  TASK-END    VALUE +2.
               88  TASK-ABEND  VALUE +3.

       PROCEDURE DIVISION.

           IF EIBCALEN NOT = 4 THEN GO TO DO-MSG.

           IF TASK-START
            MOVE 'SPX-TASK START' TO WS-MSG.
           IF SP-COMMIT
            PERFORM DO-COMMIT
            MOVE 'SPX-COMMIT' TO WS-MSG.
           IF SP-ROLLBACK
            PERFORM DO-ROLLBACK
            MOVE 'SPX-ROLLBACK' TO WS-MSG.
           IF TASK-END
            PERFORM DO-COMMIT
            MOVE 'SPX-TASK END' TO WS-MSG.
           IF TASK-ABEND
            PERFORM DO-ROLLBACK
            MOVE 'SPX-TASK ABEND' TO WS-MSG.

       DO-MSG.

      * note that only first 12 bytes of msg will appear in the internal
      * trace, but all 16 will be in aux trace (if it's turned on).
      * ALSO - assuming you link this with KIKCOBGX as recommended, the
      * internal traces will be suppressed unless you turn on 'intense'.
           EXEC KICKS
              ENTER TRACEID(1) FROM(WS-MSG) FROMLENGTH(16)
           END-EXEC.

      * KLOGIT should have not problem with a 16 byte msg...
           EXEC KICKS
              LINK PROGRAM('KLOGIT') COMMAREA(WS-MSG) LENGTH(16)
           END-EXEC.

           EXEC KICKS RETURN END-EXEC.

       DO-COMMIT SECTION.
      * does nothing in this sample program...
           MOVE TALLY TO TALLY.

       DO-ROLLBACK SECTION.
      * does nothing in this sample program...
           MOVE TALLY TO TALLY.


/*
//LKED.SYSLMOD DD DSN=K.S.V1R5M0.KIKRPL,DISP=SHR
//* recommend link with KIKCOBGX (not KIKCOBGL)
//* so that exit calls don't show up in KEDF...
//LKED.SYSIN DD *
 INCLUDE SKIKLOAD(KIKCOBGX)
 ENTRY SYNCXIT
 NAME  SYNCXIT(R)
/*
//
