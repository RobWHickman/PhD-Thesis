#!/bin/bash
# word_count.sh

echo "Counting words in thesis..."
echo "Excluding: tables, footnotes, bibliography, and appendices"
echo ""

texcount -merge -inc -dir -sub=chapter thesis.tex

echo ""
echo "Note: Word limit is 60,000 words (80,000 with special permission)"