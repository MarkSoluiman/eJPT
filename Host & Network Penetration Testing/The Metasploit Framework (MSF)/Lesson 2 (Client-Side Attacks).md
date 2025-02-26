
---

## Generating Payloads With Msfvenom

A client-side attack is an attack that involves coercing a client to execute a malicious payload on their system that will connect back to the attacker when executed.

Client-side attacks typically utilize various social engineering techniques like generating malicious documents or portable executables (PEs).

Client-side attacks take advantage of human vulnerabilities as opposed to vulnerabilities in services or software running on the target system.

Attackers need to be aware of AV detection when performing a Client-side attack.

To specify the architecture of the target system:`msfvenom -a (arch type) -p (payload) (rest of command)`

We don't have to use the (-a) flag to specify the architecture of the target system, we can specify that in the payload option 

---

##  Encoding Payloads With Msfvenom


Most end user AV solutions utilize signature based detection in order to identify malicious files or executables.

We can evade older signature based AV solutions by encoding our payloads.

Encoding is the process of modifying the payload shellcode with the objective of modifying the payload signature.

We can multiple iteration using encoding technique by using the (-i) flag with a number next to it

---

## Injecting Payloads Into Windows Portable Executables

We can use Some Windows portable executables like Winrar to inject our payload into their setup file. For an example, we will download the 32-bit Winrar setup file to our machine. Then :`msfvenom -p (payload) -e (encoder) -x (Winrar setup file)`.

This however, will not keep the functionality of the Winrar setup file, meaning that when the target user executes our payload, it will not launch the Winrar setup Wizard. To keep the functionality, we can use the (-k) flag. Unfortunately, this doesn't work with Winrar

---
## Automating Metasploit With Resource Scripts

Metasploit resource scripts are a great feature of MSF that allow us to automate repetitive tasks and commands.

They operate similarly to batch scripts, whereby, we can specify a set of MSFconsole commands that we want to execute sequentially.

We can load the script with MSFconsole and automate the execution of the commands we specified in the resource script.


We can see the resource scripts under:"/usr/share/metasploit-framework/scripts/resource"

After writing our resource script, we can run it like so:`msfconsole -r (script file name)`

We can also save our commands that we have done in a metasploit session by: `msf >makerc (path to .rc file)`.

