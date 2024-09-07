### Origen.ai - Cloud DevOps Engineer Technical Test (2024)

---

### **Project Overview**
This project aims to deploy a web application with frontend, backend, and MongoDB components in an Azure Kubernetes Service (AKS) cluster. Terraform is used to set up the infrastructure, and Helm charts are utilized for deploying the components. The deployment process ensures scalability, security, and easy access to the application.

---

### **Prerequisites**

1. **Azure Free Account**: 
   - Sign up for an Azure free account to access the Azure Kubernetes Service (AKS) and other necessary Azure resources.
   - Ensure that you have sufficient credits (Azure provides $200 credit for free tier users).
   
   [Sign Up for Free Azure Account](https://azure.microsoft.com/free/)

2. **Terraform**:
   - Install Terraform CLI (at least version 1.0) for infrastructure provisioning.
   - Terraform will be used to create the AKS cluster and manage its resources.

   [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

3. **Kubectl**:
   - Install `kubectl` CLI to interact with the AKS cluster for Kubernetes operations.

   [Install Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

4. **Helm**:
   - Install Helm to manage Kubernetes applications.

   [Install Helm](https://helm.sh/docs/intro/install/)

5. **ArgoCD**:
   - ArgoCD will be used to manage the continuous deployment of Kubernetes applications. Install ArgoCD on the AKS cluster after it is set up.

   [ArgoCD Installation Guide](https://argo-cd.readthedocs.io/en/stable/getting_started/)

---

### Setup Instructions for Deploying the Application on AKS

#### **Step 1: Login to Azure**
- First, login to your Azure account via the command line.

```sh
az login
```

- Select the Subscription_id from the Azure account:

```sh
az account set --subscription "subscription-id"
```

#### **Step 3: Create and Setup the Terraform Directory**
- navigate into the aks directory.

```sh
cd aks
```

#### **Step 4: Initialize Terraform and Create AKS Cluster**
- Initialize Terraform in your project directory:

```sh
terraform init
```

- Plan the infrastructure changes to see what will be created:

```sh
terraform plan
```

- Apply the configuration to create the AKS cluster:

```sh
terraform apply -auto-approve
```

- The cluster creation will take a few minutes. Once complete, retrieve the configuration.

#### **Step 5: Connect to AKS Cluster**
- Once the cluster is up and running, configure `kubectl` to securely access the cluster:

```sh
az aks get-credentials --resource-group my-aks-resource-group --name aks-cluster
```

- Verify that your Kubernetes cluster is running:

```sh
kubectl get nodes
```

You should see your AKS cluster nodes listed.


#### **Step 7: Install ArgoCD**
- Deploy ArgoCD into your Kubernetes cluster:

```sh
kubectl create namespace argocd
helm repo add argo https://argoproj.github.io/argo-helm -n argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
helm install argocd argo/argo-cd -f values.yaml -n argocd
```
- Change the argocd-server service type to LoadBalancer:

```sh
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```
- Get the ArgoCD admin password:

```sh
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 --decode
```
- Access ArgoCD via the LoadBalancer service:

```sh
kubectl get svc argocd-server -n argocd
```
- Connect the argocd server using the Loadbalancer External_IP ans use 'admin' and the default username and the password

#### **Step 8: Deploy Application Components Using ArgoCD and Helm**

- Deploy the Application helm charts in the helm Directory with the following:
```sh
helm install argocd argo/argo-cd -f values.yaml -n argocd
```
- On the ArgoCD server, create the Repository and add the ssh keys to authenticate