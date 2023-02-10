# Pre-reqs - need a .txt file named 'sha256.txt' with the image hash value within
# Script then takes that file as input, calls out to prisma API to retrieve vuln scan results,
# determines where a vulnerability has blocked the scan, then returns info about the
# vulnerability that has blocked the scan so that a waiver can be put in place

$sha256 = get-content -path ./vulnerability-scan-info/sha256.txt
$console = "https://europe-west3.cloud.twistlock.com/eu-2-143537337"
$api = "v1"

$user = "3104aed5-cf62-4b07-83f9-f110c07c9971"
$secret = $env:SECRET

$AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user,$secret)))
$scanres = Invoke-RestMethod -Headers @{Authorization=("Basic {0}" -f $AuthInfo)} -Uri $console/api/$api/scans?imageID=sha256:$sha256 -Method Get

$scanresinfo = $scanres.entityInfo.Vulnerabilities
$scanresinfo | where-object {$_.block -eq "True"} | select-object packageName, packageVersion, cve, graceperioddays, block, severity #| export-csv -Path "sha256-$sha256.csv" -NoTypeInformation
