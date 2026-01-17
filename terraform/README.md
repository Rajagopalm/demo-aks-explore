# Terraform Infrastructure for Microservices on AKS

This directory contains Terraform configuration to set up the necessary Azure infrastructure for deploying microservices to Azure Kubernetes Service (AKS).

## Resources Created

- **Resource Group**: Contains all resources
- **Azure Container Registry (ACR)**: For storing Docker images
- **AKS Cluster**: Kubernetes cluster for running microservices
- **Service Principal**: For GitHub Actions CI/CD with appropriate permissions
- **Role Assignments**: Grants necessary permissions for AKS to pull images from ACR and for the SP to push/pull images and access AKS

## Prerequisites

- Azure CLI installed and logged in (`az login`)
- Terraform installed (v1.0+)
- Azure subscription with sufficient permissions

## Configuration

### 1. Set up Azure Credentials

You have several options for authentication:

**Option A: Azure CLI (Recommended for development)**
```bash
az login
```

**Option B: Service Principal**
```bash
az ad sp create-for-rbac --role Contributor --scopes /subscriptions/YOUR_SUBSCRIPTION_ID
```

### 2. Configure Terraform Variables

Copy the example file and update with your values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` with your Azure details:
- `subscription_id`: Your Azure subscription ID
- `tenant_id`: Your Azure tenant ID (optional)
- `location`: Preferred Azure region
- Other resource names as needed

## GitHub Actions Integration

This Terraform configuration is designed to work with GitHub Actions. The workflow (`.github/workflows/terraform.yml`) automatically handles:

- **On Pull Request**: `terraform init`, `validate`, `fmt`, and `plan`
- **On Push to main**: All above + `terraform apply`
- **Manual Trigger**: Choose `plan`, `apply`, or `destroy`

### Required GitHub Secrets

Set these secrets in your GitHub repository (Settings > Secrets and variables > Actions):

**Azure Authentication:**
- `AZURE_CREDENTIALS`: JSON credentials for Azure service principal

**Terraform Variables (as secrets):**
- `AZURE_SUBSCRIPTION_ID`: Your Azure subscription ID
- `AZURE_TENANT_ID`: Your Azure tenant ID
- `AZURE_LOCATION`: Azure region (e.g., "SOUTH INDIA")

**Optional Resource Configuration:**
- `RESOURCE_GROUP_NAME`: Resource group name (default: "microservice-rg")
- `ACR_NAME`: ACR name (default: "microserviceacr")
- `AKS_CLUSTER_NAME`: AKS cluster name (default: "microservice-aks")
- `AKS_NODE_COUNT`: Number of AKS nodes (default: 2)
- `AKS_VM_SIZE`: VM size for AKS nodes (default: "standard_b16als_v2")

## Usage

### Automated via GitHub Actions (Recommended)

1. **Set up GitHub Secrets** as described above
2. **Push changes** to the `terraform/` directory:
   - PR: Runs plan and validation
   - Push to main: Applies infrastructure
3. **Manual operations**: Use GitHub Actions tab → "Terraform Infrastructure" → "Run workflow" to choose plan/apply/destroy

### Manual CLI Usage (Alternative)

If you prefer manual execution instead of GitHub Actions:

1. **Configure local environment**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Plan the deployment**:
   ```bash
   terraform plan
   ```

4. **Apply the configuration**:
   ```bash
   terraform apply
   ```

**Note**: For GitHub Actions usage, you don't need a local `terraform.tfvars` file. All variables are provided via GitHub secrets as environment variables.

## Outputs

After successful `terraform apply` (via GitHub Actions), the workflow will output important values. You can find these in the Actions tab under the workflow run details.

Key outputs for your CI/CD pipeline:
- `acr_name`: Use for `ACR_NAME` secret
- `aks_cluster_name`: Use for `AKS_CLUSTER_NAME` secret  
- `resource_group_name`: Use for workflow placeholders
- `sp_client_id`: Use for `ACR_USERNAME` secret
- `sp_client_secret`: Use for `ACR_PASSWORD` secret

Copy these values to set up your deployment pipeline secrets.

## GitHub Actions Secrets

After running `terraform apply`, set the following secrets in your GitHub repository:

- `AZURE_CREDENTIALS`: Use the JSON format with `clientId`, `clientSecret`, `subscriptionId`, `tenantId` from outputs
- `ACR_NAME`: The ACR name from output
- `ACR_USERNAME`: The service principal client ID (same as clientId)
- `ACR_PASSWORD`: The service principal client secret

Update the workflow file placeholders:
- `your-resource-group` → Use the resource group name from output
- `your-aks-cluster` → Use the AKS cluster name from output

## Cleanup

To destroy the infrastructure:
```bash
terraform destroy
```

**Warning**: This will delete all resources created by Terraform.