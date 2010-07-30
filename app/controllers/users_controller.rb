class UsersController < InheritedResources::Base
  before_filter :authenticate_user!
  actions :all, :except => [:new]
  
  def new
    redirect_to users_path
  end
end
