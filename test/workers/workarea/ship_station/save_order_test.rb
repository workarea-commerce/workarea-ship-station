require 'test_helper'

module Workarea
  class ShipStation::SaveOrderTest < TestCase
    def test_order_ship_station_exported
      order = create_placed_order

      Workarea::ShipStation::SaveOrder.new.perform(order.id)

      order.reload

      assert(order.ship_station_exported?)
      assert(order.ship_station_order_id.present?)
    end
  end
end
