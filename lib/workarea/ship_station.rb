require 'workarea'
require 'workarea/storefront'
require 'workarea/admin'

require 'workarea/ship_station/engine'
require 'workarea/ship_station/version'

require 'workarea/ship_station/bogus_gateway'
require 'workarea/ship_station/gateway'
require 'workarea/ship_station/response'

module Workarea
  module ShipStation
    def self.credentials
      (Rails.application.secrets.ship_station || {}).deep_symbolize_keys
    end

    def self.config
      Workarea.config.ship_station
    end

    def self.api_key
      credentials[:api_key]
    end


    def self.api_secret
      credentials[:api_secret]
    end

    def self.gateway(rest_endpoint = "")
      if credentials.present?
        ShipStation::Gateway.new(api_key: api_key, api_secret: api_secret, rest_endpoint: rest_endpoint)
      else
        ShipStation::BogusGateway.new
      end
    end
  end
end
