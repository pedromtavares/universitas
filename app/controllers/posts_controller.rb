class PostsController < InheritedResources::Base
	respond_to :html, :js
	belongs_to :topic
	skip_before_filter :set_breadcrumbs
	before_filter :authenticate_user!, :allow_members_only, :except => :textile
	
	def create
		@post = Post.new(:text => h(params[:text]), :author => current_user, :topic => parent, :parent_id => params[:parent_id])
		if @post.save
			flash[:notice] = t('posts.created')
		else
			flash[:error] = t('posts.error')
		end
		redirect_to group_forum_topic_path(parent.forum.group, parent.forum, parent)
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
	
end