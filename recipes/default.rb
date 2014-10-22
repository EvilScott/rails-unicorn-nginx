#
# Cookbook Name:: rails-unicorn-nginx
# Recipe:: default
#
# Copyright 2014, Robert S. Reis
#

include_recipe 'nginx'

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

directory '/etc/unicorn' do
  recursive true
end

template '/etc/unicorn/rails.conf' do
  source 'unicorn.conf.erb'
  variables rails_env: node['rails']['env'],
            rails_root: node['rails']['root']
  notifies :restart, 'service[unicorn]'
end

template '/etc/nginx/sites-enabled/rails.conf' do
  source 'nginx.conf.erb'
  variables sock_path: node['unicorn']['sock_path'],
            rails_root: node['rails']['root'],
            server_name: node['nginx']['server_name']
  notifies :restart, 'service[nginx]'
end

%w( unicorn nginx ).each { |s| service s }
