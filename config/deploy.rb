set :use_sudo,            false
#tell git to clone only the latest revision and not the whole repository
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

require 'bundler/capistrano'

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
	task :symlink_providers, :roles => :app do
		run "ln -nfs #{shared_path}/config/providers.yml #{release_path}/config/providers.yml"
	end
end

after 'deploy', 'deploy:symlink_db'
after 'deploy', 'deploy:symlink_providers'