Iteratively makes multiple DNS queries for a given hostname and displays the IP addresses returned.

## Example on Windows (IPv4 only):
```
$ .\dnsenerator.ps1 -hostname github.com -iterations 10 -sleeptime 2
Working...

IP             Count Percent
--             ----- -------
192.30.253.113     6 60.00 %
192.30.253.112     4 40.00 %


10 iterations, 2 unique responses for github.com
```

## Example on Linux (dual stack):
```
IP                     Count Percent
--                     ----- -------
2001:4998:58:2201::73      3 30.000%
2001:4998:44:204::100d     4 40.000%
2001:4998:c:e33::53        3 30.000%


10 iterations, 3 unique responses for yahoo.com
```

Works with PowerShell Core (6.0.1).
