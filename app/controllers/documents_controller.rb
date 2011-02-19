class DocumentsController < InheritedResources::Base
	before_filter :authenticate_user!, :except => [:index, :show]
	before_filter :allow_teacher, :except => [:show, :index, :download]  
	belongs_to :course
	
	
	def download
		file = resource.file_url
		send_data(file, :disposition => 'attachment', :filename => File.basename(file))
	end
	
	private
	
	def allow_teacher
    unless current_user && current_user.teacher_of?(parent)
      flash[:alert] = 'You do not have permission to do that.'
      redirect_to parent
    end
  end

	def set_breadcrumbs
		add_breadcrumb(parent.name, :parent_url) if parent?
		add_breadcrumb(I18n.t("#{self.controller_name}.all"), :collection_path)
		add_breadcrumb(I18n.t("#{self.controller_name}.new"), :new_resource_path)
	end

end