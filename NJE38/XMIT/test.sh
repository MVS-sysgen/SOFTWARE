for i in NJESYS NJESPOOL NJEINIT NJEFMT NJESCN NJESYS NJETRN NJERCV;do
    echo $i
    filename=$i
    echo "./ ADD NAME=${filename%.*}"
    cat ../N38.ASMSRC/$i.*
done
