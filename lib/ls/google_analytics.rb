require "ls/google_analytics/version"
require "ls/google_analytics/data_layer"
require "ls/google_analytics/events"

module LS
  module GoogleAnalytics
    DEFAULT_SCRIPT = <<-GTM
                      <!-- DataLayer -->
                      <script>
                      dataLayer = [];
                      </script>
                      <!-- End DataLayer -->
                      <!-- Google Tag Manager -->
                      <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
                      new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
                      j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
                      '//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
                      })(window,document,'script','dataLayer','property_id');</script>
                      <!-- End Google Tag Manager -->
                      GTM


    def self.environment
      environment = 'development'
      environment = defined?(Rails) ? ::Rails.env : environment #TODO: can we use RACK_ENV for other environment types here?
    end

    def self.config
      path = File.join(File.dirname(__FILE__), 'google_analytics', 'config', 'analytics.yml')
      YAML.load(File.read path)[environment]
    end

    def self.tracker
      @@tracker ||= config['PROPERTY_ID']
    end

    def self.tracker=(tracker)
      @@tracker = tracker
    end

    def self.valid_tracker?
      !(tracker.nil? || tracker == "")
    end

    def self.script
      @@script ||= DEFAULT_SCRIPT.gsub('property_id', tracker)
    end

    def self.script=(script)
      @@script = script
    end
  end
  GA = GoogleAnalytics
  if defined?(Rails)
    require 'ls/google_analytics/rails/railtie'
    GAR = GoogleAnalytics::Rails
  end
end
