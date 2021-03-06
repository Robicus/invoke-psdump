function Start-PacketJob
{
param
(
[Parameter(Mandatory=$true)]
	[System.String]$pcap
)
	#  Create and start a PS Job for each packet capture
	Start-Job -ScriptBlock {
	
		$packet = $args[1]

        Write-Verbose "Entering Start-PacketJob"
	
		$tempResults = & $args[0] -r $args[1] -nt $args[2] 2> $args[3]
		if ($tempResults)
		{
			Write-Output "Found matching packets in $packet :`n"
			Write-Output $tempResults
		}
	} -ArgumentList $Script:windump, $pcap, $Script:WinDumpFilter, $null | Out-Null
}

function Check-Jobs
{
	#  Continuously check the status of the jobs
	#  and wait for all jobs to complete
	while ( (Get-Job -State Running) )
	{
		Write-Output "Still processing packet captures."
		Start-Sleep -Seconds 2
	}
	Write-Output "Finished processing all packet captures."
	
	$Script:results = Get-Job | Receive-Job
	Get-Job | Remove-Job -Force
}


