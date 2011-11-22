class ForumsController < InheritedResources::Base
	before_filter :authenticate_user!, :allow_members_only, :except => [:index, :show]
	belongs_to :group
	respond_to :html, :js
	
	def create
		create!{collection_url}
	end
	
	def show
		@topics = resource.topics
		super
	end
  
  protected

	def allow_members_only
		unless current_user.member_of?(parent)
			flash[:error] = t('forums.not_allowed')
			redirect_to group_path(parent)
		end
	end
end
