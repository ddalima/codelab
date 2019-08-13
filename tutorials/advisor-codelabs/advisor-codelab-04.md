author:            Gadi Naor
summary:           Scan GKE clusters with Alcide Kubernetes Advisor
id:                00004
categories:        kubernetes,security,advisor
environments:      kubernetes,google,gcp,gke
status:            public
feedback link:     https://github.com/alcideio/pipeline
analytics account: 0

# Alcide Kubernetes Advisor Overview

## Welcome
Duration: 01:00

In this codelab we will create a script that given a *GCP Project*, we will scan the entire GKE clusters in the project, using **Alcide Kubernetes Advisor**.

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

In this codelab we will use a *GCP Project*, to scan the various GKE clusters deployed in this project by using Alcide Kubernetes Advisor.

Make sure your [Google GKE](https://cloud.google.com/kubernetes-engine/) clusters running as part of your *GCP Project*

Positive
: Use 'gcloud info' to see how your local environment is configured

<img src="img/advisor-devops.png" alt="Alcide Code-to-production secutiry" width="800"/>

## Prepare Your Environment
Duration: 06:00

GCP offers multiple sign-in options, if you do not already have your *gcloud cli* working against your *GCP Project*, refer to ['Initializing Cloud SDK'](https://cloud.google.com/sdk/docs/initializing) guide.

* [Install and Set Up kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
* [Install](https://cloud.google.com/sdk/docs/quickstarts) and Set Up [gcloud CLI](https://cloud.google.com/sdk/docs/initializing)

<img src="img/prereq.svg" alt="Alcide Code-to-production secutiry" width="400"/>

## Listing GKE Clusters
Duration: 01:00

Let's initially list our GKE clusters.
```bash
gcloud container clusters list --sort-by=NUM_NODES 2> /dev/null  | \
awk '{ print $1 }' | grep -v NAME
```
<img src="img/advisor-player.svg" alt="Alcide Code-to-production secutiry" width="600"/>

## GKE Cluster Credentials
Duration: 01:00

Getting a specific cluster credentials should be straight forward once you have the list of clusters and their resource groups.

```bash
cluster=mycluster && \
region=mycluster_rg && \
gcloud --quiet container clusters get-credentials --region $region $cluster
```

<img src="img/advisor-player.svg" alt="Alcide Code-to-production secutiry" width="600"/>


## Scanning Your GKE Cluster
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
./advisor validate cluster --cluster-context $cluster_name \
--namespace-include=* --namespace-exclude=-  --outfile scan.html
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
    
    ./kube-advisor --eula-sign validate cluster --cluster-context $context --namespace-include="*" --outfile $outdir/$context.html
}

scan_gke_clusters(){
    local outdir=$1
    local CLUSTER_NAMES=`gcloud container clusters list --sort-by=NUM_NODES 2> /dev/null  | awk '{ print $1 }' | grep -v NAME`

    #echo ${CLUSTER_NAMES}
    for cluster in ${CLUSTER_NAMES}
    do
        local region=`gcloud container clusters list --filter=$cluster | awk '{ print $2}' | grep -v LOCATION`
        echo Scanning $cluster
        gcloud --quiet container clusters get-credentials --region $region $cluster
        alcide_scan_current_cluster $outdir
    done  
}



outdir=$(mktemp -d -t alcide-advisor-XXXXXXXXXX)


pushd $outdir
alcide_download_advisor
scan_gke_clusters $outdir
popd

```

The script can be found [https://github.com/alcideio/pipeline/blob/master/scripts/gke-advisor-scan.sh](https://github.com/alcideio/pipeline/blob/master/scripts/gke-advisor-scan.sh)

Positive
: At this point this script can be plugged as cron job in your pipeline, and publish the reports to
an *Google Storage Bucket* for future reference

## Summary
Duration: 01:00

In this codelab we learned how to:
* List *GKE* Clusters
* Get *GKE* cluster credentials 
* Scan with **Alcide Advisor** a cluster
* Automate the scan of *GKE* clusters in a *GCP Project* 

Positive
: An overview & use cases of Alcide Kubernetes Advisor can be found in  <a href="/codelabs/advisor-codelab-01/index.html" class="btn btn-primary" role="button">here</a>

<img src="img/welcome.svg" alt="Alcide Code-to-production secutiry" width="400"/>