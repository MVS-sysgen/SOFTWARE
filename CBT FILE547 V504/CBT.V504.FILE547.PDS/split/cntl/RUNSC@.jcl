---------------- BSPRUNSC - Autopilot runscript module ----------------
*********************************************************************** 00213
*                                                                     * 00290
*  This program will read input data from a member of a PDS with      * 00251
*  DDNAME SCRIPTS.  If no SCRIPTS DDNAME is found, SYS1.PARMLIB       * 00253
*  will be used                                                       * 00253
*                                                                     * 00253
*  The member to be used is specified via the PARM passed to the      * 00253
*  program.  If none if specified, a default of BSPRUNSC is used      * 00254
*                                                                     * 00254
*  Syntax of script files:                                            * 00258
*  Leading spaces will be removed from the script line                * 00254
*                                                                     * 00254
*  An asteriks (*) in col 1 means a comment, this line gets ignored   * 00258
*  PARM TEST       - don't exec, just simulate (default),             *
*  PARM CHECK      - same as PARM TEST                                *
*  PARM ECHO       - show commands on console (default)               *
*  PARM NOECHO     - no longer echo commands to console               *
*  PARM EXEC       - Execute the script, ask operator first           *
*  PARM NOREPLYU   - Execute the script, don't ask operator permission*
*  PARM REPLYU     - Next time, ask operator permission again         *
*  WAIT xxx        - Wait specified number of seconds before going on * 00258
*                    Default is 10 seconds                            * 00258
*  COM  ccc        - Execute the command ccc                          * 00258
*  CMD  ccc        - Execute the command ccc, equivalent to COM       * 00258
*  MSG  ttt        - show the message with the text ttttt             * 00258
*  WTO  ttt        - equivalent to MSG                                * 00258
*  IF xxxxxxxx     - execute following command if xxxxxxxx is active  * 00290
*  ELSE            - otherwise execute the second branch              * 00290
*  ENDIF           - end of IF constructs.  IF may not be nested      * 00290
*                                                                     * 00266
*  JCL Execution Parameters are specified via the                     * 00266
*  PARM statement on the EXEC card:                                   * 00266
*                                                                     * 00266
*       PARM=xxxxxxxx - Member name of script to process              * 00266
*                                                                     * 00266
*  Required DD statement: none                                        * 00266
*                                                                     * 00266
*  Optional DD statements:                                            * 00266
*           SCRIPTS  -  Input dataset for control statements          * 00266
*                       Default: SYS1.PARMLIB                         * 00266
*                                                                     * 00290
*           SYSPRINT -  (When running as a batch job)                 * 00266
*                       Default: SYSOUT=A                             * 00266
*                                                                     * 00290
*           SYSUDUMP -  Default: SYSOUT=A                             * 00266
*                                                                     * 00290
*           SNAPDUMP -  (When compiled with &DEBUG=YES)               * 00266
*                       Default: SYSOUT=A                             * 00266
*                                                                     * 00290
*           JCLPDS   -  (When compiled with &DEBUG=YES)               * 00266
*                       Default: SYS1.PARMLIB                         * 00266
*                                                                     * 00290
***********************************************************************
