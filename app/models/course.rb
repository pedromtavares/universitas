class Course < ActiveRecord::Base
  has_many :students
	has_many :documents
	has_many :updates, :as => :owner, :dependent => :destroy
	has_many :update_references, :as => :reference, :dependent => :destroy, :class_name => "Update"
  belongs_to :teacher, :class_name => 'User', :foreign_key => 'teacher_id'
	after_create :status_update

	validates :name, :presence => true
  
  def to_s
    self.name
  end

	def create_student(user)
		self.students.create(:user => user, :grade => 0)
	end
	
	def remove_student(user)
		self.students.where(:user_id => user).first.destroy
	end

	private
	
	def status_update
		self.teacher.updates.create(:reference => self)
	end
end
