class Update < ActiveRecord::Base
	belongs_to :owner, :polymorphic => true
  belongs_to :reference, :polymorphic => true  
end
