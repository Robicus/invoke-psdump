function Search-Packets
{
param
(
[Parameter(Mandatory=$true)]
	[System.Object[]]$set,

[Parameter(Mandatory=$true)]
	[System.String]$pattern
)
	$matches = $set | Select-String -Pattern $pattern
	Write-Output $matches.Line
}

