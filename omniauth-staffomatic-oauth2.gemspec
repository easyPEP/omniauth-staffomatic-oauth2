# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'omniauth/staffomatic/version'

Gem::Specification.new do |s|
  s.name     = 'omniauth-staffomatic-oauth2'
  s.version  = OmniAuth::Staffomatic::VERSION
  s.authors  = ['Kalle Saas']
  s.email    = ['kalle@staffomatic.com']
  s.summary  = 'Staffomatic strategy for OmniAuth'
  s.homepage = 'https://github.com/staffomatic/omniauth-staffomatic-oauth2'
  s.license = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'omniauth-oauth2', '~> 1.2.0'

  s.add_development_dependency 'rspec', '~> 2.7.0'
  s.add_development_dependency 'rake'
end
