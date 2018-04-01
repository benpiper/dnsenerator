#Perform name resolution using nslookup

function Run-NSLookup {
    param (
        [Parameter(Mandatory)] [string]$hostname,
        [Parameter(Mandatory)] [string]$ns
    )

    $ns = (nslookup.exe $hostname $ns)[-2] 2>$null
    $lookup = [PSCustomObject]@{
    Address = ($ns -split ':')[1].Trim()
    }
    return $lookup.Address
}

function Iterate-NSLookup {
    param (
        [Parameter(Mandatory)] [string]$hostname,
        [Parameter(Mandatory)] [string]$nsfile
    )
    #read ns into array from nservers.txt
    $nservers = Get-Content -Path $nsfile

    $responses = @{}
    write-host "Working..."

    foreach ($nserver in $nservers) {
        #Query DNS
        try {$ip = Run-NSLookup -hostname $hostname -ns $nserver }
        catch { "Name resolution failed. Please check the hostname."; exit}

        #if address is in hashtable, increment counter
        if ($responses[$ip] -ge 1) { $responses[$ip]++ }
        else {
            $responses.Add($ip,1)
            Write-Host Resolved unique IP: $ip
        }
    }

    $recordlist = @()
    $responses.keys | ForEach-Object  {
        $recordlist += New-Object PSObject -Property @{
            'IP'=$_;
            'Count'=$responses[$_];
            'Percent'="{0:p}" -f ($responses[$_]/$nservers.Count)
        }
    }
    return $recordlist
}