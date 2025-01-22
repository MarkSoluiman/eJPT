
---

# Lab Environment

A Linux machine is accessible at **target.ine.local**. Identify the services running on the machine and capture the flags. The flag is an md5 hash format.

- **Flag 1:** There is a samba share that allows anonymous access. Wonder what's in there!
- **Flag 2:** One of the samba users have a bad password. Their private share with the same name as their username is at risk!
- **Flag 3:** Follow the hint given in the previous flag to uncover this one.
- **Flag 4:** This is a warning meant to deter unauthorized users from logging in.

**Note:** The wordlists located in the following directory will be useful:

- /root/Desktop/wordlists

---

target.ine.local

josh, nancy, bob 

We run our Nmap scan: `nmap -Pn -sS -T4 -p- -v (target host) -oX (xml file name)` . We discovered multiple services running on the target host: smb, ssh, ftp.

We will target the smb first to see what usernames we can use to access the smb service with.

We run Metasploit after importing the xml file of the Nmap scan.

To find valid usernames for smb, we will use this auxiliary module:scanner/smb/smb_enumusers

We run it after configuring appropriate options like the RHOST

we indeed find valid usernames: josh, nancy, bob 

Next, we will use these names in a separate text file for a brute force attack to get a valid password with one or multiple of these usernames. We can create a text file using vim and put these usernames in it, each name in one line.

For our brute-force attempt, we will use this auxiliary module:scanner/smb/smb_login

We will set the user_file option to the text file that we created with vim and the pass_file to:/usr/share/metasploit-framework/data/wordlists/unix_passwords.txt

Then, we run it

We find that one pair of credentials were successful: "josh:purple"

Now, we can run smb_enumshares to get the shares available on the smb server knowing the right credentials to access them.

We get these shares: print$ and IPC$ 

However, to get the first flag, we will need to write our own bash script as there are no tools we know about that will give us shares with anonymous login allowed.

**First flag: 3bace349f21b4cfba68301d9d314753e**


---

Now, since we know that one of the users has a share with the same name, we will try to login as josh : `smbclient //(target IP)/josh -U josh `

We find the second flag in this share

**Second flag: 81cb5130f90240608bb2726e4e2dbaed**

This flag also had a hint on where to find the third flag : Psst! I heard there is an FTP service running. Find it and check the banner.

---

We will use auxiliary modules for FTP to get the third flag.

We used the ftp_version module to get the banner and look at what we got:FTP Banner: '220 Welcome to blah FTP service. Reminder to users, specifically ashley, alice and amanda to change their weak passwords immediately

Now, we have valid usernames without using any modules for user enumeration.

We will create a text file which contains these usernames.

Since we have a list of few valid usernames, we can use Hydra tool to crack the password for one of the usernames.

To use Hydra: `hydra -L (usernames fiel) -P (Passwords file) ftp://(target Ip:port)`

After a while, we find that username "alice" and password "pretty" is a valid pair of credentials.

We login to ftp using these credentials: `ftp (target ip) -p (port)`

We get our third flag.

**Third flag: 4b429c9e114e406383fca76877f81182**

---

The forth flag is the easiest to get. We just need to know where to look for it.

We will use ssh_enumusers module to get valid usernames.

We get some valid usernames, like sysadmin, demo, and administrator.

However, if we repeated what we have done to get access to the ftp service using hydra or even using ssh_login module, the brute force attempt takes way too long. 

We will try to login using username sysadmin:`ssh sysadmin@(target IP)

We will see a banner warning us to not login if we are not authorized to do so, but we find the forth flag there.

**Forth flag: deac955db2d74fadbe99cd548d9be881**

