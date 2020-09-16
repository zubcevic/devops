# Sample powershell script

Write-Output "This is a sample powershell script!"

#Clear the command history
Clear-History 

$response = Invoke-WebRequest -Uri 'https://www.zubcevic.com/index.html' -Method Get -UserAgent 'PowerShell' -Headers @{'Accept'='text/html'}

$headers = $response.Headers
$headers.Item('Server')
$headers.Count
foreach ($myheader in $headers.GetEnumerator()) {
 Write-Output "$($myheader.Key) : $($myheader.Value)"
}
Write-Output $response.RawContent
