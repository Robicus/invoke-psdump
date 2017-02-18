
# invoke-psdump

## Introduction

Invoke-PSDump is essentially a PowerShell wrapper for WinDump.

WinDump, derived from tcpdump (for Linux), is a command-line packet capture and analysis tool.  WinDump and tcpdump have been around for a long time and have been commonplace in security analysts' toolkits.  However, these tools require a deeper understanding of BPF filters, byte offsets, bit masking, and binary arithmetic to unleash their full power.  Invoke-PSDump seeks to unleash the same power with a few added benefits:

1. Extraordinarily easy syntax
2. Elimination of byte offsets, hexadecimal and bit masking
3. Searchable text patterns
4. Lightning fast processing

Here's an example scenario.  You want to search through a packet capture looking for packets that have the "Don't Fragment" bit set.  WinDump can achieve this with:
* \WinDump.exe -r C:\Tools\PSDump\Captures\SkypeIRC.cap -nt (ip) and (ip[6]=64)

The same can be achieved, with additional text searching, with Invoke-WinDump:
* Invoke-WinDump -File $skypeIRCPCAP -DF $true -Pattern "freenode.net"

Invoke-PSDump is still considered proof-of-concept code that was originally created during graduate research that was conducted with SANS Technology Institute.  My whitepaper can be found here:  https://www.sans.org/reading-room/whitepapers/intrusion/leverage-powershell-create-user-friendly-version-windump-36642

I've been asked about the code several times, and wanted to (finally) take advantage of GitHub to share the code.

## Getting Started

### Pre-Reqs

1.  Download/clone the project.  Navigate to the primary project directory, i.e., C:\Tools\PSDump
2.  Install WinPcap
3.  Make sure you have a copy of "WinDump.exe" in the "PSDump\Tools" directory

### Running Invoke-PSDump

1.  Edit the first few lines of "PSDump.ps1" to ensure that the file paths are correct
2.  Execute "PSDump.ps1" :)

### Examples

1. Invoke-WinDump -File $skypeIRCPCAP -DF $true -Pattern "freenode.net"

2. Invoke-WinDump -File $teardropPCAP -MF $true

3. Invoke-WinDump -File $nb6startupPCAP -TCPFlags "SYN"

4. Invoke-WinDump -Files $files -TCPFlags "ACK,PUSH"
