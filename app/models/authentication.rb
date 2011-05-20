class Authentication < ActiveRecord::Base
	PROVIDERS = ['twitter', 'facebook']
	belongs_to :user
end