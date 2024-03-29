# Valet Tasks

The Valet Tasks gem allows developers at Xeno Media to easily setup their local environment for development.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'valet-tasks'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install valet-tasks

## Setup

Run install command:

```bash
curl -fsSL https://raw.githubusercontent.com/xenomedia/valet-tasks/main/bin/install| bash
```

Create a record in your ``~/.ssh/config` file for db_backup. This should be the place where your database backups live.

```bash
# Valet Tasks.
Host db_backup
    Hostname xxx.xxx.xxx.xx
    User user
    Port 22
```

## Usage

Run setup commands:

```bash
rake drupal:setup
rake wordpress:setup
rake laravel:setup
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xenomedia/valet-tasks.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
