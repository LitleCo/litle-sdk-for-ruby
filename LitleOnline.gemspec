# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'LitleOnline/version'

Gem::Specification.new do |spec|
  spec.name = 'LitleOnline'
  spec.version = LitleOnline::VERSION
  spec.authors = ['Litle & Co']
  spec.email = ['sdksupport@litle.com']

  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '>= 1.8.7'

  spec.summary = 'Ruby SDK produced by Litle & Co. for transaction processing using Litle XML format v8.29'
  spec.description = File.read(File.join(File.dirname(__FILE__), 'DESCRIPTION'))
  spec.homepage = 'http://www.litle.com/developers'
  spec.requirements = ['Contact sdksupport@litle.com for more information']

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files = Dir["test/**/**"]
  spec.bindir = 'bin'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.has_rdoc = true

  spec.add_dependency 'xml-object'
  spec.add_dependency 'xml-mapping'
  spec.add_dependency 'net-sftp'
  spec.add_dependency 'libxml-ruby'
  spec.add_dependency 'crack'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'test-unit', '~> 3.1', '>= 3.1.8'
  spec.add_development_dependency 'pry-byebug', '~> 3.3'
  spec.add_development_dependency 'mocha'
end
