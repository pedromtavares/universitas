class HomeController < ApplicationController
  require 'rest-client'
  skip_before_filter :set_breadcrumbs
  
  def show
  end
  
  # this is a location tracker that I (Pedro) built with NodeJS (to practice), please don't mess with this.
  def track
    url = Rails.env.development? ? "http://localhost:8000/stat" : "http://universit.as:8000/stat"
    RestClient.get(url, :params => {
      :ip => request.remote_ip,
      :title => request.referrer
    })
    render :js => ''
  end
end
