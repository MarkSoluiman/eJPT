
---

## Metasploit Framework Architecture

Other than the Auxiliary, and Exploit modules that we touched upon previously, MSF has more modules:
- **Payload:** Code that is delivered by MSF and remotely executed on the target after successful exploitation. An example of a payload is a reverse shell code.
- **Encoder:** Used to encode payloads in order to avoid AV detection. For example, shikata_ga_nai is used to encode Windows payloads.
- **NOPS**: Used to ensure that payloads sizes are consistent and ensure the stability of a payload when executed.

### MSF Payload Types:

MSF provides us with two types of payloads that can be paired with an exploit:

 1. **Non- Staged Payload**: Payload that is sent to the target system as is along with the exploit.
 2. **Staged Payload:** A staged payload is sent to the target in two parts, whereby: The first part (stager) contains a payload that is used to establish a reverse connection back to the attacker, download the second part of the payload (stage) and execute it.



