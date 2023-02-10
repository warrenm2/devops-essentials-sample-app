# Prisma API Interaction Cheat Sheet/ Code Snippets
## Path to console - prod:
$console = "https://europe-west3.cloud.twistlock.com/eu-2-143537337"
## Path to console - dev: 
$console = "https://europe-west3.cloud.twistlock.com/eu-2-143566970"
# CSPM
## Get token of service account - token can also be used for CWP 
### works in cloud shell bash or powershell
#### bash
curl --request POST --url https://api2.eu.prismacloud.io/login --header 'content-type: application/json; charset=UTF-8' --data '{"password":"<IN MANAGEMENT KEY VAULT","username":"597e2ff9-2ac4-4b0d-867c-bc02c0f0761e"}'

#### powershell

$consoleurl = $console #specify which console from above

$Headers = @{
    "Content-Type" = "application/json"
}

$data = '{"username":"<UN>", "password":"<PW>"}'


$tokenoutput = Invoke-RestMethod -Uri $consoleurl/api/v1/authenticate -Method POST -Headers $headers -body $data

# CWP

## Requires Java Web Token, can be generated via CURL or available from Prisma CWP > Manage > System > API Token
$API = $tokenoutput.token
### Valid for roughly 1 hour

## API version
$version = "v22.06"

## Confirm connectivity

$Headers = @{

    "Content-Type" = "application/json"

    "Authorization" = "Bearer $API"

}

$results = Invoke-RestMethod -Uri $console/api/$version/collections -Method Get -Headers $Headers
$results #If results is populated, connection has worked
