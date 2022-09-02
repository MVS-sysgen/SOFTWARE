  This program will search file PARMLIB for members with the name       00251
  SETPFKxx (where xx is the console ID), and will then modify the       00252
  PFK stoarage areas in memory with information found in those          00253
  members                                                               00254
                                                                        00258
  A member SETPFKxx, where xx is not a valid console id, will be        00258
  ignored.  A console with id yy, where there is no member SETPFKyy     00258
  will also be ignored.                                                 00258
                                                                        00258
  sample members are provided in CBT.MVS38J.CNTL(SETPFK01)              00258
                             and CBT.MVS38J.CNTL(SETPFK02)              00258
                                                                        00258
  These definitions are not permanent,  With other words, this          00255
  program should be run on every IPL, preferably via a start            00256
  command in SYS1.PARMLIB(COMMND00) or SYS1.PARMLIB(JES2PARM):          00257
  a)  copy BSPSETPF from 'CBT.MVS38J.PROCLIB' to SYS2.PROCLIB           00258
  b1) add the line COM='S BSPSETPF' to SYS1.PARMLIB(COMMND00)           00258
  or                                                                    00258
  b2) add the line $VS,'S BSPSETPF' to the end of SYS1.PARMLIB(JES2PARM)00258
                                                                        00258
  If the operator just changes on PFK definitions, BTW, all the         00259
  current active definitions will be permanently saved (I just          00260
  haven't found out where, yet)                                         00261
                                                                        00266
                                                                        00290
  JCL to assemble & Link this pgm: CBT.MVS38J.CNTL(SETPF$)              00290
  JCL to run this program:         CBT.MVS38J.CNTL(SETPF#)              00290
                                                                        00290
  JCL Execution Parameters are specified via the                        00266
  PARM statement on the EXEC card:                                      00266
                                                                        00266
       PARM=NOUPDATE:  (default) - PFKs will not be updated, the        00266
                       SETPFXxx members in PARMLIB will only be         00266
                       checked for correct syntax                       00266
       PARM=UPDATE:    The SETPFKxx members will be syntax-checked,     00266
                       and updaes to the in core PFK definition         00266
                       will be made after the operator has replied      00266
                       to message BSPSP80D                              00266
       PARM=NOREPLYU:  The SETPFKxx members will be syntax-checked,     00266
                       and updates to the in core PFK definition        00266
                       will be made.  There will be no confirmation     00266
                       request to the operator                          00266
                                                                        00266
                                                                        00266
  Required DD statement: none                                           00266
                                                                        00266
  Optional DD statements:                                               00266
           PARMLIB  -  PDS containing the SETPFKxx members to be        00266
                       processed. Default: SYS1.PARMLIB                 00266
                                                                        00266
           SYSPRINT -  Output queue for BSPSETPF messages.              00266
                       Default: SYSOUT=X                                00266
                                                                        00266
           SYSUDUMP -  Output queue for dumps (which, of course,        00266
                       will never happen). Default: SYSOUT=X            00266
                                                                        00266
 SYS1.PARMLIB(SETPFxx) record layout:                                   00267
 An asterisk (*) in colum 1 indicates a comment line, this line         00268
 will be ignored                                                        00268
                                                                        00268
  Colums            Description                                         00269
  01 - 02           PFK number                                          00271
  03                Processing flag: Y = Conversational, N nonconv.     00272
  04                ignored, should be empty                            00273
  05 - 71           (first part of) the command as the operator         00277
                    would issue it.  Multiple commands are separated    00278
                    by semicolon.  Prompt position is specified         00279
                    by an underscore                                    00279
  72                Continuation column.  If non-blank then the         00280
                    command extends to the next line of the member      00281
                    The continuation must begin exactly at col 05       00281
                    and must end on or before colum 45                  00282
                                                                        00268
 If a function key definition line is omitted, that PFK will not be     00290
 updated.  If a function key definition is provided with an empty       00290
 command area, that PFK will be deactivated                             00290
