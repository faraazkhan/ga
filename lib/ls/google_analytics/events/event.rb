module LS
  module GoogleAnalytics
    class Event
      attr_reader :name, :options
      def initialize(options, name)
        @name = name
        @options = options
      end
    end
  end
end
