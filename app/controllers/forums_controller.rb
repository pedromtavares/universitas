class ForumsController < InheritedResources::Base
	before_filter :load_presenter, :authenticate_user!, :allow_members_only
	belongs_to :group
	
	def create
		create!{collection_url}
	end
	
	def show
		@topics = paginate(resource.topics)
		super
	end
  
  protected

	def allow_members_only
		unless current_user.member_of?(parent)
			flash[:error] = t('forums.not_allowed')
			redirect_to group_path(parent)
		end
	end

	def load_presenter
		@presenter = ForumsPresenter.new(current_user, parent)
	end
	
	def set_breadcrumbs
		add_breadcrumb(parent.name.truncate(50), :parent_url) if parent?
		add_breadcrumb(I18n.t("forums.all"), :collection_path)
		add_breadcrumb(resource.to_s.truncate(50), :resource_path) if params[:id]
	end
end
