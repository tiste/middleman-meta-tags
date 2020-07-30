module Middleman
  module MetaTags
    module Helpers
      def meta_tags
        @meta_tags ||= ActiveSupport::HashWithIndifferentAccess.new
      end

      def link_tags
        @link_tags ||= ActiveSupport::HashWithIndifferentAccess.new
      end

      def set_meta_tags(meta_tags = {})
        self.meta_tags.merge! meta_tags
      end

      def set_link_tags(link_tags = {})
        self.link_tags.merge! link_tags
      end

      def site_data
        (data['site'] || {}).with_indifferent_access
      end

      def title(title = nil)
        set_meta_tags(title: title) unless title.nil?
      end

      def description(description = nil)
        set_meta_tags(description: description) unless description.nil?
      end

      def keywords(keywords = nil)
        set_meta_tags(keywords: keywords) unless keywords.nil?
      end

      def display_meta_tags(default = {})
        result    = []
        meta_tags = default.merge(self.meta_tags).with_indifferent_access
        link_tags = default.merge(self.link_tags)

        charset = meta_tags.delete(:charset)
        result << tag(:meta, charset: charset) if charset.present?

        viewport = meta_tags.delete(:viewport)
        result << tag(:meta, name: :viewport, content: viewport) if viewport.present?

        http_equiv = meta_tags.delete('http-equiv')
        result << tag(:meta, 'http-equiv': 'X-UA-Compatible', content: http_equiv) if http_equiv.present?

        need_full_title = true
        need_full_title = meta_tags['full_title'] unless meta_tags['full_title'].nil?
        need_full_title = current_page.data['full_title'] unless current_page.data['full_title'].nil?
        title = need_full_title ? full_title(meta_tags) : safe_title(meta_tags[:title])
        meta_tags.delete(:title)
        meta_tags.delete(:separator)
        result << content_tag(:title, title) if title.present?

        description = safe_description(meta_tags.delete(:description))
        result << tag(:meta, name: :description, content: description) if description.present?

        keywords = meta_tags.delete(:keywords)
        keywords = keywords.join(', ') if keywords.is_a?(Array)
        result << tag(:meta, name: :keywords, content: keywords) if keywords.present?

        refresh = meta_tags.delete(:refresh)
        result << tag(:meta, {content: refresh, 'http-equiv': 'refresh'}) if refresh.present?

        meta_tags.each do |name, content|
          unless content.blank? || %(site latitude longitude).include?(name)
            if name.start_with?('itemprop:')
              result << tag(:meta, itemprop: name.gsub('itemprop:', ''), content: content)
            elsif name.start_with?('og:')
              result << tag(:meta, property: name, content: content)
            else
              result << tag(:meta, name: name, content: content)
            end
          end
        end

        position = [meta_tags.delete(:latitude), meta_tags.delete(:longitude)] if meta_tags['latitude'] && meta_tags['longitude']
        result << tag(:meta, name: 'geo:position', content: position.join(';')) if position
        result << tag(:meta, name: 'ICBM', content: position.join(', ')) if position

        link_tags.each do |rel, href|
          if href.kind_of?(Array)
            href.each do |link|
              result << tag(:link, rel: rel, href: link)
            end
          else
            result << tag(:link, rel: rel, href: href) unless href.blank?
          end
        end

        result = result.join("\n")
        result.html_safe
      end

      def auto_display_meta_tags(default = {})
        auto_set_meta_tags

        display_meta_tags default
      end

      def auto_set_meta_tags
        geocoding_data = site_data['geocoding']
        author_data    = site_data['author']

        set_meta_tags charset:      'utf-8',
                      viewport:     'width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no',
                      'http-equiv': 'IE=edge,chrome=1'

        fall_through(site_data, :site, 'name')
        fall_through(site_data, :site, 'site')
        fall_through(site_data, :title, 'title')
        fall_through(site_data, :description, 'description')
        fall_through(site_data, :keywords, 'keywords')

        # Microdata
        fall_through(site_data,       'itemprop:name', 'name')
        fall_through(site_data,       'itemprop:name', 'site')
        fall_through(site_data,       'itemprop:name', 'title')
        fall_through(site_data,       'itemprop:description', 'description')
        fall_through_image(site_data, 'itemprop:image', 'thumbnail')

        # Twitter cards
        set_meta_tags                 'twitter:card': 'summary_large_image'
        fall_through(site_data,       'twitter:card', 'twitter_card')
        fall_through(site_data,       'twitter:site', 'name')
        fall_through(site_data,       'twitter:site', 'site')
        fall_through(author_data,     'twitter:creator', 'twitter')
        set_meta_tags                 'twitter:url': current_page_url
        fall_through(site_data,       'twitter:url', 'url')
        fall_through(site_data,       'twitter:title', 'name')
        fall_through(site_data,       'twitter:title', 'site')
        fall_through(site_data,       'twitter:title', 'title')
        fall_through(site_data,       'twitter:description', 'description')
        fall_through_image(site_data, 'twitter:image', 'thumbnail')

        # Open Graph
        set_meta_tags                 'og:url': current_page_url
        fall_through(site_data,       'og:url', 'url')
        set_meta_tags                 'og:type': 'website'
        fall_through(site_data,       'og:type', 'type')
        fall_through(site_data,       'og:title', 'name')
        fall_through(site_data,       'og:title', 'site')
        fall_through(site_data,       'og:title', 'title')
        fall_through_image(site_data, 'og:image', 'thumbnail')
        fall_through(site_data,       'og:description', 'description')
        fall_through(site_data,       'og:site_name', 'name')
        fall_through(site_data,       'og:site_name', 'site')
        set_meta_tags                 'og:locale': 'en_US'
        fall_through(site_data,       'og:locale', 'locale')

        # Theme color
        fall_through(site_data,       'theme-color', 'base_color')
        fall_through(site_data,       'msapplication-TileColor', 'base_color')

        # Geocoding
        fall_through(geocoding_data, 'latitude', 'latitude')
        fall_through(geocoding_data, 'longitude', 'longitude')
        fall_through(geocoding_data, 'geo.placename', 'place')
        fall_through(geocoding_data, 'geo.region', 'region')

        # Author
        set_link_tags author: author_data['website'] if author_data['website']
        set_link_tags license: site_data['license'] if site_data['license']

        me_link_tags = []
        me_link_tags << author_data['website'] if author_data['website']
        me_link_tags << "mailto:#{author_data['email']}" if author_data['email'].present?
        me_link_tags += ["tel:#{author_data['phone']}", "sms:#{author_data['phone']}"] if author_data['phone'].present?
        %w(github twitter dribbble medium linkedin facebook instagram gitlab bitbucket).each do |social|
          me_link_tags << "https://#{social}#{['bitbucket'].include?(social) ? '.org' : '.com'}/#{'in/' if social == 'linkedin'}#{author_data[social]}" if author_data[social].present?
          set_link_tags me: me_link_tags
        end
      end

      private

      def fall_through(site_data, name, key, default = nil)
        value = current_page.data[key] ||
                meta_tags[key] ||
                site_data[key] ||
                default

        value = yield value if block_given?

        value = safe_title(value) if key == 'title'
        value = safe_description(value) if key == 'description'

        set_meta_tags name => value if value.present?
        value
      end

      def fall_through_image(*args)
        fall_through(*args) do |path|
          uri?(path) && path ? path : meta_tags_image_url(path)
        end
      end

      def current_page_url
        meta_tags_host + current_page.url unless (data['site'] || {})['host'].nil?
      end

      def meta_tags_image_url(source)
        File.join(meta_tags_host, image_path(source))
      end

      def meta_tags_host
        (data['site'] || {})['host'] || ''
      end

      def uri?(path)
        path =~ %r{^[-a-z]+://|^(?:cid|data):|^//}
      end

      def full_title(meta_tags)
        separator   = meta_tags[:separator] || '-'
        full_title  = ''
        title       = safe_title(meta_tags[:title])

        (full_title << title) if title.present?
        (full_title << " #{separator} ") unless title.blank? || meta_tags[:site].blank?
        (full_title << meta_tags[:site]) if meta_tags[:site].present?
        full_title
      end

      def safe_description(description)
        description = description[I18n.locale] if description.is_a?(Hash) && description[I18n.locale]

        description = I18n.t(description[2..-1]) if description&.start_with?('t:')

        truncate(strip_tags(description), length: 220)
      end

      def safe_title(title)
        title = title[I18n.locale] if title.is_a?(Hash) && title[I18n.locale]

        title = I18n.t(title[2..-1]) if title&.start_with?('t:')

        strip_tags(title)
      end
    end
  end
end
