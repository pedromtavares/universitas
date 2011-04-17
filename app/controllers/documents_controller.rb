class DocumentsController < InheritedResources::Base
	respond_to :html, :js
	
	def index
		@documents = paginate(Document.search(params[:search])) if params[:search]
		super
	end
	
	def download
		file = resource.file_url
		send_data(file, :disposition => 'attachment', :filename => File.basename(file))
	end
	
	private
	
	def collection
    @documents ||= paginate(end_of_association_chain)
  end

	def set_breadcrumbs
		add_breadcrumb(I18n.t("documents.all"), :collection_path)
		add_breadcrumb(I18n.t("documents.new"), lambda { |a| new_user_document_path(current_user)  })
	end

end