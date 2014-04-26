module LS
  module GoogleAnalytics
    class DataLayer
      def initialize
        @events = []
      end

      def <<(event)
        push event
      end

      def push(event, property_id=nil)
        events << renderer_for_event(event, property_id)
      end

      def to_s
        <<-JAVASCRIPT
        <script type="text/javascript">
         var push = true;
         console.log(push);
        </script>
        JAVASCRIPT
      end

      private
      def renderer_for_event(event, property_id)
        case event
        when Event then EventRenderer.new(event, property_id)
        when EventCollection then EventCollectionRenderer.new(event, property_id)
        end
      end
    end
  end
end

DATA_LAYER = LS::GoogleAnalytics::DataLayer
