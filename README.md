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

    redmine project list
    redmine project members 1
    redmine project members trololo

Don't forget about console aliases!
I use something like this:

    # alias i='redmine issue'
    # by the way, Thor can guess your commands so:

    $ i s 123
    $ i u --assign 'vasya pupkin'


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Nondv/redmine_cli.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

