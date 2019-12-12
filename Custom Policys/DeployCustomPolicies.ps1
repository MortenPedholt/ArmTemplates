#Deploy custom policies
#Require tag on specifiecd resources
$Policy = '.\Custom\ITR_Asset_policy.json'
$Parameter = '.\CustomPolicies\ITR_Asset_parameters.json'
$Mode = 'Indexed'
$Name = 'Require ITR-AssetID on specific resourece types'
#Check if policy exist
$ITRAssetCheckpolicy = Get-AzPolicyAssignment -Name $Name -ErrorAction SilentlyContinue
if ($ITRAssetCheckpolicy) {
    Write-Host "Require Tag on Specified ResourceTypes policy already exist, not deploying policy" -ForegroundColor Cyan}
else {
    Write-Host "Required tag Policy not found in the current subscription" -ForegroundColor Cyan
    Write-Host "Deploying policy "$Name" definition and assign it to subscription $SubscriptionID" -ForegroundColor Cyan
    #Create policy definition
    $PolicyDefinition = New-AzPolicyDefinition -Name $Name -DisplayName $Name -description "Credted by ITR Default Policy. Blocking the possiblity of creating a NSG Rule to allow 3389, 25 and any to * on NSG." -Policy $Policy -Parameter $Parameter -Mode $Mode
    #Create policy assignment
    New-AzPolicyAssignment -Name $Name -PolicyDefinition $PolicyDefinition -Scope "/subscriptions/$($SubscriptionID)" 
}



#NSGRulePolicy
$NSGRulePolicy = '.\Custom\NSG_Block_rules_Policy.json'
$NSGRuleMode = 'All'
$NSGRuleName = 'NSG Block insecure rules'
#Check if policy exist
$NSGRuleCheckpolicy = Get-AzPolicyAssignment -Name $NSGRuleName -ErrorAction SilentlyContinue
if ($NSGRuleCheckpolicy) {
    Write-Host "policy already exist, not deploying policy" -ForegroundColor Cyan}
else {
    Write-Host "Policy not found  in the current subscription" -ForegroundColor Cyan
    Write-Host "Deploying policy "$NSGRuleName" definition and assign it to subscription $SubscriptionID" -ForegroundColor Cyan
    #Create policy definition
    $NSGRulePolicyDefinition = New-AzPolicyDefinition -Name $NSGRuleName -DisplayName $NSGRuleName -description "Credted by ITR Default Policy. Blocking the possiblity of creating a NSG Rule to allow 3389, 25 and any to * on NSG." -Policy $NSGRulePolicy -Mode $NSGRuleMode
    #Create policy assignment
    New-AzPolicyAssignment -Name $NSGRuleName -PolicyDefinition $NSGRulePolicyDefinition -Scope "/subscriptions/$($SubscriptionID)" 
}

