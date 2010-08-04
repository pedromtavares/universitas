Factory.define( :user ) do |f|
  f.name { Factory.next(:name) }
  f.login { Factory.next(:login)}
  f.email {Factory.next(:email)}
  f.password "123456"
  f.password_confirmation "123456"
end