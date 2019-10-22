require 'test_helper'

module Workarea
  module ShipStation
    class OrderTest < Workarea::TestCase
      def test_to_h
        create_order_total_discount(order_total: 1.to_m)
        shipping_sku = create_shipping_sku(id: 'SKU', weight: 1, dimensions: [2, 3, 4])
        order = create_placed_order
        order_details = Order.new(order.id).to_h

        order_vm = Workarea::Storefront::OrderViewModel.new(order)

        assert_equal(order.id, order_details[:orderNumber])
        assert_equal(order.id, order_details[:orderKey])
        assert_equal('awaiting_shipment', order_details[:orderStatus])
        assert_equal(order.email, order_details[:customerUsername])
        assert_equal(order.email, order_details[:customerEmail])
        refute(order_details[:shipByDate].present?)

        wa_billing_address = order_vm.billing_address
        ship_station_billing_address = order_details[:billTo]

        assert_equal("Ben Crouse", ship_station_billing_address[:name])
        assert_equal(wa_billing_address.street, ship_station_billing_address[:street1])
        assert_equal(wa_billing_address.street_2, ship_station_billing_address[:street2])
        assert_equal(wa_billing_address.city, ship_station_billing_address[:city])
        assert_equal(wa_billing_address.postal_code, ship_station_billing_address[:postalCode])
        assert_equal(wa_billing_address.region, ship_station_billing_address[:state])
        assert_equal("US", ship_station_billing_address[:country])

        wa_shipping_address = order_vm.shipping_address
        ship_station_shipping_address = order_details[:shipTo]

        assert_equal("Ben Crouse", ship_station_shipping_address[:name])
        assert_equal(wa_shipping_address.street, ship_station_shipping_address[:street1])
        assert_equal(wa_shipping_address.street_2, ship_station_shipping_address[:street2])
        assert_equal(wa_shipping_address.city, ship_station_shipping_address[:city])
        assert_equal(wa_shipping_address.postal_code, ship_station_shipping_address[:postalCode])
        assert_equal(wa_shipping_address.region, ship_station_shipping_address[:state])
        assert_equal("US", ship_station_shipping_address[:country])

        merch_item = order_details[:items].detect { |item| !item[:adjustment] }

        assert_equal(2, order_details[:items].size)
        assert_equal("SKU", merch_item[:sku])
        assert_equal("Test Product", merch_item[:name])
        assert_equal(2, merch_item[:quantity])
        assert_equal(5.0, merch_item[:unitPrice])
        assert_equal(1.0, merch_item[:weight][:value])
        assert_equal("ounces", merch_item[:weight][:units])

        discount_item = order_details[:items].detect { |item| item[:adjustment] }
        assert_equal("DISCOUNT CODE", discount_item[:sku])
        assert_equal("Order Total Discount", discount_item[:name])
        assert_equal(1, discount_item[:quantity])
        assert_equal(-1, discount_item[:unitPrice])

        Workarea.with_config do |config|
          config.ship_station.ship_by_date_lead_days = 5
          order_details = Order.new(order.id).to_h
          assert(order_details[:shipByDate] > Time.current)
        end
      end
    end
  end
end
