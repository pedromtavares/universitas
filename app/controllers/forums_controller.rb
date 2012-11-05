class ForumsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :allow_leader_only, :only => [:new, :edit, :create, :update]
  belongs_to :group
  respond_to :js
  
  def index
    super do |format|
     format.html {render "groups/show"}
    end
  end
  
  def new
    super do |format|
     format.html {render "groups/show"}
    end
  end
  
  def edit
    super do |format|
     format.html {render "groups/show"}
    end
  end
  
  def create
    create!{collection_url}
  end
  
  def show
    @topics = resource.topics
    super do |format|
     format.html {render "groups/show"}
    end
  end
  
  protected
  
  def allow_leader_only
    unless current_user.leader_of?(parent)
      flash[:alert] = t('forums.not_allowed')
      redirect_to group_path(parent)
    end
  end
end
