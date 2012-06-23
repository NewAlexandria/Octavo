require "activerepo/version"

@infrastructure_root = '~/Sites'
@repo_types          = ['gems','apps']

class Activerepo 
  attr_accessor :repo_type,  :path, :repo_name
  attr_accessor :local, :dependencies

  def initialize(repo, type=nil)
    # instance  attrs
    if ( (repo_parts = repo.match('/')).size > 1 rescue false )
      path = File.expand_path(repo)
      repo_name = repo_parts.last
      repo_type = repo_parts.select{|pt| @repo_types.include? pt}.first
    else
      path = File.expand_path [@infrastructure_root, repo_type, repo].join('/') 
      repo_name = repo
      repo_type = type
    end

    # define type-related module methods dynamically
    if File.exists? "lib/#{repo_type}.rb"
      require "lib/#{repo_type}"
      extend Module.const_get( repo_type.capitalize.to_sym )
    else
      warn "Class instantiated without module functions because the module files was not found at lib/#{repo_type}.rb"
    end
  end

  
  def local
    local ||= Grit::Repo.new(path)
  end

  def dependencies
    gemfile_path = "#{path}/Gemfile.lock" if File.exists?("#{path}/Gemfile.lock")

    dependencies ||= Bundler::LockfileParser.new(Bundler.read_file(gemfile_path)).specs rescue 'There is a problem calculating dependencies based on your Gemfile.lock in the repo root'
  end

end
