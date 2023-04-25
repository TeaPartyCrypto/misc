# A Beginner's Guide to Installing PartyChain (Grams) Pool using Kubernetes and Google Cloud

This guide provides step-by-step instructions for installing a pool of PartyChain (Grams) using Kubernetes and Google Cloud, assuming no prior knowledge of Kubernetes.

1. Create a Google Cloud account
Visit the Google Cloud website at https://cloud.google.com and sign up for a new account if you don't have one already.

2. Create a Project and a Cluster
Log in to your Google Cloud account and navigate to the 'Projects' section. Click on 'Create a Project' and provide the required details.
Once your project is created, head to the 'Kubernetes Engine' section, and click on 'Create a Cluster'.
Choose the 'Standard' cluster type, give your cluster a name, and select a region for deployment.
Configure the nodes by setting the desired node count, and enable cluster autoscaling. For example, set the minimum nodes to 0 and maximum nodes to 4.
Click 'Create' and wait for the cluster to be provisioned.
3. Connect to the cluster via SSH
After your cluster is ready, configure the connection to the server via SSH and connect to the cluster.
4. Perform the following steps in order on the server

```
# Update the system
apt update && sudo apt upgrade -y

# Install the 'curl' utility
apt install curl
```


TODO:// we should move these files to a folder in this repo
# Create a directory to store three files which can be obtained from the following link
https://drive.google.com/drive/folders/1eResZWz2lKHT0u7ziDGMQl7hHldDjTks?usp=share_link

# Install Google Cloud CLI
sudo apt-get install apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-cli

# Initialize Google Cloud
gcloud init

# Follow the provided link, log in, and copy the access code. Paste the access code into the command line interface.

# Install the GKE gcloud auth plugin
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin

# Install Kubernetes (kubectl)
sudo apt-get install kubectl

# Connect to the cluster using the provided command (it should be similar to the following)
gcloud container clusters get-credentials mining-pool --zone us-central1-c --project mineonlium
5. Apply the provided manifests. 
```
kubectl apply -f https://raw.githubusercontent.com/cloudnative-pg/cloudnative-pg/release-1.19/releases/cnpg-1.19.1.yaml
kubectl apply -f db.yaml
kubectl apply -f pc.yaml
kubectl expose deployment partychain --type=LoadBalancer --name=partychain-ingr
kubectl expose deployment partychain --type=LoadBalancer --name=partychain-delme
```


```
# Create a new account
cd chain/cmd/geth
go run . account new
You should receive a network account similar to 0x3DAcaa8A19676A1e3aA50c351d035B5887D1C9Ea.


# Navigate to the Ethereum keystore
cd ~/.ethereum/keystore/

# Display the contents of your UTC file
cat <your UTC filename>
```

Exit the pod by typing exit.


Import the account information from the UTC file into the MetaMask browser extension.

```
# Install 'snap' and 'geth'
apt install snapd
sudo snap install geth
```


Add nodes by first obtaining the PartyChain-delme IP address using kubectl get svc. Then, attach 'geth' to the IP address:

```
geth attach http://<partychain-delme ip-address>:8545
```
If the node is added correctly, the system returns "true". Add the other nodes using the same method.

Type exit to exit 'geth'.

Check the logs of the PartyChain pod by running kubectl logs <partychain_pod_name> -f. Synchronization should begin.


Open the 'mc.yaml' file and specify the created account
Edit the addresses of the services
Save and apply the 'mc.yaml' file:

```
kubectl apply -f mc.yaml
```
Wait for synchronization to complete and the DAG file to be created. Monitor the logs of the miningcore pod with kubectl logs <miningcore_pod_name> -f.

6. Verify the services
# Use the `kubectl get svc` command to check the services
You should see output similar to the following:


Address for mining <mining-core-loadbalancer external-ip>:4073
The correct address for this slide is: “104.198.49.251:4073”
Congratulations! You have now installed a pool of PartyChain (Grams) using Kubernetes and Google Cloud.
