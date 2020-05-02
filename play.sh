#!/bin/bash

CN=`basename $1 .ly`

make ${CN}.pdf
timidity ${CN}.midi
