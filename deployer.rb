require 'yaml'
require 'git'
require 'fileutils'
require 'net/scp'
require 'net/ssh'

if ARGV.length && ARGV[0] == '-h'
  puts 'Usage:  deployer.rb  OR deployer.rb <config_file.yml>'
end

config_file = ARGV[0] ? ARGV[0] : 'config.yml'

unless File.exists?(config_file)
  puts 'Invalid config file'
  exit(false)
end

config = YAML.load_file(config_file)
deployment_directory = config['deployment-directory']

applications = []
config['applications'].each_key { |app| applications << app }

app_choice = nil

while !(1..applications.length).to_a.include?(app_choice.to_i)
  puts 'Invalid Selection' unless app_choice === nil
  puts 'Select your desired application:'
  applications.each_with_index do |application, i|
    puts "#{i + 1} #{application.to_s}"
  end

  $stdout.flush
  puts ''

  app_choice = gets.chomp
end

application_name = applications[app_choice.to_i - 1]
configured_app = config['applications'][application_name]
application_directory = "#{deployment_directory}/#{application_name}"

FileUtils.makedirs(deployment_directory) unless File.directory?(deployment_directory)

if File.directory?(application_directory)
  puts '-- Fetching latest --'
  g = Git.open(application_directory)
  g.reset_hard
  g.fetch
  g.checkout('master')
else
  puts '-- Cloning project --'
  Git.clone(configured_app['git'], application_name, path: deployment_directory)
end

servers = []
configured_app['build-commands'].each_key { |server| servers << server }

server_choice = nil

while !(1..servers.length).to_a.include?(server_choice.to_i)
  puts 'Invalid Selection' unless server_choice === nil
  puts "Where should #{application_name} be deployed:"
  servers.each_with_index do |server, i|
    puts "#{i + 1} #{server.to_s}"
  end

  $stdout.flush
  puts ''

  server_choice = gets.chomp
end

server = servers[server_choice.to_i - 1]
build_commands = configured_app['build-commands'][server]

if build_commands.length
  build_commands.insert(0, "cd #{application_directory}")
  status = system(build_commands.join(' && '))

  unless status
    puts '-- Error during build steps --'
    exit(false)
  end
end

remote_server = config['servers'][server]


if configured_app['file-to-deploy']
  puts '-- Uploading file --'
  Net::SCP.upload!(remote_server['url'],
                   remote_server['user'],
                   "#{application_directory}/#{configured_app['file-to-deploy']}",
                   configured_app['file-deploy-location'],
                   {ssh: {port: remote_server['port']}})
  puts '-- File uploaded --'
end

if configured_app['ssh-commands']
  puts '-- Running ssh commands --'
  Net::SSH.start(remote_server['url'], remote_server['user'], port: remote_server['port']) do |ssh|
    output = ssh.exec! configured_app['ssh-commands'][server].join(' && ')
    if output
      puts output
      puts '-- Error while executing remote commands --'
      exit(false)
    end
  end
end

puts '-- Build completed --'


