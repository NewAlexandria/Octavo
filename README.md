# Activerepo

#### Git repos with all the trimmings.

A (still yet) opinionate gem for managing git repository state and actions

## Opinions

* Your repos have an ontology
    [gems|apps]
* You use a mac-like unix path and keep your project files in a user home:
    ~/Sites/<repo_type>/<repo>
* You follow a branching structure similar to git-flow, i.e. master-dev-feature
* Your release branches are named by-type:
  * `gems`: prefix-VERSION
  * `apps`: prefix-RELEASE_DATE
* You push gem updates to a Gemsever defined as `gemserver` in your `~/.ssh/config`

For now, if you're interested in defining a multi-tier build order, consider [caphub](http://railsware.com/blog/2011/11/18/caphub-multiple-applications-deployment-with-capistrano/)

## Installation

Add this line to your application's Gemfile:

    gem 'activerepo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerepo

## Usage

   my_repo = ActiveRepo('/path/to/repo', repo_type)

* `my_repo.local`:        Local git repo methods current provided by Grit
* `my_repo.remote`:       Remote git repo methods currently provided by the GitHub API
* `my_repo.dependencies`: Dependency info provided by Bunder

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
