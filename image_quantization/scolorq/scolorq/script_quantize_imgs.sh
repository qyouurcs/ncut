#!/usr/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage: $0 <img_dir>"
    exit
fi

src_dir=$1
src_dir=`echo $src_dir | awk '{ sub(/\/$/, ""); print;}'`

fns=`ls $src_dir`
rgb_dir=${src_dir}_rgb
q_dir=${src_dir}_scolorq_rgb
q_dir_png=${src_dir}_scolorq_png
if [ ! -d $rgb_dir ]; then
    mkdir $rgb_dir
fi

if [ ! -d $q_dir ]; then
    mkdir $q_dir
fi

if [ ! -d $q_dir_png ]; then
    mkdir $q_dir_png
fi

for fn in $fns
do
    full_fn=$src_dir/$fn
    filename=`basename "$full_fn"`
    ext="${filename##*.}"
    fn_="${filename%.*}"

    size=`identify $full_fn`
    size=`echo $size | awk '{print $3}'`
    echo $size
    save_fn=$rgb_dir/${fn_}.rgb
    convert -depth 8 -size $size $full_fn $save_fn
    q_fn=$q_dir/${fn_}.rgb
    w=`echo $size | awk -Fx '{print $1}'`
    h=`echo $size | awk -Fx '{print $2}'`

    ./spatial_color_quant $save_fn $w $h 8 $q_fn
    q_fn_png=$q_dir_png/${fn_}.png
    convert -depth 8 -size $size $q_fn $q_fn_png
done

