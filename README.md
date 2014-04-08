## Tiler bash script

----

**This repo is incomplete.** I can't get the break script to work, however, the stitcher works fine, although it's a bit clunky and still needs work.

----

----

I'm new to shell scripting, so my work might not be great yet.
*Advice is appreciated.*

----

### Requirements
* [ImageMagick](http://www.imagemagick.org/script/binary-releases.php)

### Running
```bash
./break.sh <arguments>
``` 
```bash
./stitch.sh <arguments>
``` 

### Usage
```bash
USAGE: break.sh <basename> <levelsofdetail> <format>
example: break.sh map1 50000 png
```
```bash
USAGE: stitch.sh <basename> <levelsofdetail> <xtiles> <ytiles> <format>
example: stitch.sh map_1 50000 20 14 png
		   for files following convention: map_1_50000_2_14.png
``` 