#About:

This Linux-only tool is designed to help manga cleaners with the tedious task of applying the level tool to each page of a scanned manga.

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

#Installation:
- Put `batch_level.py` into a directory that is covered by your `$PATH` environment variable. For example, on my computer, I use `~/bin/`.
- To make this script executable, do `chmod +x batch_level.py`.
- Put `mass-level.py` into your gimp plugins directory. On my system, it's `~/.gimp-2.8/plug-ins/`
- That's all. Change directories to the one with all your scans, and try it out.
