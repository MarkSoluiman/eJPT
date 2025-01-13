
#  Lab Environment


A website is accessible at **http://target.ine.local** . Perform reconnaissance and capture the following flags.


- **Flag 1:** This tells search engines what to and what not to avoid.
- **Flag 2:** What website is running on the target, and what is its version?
- **Flag 3:** Directory browsing might reveal where files are stored.
- **Flag 4:** An overlooked backup file in the webroot can be problematic if it reveals sensitive configuration details.
- **Flag 5:** Certain files may reveal something interesting when mirrored.

---

To obtain the first flag, we simply need to add the /robots.txt at the end of our target website.

**flag: f76b967ed6054253b1c2a9b1b06b5c4d**


---

To know the technology that this website uses, we will use nmap.

we will use these flags: -sV -sC. nmap {target url} -sC -SV

**Note: don't add http:// to the target url**

The website is running Wordpress 6.5.3

**flag: 990566c064104182b47dec394999d1e8**

---

For the third flag, we will use dirb, which is a kali linux cli based tool that can reveal directories that we can access in the website.

We will use the wordlist in the following path on our lab machine: /usr/share/dirb/wordlists/big.txt . On our lab command promp: dirb {target url} {wordlist path}

This will result in multiple of directories that we can view, one of them is interesting: /wp-content/uploads

If we went to this directory in the website, we will see the flag file:

**flag: da8abe8520e547468fc751cba08cf99f**

---


For the forth flag, we will use the same tool but we will add the flag -X which will allow us to add extension of files that we want to look for. In this case, we are looking for a backup file and the most common extension for backup files are: .bak, .tmp, and .gho. We will also add: .tar, .zip, and .tar.gz for good measure.

We will do: dirb {target url} {wordlist path} -X .bak, .tmp, .zip, .tar, .tar.gz


We will find this file: http://target.ine.local/wp-config.bak 

**flag: 6ca15543804241679eab68d7ab5a3306**

---
For the final flag, we will use httrack which will download the files of the website so we can view it on our lab machine. 

We run httrack on our lab machine and we will give a name to our project and then provide the target url of the website and choose the first mirroring option. Leave the rest options as default.

After downloading the content of the website, we will find the flag in target.ine.local/xmlrpc0db0.php file.

**flag:3ba72ea507ae4f689f226dc8bc2b3e90**



