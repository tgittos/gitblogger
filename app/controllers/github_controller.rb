class GithubController < ApplicationController

  skip_before_filter :verify_authenticity_token  

  def index
    if params[:payload]
      Github.process(params[:payload])
      render :nothing
    end
    render :text => "I think you're lost"
  end

end
