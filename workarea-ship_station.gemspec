$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "workarea/ship_station/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "workarea-ship_station"
  spec.version     = Workarea::ShipStation::VERSION
  spec.authors     = ["Jeff Yucis"]
  spec.email       = ["jyucis@workarea.com"]
  spec.homepage    = "https://github.com/workarea-commerce/workarea-ship-station"
  spec.summary     = "Workarea Commerce Shipstation integration"
  spec.description = "Shipstation integration."
  spec.license     = "Business Software License"

  spec.files = `git ls-files`.split("\n")

  spec.add_dependency 'workarea', '~> 3.x'
end
