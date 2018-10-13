#!/bin/bash

# pandoc -t html5 -s -c docs/pandoc.css -H docs/header.html readme.md -o index.html
# pandoc -t html5 -s -c docs/pandoc.css -A docs/footer.html readme.md -o index.html
pandoc -t html5 -s -c docs/pandoc.css readme.md -o index.html
pandoc -t html5 -s  assembly.md -o assembly.html
