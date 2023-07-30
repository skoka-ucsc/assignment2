# Dev Environment for REDIS

This git repo provides a dev environment to build and run [REDIS](https://github.com/redis) software
using an AMI(Amazon Machine Image). One can create an Amazon EC2 instance using this AMI and work with
REDIS source. The AMI is built using [HashiCorp Packer](https://www.packer.io/) software.

## Instructions to build AMI image
- Install Packer using these [installation instructions](https://developer.hashicorp.com/packer/tutorials/aws-get-started/get-started-install-cli).
- The packer template redis-dev-env-aws-ubuntu.pkr.hcl for building the AMI Ubuntu image is provided. The
  template will create a build user account `redisbuilder`, clone the redis git repository into that account
  and will install software neccessary to build and run REDIS software.
- Build the AMI image by running `packer build redis-dev-env-aws-ubuntu.pkr.hcl` command.
- Packer will create an AMI image with monikor skoka followed by build timestamp. The AMI image can be
  found in the AMI management and AMI Catalog page in EC2 dashboard.

## Instructions to use the dev environment
1. Select the AMI image in EC2 dashboard and click on `Launch instance from AMI` to create an EC2 instance
   using these parameters:
   - Name of EC2 instance, e.g. redis-dev-env
   - Key pair for login
   - Create a security group to allow SSH traffic from your dev machine
   - Use defaults for rest of the parameters
2. SSH to EC2 instance as ubuntu user and then sudo to build user account by running `sudo su - redisbuilder`
3. Run `cd redis` command to change directory to the folder where the cloned redis git repository exists.
4. Run `make distclean` command clean previous build remnants.
5. Run `make` command to build redis software.
6. Run `cd src;./redis-server` command to run the redis server.

## Useful links
- [Packer Tutorial](https://developer.hashicorp.com/packer/tutorials/aws-get-started)
- [REDIS Documentation](https://redis.io/docs/)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/index.html)

