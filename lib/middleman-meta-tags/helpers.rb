module Middleman
  module MetaTags
    module Helpers
      def meta_tags
        @meta_tags ||= ActiveSupport::HashWithIndifferentAccess.new
      end

      def set_meta_tags(meta_tags = {})
        self.meta_tags.merge! meta_tags
      end

      def description(description = nil)
        set_meta_tags(description: description) unless description.nil?
      end

      def keywords(keywords = nil)
        set_meta_tags(keywords: keywords) unless keywords.nil?
      end

      def title(title = nil)
        set_meta_tags(title: title) unless title.nil?
      end

      def display_meta_tags(default = {})
        result    = []
        meta_tags = default.merge(self.meta_tags).with_indifferent_access

        title = full_title(meta_tags)
        meta_tags.delete(:title)
        meta_tags.delete(:separator)
        result << content_tag(:title, title) unless title.blank?

        description = safe_description(meta_tags.delete(:description))
        result << tag(:meta, name: :description, content: description) unless description.blank?

        keywords = meta_tags.delete(:keywords)
        keywords = keywords.join(', ') if keywords.is_a?(Array)
        result << tag(:meta, name: :keywords, content: keywords) unless keywords.blank?

        meta_tags.each do |name, content|
          if name.start_with?('og:')
            result << tag(:meta, property: name, content: content ) unless content.blank?
          else
            result << tag(:meta, name: name, content: content ) unless content.blank?
          end
        end

        result = result.join("\n")
        result.html_safe
      end

      def auto_display_meta_tags(default = {})
        auto_tag

        display_meta_tags default
      end

      def auto_tag
        site_data = (data['site'] || {}).with_indifferent_access

        set_meta_tags site: site_data['site']
        set_meta_tags 'og:site_name' => site_data['site']

        fall_through(site_data, :title, 'title')
        fall_through(site_data, :description, 'description')
        fall_through(site_data, :keywords, 'keywords')

        # Twitter cards
        fall_through(site_data, 'twitter:card', 'twitter_card', 'summary_large_image')
        fall_through(site_data, 'twitter:creator', 'twitter_author')
        fall_through(site_data, 'twitter:description', 'description')
        fall_through_image(site_data, 'twitter:image:src', 'pull_image')
        fall_through(site_data, 'twitter:site', 'publisher_twitter')
        fall_through(site_data, 'twitter:title', 'title')

        # Open Graph
        fall_through(site_data, 'og:description', 'description')
        fall_through_image(site_data, 'og:image', 'pull_image')
        fall_through(site_data, 'og:title', 'title')
      end

    private

      def fall_through(site_data, name, key, default = nil)
        need_customized = site_data[:customize_by_frontmatter]
        value = self.meta_tags[key] ||
                (need_customized && current_page.data[key]) ||
                site_data[key] ||
                default
        value = yield value if block_given?

        if key === "description"
          value = safe_description(value)
        end

        if key === "title"
          value = safe_title(value)
        end

        set_meta_tags name => value unless value.blank?
        value
      end

      def fall_through_image(*args)
        fall_through(*args) do |path|
          is_uri?(path) ? path : meta_tags_image_url(path)
        end
      end

      def meta_tags_image_url(source)
        meta_tags_host + image_path(source)
      end

      def meta_tags_host
        (data['site'] || {})['host'] || ''
      end

      # borrowed from Rails 3
      # http://apidock.com/rails/v3.2.8/ActionView/AssetPaths/is_uri%3F
      def is_uri?(path)
        path =~ %r{^[-a-z]+://|^(?:cid|data):|^//}
      end

      def full_title(meta_tags)
        separator   = meta_tags[:separator] || '|'
        full_title  = ''
        title       = safe_title(meta_tags[:title])

        (full_title << title) unless title.blank?
        (full_title << " #{separator} ") unless title.blank? || meta_tags[:site].blank?
        (full_title << meta_tags[:site]) unless meta_tags[:site].blank?
        full_title
      end

      def safe_description(description)
        if description.is_a?(Hash) && description[I18n.locale]
          description = description[I18n.locale]
        end

        if description && description.start_with?('t:')
          description = I18n.t(description[2..-1])
        end

        truncate(strip_tags(description), length: 200)
      end

      def safe_title(title)
        if title.is_a?(Hash) && title[I18n.locale]
          title = title[I18n.locale]
        end

        if title && title.start_with?('t:')
          title = I18n.t(title[2..-1])
        end

        title = strip_tags(title)
      end
    end
  end
end
