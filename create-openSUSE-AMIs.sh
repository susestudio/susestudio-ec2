#!/bin/bash
#
# Simple bash script for creating public openSUSE AMIs in all Amazon EC2
# regions, from a Studio built openSUSE image.
#
# It assumes that the image tarball is in the form
# 'Amazon_Machine_Image_AMI_12.1_32bit.i686-3.0.0.ec2.tar.gz', and parses the
# filename to extract the openSUSE version (eg. 12.2), image version (eg.
# 4.0.0) and architecture (i686 or x86_64).
#
# See https://github.com/susestudio/susestudio-ec2 for details and examples.
#
# Author: James Tan <jatan@suse.com>

usage() {
  echo >&2 "Usage: create-openSUSE-AMIs TARBALL"
  echo >&2 "  where TARBALL is in the form 'Amazon_Machine_Image_AMI_12.1_32bit.i686-3.0.0.ec2.tar.gz'"
}

if [ $# -eq 0 ]; then
  usage
  exit 1
fi

tarball=$1

arch=${tarball%%-*}
arch=${arch%%-*}
arch=${arch##*.}
[ "$arch" = "i686" ] && arch=i386

version=${tarball%%.ec2.tar.gz}
version=${version##*-}

base=${tarball#*Amazon_Machine_Image_AMI_*}
base=${base%%_*}

echo "  tarball: $tarball"
echo "     base: $base"
echo "     arch: $arch"
echo "  version: $version"

for region in \
  ap-northeast-1 \
  ap-southeast-1 \
  eu-west-1 \
  sa-east-1 \
  us-east-1 \
  us-west-1 \
  us-west-2
do
  name="openSUSE-$base-v$version.$arch"
  echo
  echo "Creating $name in $region..."
  ./susestudio/create_ami.sh.in \
    --tarball $tarball \
    --region  $region  \
    --name    $name    \
    --base    $base    \
    --arch    $arch    \
    --test_ami         \
    --public  2>&1 | tee upload_images.log
done
