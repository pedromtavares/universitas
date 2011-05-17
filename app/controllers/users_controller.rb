class UsersController < InheritedResources::Base
	
	def index
		@users = paginate(User.search(params[:search])) if params[:search]
		@user ||= current_user
		super
	end
	
	def show
		@documents = @user.documents
		@groups = @user.groups
		@timeline = @user.timeline
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
			format.js{ render 'dashboard/show'}
		end
	end
  
  protected
  
  def collection
    @users ||= paginate(end_of_association_chain)
  end
end
