require 'test_helper'

module Workarea
  module Storefront
    class ShipStationWebhookTest < Workarea::IntegrationTest
      def test_resource_url
        post storefront.ship_station_webhook_path, params: invalid_payload, as: :json
        refute(response.ok?)
        assert_equal(400, response.status)
      end

      def test_no_processor
        post storefront.ship_station_webhook_path, params: no_processor_payload, as: :json

        refute(response.ok?)
        assert(response.body.include? "no class defined to handle FOO_BAR_BAZ")
         assert_equal(404, response.status)
      end

      private

      def invalid_payload
        {
          "resource_url": "https://ssapiX.example.com",
          "resource_type": "ITEM_SHIP_NOTIFY"
        }
      end

      def no_processor_payload
        {
          "resource_url": "https://ssapiX.shipstation.com",
          "resource_type": "FOO_BAR_BAZ"
        }
      end
    end
  end
end
