module Workarea
  module ShipStation
    class SaveOrder
      class ShipStationSaveOrderError < StandardError; end
      include Sidekiq::Worker
      include Sidekiq::CallbacksWorker

      sidekiq_options(
        enqueue_on: { Workarea::Order => [:place] },
        unique: :until_executing
      )

      def perform(id)
        order = Workarea::Order.find(id)
        shipstation_details = Workarea::ShipStation::Order.new(id).to_h
        response = ShipStation.gateway.create_order(shipstation_details)

        raise ShipStationSaveOrderError, response.body["ExceptionMessage"]  unless response.success?
        order.ship_station_order_id = response.body["orderId"]
        order.set_ship_station_exported_at!
      end
    end
  end
end
