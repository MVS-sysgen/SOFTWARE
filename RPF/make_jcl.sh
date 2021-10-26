#!/bin/bash
cd $(dirname $0)
function echoc {
    echo "[+] $1"
}

function check_return {

    echo >&2 "$(tput bold)$(tput setaf 1)
    *************************
    *** ERROR DOWNLOADING ***
    *************************
    "
    echo "[!] Error encoutered exiting.$(tput sgr0)" >&2
    exit 1
}

cd $(dirname $0)

rm *.xmi
mkdir -p zip

echoc "Checking for new RPF release"

rpf_internet=$(curl -s http://www.prince-webdesign.nl/index.php/software/rpf-english-version|grep downloads|grep zip|grep rpf|awk -F'"' '{print $2}'|awk -F"/" '{print $4}')

for x in $rpf_internet; do
    if [[ ${x: -6} == @('os.zip'|'as.zip'|'s1.zip'|'87.zip') ]]; then
        # Skip zos, source and maclib
        true
    else
        echoc "Version: ${x:3:3}"
        if [[ ! -f "$x" ]]; then
            #echoc "$x exists skipping"
        #else
            #echoc "Checking $x"
            current_file=$(ls zip|grep ${x: -6})
            if [[ ! -z $current_file ]]; then
                 echoc "Current Version $current_file"
                 echoc "Updated version $x"
                if [ ${x:3:3} -gt ${current_file:3:3} ]; then
                    echoc "New version found"
                    echoc "Updating $current_file to $x"
                    cd zip; curl -O http://www.prince-webdesign.nl/images/downloads/$x ;
                    if [ $? -gt 0 ]; then
                        check_return
                    fi
                    rm $current_file
                    cd ..
                fi
            else
                echoc "rpf${x: -9} does not exist downloading"
                cd zip; curl -O http://www.prince-webdesign.nl/images/downloads/$x ; cd ..
                if [ $? -gt 0 ]; then
                    check_return
                fi
            fi
        fi
    fi
done

for i in zip/*.zip; do
    echoc "Extracting $i"
    unzip -o $i
done

# Get version
version=$(ls zip/*mv.zip)
v=${version:7:1}
r=${version:8:1}
m=${version:9:1}

mv *he.xmi HELP.xmi
mv *jc.xmi JCL.xmi
mv *mv.xmi LOAD.xmi
echoc "Version: V${v}R${r}M${m}"

for f in templates/*.template.jcl; do
    jcl=$(basename $f .template)
    echoc "Generating #001JCL.jcl"
    sed "s/##CHANGEME##/V${v}R${r}M${m}/g" $f > "#001JCL.jcl"
done

echoc "Done"
