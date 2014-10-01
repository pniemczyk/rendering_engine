module RenderingEngine
  class Provider
    def initialize(file_repo, base_opts = {})
      @file_repo = file_repo
      @base_opts = base_opts
    end

    def get(file_path, opts = {})
      content_opts = base_opts.merge(opts)
      Content.new(file_repo, file_path, content_opts)
    end

    private

    attr_reader :file_repo, :base_opts
  end
end
