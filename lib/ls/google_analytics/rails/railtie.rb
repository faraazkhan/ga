require 'ls/google_analytics/rails/view_helpers'
module LS
  module GoogleAnalytics::Rails
    class Railtie < ::Rails::Railtie
      initializer "ls-google_analytics" do
        ActionView::Base.send :include, ViewHelpers
      end
    end
  end
end
