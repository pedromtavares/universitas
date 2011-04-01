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
		@chosen = params[:documents]
		if @chosen.blank?
			@group_document = Document.new(params[:document].merge(:uploader => current_user))
			current_user.user_documents.create!(:document => @group_document)
			parent.group_documents.create!(:document => @group_document)
			create!{collection_url}
		else
			@chosen.each do |document|
				unless collection.find_by_document_id(document)
					parent.group_documents.create(:document_id => document, :pending => true, :group_module_id => params[:module], :sender => current_user)
				end
			end
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
			Document.new
		end
	end

	def collection
		@group_documents = parent.group_documents
	end
	
	def set_breadcrumbs
		add_breadcrumb(parent.name, :parent_url) if parent?
		add_breadcrumb(I18n.t("documents.all"), :collection_path)
		add_breadcrumb(I18n.t("documents.new"), :new_resource_path)
	end

end