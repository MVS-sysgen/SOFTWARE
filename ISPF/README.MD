# Wally ISPF for MVS 3.8J

This is the packaged version of Wally ISPF packaged for MVP with permission from Wally.

Steps to make this package:

1) Run `make_xmit.sh > output.jcl`
2) Mount the ISPF tape with the following command in herculse: `devinit 100 /path/to/ISPF.V2R2M0.aws`
3) Start the punchcard writer on the hercules console: `/$s punch1`
4) submit the output from this script
5) Wait for `$HASP190 ISPFXMIT SETUP -- PUNCH1`
6) Start the punchcard writer on the hercules console (yes, again): `/$s punch1`
7) Wait for `HASP250 ISPFXMIT IS PURGED`
8) Trim the punchcard output with these lines of python (or run `python3 fix_xmi.py /path/to/punchcard/pch00d.txt`)

```python
with open("punchcards/pch00d.txt", 'rb') as punchfile:
  punchfile.seek(160)
  no_headers = punchfile.read()
  no_footers = no_headers[:-80]
with open("ISPF.XMIT", 'wb') as review_out:
  review_out.write(no_footers)
```