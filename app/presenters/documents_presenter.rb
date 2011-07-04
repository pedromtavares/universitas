class DocumentsPresenter < ApplicationPresenter
	
	
	def documents
		@user.documents
	end
	
	memoize :documents
	
end