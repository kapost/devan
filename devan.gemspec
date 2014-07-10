$: << File.expand_path("../lib", __FILE__)
require 'devan/version'

Gem::Specification.new do |s|
  s.name          = 'devan'
  s.version       = Devan::VERSION
  s.date          = '2013-07-18'
  s.summary       = "Adobe CRX/JCR Client"
  s.description   = "Adobe CRX/JCR Client"
  s.authors       = ["Mihail Szabolcs"]
  s.email         = 'szaby@kapost.com'
  s.files         = Dir['lib/**/*.rb']
  s.require_paths = ['lib']
  s.homepage      = 'http://github.com/kapost/devan'
  s.licenses      = ['MIT']

  s.add_dependency 'json'
  s.add_dependency 'httparty'
  s.add_dependency 'httmultiparty'

  s.add_development_dependency 'rspec'
end
