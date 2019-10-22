module Workarea
  module ShipStation
    class Webhook
      class ItemShipNotify < Webhook
        class ShipStationItemShipNotifyError < StandardError; end

        def process
          uri = URI(attrs["resource_url"])
          rest_endpoint = "https://" + uri.host
          query_hash = Rack::Utils.parse_query(uri.query)

          response = gateway(rest_endpoint).get_shipping(query_hash)

          raise ShipStationItemShipNotifyError, response.body["ExceptionMessage"] unless response.success?

          response.body["shipments"].each do |shipment|
            fulfillment = Workarea::Fulfillment.find(shipment["orderKey"])
            tracking_number = shipment["trackingNumber"]
            items = shipment["shipmentItems"].map { |item| { id: item["lineItemKey"], quantity: item["quantity"] } }

            fulfillment.ship_items(tracking_number, items)
          end
        end

        private

          def gateway(rest_endpoint)
            Workarea::ShipStation.gateway(rest_endpoint)
          end
      end
    end
  end
end
