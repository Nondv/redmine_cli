require 'thor'

module RedmineCLI
  module Subcommands
    #
    # All methods for working with config file
    #
    class Conf < Thor
      extend Helpers::Output

      include Helpers::Output
      include Helpers::Input

      desc 'init', m('desc.conf.init')
      def init
        Config['user'] = ask m('commands.conf.init.enter_user'), default: Config['user']
        Config['password'] = ask m('commands.conf.init.enter_password'), default: Config['password']
        Config['site'] = ask_url m('commands.conf.init.enter_site'), default: Config['site']
        Config['just_created'] = false

        Config.save

        puts m(:thank_you)
      end
    end
  end
end
