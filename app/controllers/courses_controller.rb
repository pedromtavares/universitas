class CoursesController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :allow_teacher, :only => [:edit, :update] 

  actions :all, :except => :delete
  
  def create
    @course = Course.new(params[:course].merge(:teacher => current_user))
    create!
  end
  
  def enter
    @course = Course.find params[:id]
    unless current_user.student_of?(@course)
			@course.create_student(current_user)
      redirect_to @course, :notice => "#{t('courses.have_entered')} #{@course}"
    else
      redirect_to @course, :error => t('courses.already_in')
    end
  end
  
  def leave
    @course = Course.find params[:id]
		@course.remove_student(current_user)
    redirect_to courses_path, :notice => "#{t('courses.have_left')} #{@course}"
  end
  
  protected
  
  def collection
    @courses ||= paginate(end_of_association_chain)
  end
  
  def allow_teacher
    course = Course.find(params[:id])
    unless current_user.teacher_of?(course)
      flash[:alert] = t('shared.no_permission')
      redirect_to course
    end
  end
end
