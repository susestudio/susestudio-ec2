Amazon EC2 scripts for SUSE Studio built images
================================================

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
Simple bash script for creating public openSUSE AMIs in all Amazon EC2 regions,
from a single Studio built EC2 image. This is used for creating all the
official openSUSE AMIs in Amazon EC2, under the owner ID 056126556840.

Details of the previous public openSUSE AMI releases can be found in the
following blog posts:

  * [Public AMIs based on openSUSE 12.1](http://blog.susestudio.com/2012/07/public-amis-based-on-opensuse-121.html)
  * [Update for openSUSE 11.4 AMIs on EC2](http://blog.susestudio.com/2011/06/we-updated-all-opensuse-11.html)
  * [openSUSE 11.4 for Amazon EC2](http://blog.susestudio.com/2011/03/opensuse-114-for-amazon-ec2.html)
  * [Public openSUSE 11.3 AMIs](http://blog.susestudio.com/2011/02/public-opensuse-113-amis.html)


run-and-connect
----------------
Bash script for launching the specific Amazon Machine Image (AMI) and
connecting to it. Automatically termintes the instance upon logout. This is
intended for easy testing of AMIs.
