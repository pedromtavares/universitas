Factory.define( :user ) do |f|
  f.name { Factory.next(:name) }
end