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
ssh_options[:keys] 				=	['~/.ssh/authorized_keys']
ssh_options[:paranoid]    = false
default_run_options[:pty] = true

role :app, "66.228.47.42"
role :web, "66.228.47.42"
role :db,  "66.228.47.42", :primary => true