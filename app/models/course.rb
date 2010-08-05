class Course < ActiveRecord::Base
  has_many :students
  belongs_to :teacher, :class_name => 'User', :foreign_key => 'teacher_id'
  
  def to_s
    self.name
  end
end
