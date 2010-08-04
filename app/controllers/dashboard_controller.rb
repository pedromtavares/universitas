class DashboardController < ApplicationController
  before_filter :authenticate_user!
  def show
    @feed = current_user.feed
  end
  
  def update_status
    current_user.update_status(params[:status])
    redirect_to root_path
  end
end
