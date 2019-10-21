module Workarea
  module ShipStation
    class Gateway
      attr_reader :options

      def initialize(options = {})
        requires!(options, :api_secret, :api_key)
        @options = options
      end

      def create_order(order)
        response = connection.post do |req|
          req.url "orders/createorder"
          req.body = order.to_json
        end
        ShipStation::Response.new(response)
      end

      def hold_order(attrs = {})
        response = connection.post do |req|
          req.url "orders/holduntil"
          req.body = attrs.to_json
        end
        ShipStation::Response.new(response)
      end

      def clear_hold_order(attrs = {})
        response = connection.post do |req|
          req.url "orders/restorefromhold"
          req.body = attrs.to_json
        end
        ShipStation::Response.new(response)
      end

      def get_shipping(attrs = {})
        response = connection.get do |req|
          req.url "shipments"
          req.params = attrs
        end

        ShipStation::Response.new(response)
      end

      private

        def connection
          headers = {
            "Content-Type"  => "application/json",
            "Accept"        => "application/json",
          }

          request_timeouts = {
            timeout: Workarea.config.ship_station[:api_timeout],
            open_timeout: Workarea.config.ship_station[:open_timeout]
          }

          conn = Faraday.new(url: rest_endpoint, headers: headers, request: request_timeouts)
          conn.basic_auth(api_key, api_secret)
          conn
        end

        def api_key
          options[:api_key]
        end

        def api_secret
          options[:api_secret]
        end

        def test?
          (options.has_key?(:test) ? options[:test] : true)
        end

        def rest_endpoint
          options[:rest_endpoint].presence || "https://ssapi.shipstation.com"
        end

        def requires!(hash, *params)
          params.each do |param|
            if param.is_a?(Array)
              raise ArgumentError.new("Missing required parameter: #{param.first}") unless hash.has_key?(param.first)

              valid_options = param[1..-1]
              raise ArgumentError.new("Parameter: #{param.first} must be one of #{valid_options.to_sentence(words_connector: 'or')}") unless valid_options.include?(hash[param.first])
            else
              raise ArgumentError.new("Missing required parameter: #{param}") unless hash.has_key?(param)
            end
          end
        end
    end
  end
end
