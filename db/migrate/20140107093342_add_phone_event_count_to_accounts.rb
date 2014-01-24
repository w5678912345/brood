# encoding: utf-8
class AddPhoneEventCountToAccounts < ActiveRecord::Migration
  def change
  	add_column :accounts,:phone_event_count,:integer,:default => 0
  end
end
