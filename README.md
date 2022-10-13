## Install AZ-CLI
``$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi``

https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=powershell

## Install Chocolatey
``
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
``
## Install Terraform
``
choco install terraform
``
## Review Installation
``
terrraform -help
``
## Terraform Main Commands

**terraform init** Initializes a working directory containing Terraform configuration files
**terraform plan** Creates an execution plan, which lets you preview the changes
**terraform apply** Without passing a saved plan file, Terraform automatically creates a new execution plan.

