# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#

set :output, {:error => "log/cron.error.log", :standard => "log/cron.log"}
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
# whenever:write
# whenever:clear

str_environment = 'production'

# every :day, :at => '11:20am' do
#   rake 'foo:bar'
# end

#
every 25.minutes do
  runner 'TimeTask.auto_stop',:environment => str_environment
end

#
every 60.minutes do
  runner 'Account.auto_normal',:environment => str_environment
end

every :day ,:at => '00:01 am' do
  runner 'Computer.auto_stop_start',:environment => str_environment 
end


every :day, :at => '06:00 am' do
  runner 'TimeTask.at_06_time',:environment => str_environment 
end


# every 3.days do
#   runner 'Api.reset_bslock_role',:environment => str_environment 
# end

# every 7.days do
#   runner 'Api.reset_role_ip_range',:environment => str_environment 
# end



