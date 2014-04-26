module LS
  module GoogleAnalytics
    class EventRenderer
      def initialize(event, property_id)
        @event = event
        @property_id = property_id
      end

      def to_s
        "dataLayer.push(#{array_to_json([@property_id ? "#{@property_id}.#{@event.name}" : @event.name, *@event.params])});"
      end

      private

      def array_to_json(array)
        "[" << array.map {|string| string_to_json(string) } .join(',') << "]"
      end

      def string_to_json(string)
        # replace double quotes with single ones
        string.to_json.gsub(/^"/, "'").gsub(/"$/, "'")
      end
    end
  end
end
