require_relative 'lib/spongiform/version'

Gem::Specification.new do |s|
  s.name = 'spongiform-server'
  s.version = Spongiform::VERSION
  s.summary = 'Allow/disallow access to websites using Squidguard via an API'
  s.licenses = ['MIT']
  s.authors = ['spacepilothannah']
  s.homepage = 'https://github.com/spacepilothannah/spongiform-server'

  s.files = Dir[
    'lib/**/*.rb',
    'lib/**/*.rake',
    'bin/*',
    'Rakefile',
    'README.md',
    'views/*'
  ]

  s.add_runtime_dependency 'haml', '~> 5.0.4'
  s.add_runtime_dependency 'rake', '>= 12.3.2', '< 13.1.0'
  s.add_runtime_dependency 'roda', '~> 3.17.0'
  s.add_runtime_dependency 'roda-basic-auth', '~> 0.1.1'
  s.add_runtime_dependency 'sequel', '~> 5.18.0'
  s.add_runtime_dependency 'sqlite3', '~> 1.4.0'
  s.add_runtime_dependency 'tilt', '~> 2.0.9'

  s.add_development_dependency 'database_cleaner', '~> 1.7.0'
  s.add_development_dependency 'factory_bot', '~> 5.0.2'
  s.add_development_dependency 'faker', '~> 1.9.3'
  s.add_development_dependency 'guard', '~> 2.15'
  s.add_development_dependency 'guard-rspec', '~> 4.7'
  s.add_development_dependency 'rspec', '~> 3.8.0'
  s.add_development_dependency 'rspec-roda', '~> 0.2.2'
end
