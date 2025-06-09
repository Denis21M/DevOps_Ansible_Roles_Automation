# DevOps_Ansible_Roles_Automation
This project automates the provisioning and configuration of two Windows-based web servers using **Ansible**. One VM hosts a website via **IIS**, and the other via **NGINX** on Windows. The configuration is fully automated with Ansible roles and can be run from any control machine, including GitHub Actions CI/CD or WSL.

# Project Architecture.....

# Deployment Workflow

# Step 1: Prepare Azure Environment separately via CLI
- Create a resource group in your desired Azure region.

- Create an Azure Key Vault to securely store the admin username and password.

- Add secrets for adminUsername and adminPassword to the Key Vault by using bash script to execute keyvault bicep.

- Register an Azure AD App (Service Principal) for GitHub Actions.

- Assign it the Contributor role on the resource group.

- Export the service principal credentials to use in GitHub as AZURE_CREDENTIALS secret.

# Step 2: Write Infrastructure Code (Bicep) to;
- Create main.bicep to orchestrate provisioning of two Windows Server VMs.

- Create vm1.bicep for the IIS VM and vm2.bicep for the NGINX VM.

- Include the following in each Bicep file:

    - Virtual Network and Subnet

    - Public IP Address

    - Network Security Group with rules for RDP (3389) and HTTP (80)

    - Network Interface

    - Virtual Machine with Windows image

    - Admin credentials pulled securely from Key Vault

# Step 3: Write Ansible Roles
- Create roles/iis:

    - Install IIS web server

    - Deploy a sample index.html to IIS root

- Create roles/nginx:

    - Install NGINX using Chocolatey

    - Ensure NGINX service is started

# Step 4: Write the Ansible Playbook
- Create site.yml to:

- Apply the IIS role to [iis] hosts

- Apply the NGINX role to [nginx] hosts

- Define host groups in inventory.ini (which will be generated dynamically via GitHub workflow)

- Configure ansible_user, ansible_password, and WinRM connection variables

# Step 5: Automate with GitHub Actions
- Create a workflow file in .github/workflows/deploy.yml

- Define the following steps:

    - Checkout repo

    - Log in to Azure using AZURE_CREDENTIALS

    - Deploy the Bicep templates

    - Retrieve public IPs of both VMs using az vm list-ip-addresses

    - Fetch the admin password from Key Vault using az keyvault secret show

    - Dynamically generate inventory.ini with the IPs and credentials

    -Run the Ansible playbook using the generated inventory

# Step 6: Post-Deployment Validation
- Access the IIS and NGINX web servers in a browser using their public IPs.

- Ensure that the respective landing pages are served correctly.

- Optionally RDP into the VMs for firewall and creds management in case the username and password set in Github secrets are rejected by the server due basic auth not being set to enable.

# Step 7: Clean Up Resources (Optional for cost if not in use)
- Delete the Azure resource group to remove all created resources.