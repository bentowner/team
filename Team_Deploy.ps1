#---------------------------------------------------------------------------------------------------------------------------#
# @Project: TEAM                                                                                                            #
# @Author: Equinix Professional Services | Benjamin Towner | Cloud Architect                                                #
# @Date: 05/25/2017                                                                                                         #
#                                                                                                                           #
# Requires -Module AzureRM.Resources                                                                                        #
# Requires -Module Azure.Storage                                                                                            #
#                                                                                                                           #
# 1. Creates resource group                                                                                                 #
# 2. Import Master Template                                                                                                 #
#                                                                                                                           #
# *** Master Template references additional templates located within the Management storage account.***                     #
#                                                                                                                           #
#---------------------------------------------------------------------------------------------------------------------------#
   param
(
    [string][parameter(mandatory=$true, Position=0, HelpMessage="Account name? (ie ben.towner@equinix.com)")]$azureAccountName,
    [SecureString][parameter(mandatory=$true, Position=0, HelpMessage="Password?")]$azurePassword
)

if (-not (Get-Module Import-AzureRM -ErrorAction SilentlyContinue)) 
{
   Import-Module Azure -ErrorAction SilentlyContinue
}

$psCred = New-Object System.Management.Automation.PSCredential($azureAccountName, $azurePassword)
$filelocation = "C:\client_team\team\"

$subscriptionName = "Sandbox_001"
$template1File = $filelocation + "azuredeploy.json"
$template1ParameterFile = $filelocation + "azuredeploy.parameters.json"

$location = "East US"
$resourceGroup1 = "rg-team-fci"

# Login-AzureRmAccount
Login-AzureRmAccount -Credential $psCred
Set-StrictMode -Version Latest

Set-AzureRmContext -SubscriptionName $subscriptionName

## Creates the Resource Group that you have specified.
New-AzureRmResourceGroup -Name $resourceGroup1 -Location $location

## Deploys the template that you have specified.
New-AzureRmResourceGroupDeployment -Name TEAMFCI -ResourceGroupName $resourceGroup1 -TemplateFile $template1File -TemplateParameterFile $template1ParameterFile -Verbose
