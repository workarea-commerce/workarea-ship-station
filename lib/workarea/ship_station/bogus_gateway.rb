module Workarea
  module ShipStation
    class BogusGateway
      def initialize(options = {})
      end

      def create_order(order)
        Response.new(response(create_order_body))
      end

      def get_shipping(attrs = {})
         Response.new(response(get_shipments_body))
      end

      def get_shipping(attrs = {})
         Response.new(response(get_shipments_body))
      end

      def hold_order(attrs = {})
        Response.new(response(hold_body))
      end

      def clear_hold_order(attrs = {})
        Response.new(response(hold_body))
      end

      private

      def response(body, status = 200)
        response = Faraday.new do |builder|
          builder.adapter :test do |stub|
            stub.get("/orders/createorder") { |env| [ status, {}, body.to_json ] }
          end
        end
        response.get("/orders/createorder")
      end

      def create_order_body
        {
          orderId: 5017358,
          orderNumber: "1234",
          orderKey: "1234",
          orderDate: "2019-10-04T06 57 17.5930000",
          createDate: "2019-10-04T06 57 18.9030000",
          modifyDate: "2019-10-04T06 57 18.9030000",
          paymentDate: "2019-10-04T06 57 17.5930000",
          shipByDate: nil,
          orderStatus: "awaiting_shipment",
          customerId: nil,
          customerUsername: "jyucis@weblinc.com",
          customerEmail: "jyucis@weblinc.com",
          billTo: {
            name: "Jeff Yucis",
            company: "",
            street1: "35 Letitia Ln",
            street2: "",
            street3: nil,
            city: "Media",
            state: "PA",
            postalCode: "19063-5838",
            country: "US",
            phone: "3027507743",
            residential: nil,
            addressVerified: nil
          },
          shipTo: {
            name: "Jeff Yucis",
            company: "",
            street1: "35 LETITIA LN",
            street2: "",
            street3: nil,
            city: "MEDIA",
            state: "PA",
            postalCode: "19063-4019",
            country: "US",
            phone: "3027507743",
            residential: true,
            addressVerified: "Address validated successfully"
          },
          items: [
            {
              orderItemId: 7804579,
              lineItemKey: "5d974f5e987b4750710c04fc",
              sku: "396342674-8",
              name: "Sleek Wooden Table",
              imageUrl: "/product_images/sleek-wooden-table/5d89164b987b47002578378f/detail.jpg?c=1569265227",
              weight: nil,
              quantity: 1,
              unitPrice: 8.0,
              taxAmount: 0.0,
              shippingAmount: nil,
              warehouseLocation: nil,
              options: [
                { name: "Size", value: "Extra Small" },
                { name: "Color", value: "Maroon" }
              ],
              productId: nil,
              fulfillmentSku: nil,
              adjustment: false,
              upc: nil,
              createDate: "2019-10-04T06 57 18.903",
              modifyDate: "2019-10-04T06 57 18.903"
            }
          ],
          orderTotal: 15.0,
          amountPaid: 15.0,
          taxAmount: 0.0,
          shippingAmount: 7.0,
          customerNotes: nil,
          internalNotes: nil,
          gift: false,
          giftMessage: nil,
          paymentMethod: "credit_card",
          requestedShippingService: "Ground",
          carrierCode: nil,
          serviceCode: nil,
          packageCode: nil,
          confirmation: "none",
          shipDate: nil,
          holdUntilDate: nil,
          weight: { value: 0.0, units: "ounces", WeightUnits: 1 },
          dimensions: nil,
          insuranceOptions: {
            provider: nil, insureShipment: false, insuredValue: 0.0
          },
          internationalOptions: {
            contents: nil, customsItems: nil, nonDelivery: nil
          },
          advancedOptions: {
            warehouseId: 113059,
            nonMachinable: false,
            saturdayDelivery: false,
            containsAlcohol: false,
            mergedOrSplit: false,
            mergedIds: [],
            parentId: nil,
            storeId: 62810,
            customField1: nil,
            customField2: nil,
            customField3: nil,
            source: nil,
            billToParty: nil,
            billToAccount: nil,
            billToPostalCode: nil,
            billToCountryCode: nil,
            billToMyOtherAccount: nil
          },
          tagIds: nil,
          userId: nil,
          externallyFulfilled: false,
          externallyFulfilledBy: nil,
          labelMessages: nil
        }
      end

      def get_shipments_body
        {
          page: 1,
          pages: 0,
          shipments: [
            {
              advancedOptions: {
              billToAccount: nil,
              billToCountryCode: nil,
              billToParty: "4",
              billToPostalCode: nil,
              storeId: 62810
            },
              batchNumber: nil,
              carrierCode: "stamps_com",
              confirmation: "delivery",
              createDate: "2019-09-30T13:37:05.7230000",
              customerEmail: "jyucis@workarea.com",
              dimensions: {
                height: 4.0,
                length: 4.0,
                units: "inches",
                width: 4.0
              },
              formData: nil,
              insuranceCost: 0.0,
              insuranceOptions: {
                insureShipment: false,
                insuredValue: 0.0,
                provider: nil
              },
              isReturnLabel: false,
              labelData: nil,
              marketplaceNotified: true,
              notifyErrorMessage: nil,
              orderId: 4599538,
              orderKey: "1234",
              orderNumber: "1234",
              packageCode: "package",
              serviceCode: "usps_first_class_mail",
              shipDate: "2019-09-30",
              shipTo: {
                addressVerified: nil,
                city: "PENNSVILLE",
                company: "",
                country: "US",
                name: "Jeffrey Yucis",
                phone: "3027507743",
                postalCode: "08070-2726",
                residential: nil,
                state: "NJ",
                street1: "29 FORT MOTT RD APT 2",
                street2: "",
                street3: nil
              },
              shipmentCost: 2.66,
              shipmentId: 1384210,
              shipmentItems: [
                {
                  adjustment: false,
                  createDate: "2019-09-27T13:18:49.153",
                  fulfillmentSku: nil,
                  imageUrl: "/product_images/gorgeous-wool-wallet/5d89163b987b4700257835a5/detail.jpg?c=1569265211",
                  lineItemKey: "5d8e6e75987b4701f4bc308f",
                  modifyDate: "2019-09-27T13:18:49.153",
                  name: "Gorgeous Wool Wallet",
                  options: [
                    {
                      name: "Size",
                      value: "Medium"
                    },
                    {
                      name: "Color",
                      value: "White"
                    }
                  ],
                  orderItemId: 7169563,
                  productId: 2022076,
                  quantity: 1,
                  shippingAmount: nil,
                  sku: "534286467-4",
                  taxAmount: 0.0,
                  unitPrice: 48.45,
                  upc: nil,
                  warehouseLocation: nil,
                  weight: nil
                },
                {
                  adjustment: false,
                  createDate: "2019-09-27T13:18:49.153",
                  fulfillmentSku: nil,
                  imageUrl: "/product_images/gorgeous-linen-wallet/5d891632987b47002578349b/detail.jpg?c=1569265202",
                  lineItemKey: "5d8e6e80987b4701f4bc3111",
                  modifyDate: "2019-09-27T13:18:49.153",
                  name: "Gorgeous Linen Wallet",
                  options: [
                    {
                      name: "Size",
                      value: "Medium"
                    },
                    {
                      name: "Color",
                      value: "Cyan"
                    }
                  ],
                  orderItemId: 7169562,
                  productId: 2022077,
                  quantity: 2,
                  shippingAmount: nil,
                  sku: "680422763-8",
                  taxAmount: 0.0,
                  unitPrice: 45.2,
                  upc: nil,
                  warehouseLocation: nil,
                  weight: nil
                }
              ],
              trackingNumber: "9400111699000508143346",
              userId: "a1f5b238-01d3-4a59-bd9b-010cd67d0e34",
              voidDate: nil,
              voided: false,
              warehouseId: 113059,
              weight: {
                weightUnits: 1,
                units: "ounces",
                value: 3.0
              }
            }
          ],
          total: 1
        }
      end

      def hold_body
        {
          success: true,
          message: "hold data set"
        }
      end
    end
  end
end
