class Student < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
  
  delegate :name, :email, :to => :user  
end
