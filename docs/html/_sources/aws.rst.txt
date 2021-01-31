.. Comment

AWS
=================

TODO:
-------

- AWS account setup
- EC2 instance setup
- Link EC2 to S3 bucket (give access to EC2 to R/W from S3)

Use docker in EC2 Instance
Create EC2 instance with docker contrainer (can this interface with S3?)
developing jpyterlab in docker AML container remotely
piping jupyterlap to local computer / ipad (development)

OVERVIEW - Table of Contents
``````````````````````````````````

Part 2: [2.0 Getting Started with AWS](#20-getting-started-with-aws)
- 2.1 Account setup Root
- 2.2 IAM account setup
- 2.2b IAM account setup with CLI **todo: link to 5.x?**

Part 3: [3.0 Getting Started with EC2](#30-getting-started-with-ec2)
- 3.1 Create a VPC network
- 3.2 Create a Security Group
- 3.2 Create a Key-Pair
- Everything needed to prep, launch and remote into EC2 instance
- Configuration and launching, & terminating an EC2 instance from web-portal


Part 4: [4.0 AWS CLI Tools Install](#40-aws-cli-tools-install)
- How to install the AWS CLI python tools locally
- This provides command line access to AWS

Part 5: [5.0 AWS CLI Usage](#50-aws-cli-Usage)
- How to use AWS CLI tools to query AWS Account
- Steps to gather necessary information and launch EC2 instances
- **TODO** link S3 bucket to EC2 instance
- how to terminate instance
- Tool specific instructions:

  - IAM account creation
  - Key-Pair Creation
  - VPC Creation
  - Security Group Creation

Part 6: [6.0 EC2 Usage](#60-ec2-usage)
- **TODO**
- SSH into instance
- how to launch a docker image
- how to mount s3 storage

Getting Started with AWS
------------------------------

The first part of getting started with AWS is creating an AWS account. After
the account has been created, it is recommended to create a second, 'sub'
account which will be used to access all services. This second account is
isolated from the billing account.

Once a root-administrative account is created, it will be used for billing
purposes and root control of all AWS activity. To separate developer(s) from
accessing billing information, it is necessary to create Identity and Access
Managment (IAM) accounts that limit access.

Create AWS Account
``````````````````

1. To create an AWS account, follow [THIS Guide](https://aws.amazon.com/premiumsupport/knowledge-center/create-and-activate-aws-account/)
2. (OPTIONAL) It is recommended to create an account alias that will make it

easier to log into the AWS portal, see [THIS Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/console_account-alias.html)

Create IAM User
```````````````

To create an IAM account with Admin access and add them to an 'Administrators'
group, follow [THIS guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html#create-an-iam-user)

Create IAM User USING AWS CLI
`````````````````````````````

**TODO**


Getting Started with EC2
------------------------

Once a root billing account has been created, and an IAM account has been
created, it is possible to now create and configure all the necessary
back-end tools in order to successfully launch an AWS EC2 instance. In order
to launch an EC2 instance, the following is required:

**[A VPC network](#31-create-a-vpc)**
- This will provide a Virtual Private Cloud network in which to launch the
instance

**[A Security Group](#32-create-a-security-group)**
- This will provide a inbound and outbound connection rules for internet
access and SSH access

**[Key Pair]()**
- This will provide a key pair for remote SSH connection


Create a VPC
```````````````

Follow [THIS Guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html#create-a-vpc) to create a VPC.

The VPC defines a Virtual Private Cloud into which an EC2 instance can be
launched. One default VPC could be created that is _region_ specific.

The VPC will be used later to address the subnet when creating an EC2 instance
using the AWS CLI.

**NOTE** VPC must have DNS Hostnames set to YES!

**todo: ref to create a vpc through cli**

Create a Security Group
```````````````````````

Follow [THIS Guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html#create-a-base-security-group) to create a security group.

The security groups define inbound and outbound connections allowed to an EC2
instance.
The important bit about these groups is the inbound IP -> this allows your
public IP to access the EC2 to which the security group is made.

It is important that the security group is created in the correct region.
The group can be made using the online interface, or the AWS interface.

AWS Security Group Creation
'''''''''''''''''''''''''''''''''''
- The Security group region needs to match the Key-Pair region
- what are the considerations (region + IP)

Key Pair
```````````````
Follow [THIS Guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html#create-a-key-pair) to create a key pair.

A key-pair made, must be downloaded as .pem file and used when SSH'ing into
Instance. A created key can only be downloaded once. The key can be created
through the web portal.

The key pair provides access to whichever service it is attached to.

The key-pair region needs to match the Security Group Region.

AWS CLI Tools Install
---------------------------
ipsum

AWS CLI Usage
-------------------

To launch an instance from bash, need to use AWS CLI tools, which are python
tools.

Queries
```````````````

Launching Instance
``````````````````````

Attaching S3 (S3 buckets required)
``````````````````````````````````````

Terminating Instance
````````````````````````

AWS CLI Queries
``````````````````````

ipsum

- Get running instances `aws ec2 desrcibe-isntances`
- get key pairs `aws ec2 describe-key-pairs`
- security groups `aws ec2 describe-security-groups`
- IAM users `aws iam get-users`
- VPCs `aws ec2 describe-vpcs` / subnets -> `aws ec2 describe-subnets`

AWS CLI Launching EC2 Instance
`````````````````````````````````````

What is needed to launch an instance? [THIS](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-instances.html#launching-instances)

.. code-block:: bash

	aws ec2 run-instances --image-id <ami-xxxxxxxx> --count 1 --instance-type t2.micro --key-name <MyKeyPair> --security-group-ids <sg-903004f8> --subnet-id <subnet-6e7f829e>

**NOTE** Tried to run the above; but cannot connect, even though it is running
there seems to be no public DNS -> need to enable Auto-assign Public IP when Launching
since vpc has DNS hostname resolution

At least the following 4 `<>` things:
1. AMI image ID
2. Key Pair
3. security group ID (note, this will define the inbound IPs allowed to access the instance)
4. Subnet ID (this is taken from the VPC)
5. Need

Choose AMI Image ID
'''''''''''''''''''''''''''''''''''''

The AMI image ID describes which EC2 base instance to launch. **TODO** How does this work with AMIDL docker images?

The basic free-tier amazon linux image ID is:
.. code-block:: bash

	ami-00c03f7f7f2ec15c3


Create or Choose Key Pair
'''''''''''''''''''''''''''''''''''''

To create a Key using the aws cli tools [ref](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html#creating-a-key-pair):
.. code-block:: bash

	aws ec2 create-key-pair --key-name <KeyPairName> --query 'KeyMaterial' --output text > <pathToSaveAndNameKeyPair>.pem
	# allow execution of key:
	chmod +x <pathToSaveAndNameKeyPair>.pem

Inputs:
1. KeyPairName -> name of the key
2. Save Path+Name.pem of the key locally.

All made Keys can be queried with the `aws ec2 describe-key-pairs` command. If the local key is available, it can be used.


### 3) Security Group ID
The security group ID is taken from the defined security group.

# 6.0 EC2 Usage

## 6.1 Launching Instances

### 6.1.1 Using AWS Console

### 6.1.2 Using AWS CLI

## 6.2 Attaching S3 Storage
[ref](https://cloudkul.com/blog/mounting-s3-bucket-linux-ec2-instance/)

.. code-block:: bash

	apt-get update







--------------------------
## SSH EC2

To SSH into the instance, make sure it is:
1. Running (using aws cli->add instructions `aws ec2 instance-describe`)
2. You have the keyPair locally available in `.pem` file
3. Run the Command:
.. code-block:: bash

	ssh -i <path_to_key_pair.pem> ec2-user@<instance_id>


# Creating S3

S3 is Amazon Simple storage. It can be linked to an EC2 instance.


# Unsorted

STEP 1: [Setting up with Amazon EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html)
- AWS account
- IAM Admin user [Administrator] (this separates the user from account owner billing info etc)
- Create account alias
- Create key-pair
- save .pem file locally to use later for SSH connection to EC2 instance
- Q: In [create security group](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/get-set-up-for-amazon-ec2.html#create-a-base-security-group)
, the inbound SSH IP is set to match the current computer; however,
this might change, how to ensure I can connect for different locations around the world?

- Q: what about using AWS CLI? -> can use CLI to launch and manage instances; not sure about setting security groups & config; but probably

STEP 2: [Getting Started with Amazon EC2 Linux](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html)
(AWS CONSOLE)
- Remeber to attach the security group created in the STEP 1
- once instance is launched, use (THIS)[https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstances.html) guide for connection]
- Confirmed this work! - just remeber to set security groups correctly, will now close and clean up, then try with awscli
- to clean up use [THIS]() guide

STEP 2: COMMAND LINE:
[AWS CLI tool Install](https://docs.aws.amazon.com/cli/latest/userguide/install-macos.html)
-> Used pip3 on macOS; seems to work first shot, next is [awscli config](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
--> create Administrator access keys
--> use keys to fill `aws configure` with us-east-2 region and 'json'

[AWS CLI tools](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2.html)

<TODO> Update instructions with more input...
