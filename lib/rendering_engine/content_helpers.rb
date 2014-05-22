module RenderingEngine
  class ContentHelpers
    def initialize(opts={})
      @base_path = opts.fetch(:base_path)
    end

    def render(file_relative_path)
      file_path = File.join(base_path, file_relative_path)

      RenderingEngine::Content.new(file_path).source
    end

    private

    attr_reader :base_path
  end
end
