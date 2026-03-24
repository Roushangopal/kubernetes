🚀 Kubernetes Platform with Cluster API & AWS Cloud Control

This project demonstrates how to build a platform engineering system using Kubernetes as a control plane to manage infrastructure and applications declaratively.

It combines:

Terraform (infrastructure bootstrap)
Cluster API (Kubernetes cluster lifecycle)
AWS Cloud Control Manager (AWS resources as CRDs)
Custom Go Operator (platform orchestration)
📌 Project Objective

Build a platform where:

Terraform bootstraps a management EKS cluster
Cluster API creates and manages workload clusters
AWS Cloud Control exposes AWS services as Kubernetes CRDs
A custom Go operator orchestrates everything using an Environment CRD
🏗️ Architecture Overview
Terraform → EKS (Management Cluster)
                 ↓
         Cluster API (CAPI)
                 ↓
     Workload Kubernetes Clusters
                 ↓
AWS Cloud Control Manager (CRDs for AWS)
                 ↓
Custom Go Operator (Environment Controller)
📁 Repository Structure
platform-project/
├── terraform/
│   ├── main.tf
│   ├── eks.tf
│   ├── iam.tf
│
├── operator/
│   ├── api/
│   ├── controllers/
│   ├── main.go
│   ├── go.mod
│
├── manifests/
│   ├── environment-crd.yaml
│   ├── rbac.yaml
│
├── examples/
│   └── dev-environment.yaml
⚙️ Step-by-Step Setup
1. Terraform Bootstrap

Provision base infrastructure:

VPC
EKS Management Cluster
IAM Roles
OIDC Provider
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "platform-cluster"
  cluster_version = "1.29"
}
2. Install Cluster API

Initialize Cluster API with AWS provider:

clusterctl init --infrastructure aws

This installs CRDs like:

Cluster
Machine
AWSCluster
AWSMachine
3. Install AWS Cloud Control Manager

This enables AWS resources as Kubernetes CRDs:

Examples:

S3Bucket
RDSDBInstance
EC2Instance
IAMRole

Example:

apiVersion: cloudcontrol.services.k8s.aws/v1alpha1
kind: S3Bucket
metadata:
  name: demo-bucket
spec:
  name: my-demo-bucket
4. Define Platform CRD (Environment)

Create a higher-level abstraction:

apiVersion: platform.io/v1
kind: Environment
metadata:
  name: dev
spec:
  cluster:
    name: dev-cluster
  database:
    engine: postgres
  storage:
    bucket: dev-app-bucket
5. Generate Operator (Kubebuilder)
kubebuilder init --domain platform.io
kubebuilder create api --group platform --version v1 --kind Environment

This generates:

CRDs
Controller skeleton
RBAC configs
6. Reconciliation Logic

The operator watches Environment resources and performs:

Workflow:

User applies Environment YAML
Controller starts reconciliation
Creates Cluster API cluster
Provisions AWS resources via CRDs
Updates status

Pseudo-code:

env := getEnvironment()

createClusterAPICluster(env.Spec.Cluster.Name)
createS3Bucket(env.Spec.Storage.Bucket)
createDatabase(env.Spec.Database)

updateStatus("Ready")
7. Deploy Operator
docker build -t platform-operator .
make deploy

This installs:

CRDs
Controller into the cluster
8. Test the Platform

Apply example:

kubectl apply -f examples/dev-environment.yaml

Verify:

kubectl get environments
kubectl get clusters
kubectl get s3buckets

You should see resources automatically provisioned 🎉

💡 Key Concepts Demonstrated
Kubernetes as a control plane
Custom Resources (CRDs)
Controllers & reconciliation loops
Cluster lifecycle management via Cluster API
AWS resource management via Kubernetes
Platform engineering patterns
