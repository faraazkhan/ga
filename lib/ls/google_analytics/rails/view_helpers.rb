# coding: utf-8

require 'active_support/core_ext/string/output_safety'
require 'active_support/core_ext/object/blank'
module LS
  module GoogleAnalytics
    module Rails
      # All the helper methods output raw javascript with single quoted strings. This allows more flexbility in choosing when the event gets sent (on page load, on user action, etc).
      #
      # The only exception is {#analytics_init}, which is wrapped in a `<script>` tag.
      #
      # @example This event is always sent on page load
      #
      #     <script>
      #       <%= analytics_track_event "Videos", "Play", "Gone With the Wind" %>
      #     </script>
      #
      # @example This event is sent when the visitor clicks on the link
      #
      #     # note the double quotes around the onclick attribute,
      #     # they are necessary because the javascript is single quoted
      #     <a href="my_url" onclick="<%= analytics_track_event "Videos", "Play", "Gone With the Wind" %>">Link</a>
      #
      # @example Full ecommerce example
      #
      #     # create a new transaction
      #     analytics_add_transaction(
      #       '1234',           # order ID - required
      #       'Acme Clothing',  # affiliation or store name
      #       '11.99',          # total - required
      #       '1.29',           # tax
      #       '5',              # shipping
      #       'San Jose',       # city
      #       'California',     # state or province
      #       'USA'             # country
      #     )
      #
      #     # add an item to the transaction
      #     analytics_add_item(
      #       '1234',           # order ID - required
      #       'DD44',           # SKU/code - required
      #       'T-Shirt',        # product name
      #       'Green Medium',   # category or variation
      #       '11.99',          # unit price - required
      #       '1'               # quantity - required
      #     )
      #
      #     # submit the transaction
      #     analytics_track_transaction
      #
      module ViewHelpers
        # Initializes the Analytics javascript. Put it in the `<head>` tag.
        #
        # @param options [Hash]
        # @option options [Boolean] :local (false) Sets the local development mode.
        #   See {http://www.google.com/support/forum/p/Google%20Analytics/thread?tid=741739888e14c07a&hl=en}
        # @option options [Array, GoogleAnalytics::Event] :add_events ([])
        #   The page views are tracked by default, additional events can be added here.
        # @option options [String] :page
        #   The optional virtual page view to track through {GoogleAnalytics::Events::TrackPageview}
        # @option options [String] :tracker
        #   The tracker to use instead of the default {GoogleAnalytics.tracker}
        # @option options [String] :domain
        #   The domain name to track, see {GoogleAnalytics::Events::SetDomainName}
        # @option options [Boolean] :anonymize
        #   Whether to anonymize the visitor ip or not.
        #   This is required for european websites and actively enforced for german ones,
        #   see {GoogleAnalytics::Events::AnonymizeIp}.
        # @option options [Boolean] :enhanced_link_attribution
        #   See separate information for multiple links on a page that all have the same destination,
        #   see {https://support.google.com/analytics/answer/2558867}.
        # @option options [Array, GoogleAnalytics::Events::SetCustomVar] :custom_vars ([])
        #
        # @example Set the local bit in development mode
        #   analytics_init :local => Rails.env.development?
        #
        # @example Allow links across domains
        #   analytics_init :add_events => Events::SetAllowLinker.new(true)
        #
        # @return [String] a `<script>` tag, containing the analytics initialization sequence.
        #
        def analytics_init(opts = {})
          LS::GA.script.html_safe
        end

        def analytics_send(options, event_name=nil)
          event = LS::GA::Event.new(options, event_name)
          analytics_render_event(event)
        end

        # Track a custom event
        # @see http://code.google.com/apis/analytics/docs/tracking/eventTrackerGuide.html
        #
        # @example
        #
        #     analytics_track_event "Videos", "Play", "Gone With the Wind"
        #
        def analytics_track_event(category, action, label = nil, value = nil)
          analytics_render_event(LS::GA::Events::TrackEvent.new(category, action, label, value))
        end

        # Set a custom variable.
        # @see http://code.google.com/apis/analytics/docs/tracking/gaTrackingCustomVariables.html
        # You're allowed only 1-5 for the index.
        # The lifetime is defined by:
        #  1 = visitor-level
        #  2 = session-level
        #  3 = page-level (default)
        def analytics_set_custom_var(index, name, value, opt_scope = 3)
          analytics_render_event(LS::GA::Events::SetCustomVar.new(index, name, value, opt_scope))
        end

        # Track an ecommerce transaction
        # @see http://code.google.com/apis/analytics/docs/tracking/gaTrackingEcommerce.html
        def analytics_add_transaction(order_id, store_name, total, tax, shipping, city, state_or_province, country)
          analytics_render_event(LS::GA::Events::Ecommerce::AddTransaction.new(order_id, store_name, total, tax, shipping, city, state_or_province, country))
        end

        # Add an item to the current transaction
        # @see http://code.google.com/apis/analytics/docs/tracking/gaTrackingEcommerce.html
        def analytics_add_item(order_id, product_id, product_name, product_variation, unit_price, quantity)
          analytics_render_event(LS::GA::Events::Ecommerce::AddItem.new(order_id, product_id, product_name, product_variation, unit_price, quantity))
        end

        # Flush the current transaction
        # @see http://code.google.com/apis/analytics/docs/tracking/gaTrackingEcommerce.html
        def analytics_track_transaction
          analytics_render_event(LS::GA::Events::Ecommerce::TrackTransaction.new)
        end

        private

        def analytics_render_event(event)
          raise ArgumentError, "Tracker must be set! Did you set LS::GA.tracker ?" unless LS::GA.valid_tracker?
          LS::GA::EventRenderer.new(event).to_s.html_safe
        end
      end
    end
  end
end

