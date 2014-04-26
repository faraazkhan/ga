module LS
  module GoogleAnalytics
    class EventCollectionRenderer
      def initialize(event_collection, property_id)
        @event_collection = event_collection
        @property_id = property_id
      end

      def to_s
        @event_collection.map {|event| EventRenderer.new(event, @property_id).to_s }.join("\n")
      end
    end
  end
end
