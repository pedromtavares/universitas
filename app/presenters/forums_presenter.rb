class ForumsPresenter < ApplicationPresenter
	def initialize(user, group)
		@group = group
		super(user)
	end
	
	def new_topics
		@group.topics.order('created_at desc').limit(5)
	end
	
	memoize :new_topics
end