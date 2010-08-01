Factory.sequence :email do |n|
    "user#{n}@example.com"
end

Factory.sequence :name do |n|
    "User #{n}"
end

Factory.sequence :login do |n|
  "user#{n}"
end