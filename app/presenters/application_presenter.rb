class ApplicationPresenter
	extend ActiveSupport::Memoizable
	
	attr_accessor :user
	
	def initialize(user)
		@user = user
	end
	
end