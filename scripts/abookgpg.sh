#!/bin/sh
ABOOK_ORIG=$HOME/.abook/addressbook
ABOOK=$HOME/.abook/addressbook.bak
cp $ABOOK_ORIG $ABOOK
MAX_NUM=$(sed -n 's/.*\[\([0-9]\+\)\].*/\1/p' $ABOOK | tail -n1)
gpg --list-keys \
        | sed -n "/^uid/s/.*] \(.*\) <\(.*@.*\..*\)>/\2\t\1/p" \
        | sort \
        | uniq -u -s 1 \
        | while read mail name; do
                if ! grep -q "$name" "$ABOOK"; then
                        MAX_NUM=$(( $MAX_NUM + 1 ))
                        echo >> $ABOOK
                        echo "[$MAX_NUM]" >> $ABOOK
                        echo "name=$name" >> $ABOOK
                        echo "email=$mail" >> $ABOOK
                elif ! grep -q "$mail" "$ABOOK"; then
                        sed -i "/$name/,+1s/email=.*/&,$mail/" $ABOOK
                fi
        done
diff --color=always $ABOOK_ORIG $ABOOK | less
read -p "Enter YES to apply changes > " response
if [ "$response" == "YES" ]; then
        mv $ABOOK $ABOOK_ORIG
        echo "Copied"
else
        echo "Abort"
fi
