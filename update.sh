#!/bin/sh
cd src
git pull
cd ../publications
python bib.py
cd ..
export DOCFX_SOURCE_BRANCH_NAME=master
docfx 
