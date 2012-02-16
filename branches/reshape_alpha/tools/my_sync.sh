#!/bin/sh
FROM=/Volumes/aki-s/svn.d/art_repo2/branches/reshape_alpha/outdir/fig/masterT/ 
TO=/Users/hogehoge/Dropbox/reserch/periodic-repo/fig/grad2/
rsync -av --exclude=*.m $FROM $TO
