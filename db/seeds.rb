# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)



AccountStatus.create(:status=>'normal',:hours=>0)
AccountStatus.create(:status=>'bslocked',:hours=>72)
AccountStatus.create(:status=>'disconnect',:hours=>2)
AccountStatus.create(:status=>'exception',:hours=>3)
AccountStatus.create(:status=>'locked',:hours=>1200)
AccountStatus.create(:status=>'lost',:hours=>24)
AccountStatus.create(:status=>'discard',:hours=>1200)
AccountStatus.create(:status=>'no_rms_file',:hours=>72)
AccountStatus.create(:status=>'no_qq_token',:hours=>1200)

AccountStatus.create(:status=>'discardfordays',:hours=>72)
AccountStatus.create(:status=>'discardbysailia',:hours=>240)
AccountStatus.create(:status=>'discardforyears',:hours=>12000)
AccountStatus.create(:status=>'discardforverifycode',:hours=>1200)
AccountStatus.create(:status=>'recycle',:hours=>12000)



# puts 'seed users...'

# User.create({:email => "test@brood.com", :name => "天3",:is_admin => true,:password => '12345678', :password_confirmation => '12345678'})

# if (Rails.env == "development")
# 10.times do |n|
#   User.create({:email => "user#{n+1}@broot.com", :name => "用户#{n+1}",:password => '12345678', :password_confirmation => '12345678'})
# end


# puts 'seed roles...'
# 20.times do |n|
# 	Role.create(:account => "account#{n+1}",:password =>"12345678")
# end


# puts 'seed computers...'

# 20.times do |n|
# 	Computer.create(:hostname=>"computer#{n+1}",:user_id=>User.first.id,:auth_key=>"computer#{n+1}")
# end
# end


# User.create({:email => "bolt@dabi.co", :name => "管理员",:is_admin => true,:password => '12345678', :password_confirmation => '12345678'})

