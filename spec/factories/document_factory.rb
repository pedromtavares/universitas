Factory.define( :document ) do |f|
  f.course { Factory(:course) }
	f.name "Test Doc"
	f.file File.open("#{Rails.root}/spec/fixtures/doc.txt")
end