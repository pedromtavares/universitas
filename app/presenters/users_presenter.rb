class UsersPresenter < ApplicationPresenter
	def followers
		@user.followers
	end
	
	def following
		@user.following
	end
	
	memoize :followers, :following
end