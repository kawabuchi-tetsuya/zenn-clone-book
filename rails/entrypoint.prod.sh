#!/bin/bash
set -e

echo 'Start entrypoint.prod.sh'

echo 'rm -f /myapp/tmp/pids/server.pid'
rm -f /myapp/tmp/pids/server.pid

echo 'bundle exec rails db:create RAILS_ENV=production'
bundle exec rails db:create RAILS_ENV=production

echo 'bundle exec rake ridgepole:apply RAILS_ENV=production'
bundle exec rake ridgepole:apply RAILS_ENV=production

echo 'bundle exec rails db:seed RAILS_ENV=production'
bundle exec rails db:seed RAILS_ENV=production

echo 'exec pumactl start'
bundle exec pumactl start
