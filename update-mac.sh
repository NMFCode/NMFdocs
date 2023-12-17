#!/bin/sh
cd src
git pull
cd ../publications
python bib.py
cd ..
docfx 