default['nginx']['default_site_enabled'] = false
default['nginx']['server_name'] = 'rails.dev'

default['rails']['root'] = '/vagrant'
default['rails']['env'] = 'development'

default['unicorn']['sock_path'] = '/tmp/unicorn.sock'
default['unicorn']['pid_path'] = '/vagrant/tmp/pids/unicorn.pid'
