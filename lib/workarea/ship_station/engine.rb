require 'workarea/ship_station'

module Workarea
  module ShipStation
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::ShipStation
    end
  end
end
