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
    end
  end
  
  def unfollow
    if current_user.following?(resource)
      current_user.unfollow!(resource)
    end
  end
  
  protected
  
  def scope_for(params)
    user = if params[:type] == 'user'
      User.find(params[:id])
    else
      current_user
    end
    case params[:filter]
    when 'following'
      user.following
    when 'followers'
    	user.followers
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
