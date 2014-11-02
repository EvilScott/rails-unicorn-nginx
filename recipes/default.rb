# Cookbook Name:: rails-unicorn-nginx
# Recipe:: default
# Copyright 2014, Robert S. Reis

gem_package 'bundler' do
  notifies :run, 'execute[bundle]', :immediately
end

execute 'bundle' do
  cwd node['rails']['root']
  action :nothing
end

template '/etc/init.d/unicorn' do
  source 'unicorn.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables rails_env: node['rails']['env'],
            rails_root: node['rails']['root'],
            pid_path: node['unicorn']['pid_path']
end

service 'unicorn' do
  supports start: true, stop: true, restart: true
  action [ :enable, :start ]
end

include_recipe 'nginx'

template '/etc/nginx/sites-enabled/rails.conf' do
  source 'nginx.conf.erb'
  variables sock_path: node['unicorn']['sock_path'],
            rails_root: node['rails']['root'],
            server_name: node['nginx']['server_name']
  notifies :restart, 'service[nginx]'
end
