class UsersController < InheritedResources::Base
  respond_to :html, :js
	
	def index
	  @filter = params[:filter]
		scope = paginate(scope_for(@filter).order('created_at desc'))
		@users = if params[:search].present?
		  scope.search(params[:search])
	  else
	    scope
    end
	end
	
	def show
		@documents = resource.documents
		@groups = resource.groups
		@timeline = resource.timeline
		super
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

	def timeline
		@feed = resource.timeline(Time.parse(params[:last]))
		respond_to do |format|
			format.js{ render 'updates/index'}
		end
	end
  
  protected
  
  def scope_for(filter)
    case filter
    when 'following'
      current_user.following
    when 'followers'
    	current_user.followers
    else
      User
    end
  end
end
