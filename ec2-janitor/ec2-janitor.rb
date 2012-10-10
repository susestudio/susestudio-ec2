#!/usr/bin/env ruby
#
# Ruby script for managing openSUSE Amazon EC2 account and AMIs.
#
# See README.md for details.
#
# Author: Christoph Thiel <cthiel@suse.com>
# Author: James Tan <jatan@suse.com>

require 'rubygems'
require 'bundler/setup'
require 'aws-sdk'
require 'terminal-table/import'
require 'yaml'
require 'thor'

def suppress_warnings
  v = $VERBOSE
  $VERBOSE = nil
  yield
ensure
  $VERBOSE = v
end

class Ec2Janitor < Thor

  # Workaround for Ruby SSL problem
  suppress_warnings do
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  end

  CONFIG_FILE = 'config.yml'

  desc "instances", "Displays active instances in all regions"
  def instances
    results = []
    threaded_regions do |region|
      region.instances.each do |instance|
        next if instance.status == :terminated
        results << [
          region.name, instance.id, instance.instance_type, instance.ip_address,
          instance.status, instance.launch_time
        ]
      end
    end
    if results.empty?
      puts "No instances"
    else
      puts table(['Region','Instance ID', 'Type', 'IP', 'Status', 'Launch time'],
           *results.sort_by{ |k| k.last })
    end
  end

  desc "images", "Displays images in all regions"
  def images
    results = []
    threaded_regions do |region|
      region.images.with_owner('self').each do |image|
        results << [ region.name, image.name, image.id,
                     (image.public? ? 'Public' : 'Private') ]
      end
    end
    if results.empty?
      puts "No images"
    else
      puts table(['Region', 'Name', 'AMI ID', 'Perms'],
                 *results.sort_by{ |k| [k[0], k[1]] })
    end
  end

  desc "textile VERSION ARCH", "Output matching openSUSE AMI IDs from all regions in Textile format. Useful for SUSE Gallery descriptions.\nVERSION is the openSUSE release version (eg. 12.2).\nARCH is the AMI architecture (i386, x86_64)."
  def textile(version, arch)
    arch = arch.to_sym
    region_map = {
      'ap-northeast-1' => '!http://bit.ly/OTd2gE! &nbsp; Asia Pacific (Tokyo)',
      'ap-southeast-1' => '!http://bit.ly/VOQCi3! &nbsp; Asia Pacific (Singapore) &nbsp;&nbsp;&nbsp;',
      'eu-west-1'      => '!http://bit.ly/WQHpno! &nbsp; EU West (Ireland)',
      'sa-east-1'      => '!http://bit.ly/QcQdRT! &nbsp; S. America (Sao Paulo)',
      'us-east-1'      => '!http://bit.ly/UR3hfC! &nbsp; US East (Virginia)',
      'us-west-1'      => '!http://bit.ly/UR3hfC! &nbsp; US West (N. California)',
      'us-west-2'      => '!http://bit.ly/UR3hfC! &nbsp; US West (Oregon)'
    }
    results = []
    threaded_regions do |region|
      region.images.with_owner('self').each do |image|
        next unless image.public? && image.name =~ /openSUSE-#{version}/ && image.architecture == arch
        results << [ region.name, image.id ]
      end
    end
    puts "| *Region* | *Region ID* | *AMI ID* |"
    results.sort_by{ |k| [k[0], k[1]] }.each do |k|
      puts "| #{region_map[k[0]]} | @#{k[0]}@ &nbsp;&nbsp; | @#{k[1]}@ |"
    end
  end

  desc "html VERSION", "Output matching openSUSE AMI IDs from all regions in HTML format. Useful for blog posts.\nVERSION is the openSUSE release version (eg. 12.2)."
  def html(version)
    country_map = {
      'ap-northeast-1' => 'tk', 'ap-southeast-1' => 'sg', 'eu-west-1' => 'eu',
      'sa-east-1'      => 'sa', 'us-east-1'      => 'us', 'us-west-1' => 'us',
      'us-west-2'      => 'us'
    }
    region_map = {
      'ap-northeast-1' => 'Asia Pacific (Tokyo)',
      'ap-southeast-1' => 'Asia Pacific (Singapore)',
      'eu-west-1'      => 'EU West (Ireland)',
      'sa-east-1'      => 'S. America (Sao Paulo)',
      'us-east-1'      => 'US East (Virginia)',
      'us-west-1'      => 'US West (N. California)',
      'us-west-2'      => 'US West (Oregon)'
    }

    results = []
    threaded_regions do |region|
      region.images.with_owner('self').each do |image|
        next unless image.public? && image.name =~ /openSUSE-#{version}/
        results << [ region.name, image.architecture, image.id ]
      end
    end

    puts <<-EOS
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
    EOS
    results.sort_by{|k| [k[0], k[1]]}.each do |k|
      puts <<-EOS
        <tr>
          <td class="region-#{country_map[k[0]]}">#{region_map[k[0]]}</td>
          <td><tt>#{k[0]}</tt></td>
          <td><tt>#{k[1]}</tt></td>
          <td><tt>#{k[2]}</tt></td>
        </tr>
      EOS
    end
    puts <<-EOS
        </tbody>
      </table>
      <div class="caption">List of openSUSE #{version} AMI IDs.</div>
    EOS
  end


  private

  def check_config
    unless File.exists? CONFIG_FILE
      puts "Missing #{CONFIG_FILE}!"
      puts "Please create it and place your Amazon EC2 API credentials there in the"
      puts "following form:"
      puts "  access_key_id:     AGSA1232ASDFHTRT1441"
      puts "  secret_access_key: Aia24sadfag34t634kjhawkfjdhhsgfkj2345gkj"
      exit 1
    end
  end

  def threaded_regions
    check_config
    AWS.config(YAML.load_file(CONFIG_FILE))
    @ec2 = AWS::EC2.new

    threads = []
    @ec2.regions.each do |region|
      threads << Thread.new{ yield region }
    end
    threads.map(&:join)
  end
end

Ec2Janitor.start
