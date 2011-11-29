class UpdatesController < InheritedResources::Base
	respond_to :html, :js 
  before_filter :authenticate_user!
  
  def index
    @updates = scope_for(params)
    super
  end
  
  def create
    current_user.update_status(params[:status])
    redirect_to updates_path, :notice => t('updates.updated_status_success')
  end
  
  protected
  
  def scope_for(params)
    last = params[:last].blank? ? Time.now + 1.second : Time.parse(params[:last])
    if params[:id]
      case params[:type]
      when 'user'
        User.find(params[:id]).timeline(last)
      when 'group'
        Group.find(params[:id]).timeline(last)
      end
    else
      current_user.feed(last, params[:type])
    end
  end
end
