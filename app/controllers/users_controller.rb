class UsersController < InheritedResources::Base
  respond_to :html, :js
	
	def index
		@users = paginate(User.search(params[:search])) if params[:search].present?
		@user ||= current_user
		super
	end
	
	def show
		@documents = resource.documents
		@groups = resource.groups
		@timeline = resource.timeline
		super
	end
	
	def following
	  @filter = 'following'
    @users = if params[:search].present?
  	  current_user.following.search(params[:search])
  	else
  		current_user.following
  	end
  	render :index
	end
	
	def followers
	  @filter = 'following'
    @users = if params[:search].present?
  	  current_user.followers.search(params[:search])
  	else
  		current_user.followers
  	end
  	render :index
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
  
  def collection
    @users ||= paginate(end_of_association_chain.order('created_at desc'))
  end
end
