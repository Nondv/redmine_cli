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
        puts erb('issue/show', issue: Models::Issue.find(id), journals_limit: options[:limit])

      rescue ActiveResource::ResourceNotFound # WARNING: it can be raised by associations in template
        puts m(:not_found)
      end

      #
      # TODO:
      # * status
      # * estimated time
      # * priority
      # * subject
      # * tracker
      # * project
      # * version
      # * description
      # * comment
      # * time entry
      # * parent (?) - mb it will be in command for relations
      #
      desc 'update <id>', m('desc.issue.update')
      option :done, aliases: '-d', type: :numeric, desc: m('desc.issue.options.update.done')
      option :assign, aliases: '-a', type: :numeric, desc: m('desc.issue.options.update.assign')
      def update(id)
        issue = Models::Issue.find(id)

        issue.done_ratio = options[:done] if options[:done]
        update_assigned_to(issue) if options[:assign]

        puts m(issue.save ? :success : :error)
      rescue ActiveResource::ResourceNotFound
        puts m(:not_found)
      rescue UserNotFound => e
        puts e
      end

      private

      def update_assigned_to(issue)
        issue.assigned_to_id = options[:assign] if Models::User.find(options[:assign])
      rescue ActiveResource::ResourceNotFound
        raise(UserNotFound, 'Assign: ' + m(:not_found))
      end
    end
  end
end
