rm -f tmp/pids/server.pid
bundle exec rake db:create 
bundle exec rake db:migrate
bundle exec rake elasticsearch:build_index
bundle exec rails server -b 0.0.0.0
