import sys
skip = True
text = ''
dlm = False
with open(sys.argv[1], 'r') as f:
    for l in f.readlines():
        if 'DATA,DLM=@@' in l:
            dlm = True
            continue
        if l[0:2] == "//" and not dlm:
            continue
        if l[0:2] == "@@":
            continue
        if "./ ADD NAME=" in l:
            if skip:
                skip = False
                name = l.split()[2].split("=")[1]
                continue
            with open("tmp/"+name, 'w') as out:
                out.write(text)
            text = ''
            name = l.split()[2].split("=")[1]
            print(name)
            continue
        text += l

with open("tmp/"+name, 'w') as out:
    out.write(text)