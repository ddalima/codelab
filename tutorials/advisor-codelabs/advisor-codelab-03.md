author:            Gadi Naor
summary:           Scan Azure subscription entire AKS clusters with Alcide Kubernetes Advisor
id:                00003
categories:        kubernetes,security,advisor
environments:      kubernetes,azure,aks
status:            draft
feedback link:     https://github.com/alcideio/pipeline
analytics account: 0

# Alcide Kubernetes Advisor Overview

## Welcome
Duration: 01:00

In this tutorial we will learn about **Alcide Kubernetes Advisor**, and how we can integrate it with Azure DevOps to implement continous security and cluster hygiene for one or more Kubernetes clusters.

<img src="img/advisor.png" alt="Alcide Code-to-production secutiry" width="300"/>


Alcide Advisor is an agentless Kubernetes audit, compliance and hygiene scanner that’s built to ensure a friciton free DevSecOps workflows. Alcide Advisor can be plugged early in the development process and before moving to production.

#### With Alcide Advisor, the security checks you can cover includes:

- Kubernetes infrastructure vulnerability scanning.
- Hunting misplaced secrets, or excessive priviliges for secret access.
- Workload hardening from Pod Security to network policies.
- Istio security configuration and best practices.
- Ingress Controllers for security best practices.
- Kubernetes API server access privileges.
- Kubernetes operators security best practices.
- Deployment conformance to labeling, annotating, resource limits and much more ...


## Prerequisites
Duration: 00:00

In this codelab we will use an *Azure Subscription*, and scan the various AKS deployed in this subscription using Alcide Kubernetes Advisor.

Make sure your [Azure AKS](https://azure.microsoft.com/en-in/services/kubernetes-service/) clusters running as part of your *Azure Subscription*

<img src="img/advisor-devops.png" alt="Alcide Code-to-production secutiry" width="800"/>

## Prepare Your Environment
Duration: 06:00

Azure offers multiple sign-in options, if you do not already have your *Azure CLI* working against your *Azure Subscription*, refer to ['Sign in with Azure CLI'](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli?view=azure-cli-latest) guide.

* [Install and Set Up kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
* [Install and Set Up Azure CLI](https://kubernetes.io/docs/tasks/tools/install-minikube/)
* [Install JSON Query - jq](https://stedolan.github.io/jq/download/)


<img src="img/prereq.svg" alt="Alcide Code-to-production secutiry" width="400"/>

## Listing AKS Clusters
Duration: 01:00

Let's initially list our AKS clusters.
```bash
az aks list | jq -r '.[] | "Cluster Name: \(.name) ,Resource Group: \(.resourceGroup)"'
```
<img src="img/advisor-player.svg" alt="Alcide Code-to-production secutiry" width="600"/>

## AKS Cluster Credentials
Duration: 01:00

Getting a specific cluster credentials should be straight forward once you have the list of clusters and their resource groups.

```bash
cluster_name=mycluster && \
cluster_rg=mycluster_rg && \
az aks get-credentials --overwrite-existing --name $cluster_name  --resource-group $cluster_rg
```

<img src="img/advisor-player.svg" alt="Alcide Code-to-production secutiry" width="600"/>


## Scanning Your AKS Cluster
Duration: 03:00

Positive
: Download kube-advisor into local directory or any other location in your *PATH*.

##### For Linux
``` sh
cd /tmp/training/advisor &&\
curl -o advisor https://alcide.blob.core.windows.net/generic/stable/linux/advisor &&\
chmod +x advisor
``` 

##### For Mac 
``` sh
cd /tmp/training/advisor &&\
curl -o advisor https://alcide.blob.core.windows.net/generic/stable/darwin/advisor &&\
chmod +x advisor
```

Make sure you have Alcide Kubernetes Advisor in your PATH environment variable.
We are going to start with an initial cluster scan using the buitin scan profile.

```bash
cluster_name=mycluster && \
./advisor validate cluster --cluster-context $cluster_name --namespace-include=* --namespace-exclude=-  --outfile scan.html
```

Open in your browser the generated report **scan.html** and review the result across the various categories.

Positive
: An overview & use cases of Alcide Kubernetes Advisor. <a href="/codelabs/advisor-codelab-01/index.html" class="btn btn-primary" role="button">Start Codelab</a>

<img src="img/advisor-player.svg" alt="Alcide Code-to-production secutiry" width="600"/>

## Putting It Altogether
Duration: 05:00

Now that we know how to list our clusters, get its credntials and scan it with **Alcide Advisor**,
Lets put everything toghether into a script that we can run.

```bash
#!/usr/bin/env bash

alcide_download_advisor(){
    echo "Downloading Alcide Advisor"
    curl -o kube-advisor https://alcide.blob.core.windows.net/generic/stable/linux/advisor
    chmod +x kube-advisor  
}

alcide_scan_current_cluster(){
    local outdir=$1

    CURRENT_CONTEXT=`kubectl config current-context`
    alcide_scan_cluster $outdir ${CURRENT_CONTEXT}
}

alcide_scan_cluster(){
    local outdir=$1
    local context=$2
    
    echo "Running: './kube-advisor --eula-sign validate cluster --cluster-context $context --namespace-include=\"*\" --outfile $outdir/$context.html'"
    ./kube-advisor --eula-sign validate cluster --cluster-context $context --namespace-include="*" --outfile $outdir/$context.html
}

scan_aks_clusters(){
    local outdir=$1
    local CLUSTERS=`az aks list | jq -r '.[] | "\(.name):\(.resourceGroup)" '`

    for cluster in ${CLUSTERS}
    do
        local cluster_name=`echo $cluster | tr ':' ' ' | awk '{ print $1}'`
        local cluster_rg=`echo $cluster | tr ':' ' '  | awk '{ print $2}'`

        echo Scanning $cluster_name $cluster_rg 
        az aks get-credentials --overwrite-existing --name $cluster_name  --resource-group $cluster_rg
        alcide_scan_current_cluster $outdir $cluster_name
    done  
}



outdir=$(mktemp -d -t alcide-advisor-XXXXXXXXXX)


pushd $outdir
alcide_download_advisor
scan_aks_clusters $outdir
popd

```

The script can be found [https://github.com/alcideio/pipeline/blob/master/scripts/aks-advisor-scan.sh](https://github.com/alcideio/pipeline/blob/master/scripts/aks-advisor-scan.sh)

Positive
: At this point this script can be plugged as cron job in your pipeline, and publish the reports to
an Azure Blob for future reference

## Summary
Duration: 01:00

In this codelab we learned how to:
* List *AKS* Clusters
* Get *AKS* cluster credentials 
* Scan with **Alcide Advisor** a cluster
* Automate the scan of *AKS* clusters in an *Azure Subscription* 

Positive
: An overview & use cases of Alcide Kubernetes Advisor. <a href="/codelabs/advisor-codelab-01/index.html" class="btn btn-primary" role="button">Start Codelab</a>