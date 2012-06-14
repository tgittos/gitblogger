require 'nokogiri'

module Github

  def self.process(payload)

    diffs = []

    # grab the git push contents
    push = JSON.parse(payload)

    # loop through the commits
    puts push.inspect
    push["commits"].each do |commit|
      url = commit["url"]
      doc = Nokogiri::HTML(open(url))
      # extract the diff for this commit
      doc.css('#files .file').each do |diff|
        diffs << diff.css('table')
      end
    end

    logger.info "Push: #{push.inspect}, diffs: #{diffs.inspect}"

  end
end