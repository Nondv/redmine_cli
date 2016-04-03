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

        user = InputParser.parse_user(id)
        puts erb('issue/list', issues: user.issues)
      rescue UserNotFound
        puts "User #{m(:not_found)}"
      end

      desc 'show <id>', m('desc.issue.show')
      option :limit, aliases: ['-l'], type: :numeric, default: 5, desc: m('desc.issue.options.show.limit')
      option :comments_only, aliases: ['-c'], type: :boolean, desc: m('desc.issue.options.show.comments')
      def show(id)
        puts erb 'issue/show',
                 issue: Models::Issue.find(id),
                 journals_limit: options[:limit],
                 comments_only: options[:comments_only]

      rescue ActiveResource::ResourceNotFound # WARNING: it can be raised by associations in template
        puts m(:not_found)
      end

      desc 'complete <id>', m('desc.issue.complete')
      def complete(id)
      end

      #
      # TODO:
      # * estimated time
      # * priority
      # * subject
      # * tracker
      # * project
      # * version
      # * parent (?) - mb it will be in command for relations
      #
      desc 'update <id>', m('desc.issue.update')
      option :done,          type: :numeric, aliases: '-d', desc: m('desc.issue.options.update.done')
      option :assign,        type: :string, aliases: '-a', desc: m('desc.issue.options.update.assign')
      option :time,          type: :string, aliases: '-t', desc: m('desc.issue.options.update.time')
      option :status,        type: :string, aliases: '-s', desc: m('desc.issue.options.update.status')
      option :comment,       type: :boolean, aliases: '-c', desc: m('desc.issue.options.update.comment')
      option :description,   type: :boolean, desc: m('desc.issue.options.update.description')
      def update(id)
        # load helpers inside instance method for better performance
        self.class.include Helpers::Issue::Update

        issue = Models::Issue.find(id)
        if update_issue(issue) # update_issue will return nil/false if something goes wrong
          puts m(issue.save ? :success : :error)
        else
          @errors.each { |e| puts e }
        end

      rescue ActiveResource::ResourceNotFound
        puts m(:not_found)
      end

      desc 'create', m('desc.issue.create')
      def create
        self.class.include Helpers::Issue::Create

        @issue = Models::Issue.new
        set_attributes

        @issue.save
        puts 'Done.'
      end
    end
  end
end
