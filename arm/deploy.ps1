# This script deploys in Azure tenant a new resource group and a storage account inside it.
# It also has the option to decomission the previous resources.
# Parameters are specified in a separated file
# Script options: deploy, remove

param ($option, $env)
# Check params
if (($option -ne "deploy") -and ($option -ne "remove")) {
    Write-Error "Possible options: deploy, remove" -ErrorAction Stop
}
if (($env -ne "dev") -and ($env -ne "prod")) {
    Write-Error "Possible options: dev, prod" -ErrorAction Stop
}

#Connect-AzAccount

switch ($option) {
    "deploy" {
        # Deployment
        if ($env -eq "dev") {
            $ParametersFile = ".\azuredeploy.parameters.dev.json"
        }
        else {
            $ParametersFile = ".\azuredeploy.parameters.prod.json"
        }
        Write-Host "Start deployment in $env"
        $ResourceGroupName = "AA-Test-" + $env
        $Location = "West Europe"
        $DeploymentName = "AA-Deployment-" + $env
        Write-Host "Creating resource group $ResourceGroupName in $Location"
        New-AzResourceGroup -Name $ResourceGroupName -Location $Location
        Write-Host "Creating new deployment named $DeploymentName inside resource group $ResourceGroupName"
        New-AzResourceGroupDeployment -Name $DeploymentName  -ResourceGroupName $ResourceGroupName -TemplateFile .\azuredeploy.json -TemplateParameterFile $ParametersFile
        Write-Host "Deployment done!"
        break;
    }
    "remove" {
        # Clean up resource group
        Write-Host "Start clean up"
        $ResourceGroupName = "AA-Test-" + $env
        Write-Host "Removing resource group $ResourceGroupName"
        Remove-AzResourceGroup -Name $ResourceGroupName -Force
        Write-Host "Clean up done!"
        break;
    }
    default {
        break;
    }
}
