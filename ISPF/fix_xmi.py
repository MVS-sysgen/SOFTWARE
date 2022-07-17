import sys

if len(sys.argv) < 2:
    print("Usage: python fix_xmi.py /path/to/punchcards/pch00d.txt")
    sys.exit()

with open(sys.argv[1], 'rb') as punchfile:
  punchfile.seek(160)
  no_headers = punchfile.read()
  no_footers = no_headers[:-80]
with open("ISPF.XMIT", 'wb') as review_out:
  review_out.write(no_footers)