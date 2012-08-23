require "octavo/version"
require 'grit'

module FileUtils
  class Octavo 
    attr_accessor :repo_type,  :path, :repo_name
    attr_accessor :local, :dependencies
    attr_accessor :ent

    def initialize(repo, type=nil)
      self.infrastructure_root = File.expand_path '~/Sites'
      self.repo_types          = ['gems','apps']
      self.local_vc            = nil
      self.remote_vc           = nil
      self.depends             = nil
      prefixes = { :release => 'rel-',
                   :hotfix  => 'hotfix-' }


      # instance  attrs
      if ( (repo_parts = repo.split('/')).size > 1 rescue false )
        self.path = File.expand_path(repo)
        self.repo_name = repo_parts.last
        self.repo_type = repo_parts.select{|pt| repo_types.include? pt}.first
      else
        self.path = File.expand_path [@@infrastructure_root, repo_type, repo].join('/') 
        self.repo_name = repo
        self.repo_type = type
      end

      # define type-related module methods dynamically
      if File.exists? "lib/octavo/#{self.repo_type}.rb"
        require "lib/octavo/#{self.repo_type}"
        extend Module.const_get( self.repo_type.capitalize.to_sym )
      else
        warn "Class instantiated without module functions because the module files was not found at octavo/#{self.repo_type}.rb"
      end
    end

    
    def local
      self.local_vc ||= Grit::Repo.new(path)
    end

    def dependencies
      gemfile_path = "#{path}/Gemfile.lock" if File.exists?("#{path}/Gemfile.lock")

      @@depends ||= Bundler::LockfileParser.new(Bundler.read_file(gemfile_path)).specs rescue 'There is a problem calculating dependencies based on your Gemfile.lock in the repo root'
    end

    private

    attr_accessor :infrastructure_root, :repo_types, :local_vc, :remote_vc, :depends

    def self.repo_types
      @@repo_types
    end

    def self.infrastructure_root
      self.infrastructure_root
    end
  end
end
