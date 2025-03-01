
---
# Lab Environment

In this lab environment, you will have GUI access to a Kali machine. The target machine will be accessible at **target.ine.local**.

**Objective:** Use Metasploit and manual investigation techniques to capture the following flags:

- **Flag 1:** Gain access to the MSSQLSERVER account on the target machine to retrieve the first flag.
- **Flag 2:** Locate the second flag within the Windows configuration folder.
- **Flag 3:** The third flag is also hidden within the system directory. Find it to uncover a hint for accessing the final flag.
- **Flag 4:** Investigate the Administrator directory to find the fourth flag.

# Tools

The best tools for this lab are:

- Nmap
- Metasploit Framework
- mssql

---

We will start with our Nmap scan in MSF: `db_nmap -Pn -A -v target.ine.local`

We will find MSSql running on port 1433. We will brute-force the credentials by using this MSF module: "auxiliary/scanner/mssql/mssql_login"

The username is: "sa" without any password. Next, we will use this MSF module to gain access to the target machine: "windows/mssql/mssql_clr_payload" 

Before we do that, we need to know the name of the Database name, and to do that, we will use Impacket to connect to the MSSql database and get the name of the database.

The python file we will use is: "/usr/share/doc/python3-impacket/examples/mssqlclient.py"

We will do: `python3 /usr/share/doc/python3-impacket/examples/mssqlclient.py sa@10.3.29.83`

Once we are connected to the database, we will do: `SELECT name FROM sys.databases;`

The first name that we get is master.

Now, we will use the MSF module to get access to the target host. After we get a meterpreter session, we can try to escalate our privileges by: `getsystem`. This indeed escalates our privileges and we have Admin access. 

The first flag, we will find in: "C:\"

**First flag:** 59039f8496584cee985bd822eebafdca

---

To find the second flag, we will search the "C:\Windows\system32" directory like so: `dir C:\Windows\system32\flag*.txt /B /S` 

The second flag is in: "C:\Windows\system32\config\flag2.txt"

**Second flag**:  88090b5fd55646148510d3febb95bf17

---

We will search the same directory to find the third flag but this time we will change our search query: `dir C:\Windows\system32\*flag*.txt /B /S`

The third flag is in: "C:\Windows\system32\drivers\etc\EscaltePrivilageToGetThisFlag.txt"

**Third flag:** 9983a299b7494bcd8f4e284294eaf529

---

Since we escalated our privileges already, we can directly access the forth flag by going to the Desktop directory under Administrator user.

**Forth flag:** 67033ae4394147cd8675166c28122fab

