#!/usr/bin/env ruby
require 'json'
require 'fileutils'
require 'erb'

# Generate zabbix template method
def output (a)
  open("./#{a}.xml", 'w+') { |f| f.chmod(0755)
    template=IO.read("./templates/#{a}.xml.erb")
    x = ERB.new(template).result(binding)
    f << "#{x}\n"
  }
end

################################################################################################
#                                                                                              #  
#   Create Multiple Zabbix Templates Method                                                    #
################################################################################################
def self.multipleTemplates
  file = File.read('./services.json')
  data_hash = JSON.parse(file)

  service = data_hash.keys
  service.each do |microservice|
    puts "Microservice: #{microservice}"
    adminport = data_hash["#{microservice}"]['adminport']
    puts "AdminPort: #{adminport}"

    port = data_hash["#{microservice}"]['ports']
    ports = port.split","
    ports.each do |p|
      puts "Listen on port: #{p}"
    end
    
    open("./#{microservice}.xml", 'w+') { |f| f.chmod(0755)
      template=IO.read('./templates/healthcheck.xml.erb')
      x = ERB.new(template).result(binding)
      f << "#{x}\n"
    }
  end 
end

################################################################################################
#                                                                                              #  
#   Create Single Zabbix Template Method                                                       #
################################################################################################
def self.singleTemplate
  microservice, *ports = ARGV
  adminport = ARGV[1]
  puts "Microservice: #{microservice}"
  puts "AdminPort: #{adminport}"

  ports.each do |p|
    puts "Listen to port: #{p}"
  end

  def is_a_number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

  if !is_a_number?(microservice)
    open("#{microservice}.xml", 'w+') { |f| f.chmod(0755)
      template=IO.read('./templates/healthcheck.xml.erb')
      x = ERB.new(template).result(binding)
      f << "#{x}\n"
    }
  else
    puts "You should set a string as a fisrt argument! This will be the microservice name! Please run again the script!\n"
    usage
    exit
  end

  output = "#{microservice}.xml"
  if File.exist?(output)
    puts "#{microservice}.xml template was succesfully generated!"
  else
    puts "Error! Template for #{microservice} was not generated."
    exit
  end
end

################################################################################################
#                                                                                              #  
#   Create HAProxy Zabbix Templates Method                                                     #
################################################################################################
def self.haproxyTemplates
  file = File.read('./services.json')
  data_hash = JSON.parse(file)

  service = data_hash.keys
  service.each do |microservice|
    puts "Microservice: #{microservice}"
    httpport = data_hash["#{microservice}"]['httpport']
    puts "httpPort: #{httpport}"
    haproxyport = data_hash["#{microservice}"]['haproxyport']
    puts "HAProxy Stats Port: #{haproxyport}"
    lbbackend = data_hash["#{microservice}"]['loadbalancer']
    puts "Loadbalancer: #{lbbackend}"

    node = data_hash["#{microservice}"]['nodes']
    nodes = node.split","
    nodes.each do |n|
      puts "Check HAProxy on nodes: #{n}"
    end
  end
  
  open("./haproxy.xml", 'w+') { |f| f.chmod(0755)
    template=IO.read('./templates/haproxy.xml.erb')
    x = ERB.new(template).result(binding)
    f << "#{x}\n"
  } 
end

################################################################################################
#                                                                                              #  
#   Create HTTP Zabbix Template Method                                                         #
################################################################################################
def self.httpTemplates
  microservice = ARGV[1]
  puts "Microservice: #{microservice}"
  open("./#{microservice}http.xml", 'w+') { |f| f.chmod(0755)
    template=IO.read('./templates/http.xml.erb')
    x = ERB.new(template).result(binding)
    f << "#{x}\n"
  } 
end

################################################################################################
#                                                                                              #  
#   Create MySQL Zabbix Template Method                                                        #
################################################################################################
def self.mysqlTemplates
  output ('mysql')
end
 
################################################################################################
#                                                                                              #  
#   Create Mongo Zabbix Templates Method                                                       #
################################################################################################
def self.mongoTemplates
  output ('mongos')
  output ('mongod')
end

################################################################################################
#                                                                                              #  
#   Create RabbitMQ Zabbix Template Method                                                     #
################################################################################################
def self.rabbitmqTemplates
  output ('rabbitmq')
end

################################################################################################
#                                                                                              #  
#   Create OS Zabbix Templates Method                                                          #
################################################################################################
def self.osTemplates
  output ('linuxOS')
  output ('windowsOS')
end

################################################################################################
#                                                                                              #  
#   Create SFTP Zabbix Template Method                                                         #
################################################################################################
def self.sftpTemplates
  output ('sftp')
end

################################################################################################
#                                                                                              #  
#   Parse the Arguments                                                                        #
################################################################################################
def self.usage
   puts "\nUsage:"
   puts "Please run script with arguments for a single microservice: ./templategen.rb microservice adminPort port2 port3"
   puts "Please run script with 'services' argument for all the microservices listed in service.json file: ./templategen.rb services"
   puts "Please run script with 'haproxy' argument for HAProxy Zabbix template with the microservices listed in service.json file: ./templategen.rb haproxy"
   puts "Please run script with 'http' argument and 'microservice' argument for http microservice templates: ./templategen.rb http dora"
   puts "Please find templategen.rb other arguments: mysql, mongo, rabbitmq, os, sftp\n"
   puts "\n"
   exit
end

if ARGV.empty? then
  usage
end

case ARGV[0]
  when '--help','-h'
    usage
  when 'services','service'
    STDOUT.puts "Start generating zabbix templates for microservices..."
    multipleTemplates
    STDOUT.puts "Done!"
  when "haproxy"
    STDOUT.puts "Start generating zabbix templates for HAProxy microservices..."
    haproxyTemplates
    STDOUT.puts "Done!"
  when "http"
    STDOUT.puts "Start generating MySQL template..."
    httpTemplates
    STDOUT.puts "Done!"
  when "mysql"
    STDOUT.puts "Start generating MySQL template..."
    mysqlTemplates
    STDOUT.puts "Done!"
  when "mongo"
    STDOUT.puts "Start generating mongo templates..."
    mongoTemplates
    STDOUT.puts "Done!"
  when "rabbitmq"
    STDOUT.puts "Start generating RabbitMQ template..."
    rabbitmqTemplates
    STDOUT.puts "Done!"
  when "os"
    STDOUT.puts "Start generating Linux & Windows OS templates..."
    osTemplates
    STDOUT.puts "Done!"
  when "sftp"
    STDOUT.puts "Start generating SFTP template..."
    sftpTemplates
    STDOUT.puts "Done!"
  else
    STDOUT.puts "Start generating template..."
    singleTemplate
    STDOUT.puts "Done!"
end
