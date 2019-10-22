module Workarea
  module ShipStation
    class Response
      def initialize(response)
        @response = response
      end

      def success?
        @response.success?
      end

      def body
        @body ||= JSON.parse(@response.body)
      end
    end
  end
end
