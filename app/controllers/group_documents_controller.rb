class GroupDocumentsController < InheritedResources::Base
	defaults :route_collection_name => 'documents', :route_instance_name => 'document'
	before_filter :authenticate_user!, :check_leader
	belongs_to :group
	respond_to :html, :js
	
	def index
	  @group = parent
	  super do |format|
	   format.html {render "groups/show"}
	  end
	end
	
	def add_multiple
	  ids = params[:chosen_documents]
	  ids.each do |document_id|
	    parent.add_document(document_id, current_user)
	  end
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
	
	def check_leader
    unless current_user.leader_of?(parent)
      flash[:alert] = t('shared.no_permission')
      redirect_to parent
    end
  end

end