require 'thor'
require 'redmine_rest'

module RedmineCLI
  module Subcommands
    #
    # All methods for working with issues, e.g. listing, linking, updating...
    #
    class Issue < Thor
      extend Helpers::Output

      include RedmineRest
      include Helpers::Output

      desc 'list [user]', m('desc.issue.list')
      def list(id = 'current')
        fail('new config') if Config.new?

        puts erb('issue/list', issues: Models::User.find(id).issues)
      end

      desc 'show <id>', m('desc.issue.show')
      def show(id)
        puts erb('issue/show', issue: Models::Issue.find(id))
      #
      # WARNING: it can be raised by associations in template
      #
      rescue ActiveResource::ResourceNotFound
        puts m(:not_found)
      end
    end
  end
end
