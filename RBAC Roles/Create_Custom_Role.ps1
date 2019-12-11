<#
.DESCRIPTION
##*===============================================
##* START - DESCRIPTION
##*===============================================    
This will Create a custom RBAC in azure

Script author: Morten Pedholt
Script created on: November 2019
Script edited date: NA
Script last edited by: NA
Script version: 1.0.0
##*===============================================
##* END - DESCRIPTION
##*===============================================
#>

##*===============================================
##* START - PARAMETERS
##*===============================================

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$false)]    
    [string]$logpath = '',
    [Parameter(Mandatory=$false)]    
    [string]$modulename = 'Az',
    [Parameter(Mandatory=$true)]    
    [string]$JsonFilePath = ''
    	
)
##*===============================================
##* END - PARAMETERS
##*===============================================


##*===============================================
##* START - CHECK FOR LOGGIN IN SCRIPT
##*===============================================

#Start transcript if logpath is defined
if ($logpath) {
    If(!(test-path $logpath)) {
            New-Item -ItemType Directory -Force -Path $logpath  -Verbose

    } else{
        Write-Host "$logpath Directory already exist" -ForegroundColor Cyan
        
    }

 Start-Transcript -Path $logpath\Pedholtlab_$(get-date -f yyyy-MM-dd).txt -IncludeInvocationHeader -Append -Force -Verbose
    }else {
    Write-Host "No logpath is specificed in variables" -ForegroundColor Cyan
}
##*===============================================
##*  END - CHECK FOR LOGGIN IN SCRIPT
##*===============================================


##*===============================================
##*  START - CHECK IF REQUIRED MODULE IS INSTALLED
##*===============================================

#Check if the required module is installed, if not it will install and import the module.
if ($modulename) {
    $checkmodule = Get-Module -ListAvailable | Where-Object { $_.Name -like $modulename } -Verbose
    if($checkmodule) {
    Write-Host "$modulename is already installed" -ForegroundColor Cyan
    Import-Module $checkmodule.Name
    }
    Else{
    Write-Host "$modulename is not installed, installing $modulename module" -ForegroundColor Green
    Install-Module $modulename -AllowClobber -Verbose
    Import-Module $modulename
    }

} else {
    Write-Host "No module requirements is specificed in variables" -ForegroundColor Cyan
}

##*===============================================
##*  END - CHECK IF REQUIRED MODULE IS INSTALLED
##*===============================================

##*===============================================
##* START - SCRIPT BODY
##*===============================================
#Login Azure Account
Write-Host "Loggin in.." -ForegroundColor Cyan
Login-AzAccount -ErrorAction Stop

#Get Azure subscriptions
$Subscriptions = Get-AzSubscription
if ($Subscriptions.count -gt 1){
    Write-Host "There is more than one subscription, please enter your Azure subscription ID" -ForegroundColor Cyan
    $SelectSubscriptionID = Read-Host 'Enter your Subscription ID here'

}else {
    $SelectSubscriptionID = $Subscriptions.Id
}

# Select Azure subscription
Write-Host "Selecting subscription ID" $Subscriptions.Id -ForegroundColor Cyan
Set-AzContext -SubscriptionId $SelectSubscriptionID -ErrorAction Stop


New-AzRoleDefinition -InputFile $JsonFilePath



#Disconnect Azure session
Write-Host "Disconnecting Azure account, end of script" -ForegroundColor Cyan
Disconnect-AzAccount




##*===============================================
##* END - SCRIPT BODY
##*===============================================


#Stop Transcript if it's startet
try{
    stop-transcript | out-null
  }
  catch [System.InvalidOperationException]{}

##*===============================================
##* END - CHECK FOR LOGGIN IN SCRIPT
##*===============================================

