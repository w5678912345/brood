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



# every :day, :at => '11:20am' do
#   rake 'foo:bar'
# end

every 2.minutes do
  runner 'Api.role_auto_offline'
end

every 1.day, :at => '16:10 pm' do
  # reset vit power
  runner 'Api.reset_role_vit_power'
end

every 1.day ,:at => '16:12 am' do
  runner 'Api.reset_ip_use_count'
end