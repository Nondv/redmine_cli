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
      option :limit, aliases: ['-l'], type: :numeric, default: 5, desc: m('desc.issue.options.show.limit')
      def show(id)
        puts erb('issue/show', issue: Models::Issue.find(id))
      rescue ActiveResource::ResourceNotFound
        puts m(:not_found)
      end
    end
  end
end
