# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
 set :output, "log/cron.log"
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

str_environment = 'test'

# every :day, :at => '11:20am' do
#   rake 'foo:bar'
# end

#
every 2.minutes do
  runner 'Api.role_auto_offline',:environment => 'test'
end

#
every 20.minutes do
  runner 'Api.role_auto_reopen',:environment => 'test'
end

every 1.day, :at => '6:00 am' do
  # reset vit power
  runner 'Api.reset_role_vit_power',:environment => 'test'
end

every 1.day ,:at => '6:10 am' do
  runner 'Api.reset_ip_use_count',:environment => 'test'
end


every 2.minutes do
  runner 'Api.role_auto_offline',:environment => 'production'
end

#
every 20.minutes do
  runner 'Api.role_auto_reopen',:environment => 'production'
end

every 1.day, :at => '6:00 am' do
  # reset vit power
  runner 'Api.reset_role_vit_power',:environment => 'production'
end

every 1.day ,:at => '6:10 am' do
  runner 'Api.reset_ip_use_count',:environment => 'production'
end
