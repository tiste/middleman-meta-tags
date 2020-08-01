require 'middleman-core'
require 'middleman-meta-tags/helpers'

module Middleman
  class MetaTagsExtension < Extension
    self.defined_helpers = [Middleman::MetaTags::Helpers]
  end
end
