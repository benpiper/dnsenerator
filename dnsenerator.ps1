param (
    [Parameter(Mandatory)] [string]$hostname,
    [Parameter] [int]$iterations,
    [Parameter] [int]$sleeptime,
    [switch]$nslookup
)

if ($nslookup.isPresent) {
    . ./nsane.ps1
    $records = Iterate-NSLookup -hostname $hostname -nsfile "nservers.txt"
    $records | Format-Table -Property ip,count,percent
    Write-Host $records.count "unique responses" for $hostname
} else {
    . ./dotnutty.ps1
    $records = Iterate-Resolution -hostname $hostname -iterations $iterations -sleeptime $sleeptime
    $records | Format-Table -Property ip,count,percent
    Write-Host $iterations "iterations," $records.count "unique responses" for $hostname
}