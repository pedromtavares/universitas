class PostsController < InheritedResources::Base
	respond_to :html, :js
	belongs_to :topic
	before_filter :authenticate_user!, :allow_members_only, :except => :textile
	
	def create
		@post = Post.create(:text => h(params[:text]), :author => current_user, :topic => parent, :parent_id => params[:parent_id])
	end
	
	def textile
		render :layout => false
	end
	
	def update
 		resource.text = params[:text]
		if resource.valid? && (current_user == resource.author || current_user.leader_of?(parent.forum.group))
			resource.save
		else
			resource.reload
		end
	end
	
	def destroy
		if current_user.leader_of?(parent.forum.group)
			destroy!{group_forum_topic_path(parent.forum.group, parent.forum, parent)}
		else
			flash[:error] = t('posts.no_permission')
			redirect_to group_forum_topic_path(parent.forum.group, parent.forum, parent)
		end
	end
	
	private
	
	def allow_members_only
		unless current_user.member_of?(parent.forum.group)
			flash[:error] = t('forums.not_allowed')
			redirect_to group_path(parent.forum.group)
		end
	end
	
end