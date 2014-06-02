module RenderingEngine
  class ContentHelpers
    def initialize(opts={})
      @base_path = opts.fetch(:base_path)
      @data      = opts[:data]
    end

    def render(file_relative_path, optional_data=nil)
      file_path = File.join(base_path, file_relative_path)
      renering_data = optional_data || data

      RenderingEngine::Content.new(file_path, data: renering_data).source
    end

    attr_reader :data

    private

    attr_reader :base_path
  end
end
