# Cookbook Name:: rails-unicorn-nginx
# Recipe:: default
# Copyright 2014, Robert S. Reis

gem_package 'bundler' do
  notifies :run, 'execute[bundle]'
end

execute 'bundle' do
  cwd node['rails']['root']
  action :nothing
end

cookbook_file 'unicorn.sh' do
  path '/etc/init.d/unicorn'
  owner 'root'
  group 'root'
  mode '0755'
end

service 'unicorn' do
  supports start: true, stop: true, restart: true
  action :nothing
end

template '/etc/unicorn/rails.conf' do
  source 'unicorn.conf.erb'
  variables rails_env: node['rails']['env'],
            rails_root: node['rails']['root']
  notifies :start, 'service[unicorn]'
end

include_recipe 'nginx'

template '/etc/nginx/sites-enabled/rails.conf' do
  source 'nginx.conf.erb'
  variables sock_path: node['unicorn']['sock_path'],
            rails_root: node['rails']['root'],
            server_name: node['nginx']['server_name']
  notifies :start, 'service[nginx]'
end
