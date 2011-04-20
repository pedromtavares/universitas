class UserDocumentsController < InheritedResources::Base
	defaults :route_collection_name => 'documents', :route_instance_name => 'document'
	before_filter :authenticate_user!, :except => [:index, :show]
	belongs_to :user
	
	def create
		params[:user_document][:document_attributes].merge!(:uploader => current_user)
		create! do |success, failure|
			success.html{redirect_to collection_url}
		end
	end
	
	def add
		if current_user.has_document?(params[:id])
			redirect_to :back, :alert => I18n.t("users.documents.already_exists")
		else
			UserDocument.create!(:document_id => params[:id], :user => current_user)
			redirect_to :back, :notice => I18n.t("users.documents.added_collection")
		end
	end
	
	def remove
		UserDocument.find(params[:id]).destroy
		redirect_to :back, :notice => I18n.t("documents.removed_collection")
	end
	
	private

	def resource
		@user_document = if params[:id]
			parent.user_documents.find_by_document_id(params[:id])
		else
			@user_document.errors.blank? ? UserDocument.new(:document => Document.new) : @user_document
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