
# Ansible for Beginners Labs

Welcome to the Ansible for Beginners course! This guide will walk you through setting up your environment and running Ansible playbooks. Each lab is organized into its own directory under the main `ansible-labs` repository.

## Prerequisites

Before you begin, ensure you have the following:

1. **AWS Account**: You need an AWS account to create the resources.
2. **AWS CLI**: Ensure you have the AWS CLI installed and configured with the necessary permissions.
3. **Terraform**: Install Terraform on your local machine.
4. **Ansible**: Familiarity with basic Ansible concepts is helpful but not mandatory.


## Lab 1: Install and run apache
### Running the Terraform Lab

#### Step 1: Clone the Repository

Clone the repository to your local machine:

```bash
git clone https://github.com/tpaz1/ansible-labs.git
cd ansible-labs/hands-on-demo1
```

#### Step 2: Initialize Terraform

Navigate to the `hands-on-demo1` directory and initialize Terraform:

```bash
terraform init
```

#### Step 3: Apply Terraform Configuration

Run the following command to create the resources defined in `main.tf`:

```bash
terraform apply
```

- Confirm the action by typing `yes` when prompted.

This will create:
- An Ansible controller instance.
- Three Ansible worker instances.
- A security group that allows SSH traffic.

#### Step 4: Retrieve DNS Names

After the Terraform apply is complete, retrieve the public DNS names of the created instances:

1. Go to the AWS Management Console.
2. Navigate to the EC2 Dashboard.
3. Find your newly created instances and note their public DNS names.

### Running the Ansible Playbook

#### Step 5: Connect to the Ansible Controller

SSH into the Ansible controller instance:

```bash
# copy the ssh private key to be able to connect to the worker machines
scp -i <private-key> <private-key> ec2-user@<public-ip>:/home/ec2-user/
# connect to the controller machine
ssh -i <private-key> ec2-user@<public-ip>
```

#### Step 6: Navigate to the Lab Directory

Once logged in, navigate to the cloned repository:

```bash
cd /home/ec2-user/ansible-labs/hands-on-demo1
```

#### Step 7: Run the Ansible Playbook

Execute the Ansible playbook to install Apache on the worker instances:

```bash
ansible-playbook -i inventory install_apache.yml --private-key=<private-key>
```

#### Step 8: Open the Browser

After running the playbook, open a browser and visit the public DNS names of the worker instances to see the Apache home page.


### Lab 2: Configure Nginx Load Balancer

#### Objectives:
- Set up an Nginx load balancer in front of multiple web servers.

#### Instructions:
1. Create a new directory `hands-on-demo2`.
2. Modify the Terraform configuration to deploy an Nginx instance as a load balancer and adjust the security group accordingly.
3. Write an Ansible playbook to install and configure Nginx on the load balancer to forward requests to the worker instances.

### Lab 3: Deploy a Simple Node.js Application

#### Objectives:
- Deploy a simple Node.js application on the worker instances.

#### Instructions:
1. Create a new directory `hands-on-demo3`.
2. In the Terraform configuration, ensure that Node.js is installed on the worker instances using an Ansible playbook.
3. Write a playbook to clone a sample Node.js application from a GitHub repository and run it on the worker instances.

### Lab 4: Monitor Instances with Prometheus

#### Objectives:
- Set up Prometheus to monitor the health of the web servers.

#### Instructions:
1. Create a new directory `hands-on-demo4`.
2. Modify the Terraform configuration to deploy a Prometheus server instance.
3. Write an Ansible playbook to install and configure Prometheus to scrape metrics from the worker instances.
