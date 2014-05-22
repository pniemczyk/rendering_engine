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

      content = content_provider.get(path)
      return not_found if content.unknown?

      render text: content.source
    end

    def content_provider
      @content_provider ||= RenderingEngine::Provider.new(Rails.root.join('app/content'))
    end
    ---

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
