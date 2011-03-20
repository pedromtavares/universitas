Factory.define( :group ) do |f|
  f.name "Example Group"
  f.leader {Factory(:user)}
	f.image File.open("#{Rails.root}/spec/fixtures/rails.png")
end