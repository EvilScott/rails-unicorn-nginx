name             'rails-unicorn-nginx'
maintainer       'Robert S. Reis'
maintainer_email 'reis.robert.s@gmail.com'
license          'MIT'
description      'Installs/configures Unicorn+nginx for use with Rails'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

# cookbook dependencies
depends 'nginx'
