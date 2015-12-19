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
every 30.minutes do
  runner 'TimeTask.auto_stop',:environment => str_environment
end

every 10.minutes do
  runner 'TimeTask.every_10_minutes',:environment => str_environment
end

every 125.minutes do
  runner 'TimeTask.reset_vit_power_roles',:environment => str_environment
end
#
# every 60.minutes do
#   runner 'Account.auto_normal',:environment => str_environment
# end

every :day ,:at => '00:05 am' do
  #runner 'Computer.auto_stop_start',:environment => str_environment 
  #runner 'DataNode.mark_notes_yesterday',:environment => str_environment
end


every :day, :at => '06:05 am' do
  runner 'TimeTask.at_06_time',:environment => str_environment 
end

#自动采集币价的部分
every :day, :at => '1:05 pm' do
  runner 'TimeTask.update_gold_price',:environment => str_environment 
end
every :day, :at => '3:35 pm' do
  runner 'TimeTask.update_gold_price',:environment => str_environment 
end
every :day, :at => '6:00 pm' do
  runner 'TimeTask.update_gold_price',:environment => str_environment 
end


###############################
#以下为自动调整配置
every :day, :at => '0:00 am' do
  runner 'TimeTask.set_role_profile({:profession => "gunner"},{:name => "gunner-00"})',:environment => str_environment 
  runner 'TimeTask.set_role_profile({:profession => "witch"},{:name => "witch-00"})',:environment => str_environment 
  runner 'TimeTask.set_role_profile({:profession => "darkknight"},{:name => "darknight-00"})',:environment => str_environment   
end
every :day, :at => '4:00 am' do
  runner 'TimeTask.set_role_profile({:profession => "gunner"},{:name => "gunner-04"})',:environment => str_environment 
  runner 'TimeTask.set_role_profile({:profession => "witch"},{:name => "witch-04"})',:environment => str_environment 
  runner 'TimeTask.set_role_profile({:profession => "darkknight"},{:name => "darknight-04"})',:environment => str_environment   
end
every :day, :at => '8:00 am' do
  runner 'TimeTask.set_role_profile({:profession => "gunner"},{:name => "gunner-08"})',:environment => str_environment 
  runner 'TimeTask.set_role_profile({:profession => "witch"},{:name => "witch-08"})',:environment => str_environment 
  runner 'TimeTask.set_role_profile({:profession => "darkknight"},{:name => "darknight-08"})',:environment => str_environment   
end

every :day, :at => '11:55 am' do
  runner 'TimeTask.set_role_profile({:profession => "gunner"},{:name => "gunner-12"})',:environment => str_environment 
  runner 'TimeTask.set_role_profile({:profession => "witch"},{:name => "witch-12"})',:environment => str_environment 
  runner 'TimeTask.set_role_profile({:profession => "darkknight"},{:name => "darknight-12"})',:environment => str_environment   
end
every :day, :at => '4:00 pm' do
  runner 'TimeTask.set_role_profile({:profession => "gunner"},{:name => "gunner-16"})',:environment => str_environment 
  runner 'TimeTask.set_role_profile({:profession => "witch"},{:name => "witch-16"})',:environment => str_environment 
  runner 'TimeTask.set_role_profile({:profession => "darkknight"},{:name => "darknight-16"})',:environment => str_environment   
end
every :day, :at => '8:00 pm' do
  runner 'TimeTask.set_role_profile({:profession => "gunner"},{:name => "gunner-20"})',:environment => str_environment 
  runner 'TimeTask.set_role_profile({:profession => "witch"},{:name => "witch-20"})',:environment => str_environment 
  runner 'TimeTask.set_role_profile({:profession => "darkknight"},{:name => "darknight-20"})',:environment => str_environment   
end



# every 3.days do
#   runner 'Api.reset_bslock_role',:environment => str_environment 
# end

# every 7.days do
#   runner 'Api.reset_role_ip_range',:environment => str_environment 
# end

# every :day, :at => '04:30 am' do
# 	command "cd /root/apps/tianyi.dabi.co && thin -C config/thin.yml stop"
# end

