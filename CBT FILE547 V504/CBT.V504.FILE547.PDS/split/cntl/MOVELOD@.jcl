*
*   MOVELOAD - Load IEHMOVE modules & link to IEHMOVE
*   MOVELOD - Load/Delete IEHMOVE modules
*
*     Entry:  As at entry to IEHMOVE
*
*     Exit:   As at exit from IEHMOVE
*
* When using IEHMOVE on small data sets, IEHMOVE can do as much
* I/O loading its modules as copying data.  This program
* pre-loads all RENT or REUS IEHMOVE modules to avoid the
* program load I/O.
*
* Since the normal IEHMOVE requires APF authorization to run,
* this module would have to be linked AC=1 to run it.
*
* ( Note that there are Zap's which allow IEHMOVE to run without
*   APF authorization for a major subset of functions.
*   There are also Zap's which allow VIO work files for IEHMOVE ).
*
