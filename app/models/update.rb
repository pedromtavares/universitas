class Update < ActiveRecord::Base
	belongs_to :creator, :polymorphic => true
  belongs_to :target, :polymorphic => true  
end
