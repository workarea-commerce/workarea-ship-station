require 'workarea/testing/teaspoon'

Teaspoon.configure do |config|
  config.root = Workarea::ShipStation::Engine.root
  Workarea::Teaspoon.apply(config)
end
