class GroupsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index, :show, :timeline]
  before_filter :check_leader, :only => [:edit, :update] 
	before_filter :load_presenter
	respond_to :html, :js

  actions :all, :except => :delete

	def index
		@groups = paginate(Group.search(params[:search])) if params[:search].present?
		super
	end
	
	def my
	 @groups = if params[:search].present?
	   paginate(current_user.groups.search(params[:search]))
   else
     paginate(current_user.groups)
   end
	 @filter = 'my'
	 render :index
	end
	
	def show
		@timeline = resource.timeline
		@modules = resource.modules
		@accepted_docs = resource.group_documents.accepted
		@members = resource.members
		add_breadcrumb(t('forums.plural'), lambda { group_forums_path(resource) })
		super
	end
  
  def create
    @group = Group.new(params[:group].merge(:leader => current_user))
    create!
  end
  
  def join
    @group = Group.find params[:id]
    unless current_user.member_of?(@group)
			@group.create_member(current_user)
      redirect_to @group, :notice => "#{t('groups.have_joined')} #{@group}"
    else
      redirect_to @group, :error => t('groups.already_in')
    end
  end
  
  def leave
    @group = Group.find params[:id]
		@group.remove_member(current_user)
    redirect_to groups_path, :notice => "#{t('groups.have_left')} #{@group}"
  end

	def update_status
		resource.update_status(params[:status])
		redirect_to resource_path
	end
	
	def timeline
		@feed = resource.timeline(Time.parse(params[:last]))
		respond_to do |format|
			format.js{ render 'updates/index'}
		end
	end
	
	def promote
		resource.promote(params[:message], current_user)
		redirect_to resource_path, :notice => "#{t('groups.have_promoted')}"
	end
  
  protected
  
  def collection
    @groups ||= paginate(end_of_association_chain.includes(:leader).order('created_at desc'))
  end
  
  def check_leader
    unless current_user.leader_of?(resource)
      flash[:alert] = t('shared.no_permission')
      redirect_to group
    end
  end

	def load_presenter
		@presenter = GroupsPresenter.new(current_user)
	end
end
