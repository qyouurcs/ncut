#!/usr/bin/python

import os
import sys
import shutil

if len(sys.argv) < 3:
    print 'Usage: {0} <fn.list> <dir> <save_dir>'.format(sys.argv[0])
    sys.exit()
save_dir = sys.argv[3]

if not os.path.isdir(save_dir):
    os.makedirs(save_dir)
dict_fn = {}
with open(sys.argv[1],'r') as fid:
    for aline in fid:
        key = aline.strip()
        if key not in dict_fn:
            dict_fn[key] = 1

for root, subdirs, fns in os.walk(sys.argv[2]):
    for fn in fns:
        key = os.path.splitext(fn)[0]
        if key in dict_fn:
            shutil.copy(os.path.join(root, fn), save_dir)

