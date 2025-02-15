
---

There is a tool called Linux-exploit-suggester which we can run on the target system and will give us a list of exploits that we can run:https://github.com/The-Z-Labs/linux-exploit-suggester

---

## Exploiting Misconfigured Cron Jobs

Linux implements task scheduling through a utility called Cron.

Cron is a time-based service that runs applications, scripts and other commands repeatedly on a specific schedule.

An application or script that has been configured to be run repeatedly with Cron is known as a Cron job. Cron can be used to automate or  repeat a wide variety of functions on a system, from daily backups to system upgrades and patches.

The crontab file is a configuration file that is used by the Cron utility to store and track Cron jobs that have been created.

Cron jobs can be also run as any user on the system, this is a very important factor to keep an eye on as we will be targeting Cron jobs that have been configured to be run as the "root" user.

This is primarily because, any script or command that is run by a Cron job will run as the root user and will consequently provide us with root access.

In order to elevate our privileges, we will need to find and identify cron jobs scheduled by the root user or the files being processed by the cron job.

**If we have a cron job bash file, we can add our current signed-in user to the sudoers group and make it run commands without providing any password:`printf '#!/bin/bash\necho "(username) ALL=NOPASSWD:ALL" >> /etc/sudoers' > (cron file path)**

We wait until the script is executed, and if we do:`sudo su`, we should be root.

---

## Exploiting SUID Binaries

In addition to the three main file access permissions (read, write and execute), Linux also provides users with specialized permissions that can be utilized in specific situations. One of these access permissions is the SUID (Set Owner User ID) permission.

When applied, this permission provides users with the ability to execute a script or binary with the permissions of the file owner as opposed to the user that is running the script or binary.

SUID permissions are typically used to provide unprivileged users with the ability to run specific scripts or binaries with "root" permissions. It is to be noted, however, that the provision of elevate privileges is limited to the execution of the script and does not translate to elevation of privileges, however, if improperly configured unprivileged, users can exploit misconfigurations or  vulnerabilities within the binary or script to obtain an elevated session.

The success of the attack will depend on the following factors:
- **Owner of the SUID binary**: Given that we are attempting to elevate our privileges, we will only be exploiting SUID binaries that are owned by the "root" user or other privileged users.
- **Access Permissions:** We will require executable permissions in order to execute the SUID binary.

If we find a binary file that has the s permission along side with the x permission for regular users, we can perform the SUID binary attack. For example, if we find a file with the following permissions: "-rwsr-xr-x " we can indeed perform the SUID binary attack.

We will take a look at the strings in the binary file:`strings (binary file name)`
If we found that the binary file is calling for another binary file, we can can remove the binary file being called upon and replace it with "/bin/bash" . 
For example, if we have two binary files:"welcome", and "greetings". The welcome binary file is calling greetings and we can execute greetings without permission, so we remove the greetings file and will do:`cp /bin/bash greetings`. Now, if we ran "welcome" binary file, we will be root.

 ---
## Dumping Linux Password Hashes


All of the information for all accounts on Linux is stored in the password file located in:/etc/passwd

We can't view the passwords for the users in the passwd file because they are encrypted and the password file is readable by any user on the system.

All the encrypted passwords for the users are stored in the shadow file. It can be found in the following directory :/etc/shadow

The shadow file can only be accessed and read by the root account, this is a very important security feature as it prevents other accounts on the system from accessing the hashed passwords.

The passwd file gives us information in regards to the hashing algorithm that is being used and the password hash, this is very helpful as we are able to determine the type of hashing algorithm that is being used and its strength. We can determine this by looking at the number after the username encapsulated by the symbol ($)

| Value | Hashing Algorithm |
| ----- | ----------------- |
| $1    | MD5               |
| $2    | Blowfish          |
| $5    | SHA-256           |
| $6    | SHA-512           |
**Note: If we got a reverse shell session to a target host, we can put it in the background by pressing left Ctrl and Z, then:`sessions -u (session ID)` This will upgrade the session to meterpreter making upload and downloading files easier.**

After getting the hash from the /etc/shadow file, we will use John the ripper to crack the password.

**Note: We need to remove the salt first from the hash for John the ripper to be able to crack the hash. For example, we get his hash:$6$sgewtGbw$ihhoUYASuXTh7Dmw0adpC7a3fBGkf9hkOQCffBQRMIF8/0w6g/Mh4jMWJ0yEFiZyqVQhZ4.vuS8XOyq.hLQBb.:18348:0:99999:7:::. The salt starts from ":", so the hash will be only : $6$sgewtGbw$ihhoUYASuXTh7Dmw0adpC7a3fBGkf9hkOQCffBQRMIF8/0w6g/Mh4jMWJ0yEFiZyqVQhZ4.vuS8XOyq.hLQBb.**

We will save the hash we got in a text file.

To use John the ripper with SHA-512 hash:`john --format=sha512crypt --wordlist(path to passwords wordlist) (path to hash file ).

