require "ls/google_analytics/version"

module LS
  module GoogleAnalytics
    PROPERTY_ID = "UA-12345"
    DEFAULT_SCRIPT = "some script"

    def self.tracker
      @@tracker ||= PROPERTY_ID
    end

    def self.tracker=(tracker)
      @@tracker = tracker
    end

    def self.valid_tracker?
      !(tracker.nil? || tracker == "")
    end

    def self.script
      @@script ||= DEFAULT_SCRIPT
    end

    def self.script=(script)
      @@script = script
    end

    GA = GoogleAnalytics

    if defined?(Rails)
      require 'ls/google_analytics/rails/railtie'
      GAR = GoogleAnalytics::Rails
    end
  end
end
