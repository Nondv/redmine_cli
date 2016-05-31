require 'erb'
require 'colorize'

require_relative 'config'

module RedmineCLI
  #
  # Renders templates
  #
  module TemplateRenderer
    @template_directory = File.expand_path("../../assets/templates/#{Config.locale}", __FILE__)

    #
    # finds template and renders it
    #
    # @param template [String, Symbol] name of template. Use 'dir1/dir2/name' means assets/templates/dir1/dir2/name.erb
    #
    def self.render(template, variables = {})
      path = File.expand_path(template.to_s, @template_directory) + '.erb'
      fail "Template not found: #{path}" unless File.exist? path

      ErbEnvironment.new(File.read(path), variables).render
    end

    #
    # Class for renderer. Don't use it outside
    #
    class ErbEnvironment
      include Helpers::Output

      def initialize(template, vars = {})
        @template = template
        @vars = vars
      end

      def method_missing(m, *args)
        return @vars[m] if args.empty? && @vars.key?(m)

        super
      end

      def render
        ERB.new(@template, nil, '%<>').result(binding)
      end
    end
  end
end
