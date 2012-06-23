# Activerepo

#### Git repos with all the trimmings.

A (still yet) opinionate gem for managing git repository state and actions


## Installation

Add this line to your application's Gemfile:

    gem 'activerepo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerepo

## Usage

`my_repo = ActiveRepo('/path/to/repo', repo_type)`

* Local git repo methods current provided by Grit
* Remote git repo methods currently provided by the GitHub API
* Dependency info provided by Bunder

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
