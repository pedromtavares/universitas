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
	  name = params[:Filename].split('.').first
	  name = "#{name}-#{current_user.login}" if name.length < 4
	  @document = Document.new(:name => name, :file => params[:file], :uploader => current_user)
    if @document.save
      current_user.add_document(@document)
      Group.find(params[:group_id]).add_document(@document, current_user) if params[:group_id].present?
	    render(:text => render_to_string(:partial => 'form_document', :locals => {:document => @document}))
	  end
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