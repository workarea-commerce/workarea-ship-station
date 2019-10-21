require 'test_helper'

module Workarea
  module Storefront
    module ShipStationWebhooks
      class NotifyShipmentTest < Workarea::IntegrationTest
        def test_notify_shipment
          order = create_placed_order
          fulfillment = create_fulfillment_from_order(order)

          Workarea::ShipStation::Response.any_instance.stubs(:body).returns(order_response(order))

          post storefront.ship_station_webhook_path, params: notify_shipment_payload, as: :json

          assert(response.ok?)

          assert_equal({ "status" => 200 }, JSON.parse(response.body))
          assert_equal(200, response.status)

          fulfillment.reload
          assert_equal(:shipped, fulfillment.status)
        end

        private

        def notify_shipment_payload
          {
            "resource_url": "https://ssapiX.shipstation.com/shipments?storeID=123456&batchId=12345678&includeShipmentItems=True",
            "resource_type": "ITEM_SHIP_NOTIFY"
          }
        end

        def order_response(order)
          items = order.items.map do |order_item|
            {
              "lineItemKey" => order_item.id.to_s,
              "quantity" => order_item.quantity
            }
          end

          {
            "page" => 1,
            "pages" => 0,
            "shipments" => [
              {
                "orderKey" => order.id.to_s,
                "shipmentItems" => items,
                "trackingNumber" => "9400111699000508143346"
              }
            ]
          }
        end
      end
    end
  end
end
