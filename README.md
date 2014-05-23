# RenderingEngine

## Installation

Add this line to your application's Gemfile:

    gem 'rendering_engine'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rendering_engine

## Usage

    $ content_provider = RenderingEngine::Provider.new(base_path)
    $ content = content_provider.get(relative_file_path)
    $ content.source #gets source of file (rendered or not :D)
    $ content.kind return (:orginal, :template, :unknown)

    In controller can looks like this:

    ---
    def show
      path = "#{params[:client]}/#{params[:path]}"
      data = params[:data]

      content = content_provider.get(path, data)
      return not_found if content.unknown?

      render text: content.source
    end

    def content_provider
      @content_provider ||= RenderingEngine::Provider.new(Rails.root.join('app/content'))
    end
    ---

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

### Usage own custom class

```

provider = RenderingEngine::Provider.new(Rails.root.join('app/content'), custom_helper: ContentCustomHelpers)
provider.get(path).source

```

or

```

provider = RenderingEngine::Provider.new(Rails.root.join('app/content'))
provider.get(path, custom_helper: ContentCustomHelpers).source


```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
