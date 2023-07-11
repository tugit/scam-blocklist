#!/bin/bash

# convert csv to blocklist
wget https://www.watchlist-internet.at/liste-betruegerischer-shops/csv/ -O scam-domains.txt
sed -i 's/;.*//' scam-domains.txt
sed -i 's/"//g' scam-domains.txt

# filter out unresolvable domains
rm scam-domains-light.txt
while IFS= read -r line; do
   if host $line > /dev/null; then
      echo "$line" | tee -a scam-domains-light.txt
   fi
done <<< $(cat scam-domains.txt)

# autocommit and push changes
git commit -am "Update filters"
git push
