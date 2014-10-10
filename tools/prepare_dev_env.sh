#!/bin/bash

# Set the patches directory
export QUILT_PATCHES="debian/patches"
# Remove all useless formatting from the patches
export QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"
# The same for quilt diff command, and use colored output
export QUILT_DIFF_ARGS="-p ab --no-timestamps --no-index --color=auto"
QUILT_NO_DIFF_INDEX=1
QUILT_NO_DIFF_TIMESTAMPS=1
