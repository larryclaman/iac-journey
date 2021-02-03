# This file can be used to bootstrap when you are developing locally
# this script is ignored when running pipelines in Azure DevOps
# change these as appropriate
$RG="terraformEXP"
$LOCATION="eastUS"
$SA="lncexpterraformstate"
$CONTAINER="terraform-state"
$KEY="localdev1"

az resource list --query "[?resourceGroup=='$RG'].{ name: name, flavor: kind, resourceType: type, region: location }" --output table
az group create --name $RG --location $LOCATION
az storage account create -n $SA -g $RG -l $LOCATION --sku Standard_LRS
az storage container create -n $CONTAINER --account-name $SA --auth-mode login

"resource_group_name = `"$RG`"" |Out-file -Encoding ascii -filepath backend.tfvars
"key = `"$KEY`"" |Out-file -Encoding ascii -Append -filepath  backend.tfvars
"container_name = `"$CONTAINER`"" |Out-file -Encoding ascii -Append -filepath  backend.tfvars
"storage_account_name = `"$SA`"" |Out-file -Encoding ascii -Append -filepath  backend.tfvars

terraform init -backend-config backend.tfvars -reconfigure

az group create --name tailspintoys-paaslab-rg --location eastus
