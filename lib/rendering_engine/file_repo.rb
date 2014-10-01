module RenderingEngine
  class FileRepo
    attr_reader :base_path

    def initialize(base_path)
      @base_path = base_path
    end

    def read(file_path)
      File.read(full_file_path(file_path))
    end

    def exist?(file_path)
      File.exist?(full_file_path(file_path))
    end

    def file_dirname(file_path)
      File.dirname(file_path)
    end

    private

    def full_file_path(file_path)
      File.join(base_path, file_path)
    end
  end
end
