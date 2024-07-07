# Terraform Setup for Apache Web Servers on AWS and Azure

This guide provides step-by-step instructions for using Terraform to deploy Apache web servers on AWS EC2 and an Azure VM. Ensure that you have your AWS and Azure accounts configured with appropriate permissions and API access for Terraform.

## Prerequisites

- Terraform installed on your local machine.
- AWS CLI and Azure CLI installed and configured with your credentials.
- Access to AWS and Azure accounts with permissions to create and manage EC2 instances and Azure VMs.

## Structure of Terraform Files

Ensure your Terraform project is structured as follows:

- `main.tf` – Contains the provider configuration and calls to module definitions.
- `variables.tf` – Defines variables used across all configurations.
- `outputs.tf` – Specifies output values that Terraform will display after execution.
- `aws_apache/` – Directory containing Terraform configurations specific to AWS.
- `azure_apache/` – Directory containing Terraform configurations specific to Azure.

## Configuration Steps

### AWS EC2 Apache Server

1. **Navigate to the AWS directory**:
    ```bash
    cd aws_apache
    ```

2. **Initialize Terraform**:
    ```bash
    terraform init
    ```

3. **Plan the Terraform deployment**:
    - This step allows you to see what resources Terraform will create, modify, or destroy.
    ```bash
    terraform plan
    ```

4. **Apply the Terraform configuration**:
    - This step will provision an EC2 instance and install Apache.
    ```bash
    terraform apply
    ```

5. **Verify the deployment**:
    - Once Terraform completes the deployment, check the output for the public IP address of the EC2 instance. Access it via a web browser to see the default Apache page.

### Azure VM Apache Server

1. **Navigate to the Azure directory**:
    ```bash
    cd ../azure_apache
    ```

2. **Initialize Terraform**:
    ```bash
    terraform init
    ```

3. **Plan the Terraform deployment**:
    ```bash
    terraform plan
    ```

4. **Apply the Terraform configuration**:
    - This step will provision an Azure VM and install Apache.
    ```bash
    terraform apply
    ```

5. **Verify the deployment**:
    - Check the output for the public IP address of the Azure VM. Access this IP via a web browser to confirm Apache is running.

## Conclusion

Following these instructions, you should have Apache web servers running on both AWS and Azure, provisioned using Terraform. For detailed customization of the Apache setup or additional configurations, modify the Terraform scripts in the respective directories according to your needs.

## Notes

- Always ensure your security groups (AWS) and network security groups (Azure) are configured to allow HTTP traffic on port 80.
- Regularly update your Terraform scripts to reflect any changes in provider APIs or best practices.
