require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    User.create!(:name => "Default User",
                 :email => "default@default.com",
                 :login => "default",
                 :password => "default",
                 :password_confirmation => "default")
    99.times do |n|
      name  = Faker::Name.name
      login = name.parameterize[0..19]
      email = "#{login}@default.com"
      password  = "password"
      user = User.create!(:name => name,
                   :login => login,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
      user.update_status Faker::Lorem.sentence
      puts "Successfully created #{name}"
    end
    
    users = User.all
    users.each do |user|
      5.times do
        target = User.find(rand(100)+1)
        user.follow!(target) unless user.following?(target) || user == target
        puts "#{user.name} is now following #{target.name}"
      end
    end
  end
end