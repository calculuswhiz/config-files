#!/usr/bin/env python
# This goes into your ~/bin/ directory or somewhere in your PATH. Be sure to make it executable. This way, you can run directly from the terminal.
# Also, to convert an XCF to JPG at 85 quality, you can alias the command `batch_level.py 0 255`.
import sys
import os
import argparse

parser = argparse.ArgumentParser(description="Apply level to a bunch of images in the current dir.")
parser.add_argument('min', metavar='MIN', type=int,  help='Level input min. Cutoff at 0.')
parser.add_argument('max', metavar='MAX', type=int,  help='Level input max. Cutoff at 255.')

args = parser.parse_args()
argList = vars(args)
minIn = argList['min']
maxIn = argList['max']

if minIn<0:
    minIn=0

if maxIn>255:
    maxIn=255

cmd = ("gimp -i -b '(python-fu-mass-level RUN-NONINTERACTIVE \".\" %s %s)' -b '(gimp-quit 0)'")%( minIn, maxIn)

print(cmd)
os.system(cmd)
