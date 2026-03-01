# frozen_string_literal: true

require_relative 'lib/log_scanner/version'

Gem::Specification.new do |spec|
  spec.name          = 'log_scanner'
  spec.version       = LogScanner::VERSION
  spec.authors       = ['Matt-Yeldalo']
  spec.summary       = 'A gem for scanning and analyzing log files'
  spec.description   = 'LogScanner provides a CLI tool for filtering and analyzing log files by tag, request ID,
                        timestamp, and logger name.'
  spec.homepage      = 'https://github.com/Matt-Yeldalo/log-scanner'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 2.7.0'

  spec.files         = Dir['lib/**/*.rb', 'bin/*', 'README.md']
  spec.bindir        = 'bin'
  spec.executables   = ['log-scanner']
  spec.require_paths = ['lib']
end
