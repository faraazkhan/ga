module LS
  module GoogleAnalytics
    class EventRenderer
      def initialize(event, single_quoted=false)
        @event = event
      end

      def to_s
         <<-SCRIPT
         <script>
           dataLayer.push(#{options_to_json(@event.name, @event.options)})
         </script>
         SCRIPT
      end

      private

      def array_to_json(array)
        "[" << array.map {|string| string_to_json(string) } .join(',') << "]"
      end

      def options_to_json(event_name, variables_hash)
        variables_hash['event'] = event_name if event_name
        variables_hash.to_json
      end

      def string_to_json(string)
        # replace double quotes with single ones
        string.to_json.gsub(/^"/, "'").gsub(/"$/, "'")
      end
    end
  end
end
