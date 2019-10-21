module Workarea
  module ShipStation
    class Webhook
      class Error < RuntimeError; end
      class Error::NotFound < RuntimeError; end
      class Error::UnhandledWebhook < RuntimeError; end

      def self.process(attrs)
        resource = attrs["resource_type"]
        begin
          klass = "Workarea::ShipStation::Webhook::#{resource.downcase.classify}".constantize
        rescue NameError => _error
          raise Error::UnhandledWebhook, "no class defined to handle #{resource}"
        end
        klass.new(attrs).process
      end

      attr_reader :attrs

      def initialize(attrs)
        @attrs = attrs
      end

      def process; end
    end
  end
end
