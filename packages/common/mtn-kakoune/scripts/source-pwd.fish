while true
    set kakrc (pwd)/.kakrc
    if test -f $kakrc
        echo source $kakrc
    end
    if test (pwd) = "/"
        exit 0
    end
    cd ..
end
