#!/usr/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 <dst_dir>"
    exit
fi

for a in `ls $1`
do 
    mv $1/$a $1/o_${a}
done
