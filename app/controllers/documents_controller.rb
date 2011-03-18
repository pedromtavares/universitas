class DocumentsController < InheritedResources::Base
	
	def index
		@documents = paginate(Document.search(params[:search])) if params[:search]
		super
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