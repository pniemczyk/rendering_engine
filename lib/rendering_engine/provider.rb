module RenderingEngine
  class Provider
    def initialize(base_path)
      @base_path = base_path
    end

    def get(relative_path)
      file_path = File.join(base_path, relative_path)
      Content.new(file_path)
    end

    private

    attr_reader :base_path
  end
end
