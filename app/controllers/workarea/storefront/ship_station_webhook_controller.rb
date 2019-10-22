module Workarea
  module Storefront
    class ShipStationWebhookController < Storefront::ApplicationController
      skip_before_action :verify_authenticity_token

      def event
        body = JSON.parse(request.body.read)

        # return a bad response if the resource url in the
        # body is not shipstation.
        uri =  URI(body["resource_url"])
        return unsuccessful_response unless !!uri.host.match(/.shipstation.com/)

        begin
          ShipStation::Webhook.process(body)
          successful_response

        rescue Mongoid::Errors::DocumentNotFound => error
          not_found_response(params: error.params, problem: error.problem)
        rescue ShipStation::Webhook::Error::NotFound, ShipStation::Webhook::Error::UnhandledWebhook => error
          not_found_response(error: "UnhandledWebhook: #{error}")
        end
      end

      private

        def verify_signature
          request_valid = ShipStation::WebhookRequestSignature.valid?(
            request_signature: request.headers['X-Flow-Signature'],
            request_body: request.raw_post
          )
          unsuccessful_response unless request_valid
        end

        def successful_response
          render json: { status: 200 }
        end

        def unsuccessful_response
          head :bad_request
        end

        def error_response(payload)
          render json: payload, status: :unprocessable_entity
        end

        def not_found_response(payload)
          render json: payload, status: :not_found
        end
    end
  end
end
