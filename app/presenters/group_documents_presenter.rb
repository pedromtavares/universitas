class GroupDocumentsPresenter < ApplicationPresenter
	
	def initialize(user, group)
		@group = group
		super(user)
	end
	
	def senders
		@group.group_documents.includes(:sender).map(&:sender).uniq
	end
	
	memoize :senders
	
end