class GroupDocumentsController < InheritedResources::Base
	defaults :route_collection_name => 'documents', :route_instance_name => 'document'
	before_filter :authenticate_user!, :except => [:index, :show]
	belongs_to :group
	respond_to :html, :js
	
	def index
	  @group = parent
	  super do |format|
	   format.html {render "groups/show"}
	  end
	end
	
	def new
	  @group = parent
	  super do |format|
	   format.html {render "groups/show"}
	  end
	end
	
	def create
		params[:group_document].merge!(:sender => current_user, :pending => false)
		params[:group_document][:document_attributes].merge!(:uploader => current_user)
		create!{group_documents_path(parent)}
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
		paginate(@group_documents = parent.group_documents.includes([:document, :module, :group]).order('created_at desc'))
	end

end