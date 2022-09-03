#!/bin/bash

while IFS="|" read -r name title noneed link
do
   desc=$(lynx -dump $link | sed '/Installation/Q'|tail -n +3|sed 's/^ */ /g')
   Title=$(echo "${title^}")
   if [ ! -f "staging/${name,,}.jcl" ]; then
      echo "!!!!! staging/${name,,}.jcl does not exist skipping"
      continue
   fi

echo "Making : MVP/$name.desc"
cat << END > MVP/$name.desc
Package: $name
Version: 1.0
Maintainer: Jay Moseley <dino@jaymoseley.com>
Depends: 
Homepage: $link
Description: $Title
$desc
END

# Remove the 2 if you really want to rebuild everything but its a PITA
echo "Making : MVP/$name.jcl"
cat << END > MVP2/$name.jcl
//$name  JOB (TSO),
//             'Install $name',
//             CLASS=A,
//             MSGCLASS=A,
//             MSGLEVEL=(1,1),
//             USER=IBMUSER,
//             PASSWORD=SYS1
//*
END

tail -n +2 staging/${name,,}.jcl >> MVP2/$name.jcl

done < formatted.txt