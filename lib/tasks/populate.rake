require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
		raise "Don't run this on prod! Are you crazy?" if Rails.env.production?
		system("rm -r #{Rails.root}/public/uploads")
    Rake::Task['db:reset'].invoke
		# creates a default user to easily log in
    User.create!(:name => "Default User",
                 :email => "default@default.com",
                 :login => "default",
                 :password => "default",
                 :password_confirmation => "default")

		# creates a bunch of dummy users
    99.times do |n|
      name  = Faker::Name.name
      login = name.parameterize[0..19]
      email = "#{login}@default.com"
      password  = "default"
      user = User.create!(:name => name,
                   :login => login,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
      user.update_status Faker::Lorem.sentence
      puts "Successfully created user #{name}"
    end

		# creates some groups with previously created users as leaders
		30.times do |n|
			name = Faker::Company.catch_phrase
			group = Group.create!(:name => name,
										:description => Faker::Lorem.paragraph,
										:leader => User.find(n + 1),
										:image => File.open("#{Rails.root}/spec/fixtures/rails.png"))
			3.times do
				GroupModule.create!(:group => group, :name => Faker::Company.catch_phrase, :description => Faker::Lorem.paragraph)
			end
			puts "Successfully created group #{name}"
		end
    
		# makes dummy users follow each other and enter random groups
    users = User.all
    users.each do |user|
      5.times do
        target = User.find(rand(100)+1)
        user.follow!(target) unless user.following?(target) || user == target
        puts "#{user.name} is now following #{target.name}"

				group = Group.find(rand(30) + 1)
				group.create_member(user)
				puts "#{user.name} is now a member of course #{group.name}"
      end
			
			10.times do
				UserDocument.create!(:document => Document.create(:name => Faker::Company.name, :uploader => user, :file => File.open("#{Rails.root}/spec/fixtures/doc.txt")), :user => user)
			end
			
    end

  end
end