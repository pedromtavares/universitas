Factory.define( :user ) do |f|
  f.name { Factory.next(:name) }
  f.login { Factory.next(:login)}
  f.email {Factory.next(:email)}
  f.password { |f| "123456" }
  f.password_confirmation { |f| "123456" }
end