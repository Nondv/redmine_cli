require 'thor'
require 'redmine_rest'
module RedmineCLI
  module Subcommands
    #
    # All methods for working with users
    #
    class User < Thor
      extend Helpers::Output

      include RedmineRest
      include Helpers::Output
      include Helpers::Input

      desc 'find [id|name|email]', m('desc.user.find')
      def find(*args)
        input = args.join ' '

        puts erb('user/find', users: users_from_input(input))
      end

      private

      def users_from_input(input)
        if input.empty? || !input.to_i.zero? # TODO: numeric?
          [Models::User.find(input.empty? ? 'current' : input.to_i)]
        else
          Models::User.all_by_name_or_mail(input).sort { |a, b| a.id.to_i <=> b.id.to_i }
        end
      end
    end
  end
end
