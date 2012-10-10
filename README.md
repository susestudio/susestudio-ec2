Amazon EC2 scripts for SUSE Studio images
==========================================

This repository contains a collection of sub-projects and scripts used for
creating and managing [Amazon EC2](http://aws.amazon.com/ec2/), in the context
of SUSE Studio ([Online](http://susestudio.com), [Onsite]
(https://www.suse.com/products/susestudio)) built images.

Pull requests, feature requests and bug reports are very much appreciated!


ec2-janitor
-----------
This sub-project provides an easy way to monitor and clean-up Amazon EC2
instances and AMIs across all EC2 regions.


susestudio
-----------
This sub-project contains the documentation and script that is included with
all SUSE Studio built EC2 images (it's bundled in the resulting tarball). The
README file is included as is, while the script has the values marked in {}
substituted during image creation.

The code in this repository is periodically merged and deployed to
[susestudio.com](http://susestudio.com). Please refer to the sub-project's
[README.md](https://github.com/susestudio/susestudio-ec2/blob/master/susestudio/README.md)
for more details.


create-openSUSE-AMIs.sh
------------------------
Bash script for creating public openSUSE AMIs in all Amazon EC2 regions, from a
single Studio built EC2 image. This is used for creating all the official
openSUSE AMIs in Amazon EC2, under the owner ID `056126556840`.

It's a simple wrapper script that extracts information from a tarball name
(hence it must adhere to the naming convention), and calls the [create_ami.sh]
(https://github.com/susestudio/susestudio-ec2/blob/master/susestudio/create_ami.sh.in)
script for each region.

    Usage: create-openSUSE-AMIs.sh TARBALL
      where TARBALL is in the form 'Amazon_Machine_Image_AMI_12.1_32bit.i686-3.0.0.ec2.tar.gz'

Details of the previous public openSUSE AMI releases can be found in the
following blog posts:

  * 27 Jul 2012 - [Public AMIs based on openSUSE 12.1]
    (http://blog.susestudio.com/2012/07/public-amis-based-on-opensuse-121.html)
  * 24 Jun 2011 - [Update for openSUSE 11.4 AMIs on EC2]
    (http://blog.susestudio.com/2011/06/we-updated-all-opensuse-11.html)
  * 11 Mar 2011 - [openSUSE 11.4 for Amazon EC2]
    (http://blog.susestudio.com/2011/03/opensuse-114-for-amazon-ec2.html)
  * 21 Feb 2011 - [Public openSUSE 11.3 AMIs]
    (http://blog.susestudio.com/2011/02/public-opensuse-113-amis.html)


run-and-connect
----------------
Bash script for launching the specific Amazon Machine Image (AMI) and
connecting to it. The instance is automatically terminated upon logout. This is
intended for easy testing of AMIs.

    Usage: run-and-connect [--region REGION] AMI_ID

    Launches and connects to the specified AMI in the specified region.

    Script creates a one-time SSH keypair, waits for the AMI to be available,
    launches the instance, waits for it to boot, then SSHs into it. It
    automatically terminates the EC2 instanceand removes the created SSH
    keypair on logout.

    Options:
      --region REGION      The region to upload and register in [us-east-1, us-west-1,
                           eu-west-1, ap-southeast-1, ap-northeast-1]. Default is 'eu-west-1'.
      --self_test          Run self test on AMI instance and exit.
      --help               Display this help and exit.

Sample run:

    jamestyj@sentosa:~> run-and-connect ami-bdd3e7c9
    10:19:57 Creating SSH keypair suse-studio.DO0fSzzp7m in eu-west-1...
    10:20:01 Waiting for AMI...
    10:20:05 Starting new instance...
    10:20:09 Started i-eb8a779d
    10:20:09 Waiting for hostname......
    10:20:31 Hostname is ec2-46-137-26-197.eu-west-1.compute.amazonaws.com
    10:20:31 Waiting for instance boot and SSH....
    Warning: Permanently added 'ec2-46-137-26-197.eu-west-1.compute.amazonaws.com,46.137.26.197' (RSA) to the list of kno    wn hosts.

      __|  __|_  )  SUSE Linux Enterprise
      _|  (     /       Server 11 SP1
     ___|\___|___|     x86_64 (64-bit)

    For more information about using SUSE Linux Enterprise Server please see
    http://www.novell.com/documentation/sles11/

    Have a lot of fun...
    ip-10-234-223-220:~ # logout
    Connection to ec2-46-137-26-197.eu-west-1.compute.amazonaws.com closed.
    10:21:02 Cleaning up...
    10:21:02 Removing SSH keypair suse-studio.DO0fSzzp7m...
    10:21:05 Terminating instance i-eb8a779d...
    10:21:09 Bye
