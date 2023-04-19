#!/bin/bash
echo -n "Do you want to continue?(Yes/No):"
read YN
if [ "$YN"  == "Y" -o "$YN"  == "Yes" -o "$YN"  == "y" -o "$YN"  == "yes" -o "$YN"  == "YES" ];then
    echo "continue"
elif [ "$YN"  == "N" -o "$YN"  == "No" -o "$YN"  == "n" -o "$YN"  == "no" -o "$YN"  == "NO" ];then
    echo "break"
    exit 0
else
   echo "rewrite please!!!"
fi
#
## case
#echo -n "Do you want to continue?(Yes/No):"
#read YN
#case "$YN" in
#[Yy]|[Yy][Ee][Ss])
#     echo "continue"
#;;
#*)
#  exit 0
#esac
