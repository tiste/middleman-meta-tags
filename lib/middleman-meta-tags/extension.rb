require 'middleman-meta-tags/helpers'

module Middleman
  module MetaTags
    class << self
      def registered(app, options_hash = {}, &block)
        app.helpers Middleman::MetaTags::Helpers
      end
    end
  end
end
