module Workarea
  module ShipStation
    class Order
      module ProductImageUrl
        include Workarea::ApplicationHelper
        include Workarea::I18n::DefaultUrlOptions
        include ActionView::Helpers::AssetUrlHelper
        include Core::Engine.routes.url_helpers
        extend self

        def mounted_core
          self
        end
      end

      attr_reader :order

      def initialize(order_id)
        wa_order = Workarea::Order.find(order_id)
        @order = Workarea::Storefront::OrderViewModel.new(wa_order)
      end

      def to_h
        {
          orderNumber: order.id,
          orderKey: order.id,
          orderDate: order.placed_at,
          paymentDate: order.placed_at,
          orderStatus: 'awaiting_shipment',
          customerUsername: order.email,
          customerEmail: order.email,
          billTo: address(order.billing_address),
          shipTo: address(order.shipping_address),
          items: items,
          amountPaid: order.total_price.to_s,
          taxAmount: order.tax_total.to_s,
          shippingAmount: order.shipping_total.to_s,
          paymentMethod: payment_methods,
          requestedShippingService: shipping_service_name,
          serviceCode: shipping_service_code,
          shipByDate: ship_by_date
        }
      end

      private

      def ship_by_date
        return unless Workarea::ShipStation.config.ship_by_date_lead_days.present?

        Time.current + Workarea::ShipStation.config.ship_by_date_lead_days.days
      end

      def shipping
        @shipping = Workarea::Shipping.find_by_order(order.id)
      end

      def shipping_service_code
        return unless shipping.present?
        shipping.shipping_service.service_code
      end

      def shipping_service_name
        return unless shipping.present?
        shipping.shipping_service.name
      end

      def payment
        @payment = Workarea::Payment.find(order.id)
      end

      def address(obj)
        return unless  obj.present?
        {
          name: obj.first_name + ' ' + obj.last_name,
          company: obj.company,
          street1: obj.street,
          street2: obj.street_2,
          city: obj.city,
          state: obj.region,
          postalCode: obj.postal_code,
          country: obj.country.alpha2,
          phone: obj.phone_number
        }
      end

      def items
        order_items = order.items.map do |order_item|

          hash = {
            lineItemKey: order_item.id,
            sku: order_item.sku,
            name: order_item.product_name,
            imageUrl: ProductImageUrl.product_image_url(order_item.image, :detail),
            quantity: order_item.quantity,
            unitPrice: order_item.original_unit_price.to_f,
            taxAmount: item_tax(order_item).to_f,
            options: item_options(order_item),
            adjustment: false
          }

          item_shipping_sku = shipping_sku(order_item.sku)
          if item_shipping_sku.present?
            weight_data = {
                weight: {
                  value: item_shipping_sku.weight,
                  units: item_shipping_sku.weight_units.to_s
                }
            }

            hash.merge!(weight_data)
          end

          hash
        end

        order_items + discount_items
      end

      def shipping_sku(sku)
        return unless shipping.present?
        Workarea::Shipping::Sku.find(sku) rescue nil
      end

      def item_tax(order_item)
        return unless shipping.present?
        item = shipping.price_adjustments.adjusting('tax').detect { |pa| pa["data"]["order_item_id"].to_s == order_item.id.to_s }
        return 0 unless item.present?
        item.amount.to_f
      end

      def item_options(order_item)
        order_item.details.map { |k, v| { name: k, value: v } }
      end

      def payment_methods
        payment.tenders.map(&:slug).join(',')
      end

      def discount_items
        discounts = order.price_adjustments.select { |p| p.discount? }
        return [] unless discounts.present?

        discounts.map do |d|
          {
            lineItemKey: nil,
            sku: "DISCOUNT CODE",
            name: d.description,
            imageUrl: nil,
            weight: {
              value: 0,
              units: "ounces"
            },
            quantity: 1,
            unitPrice: d.amount.to_f,
            adjustment: true
          }
        end
      end
    end
  end
end
