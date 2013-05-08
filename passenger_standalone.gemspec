# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'passenger_standalone/version'

Gem::Specification.new do |spec|
  spec.name          = "passenger_standalone"
  spec.version       = PassengerStandalone::VERSION
  spec.authors       = ["Mat Brown"]
  spec.email         = ["mat.a.brown@gmail.com"]
  spec.summary       = %q{Self-contained gem installation of standalne Passenger with Nginx}
  spec.description   = <<DESC
passenger_standalone is a small wrapper which installs the passenger gem and
builds a copy of Nginx into the gem's installed location. It provides the
passenger_standalone executable to start the standalone passenger using the
installed version of Nginx. The goal is to provide a self-contained standalone
Passenger installation that can be run on Heroku.
DESC
  spec.license       = "MIT"

  spec.extensions << 'ext/Rakefile'

  spec.files         = Dir["lib/**/*.rb"] + Dir["src/*"] + Dir["bin/*"] + Dir["ext/*"]
  spec.require_paths = ["lib"]
  spec.bindir = 'bin'
  spec.executables << 'passenger_standalone'
  spec.default_executable = 'passenger_standalone'

  spec.add_dependency "passenger", PassengerStandalone.passenger_version
  spec.add_dependency "rake"
  spec.add_development_dependency "bundler", "~> 1.3"

  Gem.post_install do |installer|
    if installer.spec.name == 'passenger_standalone'
      root = installer.dir
      begin
        vendor_path = File.join(root, 'vendor/passenger')
        nginx_tarball_path = Dir[File.join(root, "src/nginx-*.tar.gz")].first
        target_path = File.join(vendor_path, PassengerStandalone.passenger_version)
        unless File.exists?(target_path)
          STDERR.puts("Attempting to install Nginx from #{nginx_tarball_path}")
          system('passenger',
                 'package-runtime', vendor_path,
                 '--nginx-tarball', nginx_tarball_path)
        end
      rescue => e
        STDERR.puts("Error installing Nginx: #{e.class.name}: #{e.message}")
        raise
      end
    end
  end
end
