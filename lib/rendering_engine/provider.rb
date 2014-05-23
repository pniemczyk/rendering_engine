module RenderingEngine
  class Provider
    def initialize(base_path, base_opts={})
      @base_path = base_path
      @base_opts = base_opts
    end

    def get(relative_path, opts={})
      file_path    = File.join(base_path, relative_path)
      content_opts = base_opts.merge(opts)
      Content.new(file_path, content_opts)
    end

    private

    attr_reader :base_path, :base_opts
  end
end
