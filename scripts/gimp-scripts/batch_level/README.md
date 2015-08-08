#About:

This tool is designed to help manga cleaners with the tedious task of applying the level tool to each page of a scanned manga.

Help message:

    usage: batch_level.py [-h] MIN MAX

    Apply level to a bunch of images in the current dir.

    positional arguments:
      MIN         Level input min. Cutoff at 0.
      MAX         Level input max. Cutoff at 255.

    optional arguments:
      -h, --help  show this help message and exit

When used, it takes all the images in a directory, creates a new directory called "levl" and puts the new JPGs in that directory. JPGs are saved at 85 percent quality, which I found to be the optimal balance between file size and image quality. It does not overwrite the old images. Note that color images often require different parameters.
  
As a side effect, this tool can also be used to batch flatten XCF images as `batch_level.py 0 255`. I put `alias xcf2jpg='batch_level.py 0 255'` in my .zshrc/.bashrc file so I just have to type the one command.
