require 'spec_helper'

describe Middleman::MetaTags::Helpers do
  let(:h) { Class.new { extend Middleman::MetaTags::Helpers } }

  before(:each) do
    allow(h).to receive_message_chain(:current_page, :data).and_return({ full_title: nil })
  end

  it 'transforms title tag' do
    h.set_meta_tags title: 'Relevant title'
    expect(h.display_meta_tags).to eql('<title>Relevant title</title>')
  end

  it 'transforms description tag' do
    h.set_meta_tags description: 'Relevant title of more than 220 characters
1 Relevant title of more than 220 characters
2 Relevant title of more than 220 characters
3 Relevant title of more than 220 characters
4 Relevant title of more than 220 characters'
    expect(h.display_meta_tags).to eql('<meta name="description" content="Relevant title of more than 220 characters
1 Relevant title of more than 220 characters
2 Relevant title of more than 220 characters
3 Relevant title of more than 220 characters
4 Relevant title of more than 220 chara..." />')
  end

  it 'transforms keywords tag' do
    h.set_meta_tags keywords: %w(some seo keywords)
    expect(h.display_meta_tags).to eql('<meta name="keywords" content="some, seo, keywords" />')
  end

  it 'transforms site tag' do
    expect(h.display_meta_tags site: 'My Awesome Website').to eql('<title>My Awesome Website</title>
<link rel="site" href="My Awesome Website" />')
  end
end
