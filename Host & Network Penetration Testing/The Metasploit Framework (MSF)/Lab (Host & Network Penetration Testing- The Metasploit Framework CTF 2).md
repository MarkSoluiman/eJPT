---

---

---

# Lab Environment

In this lab environment, you will have GUI access to a Kali Linux machine. Two machines are accessible at **target1.ine.local** and **target2.ine.local**.

**Objective:** Using various exploration techniques, complete the following tasks to capture the associated flags:

- **Flag 1:** Enumerate the open port using Metasploit, and inspect the RSYNC banner closely; it might reveal something interesting.
- **Flag 2:** The files on the RSYNC server hold valuable information. Explore the contents to find the flag.
- **Flag 3:** Try exploiting the webapp to gain a shell using Metasploit on target2.ine.local.
- **Flag 4:** Automated tasks can sometimes leave clues. Investigate scheduled jobs or running processes to uncover the hidden flag.

# Tools

The best tools for this lab are:

- Nmap
- Metasploit Framework
- rsync

---
### First Target

We will start with Nmap scan within MSFconsole: `db_nmap -Pn -A -v target1.ine.local `
We will see one open port 873 running rsync service.

To get the first flag, we will ask ChatGPT on how to get banner from rsync server.

The right command is:`rsync -av rsync://192.65.88.3/`

Also, next to the first flag, we get the name of the directory that has files inside of it: "backupwscohen"

**First flag**: c7a88bc82e454ef98c53c952aa002edd

---

To get the second flag, we will ask ChatGPT on how to download files from a directory. The right command: `rsync -av rsync://192.65.88.3/backupwscohen . ` The dot ('.') is to download every file to the current directory.

We will get three files: "TPSData.txt", "office_staff.vhd", and "pii_data.xlsx" . The second flag can be found in "pii_data.xlsx" file.

**Second flag:** 1ee71d39c2444832abe4fd142aee6a45

---

### Second Target

We will do the same as we did for the first target in MSFconsole: `db_nmap -Pn -A -v target2.ine.local`

We will see port 80 open, that means there is a website that is running. We go to the website and we can see that the website is running Roxy-WI. We will search MSF for a module under that name. We indeed found this module: "linux/http/roxy_wi_exec".

We use it to get a meterpreter session that can be upgraded to a shell session.

The third flag can be found in "/" directory.


**Third flag:** 2d390244d0c64257b82a59393c8fd763

The forth flag is tricky, we need to know where cron jobs can be stored in Linux, so we ask ChatGPT. 


The file we are looking for is under "/etc/cron.d/" directory and the file name is: "www-data-cron". We read its content to get the forth flag.

**Forth flag:** e7ab02e91f9d4fa9b8a4efb5827090f3

