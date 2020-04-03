#!/usr/bin/env bash

#=============================================================================================
# Setup script for vu.
#
# Author: Rajinder Yadav
# Date: April 2, 2020
# Licence: MIT
# Version: 1.1.4
#=============================================================================================
NODE=$(command -v node)
NPM=$(command -v npm)
VUE=$(command -v vue)
GIT=$(command -v git)

PLATFORM=$(uname -a)
BASH_PROFILE="${HOME}/.bashrc"

if [[ ${PLATFORM} =~ *"Darwin"* ]]; then
    BASH_PROFILE="${HOME}/.bash_profile"
fi

if [ ! -z ${GIT} ]; then
    # Download vu and update Bash startup script.
    git clone git@github.com:rajinder-yadav/.vu.git ${HOME}/.vu
    cat >>"${BASH_PROFILE}" <<-EOF

# vu CLI for Vue.js
if [ -f "${HOME}/.vu/vu.sh" ]; then
    . "${HOME}/.vu/vu.sh"
fi
EOF
else
    echo "WARNING! You must install Git"
fi

# Install Vue.js CLI dependency.
if [ -z ${NODE} ]; then
    echo "WARNING! You must install Node.js"
elif [ -z ${VUE} ]; then
    npm install -g @vue/cli
fi

# Place this at the end of the file.
rm vu-setup.sh
