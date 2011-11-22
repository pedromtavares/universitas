class TopicsController < InheritedResources::Base
	respond_to :html, :js
	before_filter :authenticate_user!, :allow_members_only, :except => [:index, :show]
	belongs_to :forum
	
	def create
		@topic = parent.topics.build(:title => params[:topic][:title])
		if @topic.save && @topic.create_post(params[:topic][:post].merge(:author => current_user))
			flash[:notice] = t('topics.created')
			redirect_to group_forum_topic_path(parent.group, parent, @topic)
		else
			render :new
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
		@posts = paginate(resource.posts, 50)
		super
	end
	
	def destroy
		destroy!{group_forum_path(@forum.group, @forum)}
	end
	
  private

	def allow_members_only
		unless current_user.member_of?(parent.group)
			flash[:error] = t('forums.not_allowed')
			redirect_to group_path(parent.group)
		end
	end
end
