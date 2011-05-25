class UserDocumentsPresenter < ApplicationPresenter
	
	def documents
		@user.documents
	end
	
	def uploaded_documents
		docs = @user.uploaded_documents.map(&:id)
		# we need to remap Documents to UserDocuments
		@user.user_documents.where(:document_id => docs)
	end
	
	memoize :documents, :uploaded_documents
	
end