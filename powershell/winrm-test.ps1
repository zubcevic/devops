param(
[parameter(Mandatory=$true)]
[string] $MyServerName = ""
)

Write-Output ("Server: $($MyServerName)")

$MySessionOption = New-PSSessionOption -SkipCACheck -SkipCNCheck

$username = Read-Host "Enter username: "
$password = Read-Host -AsSecureString "Enter password: "

$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$password

Invoke-Command -ComputerName $MyServerName -ScriptBlock {
    [environment]::OSVersion
    $PSVersionTable
} -Credential $credential -UseSSL -SessionOption $MySessionOption
