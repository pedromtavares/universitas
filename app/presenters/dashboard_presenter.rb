class DashboardPresenter < ApplicationPresenter

	def groups
		@user.groups
	end
	
	def documents
		@user.documents
	end
	
	def following
		@user.following
	end
	
	def followers
		@user.followers
	end
	
	memoize :groups, :documents, :followers, :following
	
end