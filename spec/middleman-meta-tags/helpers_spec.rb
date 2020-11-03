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

  describe "meta_tags_image_url" do
    before do
      allow(h).to receive(:data).and_return(
        {
          "site" => {
            "host" => "https://example.com"
          }
        }
      )
    end

    it "returns a URL when image is given" do
      expect(
        h.send(:meta_tags_image_url, "/awesome/image.jpg")
      ).to eq("https://example.com/awesome/image.jpg")
    end

    it "returns nil when image is nil" do
      expect(
        h.send(:meta_tags_image_url, nil)
      ).to be_nil
    end
  end
end
