

BRODSCAN -

    This program analyzes the TSO broadcast dataset.  It
    displays the number of available blocks and how they
    are used.  It also displays the TSO users who have
    messages waiting.  In addition it also does a validity
    check on records which are in the message pool to assure
    they are chained off of a user record.  According to
    documentation, instances occur which can result in these
    garbage records existing.


SAMPLE EXECUTION JCL can be found in CBT.MVS38J.CNTL(BRODSCN#)

SAMPLE EXECUTION OUTPUT

 TOTAL AVAILABLE BLOCKS IN DATASET                              795
 BLOCKS NECESSARY FOR BROADCST MSGS (DIRECTORY/MESSAGES)        104

 < THE FOLLOWING KEY BREAKDOWN WAS FOUND >
          HEADER RECORDS                                          1
          BROADCAST MSG DIRECTORY RECORDS                         4
          BROADCAST MESSAGE RECORDS                             100
          USERID INDEX RECORDS                                   64
          NON-BROADCAST MESSAGE RECORDS                         133
          FREE RECORDS                                          493

 < THE FOLLOWING USERS HAVE MESSAGES WAITING >
     A7T           21          C1F            1          C1G         1
     C1Q            1          C23            1          C28         1
     C3I            2          C37            2          C4K        10
     C4X            1          C45            1          C47         1
     C5D            1          C5M            1          C52         1
     C77            1          C79            1          D40         5
     HAE            1          HAR            1          HA7         1
     HA9            3          HCE            2          HCH         3
     HCN            3          HC2            1          HC8         1
     HD3            9          HEB            1          HE9         1
     HZE            1          HZI            3          HZM         2
     HZN            1          HZP            1          HZV         1
     HZ0            1          HZ4            1          KP1         1
     K14            5          MS8            1          SCM         8
     SFF           22          SFO            5          SFW         1
     SWW           10          SW2            5          SW7         1

 NUMBER OF TSO USERS DEFINED IN DATASET                         571

 BLOCKS FOUND TO BE GARBAGED                                      0
