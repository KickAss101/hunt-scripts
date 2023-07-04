#!/usr/bin/bash

# Define color variables
GREEN='\033[0;32m'
RESET='\033[0m'
YELLOW='\033[0;33m'

i=1

mkdir ghdb-dorks 2>/dev/null

while [ $i -lt 15 ]; do
    resp=$(curl -s https://www.exploit-db.com/google-hacking-database\?columns%5B0%5D%5Bdata%5D\=date\&order%5B0%5D%5Bdir%5D\=decsc\&start\=1\&length\=1\&category\=$i \
        -H "X-Requested-With: XMLHttpRequest" \
        -A "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/114.0")

    total_entries=$(echo $resp | jq .recordsTotal)
    category=$(echo $resp | jq  '.data[0].category.cat_title' | sed 's/ /_/g' | tr -d '"')

    echo -e "${YELLOW}Category:${RESET} $category ${GREEN}[$total_entries]${RESET}"

    curl -s https://www.exploit-db.com/google-hacking-database\?columns%5B0%5D%5Bdata%5D\=date\&order%5B0%5D%5Bdir%5D\=decsc\&start\=1\&length\=$total_entries\&category\=$i \
        -A "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/114.0" \
        -H "X-Requested-With: XMLHttpRequest" | jq '.data[].url_title' | cut -d ">" -f 2 | cut -d "<" -f 1 |  sed 's/\\"/"/g' | sort -u > ghdb-dorks/$category.txt
    ((i++))
done