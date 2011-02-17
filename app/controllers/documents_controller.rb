class DocumentsController < InheritedResources::Base
	before_filter :authenticate_user!, :except => [:index, :show]
	before_filter :allow_teacher, :except => [:show, :index]  
	belongs_to :course
	
	private
	
	def allow_teacher
    course = Course.find(params[:id])
    unless current_user && current_user.teacher_of?(course)
      flash[:alert] = 'You do not have permission to do that.'
      redirect_to course
    end
  end

end