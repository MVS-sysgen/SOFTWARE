# EZASMI - TCP/IP for MVS 3.8 Assembler Introduction

This installs the EZASMI socket API to sysgen.

TCP/IP for MVS 3.8 Assembler is built upon the original EZASOKET interface developed by Jason Winter. It has been extended to provide additional functionality, improved error detection, and compatibility with the EZASMI macros. It ships as a load module, EZASOH03 included in this package, which must be linked with your TCP/IP application.


Version 1.0.0 by Shelby Lynne Beach and Jürgen Winkelmann

## Install

This package is designed for use with MVP. If you're not using MVP you need to install `SOFTWARE/MACLIB` and `SOFTWARE/SXMACLIB` prior to instalation.

## Samples

This library comes with two examples located in `SYSGEN.TCPIP.SAMPLIB` (or in the SAMPLIB folder). The files `COMPNCAT.jcl` and `CNSLOOKUP.jcl` (or `SYSGEN.TCPIP.SAMPLIB(COMPNCAT)`/`SYSGEN.TCPIP.SAMPLIB(CNSLOOKUP)` ) provides an example how to assemble and link programs that use the EZASMI macros.

## Documentation

The `docs` folder contains the EZASMI documentation

