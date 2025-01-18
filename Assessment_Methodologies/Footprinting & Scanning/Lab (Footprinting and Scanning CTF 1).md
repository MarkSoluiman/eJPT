
---

## # Lab Environment

In this lab environment, you will be provided with GUI access to a Kali Linux machine. The target machine will be accessible at **http://target.ine.local.

**Objective:** Perform reconnaissance on the target and capture all the flags hidden within the environment.

**Flags to Capture:**

- **Flag 1**: The server proudly announces its identity in every response. Look closely; you might find something unusual.
- **Flag 2**: The gatekeeper's instructions often reveal what should remain unseen. Don't forget to read between the lines.
- **Flag 3**: Anonymous access sometimes leads to forgotten treasures. Connect and explore the directory; you might stumble upon something valuable.
- **Flag 4**: A well-named database can be quite revealing. Peek at the configurations to discover the hidden treasure.

---

First, we need to make sure that the host is live. We either ping it: `ping target.ine.local` or we can use nmap like so: `nmap -sn target.ine.local`

The host is indeed up. 

To fully scan the host, we will perform an Aggressive stealthy scan on all ports with timing time template of -T4 which will make our scan faster: `nmap -T4 -sS -A -v -p- target.ine.local`


This scan revealed so much to us. We know that an ftp service is running on the host and it allows for anonymous login (no password required). 

Also, we got the first flag.

There is a website running on HTTP port 80.

There is also mysql server running on the host which we can scan further using mysql scripts in nmap.

There is also ssh running on port 22.

Smtp is also running on port 25

**First flag:ff13f646025f4739975b2b065bf80fdb**

---

Now, we will try to login to ftp using username anonymous and without a password:

We successfully login using username of "anonymous" with no password required. 

We find two text files, the first is flag.txt which has the third flag for his lab, and the second is creds.txt which has the password for the database being used.

We can download the files to our lab machine by: `get {name of file}`

To get the second flag, we have to check the robots.txt of the website.

We will find that there is a path marked as Disallow: /secret-info/

If we tried to go to this path by adding it to the end of our target URL, we will see a "flag.txt" in text, if we tried to add this to the end of the current URL we have which should be: "target.ine.local/secret-info/",  we will get our second flag.

**Second flag:1464d950218e434888c9649db5187b52**

---

We got our third flag while we were trying to get our second flag.

**Third flag: 8ac7982acd3d4d7cabc586c3be59f193**

---

Now, since we know that there is a mySQL server running on the target on port 3306, we can use one of the nmap scripts to further analyse the port so we may get a username.

After trying to get the username using nmap scripts, we find out that the username was in creds.txt all along. Username:db_admin, Password:password@123

To connect to mysql: `mysql -u db_admin -p -P 3306 -h 192.249.199.3`
When we are prompt to enter the password, we enter the password that we got from creds.txt.

We are successfully logged in.

To show databases in the mysql server: show databases;

We find the forth flag as one of the databases.

**Forth flag:ffff86bf21b04438bad317c132da34ce**


