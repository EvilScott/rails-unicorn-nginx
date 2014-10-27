#
# Cookbook Name:: rails-unicorn-nginx
# Recipe:: default
#
# Copyright 2014, Robert S. Reis
#

execute 'bundler' do
  command 'gem install bundler && bundler install'
  cwd node['rails']['root']
end

execute 'unicorn' do
  command "unicorn_rails -c config/unicorn.rb -E #{node['rails']['env']} -D"
  cwd node['rails']['root']
end

include_recipe 'nginx'

template '/etc/nginx/sites-enabled/rails.conf' do
  source 'nginx.conf.erb'
  variables sock_path: node['unicorn']['sock_path'],
            rails_root: node['rails']['root'],
            server_name: node['nginx']['server_name']
  notifies :start, 'service[nginx]'
end
