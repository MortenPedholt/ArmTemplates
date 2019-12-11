<###
DESCRIPTION
Author: Morten Pedholt
Created: August 2019
Edited: N/A
Edited by: N/A
ScriptVersion: 1.0.0

###>

##*===============================================
##* START - VARIABLES
##*===============================================

[CmdletBinding()]
Param (
    [Parameter(Mandatory=$true)]    
    [string]$ResourceGroupName = '',
    [Parameter(Mandatory=$true)]    
    [string]$ResourceGroupLocation = '',
    [Parameter(Mandatory=$true)]    
    [string]$SubscriptionId = '',
    [Parameter(Mandatory=$true)]    
    [string]$DeploymentName = '',
    [Parameter(Mandatory=$true)]    
    [string]$mode = 'incremental',
    [Parameter(Mandatory=$true)]    
    [string]$TemplateFilePath = '',
    [Parameter(Mandatory=$true)]    
    [string]$ParametersFilePath = ''
	
)
##*===============================================
##* END - VARIABLES
##*===============================================

Function RegisterRP {
    Param(
        [string]$ResourceProviderNamespace
    )

    Write-Host "Registering resource provider '$ResourceProviderNamespace'";
    Register-AzResourceProvider -ProviderNamespace $ResourceProviderNamespace;
}

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"

# Verify that the Az module is installed 
if (!(Get-InstalledModule -Name Az -ErrorAction SilentlyContinue)) {
    Write-Host "This script requires to have Az Module version $AzModuleVersion installed..
It was not found, please install from: https://docs.microsoft.com/en-us/powershell/azure/install-az-ps"
    exit
} 

# sign in
Write-Host "Logging in...";
connect-AzAccount;

# select subscription
Write-Host "Selecting subscription '$SubscriptionId'";
Select-AzSubscription -SubscriptionID $SubscriptionId;


#Create or check for existing resource group
$ResourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue
if(!$ResourceGroup)
{
    Write-Host "Resource group '$ResourceGroupName' does not exist. To create a new resource group, please enter a location.";
    if(!$ResourceGroupLocation) {
        $ResourceGroupLocation = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$ResourceGroupName' in location '$ResourceGroupLocation'";
    New-AzResourceGroup -Name $ResourceGroupName -Location $ResourceGroupLocation
}
else{
    Write-Host "Using existing resource group '$ResourceGroupName'";
}

# Start the deployment
Write-Host "Starting deployment...";
if(Test-Path $ParametersFilePath) {
    New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -Name $DeploymentName -TemplateFile $TemplateFilePath -TemplateParameterFile $ParametersFilePath -Mode $mode -Verbose;
} else {
    New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName -Name $DeploymentName -TemplateFile $TemplateFilePath -Mode $Mode -Verbose;
}
