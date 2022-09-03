for i in MVP/*.desc; do 
    x=${i%.*}; 
    b=$(basename $x)
    echo "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  $b  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="
    echo "copying $x.desc to ~/DEV/MVP/desc/$b";
    cp -v $x.desc ~/DEV/MVP/desc/$b
    echo "copying $x.jcl to ~/DEV/MVP/packages/$b";
    cp -v $x.jcl ~/DEV/MVP/packages/$b
    v=$(grep '^Version' $x.desc|awk '{print $2}')
    if ! grep -q "^$b JCL $v" ~/DEV/MVP/cache; then
        echo "$b JCL $v does not exist!!"
        echo "Adding '$b JCL $v' to ~/DEV/MVP/cache"
        echo "$b JCL $v" >> ~/DEV/MVP/cache
    fi
done