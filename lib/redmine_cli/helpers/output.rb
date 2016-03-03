
module RedmineCLI
  module Helpers
    #
    # Helpers for output
    #
    module Output
      #
      # Alias for TemplateRenderer#render
      #
      def erb(template, vars = {})
        RedmineCLI::TemplateRenderer.render(template, vars)
      end

      #
      # Gets text from I18n and replaces params
      # e.g.
      #   I18n.t(:hello) => 'Hello, {{ user }}'
      #   message(:hello, user: 'Vasya') => 'Hello, Vasya'
      #
      # @param name [Symbol]
      # @param params [Hash] optional
      #
      def message(name, params = {})
        result = I18n.t name
        params.each { |k, e| result.gsub!("{{ #{k} }}", e.to_s) }
        result
      end

      alias m message
    end
  end
end
