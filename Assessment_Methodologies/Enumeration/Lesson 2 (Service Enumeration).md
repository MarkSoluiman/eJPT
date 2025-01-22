
---

## FTP Enumeration

We can specify the type of modules that we want to look at using the search command in MSF by:`search type:(type of modules) name:(name of scan)

This will limit our search results to only show the type of modules that we want, in this case Auxiliary, and the name of the scan, in this case ftp

### Useful ftp auxiliary modules:

| Module        | Description                          |
| :------------ | ------------------------------------ |
| ftp_version   | Checks the version of the ftp server |
| ftp_login     | Performs brute force attack          |
| ftp/anonymous | Checks if anonymous login is enabled |

In the ftp_login module, we can set a file that contains the possible usernames and passwords.

**Metasploit has word lists that contain usernames and passwords under /usr/share/metasploit-framework/data/wordlists/

Most common usernames found in the 'common_users.txt' file and the most common passwords are found in the 'unix_passwords.txt'

---

## SMB Enumeration


SMB uses ports 445. However, originally, SMB ran on top of NetBIOS using port 139.

SAMBA is the Linux implementation of SMB, and allows Windows systems to access Linux shares and devices.

Auxiliary modules can be used to enumerate the SMB version, shares, users, and perform brute force attack to get the username and password.


**Neat Trick**: Instead of setting the RHOST every time when running a different module, we can set a global variable that has the RHOST: `setg RHOST (target IP address)`


### Useful SMB auxiliary modules:

| Module         | Description                                             |
| -------------- |:------------------------------------------------------- |
| smb_enumusers  | Determines what users exist                             |
| smb_login      | Performs a brute-force attack using list of credentials |
| smb_version    | Defines the SMB version                                 |
| smb_enumshares | Determines the shares in the SMB                        |

To login into smb server using smbclient tool in Kali Linux: `smbclient //(IP address)/(share name) -U (username)`

---

## Web Sever Enumeration

Apache/2.4.18

Now, we know the concept of how Metasploit works when it comes to searching for auxiliary modules which target specific services which are running on the host target

### Useful HTTP auxiliary modules:

| Module                    | Description                                                                                                  |
| ------------------------- | ------------------------------------------------------------------------------------------------------------ |
| http_version              | Determines the version of the HTTP service                                                                   |
| http_login                | Perfomres a login brute-force for against pages that requires a login                                        |
| brute_dirs or dir_scanner | Performs a brute-force directory search                                                                      |
| robots_txt                | Shows the content of the robots.txt file                                                                     |
| files_dir                 | This module identifies the existence of interesting files in a given directory path.                         |
| apache_userdir_enum       | Determines valid usernames which exits on an Apache server                                                   |
| http_put                  | Allows us to upload a file from our system to the server when providing a directory that allows file uploads |

---


## MySql Enumeration


### Useful MySql auxiliary modules:

| Module              | Description                                                                                                              |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| mysql_version       | Detects the MySQL server version by connecting and reading the version banner.                                           |
| mysql_login         | Attempts to brute-force MySQL credentials using a dictionary of usernames and passwords.                                 |
| mysql_enum          | Enumerates MySQL server details, including database users, privileges, and other metadata.                               |
| mysql_sql           | Executes arbitrary SQL queries on a MySQL server, provided valid credentials.                                            |
| mysql_file_enum     | Enumerates readable/writable files on the MySQL server through the MySQL `LOAD_FILE()` and file-writing functionalities. |
| mysql_hashdump      | Dumps MySQL password hashes from the `mysql.user` table, which can then be cracked offline.                              |
| mysql_schemadump    | Extracts the database schema (list of tables and columns) from a MySQL server.                                           |
| mysql_writable_dirs | Identifies writable directories on the MySQL server, which can be exploited for file-writing attacks.                    |


---


## SSH Enumeration

sysadmin:hailey

### Useful SSH auxiliary modules:

| Module        | Description                                       |
| ------------- | ------------------------------------------------- |
| ssh_version   | Defines the version of the ssh version being used |
| ssh_login     | Performs a brute-force attack                     |
| ssh_enumusers | Finds valid usernames for a ssh session           |

---

## SMTP Enumeration


### Useful SMTP auxiliary modules:


| Module       | Description                                        |
| ------------ | -------------------------------------------------- |
| smtp_version | Defines the version of the smtp version being used |
| smtp_enum    | Finds valid usernames in smtp                      |


