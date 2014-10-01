# RenderingEngine

[![Gem Version](https://badge.fury.io/rb/rendering_engine.svg)](http://badge.fury.io/rb/rendering_engine)
[![Build Status](https://travis-ci.org/pniemczyk/rendering_engine.svg?branch=0.2.0)](https://travis-ci.org/pniemczyk/rendering_engine)
[![Dependency Status](https://gemnasium.com/pniemczyk/rendering_engine.svg)](https://gemnasium.com/pniemczyk/rendering_engine)
[![Coverage Status](https://coveralls.io/repos/pniemczyk/rendering_engine/badge.png)](https://coveralls.io/r/pniemczyk/rendering_engine)

## Installation

Add this line to your application's Gemfile:

    gem 'rendering_engine'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rendering_engine

## Usage

    $ file_repo        = RenderingEngine::FileRepo.new(base_path)
    $ content_provider = RenderingEngine::Provider.new(file_repo)
    $ content = content_provider.get(relative_file_path)
    $ content.source #gets source of file (rendered or not :D)
    $ content.kind return (:orginal, :template, :unknown)

    In controller can looks like this:

    ---
    def show
      path = "#{params[:client]}/#{params[:path]}"
      data = params[:data]

      content = content_provider.get(path, data: data)
      return not_found if content.unknown?

      render text: content.source
    end

    def content_provider
      @content_provider ||= RenderingEngine::Provider.new(file_repo)
    end

    def file_repo
      @file_repo ||= RenderingEngine::FileRepo(Rails.root.join('app/content'))
    end
    ---

## Own File repository class
needed gems 'moped' and 'moped-gridfs'

```
class MongoFileRepo
  def initilaize(mongo)
    @mongo = mongo
  end

  def get(file_path)
    bucket.open(file_path, 'r+')
  end

  def read(file_path)
    bucket.open(file_path, 'r').read
  end

  def exist?(file_path)
    bucket.files.select { |f| f.filename == file_path }.count > 0
  end

  def save(file_path, body, opts = {})
    file_opts = opts.merge(filename: file_path)
    bucket.open(file_opts , 'w+').write(body)
  end

  def delete(file_path)
    bucket.delete(file_path)
  end

  def file_dirname(file_path)
    File.dirname(file_path)
  end

  private

  attr_reader :mongo

  def bucket
    @bucket ||= mongo.bucket
  end
end
```

### Usage own custom file repository class

```

mongo = Moped::Session.new(['127.0.0.1:27017'], database: 'test')
file_repo = MongoFileRepo(mongo)
provider = RenderingEngine::Provider.new(file_repo)
provider.get(path, custom_helper: ContentCustomHelpers).source

```

## Own Helper class

```

class ContentCustomHelpers
  def initialize(opts={})
    @base_path = opts.fetch(:base_path)
    @data      = opts[:data]
  end

  def make_some_stuff
    "best line ever!"
  end

  def render(file_relative_path)
    file_path = File.join(base_path, file_relative_path)

    RenderingEngine::Content.new(file_path, data: data, custom_helper: self.class).source
  end

  attr_reader :data

  private

  attr_reader :base_path
end


```

### Usage own custom helper class

```

file_repo = RenderingEngine::FileRepo.new(Rails.root.join('app/content'))
provider = RenderingEngine::Provider.new(file_repo, custom_helper: ContentCustomHelpers)
provider.get(path).source

```

or

```

file_repo = RenderingEngine::FileRepo.new(Rails.root.join('app/content'))
provider = RenderingEngine::Provider.new(file_repo)
provider.get(path, custom_helper: ContentCustomHelpers).source

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
