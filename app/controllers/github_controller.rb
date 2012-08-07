require 'github'

class GithubController < ApplicationController

  layout false
  skip_before_filter :verify_authenticity_token

  def index
    if params[:payload]
      data = Github.inject_diffs(params[:payload])
      @repo = data["repository"]["name"]
      write_posts data
      render :text => "Wrote blog posts :)"
    else
      render :text => "I think you're lost"
    end
  end

  private

  def write_posts(data)
    data["commits"].each do |commit|
      commit["message"] = commit["message"].split("\n").first
      post = render_to_string(:action => 'index', :locals => { :commit => commit })
      Github.write_and_publish_post get_title(commit), post, @repo
    end
  end

  def get_title(commit)
    "#{Date.today.strftime("%Y-%m-%d")}-#{commit["message"].downcase.gsub(/\s/,'-').gsub(/[^A-Za-z0-9\-]/, '')}-on-#{@repo}.textile"
  end

end
