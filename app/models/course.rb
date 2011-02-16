class Course < ActiveRecord::Base
  has_many :students
	has_many :documents
  belongs_to :teacher, :class_name => 'User', :foreign_key => 'teacher_id'

	validates :name, :presence => true
  
  def to_s
    self.name
  end
end
