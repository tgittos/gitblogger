require 'nokogiri'
require 'open-uri'

module Github

  def self.inject_diffs(payload)
    
    # grab the git push contents
    push = JSON.parse(payload)

    # loop through the commits
    push["commits"].each do |commit|
      commit["diffs"] = []
      url = commit["url"]
      doc = Nokogiri::HTML(open(url))
      # extract the diff for this commit
      commit["desc"] = doc.css(".commit-desc pre").first.content.gsub(/\n/, ' ').squeeze(' ') unless doc.css('.commit-desc pre').first.nil?
      doc.css('#files .file').each do |diff|
        commit["diffs"] << diff.to_s
      end
    end

    push

  end

  def self.write_and_publish_post(filename, content, repo)
    @blog_path = APP_CONFIG['blog']['path']
    ensure_category_for_repo repo
    post_location = File.join("#{@blog_path}/#{repo}/_posts")
    File.open(File.join(post_location, filename), 'w') do |f|
      f.puts content
    end
    #`jekyll #{APP_CONFIG['blog']['jekyll']['root']} #{APP_CONFIG['blog']['jekyll']['output']}`
    #`(cd #{APP_CONFIG['blog']['jekyll']['root']} && git add -A && git commit -m 'Gitblogger added some commits' && git push)`
  end

  def self.ensure_category_for_repo(repo)
    write_repo_dir repo unless File.exists? "#{@blog_path}/#{repo}"
    write_repo_index repo unless File.exists? "#{@blog_path}/#{repo}/index.textile"
    write_repo_post repo unless Dir.entries("#{@blog_path}/_posts").select{|e| e =~ /#{repo}/}.length > 0
  end

  private

  def self.write_repo_dir(repo)
    Rails.logger.info "Creating directory for #{repo} at #{@blog_path}/#{repo}"
    Rails.logger.info "Creating posts directory for #{repo} at #{@blog_path}/#{repo}/_posts"
    Dir.mkdir("#{@blog_path}/#{repo}")
    Dir.mkdir("#{@blog_path}/#{repo}/_posts")
  end

  def self.write_repo_index(repo)
    Rails.logger.info "Creating index for new repo at #{@blog_path}/#{repo}/index.textile"
    File.open("#{@blog_path}/#{repo}/index.textile", 'w') do |f|
      f.write <<-EOS
---
layout: page
parent: true
category: #{repo}
tags: github commit code
---

<div id="post-list">
  {% include post-list.html %}
</div>
      EOS
    end
  end

  def self.write_repo_post(repo)
    Rails.logger.info "Creating commit post for new repo at #{@blog_path}/_posts"
    File.open("#{@blog_path}/_posts/#{Date.today.strftime("%Y-%m-%d")}-#{repo}.textile".squeeze('-'), 'w') do |f|
      f.write <<-EOS
---
layout: page
parent: true
category: #{repo}
tags: github commit code
---

THIS IS A DUMMY ENTRY
EOS
    end
  end

end
