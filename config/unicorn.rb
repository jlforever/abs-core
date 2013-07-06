# config/unicorn.rb
# To start unicorn in dev
# RACK_ENV=none RAILS_ENV=development unicorn -c config/unicorn.rb

if ENV["RAILS_ENV"] == "development"
  worker_processes 1
  listen 3001, :tcp_nopush => true
  timeout 30
else
  # This is production configuration
  
  # This is a direct copy from the heroku unicorn 
  # configuration section. Any further changes are welcomed
  
  worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
  timeout 15
  preload_app true

  before_fork do |server, worker|
    Signal.trap 'TERM' do
      puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
      Process.kill 'QUIT', Process.pid
    end

    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
  end 

  after_fork do |server, worker|
    Signal.trap 'TERM' do
      puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
    end

    defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
  end
  
end

