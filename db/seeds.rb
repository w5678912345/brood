# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'seed users...'

User.create({:email => "test@brood.com", :name => "天二",:is_admin => true,:password => '12345678', :password_confirmation => '12345678'})

if (Rails.env == "development")
10.times do |n|
  User.create({:email => "user#{n+1}@broot.com", :name => "用户#{n+1}",:password => '12345678', :password_confirmation => '12345678'})
end


puts 'seed roles...'
20.times do |n|
	Role.create(:account => "account#{n+1}",:password =>"12345678")
end


puts 'seed computers...'

20.times do |n|
	Computer.create(:hostname=>"computer#{n+1}",:user_id=>User.first.id,:auth_key=>"computer#{n+1}")
end
end


User.create({:email => "bolt@dabi.co", :name => "管理员",:is_admin => true,:password => '12345678', :password_confirmation => '12345678'})

