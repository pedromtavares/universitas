class TopicsPresenter < ApplicationPresenter
	def initialize(user, group)
		@group = group
		super(user)
	end
	
	#memoize :new_posts
end