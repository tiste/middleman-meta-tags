# Middleman MetaTags

SEO gem for your Middleman apps.

Based on [meta-tags](https://github.com/kpumuk/meta-tags) Rails gem.

## Installation

Add this line to your application's Gemfile:

    gem 'middleman-meta-tags'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install middleman-meta-tags

## Usage

### Configuration

Edit `config.rb` and add:

```rb
activate :meta_tags
```

### Title

```rb
set_meta_tags title: 'Relevant title'
title 'Relevant title'
```

### Description

```rb
set_meta_tags description: 'Powerful website full of best practices and keywords'
description 'Powerful website full of best practices and keywords'
```

### Keywords

```rb
set_meta_tags keywords: %w(some seo keywords).join(', ')
keywords %w(some seo keywords).join(', ')
```

### Meta-Refresh

To set the HTTP Meta-Refresh property of a page, use the `refresh` key:

```rb
set_meta_tags refresh: "0;url=http://example.com/"
```

## Display meta tags

Into your `<head></head>` tag:

```rb
display_meta_tags site: 'My Awesome Website'
```

By default, there is a `|` as separator between title and website name.

You can modify it by adding: `separator: '&raquo;'`

## Autotagging

If you want to enable auto meta tagging, put this in you `<head></head>` tag:

```rb
auto_display_meta_tags
```

This will look inside of `data/site.yml` file to find any site wide defaults.
Then it looks the page meta data to attempt to display the following keys:

- MM `site` => META `title`
- MM `title` => META `title`
- MM `description` => META `description`
- MM `keywords` => META `keywords`
- MM `twitter_card` (defaults to `summary_large_image`) => META `twitter:card`
- MM `twitter_author` => META `twitter:creator`
- MM `description` => META `twitter:description`
- MM `thumbnail` => META `twitter:image:src`
- MM `publisher_twitter` => META `twitter:site`
- MM `title` => META `twitter:title`
- MM `description` => META `og:description`
- MM `thumbnail` => META `og:image`
- MM `site` => META `og:site_name`
- MM `title` => META `og:title`
- MM `host` => optional attribute for composing `thumbnail` src with asset helper

In addition, if you want to customize meta tags by each page's frontmatter, you
can add `customize_by_frontmatter: true` in `data/site.yml`. The priority would
be set_meta_tags > frontmatter > site wide defaults.

### Manually adding addition tags

Create a helper method inside of your config.rb, like so

```rb
helper do
  def my_tags
    set_meta_tags key => value
  end
end
```

And add it to the layouts and views that you need.

### Pull images

For the `thumbnail` to render for twitter metatags, a full url must be used:

```
thumbnail: 'http://example.com/path/to/image.jpg'
```

If pointing to an image in your Middleman source, you can instead specify the
relative image path as you would with an asset helper provided you have also
configured the `host` in your `site.yml`. If your Middleman build activates
extensions like `:asset_hash`, the full, hashed URL will be generated in your
metatags.

```
# site.yml
host: http://example.com

# your article
thumbnail 'page/to/image/jpg'
```

## Contributing

1. [Fork it](http://github.com/tiste/middleman-meta-tags/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Publishing

1. Update `./lib/middleman-meta-tags/version.rb` and CHANGELOG.md
2. `gem build middleman-meta-tags.gemspec`
3. `bundle exec rake release`
