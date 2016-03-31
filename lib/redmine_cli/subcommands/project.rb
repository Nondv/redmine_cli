require 'thor'
require 'redmine_rest'
module RedmineCLI
  module Subcommands
    #
    # Methods for working with projects
    #
    class Project < Thor
      extend Helpers::Output

      include RedmineRest
      include Helpers::Output
      include Helpers::Input

      map 'users' => 'members'

      desc 'list', m('desc.project.list')
      def list
        puts erb('id_and_name_list', list: Models::Project.all)
      end

      desc 'members <id | name part>', m('desc.project.members')
      def members(project)
        project = InputParser.parse_project(project)

        users = project.members
                       .map(&:reload)
                       .sort { |a, b| a.id.to_i <=> b.id.to_i }

        puts erb('user/find', users: users)
      rescue ProjectNotFound
        puts "Project #{m(:not_found)}"
      end
    end
  end
end
