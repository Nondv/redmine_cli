require 'thor'
require 'redmine_rest'
require 'i18n'

# helpers
Dir[File.expand_path('../redmine_cli/helpers/*.rb', __FILE__)].each { |f| require f }

require 'redmine_cli/version'
require 'redmine_cli/config'
require 'redmine_cli/template_renderer'
Dir[File.expand_path('../redmine_cli/subcommands/*.rb', __FILE__)].each { |f| require f }

I18n.load_path = Dir["#{File.dirname __FILE__}/assets/messages/*"]
I18n.locale = RedmineCLI::Config['locale'] || :en

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

    desc 'issue ...', m('desc.client.issue')
    subcommand 'issue', Subcommands::Issue
  end
end
