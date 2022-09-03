#!/bin/bash

while IFS="|" read -r name title noneed link
do
   echo "Record is : $name $link"
   d=$(lynx -dump $link |grep 'https://www.jaymoseley.com/hercules/downloads/archives'|awk '{print $2}')
   cd zip
   wget $d
   cd ..


done < formatted.txt