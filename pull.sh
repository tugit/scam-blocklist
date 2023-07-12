#!/bin/bash

# convert csv to blocklist
wget https://www.watchlist-internet.at/liste-betruegerischer-shops/csv/ -O scam-domains.txt
sed -i 's/;.*//' scam-domains.txt
sed -i 's/"//g' scam-domains.txt

# filter out unresolvable domains
rm scam-domains-light.txt
echo "# Domains from watchlist-internet.at" | tee -a scam-domains-light.txt
while IFS= read -r line; do
   if host $line > /dev/null; then
      echo "$line" | tee -a scam-domains-light.txt
   fi
done <<< $(cat scam-domains.txt)

# add anfras.org blocklist
wget https://anfras.org/fakeshops -O anfras.txt
sed -i 's/#.*//' anfras.txt
sed -i '/^$/d' anfras.txt
echo "" | tee -a scam-domains-light.txt
echo "# Domains from anfras.org" | tee -a scam-domains-light.txt
while IFS= read -r line; do
   if ! grep -q $line scam-domains-light.txt && host $line > /dev/null; then
      echo "$line" | tee -a scam-domains-light.txt
   fi
done <<< $(cat anfras.txt)

# autocommit and push changes
git commit -am "Update filters"
git push
