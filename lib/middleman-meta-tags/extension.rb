require 'middleman-meta-tags/helpers'

module Middleman
  class MetaTagsExtension < Extension
    def initialize(app, options = {}, &block)
      super
      app.helpers Middleman::MetaTags::Helpers
    end
  end
end
