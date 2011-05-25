class GroupsPresenter < ApplicationPresenter
	def groups
		@user.groups
	end
	
	memoize :groups
end