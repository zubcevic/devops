$basicauth = "username:password"
$enc_basicauth = [Convert]::ToBase64String([Text.Encoding]::ASCII.getBytes($basicauth))
Write-Output "$basicauth ==> $enc_basicauth"

$api_endpoint = "https://www.zubcevic.com/rest/api/content/123"
$req_headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]])"
$req_headers.add("Authorization","Basic $enc_basicauth")
$req_headers.add("Content-Type","application/json")
$req_headers.add("Accept","*/*")

try {
    $current_page = '{"type":"type","title":"title","version":{"number":1}}'
    #Invoke-RestMethod -Uri "$($api_endpoint)?expand=body.storage,version" -Method GET -Headers $req_headers
    $page_version = ($current_page.version.number + 1)
    $page_data = "<h2>Test $page_version</h2>"
    Write-Output "$page_version $page_data"
    $req_body = '{"type":"'+$current_page.type+'","title":"'+$current_page.title
    $req_body +='","version":{"number":'+$page_version+'},"body":{"storage":{"value":"'
    $req_body +=$page_data+'","representation":"storage"}}}'
    Write-Output "body $($req_body)"
    Invoke-RestMethod -Uri "$($api_endpoint)?expand=body.storage" -Method GET -Headers $req_headers -Body $req_body
} catch {
    Write-Output $_.Exception
    Write-Output "status: $($_.Exception.Response.statusCode)"
}