#!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'
require 'aws-sdk'
require 'terminal-table/import'
require 'yaml'

# FIXME Temp workaround for Ruby SSL problem
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

CONFIG_FILE = 'config.yml'

unless File.exists? CONFIG_FILE
  puts "Missing #{CONFIG_FILE}!"
  puts "Please create it and place your Amazon EC2 API credentials there in the"
  puts "following form:"
  puts "  access_key_id:     AGSA1232ASDFHTRT1441"
  puts "  secret_access_key: Aia24sadfag34t634kjhawkfjdhhsgfkj2345gkj"
  exit 1
end

AWS.config(YAML.load_file(CONFIG_FILE))

@ec2 = AWS::EC2.new

def check_instances
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

def check_images
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

def threaded_regions
  threads = []
  @ec2.regions.each do |region|
    threads << Thread.new{ yield region }
  end
  threads.map(&:join)
end

puts "Checking active instances..."
check_instances

puts "\nChecking AMIs..."
check_images
