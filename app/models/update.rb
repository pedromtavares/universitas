class Update < ActiveRecord::Base
  belongs_to :user
  
  class << self
    def new_status(user, msg)
      Update.create!(:content => " updated status to: \"#{msg}\"", :user => user)
    end
    
    def new_course(user, course)
      Update.create!(:content => " created a new course: \"#{course}\"", :user => user)
    end
    
    def entered_course(user, course)
      Update.create!(:content => " entered a course: \"#{course}\"", :user => user)
    end

  end
end
