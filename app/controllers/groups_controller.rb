class GroupsController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :check_leader, :only => [:edit, :update] 
	respond_to :html, :js

  actions :all, :except => :delete

	def index
		@filter = params[:filter]
		scope = paginate(scope_for(params).order('created_at desc'))
		@groups = if params[:search].present?
		  scope.search(params[:search])
	  else
	    scope
    end
	end
	
	def show
	  @group = Group.find params[:id]
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
	
	def promote
		resource.promote(params[:message], current_user)
		redirect_to resource_path, :notice => "#{t('groups.have_promoted')}"
	end
  
  protected
  
  def scope_for(params)
    case params[:filter]
    when 'my'
      current_user.groups
    else
      case params[:type]
      when 'user'
        User.find(params[:id]).groups
      when 'document'
        Document.find(params[:id]).groups
      else
        Group
      end
    end
  end
  
  def check_leader
    unless current_user.leader_of?(resource)
      flash[:alert] = t('shared.no_permission')
      redirect_to group
    end
  end
end
