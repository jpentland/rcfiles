# ls command for git repo
function lsgit {

        for f in `ls $@ --color=always`; do
                for mf in `git ls-files --modified`; do
                        if echo $f | grep -F $mf > /dev/null; then
                                echo $f-M
                        else
                                echo $f
                        fi
                done
        done
}

