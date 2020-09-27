#Requires -RunAsAdministrator

function Create-Local-Admin {
    param (
        [string] $NewLocalAdmin,
        [securestring] $NewPassword
    )
    begin {

    }
    process {
        New-LocalUser "$NewLocalAdmin" -Password $NewPassword -FullName "$NewLocalAdmin" -Description "local admin"
        Add-LocalGroupMember -Group "Administrators" -Member "$NewLocalAdmin"
        Add-LocalGroupMember -Group "Remote Management Users" -Member "$NewLocalAdmin"
    }
    end {

    }
}

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit 
}


$NewLocalAdmin = Read-Host "Enter name for new local admin: "
$NewPassword = Read-Host -AsSecureString "Enter password: "

Create-Local-Admin -NewLocalAdmin $NewLocalAdmin -NewPassword $NewPassword

Get-LocalUser "$NewLocalAdmin"
Get-LocalGroupMember "Administrators"

Remove-LocalUser "$NewLocalAdmin"