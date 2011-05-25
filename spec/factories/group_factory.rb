Factory.define( :group ) do |f|
  f.name { Factory.next(:name) }
  f.leader {Factory(:user)}
	f.image File.open("#{Rails.root}/spec/fixtures/rails.png")
end