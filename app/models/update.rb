class Update < ActiveRecord::Base
  belongs_to :user
  
  def self.new_status(user, msg)
    Update.create!(:content => " updated status to: \"#{msg}\"", :user => user)
  end
end
