require 'middleman-core'

::Middleman::Extensions.register(:meta_tags) do
  require 'middleman-meta-tags/extension'
  ::Middleman::MetaTags
end
