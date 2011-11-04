class UpdatesController < ApplicationController
	respond_to :html, :js 
  before_filter :authenticate_user!
  
  def index
		last = params[:last].blank? ? Time.now + 1.second : Time.parse(params[:last])
    @feed = current_user.feed(last)
  end
  
  def create
    current_user.update_status(params[:status])
    redirect_to updates_path, :notice => t('updates.updated_status_success')
  end
  
  def show
    @update = Update.find(params[:id])
  end

	def destroy
		@update = Update.find(params[:id])
		@update.destroy
	end
end
