$resourceGroupName = "ausgovcaf-assets-rg"
$location = "australiaeast"


New-AzResourceGroup -Name $resourceGroupName -Location $location -Verbose -Force

$deployParams = @{
    automationAccountName = "ausgovcaf-automation"
    logAnalyticsWorkspace = "ausgovcaf-loganalytics"
    storageAccountName    = "ausgovcafassets01"
}

$deployment = New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName `
    -TemplateFile .\deployment\resources.bicep `
    -TemplateParameterObject $deployParams `
    -Verbose -Force

# run the workflow

$params = @{policyScopeId       = "/subscriptions/$((Get-Azcontext).Subscription.Id)"
    workspaceId                 = $deployment.Outputs.workspaceId.Value;
    workspaceResourceId         = $deployment.Outputs.workspaceResourceId.Value;
    workspaceRegion             = $location
    automationAccountResourceId = $deployment.Outputs.automationAccountResourceId.Value;
    updateManagementScope       = @("/subscriptions/$((Get-Azcontext).Subscription.Id)")
}

New-AzSubscriptionDeployment -Name CloudSOEDeployment `
    -Location australiaeast `
    -TemplateUri "https://raw.githubusercontent.com/anwather/ausgovcaf-cloudsoe/main/azureDeploy.json" `
    -TemplateParameterObject $params