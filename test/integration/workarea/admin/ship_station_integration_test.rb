require 'test_helper'

module Workarea
  module Admin
    class ShipStationIntegrationTest < Workarea::IntegrationTest
      include Admin::IntegrationTest

      def test_setting_order_on_hold
        order = create_placed_order

        hold_date = 10.days.from_now
        patch admin.save_hold_date_order_path(order),
          params: {
            hold_until: hold_date
          }

        order.reload

        assert(order.ship_station_on_hold?)
        assert(order.ship_station_on_hold_until.present?)
      end

      def test_clearing_order_hold
        order = create_placed_order(ship_station_on_hold_until: 1.day.from_now)

        assert(order.ship_station_on_hold?)

        patch admin.clear_hold_date_order_path(order)
        order.reload

        refute(order.ship_station_on_hold?)
        refute(order.ship_station_on_hold_until.present?)
      end
    end
  end
end
