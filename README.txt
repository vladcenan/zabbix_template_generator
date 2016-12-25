# Microservice Template Generator for Zabbix Monitor

  TODO: ruby templategen.rb
        ./templategen.rb

  Usage:
  Please run script with arguments for a single microservice: ./templategen.rb microservice adminPort port2 port3
  Please run script with 'services' argument for all the microservices listed in service.json file: ./templategen.rb services 
  Please run script with 'haproxy' argument for HAProxy Zabbix template with the microservices listed in service.json file: ./templategen.rb haproxy
  Please run script with 'http' argument and 'microservice' argument for http microservice templates: ./templategen.rb http microservice 
  Please find templategen.rb other arguments: mysql, mongo, rabbitmq, os, sftp

  Please populate the json file in the exact form that is populated now (json format)

  Please note:
  microservice1, microservice2 -> are the key values for creating any kind of zabbix templates 
  adminport, ports -> are mandatory for creating healthcheck templates for microservices added in services.json 
  httpport, haproxyport, loadbalancer, nodes -> are mandatory for creating HAProxy healthchecks template for the microservices added in services.json 

# Supported Platforms
  
  Linux & Ruby Environment
  Gems: json, erb, fileutils

# License and Authors

  Author:: Vlad Cenan 
