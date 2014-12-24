module Middleman
  module MetaTags
    module Helpers
      def meta_tags
        @meta_tags ||= {}
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
        meta_tags = default.merge(self.meta_tags)

        title = full_title(meta_tags)
        result << content_tag(:title, title) unless title.blank?

        description = safe_description(meta_tags.delete(:description))
        result << tag(:meta, name: :description, content: description) unless description.blank?

        keywords = meta_tags.delete(:keywords)
        result << tag(:meta, name: :keywords, content: keywords) unless keywords.blank?

        meta_tags.each do |name, content|
          result << tag(:meta, name: name, content: content ) unless content.blank?
        end

        result = result.join("\n")
        result.html_safe
      end

      def auto_display_meta_tags(default = {})
        auto_tag

        display_meta_tags default
      end

      def auto_tag
        site_data = data['site'] || {}

        set_meta_tags site: site_data['title']
        set_meta_tags 'og:site_name' => site_data['title']

        fall_through(site_data, :title, 'title')
        fall_through(site_data, :description, 'description')

        # Twitter cards
        fall_through(site_data, 'twitter:card', 'twitter_card', 'summary_large_image')
        fall_through(site_data, 'twitter:creator', 'twitter_author')
        fall_through(site_data, 'twitter:description', 'description')
        fall_through(site_data, 'twitter:image:src', 'pull_image')
        fall_through(site_data, 'twitter:site', 'publisher_twitter')
        fall_through(site_data, 'twitter:title', 'title')

        # Open Graph
        fall_through(site_data, 'og:description', 'description')
        fall_through(site_data, 'og:image', 'pull_image')
        fall_through(site_data, 'og:title', 'title')
      end

    private

      def fall_through(site_data, name, key, default = nil)
        value = current_page.data[key] || site_data[key] || default
        set_meta_tags name => value unless value.blank?
        value
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
        truncate(strip_tags(description), length: 200)
      end

      def safe_title(title)
        title = strip_tags(title)
      end
    end
  end
end
