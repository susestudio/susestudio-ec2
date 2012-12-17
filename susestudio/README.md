README for SUSE Studio Amazon EC2 image
=======================================

NOTE: The latest version of this README and corresponding scripts are available
on [Github](https://github.com/susestudio/susestudio-ec2/tree/master/susestudio).
The rendered version of this document is also easier to read there.

This tarball contains the Amazon [EC2](http://aws.amazon.com/ec2/) image
created by SUSE Studio ([Online](http://susestudio.com), [Onsite]
(https://www.suse.com/products/susestudio/)) and the `create_ami.sh` script.
The script uploads the image to Amazon EC2 and creates an [EBS]
(http://aws.amazon.com/ebs/) backed Amazon Machine Image ([AMI]
(http://en.wikipedia.org/wiki/Amazon_Machine_Image)).


Installation
-------------

The Amazon EC2 API tools must be installed for the script to work. The easiest
way is to install the RPM from the [Cloud:EC2 repository]
(http://download.opensuse.org/repositories/Cloud:/EC2/). For
example, if you're running openSUSE 12.2, run the following commands:

    sudo zypper addrepo http://download.opensuse.org/repositories/Cloud:/EC2/openSUSE_12.2/ Cloud:EC2
    sudo zypper refresh Cloud:EC2
    sudo zypper install ec2-api-tools

Alternatively, you can [download]
(http://developer.amazonwebservices.com/connect/entry.jspa?externalID=351) and
[install](http://docs.amazonwebservices.com/AmazonEC2/gsg/2006-06-26/setting-up-your-tools.html)
them directly from Amazon.


Configuration
--------------

In order to access Amazon Web Services (AWS), the script requires the following
environment variables to be defined:

    $AWS_USER_ID     - AWS user ID (eg. 123456789012)
    $AWS_ACCESS_KEY  - AWS access key ID (eg. ABCDEFGHIJKLMNOPQRST)
    $AWS_SECRET_KEY  - AWS secret access key (eg. abcdefghijklmnoprqrtuvwxyzabcdv)
    $EC2_CERT        - Path to EC2 X.509 certification (eg. ~/cert-aws.pem)
    $EC2_PRIVATE_KEY - Path to EC2 private key (eg. ~/pk-ec2.pem)

We recommend setting these variables in your `~/.profile` file so that you don't
have to set them up manually each time, eg:

    export AWS_USER_ID=123456789012
    export AWS_ACCESS_KEY=ABCDEFGHIJKLMNOPQRST
    export AWS_SECRET_KEY=abcdefghijklmnoprqrtuvwxyzabcdv
    export EC2_CERT=~/cert-aws.pem
    export EC2_PRIVATE_KEY=~/pk-ec2.pem


Execution
----------

Now you can create your AMI in the specific Amazon region (eg. `us-west-1`,
`eu-west-1`) simply by executing the script:

    ./create_ami.sh --region eu-west-1

You can then use Amazon's [AWS web console](https://console.aws.amazon.com) to
manage and launch instances of your AMIs.

There are additional options you can specify:

    jamestyj@sg:/My_EC2-0.0.1> ./create_ami.sh --help
    Usage: create_ami.sh [--region REGION] ...
    Uploads and creates an EBS backed EC2 Amazon Machine Image (AMI) in Amazon Web Services (AWS).

    Report bugs to https://github.com/susestudio/susestudio-ec2/issues.

    General options:
      --region REGION          The region to upload and register in [us-east-1, us-west-1,
                               eu-west-1, ap-southeast-1, ap-northeast-1]. Default is 'us-east-1'.
      --name NAME              AMI name. Must be unique. Default is 'My_EC2-0.0.1'.
      --description TEXT       AMI description. Default is 'Built by SUSE Studio'.

    Advanced options:
      --arch ARCH              System architecture [i386, x86_64]. Default is 'i386'.
      --base BASE_SYSTEM       Base system [11.3, 11.4, SLES10_SP3, SLES11_SP1]. Default is '12.2'.
      --tarball FILE_PATH      Path to Studio EC2 tarball. Default is '../My_EC2-0.0.1.ec2.tar.gz'.
      --volume_size SIZE       Root volume size, in GB. Default is 5.
      --test_ami               Test the resulting AMI by launching and SSH into it.
      --public                 Make the resulting AMI public.


### Sample output

Normal execution of the create_ami.sh script looks like this:

    jamestyj@sg:/> tar xf My_EC2.x86_64-0.0.1.ec2.tar.gz
    jamestyj@sg:/> cd My_EC2-0.0.1
    jamestyj@sg:/My_EC2-0.0.1> ./create_ami.sh --region eu-west-1
    20:13:35 Creating 'SUSE_Studio' security group in eu-west-1...
    20:13:38 Created new security group
    20:13:38 Adding SSH permissions to 'SUSE_Studio' security group in eu-west-1...
    20:13:40 Added SSH permissions
    20:13:40 Creating SSH keypair suse-studio.7t0KnY0zjn in eu-west-1...
    20:13:42 Starting new instance (ami-6e57621a)...
    20:13:48 Started i-4d0a563a in eu-west-1b
    20:13:48 Waiting for hostname.....
    20:14:05 Hostname is ec2-79-125-65-52.eu-west-1.compute.amazonaws.com
    20:14:05 Creating 10G EBS image volume in eu-west-1b...
    20:14:08 Created vol-70a16a19
    20:14:08 Attaching image volume...
    20:14:12 Waiting for instance boot and SSH.......
    20:14:37 Uploading image...
    Warning: Permanently added 'ec2-79-125-65-52.eu-west-1.compute.amazonaws.com,79.125.65.52' (RSA) to the list of known hosts.
    Amazon_SLES11.x86_64-0.0.4.ec2.tar.gz                                           100%   92MB  11.5MB/s   00:08
    20:14:46 Extracting image...
    20:15:36 Writing image to vol-70a16a19 (may take a few minutes)...
    20:15:37 Stopping instance i-4d0a563a.......
    20:16:10 Detaching root volume vol-7aa16a13...
    20:16:14 Detaching image volume vol-70a16a19...
    20:16:21 Attaching vol-70a16a19 as root volume...
    20:16:28 Creating AMI with name='a63-Amazon_SLES11.x86_64-0.0.6'
    20:16:31 Created ami-e04f7a94
    20:16:31 Cleaning up...
    20:16:31 Terminating instance i-4d0a563a...
    20:16:38 Removing root volume vol-7aa16a13...
    20:16:42 Removing image volume vol-70a16a19...
    20:16:43 Removing SSH keypair suse-studio.7t0KnY0zjn...
    20:16:45 Created new EBS-backed AMI. May take several minutes for AMI to be ready.
    20:16:45 AMI: ami-e04f7a94, region: eu-west-1.



Feedback / Bug reports
-----------------------

Please send your bug reports, questions, feedback, and suggestions to
feedback@susestudio.com.
