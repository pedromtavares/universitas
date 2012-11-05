class CommentsController < InheritedResources::Base
  respond_to :js
  
  def index
    @filter = params[:filter]
    @comments = paginate(scope_for(params).order('created_at desc'))
  end
  
  def create
    if doc = Document.find(params[:document_id])
      @comment = current_user.add_comment(params[:text], doc)
    end
  end
  
  def show
    respond_to do |format|
      format.html{redirect_to resource.target}
    end
  end
  
  def destroy
    current_user.remove_comment(resource)
  end
  
  protected
  
  def scope_for(params)
    case params[:type]
    when 'document'
      Document.find(params[:id]).comments
    end
  end
  
end