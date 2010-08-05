class CoursesController < InheritedResources::Base
  before_filter :authenticate_user!, :except => [:index, :show]
  actions :all, :except => :delete
  
  def create
    @course = Course.new(params[:course])
    @course.teacher = current_user
    create!
    Update.new_course(current_user, @course)
  end
  
  def enter
    @course = Course.find params[:id]
    unless current_user.student_of?(@course)
      Student.create!(:user => current_user, :course => @course, :grade => 0)
      Update.entered_course(current_user, @course)
      redirect_to @course, :notice => "You have entered the course #{@course}"
    else
      redirect_to @course, :error => "You already are in this course!"
    end
    
  end
  
  def leave
    @course = Course.find params[:id]
    Student.where(:user_id => current_user, :course_id => @course).first.destroy
    redirect_to courses_path, :notice => "You have left the course #{@course}"
  end
  
  protected
  
  def collection
    @courses ||= paginate(end_of_association_chain)
  end
end
