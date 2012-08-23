module Apps
  @general_exclude    = ['.',  "..", ".DS_Store"]
  @apps_exclude    = @general_exclude
  @all_apps        = Dir.entries("#{infrastructure_root}/apps").reject {|dirs| @apps_exclude.include? dirs }

  def get_tag( which = :last) 
    # strictly-speaking, this gets branches, not tags.  tags are prefix "v" not "rel-"
    return (`cd #{infrastructure_root}/apps/#{repo_name}; git branch -v`. # get repo branches 
                gsub("*", "").split("\n")).                     # just the lines 
                 map{|r| r.split[0]}.                           # grab the first branch name
              select{|t| t =~ /^([a-z]+-[0-9]{4}-[0-9]{2})/ }.  # filter for release branches of YYYY-MM-DD
                 map{|w| w.split("-",2).reverse }.sort.         # split type, sort by date
              send(which).reverse.join("-")                     # get target, recombine
  end

  def make_tag(repo)
    return Date.today.strftime("%Y-%m-%d")
  end

end
