Gem::Specification.new do |spec|
  spec.name          = 'salestax'
  spec.version       = '0.0.1'
  spec.authors       = ['Matias Anaya']
  spec.email         = ['matiasanaya@gmail.com']
  spec.summary       = %q{A basic sales tax calculator}
  spec.description   = %q{A basic sales tax calculator utility, that accepts a list of items and prints a receipt with taxes.}
  spec.homepage      = 'https://github.com/matiasanaya/sales-tax'
  spec.license       = 'UNLICENSE'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['salestax']
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '~> 2.1'

  spec.add_development_dependency 'rspec', '~> 3.1'
end
