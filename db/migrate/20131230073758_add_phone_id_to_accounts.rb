# encoding: utf-8
class AddPhoneIdToAccounts < ActiveRecord::Migration
  def change
  	add_column :accounts,:phone_id,:string
  end
end
