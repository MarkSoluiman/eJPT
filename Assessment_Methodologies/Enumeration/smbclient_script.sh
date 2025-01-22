#This script finds what shares on a target allows for anonymous login.
#IP for the target needs to be provided along with a wordlist of shares

#!/bin/bash

#Define the target IP along with the shares wordlist

read -p "Enter the target IP:" Target
read -p "Enter the full path of the shares wordlist:" Wordlist

#Check if wordlist is available
if [ ! -e "$Wordlist" ]; then
	echo "The file path you provided is not right"
	exit 1
fi

while read -r Share; do
	echo "Testing share: $Share"
	smbclient //$Target/$Share -N -c "ls" &>/dev/null

	if [ $? -eq 0 ]; then
		#Shows output in green
		echo -e "\e[32m[+] Anonymous access allowed for: $Share\e[0m"
    else
    	#Shows output in red
        echo -e "\e[31m[-] Access denied for: $Share\e[0m"
    fi
done< "$Wordlist"
