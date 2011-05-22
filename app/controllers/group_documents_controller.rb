class GroupDocumentsController < InheritedResources::Base
	defaults :route_collection_name => 'documents', :route_instance_name => 'document'
	before_filter :authenticate_user!, :except => [:index, :show]
	belongs_to :group
	
	respond_to :html, :js
	
	def index
		@documents = current_user.documents.search(params[:search]) if params[:search]
		@accepted = collection.accepted
		@pending = collection.pending
		super
	end
	
	def create
		params[:group_document].merge!(:sender => current_user, :pending => !current_user.leader_of?(parent))
		params[:group_document][:document_attributes].merge!(:uploader => current_user)
		create! do |success, failure|
			if current_user.leader_of?(parent)
				success.html {redirect_to collection_url}
			else
				success.html {redirect_to parent_url, :notice => I18n.t('groups.documents.created')}
				failure.html {redirect_to parent_url, :alert => I18n.t('groups.documents.invalid')}
			end
		end
	end
	
	def add_multiple
		params[:documents].each do |document|
			parent.add_document(document, params[:module], current_user)
		end
	end
	
	def accept
		resource.accept
	end
	
	private

	def resource
		@group_document = if params[:id]
			parent.group_documents.find(params[:id])
		else
			@group_document.errors.blank? ? GroupDocument.new(:document => params[:document] || Document.new) : @group_document
		end
	end

	def collection
		@group_documents = parent.group_documents.includes([:document, :module, :group])
	end
	
	def set_breadcrumbs
		add_breadcrumb(parent.name.truncate(50), :parent_url) if parent?
		add_breadcrumb(I18n.t("documents.all"), :collection_path)
		add_breadcrumb(I18n.t("groups.documents.new"), :new_resource_path)
	end

end