class DashboardController < ApplicationController
  before_filter :authenticate_user!
  def show
    @feed = paginate(current_user.feed, 20)
  end
  
  def update_status
    current_user.update_status(params[:status])
    redirect_to root_path
  end
end
