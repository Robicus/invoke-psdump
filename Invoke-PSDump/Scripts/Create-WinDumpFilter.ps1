function Create-WinDumpFilter
{
param
(
[System.String]$WinDumpParam
)

#  Look for respective paramater values and translate the expressions to WinDump syntax
   switch ($key.Name)
   {
   
   # ------------- 
   #  WinDump Options
   # ------------- 
   
   "ASCII"            { if ($ASCII -eq $true) { $Script:WinDumpOptions += " -A" } }
   "IncludeLinkLayer" { if ($IncludeLinkLayer -eq $true) { $Script:WinDumpOptions += " -e" } }
   "Interface"        { $Script:WinDumpOptions += " -l $Interface" }
   
   # ------------- 
   #  IPv4 Header
   # ------------- 
    "Version"          { if ($Version -eq '4') { $Script:WinDumpFilter += "and (ip)" }
						 elseif ($Version -eq '6') { $Script:WinDumpFilter += "and (ip6)" }
					   }
	"HeaderLength"     { $Script:WinDumpFilter += "and (ip[0] & 0x0f "; 
						Check-Operators -paramToCheck $HeaderLength }
    "TOS"              { $Script:WinDumpFilter += "and (ip[1]";
						Check-Operators -paramToCheck $TOS }
	"TotalLength"      { $Script:WinDumpFilter += "and (ip[2:2]";
						Check-Operators -paramToCheck $TotalLength }
						
	"Identification"   { $Script:WinDumpFilter += "and (ip[4:2]"; Check-Operators -paramToCheck $Identification }
	"Reserve"	       { if ($Reserve -eq $true) { $Script:WinDumpFilter += "and (ip[6]=128)" }
						 else { $Script:WinDumpFilter += "and (ip[6]!=128)" }
					   }
	"DF"	       	   { if ($DF -eq $true) { $Script:WinDumpFilter += "and (ip[6]=64)" }
						 else { $Script:WinDumpFilter += "and (ip[6]!=64)" }
					   }
	"MF"	       	   { if ($MF -eq $true) { $Script:WinDumpFilter += "and (ip[6]=32)" }
						 else { $Script:WinDumpFilter += "and (ip[6]!=32)" }
					   }
	"FragmentOffset"   {}
	"TTL"              { $Script:WinDumpFilter += "and (ip[8] "; Check-Operators -paramToCheck $TTL }
	"Protocol"         {}
	"IPChecksum"         { $Script:WinDumpFilter += "and (ip[10:2] "; Check-Operators -paramToCheck $Checksum }
	"IPSource"         { $Script:WinDumpFilter += "and (src $IPSource)" }
	"IPDestination"    { $Script:WinDumpFilter += "and (dst $IPDestination)" }
	
	# ------------- 
    #  TCP Header
    # ------------- 
	
	"SrcPort"           { $Script:WinDumpFilter += "and (src port $SrcPort)" }
	"DstPort"           { $Script:WinDumpFilter += "and (dst port $DstPort)" }
	"SequenceNumber"    { $Script:WinDumpFilter += "and (tcp[4:4] "; Check-Operators -paramToCheck $SequenceNumber }
	"AckNumber"         { $Script:WinDumpFilter += "and (tcp[8:4] "; Check-Operators -paramToCheck $AckNumber }
	"Offset"            { }
	"TCPReserved"       { }
	"TCPFlags"			{ Check-TCPFlags -paramToCheck $TCPFlags }
	"Window"		    { $Script:WinDumpFilter += "and (tcp[14:2] "; Check-Operators -paramToCheck $Window }
	"TCPChecksum"		{ $Script:WinDumpFilter += "and (tcp[16:2] "; Check-Operators -paramToCheck $TCPChecksum }
	"UrgentPointer"     { }
	
	# ------------- 
    #  UDP Header
    # -------------
	
	"UDPSrcPort"              { $Script:WinDumpFilter += "and (src port $UDPSrcPort)" }
	"UDPDstPort"              { $Script:WinDumpFilter += "and (src port $UDPDstPort)" }
	"Length"                  { $Script:WinDumpFilter += "and (udp[4:2] "; Check-Operators -paramToCheck $Length }
	"UDPChecksum"             { $Script:WinDumpFilter += "and (udp[6:2] "; Check-Operators -paramToCheck $UDPChecksum }
			   	
	# ------------- 
    #  ICMP Header
    # -------------
	
	"Type"         { $Script:WinDumpFilter += "and (icmp[0] "; Check-Operators -paramToCheck $Type }
	"Code"         { $Script:WinDumpFilter += "and (icmp[1] "; Check-Operators -paramToCheck $Code }
	"ICMPChecksum" { $Script:WinDumpFilter += "and (icmp[2:2] "; Check-Operators -paramToCheck $ICMPChecksum }
	
    }
}
	
#  Helper function to check for comparison operators ('<', '>')

function Check-Operators
{
param
(
[System.String]$paramToCheck
)
	if     ($paramToCheck.Contains('<')) { $filter = $paramToCheck + ")"; $Script:WinDumpFilter += $filter }
	elseif ($paramToCheck.Contains('>')) { $filter = $paramToCheck + ")"; $Script:WinDumpFilter += $filter }
	else                                 { $filter = "=" + $paramToCheck + ")"; $Script:WinDumpFilter += $filter }
}

function Check-TCPFlags
{
param
(
[System.String]$paramToCheck
)
	if ($paramToCheck -eq 'SYN') { $Script:WinDumpFilter += "and (tcp[13] = 0x02)" }
	if ($paramToCheck -eq 'ACK,PUSH') { $Script:WinDumpFilter += "and (tcp[13] = 0x18)" }
	if ($paramToCheck -eq 'RST') { $Script:WinDumpFilter += "and (tcp[13] = 0x04)" }
	if ($paramToCheck -eq 'SYN,ACK') { $Script:WinDumpFilter += "and (tcp[13] = 0x12)" }

}


