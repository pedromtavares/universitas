class DocumentsController < InheritedResources::Base
	respond_to :html, :js
	
	def index
		@filter = params[:filter]
		scope = paginate(scope_for(params).order('created_at desc'))
		@documents = if params[:search].present?
		  scope.search(params[:search])
	  else
	    scope
    end
	end
	
	def new
	  if params[:group_id]
	    @group = Group.find(params[:group_id])
	    @documents = current_user.documents.order('created_at desc')
	    render 'group_new', :layout => 'overlay'
    else
      render :layout => 'overlay'
    end
	end
	
	def create
	  content_type = MIME::Types.type_for(params[:file].original_filename).first.to_s
	  extension = Document.get_extension_from(params[:file].original_filename)
	  name = params[:Filename].split('.').first
	  name = "#{name}-#{current_user.login}" if name.length < 4
	  @document = if Document.is_image?(extension)
      Document.create(:name => name, :file => params[:file], :uploader => current_user, :file_size => params[:file].size, :content_type => content_type, :extension => extension)
    else
      Document.create_from_scribd(name, params[:file], current_user, content_type)
    end
    if @document.present? && @document.id
      current_user.add_document(@document)
      Group.find(params[:group_id]).add_document(@document, current_user) if params[:group_id].present?
      render(:text => render_to_string(:partial => 'form_document', :locals => {:document => @document}))
    end
	end
	
	def download
    if resource.file.present?
      redirect_to resource.file_url
    else
      if url = Scribd.new.download(resource)
        redirect_to url
      else
        redirect_to resource, :alert => t('documents.download_unavailable')
      end
    end
	end
	
	def view
    render :layout => false
	end
	
	private
	
	def scope_for(params)
    case params[:filter]
    when 'my'
      current_user.documents
    when 'uploaded'
    	current_user.uploaded_documents
    else
      case params[:type]
      when 'user'
        User.find(params[:id]).documents
      when 'group'
        Group.find(params[:id]).documents
      else
        Document
      end
    end
  end

end