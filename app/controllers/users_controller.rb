class UsersController < InheritedResources::Base
	
	def index
		@users = paginate(User.search(params[:search])) if params[:search]
		@user ||= current_user
		super
	end
	
	def show
		@user_documents = @user.user_documents
		@groups = @user.groups_leadered + @user.groups
		super
	end
  
  def follow
    unless current_user.following?(resource)
      current_user.follow!(resource)
      flash[:notice] = "You are now following #{resource}."
    end
    redirect_to :back
  end
  
  def unfollow
    if current_user.following?(resource)
      current_user.unfollow!(resource)
      flash[:notice] = "You have unfollowed #{resource}."
    end
    redirect_to :back
  end
  
  protected
  
  def collection
    @users ||= paginate(end_of_association_chain)
  end
end
