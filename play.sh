#!/bin/bash
# (c) 2020, Karsten Reincke, Germany

CN=`basename $1 .ly`

make ${CN}.pdf
timidity ${CN}.midi
