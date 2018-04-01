#Perform name resolution using the System.Net.Dns library

function Iterate-Resolution {
    param (
        [Parameter(Mandatory)] [string]$hostname,
        [Parameter(Mandatory)] [ValidateRange(1,90)] [int]$iterations,
        [Parameter(Mandatory)] [ValidateRange(0,43200)] [int]$sleeptime
    )
    $responses = @{}
    write-host "Working..."
    for ($i=0; $i -lt $iterations; $i++) {
        #Query DNS
        try {$ip = [System.Net.Dns]::GetHostAddresses($hostname).IPAddressToString | Select-Object -First 1}
        catch { "Name resolution failed. Please check the hostname."; exit}
        if ($PSVersionTable.Platform -eq "Win32NT") { ipconfig /flushdns > $null }

        #if address is in hashtable, increment counter
        if ($responses[$ip] -ge 1) { $responses[$ip]++ }
        else {
            $responses.Add($ip,1)
            Write-Host Iteration $i : Resolved unique IP: $ip
        }
        Start-Sleep -Seconds $sleeptime
    }
    #$responses.GetEnumerator()
    $recordlist = @()
    $responses.keys | ForEach-Object  {
        $recordlist += New-Object PSObject -Property @{
            'IP'=$_;
            'Count'=$responses[$_];
            'Percent'="{0:p}" -f ($responses[$_]/$iterations)
        }
    }
    return $recordlist
}