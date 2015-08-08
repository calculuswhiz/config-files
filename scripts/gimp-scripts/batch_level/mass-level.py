#!/usr/bin/env python
# Put this into your ~/.gimp-2.8/plugins/ directory.
__note__="""
I modified this from some guy's Ubuntu forum post.
"""
import sys
import os
from gimpfu import *

def save_jpeg(image, new_file, comment=""):
    layer = pdb.gimp_image_flatten(image)
    quality = 0.85
    smoothing, optimize, progressive = 0.0, True, True
    subsmp, baseline, restart, dct = 1, False, 0, 0
    pdb.file_jpeg_save(image, layer, new_file, new_file, quality, 
                       smoothing, optimize, progressive, 
                       comment, subsmp, baseline, restart, dct)

def python_fu_mass_level(img, low, high):
    channel     = 0     # HISTOGRAM-VALUE
    gamma       = 1.0
    low_output  = 0
    high_output = 255
    
    if os.path.isdir(img):
        files=os.listdir(img)
    else:
        files=[img]
    for img in files:
        root,filename=os.path.split(img)
        name, ext = os.path.splitext(img)
        new_name = name+'.jpg'
        new_dir  = os.path.join(root, 'levl')
        if not os.path.isdir(new_dir):
            os.makedirs(new_dir)
        new_file = os.path.join(new_dir, new_name)
        # print("ok so far")
        try:
            print("File: %s" %img)
            image = pdb.gimp_file_load(img, img)
            layer = pdb.gimp_image_flatten(image)
            drawable = pdb.gimp_image_get_active_drawable(image)
            pdb.gimp_levels(drawable, channel, low, high, gamma, low_output, high_output)
            save_jpeg(image, new_file, '')
            pdb.gimp_image_delete(image)
            print("  \033[32mO SUCCESS\033[0m\n")
        except RuntimeError, err:
            print("  \033[31mX FAILURE\033[0m\n")
    print("If you are happy with the results, maybe use perl-rename.")
    
    
name="python_fu_mass_level"
blurb="Apply levels to multiple images."
help_="I don't even know how to use this yet."
author="calculuswhiz"
copyright_="calculuswhiz"
date="18 APR 15"
menupath="<Toolbox>/Xtns/Batch/_Mass_level"
imagetypes=""
params=[(PF_FILE, "dir", "Directory of images", ""),
        (PF_INT, "i_min", "Input Minimum", 34),
        (PF_INT, "i_max", "Input Maximum", 250)]
results=[]
function=python_fu_mass_level
register(name, blurb, help_, author, copyright_, date, menupath, imagetypes,
         params, results, function)

main()
