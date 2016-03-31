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

      desc 'list', m('desc.project.list')
      def list
        puts erb('id_and_name_list', list: Models::Project.all)
      end
    end
  end
end
