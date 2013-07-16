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
every 20.minutes do
  runner 'Api.role_auto_offline',:environment => str_environment
end

#
every 60.minutes do
  runner 'Api.role_auto_reopen',:environment => str_environment
end


every :day ,:at => '0:00 am' do
  runner 'Api.role_auto_pay',:environment => str_environment
end


every :day, :at => '06:39 am' do
  runner 'Api.reset_role_vit_power',:environment => str_environment
end


every :day, :at => '7:00 am' do
	runner 'Api.reset_ip_use_count',:environment => str_environment
end
