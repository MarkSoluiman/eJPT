
---

## Networking Fundamentals

Every packet that network protocols use to communicate with each other has a Header and a Payload. The header has a **protocol-specific structure** so that the receiving host can read the payload correctly.

**The Payload is the actual sent information**. 

### The OSI model (Open Systems Interconnection)

![[Pasted image 20250112220430.png]]




## Network Layer


- The network layer is **responsible for logical addressing, routing, and forwarding data packets between devices across different networks**.
- Its primary goal is to find the optimal path for data to travel from sender to receiver.

Several key protocols operate on this layer:
- IPv4
- IPv6
- ICMP (Internet Control Message): **Used for error reporting and diagnostics**. ICMP messages include ping, traceroute, and other error messages.

#### IP Functionality

- Logical Addressing:
	- IP addresses serve as logical addresses assigned to network interfaces. 
	- IP addresses are hierarchical and structured based on network classes, subnet, and CIDR (Classless Inter-Domain Routing) notation

- Packet Structure:
	- IP organizes data into packets for transmission. Each packet has header and payload.
	- Header contains info like source and destination, version number, time-to-live (TTL), and protocol type


- Fragmentation and Reassembly:
	- IP allows for the fragmentation of large packets into smaller fragments when traversing networks with varying Maximum Transmission Unit (MTU) sizes.
	- The receiving host reassembles the fragments.

- IP Addressing Types:
	- IP addresses can be classified into three types: unicast (one-to-one), broadcast(one-to- all communication within a subnet), and multicast(one-to-many comm to a selected group of devices)  

- Dynamic Host Configuration Protocol (DHCP):
	- DHCP is often used in conjunction with IP to dynamically assign IP addresses to devices on a network.



#### IP Header Format

The IP protocol defines many different fields in the packet header. These fields contain binary values that the IPv4 services reference as they forward packets across the network.

- IP source address: packet source 
- IP destination address: packet destination
- Time-to-Live (TTL): an 8-bit value that indicates the remaining life of the packet.
- Type-of-Service(ToS): contains 8-bit binary value that is used to determine the priority of each packet. 
- Protocol: 8-bit value that indicates the data payload type the the packet is carrying.



