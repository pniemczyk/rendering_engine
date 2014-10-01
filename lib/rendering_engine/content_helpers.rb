module RenderingEngine
  class ContentHelpers
    def initialize(file_repo, opts = {})
      @file_repo = file_repo
      @base_path = opts.fetch(:base_path)
      @data      = opts[:data]
    end

    def render(file_relative_path, optional_data = nil)
      file_path = File.join(base_path, file_relative_path)
      rendering_data = optional_data || data

      RenderingEngine::Content.new(file_repo, file_path, data: rendering_data).source
    end

    attr_reader :data

    private

    attr_reader :base_path, :file_repo
  end
end
