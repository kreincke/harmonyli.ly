#!/bin/bash
# (c) 2020, Karsten Reincke, Germany

CN=`basename $1 .ly`

make ${CN}.pdf
timidity -B2,8 -Os1l -s 44100 ${CN}.midi
