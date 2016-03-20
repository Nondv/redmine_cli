require 'non_config'
require 'redmine_rest'

module RedmineCLI
  #
  # Class that stores configuration and manipulates with it
  #
  class Config < NonConfig::Base
    @path_to_config = File.expand_path('.redmine_cli', Dir.home)

    def self.configure_rest
      RedmineRest::Models.configure_models user: user,
                                           password: password,
                                           site: site
    rescue
      puts '!!!'
      puts 'Looks like your config file is corrupted or it was just created.'
      puts 'Please, use `redmine conf init`'
      puts '!!!'
      puts
    end

    def self.create_config
      defaults = { 'just_created' => true,
                   'user' => nil,
                   'password' => nil,
                   'site' => nil }
      File.open(@path_to_config, 'w') { |f| f.write defaults.to_yaml }
    end

    def self.new?
      self['just_created']
    end

    create_config unless File.exist? @path_to_config

    source :default, File.expand_path('../../assets/default_config.yml', __FILE__)
    source :user, @path_to_config

    configure_rest
  end
end
