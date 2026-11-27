# AWS EKS GitOps

This repository demonstrates an end-to-end, repeatable deployment of an Amazon EKS cluster. Terraform provisions the AWS infrastructure and access configuration, then installs Argo CD with Helm and connects it to a GitOps configuration repository.

The cluster is provisioned from the repository root with one command: `task apply`. The workflow is automated; no manual AWS console changes or kubectl bootstrap steps are required.

## What it provisions

The root [Taskfile.yml](Taskfile.yml) applies the Terraform stacks in dependency order:

1. **Terraform state storage** - an S3 bucket with versioning, server-side encryption, and public access blocked.
2. **Networking** - a VPC with public and private subnets across two Availability Zones, internet access, and NAT gateways for private subnet egress.
3. **IAM** - EKS control-plane and worker-node roles and their AWS-managed policies.
4. **EKS** - an EKS cluster and Spot managed node group, with VPC CNI, kube-proxy, and CoreDNS add-ons.
5. **Cluster access** - IAM roles registered through EKS access entries and associated with Kubernetes groups or EKS access policies.
6. **GitOps bootstrap** - Argo CD and the Argo CD applications chart, installed with Terraform's Helm provider.

The Argo CD bootstrap application watches the `namespaces` directory in [`aws_eks_gitops_config_argocd`](https://github.com/andrealai75/aws_eks_gitops_config_argocd), tracks its `main` branch, and enables automated sync, pruning, and self-healing.

## Prerequisites

- An AWS account and credentials available to the AWS CLI, with permissions to manage the required S3, VPC, IAM, EKS, and related resources.
- A default AWS CLI region configured (`aws configure` or an equivalent profile/environment setup).
- Terraform **1.5.0 or later**.
- [Task](https://taskfile.dev/) and the AWS CLI.
- A POSIX-compatible shell and `curl` (the Taskfiles use shell commands to read the repository name and determine the caller's public IP).
- A Git checkout with its `origin` remote configured. The repository name is used as the Terraform project identifier and in remote state keys.

The EKS API endpoint is public and restricted to the public IPv4 address detected at deploy time (`curl` to `ifconfig.me`). Keep that address current if it changes; the access and EKS stacks recalculate it when their tasks run.

## Deploy

From the repository root, with the prerequisites configured:

```sh
task apply
```

The command runs each stack's Terraform initialization and applies its configuration automatically. The EKS endpoint access CIDR is set to the caller's detected public IP as a `/32`.

To inspect an individual stack before applying it, run its plan task from that stack's directory, for example:

```sh
cd eks
task plan
```

Each stack also has a `validate` task that runs `terraform fmt -check -recursive -diff`.

## Connect to the cluster

After deployment, configure kubectl using the command exposed by the EKS stack:

```sh
aws eks update-kubeconfig --name eks
kubectl get nodes
```

The access stack also outputs kubeconfig commands for the configured IAM access roles. Use the appropriate AWS CLI profile and assume-role setup for a role before connecting as that identity.

### PaymentsDeveloper Kubernetes RBAC

The `PaymentsDeveloper` IAM role has an EKS access entry that maps it to the Kubernetes group `payments-team`. It has no EKS access policy association; Kubernetes permissions for this group are granted by a Kubernetes `RoleBinding` defined in the [GitOps configuration repository](https://github.com/andrealai75/aws_eks_gitops_config_argocd), and are reconciled by Argo CD. Update that repository's RoleBinding to change the group's Kubernetes permissions.

This is separate from AWS IAM permissions: the `PaymentsDeveloper` role is attached to the AWS-managed `ReadOnlyAccess` IAM policy. That policy grants read-only AWS API access; it does not grant Kubernetes permissions.

## GitOps

Terraform only installs and configures the Argo CD bootstrap layer. Workloads and namespace configuration are sourced from the external GitOps repository linked above. Argo CD reconciles that source automatically, including pruning resources removed from Git and self-healing drift.

## Tear down

From the repository root:

```sh
task destroy
```

This destroys the bootstrap, access, EKS, IAM, and network stacks in reverse order. The root destroy task intentionally does not destroy the Terraform state bucket, so remote state remains available after the cluster is removed. Review the stack destroy plans before running this command if any resources need to be retained.

## Repository layout

| Directory | Responsibility |
| --- | --- |
| `terraform_s3_state/` | Terraform state bucket |
| `network/` | VPC, subnets, gateways, and routes |
| `iam/` | EKS control-plane and node IAM roles |
| `eks/` | EKS control plane, managed node group, and add-ons |
| `access/` | EKS access entries, policies, and role-based access |
| `bootstrap/` | Argo CD Helm releases and GitOps application |
