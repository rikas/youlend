# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'youlend/version'

Gem::Specification.new do |spec|
  spec.name          = 'youlend'
  spec.version       = Youlend::VERSION
  spec.authors       = ['rikas']
  spec.email         = ['oterosantos@gmail.com']

  spec.summary       = 'Youlend API wrapper'
  spec.description   = spec.summary
  spec.homepage      = 'https://youlend.com/'

  spec.metadata['homepage_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'addressable'
  spec.add_dependency 'faraday', '~> 2.7'
  spec.add_dependency 'rainbow'
end
