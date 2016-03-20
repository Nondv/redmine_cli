# RedmineCLI
[![Gem Version](https://badge.fury.io/rb/redmine_cli.svg)](https://badge.fury.io/rb/redmine_cli)

Command-Line Interface for Redmine.

Why? 'cause web-browser + mouse sucks

## Installation

    $ gem install redmine_cli

## Usage

    redmine help
    redmine conf init
    redmine issue list [user id]
    redmine issue show <issue id>
    redmine issue update <issue id> --comment --done 80  --status progress --time 00:30
    redmine issue create

    redmine user find vasya
    redmine user find 123
    redmine user find pupkin@yet.another.mail.com


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Nondv/redmine_cli.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

