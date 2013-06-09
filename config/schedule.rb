# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
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



# every :day, :at => '11:20am' do
#   rake 'foo:bar'
# end

every 2.minutes do
  runner 'Role.auto_offline',:output => {:error => 'log/cron_error.log', :standard => 'log/cron.log'}
end

every 1.day, :at => '6:00 am' do
  # 清理临时上传文件
  rake 'Role.reset_vit_power',:output => {:error => 'log/cron_error.log', :standard => 'log/cron.log'}
end