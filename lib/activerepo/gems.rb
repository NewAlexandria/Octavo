module Gems
  path_var            = GEM_REPO_PATH rescue "~/Sites/gems/gems"
  @gem_repo_path      = File.expand_path( path_var )

  @general_exclude    = ['.',  "..", ".DS_Store"]
  @gems_exclude       = ['gems'] + @general_exclude  # `gems` repo is excluded because the gemserver is unlike other things.
  
  def initialize
    @all_gems           = Dir.entries("#{infrastructure_root}/gems").reject {|dirs| @gems_exclude.include? dirs }
  end
  
  @@version           = { :major => 1,
                          :minor => 2,
                          :patch => 3,
                          :pre   => 4 }

  def get_tag()
    repo_path    = repo_name.gsub("_", "\/")
    version_file = File.open "#{infrastructure_root}/gems/#{repo_name}/lib/#{repo_path}/version.rb"
    while line = version_file.readline do
      return line.match(/[0-9.-]+/)[0] if line.match(/[0-9.-]+/) 
    end
  end
  alias :version :get_tag

  def make_tag(level = :patch)
    ver = @@version[level]-1
    new_version = get_tag.split('.')
    new_version[ver] = new_version[ver].to_i + 1
    return new_version[0..ver].join('.')
  end

  def bump_version(version)
    gem_path     = repo_name.gsub("_", "\/")
    file_name    = "#{infrastructure_root}/gems/#{repo_name}/lib/#{gem_path}/version.rb"
    version_file = File.read file_name
    version    ||= make_gems_tag

    version_file.gsub!(/[0-9.-]+/, version)
    ff = File.open(file_name, 'w') {|f| f << version_file }
  end

  def remote_push( commit_msg )
    puts 'Commit gems'
    Dir.chdir `cd #{@gem_repo_path}; pwd`[0..-2] do
        `git checkout master`
        `git add -u`
        `git commit -m "#{commit_msg}"`

        puts "\nPull"
        `git pull`
        `git pull gemserver master`

        puts "\nPush"
        `git push`
        `git push gemserver master`
    end  
  end
end
