class GroupsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :allow_leader, :only => [:edit, :update] 

  actions :all, :except => :delete

	def index
		@groups = paginate(Group.search(params[:search])) if params[:search]
		super
	end
	
	def show
		@timeline = @group.timeline
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
			format.js{ render 'dashboard/show'}
		end
	end
  
  protected
  
  def collection
    @groups ||= paginate(end_of_association_chain)
  end
  
  def allow_leader
    group = Group.find(params[:id])
    unless current_user.leader_of?(group)
      flash[:alert] = t('shared.no_permission')
      redirect_to group
    end
  end
end
