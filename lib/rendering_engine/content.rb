require 'erb'

module RenderingEngine
  class Content
    attr_reader :file_path, :data

    def initialize(file_path, opts={})
      @file_path        = file_path
      @base_folder_path = opts[:base_folder_path]
      @data             = opts[:data]
      @custom_helper    = opts[:custom_helper]
    end

    def source
      @source ||= (
        case kind
        when :orginal  then File.read(file_path)
        when :template
          ERB.new(File.read(file_path_as_erb)).result(
            helper(base_folder_path, data).instance_eval { binding }
          )
        else ''
        end
      )
    end

    def kind
      @kind ||= (
        if orginal_file_present?
          :orginal
        elsif file_as_erb_present?
          :template
        else
          :unknown
        end
      )
    end

    def template?
      kind == :template
    end

    def orginal?
      kind == :orginal
    end

    def unknown?
      kind == :unknown
    end

    def base_folder_path
      @base_folder_path ||= File.dirname(file_path)
    end

    private

    attr_reader :custom_helper

    def helper(path, content_data)
      (custom_helper || ContentHelpers).new(base_path: path, data: content_data)
    end

    def orginal_file_present?
      File.exist?(file_path)
    end

    def file_as_erb_present?
      File.exist?(file_path_as_erb)
    end

    def file_path_as_erb
      @file_as_erb ||= "#{file_path}.erb"
    end
  end
end
