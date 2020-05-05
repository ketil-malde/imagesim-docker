import sys
import argparse
from generate import mkimage, initialize
import os

# check if python3 is used
if sys.version_info < (3, 0):
    print("This programs need python3x to run. Aborting.")
    sys.exit(1)

p = argparse.ArgumentParser(description='Generate images from background and elements.')
p.add_argument('-d', '--path_to_directory'
               , help='path_to_directory containing backgrounds and crops folder')
p.add_argument('-b', '--backgrounds', default = 'backgrounds'
               , help='name of directory containing background images')
p.add_argument('-c', '--classes', default = 'crops'
               , help='directory containing element images, one subdirectory per class')
p.add_argument('-s', '--single', action='store_true'
               , help='generate images containing one class elements only')
p.add_argument('-n'
               , help='number of images to generate')
p.add_argument('-e', default = 6
               , help='max number of elements per image')
p.add_argument('-o'
               , help='directory to store generated images')
p.add_argument('-m', '--masks', default = False
               , help='output per-instance masks')
args = p.parse_args()

if args.path_to_directory is not None:
    backgrounds_dir = os.path.join(args.path_to_directory, args.backgrounds)
    classes_dir = os.path.join(args.path_to_directory, args.classes)
else:
    backgrounds_dir = args.backgrounds
    classes_dir = args.classes

objects, names, backgrounds = initialize(backgrounds_dir, classes_dir)
n = int(args.n)

for i in range(1,int(n)+1):
    mkimage(args.o+'_%d' % int(i), objects, names, backgrounds,
            output_dir=args.o, maxobjs=args.e, single=args.single, masks=args.masks)

