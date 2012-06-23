require "activerepo/version"
require 'grit'

module FileUtils
  class Activerepo 
    attr_accessor :repo_type,  :path, :repo_name
    attr_accessor :local, :dependencies
    attr_accessor :ent

    @@infrastructure_root = '~/Sites'
    @@repo_types          = ['gems','apps']
    @@local_vc            = nil
    @@remote_vc           = nil
    @@depends             = nil

    def initialize(repo, type=nil)
      # instance  attrs
      if ( (repo_parts = repo.split('/')).size > 1 rescue false )
        self.path = File.expand_path(repo)
        self.repo_name = repo_parts.last
        self.repo_type = repo_parts.select{|pt| @@repo_types.include? pt}.first
      else
        self.path = File.expand_path [@@infrastructure_root, repo_type, repo].join('/') 
        self.repo_name = repo
        self.repo_type = type
      end


      # define type-related module methods dynamically
      if File.exists? "lib/activerepo/#{repo_type}.rb"
        require "lib/activerepo/#{repo_type}"
        extend Module.const_get( repo_type.capitalize.to_sym )
      else
        warn "Class instantiated without module functions because the module files was not found at activerepo/#{repo_type}.rb"
      end
    end

    
    def local
      @@local_vc ||= Grit::Repo.new(path)
    end

    def dependencies
      gemfile_path = "#{path}/Gemfile.lock" if File.exists?("#{path}/Gemfile.lock")

      @@depends ||= Bundler::LockfileParser.new(Bundler.read_file(gemfile_path)).specs rescue 'There is a problem calculating dependencies based on your Gemfile.lock in the repo root'
    end

  end
end
