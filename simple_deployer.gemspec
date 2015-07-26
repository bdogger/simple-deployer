Gem::Specification.new do |s|
  s.name = 'cli_deployer'
  s.version = '0.0.1'
  s.date = '2015-07-25'
  s.summary = 'Simple Application Deployment Using the CLI'
  s.description = 'A gem that parses an easy to create yaml file and provides a command line interface for deploying your applications'
  s.authors = ['Blair Motchan']
  s.email = 'blair.motchan@gmail.com'
  s.files = ['lib/simple_deployer.rb']
  s.executables << 'cli_deployer'
  s.homepage = 'https://github.com/bdogger/simple-deployer'
  s.license = 'MIT'

  s.add_runtime_dependency 'git', '~> 1.2'
  s.add_runtime_dependency 'fileutils', '~> 0.7'
  s.add_runtime_dependency 'net-scp', '~> 1.2'
  s.add_runtime_dependency 'ssh', '~> 1.1'
end