class TopicsController < InheritedResources::Base
	respond_to :html, :js
	before_filter :authenticate_user!, :allow_members_only, :except => [:index, :show]
	belongs_to :forum
	
	def new
	  @group = Group.find params[:group_id]
	  super do |format|
	   format.html {render "groups/show"}
	  end
	end
	
	def create
		@topic = parent.topics.build(:title => params[:topic][:title])
		begin
		  @topic.save && @topic.create_post(params[:topic][:post].merge(:author => current_user))
    rescue
      @error = true
	  end
	end
	
	def update
		resource.title = params[:title]
		if resource.valid?
			resource.save
		else
			resource.reload
		end
	end
	
	def show
	  @group = Group.find params[:group_id]
		@posts = paginate(resource.posts, 50)
		super do |format|
	   format.html {render "groups/show"}
	  end
	end
	
	def destroy
		destroy!{group_forum_path(@forum.group, @forum)}
	end
	
  private

	def allow_members_only
		unless current_user.member_of?(parent.group)
			flash[:alert] = t('forums.not_allowed')
			redirect_to group_path(parent.group)
		end
	end
end
