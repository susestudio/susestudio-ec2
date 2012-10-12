ec2-janitor
============

Amazon EC2 janitor script for managing the openSUSE EC2 account and AMIs. Also
useful for other purposes, eg. to keep EC2 accounts clean. API requests to each
Amazon EC2 region is peformed in parallel to save time.

Usage overview:

    jamestyj@sentosa:~> ./ec2-janitor.rb
    Tasks:
      ec2-janitor.rb help [TASK]           # Describe available tasks or one specific task
      ec2-janitor.rb html VERSION          # Output matching openSUSE AMI IDs from all regions in HTML format. Useful for blog posts...
      ec2-janitor.rb images                # Displays images in all regions
      ec2-janitor.rb instances             # Displays active instances in all regions
      ec2-janitor.rb textile VERSION ARCH  # Output matching openSUSE AMI IDs from all regions in Textile format. Useful for SUSE Ga...


Managing instances in all regions
----------------------------------

Usage:

    jamestyj@sentosa:~> ./ec2-janitor.rb help instances
    Usage:
      ec2-janitor.rb instances

    Options:
      [--terminate=N]  # Terminate instances that exceed N minutes of elapsed time.

    Displays instances in all regions. Optionally terminates those that exceed the specified time.


### Display instances in all regions

Sample output:

    jamestyj@sentosa:~> ./ec2-janitor.rb instances
    +-----------+-------------+----------+---------------+---------+-------------------------+---------------------+
    | Region    | Instance ID | Type     | IP            | Status  | Launch time             | Elapsed             |
    +-----------+-------------+----------+---------------+---------+-------------------------+---------------------+
    | eu-west-1 | i-2024856b  | t1.micro | 54.247.63.243 | running | 2012-10-10 16:50:27 UTC | 19 mins and 13 secs |
    | us-west-2 | i-a5bae696  | t1.micro | 54.245.54.96  | running | 2012-10-10 16:50:03 UTC | 19 mins and 37 secs |
    +-----------+-------------+----------+---------------+---------+-------------------------+---------------------+


### Terminate instances that exceed elapsed threshold

Sample output:

    jamestyj@sentosa:~> ./ec2-janitor.rb instances --terminate=10
    +-----------+-------------+----------+---------------+---------+-------------------------+---------------------+
    | Region    | Instance ID | Type     | IP            | Status  | Launch time             | Elapsed             |
    +-----------+-------------+----------+---------------+---------+-------------------------+---------------------+
    | eu-west-1 | i-2024856b  | t1.micro | 54.247.63.243 | running | 2012-10-10 16:50:27 UTC | 34 mins and 30 secs |
    | us-west-2 | i-a5bae696  | t1.micro | 54.245.54.96  | running | 2012-10-10 16:50:03 UTC | 34 mins and 54 secs |
    +-----------+-------------+----------+---------------+---------+-------------------------+---------------------+
    Terminated instances: i-2024856b, i-a5bae696


Managing AMIs in all regions
-----------------------------

Sample output:

    jamestyj@sentosa:~> ./ec2-janitor.rb images --prune
    +----------------+-----------------------------+--------------+---------+
    | Region         | Name                        | AMI ID       | Perms   |
    +----------------+-----------------------------+--------------+---------+
    | ap-northeast-1 | openSUSE-12.1-v3.0.0.i386   | ami-aa3d8fab | Public  |
    | ap-northeast-1 | openSUSE-12.1-v3.0.0.x86_64 | ami-58229059 | Public  |
    | ap-northeast-1 | openSUSE-12.2-v4.0.0.i386   | ami-5463dc55 | Public  |
    | ap-northeast-1 | openSUSE-12.2-v4.0.0.x86_64 | ami-fa63dcfb | Public  |
    | ap-southeast-1 | openSUSE-12.1-v3.0.0.i386   | ami-6c6a2b3e | Public  |
    | ap-southeast-1 | openSUSE-12.1-v3.0.0.x86_64 | ami-d86a2b8a | Public  |
    | ap-southeast-1 | openSUSE-12.2-v4.0.0.i386   | ami-7eacec2c | Public  |
    | ap-southeast-1 | openSUSE-12.2-v4.0.0.x86_64 | ami-30acec62 | Public  |
    | eu-west-1      | a46Romans_JeOSx86_64001     | ami-850203f1 | Private |
    | eu-west-1      | a46Romans_JeOSx86_64005     | ami-65e5e411 | Private |
    | eu-west-1      | a76428911sp2ec2x64x86_64002 | ami-116b6a65 | Private |
    | eu-west-1      | openSUSE-12.1-v3.0.0.i386   | ami-055e5971 | Public  |
    | eu-west-1      | openSUSE-12.1-v3.0.0.x86_64 | ami-0f5d5a7b | Public  |
    | eu-west-1      | openSUSE-12.2-v4.0.0.i386   | ami-9b0000ef | Public  |
    | eu-west-1      | openSUSE-12.2-v4.0.0.x86_64 | ami-d50101a1 | Public  |
    | sa-east-1      | openSUSE-12.1-v3.0.0.i386   | ami-2e429c33 | Public  |
    | sa-east-1      | openSUSE-12.1-v3.0.0.x86_64 | ami-26429c3b | Public  |
    | sa-east-1      | openSUSE-12.2-v4.0.0.i386   | ami-6c0ad371 | Public  |
    | sa-east-1      | openSUSE-12.2-v4.0.0.x86_64 | ami-8c0ad391 | Public  |
    | us-east-1      | openSUSE-12.1-v3.0.0.i386   | ami-6bed4502 | Public  |
    | us-east-1      | openSUSE-12.1-v3.0.0.x86_64 | ami-b5ed45dc | Public  |
    | us-east-1      | openSUSE-12.2-v4.0.0.i386   | ami-5cfe4135 | Public  |
    | us-east-1      | openSUSE-12.2-v4.0.0.x86_64 | ami-46f7482f | Public  |
    | us-west-1      | openSUSE-12.1-v3.0.0.i386   | ami-d3a38696 | Public  |
    | us-west-1      | openSUSE-12.1-v3.0.0.x86_64 | ami-6fa2872a | Public  |
    | us-west-1      | openSUSE-12.2-v4.0.0.i386   | ami-23c2e566 | Public  |
    | us-west-1      | openSUSE-12.2-v4.0.0.x86_64 | ami-ebc2e5ae | Public  |
    | us-west-2      | openSUSE-12.1-v3.0.0.i386   | ami-865cd3b6 | Public  |
    | us-west-2      | openSUSE-12.1-v3.0.0.x86_64 | ami-fe5cd3ce | Public  |
    | us-west-2      | openSUSE-12.2-v4.0.0.i386   | ami-c6ca43f6 | Public  |
    | us-west-2      | openSUSE-12.2-v4.0.0.x86_64 | ami-62cd4452 | Public  |
    +----------------+-----------------------------+--------------+---------+
    Deleted private AMIs: ami-116b6a65, ami-65e5e411, ami-850203f1


Managing volumes in all regions
--------------------------------

Sample output:

    jamestyj@sentosa:~> ./ec2-janitor.rb volumes --prune=3600
    +------------+--------------+-------+-----------+-------------------------+
    | Zone       | Volume ID    | Size  | Status    | Created                 |
    +------------+--------------+-------+-----------+-------------------------+
    | eu-west-1a | vol-1007003b | 5 GB  | available | 2012-09-10 14:22:05 UTC |
    | eu-west-1a | vol-a8c8df83 | 16 GB | available | 2012-09-18 18:08:50 UTC |
    | eu-west-1a | vol-d9ee09f3 | 16 GB | available | 2012-09-26 13:27:44 UTC |
    | eu-west-1a | vol-e87e79c3 | 12 GB | available | 2012-09-10 14:09:34 UTC |
    | eu-west-1b | vol-2daaa106 | 16 GB | available | 2012-09-16 19:15:03 UTC |
    | eu-west-1b | vol-974349bc | 16 GB | available | 2012-09-16 21:47:50 UTC |
    | eu-west-1c | vol-6137304a | 16 GB | available | 2012-09-10 16:18:03 UTC |
    | eu-west-1c | vol-f3909bd8 | 16 GB | available | 2012-09-16 18:58:18 UTC |
    +------------+--------------+-------+-----------+-------------------------+
    Deleted volumes: vol-e87e79c3, vol-1007003b, vol-6137304a, vol-f3909bd8, vol-2daaa106, vol-974349bc, vol-a8c8df83, vol-d9ee09f3


Managing snapshots in all regions
----------------------------------

Sample output:

    jamestyj@sentosa:ec2-janitor(master)> ./ec2-janitor.rb  snapshots --prune=3600
    +----------------+---------------+--------------+------+-----------+-------------------------+
    | Zone           | Snapshot ID   | Volume ID    | Size | Status    | Started                 |
    +----------------+---------------+--------------+------+-----------+-------------------------+
    | ap-northeast-1 | snap-3ab4c11b | vol-94ba85b7 | 5 GB | completed | 2012-10-09 16:04:06 UTC |
    | ap-northeast-1 | snap-53cc9b3d | vol-314c5851 | 5 GB | completed | 2012-07-26 17:49:30 UTC |
    | ap-northeast-1 | snap-79661358 | vol-22c7f801 | 5 GB | completed | 2012-10-09 14:50:40 UTC |
    | ap-northeast-1 | snap-cf7024a1 | vol-adf4e1cd | 5 GB | completed | 2012-07-26 15:55:06 UTC |
    | ap-southeast-1 | snap-23c17a4c | vol-210c4844 | 5 GB | completed | 2012-07-26 15:42:22 UTC |
    | ap-southeast-1 | snap-376cd758 | vol-5d92d638 | 5 GB | completed | 2012-07-26 17:50:15 UTC |
    | ap-southeast-1 | snap-5fd5ef7b | vol-c2c252e6 | 5 GB | completed | 2012-10-09 15:02:35 UTC |
    | ap-southeast-1 | snap-fac2f8de | vol-18f0603c | 5 GB | completed | 2012-10-09 16:15:40 UTC |
    | eu-west-1      | snap-14075142 | vol-49966e63 | 5 GB | completed | 2012-10-09 16:24:27 UTC |
    | eu-west-1      | snap-7d8d9b16 | vol-c0b5e3a8 | 5 GB | completed | 2012-07-26 17:35:15 UTC |
    | eu-west-1      | snap-bde8fed6 | vol-5295c33a | 5 GB | completed | 2012-07-26 15:31:28 UTC |
    | eu-west-1      | snap-c8e3b49e | vol-c5b34bef | 5 GB | completed | 2012-10-09 15:13:22 UTC |
    | sa-east-1      | snap-060a3a37 | vol-ed9927d2 | 5 GB | completed | 2012-10-09 15:24:12 UTC |
    | sa-east-1      | snap-1776377f | vol-92da64ff | 5 GB | completed | 2012-07-26 17:35:43 UTC |
    | sa-east-1      | snap-c10b3bf0 | vol-758a344a | 5 GB | completed | 2012-10-09 16:34:47 UTC |
    | sa-east-1      | snap-e374358b | vol-76e6581b | 5 GB | completed | 2012-07-26 17:20:55 UTC |
    | us-east-1      | snap-1a0f076b | vol-72330e13 | 5 GB | completed | 2012-07-26 16:18:51 UTC |
    | us-east-1      | snap-7fb2ae0b | vol-a60e3ddc | 5 GB | completed | 2012-10-09 16:44:51 UTC |
    | us-east-1      | snap-d90f1dad | vol-2cdfee56 | 5 GB | completed | 2012-10-09 13:02:09 UTC |
    | us-east-1      | snap-ea21299b | vol-761f2217 | 5 GB | completed | 2012-07-26 16:41:41 UTC |
    | us-west-1      | snap-2fd1a603 | vol-35c0941b | 5 GB | completed | 2012-10-09 15:35:36 UTC |
    | us-west-1      | snap-405b6a26 | vol-d79e57ae | 5 GB | completed | 2012-07-26 17:49:11 UTC |
    | us-west-1      | snap-7c23151a | vol-ef8d4396 | 5 GB | completed | 2012-07-26 14:58:42 UTC |
    | us-west-1      | snap-813442ad | vol-16f9ad38 | 5 GB | completed | 2012-10-09 16:53:05 UTC |
    | us-west-2      | snap-30913a16 | vol-bd2d709b | 5 GB | completed | 2012-10-09 15:47:18 UTC |
    | us-west-2      | snap-b264cf94 | vol-02590424 | 5 GB | completed | 2012-10-09 17:04:07 UTC |
    | us-west-2      | snap-c737f9ad | vol-b1f5e4dd | 5 GB | completed | 2012-07-26 17:01:14 UTC |
    | us-west-2      | snap-ff8a4395 | vol-69b0a105 | 5 GB | completed | 2012-07-26 17:36:21 UTC |
    +----------------+---------------+--------------+------+-----------+-------------------------+
    Snapshots still in use: snap-1a0f076b, snap-ea21299b, snap-bde8fed6, snap-e374358b, snap-d90f1dad, snap-7c23151a, snap-23c17a4c, snap-7d8d9b16, snap-c737f9ad, snap-7fb2ae0b, snap-1776377f, snap-c8e3b49e, snap-cf7024a1, snap-376cd758, snap-ff8a4395, snap-405b6a26, snap-14075142, snap-060a3a37, snap-5fd5ef7b, snap-53cc9b3d, snap-30913a16, snap-2fd1a603, snap-c10b3bf0, snap-fac2f8de, snap-813442ad, snap-b264cf94, snap-79661358, snap-3ab4c11b


Generating Textile table of AMI IDs
------------------------------------

The HTML table in Textile syntax used in the SUSE Gallery descriptions can be
generated with this script. The usage is:

    jamestyj@sentosa:~> ./ec2-janitor.rb help textile
    Usage:
      ec2-janitor.rb textile VERSION ARCH

    Output matching openSUSE AMI IDs from all regions in Textile format. Useful for SUSE Gallery descriptions.
    VERSION is the openSUSE release version (eg. 12.2).
    ARCH is the AMI architecture (i386, x86_64).

Sample output:

    jamestyj@sentosa:~> ./ec2-janitor.rb textile 12.2 x86_64
    | *Region* | *Region ID* | *AMI ID* |
    | !http://bit.ly/OTd2gE! &nbsp; Asia Pacific (Tokyo) | @ap-northeast-1@ &nbsp;&nbsp; | @ami-fa63dcfb@ |
    | !http://bit.ly/VOQCi3! &nbsp; Asia Pacific (Singapore) &nbsp;&nbsp;&nbsp; | @ap-southeast-1@ &nbsp;&nbsp; | @ami-30acec62@ |
    | !http://bit.ly/WQHpno! &nbsp; EU West (Ireland) | @eu-west-1@ &nbsp;&nbsp; | @ami-d50101a1@ |
    | !http://bit.ly/QcQdRT! &nbsp; S. America (Sao Paulo) | @sa-east-1@ &nbsp;&nbsp; | @ami-8c0ad391@ |
    | !http://bit.ly/UR3hfC! &nbsp; US East (Virginia) | @us-east-1@ &nbsp;&nbsp; | @ami-46f7482f@ |
    | !http://bit.ly/UR3hfC! &nbsp; US West (N. California) | @us-west-1@ &nbsp;&nbsp; | @ami-ebc2e5ae@ |
    | !http://bit.ly/UR3hfC! &nbsp; US West (Oregon) | @us-west-2@ &nbsp;&nbsp; | @ami-62cd4452@ |


Generating HTML table of AMI IDs
---------------------------------

The HTML table in the Studio blog can be generated with this script. The usage
is:

    jamestyj@sentosa:~> ./ec2-janitor.rb help html
    Usage:
      ec2-janitor.rb html VERSION

    Output matching openSUSE AMI IDs from all regions in HTML format. Useful for blog posts.
    VERSION is the openSUSE release version (eg. 12.2).

For example:

    jamestyj@sentosa:~> ./ec2-janitor.rb html 12.2
      <style type="text/css">
        #ami-table       { border: 1px solid gray; border-spacing: 0; }
        #ami-table th    { border-bottom: 1px solid gray; }
        #ami-table th,td { padding: 1px 10px 1px 10px; }
        #ami-table tt    { font-size: medium; }
        #ami-table td.region-us, td.region-eu, td.region-sg, td.region-tk, td.region-sa {
          padding-left: 30px; background-position: 12px 4px; background-repeat: no-repeat;
        }
        #ami-table td.region-us { background-image: url('http://bit.ly/UR3hfC'); }
        #ami-table td.region-eu { background-image: url('http://bit.ly/WQHpno'); }
        #ami-table td.region-sg { background-image: url('http://bit.ly/VOQCi3'); }
        #ami-table td.region-tk { background-image: url('http://bit.ly/OTd2gE'); }
        #ami-table td.region-sa { background-image: url('http://bit.ly/QcQdRT'); }
        .caption { text-align: center; padding-top: 3px; margin-left: -30px}
      </style>
      <table id="ami-table">
        <tbody>
          <tr>
            <th>Region</th>
            <th>Region ID</th>
            <th>Arch</th>
            <th>AMI ID</th>
          </tr>
        <tr>
          <td class="region-tk">Asia Pacific (Tokyo)</td>
          <td><tt>ap-northeast-1</tt></td>
          <td><tt>i386</tt></td>
          <td><tt>ami-5463dc55</tt></td>
        </tr>
        <tr>
          <td class="region-tk">Asia Pacific (Tokyo)</td>
          <td><tt>ap-northeast-1</tt></td>
          <td><tt>x86_64</tt></td>
          <td><tt>ami-fa63dcfb</tt></td>
        </tr>
        <tr>
          <td class="region-sg">Asia Pacific (Singapore)</td>
          <td><tt>ap-southeast-1</tt></td>
          <td><tt>i386</tt></td>
          <td><tt>ami-7eacec2c</tt></td>
        </tr>
        ...
        </tbody>
      </table>
      <div class="caption">List of openSUSE 12.2 AMI IDs.</div>
