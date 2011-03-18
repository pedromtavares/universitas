class UserDocumentsController < InheritedResources::Base
	defaults :route_collection_name => 'documents', :route_instance_name => 'document'
	before_filter :authenticate_user!, :except => [:index, :show]
	belongs_to :user
	
	def create
		@user_document = Document.new(params[:document].merge(:user_id => current_user.id))
		UserDocument.create!(:document => @user_document, :user => current_user)
		create!
	end
	
	def update
		params[:user_document] = params[:document]
		update!
	end
	
	def download
		file = resource.file_url
		send_data(file, :disposition => 'attachment', :filename => File.basename(file))
	end
	
	def add
		UserDocument.create!(:document_id => params[:id], :user => current_user)
		redirect_to :back, :notice => "Document successfully added to your collection."
	end
	
	def remove
		UserDocument.find(params[:id]).destroy
		redirect_to :back, :notice => "Document successfully removed from your collection."
	end
	
	private

	def resource
		@user_document = if params[:id]
			parent.uploaded_documents.find(params[:id])
		else
			Document.new
		end
	end

	def collection
		@user_documents = parent.uploaded_documents
	end
	
	def set_breadcrumbs
		add_breadcrumb(parent.name, :parent_url) if parent?
		add_breadcrumb(I18n.t("documents.all"), :collection_path)
		add_breadcrumb(I18n.t("documents.new"), :new_resource_path)
	end

end