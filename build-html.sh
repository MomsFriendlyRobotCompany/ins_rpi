#!/bin/bash

pandoc -t html5 -s  readme.md -o index.html
pandoc -t html5 -s  assembly.md -o assembly.html
