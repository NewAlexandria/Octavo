module Gems
  path_var            = GEM_REPO_PATH rescue "~/Sites/gems/gems"
  @gem_repo_path      = File.expand_path( path_var )
  @home_dir           = `echo ~`[0..-2]

  @general_exclude    = ['.',  "..", ".DS_Store"]
  @gems_exclude       = ['gems'] + @general_exclude  # `gems` repo is excluded because the gemserver is unlike other things.

  @all_gems           = Dir.entries("#{@home_dir}/Sites/gems").reject {|dirs| @gems_exclude.include? dirs }

  @release_tag_prefix = 'rel-'
  @hotfix_tag_prefix  = 'hotfix-'
  @prefixes           = ['rel', 'hotfix']

  def get_gems_tag(repo)
    repo_path    = repo.gsub("_", "\/")
    version_file = File.open "#{@home_dir}/Sites/gems/#{repo}/lib/#{repo_path}/version.rb"
    while line = version_file.readline do
      return line.match(/[0-9.-]+/)[0] if line.match(/[0-9.-]+/) 
    end
  end

  def make_gems_tag(repo, level=3)
    new_version = get_gems_tag(repo).split('.')
    new_version[level-1] = new_version[level-1].to_i + 1
    return new_version[0..(level-1)].join('.')
  end


  def bump_version(gem, version=nil)
    gem_path     = gem.gsub("_", "\/")
    file_name    = "#{@home_dir}/Sites/gems/#{gem}/lib/#{gem_path}/version.rb"
    version_file = File.read file_name
    version    ||= make_gems_tag(gem)

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
