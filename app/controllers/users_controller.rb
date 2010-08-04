class UsersController < InheritedResources::Base
  actions :all
  
  def follow
    unless current_user.following?(resource)
      current_user.follow!(resource)
      flash[:notice] = "You are now following #{resource}."
    end
    redirect_to root_path
  end
  
  def unfollow
    if current_user.following?(resource)
      current_user.unfollow!(resource)
      flash[:notice] = "You have unfollowed #{resource}."
    end
    redirect_to root_path
  end
  
  protected
  
  def collection
    @users ||= paginate(end_of_association_chain)
  end
end
