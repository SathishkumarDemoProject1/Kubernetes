# Prerequisites
1. Install docker (Docker version 19.03.8)
2. Install kubernetes  (minikube v1.24.0)
3. Start minikube `minikube start`
4. Install Terraform v1.0.9
5. Create a repo in docker repository.
6. Have your repo created in it and update the docker repository in start.sh of both shopping and merchant


# Building Docker image for shopping and push into docker repository:
1. Get in the root directory of shopping service
2. run `start.sh`(Please provide the proper docker repository credentials)

# Building Docker image for merchant and push into docker repository:
1. Get in the root directory of merchant service
2. run `start.sh`(Please provide the proper docker repository credentials)

# Deployment
To deploy infra run 
1. Have the tunnel open for minikube `minikube tunnel`
2. Turn on ingress `minikube addons enable ingress`
3. `terraform init`
4. `terraform plan`
5. `terraform apply --auto-aprove`

# How to access the application?
Try to use the host provided at the end of `terraform apply` command execution.
http://localhost/v1/merchants
http://localhost/v1/shopping/0
