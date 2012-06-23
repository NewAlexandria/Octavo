module Gems
  path_var       = GEM_REPO_PATH rescue "~/Sites/gems/gems"
  @gem_repo_path = File.expand_path( path_var )
  @home_dir      = `echo ~`[0..-2]
  
  def get_gems_tag(repo=nil)
    @home_dir      = `echo ~`[0..-2]

    version_file = File.open "#{@home_dir}/Sites/gems/#{repo}/lib/#{repo}/version.rb"
    while line = version_file.readline do
      if line.match(/[0-9.-]+/) 
        new_version = line.match(/[0-9.-]+/)[0].split('.')
        new_version[-1] = new_version.last.to_i + 1
        return new_version.join('.')
      end
    end
  end

  def bump_version(gem, version)
    gem_path = gem.gsub("_", "\/")
    file_name = "#{@home_dir}/Sites/gems/#{gem}/lib/#{gem_path}/version.rb"
    version_file = File.read file_name
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
