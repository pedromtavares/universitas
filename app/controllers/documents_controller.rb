class DocumentsController < InheritedResources::Base
	before_filter :load_presenter
	respond_to :html, :js
	
	def index
		@documents = paginate(Document.search(params[:search])) if params[:search]
		super
	end
	
	def show
	  @users = @document.users
	  @groups = @document.groups
		@user_document = current_user.user_documents.find_by_document_id(params[:id]) if current_user
	  super
  end
	
	def download
	  resource.download_plus_one
		file = resource.file_url
		send_data(file, :disposition => 'attachment', :filename => File.basename(file))
	end
	
	private
	
	def collection
    @documents ||= paginate(end_of_association_chain.includes(:uploader).order('created_at asc'))
  end

	def load_presenter
		@presenter = DocumentsPresenter.new(current_user)
	end

	def set_breadcrumbs
		add_breadcrumb(I18n.t("documents.all"), :collection_path)
		add_breadcrumb(I18n.t("documents.my_documents"), lambda { |a| user_documents_path(current_user)  })
		add_breadcrumb(I18n.t("documents.new"), lambda { |a| new_user_document_path(current_user)  })
		add_breadcrumb(resource.to_s.truncate(50), :resource_path) if params[:id]		
	end

end