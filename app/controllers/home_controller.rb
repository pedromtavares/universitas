class HomeController < ApplicationController
  require 'rest-client'
  
  def show
  end
  
  # this is a location tracker that I (Pedro) built with NodeJS (to practice), please don't mess with this.
  def track
    url = Rails.env.development? ? "http://localhost:8000/stat" : "http://stats.universit.as/stat"
    RestClient.get(url, :params => {
      :ip => request.remote_ip,
      :title => request.referrer
    })
    render :js => ''
  end
end
