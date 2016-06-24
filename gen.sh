#!/bin/sh
pandoc -s -S $1 -o $1.docx
pandoc -s -S $1 -o $1.pdf
pandoc -s -S $1 -o $1.html
