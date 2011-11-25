class UserDocumentsController < InheritedResources::Base
	defaults :route_collection_name => 'documents', :route_instance_name => 'document'
	before_filter :authenticate_user!, :except => [:index, :show]
	before_filter :check_uploader, :only => [:edit, :update] 
	belongs_to :user
	respond_to :html, :js
	
	def index
	 @filter = 'my'
	 @documents = if params[:search].present?
			current_user.documents.search(params[:search]).order('created_at desc')
		else
			current_user.documents.order('created_at desc')
		end
	 render "documents/index"
	end
	
	def uploaded
	  @filter = 'uploaded'
	  @documents = if params[:search].present?
		  current_user.uploaded_documents.search(params[:search]).order('created_at desc')
		else
			current_user.uploaded_documents.order('created_at desc')
		end
	  render "documents/index"
	end
	
	def update
		update!(:notice => t('documents.updated')){document_path(resource.document)}
	end
	
	def add
		if current_user.has_document?(params[:id])
			redirect_to :back, :alert => I18n.t("users.documents.already_exists")
		else
			current_user.add_document(params[:id])
			redirect_to :back, :notice => I18n.t("users.documents.added_collection")
		end
	end
	
	def remove
		current_user.remove_document(params[:id])
		redirect_to :back, :notice => I18n.t("users.documents.removed_collection")
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
		@user_documents = paginate(parent.user_documents.includes(:user, :document).order('created_at desc'))
	end
	
	def check_uploader
		unless current_user.uploaded_document?(resource.document)
			flash[:alert] = t('users.documents.no_permission')
			redirect_to user_documents_path(current_user)
		end
	end

end