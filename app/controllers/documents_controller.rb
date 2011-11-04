class DocumentsController < InheritedResources::Base
	respond_to :html, :js
	
	def index
		@documents = paginate(Document.search(params[:search])) if params[:search].present?
		super
	end
	
	def show
	  @users = resource.users
	  @groups = resource.groups
		@user_document = current_user.user_documents.find_by_document_id(params[:id]) if current_user
	  super
  end
	
	def download
		file = resource.file_url
		send_data(file, :disposition => 'attachment', :filename => File.basename(file))
	end
	
	private
	
	def collection
    @documents ||= paginate(end_of_association_chain.includes(:uploader).order('created_at desc'))
  end

end