require 'thor'
require 'redmine_rest'

module RedmineCLI
  module Subcommands
    #
    # All methods for working with issues, e.g. listing, linking, updating...
    #
    class Issue < Thor
      include RedmineRest
      include Helpers::Output

      desc 'list', 'Shows your current issues'
      def list
        fail('new config') if Config.new?

        puts erb('issue/list', issues: Models::User.find('current').issues)
      end
    end
  end
end
