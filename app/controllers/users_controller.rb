class UsersController < InheritedResources::Base
  respond_to :html, :js
	
	def index
	  @filter = params[:filter]
		scope = paginate(scope_for(params).order('created_at desc'))
		@users = if params[:search].present?
		  scope.search(params[:search])
	  else
	    scope
    end
	end
  
  def follow
    unless current_user.following?(resource)
      current_user.follow!(resource)
      flash[:notice] = "#{t('users.now_following')} #{resource}."
    end
    redirect_to :back
  end
  
  def unfollow
    if current_user.following?(resource)
      current_user.unfollow!(resource)
      flash[:notice] = "#{t('users.have_unfollowed')} #{resource}."
    end
    redirect_to :back
  end
  
  protected
  
  def scope_for(params)
    case params[:filter]
    when 'following'
      current_user.following
    when 'followers'
    	current_user.followers
    else
      case params[:type]
      when 'document'
        Document.find(params[:id]).users
      when 'group'
        Group.find(params[:id]).users
      else
        User
      end
    end
  end
end
