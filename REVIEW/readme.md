# REVIEW Front End (RFE) Install

This python script builds the REVIEW install package for MVP

untar MVSCE, copy `make_release.py` to the MVSCE folder, and run `make_release.py` from that folder

The file `REVIEW.XMIT` will be produced which contains:

- `#001JCL` A jcl file which unloads and copy the files in the other files
- `CLIST` xmit of `revclist.xmi`
- `HELP` xmit of `revhelp.xmi`
- `LOAD` xmit of `rev370ld.xmi`

