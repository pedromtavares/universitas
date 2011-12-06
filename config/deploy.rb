set :use_sudo,            false
set :git_shallow_clone,   1
set :keep_releases,       5
set :application,         "universitas"
set :user,                "deployer"
set :deploy_to,           "/home/deployer/universitas"
set :runner,              "deployer"
set :repository,          "git@github.com:pedromtavares/universitas.git"
set :scm,                 :git
ssh_options[:paranoid]    = false
default_run_options[:pty] = true

role :app, "66.228.47.42"
role :web, "66.228.47.42"
role :db,  "66.228.47.42", :primary => true

require './config/boot'
require 'bundler/capistrano'
require 'hoptoad_notifier/capistrano'


namespace :deploy do
  task :start do
    sudo "/etc/init.d/unicorn start"
  end
  task :stop do
    sudo "/etc/init.d/unicorn stop"
  end
  task :restart do
    sudo "/etc/init.d/unicorn reload"
  end
	task :symlink_db, :roles => :app do
		run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
	end
	task :symlink_services, :roles => :app do
		run "ln -nfs #{shared_path}/config/services.yml #{release_path}/config/services.yml"
	end
end

after 'deploy:update_code', 'deploy:symlink_db'
after 'deploy:update_code', 'deploy:symlink_services'
