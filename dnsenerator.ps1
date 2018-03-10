#DNS iterator

param (
    [string]$hostname = "github.com",
    [int]$iterations = 1,
    [int]$sleeptime = 1
)
function Iterate-Resolution {
    param (
        [Parameter(Mandatory)] [string]$hostname,
        [Parameter(Mandatory)] [ValidateRange(1,90)] [int]$iterations,
        [Parameter(Mandatory)] [ValidateRange(1,300)] [int]$sleeptime
    )
    $responses = @{}
    write-host "Working..."
    for ($i=0; $i -lt $iterations; $i++) {
        #Query DNS
        try {$ip = [System.Net.Dns]::GetHostAddresses($hostname).IPAddressToString | Select-Object -First 1}
        catch { "Name resolution failed. Please check the hostname."; exit}
        if ($PSVersionTable.Platform -eq "Win32NT") { ipconfig /flushdns > $null }

        #if address is in hashtable
        if ($responses[$ip] -ge 1) { $responses[$ip]++ } else { $responses.Add($ip,1)}
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

$records = Iterate-Resolution -hostname $hostname -iterations $iterations -sleeptime $sleeptime
$records | Format-Table -Property ip,count,percent
Write-Host $iterations "iterations," $records.count "unique responses" for $hostname