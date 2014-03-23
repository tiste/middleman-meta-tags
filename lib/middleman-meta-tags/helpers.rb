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

        result = result.join("\n")
        result.html_safe
      end

    private

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
