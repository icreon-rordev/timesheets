# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.
set :rails_env, 'production'

set :user, 'root'

set :deploy_to, '/root/timesheets'

puts "*** Deploying \033[1;42m#{fetch(:branch)}\033[0m  branch to the \033[1;42m  Production timesheets COMPARISIONS \033[0m servers!"


role :app, %w{root@103.231.101.233}
role :web, %w{root@103.231.101.233}
role :db,  %w{root@103.231.101.233}

set :shared_path, "/root/timesheets/shared"
set :current_path, "/root/timesheets/current"

desc 'CREATING SYM LINKS'
task :after_update_code do
  on roles(:app) do
    5.times{ puts ""}
    puts "Release PATH----------- #{release_path}"
    puts "-------------------------CREATING SYM LINKS-------------------------"
    execute "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    execute "ln -nfs #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml"
    execute "ln -nfs #{shared_path}/public/system #{release_path}/public/system" #Create symlink for paperclip uploads
    execute "ln -nfs #{shared_path}/log #{release_path}/log"
    execute "ln -nfs #{shared_path}/public/images/content_images #{release_path}/public/images/content_images"
    puts "-------------------------CREATED SYM LINKS-------------------------"
    5.times{ puts ""}
  end 
end


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '103.231.101.233', user: 'root', roles: %w{web app}, my_property: :my_value
before 'deploy:assets:precompile', "after_update_code"


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server '103.231.101.233',
#   user: 'root',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'root', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }