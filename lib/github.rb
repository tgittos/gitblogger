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
      commit["desc"] = doc.css(".commit-desc pre").first.content.gsub(/\n/, ' ').squeeze(' ')
      doc.css('#files .file').each do |diff|
        commit["diffs"] << diff.to_s
      end
    end

    push

  end

  def self.write_and_publish_post(filename, content)
    post_location = File.join('.', '../blog/commits/_posts')
    open(File.join(post_location, filename), 'w') do |f|
      f.puts content
    end
    `jekyll ../blog ../blog/_site`
    `(cd ../blog && git add -A && git commit -m 'Gitblogger added some commits' && git push)`
  end

end
