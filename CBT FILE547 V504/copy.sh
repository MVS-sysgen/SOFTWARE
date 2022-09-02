for i in *.desc; do 
    x=${i%.*}; 
    echo "copying $x.desc to ~/DEV/MVP/desc/$x";
    cp -v $x.desc ~/DEV/MVP/desc/$x
    echo "copying $x.jcl to ~/DEV/MVP/packages/$x";
    cp -v $x.jcl ~/DEV/MVP/packages/$x
    v=$(grep 'Version' $x.desc|awk '{print $2}')
    if ! grep -q "$x JCL $v" ~/DEV/MVP/cache; then
        echo "$x JCL $v does not exist!!"
        echo "Adding '$x JCL $v' to ~/DEV/MVP/cache"
        echo "$x JCL $v" >> ~/DEV/MVP/cache
    fi
done
