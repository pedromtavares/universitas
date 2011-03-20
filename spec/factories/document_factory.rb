Factory.define( :document ) do |f|
  f.uploader { Factory(:user) }
	f.name "Test Doc"
	f.file File.open("#{Rails.root}/spec/fixtures/doc.txt")
end