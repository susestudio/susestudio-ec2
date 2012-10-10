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


Displaying list of AMIs in all regions
---------------------------------------

Sample output:

    jamestyj@sentosa:~> ./ec2-janitor.rb images
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
