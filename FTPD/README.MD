# MVS 3.8J FTPD Server

This is the package version of the FTP server for MVS 3.8J. The source and full
documentation is available at https://github.com/MVS-sysgen/FTPD

Everyone in the RAKF group *ADMIN* has access to use FTP. To allow users
access to FTP add the user or group to the **FTPAUTH** resource in the FACILITY class
in `SYS1.SECURE.CNTL(PROFILES)`.

To start the FTPD server run the command `/s ftpd` in the hercules console. To stop the FTP
server run the command `/p ftpd` or `/stop ftpd` on the hercules console. To make changes to the configuration (ports, IP etc)
you can edit the config file `SYS1.PARMLIB(FTPDPM00)`.

# How to Make Release

1) Download a recently release of MVS/CE (or build your own)
2) Run this script `python3 make_release.py -x FTPD.xmi -t \#001JCL.jcl --mvsce path/to/MVSCE`
