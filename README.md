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

### Title

```rb
set_meta_tags title: 'My Awesome Website'
title 'My Awesome Website'
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

## Display meta tags

Into your `<head></head>` tag:

```rb
display_meta_tags site: 'My Awesome Website'
```

By default, there is a `|` as separator between title and website name.

You can modify it by adding: `separator: '&raquo;'`

## Contributing

1. [Fork it](http://github.com/tiste/middleman-meta-tags/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
