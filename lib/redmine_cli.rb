require 'thor'
require 'redmine_rest'
require 'i18n'

I18n.load_path = Dir["#{File.dirname __FILE__}/assets/messages/*"]

# helpers
Dir[File.expand_path('../redmine_cli/helpers/*.rb', __FILE__)].each { |f| require f }

require 'redmine_cli/version'
require 'redmine_cli/exceptions'
require 'redmine_cli/config'
I18n.locale = RedmineCLI::Config['locale']

require 'redmine_cli/template_renderer'
Dir[File.expand_path('../redmine_cli/subcommands/*.rb', __FILE__)].each { |f| require f }

#
# base namespace
#
module RedmineCLI
  include RedmineRest

  #
  # Main CLI class
  #
  class Client < Thor
    extend Helpers::Output

    map %w(--version -v) => :__print_version

    desc '--version, -v', 'print the version'
    # two underscores hides method from help
    def __print_version
      puts "redmine_cli version #{VERSION}"
    end

    desc 'issue ...', m('desc.client.issue')
    subcommand 'issue', Subcommands::Issue

    desc 'conf ...', m('desc.client.conf')
    subcommand 'conf', Subcommands::Conf

    desc 'user ...', m('desc.client.user')
    subcommand 'user', Subcommands::User
  end
end
